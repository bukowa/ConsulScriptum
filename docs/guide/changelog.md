# Changelog

## v0.7.0

**Common:**
- Added: Support for loading custom commands directly from the game directory or mods.
- Added: Example template with instructions is available in the mod pack as `consul/consul_commands.lua`.
- Added: Command `/reload_custom_commands` to refresh installed custom commands without restarting the game.

**Rome II specific:**
- Added: Specific Divide et Impera (DEI) commands for population management (`/dei_reset_all_pop`, `/dei_set_pop`, `/dei_reset_region_pop`).

---

## v0.6.2

**Common:**
- Fixed: Correctly load changelog module in campaign mode by fixing require path.

---

## v0.6.1

**Common:**
- Added: Changelog feature.
- Added: Command `/changelog` — displays version notes.
- Added: Command `/changelog_read` — marks current version as read and hides it on startup.

---

## v0.6.0

**Common:**
- Added: Consul ported to Attila: Total War (Alpha).
- Added: GitHub release page availability for Attila build.

**Attila specific:**
- Fixed: Hooked Attila systems correctly.

**Rome II specific:**
- Fixed: Hooked Rome2 systems correctly.
