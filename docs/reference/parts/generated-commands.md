## Core Commands

#### `/autoclear`
Toggles console autoclear setting.

#### `/autoclear_after`
Sets number of entries after which console will autoclear.

#### `/changelog`
Prints the changelog.

#### `/changelog_read`
Marks current changelog as read.

#### `/clear`
Clear console output.

#### `/cli_help`
Info on engine CliExecute functions.

#### `/consul_debug_events`
Toggle persistent event logging at startup.

#### `/consul_debug_turn_time`
Measure AI turn time.

#### `/debug`
Prints debug information about characters,settlements,etc.

#### `/debug_mouseover`
Prints debug information of the mouseover component.

#### `/debug_onclick`
Prints debug information of the clicked component.

#### `/faction_list`
Prints the list of factions.

#### `/help`
Show help message.

#### `/history`
Print console history.

#### `/log_events_all`
Log all game events to the consul.log file

#### `/log_events_game`
Log game events (excluding component and time trigger)

#### `/log_game_event `
Logs event Example: /log_game_event CharacterCreated

#### `/logregistry`
Logs all Lua registries and environments to consul.log.

#### `/p `
Pretty-prints a Lua value using 'penlight'. Example: /p _G

#### `/p2 `
Pretty-prints a Lua value using 'inspect'. Example: /p2 _G

#### `/profi_start`
Start profi.lua.

#### `/profi_stop`
Stop profi.lua and save to &lt;filename&gt;.

#### `/profiler_start`
Start profiler.lua.

#### `/profiler_stop`
Stop profiler.lua and save to &lt;filename&gt;.

#### `/r `
Shorthand for 'return &lt;Lua code&gt;. Example: /r 2 + 2

#### `/region_list`
Prints the list of regions.

#### `/reload_custom_commands`
Reload commands from consul_custom_commands.lua

#### `/show_shroud`
Shows/Hides the shroud on the map.

#### `/start_trace`
Starts/stops the lua trace log. Saves into consul.log file.

#### `/use_in_battle`
Toggles use of Consul in campaign battles.

## Custom Commands

#### `/ex_echo `
[Example] Echo input text.

#### `/ex_local_faction`
[Example] Print stats for human faction.

#### `/ex_run_lua `
[Example] Execute raw Lua code string.

#### `/ex_settlement_log`
[Example] Toggle player-selected settlement log.

## DeI-Specific Commands

#### `/dei_reset_all_pop`
[DEI] Wipe population of all regions to 0.

#### `/dei_reset_region_pop `
[DEI] Wipe region pop: /dei_reset_region_pop &lt;region_key&gt;

#### `/dei_set_pop `
[DEI] Set pop: /dei_set_pop &lt;region&gt; &lt;class&gt; &lt;amount&gt;

