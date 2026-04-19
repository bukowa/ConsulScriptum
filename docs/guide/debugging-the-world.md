---
next:
  text: Debugging The UI
  link: /guide/debugging-the-ui
---

# Debugging The World

Consul Scriptum provides a way to inspect game objects directly in the world without writing a single line of code. By toggling debug mode, you will see the available Lua data for settlements, characters, and units as you interact with them.

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

### Inspecting Settlements and Characters
Simply click on any **Settlement** or **Character** (General/Agent) on the campaign map. The console will print the script interface data for that object, including its name, region, faction, and other internal properties.

### Inspecting Factions and Settlements
Open the **Diplomacy View** or **Strategic Map** and click any faction or settlement on the map.

### Inspecting Units
If you have a character selected, you can **hover your mouse** over any unit card in their army. The console will display details about that unit, such as its unit key, category, and class.

This also works for:
- **Recruitable units** in the recruitment panel.
- **Mercenary units** in the mercenary pool.
- **Units** in the Custom Battles main menu.

### Console Output Mirroring

The information printed to the console during debug mode (and all other console output) is also mirrored to a local file:

**`consul.output`** (located in your game root folder)

This is particularly useful if you want to copy large amounts of data or keep a history of your inspections for later reference.


## Technical Overview
Under the hood, Consul Scriptum listens for UI click events. When an element is clicked, the script parses the UI element to extract the string identifier representing the object (such as a faction, settlement, or character). It then queries the global `GAME` object to retrieve the corresponding script interface. Once the object is found, the system dynamically iterates through and calls its available methods to gather data, which is then formatted and printed directly to the console.
