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

#### `consul.console.clear`

Clear all text currently shown in the Consul console output panel.


 Example:
```lua
consul.console.clear()

```

---

#### `consul.console.write`

Write a message to the Consul console output panel and append it to consul.output.

 Parameters:
| Name | Type | Description |
| :--- | :--- | :--- |
| `msg` | `-` |  string Message text to append. |

 Example:
```lua
consul.console.write("hello from script")

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

