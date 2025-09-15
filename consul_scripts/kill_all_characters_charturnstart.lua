table.insert(events.CharacterTurnStart, function(context)
    consul._game():kill_character('character_cqi:' .. context:character():cqi(), true, true)
end)
