# Scriptum

Scriptum is a panel of buttons, each mapped to a `.lua` file in the game root folder. Click a button to execute the corresponding file.

This is the recommended way to run anything longer than a line or two, since the console input field cannot handle long strings.

### How to use:
1. **Define your scripts**: Open `consul.scriptum` in your game root folder and add the paths to your `.lua` files (one per line).
2. **Write your code**: Create the corresponding `.lua` files and write your script.
3. **Run on click**: Inside the game, open the **Scriptum** tab. Your scripts will appear as buttons. Click one to execute it.

### Suggested Workflow:
The recommended way to work with Scriptum is to run the game in **Windowed Mode** with your text editor (like VS Code or Notepad++) open next to it. 

The files are read "live" — you can edit your `.lua` file, save it, and then click the button in the Scriptum tab to execute the updated code immediately without restarting the game.


---

## Quick Start
1. **List your scripts**: Open `consul.scriptum` in your game folder.
2. **Add a path**: Type the path to a `.lua` file (e.g., `myscript.lua` or `scripts/myscript.lua`) and save.
3. **Write Lua**: Create that `.lua` file and write your code.
4. **Execute**: Open the **Scriptum** tab in-game and click the new button.

---


## Suggested Workflow

The recommended way to work with Scriptum is to run the game in **Windowed Mode** with your text editor (like VS Code or Notepad++) open next to it. 

<video src="/ConsulScriptum/videos/attila_scriptum.mp4" data-title="Using Scriptum" data-game="Attila" autoplay loop muted playsinline></video>

::: tip No Restart Required
The Scriptum files are read "live". You can edit your `.lua` file, save it (Ctrl+S), and then click the button in the Scriptum tab to execute the updated code immediately. This creates a powerful development loop: write code, click to test, and iterate without even needing to Alt-Tab.
:::
---

## How it works

The Scriptum panel reads a file called `consul.scriptum` in the game root folder. That file lists the paths of scripts to show — one path per line:

```
scriptum.lua
scripts/myscript.lua
```

Each listed file appears as a button in the panel. Scriptum is a simple wrapper for file execution — when you click a button, the system literally runs:
```lua
pcall(dofile, "path/to/your/script.lua")
```
Because it uses `dofile`, the game engine re-reads the file from disk every time you click, which is why "live editing" works. There's no magical reloading mechanism; it's just standard Lua doing what it does best.

`consul.scriptum` is created automatically on first run, pre-populated with `scriptum.lua` (the example script). To add your own scripts, open `consul.scriptum` in a text editor and add their paths. Changes to `consul.scriptum` take effect the next time you click anywhere on the ConsulScriptum window or reopen it.

---

## Where to put files

Your scripts must be located within the game's root directory (or a subdirectory) — the simplest place is the game root folder alongside `consul.scriptum`.

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

---

## Errors

If a script has a Lua error, the error message is printed to the console output and execution stops at that point. Check the console after clicking a button if nothing happened.
