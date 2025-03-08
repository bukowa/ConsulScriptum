# read xml file
import copy
import sys
import xml.etree.ElementTree as ET

# read arguments
print(sys.argv)
consul_new_entry = f'{sys.argv[1]}_entry'
consul_new_script = f'{sys.argv[1]}_script'
consul_new_tooltip = sys.argv[2]
consul_new_latin = sys.argv[3]

# read xml file
tree = ET.parse('./src/ui/frontend ui/sp_frame.xml')
root = tree.getroot()
uientry = root.find('uientry')
consul_children_tag = uientry.find(
    './children/uientry/children/uientry/children/uientry[2]/children/uientry/children/uientry/children/uientry/children'
)

# grab first uientry tag and copy it
new_entry = copy.deepcopy(consul_children_tag.find('uientry'))

# set `entry` and `tooltip`
new_entry.find('s').text = consul_new_entry
new_entry.find('unicode').text = consul_new_tooltip

# set `script`
new_entry_children = new_entry.find('children/uientry')
new_entry_children.find('s').text = consul_new_script

# set `latin_name`
for state in new_entry_children.find('states').findall('state'):
    state.find('unicode').text = consul_new_latin

# add as last child
consul_children_tag.append(new_entry)

# update count attribute
consul_children_tag.attrib['count'] = str(len(consul_children_tag.findall('uientry')))

# sort alphabetically
consul_children_tag[:] = sorted(
    consul_children_tag,
    key=lambda x: x.find('children/uientry/states/state/unicode').text
)

# save the file
tree.write('./src/ui/frontend ui/sp_frame.xml')

def find_consul_scriptum(_root):
    for _e in _root.findall(".//uientry"):
        _f = _e.find("s")
        if _f is not None and _f.text == 'consul_scriptum':
            return _e
    raise ValueError("consul_scriptum not found")

def replace_consul_scriptum(_root, _new):
    # Helper function to recursively find and replace the element
    def find_and_replace(element):
        for child in list(element):  # Use list() to avoid modifying the list while iterating
            if child.tag == "uientry":
                s_tag = child.find("s")
                if s_tag is not None and s_tag.text == "consul_scriptum":
                    element.remove(child)  # Remove the old entry
                    element.append(_new)   # Add the new entry
                    return True  # Return True once replacement is done
            # Recursively search in child elements
            if find_and_replace(child):
                return True
        return False

    # Start the search from the root
    return find_and_replace(_root)

# read xml file
tree2 = ET.parse('./src/ui/common ui/menu_bar.xml')
root2 = tree2.getroot()

# replace consul_scriptum
if not replace_consul_scriptum(root2, copy.deepcopy(find_consul_scriptum(root))):
    raise ValueError("consul_scriptum not found in menu_bar.xml")

# save the file
tree2.write('./src/ui/common ui/menu_bar.xml')
