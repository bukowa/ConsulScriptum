# Rome II API Reference

This is an automated API reference generated from the engine dump logs for Rome II.

## Table of Contents
- [BUILDING_LIST_SCRIPT_INTERFACE](#building-list-script-interface)
- [BUILDING_SCRIPT_INTERFACE](#building-script-interface)
- [CAMPAIGN_AI_SCRIPT_INTERFACE](#campaign-ai-script-interface)
- [CAMPAIGN_MISSION_SCRIPT_INTERFACE](#campaign-mission-script-interface)
- [CAMPAIGN_POLITICS_SCRIPT_INTERFACE](#campaign-politics-script-interface)
- [CHARACTER_LIST_SCRIPT_INTERFACE](#character-list-script-interface)
- [CHARACTER_SCRIPT_INTERFACE](#character-script-interface)
- [FACTION_LIST_SCRIPT_INTERFACE](#faction-list-script-interface)
- [FACTION_SCRIPT_INTERFACE](#faction-script-interface)
- [GAME](#game)
- [GARRISON_RESIDENCE_SCRIPT_INTERFACE](#garrison-residence-script-interface)
- [MILITARY_FORCE_LIST_SCRIPT_INTERFACE](#military-force-list-script-interface)
- [MILITARY_FORCE_SCRIPT_INTERFACE](#military-force-script-interface)
- [MODEL_SCRIPT_INTERFACE](#model-script-interface)
- [NULL_SCRIPT_INTERFACE](#null-script-interface)
- [PENDING_BATTLE_SCRIPT_INTERFACE](#pending-battle-script-interface)
- [REGION_LIST_SCRIPT_INTERFACE](#region-list-script-interface)
- [REGION_MANAGER_SCRIPT_INTERFACE](#region-manager-script-interface)
- [REGION_SCRIPT_INTERFACE](#region-script-interface)
- [SETTLEMENT_SCRIPT_INTERFACE](#settlement-script-interface)
- [SLOT_LIST_SCRIPT_INTERFACE](#slot-list-script-interface)
- [SLOT_SCRIPT_INTERFACE](#slot-script-interface)
- [UIComponent](#uicomponent)
- [UNIT_LIST_SCRIPT_INTERFACE](#unit-list-script-interface)
- [UNIT_SCRIPT_INTERFACE](#unit-script-interface)
- [WORLD_SCRIPT_INTERFACE](#world-script-interface)

---

## BUILDING_LIST_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `is_empty` |
| `item_at` |
| `new` |
| `num_items` |

## BUILDING_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `chain` |
| `faction` |
| `model` |
| `name` |
| `new` |
| `region` |
| `slot` |
| `superchain` |

## CAMPAIGN_AI_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `new` |
| `strategic_stance_between_factions` |
| `strategic_stance_between_factions_available` |
| `strategic_stance_between_factions_is_being_blocked` |
| `strategic_stance_between_factions_is_being_blocked_until` |
| `strategic_stance_between_factions_promotion_current_level` |
| `strategic_stance_between_factions_promotion_end_level` |
| `strategic_stance_between_factions_promotion_end_round` |
| `strategic_stance_between_factions_promotion_is_active` |
| `strategic_stance_between_factions_promotion_or_blocking_is_set` |
| `strategic_stance_between_factions_promotion_start_level` |
| `strategic_stance_between_factions_promotion_start_round` |

## CAMPAIGN_MISSION_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `model` |
| `new` |

## CAMPAIGN_POLITICS_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `get_current_politics_government_type` |
| `get_parties` |
| `government_type_key` |
| `new` |
| `state_changed` |

## CHARACTER_LIST_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `is_empty` |
| `item_at` |
| `new` |
| `num_items` |

## CHARACTER_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `action_points_per_turn` |
| `action_points_remaining_percent` |
| `age` |
| `battles_fought` |
| `battles_won` |
| `body_guard_casulties` |
| `character_type` |
| `cqi` |
| `defensive_ambush_battles_fought` |
| `defensive_ambush_battles_won` |
| `defensive_battles_fought` |
| `defensive_battles_won` |
| `defensive_naval_battles_fought` |
| `defensive_naval_battles_won` |
| `defensive_sieges_fought` |
| `defensive_sieges_won` |
| `display_position_x` |
| `display_position_y` |
| `faction` |
| `forename` |
| `fought_in_battle` |
| `garrison_residence` |
| `get_forename` |
| `get_political_party_id` |
| `get_surname` |
| `has_ancillary` |
| `has_garrison_residence` |
| `has_military_force` |
| `has_recruited_mercenaries` |
| `has_region` |
| `has_skill` |
| `has_spouse` |
| `has_trait` |
| `in_port` |
| `in_settlement` |
| `is_ambushing` |
| `is_besieging` |
| `is_blockading` |
| `is_carrying_troops` |
| `is_deployed` |
| `is_embedded_in_military_force` |
| `is_faction_leader` |
| `is_hidden` |
| `is_male` |
| `is_polititian` |
| `logical_position_x` |
| `logical_position_y` |
| `military_force` |
| `model` |
| `new` |
| `number_of_traits` |
| `offensive_ambush_battles_fought` |
| `offensive_ambush_battles_won` |
| `offensive_battles_fought` |
| `offensive_battles_won` |
| `offensive_naval_battles_fought` |
| `offensive_naval_battles_won` |
| `offensive_sieges_fought` |
| `offensive_sieges_won` |
| `percentage_of_own_alliance_killed` |
| `performed_action_this_turn` |
| `rank` |
| `region` |
| `routed_in_battle` |
| `spouse` |
| `surname` |
| `trait_level` |
| `trait_points` |
| `turns_at_sea` |
| `turns_in_enemy_regions` |
| `turns_in_own_regions` |
| `turns_without_battle_in_home_lands` |
| `won_battle` |

## FACTION_LIST_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `is_empty` |
| `item_at` |
| `new` |
| `num_items` |

## FACTION_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `allied_with` |
| `ancillary_exists` |
| `at_war` |
| `character_list` |
| `culture` |
| `difficulty_level` |
| `ended_war_this_turn` |
| `faction_attitudes` |
| `faction_leader` |
| `government_type` |
| `has_faction_leader` |
| `has_food_shortage` |
| `has_home_region` |
| `has_researched_all_technologies` |
| `has_technology` |
| `home_region` |
| `imperium_level` |
| `is_human` |
| `losing_money` |
| `military_force_list` |
| `model` |
| `name` |
| `new` |
| `num_allies` |
| `num_enemy_trespassing_armies` |
| `num_factions_in_war_with` |
| `num_generals` |
| `num_trade_agreements` |
| `politics` |
| `politics_party_add_loyalty_modifier` |
| `region_list` |
| `research_queue_idle` |
| `sea_trade_route_raided` |
| `started_war_this_turn` |
| `state_religion` |
| `subculture` |
| `tax_category` |
| `tax_level` |
| `total_food` |
| `trade_resource_exists` |
| `trade_route_limit_reached` |
| `trade_ship_not_in_trade_node` |
| `trade_value` |
| `trade_value_percent` |
| `treasury` |
| `treasury_percent` |
| `treaty_details` |
| `unused_international_trade_route` |
| `upkeep_expenditure_percent` |

## GAME

| Function Name |
| :--- |
| `add_agent_experience` |
| `add_attack_of_opportunity_overrides` |
| `add_building_model_override` |
| `add_circle_area_trigger` |
| `add_custom_battlefield` |
| `add_development_points_to_region` |
| `add_event_restricted_building_record` |
| `add_event_restricted_building_record_for_faction` |
| `add_event_restricted_unit_record` |
| `add_event_restricted_unit_record_for_faction` |
| `add_exclusion_zone` |
| `add_location_trigger` |
| `add_marker` |
| `add_outline_area_trigger` |
| `add_restricted_building_level_record` |
| `add_restricted_building_level_record_for_faction` |
| `add_settlement_model_override` |
| `add_time_trigger` |
| `add_unit_model_overrides` |
| `add_visibility_trigger` |
| `advance_to_next_campaign` |
| `allow_player_to_embark_navies` |
| `apply_effect_bundle` |
| `apply_effect_bundle_to_characters_force` |
| `apply_effect_bundle_to_force` |
| `attack` |
| `autosave_at_next_opportunity` |
| `award_experience_level` |
| `cai_strategic_stance_manager_block_all_stances_but_that_specified_towards_target_faction` |
| `cai_strategic_stance_manager_clear_all_blocking_between_factions` |
| `cai_strategic_stance_manager_clear_all_promotions_between_factions` |
| `cai_strategic_stance_manager_force_stance_update_between_factions` |
| `cai_strategic_stance_manager_promote_specified_stance_towards_target_faction` |
| `cai_strategic_stance_manager_promote_specified_stance_towards_target_faction_by_number` |
| `cai_strategic_stance_manager_set_stance_blocking_between_factions_for_a_given_stance` |
| `cai_strategic_stance_manager_set_stance_promotion_between_factions_for_a_given_stance` |
| `cancel_actions_for` |
| `cinematic` |
| `compare_localised_string` |
| `create_agent` |
| `create_force` |
| `disable_elections` |
| `disable_end_turn` |
| `disable_movement_for_ai_under_shroud` |
| `disable_movement_for_character` |
| `disable_movement_for_faction` |
| `disable_rebellions_worldwide` |
| `disable_saving_game` |
| `disable_shopping_for_ai_under_shroud` |
| `disable_shortcut` |
| `dismiss_advice` |
| `dismiss_advice_at_end_turn` |
| `display_turns` |
| `enable_auto_generated_missions` |
| `enable_movement_for_character` |
| `enable_movement_for_faction` |
| `enable_ui` |
| `end_turn` |
| `exempt_region_from_tax` |
| `force_add_ancillary` |
| `force_add_skill` |
| `force_add_trait` |
| `force_agent_action_success_for_human` |
| `force_assassination_success_for_human` |
| `force_change_cai_faction_personality` |
| `force_character_force_into_stance` |
| `force_declare_war` |
| `force_diplomacy` |
| `force_garrison_infiltration_success_for_human` |
| `force_make_peace` |
| `force_make_trade_agreement` |
| `force_make_vassal` |
| `force_rebellion_in_region` |
| `grant_faction_handover` |
| `grant_unit` |
| `hide_character` |
| `infect_force_with_plague` |
| `infect_region_with_plague` |
| `instant_set_building_health_percent` |
| `instantly_dismantle_building` |
| `instantly_repair_building` |
| `is_new_game` |
| `join_garrison` |
| `kill_character` |
| `leave_garrison` |
| `load_named_value` |
| `lock_technology` |
| `make_neighbouring_regions_seen_in_shroud` |
| `make_neighbouring_regions_visible_in_shroud` |
| `make_region_seen_in_shroud` |
| `make_region_visible_in_shroud` |
| `make_sea_region_seen_in_shroud` |
| `make_sea_region_visible_in_shroud` |
| `make_son_come_of_age` |
| `model` |
| `modify_next_autoresolve_battle` |
| `move_to` |
| `new` |
| `optional_extras_for_episodics` |
| `override_ui` |
| `pending_auto_show_messages` |
| `register_instant_movie` |
| `register_movies` |
| `register_outro_movie` |
| `remove_area_trigger` |
| `remove_attack_of_opportunity_overrides` |
| `remove_barrier` |
| `remove_building_model_override` |
| `remove_custom_battlefield` |
| `remove_effect_bundle` |
| `remove_effect_bundle_from_characters_force` |
| `remove_effect_bundle_from_force` |
| `remove_event_restricted_building_record` |
| `remove_event_restricted_building_record_for_faction` |
| `remove_event_restricted_unit_record` |
| `remove_event_restricted_unit_record_for_faction` |
| `remove_location_trigger` |
| `remove_marker` |
| `remove_restricted_building_level_record` |
| `remove_restricted_building_level_record_for_faction` |
| `remove_settlement_model_override` |
| `remove_time_trigger` |
| `remove_visibility_trigger` |
| `render_campaign_to_file` |
| `replenish_action_points` |
| `restore_shroud_from_snapshot` |
| `save_named_value` |
| `scroll_camera` |
| `scroll_camera_with_direction` |
| `seek_exchange` |
| `set_ai_uses_human_display_speed` |
| `set_campaign_ai_force_all_factions_boardering_human_vassals_to_have_invasion_behaviour` |
| `set_campaign_ai_force_all_factions_boardering_humans_to_have_invasion_behaviour` |
| `set_character_experience_disabled` |
| `set_character_skill_tier_limit` |
| `set_event_generation_enabled` |
| `set_general_offered_dilemma_permitted` |
| `set_ignore_end_of_turn_public_order` |
| `set_liberation_options_disabled` |
| `set_looting_options_disabled_for_human` |
| `set_map_bounds` |
| `set_non_scripted_ancillaries_disabled` |
| `set_non_scripted_traits_disabled` |
| `set_public_order_of_province_for_region` |
| `set_tax_disabled` |
| `set_tax_rate` |
| `set_technology_research_disabled` |
| `set_ui_notification_of_victory_disabled` |
| `set_zoom_limit` |
| `show_message_event` |
| `show_shroud` |
| `shown_message` |
| `speedup_active` |
| `steal_user_input` |
| `stop_camera` |
| `stop_user_input` |
| `take_shroud_snapshot` |
| `technology_osmosis_for_playables_enable_all` |
| `technology_osmosis_for_playables_enable_culture` |
| `toggle_speedup` |
| `transfer_region_to_faction` |
| `treasury_mod` |
| `trigger_custom_dilemma` |
| `trigger_custom_incident` |
| `trigger_custom_mission` |
| `unhide_character` |
| `win_next_autoresolve_battle` |
| `zero_action_points` |

## GARRISON_RESIDENCE_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `army` |
| `buildings` |
| `faction` |
| `has_army` |
| `has_navy` |
| `is_settlement` |
| `is_slot` |
| `is_under_siege` |
| `model` |
| `navy` |
| `new` |
| `region` |
| `settlement_interface` |
| `slot_interface` |
| `unit_count` |

## MILITARY_FORCE_LIST_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `is_empty` |
| `item_at` |
| `new` |
| `num_items` |

## MILITARY_FORCE_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `character_list` |
| `contains_mercenaries` |
| `faction` |
| `garrison_residence` |
| `general_character` |
| `has_garrison_residence` |
| `has_general` |
| `is_army` |
| `is_navy` |
| `model` |
| `new` |
| `unit_list` |
| `upkeep` |

## MODEL_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `campaign_ai` |
| `campaign_name` |
| `campaign_type` |
| `character_can_reach_character` |
| `date_and_week_in_range` |
| `date_in_range` |
| `difficulty_level` |
| `faction_is_local` |
| `is_multiplayer` |
| `is_player_turn` |
| `new` |
| `pending_battle` |
| `player_steam_id_is_odd` |
| `random_number` |
| `random_percent` |
| `season` |
| `turn_number` |
| `world` |

## NULL_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `new` |

## PENDING_BATTLE_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `ambush_battle` |
| `attacker` |
| `attacker_battle_result` |
| `attacker_commander_fought_in_battle` |
| `attacker_commander_fought_in_melee` |
| `attacker_is_stronger` |
| `battle_type` |
| `contested_garrison` |
| `defender` |
| `defender_battle_result` |
| `defender_commander_fought_in_battle` |
| `defender_commander_fought_in_melee` |
| `failed_ambush_battle` |
| `has_attacker` |
| `has_contested_garrison` |
| `has_defender` |
| `is_active` |
| `model` |
| `naval_battle` |
| `new` |
| `night_battle` |
| `percentage_of_attacker_killed` |
| `percentage_of_attacker_routed` |
| `percentage_of_defender_killed` |
| `percentage_of_defender_routed` |
| `seige_battle` |

## REGION_LIST_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `is_empty` |
| `item_at` |
| `new` |
| `num_items` |

## REGION_MANAGER_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `faction_region_list` |
| `model` |
| `new` |
| `region_by_key` |
| `region_list` |
| `resource_exists_anywhere` |
| `settlement_by_key` |
| `slot_by_key` |

## REGION_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `adjacent_region_list` |
| `building_exists` |
| `building_superchain_exists` |
| `garrison_residence` |
| `last_building_constructed_key` |
| `majority_religion` |
| `model` |
| `name` |
| `new` |
| `num_buildings` |
| `owning_faction` |
| `province_name` |
| `public_order` |
| `region_wealth` |
| `region_wealth_change_percent` |
| `resource_exists` |
| `sanitation` |
| `settlement` |
| `slot_list` |
| `slot_type_exists` |
| `squalor` |
| `tax_income` |
| `town_wealth_growth` |

## SETTLEMENT_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `castle_slot` |
| `commander` |
| `display_position_x` |
| `display_position_y` |
| `faction` |
| `has_castle_slot` |
| `has_commander` |
| `logical_position_x` |
| `logical_position_y` |
| `model` |
| `new` |
| `region` |
| `slot_list` |

## SLOT_LIST_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `buliding_type_exists` |
| `is_empty` |
| `item_at` |
| `new` |
| `num_items` |
| `slot_type_exists` |

## SLOT_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `building` |
| `faction` |
| `has_building` |
| `model` |
| `name` |
| `new` |
| `region` |
| `type` |

## UIComponent

| Function Name |
| :--- |
| `Address` |
| `Adopt` |
| `AttachCustomControl` |
| `Bounds` |
| `CallbackId` |
| `ChildCount` |
| `CurrentAnimationId` |
| `CurrentState` |
| `CurrentStateUI` |
| `DestroyChildren` |
| `Dimensions` |
| `Divorce` |
| `DockingPoint` |
| `Find` |
| `FindPositionIntoCurrentText` |
| `FindTextSnapPosition` |
| `ForceEvent` |
| `GetProperty` |
| `GetStateText` |
| `GetStateTextDetails` |
| `GetTooltipText` |
| `GlobalExists` |
| `HasInterface` |
| `Height` |
| `Highlight` |
| `Id` |
| `InterfaceFunction` |
| `IsCharPrintable` |
| `IsDragged` |
| `IsInteractive` |
| `IsMouseOverChildren` |
| `IsMoveable` |
| `Layout` |
| `LockPriority` |
| `LuaCall` |
| `MoveTo` |
| `Parent` |
| `PopulateTextures` |
| `Position` |
| `Priority` |
| `PropagateImageColour` |
| `PropagateOpacity` |
| `PropagatePriority` |
| `PropagateVisibility` |
| `ReorderChildren` |
| `Resize` |
| `RestoreUIHeirarchy` |
| `RunScript` |
| `SaveUIHeirarchy` |
| `SequentialFind` |
| `SetDisabled` |
| `SetDockingPoint` |
| `SetDragged` |
| `SetEventCallback` |
| `SetGlobal` |
| `SetImageColour` |
| `SetImageRotation` |
| `SetInteractive` |
| `SetMoveable` |
| `SetOpacity` |
| `SetProperty` |
| `SetState` |
| `SetStateColours` |
| `SetStateText` |
| `SetStateTextDetails` |
| `SetStateTextXOffset` |
| `SetTooltipText` |
| `SetVisible` |
| `ShaderTechniqueGet` |
| `ShaderTechniqueSet` |
| `ShaderVarsGet` |
| `ShaderVarsSet` |
| `SimulateClick` |
| `SimulateKey` |
| `StealInputFocus` |
| `StealShortcutKey` |
| `TextDimensions` |
| `TextShaderTechniqueSet` |
| `TextShaderVarsGet` |
| `TextShaderVarsSet` |
| `TriggerAnimation` |
| `TriggerShortcut` |
| `UnLockPriority` |
| `Visible` |
| `Width` |
| `WidthOfTextLine` |
| `new` |

## UNIT_LIST_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `has_unit` |
| `is_empty` |
| `item_at` |
| `new` |
| `num_items` |

## UNIT_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `faction` |
| `force_commander` |
| `has_force_commander` |
| `has_unit_commander` |
| `is_land_unit` |
| `is_naval_unit` |
| `military_force` |
| `model` |
| `new` |
| `percentage_proportion_of_full_strength` |
| `unit_category` |
| `unit_class` |
| `unit_commander` |
| `unit_key` |

## WORLD_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `ancillary_exists` |
| `faction_by_key` |
| `faction_exists` |
| `faction_list` |
| `model` |
| `new` |
| `region_manager` |

