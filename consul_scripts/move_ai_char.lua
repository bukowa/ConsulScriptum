
-- ROTR ROME
XX = 418
YY = 402

table.insert(events.CharacterTurnStart, function(context)
    local char = context:character()
    if char:character_type("general") and char:has_military_force() and char:military_force():is_army() then
        consul._game():force_character_force_into_stance('character_cqi:'..char:cqi(), "MILITARY_FORCE_ACTIVE_STANCE_TYPE_DEFAULT")
        consul._game():move_to('character_cqi:'..char:cqi(), XX, YY, false)
    end
end)
