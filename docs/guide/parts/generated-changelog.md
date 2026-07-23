## v0.10.0
**Rome II specific:**
- Now working on MacOS.

**Attila specific:**
- Now working on MacOS.

---

## v0.9.3
**Common:**
- Fixed: consul.env.mode stack overflow in battles that prevented moving consul window

---

## v0.9.2
**Common:**
- Fixed: event logging bugfix
- Fixed: typo in DEI specific commands

---

## v0.9.1
**Common:**
- Fixed: Changelog improvements so you don't get spammed with them
- Fixed: event logging and logging improvement bugs

---

## v0.9.0
**Common:**
- New: THRONES OF BRITANNIA support for Consul Scriptum (link in Github release page)
- Fixed: few minor boring bugs (html debug, ui component finding,offscreen detection)

---

## v0.8.1
**Common:**
- Fixed: UI Debugger permission issues (Program Files access) by redirecting data to C:\\Users\\Public\\consul.

---

## v0.8.0
**Common:**
- Added: UI Debugger (/debug_html command) - A powerful new HTML-based tool for real-time UI inspection, hierarchy manipulation, and live searching.
- Added: Console minimized state is now remembered across sessions.
- Added: Official Manual updates with new 'Debugging The World' and 'Debugging The UI' sections.
- Added: Improved /debug, /debug_mouseover and /debug_onclick with more detailed information.
- Fixed: Increased priority of consul UI to ensure it loads on top of game elements (especially for Attila).
- Fixed: /debug command now works properly for factions and settlements in diplomacy and strategic map.

**Attila specific:**
- Fixed: Prevent multiple creations of consul UI in battle mode.
- Added: Consul visibility can be toggled on/off via top left button like in Rome2.

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

