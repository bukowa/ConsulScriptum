# Battle Mode Guide

By default, the ConsulScriptum interface is not available in battle because the game does not load the campaign scripting and UI interfaces during tactical sessions. 

However, for both **Total War: Rome II** and **Total War: Attila**, a workaround is available to force the game to load these interfaces via a custom battlefield override.

---

## How to Enable (Rome II & Attila)

In both games, you can force the campaign UI (and thus the console) to load during a battle using a simple toggle command.

### Setup Instructions
1.  **Go into a Campaign.**
2.  **Run the Command**:
    ```bash
    /use_in_battle
    ```
3.  **Confirm**: You should see a message confirming that battle mode is enabled for **all subsequent campaign battles**.
4.  **Start Battle**: Enter any campaign battle. The ConsulScriptum window will now be available.

### Toggling Off
The `/use_in_battle` command is a toggle. If you wish to disable the console in battles (e.g., to restore standard UI performance), simply run the command again from a campaign session.

---

## Performance Notes

::: warning Performance Impact
Enabling the console in battle forces the game to load additional scripting and UI interfaces. This triggers a large number of internal events (for example, events linked to every missile particle hit), which **may potentially slow down performance during intense battles**. If you experience lag, it is recommended to toggle battle mode off.
:::

::: warning Campaign Sessions Only
The `/use_in_battle` command **only works within an active campaign session**. It cannot be used to enable the console for Custom Battles or Historical Battles launched from the main menu by default.

**Modders & Developers**: If your project specifically requires console access in standalone battles, please contact me on [Discord](https://discord.gg/tgggqMs4). 
:::

---

## Example Script: Battle Mode (Rome II & Attila)

The `bm` (Battle Manager) object is globally available when running scripts in battle. The following script is compatible with both **Rome II** and **Attila** and showcases how to iterate through all alliances and units currently on the field:

```lua
-- clear the console output for a nice view
consul.console.clear()

-- shortcut for writing into consul console
function wr(x)
    consul.console.write(x)
end

wr("how many alliances in battle?")
wr(bm:alliances():count())

for i = 1, bm:alliances():count() do
    local alliance = bm:alliances():item(i)
    wr("alliance " .. i .. " has " .. alliance:armies():count() .. " armies")

    for j = 1, alliance:armies():count() do
        local army = alliance:armies():item(j)
        wr("  army " .. j .. " has " .. army:units():count() .. " units")

        -- create controller
        local uc = army:create_unit_controller()

        local unit_types = {}
        for k = 1, army:units():count() do
            local unit = army:units():item(k)

            -- add each unit to the controller
            uc:add_units(unit)

            -- gather info for printing
            local utype = unit:type()
            local uname = unit:name()
            local men_alive = unit:number_of_men_alive()
            local men_start = unit:initial_number_of_men()
            table.insert(unit_types, utype .. " (" .. uname .. ", " .. men_alive .. "/" .. men_start .. ")")
        end
        
        wr("    units: " .. table.concat(unit_types, ", "))
    end
end
```

---

## Video Tutorial (Rome II Example)

The process for enabling battle mode in Attila is identical to the Rome II process shown below:

<div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.4); margin: 1.5rem 0;">
  <iframe 
    src="https://www.youtube.com/embed/NDv9TTjyqgM" 
    style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; border: 0;" 
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
    allowfullscreen>
  </iframe>
</div>
