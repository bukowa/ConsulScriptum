local changelog = {
    header = "--------------------------------------------------------------------------------\n>> To mark as read and hide, type: /changelog_read\n>> To read again, type: /changelog\n--------------------------------------------------------------------------------\n\n",
    notes = {
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
