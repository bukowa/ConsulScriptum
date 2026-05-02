import sys
import os
import re

def bump_version(new_version):
    # 1. Update Makefile
    makefile_path = 'Makefile'
    if os.path.exists(makefile_path):
        with open(makefile_path, 'r', encoding='utf-8') as f:
            content = f.read()
        # MOD_VERSION = 0.1.0
        new_content = re.sub(r'MOD_VERSION\s*=\s*[\d\.]+', f'MOD_VERSION = {new_version}', content)
        with open(makefile_path, 'w', encoding='utf-8', newline='\n') as f:
            f.write(new_content)
        print(f"Updated {makefile_path}")

    # 2. Update src/consul/consul.lua
    consul_lua_path = 'src/consul/consul.lua'
    if os.path.exists(consul_lua_path):
        with open(consul_lua_path, 'r', encoding='utf-8') as f:
            content = f.read()
        # VERSION = "0.9.1",
        new_content = re.sub(r'VERSION\s*=\s*["\'][\d\.]+["\']', f'VERSION = "{new_version}"', content)
        with open(consul_lua_path, 'w', encoding='utf-8', newline='\n') as f:
            f.write(new_content)
        print(f"Updated {consul_lua_path}")

    # 3. Update docs/.vitepress/config.mts
    vitepress_config_path = 'docs/.vitepress/config.mts'
    if os.path.exists(vitepress_config_path):
        with open(vitepress_config_path, 'r', encoding='utf-8') as f:
            content = f.read()
        # look for text: 'v0.9.1'
        new_content = re.sub(r"text:\s*['\"]v[\d\.]+['\"]", f"text: 'v{new_version}'", content)
        with open(vitepress_config_path, 'w', encoding='utf-8', newline='\n') as f:
            f.write(new_content)
        print(f"Updated {vitepress_config_path}")

    # 4. Update src/consul/consul_changelog.lua
    changelog_path = 'src/consul/consul_changelog.lua'
    if os.path.exists(changelog_path):
        with open(changelog_path, 'r', encoding='utf-8') as f:
            content = f.read()
        # Look for ["unreleased"] or ['unreleased']
        if '["unreleased"]' in content or "['unreleased']" in content:
            new_content = content.replace('["unreleased"]', f'["{new_version}"]')
            new_content = new_content.replace("['unreleased']", f"['{new_version}']")
            with open(changelog_path, 'w', encoding='utf-8', newline='\n') as f:
                f.write(new_content)
            print(f"Updated {changelog_path} (renamed 'unreleased' to '{new_version}')")
        else:
            print(f"Warning: 'unreleased' section not found in {changelog_path}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python scripts/bump_version.py <NEW_VERSION>")
        sys.exit(1)
    bump_version(sys.argv[1])
