import os
import re

# Configuration
SOURCE_FILES = [
    ('src/consul/consul.lua', 'Core Commands'),
    ('src/consul/consul_commands.lua', 'Custom Commands'),
    ('src/consul/consul_commands_dei.lua', 'DeI-Specific Commands'),
]

OUTPUT_FILE = 'docs/reference/commands.md'

def parse_commands(content):
    commands = []
    
    # Regex to find the command block starting with a slash: ['/command'] = {
    cmd_pattern = re.compile(r"\[['\"](/[^'\"]+)['\"]\]\s*=\s*\{", re.DOTALL)
    
    # Extract the entire help function block
    help_func_pattern = re.compile(r"help\s*=\s*function\(\)(.*?)end\s*[,}]", re.DOTALL)
    # Robust Lua string literal regex (handles escaped quotes and both types)
    string_literal_pattern = re.compile(r'"(?:[^"\\]|\\.)*"|\'(?:[^\'\\]|\\.)*\'', re.DOTALL)

    matches = list(cmd_pattern.finditer(content))
    
    for i, match in enumerate(matches):
        command_name = match.group(1)
        start_pos = match.end()
        next_match_start = matches[i+1].start() if i + 1 < len(matches) else len(content)
        
        # Look for the help function block within this command's definition
        block_content = content[start_pos:next_match_start]
        help_block_match = help_func_pattern.search(block_content)
        
        if help_block_match:
            help_body = help_block_match.group(1)
            
            # Find all strings
            raw_literals = string_literal_pattern.findall(help_body)
            # Remove wrapping quotes from each literal
            literals = [s[1:-1] for s in raw_literals]
            description = "".join(literals).strip()
            
            # Clean up extra spaces and newlines
            description = re.sub(r'\s+', ' ', description)
            
            # Escape HTML special characters that break Vue/VitePress
            description = description.replace('<', '&lt;').replace('>', '&gt;')
            
            if description:
                commands.append((command_name, description))
            
    return commands

def main():
    all_content = [
        "# Built-in Commands Reference\n\n",
        "ConsulScriptum comes with a variety of built-in slash-commands for debugging and campaign manipulation. You can run these by typing them directly into the **Console** tab.\n\n",
        "::: tip\n",
        "Type `/help` in the game console to see this list in-game.\n",
        ":::\n\n"
    ]
    
    found_any = False
    
    for file_path, category in SOURCE_FILES:
        if not os.path.exists(file_path):
            print(f"Warning: {file_path} not found. Skipping.")
            continue
            
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        commands = parse_commands(content)
        
        if commands:
            found_any = True
            all_content.append(f"## {category}\n\n")
            all_content.append("<div class=\"compact-reference\">\n\n")
            
            # Sort commands alphabetically
            commands.sort()
            
            for name, desc in commands:
                all_content.append(f"#### `{name}`\n")
                all_content.append(f"{desc}\n\n")

            all_content.append("</div>\n\n")
            
    if not found_any:
        print("Error: No commands found in any source files.")
        return

    # Ensure output directory exists
    os.makedirs(os.path.dirname(OUTPUT_FILE), exist_ok=True)
    
    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        f.writelines(all_content)
        
    print(f"Successfully generated {OUTPUT_FILE}")

if __name__ == "__main__":
    main()
