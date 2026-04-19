## Generated reference

### Functions

#### `consul._game`

Return active game interface `scripting.game_interface` or `nil`.<br>
 This may be unavailable in Frontend/Battle contexts.


 Example:
```lua
consul._game():force_make_peace(faction1, faction2)

```

---

#### `consul.compat.is_dei`

A function returning a boolean indicating if the DEI mod is loaded.



---

#### `consul.config.process`

A function that reads the config file and writes it back to the file.

 Parameters:
| Name | Type | Description |
| :--- | :--- | :--- |
| `func` | `function` |  A function that takes a config table as an argument. |

 Example:
```lua
consul.config.process(function(cfg)
    cfg.ui.position.x = 100
    cfg.ui.position.y = 100
end)

```

---

#### `consul.config.read`

A function that reads the config file and returns a table.


 Example:
```lua
local cfg = consul.config.read()

```

---

#### `consul.config.write`

A function that writes the config table to the config file.

 Parameters:
| Name | Type | Description |
| :--- | :--- | :--- |
| `cfg` | `table` |  The config table to write. |

 Example:
```lua
consul.config.write(cfg)

```

---

#### `consul.console.clear`

Clear all text currently shown in the Consul console output panel.


 Example:
```lua
consul.console.clear()

```

---

#### `consul.console.commands.load_module`

A function that loads a module into the console commands.

 Parameters:
| Name | Type | Description |
| :--- | :--- | :--- |
| `module_name` | `string` |  The name of the module to load. |

 Example:
```lua
local ok, err = consul.console.commands.load_module('consul_commands')
if not ok then
    consul.console.write(err)
end

```

---

#### `consul.console.execute`

A function that executes a command from the console.

 Parameters:
| Name | Type | Description |
| :--- | :--- | :--- |
| `cmd` | `string` |  The command to execute. |

 Example:
```lua
consul.console.execute("2+2")

```

---

#### `consul.console.read`

A function that reads the input from the console.


 Example:
```lua
local input = consul.console.read()
consul.console.write(input)

```

---

#### `consul.console.write`

Write a message to the Consul console output panel and append it to consul.output.

 Parameters:
| Name | Type | Description |
| :--- | :--- | :--- |
| `msg` | `string` |  Message text to append. |

 Example:
```lua
consul.console.write("hello from script")

```

---

#### `consul.debug.disable_all_diplomacy`

Sets all diplomacy to false via (force_diplomacy) for all faction pairs.


 Example:
```lua
consul.debug.disable_all_diplomacy()

```

---

#### `consul.debug.logevents`

A function that logs all available engine events to the consul.log file.
 Very useful if you want to see what events you can listen to.


 Example:
```lua
-- check consul.log for the output
consul.debug.logevents()

```

---

#### `consul.debug.logregistry`

A function that logs every environment in all of the game's Lua registries.
 Uses consul.pretty to format the output into the consul.log file.
 Very useful if you want to see what the game makes available to Lua.


 Example:
```lua
-- check consul.log for the output
-- output may vary based on where the function is called
-- I used it extensively when debugging different issues with the scripts
consul.debug.logregistry()

```

---

#### `consul.debug.profi.start`

Starts the ProFi Lua profiler.

 Parameters:
| Name | Type | Description |
| :--- | :--- | :--- |
| `filename` | `string` |  The filename to save the report to (defaults to "profi_report.txt"). |

 Example:
```lua
consul.debug.profi.start("my_report.txt")

```

---

#### `consul.debug.profi.stop`

Stops the ProFi Lua profiler and writes the report.

 Parameters:
| Name | Type | Description |
| :--- | :--- | :--- |
| `filename` | `string` |  The filename to save the report to (overrides the one from start). |

 Example:
```lua
consul.debug.profi.stop()

```

---

#### `consul.debug.profile.start`

Starts the 2dengine Lua profiler.


 Example:
```lua
consul.debug.profile.start()

```

---

#### `consul.debug.profile.stop`

Stops the 2dengine Lua profiler, saves it to a file, and returns a report string.

 Parameters:
| Name | Type | Description |
| :--- | :--- | :--- |
| `filename` | `string` |  The filename to save the report to (defaults to "profile_report.txt"). |

 Example:
```lua
local report = consul.debug.profile.stop("my_profile.txt")
consul.console.write(report)

```

---

#### `consul.game.faction`

A function that returns a faction by key.

 Parameters:
| Name | Type | Description |
| :--- | :--- | :--- |
| `key` | `string` |  The key of the faction to return. |

 Example:
```lua
local faction = consul.game.faction("faction_key")
consul.console.write(faction:name())

```

---

#### `consul.game.model`

A function that returns the model of the game.


 Example:
```lua
local model = consul.game.model()

```

---

#### `consul.game.region`

A function that returns a region by key.

 Parameters:
| Name | Type | Description |
| :--- | :--- | :--- |
| `key` | `string` |  The key of the region to return. |

 Example:
```lua
local region = consul.game.region("region_key")
consul.console.write(region:name())

```

---

#### `consul.game.region_list`

A function that returns a list of all regions.


 Example:
```lua
local regions = consul.game.region_list()
consul.console.write(regions[1])

```

---

#### `consul.game.settlement`

A function that returns a settlement by key.

 Parameters:
| Name | Type | Description |
| :--- | :--- | :--- |
| `key` | `string` |  The key of the settlement to return. |

 Example:
```lua
local settlement = consul.game.settlement("settlement_key")
consul.console.write(settlement:name())

```

---

#### `consul.game.world`

A function that returns the world of the game.


 Example:
```lua
local world = consul.game.world()

```

---

#### `consul.new_logger`

Creates a new logger instance.<br>
 Very useful shortcut with predefined log levels.

 Parameters:
| Name | Type | Description |
| :--- | :--- | :--- |
| `file_path` | `string` |  The path to the log file. |
| `level` | `integer` |  The log level - 2 for info (default). |
| `name` | `string` |  The name of the logger. |

 Example:
```lua
-- DISABLED = -2,
-- TRACE = -1,
-- INTERNAL = 0,
-- DEBUG = 1,
-- INFO = 2,
-- WARN = 3,
-- ERROR = 4,
-- CRITICAL = 5,
-- create default logger with level (INFO)
local log = consul.new_logger("myfile.txt")
-- or pass a custom logging level   (DEBUG)
local log = consul.new_logger("myfile.txt", 1)
-- log info message
log:info("hello")!
-- log debug message
log:debug("debug!")
-- log error message
log:error("error!")

```

---

#### `consul.pretty`

A function that pretty-prints a Lua value using 'penlight'.

 Parameters:
| Name | Type | Description |
| :--- | :--- | :--- |
| `_obj` | `-` |  Any Lua value to pretty-print. |

 Example:
```lua
-- pretty-print a table
local table = { a = 1, b = 2, c = 3 }
local pretty_table = consul.pretty(table)
-- extra print to the console
consul.console.write(pretty_table)
-- or into the log file
consul.log:info(pretty_table)

```

---

#### `consul.pretty_inspect`

A function that pretty-prints a Lua value using 'inspect.lua'.

 Parameters:
| Name | Type | Description |
| :--- | :--- | :--- |
| `_obj` | `-` |  Any Lua value to pretty-print. |

 Example:
```lua
-- pretty-print a table
local table = { a = 1, b = 2, c = 3 }
local pretty_table = consul.pretty_inspect(table)

```

---

#### `consul.ui.MoveRootToCenter`

A function that moves the consul root to the center of the screen.


 Example:
```lua
consul.ui.MoveRootToCenter()

```

---

#### `consul.ui.MoveToConfigPosition`

A function that moves the consul root to the position saved in config.<br>
 If position is 0,0 it moves to center.


 Example:
```lua
consul.ui.MoveToConfigPosition()

```

---

#### `consul.ui.find`

A shortcut function that finds a UIComponent by key.<br>
 Contains some guards to make sure the function works as expected.

 Parameters:
| Name | Type | Description |
| :--- | :--- | :--- |
| `key` | `string` |  The key of the UIComponent to find. |

 Example:
```lua
local c = consul.ui.find("consul_exterminare_entry")
consul.console.write(c:Visible())

```

---

### Fields

#### `consul.is_in_battle_script`

Boolean flag indicating if the script is running in battle.



---

