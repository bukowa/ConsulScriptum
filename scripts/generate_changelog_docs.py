import os
import re

# Configuration
SOURCE_FILE = 'src/consul/consul_changelog.lua'
OUTPUT_FILE = 'docs/guide/parts/generated-changelog.md'

def parse_changelog(content):
    # regex for version blocks like ["0.6.2"] = { ... }
    # This regex is more robust to find entries within the notes table
    version_pattern = re.compile(r'\[["\']([^"\']+)["\']\]\s*=\s*\{(.*?)\n\s*\},', re.DOTALL)
    
    # Also check without comma for the last entry
    matches = list(version_pattern.finditer(content))
    if not matches:
        # Try without the trailing comma
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
        
        # Extract fields like common, Rome2, Attila
        field_pattern = re.compile(r'(\w+)\s*=\s*(".*?"|\'.*?\')(\s*\.\.\s*("\s*\\n.*?"|\'\s*\\n.*?\'))*', re.DOTALL)
        # Note: the above regex might be too simple for multiline concatenated Lua strings
        
        # Let's use a simpler approach for the fields since they are basically: key = "value"
        # and handle concatenation manually
        
        lines = body.split('\n')
        current_key = None
        current_val = ""
        
        for line in lines:
            line = line.strip()
            if not line: continue
            
            # Match start of a field: key = "value"
            field_start_match = re.match(r'^(\w+)\s*=\s*(.*)$', line)
            if field_start_match:
                current_key = field_start_match.group(1)
                val_part = field_start_match.group(2)
                # Remove starting quote and any trailing stuff
                current_val = val_part
                note_data[current_key] = current_val
            elif current_key and line.startswith('..'):
                # Continuation line
                note_data[current_key] += " " + line[2:].strip()
        
        # Post-process values (remove quotes and handle \n)
        for k in note_data:
            v = note_data[k]
            
            # Remove all forms of Lua string concatenation artifacts
            # Matches strings like "some text" ..
            v = re.sub(r'["\']\s*\.\.\s*$', '', v) 
            # Matches strings like .. "some text"
            v = re.sub(r'^\s*\.\.\s*["\']', '', v)
            
            # Remove leading/trailing quotes from the whole thing
            v = v.strip()
            if v.startswith('"') or v.startswith("'"):
                v = v[1:]
            if v.endswith('"') or v.endswith("'") or v.endswith(','):
                v = v.rstrip(',')
                v = v.rstrip('"').rstrip("'")
            
            # Final cleanup of any lingering ".. or similar from the middle if concatenation was complex
            v = re.sub(r'["\']\s*\.\.\s*["\']', '', v)
            v = re.sub(r'["\']\s*\.\.\s*', '', v)
            v = re.sub(r'\s*\.\.\s*["\']', '', v)
            
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
            
        md.append("---\n\n")
        
    return "".join(md)

def main():
    if not os.path.exists(SOURCE_FILE):
        print(f"Error: {SOURCE_FILE} not found.")
        return

    with open(SOURCE_FILE, 'r', encoding='utf-8') as f:
        content = f.read()

    entries = parse_changelog(content)
    if not entries:
        print("Error: No changelog entries found.")
        return

    md_output = format_markdown(entries)
    
    os.makedirs(os.path.dirname(OUTPUT_FILE), exist_ok=True)
    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        f.write(md_output)
        
    print(f"Successfully generated {OUTPUT_FILE}")

if __name__ == "__main__":
    main()
