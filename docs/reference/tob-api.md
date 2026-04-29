# Thrones of Britannia Scripting API Reference

This is an automated API reference generated from the engine dump logs for Thrones of Britannia.

## Table of Contents

- [BUILDING_LIST_SCRIPT_INTERFACE](#building_list_script_interface)
- [BUILDING_SCRIPT_INTERFACE](#building_script_interface)
- [CAMPAIGN_AI_SCRIPT_INTERFACE](#campaign_ai_script_interface)
- [CAMPAIGN_MISSION_SCRIPT_INTERFACE](#campaign_mission_script_interface)
- [CHARACTER_LIST_SCRIPT_INTERFACE](#character_list_script_interface)
- [CHARACTER_SCRIPT_INTERFACE](#character_script_interface)
- [ESTATE_SCRIPT_INTERFACE](#estate_script_interface)
- [FACTION_LIST_SCRIPT_INTERFACE](#faction_list_script_interface)
- [FACTION_SCRIPT_INTERFACE](#faction_script_interface)
- [FAMILY_MEMBER_SCRIPT_INTERFACE](#family_member_script_interface)
- [GARRISON_RESIDENCE_SCRIPT_INTERFACE](#garrison_residence_script_interface)
- [MILITARY_FORCE_LIST_SCRIPT_INTERFACE](#military_force_list_script_interface)
- [MILITARY_FORCE_SCRIPT_INTERFACE](#military_force_script_interface)
- [MODEL_SCRIPT_INTERFACE](#model_script_interface)
- [NULL_SCRIPT_INTERFACE](#null_script_interface)
- [PENDING_BATTLE_SCRIPT_INTERFACE](#pending_battle_script_interface)
- [REGION_LIST_SCRIPT_INTERFACE](#region_list_script_interface)
- [REGION_MANAGER_SCRIPT_INTERFACE](#region_manager_script_interface)
- [REGION_SCRIPT_INTERFACE](#region_script_interface)
- [SETTLEMENT_SCRIPT_INTERFACE](#settlement_script_interface)
- [SLOT_LIST_SCRIPT_INTERFACE](#slot_list_script_interface)
- [SLOT_SCRIPT_INTERFACE](#slot_script_interface)
- [UIComponent](#uicomponent)
- [UNIT_LIST_SCRIPT_INTERFACE](#unit_list_script_interface)
- [UNIT_SCRIPT_INTERFACE](#unit_script_interface)
- [WORLD_SCRIPT_INTERFACE](#world_script_interface)

---

## BUILDING_LIST_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `is_empty` | |
| `item_at` | |
| `new` | |
| `num_items` | |

---

## BUILDING_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `chain` | |
| `faction` | |
| `is_null_interface` | |
| `model` | |
| `name` | |
| `new` | |
| `percent_health` | |
| `region` | |
| `slot` | |
| `superchain` | |

---

## CAMPAIGN_AI_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `is_null_interface` | |
| `new` | |
| `strategic_stance_between_factions` | |
| `strategic_stance_between_factions_available` | |
| `strategic_stance_between_factions_is_being_blocked` | |
| `strategic_stance_between_factions_is_being_blocked_until` | |
| `strategic_stance_between_factions_promotion_current_level` | |
| `strategic_stance_between_factions_promotion_end_level` | |
| `strategic_stance_between_factions_promotion_end_round` | |
| `strategic_stance_between_factions_promotion_is_active` | |
| `strategic_stance_between_factions_promotion_or_blocking_is_set` | |
| `strategic_stance_between_factions_promotion_start_level` | |
| `strategic_stance_between_factions_promotion_start_round` | |

---

## CAMPAIGN_MISSION_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `faction` | |
| `is_null_interface` | |
| `mission_issuer_record_key` | |
| `mission_record_key` | |
| `model` | |
| `new` | |

---

## CHARACTER_LIST_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `is_empty` | |
| `item_at` | |
| `new` | |
| `num_items` | |

---

## CHARACTER_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `action_points_per_turn` | |
| `action_points_remaining_percent` | |
| `age` | |
| `battles_fought` | |
| `battles_won` | |
| `body_guard_casulties` | |
| `character_type` | |
| `command_queue_index` | |
| `cqi` | |
| `defensive_ambush_battles_fought` | |
| `defensive_ambush_battles_won` | |
| `defensive_battles_fought` | |
| `defensive_battles_won` | |
| `defensive_naval_battles_fought` | |
| `defensive_naval_battles_won` | |
| `defensive_sieges_fought` | |
| `defensive_sieges_won` | |
| `display_position_x` | |
| `display_position_y` | |
| `faction` | |
| `family_member` | |
| `father` | |
| `forename` | |
| `fought_in_battle` | |
| `garrison_residence` | |
| `get_forename` | |
| `get_surname` | |
| `gravitas` | |
| `has_ancillary` | |
| `has_father` | |
| `has_garrison_residence` | |
| `has_military_force` | |
| `has_mother` | |
| `has_recruited_mercenaries` | |
| `has_region` | |
| `has_skill` | |
| `has_spouse` | |
| `has_trait` | |
| `in_port` | |
| `in_settlement` | |
| `is_ambushing` | |
| `is_besieging` | |
| `is_blockading` | |
| `is_carrying_troops` | |
| `is_deployed` | |
| `is_embedded_in_military_force` | |
| `is_faction_leader` | |
| `is_heir` | |
| `is_hidden` | |
| `is_male` | |
| `is_minister` | |
| `is_null_interface` | |
| `is_politician` | |
| `is_seeking_wife` | |
| `logical_position_x` | |
| `logical_position_y` | |
| `loyalty` | |
| `military_force` | |
| `model` | |
| `mother` | |
| `new` | |
| `number_of_traits` | |
| `offensive_ambush_battles_fought` | |
| `offensive_ambush_battles_won` | |
| `offensive_battles_fought` | |
| `offensive_battles_won` | |
| `offensive_naval_battles_fought` | |
| `offensive_naval_battles_won` | |
| `offensive_sieges_fought` | |
| `offensive_sieges_won` | |
| `percentage_of_own_alliance_killed` | |
| `performed_action_this_turn` | |
| `rank` | |
| `region` | |
| `routed_in_battle` | |
| `spouse` | |
| `surname` | |
| `trait_level` | |
| `trait_points` | |
| `turns_at_sea` | |
| `turns_in_enemy_regions` | |
| `turns_in_own_regions` | |
| `turns_without_wife` | |
| `won_battle` | |

---

## ESTATE_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `estate_record_key` | |
| `is_null_interface` | |
| `new` | |
| `owner` | |
| `region` | |

---

## FACTION_LIST_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `is_empty` | |
| `item_at` | |
| `new` | |
| `num_items` | |

---

## FACTION_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `allied_with` | |
| `ancillary_exists` | |
| `at_war` | |
| `at_war_with` | |
| `character_list` | |
| `command_queue_index` | |
| `culture` | |
| `ended_war_this_turn` | |
| `faction_leader` | |
| `factions_at_war_with` | |
| `factions_trading_with` | |
| `has_effect_bundle` | |
| `has_faction_leader` | |
| `has_food_shortage` | |
| `has_home_region` | |
| `has_technology` | |
| `home_region` | |
| `imperium_level` | |
| `is_dead` | |
| `is_horde` | |
| `is_human` | |
| `is_null_interface` | |
| `is_trading_with` | |
| `is_vassal_of` | |
| `losing_money` | |
| `mercenary_pool` | |
| `military_force_list` | |
| `model` | |
| `name` | |
| `new` | |
| `num_allies` | |
| `num_generals` | |
| `region_list` | |
| `research_queue_idle` | |
| `sea_trade_route_raided` | |
| `started_war_this_turn` | |
| `state_religion` | |
| `state_religion_percentage` | |
| `subculture` | |
| `tax_category` | |
| `tax_level` | |
| `total_food` | |
| `trade_resource_exists` | |
| `trade_route_limit_reached` | |
| `trade_ship_not_in_trade_node` | |
| `trade_value` | |
| `trade_value_percent` | |
| `treasury` | |
| `treasury_percent` | |
| `unused_international_trade_route` | |
| `upkeep_expenditure_percent` | |

---

## FAMILY_MEMBER_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `come_of_age` | |
| `father` | |
| `has_father` | |
| `has_mother` | |
| `has_trait` | |
| `is_null_interface` | |
| `mother` | |
| `new` | |

---

## GARRISON_RESIDENCE_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `army` | |
| `buildings` | |
| `can_assault` | |
| `faction` | |
| `has_army` | |
| `has_navy` | |
| `is_null_interface` | |
| `is_settlement` | |
| `is_slot` | |
| `is_under_siege` | |
| `model` | |
| `navy` | |
| `new` | |
| `region` | |
| `settlement_interface` | |
| `slot_interface` | |
| `unit_count` | |

---

## MILITARY_FORCE_LIST_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `is_empty` | |
| `item_at` | |
| `new` | |
| `num_items` | |

---

## MILITARY_FORCE_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `active_stance` | |
| `building_exists` | |
| `buildings` | |
| `can_activate_stance` | |
| `character_list` | |
| `command_queue_index` | |
| `contains_mercenaries` | |
| `faction` | |
| `garrison_residence` | |
| `general_character` | |
| `has_garrison_residence` | |
| `has_general` | |
| `is_armed_citizenry` | |
| `is_army` | |
| `is_horde` | |
| `is_navy` | |
| `is_null_interface` | |
| `model` | |
| `morale` | |
| `new` | |
| `unit_list` | |
| `upkeep` | |

---

## MODEL_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `campaign_ai` | |
| `campaign_name` | |
| `campaign_type` | |
| `character_can_reach_character` | |
| `character_for_command_queue_index` | |
| `date_and_week_in_range` | |
| `date_in_range` | |
| `difficulty_level` | |
| `faction_for_command_queue_index` | |
| `faction_is_local` | |
| `has_character_command_queue_index` | |
| `has_faction_command_queue_index` | |
| `has_military_force_command_queue_index` | |
| `is_multiplayer` | |
| `is_null_interface` | |
| `is_player_turn` | |
| `military_force_for_command_queue_index` | |
| `new` | |
| `pending_battle` | |
| `player_steam_id_is_odd` | |
| `random_percent` | |
| `season` | |
| `turn_number` | |
| `world` | |

---

## NULL_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `is_null_interface` | |
| `new` | |

---

## PENDING_BATTLE_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `ambush_battle` | |
| `attacker` | |
| `attacker_battle_result` | |
| `attacker_commander_fought_in_battle` | |
| `attacker_commander_fought_in_melee` | |
| `attacker_is_stronger` | |
| `attacker_strength` | |
| `battle_type` | |
| `contested_garrison` | |
| `defender` | |
| `defender_battle_result` | |
| `defender_commander_fought_in_battle` | |
| `defender_commander_fought_in_melee` | |
| `defender_strength` | |
| `failed_ambush_battle` | |
| `has_attacker` | |
| `has_contested_garrison` | |
| `has_defender` | |
| `is_active` | |
| `is_null_interface` | |
| `model` | |
| `naval_battle` | |
| `new` | |
| `night_battle` | |
| `percentage_of_attacker_killed` | |
| `percentage_of_attacker_routed` | |
| `percentage_of_defender_killed` | |
| `percentage_of_defender_routed` | |
| `secondary_attackers` | |
| `secondary_defenders` | |
| `seige_battle` | |

---

## REGION_LIST_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `is_empty` | |
| `item_at` | |
| `new` | |
| `num_items` | |

---

## REGION_MANAGER_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `faction_region_list` | |
| `is_null_interface` | |
| `model` | |
| `new` | |
| `region_by_key` | |
| `region_list` | |
| `resource_exists_anywhere` | |
| `settlement_by_key` | |
| `slot_by_key` | |

---

## REGION_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `adjacent_region_list` | |
| `building_exists` | |
| `building_superchain_exists` | |
| `garrison_residence` | |
| `governor` | |
| `has_governor` | |
| `is_null_interface` | |
| `is_province_capital` | |
| `last_building_constructed_key` | |
| `majority_religion` | |
| `majority_religion_percentage` | |
| `model` | |
| `name` | |
| `new` | |
| `num_buildings` | |
| `owning_faction` | |
| `province_name` | |
| `public_order` | |
| `region_wealth_change_percent` | |
| `resource_exists` | |
| `sanitation` | |
| `settlement` | |
| `slot_list` | |
| `slot_type_exists` | |
| `squalor` | |
| `town_wealth_growth` | |

---

## SETTLEMENT_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `commander` | |
| `display_position_x` | |
| `display_position_y` | |
| `faction` | |
| `has_commander` | |
| `is_null_interface` | |
| `logical_position_x` | |
| `logical_position_y` | |
| `model` | |
| `new` | |
| `region` | |
| `slot_list` | |

---

## SLOT_LIST_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `buliding_type_exists` | |
| `is_empty` | |
| `item_at` | |
| `new` | |
| `num_items` | |
| `slot_type_exists` | |

---

## SLOT_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `building` | |
| `faction` | |
| `has_building` | |
| `is_null_interface` | |
| `model` | |
| `name` | |
| `new` | |
| `region` | |
| `type` | |

---

## UIComponent

| Function | Description |
| :--- | :--- |
| `Address` | |
| `Adopt` | |
| `AttachCustomControl` | |
| `Bounds` | |
| `CallbackId` | |
| `ChildCount` | |
| `ClearSound` | |
| `CreateComponent` | |
| `CurrentAnimationId` | |
| `CurrentState` | |
| `CurrentStateUI` | |
| `DestroyChildren` | |
| `Dimensions` | |
| `Divorce` | |
| `DockingPoint` | |
| `Find` | |
| `FindPositionIntoCurrentText` | |
| `FindTextSnapPosition` | |
| `ForceEvent` | |
| `GetProperty` | |
| `GetStateText` | |
| `GetStateTextDetails` | |
| `GetTooltipText` | |
| `GlobalExists` | |
| `HasInterface` | |
| `Height` | |
| `Highlight` | |
| `Id` | |
| `InterfaceFunction` | |
| `IsCharPrintable` | |
| `IsDragged` | |
| `IsInteractive` | |
| `IsMouseOverChildren` | |
| `IsMoveable` | |
| `Layout` | |
| `LockPriority` | |
| `LuaCall` | |
| `MoveTo` | |
| `Opacity` | |
| `Parent` | |
| `PopulateTextures` | |
| `Position` | |
| `Priority` | |
| `PropagateImageColour` | |
| `PropagateOpacity` | |
| `PropagatePriority` | |
| `PropagateVisibility` | |
| `ReorderChildren` | |
| `Resize` | |
| `RestoreUIHeirarchy` | |
| `RunScript` | |
| `SaveUIHeirarchy` | |
| `SequentialFind` | |
| `SetDisabled` | |
| `SetDockingPoint` | |
| `SetDragged` | |
| `SetEventCallback` | |
| `SetGlobal` | |
| `SetImageColour` | |
| `SetImageRotation` | |
| `SetInteractive` | |
| `SetMoveable` | |
| `SetOpacity` | |
| `SetProperty` | |
| `SetState` | |
| `SetStateColours` | |
| `SetStateText` | |
| `SetStateTextDetails` | |
| `SetStateTextXOffset` | |
| `SetTooltipText` | |
| `SetTooltipTextWithRLSKey` | |
| `SetVisible` | |
| `ShaderTechniqueGet` | |
| `ShaderTechniqueSet` | |
| `ShaderVarsGet` | |
| `ShaderVarsSet` | |
| `SimulateClick` | |
| `SimulateKey` | |
| `SimulateLClick` | |
| `SimulateMouseMove` | |
| `SimulateMouseOff` | |
| `SimulateMouseOn` | |
| `SimulateRClick` | |
| `StealInputFocus` | |
| `StealShortcutKey` | |
| `TextDimensions` | |
| `TextShaderTechniqueSet` | |
| `TextShaderVarsGet` | |
| `TextShaderVarsSet` | |
| `TriggerAnimation` | |
| `TriggerShortcut` | |
| `UnLockPriority` | |
| `Visible` | |
| `Width` | |
| `WidthOfTextLine` | |
| `new` | |

---

## UNIT_LIST_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `has_unit` | |
| `is_empty` | |
| `item_at` | |
| `new` | |
| `num_items` | |

---

## UNIT_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `can_upgrade_unit` | |
| `can_upgrade_unit_equipment` | |
| `cqi` | |
| `faction` | |
| `force_commander` | |
| `has_force_commander` | |
| `has_unit_commander` | |
| `is_land_unit` | |
| `is_naval_unit` | |
| `is_null_interface` | |
| `military_force` | |
| `model` | |
| `new` | |
| `percentage_proportion_of_full_strength` | |
| `unit_category` | |
| `unit_class` | |
| `unit_commander` | |
| `unit_key` | |

---

## WORLD_SCRIPT_INTERFACE

| Function | Description |
| :--- | :--- |
| `ancillary_exists` | |
| `climate_phase_index` | |
| `faction_by_key` | |
| `faction_exists` | |
| `faction_list` | |
| `is_null_interface` | |
| `model` | |
| `new` | |
| `region_manager` | |
| `whose_turn_is_it` | |

---

