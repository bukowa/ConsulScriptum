
local personalities = {
    "default",
    "gaul_minor_friendly",
    "gaul_minor_money_driven",
    "gaul_minor_money_hater",
    "gaul_minor_naval_aggressive",
    "gaul_minor_naval_defensive",
    "gaul_minor_opportunist",
    "gaul_minor_warlike",
    "gaul_playable_barbarian_extra_research",
    "gaul_playable_roman_extra_research",
    "minor_afroarabian",
    "minor_afroarabian_alternative",
    "minor_celtic",
    "minor_celtic_alternative",
    "minor_eastern",
    "minor_eastern_alternative",
    "minor_germanic",
    "minor_germanic_alternative",
    "minor_hellenic",
    "minor_hellenic_alternative",
    "minor_hellenic_eastern",
    "minor_hellenic_eastern_alternative",
    "minor_latin",
    "minor_nomadic",
    "minor_nomadic_alternative",
    "minor_punic",
    "playable_british",
    "playable_carthaginian",
    "playable_celtic",
    "playable_egyptian",
    "playable_germanic",
    "playable_greek",
    "playable_pathian",
    "playable_pontic",
    "playable_roman",
    "playable_seleucid",
    "playable_spartan",
    "pro_passive",
    "pun_rome",
    "random",
    "playable_pel_greek",
    "playable_pel_league",
    "playable_pel_naval_state",
    "playable_pel_spartan",
    "playable_pel_spartan_tricky",
    "dei_greek_colony",
    "playable_egyptian_meroe",
    "3c_minor_afroarabian",
    "3c_minor_afroarabian_alternative",
    "3c_minor_eastern",
    "3c_minor_germanic",
    "3c_minor_germanic_alternative",
    "3c_minor_nomadic",
    "3c_playable_british",
    "3c_playable_celtic",
    "3c_playable_germanic",
    "3c_playable_pathian",
    "3c_playable_roman",
    "inv_aggressive",
    "inv_aggressive_loyal",
    "inv_aggressive_treacherous",
    "inv_aggressive_unreliable",
    "inv_balanced",
    "inv_balanced_cautious",
    "inv_balanced_loyal",
    "inv_balanced_treacherous",
    "inv_diplomatic_aggressive",
    "inv_diplomatic_cautious",
    "inv_diplomatic_passive",
    "inv_diplomatic_warlike",
    "inv_gauls_diplomatic",
    "inv_gauls_diplomatic_aggressive",
    "inv_gauls_diplomatic_cautious",
    "inv_gauls_diplomatic_passive",
    "inv_gauls_warlike",
    "inv_gauls_warlike_aggressive",
    "inv_gauls_warlike_confident",
    "inv_gauls_warlike_passive",
    "inv_carthage_personality",
    "inv_nuragic",
}

local stances = {
    "CAI_STRATEGIC_STANCE_BEST_FRIENDS",
    "CAI_STRATEGIC_STANCE_VERY_FRIENDLY",
    "CAI_STRATEGIC_STANCE_FRIENDLY",
    "CAI_STRATEGIC_STANCE_NEUTRAL",
    "CAI_STRATEGIC_STANCE_UNFRIENDLY",
    "CAI_STRATEGIC_STANCE_VERY_UNFRIENDLY",
    "CAI_STRATEGIC_STANCE_BITTER_ENEMIES"
}

---@type FACTION_LIST_SCRIPT_INTERFACE
local faction_list = consul._game():model():world():faction_list()

for i = 0, faction_list:num_items() - 1 do
    ---@type FACTION_SCRIPT_INTERFACE
    local faction = faction_list:item_at(i)
    local personality = personalities[math.random(#personalities)]

    consul._game():force_change_cai_faction_personality(faction:name(), personality)
    --consul.log:info(faction:name() .. " " .. personality)

    for j = 0, faction_list:num_items() - 1 do
        if i ~= j then
            local target = faction_list:item_at(j)
            local stance = stances[math.random(#stances)]
            --consul.log:info("  " .. target:name() .. " " .. stance)
            consul._game():cai_strategic_stance_manager_promote_specified_stance_towards_target_faction(faction:name(), target:name(), stance)
        end
    end
end
