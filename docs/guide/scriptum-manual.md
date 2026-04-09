---
title: "Total War Script Runner (Scriptum)"
description: "File-based scripting for Total War. Execute complex .lua files live in Rome II and Attila without restarting the game. Perfect for mod development."
---

# Scriptum

Scriptum is a panel of buttons, each mapped to a .lua file in the game root folder. Click a button to execute the corresponding file.

## Quick Start
1. **List your scripts**: Open consul.scriptum in your game folder.
2. **Add a path**: Add the path to your file into a new line (e.g. myscript.lua).
3. **Write Lua**: Create that .lua file in your game folder and write your code.
4. **Execute**: Open the **Scriptum** tab in-game and click the new button.

## Toggling Highlight (Green State)

<div class="cs-video-prominent">
  <video :src="$withBase('/videos/scriptum_toggle.mp4')" data-title="Green Toggle" data-game="Attila" autoplay loop muted playsinline></video>
</div>

You can make your scripts behave like the built-in **Consul** scripts by toggling their visual "active" state (the green highlight). 

When you click a Scriptum button, the system automatically sets consul.scriptum.entry to the ID of the **text component** of that button.

```lua
-- toggle_green.lua
local my_id = consul.scriptum.entry
local btn = consul.ui.find(my_id)

if btn:CurrentState() == 'online' then
    btn:SetState('offline')
    consul.console.write("Highlight OFF")
else
    btn:SetState('online')
    consul.console.write("Highlight ON")
end
```


## Suggested Workflow

The recommended way to work with Scriptum is to run the game in **Windowed Mode** with your text editor (like VS Code or Notepad++) open next to it. 

<div class="cs-video-prominent">
  <video :src="$withBase('/videos/attila_scriptum.mp4')" data-title="Using Scriptum" data-game="Attila" autoplay loop muted playsinline></video>
</div>

::: tip No Restart Required
The Scriptum files are read "live". You can edit your .lua file, save it (Ctrl+S), and then click the button in the Scriptum tab to execute the updated code immediately. This creates a powerful development loop.
:::

## Writing a script

Scripts are plain Lua. The consul global is always available.

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

## How it works

The Scriptum panel reads a file called consul.scriptum in the game root folder. That file lists the paths of scripts to show — one path per line:

```
scriptum.lua
scripts/myscript.lua
```

Each listed file appears as a button in the panel. Scriptum is a simple wrapper for file execution — when you click a button, the system literally runs:
```lua
pcall(dofile, "path/to/your/script.lua")
```
Because it uses `dofile`, the game engine re-reads the file from disk every time you click, which is why "live editing" works.

## Technical Details

### File Locations
Your scripts must be located within the game's root directory:
- Rome II: `...\Total War Rome II\`
- Attila: `...\Total War Attila\`

### Errors
If a script has a Lua error, the error message is printed to the console output. Check the console if nothing happens after clicking a button.
