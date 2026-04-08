---
outline: deep
title: "Total War Lua Console Guide (Rome 2 & Attila)"
description: "Total War Lua console. Learn how to execute raw Lua scripts, trigger events, and interact with the game model in real-time within Rome II and Attila."
---

# Commands & Lua Console

The console is a simple TextInput UI element.

## How Input is Processed

Type in the input field and click **Send**.<br>
The console differentiates between two types of input:

### 1. Slash Commands

Any input starting with a / is matched against the [Command Registry](../reference/console-commands).<br>
For example, `/help` will list all built-in commands.


::: warning Input field truncates long text
Pasting more than a few lines will silently cut the input and produce an `unfinished string near '<eof>'` error. Use **Scriptum** for anything longer than a short expression.
:::

::: warning No Enter key
You cannot press Enter to send - you must click the **Send** button each time.
:::

::: warning No output copy
You cannot select or copy text from the console output. All output is also written to consul.output in the game root folder - open it in a text editor.
:::

### 2. Lua Mode

Anything that does **not** start with `/` is treated as raw Lua and executed directly in the game's scripting environment. The full game scripting API is available - you can use the console to register listeners, trigger events, or interact with the internal game model on the fly.

```lua
-- Write to the console output
consul.console.write("hello from Lua")

-- Access the game model
local world = consul._game():model():world()
consul.console.write("Factions: " .. world:faction_list():num_items())
```

::: tip Modder & Script Authors
The functions shown above are part of the core ConsulScriptum API. You can use these identical calls in your own external .lua scripts. For a full list of accessible functions, see the [Internal API Reference](../reference/internal-lua-api).
:::

::: tip Run scripts from Pack Files
You can use the console to execute **any** script - not just files in your game folder, but also those hidden inside the game's `.pack` files.

This is perfect for reloading internal game scripts or running one-off files:

```lua
dofile("lua_scripts/all_scripted.lua")
```

If the script fails, the console will print the error message directly to the output.
:::

## How it works

The console is not "magic". When you send raw Lua, the system performs a standard Lua execution flow:

1. Your input is parsed into a function via `loadstring(cmd)`.
2. That function is then executed within a `pcall(f)` to catch errors.

```lua
-- Behind the scenes:
local f, err = loadstring(your_input)
if not err then
    pcall(f)
end
```

This means you are interacting directly with the game's Lua environment just as you would with any other script.

## Command history

Previous commands are saved to consul.history (one per line, max 100 entries). Use the on-screen **up** and **down** buttons to navigate. The keyboard arrow keys do not work.

## Auto-clear

/autoclear toggles automatic clearing of the output area after each command. Useful when running repeated commands and the output gets cluttered.

## Available Commands

To view the list of available commands, see [Consul Commands](../reference/console-commands).


## Custom Commands

To learn how to add custom commands, see [How To Add Custom Commands](../reference/adding-custom-commands).
