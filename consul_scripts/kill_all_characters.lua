--
-- This script will kill all characters in the game.
--
local factions = consul.game.faction_list()
local faction_to_characters_map = {}

for i = 1, #factions do
    local character_list = consul.game.faction(factions[i]):character_list()

    local characters = {}
    for j = 0, character_list:num_items() - 1 do
        table.insert(characters, character_list:item_at(j))
    end
    faction_to_characters_map[factions[i]] = characters
end

for i = 1, #factions do
    local faction = factions[i]
    local characters = faction_to_characters_map[faction]
    --.log:info(faction)

    for j = 1, #characters do
        local character = characters[j]

        --consul.log:info(character:cqi() .. " " .. character:age())
        consul._game():kill_character('character_cqi:' .. character:cqi(), false, true)
    end
end
