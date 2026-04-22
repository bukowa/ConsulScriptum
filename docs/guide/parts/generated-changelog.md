## v0.8.0-alpha.1
**Common:**
- This update is focused on debugging the world and ui, it brings another set of improvements for the Attila too!
- Added: New 'Debugging The World' section to the official manual.
- Added: New 'Debugging The UI' section to the official manual.
- Added: /debug_mouseover and /debug_onclick displays more information about the UI component alongside the hierarchy
- Fixed: /debug command now works properly for factions and settlements in diplomacy and strategic map (Rome 2 and Attila).
- Fixed: /debug fixes and improvements, theres a lot, overall everything should be more readable
- Fixed: increased priority of consul UI to ensure it loads on top (especially important for Attila).

**Attila specific:**
- Fixed: prevent multiple creations of consul UI in battle mode.

---

## v0.7.2
**Common:**
- Added: Command `/consul_log_level <integer>` to set the consul log level persistently (e.g. 1=DEBUG, 2=INFO, 3=WARN).

**Attila specific:**
- Fixed: /debug commands now properly prints information in Attila

---

## v0.7.1
**Common:**
- Added: Commands for Lua profiling via `/profi_start`, `/profiler_start`, `/profi_stop <filename>`, and `/profiler_stop <filename>` commands.
- Added: Command `/consul_debug_turn_time` to measure AI turn duration.
- Added: New function `consul.debug.disable_all_diplomacy()` to instantly block all diplomacy actions between all factions.

---

## v0.7.0
**Common:**
- Added: Official manual page with detailed instructions on how scripting works and how to create your own scripts: https://bukowa.github.io/ConsulScriptum
- Added: Direct link to the manual added to the top of the Steam Workshop description.
- Added: Support for loading custom commands directly from the game directory or pack mods (you can now distribute your commands on the Steam Workshop).
- Added: An example template with instructions is available in the mod pack as `consul/consul_commands.lua`.
- Added: Command `/reload_custom_commands` to refresh installed custom commands without restarting the game.
- Added: `consul.scriptum.entry` variable is now available in custom scripts, allowing them to identify and highlight the button (green) that triggered them. More info in the Consul documentation.
- Fixed: Scriptum scripts now reload on any Consul component click to ensure they are fresh.
- Added: Command `/logregistry` to dump all Lua registries and environments to `consul.log`.
- Added: Command `/consul_debug_events` to toggle persistent event logging at startup.

**Rome II specific:**
- Added: Specific Divide et Impera (DEI) commands for population management (`/dei_reset_all_pop`, `/dei_set_pop`, `/dei_reset_region_pop`).

**Attila specific:**
- Added: Consul now works in Attila campaign battles (trigger via /use_in_battle)
- Added: All game events for Attila for event tracking.

---

## v0.6.2
**Common:**
- Fixed: The changelog module now correctly loads in campaign mode by fixing the require path.

---

## v0.6.1
**Common:**
- Added: Changelog feature.
- Added: Command /changelog - displays version notes.
- Added: Command /changelog_read - marks current version as read and hides it on startup.

---

## v0.6.0
**Common:**
- Added: Ported Consul to Attila: Total War (Alpha).
- Added: GitHub release page is now available for the Attila build.

**Rome II specific:**
- Fixed: Correctly hooked Rome2 systems.

**Attila specific:**
- Fixed: Correctly hooked Attila systems.

---

