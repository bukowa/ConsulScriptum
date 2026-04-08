# Custom Commands

Custom commands are `/slash-commands` that you write yourself and load into ConsulScriptum.

---

## Module format

A command module is a Lua file that returns a table with `exact` and/or `starts_with` keys.

```lua
return {
    -- Matched when input equals the key exactly
    exact = {
        ['/my_cmd'] = {
            help    = function() return "Description shown in /help" end,
            func    = function() return "output string" end,
            exec    = false,  -- if true: returned string is executed as Lua
            returns = true,   -- if true: returned string is printed to output
            setup   = function(cfg) end,  -- optional: called once at load
        },
    },

    -- Matched when input starts with the key
    starts_with = {
        ['/my_cmd '] = {  -- trailing space separates command from arguments
            help = function() return "Description with <args>" end,
            func = function(_cmd)
                -- _cmd is the full raw input, e.g. "/my_cmd hello"
                local args = string.sub(_cmd, 9)
                return args
            end,
            exec    = false,
            returns = true,
        },
    },
}
```

### Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `help` | `function() → string` | Yes | Text shown in `/help` output |
| `func` | `function([_cmd]) → string` | Yes | Command logic. `_cmd` passed only for `starts_with` |
| `exec` | boolean | Yes | Return value is executed as Lua code |
| `returns` | boolean | Yes | Return value is printed to console output |
| `setup` | `function(cfg)` | No | Called once when module loads. `cfg` = `consul.config.read()` |

---

## Installation

### Option A — local file (highest priority)

Create `consul_custom_commands.lua` in the game root folder. It is loaded after any mod pack commands, so it overrides them if you use the same command key.

### Option B — mod pack

Include your commands at `consul/consul_commands.lua` inside a `.pack` file. ConsulScriptum loads this automatically.

### Option C — DEI-specific

Name your file `consul/consul_commands_dei.lua` inside a pack. It is loaded automatically only when Divide et Impera is active.

---

## Hot-reload

```
/reload_custom_commands
```

Forces a fresh load of all three sources (local, pack, DEI) without restarting the game. Old command registrations from the previous load are removed first — you won't end up with duplicate or ghost commands.

---

## Using `setup()`

`setup()` runs once when the module is loaded (and again on `/reload_custom_commands`). Use it to register game event listeners.

If you use `setup()` to hook a game event, guard it with a global flag to avoid duplicate listeners on reload:

```lua
return {
    exact = {
        ['/log_settlements'] = {
            setup = function(cfg)
                if not __log_settlements_hooked then
                    table.insert(events.SettlementSelected, function(context)
                        if _is_logging then
                            consul.console.write(context:garrison_residence():region():name())
                        end
                    end)
                    __log_settlements_hooked = true
                end
            end,
            help    = function() return "Toggle settlement selection log" end,
            func    = function()
                _is_logging = not _is_logging
                return "logging: " .. tostring(_is_logging)
            end,
            exec    = false,
            returns = true,
        }
    }
}
```

---

## Examples

### Print a value

```lua
return {
    exact = {
        ['/treasury'] = {
            help = function() return "Print human faction treasury" end,
            func = function()
                local fl = consul._game():model():world():faction_list()
                for i = 0, fl:num_items() - 1 do
                    local fac = fl:item_at(i)
                    if fac:is_human() then
                        return fac:name() .. ": " .. fac:treasury()
                    end
                end
            end,
            exec = false, returns = true,
        }
    }
}
```

### Parameterized command

```lua
return {
    starts_with = {
        ['/echo '] = {
            help = function() return "Echo: /echo <text>" end,
            func = function(_cmd)
                return string.sub(_cmd, 7)  -- strip "/echo "
            end,
            exec = false, returns = true,
        }
    }
}
```

### Execute Lua dynamically (exec mode)

```lua
return {
    starts_with = {
        ['/run '] = {
            help = function() return "Run Lua: /run <code>" end,
            func = function(_cmd)
                return string.sub(_cmd, 6)  -- return the code string
            end,
            exec = true,   -- ConsulScriptum will execute the returned string
            returns = false,
        }
    }
}
```

---

## Available API in commands

See [Internal API](./internal-api) for the full reference.
