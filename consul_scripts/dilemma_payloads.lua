--WORKS
scripting.game_interface:trigger_custom_dilemma(
        'rom_rome',
        "move_capital_rome",
        "payload { set_capital rom_italia_latium; }",
        "",
        true
)

--WORKS
scripting.game_interface:trigger_custom_dilemma(
        'rom_rome',
        "move_capital_rome",
        "payload { rebellion rom_italia_latium; }",
        "",
        true
)

--WORKS
scripting.game_interface:trigger_custom_dilemma(
        'rom_rome',
        "move_capital_rome",
        "payload { grant_agent { agent_key dignitary; location capital; } }",
        "",
        true
)

--WORKS
scripting.game_interface:trigger_custom_dilemma(
        'rom_rome',
        "move_capital_rome",
        "payload { effect_bundle { bundle_key wealth_local_commerce_15_plus; turns 379; } }",
        "",
        true
)

--WORKS
scripting.game_interface:trigger_custom_dilemma(
        'rom_rome',
        "move_capital_rome",
        "payload { unit_restriction { unit_key Rom_Hastati; disable;  } }",
        "",
        true
)
