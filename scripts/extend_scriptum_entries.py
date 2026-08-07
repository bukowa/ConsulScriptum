import re


CONSUL_XML = "./src/ui/common ui/consul.xml"
MENU_BAR_XML = "./src/ui/common ui/menu_bar.xml"
SP_FRAME_XML = "./src/ui/frontend ui/sp_frame.xml"
CONSUL_LUA = "./src/consul/consul.lua"

FILES = [CONSUL_XML, MENU_BAR_XML, SP_FRAME_XML]

TARGET_COUNT = 40

ENTRY_HEIGHT = 22

ENTRY_TITLE = re.compile(r"<s>scriptum_entry(\d+)</s><!-- title -->")

VSLIDER_MAXVALUE = re.compile(
    r"<s>maxValue</s><!-- key -->\s*<s>[0-9.]+</s><!-- value -->"
)


def detect_newline(text):
    return "\r\n" if "\r\n" in text else "\n"


def find_last_entry(text):
    matches = list(ENTRY_TITLE.finditer(text))
    if not matches:
        raise ValueError("No scriptum_entryN title found")
    return max(matches, key=lambda m: int(m.group(1)))


def extract_block(text, title_pos):
    open_pos = text.rfind("<uientry>", 0, title_pos)
    if open_pos == -1:
        raise ValueError("No <uientry> before scriptum entry title")

    depth = 0
    i = open_pos
    while i < len(text):
        next_open = text.find("<uientry>", i)
        next_close = text.find("</uientry>", i)
        if next_open != -1 and (next_close == -1 or next_open < next_close):
            depth += 1
            i = next_open + len("<uientry>")
        elif next_close != -1:
            depth -= 1
            i = next_close + len("</uientry>")
            if depth == 0:
                return open_pos, i
        else:
            raise ValueError("Unbalanced <uientry> tags")

    raise ValueError("Could not find end of scriptum entry block")


def extend_file(path):
    with open(path, "r", encoding="utf-8", newline="") as f:
        text = f.read()
    newline = detect_newline(text)

    last_match = find_last_entry(text)
    last_num = int(last_match.group(1))
    if last_num >= TARGET_COUNT:
        print(f"SKIP {path}: already has scriptum_entry{last_num}")
        return

    block_start, block_end = extract_block(text, last_match.start())
    template = text[block_start:block_end]

    first_match = next(
        m for m in ENTRY_TITLE.finditer(text) if int(m.group(1)) == 1
    )
    container_open = text.rfind('<children count="', 0, first_match.start())
    if container_open == -1:
        raise ValueError("Could not find scriptum list children tag")
    if not (container_open < block_start < text.find("</children>", block_end)):
        raise ValueError("Scriptum list container not found before entries")
    container_tag_end = text.find(">", container_open)
    old_tag = text[container_open:container_tag_end + 1]
    new_tag = re.sub(r'count="\d+"', f'count="{TARGET_COUNT}"', old_tag)

    children_close = text.find("</children>", block_end)
    if children_close == -1:
        raise ValueError("Could not find closing </children> after last scriptum entry")

    new_blocks = []
    for n in range(last_num + 1, TARGET_COUNT + 1):
        block = template.replace(f"scriptum_entry_text{last_num}", f"scriptum_entry_text{n}")
        block = block.replace(f"scriptum_entry{last_num}", f"scriptum_entry{n}")
        new_blocks.append(block + newline)

    text = (
        text[:container_open]
        + new_tag
        + text[container_tag_end + 1:children_close]
        + "".join(new_blocks)
        + text[children_close:]
    )

    with open(path, "w", encoding="utf-8", newline="") as f:
        f.write(text)

    print(f"OK {path}: extended from scriptum_entry{last_num} to scriptum_entry{TARGET_COUNT}")


def apply_scriptum_scroll(path):
    # Scriptum listview needs its vslider maxValue to match the total content height
    # (40 entries x 22px = 880), mirroring how the console slider's maxValue matches
    # its tall text entry. Without this the list only scrolls ~14 entries in-game.
    with open(path, "r", encoding="utf-8", newline="") as f:
        text = f.read()

    i = text.find("<s>scriptum_entry1</s><!-- title -->")
    if i == -1:
        raise ValueError(f"No scriptum_entry1 title in {path}")
    v = text.find("<s>vslider</s><!-- title -->", i)
    if v == -1:
        raise ValueError(f"No vslider after scriptum_entry1 in {path}")

    window = text[v:v + 16000]
    match = VSLIDER_MAXVALUE.search(window)
    if not match:
        raise ValueError(f"No maxValue in scriptum vslider of {path}")

    target = str(TARGET_COUNT * ENTRY_HEIGHT)
    new_window = (
        window[:match.start()]
        + re.sub(r"(<s>)[0-9.]+(</s><!-- value -->)", r"\g<1>" + target + r"\g<2>", match.group(0))
        + window[match.end():]
    )
    text = text[:v] + new_window + text[v + 16000:]

    with open(path, "w", encoding="utf-8", newline="") as f:
        f.write(text)

    print(f"OK {path}: scriptum vslider maxValue -> {target}")


def update_consul_lua(path):
    with open(path, "r", encoding="utf-8", newline="") as f:
        text = f.read()

    def repl(m):
        return "max_entries = " + str(TARGET_COUNT)

    new_text, count = re.subn(r"max_entries\s*=\s*\d+", repl, text, count=1)
    if count == 0:
        raise ValueError(f"No max_entries found in {path}")

    if new_text == text:
        print(f"SKIP {path}: max_entries already {TARGET_COUNT}")
        return

    with open(path, "w", encoding="utf-8", newline="") as f:
        f.write(new_text)

    print(f"OK {path}: max_entries -> {TARGET_COUNT}")


def main():
    for path in FILES:
        extend_file(path)
        apply_scriptum_scroll(path)
    update_consul_lua(CONSUL_LUA)


if __name__ == "__main__":
    main()
