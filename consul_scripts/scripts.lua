
-- pass the faction to the rom_rome
-- seems like it should work like confederation but it doesnt pass the armies
consul._game():grant_faction_handover('rom_rome', "rom_etruscan", 0, -1, nil)

-- creates force in Roma, seems like the `rom_italia_latium` is not important
consul._game():create_force('rom_rome', 'Rom_Hastati', 'rom_italia_latium', 313, 379, 'id', true)

-- gives the unit to the character, it uses the settlement key from startpos
-- it can be queried in game by dumping ui and looking for label on campaign map / strategic map
consul._game():grant_unit('settlement:rom_italia_latium:roma', 'Rom_Hastati')