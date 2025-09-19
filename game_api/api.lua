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
---@return int
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
function unit_controller:goto_location() end
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

---------------------------------
-- GLOBAL VARIABLE DEFINITIONS --
---------------------------------

---@type battle_manager
bm = nil
