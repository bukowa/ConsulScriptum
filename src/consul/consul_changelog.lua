local changelog = {
    header = "--------------------------------------------------------------------------------\n>> To mark as read and hide, type: /changelog_read\n>> To read again, type: /changelog\n>> To read documentation visit https://consulscriptum.com\n --------------------------------------------------------------------------------\n\n",
    notes = {
        ["unreleased"] = {
            common = "Fixed: consul.env.mode stack overflow in battles that prevented moving consul window",
        },
        ["0.9.2"] = {
            common = "Fixed: event logging bugfix"..
            "\nFixed: typo in DEI specific commands",
            silent = true
        },
        ["0.9.1"] = {
          common = "Fixed: Changelog improvements so you don't get spammed with them"..
          "\nFixed: event logging and logging improvement bugs",
          silent = true
        },
        ["0.9.0"] = {
          common = "New: THRONES OF BRITANNIA support for Consul Scriptum (link in Github release page)"..
          "\nFixed: few minor boring bugs (html debug, ui component finding,offscreen detection)"
        },
        ["0.8.1"] = {
            common = "Fixed: UI Debugger permission issues (Program Files access) by redirecting data to C:\\Users\\Public\\consul.",
            silent = true
        },
        ["0.8.0"] = {
            common = "\nAdded: UI Debugger (/debug_html command) - A powerful new HTML-based tool for real-time UI inspection, hierarchy manipulation, and live searching."..
            "\nAdded: Console minimized state is now remembered across sessions."..
            "\nAdded: Official Manual updates with new 'Debugging The World' and 'Debugging The UI' sections."..
            "\nAdded: Improved /debug, /debug_mouseover and /debug_onclick with more detailed information."..
            "\nFixed: Increased priority of consul UI to ensure it loads on top of game elements (especially for Attila)."..
            "\nFixed: /debug command now works properly for factions and settlements in diplomacy and strategic map.",
            Attila = "Fixed: Prevent multiple creations of consul UI in battle mode."..
            "\nAdded: Consul visibility can be toggled on/off via top left button like in Rome2.",
            TOB = "Added: Ported Consul to Total War Saga: Thrones of Britannia."
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
            common = "Fixed: The changelog module now correctly loads in campaign mode by fixing the require path.",
            silent = true
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
