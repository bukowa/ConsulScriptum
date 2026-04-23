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

Once debug mode is active, the console will automatically update to show information based on your actions in the game world.
This means clicking on different settlements, characters, or units will print their relevant data to the console in real time.

Consul registers event handlers for various UI interactions (`CharacterSelected`, `SettlementSelected`, `ComponentMouseOver`, `ComponentLClickUp`).
In some cases, the game provides the handle to the object directly in the event context. However, for features like the diplomacy view or strategic map, Consul relies on extracting the string representing the clicked object and then querying the game world to retrieve the relevant script interface. More details can be found in the Consul source code.

> [!NOTE]
> Not everything in the game world is covered, but it's a comprehensive starting point.

### Inspecting Factions
Open the **Diplomacy View** and click any faction icon.
Clicking on settlements or characters will also print out the owning faction's data.
#### Example Output
```lua
{
   ...   
   at_war = true,
   character_list = "CHARACTER_LIST_SCRIPT_INTERFACE (3A2FD1A0)",
   culture = "rom_Hellenistic",
   difficulty_level = 0,
   ended_war_this_turn = false,
   faction_leader = "CHARACTER_SCRIPT_INTERFACE (26B5467C)",
   government_type = "gov_absolute_monarchy",
   ...
   num_generals = 8,
   num_trade_agreements = 1,
   politics = "CAMPAIGN_POLITICS_SCRIPT_INTERFACE (26B546AC)",
   politics_party_add_loyalty_modifier = false,
   region_list = "REGION_LIST_SCRIPT_INTERFACE (3A2FD1C0)",
   ...
   upkeep_expenditure_percent = 100,
   faction_attitudes = {
      rom_arevaci = -41,
      rom_edetani = -79,
      rom_epirus = 3,
      rom_etruscan = 67,
      ...
   },
   treaty_details = {
      rom_arevaci = {
         culture = "rom_Barbarian",
         subculture = "sc_rom_celtiberian"
      },
      rom_edetani = {
         culture = "rom_Barbarian",
         subculture = "sc_rom_celtiberian"
      },
	  ...
```

### Inspecting Settlements
Simply click on any **Settlement** on the campaign map or in the **Strategic Map**.
The console will clear and print the script interface data for it.

#### Example Output
```lua
{
   army = "NULL_SCRIPT_INTERFACE (2ECE9DA0)",
   buildings = "BUILDING_LIST_SCRIPT_INTERFACE (3A2FD240)",
   faction = "FACTION_SCRIPT_INTERFACE (26B554C8)",
   has_army = false,
   has_navy = false,
   is_settlement = true,
   is_slot = false,
   is_under_siege = false,
   model = "MODEL_SCRIPT_INTERFACE (26B547C0)",
   navy = "NULL_SCRIPT_INTERFACE (2ECE9DA4)",
   region = "REGION_SCRIPT_INTERFACE (26B54B5C)",
   slot_interface = "NULL_SCRIPT_INTERFACE (2ECE9DBC)",
   unit_count = 0,
   settlement_interface = {
      castle_slot = "NULL_SCRIPT_INTERFACE (2ECE9DA8)",
      commander = "NULL_SCRIPT_INTERFACE (2ECE9DAC)",
      display_position_x = 209.23202514648438,
      display_position_y = 292.93075561523438,
      has_castle_slot = false,
      has_commander = false,
      logical_position_x = 313,
      logical_position_y = 379,
      slot_list = {
         buliding_type_exists = false,
         is_empty = false,
         num_items = 5,
         slot_type_exists = false,
         _consul_slots = {
            ["0"] = {
               faction = "FACTION_SCRIPT_INTERFACE (26B54AD8)",
               has_building = true,
               name = "primary",
               region = "REGION_SCRIPT_INTERFACE (26B54FE8)",
               type = "primary",
               building = {
                  chain = "rome_city",
                  faction = "FACTION_SCRIPT_INTERFACE (26B54E38)",
                  name = "rome_city_1",
                  region = "REGION_SCRIPT_INTERFACE (26B54ACC)",
                  slot = "SLOT_SCRIPT_INTERFACE (26B54D48)",
                  superchain = "SettlementMajor"
               }
            },
            ["1"] = {
               faction = "FACTION_SCRIPT_INTERFACE (26B54E14)",
               has_building = true,
               name = "secondary",
               region = "REGION_SCRIPT_INTERFACE (26B54D24)",
               type = "secondary",
               building = {
                  chain = "rome_military",
                  faction = "FACTION_SCRIPT_INTERFACE (26B55078)",
                  name = "rome_military_1",
                  region = "REGION_SCRIPT_INTERFACE (26B54C94)",
                  slot = "SLOT_SCRIPT_INTERFACE (26B55084)",
                  superchain = "MilitaryMain"
               }
            },
			...
         }
      },
      region = {
         adjacent_region_list = "REGION_LIST_SCRIPT_INTERFACE (3A2FD280)",
		 ...
      faction = {
         at_war = true,
		 ...
```

### Inspecting Characters
Click on any **Character** (General/Agent) on the map to see their data. 

#### Example Output
```lua
{
   action_points_per_turn = 4950,
   action_points_remaining_percent = 0,
   age = 21,
   battles_fought = 0,
   battles_won = 0,
   body_guard_casulties = "will crash game in campaign",
   character_type = false,
   cqi = 4,
   ...
   military_force = {
      character_list = "CHARACTER_LIST_SCRIPT_INTERFACE (3A2FCFA0)",
      contains_mercenaries = false,
      faction = "FACTION_SCRIPT_INTERFACE (2944A0E8)",
      garrison_residence = "NULL_SCRIPT_INTERFACE (2ECE9D7C)",
      general_character = "CHARACTER_SCRIPT_INTERFACE (2944A0F4)",
      has_garrison_residence = false,
      has_general = true,
      is_army = false,
      is_navy = true,
      upkeep = 253,
      unit_list = {
         {
            faction = "FACTION_SCRIPT_INTERFACE (29449FBC)",
            force_commander = "CHARACTER_SCRIPT_INTERFACE (29449FD4)",
            has_force_commander = true,
            has_unit_commander = true,
            is_land_unit = false,
            is_naval_unit = true,
            military_force = "MILITARY_FORCE_SCRIPT_INTERFACE (29449FEC)",
            percentage_proportion_of_full_strength = 100,
            unit_category = "medium_ship",
            unit_class = "shp_mel",
            unit_commander = "CHARACTER_SCRIPT_INTERFACE (29449FF8)",
            unit_key = "Rom_Principes_Four"
         },
		 ...
   },
   faction = {
      ...
```

### Inspecting Units
If you have a character selected, you can **hover your mouse** over any unit card in their army. The console will display details about that unit, such as its unit key, category, and class.

This also works for:
- **Recruitable units** in the recruitment panel.
- **Mercenary units** in the mercenary pool.
- **Units** in the Custom Battles main menu (this requires `/debug_mouseover`).

Example Output
```lua
{
   faction = "FACTION_SCRIPT_INTERFACE (292A7E48)",
   force_commander = "CHARACTER_SCRIPT_INTERFACE (29255A80)",
   has_force_commander = true,
   has_unit_commander = false,
   is_land_unit = false,
   is_naval_unit = true,
   military_force = "MILITARY_FORCE_SCRIPT_INTERFACE (292A7818)",
   percentage_proportion_of_full_strength = 100,
   unit_category = "light_ship",
   unit_class = "shp_mis",
   unit_commander = "NULL_SCRIPT_INTERFACE (2ECE9E1C)",
   unit_key = "Rom_Leves_One_Halfer"
}
```

### Can't find what you need? 
You can use `/debug_mouseover` to find UI data about additional components.
Under the hood, Consul often uses the UI state to extract region or unit names from the component ID.


### Grabbing a Script Interface Handle

Once you use the `/debug` command to inspect an object, look for its unique identifier — usually its `name` or `cqi` (Command Queue Index).
With this identifier in hand, you can use game model functions inside your scripts to fetch the object handle and begin interacting with it.

You can also rely on built-in Consul handles that cache the last clicked object when `/debug` is active:
- `consul.debug.garrison_residence`
- `consul.debug.settlement`
- `consul.debug.character`
- `consul.debug.faction`
- `consul.debug.unit`
- `consul.debug.unit_list`
- `consul.debug.military_force`

These are perfect for rapid console experimentation:
```lua
-- execute in the console after clicking on a character with /debug active
/p consul.debug.character:age()
```
> [!NOTE]
> `consul.debug.unit` will be available only for the unit that you mouseover in a character's army.

If you need to print similarly detailed structures from inside your event listeners, Consul provides built-in functions via `consul.pretty` to pretty-print the data of an object at any time:

```lua
-- Pretty-print the character interface data just like /debug does!
table.insert(events.CharacterCompletedBattle, function(context)
    local char = context:character()
    consul.log:info(consul.pretty(char))
end)
```

## Console Output Mirroring

The information printed to the console during debug mode (and all other console output) is also mirrored to a local file:

**`consul.output`** (located in your game root folder)

This is particularly useful if you want to copy large amounts of data or keep a history of your inspections for later reference.

## Technical Overview
Under the hood, Consul Scriptum listens for UI click events. When an element is clicked, the script parses the UI element to extract the string identifier representing the object (such as a faction, settlement, or character). It then queries the global `GAME` object to retrieve the corresponding script interface. Once the object is found, the system dynamically iterates through and calls its available methods using `consul.pprinter` to gather data, which is then pretty-printed directly to the console.
