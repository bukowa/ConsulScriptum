# Battle mode

By default, the ConsulScriptum interface is not available in battle in **Rome II** and **Attila** because the game does not load the campaign scripting and UI interfaces during tactical sessions. However, **Total War Saga: ToB** supports the console in battle natively.

:::tabs key:game
== ToB
The console works **out of the box** in *Thrones of Britannia*. Because the game makes the battle scripting API available by default in campaign battles, no workarounds are required. Simply open the console as you would in the campaign using your toggle key.

== Rome II & Attila
In these games, you must use an experimental workaround to force the game to load the console interfaces via a custom battlefield override.

### How to Enable
1.  **Go into a Campaign.**
2.  **Run the Command**:
    ```bash
    /use_in_battle
    ```
3.  **Confirm**: You should see a message confirming that battle mode is enabled for **all subsequent campaign battles**.
4.  **Start Battle**: Enter any campaign battle. The ConsulScriptum window will now be available.

> [!TIP] Toggling Off
> The `/use_in_battle` command is a toggle. Run it again from a campaign session to disable the console in battles.
:::

## Performance & Constraints

::: warning Performance Impact (Rome II & Attila)
For Rome II and Attila, using the `/use_in_battle` workaround forces the game to load additional scripting and UI interfaces. This triggers a large number of internal events (e.g., events for every missile particle hit), which **may potentially slow down performance during intense battles**. If you experience lag, it is recommended to toggle battle mode off.

**Note for ToB**: This warning does not apply to *Thrones of Britannia*, as the console is native and does not require the workaround overhead.
:::

::: warning Campaign Sessions Only (Rome II & Attila)
The `/use_in_battle` workaround for Rome II/Attila **only works within an active campaign session**. It cannot be used to enable the console for Custom Battles or Historical Battles launched from the main menu.

For more technical details on why these restrictions exist, see [Technical Limitations](./technical-limitations#battle-mode).
:::

## Example Script: Battle Mode

The `bm` (Battle Manager) object is globally available when running scripts in battle. The following script is compatible with both **Rome II**, **Attila**, **ToB** and showcases how to iterate through all alliances and units currently on the field:

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
