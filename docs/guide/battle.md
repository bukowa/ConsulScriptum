# Battle Mode Guide

By default, the ConsulScriptum interface is not available in battle because the game does not load the battle scripting and UIComponent interfaces by default. 

For **Total War: Rome II**, a workaround is available to force the game to load these interfaces via a custom battlefield override.

---

## Total War: Rome II

In Rome II, you can force the campaign UI (and thus the console) to load during a battle by using a custom battlefield override.

### How to Enable
1.  **Start a Campaign**: Load your campaign save.
2.  **Run the Command**: In the console, type and submit:
    ```bash
    /use_in_battle
    ```
3.  **Confirm**: You should see a message confirming that battle mode is enabled for **all subsequent campaign battles**.
4.  **Start Battle**: Enter any land or sea battle. The ConsulScriptum window will now be available.

### Toggling Off
The `/use_in_battle` command is a toggle. If you wish to disable the console in battles, simply run the command again from a campaign session.

::: warning Performance Impact
Enabling the console in battle forces the game to load additional scripting and UI interfaces. This triggers a large number of internal events (for example, events linked to every missile particle hit), which **may potentially slow down performance during intense battles**. If you experience lag, it is recommended to toggle battle mode off.
:::

::: warning Campaign Sessions Only
The `/use_in_battle` command **only works within an active campaign session**. It cannot be used to enable the console for Custom Battles or Historical Battles launched from the main menu by default.

**Modders & Developers**: If your project (e.g., a total conversion or large overhaul) specifically requires console access in standalone battles, please contact me on [Discord](https://discord.gg/tgggqMs4). Implementing this may be possible with further research and I am open to investigating it if there is enough demand.
:::

### Video Tutorial
See the process in action in the video below:

<div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.4); margin: 1.5rem 0;">
  <iframe 
    src="https://www.youtube.com/embed/NDv9TTjyqgM" 
    style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; border: 0;" 
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
    allowfullscreen>
  </iframe>
</div>

---

## Total War: Attila

**Battle mode is currently unsupported in Attila.**

The engine-level workaround used in Rome II (custom battlefield overrides) behaves differently in Attila and does not currently trigger the campaign UI load. Research into alternative hooks for Attila is ongoing.

::: tip Stay Updated
Check the [Compatibility](./compatibility) page or join the [Discord](https://discord.gg/tgggqMs4) for updates on Attila support.
:::
