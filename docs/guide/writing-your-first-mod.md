---
title: "Writing Your First Mod"
description: "A practical, step-by-step tutorial on how to use ConsulScriptum to write a functional mod for Total War."
outline: deep
---

# Writing Your First Mod

In this tutorial, we will take the concepts learned in the [Scripting Manual](./scripting-manual) and apply them to create a functional mod. Our goal is to build a script that has visible, immediate effects on the game model.

## The Goal

For this tutorial, we will build a script that dynamically assigns **effect bundles** (buffs, debuffs) to different entities in the game, specifically targeting:
- A **Faction**
- A **Military Force**

We'll use varied **Events** to trigger these assignments, showcasing how event-driven logic can directly impact the game world.

## Prerequisites

To follow this tutorial, you will need **RPFM (Rusted Pack File Manager)**, the standard tool for managing Total War pack files.  **RPFM** is an open source project created by Frodo.
1.  Download the latest version from the [RPFM Releases page](https://github.com/Frodo45127/rpfm/releases).
2. Open RPFM by clicking on `rpfm_ui.exe`

## Step 1: Preparing Database with RPFM
Before adding any files, you must tell RPFM which game you are modding. This ensures the tool uses the correct database schemas and file structures.
Simply follow the video tutorial below to quickly setup RPFM with dependencies cache. Remember to select the proper game!

Editing database tables is not in the scope of this tutorial. To keep things simple, we will reuse **existing effect bundles** that are already in the base game. This is where the dependency cache becomes essential.
We can now freely view all the effect bundles that the base game offers to us.

1.  In the **Dependencies** pane (bottom-left), find the search box.
2.  Type `effect_bundles_tables`.
3.  Open the `effect_bundles` table to browse the list of vanilla effects.


<div class="cs-video-prominent">
  <video :src="$withBase('/videos/writing_your_first_mod_rpfm_1.mp4')" data-title="RPFM Setup" autoplay loop muted playsinline></video>
</div>


For this tutorial, we will use the following vanilla keys:

:::tabs key:game

== Attila
- **Character's Force Effect Bundle**: `rom_payload_infantry_command`
<br>(boost morale to all infrantry units in all your forces)
- **Faction Effect Bundle**: `rom_payload_call_to_arms_global`
<br>(increases army recruitment capacity for your faction)

== Rome II
- **Character's Force Effect Bundle**: `rom_payload_infantry_command`
<br>(boost morale to all infrantry units in all your forces)
- **Faction Effect Bundle**: `rom_payload_call_to_arms_global`
<br>(increases army recruitment capacity for your faction)

:::

## Step 5: Researching the API

Before writing any logic, you need to know which functions are available and how they behave. In Total War modding, documentation is notoriously fragmented, often incomplete, or flat-out incorrect. 

### The Documentation Challenge

When modding titles like Rome II or Attila, you will quickly realize that "official" resources are sparse and often unreliable:
- **Rome II**: Has virtually no official scripting documentation.
- **Attila**: The [Official Wiki](https://wiki.totalwar.com/w/Total_War:_ATTILA_Kit_Scripting.html) is often incomplete and sometimes contains invalid information.
- **Troy**: The [Troy Documentation](https://chadvandy.github.io/tw_modding_resources/Troy/) is much more comprehensive. Since Rome II, Attila, Thrones of Britannia, and Troy share a similar engine, Troy's API is often a good reference—but keep in mind that many functions may not exist or may behave differently in older games.

### Reliable Resources

To navigate this ambiguity, use these verified sources:
1. **ConsulScriptum Reference**: Check the [Rome II API Reference](../reference/rome2-api) and [Attila API Reference](../reference/attila-api) included in this documentation. These are based on confirmed game functions.
2. **Cross-Game Comparison**: If you find a function in Troy's docs, cross-reference it with the Consul references to see if it likely exists in your target game.

### Finding the Source of Truth

When documentation fails, your best options are **Global Search** and **Live Testing**.

#### 1. RPFM Global Search
The best way to verify a function's parameters is to see how the game's original developers used it:
1. In RPFM, open the **Global Search** (Ctrl+Shift+F).
2. Search for the function name (e.g., `apply_effect_bundle_to_characters_force`).
3. Set the scope to **Dependencies** (base game files).
4. Analyze the results to see the arguments passed in vanilla scripts.

> [!NOTE]
> **A Word of Caution**: Just because a function appears in the base game code doesn't guarantee it works. It could be "dead code" or a leftover from a previous engine. If a search yields no results in the vanilla scripts, the function might be unused or unsupported.

#### 2. Live Testing with Consul
The most reliable way to confirm a function works is to test it in-game using the Consul console. Testing small snippets of logic before committing to a full mod script will save you hours of troubleshooting.

> [!CAUTION]
> **Example: The Parameter Trap**
>
> The function `apply_effect_bundle_to_characters_force` perfectly illustrates why research is vital:
> - **Official Attila Docs**: State it takes **3** parameters.
> - **Rome II**: It works correctly with **3** parameters.
> - **Attila**: Calling it with **3** parameters will cause an immediate **CTD (Crash to Desktop)**. 
>
> By searching the vanilla Attila scripts in RPFM, you would discover that developers actually pass a **4th** undocumented boolean flag at the end. Without this discovery, you might spend hours wondering why your "correct" code is crashing the game.

For this tutorial, we will use the following functions:

:::tabs key:game

== Attila
- **Character's Force Effect Bundle**: `apply_effect_bundle_to_characters_force`
> effect_bundle_key,character_cqi,number_of_turns,boolean
- **Faction Effect Bundle**: `apply_effect_bundle`
> faction_name,number_of_turns
== Rome II
- **Character's Force Effect Bundle**: `apply_effect_bundle_to_characters_force`
- > effect_bundle_key,character_cqi,number_of_turns
- **Faction Effect Bundle**: `apply_effect_bundle`
- > faction_name,number_of_turns
:::

#### Using /debug flag 
Based on our research we determined what parameters the functions take.
Now we will utilize Consul and the /debug flag to quickly test it.

1. Lets turn on the `/debug` command in Consul
2. Lets click on the character on the campaign map.
3. Lets turn off the `/debug` flag in Consul.

<div class="cs-video-prominent">
  <video :src="$withBase('/videos/writing_your_first_mod_1_debug.mp4')" data-title="Debug" autoplay loop muted playsinline></video>
</div>

#### Using Scriptum 
After performing these steps consul with populate the `consul.debug.character` and `consul.debug.faction` variables.
This is a great shortcut to quickly test our functions. Because testing our script can take more space than a single line of code
lets now utilize the Scriptum module to write it.

:::tabs key:game

== Attila
```lua
consul.console.clear()

local cqi = consul.debug.character:cqi()
local faction = consul.debug.faction:name()
local force_effect_bundle = "rom_payload_infantry_command"
local faction_effect_bundle = "rom_payload_call_to_arms_global"

consul._game():apply_effect_bundle_to_characters_force(force_effect_bundle, cqi, 1, false)
consul._game():apply_effect_bundle(faction_effect_bundle, faction, 1)
```
== Rome II
```lua
consul.console.clear()

local cqi = consul.debug.character:cqi()
local faction = consul.debug.faction:name()
local force_effect_bundle = "rom_payload_infantry_command"
local faction_effect_bundle = "rom_payload_call_to_arms_global"

consul._game():apply_effect_bundle_to_characters_force(force_effect_bundle, cqi, 1)
consul._game():apply_effect_bundle(faction_effect_bundle, faction, 1)
```
:::

<div class="cs-video-prominent">
  <video :src="$withBase('/videos/writing_your_first_mod_2_debug.mp4')" data-title="Debug" autoplay loop muted playsinline></video>
</div>


## NExt Steps...
Below is how your `.pack` file structure should look in RPFM once you've added your custom script:


## Step 3: Saving the PackFile

> [!TIP]
> **Interactive Explorer**: The windows below are interactive! You can click on folders to expand them, or use the **📂 button** in the header to hide the explorer and view the scripts in full width.

Before adding any scripts, it is best practice to save your work in the correct location so the game can find it.

1.  Click on **PackFile -> Save PackFile As...** in the top menu.
2.  Navigate to your game's **data** directory (e.g., `Total War Rome II/data`)
3.  Name your file `mymod.pack` and click **Save**.

Your explorer will now reflect the new file name:

<PackExplorer packName="new_pack.pack" :files="[]" />


<script setup>
const modFiles = [
  {
    path: 'script/campaign/mod/my_first_mod.lua',
    content: `-- Load the game interface
scripting = require "lua_scripts.episodicscripting"
local game = scripting.game_interface

-- 1. Assign to Faction on Turn Start
table.insert(events.FactionTurnStart, function(context)
    local faction = context:faction()
    
    -- We target the Huns (Attila) or Rome (Rome II)
    if faction:name() == "att_fact_hunni" or faction:name() == "rom_rome" then
        -- We use a vanilla bundle key found in the dependencies cache
        game:apply_effect_bundle("att_bundle_faction_venerated_ancestors", faction:name(), 0)
        consul.console.write("The ancestors favor " .. faction:name() .. "!")
    end
end)`
  },
  {
    path: 'script/campaign/mod/helpers.lua',
    content: `-- Optional helper functions
local helpers = {}

function helpers.log_action(msg)
    consul.console.write("[Mod Log] " .. msg)
end

return helpers`
  }
]
</script>

<PackExplorer packName="mymod.pack" :files="modFiles" />

*(Tutorial content continued: Detailed explanation of the logic above and how to test it in-game.)*
