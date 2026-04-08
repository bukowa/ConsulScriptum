---
outline: [2, 4]
---

# Consul Manual

1. Click the **Consul** tab at the top of the interface.
2. Scroll through the list of pre-bundled scripts.
3. Click a script entry to execute it. **The entry will highlight in green** to indicate that the script is currently active or has been triggered.
4. To deactivate or "unclick" a script, simply click the highlighted entry again.

:::tabs

== Attila
<video src="/videos/attila_index.mp4" data-title="Killing Multiple Characters" data-game="Attila" autoplay loop muted playsinline></video>

== Rome II
<video src="/videos/rome2_index.mp4" data-title="Transferring Settlement & Killing Character" data-game="Rome II" autoplay loop muted playsinline></video>

:::

### Usage Notes
- **Highlighting**: When a script is active or has been triggered, the entry will highlight in green.
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


### How It Works
When you click a Consul entry, that script becomes active. While active, it listens for game events such as selecting a settlement or a character, and then executes its action when that event happens. If the script is not active, it does nothing. Clicking the same entry again turns the script off.

## Custom Scripts

For custom scripts and commands, see [Consul Scripts](./consul-advanced).


## Available Scripts

<div class="compact-reference">

<!-- @include: ./parts/generated-consul-scripts.md -->

</div>

---
