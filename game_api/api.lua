---@meta

---@class battle_manager
local battle_manager = {}

function battle_manager:__index() end
function battle_manager:__tostring() end
function battle_manager:__type() end

function battle_manager:new(battle_obj) end
function battle_manager:advice_cease() end
function battle_manager:advice_resume() end
function battle_manager:callback() end
function battle_manager:check_rout_manager() end
function battle_manager:check_watch_entry() end
function battle_manager:clear_watches_and_callbacks() end
function battle_manager:dont_close_queue_advice() end
function battle_manager:end_battle() end
function battle_manager:end_deployment() end
function battle_manager:get_next_watch_entry() end
function battle_manager:out() end
function battle_manager:play_next_advice() end
function battle_manager:print_callback_list() end
function battle_manager:print_watch_list() end
function battle_manager:process_results() end
function battle_manager:queue_advisor() end
function battle_manager:register_esc_key_callback() end
function battle_manager:register_phase_change_callback() end
function battle_manager:register_repeating_timer() end
function battle_manager:register_results_callbacks() end
function battle_manager:register_singleshot_timer() end
function battle_manager:register_victory_countdown_callback() end
function battle_manager:release_escape_key() end
function battle_manager:remove_process() end
function battle_manager:remove_process_from_callback_list() end
function battle_manager:remove_process_from_watch_list() end
function battle_manager:repeat_callback() end
function battle_manager:rout_threshold_reached() end
function battle_manager:set_load_balancing() end
function battle_manager:setup_battle() end
function battle_manager:setup_victory_callback() end
function battle_manager:start_rout_manager() end
function battle_manager:steal_escape_key() end
function battle_manager:stop_advice_on_battle_end() end
function battle_manager:stop_advisor_queue() end
function battle_manager:stop_rout_manager() end
function battle_manager:tick_watch_counter() end
function battle_manager:unlock_achievement() end
function battle_manager:unregister_esc_key_callback() end
function battle_manager:unregister_timer() end
function battle_manager:watch() end
function battle_manager:watch_advice_queue() end

-- Newly added from second dump
function battle_manager:add_ping_icon() end
function battle_manager:advice_finished() end
---@return battle.alliances
function battle_manager:alliances() end
function battle_manager:assault_equipment() end
function battle_manager:buildings() end
function battle_manager:camera() end
function battle_manager:change_conflict_time_update_overridden() end
function battle_manager:change_victory_countdown_limit() end
function battle_manager:cindy_playback() end
function battle_manager:cindy_playback_no_camera() end
function battle_manager:close_advisor() end
function battle_manager:create_ui_attack_group() end
function battle_manager:create_ui_defend_group() end
function battle_manager:debug_drawing() end
function battle_manager:disable_shortcut() end
function battle_manager:enable_cinematic_camera() end
function battle_manager:enable_cinematic_ui() end
function battle_manager:enable_tooltips() end
function battle_manager:end_benchmark() end
function battle_manager:end_current_battle_phase() end
function battle_manager:error() end
function battle_manager:fade_volume() end
function battle_manager:get_volume() end
function battle_manager:highlight_component() end
function battle_manager:is_battle_over() end
function battle_manager:is_benchmarking_mode() end
function battle_manager:is_movie_playing() end
function battle_manager:is_music_playing() end
function battle_manager:local_alliance() end
function battle_manager:local_army() end
function battle_manager:modify_battle_speed() end
function battle_manager:place_naval_mine() end
function battle_manager:play_movie() end
function battle_manager:play_music() end
function battle_manager:play_music_custom_fade() end
function battle_manager:random_number() end
function battle_manager:register_battle_phase_handler() end
function battle_manager:register_command_handler() end
function battle_manager:register_input_handler() end
function battle_manager:register_unit_selection_handler() end
function battle_manager:release_input_focus() end
function battle_manager:remaining_conflict_time() end
function battle_manager:remove_ping_icon() end
function battle_manager:restore_battle_speed() end
function battle_manager:set_banners_enabled() end
function battle_manager:set_music_auto_playback() end
function battle_manager:set_music_loop() end
function battle_manager:set_volume() end
function battle_manager:show_objective() end
function battle_manager:start_lighting_environment_cross_fade() end
function battle_manager:start_terrain_effect() end
function battle_manager:steal_input_focus() end
function battle_manager:stop_cindy_playback() end
function battle_manager:stop_cindy_playback_no_camera() end
function battle_manager:stop_music() end
function battle_manager:stop_music_custom_fade() end
function battle_manager:stop_terrain_effect() end
function battle_manager:subtitles() end
function battle_manager:suppress_unit_musicians() end
function battle_manager:suppress_unit_voices() end
function battle_manager:suspend_contextual_advice() end
function battle_manager:trigger_projectile_launch() end
function battle_manager:ui_component() end
function battle_manager:unregister_battle_phase_handler() end
function battle_manager:unregister_command_handler() end
function battle_manager:unregister_input_handler() end
function battle_manager:unregister_unit_selection_handler() end
function battle_manager:vo_finished() end
function battle_manager:weather() end


---@class battle.alliances
local alliances = {}

function alliances:new() end
function alliances:count() end
---@return battle.alliance
function alliances:item(index) end

---@class battle.alliance
local alliance = {}

function alliance:new() end
---@return battle.armies
function alliance:armies() end
function alliance:create_ai_unit_planner() end
function alliance:force_ai_plan_type_attack() end
function alliance:force_ai_plan_type_defend() end
function alliance:force_snap_ai_to_hint_lines() end

---@class battle.armies
local armies = {}

function armies:new() end
function armies:count() end

---@return battle.army
function armies:item(index) end

---@class battle.army
local army = {}

function army:new() end
function army:army_handicap() end
function army:change_faction() end
---@return battle.unit_controller
function army:create_unit_controller() end
function army:enable_army_destruction_morale_effect() end
function army:get_reinforcement_ships() end
---@return battle.units
function army:get_reinforcement_units() end
function army:is_commander_alive() end
function army:is_commander_invincible() end
function army:quit_battle() end
function army:ships() end
---@return battle.units
function army:units() end

---@class battle.units
local units = {}

function units:new() end
---@return number
function units:count() end
function units:kill_commander() end
function units:mountable_artillery_item() end

---@return battle.unit
function units:item(index) end

---@class battle.unit
local unit = {}

function unit:new() end
function unit:ammo_left() end
function unit:bearing() end
function unit:can_perform_special_ability() end
function unit:current_special_ability() end

---Prevents or allows the unit to deploy as a reinforcement.
---If set to false, and the unit has not yet entered the battlefield,
---the unit will not be able to deploy until called again with true.
---Has no effect if the unit is not part of a reinforcement army.
--- NOT WORKING?!
---@param can_deploy boolean Whether the unit can deploy
function unit:deploy_reinforcement(can_deploy) end
function unit:has_ships() end
function unit:initial_number_of_men() end
function unit:is_artillery() end
function unit:is_behaviour_active() end
function unit:is_cavalry() end
function unit:is_currently_garrisoned() end
function unit:is_dismounted_ships() end
function unit:is_hidden() end
function unit:is_idle() end
function unit:is_infantry() end
function unit:is_leaving_battle() end
function unit:is_limbered_artillery() end
function unit:is_moving() end
function unit:is_moving_fast() end
function unit:is_routing() end
function unit:is_shattered() end
function unit:is_under_missile_attack() end
function unit:is_valid_target() end
function unit:is_visible_to_alliance() end
function unit:kill_number_of_men() end
function unit:missile_range() end
function unit:name() end
function unit:number_of_enemies_killed() end
function unit:number_of_men_alive() end
function unit:ordered_position() end
function unit:ordered_width() end
function unit:play_anim_for_captain() end
---@return battle_vector
function unit:position() end
function unit:position_of_officer() end
function unit:set_current_ammo_unary() end
function unit:starting_ammo() end
function unit:trigger_sound_charge() end
function unit:trigger_sound_taunt() end
function unit:trigger_sound_warcry() end
function unit:type() end
function unit:unary_of_men_alive() end
function unit:unit_distance() end
function unit:unit_in_range() end

---@class battle.unit_controller
local unit_controller = {}

function unit_controller:new() end
function unit_controller:add_all_units() end
function unit_controller:add_group() end
---@param ... battle.unit  # one or more units
function unit_controller:add_units(...) end
function unit_controller:attack_building() end
function unit_controller:attack_building_q() end
function unit_controller:attack_line() end
function unit_controller:attack_line_q() end
function unit_controller:attack_location() end
function unit_controller:attack_location_q() end
function unit_controller:attack_unit() end
function unit_controller:attack_unit_q() end
function unit_controller:change_behaviour_active() end
function unit_controller:change_current_walk_speed() end
function unit_controller:change_enabled() end
function unit_controller:change_fatigue_amount() end
function unit_controller:change_group_formation() end
function unit_controller:change_group_formation_q() end
function unit_controller:change_move_speed() end
function unit_controller:change_shot_type() end
function unit_controller:change_shot_type_q() end
function unit_controller:clear_all() end
function unit_controller:climb_building() end
function unit_controller:climb_building_q() end
function unit_controller:decrement_formation_width() end
function unit_controller:defend_building() end
function unit_controller:defend_building_q() end
function unit_controller:fire_at_will() end
---Orders the units in this unit_controller to move to a supplied location.
---No facing or width is specified.
---@param position battle_vector The target position to move to
---@param move_fast boolean|nil Optional. If true, units move fast. Default is false.
function unit_controller:goto_location(position, move_fast) end
function unit_controller:goto_location_angle_width() end
function unit_controller:goto_location_angle_width_q() end
function unit_controller:goto_location_q() end
function unit_controller:halt() end
function unit_controller:hide_unit_card() end
function unit_controller:highlight() end
function unit_controller:increment_formation_width() end
function unit_controller:interact_with_deployable() end
function unit_controller:interact_with_deployable_q() end
function unit_controller:kill() end
function unit_controller:leave_building() end
function unit_controller:melee() end
function unit_controller:morale_behavior_default() end
function unit_controller:morale_behavior_fearless() end
function unit_controller:morale_behavior_rout() end
function unit_controller:occupy_vehicle() end
function unit_controller:occupy_vehicle_q() end
function unit_controller:occupy_zone() end
function unit_controller:occupy_zone_q() end
function unit_controller:perform_special_ability() end
function unit_controller:perform_special_ability_q() end
function unit_controller:release_control() end
function unit_controller:rotate() end
function unit_controller:rotate_q() end
function unit_controller:select_deployable_object() end
function unit_controller:set_always_visible_to_all() end
function unit_controller:set_invincible() end
function unit_controller:set_invisible_to_all() end
function unit_controller:start_celebrating() end
function unit_controller:start_taunting() end
function unit_controller:step_backward() end
function unit_controller:step_forward() end
function unit_controller:take_control() end
---Instructs the script_unit to teleport to a location.
---@param position battle_vector Position to teleport to
---@param bearing number Bearing to face at the target position in degrees
---@param width number Width in meters of the formation at the target position
function unit_controller:teleport_to_location(position, bearing, width) end
function unit_controller:trigger_sound_vo() end
function unit_controller:update_card_existance_on_HUD() end
function unit_controller:withdraw() end
function unit_controller:withdraw_q() end

---@class battle_vector
local battle_vector = {}

function battle_vector:new() end
function battle_vector:distance() end
function battle_vector:distance_xz() end
function battle_vector:get_x() end
function battle_vector:get_y() end
function battle_vector:get_z() end
function battle_vector:length() end
function battle_vector:length_xz() end
function battle_vector:set() end
function battle_vector:set_x() end
function battle_vector:set_y() end
function battle_vector:set_z() end

---@class BUILDING_LIST_SCRIPT_INTERFACE
local BUILDING_LIST_SCRIPT_INTERFACE = {}
---@return boolean
function BUILDING_LIST_SCRIPT_INTERFACE:is_empty() end
---@return BUILDING_SCRIPT_INTERFACE
function BUILDING_LIST_SCRIPT_INTERFACE:item_at() end
function BUILDING_LIST_SCRIPT_INTERFACE:new() end
---@return number
function BUILDING_LIST_SCRIPT_INTERFACE:num_items() end

---@class BUILDING_SCRIPT_INTERFACE
local BUILDING_SCRIPT_INTERFACE = {}
---@return string
function BUILDING_SCRIPT_INTERFACE:chain() end
---@return FACTION_SCRIPT_INTERFACE
function BUILDING_SCRIPT_INTERFACE:faction() end
function BUILDING_SCRIPT_INTERFACE:model() end
---@return string
function BUILDING_SCRIPT_INTERFACE:name() end
function BUILDING_SCRIPT_INTERFACE:new() end
function BUILDING_SCRIPT_INTERFACE:region() end
function BUILDING_SCRIPT_INTERFACE:slot() end
function BUILDING_SCRIPT_INTERFACE:superchain() end

---@class CAMPAIGN_AI_SCRIPT_INTERFACE
local CAMPAIGN_AI_SCRIPT_INTERFACE = {}
function CAMPAIGN_AI_SCRIPT_INTERFACE:new() end
function CAMPAIGN_AI_SCRIPT_INTERFACE:strategic_stance_between_factions() end
function CAMPAIGN_AI_SCRIPT_INTERFACE:strategic_stance_between_factions_available() end
function CAMPAIGN_AI_SCRIPT_INTERFACE:strategic_stance_between_factions_is_being_blocked() end
function CAMPAIGN_AI_SCRIPT_INTERFACE:strategic_stance_between_factions_is_being_blocked_until() end
function CAMPAIGN_AI_SCRIPT_INTERFACE:strategic_stance_between_factions_promotion_current_level() end
function CAMPAIGN_AI_SCRIPT_INTERFACE:strategic_stance_between_factions_promotion_end_level() end
function CAMPAIGN_AI_SCRIPT_INTERFACE:strategic_stance_between_factions_promotion_end_round() end
function CAMPAIGN_AI_SCRIPT_INTERFACE:strategic_stance_between_factions_promotion_is_active() end
function CAMPAIGN_AI_SCRIPT_INTERFACE:strategic_stance_between_factions_promotion_or_blocking_is_set() end
function CAMPAIGN_AI_SCRIPT_INTERFACE:strategic_stance_between_factions_promotion_start_level() end
function CAMPAIGN_AI_SCRIPT_INTERFACE:strategic_stance_between_factions_promotion_start_round() end

---@class CAMPAIGN_MISSION_SCRIPT_INTERFACE
local CAMPAIGN_MISSION_SCRIPT_INTERFACE = {}
function CAMPAIGN_MISSION_SCRIPT_INTERFACE:model() end
function CAMPAIGN_MISSION_SCRIPT_INTERFACE:new() end

---@class CAMPAIGN_POLITICS_SCRIPT_INTERFACE
local CAMPAIGN_POLITICS_SCRIPT_INTERFACE = {}
function CAMPAIGN_POLITICS_SCRIPT_INTERFACE:get_current_politics_government_type() end
function CAMPAIGN_POLITICS_SCRIPT_INTERFACE:get_parties() end
function CAMPAIGN_POLITICS_SCRIPT_INTERFACE:government_type_key() end
function CAMPAIGN_POLITICS_SCRIPT_INTERFACE:new() end
function CAMPAIGN_POLITICS_SCRIPT_INTERFACE:state_changed() end

---@class CHARACTER_LIST_SCRIPT_INTERFACE
local CHARACTER_LIST_SCRIPT_INTERFACE = {}
---@return boolean
function CHARACTER_LIST_SCRIPT_INTERFACE:is_empty() end
---@return CHARACTER_SCRIPT_INTERFACE
function CHARACTER_LIST_SCRIPT_INTERFACE:item_at() end
function CHARACTER_LIST_SCRIPT_INTERFACE:new() end
---@return number
function CHARACTER_LIST_SCRIPT_INTERFACE:num_items() end

---@class CHARACTER_SCRIPT_INTERFACE
local CHARACTER_SCRIPT_INTERFACE = {}
---@return number
function CHARACTER_SCRIPT_INTERFACE:action_points_per_turn() end
---@return number
function CHARACTER_SCRIPT_INTERFACE:action_points_remaining_percent() end
---@return number
function CHARACTER_SCRIPT_INTERFACE:age() end
---@return number
function CHARACTER_SCRIPT_INTERFACE:battles_fought() end
---@return number
function CHARACTER_SCRIPT_INTERFACE:battles_won() end
function CHARACTER_SCRIPT_INTERFACE:body_guard_casulties() end
--- Return true/false if character is of the given type.
---@param agent_type string agent type (general,colonel,spy...)
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:character_type(agent_type) end
---@return string
function CHARACTER_SCRIPT_INTERFACE:cqi() end
function CHARACTER_SCRIPT_INTERFACE:defensive_ambush_battles_fought() end
function CHARACTER_SCRIPT_INTERFACE:defensive_ambush_battles_won() end
function CHARACTER_SCRIPT_INTERFACE:defensive_battles_fought() end
function CHARACTER_SCRIPT_INTERFACE:defensive_battles_won() end
function CHARACTER_SCRIPT_INTERFACE:defensive_naval_battles_fought() end
function CHARACTER_SCRIPT_INTERFACE:defensive_naval_battles_won() end
function CHARACTER_SCRIPT_INTERFACE:defensive_sieges_fought() end
function CHARACTER_SCRIPT_INTERFACE:defensive_sieges_won() end
---@return number
function CHARACTER_SCRIPT_INTERFACE:display_position_x() end
---@return number
function CHARACTER_SCRIPT_INTERFACE:display_position_y() end
---@return FACTION_SCRIPT_INTERFACE
function CHARACTER_SCRIPT_INTERFACE:faction() end
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:forename() end
function CHARACTER_SCRIPT_INTERFACE:fought_in_battle() end
---@return GARRISON_RESIDENCE_SCRIPT_INTERFACE
function CHARACTER_SCRIPT_INTERFACE:garrison_residence() end
---@return string
function CHARACTER_SCRIPT_INTERFACE:get_forename() end
function CHARACTER_SCRIPT_INTERFACE:get_political_party_id() end
---@return string
function CHARACTER_SCRIPT_INTERFACE:get_surname() end
---@param anciliary string
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:has_ancillary(anciliary) end
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:has_garrison_residence() end
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:has_military_force() end
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:has_recruited_mercenaries() end
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:has_region() end
---@param skill string
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:has_skill(skill) end
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:has_spouse() end
---@param trait string
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:has_trait(trait) end
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:in_port() end
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:in_settlement() end
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:is_ambushing() end
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:is_besieging() end
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:is_blockading() end
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:is_carrying_troops() end
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:is_deployed() end
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:is_embedded_in_military_force() end
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:is_faction_leader() end
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:is_hidden() end
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:is_male() end
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:is_polititian() end
---@return number
function CHARACTER_SCRIPT_INTERFACE:logical_position_x() end
---@return number
function CHARACTER_SCRIPT_INTERFACE:logical_position_y() end
---@return MILITARY_FORCE_SCRIPT_INTERFACE
function CHARACTER_SCRIPT_INTERFACE:military_force() end
function CHARACTER_SCRIPT_INTERFACE:model() end
function CHARACTER_SCRIPT_INTERFACE:new() end
---@return number
function CHARACTER_SCRIPT_INTERFACE:number_of_traits() end
function CHARACTER_SCRIPT_INTERFACE:offensive_ambush_battles_fought() end
function CHARACTER_SCRIPT_INTERFACE:offensive_ambush_battles_won() end
function CHARACTER_SCRIPT_INTERFACE:offensive_battles_fought() end
function CHARACTER_SCRIPT_INTERFACE:offensive_battles_won() end
function CHARACTER_SCRIPT_INTERFACE:offensive_naval_battles_fought() end
function CHARACTER_SCRIPT_INTERFACE:offensive_naval_battles_won() end
function CHARACTER_SCRIPT_INTERFACE:offensive_sieges_fought() end
function CHARACTER_SCRIPT_INTERFACE:offensive_sieges_won() end
function CHARACTER_SCRIPT_INTERFACE:percentage_of_own_alliance_killed() end
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:performed_action_this_turn() end
function CHARACTER_SCRIPT_INTERFACE:rank() end
---@return REGION_SCRIPT_INTERFACE
function CHARACTER_SCRIPT_INTERFACE:region() end
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:routed_in_battle() end
function CHARACTER_SCRIPT_INTERFACE:spouse() end
function CHARACTER_SCRIPT_INTERFACE:surname() end
function CHARACTER_SCRIPT_INTERFACE:trait_level() end
function CHARACTER_SCRIPT_INTERFACE:trait_points() end
function CHARACTER_SCRIPT_INTERFACE:turns_at_sea() end
function CHARACTER_SCRIPT_INTERFACE:turns_in_enemy_regions() end
function CHARACTER_SCRIPT_INTERFACE:turns_in_own_regions() end
function CHARACTER_SCRIPT_INTERFACE:turns_without_battle_in_home_lands() end
---@return boolean
function CHARACTER_SCRIPT_INTERFACE:won_battle() end

---@class CampaignCharacter
local CampaignCharacter = {}
function CampaignCharacter:ActionPointsRatio() end
function CampaignCharacter:Release() end
function CampaignCharacter:new() end

---@class CampaignSettlement
local CampaignSettlement = {}
function CampaignSettlement:LabelDetails() end
function CampaignSettlement:ListDetails() end
function CampaignSettlement:Release() end
function CampaignSettlement:Settlement() end
function CampaignSettlement:new() end

---@class CampaignUI
local CampaignUI = {}
function CampaignUI:ClearSelection() end
function CampaignUI:CurrentTabTypename() end
function CampaignUI:GetCameraPosition() end
function CampaignUI:HighlightComponent() end
function CampaignUI:HighlightConstructionItem() end
function CampaignUI:HighlightRecruitmentItem() end
function CampaignUI:IsMultiplayer() end
function CampaignUI:IsPreBattleTypeSiege() end
function CampaignUI:SetCameraHeading() end
function CampaignUI:SetCameraMaxTiltAngle() end
function CampaignUI:SetCameraMinDistance() end
function CampaignUI:SetCameraTarget() end
function CampaignUI:SetCameraTargetInstant() end
function CampaignUI:SetCameraZoom() end
function CampaignUI:ToggleCinematicBorders() end
function CampaignUI:ToggleScreenCover() end
function CampaignUI:clear_highlights() end
function CampaignUI:highlight_character() end
function CampaignUI:highlight_position() end
function CampaignUI:highlight_settlement() end
function CampaignUI:unhighlight_character() end
function CampaignUI:unhighlight_position() end
function CampaignUI:unhighlight_settlement() end

---@class CoreUtils
local CoreUtils = {}
function CoreUtils:Clamp() end
function CoreUtils:CompareByValue() end
function CoreUtils:CopyIntoTable() end
function CoreUtils:CopyTable() end
function CoreUtils:LoadTable() end
function CoreUtils:Max() end
function CoreUtils:Min() end
function CoreUtils:NamespaceFile() end
function CoreUtils:OffsetFrom() end
function CoreUtils:PickFGColour() end
function CoreUtils:PrintTable() end
function CoreUtils:Require() end
function CoreUtils:RoundToInt() end
function CoreUtils:RupToInt() end
function CoreUtils:SaveTable() end
function CoreUtils:TimeString() end
function CoreUtils:TruncToInt() end
function CoreUtils:UnRequire() end
function CoreUtils:UnRequireAll() end
function CoreUtils:outputbitfield() end

---@class Cursor
local Cursor = {}
function Cursor:DistanceToBL() end
function Cursor:Mode() end
function Cursor:ModeString() end
function Cursor:Modes() end
function Cursor:SetMode() end
function Cursor:new() end

---@class EpisodicScripting
local EpisodicScripting = {}
function EpisodicScripting:AddEventCallBack() end
function EpisodicScripting:ClearEventCallbacks() end
function EpisodicScripting:ClearMessageAutoShowOverrides() end
function EpisodicScripting:DisableFeature() end
function EpisodicScripting:EnableComponent() end
function EpisodicScripting:EnableFeature() end
function EpisodicScripting:HideComponent() end
function EpisodicScripting:HighlightComponent() end
function EpisodicScripting:HighlightConstructionItem() end
function EpisodicScripting:HighlightRecruitmentItem() end
function EpisodicScripting:InitFeature() end
function EpisodicScripting:IsOnCampaignMap() end
function EpisodicScripting:OnUICreated() end
function EpisodicScripting:OverrideMessageAutoShow() end
function EpisodicScripting:RevealComponent() end
function EpisodicScripting:SetCampaign() end
function EpisodicScripting:ShowHUD() end

---@class FACTION_LIST_SCRIPT_INTERFACE
local FACTION_LIST_SCRIPT_INTERFACE = {}
---@return boolean
function FACTION_LIST_SCRIPT_INTERFACE:is_empty() end
---@return FACTION_SCRIPT_INTERFACE
function FACTION_LIST_SCRIPT_INTERFACE:item_at() end
function FACTION_LIST_SCRIPT_INTERFACE:new() end
---@return number
function FACTION_LIST_SCRIPT_INTERFACE:num_items() end

---@class FACTION_SCRIPT_INTERFACE
local FACTION_SCRIPT_INTERFACE = {}
function FACTION_SCRIPT_INTERFACE:allied_with() end
function FACTION_SCRIPT_INTERFACE:ancillary_exists() end
function FACTION_SCRIPT_INTERFACE:at_war() end
---@return CHARACTER_LIST_SCRIPT_INTERFACE
function FACTION_SCRIPT_INTERFACE:character_list() end
function FACTION_SCRIPT_INTERFACE:culture() end
function FACTION_SCRIPT_INTERFACE:difficulty_level() end
function FACTION_SCRIPT_INTERFACE:ended_war_this_turn() end
function FACTION_SCRIPT_INTERFACE:faction_attitudes() end
function FACTION_SCRIPT_INTERFACE:faction_leader() end
function FACTION_SCRIPT_INTERFACE:government_type() end
function FACTION_SCRIPT_INTERFACE:has_faction_leader() end
function FACTION_SCRIPT_INTERFACE:has_food_shortage() end
function FACTION_SCRIPT_INTERFACE:has_home_region() end
function FACTION_SCRIPT_INTERFACE:has_researched_all_technologies() end
function FACTION_SCRIPT_INTERFACE:has_technology() end
function FACTION_SCRIPT_INTERFACE:home_region() end
function FACTION_SCRIPT_INTERFACE:imperium_level() end
---@return boolean
function FACTION_SCRIPT_INTERFACE:is_human() end
---@return boolean
function FACTION_SCRIPT_INTERFACE:losing_money() end
--@return MILITARY_FORCE_LIST_SCRIPT_INTERFACE
function FACTION_SCRIPT_INTERFACE:military_force_list() end
function FACTION_SCRIPT_INTERFACE:model() end
---@return string
function FACTION_SCRIPT_INTERFACE:name() end
function FACTION_SCRIPT_INTERFACE:new() end
function FACTION_SCRIPT_INTERFACE:num_allies() end
function FACTION_SCRIPT_INTERFACE:num_enemy_trespassing_armies() end
function FACTION_SCRIPT_INTERFACE:num_factions_in_war_with() end
function FACTION_SCRIPT_INTERFACE:num_generals() end
function FACTION_SCRIPT_INTERFACE:num_trade_agreements() end
function FACTION_SCRIPT_INTERFACE:politics() end
function FACTION_SCRIPT_INTERFACE:politics_party_add_loyalty_modifier() end
---@return REGION_LIST_SCRIPT_INTERFACE
function FACTION_SCRIPT_INTERFACE:region_list() end
function FACTION_SCRIPT_INTERFACE:research_queue_idle() end
function FACTION_SCRIPT_INTERFACE:sea_trade_route_raided() end
function FACTION_SCRIPT_INTERFACE:started_war_this_turn() end
function FACTION_SCRIPT_INTERFACE:state_religion() end
function FACTION_SCRIPT_INTERFACE:subculture() end
function FACTION_SCRIPT_INTERFACE:tax_category() end
function FACTION_SCRIPT_INTERFACE:tax_level() end
function FACTION_SCRIPT_INTERFACE:total_food() end
function FACTION_SCRIPT_INTERFACE:trade_resource_exists() end
function FACTION_SCRIPT_INTERFACE:trade_route_limit_reached() end
function FACTION_SCRIPT_INTERFACE:trade_ship_not_in_trade_node() end
function FACTION_SCRIPT_INTERFACE:trade_value() end
function FACTION_SCRIPT_INTERFACE:trade_value_percent() end
function FACTION_SCRIPT_INTERFACE:treasury() end
function FACTION_SCRIPT_INTERFACE:treasury_percent() end
function FACTION_SCRIPT_INTERFACE:treaty_details() end
function FACTION_SCRIPT_INTERFACE:unused_international_trade_route() end
function FACTION_SCRIPT_INTERFACE:upkeep_expenditure_percent() end

---@class GAME
local GAME = {}
function GAME:add_agent_experience() end
function GAME:add_attack_of_opportunity_overrides() end
function GAME:add_building_model_override() end
function GAME:add_circle_area_trigger() end
function GAME:add_custom_battlefield() end
function GAME:add_development_points_to_region() end
function GAME:add_event_restricted_building_record() end
function GAME:add_event_restricted_building_record_for_faction() end
function GAME:add_event_restricted_unit_record() end
function GAME:add_event_restricted_unit_record_for_faction() end
function GAME:add_exclusion_zone() end
function GAME:add_location_trigger() end
function GAME:add_marker() end
function GAME:add_outline_area_trigger() end
function GAME:add_restricted_building_level_record() end
function GAME:add_restricted_building_level_record_for_faction() end
function GAME:add_settlement_model_override() end
function GAME:add_time_trigger() end
function GAME:add_unit_model_overrides() end
function GAME:add_visibility_trigger() end
function GAME:advance_to_next_campaign() end
function GAME:allow_player_to_embark_navies() end
function GAME:apply_effect_bundle() end
function GAME:apply_effect_bundle_to_characters_force() end
function GAME:apply_effect_bundle_to_force() end
function GAME:attack() end
function GAME:autosave_at_next_opportunity() end
function GAME:award_experience_level() end
function GAME:cai_strategic_stance_manager_block_all_stances_but_that_specified_towards_target_faction() end
function GAME:cai_strategic_stance_manager_clear_all_blocking_between_factions() end
function GAME:cai_strategic_stance_manager_clear_all_promotions_between_factions() end
function GAME:cai_strategic_stance_manager_force_stance_update_between_factions() end
function GAME:cai_strategic_stance_manager_promote_specified_stance_towards_target_faction() end
function GAME:cai_strategic_stance_manager_promote_specified_stance_towards_target_faction_by_number() end
function GAME:cai_strategic_stance_manager_set_stance_blocking_between_factions_for_a_given_stance() end
function GAME:cai_strategic_stance_manager_set_stance_promotion_between_factions_for_a_given_stance() end
function GAME:cancel_actions_for() end
function GAME:cinematic() end
function GAME:compare_localised_string() end
function GAME:create_agent() end
function GAME:create_force() end
function GAME:disable_elections() end
function GAME:disable_end_turn() end
function GAME:disable_movement_for_ai_under_shroud() end
function GAME:disable_movement_for_character() end
function GAME:disable_movement_for_faction() end
function GAME:disable_rebellions_worldwide() end
function GAME:disable_saving_game() end
function GAME:disable_shopping_for_ai_under_shroud() end
function GAME:disable_shortcut() end
function GAME:dismiss_advice() end
function GAME:dismiss_advice_at_end_turn() end
function GAME:display_turns() end
function GAME:enable_auto_generated_missions() end
function GAME:enable_movement_for_character() end
function GAME:enable_movement_for_faction() end
function GAME:enable_ui() end
function GAME:end_turn() end
function GAME:exempt_region_from_tax() end
function GAME:force_add_ancillary() end
function GAME:force_add_skill() end
function GAME:force_add_trait() end
function GAME:force_agent_action_success_for_human() end
function GAME:force_assassination_success_for_human() end
function GAME:force_change_cai_faction_personality() end
---@param char_cqi string Character CQI
---@param stance string Stance to force ex. MILITARY_FORCE_ACTIVE_STANCE_TYPE_DEFAULT
function GAME:force_character_force_into_stance(char_cqi, stance) end
function GAME:force_declare_war() end
function GAME:force_diplomacy() end
function GAME:force_garrison_infiltration_success_for_human() end
function GAME:force_make_peace() end
function GAME:force_make_trade_agreement() end
function GAME:force_make_vassal() end
function GAME:force_rebellion_in_region() end
function GAME:grant_faction_handover() end
function GAME:grant_unit() end
function GAME:hide_character() end
function GAME:infect_force_with_plague() end
function GAME:infect_region_with_plague() end
function GAME:instant_set_building_health_percent() end
function GAME:instantly_dismantle_building() end
function GAME:instantly_repair_building() end
function GAME:is_new_game() end
function GAME:join_garrison() end
function GAME:kill_character() end
function GAME:leave_garrison() end
function GAME:load_named_value() end
function GAME:lock_technology() end
function GAME:make_neighbouring_regions_seen_in_shroud() end
function GAME:make_neighbouring_regions_visible_in_shroud() end
function GAME:make_region_seen_in_shroud() end
function GAME:make_region_visible_in_shroud() end
function GAME:make_sea_region_seen_in_shroud() end
function GAME:make_sea_region_visible_in_shroud() end
function GAME:make_son_come_of_age() end
---@return MODEL_SCRIPT_INTERFACE
function GAME:model() end
function GAME:modify_next_autoresolve_battle() end
---@param char_cqi string Character CQI
---@param x number X coordinate to move to
---@param y number Y coordinate to move to
---@param cmd_queue boolean Use the command queue
function GAME:move_to(char_cqi, x, y, cmd_queue) end
function GAME:new() end
function GAME:optional_extras_for_episodics() end
function GAME:override_ui() end
function GAME:pending_auto_show_messages() end
function GAME:register_instant_movie() end
function GAME:register_movies() end
function GAME:register_outro_movie() end
function GAME:remove_area_trigger() end
function GAME:remove_attack_of_opportunity_overrides() end
function GAME:remove_barrier() end
function GAME:remove_building_model_override() end
function GAME:remove_custom_battlefield() end
function GAME:remove_effect_bundle() end
function GAME:remove_effect_bundle_from_characters_force() end
function GAME:remove_effect_bundle_from_force() end
function GAME:remove_event_restricted_building_record() end
function GAME:remove_event_restricted_building_record_for_faction() end
function GAME:remove_event_restricted_unit_record() end
function GAME:remove_event_restricted_unit_record_for_faction() end
function GAME:remove_location_trigger() end
function GAME:remove_marker() end
function GAME:remove_restricted_building_level_record() end
function GAME:remove_restricted_building_level_record_for_faction() end
function GAME:remove_settlement_model_override() end
function GAME:remove_time_trigger() end
function GAME:remove_visibility_trigger() end
function GAME:render_campaign_to_file() end
function GAME:replenish_action_points() end
function GAME:restore_shroud_from_snapshot() end
function GAME:save_named_value() end
function GAME:scroll_camera() end
function GAME:scroll_camera_with_direction() end
function GAME:seek_exchange() end
function GAME:set_ai_uses_human_display_speed() end
function GAME:set_campaign_ai_force_all_factions_boardering_human_vassals_to_have_invasion_behaviour() end
function GAME:set_campaign_ai_force_all_factions_boardering_humans_to_have_invasion_behaviour() end
function GAME:set_character_experience_disabled() end
function GAME:set_character_skill_tier_limit() end
function GAME:set_event_generation_enabled() end
function GAME:set_general_offered_dilemma_permitted() end
function GAME:set_ignore_end_of_turn_public_order() end
function GAME:set_liberation_options_disabled() end
function GAME:set_looting_options_disabled_for_human() end
function GAME:set_map_bounds() end
function GAME:set_non_scripted_ancillaries_disabled() end
function GAME:set_non_scripted_traits_disabled() end
function GAME:set_public_order_of_province_for_region() end
function GAME:set_tax_disabled() end
function GAME:set_tax_rate() end
function GAME:set_technology_research_disabled() end
function GAME:set_ui_notification_of_victory_disabled() end
function GAME:set_zoom_limit() end
function GAME:show_message_event() end
function GAME:show_shroud() end
function GAME:shown_message() end
function GAME:speedup_active() end
function GAME:steal_user_input() end
function GAME:stop_camera() end
function GAME:stop_user_input() end
function GAME:take_shroud_snapshot() end
function GAME:technology_osmosis_for_playables_enable_all() end
function GAME:technology_osmosis_for_playables_enable_culture() end
function GAME:toggle_speedup() end
function GAME:transfer_region_to_faction() end
function GAME:treasury_mod() end
function GAME:trigger_custom_dilemma() end
function GAME:trigger_custom_incident() end
function GAME:trigger_custom_mission() end
function GAME:unhide_character() end
function GAME:win_next_autoresolve_battle() end
function GAME:zero_action_points() end

---@class GARRISON_RESIDENCE_SCRIPT_INTERFACE
local GARRISON_RESIDENCE_SCRIPT_INTERFACE = {}
---@return MILITARY_FORCE_SCRIPT_INTERFACE
function GARRISON_RESIDENCE_SCRIPT_INTERFACE:army() end
---@return BUILDING_LIST_SCRIPT_INTERFACE
function GARRISON_RESIDENCE_SCRIPT_INTERFACE:buildings() end
---@return FACTION_SCRIPT_INTERFACE
function GARRISON_RESIDENCE_SCRIPT_INTERFACE:faction() end
---@return boolean
function GARRISON_RESIDENCE_SCRIPT_INTERFACE:has_army() end
---@return boolean
function GARRISON_RESIDENCE_SCRIPT_INTERFACE:has_navy() end
---@return boolean
function GARRISON_RESIDENCE_SCRIPT_INTERFACE:is_settlement() end
function GARRISON_RESIDENCE_SCRIPT_INTERFACE:is_slot() end
---@return boolean
function GARRISON_RESIDENCE_SCRIPT_INTERFACE:is_under_siege() end
function GARRISON_RESIDENCE_SCRIPT_INTERFACE:model() end
---@return MILITARY_FORCE_SCRIPT_INTERFACE
function GARRISON_RESIDENCE_SCRIPT_INTERFACE:navy() end
function GARRISON_RESIDENCE_SCRIPT_INTERFACE:new() end
---@return REGION_SCRIPT_INTERFACE
function GARRISON_RESIDENCE_SCRIPT_INTERFACE:region() end
---@return SETTLEMENT_SCRIPT_INTERFACE
function GARRISON_RESIDENCE_SCRIPT_INTERFACE:settlement_interface() end
---@return SLOT_LIST_SCRIPT_INTERFACE
function GARRISON_RESIDENCE_SCRIPT_INTERFACE:slot_interface() end
---@return number
function GARRISON_RESIDENCE_SCRIPT_INTERFACE:unit_count() end

---@class Keyboard
local Keyboard = {}
function Keyboard:DisableQuickload() end
function Keyboard:ReturnKey() end
function Keyboard:StealKey() end

---@class MILITARY_FORCE_LIST_SCRIPT_INTERFACE
local MILITARY_FORCE_LIST_SCRIPT_INTERFACE = {}
---@return boolean
function MILITARY_FORCE_LIST_SCRIPT_INTERFACE:is_empty() end
---@param index number Index of the military force to return (0-based)
---@return MILITARY_FORCE_SCRIPT_INTERFACE
function MILITARY_FORCE_LIST_SCRIPT_INTERFACE:item_at(index) end
function MILITARY_FORCE_LIST_SCRIPT_INTERFACE:new() end
---@return number
function MILITARY_FORCE_LIST_SCRIPT_INTERFACE:num_items() end

---@class MILITARY_FORCE_SCRIPT_INTERFACE
local MILITARY_FORCE_SCRIPT_INTERFACE = {}
---@return CHARACTER_LIST_SCRIPT_INTERFACE
function MILITARY_FORCE_SCRIPT_INTERFACE:character_list() end
---@return boolean
function MILITARY_FORCE_SCRIPT_INTERFACE:contains_mercenaries() end
---@return FACTION_SCRIPT_INTERFACE
function MILITARY_FORCE_SCRIPT_INTERFACE:faction() end
---@return GARRISON_RESIDENCE_SCRIPT_INTERFACE
function MILITARY_FORCE_SCRIPT_INTERFACE:garrison_residence() end
---@return CHARACTER_SCRIPT_INTERFACE
function MILITARY_FORCE_SCRIPT_INTERFACE:general_character() end
---@return boolean
function MILITARY_FORCE_SCRIPT_INTERFACE:has_garrison_residence() end
---@return boolean
function MILITARY_FORCE_SCRIPT_INTERFACE:has_general() end
---@return boolean
function MILITARY_FORCE_SCRIPT_INTERFACE:is_army() end
---@return boolean
function MILITARY_FORCE_SCRIPT_INTERFACE:is_navy() end
function MILITARY_FORCE_SCRIPT_INTERFACE:model() end
function MILITARY_FORCE_SCRIPT_INTERFACE:new() end
---@return UNIT_LIST_SCRIPT_INTERFACE
function MILITARY_FORCE_SCRIPT_INTERFACE:unit_list() end
---@return number
function MILITARY_FORCE_SCRIPT_INTERFACE:upkeep() end

---@class MODEL_SCRIPT_INTERFACE
local MODEL_SCRIPT_INTERFACE = {}
---@return CAMPAIGN_AI_SCRIPT_INTERFACE
function MODEL_SCRIPT_INTERFACE:campaign_ai() end
function MODEL_SCRIPT_INTERFACE:campaign_name() end
function MODEL_SCRIPT_INTERFACE:campaign_type() end
function MODEL_SCRIPT_INTERFACE:character_can_reach_character() end
function MODEL_SCRIPT_INTERFACE:date_and_week_in_range() end
function MODEL_SCRIPT_INTERFACE:date_in_range() end
function MODEL_SCRIPT_INTERFACE:difficulty_level() end
function MODEL_SCRIPT_INTERFACE:faction_is_local() end
function MODEL_SCRIPT_INTERFACE:is_multiplayer() end
function MODEL_SCRIPT_INTERFACE:is_player_turn() end
function MODEL_SCRIPT_INTERFACE:new() end
---@return PENDING_BATTLE_SCRIPT_INTERFACE
function MODEL_SCRIPT_INTERFACE:pending_battle() end
function MODEL_SCRIPT_INTERFACE:player_steam_id_is_odd() end
function MODEL_SCRIPT_INTERFACE:random_number() end
function MODEL_SCRIPT_INTERFACE:random_percent() end
function MODEL_SCRIPT_INTERFACE:season() end
function MODEL_SCRIPT_INTERFACE:turn_number() end
---@return WORLD_SCRIPT_INTERFACE
function MODEL_SCRIPT_INTERFACE:world() end

---@class MPAvatar
local MPAvatar = {}
function MPAvatar:Free() end
function MPAvatar:SetComponentTexture() end
function MPAvatar:Valid() end
function MPAvatar:new() end

---@class MessageManager
local MessageManager = {}
function MessageManager:CanDismissAllMessages() end
function MessageManager:CheckForAutoOpen() end
function MessageManager:ClearMessagesFromEnv() end
function MessageManager:ClearOverrides() end
function MessageManager:ClosePanelIfNoMessage() end
function MessageManager:DestroyAllMessages() end
function MessageManager:DismissAllMessages() end
function MessageManager:HasMessagesStored() end
function MessageManager:HideAllMessages() end
function MessageManager:HideMessage() end
function MessageManager:HidingMessage() end
function MessageManager:InitMessageCallback() end
function MessageManager:OverrideAutoShow() end
function MessageManager:PendingAutoShowMessage() end
function MessageManager:ReInitialiseStackbase() end
function MessageManager:RestoreMessages() end
function MessageManager:SelectLayout() end
function MessageManager:SetCurrentMessageUnread() end
function MessageManager:ShowingMessage() end
function MessageManager:StoreMessages() end

---@class NULL_SCRIPT_INTERFACE
local NULL_SCRIPT_INTERFACE = {}
function NULL_SCRIPT_INTERFACE:new() end

function OnKeyPressed() end
function OnLETCharacterCreated() end
function OnLETCharacterDeselected() end
function OnLETCharacterSelected() end
function OnLETFactionTurnStart() end
function OnLETLoadingGame() end
function OnLETSavingGame() end

---@class PENDING_BATTLE_SCRIPT_INTERFACE
local PENDING_BATTLE_SCRIPT_INTERFACE = {}
function PENDING_BATTLE_SCRIPT_INTERFACE:ambush_battle() end
---@return CHARACTER_SCRIPT_INTERFACE
function PENDING_BATTLE_SCRIPT_INTERFACE:attacker() end
---@return string close_victory,decisive_victory,heroic_victory,pyrrhic_victory...
function PENDING_BATTLE_SCRIPT_INTERFACE:attacker_battle_result() end
---@return boolean
function PENDING_BATTLE_SCRIPT_INTERFACE:attacker_commander_fought_in_battle() end
---@return boolean
function PENDING_BATTLE_SCRIPT_INTERFACE:attacker_commander_fought_in_melee() end
---@return boolean
function PENDING_BATTLE_SCRIPT_INTERFACE:attacker_is_stronger() end
---@return string
function PENDING_BATTLE_SCRIPT_INTERFACE:battle_type() end
---@return GARRISON_RESIDENCE_SCRIPT_INTERFACE
function PENDING_BATTLE_SCRIPT_INTERFACE:contested_garrison() end
---@return FACTION_SCRIPT_INTERFACE
function PENDING_BATTLE_SCRIPT_INTERFACE:defender() end
---@return string close_victory,decisive_victory,heroic_victory,pyrrhic_victory...
function PENDING_BATTLE_SCRIPT_INTERFACE:defender_battle_result() end
---@return boolean
function PENDING_BATTLE_SCRIPT_INTERFACE:defender_commander_fought_in_battle() end
---@return boolean
function PENDING_BATTLE_SCRIPT_INTERFACE:defender_commander_fought_in_melee() end
---@return boolean
function PENDING_BATTLE_SCRIPT_INTERFACE:failed_ambush_battle() end
---@return boolean
function PENDING_BATTLE_SCRIPT_INTERFACE:has_attacker() end
---@return boolean
function PENDING_BATTLE_SCRIPT_INTERFACE:has_contested_garrison() end
---@return boolean
function PENDING_BATTLE_SCRIPT_INTERFACE:has_defender() end
---@return boolean
function PENDING_BATTLE_SCRIPT_INTERFACE:is_active() end
---@return MODEL_SCRIPT_INTERFACE
function PENDING_BATTLE_SCRIPT_INTERFACE:model() end
---@return boolean
function PENDING_BATTLE_SCRIPT_INTERFACE:naval_battle() end
function PENDING_BATTLE_SCRIPT_INTERFACE:new() end
---@return boolean
function PENDING_BATTLE_SCRIPT_INTERFACE:night_battle() end
function PENDING_BATTLE_SCRIPT_INTERFACE:percentage_of_attacker_killed() end
function PENDING_BATTLE_SCRIPT_INTERFACE:percentage_of_attacker_routed() end
function PENDING_BATTLE_SCRIPT_INTERFACE:percentage_of_defender_killed() end
function PENDING_BATTLE_SCRIPT_INTERFACE:percentage_of_defender_routed() end
---@return boolean
function PENDING_BATTLE_SCRIPT_INTERFACE:seige_battle() end

---@class REGION_LIST_SCRIPT_INTERFACE
local REGION_LIST_SCRIPT_INTERFACE = {}
---@return boolean
function REGION_LIST_SCRIPT_INTERFACE:is_empty() end
---@return REGION_SCRIPT_INTERFACE
function REGION_LIST_SCRIPT_INTERFACE:item_at() end
function REGION_LIST_SCRIPT_INTERFACE:new() end
---@return number
function REGION_LIST_SCRIPT_INTERFACE:num_items() end

---@class REGION_MANAGER_SCRIPT_INTERFACE
local REGION_MANAGER_SCRIPT_INTERFACE = {}
---@return REGION_LIST_SCRIPT_INTERFACE
function REGION_MANAGER_SCRIPT_INTERFACE:faction_region_list() end
---@return MODEL_SCRIPT_INTERFACE
function REGION_MANAGER_SCRIPT_INTERFACE:model() end
function REGION_MANAGER_SCRIPT_INTERFACE:new() end
---@return REGION_SCRIPT_INTERFACE
---@param key string Key of the region to return
function REGION_MANAGER_SCRIPT_INTERFACE:region_by_key(key) end
---@return REGION_LIST_SCRIPT_INTERFACE
function REGION_MANAGER_SCRIPT_INTERFACE:region_list() end
---@return boolean
function REGION_MANAGER_SCRIPT_INTERFACE:resource_exists_anywhere() end
---@return SETTLEMENT_SCRIPT_INTERFACE
---@param key string Key of the settlement to return
function REGION_MANAGER_SCRIPT_INTERFACE:settlement_by_key(key) end
---@return SLOT_SCRIPT_INTERFACE
---@param key string Key of the slot to return
function REGION_MANAGER_SCRIPT_INTERFACE:slot_by_key(key) end

---@class REGION_SCRIPT_INTERFACE
local REGION_SCRIPT_INTERFACE = {}
---@return REGION_LIST_SCRIPT_INTERFACE
function REGION_SCRIPT_INTERFACE:adjacent_region_list() end
function REGION_SCRIPT_INTERFACE:building_exists() end
function REGION_SCRIPT_INTERFACE:building_superchain_exists() end
---@return GARRISON_RESIDENCE_SCRIPT_INTERFACE
function REGION_SCRIPT_INTERFACE:garrison_residence() end
function REGION_SCRIPT_INTERFACE:last_building_constructed_key() end
function REGION_SCRIPT_INTERFACE:majority_religion() end
---@return FACTION_SCRIPT_INTERFACE
function REGION_SCRIPT_INTERFACE:model() end
---@return string
function REGION_SCRIPT_INTERFACE:name() end
function REGION_SCRIPT_INTERFACE:new() end
---@return number
function REGION_SCRIPT_INTERFACE:num_buildings() end
---@return FACTION_SCRIPT_INTERFACE
function REGION_SCRIPT_INTERFACE:owning_faction() end
---@return string
function REGION_SCRIPT_INTERFACE:province_name() end
---@return number
function REGION_SCRIPT_INTERFACE:public_order() end
---@return number
function REGION_SCRIPT_INTERFACE:region_wealth() end
---@return number
function REGION_SCRIPT_INTERFACE:region_wealth_change_percent() end
function REGION_SCRIPT_INTERFACE:resource_exists() end
---@return number
function REGION_SCRIPT_INTERFACE:sanitation() end
---@return SETTLEMENT_SCRIPT_INTERFACE
function REGION_SCRIPT_INTERFACE:settlement() end
---@return SLOT_LIST_SCRIPT_INTERFACE
function REGION_SCRIPT_INTERFACE:slot_list() end
function REGION_SCRIPT_INTERFACE:slot_type_exists() end
---@return number
function REGION_SCRIPT_INTERFACE:squalor() end
function REGION_SCRIPT_INTERFACE:tax_income() end
function REGION_SCRIPT_INTERFACE:town_wealth_growth() end

---@class SETTLEMENT_SCRIPT_INTERFACE
local SETTLEMENT_SCRIPT_INTERFACE = {}
function SETTLEMENT_SCRIPT_INTERFACE:castle_slot() end
function SETTLEMENT_SCRIPT_INTERFACE:commander() end
---@return number
function SETTLEMENT_SCRIPT_INTERFACE:display_position_x() end
---@return number
function SETTLEMENT_SCRIPT_INTERFACE:display_position_y() end
---@return FACTION_SCRIPT_INTERFACE
function SETTLEMENT_SCRIPT_INTERFACE:faction() end
---@return boolean
function SETTLEMENT_SCRIPT_INTERFACE:has_castle_slot() end
---@return boolean
function SETTLEMENT_SCRIPT_INTERFACE:has_commander() end
---@return number
function SETTLEMENT_SCRIPT_INTERFACE:logical_position_x() end
---@return number
function SETTLEMENT_SCRIPT_INTERFACE:logical_position_y() end
---@return MODEL_SCRIPT_INTERFACE
function SETTLEMENT_SCRIPT_INTERFACE:model() end
function SETTLEMENT_SCRIPT_INTERFACE:new() end
---@return REGION_SCRIPT_INTERFACE
function SETTLEMENT_SCRIPT_INTERFACE:region() end
---@return SLOT_LIST_SCRIPT_INTERFACE
function SETTLEMENT_SCRIPT_INTERFACE:slot_list() end

---@class SLOT_LIST_SCRIPT_INTERFACE
local SLOT_LIST_SCRIPT_INTERFACE = {}
function SLOT_LIST_SCRIPT_INTERFACE:buliding_type_exists() end
---@return boolean
function SLOT_LIST_SCRIPT_INTERFACE:is_empty() end
---@return SLOT_SCRIPT_INTERFACE
---@param index number Index of the slot to return (0-based)
function SLOT_LIST_SCRIPT_INTERFACE:item_at(index) end
function SLOT_LIST_SCRIPT_INTERFACE:new() end
---@return number
function SLOT_LIST_SCRIPT_INTERFACE:num_items() end
function SLOT_LIST_SCRIPT_INTERFACE:slot_type_exists() end

---@class SLOT_SCRIPT_INTERFACE
local SLOT_SCRIPT_INTERFACE = {}
---@return BUILDING_SCRIPT_INTERFACE
function SLOT_SCRIPT_INTERFACE:building() end
---@return FACTION_SCRIPT_INTERFACE
function SLOT_SCRIPT_INTERFACE:faction() end
function SLOT_SCRIPT_INTERFACE:has_building() end
---@return MODEL_SCRIPT_INTERFACE
function SLOT_SCRIPT_INTERFACE:model() end
---@return string
function SLOT_SCRIPT_INTERFACE:name() end
function SLOT_SCRIPT_INTERFACE:new() end
---@return REGION_SCRIPT_INTERFACE
function SLOT_SCRIPT_INTERFACE:region() end
function SLOT_SCRIPT_INTERFACE:type() end

---@class ScriptedValueRegistry
local ScriptedValueRegistry = {}

function ScriptedValueRegistry:LoadBool() end
function ScriptedValueRegistry:SaveBool() end
function ScriptedValueRegistry:new() end

---@class UIComponent
local UIComponent = {}

function UIComponent:Address() end
function UIComponent:Adopt() end
function UIComponent:AttachCustomControl() end
function UIComponent:Bounds() end
function UIComponent:CallbackId() end
function UIComponent:ChildCount() end
function UIComponent:CurrentAnimationId() end
function UIComponent:CurrentState() end
function UIComponent:CurrentStateUI() end
function UIComponent:DestroyChildren() end
function UIComponent:Dimensions() end
function UIComponent:Divorce() end
function UIComponent:DockingPoint() end
function UIComponent:Find() end
function UIComponent:FindPositionIntoCurrentText() end
function UIComponent:FindTextSnapPosition() end
function UIComponent:ForceEvent() end
function UIComponent:GetProperty() end
function UIComponent:GetStateText() end
function UIComponent:GetStateTextDetails() end
function UIComponent:GetTooltipText() end
function UIComponent:GlobalExists() end
function UIComponent:HasInterface() end
function UIComponent:Height() end
function UIComponent:Highlight() end
function UIComponent:Id() end
function UIComponent:InterfaceFunction() end
function UIComponent:IsCharPrintable() end
function UIComponent:IsDragged() end
function UIComponent:IsInteractive() end
function UIComponent:IsMouseOverChildren() end
function UIComponent:IsMoveable() end
function UIComponent:Layout() end
function UIComponent:LockPriority() end
function UIComponent:LuaCall() end
function UIComponent:MoveTo() end
function UIComponent:Parent() end
function UIComponent:PopulateTextures() end
function UIComponent:Position() end
function UIComponent:Priority() end
function UIComponent:PropagateImageColour() end
function UIComponent:PropagateOpacity() end
function UIComponent:PropagatePriority() end
function UIComponent:PropagateVisibility() end
function UIComponent:ReorderChildren() end
function UIComponent:Resize() end
function UIComponent:RestoreUIHeirarchy() end
function UIComponent:RunScript() end
function UIComponent:SaveUIHeirarchy() end
function UIComponent:SequentialFind() end
function UIComponent:SetDisabled() end
function UIComponent:SetDockingPoint() end
function UIComponent:SetDragged() end
function UIComponent:SetEventCallback() end
function UIComponent:SetGlobal() end
function UIComponent:SetImageColour() end
function UIComponent:SetImageRotation() end
function UIComponent:SetInteractive() end
function UIComponent:SetMoveable() end
function UIComponent:SetOpacity() end
function UIComponent:SetProperty() end
function UIComponent:SetState() end
function UIComponent:SetStateColours() end
function UIComponent:SetStateText() end
function UIComponent:SetStateTextDetails() end
function UIComponent:SetStateTextXOffset() end
function UIComponent:SetTooltipText() end
function UIComponent:SetVisible() end
function UIComponent:ShaderTechniqueGet() end
function UIComponent:ShaderTechniqueSet() end
function UIComponent:ShaderVarsGet() end
function UIComponent:ShaderVarsSet() end
function UIComponent:SimulateClick() end
function UIComponent:SimulateKey() end
function UIComponent:StealInputFocus() end
function UIComponent:StealShortcutKey() end
function UIComponent:TextDimensions() end
function UIComponent:TextShaderTechniqueSet() end
function UIComponent:TextShaderVarsGet() end
function UIComponent:TextShaderVarsSet() end
function UIComponent:TriggerAnimation() end
function UIComponent:TriggerShortcut() end
function UIComponent:UnLockPriority() end
function UIComponent:Visible() end
function UIComponent:Width() end
function UIComponent:WidthOfTextLine() end
function UIComponent:new() end


---@class UNIT_LIST_SCRIPT_INTERFACE
local UNIT_LIST_SCRIPT_INTERFACE = {}

function UNIT_LIST_SCRIPT_INTERFACE:has_unit() end
---@return boolean
function UNIT_LIST_SCRIPT_INTERFACE:is_empty() end
---@return UNIT_SCRIPT_INTERFACE
---@param index number Index of the unit to return (0-based)
function UNIT_LIST_SCRIPT_INTERFACE:item_at(index) end
function UNIT_LIST_SCRIPT_INTERFACE:new() end
---@return number
function UNIT_LIST_SCRIPT_INTERFACE:num_items() end

---@class UNIT_SCRIPT_INTERFACE
local UNIT_SCRIPT_INTERFACE = {}

---@return FACTION_SCRIPT_INTERFACE
function UNIT_SCRIPT_INTERFACE:faction() end
---@return CHARACTER_SCRIPT_INTERFACE
function UNIT_SCRIPT_INTERFACE:force_commander() end
---@return boolean
function UNIT_SCRIPT_INTERFACE:has_force_commander() end
---@return boolean
function UNIT_SCRIPT_INTERFACE:has_unit_commander() end
---@return boolean
function UNIT_SCRIPT_INTERFACE:is_land_unit() end
---@return boolean
function UNIT_SCRIPT_INTERFACE:is_naval_unit() end
---@return MILITARY_FORCE_SCRIPT_INTERFACE
function UNIT_SCRIPT_INTERFACE:military_force() end
---@return MODEL_SCRIPT_INTERFACE
function UNIT_SCRIPT_INTERFACE:model() end
function UNIT_SCRIPT_INTERFACE:new() end
---@return number
function UNIT_SCRIPT_INTERFACE:percentage_proportion_of_full_strength() end
---@return string
function UNIT_SCRIPT_INTERFACE:unit_category() end
---@return string
function UNIT_SCRIPT_INTERFACE:unit_class() end
function UNIT_SCRIPT_INTERFACE:unit_commander() end
---@return string
function UNIT_SCRIPT_INTERFACE:unit_key() end

---@class WORLD_SCRIPT_INTERFACE
local WORLD_SCRIPT_INTERFACE = {}

function WORLD_SCRIPT_INTERFACE:ancillary_exists() end
function WORLD_SCRIPT_INTERFACE:faction_by_key() end
function WORLD_SCRIPT_INTERFACE:faction_exists() end
---@return FACTION_LIST_SCRIPT_INTERFACE
function WORLD_SCRIPT_INTERFACE:faction_list() end
---@retrn MODEL_SCRIPT_INTERFACE
function WORLD_SCRIPT_INTERFACE:model() end
function WORLD_SCRIPT_INTERFACE:new() end
---@return REGION_MANAGER_SCRIPT_INTERFACE
function WORLD_SCRIPT_INTERFACE:region_manager() end

---@class conditions
local conditions = {}

function conditions.AdjacentRegionRebelling() end
function conditions.AnyFactionDestroyedLastTurn() end
function conditions.ArmyIsAlliedCampaign() end
function conditions.ArmyIsLocalCampaign() end
function conditions.BattleAllianceHasDeployables() end
function conditions.BattleAllianceIsAttacker() end
function conditions.BattleAllianceIsPlayers() end
function conditions.BattleAllianceNumberOfShips() end
function conditions.BattleAllianceNumberOfUnits() end
function conditions.BattleCommanderIsGeneral() end
function conditions.BattleEnemyAlliancePercentageCanHide() end
function conditions.BattleEnemyAlliancePercentageOfClassAndCategory() end
function conditions.BattleEnemyAlliancePercentageOfMountType() end
function conditions.BattleEnemyAlliancePercentageOfSpecialAbility() end
function conditions.BattleEnemyAlliancePercentageOfUnitCategory() end
function conditions.BattleEnemyAlliancePercentageOfUnitClass() end
function conditions.BattleEnemyDirectionOfMeleeAttack() end
function conditions.BattleEnemyHasMissileSuperiority() end
function conditions.BattleEnemyShipActionStatus() end
function conditions.BattleEnemyShipOnFire() end
function conditions.BattleEnemyUnitActionStatus() end
function conditions.BattleEnemyUnitCategory() end
function conditions.BattleEnemyUnitClass() end
function conditions.BattleEnemyUnitCurrentFormation() end
function conditions.BattleEnemyUnitOnLeftFlank() end
function conditions.BattleEnemyUnitOnRightFlank() end
function conditions.BattleEnemyUnitSpecialAbilitySupported() end
function conditions.BattleEnemyUnitTechnologySupported() end
function conditions.BattleHasCoverBuildings() end
function conditions.BattleHasCoverWalls() end
function conditions.BattleIsAmbushConflict() end
function conditions.BattleIsLandConflict() end
function conditions.BattleIsNavalConflict() end
function conditions.BattleIsSiegeConflict() end
function conditions.BattlePlayerAllianceDefendingHill() end
function conditions.BattlePlayerAlliancePercentageCanHide() end
function conditions.BattlePlayerAlliancePercentageGuerrillas() end
function conditions.BattlePlayerAlliancePercentageOfAmmoType() end
function conditions.BattlePlayerAlliancePercentageOfClassAndCategory() end
function conditions.BattlePlayerAlliancePercentageOfMountType() end
function conditions.BattlePlayerAlliancePercentageOfSpecialAbility() end
function conditions.BattlePlayerAlliancePercentageOfTechnology() end
function conditions.BattlePlayerAlliancePercentageOfUnitCategory() end
function conditions.BattlePlayerAlliancePercentageOfUnitClass() end
function conditions.BattlePlayerAllianceToEnemyAllianceRatio() end
function conditions.BattlePlayerDefendingFort() end
function conditions.BattlePlayerDirectionOfMeleeAttack() end
function conditions.BattlePlayerDirectionOfMissileAttack() end
function conditions.BattlePlayerSailsPercentageDamaged() end
function conditions.BattlePlayerShipActionStatus() end
function conditions.BattlePlayerShipClass() end
function conditions.BattlePlayerUnitActionStatus() end
function conditions.BattlePlayerUnitAmmoType() end
function conditions.BattlePlayerUnitCategory() end
function conditions.BattlePlayerUnitClass() end
function conditions.BattlePlayerUnitCurrentFormation() end
function conditions.BattlePlayerUnitDefendingHill() end
function conditions.BattlePlayerUnitEngaged() end
function conditions.BattlePlayerUnitEngagedInMelee() end
function conditions.BattlePlayerUnitMountType() end
function conditions.BattlePlayerUnitMovingFast() end
function conditions.BattlePlayerUnitSpecialAbilityActive() end
function conditions.BattlePlayerUnitSpecialAbilitySupported() end
function conditions.BattlePlayerUnitTechnologySupported() end
function conditions.BattleResult() end
function conditions.BattleShipIsPlayers() end
function conditions.BattleShipSailsPercentageDamage() end
function conditions.BattleTimeLimitSet() end
function conditions.BattleType() end
function conditions.BattleUnitIsAllied() end
function conditions.BattleUnitIsPlayers() end
function conditions.BattlesFought() end
function conditions.BuildingLevelName() end
function conditions.BuildingTypeExistsAtSettlement() end
function conditions.BuildingTypeExistsAtSlot() end
function conditions.CampaignBattleType() end
function conditions.CampaignName() end
function conditions.CampaignNumberOfUnitsInEnemyAlliance() end
function conditions.CampaignNumberOfUnitsInEnemyArmy() end
function conditions.CampaignNumberOfUnitsInPlayerAlliance() end
function conditions.CampaignNumberOfUnitsInPlayerArmy() end
function conditions.CampaignPercentageOfOwnCaptured() end
function conditions.CampaignPercentageOfOwnKilled() end
function conditions.CampaignPercentageOfOwnRouted() end
function conditions.CampaignPercentageOfThemCaptured() end
function conditions.CampaignPercentageOfThemKilled() end
function conditions.CampaignPercentageOfThemRouted() end
function conditions.CampaignPercentageOfUnitCategory() end
function conditions.CanGenerateHistoricalCharacter() end
function conditions.CharacterAbility() end
function conditions.CharacterArmyCouldReplenishFromBattle() end
function conditions.CharacterArmyUsedCoverBuildings() end
function conditions.CharacterArmyUsedCoverWalls() end
function conditions.CharacterAttribute() end
function conditions.CharacterBattleWallsBreached() end
function conditions.CharacterBuildingConstructed() end
function conditions.CharacterCapturedEnemyShip() end
function conditions.CharacterCommandsNavy() end
function conditions.CharacterCultureType() end
function conditions.CharacterDuelWeapon() end
function conditions.CharacterDuelsFought() end
function conditions.CharacterDuelsLost() end
function conditions.CharacterDuelsWon() end
function conditions.CharacterEndedInAmbushPosition() end
function conditions.CharacterFactionAdmiralCount() end
function conditions.CharacterFactionGeneralCount() end
function conditions.CharacterFactionHasTechType() end
function conditions.CharacterFactionMinisterAncillary() end
function conditions.CharacterFactionMinisterTrait() end
function conditions.CharacterFactionName() end
function conditions.CharacterFactionReligion() end
function conditions.CharacterFactionSubcultureType() end
function conditions.CharacterForename() end
function conditions.CharacterFoughtCulture() end
function conditions.CharacterHasAncillary() end
function conditions.CharacterHasTrait() end
function conditions.CharacterHoldsPost() end
function conditions.CharacterHusbandHasTrait() end
function conditions.CharacterInBuildingOfChain() end
function conditions.CharacterInBuildingType() end
function conditions.CharacterInEnemyLands() end
function conditions.CharacterInHomeRegion() end
function conditions.CharacterInOwnFactionLands() end
function conditions.CharacterInRegion() end
function conditions.CharacterInTheatre() end
function conditions.CharacterIsAlliedCampaign() end
function conditions.CharacterIsEnemyCampaign() end
function conditions.CharacterIsFemale() end
function conditions.CharacterIsLocalCampaign() end
function conditions.CharacterMPPercentageRemaining() end
function conditions.CharacterMinisterialPosition() end
function conditions.CharacterNumberOfChildren() end
function conditions.CharacterOlderThan() end
function conditions.CharacterRallied() end
function conditions.CharacterRank() end
function conditions.CharacterRouted() end
function conditions.CharacterRunsSpyNetwork() end
function conditions.CharacterSpouseHasTrait() end
function conditions.CharacterStationaryForOneTurn() end
function conditions.CharacterSurname() end
function conditions.CharacterTrait() end
function conditions.CharacterTurnsAtHome() end
function conditions.CharacterTurnsAtSea() end
function conditions.CharacterTurnsInEnemyLands() end
function conditions.CharacterType() end
function conditions.CharacterWasAttacker() end
function conditions.CharacterWifeHasTrait() end
function conditions.CharacterWithdrewFromBattle() end
function conditions.CharacterWonBattle() end
function conditions.CharacterWonDuel() end
function conditions.CharactersUnitRallied() end
function conditions.CommanderAncillary() end
function conditions.CommanderFoughtInBattle() end
function conditions.CommanderFoughtInMelee() end
function conditions.CommanderTrait() end
function conditions.DateAndWeekInRange() end
function conditions.DateInRange() end
function conditions.DefensiveSiegesFought() end
function conditions.DefensiveSiegesWon() end
function conditions.DifficultyLevel() end
function conditions.EnemyArmyGreaterCombatStrength() end
function conditions.FactionAllyCount() end
function conditions.FactionBuildingExists() end
function conditions.FactionBuildingUnderConstruction() end
function conditions.FactionCanBuildBuilding() end
function conditions.FactionCashFlow() end
function conditions.FactionDestroyedByCharacterFaction() end
function conditions.FactionExists() end
function conditions.FactionGovernmentType() end
function conditions.FactionHasAllies() end
function conditions.FactionHasRecruitedAnyAgents() end
function conditions.FactionHasTradeShipNotInTradeNode() end
function conditions.FactionIsAlliedCampaign() end
function conditions.FactionIsEnemyCampaign() end
function conditions.FactionIsHuman() end
function conditions.FactionIsLocal() end
function conditions.FactionKeyIsLocal() end
function conditions.FactionLeadersAttribute() end
function conditions.FactionLeadersTrait() end
function conditions.FactionName() end
function conditions.FactionParticipatedInBattle() end
function conditions.FactionPatrioticFervour() end
function conditions.FactionSupportCostsPercentage() end
function conditions.FactionTaxLevel() end
function conditions.FactionTechExists() end
function conditions.FactionTradeResourceExists() end
function conditions.FactionTradeValue() end
function conditions.FactionTradeValuePercentage() end
function conditions.FactionTreasury() end
function conditions.FactionTreasuryWorldPercentage() end
function conditions.FactionWarWeariness() end
function conditions.FactionwideAncillaryTypeExists() end
function conditions.ForcesComposedOf() end
function conditions.GarrisonIsLocal() end
function conditions.GarrisonUnitCount() end
function conditions.GovernorTaxLevel() end
function conditions.GovernorshipEquals() end
function conditions.GovernorshipTaxLevel() end
function conditions.GovernorshipsTaxLevel() end
function conditions.HasUnspecialisedPort() end
function conditions.InPort() end
function conditions.InSettlement() end
function conditions.InsurrectionCrushed() end
function conditions.IsAdmiral() end
function conditions.IsBesieging() end
function conditions.IsBlockading() end
function conditions.IsBuildingInChain() end
function conditions.IsBuildingOfType() end
function conditions.IsCarryingTroops() end
function conditions.IsChildOf() end
function conditions.IsColony() end
function conditions.IsComponentType() end
function conditions.IsFactionBesiegingSettlement() end
function conditions.IsFactionLeader() end
function conditions.IsFactionLeaderFemale() end
function conditions.IsFamilyMember() end
function conditions.IsGarrisoned() end
function conditions.IsHomeRegion() end
function conditions.IsMessageType() end
function conditions.IsMultiplayer() end
function conditions.IsNightBattle() end
function conditions.IsPlayerTurn() end
function conditions.IsPortGarrisoned() end
function conditions.IsTheatreGovernor() end
function conditions.IsTriggerableHistoricalEvent() end
function conditions.IsUnderBlockade() end
function conditions.IsUnderSiege() end
function conditions.LosingMoney() end
function conditions.MapPosition() end
function conditions.MapPositionNear() end
function conditions.NoActionThisTurn() end
function conditions.OffensiveSiegesFought() end
function conditions.OffensiveSiegesWon() end
function conditions.OnAWarFooting() end
function conditions.ParentId() end
function conditions.PercentageUnspentIncome() end
function conditions.PlayerFactionIsAttacker() end
function conditions.PortBlockaded() end
function conditions.PortBlockadedLocal() end
function conditions.RandomPercentCampaign() end
function conditions.RegionBuildableSlotEmpty() end
function conditions.RegionBuildingFinished() end
function conditions.RegionClamoursReform() end
function conditions.RegionCultureIsFactionCulture() end
function conditions.RegionDemands() end
function conditions.RegionEconomicGrowthLow() end
function conditions.RegionGovernorAttribute() end
function conditions.RegionIsLocal() end
function conditions.RegionIsRebelling() end
function conditions.RegionMajorityReligion() end
function conditions.RegionName() end
function conditions.RegionPopulationLow() end
function conditions.RegionPopulationMaxReached() end
function conditions.RegionRebels() end
function conditions.RegionReligionIsStateReligion() end
function conditions.RegionResourceExists() end
function conditions.RegionResourceExploited() end
function conditions.RegionRiots() end
function conditions.RegionSlotBuildingCount() end
function conditions.RegionSlotBuildingCultureExists() end
function conditions.RegionSlotBuildingTypeCount() end
function conditions.RegionSlotBuildingTypeExists() end
function conditions.RegionSlotCount() end
function conditions.RegionSlotEmptyCount() end
function conditions.RegionSlotTypeExists() end
function conditions.RegionTaxExempt() end
function conditions.RegionTaxLevel() end
function conditions.RegionTaxTownWealthGrowthReduction() end
function conditions.RegionTownWealthGrowth() end
function conditions.RegionWealthDecrease() end
function conditions.RegionWealthIncrease() end
function conditions.RegionWouldBeHappyWithNoTaxExemption() end
function conditions.ResearchCategory() end
function conditions.ResearchQueueIdle() end
function conditions.ResearchType() end
function conditions.ResearchTypeUniqueToFaction() end
function conditions.SeaTradeRouteRaided() end
function conditions.SettlementBuildingQueueIdleDespiteCash() end
function conditions.SettlementFortificationsBuildingQueueIdleDespiteCash() end
function conditions.SettlementIsLocal() end
function conditions.SettlementName() end
function conditions.SlotBuildingQueueIdleDespiteCash() end
function conditions.SlotIsAlliedCampaign() end
function conditions.SlotIsLocal() end
function conditions.SlotName() end
function conditions.SlotSuperchain() end
function conditions.SlotType() end
function conditions.SupportCostsPercentage() end
function conditions.TargetArmyGreaterCombatStrength() end
function conditions.TargetCharacterIsAlliedCampaign() end
function conditions.TargetCharacterIsEnemyCampaign() end
function conditions.TargetInStrikingRangeOfEnemy() end
function conditions.TaxCollectionLimited() end
function conditions.TaxLevel() end
function conditions.TradeNodeAvailableWorldwide() end
function conditions.TradePortsAtMaxLevel() end
function conditions.TradeRouteIsEnemy() end
function conditions.TradeRouteIsLocal() end
function conditions.TradeRouteLimitReached() end
function conditions.TurnNumber() end
function conditions.TurnsSinceThreadLastAdvanced() end
function conditions.UnitCategory() end
function conditions.UnitClass() end
function conditions.UnitCrushedInsurrection() end
function conditions.UnitCultureType() end
function conditions.UnitFoughtInBattle() end
function conditions.UnitFoughtInMelee() end
function conditions.UnitInTheatre() end
function conditions.UnitOnContinent() end
function conditions.UnitRouted() end
function conditions.UnitSufferedCasualties() end
function conditions.UnitTrait() end
function conditions.UnitType() end
function conditions.UnitWonBattle() end
function conditions.UnusedInternationalTradeRoute() end
function conditions.WarEndedCharacterFaction() end
function conditions.WarStartedCharacterFaction() end
function conditions.WorldResourceExists() end
function conditions.WorldResourceExploited() end
function conditions.WorldwideAncillaryTypeExists() end
function conditions.is_advice_audio_playing() end
-- endregion


---------------------------------
-- GLOBAL VARIABLE DEFINITIONS --
---------------------------------

---@type battle_manager
bm = nil


