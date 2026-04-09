---
next:
  text: Scripting Manual
  link: /guide/scripting-manual
---
# Getting started

## Step 1: Installation

<!-- @include: ./parts/installation-links.md -->

<div class="cs-step-footer">
  <a href="./game-compatibility" class="cs-step-ref">
    <div class="cs-ref-icon">⚙️</div>
    <div class="cs-ref-content">
      <div class="cs-ref-label">Supported Games</div>
      <div class="cs-ref-desc">Game differences and stability notes</div>
    </div>
  </a>
  <a href="./technical-limitations" class="cs-step-ref">
    <div class="cs-ref-icon">⚠️</div>
    <div class="cs-ref-content">
      <div class="cs-ref-label">Limitations</div>
      <div class="cs-ref-desc">Technical constraints and issues</div>
    </div>
  </a>
</div>

## Step 2: Accessing the Interface

The interface consists of three main panels: **Console**, **Consul**, and **Scriptum**. You can switch between them using the tabs at the top of the ConsulScriptum window.

:::tabs key:game

== Attila
<video :src="$withBase('/videos/attila_accessconsole.mp4')" data-title="Accessing the Interface" data-game="Attila" autoplay loop muted playsinline></video>

In Attila, the ConsulScriptum window is visible on screen by default when you load into a campaign. There is no hide/show toggle yet. You can drag it to reposition it.

== Rome II
<video :src="$withBase('/videos/rome2_accessconsole.mp4')" data-title="Accessing the Interface" data-game="Rome II" autoplay loop muted playsinline></video>

Click the **ConsulScriptum toggle button** in the campaign UI top bar. The window will appear. You can drag it anywhere — its position is saved automatically between sessions.

:::

## Step 3: Using Consul (One-Click Actions)

Most actions follow a simple **Point and Click** logic: activate a script, then select one or two targets (like a character or settlement) on the map to trigger the effect.

:::tabs key:game

== Attila
<video :src="$withBase('/videos/attila_index.mp4')" data-title="Killing Multiple Characters" data-game="Attila" autoplay loop muted playsinline></video>

== Rome II
<video :src="$withBase('/videos/rome2_index.mp4')" data-title="Transferring Settlement & Killing Character" data-game="Rome II" autoplay loop muted playsinline></video>

:::

### Usage Notes
- **Highlighting**: When a script is active, the entry will highlight in green.
- **Toggle**: Click the highlighted entry again to deactivate it.

<div class="cs-ui-magnifier">
  <div class="cs-magnifier-label">Tooltip Preview</div>
  <div class="cs-magnifier-images">
    <img src="/media/consul_tooltip1.png" alt="" />
    <img src="/media/consul_tooltip2.png" alt="" />
  </div>
  <div class="cs-magnifier-hint">
    Hover your mouse over any script in the list to reveal its full usage instructions.
  </div>
</div>


<div class="cs-step-footer">
  <a href="./consul-manual" class="cs-step-ref">
    <div class="cs-ref-icon">📜</div>
    <div class="cs-ref-content">
      <div class="cs-ref-label">Consul Manual</div>
      <div class="cs-ref-desc">Read more about one-click scripts</div>
    </div>
  </a>
  <a href="./advanced-consul-scripting" class="cs-step-ref">
    <div class="cs-ref-icon">🛠️</div>
    <div class="cs-ref-content">
      <div class="cs-ref-label">Custom Consul scripts</div>
      <div class="cs-ref-desc">How to create your custom scripts.</div>
    </div>
  </a>
</div>

## Step 4: The Console (Commands & Lua)

Use the **Console** tab for manual interaction. It allows you to run slash commands or raw Lua snippets. You can also clear the output at any time to remove text from other scripts. Type /help to list all available slash-commands.

:::tabs key:game

== Attila
<video :src="$withBase('/videos/attila_console.mp4')" data-title="Scripting Console" data-game="Attila" autoplay loop muted playsinline></video>

== Rome II
<video :src="$withBase('/videos/rome2_console.mp4')" data-title="Scripting Console" data-game="Rome II" autoplay loop muted playsinline></video>

:::

<div class="cs-step-footer">
  <a href="./console-manual" class="cs-step-ref">
    <div class="cs-ref-icon">💻</div>
    <div class="cs-ref-content">
      <div class="cs-ref-label">Console Manual</div>
      <div class="cs-ref-desc">How to work with the console</div>
    </div>
  </a>
  <a href="../reference/adding-custom-commands" class="cs-step-ref">
    <div class="cs-ref-icon">🛠️</div>
    <div class="cs-ref-content">
      <div class="cs-ref-label">Custom commands</div>
      <div class="cs-ref-desc">How to add your own /commands</div>
    </div>
  </a>
</div>

## Step 5: Scriptum (File-Based Scripts)

Because the console input field is limited to short text, use the **Scriptum** tab for long or complex scripts. This module reads `.lua` files directly from your game folder.

:::tabs key:game
== Attila
<video :src="$withBase('/videos/attila_scriptum.mp4')" data-title="Using Scriptum" data-game="Attila" autoplay loop muted playsinline></video>

== Rome II
<video :src="$withBase('/videos/attila_scriptum.mp4')" data-title="Using Scriptum" data-game="Rome II" autoplay loop muted playsinline></video>
:::

<div class="cs-step-footer">
  <a href="./scriptum-manual" class="cs-step-ref">
    <div class="cs-ref-icon">✍️</div>
    <div class="cs-ref-content">
      <div class="cs-ref-label">Scriptum Manual</div>
      <div class="cs-ref-desc">How to work with file-based scripting.</div>
    </div>
  </a>
  <a href="./consul-scriptum-files" class="cs-step-ref">
    <div class="cs-ref-icon">📂</div>
    <div class="cs-ref-content">
      <div class="cs-ref-label">Consul Files</div>
      <div class="cs-ref-desc">Learn about the outputs and logs that make scripting easier</div>
    </div>
  </a>
</div>

## Step 6: Writing your own scripts

If you're ready to create your own mods or automate complex tasks, move on to the Scripting Manual. It explains how the game engine works and provides code patterns you can use immediately.

<div class="cs-step-footer">
  <a href="./scripting-manual" class="cs-step-ref">
    <div class="cs-ref-icon">📖</div>
    <div class="cs-ref-content">
      <div class="cs-ref-label">Scripting Manual</div>
      <div class="cs-ref-desc">Learn the fundamentals of Total War scripting</div>
    </div>
  </a>
</div>
