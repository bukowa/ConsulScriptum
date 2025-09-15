set_all_diplomacy = function()
    local diplomacy_types = {
        "trade agreement",
        "military access",
		"military alliance",
        "cancel military access",
        "alliance",
        "regions",
        "technology",
        "state gift",
        "payments",
        "vassal",
        "peace",
        "war",
        "join war",
        "break trade",
        "break alliance",
        "hostages",
        "marriage",
        "non aggression pact",
        "soft military access",
		"hard military access",
        "cancel soft military access",
        "defensive alliance",
        "client state",
        "form confederation",
        "break non aggression pact",
        "break soft military access",
		"break hard military access",
        "break defensive alliance",
        "break vassal",
        "break client state",
        "state gift unilateral"
    }

    local factions = consul.game.faction_list()

    for i = 1, #factions do
        for j = 1, #factions do
            if i ~= j then  -- skip diplomacy with self
                for k = 1, #diplomacy_types do
                    consul._game():force_diplomacy(factions[i], factions[j], diplomacy_types[k], false, false)
                end
            end
        end
    end
end


set_all_diplomacy()