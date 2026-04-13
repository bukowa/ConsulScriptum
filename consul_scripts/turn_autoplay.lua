-- this script works on vanilla as rom_rome in Rome2 (may work anywhere tho)
-- it auto plays the turns teleporting you to Terra Incognita and blocking all diplomation with you
-- it also auto clicks all general died and dilemmas

-- WARNING: currently the logic for making sure theres at least one army on the map
--          so theres no "Defeat" is a bit flawed, it needs rework because theres too many character spawning
--          i got a crash at turn 100 so for sure this needs improvement and fixes :))

STOP_NOW = false
STOP_AT_TURNS = 500

local faction_name = 'rom_rome'
local unit_name = 'Rom_Hastati'

local game = consul._game()
local model = game:model()
local world = model:world()
local faction = world:faction_by_key(faction_name)
local characters = faction:character_list()
local regions = faction:region_list()
local factions = world:faction_list()

local diplomacy_types = {
    "trade agreement", "military access", "military alliance", "cancel military access",
    "alliance", "regions", "technology", "state gift", "payments", "vassal", "peace", "war",
    "join war", "break trade", "break alliance", "hostages", "marriage", "non aggression pact",
    "soft military access", "hard military access", "cancel soft military access",
    "defensive alliance", "client state", "form confederation", "break non aggression pact",
    "break soft military access", "break hard military access", "break defensive alliance",
    "break vassal", "break client state", "state gift unilateral"
}

local count = 0
for i = 0, factions:num_items() - 1, 1 do
    for k = 1, #diplomacy_types do
        game:force_diplomacy(factions:item_at(i):name(), faction:name(), diplomacy_types[k], false, false)
        game:force_diplomacy(faction:name(), factions:item_at(i):name(), diplomacy_types[k], false, false)
        count = count + 1
    end
end

for i = 0, characters:num_items() - 1, 1 do
    local char = characters:item_at(i)
    if char:has_military_force() then
        game:kill_character('character_cqi:' .. char:cqi(), true, false)
    end
end

for i = 1, 4, 1 do
    game:create_force(faction_name, unit_name, 'rom_italia_latium', 0, 0, 'id', true)
end

for i = 0, regions:num_items() - 1, 1 do
    local region = regions:item_at(i)
    game:transfer_region_to_faction(region:name(), world:faction_list():item_at(25):name())
end


table.insert(events.IncomingMessage, function(ctx)
    if ctx.string ~= "character_dies_commanding_replace" then return end
    consul.ui.find('button_hire'):SimulateClick()
end)


local function find_accept()
    return consul.ui.find('button_accept')
end

local function click_accept()
    return consul.ui.find('button_accept'):SimulateClick()
end

local function find_dillema()
    if consul.ui.find('dilemma_button') ~= nil then
        return true
    end
    return false
end

local function click_dilemma()
    consul.ui.find('dilemma_button'):SimulateClick()
end


table.insert(events.FactionTurnStart, function(ctx)
    game:treasury_mod(faction:name(), 50000)

    if STOP_NOW then return end
    if model:turn_number() == STOP_AT_TURNS then return end

    if ctx:faction():is_human() then
        local general_count = 0

        characters = ctx:faction():character_list()

        for i = 0, characters:num_items() - 1, 1 do
            local char = characters:item_at(i)
            if char:has_military_force() then
                general_count = general_count + 1
            end
        end

        if (general_count <= 7) then
            for i = 1, 4, 1 do
                game:create_force(faction_name, unit_name, 'rom_italia_latium', 0, 0,
                    'id', false)
            end
        end

        while find_dillema() do
            click_dilemma()
        end

        while find_accept() do
            click_accept()
        end

        game:add_time_trigger('click_dilemma', 2)
        game:end_turn(true)
    end
end)

table.insert(events.TimeTrigger, function(ctx)
    if ctx.string == 'click_dilemma' then
        while find_dillema() do
            click_dilemma()
        end
        while find_accept() do
            click_accept()
        end
    end
end)

game:end_turn(true)
