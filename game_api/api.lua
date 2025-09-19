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
function army:create_unit_controller() end
function army:enable_army_destruction_morale_effect() end
function army:get_reinforcement_ships() end
function army:get_reinforcement_units() end
function army:is_commander_alive() end
function army:is_commander_invincible() end
function army:quit_battle() end
function army:ships() end
function army:units() end

---------------------------------
-- GLOBAL VARIABLE DEFINITIONS --
---------------------------------

---@type battle_manager
bm = nil
