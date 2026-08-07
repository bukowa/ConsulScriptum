-- Scriptum: Strategic stance picker (green toggle)
--
-- Usage:
--   1. Copy this file into your game folder (e.g. ...\Total War Attila\set_strategic_stance.lua)
--   2. Add a line with `set_strategic_stance.lua` to the consul.scriptum file (game folder)
--   3. Reopen the Consul window, go to the Scriptum tab and click the new button
--
-- Clicking the button toggles the green highlight. While active, click two
-- settlements or characters - the second click sets a random strategic stance
-- between the two selected factions.

local stances = {
    "CAI_STRATEGIC_STANCE_BEST_FRIENDS",
    "CAI_STRATEGIC_STANCE_VERY_FRIENDLY",
    "CAI_STRATEGIC_STANCE_FRIENDLY",
    "CAI_STRATEGIC_STANCE_NEUTRAL",
    "CAI_STRATEGIC_STANCE_UNFRIENDLY",
    "CAI_STRATEGIC_STANCE_VERY_UNFRIENDLY",
    "CAI_STRATEGIC_STANCE_BITTER_ENEMIES",
}

-- state persists across script re-executions (the file is dofile'd on every click)
local STATE_KEY = "consul_strategic_stance_script_state"
local state = _G[STATE_KEY]
if not state then
    state = { active = false, registered = false, faction1 = nil }
    _G[STATE_KEY] = state
end

local function stance_handler(context)
    if not state.active then return end

    local faction_name
    if context.character then
        faction_name = context:character():faction():name()
    elseif context.garrison_residence then
        faction_name = context:garrison_residence():faction():name()
    end
    if not faction_name then return end

    if not state.faction1 then
        state.faction1 = faction_name
        consul.console.write("Strategic stance: first faction " .. faction_name .. " (click the 2nd)")
    elseif faction_name ~= state.faction1 then
        local stance = stances[math.random(#stances)]
        consul._game():cai_strategic_stance_manager_promote_specified_stance_towards_target_faction(
            state.faction1, faction_name, stance)
        consul.console.write("Strategic stance " .. stance .. " set: " .. state.faction1 .. " -> " .. faction_name)
        state.faction1 = nil
    end
end

-- register the listener once; it stays registered but only acts while active
if not state.registered then
    table.insert(events.SettlementSelected, stance_handler)
    table.insert(events.CharacterSelected, stance_handler)
    state.registered = true
end

-- toggle the green highlight
local my_id = consul.scriptum.entry
local btn = my_id and consul.ui.find(my_id)
if btn then
    if state.active then
        state.active = false
        state.faction1 = nil
        btn:SetState('offline')
        consul.console.clear()
    else
        state.active = true
        btn:SetState('online')
        consul.console.write("Strategic stance picker ON - click 2 settlements/characters")
    end
end
