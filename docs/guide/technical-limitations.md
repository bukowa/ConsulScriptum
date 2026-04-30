---
title: "Technical Limitations & Constraints"
description: "Understand the technical limitations and constraints of modding the Total War: Rome II, Attila, and Thrones of Britannia engine. Coverage of UI restrictions, console input, and battle mode scripting."
---

# Limitations

<!-- @include: ./parts/disclaimer.md -->

::: tip Help Improve This Project
Most of the limitations described below are due to hardcoded constraints of the game engine's UI system. If you are a modder and know a technical workaround for any of these issues (especially regarding keyboard events, custom fonts, or input focus), please [get in touch on Discord](https://discord.gg/6vm2M94vhX) or [open an issue on GitHub](https://github.com/bukowa/ConsulScriptum/issues).
:::

## Console input

The console input component is a basic game engine TextInput element, which has several hardcoded restrictions that cannot be modified via scripts.

##### **No Enter key.** 
The game does not capture the "Enter" key as a submission trigger for this UI component. You must click the **Send** button to execute your input.

##### **No arrow key history navigation.** 
Keyboard events like the Up (↑) and Down (↓) arrow keys are not exposed to the modding API for this field. Use the on-screen **↑** and **↓** buttons next to the input to cycle through your command history.

##### **Locked cursor in history.**
When you restore a command from history using the arrow buttons, the cursor remains locked at the end of the line. You cannot click within the text or use the mouse to reposition the cursor for partial editing.

##### **No tab autocomplete.** 
Standard Lua or console-style autocompletion (pressing Tab) is not supported by the game's internal text fields.

##### **Input truncation (Character Limit).** 
The game's input buffer silently truncates long strings, usually around 100-255 characters. If you paste a long script, the console may only receive the first few lines, leading to syntax errors like `unfinished string near '<eof>'`.

::: tip Multi-line Scripts
The console is best for one-liners or running predefined commands.<br>For anything longer or more complex, use [Scriptum](./scriptum-manual) to run files directly from your disk.
:::

## Console output

##### **You cannot copy text directly from the UI.** 
The output area is a read-only text component. Selecting, highlighting, or copying text with the mouse within the game window is not possible.

##### **How to copy output:**
All console activity is automatically mirrored to a file called `consul.output` in your game root folder. Open this file in a text editor (like Notepad++) to copy, search, or share your results.

##### **The scroll slider does not auto-reset.** 
When new text is added, the scrollbar may not automatically jump to the bottom. You may need to scroll manually to see the latest results. Clicking **Clear** can help keep the view manageable.

## Scriptum panel

**Slot Limit (10 Scripts).** 
The panel is currently hard-capped at 10 script buttons. This is not a random number, but a technical compromise:
- **Rome II**: The UI engine cannot create components on the fly. All 10 buttons are pre-built into the interface files.
- **Attila / ToB**: While they technically support dynamic lists, the 10-slot limit is maintained to keep the experience consistent across all supported games.

::: tip Pro Tip: Master Scripts
If you run out of slots, you can create a "Master Script" that uses Lua `dofile()` to execute multiple other scripts in sequence, or use the console to run one-off files.

**Need more slots?** Please [reach out via GitHub](https://github.com/bukowa/ConsulScriptum).
:::


## Battle mode

<!-- @include: ./parts/battle-mode.md -->

## Total War: Attila & ToB

The Attila implementation is currently considered **Alpha**. 

##### **Legacy UI Files.**
To maintain a unified experience and ensure stability, the Attila version reuses several core UI components and layout logic from the Rome II version. Because of this "frankenstein" approach, minor visual glitches or alignment issues in the console may occur.

##### **Experimental Status (Attila).**
While the core features (Consul Scripts, Scriptum, and Lua Console) are functional, the engine differences mean that Attila is currently considered more experimental than Rome II or ToB. 

##### **Stability Note (ToB).**
Thrones of Britannia is built on the most refined version of this engine branch. While it shares some of the "Frankenstein" UI traits of the Attila version, it is generally more stable and supports several features (like Battle Mode) natively.

::: warning Bug Reports
If you encounter a UI crash or a script that behaves differently in Attila or ToB than in Rome II, please [open an issue](https://github.com/bukowa/ConsulScriptum/issues).
:::

## Resolution Changes

**Changing screen resolution during an active session.**
The Total War UI engine does not always update component positions correctly when the screen resolution or UI scale is changed while the game is running.
- **Symptom**: The Consul window may appear misplaced, stretched, or partially off-screen.
- **Fix**: Auto-correction logic will attempt to bring the Consul back to the center on the next toggle, but for full UI alignment restoration, you may need to reload the UI (e.g., by entering and exiting a battle, or restarting the game).

::: tip Restore Defaults
If the Consul UI remains broken or invisible after a resolution change, you can manually delete the `consul.config` file in your game root folder. This will reset all settings and UI positions to their defaults on the next launch.
:::

---


