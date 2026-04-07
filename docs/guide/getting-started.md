# Getting Started

## Step 1: Installation

<!-- @include: ./parts/installation-links.md -->

See [Detailed Compatibility](./compatibility) for engine differences and stability notes.

---

## Step 2: Accessing the Interface

The interface consists of three main panels: **Console**, **Consul**, and **Scriptum**. You can switch between them using the tabs at the top of the ConsulScriptum window.

:::tabs

== Attila
<video src="/ConsulScriptum/videos/attila_accessconsole.mp4" data-title="Accessing the Interface" data-game="Attila" autoplay loop muted playsinline></video>

In Attila, the ConsulScriptum window is visible on screen by default when you load into a campaign. There is no hide/show toggle yet. You can drag it to reposition it.

== Rome II
<video src="/ConsulScriptum/videos/rome2_accessconsole.mp4" data-title="Accessing the Interface" data-game="Rome II" autoplay loop muted playsinline></video>

Click the **ConsulScriptum toggle button** in the campaign UI top bar. The window will appear. You can drag it anywhere — its position is saved automatically between sessions.

:::

## Step 3: Using Consul (One-Click Actions)

Most actions follow a simple **Point and Click** logic: activate a script, then select one or two targets (like a character or settlement) on the map to trigger the effect.

:::tabs

== Attila
<video src="/ConsulScriptum/videos/attila_index.mp4" data-title="Killing Multiple Characters" data-game="Attila" autoplay loop muted playsinline></video>

**Exterminare** script to kill a character on the campaign map.

== Rome II
<video src="/ConsulScriptum/videos/rome2_index.mp4" data-title="Transferring Settlement & Killing Character" data-game="Rome II" autoplay loop muted playsinline></video>

**Adice Provinciam** script to transfer a settlement between factions.

:::

::: tip Hover for details
**Hover your mouse over any script name** in the list to see detailed usage instructions.

<div align="center">
  <img src="/media/consul_custodes.png" alt="Hover for details" />
</div>
:::

See more details and reference about [Consul Scripts](./consul-scripts).

## Step 4: The Console (Commands & Lua)

::: warning Console Quick Tips
- **No Enter Key**: You must click the **Send** button to submit commands.
- **No UI Copy**: You cannot copy text directly from the console output. Use the `consul.output` file in your game folder instead.
- **No Autocomplete**: Tab completion and keyboard history (↑/↓) are not supported. Use the on-screen arrow buttons for history.
:::

Use the **Console** tab for manual interaction. It allows you to run slash commands or raw Lua snippets. You can also clear the output at any time to remove text from other scripts.

1. **Commands**: Type `/help` to list all available slash-commands.
2. **Raw Lua**: Interact directly with the game or manage the console view.

```lua
consul.console.write("Hello World") -- Prints text to the console
consul.console.clear()             -- Clears the console output
```

:::tabs

== Attila
<video src="/ConsulScriptum/videos/attila_console.mp4" data-title="Scripting Console" data-game="Attila" autoplay loop muted playsinline></video>

== Rome II
<video src="/ConsulScriptum/videos/rome2_console.mp4" data-title="Scripting Console" data-game="Rome II" autoplay loop muted playsinline></video>

:::

## Step 5: Scriptum (File-Based Scripts)

Because the console input field is limited to short text, use the **Scriptum** tab for long or complex scripts. This module reads `.lua` files directly from your game folder.

### How to use:
1. **Define your scripts**: Open `consul.scriptum` in your game root folder and add the paths to your `.lua` files (one per line).
2. **Write your code**: Create the corresponding `.lua` files and write your script.
3. **Run on click**: Inside the game, open the **Scriptum** tab. Your scripts will appear as buttons. Click one to execute it.

### Suggested Workflow:
The recommended way to work with Scriptum is to run the game in **Windowed Mode** with your text editor (like VS Code or Notepad++) open next to it. 

The files are read "live" — you can edit your `.lua` file, save it, and then click the button in the Scriptum tab to execute the updated code immediately without restarting the game.

:::tabs
== Attila & Rome II
<video src="/ConsulScriptum/videos/attila_scriptum.mp4" data-title="Using Scriptum" data-game="Both" autoplay loop muted playsinline></video>
:::

See the [Scriptum guide](./scriptum) for more details.

---

## Next steps

- [Limitations](./limitations) — read this before reporting bugs
- [The Console](./console) — full command and Lua reference
- [Battle Mode](./battle) — how to use the console in Rome II battles
- [Scriptum](./scriptum) — advanced file-based scripting
- [Custom Commands](../reference/custom-commands) — adding your own `/commands`
