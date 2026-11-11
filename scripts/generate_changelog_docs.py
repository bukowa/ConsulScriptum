import os
import re

# Configuration
SOURCE_FILE = 'src/consul/consul_changelog.lua'
OUTPUT_FILE = 'docs/guide/parts/generated-changelog.md'

def parse_changelog(content):
    # regex for version blocks like ["0.6.2"] = { ... }
    # Made the trailing comma optional and moved it out of the capturing group
    version_pattern = re.compile(r'\[["\']([^"\']+)["\']\]\s*=\s*\{(.*?)\n\s*\}', re.DOTALL)
    
    matches = list(version_pattern.finditer(content))
    entries = []
    
    for match in matches:
        version = match.group(1)
        body = match.group(2)
        
        # Clean up version string
        if version == "unreleased":
            display_version = "Unreleased"
        else:
            display_version = f"v{version}" if not version.startswith('v') else version
            
        note_data = {}
        
        lines = body.split('\n')
        current_key = None
        
        for line in lines:
            line = line.strip()
            if not line: continue
            
            # Match start of a field: key = "value" or key = [[value]]
            field_start_match = re.match(r'^(\w+)\s*=\s*(.*)$', line)
            if field_start_match:
                current_key = field_start_match.group(1)
                val_part = field_start_match.group(2)
                note_data[current_key] = val_part
            elif current_key:
                # Continuation line (handles Lua concatenation artifacts in post-processing)
                note_data[current_key] += " " + line
        
        # Post-process values (remove quotes, handle concatenation and \n)
        for k in note_data:
            v = note_data[k]
            
            # Remove all forms of Lua string concatenation/quote artifacts
            # Remove trailing comma if exists (usually at the end of the last line of a field)
            v = v.strip().rstrip(',')
            
            # Handle concatenation operators and internal quotes
            # Replace: " .. "  or " .. \n " or just ..
            v = re.sub(r'["\']\s*\.\.\s*["\']', '', v)
            v = re.sub(r'["\']\s*\.\.\s*', '', v)
            v = re.sub(r'\s*\.\.\s*["\']', '', v)
            v = re.sub(r'\s*\.\.\s*', '', v)
            
            # Remove leading/trailing quotes
            if v.startswith('"') or v.startswith("'"):
                v = v[1:]
            if v.endswith('"') or v.endswith("'"):
                v = v[:-1]
            
            # Unescape newlines and clean up
            v = v.replace('\\n', '\n')
            note_data[k] = v.strip()
            
        entries.append((display_version, note_data))
        
    return entries

def format_markdown(entries):
    md = []
    
    # We want to preserve the order in the Lua file (usually newest first or oldest first)
    # However, traditionally newest is at top. 
    # Let's just follow the file order unless it looks like it's reversed.
    
    for version, data in entries:
        md.append(f"## {version}\n")
        
        if 'common' in data:
            md.append("**Common:**\n")
            # Convert internal newlines/bullet points to MD list
            lines = data['common'].split('\n')
            for line in lines:
                line = line.strip()
                if not line: continue
                if not line.startswith('-'):
                    md.append(f"- {line}\n")
                else:
                    md.append(f"{line}\n")
            md.append("\n")
            
        if 'Rome2' in data:
            md.append("**Rome II specific:**\n")
            lines = data['Rome2'].split('\n')
            for line in lines:
                line = line.strip()
                if not line: continue
                if not line.startswith('-'):
                    md.append(f"- {line}\n")
                else:
                    md.append(f"{line}\n")
            md.append("\n")
            
        if 'Attila' in data:
            md.append("**Attila specific:**\n")
            lines = data['Attila'].split('\n')
            for line in lines:
                line = line.strip()
                if not line: continue
                if not line.startswith('-'):
                    md.append(f"- {line}\n")
                else:
                    md.append(f"{line}\n")
            md.append("\n")

        if 'TOB' in data:
            md.append("**Thrones of Britannia specific:**\n")
            lines = data['TOB'].split('\n')
            for line in lines:
                line = line.strip()
                if not line: continue
                if not line.startswith('-'):
                    md.append(f"- {line}\n")
                else:
                    md.append(f"{line}\n")
            md.append("\n")
            
        md.append("---\n\n")
        
    return "".join(md)

def main():
    import argparse
    parser = argparse.ArgumentParser(description="Generate markdown changelog from Lua changelog notes.")
    parser.add_argument("--version", help="Extract notes for a specific version only (e.g. 1.1.0 or v1.1.0)")
    parser.add_argument("--output", help=f"Output markdown file (default: {OUTPUT_FILE})", default=OUTPUT_FILE)
    args = parser.parse_args()

    if not os.path.exists(SOURCE_FILE):
        print(f"Error: {SOURCE_FILE} not found.")
        return

    with open(SOURCE_FILE, 'r', encoding='utf-8') as f:
        content = f.read()

    entries = parse_changelog(content)
    if not entries:
        print("Error: No changelog entries found.")
        return

    if args.version:
        target = args.version.lstrip("v").strip()
        matched = [e for e in entries if e[0].lstrip("v").strip() == target]
        if not matched:
            print(f"Warning: No changelog notes found for version '{args.version}'")
            md_output = f"## v{target}\n\n*No release notes recorded in changelog for this version.*\n"
        else:
            md_output = format_markdown(matched)
            # Remove trailing '---' if single version
            md_output = re.sub(r'\n---\n\n$', '\n', md_output)
    else:
        md_output = format_markdown(entries)

    out_dir = os.path.dirname(args.output)
    if out_dir:
        os.makedirs(out_dir, exist_ok=True)
    with open(args.output, 'w', encoding='utf-8', newline='\n') as f:
        f.write(md_output)

    print(f"Successfully generated {args.output}")

if __name__ == "__main__":
    main()
