import os
import xml.etree.ElementTree as ET
import re

def generate_consul_docs():
    xml_path = os.path.join('src', 'ui', 'common ui', 'consul.xml')
    md_path = os.path.join('docs', 'guide', 'parts', 'generated-consul-scripts.md')

    if not os.path.exists(xml_path):
        print(f"Error: {xml_path} not found.")
        return

    try:
        print(f"Parsing {xml_path}...")
        tree = ET.parse(xml_path)
        root = tree.getroot()

        scripts_data = []
        # Scan all uientry elements in the entire file
        for script_entry in root.iter('uientry'):
            s_tag = script_entry.find('s')
            tech_id = s_tag.text.strip() if s_tag is not None and s_tag.text else ""

            # Filter for entries starting with consul_ and ending with _entry
            if not (tech_id.lower().startswith('consul_') and tech_id.lower().endswith('_entry')):
                continue

            print(f"Found potential script: {tech_id}")

            # Tooltip
            unicode_tag = script_entry.find('unicode')
            tooltip = unicode_tag.text.strip() if unicode_tag is not None and unicode_tag.text else "No description available."

            # Display Name
            display_name = tech_id.replace('consul_', '').replace('_entry', '').replace('_', ' ').title()

            inner_children = script_entry.find('children')
            if inner_children is not None:
                for inner_uientry in inner_children.findall('uientry'):
                    inner_s = inner_uientry.find('s')
                    if inner_s is not None and inner_s.text and '_script' in inner_s.text:
                        states = inner_uientry.find('states')
                        if states is not None:
                            for state in states.findall('state'):
                                state_s = state.find('s')
                                if state_s is not None and state_s.text in ['default', 'unselected', 'NewState']:
                                    u_tag = state.find('unicode')
                                    if u_tag is not None and u_tag.text and u_tag.text.strip():
                                        display_name = u_tag.text.strip()
                                        break

            # Avoid duplicates if multiple entries exist
            if not any(s['tech_id'] == tech_id for s in scripts_data):
                scripts_data.append({
                    'display_name': display_name,
                    'tech_id': tech_id,
                    'tooltip': tooltip.replace('|', '\\|')
                })

        print(f"Collected {len(scripts_data)} unique scripts.")

        if not scripts_data:
            print("Warning: No scripts found matching the criteria.")
            return

        # Generate Markdown (List only)
        md_content = []

        # Short summaries mapping to clarify what each script does in plain English
        SHORT_SUMMARIES = {
            "Ad Rebellos": "Spawns rebellion",
            "Adice Provinciam": "Transfer settlement",
            "Aedificatio": "Fast construction",
            "Aerarium": "Add treasury",
            "Casus Belli": "Force war",
            "Custodes Vocati": "Exchange garrison",
            "Exterminare": "Kill character",
            "Impetus": "Restore action points",
            "Incrementum": "Add growth point",
            "Pax Aeterna": "Force peace",
            "Scientia": "Fast research",
            "Sedatio": "Boost public order",
            "Subiugatio": "Force vassalage",
            "Vexatio": "Penalize public order",
            "Virtus": "Boost combat stats",
        }

        # Sort scripts by name
        scripts_data.sort(key=lambda x: x['display_name'])

        # Game compatibility mapping based on engine support & consul.lua TOB.setup()
        TOB_EXCLUDED = {
            "consul_force_exchange_garrison_entry",
            "consul_incrementum_regio_entry",
            "consul_sedatio_provinciae_entry",
            "consul_vexatio_provinciae_entry",
        }

        # Add Compatibility Matrix Table
        md_content.append("### Compatibility Matrix\n")
        md_content.append("| Script | ID | Rome II | Attila | ToB |")
        md_content.append("| :--- | :--- | :---: | :---: | :---: |")
        for script in scripts_data:
            name = script['display_name']
            tid = script['tech_id']
            tob_status = "❌" if tid in TOB_EXCLUDED else "✅"
            md_content.append(f"| **{name}** | `{tid}` | ✅ | ✅ | {tob_status} |")
        md_content.append("\n---\n")

        for script in scripts_data:
            name = script['display_name']
            short = SHORT_SUMMARIES.get(name, "Script action")
            tid = script['tech_id']
            games = "Rome II, Attila" if tid in TOB_EXCLUDED else "Rome II, Attila, ToB"
            
            md_content.append(f"#### {name} — {short}\n")
            md_content.append(f"**ID**: `{tid}`  ")
            md_content.append(f"**Compatibility**: {games}  ")
            md_content.append(f"{script['tooltip']}\n")

        # Ensure directory exists
        os.makedirs(os.path.dirname(md_path), exist_ok=True)

        with open(md_path, 'w', encoding='utf-8', newline='\n') as f:
            f.write("\n".join(md_content))

        print(f"Successfully generated {md_path}")

    except Exception as e:
        import traceback
        print(f"An error occurred: {e}")
        traceback.print_exc()

if __name__ == "__main__":
    generate_consul_docs()
