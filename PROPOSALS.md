# Consul Script Proposals

Verified proposals for expanding the **Consul** click-to-run / click-to-toggle list (`consul.consul_scripts` / `consul.consul_scripts_v2`). None of the 20 proposals below duplicate the 15 existing Consul entries (`Ad Rebellos`, `Adice Provinciam`, `Aedificatio`, `Aerarium`, `Casus Belli`, `Custodes Vocati`, `Exterminare`, `Impetus`, `Incrementum`, `Pax Aeterna`, `Scientia`, `Sedatio`, `Subiugatio`, `Vexatio`, `Virtus`) or existing `/slash` commands.

All proposals follow the `AGENTS.md` architecture rules:
- **Silent Console UX:** Route diagnostics through `consul.new_log(...)`; never spam `consul.console.write(...)`.
- **Lua 5.1 & Nil Safety:** Use `consul.pprinter._is_null(...)` on C++ interfaces (Rome II lacks `:is_null_interface()`), guard `consul._game()` and `consul.consul_scripts_v2.played_faction()`, and reject `"rebels"` where faction queries or diplomacy methods apply.
- **UI List Layout:** `Virtus` remains alphabetically last among all existing and proposed entries, preserving `consul_virtus_entry` as the `:Layout()` anchor in `src/consul/consul.lua`.
- **Rome II Exclusions:** `consul.consul_scripts.games` currently only defines `TOB.setup()`. Supporting Rome II-excluded scripts (`Dissolutio`, `Immortalis`, `Vastatio`) requires adding `consul.consul_scripts.games.Rome2.setup()` in `src/consul/consul.lua` and a matching `ROME2_EXCLUDED` set in `scripts/generate_consul_scripts_docs.py`.

---

## 1. Instant One-Shot Actions

Entries with `once = true`: execute `start()` per click without staying active (`green`) or persisting state in `consul.state`.

### 1.1 Victoria — Win Next Autoresolve Battle
- **UI IDs:** `consul_victoria_entry` / `consul_victoria_script`
- **Compatibility:** Rome II, Attila, ToB | **DeI:** Compatible
- **Engine Calls & Queries:**
  - `consul._game():win_next_autoresolve_battle(player:name())`
  - `consul.consul_scripts_v2.played_faction()`, `player:name()`
- **Summary & Guards:** Configures the player faction to win its immediately upcoming autoresolved campaign battle on click without modifying unit stats. Guard `consul._game() ~= nil`, `player ~= nil` (spectator/autorun safety), and `player:name() ~= "rebels"`. Note that extreme odds (e.g., a single depleted unit vs. a full stack) can still resist autoresolve weighting in-engine.

---

## 2. Event-Driven Map Selection Toggles

Entries that stay active while armed, attach handlers to `consul.consul_scripts.event_handlers["<Event>"]["<key>"]` in `start()`, and clear both handlers and selection state in `setup()` and `stop()`. Never persist these in `consul.state`.

### 2.1 Commercium — Instant Trade Pact
- **UI IDs:** `consul_commercium_entry` / `consul_commercium_script`
- **Events:** `CharacterSelected`, `SettlementSelected` (two-step faction picker)
- **Compatibility:** Rome II, Attila, ToB | **DeI:** Compatible
- **Engine Calls & Queries:**
  - `consul._game():force_make_trade_agreement(faction1, faction2)`
  - `context:character():faction()`, `context:garrison_residence():faction()`, `faction:name()`, `consul.pprinter._is_null(...)`
- **Summary & Guards:** Clicking two characters or settlements belonging to distinct factions forces a trade agreement between them (subject to valid sea/land trade route connectivity in-engine). Guard `consul.pprinter._is_null` on character/garrison/faction, reject `"rebels"` and identical `faction1 == faction2`, and reset pending selection state in `setup()`/`stop()`. Do not call `is_trading_with` unguarded (Attila/ToB-only; absent in Rome II) or `factions_trading_with` on `"rebels"`.

### 2.2 Compedes — Pin Force & Strip Stance
- **UI IDs:** `consul_compedes_entry` / `consul_compedes_script`
- **Events:** `CharacterSelected`
- **Compatibility:** Rome II, Attila, ToB | **DeI:** Compatible
- **Engine Calls & Queries:**
  - `consul._game():zero_action_points("character_cqi:" .. char:cqi())`
  - `consul._game():force_character_force_into_stance("character_cqi:" .. char:cqi(), "MILITARY_FORCE_ACTIVE_STANCE_TYPE_DEFAULT")`
  - `context:character()`, `char:cqi()`, `char:has_military_force()`, `char:in_settlement()`, `char:in_port()`, `char:is_embedded_in_military_force()`, `consul.pprinter._is_null(char)`
- **Summary & Guards:** Inverse counterpart to `Impetus`: drains remaining campaign movement points to zero and pulls a field army or fleet out of Forced March, Raid, or Ambush back into default stance (`MILITARY_FORCE_ACTIVE_STANCE_TYPE_DEFAULT`, verified in `campaign_stances_tables` across all three games). Guard `consul.pprinter._is_null(char)`, `char:has_military_force()`, and skip characters inside settlements/ports or embedded agents to avoid invalid stance transitions.

### 2.3 Dissolutio — Break Alliances & Non-Aggression Pacts
- **UI IDs:** `consul_dissolutio_entry` / `consul_dissolutio_script`
- **Events:** `CharacterSelected`, `SettlementSelected` (two-step faction picker)
- **Compatibility:** Attila, ToB (**Rome II excluded**) | **DeI:** N/A
- **Engine Calls & Queries:**
  - `consul._game():force_break_alliance(faction1, faction2)`
  - `consul._game():force_break_non_aggression_pact(faction1, faction2)`
  - `context:character():faction()`, `context:garrison_residence():faction()`, `f1:allied_with(f2)`, `consul.pprinter._is_null(...)`
- **Summary & Guards:** Selecting two distinct factions immediately severs active alliances and non-aggression pacts between them without declaring war. `force_break_alliance` and `force_break_non_aggression_pact` do not exist in Rome II; hide in `consul.consul_scripts.games.Rome2.setup()`. Guard `consul.pprinter._is_null`, reject `"rebels"` and self-selection, and reset pending selection state in `setup()`/`stop()`.

### 2.4 Exploratio — Provincial Shroud Reveal
- **UI IDs:** `consul_exploratio_entry` / `consul_exploratio_script`
- **Events:** `SettlementSelected`
- **Compatibility:** Rome II, Attila, ToB | **DeI:** Compatible
- **Engine Calls & Queries:**
  - `consul._game():make_region_visible_in_shroud(player:name(), region:name())` (clicked region + each entry in `region:adjacent_region_list()`)
  - `consul.consul_scripts_v2.played_faction()`, `context:garrison_residence():region()`, `region:name()`, `region:adjacent_region_list()`, `num_items()`, `item_at(i)`, `consul.pprinter._is_null(...)`
- **Summary & Guards:** Permanently clears fog of war for the player over the clicked settlement's region and its immediate neighbors, complementing the global `/show_shroud` console command. Guard `player ~= nil`, `player:name() ~= "rebels"`, and `consul.pprinter._is_null` on `garrison`, `region`, and each adjacent region interface.

### 2.5 Immortalis — Character Immortality
- **UI IDs:** `consul_immortalis_entry` / `consul_immortalis_script`
- **Events:** `CharacterSelected`
- **Compatibility:** Attila, ToB (**Rome II excluded**) | **DeI:** N/A
- **Engine Calls & Queries:**
  - `consul._game():set_character_immortality("character_cqi:" .. char:cqi(), true)`
  - `context:character()`, `char:cqi()`, `char:get_forename()`, `char:get_surname()`, `consul.pprinter._is_null(char)`
- **Summary & Guards:** Marks the clicked character immortal on the campaign map so battle defeat or assassination wounds rather than kills them. `set_character_immortality` does not exist in Rome II; hide in `consul.consul_scripts.games.Rome2.setup()`. Guard `consul.pprinter._is_null(char)` and `char:cqi() ~= nil`.

### 2.6 Promotio — Character Rank XP (+100 XP)
- **UI IDs:** `consul_promotio_entry` / `consul_promotio_script`
- **Events:** `CharacterSelected`
- **Compatibility:** Rome II, Attila, ToB | **DeI:** Compatible
- **Engine Calls & Queries:**
  - `consul._game():add_agent_experience("character_cqi:" .. char:cqi(), 100)`
  - `context:character()`, `char:cqi()`, `char:rank()`, `consul.pprinter._is_null(char)`
- **Summary & Guards:** Grants `+100` character XP to the clicked general, admiral, governor, or agent (verified `character_experience_skill_tiers_tables` thresholds begin at `20 / 60 / 120 / 200` across all three titles; note that in ToB, generals/admirals have `skill_points = 0` in that table because ToB uses rank/traits rather than manual skill trees). Complements `Speculatores` (DB buff for agents). Guard `consul.pprinter._is_null(char)` and `char:cqi() ~= nil`.

### 2.7 Restitutio — Instant Settlement Repair
- **UI IDs:** `consul_restitutio_entry` / `consul_restitutio_script`
- **Events:** `SettlementSelected`
- **Compatibility:** Rome II, Attila, ToB | **DeI:** Compatible
- **Engine Calls & Queries:**
  - `consul._game():instantly_repair_building(slot:name())` for each occupied slot
  - `context:garrison_residence()`, `garrison:region()`, `region:slot_list()`, `slot:has_building()`, `slot:building():percent_health()`, `slot:name()`, `consul.pprinter._is_null(...)`
- **Summary & Guards:** Clicking any settlement immediately repairs all damaged or sacked buildings (`percent_health() < 100`) across its region slots without waiting turns or paying treasury. Guard `consul.pprinter._is_null` on `garrison`, `region`, `slot`, and `slot:building()`, and check `slot:has_building()` and `percent_health() < 100` before calling `slot:name()`. (Verify `instantly_repair_building(slot:name())` in-game during implementation, as vanilla `data/*/script/` contains no direct call example.)

### 2.8 Vastatio — Abandon & Raze Settlement
- **UI IDs:** `consul_vastatio_entry` / `consul_vastatio_script`
- **Events:** `SettlementSelected`
- **Compatibility:** Attila, ToB (**Rome II excluded**) | **DeI:** N/A
- **Engine Calls & Queries:**
  - `consul._game():set_region_abandoned(region:name())`
  - `context:garrison_residence()`, `garrison:region()`, `region:name()`, `region:owning_faction()`, `consul.pprinter._is_null(...)`
- **Summary & Guards:** Instantly abandons the clicked settlement into uncolonized ruins for border shaping or resetting stuck regions. `set_region_abandoned` does not exist in Rome II; hide in `consul.consul_scripts.games.Rome2.setup()`. Guard `consul.pprinter._is_null` on `garrison`, `region`, and `owning_faction` (skip already-abandoned regions), and never persist in `consul.state`.

### 2.9 Veterani — Veteran Field Army (+1 Unit Chevron)
- **UI IDs:** `consul_veterani_entry` / `consul_veterani_script`
- **Events:** `CharacterSelected`
- **Compatibility:** Rome II, Attila, ToB | **DeI:** Compatible
- **Engine Calls & Queries:**
  - `consul._game():award_experience_level("character_cqi:" .. char:cqi(), 1)`
  - `context:character()`, `char:cqi()`, `char:has_military_force()`, `char:military_force():is_army()`, `char:military_force():is_navy()`, `consul.pprinter._is_null(char)`
- **Summary & Guards:** Grants `+1` experience chevron to all existing units in the clicked general or admiral's force (complements `Dilectus`, which applies XP to newly recruited units). Guard `consul.pprinter._is_null(char)` and `char:has_military_force()`. **Crash guard:** Always pass a positive integer (`1`); negative values to `award_experience_level` crash the engine.

---

## 3. Persistent Faction Buff Toggles

Entries backed by `consul.consul_scripts_v2.create_cheat_toggle(...)` + `apply_effect_bundle` / `remove_effect_bundle` (`advancement_stage = start_turn_completed`, `bundle_target = faction`) with campaign `.save` persistence via `consul.state`. All keys and scopes below were verified against extracted vanilla and DeI tables (`effects_tables`, `campaign_effect_scopes_tables`, and `effect_bonus_value_*` junctions).

### 3.1 Abundantia — Food, Fertility & Sanitation
- **UI IDs / Bundle:** `consul_abundantia_entry` / `consul_abundantia_script` | `consul_scriptum_abundantia`
- **Compatibility:** Rome II, Attila, ToB | **DeI:** Compatible (helps offset `rom_army_food_consumption`)
- **DB Effects & Scopes:**
  - **Rome II:** `rom_payload_food` (`in_all_your_provinces`, `+20`), `3c_event_sanitation` (`in_all_your_regions`, `+10`; applies in Empire Divided/RotR, harmlessly ignored in Grand Campaign).
  - **Attila:** `att_effect_province_food_events` (`faction_to_province_own`, `+20`), `att_effect_food_base_production` (`faction_to_faction_own`, `+50`), `att_effect_faction_fertility` (`faction_to_province_own`, `+3`), `att_effect_sanitation_events` (`faction_to_region_own`, `+10`).
  - **ToB:** `vik_food_base_production` (`faction_to_faction_own`, `+500`), `vik_food_production_mod` (`faction_to_region_own`, `+50`). ToB scales food in hundreds and repurposes `sanitation_events` for public order (handled in *Concordia*).

### 3.2 Concordia — Public Order, Corruption, Loyalty & Integrity
- **UI IDs / Bundle:** `consul_concordia_entry` / `consul_concordia_script` | `consul_scriptum_concordia`
- **Compatibility:** Rome II, Attila, ToB | **DeI:** Compatible
- **DB Effects & Scopes:**
  - **Rome II:** `rom_faction_public_order_events` (`in_all_your_provinces`, `+20`), `rom_any_corruption_mod_global` (`this_faction`, `-50`), `rom_event_political_party_loyalty` (`this_faction`, `+15`).
  - **Attila:** `att_effect_public_order_events` (`faction_to_province_own`, `+20`), `att_effect_economy_corruption_mod` (`faction_to_faction_own`, `-50`), `att_effect_character_loyalty_mod_faction` (`faction_to_general_own`, `+5`), `att_effect_force_all_campaign_military_morale_factor_faction` (`faction_to_force_own`, `+20` Integrity).
  - **ToB:** `vik_public_order_new_positive_events` (`faction_to_region_own`, `+20`; maps to active `sanitation_events` PO system), `vik_corruption_mod` (`faction_to_province_own`, `-50`), `vik_loyalty_mod_faction` (`faction_to_character_own`, `+5`), `vik_supplies_faction` (`faction_to_army_own`, `+20`).
- **Notes:** Distinct from `Sedatio` (manual per-click `+10` PO on one settlement).

### 3.3 Cursus Publicus — Campaign Movement Range
- **UI IDs / Bundle:** `consul_cursus_entry` / `consul_cursus_script` | `consul_scriptum_cursus`
- **Compatibility:** Rome II, Attila, ToB | **DeI:** Compatible
- **DB Effects & Scopes:**
  - **Rome II:** `rom_force_campaign_mod_movement_range` (`in_all_your_forces`, `+100`)
  - **Attila:** `att_effect_force_all_campaign_movement_range` (`faction_to_force_own`, `+100`)
  - **ToB:** `vik_campaign_movement` (`faction_to_force_own`, `+100`)
- **Notes:** `+100%` campaign land & sea AP (`mod_land_movement_campaign`, `mod_ship_movement_campaign`); does not alter battle movement speed or animations. Distinct from `Impetus` (1-click AP refill).

### 3.4 Dilectus — Recruitment Capacity, Cost & Veteran Rank
- **UI IDs / Bundle:** `consul_dilectus_entry` / `consul_dilectus_script` | `consul_scriptum_dilectus`
- **Compatibility:** Rome II, Attila, ToB | **DeI:** Compatible (population class caps still govern eligibility)
- **DB Effects & Scopes:**
  - **Rome II:** `rom_tech_military_management_recruitment_mod` (`in_all_your_provinces`, `+3`; preferred over `rom_building_recruitment_points`, which DeI sets to `priority = -1` in `DeI_effects.tsv` to hide its UI tooltip line), `rom_tech_military_management_recruitment_navy_mod` (`in_all_your_sea_regions`, `+2`), `rom_force_campaign_mod_recruitment_cost_all` (`in_all_your_forces`, `-50`), `rom_force_unit_mod_experience_base` (`in_all_your_provinces`, `+3`, `all_units` via `unit_sets`).
  - **Attila:** `att_effect_unit_recruitment_points` (`faction_to_province_own`, `+3`), `att_unseen_horde_recruitment_points` (`faction_to_force_own`, `+3`), `att_effect_unit_recruitment_points_naval` (`faction_to_sea_region_own`, `+2`), `att_effect_force_all_campaign_recruitment_cost_all` (`faction_to_force_own`, `-50`), `att_effect_force_all_campaign_experience_base_all` (`faction_to_province_own`, `+3`, `all_units` via `unit_sets`).
  - **ToB:** `vik_recruitment_points` (`faction_to_province_own`, `+3`), `vik_recruitment_points_naval` (`faction_to_sea_region_own`, `+2`), `vik_recruitment_cost_all` (`faction_to_army_own`, `-50`), `vik_unit_pool_replenishment_mod` (`faction_to_faction_own`, `+3`), `vik_unit_pool_cap_mod` (`faction_to_faction_own`, `+5`), `vik_unit_xp_land` (`faction_to_army_own`, `+3`).

### 3.5 Immunitas — Terrain, Sea & Siege Attrition Immunity
- **UI IDs / Bundle:** `consul_immunitas_entry` / `consul_immunitas_script` | `consul_scriptum_immunitas`
- **Compatibility:** Rome II (partial: desert + siege only), Attila, ToB | **DeI:** Compatible (DeI scripted `rom_seasonal_effect_attrition` may still apply)
- **DB Effects & Scopes:**
  - **Rome II:** `3c_tech_military_desert_attrition_immunity` (`this_faction`, `1`), `rom_tech_engineering_siege_defence_attrition_mod` (`in_all_your_forces`, `-100`), `rom_tech_engineering_siege_offence_attrition_mod` (`all_your_generals`, `-100`). Rome II lacks snow/swamp/high-seas immunity flags in `basic_junction`.
  - **Attila:** `att_effect_force_army_campaign_attrition_snow_immunity` (`faction_to_force_own`, `1`), `att_effect_force_army_campaign_attrition_desert_immunity` (`faction_to_army_own`, `1`), `att_effect_force_army_campaign_attrition_swamp_immunity` (`faction_to_army_own`, `1`), `att_effect_force_navy_campaign_attrition_high_seas_immunity` (`faction_to_navy_own`, `1`), `att_effect_force_army_campaign_siege_defend_attrition` (`faction_to_force_own`, `-100`), `att_effect_force_army_campaign_siege_attack_attrition` (`faction_to_force_own`, `-100`).
  - **ToB:** `vik_force_terrain_immunity` (`faction_to_army_own`, `1`; covers desert, mountain, snow, swamp), `vik_faction_trait_vikings_heritage` (`faction_to_force_own`, `1`; high-sea immunity), `vik_siege_defence_attrition` (`faction_to_army_own`, `-100`), `vik_siege_attack_attrition` (`faction_to_army_own`, `-100`).

### 3.6 Obsidio — Siege Holdout & Siege Assault
- **UI IDs / Bundle:** `consul_obsidio_entry` / `consul_obsidio_script` | `consul_scriptum_obsidio`
- **Compatibility:** Rome II, Attila, ToB | **DeI:** Compatible
- **DB Effects & Scopes:**
  - **Rome II:** `rom_tech_engineering_siege_defence_time_mod` (`in_all_your_regions`, `+6`), `rom_tech_engineering_siege_offence_time_mod` (`all_your_generals`, `+3` — positive reduces enemy holdout).
  - **Attila:** `att_effect_force_army_campaign_siege_defend_holdout_time` (`faction_to_general_own`, `+6`), `att_effect_force_army_campaign_siege_attack_holdout_time` (`faction_to_general_own`, `-3` — negative reduces enemy holdout).
  - **ToB:** `vik_siege_defence_holdout_time` (`faction_to_region_own`, `+6`), plus a custom `consul_scriptum_obsidio_attack` (`faction_to_general_own`, `-3`, `siege_time_reduction_for_attacker` in `basic_junction` with `is_hidden = false` and localized text in `_consul.loc.tsv`). Prefer this over vanilla `vik_siege_defence_holdout_time_hidden` (`priority = 0`), whose loc string/display may be blank or misleading.

### 3.7 Opulentia — Tax, Trade, Wealth & Construction Cost
- **UI IDs / Bundle:** `consul_opulentia_entry` / `consul_opulentia_script` | `consul_scriptum_opulentia`
- **Compatibility:** Rome II, Attila, ToB | **DeI:** Compatible
- **DB Effects & Scopes:**
  - **Rome II:** `3c_event_tax_rate` (`in_all_your_provinces`, `+50`), `rom_building_trade_tariffs_all` (`this_faction`, `+50`), `rom_building_gdp_mod_all` (`in_all_your_regions`, `+50`), `rom_building_building_cost_mod` (`in_all_your_regions`, `-50`).
  - **Attila:** `att_effect_province_tax_rate` (`faction_to_province_own`, `+50`), `att_effect_economy_trade_tariff_mod` (`faction_to_faction_own`, `+50`), `att_effect_economy_gdp_mod_all` (`faction_to_region_own`, `+50`), plus custom `consul_scriptum_opulentia_build` (`faction_to_region_own`, `-50`) and `consul_scriptum_opulentia_force` (`faction_to_force_own`, `-50`) wired via `effect_bonus_value_building_set_junctions_tables` (`mod_cost`, `mod_conversion_cost`, `military_force_building_cost_mod`, `military_force_building_conversion_cost_mod` across all `att_building_set_*` & `rom_building_set_*`, matching `Aedificatio`).
  - **ToB:** `vik_tax_mod` (`faction_to_province_own`, `+50`), `vik_trade_mod` (`faction_to_faction_own`, `+50`), `vik_gdp_mod_all` (`faction_to_region_own`, `+50`), `vik_construction_cost_mod` (`faction_to_region_own`, `-50`).
- **Notes:** Distinct from `Aerarium` (`+10,000` treasury lump sum).

### 3.8 Redintegratio — Unit Replenishment
- **UI IDs / Bundle:** `consul_redintegratio_entry` / `consul_redintegratio_script` | `consul_scriptum_redintegratio`
- **Compatibility:** Rome II, Attila, ToB | **DeI:** Compatible (DeI supply/population rules still govern foreign-territory eligibility)
- **DB Effects & Scopes:**
  - **Rome II:** `3c_event_faction_replenishment` (`in_all_your_forces`, `+50`)
  - **Attila:** `att_effect_force_all_campaign_replenishment_rate` (`faction_to_force_own`, `+50`), `att_effect_horde_unit_replenishment_hidden` (`faction_to_force_own`, `+50`; unlocks `unrestricted_replenishment_bonus`)
  - **ToB:** `vik_replenishment_rate` (`faction_to_force_own`, `+50`), `vik_replenishment_mod` (`faction_to_force_own`, `+100`)

### 3.9 Speculatores — Agent Mastery & Rank
- **UI IDs / Bundle:** `consul_speculatores_entry` / `consul_speculatores_script` | `consul_scriptum_speculatores`
- **Compatibility:** Rome II, Attila (**ToB excluded**) | **DeI:** Compatible
- **DB Effects & Scopes:**
  - **Rome II:** `rom_agent_action_success_chance_mod` (`all_agents`, `+40`), `rom_agent_action_cost_mod` (`all_agents`, `-100`), `rom_building_recruitment_agent_level_all` (`in_all_your_regions`, `+3`), `inv_tech_civil_experience_rate_agents` (`all_agents`, `+100`), `rom_agent_action_parent_army_general_xp_gain` (`all_your_generals`, `+50`).
  - **Attila:** `att_effect_agent_action_success_chance` (`faction_to_agent_factionwide`, `+40`), `att_effect_agent_action_cost_mod` (`faction_to_agent_factionwide`, `-100`), `att_effect_agent_recruitment_xp_all_agents` (`faction_to_province_own`, `+3`).
  - **ToB:** Excluded (`TOB_EXCLUDED` in `scripts/generate_consul_scripts_docs.py` and `consul.consul_scripts.games.TOB.setup()`), because ToB has no deployed map agents and lacks `action_cost_mod`/`success_mod` in `effect_bonus_value_agent_junction_tables`.

### 3.10 Stipendium — Zero Military Upkeep
- **UI IDs / Bundle:** `consul_stipendium_entry` / `consul_stipendium_script` | `consul_scriptum_stipendium`
- **Compatibility:** Rome II, Attila, ToB | **DeI:** Compatible (covers unit upkeep; DeI scripted `dei_faction_imperium_income_upkeep` / building upkeep remain separate)
- **DB Effects & Scopes:**
  - **Rome II:** `rom_force_campaign_mod_upkeep_land` (`in_all_your_armies`, `-100`), `rom_force_campaign_mod_upkeep_naval` (`in_all_your_navies`, `-100`)
  - **Attila:** `att_effect_force_all_campaign_upkeep` (`faction_to_force_own`, `-100`; `upkeep_mod` on `all_units_regulars` & `all_units_mercenary`)
  - **ToB:** `vik_military_upkeep` (`faction_to_force_own`, `-100`; `upkeep_mod` on `all_units`), `vik_navy_upkeep` (`faction_to_navy_own`, `-100`)

---

## 4. Compatibility & Implementation Summary Table

| Latin Title | UI Entry ID | Archetype | Trigger / Bundle Key | Rome II | Attila | ToB | DeI |
| :--- | :--- | :--- | :--- | :---: | :---: | :---: | :---: |
| **Victoria** | `consul_victoria_entry` | One-Shot | `once = true` | ✅ | ✅ | ✅ | ✅ |
| **Commercium** | `consul_commercium_entry` | Selection Toggle | `CharacterSelected`, `SettlementSelected` | ✅ | ✅ | ✅ | ✅ |
| **Compedes** | `consul_compedes_entry` | Selection Toggle | `CharacterSelected` | ✅ | ✅ | ✅ | ✅ |
| **Dissolutio** | `consul_dissolutio_entry` | Selection Toggle | `CharacterSelected`, `SettlementSelected` | ❌ | ✅ | ✅ | N/A |
| **Exploratio** | `consul_exploratio_entry` | Selection Toggle | `SettlementSelected` | ✅ | ✅ | ✅ | ✅ |
| **Immortalis** | `consul_immortalis_entry` | Selection Toggle | `CharacterSelected` | ❌ | ✅ | ✅ | N/A |
| **Promotio** | `consul_promotio_entry` | Selection Toggle | `CharacterSelected` | ✅ | ✅ | ✅ | ✅ |
| **Restitutio** | `consul_restitutio_entry` | Selection Toggle | `SettlementSelected` | ✅ | ✅ | ✅ | ✅ |
| **Vastatio** | `consul_vastatio_entry` | Selection Toggle | `SettlementSelected` | ❌ | ✅ | ✅ | N/A |
| **Veterani** | `consul_veterani_entry` | Selection Toggle | `CharacterSelected` | ✅ | ✅ | ✅ | ✅ |
| **Abundantia** | `consul_abundantia_entry` | DB Buff Toggle | `consul_scriptum_abundantia` | ✅ | ✅ | ✅ | ✅ |
| **Concordia** | `consul_concordia_entry` | DB Buff Toggle | `consul_scriptum_concordia` | ✅ | ✅ | ✅ | ✅ |
| **Cursus Publicus** | `consul_cursus_entry` | DB Buff Toggle | `consul_scriptum_cursus` | ✅ | ✅ | ✅ | ✅ |
| **Dilectus** | `consul_dilectus_entry` | DB Buff Toggle | `consul_scriptum_dilectus` | ✅ | ✅ | ✅ | ✅ |
| **Immunitas** | `consul_immunitas_entry` | DB Buff Toggle | `consul_scriptum_immunitas` | ⚠️ | ✅ | ✅ | ✅ |
| **Obsidio** | `consul_obsidio_entry` | DB Buff Toggle | `consul_scriptum_obsidio` | ✅ | ✅ | ✅ | ✅ |
| **Opulentia** | `consul_opulentia_entry` | DB Buff Toggle | `consul_scriptum_opulentia` | ✅ | ✅ | ✅ | ✅ |
| **Redintegratio** | `consul_redintegratio_entry` | DB Buff Toggle | `consul_scriptum_redintegratio` | ✅ | ✅ | ✅ | ✅ |
| **Speculatores** | `consul_speculatores_entry` | DB Buff Toggle | `consul_scriptum_speculatores` | ✅ | ✅ | ❌ | ✅ |
| **Stipendium** | `consul_stipendium_entry` | DB Buff Toggle | `consul_scriptum_stipendium` | ✅ | ✅ | ✅ | ✅ |

Legend: ✅ Full support | ⚠️ Partial (Rome II `Immunitas` covers desert & siege attrition only) | ❌ Excluded (lacks engine API or DB mechanic)
