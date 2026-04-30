---
title: "Tips & Tricks"
description: "Advanced techniques, snippets, and creative ways to use Consul Scriptum."
---

# Tips & Tricks

A collection of useful snippets and advanced techniques for modding Total War with Consul Scriptum.

## Catch-All Event Logger

Not all events are documented in the DB or Lua scripts, but the core game engine will still fire them! You can use a `metatable` on the `events` table to catch every single event the engine triggers, even the hidden ones.

```lua
-- catch_all_events.lua
-- Intercept and log all engine events to the console and consul.log file
setmetatable(events, {
    __index = function(t, key)
        -- 1. Create the table containing your single function
        local new_event_table = {
            function(context)
                local debug_info = consul.pretty({
                    event = tostring(key),
                    context = debug.getmetatable(context).__index
                })
                -- write to file
                consul.log:info(debug_info)
                -- or into console
                consul.console.write(debug_info)
            end
        }

        -- 2. SAVE IT into the actual 'events' table.
        -- We use rawset to bypass the metatable.
        rawset(t, key, new_event_table)

        -- 3. Return it to the C++ engine
        return new_event_table
    end
})
```

You can save this snippet as a script and run it using Scriptum, or run it through the Consul interface. Once executed, every event that fires will be captured and output to the game's log and Consul console, along with its full context interface.
