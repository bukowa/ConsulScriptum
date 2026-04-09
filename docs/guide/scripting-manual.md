---
title: "Scripting Manual"
description: "A beginner-friendly guide to scripting with ConsulScriptum. Learn about the game engine hierarchy, iteration patterns, and how to manipulate Rome II and Attila."
---

# Scripting Manual

This manual is for anyone who wants to move beyond the built-in commands and start writing their own Lua scripts for Total War. You don't need to be a programmer to start; you just need to understand the engine's scripting architecture.

## 1. The Foundation
To do anything in Total War, you first need to require the official interface.
:::tabs key:game

== Attila
```lua
-- load the official Lua library from the base game
scripting = require "lua_scripts.episodicscripting"

-- grab a reference to the GAME interface
local game = scripting.game_interface
```
== Rome II
```lua
-- load the official Lua library from the base game
scripting = require "lua_scripts.EpisodicScripting"

-- grab a reference to the GAME interface
local game = scripting.game_interface
```
:::

> [!TIP]
> **Consul Shortcut**: Use `consul._game()` for fast prototyping in the console.


### The GAME Interface

The `game` variable is an instance of the <GameLink hash="game">**GAME**</GameLink> object. It is the **Root Control Panel** of the entire engine. This object is a **binding** created by the game developers to expose C++ engine functions directly to Lua, allowing you to manipulate the game world in real-time.



While the next section shows you how to "find" things, the `game` variable itself contains direct functions that affect the whole world at once.
Below are few examples of such functions:
| Action | Function Name | What it does |
| :--- | :--- | :--- |
| **Money** | `game:treasury_add()` | Grants gold to a faction. |
| **Life/Death** | `game:kill_character()` | Instantly kills a character. |
| **Events** | `game:trigger_incident()` | Starts a specific historical incident. |
| **Buffs** | `game:apply_effect_bundle()` | Applies a persistent effect from the DB. |
> [!NOTE]
> To see the full list of over 100 global commands available on the game object, consult the <GameLink hash="game">**Game API Reference**</GameLink>. For in-depth tutorials on how these mechanics work together, refer to the official guides in [Section 8: Further Reading](#_8-further-reading-official-wikis).


## 2. Navigating the Game Object Hierarchy

The engine exposes data through a nested **object hierarchy**. To find a specific faction or region, you must traverse the <GameLink hash="game">**GAME**</GameLink> from the root manager down to the specific object you want.

### The Chain of Command

> [!NOTE]
> **Click any node** in the graph below to jump directly to its API definition.

<div class="cs-game-graph-sync">

<div class="cs-game-attila-only">

```mermaid
graph TD
    G[GAME] --> |".model()"| M[MODEL_SCRIPT_INTERFACE]
    M --> |".world()"| W[WORLD_SCRIPT_INTERFACE]
    W --> |".faction_by_key()"| F[FACTION_SCRIPT_INTERFACE]
    W --> |".region_manager()"| RM[REGION_MANAGER_SCRIPT_INTERFACE]
    RM --> |".region_by_key()"| R[REGION_SCRIPT_INTERFACE]
    F --> |".military_force_list()"| ML[MILITARY_FORCE_LIST_SCRIPT_INTERFACE]
    ML --> |".num_items()"| I[INTEGER]
    R --> |".garrison_residence()"| GR[GARRISON_RESIDENCE_SCRIPT_INTERFACE]
    GR --> |".is_under_siege()"| B[BOOLEAN]

    click G "../reference/attila-api#game" "Open GAME API"
    click M "../reference/attila-api#model-script-interface" "Open MODEL API"
    click W "../reference/attila-api#world-script-interface" "Open WORLD API"
    click F "../reference/attila-api#faction-script-interface" "Open FACTION API"
    click RM "../reference/attila-api#region-manager-script-interface" "Open REGION_MANAGER API"
    click R "../reference/attila-api#region-script-interface" "Open REGION API"
    click ML "../reference/attila-api#military-force-list-script-interface" "Open MILITARY_FORCE_LIST API"
    click GR "../reference/attila-api#garrison-residence-script-interface" "Open GARRISON_RESIDENCE API"
```

</div>

<div class="cs-game-rome2-only">

```mermaid
graph TD
    G[GAME] --> |".model()"| M[MODEL_SCRIPT_INTERFACE]
    M --> |".world()"| W[WORLD_SCRIPT_INTERFACE]
    W --> |".faction_by_key()"| F[FACTION_SCRIPT_INTERFACE]
    W --> |".region_manager()"| RM[REGION_MANAGER_SCRIPT_INTERFACE]
    RM --> |".region_by_key()"| R[REGION_SCRIPT_INTERFACE]
    F --> |".military_force_list()"| ML[MILITARY_FORCE_LIST_SCRIPT_INTERFACE]
    ML --> |".num_items()"| I[INTEGER]
    R --> |".garrison_residence()"| GR[GARRISON_RESIDENCE_SCRIPT_INTERFACE]
    GR --> |".is_under_siege()"| B[BOOLEAN]

    click G "../reference/rome2-api#game" "Open GAME API"
    click M "../reference/rome2-api#model-script-interface" "Open MODEL API"
    click W "../reference/rome2-api#world-script-interface" "Open WORLD API"
    click F "../reference/rome2-api#faction-script-interface" "Open FACTION API"
    click RM "../reference/rome2-api#region-manager-script-interface" "Open REGION_MANAGER API"
    click R "../reference/rome2-api#region-script-interface" "Open REGION API"
    click ML "../reference/rome2-api#military-force-list-script-interface" "Open MILITARY_FORCE_LIST API"
    click GR "../reference/rome2-api#garrison-residence-script-interface" "Open GARRISON_RESIDENCE API"
```

</div>

</div>

**Following the model in code:**

:::tabs key:game

== Attila

```lua
-- Load the GAME interface
-- Load the GAME interface
scripting = require "lua_scripts.episodicscripting"
local game = scripting.game_interface

-- Example 1: Finding how many armies a faction has
local faction = game:model():world():faction_by_key("att_fact_hunni")
local armies = faction:military_force_list()
local count = armies:num_items() -- Returns an INTEGER

-- Example 2: Checking if a region is under siege
local region = game:model():world():region_manager():region_by_key("att_reg_arabia_felix_zafar")
local residence = region:garrison_residence()
local is_sieged = residence:is_under_siege() -- Returns a BOOLEAN (true/false)

-- Optional Log data to the console
consul.console.write("number of armies: " .. count)
consul.console.write("is siegied: " .. tostring(is_sieged))
```

== Rome II

```lua
-- Load the GAME interface
scripting = require "lua_scripts.EpisodicScripting"
local game = scripting.game_interface

-- Example 1: Finding how many armies a faction has
local faction = game:model():world():faction_by_key("rom_rome")
local armies = faction:military_force_list()
local count = armies:num_items() -- Returns an INTEGER

-- Example 2: Checking if a region is under siege
local region = game:model():world():region_manager():region_by_key("rom_italia_latium")
local residence = region:garrison_residence()
local is_sieged = residence:is_under_siege() -- Returns a BOOLEAN (true/false)

-- Optional Log data to the console
consul.console.write("number of armies: " .. count)
consul.console.write("is siegied: " .. tostring(is_sieged))

```

:::

## 3. Iterating the World: Finding Objects

Once you have access to the `game` variable, you can find objects by using a specific key (like a name) or by iterating through a list (a collection of objects).

### 3.1 Finding Factions
You can find a single faction by its name, or look at every faction in the game.

:::tabs key:game

== Attila

```lua
scripting = require "lua_scripts.episodicscripting"

local game = scripting.game_interface
local world = game:model():world()

-- Option A: Find one specific faction
local rome = world:faction_by_key("att_fact_hunni")

-- Option B: Iterate (loop) through ALL factions
local factions = world:faction_list()
for i = 0, factions:num_items() - 1 do
    local fac = factions:item_at(i)
    consul.console.write("Found faction: " .. fac:name())
end
```

== Rome II

```lua
scripting = require "lua_scripts.EpisodicScripting"

local game = scripting.game_interface
local world = game:model():world()

-- Option A: Find one specific faction
local rome = world:faction_by_key("rom_rome")

-- Option B: Iterate (loop) through ALL factions
local factions = world:faction_list()
for i = 0, factions:num_items() - 1 do
    local fac = factions:item_at(i)
    consul.console.write("Found faction: " .. fac:name())
end
```

:::

> [!NOTE]
> Check the <GameLink hash="faction-script-interface">**FACTION_SCRIPT_INTERFACE**</GameLink> reference to see what you can do with a faction.


### 3.2 Finding Regions
Regions are handled by a region manager inside the world.

:::tabs key:game

== Attila

```lua
scripting = require "lua_scripts.episodicscripting"

local game = scripting.game_interface
local world = game:model():world()

-- Option A: Find one specific region
local lathium = world:region_manager():region_by_key("att_reg_arabia_felix_zafar")

-- Option B: Iterate through ALL regions in the world
local regions = world:region_manager():region_list()
for i = 0, regions:num_items() - 1 do
    local region = regions:item_at(i)
    consul.console.write("Region: " .. region:name() .. " is owned by " .. region:owning_faction():name())
end
```

== Rome II

```lua
scripting = require "lua_scripts.EpisodicScripting"

local game = scripting.game_interface
local world = game:model():world()

-- Option A: Find one specific region
local lathium = world:region_manager():region_by_key("rom_italia_latium")

-- Option B: Iterate through ALL regions in the world
local regions = world:region_manager():region_list()
for i = 0, regions:num_items() - 1 do
    local region = regions:item_at(i)
    consul.console.write("Region: " .. region:name() .. " is owned by " .. region:owning_faction():name())
end
```

:::

> [!NOTE]
> Check the <GameLink hash="region-script-interface">**REGION_SCRIPT_INTERFACE**</GameLink> reference to see what you can do with a region.



### 3.3 Finding Armies (Military Forces)
To find armies, you must first "drill down" into a specific Faction. Every Faction has its own list of military forces.

:::tabs key:game

== Attila

```lua
local game = scripting.game_interface
local world = game:model():world()
local rome = world:faction_by_key("att_fact_hunni")

-- Get the cabinet of armies for Rome
local armies = rome:military_force_list()

for i = 0, armies:num_items() - 1 do
    local force = armies:item_at(i)
    -- Is it an army or a navy?
    if force:is_army() then
        consul.console.write("Rome has an army at " .. force:general_character():logical_position_x())
    end
end
```

== Rome II

```lua
local game = scripting.game_interface
local world = game:model():world()
local rome = world:faction_by_key("rom_rome")

-- Get the cabinet of armies for Rome
local armies = rome:military_force_list()

for i = 0, armies:num_items() - 1 do
    local force = armies:item_at(i)
    -- Is it an army or a navy?
    if force:is_army() then
        consul.console.write("Rome has an army at " .. force:general_character():logical_position_x())
    end
end
```

:::

> [!NOTE]
> Check the <GameLink hash="military-force-script-interface">**MILITARY_FORCE_SCRIPT_INTERFACE**</GameLink> reference.


---



## 4. Events: Event-Driven Triggers

An **Event** is a trigger that executes code when a specific game state changes. Think of it as a listener: "When this event occurs, run this function."

```lua
-- When a settlement is selected (clicked), do something!
table.insert(events.SettlementSelected, 
    function(context)
        local region_name = context:garrison_residence():region():name()
        consul.console.write("You clicked on " .. region_name)
    end
)
```

---

## 5. Advanced: How "require" works

You will often see `require 'something'` at the top of scripts. This is how you borrow code from other files.

### The "Already Done" List
Lua is smart. It keeps a "Done List" (called `package.loaded`). If it's already there, it just hands you the existing version immediately. It **never** reads the file a second time.

---

## 6. Advanced: Registries (Isolated Environments)

The Total War environment is partitioned into isolated execution environments called **Registries**.
- **The UI Registry**: Contains tools for interface manipulation (`UIComponent`).
- **The Campaign Registry**: Contains tools for world state manipulation.

If a tool is missing in your current environment, Consul can "bridge" registries to find it. This is known as **Registry Diving**.

---

## 7. Putting it All Together: A Global Cheat Script

Here is a complete script you can run in **Scriptum**. It finds all human players and gives them 5000 gold.

```lua
-- 1. Load the toolkit
scripting = require "lua_scripts.EpisodicScripting"
local game = scripting.game_interface
-- 2. Follow the Game Model to the Faction List
local factions = game:model():world():faction_list()

-- 3. Loop through every faction
for i = 0, factions:num_items() - 1 do
    local fac = factions:item_at(i)
    
    -- 4. If it's a human, give them gold
    if fac:is_human() then
        consul.console.write("Cheating gold for: " .. fac:name())
        game:treasury_add(fac:name(), 5000)
    end
end
```

---

## 8. Further Reading: Official Wikis

For a deeper look at the mechanics of Total War scripting, refer to the official Creative Assembly documentation. These guides cover the "Official" toolkit in extreme detail:

- [Total War: Attila KIT - Campaign Script Interface](https://wiki.totalwar.com/w/Total_War:_ATTILA_KIT_-_Campaign_Script_Interface)
- [Total War: Attila KIT - Extra Scripting Guides](https://wiki.totalwar.com/w/Total_War:_ATTILA_KIT_-_Extra_Scripting_Guides)

> [!TIP]
> While Rome II lacks official documentation from the game developers, Attila is 99% similar.