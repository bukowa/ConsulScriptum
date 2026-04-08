# Local files and logs

While Consul is running, it also creates and updates several support files that are useful for day-to-day work and debugging.
All files are written to the **game root folder** (same directory as the game executable). They are plain text and can be opened in any editor.

## consul.output

Every line written to the console output area is also appended to this file. This is the way to read output you can't copy from the UI.

```
$ /faction_list
rom
pyr
sab
...
```

If autoclear is enabled (`/autoclear`), this file is truncated automatically when the autoclear threshold is reached (`/autoclear_after`). You can open this file in a text editor while the game is running - it updates as new lines are written.

## consul.history

One command per line, appended on every Send (except immediate duplicates). Loaded when the UI is created. The in-memory history navigation target is 100 entries, but the file itself is append-only.

```
/faction_list
/region_list
/help
consul.console.write("test")
```

## consul.config

Window position, panel visibility, and console settings. Written automatically each time a setting changes. Delete the file to reset everything to defaults.

Format: a serialized Lua table (written by [Serpent](https://github.com/pkulchenko/serpent)).

```lua
{
    ui = {
        position    = { x = 0, y = 0 },  -- 0,0 means auto-center on next open
        visibility  = { root = 0, consul = 1, scriptum = 1 }
    },
    console = {
        autoclear           = false,
        autoclear_after     = 1,
        last_read_changelog = "0.0.0",
    },
    battle = {
        use_in_battle = false,
    }
}
```

## consul.log

Internal debug log. Each line has a timestamp, level, and subsystem name. Useful when something isn't working.

```
[2026-04-05 21:13:58] [DEBUG] consul:commands: Module 'consul_commands' successfully loaded.
[2026-04-05 21:13:58] [DEBUG] consul:compat: DEI detected, applying compatibility patch
[2026-04-05 21:13:58] [ERROR] consul:commands: Error loading custom commands: ...
```

Log levels (from lowest to highest): `DISABLED`, `TRACE`, `INTERNAL`, `DEBUG`, `INFO`, `WARN`, `ERROR`, `CRITICAL`.

## consul.scriptum

A plain text file listing the paths of scripts shown in the Scriptum panel — one file path per line. Created automatically on first run, pre-populated with `scriptum.lua`.

```
scriptum.lua
scripts/campaign_debug.lua
```

Edit this file to add or remove scripts from the Scriptum panel. Changes take effect the next time you open the ConsulScriptum window (no game restart needed).

## scriptum.lua

The example script, created automatically on first run if it doesn't exist. Safe to edit or replace. It's just a regular Lua file.

## consul_custom_commands.lua

Your personal local command overrides. See [Custom console commands](../reference/adding-custom-commands) for the format. Not created automatically — you create it.
