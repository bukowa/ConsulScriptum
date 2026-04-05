# Internal API

The `consul` global table is the entire ConsulScriptum API. Everything described here is accessible from Scriptum files and custom commands.

---

## Game access

### `consul._game()`

Returns `scripting.game_interface` or `nil`. May return `nil` in Frontend and Battle contexts.

```lua
local game = consul._game()
if game then
    local world = game:model():world()
end
```

---

## Console output

### `consul.console.write(msg)`

Append a string to the console output area.

```lua
consul.console.write("done")
consul.console.write(tostring(some_value))
```

---

## Config

### `consul.config.read() → table`

Returns the current config. Creates defaults if the file is missing or invalid.

### `consul.config.process(func)`

Read, mutate, write in one call.

```lua
consul.config.process(function(cfg)
    cfg.console.autoclear = true
end)
```

---

## Logging

### `consul.new_log(name) → Logger`

Creates a named logger that writes to `consul.log`.

```lua
local log = consul.new_log('my_script')
log:debug("value: " .. tostring(x))
log:warn("something unexpected")
log:error("failed: " .. err)
```

---

## Debug pointers

These are populated when the player selects a character or settlement via the debug interaction.

| Field | Type |
|-------|------|
| `consul.debug.character` | `character_script_interface` or nil |
| `consul.debug.settlement` | `settlement_script_interface` or nil |
| `consul.debug.faction` | `faction_script_interface` or nil |

---

## Custom command loader

### `consul.console.commands.load_module(name) → ok, msg`

Load a single command module by name. Returns `true, msg` on success, `false, err` on failure.

### `consul.console.commands.load_custom()`

Load all three standard sources: `consul_commands`, `consul_custom_commands`, `consul_commands_dei`. Same as `/reload_custom_commands`.

---

## Bundled libraries

These are available in any script or command:

| | Library | Common use |
|-|---------|-----------|
| `consul.serpent` | [Serpent](https://github.com/pkulchenko/serpent) | Serialize/deserialize tables |
| `consul.inspect(v)` | [inspect.lua](https://github.com/kikito/inspect.lua) | Pretty-print any value |
| `consul.pretty(v)` | [Penlight pretty](https://lunarmodules.github.io/Penlight/) | Formatted table output |

---

## Compatibility

### `consul.compat.is_dei() → boolean`

Returns `true` if Divide et Impera is loaded (Rome II only). Always returns `false` on Attila.
