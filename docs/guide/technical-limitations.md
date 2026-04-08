---
title: "Technical Limitations & Constraints"
description: "Understand the technical limitations and constraints of modding the Total War: Rome II and Attila engine. Coverage of UI restrictions, console input, and battle mode scripting."
---

# Limitations

<!-- @include: ./parts/disclaimer.md -->

::: tip Help Improve This Project
Most of the limitations described below are due to hardcoded constraints of the game engine's UI system. If you are a modder and know a technical workaround for any of these issues (especially regarding keyboard events, custom fonts, or input focus), please [get in touch on Discord](https://discord.gg/tgggqMs4) or [open an issue on GitHub](https://github.com/bukowa/ConsulScriptum/issues).
:::

## Console input

The console input component is a basic game engine TextInput element, which has several hardcoded restrictions that cannot be modified via scripts.

**No Enter key.** 
The game does not capture the "Enter" key as a submission trigger for this UI component. You must click the **Send** button to execute your input.

**No arrow key history navigation.** 
Keyboard events like the Up (↑) and Down (↓) arrow keys are not exposed to the modding API for this field. Use the on-screen **↑** and **↓** buttons next to the input to cycle through your command history.

**Locked cursor in history.**
When you restore a command from history using the arrow buttons, the cursor remains locked at the end of the line. You cannot click within the text or use the mouse to reposition the cursor for partial editing.

**No tab autocomplete.** 
Standard Lua or console-style autocompletion (pressing Tab) is not supported by the game's internal text fields.

**Input truncation (Character Limit).** 
The game's input buffer silently truncates long strings, usually around 100-255 characters. If you paste a long script, the console may only receive the first few lines, leading to syntax errors like `unfinished string near '<eof>'`.

::: tip Multi-line Scripts
The console is best for one-liners or running predefined commands.<br>For anything longer or more complex, use [Scriptum](./scriptum-manual) to run files directly from your disk.
:::

## Console output

**You cannot copy text directly from the UI.** 
The output area is a read-only text component. Selecting, highlighting, or copying text with the mouse within the game window is not possible.

**How to copy output:**
All console activity is automatically mirrored to a file called `consul.output` in your game root folder. Open this file in a text editor (like Notepad++) to copy, search, or share your results.

**The scroll slider does not auto-reset.** 
When new text is added, the scrollbar may not automatically jump to the bottom. You may need to scroll manually to see the latest results. Clicking **Clear** can help keep the view manageable.

## Scriptum panel

**Slot Limit (10 Scripts).** 
The panel is currently hard-capped at 10 script buttons. This is not a random number, but a technical compromise:
- **Rome II**: The UI engine cannot create components on the fly. All 10 buttons are pre-built into the interface files.
- **Attila**: While it technically supports dynamic lists, the 10-slot limit is maintained to keep the experience consistent across both games.

::: tip Pro Tip: Master Scripts
If you run out of slots, you can create a "Master Script" that uses dofile() to execute multiple other scripts in sequence, or use the console to run one-off files.

**Need more slots?** Please [reach out via GitHub](https://github.com/bukowa/ConsulScriptum).
:::


## Battle mode

<!-- @include: ./parts/battle-mode.md -->

---

