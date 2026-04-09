# Attila API Reference

This is an automated API reference generated from the engine dump logs for Attila.

## Table of Contents
- [BUILDING_LIST_SCRIPT_INTERFACE](#building-list-script-interface)
- [BUILDING_SCRIPT_INTERFACE](#building-script-interface)
- [CAMPAIGN_AI_SCRIPT_INTERFACE](#campaign-ai-script-interface)
- [CAMPAIGN_MISSION_SCRIPT_INTERFACE](#campaign-mission-script-interface)
- [CHARACTER_LIST_SCRIPT_INTERFACE](#character-list-script-interface)
- [CHARACTER_SCRIPT_INTERFACE](#character-script-interface)
- [FACTION_LIST_SCRIPT_INTERFACE](#faction-list-script-interface)
- [FACTION_SCRIPT_INTERFACE](#faction-script-interface)
- [FAMILY_MEMBER_SCRIPT_INTERFACE](#family-member-script-interface)
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
| `is_null_interface` |
| `model` |
| `name` |
| `new` |
| `percent_health` |
| `region` |
| `slot` |
| `superchain` |

## CAMPAIGN_AI_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `is_null_interface` |
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
| `faction` |
| `is_null_interface` |
| `mission_issuer_record_key` |
| `mission_record_key` |
| `model` |
| `new` |

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
| `command_queue_index` |
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
| `family_member` |
| `father` |
| `forename` |
| `fought_in_battle` |
| `garrison_residence` |
| `get_forename` |
| `get_surname` |
| `gravitas` |
| `has_ancillary` |
| `has_father` |
| `has_garrison_residence` |
| `has_military_force` |
| `has_mother` |
| `has_recruited_mercenaries` |
| `has_region` |
| `has_skill` |
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
| `is_null_interface` |
| `is_politician` |
| `logical_position_x` |
| `logical_position_y` |
| `loyalty` |
| `military_force` |
| `model` |
| `mother` |
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
| `surname` |
| `trait_level` |
| `trait_points` |
| `turns_at_sea` |
| `turns_in_enemy_regions` |
| `turns_in_own_regions` |
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
| `at_war_with` |
| `character_list` |
| `command_queue_index` |
| `culture` |
| `ended_war_this_turn` |
| `faction_leader` |
| `has_faction_leader` |
| `has_food_shortage` |
| `has_home_region` |
| `has_technology` |
| `home_region` |
| `imperium_level` |
| `is_horde` |
| `is_human` |
| `is_null_interface` |
| `is_trading_with` |
| `losing_money` |
| `military_force_list` |
| `model` |
| `name` |
| `new` |
| `num_allies` |
| `num_generals` |
| `region_list` |
| `research_queue_idle` |
| `sea_trade_route_raided` |
| `started_war_this_turn` |
| `state_religion` |
| `state_religion_percentage` |
| `subculture` |
| `tax_level` |
| `trade_resource_exists` |
| `trade_route_limit_reached` |
| `trade_ship_not_in_trade_node` |
| `trade_value` |
| `trade_value_percent` |
| `treasury` |
| `treasury_percent` |
| `unused_international_trade_route` |
| `upkeep_expenditure_percent` |

## FAMILY_MEMBER_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `come_of_age` |
| `father` |
| `has_father` |
| `has_mother` |
| `has_trait` |
| `is_null_interface` |
| `mother` |
| `new` |

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
| `add_prestige` |
| `add_restricted_building_level_record` |
| `add_restricted_building_level_record_for_faction` |
| `add_settlement_model_override` |
| `add_time_trigger` |
| `add_unit_model_overrides` |
| `add_unit_to_force` |
| `add_visibility_trigger` |
| `advance_to_next_campaign` |
| `allow_player_to_embark_navies` |
| `apply_effect_bundle` |
| `apply_effect_bundle_to_characters_force` |
| `apply_effect_bundle_to_force` |
| `apply_effect_bundle_to_region` |
| `appoint_character_to_most_expensive_force` |
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
| `cancel_custom_mission` |
| `compare_localised_string` |
| `create_agent` |
| `create_force` |
| `disable_elections` |
| `disable_end_turn` |
| `disable_movement_for_ai_under_shroud` |
| `disable_movement_for_character` |
| `disable_movement_for_faction` |
| `disable_pathfinding_restriction` |
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
| `faction_offers_peace_to_other_faction` |
| `fade_volume` |
| `force_add_ancillary` |
| `force_add_skill` |
| `force_add_trait` |
| `force_agent_action_success_for_human` |
| `force_assassination_success_for_human` |
| `force_break_alliance` |
| `force_break_defensive_alliance` |
| `force_break_military_alliance` |
| `force_break_non_aggression_pact` |
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
| `override_attacker_win_chance_prediction` |
| `override_mission_succeeded_status` |
| `override_ui` |
| `pending_auto_show_messages` |
| `play_movie_in_ui` |
| `play_sound` |
| `register_instant_movie` |
| `register_movies` |
| `register_outro_movie` |
| `remove_area_trigger` |
| `remove_attack_of_opportunity_overrides` |
| `remove_building_model_override` |
| `remove_custom_battlefield` |
| `remove_effect_bundle` |
| `remove_effect_bundle_from_characters_force` |
| `remove_effect_bundle_from_force` |
| `remove_effect_bundle_from_region` |
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
| `set_character_immortality` |
| `set_character_skill_tier_limit` |
| `set_event_generation_enabled` |
| `set_faction_name_override` |
| `set_faction_summary_override` |
| `set_general_offered_dilemma_permitted` |
| `set_ignore_end_of_turn_public_order` |
| `set_imperium_level_change_disabled` |
| `set_liberation_options_disabled` |
| `set_looting_options_disabled_for_human` |
| `set_non_scripted_ancillaries_disabled` |
| `set_non_scripted_traits_disabled` |
| `set_only_allow_basic_recruit_stance` |
| `set_public_order_disabled_for_province_for_region` |
| `set_public_order_of_province_for_region` |
| `set_region_abandoned` |
| `set_tax_disabled` |
| `set_tax_rate` |
| `set_technology_research_disabled` |
| `set_ui_notification_of_victory_disabled` |
| `set_volume` |
| `set_zoom_limit` |
| `show_message_event` |
| `show_message_event_located` |
| `show_shroud` |
| `shown_message` |
| `shutdown` |
| `spawn_character_into_family_tree` |
| `speedup_active` |
| `steal_user_input` |
| `stop_camera` |
| `stop_sound` |
| `stop_user_input` |
| `take_shroud_snapshot` |
| `technology_osmosis_for_playables_enable_all` |
| `technology_osmosis_for_playables_enable_culture` |
| `toggle_speedup` |
| `transfer_region_to_faction` |
| `treasury_mod` |
| `trigger_custom_dilemma` |
| `trigger_custom_mission` |
| `trigger_dilemma` |
| `trigger_incident` |
| `trigger_mission` |
| `unhide_character` |
| `unlock_technology` |
| `win_next_autoresolve_battle` |
| `zero_action_points` |

## GARRISON_RESIDENCE_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `army` |
| `buildings` |
| `can_assault` |
| `faction` |
| `has_army` |
| `has_navy` |
| `is_null_interface` |
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
| `active_stance` |
| `building_exists` |
| `buildings` |
| `can_activate_stance` |
| `character_list` |
| `command_queue_index` |
| `contains_mercenaries` |
| `faction` |
| `garrison_residence` |
| `general_character` |
| `has_garrison_residence` |
| `has_general` |
| `is_army` |
| `is_horde` |
| `is_navy` |
| `is_null_interface` |
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
| `character_for_command_queue_index` |
| `date_and_week_in_range` |
| `date_in_range` |
| `difficulty_level` |
| `faction_for_command_queue_index` |
| `faction_is_local` |
| `has_character_command_queue_index` |
| `has_faction_command_queue_index` |
| `has_military_force_command_queue_index` |
| `is_multiplayer` |
| `is_null_interface` |
| `is_player_turn` |
| `military_force_for_command_queue_index` |
| `new` |
| `pending_battle` |
| `player_steam_id_is_odd` |
| `random_percent` |
| `season` |
| `turn_number` |
| `world` |

## NULL_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `is_null_interface` |
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
| `attacker_strength` |
| `battle_type` |
| `contested_garrison` |
| `defender` |
| `defender_battle_result` |
| `defender_commander_fought_in_battle` |
| `defender_commander_fought_in_melee` |
| `defender_strength` |
| `failed_ambush_battle` |
| `has_attacker` |
| `has_contested_garrison` |
| `has_defender` |
| `is_active` |
| `is_null_interface` |
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
| `is_null_interface` |
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
| `governor` |
| `has_governor` |
| `is_null_interface` |
| `last_building_constructed_key` |
| `majority_religion` |
| `majority_religion_percentage` |
| `model` |
| `name` |
| `new` |
| `num_buildings` |
| `owning_faction` |
| `public_order` |
| `region_wealth_change_percent` |
| `resource_exists` |
| `sanitation` |
| `settlement` |
| `slot_list` |
| `slot_type_exists` |
| `squalor` |
| `town_wealth_growth` |

## SETTLEMENT_SCRIPT_INTERFACE

| Function Name |
| :--- |
| `commander` |
| `display_position_x` |
| `display_position_y` |
| `faction` |
| `has_commander` |
| `is_null_interface` |
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
| `is_null_interface` |
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
| `ClearSound` |
| `CreateComponent` |
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
| `Opacity` |
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
| `SetTooltipTextWithRLSKey` |
| `SetVisible` |
| `ShaderTechniqueGet` |
| `ShaderTechniqueSet` |
| `ShaderVarsGet` |
| `ShaderVarsSet` |
| `SimulateClick` |
| `SimulateKey` |
| `SimulateLClick` |
| `SimulateMouseMove` |
| `SimulateMouseOff` |
| `SimulateMouseOn` |
| `SimulateRClick` |
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
| `can_upgrade_unit` |
| `can_upgrade_unit_equipment` |
| `faction` |
| `force_commander` |
| `has_force_commander` |
| `has_unit_commander` |
| `is_land_unit` |
| `is_naval_unit` |
| `is_null_interface` |
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
| `climate_phase_index` |
| `faction_by_key` |
| `faction_exists` |
| `faction_list` |
| `is_null_interface` |
| `model` |
| `new` |
| `region_manager` |

