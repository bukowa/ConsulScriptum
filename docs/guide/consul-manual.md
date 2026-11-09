---
outline: [2, 4]
---

# Consul (one-click actions)

1. Click the **Consul** tab at the top of the interface.
2. Scroll through the list of pre-bundled scripts.
3. Click a script entry to execute it. **The entry will highlight in green** to indicate that the script is currently active or has been triggered.
4. To deactivate or "unclick" a script, simply click the highlighted entry again.

:::tabs key:game

== Attila
<video :src="$withBase('/videos/attila_index.mp4')" data-title="Killing Multiple Characters" data-game="Attila" autoplay loop muted playsinline></video>

== ToB
<video :src="$withBase('/videos/tob_index.mp4')" data-title="Transferring Settlement & Killing Character" data-game="ToB" autoplay loop muted playsinline></video>

== Rome II
<video :src="$withBase('/videos/rome2_index.mp4')" data-title="Transferring Settlement & Killing Character" data-game="Rome II" autoplay loop muted playsinline></video>

:::

### Usage Notes
- **Highlighting**: When a script is active or has been triggered, the entry will highlight in green.
- **Toggle**: Click the highlighted entry again to deactivate it.


<div class="cs-ui-magnifier">
  <div class="cs-magnifier-label">Tooltip Preview</div>
  <div class="cs-magnifier-images">
    <img :src="$withBase('/media/consul_tooltip1.png')" alt="" />
    <img :src="$withBase('/media/consul_tooltip2.png')" alt="" />
  </div>
  <div class="cs-magnifier-hint">
    Hover your mouse over any script in the list to reveal its full usage instructions.
  </div>
</div>


### How It Works
Consul entries operate in two distinct modes:
- **Instant actions**: Scripts such as **Aerarium** trigger immediately upon clicking (e.g. adding +10,000 treasury) and run on every click without toggling.
- **Toggles & event listeners**: Scripts such as **Aedificatio**, **Scientia**, and **Virtus** apply persistent faction effects while active. Targeted scripts like **Exterminare** or **Adice Provinciam** listen for campaign map selections while active. Clicking an active entry deactivates it.
- **Save persistence**: Active toggle states are automatically saved and restored across campaign save and load cycles.


## Available Scripts

To view the list of available scripts, see [Consul Scripts](../reference/consul-scripts-reference).

## Custom Scripts

To learn how to add custom scripts, see [How to add a Consul Script](./advanced-consul-scripting).
