# Scriptum

Scriptum is a panel of buttons, each mapped to a `.lua` file in the game root folder. Click a button to execute the corresponding file.

This is the recommended way to run anything longer than a line or two, since the console input field cannot handle long strings.

---

## How it works

The Scriptum panel reads a file called `consul.scriptum` in the game root folder. That file lists the paths of scripts to show — one path per line:

```
scriptum.lua
C:/my_scripts/debug.lua
```

Each listed file appears as a button in the panel. Clicking it executes that file immediately. The file is re-read from disk each time you click, so you can edit it and run the updated version without restarting.

`consul.scriptum` is created automatically on first run, pre-populated with `scriptum.lua` (the example script). To add your own scripts, open `consul.scriptum` in a text editor and add their paths. Changes to `consul.scriptum` take effect the next time you open the ConsulScriptum window.

---

## Quick Start
1. **List your scripts**: Open `consul.scriptum` in your game folder.
2. **Add a path**: Type the path to a `.lua` file (e.g., `myscript.lua`) and save.
3. **Write Lua**: Create that `.lua` file and write your code.
4. **Execute**: Open the **Scriptum** tab in-game and click the new button.

---

## Suggested Workflow

The recommended way to use Scriptum is to run the game in **Windowed Mode** with your text editor (like VS Code, Notepad++, or Sublime Text) open next to it. 

::: tip No Restart Required
The Scriptum files are read "live". You can edit your `.lua` file, save it (Ctrl+S), and then click the button in the Scriptum tab to execute the updated code immediately. This creates a powerful development loop: write code, click to test, and iterate without even needing to Alt-Tab.
:::

The maximum is currently 10 entries. Rome II cannot create UI components dynamically, so the slots are pre-built in the UI file. If you need more, open an issue — it's not a hard ceiling.

---

## Where to put files

Your scripts can be anywhere that the game process can read — the simplest place is the game root folder alongside `consul.scriptum`. You can also use absolute paths in `consul.scriptum` to reference scripts elsewhere on disk.

Game root locations:
- Rome II: `...\Total War Rome II\`
- Attila: `...\Total War Attila\`

---

## Writing a script

Scripts are plain Lua. The `consul` global is available.

```lua
-- scriptum_1.lua
-- Print the human faction's treasury
local world = consul._game():model():world()
local fl = world:faction_list()
for i = 0, fl:num_items() - 1 do
    local fac = fl:item_at(i)
    if fac:is_human() then
        consul.console.write(fac:name() .. " treasury: " .. fac:treasury())
        return
    end
end
```

```lua
-- scriptum_2.lua
-- Write game state to a file (since you can't copy from the console)
local f = io.open("debug_output.txt", "w")
local world = consul._game():model():world()
local fl = world:faction_list()
for i = 0, fl:num_items() - 1 do
    local fac = fl:item_at(i)
    f:write(fac:name() .. "\n")
end
f:close()
consul.console.write("Written to debug_output.txt")
```

---

## Errors

If a script has a Lua error, the error message is printed to the console output and execution stops at that point. Check the console after clicking a button if nothing happened.
