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
2.  Launch RPFM and click on **PackFile -> New PackFile**.
3.  You will be left with an empty file named `unknown.pack`:

> [!TIP]
> **Interactive Explorer**: The windows below are interactive! You can click on folders to expand them, or use the **📂 button** in the header to hide the explorer and view the scripts in full width.

<PackExplorer packName="unknown.pack" :files="[]" />

## Step 1: Select Your Game

Before adding any files, you must tell RPFM which game you are modding. This ensures the tool uses the correct database schemas and file structures.

1.  Click on **Game Selected**.
2.  Select your target game from the list.

:::tabs key:game

== Attila
Select **Attila** from the menu. RPFM will now be configured for Attila's engine and file paths.

== Rome II
Select **Rome 2** from the menu. RPFM will now be configured for Rome II's engine and file paths.

:::

## Step 2: Generate Dependencies Cache

To help you find keys and values (like faction names or effect keys), you should generate the dependencies cache. This pulls data from the game's base files and displays it in the **Dependencies** pane.

1.  Click on **Special Stuff**.
2.  Navigate to your selected game (e.g., **Attila** or **Rome 2**).
3.  Click on **Generate Dependencies Cache**.

Once finished, you will see the **Game Files** appear in the bottom-left pane of RPFM.

<div style="text-align: center;">
  <img src="/media/writing_your_first_mod_rpfm1.png" style="max-width: 400px; border-radius: 8px;" />
</div>

## Step 3: Saving the PackFile

Before adding any scripts, it is best practice to save your work in the correct location so the game can find it.

1.  Click on **PackFile -> Save PackFile As...** in the top menu.
2.  Navigate to your game's **data** directory (e.g., `Total War Rome II/data`)
3.  Name your file `mymod.pack` and click **Save**.

Your explorer will now reflect the new file name:

<PackExplorer packName="mymod.pack" :files="[]" />

## Step 4: Designing the Script

Editing database tables is not in the scope of this tutorial. To keep things simple, we will reuse **existing effect bundles** that are already in the base game. This is where the dependency cache we generated in Step 2 becomes essential.
We can now freely view all the effect bundles that the base game offers to us.

1.  In the **Dependencies** pane (bottom-left), find the search box.
2.  Type `effect_bundles_tables`.
3.  Open the `effect_bundles` table to browse the list of vanilla effects.

<div style="text-align: center;">
  <img src="/media/writing_your_first_mod_rpfmdeps.png" style="max-width: 400px; border-radius: 8px;" />
</div>

For this tutorial, we will use the following vanilla keys:

:::tabs key:game

== Attila
- **Faction Effect Bundle**: `rom_payload_infantry_command`
<br>(boost morale to all infrantry units in all your forces)

== Rome II
- **Faction Effect Bundle**: `rom_payload_infantry_command`
<br>(boost morale to all infrantry units in all your forces)

:::

Below is how your `.pack` file structure should look in RPFM once you've added your custom script:

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
