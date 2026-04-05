# Limitations

<!-- @include: ./parts/disclaimer.md -->

---

## Console input

**No Enter key.** You cannot press Enter to submit a command. You must click the Send button every time.

**No arrow key history navigation.** The ↑ and ↓ arrow keys on the keyboard do nothing. Use the on-screen ↑↓ buttons to cycle through history.

**No tab autocomplete.** Pressing Tab does nothing.

**Long commands break.** The game's input field silently truncates long strings. Pasting a long command will often produce an `unfinished string near '<eof>'` error or no output at all. No known fix for this in the console.

::: tip Use Scriptum for long scripts
Use **Scriptum** for anything longer than a few lines. See [Running longer scripts](./getting-started#running-longer-scripts).
:::


---

## Console output

**You cannot copy text from the output.** Selecting or copying text from the output area with the mouse is not possible. All output is automatically written to `consul.output` in the game root folder — open that file in a text editor to read it.

**The scroll slider does not reset.** The vertical scrollbar does not jump to the bottom when new output is added. You may need to scroll manually.

---

## Scriptum panel

**10 scripts currently.** The Scriptum panel has 10 slots. This number was chosen because Rome II cannot create UI components dynamically, so the slots are pre-built in the UI file. Attila technically supports dynamic creation but it hasn't been implemented yet. If you need more than 10, open an issue — it's not a hard ceiling.

---

## Battle mode

**Rome II** — the console does not show in battle by default because the battle interface is not loaded. There is a workaround: the mod registers a custom battlefield override using `game_interface:add_custom_battlefield`, which causes the Rome II battle UI to load and makes the console accessible. Enable it by running `/use_in_battle` in a campaign session, then start a battle. This is experimental.

**Attila** — battle mode is not supported yet. Whether Attila's battle interface can be made available without the Rome II override trick is still to be researched.

---

