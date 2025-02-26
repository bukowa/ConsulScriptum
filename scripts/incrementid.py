import re
import sys

def increment_ids_in_file(file_path):
    # Read the file content
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()

    # Regex to find all <u>ID</u> entries
    u_pattern = re.compile(r"(<u>)(\d+)(</u><!-- ID )")
    # Regex to find all <i>ID</i> entries with the comment <!-- default state id -->
    i_pattern = re.compile(r"(<i>)(\d+)(</i><!-- default state id -->)")

    # Function to increment the ID by 1, but skip if the ID is 0
    def increment_id(match):
        id_value = int(match.group(2))
        if id_value == 0:
            return match.group(0)  # Return the original match if ID is 0
        return f"{match.group(1)}{id_value + 1872}{match.group(3)}"

    # Replace all IDs in the content for <u> tags
    updated_content = u_pattern.sub(increment_id, content)
    # Replace all IDs in the content for <i> tags
    updated_content = i_pattern.sub(increment_id, updated_content)

    # Write the updated content back to the file
    with open(file_path, 'w', encoding='utf-8') as file:
        file.write(updated_content)

    print(f"IDs in '{file_path}' have been incremented by 1 (skipping 0).")

# Main function
if __name__ == "__main__":
    # Check if a file path is provided as an argument
    if len(sys.argv) != 2:
        print("Usage: python increment_ids.py <file_path>")
        sys.exit(1)

    # Get the file path from the command-line argument
    file_path = sys.argv[1]
    increment_ids_in_file(file_path)