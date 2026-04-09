local changelog = {
    header = "--------------------------------------------------------------------------------\n>> To mark as read and hide, type: /changelog_read\n>> To read again, type: /changelog\n--------------------------------------------------------------------------------\n\n",
    notes = {
        ["unreleased"] = {
            common = "Added: Support for loading custom commands directly from the game directory or pack mods (you can now distribute your commands on the Steam Workshop)."..
            "\nAdded: An example template with instructions is available in the mod pack as `consul/consul_commands.lua`."..
            "\nAdded: Command `/reload_custom_commands` to refresh installed custom commands without restarting the game."..
            "\nAdded: `consul.scriptum.entry` variable is now available in custom scripts, allowing them to identify the button that triggered them."..
            "\nFixed: Scriptum scripts now reload on any Consul component click to ensure they are fresh.",
            Rome2  = "Added: Specific Divide et Impera (DEI) commands for population management (`/dei_reset_all_pop`, `/dei_set_pop`, `/dei_reset_region_pop`).",
            Attila = "Added: Consul now works in Attila campaign battles (trigger via /use_in_battle)"
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
