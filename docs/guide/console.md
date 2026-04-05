The console accepts two kinds of input: `/slash-commands` and raw Lua code.

::: warning Input field truncates long text
Pasting more than a few lines will silently cut the input and produce an `unfinished string near '<eof>'` error. Use **Scriptum** for anything longer than a short expression.
:::

::: warning No output copy
You cannot select or copy text from the console output. All output is also written to `consul.output` in the game root folder — open that in a text editor.
:::

::: warning No Enter key
You cannot press Enter to send — you must click the **Send** button every time.
:::

---

## Sending input

Type in the input field, then click **Send**. There is no keyboard shortcut to send — see [Limitations](./limitations).

Commands starting with `/` are matched against the command registry. Everything else is treated as Lua and executed with `load()`.

---

## Lua mode

Anything that doesn't start with `/` runs as Lua in the game's scripting environment. The full game scripting API is available—you can use the console to register listeners, trigger events, or interact with any internal game model on the fly.


```lua
-- Write to the console output
consul.console.write("hello from Lua")

-- Access the game model
local world = consul._game():model():world()
consul.console.write("Factions: " .. world:faction_list():num_items())
```

::: tip Modder & Script Authors
The functions shown above are part of the core ConsulScriptum API. You can use these identical calls in your own external `.lua` scripts. For a full list of accessible functions, see the [Internal API Reference](../reference/internal-api).
:::

---

## Command history

Previous commands are saved to `consul.history` (one per line, max 100 entries). Use the on-screen **↑** and **↓** buttons to navigate. The keyboard arrow keys do not work.

---

## Auto-clear

`/autoclear` toggles automatic clearing of the output area after each command. Useful when running repeated commands and the output gets cluttered.

---

## Built-in commands

See the [Built-in Commands reference](../reference/commands) for the full list.
