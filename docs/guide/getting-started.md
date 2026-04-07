# Getting Started

## Step 1: Installation

<!-- @include: ./parts/installation-links.md -->

<div class="cs-step-footer">
  <a href="./compatibility" class="cs-step-ref">
    <div class="cs-ref-icon">⚙️</div>
    <div class="cs-ref-content">
      <div class="cs-ref-label">Compatibility Guide</div>
      <div class="cs-ref-desc">Engine differences and stability notes</div>
    </div>
  </a>
  <a href="./limitations" class="cs-step-ref">
    <div class="cs-ref-icon">⚠️</div>
    <div class="cs-ref-content">
      <div class="cs-ref-label">Limitations</div>
      <div class="cs-ref-desc">Technical constraints and known issues</div>
    </div>
  </a>
</div>

---

## Step 2: Accessing the Interface

The interface consists of three main panels: **Console**, **Consul**, and **Scriptum**. You can switch between them using the tabs at the top of the ConsulScriptum window.

:::tabs

== Attila
<video src="/videos/attila_accessconsole.mp4" data-title="Accessing the Interface" data-game="Attila" autoplay loop muted playsinline></video>

In Attila, the ConsulScriptum window is visible on screen by default when you load into a campaign. There is no hide/show toggle yet. You can drag it to reposition it.

== Rome II
<video src="/videos/rome2_accessconsole.mp4" data-title="Accessing the Interface" data-game="Rome II" autoplay loop muted playsinline></video>

Click the **ConsulScriptum toggle button** in the campaign UI top bar. The window will appear. You can drag it anywhere — its position is saved automatically between sessions.

:::

## Step 3: Using Consul (One-Click Actions)

Most actions follow a simple **Point and Click** logic: activate a script, then select one or two targets (like a character or settlement) on the map to trigger the effect.

:::tabs

== Attila
<video src="/videos/attila_index.mp4" data-title="Killing Multiple Characters" data-game="Attila" autoplay loop muted playsinline></video>

== Rome II
<video src="/videos/rome2_index.mp4" data-title="Transferring Settlement & Killing Character" data-game="Rome II" autoplay loop muted playsinline></video>

:::

### Usage Notes
- **Highlighting**: When a script is active the entry will highlight in green.
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
      <div class="cs-ref-label">Consul Reference</div>
      <div class="cs-ref-desc">Complete library of one-click scripts</div>
    </div>
  </a>
</div>

## Step 4: The Console (Commands & Lua)

Use the **Console** tab for manual interaction. It allows you to run slash commands or raw Lua snippets. You can also clear the output at any time to remove text from other scripts. Type /help to list all available slash-commands.

:::tabs

== Attila
<video src="/videos/attila_console.mp4" data-title="Scripting Console" data-game="Attila" autoplay loop muted playsinline></video>

== Rome II
<video src="/videos/rome2_console.mp4" data-title="Scripting Console" data-game="Rome II" autoplay loop muted playsinline></video>

:::

<div class="cs-step-footer">
  <a href="./console" class="cs-step-ref">
    <div class="cs-ref-icon">💻</div>
    <div class="cs-ref-content">
      <div class="cs-ref-label">Console Guide</div>
      <div class="cs-ref-desc">Slash commands and Lua API reference</div>
    </div>
  </a>
  <a href="../reference/custom-commands" class="cs-step-ref">
    <div class="cs-ref-icon">🛠️</div>
    <div class="cs-ref-content">
      <div class="cs-ref-label">Custom Commands</div>
      <div class="cs-ref-desc">How to add your own console /commands</div>
    </div>
  </a>
</div>

## Step 5: Scriptum (File-Based Scripts)

Because the console input field is limited to short text, use the **Scriptum** tab for long or complex scripts. This module reads `.lua` files directly from your game folder.

:::tabs
== Attila & Rome II
<video src="/videos/attila_scriptum.mp4" data-title="Using Scriptum" data-game="Both" autoplay loop muted playsinline></video>
:::

<div class="cs-step-footer">
  <a href="./scriptum" class="cs-step-ref">
    <div class="cs-ref-icon">✍️</div>
    <div class="cs-ref-content">
      <div class="cs-ref-label">Scriptum Guide</div>
      <div class="cs-ref-desc">Advanced file-based scripting workflow</div>
    </div>
  </a>
  <a href="./files" class="cs-step-ref">
    <div class="cs-ref-icon">📂</div>
    <div class="cs-ref-content">
      <div class="cs-ref-label">Consul Files</div>
      <div class="cs-ref-desc">Learn about the outputs and logs that make scripting easier</div>
    </div>
  </a>
</div>


