import copy
import sys
import xml.etree.ElementTree as ET


ROME2_SP_FRAME = "./src/ui/frontend ui/sp_frame.xml"
ROME2_MENU_BAR = "./src/ui/common ui/menu_bar.xml"
ATTILA_CONSUL = "./src/ui/common ui/consul.xml"


def normalize_game(raw_game: str) -> str:
    value = (raw_game or "").strip().lower()
    if value in ("rome2", "rome_2", "rome ii", "romeii"):
        return "Rome2"
    if value in ("attila",):
        return "Attila"
    raise ValueError(f"Unsupported GAME value: {raw_game}")


def build_new_entry(consul_children_tag, consul_new_entry, consul_new_script, consul_new_tooltip, consul_new_latin):
    template_entry = consul_children_tag.find("uientry")
    if template_entry is None:
        raise ValueError("No uientry template found in consul children")

    new_entry = copy.deepcopy(template_entry)

    new_entry.find("s").text = consul_new_entry
    new_entry.find("unicode").text = consul_new_tooltip

    new_entry_children = new_entry.find("children/uientry")
    if new_entry_children is None:
        raise ValueError("Entry template missing children/uientry")

    new_entry_children.find("s").text = consul_new_script

    states = new_entry_children.find("states")
    if states is None:
        raise ValueError("Entry template missing states")

    for state in states.findall("state"):
        unicode_field = state.find("unicode")
        if unicode_field is not None:
            unicode_field.text = consul_new_latin

    return new_entry


def sort_consul_entries(consul_children_tag):
    def sort_key(entry):
        label = entry.find("children/uientry/states/state/unicode")
        return (label.text or "").lower() if label is not None and label.text else ""

    entries = [child for child in consul_children_tag if child.tag == "uientry"]
    entries.sort(key=sort_key)
    consul_children_tag[:] = entries


def add_entry_to_children(consul_children_tag, consul_new_entry, consul_new_script, consul_new_tooltip, consul_new_latin):
    new_entry = build_new_entry(
        consul_children_tag,
        consul_new_entry,
        consul_new_script,
        consul_new_tooltip,
        consul_new_latin
    )
    consul_children_tag.append(new_entry)
    consul_children_tag.attrib["count"] = str(len(consul_children_tag.findall("uientry")))
    sort_consul_entries(consul_children_tag)


def find_consul_children_rome2(root):
    uientry = root.find("uientry")
    if uientry is None:
        raise ValueError("sp_frame root/uientry not found")

    path = (
        "./children/uientry/children/uientry/children/uientry[2]/"
        "children/uientry/children/uientry/children/uientry/children"
    )
    consul_children_tag = uientry.find(path)
    if consul_children_tag is None:
        raise ValueError("Rome2 consul children path not found in sp_frame.xml")
    return consul_children_tag


def find_consul_children_attila(root):
    for parent in root.iter():
        if parent.tag != "children":
            continue
        children = [child for child in parent if child.tag == "uientry"]
        for child in children:
            s_tag = child.find("s")
            if s_tag is not None and s_tag.text and s_tag.text.startswith("consul_") and s_tag.text.endswith("_entry"):
                return parent
    raise ValueError("Attila consul entries container not found in consul.xml")


def find_consul_scriptum(root):
    for element in root.findall(".//uientry"):
        s_tag = element.find("s")
        if s_tag is not None and s_tag.text == "consul_scriptum":
            return element
    raise ValueError("consul_scriptum not found")


def replace_consul_scriptum(root, new_entry):
    def find_and_replace(element):
        for child in list(element):
            if child.tag == "uientry":
                s_tag = child.find("s")
                if s_tag is not None and s_tag.text == "consul_scriptum":
                    element.remove(child)
                    element.append(new_entry)
                    return True
            if find_and_replace(child):
                return True
        return False

    return find_and_replace(root)


def update_rome2(consul_new_entry, consul_new_script, consul_new_tooltip, consul_new_latin):
    tree = ET.parse(ROME2_SP_FRAME)
    root = tree.getroot()
    consul_children_tag = find_consul_children_rome2(root)
    add_entry_to_children(consul_children_tag, consul_new_entry, consul_new_script, consul_new_tooltip, consul_new_latin)
    tree.write(ROME2_SP_FRAME)

    tree2 = ET.parse(ROME2_MENU_BAR)
    root2 = tree2.getroot()
    if not replace_consul_scriptum(root2, copy.deepcopy(find_consul_scriptum(root))):
        raise ValueError("consul_scriptum not found in menu_bar.xml")
    tree2.write(ROME2_MENU_BAR)


def update_attila(consul_new_entry, consul_new_script, consul_new_tooltip, consul_new_latin):
    tree = ET.parse(ATTILA_CONSUL)
    root = tree.getroot()
    consul_children_tag = find_consul_children_attila(root)
    add_entry_to_children(consul_children_tag, consul_new_entry, consul_new_script, consul_new_tooltip, consul_new_latin)
    tree.write(ATTILA_CONSUL)


def main():
    if len(sys.argv) < 5:
        raise ValueError("Usage: insert_consul_entry.py <GAME> <ARG1> <ARG2> <ARG3>")

    game = normalize_game(sys.argv[1])
    base_id = sys.argv[2]
    consul_new_entry = f"{base_id}_entry"
    consul_new_script = f"{base_id}_script"
    consul_new_tooltip = sys.argv[3]
    consul_new_latin = sys.argv[4]

    if game == "Rome2":
        update_rome2(consul_new_entry, consul_new_script, consul_new_tooltip, consul_new_latin)
    else:
        update_attila(consul_new_entry, consul_new_script, consul_new_tooltip, consul_new_latin)


if __name__ == "__main__":
    main()
