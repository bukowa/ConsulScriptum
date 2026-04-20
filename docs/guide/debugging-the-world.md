---
next:
  text: Debugging The UI
  link: /guide/debugging-the-ui
---

# Debugging The World

Consul Scriptum provides a way to inspect game objects directly in the world. By toggling debug mode, you will see the available Lua data for settlements, characters, and units as you interact with them.

:::tabs key:game

== Attila
<video :src="$withBase('/videos/attila_debugging.mp4')" data-title="Killing Multiple Characters" data-game="Attila" autoplay loop muted playsinline></video>

== Rome II
<video :src="$withBase('/videos/rome2_debugging.mp4')" data-title="Transferring Settlement & Killing Character" data-game="Rome II" autoplay loop muted playsinline></video>

:::

## The /debug Command

To start debugging, simply type the following command in the console:

```
/debug
```

This is a toggle command. Type it again to disable debug mode.

## How It Works

Once debug mode is active, the console will automatically update and clear itself to show information based on your actions in the game world.
This means clicking on different settlements, characters, or units will print out their relevant data to the console in real time.
This works in a very simple manner, Consul register event handlers for various UI interactions (CharacterSelected, SettlementSelected, ComponentMouseOver, ComponentLClickUp).
In some cases the game provides the handle to the object directly in the event context, but some stuff like the diplomacy view or strategic map really on extracting the string representing the clicked object and then querying the game world to retrieve the relevant script interface. More can be found in Consul source code.

### Inspecting Factions
Open the **Diplomacy View** and click any faction icon.
<br>Clicking on settlements or characters should also print out the owning faction's data as well.
#### Example Output
```lua
["name"] = "rom_athens",
["culture"] = "rom_Hellenistic",
["character_list"] = "CHARACTER_LIST_SCRIPT_INTERFACE (392661C8)",
["difficulty_level"] = 0,
["faction_attitudes"] = {
    ["rom_epirus"] = -61,
    ["rom_macedon"] = -8,
    ["rom_pergamon"] = 10,
    ["rom_pontus"] = 15,
    ["rom_ptolemaics"] = 53,
    ["rom_rome"] = 15,
    ["rom_sparta"] = 81,
    ["rom_tylis"] = -38,
},
["faction_leader"] = "CHARACTER_SCRIPT_INTERFACE (27A3F9B0)",
-- ... more faction properties ...
```

### Inspecting Settlements
Simply click on any **Settlement** on the campaign map or in the **Strategic Map**.
<br>The console will clear and print the script interface data for it.

#### Example Output
```lua
["army"] = "NULL_SCRIPT_INTERFACE (38ED0EE0)",
["buildings"] = "BUILDING_LIST_SCRIPT_INTERFACE (39265F68)",
["has_army"] = false,
["has_navy"] = false,
["navy"] = "NULL_SCRIPT_INTERFACE (38ED0EE4)",
["region"] = "REGION_SCRIPT_INTERFACE (2A2850E0)",
["settlement_interface"] = {
        ["castle_slot"] = "NULL_SCRIPT_INTERFACE (38ED0EE8)",
        ["commander"] = "NULL_SCRIPT_INTERFACE (38ED0EEC)",
        ["display_position_x"] = 200.54188537598,
        ["display_position_y"] = 313.3857421875,
        ["region"] = {
            ["adjacent_region_list"] = "REGION_LIST_SCRIPT_INTERFACE (39265F78)",
            ["garrison_residence"] = "GARRISON_RESIDENCE_SCRIPT_INTERFACE (2A284FFC)",
            ["name"] = "rom_italia_etruria",
            -- ... more region properties ...
```

### Inspecting Characters
Click on any **Character** (General/Agent) on the map to see their data. 

#### Example Output
```lua
["action_points_per_turn"] = 2404,
["action_points_remaining_percent"] = 0,
["age"] = 25,
["battles_fought"] = 0,
["battles_won"] = 0,
["cqi"] = 5,
["display_position_x"] = 205.22117614746,
["display_position_y"] = 299.10586547852,
["faction"] = {
    ["name"] = "rom_rome",
    ["character_list"] = "CHARACTER_LIST_SCRIPT_INTERFACE (39266058)",
    ["culture"] = "rom_Roman",
    ["faction_attitudes"] = {
        ["rom_ardiaei"] = -15,
        ["rom_athens"] = 0,
        ["rom_carthage"] = -47,
        },
    ["faction_leader"] = "CHARACTER_SCRIPT_INTERFACE (39FC42EC)",
    -- ... more faction properties ...
```

### Inspecting Units
If you have a character selected, you can **hover your mouse** over any unit card in their army. The console will display details about that unit, such as its unit key, category, and class.

This also works for:
- **Recruitable units** in the recruitment panel.
- **Mercenary units** in the mercenary pool.
- **Units** in the Custom Battles main menu (this requires /debug_mouseover)

Example Output
```lua
["faction"] = "CONSUL_WONT_PRINT",
["force_commander"] = "CHARACTER_SCRIPT_INTERFACE (2C088848)",
["has_force_commander"] = true,
["has_unit_commander"] = false,
["is_land_unit"] = true,
["is_naval_unit"] = false,
["military_force"] = "CONSUL_WONT_PRINT",
["percentage_proportion_of_full_strength"] = 100,
["unit_category"] = "inf_melee",
["unit_class"] = "inf_mel",
["unit_commander"] = "NULL_SCRIPT_INTERFACE (2695E81C)",
["unit_key"] = "Rom_Hastati",
```

### Grabbing a Script Interface Handle

Once you use the `/debug` command to inspect an object, look for its unique identifier — usually its `name` or `cqi` (Command Queue Index).
With this identifier in hand, you can use game model functions inside your scripts to fetch the object handle and begin interacting with it.

You can also rely on built-in Consul handles that cache the last clicked object when `/debug` is active:
- `consul.debug.character`
- `consul.debug.settlement`
- `consul.debug.faction`
- `consul.debug.unit`

These are perfect for rapid console experimentation:
```lua
-- execute in the console after clicking on a character with /debug active
/p consul.debug.character:age()
```
> [!NOTE]
> `consul.debug.unit` will be available only for the unit that you mouseover in a character's army

## Logging Object Data

If you need to print similarly detailed structures from inside your event listeners, Consul provides built-in functions via the `consul.pprinter` (pretty printer) module.
You can combine it with `consul.pretty` and `consul.log` to write out the data of an object during an event:

```lua
table.insert(events.CharacterCompletedBattle, function(context)
    local char = context:character()
    -- Pretty-print the character interface data just like /debug does!
    local debug_data = consul.pprinter.character_script_interface(char)
    consul.log:info("Character finished a battle:\n" .. consul.pretty(debug_data))
end)
```

## Console Output Mirroring

The information printed to the console during debug mode (and all other console output) is also mirrored to a local file:

**`consul.output`** (located in your game root folder)

This is particularly useful if you want to copy large amounts of data or keep a history of your inspections for later reference.

## Technical Overview
Under the hood, Consul Scriptum listens for UI click events. When an element is clicked, the script parses the UI element to extract the string identifier representing the object (such as a faction, settlement, or character). It then queries the global `GAME` object to retrieve the corresponding script interface. Once the object is found, the system dynamically iterates through and calls its available methods using `consul.pprinter` to gather data, which is then pretty-printed directly to the console.
