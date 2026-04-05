local changelog = {
    header = "--------------------------------------------------------------------------------\n>> To mark as read and hide, type: /changelog_read\n>> To read again, type: /changelog\n--------------------------------------------------------------------------------\n\n",
    notes = {
        ["0.7.0"] = {
            common = "Added: Support for loading custom commands directly from the game directory or mods.\nAdded: Example template with instructions is available in the mod pack as `consul/consul_commands.lua`.\nAdded: Command `/reload_custom_commands` to refresh installed custom commands without restarting the game.",
            Rome2  = "Added: Specific Divide et Impera (DEI) commands for population management (`/dei_reset_all_pop`, `/dei_set_pop`, `/dei_reset_region_pop`)."
        },
        ["0.6.2"] = {
            common = "Fixed: Correctly load changelog module in campaign mode by fixing require path."
        },
        ["0.6.1"] = {
            common = "Added: Changelog feature.\nAdded: Command /changelog - displays version notes.\nAdded: Command /changelog_read - marks current version as read and hides it on startup."
        },
        ["0.6.0"] = {
            common = "Added: Consul ported to Attila: Total War (Alpha).\nAdded: GitHub release page availability for Attila build.",
            Attila = "Fixed: Hooked Attila systems correctly.",
            Rome2 = "Fixed: Hooked Rome2 systems correctly."
        }
    }
}
return changelog
