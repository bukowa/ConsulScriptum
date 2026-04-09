import re
import sys
import os

def parse_dump(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Find the logregistry structure
    # Match blocks like ["NAME"] = { ... }
    # We use a state machine-ish regex or simple split to find primary tables
    
    # Target patterns
    # ["FACTION_SCRIPT_INTERFACE"] = {
    #   ["method"] = "function: ...",
    # }
    
    # Extract first-level tables
    tables = {}
    
    # Find all top-level table matches in a dict-like structure: ["Key"] = {
    # Note: We look for keys at indentation level of 2 spaces
    table_matches = re.finditer(r'^  \["(?P<name>.*_SCRIPT_INTERFACE|UIComponent|GAME)"\] = \{', content, re.MULTILINE)
    
    for match in table_matches:
        table_name = match.group('name')
        start_pos = match.end()
        
        # Find the closing brace for this specific table (at the same indentation level)
        # We look for the next "  }" on its own line
        end_match = re.search(r'^  \}', content[start_pos:], re.MULTILINE)
        if not end_match:
            continue
            
        end_pos = start_pos + end_match.start()
        table_content = content[start_pos:end_pos]
        
        # Extract functions
        # ["allied_with"] = "function: 2CDCA288",
        functions = re.findall(r'\["(?P<func>.*)"\] = "function: .*?"', table_content)
        if functions:
            tables[table_name] = sorted(functions)

    return tables

def generate_markdown(tables, game_name, output_file):
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(f"# {game_name} API Reference\n\n")
        f.write(f"This is an automated API reference generated from the engine dump logs for {game_name}.\n\n")
        
        # Table of Contents
        f.write("## Table of Contents\n")
        for name in sorted(tables.keys()):
            anchor = name.lower().replace("_", "-")
            f.write(f"- [{name}](#{anchor})\n")
        f.write("\n---\n\n")
        
        for name in sorted(tables.keys()):
            f.write(f"## {name}\n\n")
            f.write("| Function Name |\n")
            f.write("| :--- |\n")
            for func in tables[name]:
                f.write(f"| `{func}` |\n")
            f.write("\n")

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Usage: python generate_api_reference.py <input_log> <game_name> <output_md>")
        sys.exit(1)
        
    input_log = sys.argv[1]
    game_name = sys.argv[2]
    output_md = sys.argv[3]
    
    if not os.path.exists(input_log):
        print(f"Error: {input_log} not found.")
        sys.exit(1)
        
    tables = parse_dump(input_log)
    generate_markdown(tables, game_name, output_md)
    print(f"Successfully generated {output_md}")
