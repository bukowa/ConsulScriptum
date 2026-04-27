local changelog = {
    header = "--------------------------------------------------------------------------------\n>> To mark as read and hide, type: /changelog_read\n>> To read again, type: /changelog\n--------------------------------------------------------------------------------\n\n",
    notes = {
        ["unreleased"] = {
            common = "\nAdded: In-game highlighting sync: Selecting a component in the tree now highlights it in the game automatically."..
            "\nAdded: Drag & Drop hierarchy restructuring (move components in the tree to call :Adopt)."..
            "\nAdded: UI Debugger tree improvements: Auto-expand folders when hovering during drag operations."..
            "\nAdded: Component Factory (Attila): Dynamically instantiate new UI components using layout templates directly from the inspector."
        },
        ["0.8.0-alpha.6"] = {
            common = "\nAdded: New Global Search in UI Debugger sidebar (search by ID, Address, Text, Tooltip, State, etc.)."..
            "\nAdded: UI Debugger search features: Highlighting, Auto-expand folders, Auto-scroll, and Live Refresh during polling."..
            "\nFixed: Critical bug in UI Debugger parsing where multi-line text (GetStateText) would break the tree structure."
        },
        ["0.8.0-alpha.5"] = {
            common = "\nRefactored UI Debugger core logic for improved reliability."..
            "\nAdded: Ability to hide individual property boxes in UI Debugger with persistence (saves to local storage)."..
            "\nChanged: UI Debugger toggle shortcut changed from F5 to F7 (toggle_stream_pause)."..
            "\nFixed: UI Debugger now correctly handles methods returning multiple values (like GetStateText)."
        },
        ["0.8.0-alpha.4"] = {
            common = "\nThis update is focused on debugging the world and ui, it brings another set of improvements for the Attila.\n"..
            "\nAdded: New /debug_html command that opens a HTML page in browser for epic UI debugging (and /debug_html_on as a toggle for persistence across restarts)"..
            "\nAdded: New 'Debugging The World' section to the official manual."..
            "\nAdded: New 'Debugging The UI' section to the official manual."..
            "\nAdded: /debug_mouseover and /debug_onclick displays more information about the UI component alongside the hierarchy"..
            "\nFixed: /debug command now works properly for factions and settlements in diplomacy and strategic map (Rome 2 and Attila)."..
            "\nFixed: /debug fixes and improvements, theres a lot, overall everything should be more readable"..
            "\nFixed: increased priority of consul UI to ensure it loads on top (especially important for Attila).",
            Attila = "Fixed: prevent multiple creations of consul UI in battle mode.",
        },
        ["0.7.2"] = {
            common = "Added: Command `/consul_log_level <integer>` to set the consul log level persistently (e.g. 1=DEBUG, 2=INFO, 3=WARN).",
            Attila = "Fixed: /debug commands now properly prints information in Attila"
        },
        ["0.7.1"] = {
            common = "Added: Commands for Lua profiling via `/profi_start`, `/profiler_start`, `/profi_stop <filename>`, and `/profiler_stop <filename>` commands."..
            "\nAdded: Command `/consul_debug_turn_time` to measure AI turn duration."..
            "\nAdded: New function `consul.debug.disable_all_diplomacy()` to instantly block all diplomacy actions between all factions."
        },
        ["0.7.0"] = {
            common = "Added: Official manual page with detailed instructions on how scripting works and how to create your own scripts: https://bukowa.github.io/ConsulScriptum"..
            "\nAdded: Direct link to the manual added to the top of the Steam Workshop description."..
            "\nAdded: Support for loading custom commands directly from the game directory or pack mods (you can now distribute your commands on the Steam Workshop)."..
            "\nAdded: An example template with instructions is available in the mod pack as `consul/consul_commands.lua`."..
            "\nAdded: Command `/reload_custom_commands` to refresh installed custom commands without restarting the game."..
            "\nAdded: `consul.scriptum.entry` variable is now available in custom scripts, allowing them to identify and highlight the button (green) that triggered them. More info in the Consul documentation."..
            "\nFixed: Scriptum scripts now reload on any Consul component click to ensure they are fresh."..
            "\nAdded: Command `/logregistry` to dump all Lua registries and environments to `consul.log`."..
            "\nAdded: Command `/consul_debug_events` to toggle persistent event logging at startup.",
            Rome2  = "Added: Specific Divide et Impera (DEI) commands for population management (`/dei_reset_all_pop`, `/dei_set_pop`, `/dei_reset_region_pop`).",
            Attila = "Added: Consul now works in Attila campaign battles (trigger via /use_in_battle)"..
            "\nAdded: All game events for Attila for event tracking."
        },
        ["0.6.2"] = {
            common = "Fixed: The changelog module now correctly loads in campaign mode by fixing the require path."
        },
        ["0.6.1"] = {
            common = "Added: Changelog feature.\nAdded: Command /changelog - displays version notes.\nAdded: Command /changelog_read - marks current version as read and hides it on startup."
        },
        ["0.6.0"] = {
            common = "Added: Ported Consul to Attila: Total War (Alpha).\nAdded: GitHub release page is now available for the Attila build.",
            Attila = "Fixed: Correctly hooked Attila systems.",
            Rome2 = "Fixed: Correctly hooked Rome2 systems."
        }
    }
}
return changelog
