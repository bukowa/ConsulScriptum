---@module consul

consul_build = "Attila" -- or "Rome2"

consul = {

	VERSION = "0.8.0-alpha.1",
	URL = "http://github.com/bukowa/ConsulScriptum",
	AUTHOR = "Mateusz Kurowski",
	CONTACT = "gitbukowa@gmail.com",

	-- game requires a char before /t
	-- it also makes /t very long, so just use spaces
	tab = string.char(1) .. "   ",

	--- Boolean flag indicating if the script is running in battle.
	--- @field consul.is_in_battle_script
	is_in_battle_script = false,
	bm = nil,

	-- attribute holding stuff selected by debug
	debug = {
		-- return a cqi for lookups
		character_cqi = function()
			return "character_cqi:" .. consul.debug.character:cqi()
		end,
		-- hide the character
		character_hide = function(queue)
			queue = (queue == nil) and true or queue
			return consul._game():hide_character(consul.debug.character_cqi(), queue)
		end,
		--character_unhide = function(queue, x, y, cqi)
		--    queue = (queue == nil) and true or queue
		--    x   = x   or consul.debug.character:logical_position_x()
		--    y   = y   or consul.debug.character:logical_position_y()
		--    cqi = cqi or consul.debug.character_cqi()
		--    consul.log:info("")
		--    return consul._game():unhide_character(cqi, x, y, queue)
		--end,
		garrison_residence = nil,
		settlement = nil,
		character = nil,
		faction = nil,
		unit = nil,
		unit_list = nil,
		military_force = nil,
		component = nil,

		_units = {},
		_units_to_write = {},
		--- A function that logs every environment in all of the game's Lua registries.
		--- Uses consul.pretty to format the output into the consul.log file.
		--- Very useful if you want to see what the game makes available to Lua.
		--- @function debug.logregistry
		--- @usage
		--- -- check consul.log for the output
		--- -- output may vary based on where the function is called
		--- -- I used it extensively when debugging different issues with the scripts
		--- consul.debug.logregistry()
		logregistry = function()
			local log = consul.new_log("debug:logregistry")
			local count = 0

			for k, v in pairs(debug.getregistry()) do
				count = count + 1
				local status, env = pcall(debug.getfenv, v)
				if status and type(env) == "table" then
					log:info("printing registry number " .. tostring(count))

					local env_copy = {}
					for key, val in pairs(env) do
						if key == "consul" then
							env_copy[key] = "removed"
						elseif key == "consul_game_events" then
							env_copy[key] = "removed"
						elseif key == "consul_game_events_decompiled_only" then
							env_copy[key] = "removed"
						else
							env_copy[key] = val
						end
					end

					log:info(consul.pretty(env_copy))
				end
			end
		end,
		--- A function that logs all available engine events to the consul.log file.
		--- Very useful if you want to see what events you can listen to.
		--- @function debug.logevents
		--- @usage
		--- -- check consul.log for the output
		--- consul.debug.logevents()
		logevents = function()
			local log = consul.new_log("debug:logevents")
			log:info("Dumping engine events:")
			log:info(consul.pretty(consul.log:get_all_events()))
		end,
		profi = {
			_profi = require("profi.profi"),
			_filename = "profi_report.txt",
			--- Starts the ProFi Lua profiler.
			--- @function debug.profi.start
			--- @tparam[opt] string filename The filename to save the report to (defaults to "profi_report.txt").
			--- @usage
			--- consul.debug.profi.start("my_report.txt")
			start = function(filename)
				consul.debug.profi._filename = filename or "profi_report.txt"
				consul.debug.profi._profi:start("once")
				return "profi.lua profiling started."
			end,
			--- Stops the ProFi Lua profiler and writes the report.
			--- @function debug.profi.stop
			--- @tparam[opt] string filename The filename to save the report to (overrides the one from start).
			--- @usage
			--- consul.debug.profi.stop()
			stop = function(filename)
				consul.debug.profi._profi:stop()
				local final_filename = filename or consul.debug.profi._filename
				consul.debug.profi._profi:writeReport(final_filename)
				consul.debug.profi._profi:reset()
				return "profi.lua profiling stopped. Report written to: " .. final_filename
			end,
		},
		profile = {
			_profiler = require("profile.profile"),
			_filename = "profile_report.txt",
			--- Starts the 2dengine Lua profiler.
			--- @function debug.profile.start
			--- @usage
			--- consul.debug.profile.start()
			start = function()
				consul.debug.profile._profiler.start()
				return "profile.lua profiling started."
			end,
			--- Stops the 2dengine Lua profiler, saves it to a file, and returns a report string.
			--- @function debug.profile.stop
			--- @tparam[opt] string filename The filename to save the report to (defaults to "profile_report.txt").
			--- @return string The profiling report.
			--- @usage
			--- local report = consul.debug.profile.stop("my_profile.txt")
			--- consul.console.write(report)
			stop = function(filename)
				consul.debug.profile._profiler.stop()
				local final_filename = filename or consul.debug.profile._filename
				local report = consul.debug.profile._profiler.report()

				local f = io.open(final_filename, "w")
				if f then
					f:write(report)
					f:close()
				end
				consul.debug.profile._profiler.reset()
				return "profile.lua profiling stopped. Report written to: " .. final_filename
			end,
		},

		--- Sets all diplomacy to false via (force_diplomacy) for all faction pairs.
		--- @function debug.disable_all_diplomacy
		--- @usage
		--- consul.debug.disable_all_diplomacy()
		disable_all_diplomacy = function()
			local diplomacy_types = {
				"trade agreement",
				"military access",
				"military alliance",
				"cancel military access",
				"alliance",
				"regions",
				"technology",
				"state gift",
				"payments",
				"vassal",
				"peace",
				"war",
				"join war",
				"break trade",
				"break alliance",
				"hostages",
				"marriage",
				"non aggression pact",
				"soft military access",
				"hard military access",
				"cancel soft military access",
				"defensive alliance",
				"client state",
				"form confederation",
				"break non aggression pact",
				"break soft military access",
				"break hard military access",
				"break defensive alliance",
				"break vassal",
				"break client state",
				"state gift unilateral",
			}
			local factions = consul.game.faction_list()
			local count = 0
			for i = 1, #factions do
				for j = 1, #factions do
					if i ~= j then
						for k = 1, #diplomacy_types do
							consul._game():force_diplomacy(factions[i], factions[j], diplomacy_types[k], false, false)
							count = count + 1
						end
					end
				end
			end
			return true
		end,
		_turn_start_time = 0,
		_measuring_turn = false,
	},

	-- setup consul
	setup = function()
		table.insert(events.UICreated, consul.console.commands.setup)
		table.insert(events.UICreated, consul.ui.OnUICreated)
		table.insert(events.UICreated, consul.compat.setup)
		table.insert(events.ComponentMoved, consul.ui.OnComponentMoved)
		if consul_build == "Attila" then
			table.insert(events.ComponentMoved, consul.ui.attila.OnComponentMoved)
			table.insert(events.TimeTrigger, consul.ui.attila.TimeTrigger)
			table.insert(events.UICreated, consul.ui.attila.OnUICreated)
		end
		table.insert(events.ComponentLClickUp, consul.ui.OnComponentLClickUp)
		table.insert(events.UICreated, consul.history.OnUICreated)
		table.insert(events.ComponentLClickUp, consul.history.OnComponentLClickUp)
		table.insert(events.ComponentLClickUp, consul.console.OnComponentLClickUp)
		-- access to 'EpisodicScripting' may be required
		-- load later to avoid any issues with the game
		table.insert(events.UICreated, consul.consul_scripts.setup)
		table.insert(events.UICreated, consul.battle.setup)
		table.insert(events.ComponentLClickUp, consul.consul_scripts.OnComponentLClickUp)
		table.insert(events.UICreated, consul.scriptum.setup)
		table.insert(events.ComponentLClickUp, consul.scriptum.OnComponentLClickUp)
		table.insert(events.UICreated, consul.changelog.OnUICreated)

		-- persistent debug logging
		local cfg = consul.config.read()
		if cfg.debug then
			if cfg.debug.log_level then
				consul.log:set_level(cfg.debug.log_level)
			end
			if cfg.debug.log_events then
				consul.log:log_events_all()
			end
		end

		-- turn time measurement
		table.insert(events.FactionTurnStart, function(context)
			if consul.debug._measuring_turn and context:faction():is_human() then
				local duration = os.clock() - consul.debug._turn_start_time
				local msg = "Turn cycle completed in " .. string.format("%.2f", duration) .. " seconds."
				consul.console.write(msg)
				consul.log:info(msg)
				consul.debug._measuring_turn = false
			end
		end)
	end,

	-- logging
	log = require("consul_logging").Logger.new("consul"),

	-- changelog
	changelog = {
		_data = require("consul_changelog"),
		format_all = function()
			if not consul.changelog._data then
				return "Changelog not found."
			end
			local data = consul.changelog._data
			local raw_log = data.header or ""
			local versions = {}
			for k, _ in pairs(data.notes or {}) do
				table.insert(versions, k)
			end
			table.sort(versions, function(a, b)
				return a > b
			end)

			local sep = ""
			for _, v in ipairs(versions) do
				local note = data.notes[v]
				local note_text = ""

				if type(note) == "table" then
					if note.common and note.common ~= "" then
						note_text = note.common
					end
					if note[consul_build] and note[consul_build] ~= "" then
						if note_text ~= "" then
							note_text = note_text .. "\n\n"
						end
						note_text = note_text .. "--- " .. consul_build .. " Specific ---\n" .. note[consul_build]
					end
				else
					note_text = tostring(note)
				end

				if note_text ~= "" then
					raw_log = raw_log .. sep .. "Version " .. v .. "\n" .. note_text
					sep = "\n\n----------------------------------------\n\n"
				end
			end

			-- Strip carriage returns which break UI layout engines
			return string.gsub(raw_log, "\r", "")
		end,
		OnUICreated = function(context)
			local log = consul.new_log("changelog:OnUICreated")
			local cfg = consul.config.read()
			if cfg.console.last_read_changelog ~= consul.VERSION then
				log:debug("New changelog available, printing to console")
				local text = consul.changelog.format_all()
				-- bypass history, directly write to UI
				local ui = consul.ui
				local c = ui.find(ui.console_output_text_1)
				if c then
					local current = c:GetStateText()
					if current == "" then
						c:SetStateText(text)
					else
						c:SetStateText(current .. "\n" .. text)
					end
				end
			end
		end,
	},

	new_log = function(name)
		return require("consul_logging").Logger.new(name, consul.log.log_level)
	end,

	--- Creates a new logger instance.<br>
	--- Very useful shortcut with predefined log levels.
	--- @function consul.new_logger
	--- @tparam[opt] string file_path The path to the log file.
	--- @tparam[opt] integer level The log level - 2 for info (default).
	--- @tparam[opt] string name The name of the logger.
	--- @treturn table A new Logger instance.
	--- @usage
	--- -- DISABLED = -2,
	--- -- TRACE = -1,
	--- -- INTERNAL = 0,
	--- -- DEBUG = 1,
	--- -- INFO = 2,
	--- -- WARN = 3,
	--- -- ERROR = 4,
	--- -- CRITICAL = 5,
	--- -- create default logger with level (INFO)
	--- local log = consul.new_logger("myfile.txt")
	--- -- or pass a custom logging level   (DEBUG)
	--- local log = consul.new_logger("myfile.txt", 1)
	--- -- log info message
	--- log:info("hello")!
	--- -- log debug message
	--- log:debug("debug!")
	--- -- log error message
	--- log:error("error!")
	new_logger = function(file_path, level, name)
		-- We pass the arguments to the original Logger.new in the correct order
		return require("consul_logging").Logger.new(file_path, level, name)
	end,

	-- contrib
	serpent = require("serpent.serpent"),
	inspect = require("inspect.inspect"),
	--- A function that pretty-prints a Lua value using 'penlight'.
	--- @function consul.pretty
	--- @param _obj Any Lua value to pretty-print.
	--- @return string The pretty-printed string.
	--- @usage
	--- -- pretty-print a table
	--- local table = { a = 1, b = 2, c = 3 }
	--- local pretty_table = consul.pretty(table)
	--- -- extra print to the console
	--- consul.console.write(pretty_table)
	--- -- or into the log file
	--- consul.log:info(pretty_table)
	pretty = function(...)
		-- here's a trick, we have to extract first argument
		-- and if it comes not nil from consul.pprinter.print then we use it instead
		-- extract the first argument
		local first_arg = select(1, ...)
		if first_arg ~= nil then
			local formatted = consul.pprinter.format(...)
			if formatted ~= nil then
				return formatted
			end
		end
		return require("penlight.pretty").write(...)
	end,

	--- A function that pretty-prints a Lua value using 'inspect.lua'.
	--- @function consul.pretty_inspect
	--- @param _obj Any Lua value to pretty-print.
	--- @return string The pretty-printed string.
	--- @usage
	--- -- pretty-print a table
	--- local table = { a = 1, b = 2, c = 3 }
	--- local pretty_table = consul.pretty_inspect(table)
	pretty_inspect = function(_obj)
		return consul.inspect(_obj, { newline = "\n" })
	end,

	-- table with base game events and decompiled game events
	-- decompiled events are these only found in game source but not in game pack files
	_events = require("consul_game_events"),

	-- compatibility patches for other mods
	compat = {

		setup = function()
			local log = consul.new_log("compat:setup")
			log:debug("Setting up compatibility patches")

			-- pcall each and log errors
			for k, v in pairs(consul.compat.patches) do
				local ok, result = pcall(v)
				if not ok then
					log:error("Error in patch: " .. k .. " " .. result)
				elseif result then
					-- 'result' is expected to be a boolean
					log:debug("Compat patch applied: " .. k)
				end
			end
		end,

		--- A function returning a boolean indicating if the DEI mod is loaded.
		--- @function compat.is_dei
		--- @return boolean True if DEI is loaded, false otherwise.
		is_dei = function()
			if consul_build ~= "Rome2" then
				return false
			end

			-- this file has only tables, it should be safe to require
			local dei_script = "script._lib.manpower.units"

			-- Attempt to require the script and check if DEI is loaded
			local ok, _ = pcall(require, dei_script)
			if not ok then
				return false
			end
			return true
		end,

		patches = {
			-- DEI removes the Prologue button in main menu
			-- it is done by modifying the sp_frame ui file which we override
			-- just disable the Prologue button in the main menu
			dei = function()
				local log = consul.new_log("compat:dei")

				if not consul.compat.is_dei() then
					return
				end

				-- If DEI is loaded, apply the patch
				log:debug("DEI detected, applying compatibility patch")

				-- Find and disable the Prologue button
				local button = consul.ui.find("button_introduction")
				if button then
					button:SetState("inactive")
					log:debug("Disabled Prologue button")
				else
					-- we may be in Campaign UI or Battle UI
					-- just skip, the proper way would be to check
					-- if we are in Frontend UI...
				end

				return true
			end,
		},
	},

	utils = {
		-- merges multiple tables and removes duplicates
		merge_and_deduplicate = function(...)
			local seen = {}
			local unique_items = {}
			local arg_tables = { ... }

			for _, input_table in ipairs(arg_tables) do
				-- Ensure the input is actually a table
				if type(input_table) == "table" then
					for _, item in ipairs(input_table) do
						-- We only handle strings here, as per your original request's data type
						if type(item) == "string" and not seen[item] then
							table.insert(unique_items, item)
							seen[item] = true
						end
					end
				end
			end

			-- Optionally sort the final list for consistent output
			table.sort(unique_items)

			return unique_items
		end,
	},

	battle = {
		script_identifier = "consul_battle",
		script_path = "consul/consul_battle.lua",
		battle_path = "",
		debug = false,

		setup = function()
			local log = consul.new_log("battle:setup")
			log:debug("Setting up battle stuff")

			local cfg = consul.config.read()
			if cfg.battle.use_in_battle then
				log:debug("Using consul in battle")
				consul.battle.init()
			else
				log:debug("Not using consul in battle")
				consul.battle.deinit()
			end
		end,

		deinit = function()
			consul._game():remove_custom_battlefield(consul.battle.script_identifier)
		end,

		init = function()
			local log = consul.new_log("battle:init")
			log:debug("Initializing battle stuff")

			consul.battle.deinit()
			if consul_build == "Rome2" then
				consul._game():add_custom_battlefield(
					consul.battle.script_identifier, -- string identifier
					0, -- x co-ord
					0, -- y co-ord
					1000000, -- radius around position
					false, -- will campaign be dumped
					"", -- loading override
					consul.battle.script_path, -- script override
					consul.battle.battle_path, -- entire battle override
					0 -- human alliance when battle override
				)
			elseif consul_build == "Attila" then
				consul._game():add_custom_battlefield(
					consul.battle.script_identifier, -- string identifier
					0, -- x co-ord
					0, -- y co-ord
					1000000, -- radius around position
					false, -- will campaign be dumped
					"", -- loading override
					consul.battle.script_path, -- script override
					consul.battle.battle_path, -- entire battle override
					0, -- human alliance when battle override,
					false, -- launch_battle_immediately
					false
				)
			end
		end,
	},

	config = {
		path = "consul.config",

		new = function()
			return {
				ui = {
					position = {
						x = 0,
						y = 0,
					},
					visibility = {
						root = 0,
						consul = 1,
						scriptum = 1,
					},
				},
				console = {
					autoclear = false,
					autoclear_after = 1,
					last_read_changelog = "0.0.0",
				},
				battle = {
					use_in_battle = false,
				},
				debug = {
					log_events = false,
					log_level = 2,
				},
			}
		end,

		validate = function(_config)
			return type(_config) == "table"
				and type(_config.ui) == "table"
				and type(_config.ui.position) == "table"
				and type(_config.ui.position.x) == "number"
				and type(_config.ui.position.y) == "number"
				and type(_config.ui.visibility) == "table"
				and type(_config.ui.visibility.root) == "number"
				and type(_config.ui.visibility.consul) == "number"
				and type(_config.ui.visibility.scriptum) == "number"
				and type(_config.console) == "table"
				and type(_config.console.autoclear) == "boolean"
				and type(_config.console.autoclear_after) == "number"
				and type(_config.console.last_read_changelog) == "string"
				and type(_config.battle) == "table"
				and type(_config.battle.use_in_battle) == "boolean"
				and type(_config.debug) == "table"
				and type(_config.debug.log_events) == "boolean"
				and type(_config.debug.log_level) == "number"
		end,

		--- A function that reads the config file and writes it back to the file.
		--- @function config.process
		--- @tparam[opt] function func A function that takes a config table as an argument.
		--- @usage
		--- consul.config.process(function(cfg)
		---     cfg.ui.position.x = 100
		---     cfg.ui.position.y = 100
		--- end)
		process = function(func)
			local log = consul.new_log("config:process")
			log:debug("Processing config file: " .. consul.config.path)
			local cfg = consul.config.read()
			func(cfg)
			consul.config.write(cfg)
		end,

		--- A function that reads the config file and returns a table.
		--- @function config.read
		--- @return table The config table.
		--- @usage
		--- local cfg = consul.config.read()
		read = function()
			local log = consul.new_log("config:read")
			local serpent = consul.serpent
			local config = consul.config

			log:debug("Reading config file: " .. config.path)

			local f = io.open(config.path, "r")
			if f then
				log:debug("File exists: " .. config.path)
				local f_content = f:read("*all")
				f:close()

				local ok, cfg = serpent.load(f_content)
				if ok then
					if cfg.console and type(cfg.console.last_read_changelog) ~= "string" then
						cfg.console.last_read_changelog = "0.0.0"
					end
					if config.validate(cfg) then
						return cfg
					else
						log:error("Config file is invalid: " .. config.path)
					end
				else
					log:warn("Could not load config: " .. cfg) -- Log the error message from serpent.load
				end
			end

			log:debug("Creating default config file: " .. config.path)
			local cfg = config.new()
			config.write(cfg)
			return cfg
		end,

		--- A function that writes the config table to the config file.
		--- @function config.write
		--- @tparam table cfg The config table to write.
		--- @usage
		--- consul.config.write(cfg)
		write = function(cfg)
			local log = consul.new_log("config:write")
			log:debug("Writing config file: " .. consul.config.path)
			local f = io.open(consul.config.path, "w")
			if f then
				-- remember to pass maxlevel as Rome2 LUA has no math.huge defined
				f:write(consul.serpent.dump(cfg, { maxlevel = 10000, comment = false, indent = "\t" }))
				f:close()
			end
		end,
	},

	ui = {
		-- contains all the components
		root = (function()
			if consul_build == "Attila" then
				return "consul"
			end
			return "consul_scriptum"
		end)(),
		-- path to the consul template for Attila
		template_attila = "ui/common ui/consul",
		-- contains the consul listview
		consul = "room_list",
		-- contains the scriptum listview
		scriptum = "friends_list",
		-- contains the console
		console = "consul_scriptum_console",
		-- contains the input field
		console_input = "consul_console_input",
		-- sends the input to the console
		console_send = "consul_send_cmd",
		-- displays console output
		console_output_text_1 = "console_output_text1",
		-- minimizes the consul listview
		consul_minimize = "room_list_button_minimize",
		-- turns visibility of the root component on and off
		button_toggle = "consul_scriptum_button_toggle",
		-- minimizes the scriptum listview
		scriptum_minimize = "friends_list_button_minimize",
		-- history up
		history_up = "consul_history_up_btn",
		-- history down
		history_down = "consul_history_down_btn",

		-- scriptum entry
		scriptum_entry = "scriptum_entry",
		scriptum_entry_text = "scriptum_entry_text",

		-- consul entries
		consul_exterminare_entry = "consul_exterminare_entry",
		consul_exterminare_script = "consul_exterminare_script",
		consul_transfersettlement_entry = "consul_transfersettlement_entry",
		consul_transfersettlement_script = "consul_transfersettlement_script",
		consul_adrebellos_entry = "consul_adrebellos_entry",
		consul_adrebellos_script = "consul_adrebellos_script",
		consul_force_make_peace_entry = "consul_force_make_peace_entry",
		consul_force_make_peace_script = "consul_force_make_peace_script",
		consul_force_make_war_entry = "consul_force_make_war_entry",
		consul_force_make_war_script = "consul_force_make_war_script",
		consul_force_make_vassal_entry = "consul_force_make_vassal_entry",
		consul_force_make_vassal_script = "consul_force_make_vassal_script",
		consul_force_exchange_garrison_entry = "consul_force_exchange_garrison_entry",
		consul_force_exchange_garrison_script = "consul_force_exchange_garrison_script",
		consul_replenish_action_points_entry = "consul_replenish_action_points_entry",
		consul_replenish_action_points_script = "consul_replenish_action_points_script",
		consul_vexatio_provinciae_entry = "consul_vexatio_provinciae_entry",
		consul_vexatio_provinciae_script = "consul_vexatio_provinciae_script",
		consul_sedatio_provinciae_entry = "consul_sedatio_provinciae_entry",
		consul_sedatio_provinciae_script = "consul_sedatio_provinciae_script",
		consul_incrementum_regio_entry = "consul_incrementum_regio_entry",
		consul_incrementum_regio_script = "consul_incrementum_regio_script",

		-- keep internals private
		_UIRoot = nil, -- UIComponent(context.component)
		_UIComponent = nil, -- UIComponent
		_UIContext = nil, -- context
		_UIContextComponent = nil, -- context.component

		debug = {
			get_id_chains = function(component)
				local chain = {}
				local current = component

				while current do
					table.insert(chain, 1, tostring(current:Id())) -- Insert at front to keep order
					local parent = current:Parent()
					if not parent then
						break
					end
					current = consul.ui._UIComponent(parent) -- Assuming 'Parent()' is the method to get the container
				end

				return chain
			end,

			get_component_report = function(component)
				local safe_call = function(obj, method)
					if not obj[method] then
						return "n/a"
					end
					if type(obj[method]) ~= "function" then
						return tostring(obj[method])
					end

					local ok, val1, val2, val3, val4 = pcall(function()
						return obj[method](obj)
					end)
					if not ok then
						return "error"
					end

					-- handle multiple returns
					if val4 ~= nil then
						return { val1, val2, val3, val4 }
					end
					if val3 ~= nil then
						return { val1, val2, val3 }
					end
					if val2 ~= nil then
						return { val1, val2 }
					end
					return val1
				end

				local report = {
					Id = safe_call(component, "Id"),
					Hierarchy = table.concat(consul.ui.debug.get_id_chains(component), " > "),
					properties = {
						Id = safe_call(component, "Id"),
						IsInteractive = safe_call(component, "IsInteractive"),
						Priority = safe_call(component, "Priority"),
						ChildCount = safe_call(component, "ChildCount"),
						-- positions & dimensions
						Bounds = safe_call(component, "Bounds"),
						Dimensions = safe_call(component, "Dimensions"),
						Position = safe_call(component, "Position"),
						Width = safe_call(component, "Width"),
						Height = safe_call(component, "Height"),
						CurrentState = safe_call(component, "CurrentState"),
						Visible = safe_call(component, "Visible"),
						GetStateText = safe_call(component, "GetStateText"),
						GetTooltipText = safe_call(component, "GetTooltipText"),
						CallbackId = safe_call(component, "CallbackId"),
					},
					children = {},
				}

				local count = safe_call(component, "ChildCount")
				if type(count) == "number" and count > 0 then
					for i = 0, count - 1 do
						local child = component:Find(i)
						if child then
							table.insert(report.children, tostring(consul.ui._UIComponent(child):Id()))
						end
					end
				end

				return report
			end,

			format_report = function(report)
				local p = report.properties
				local output = {}
				local f = function(v)
					return (type(v) == "table") and table.concat(v, ", ") or tostring(v)
				end

				table.insert(output, "--------------------------------------------------------------------------------")
				table.insert(output, "Id:                               " .. f(p.Id))
				table.insert(output, "CallbackId:                   " .. f(p.CallbackId))
				table.insert(output, "Visible:                         " .. f(p.Visible))
				table.insert(output, "ChildCount:                  " .. f(p.ChildCount))
				table.insert(output, "IsInteractive:                 " .. f(p.IsInteractive))
				table.insert(output, "CurrentState:                 " .. f(p.CurrentState))
				table.insert(output, "Priority:                       " .. f(p.Priority))
				table.insert(output, "Position:                      " .. f(p.Position))
				table.insert(output, "Bounds, Dimensions:     " .. f(p.Bounds) .. ", " .. f(p.Dimensions))
				table.insert(output, "Width, Height:             " .. f(p.Width) .. ", " .. f(p.Height))
				table.insert(output, "GetStateText:           " .. f(p.GetStateText))
				table.insert(output, "GetTooltipText:         " .. f(p.GetTooltipText))
				table.insert(output, "--------------------------------------------------------------------------------")
				table.insert(output, "Hierarchy:  " .. tostring(report.Hierarchy))

				if #report.children > 0 then
					table.insert(
						output,
						"--------------------------------------------------------------------------------"
					)
					table.insert(output, "Children: ")
					for _, child_id in ipairs(report.children) do
						table.insert(output, "  " .. child_id)
					end
				end

				return table.concat(output, "\n")
			end,
		},

		--- A shortcut function that finds a UIComponent by key.<br>
		--- Contains some guards to make sure the function works as expected.
		--- @function ui.find
		--- @tparam string key The key of the UIComponent to find.
		--- @return UIComponent The UIComponent found.
		--- @usage
		--- local c = consul.ui.find("consul_exterminare_entry")
		--- consul.console.write(c:Visible())
		find = function(key)
			local log = consul.new_log("ui:find")

			-- make sure the key is of type string- if not, and you pass something
			-- that cannot be resolved to a string, it may break the upstream game code
			-- making all kind of weird things happen
			if type(key) ~= "string" then
				return "error: key passed to find is not a string"
			end

			-- try recreating the UIComponent in case something bad happened
			if not consul.ui._UIRoot then
				log:warn("Recreating UIComponent: " .. tostring(consul.ui._UIContext))
				consul.ui._UIRoot = UIComponent(consul.ui._UIContext.component)
			end

			-- if still nil, return error and log it
			if (not consul.ui._UIRoot) or not consul.ui._UIComponent then
				log:error("No access to UIComponent")
				return nil
			end

			-- try to find locally and check if it still works
			local c = consul.ui._UIComponent(consul.ui._UIRoot:Find(key))

			-- check if component handling is still functional
			if (not consul.ui._UIRoot) or not consul.ui._UIComponent then
				log:error("Something went wrong with the UIComponent handling; UIComponent is nil")
				return nil
			end

			-- c is nil
			if not c then
				log:warn("Could not find component: " .. key)
				return nil
			end

			-- even if the component is found, some actions may not work
			-- assume that everything works if Visible is not nil (it may be any method)
			if c:Visible() == nil then
				log:error("Something went wrong with the UIComponent handling; visible is nil")
				return nil
			end

			-- all fine
			return c
		end,

		-- moves the consul root to the center of the screen
		-- trying to make docking work in the ui files is a pain
		-- so we just move it to the center of the screen
		-- lets calculate the proper position - resolution can vary

		--- A function that moves the consul root to the center of the screen.
		--- @function ui.MoveRootToCenter
		--- @usage
		--- consul.ui.MoveRootToCenter()
		MoveRootToCenter = function()
			-- shorthand
			local ui = consul.ui

			-- just move it!
			local x = ui._UIRoot:Width()
			local y = ui._UIRoot:Height()
			local w = 700
			local h = 500
			local cx = (x / 2) - (w / 2)
			local cy = (y / 2) - (h / 2)

			-- thank you
			ui.find(ui.root):MoveTo(cx + w, cy)
		end,

		-- event handler to be set in the main script
		OnUICreated = function(context)
			local log = consul.new_log("ui:OnUICreated")
			log:debug("UI created start")

			local ui = consul.ui
			ui._UIContext = context
			ui._UIContextComponent = context.component

			-- if UIComponent is nil grab it from registry
			if not UIComponent then
				log:warn("UIComponent is nil; trying to grab it from lua registry")

				for k, v in pairs(debug.getregistry()) do
					local status, env = pcall(debug.getfenv, v)

					if status and type(env) == "table" then
						if env.UIComponent ~= nil then
							log:info("Found UIComponent in environment of registry index: " .. tostring(k))
							UIComponent = env.UIComponent
							break
						end
					end
				end
			end

			if UIComponent == nil then
				log:error("UIComponent is nil!")
				return
			end

			-- set the root and UIComponent
			ui._UIRoot = UIComponent(context.component)
			ui._UIComponent = UIComponent

			log:debug("OnUICreated end")
		end,

		attila = {

			xx = 0,
			yy = 0,
			should_move = false,

			-- to avoid creating consul multiple times in battle, as the UI is recreated multiple times
			-- this is strange behavior because the UICreated event is not "called"; it is called but does not
			-- appear in the log of the events... if that makes sense lol
			created = false,

			OnUICreated = function()
				local ui = consul.ui
				local log = consul.new_log("ui.attila:OnUICreated")
				log:debug("Attila specific OnUICreated start")

				if consul.ui.attila.created then
					log:debug("Consul already created, skipping...")
					return
				end

				ui._UIRoot:CreateComponent(ui.root, ui.template_attila)
				ui.MoveToConfigPosition()
				--ui.find(ui.consul):TriggerAnimation('move_up')
				ui.find(ui.scriptum):TriggerAnimation("move_up")
				ui.find(ui.consul_minimize):SimulateLClick()
				ui.find(ui.scriptum_minimize):SimulateLClick()

				consul.ui.attila.created = true
				log:debug("Attila specific OnUICreated end")
			end,

			OnComponentMoved = function(context)
				local log = consul.new_log("ui.attila:OnComponentMoved")
				log:debug("Attila specific OnComponentMoved start")

				if context.string ~= consul.ui.root then
					return
				end
				local ui, attila = consul.ui, consul.ui.attila
				-- in campaign
				if consul._game() ~= nil then
					consul._game():add_time_trigger("consul_move_trigger", 0)
					-- in battle
				elseif consul_build == "Attila" and consul.is_in_battle_script then
					function __consul_attila_ui_battle_single_shot_timer()
						consul.ui.attila.TimeTrigger()
					end

					consul.bm:register_singleshot_timer("__consul_attila_ui_battle_single_shot_timer", 0)
				end
				local c = ui.find(consul.ui.root)
				attila.xx, attila.yy = c:Position()
				attila.should_move = true
				c:SetVisible(false)

				log:debug("Attila specific OnComponentMoved end")
			end,

			TimeTrigger = function()
				local log = consul.new_log("ui.attila:TimeTrigger")
				log:debug("Attila specific TimeTrigger start")

				local ui, attila = consul.ui, consul.ui.attila
				local c = ui.find(ui.root)
				local x, y = c:Position()
				local xx, yy = attila.xx, attila.yy
				-- always set visible, the component may be moved without changing position
				c:SetVisible(true)
				if (x ~= xx or y ~= yy) and attila.should_move == true then
					c:MoveTo(xx, yy)
					attila.should_move = false
				end

				log:debug("Attila specific TimeTrigger end")
			end,
		},

		-- event handler to be set in the main script
		-- moves the consul root to the position saved in config
		-- if position is 0,0 it moves to center

		--- A function that moves the consul root to the position saved in config.<br>
		--- If position is 0,0 it moves to center.
		--- @function ui.MoveToConfigPosition
		--- @usage
		--- consul.ui.MoveToConfigPosition()
		MoveToConfigPosition = function()
			local ui = consul.ui
			local cfg = consul.config.read()
			local x = cfg.ui.position.x
			local y = cfg.ui.position.y
			local c = ui.find(ui.root)
			if x == 0 and y == 0 then
				-- move to center
				local screen_x = ui._UIRoot:Width()
				local screen_y = ui._UIRoot:Height()
				local w = 700
				local h = 500
				local cx = (screen_x / 2) - (w / 2)
				local cy = (screen_y / 2) - (h / 2)
				c:MoveTo(cx + w, cy)
			else
				c:MoveTo(x, y)
			end
			return c
		end,

		-- event handler to be set in the main script
		-- handles any click event for the consul
		OnComponentLClickUp = function(context)
			-- shorthand
			local ui = consul.ui
			local log = consul.new_log("ui:OnComponentLClickUp")
			log:trace("Clicked on: " .. context.string)

			-- reload scriptum when any component containing consul is clicked
			-- this ensures scripts are fresh even if the reopen logic doesn't trigger
			if string.find(context.string, "consul") then
				consul.scriptum.setup()
			end

			-- top menu toggle button
			if context.string == ui.button_toggle then
				log:debug("Toggled visibility of: consul root")

				-- find the root component
				local r = ui.MoveToConfigPosition()

				-- toggle visibility
				r:SetVisible(not r:Visible())

				-- save to config
				consul.config.process(function(_cfg)
					_cfg.ui.visibility.root = r:Visible() and 1 or 0
				end)

				-- setup scriptum
				-- doing it here allows for
				-- reload each time the consul is toggled
				consul.scriptum.setup()
				return
			end

			-- scriptum listview minimized
			if context.string == ui.scriptum_minimize then
				log:debug("Toggled visibility of: scriptum listview")

				-- find the component
				local c = ui.find(ui.console)

				-- toggle visibility
				c:SetVisible(not c:Visible())

				-- save to config
				consul.config.process(function(cfg)
					cfg.ui.visibility.scriptum = c:Visible() and 1 or 0
				end)

				return
			end
		end,

		-- event handler to be set in the main script
		-- handles movement of the consul components
		-- we want to save position to config - user shouldn't
		-- have to move the consul every time he comes from a battle
		OnComponentMoved = function(context)
			-- shorthand
			local ui = consul.ui
			local log = consul.new_log("ui:OnComponentMoved")
			local config = consul.config

			-- when root is moved
			if context.string == ui.root then
				log:debug("Moved: consul root")

				-- grab the component
				local c = ui.find(ui.root)
				local x, y = c:Position()

				-- save the position to config
				local cfg = config.read()
				cfg.ui.position.x = x
				cfg.ui.position.y = y

				-- todo grab other components settings

				-- write the config
				config.write(cfg)
			end
		end,
	},

	history = {
		-- the path to the history file
		path = "consul.history",
		-- contains the history of the console
		entries = {},
		-- the current index in the history
		index = 0,
		-- the current entry in the history
		current = "",
		-- the maximum number of entries in the history
		max = 100,

		-- adds an entry to the history
		add = function(entry)
			if entry == "" then
				return
			end

			local hst = consul.history
			if #hst.entries == 0 or hst.entries[#hst.entries] ~= entry then
				table.insert(hst.entries, entry)
				if #hst.entries > hst.max then
					table.remove(hst.entries, 1)
				end
				-- write the entry to the history file
				local f = io.open(hst.path, "a")
				if f then
					f:write(entry .. "\n")
					f:close()
				end
			end
			hst.index = #hst.entries + 1
			hst.current = ""
		end,

		-- reads the initial history from the history file
		read = function()
			local hst = consul.history
			local f = io.open(hst.path, "r")
			if f then
				for line in f:lines() do
					table.insert(hst.entries, line)
				end
				f:close()
			else
				local f = io.open(hst.path, "w")
				if f then
					f:close()
				end
			end
			hst.index = #hst.entries + 1
			hst.current = ""
		end,

		-- appends the current entry to the history file
		append = function(entry)
			local hst = consul.history
			local f = io.open(hst.path, "a")
			if f then
				f:write(entry .. "\n")
				f:close()
			end
		end,

		-- moves the history index up
		up = function()
			local hst = consul.history
			if hst.index > 1 then
				hst.index = hst.index - 1
				hst.current = hst.entries[hst.index]
			end
		end,

		-- moves the history index down
		down = function()
			local hst = consul.history
			if hst.index < #hst.entries then
				hst.index = hst.index + 1
				hst.current = hst.entries[hst.index]
			end
		end,

		-- when UI is created we read the history from the file
		OnUICreated = function(context)
			consul.history.read()
		end,

		-- register event handler for handling the buttons that move the history
		OnComponentLClickUp = function(context)
			-- shorthand
			local ui = consul.ui
			local log = consul.new_log("history:OnComponentLClickUp")
			local hst = consul.history

			if context.string == ui.console_send then
				log:debug("Adding entry to history")

				local c = ui.find(ui.console_input)
				local entry = c:GetStateText()
				hst.add(entry)
				return
			end

			if context.string == ui.history_up then
				log:debug("Moving history up")

				hst.up()
				local c = ui.find(ui.console_input)

				-- if current input is equal to the current history entry
				-- move history index up
				if c:GetStateText() == hst.current then
					hst.up()
				end

				c:SetStateText(hst.current)
				return
			elseif context.string == ui.history_down then
				log:debug("Moving history down")
				hst.down()
				local c = ui.find(ui.console_input)
				c:SetStateText(hst.current)
				return
			end
		end,
	},

	console = {
		-- dump the console output to a file
		output_path = "consul.output",

		--- Clear all text currently shown in the Consul console output panel.
		--- @function console.clear
		--- @usage consul.console.clear()
		clear = function()
			local ui = consul.ui
			ui.find(ui.console_output_text_1):SetStateText("")
		end,

		-- reads the input from the console

		--- A function that reads the input from the console.
		--- @function console.read
		--- @return string The input text.
		--- @usage
		--- local input = consul.console.read()
		--- consul.console.write(input)
		read = function()
			local ui = consul.ui
			local c = ui.find(ui.console_input)
			return c:GetStateText()
		end,

		--- Write a message to the Consul console output panel and append it to consul.output.
		--- @function console.write
		--- @tparam string msg Message text to append.
		--- @usage consul.console.write("hello from script")
		write = function(msg)
			-- raw dump to file
			local f = io.open(consul.console.output_path, "a")
			if f then
				f:write(msg .. "\n")
				f:close()
			end

			local ui = consul.ui

			-- find the console output component
			local c = ui.find(ui.console_output_text_1)

			-- grab the current text
			text = c:GetStateText()

			-- if text is empty, we don't want to add a newline
			if text == "" then
				c:SetStateText(msg)
			else
				c:SetStateText(text .. "\n" .. msg)
			end
		end,

		-- defines the commands that can be executed in the console
		commands = {

			-- settings for the console commands
			settings = {
				autoclear = false,
				autoclear_after = 1,
				_autoclear_current = 0,
			},

			_is_setup = false,

			-- Tracks dynamically injected commands per-module to prevent cross-module ghosting on reload
			_module_keys = {},

			-- Generic loader to dynamically merge ANY correctly formatted command module into the consul framework.

			--- A function that loads a module into the console commands.
			--- @function console.commands.load_module
			--- @tparam string module_name The name of the module to load.
			--- @return boolean True if the module was loaded successfully, false otherwise.
			--- @return string The error message if the module was not loaded successfully.
			--- @usage
			--- local ok, err = consul.console.commands.load_module('consul_commands')
			--- if not ok then
			---     consul.console.write(err)
			--- end
			load_module = function(module_name)
				local cmds = consul.console.commands
				local cfg = consul.config.read()
				local log = consul.new_log("console:commands:load_module")

				if not string.find(package.path, ";consul/?.lua") then
					package.path = package.path .. ";consul/?.lua"
				end

				-- Initialize tracking array for this specific module
				if not cmds._module_keys[module_name] then
					cmds._module_keys[module_name] = { exact = {}, starts_with = {} }
				end

				-- Strip previously loaded custom commands from THIS module to prevent ghosting
				for _, k in ipairs(cmds._module_keys[module_name].exact) do
					cmds.exact[k] = nil
				end
				for _, k in ipairs(cmds._module_keys[module_name].starts_with) do
					cmds.starts_with[k] = nil
				end
				cmds._module_keys[module_name] = { exact = {}, starts_with = {} }

				local ok, res
				package.loaded[module_name] = nil
				ok, res = pcall(require, module_name)

				if ok and type(res) == "table" then
					if type(res.exact) == "table" then
						for k, v in pairs(res.exact) do
							cmds.exact[k] = v
							table.insert(cmds._module_keys[module_name].exact, k)
							if v.setup then
								pcall(v.setup, cfg)
							end
						end
					end
					if type(res.starts_with) == "table" then
						for k, v in pairs(res.starts_with) do
							cmds.starts_with[k] = v
							table.insert(cmds._module_keys[module_name].starts_with, k)
							if v.setup then
								pcall(v.setup, cfg)
							end
						end
					end
					log:debug("Module '" .. module_name .. "' successfully loaded.")
					return true, "Module loaded."
				else
					log:debug("Module '" .. module_name .. "' not available: " .. tostring(res))
					return false, tostring(res)
				end
			end,

			load_custom = function()
				local cmds = consul.console.commands
				local log = consul.new_log("console:commands:load_custom")
				log:debug("Start...")

				local ok_vfs, _ = cmds.load_module("consul_commands")
				if ok_vfs then
					log:debug("consul_commands loaded successfully.")
				end

				local ok_root, _ = cmds.load_module("consul_custom_commands")
				if ok_root then
					log:debug("consul_custom_commands loaded successfully.")
				end

				if consul.compat.is_dei() then
					local ok_dei, _ = cmds.load_module("consul_commands_dei")
					if ok_dei then
						log:debug("DEI-specific commands loaded successfully.")
					end
				end

				return "Custom commands merged and loaded successfully."
			end,

			-- setups the commands
			setup = function()
				local log = consul.new_log("console:commands:setup")
				local cfg = consul.config.read()
				local commands = consul.console.commands

				log:debug("Setting up console commands")

				-- if already setup, skip
				if commands._is_setup then
					log:debug("Already setup")
					return
				end

				for k, v in pairs(commands.exact) do
					if v.setup then
						v.setup(cfg)
					end
				end
				for k, v in pairs(commands.starts_with) do
					if v.setup then
						v.setup(cfg)
					end
				end

				local ok, err = pcall(commands.load_custom)
				if not ok then
					log:error("Error loading custom commands: " .. tostring(err))
				else
					log:debug("Custom commands loaded successfully.")
				end

				commands._is_setup = true
			end,

			-- these should include extra space if they take params
			starts_with = {
				["/r "] = {
					help = function()
						return "Shorthand for 'return <Lua code>. " .. "Example: /r 2 + 2"
					end,
					func = function(_cmd)
						return "return " .. string.sub(_cmd, 4)
					end,
					exec = true,
					returns = true,
				},
				["/p "] = {
					help = function()
						return "Pretty-prints a Lua value using 'penlight'. " .. "Example: /p _G"
					end,
					func = function(_cmd)
						return "return consul.pretty(" .. string.sub(_cmd, 4) .. ")"
					end,
					exec = true,
					returns = true,
				},
				["/p2 "] = {
					help = function()
						return "Pretty-prints a Lua value using 'inspect'. " .. "Example: /p2 _G"
					end,
					func = function(_cmd)
						return "return consul.pretty_inspect(" .. string.sub(_cmd, 4) .. ")"
					end,
					exec = true,
					returns = true,
				},
				["/autoclear_after"] = {
					help = function()
						return "Sets number of entries after which console will autoclear. "
					end,
					func = function(_cmd)
						-- convert to number
						local n = tonumber(string.sub(_cmd, 18))
						if not n then
							return "Invalid number: " .. tostring(n)
						end

						-- write to config
						consul.console.commands.settings.autoclear_after = n
						local cfg = consul.config.read()
						cfg.console.autoclear_after = n
						consul.config.write(cfg)

						return tostring(n)
					end,
					exec = false,
					returns = true,
					setup = function(cfg)
						consul.console.commands.settings.autoclear_after = cfg.console.autoclear_after
					end,
				},
				["/log_game_event "] = {
					help = function()
						return "Logs event Example: /log_game_event CharacterCreated"
					end,
					func = function(_cmd)
						local event = string.sub(_cmd, 17)
						if event == "" then
							return "No event specified"
						end
						consul.log:log_events({ event }, function()
							return true
						end)
					end,
					exec = false,
					returns = true,
				},
				["/profi_stop"] = {
					help = function()
						return "Stop profi.lua and save to <filename>."
					end,
					func = function(_cmd)
						local arg = string.sub(_cmd, 13)
						if #_cmd <= 11 or arg == "" then
							return "Error: No filename provided. Usage: /profi_stop <filename>"
						end
						return consul.debug.profi.stop(arg)
					end,
					exec = false,
					returns = true,
				},
				["/profiler_stop"] = {
					help = function()
						return "Stop profiler.lua and save to <filename>."
					end,
					func = function(_cmd)
						local arg = string.sub(_cmd, 16)
						if #_cmd <= 14 or arg == "" then
							return "Error: No filename provided. Usage: /profiler_stop <filename>"
						end
						return consul.debug.profile.stop(10, arg)
					end,
					exec = false,
					returns = true,
				},
				["/consul_log_level "] = {
					help = function()
						return "Set consul log level. Levels: -2 DISABLED -1 TRACE 0 INTERNAL 1 DEBUG 2 INFO 3 WARN 4 ERROR 5 CRITICAL."
					end,
					func = function(_cmd)
						local n = tonumber(string.sub(_cmd, 19))
						if not n then
							return "Invalid number. Usage: /consul_log_level <integer>"
						end
						consul.log:set_level(n)
						consul.config.process(function(cfg)
							cfg.debug.log_level = n
						end)
						return "Log level set to: " .. tostring(n)
					end,
					exec = false,
					returns = true,
					setup = function(cfg)
						if cfg.debug and cfg.debug.log_level then
							consul.log:set_level(cfg.debug.log_level)
						end
					end,
				},
			},
			exact = {
				["/reload_custom_commands"] = {
					help = function()
						return "Reload commands from consul_custom_commands.lua"
					end,
					func = function()
						return consul.console.commands.load_custom()
					end,
					exec = false,
					returns = true,
				},
				["/help"] = {
					help = function()
						return "Show help message."
					end,
					func = function(...)
						-- using raw \t doesn't work as it requires a string
						local tab = consul.tab

						-- build the help message from other commands
						-- so all the keys so they are aligned
						local keys = {}
						for k, v in pairs(consul.console.commands.exact) do
							table.insert(keys, k)
						end
						for k, v in pairs(consul.console.commands.starts_with) do
							table.insert(keys, k)
						end
						table.sort(keys)

						-- now we have to take longest key to calculate the padding
						local max = 0
						for _, v in pairs(keys) do
							if string.len(v) > max then
								max = string.len(v)
							end
						end

						-- now we can build the help message
						local help = "Console commands:\n"
						for _, k in pairs(keys) do
							local v = consul.console.commands.exact[k] or consul.console.commands.starts_with[k]
							local padding = string.rep(" ", max - string.len(k) + 1)
							help = help .. tab .. k .. padding .. " - " .. v.help() .. "\n"
						end

						-- strip the last newline
						return string.sub(help, 1, string.len(help) - 1)
					end,
					exec = false,
					returns = true,
				},
				["/clear"] = {
					help = function()
						return "Clear console output."
					end,
					func = function()
						consul.console.clear()
					end,
					exec = false,
					returns = false,
				},
				["/history"] = {
					help = function()
						return "Print console history."
					end,
					func = function()
						local hst = consul.history
						local out = ""
						for _, v in pairs(hst.entries) do
							out = out .. v .. "\n"
						end
						return out
					end,
					exec = false,
					returns = true,
				},
				["/autoclear"] = {
					help = function()
						return "Toggles console autoclear setting."
					end,
					func = function()
						local commands = consul.console.commands

						commands.settings.autoclear = not commands.settings.autoclear
						local cfg = consul.config.read()
						cfg.console.autoclear = commands.settings.autoclear
						consul.config.write(cfg)
						return tostring(commands.settings.autoclear)
					end,
					exec = false,
					returns = true,
					setup = function(cfg)
						consul.console.commands.settings.autoclear = cfg.console.autoclear
					end,
				},
				["/changelog"] = {
					help = function()
						return "Prints the changelog."
					end,
					func = function()
						return consul.changelog.format_all()
					end,
					exec = false,
					returns = true,
				},
				["/changelog_read"] = {
					help = function()
						return "Marks current changelog as read."
					end,
					func = function()
						local cfg = consul.config.read()
						cfg.console.last_read_changelog = consul.VERSION
						consul.config.write(cfg)
						consul.console.clear()
						return "Changelog marked as read for version "
							.. consul.VERSION
							.. ". Type /changelog to view it again."
					end,
					exec = false,
					returns = true,
				},
				["/faction_list"] = {
					help = function()
						return "Prints the list of factions."
					end,
					func = function()
						return consul.pretty(consul.game.faction_list())
					end,
					exec = false,
					returns = true,
				},
				["/region_list"] = {
					help = function()
						return "Prints the list of regions."
					end,
					func = function()
						return consul.pretty(consul.game.region_list())
					end,
					exec = false,
					returns = true,
				},
				["/debug_onclick"] = {
					_is_running = false,

					help = function()
						return "Prints debug information of the clicked component."
					end,

					func = function()
						local command = consul.console.commands.exact["/debug_onclick"]
						local console = consul.console

						if command._is_running then
							command._is_running = false
							return
						end

						table.insert(events.ComponentLClickUp, function(context)
							if context.string == consul.ui.console_input then
								return
							end
							if command._is_running then
								console.clear()
								local component = UIComponent(context.component)
								local report = consul.ui.debug.get_component_report(component)
								console.write(consul.ui.debug.format_report(report))
								consul.debug.component = component
							end
						end)

						command._is_running = true
					end,
					exec = false,
					returns = true,
				},
				["/debug_mouseover"] = {
					_is_running = false,
					help = function()
						return "Prints debug information of the mouseover component."
					end,
					func = function()
						local command = consul.console.commands.exact["/debug_mouseover"]
						local console = consul.console

						if command._is_running then
							command._is_running = false
							return
						end

						table.insert(events.ComponentMouseOn, function(context)
							if context.string == consul.ui.console_input then
								return
							end
							if command._is_running then
								console.clear()
								local component = UIComponent(context.component)
								local report = consul.ui.debug.get_component_report(component)
								console.write(consul.ui.debug.format_report(report))
							end
						end)

						command._is_running = true
					end,
					exec = false,
					returns = true,
				},
				["/consul_debug_events"] = {
					help = function()
						return "Toggle persistent event logging at startup."
					end,
					func = function()
						local newState = ""
						consul.config.process(function(cfg)
							cfg.debug.log_events = not cfg.debug.log_events
							newState = tostring(cfg.debug.log_events)
						end)
						return "Persistent early event logging: " .. newState
					end,
					exec = false,
					returns = true,
				},
				["/logregistry"] = {
					help = function()
						return "Logs all Lua registries and environments to consul.log."
					end,
					func = function()
						consul.debug.logregistry()
						return "All Lua registries logged to consul.log"
					end,
					exec = false,
					returns = true,
				},
				["/debug"] = {
					_is_running = false,

					help = function()
						return "Prints debug information about characters,settlements,etc."
					end,

					-- when you mouse over a unit after selecting a character
					-- the game uses a callback, so each unit you mouse over
					-- is just a 'LandUnit i' component string - we need to parse it
					-- and then map to the actual unit index to the character unit list
					_debug_character_unit_list = {

						OnCharacterSelected = function(context)
							local command = consul.console.commands.exact["/debug"]
							if not command._is_running then
								return
							end

							local unit_list = context:character():military_force():unit_list()
							local units = {}
							local units_to_write = {}
							for i = 0, unit_list:num_items() - 1 do
								local unit = unit_list:item_at(i)
								-- build it here, so nothing breaks later
								local unit_key = "LandUnit " .. tostring(i)
								units[unit_key] = unit
								-- this tries to fix the annoying Rome2 bug that causes a crash
								-- just save the formatted output while we hold a fresh ref to the object
								units_to_write[unit_key] = consul.pretty(unit)
							end

							consul.debug._units_to_write = units_to_write
							consul.debug._units = units
						end,

						ComponentMouseOn = function(context)
							local command = consul.console.commands.exact["/debug"]
							if not command._is_running then
								return
							end

							-- make sure mouseover was on a unit
							if string.sub(context.string, 1, 9) == "LandUnit " then
								local debug_unit = consul.debug._units[context.string]
								if debug_unit then
									consul.console.clear()
									-- here is the workaround for Rome2...
									consul.console.write(consul.debug._units_to_write[context.string])
									consul.debug.unit = debug_unit
								end
								return
							end

							-- Check if string ends with '_recruitable'
							if context.string:match("_recruitable$") then
								consul.console.clear()
								consul.console.write(consul.pretty({
									["unit_key"] = context.string:sub(1, -#"_recruitable" - 1),
								}))
								return
							end

							-- Check if string ends with '_mercenary'
							if context.string:match("_mercenary$") then
								consul.console.clear()
								consul.console.write(consul.pretty({
									["unit_key"] = context.string:sub(1, -#"_mercenary" - 1),
								}))
								return
							end

							-- Attila garrison units
							if consul_build == "Attila" then
								local element = consul.ui._UIComponent(context.component)
								local parent = element:Parent()
								if parent ~= nil then
									parent = consul.ui._UIComponent(parent)
									if tostring(parent:Id()) == "land_units_frame" then
										consul.console.clear()
										consul.console.write(consul.pretty({
											["unit_key"] = context.string,
										}))
									end
								end
							end
						end,
					},

					func = function()
						local command = consul.console.commands.exact["/debug"]
						local pprinter = consul.pprinter
						local console = consul.console
						-- if already running, stop
						if command._is_running then
							command._is_running = false
							return
						end

						-- wrap common actions
						local wrap = function(opts, f)
							return function(context)
								-- skip if not running
								if not command._is_running then
									return
								end

								-- clear the console
								if opts.clean == true then
									console.clear()
								end

								-- run the function
								local _, err = pcall(f, context)
								if err ~= nil then
									consul.log:error(err)
								end
							end
						end

						table.insert(
							events.SettlementSelected,
							wrap({ clean = true }, function(context)
								console.write(consul.pretty(context:garrison_residence()))
								consul.debug.garrison_residence = context:garrison_residence()
								consul.debug.settlement = context:garrison_residence():settlement_interface()
								consul.debug.faction = context:garrison_residence():faction()
							end)
						)

						table.insert(
							events.CharacterSelected,
							wrap({ clean = true }, function(context)
								console.write(consul.pretty(context:character()))
								consul.debug.character = context:character()
								consul.debug.faction = context:character():faction()
								consul.debug.military_force = context:character():military_force()
								consul.debug.unit_list = context:character():military_force():unit_list()
							end)
						)

						local game_mappings = {
							Attila = {
								main_icon = {
									type = "settlement",
									strip = { "radar_icon_settlement:" },
									strip_element = "parent",
									f = function(name)
										local settlement = consul.game.region(name):settlement()
										consul.debug.settlement = settlement
										return pprinter.settlement_script_interface(settlement)
									end,
								},
								button_icon = {
									type = "faction",
									strip = { "faction_icon_" },
									strip_element = "parent",
									f = function(name)
										local faction = consul.game.faction(name)
										consul.debug.faction = faction
										return pprinter.faction_script_interface(faction)
									end,
								},
								faction_row_entry_ = {
									type = "faction",
									strip = { "faction_row_entry_" },
									strip_element = "this",
									f = function(name)
										local faction = consul.game.faction(name)
										consul.debug.faction = faction
										return pprinter.faction_script_interface(faction)
									end,
								},
							},
							Rome2 = {
								["radar_icon_settlement:"] = {
									type = "settlement",
									strip = { "radar_icon_settlement:" },
									strip_element = "this",
									f = function(name)
										local parts = {}
										for part in string.gmatch(name, "[^:]+") do
											table.insert(parts, part)
										end
										local settlement = consul.game.region(parts[1]):settlement()
										consul.debug.settlement = settlement
										return pprinter.settlement_script_interface(settlement)
									end,
								},
								["faction_icon_"] = {
									type = "faction",
									strip = { "faction_icon_" },
									strip_element = "this",
									f = function(name)
										local faction = consul.game.faction(name)
										consul.debug.faction = faction
										return pprinter.faction_script_interface(faction)
									end,
								},
								faction_row_entry_ = {
									type = "faction",
									strip = { "faction_row_entry_" },
									strip_element = "this",
									f = function(name)
										local faction = consul.game.faction(name)
										consul.debug.faction = faction
										return pprinter.faction_script_interface(faction)
									end,
								},
							},
						}

						local mapping = game_mappings[consul_build] or {}

						table.insert(
							events.ComponentLClickUp,
							wrap({ clean = false }, function(ctx)
								local name = nil
								local config = nil

								if mapping[ctx.string] then
									config = mapping[ctx.string]
								else
									for key, value in pairs(mapping) do
										if ctx.string:sub(1, #key) == key then
											config = value
											break
										end
									end
								end

								if not config then
									return
								end

								local btn = consul.ui._UIComponent(ctx.component)
								if not btn then
									return
								end

								local target = nil
								if config.strip_element == "parent" then
									local parent_raw = btn:Parent()
									if parent_raw then
										target = consul.ui._UIComponent(parent_raw)
									end
								else
									target = btn
								end

								if target then
									local id = tostring(target:Id())

									for _, prefix in ipairs(config.strip) do
										if id:sub(1, #prefix) == prefix then
											name = id:sub(#prefix + 1)
											break
										end
									end
								end

								console.clear()
								console.write(consul.pretty(config["f"](name)))
							end)
						)

						-- _debug_character_unit_list
						table.insert(events.CharacterSelected, command._debug_character_unit_list.OnCharacterSelected)
						table.insert(events.ComponentMouseOn, command._debug_character_unit_list.ComponentMouseOn)
						table.insert(events.ComponentLClickUp, command._debug_character_unit_list.ComponentMouseOn)

						-- mark as running
						command._is_running = true
					end,
					exec = false,
					returns = false,
				},
				["/show_shroud"] = {
					_flag = false,

					help = function()
						return "Shows/Hides the shroud on the map."
					end,
					func = function()
						local command = consul.console.commands.exact["/show_shroud"]
						consul._game():show_shroud(command._flag)
						command._flag = not command._flag
					end,
					exec = false,
					returns = false,
					setup = function()
						-- shroud turns to true when FactionTurnEnds
						-- meaning we have to trigger it again, for the user to
						-- heave a pleasant experience
						table.insert(events.FactionTurnEnd, function(context)
							local command = consul.console.commands.exact["/show_shroud"]

							-- function is not turned on
							if command._flag == false then
								return
							end

							-- just do it once
							if not context:faction():is_human() then
								return
							end

							-- disable shroud
							consul._game():show_shroud(false)
						end)
					end,
				},
				["/cli_help"] = {
					help = function()
						return "Info on engine CliExecute functions."
					end,
					func = function()
						return [[
This is some information about the CliExecute functions in the base game.

-- CliExecute('dump_render_stats <filename>') - Dumps render stats to a file in AppData dir.

-- CliExecute('terrain_write_html_around_camera') - Writes the terrain html around the camera in campaign map in AppData dir.

-- CliExecute('terrain_write_html') - Writes the terrain html in battle map (partial data in the campaign map) in AppData dir.

-- CliExecute('report_rigid_models') - Reports rigid models into a file in AppData dir.

-- CliExecute('compile_all_shaders') - Compiles all shaders.

-- CliExecute('frame_rate_test_fps <fps>') - Runs the game engine at different fps values (slower/faster game). Lower values means faster.

-- CliExecute('docudemon') - Runs the docudemon tool saving the documentation for game code in the Game folder.

-- CliExecute('toggle_terrain_vtex') - Toggles the terrain vtex.

-- CliExecute('force_rigid_lod <int>') - Forces rigid LOD , try values from -1 to 3 and up.

-- CliExecute('add_unit_experience') - When in battle, triggers the add unit experience animation on selected unit.

-- CliExecute('add_unit_effect_icon <index>') - When in battle, triggers the add unit effect icon animation on selected unit.

-- CliExecute('set_battle_size <int>') - Sets the battle size to the specified value.
]]
					end,
					exec = false,
					returns = true,
				},
				["/start_trace"] = {
					_is_running = false,
					help = function()
						return "Starts/stops the lua trace log. Saves into consul.log file."
					end,
					func = function()
						local command = consul.console.commands.exact["/start_trace"]
						command._is_running = not command._is_running
						if command._is_running then
							consul.log:start_trace("clr")
						else
							consul.log:stop_trace()
						end
					end,
					exec = false,
					returns = false,
				},
				["/use_in_battle"] = {
					help = function()
						return "Toggles use of Consul in campaign battles."
					end,
					func = function()
						local r
						consul.config.process(function(cfg)
							cfg.battle.use_in_battle = not cfg.battle.use_in_battle
							if cfg.battle.use_in_battle then
								consul.battle.init()
							else
								consul.battle.deinit()
							end
							r = cfg.battle.use_in_battle
						end)
						return tostring(r)
					end,
					exec = false,
					returns = true,
				},
				["/log_events_all"] = {
					help = function()
						return "Log all game events to the consul.log file"
					end,
					func = function()
						consul.log:info("Logging all game events")
						consul.log:log_events_all()
					end,
				},
				["/log_events_game"] = {
					help = function()
						return "Log game events (excluding component and time trigger)"
					end,
					func = function()
						consul.log:info("Logging game events")
						consul.log:log_game_events()
					end,
				},
				["/profi_start"] = {
					help = function()
						return "Start profi.lua."
					end,
					func = function()
						return consul.debug.profi.start()
					end,
					exec = false,
					returns = true,
				},
				["/profiler_start"] = {
					help = function()
						return "Start profiler.lua."
					end,
					func = function()
						return consul.debug.profile.start()
					end,
					exec = false,
					returns = true,
				},
				["/consul_debug_turn_time"] = {
					help = function()
						return "Measure AI turn time."
					end,
					func = function()
						consul.debug._turn_start_time = os.clock()
						consul.debug._measuring_turn = true
						consul._game():end_turn(true)
						return "Turn measurement started. Ending turn..."
					end,
					exec = false,
					returns = true,
				},
			},
		},

		-- internal function to execute a command
		_execute = function(cmd)
			-- make function from string
			local f, err = loadstring(cmd)
			if err then
				return tostring("lua loadstring: " .. tostring(err))
			end

			-- execute the function
			local success, result = pcall(f)

			-- if cmd did not start with 'return' statement
			-- then lua will just return nil as the result
			-- we don't want to print it as this is not the standard lua behavior
			if success and not result and (string.sub(cmd, 1, 7) ~= "return ") then
				assert(false, "this value should not be returned")
			end

			-- return error message if failed
			if not success then
				return tostring("lua pcall: " .. tostring(result))
			end

			return tostring(result)
		end,

		--- A function that executes a command from the console.
		--- @function console.execute
		--- @tparam string cmd The command to execute.
		--- @usage
		--- consul.console.execute("2+2")
		execute = function(cmd)
			local console = consul.console
			local settings = console.commands.settings

			-- check for autoclear setting
			if settings.autoclear then
				if settings._autoclear_current >= settings.autoclear_after then
					console.clear()
					settings._autoclear_current = 0
					-- clear output file
					local f = io.open(console.output_path, "w")
					if f then
						f:close()
					end
				end
			end

			-- increase _autoclear_current
			settings._autoclear_current = settings._autoclear_current + 1

			-- first write the command to the output window
			console.write("$ " .. cmd)

			-- exact
			for k, v in pairs(console.commands.exact) do
				if cmd == k then
					local r = v.func(cmd)
					if v.exec then
						r = console._execute(r)
					end
					if v.returns then
						console.write(r)
					end
					return
				end
			end

			-- handle starts with cases
			for k, v in pairs(console.commands.starts_with) do
				if string.sub(cmd, 1, string.len(k)) == k then
					local r = v.func(cmd)
					if v.exec then
						r = console._execute(r)
					end
					if v.returns then
						console.write(r)
					end
					return
				end
			end

			-- otherwise raw exec
			console.write(console._execute(cmd))
		end,

		OnComponentLClickUp = function(context)
			local log = consul.new_log("console:OnComponentLClickUp")
			local ui = consul.ui
			local console = consul.console

			if context.string == ui.console_send then
				log:debug("Clicked on: console_send")

				if consul.is_in_battle_script then
					log:debug("In battle script, registering __consul_console_single_shot_timer")
					function __consul_console_single_shot_timer()
						consul.console.execute(console.read())
					end

					consul.bm:register_singleshot_timer("__consul_console_single_shot_timer", 0)
				else
					log:debug("Normal script, executing immediately")
					console.execute(console.read())
				end
				-- put the cursor back to the input field
				-- WARNING this will break the history handling
				--ui.find(ui.console_input):SimulateClick()
				return
			end
		end,
	},

	-- scripts to be run from the 'scriptum' view
	scriptum = {

		path = "consul.scriptum",
		path_example = "scriptum.lua",
		example_script = [[
-- Example script for consul
require 'consul'
consul.console.clear()
consul.console.write(
    'Hello from scriptum.lua!\n\n' ..
    'This script runs from the Scriptum list menu when you click on it.\n' ..
    'Its content is located in the game folder in the scriptum.lua file.\n' ..
    'To add your own scripts, list their paths in the consul.scriptum file.\n' ..
    'After adding a new script, reopen the console to have it listed in the menu.\n' ..
    'It runs in the global scope, meaning you can access game functions and variables.\n\n' ..
    'Type /clear to clear the console.\n' ..
    'Type /help for more information.\n\n' ..
    'You can also run Lua commands here.\nTry typing: return 2+2\n'
)
-- Uncomment these lines to see what happens
--scripting = require 'lua_scripts.EpisodicScripting'
--scripting.AddEventCallBack('ComponentLClickUp', function(context)
--	consul.console.write('You clicked on: ' .. context.string)
--end)

-- Uncomment that line to see what happens
-- consul.console.write(consul.pretty({_G}))
]],
		-- because we don't know how to create elements
		-- dynamically, we have to set a maximum number of entries
		-- they are pre-created in the ui file
		max_entries = 10,

		-- this is a map of ui listview entries to the scripts
		-- example scriptum_text1 -> consul_example.lua
		ui_scripts_map = {},

		-- holds the name of the currently executed scriptum entry text component (e.g. scriptum_entry_text1)
		-- during execution. Accessible within custom scripts via consul.scriptum.entry
		entry = nil,

		-- read paths to files from inside consul.scriptum file
		-- each lines is a path to a file that can be executed from the listview
		-- if the consul.scriptum file is not found, it will be created
		-- and then if consul_example.lua does not exist, it will be created
		-- and added to the list
		setup = function()
			local log = consul.new_log("scriptum:setup")
			log:trace("Setting up scriptum")

			local ui = consul.ui
			local path = consul.scriptum.path
			local max = consul.scriptum.max_entries

			local f = io.open(path, "r")
			if f then
				f:close()
			end

			if not f then
				-- create consul.scriptum
				f = io.open(path, "w")
				if f then
					f:write(consul.scriptum.path_example .. "\n")
					f:close()
				end

				-- create consul_example.lua
				f = io.open(consul.scriptum.path_example, "r")
				if f then
					log:debug("Example script exists: " .. consul.scriptum.path_example)
					f:close()
				else
					log:debug("Creating example script: " .. consul.scriptum.path_example)
					f = io.open(consul.scriptum.path_example, "w")
					if f then
						f:write(consul.scriptum.example_script)
						f:close()
					end
				end
			end

			-- at start just clean all the entries
			-- and set all the elements to invisible
			-- this can be reloaded while the game is running
			-- p.s this is required as setting any element in list
			-- as invisible by default in the ui file will break display of it
			-- just make sure they are always visible by default and turn them
			-- off ... this probably applies to all element based ui components
			for i = 1, max do
				local ui_root_name = ui.scriptum_entry .. tostring(i)
				local ui_state_name = ui.scriptum_entry_text .. tostring(i)
				local ui_root = ui.find(ui_root_name)
				local ui_state = ui.find(ui_state_name)

				if ui_root and ui_state then
					ui_root:SetVisible(false)
					ui_state:SetVisible(false)
				else
					-- this is bad
					log:error("Could not find scriptum entry: " .. ui_root_name)
				end
			end

			log:trace("Loading scriptum scripts from: " .. path)
			-- now we can open the file and read its lines
			-- each line is a path to a script that can be executed
			-- it will be added to the listview by toggling visibility flag
			-- we can support up to 10 scripts for now, and each script
			-- has to find ui element with index +1 after the scriptum_entry

			-- first read all lines to local var so we can close the file
			local lines = {}
			f = io.open(path, "r")
			if not f then
				log:error("Could not open scriptum file, this should never happen " .. path)
				return
			end
			for line in f:lines() do
				table.insert(lines, line)
			end
			f:close()

			log:trace("Loaded scriptum scripts: " .. consul.inspect(lines))

			-- now we can iterate over the lines
			local i = 1
			for _, line in pairs(lines) do
				log:trace("Adding script to the listview: " .. line)

				-- if we are over the limit notify and break
				if i > max then
					log:warn("Too many scripts in the scriptum file, only first " .. max .. " will be loaded")
					break
				end

				-- make sure the line is not empty
				if line ~= "" then
					-- if the file exists, add it to the list
					local f = io.open(line, "r")
					if f then
						f:close()

						-- now find the elements
						local ui_root_name = ui.scriptum_entry .. tostring(i)
						local ui_state_name = ui.scriptum_entry_text .. tostring(i)
						local ui_root = ui.find(ui_root_name)
						local ui_state = ui.find(ui_state_name)

						-- and switch the flags
						if ui_root then
							log:trace("Setting scriptum entries: " .. ui_root_name .. " " .. ui_state_name)
							ui_root:SetVisible(true)

							-- HACK: The friends_list UI tends to overwrite text when state changes.
							-- We save the current state first, cycle to force the text, then restore.
							local current_state = ui_state:CurrentState()

							ui_state:SetState("online")
							ui_state:SetStateText(line)
							ui_state:SetState("offline")
							ui_state:SetStateText(line)

							ui_state:SetState(current_state)

							ui_state:SetVisible(true)
							consul.scriptum.ui_scripts_map[ui_root_name] = line

							-- only then increment the index
							i = i + 1
						end
					end
				end
			end
		end,

		-- let's handle the event when we click on the scriptum entry
		OnComponentLClickUp = function(context)
			local log = consul.new_log("scriptum:OnComponentLClickUp")
			local ui = consul.ui

			-- check if we clicked on the scriptum entry
			if string.sub(context.string, 1, 14) == ui.scriptum_entry then
				log:debug("Clicked on scriptum entry: " .. context.string)
			else
				-- fail fast
				return
			end

			if consul.scriptum.ui_scripts_map[context.string] == nil then
				log:error(context.string .. " not found")
				return
			end

			local script_name = context.string

			-- wrap the command so it can executed from inside battle
			local _execute_scriptum_entry = function()
				log:debug("inside _execute_scriptum_entry")
				local script = consul.scriptum.ui_scripts_map[script_name]

				if script ~= nil then
					log:debug("Executing script: " .. script)

					-- Pass the text component name (e.g. scriptum_entry_text1) to the script
					-- This is what users actually want to toggle visually
					local index = string.sub(script_name, #ui.scriptum_entry + 1)
					consul.scriptum.entry = ui.scriptum_entry_text .. index

					local success, err = pcall(dofile, script)

					-- Clean up after execution
					consul.scriptum.entry = nil

					if not success then
						log:error("Error executing script: " .. script .. " " .. err)
						consul.console.write("error: " .. script .. " " .. err)
					else
						log:debug("Executed script: " .. script)
					end
				end
			end

			-- handle click in battle
			if consul.is_in_battle_script then
				log:debug("In battle script, registering __consul_scriptum_single_shot_timer")
				function __consul_scriptum_single_shot_timer()
					_execute_scriptum_entry()
				end

				consul.bm:register_singleshot_timer("__consul_scriptum_single_shot_timer", 0)
			else
				log:debug("Normal script, executing immediately")
				_execute_scriptum_entry()
			end
		end,
	},

	-- new version that should be more flexible with better patterns and less code
	consul_scripts_v2 = {

		-- initialize all scripts
		initialize = function()
			local scripts = consul.consul_scripts_v2
			scripts.instances["vexatio_provinciae"] = scripts.create_change_public_order_by_func(-10)
			scripts.instances["sedatio_provinciae"] = scripts.create_change_public_order_by_func(10)
			scripts.instances["incrementum_regio"] = scripts.create_increase_growth_points_func(1)

			-- two faction scripts
			scripts.instances["force_make_peace"] = scripts.create_two_faction_script(
				"force_make_peace",
				function(faction1, faction2)
					consul._game():force_make_peace(faction1, faction2)
				end,
				"Forcing peace between"
			)
			scripts.instances["force_make_war"] = scripts.create_two_faction_script(
				"force_make_war",
				function(faction1, faction2)
					consul._game():force_declare_war(faction1, faction2)
				end,
				"Forcing war between"
			)
			scripts.instances["force_make_vassal"] = scripts.create_two_faction_script(
				"force_make_vassal",
				function(faction1, faction2)
					consul._game():force_make_vassal(faction2, faction1)
				end,
				"Forcing vassal"
			)
		end,

		instances = {
			vexatio_provinciae = nil,
			sedatio_provinciae = nil,
			incrementum_regio = nil,
			force_make_peace = nil,
			force_make_war = nil,
			force_make_vassal = nil,
		},

		__wrap_func_with_log = function(func, log, text)
			return function()
				log:debug(text)
				func()
			end
		end,

		__wrap_setup = function(setup, log)
			return function()
				log:debug("Setting up...")
				setup()
			end
		end,

		__wrap_start = function(start, log)
			return function()
				log:debug("Starting...")
				start()
			end
		end,

		__wrap_stop = function(stop, log)
			return function()
				log:debug("Stopping...")
				stop()
			end
		end,

		__get_logger = function(name)
			return consul.new_log("consul_scripts:" .. name)
		end,

		create_change_public_order_by_func = function(number)
			local scripts2 = consul.consul_scripts_v2
			local scripts = consul.consul_scripts

			local log = scripts2.__get_logger("change_public_order_by_" .. tostring(number))
			local event = "change_public_order_by_" .. tostring(number)

			local setup = function()
				scripts.event_handlers["SettlementSelected"][event] = nil
			end

			local start = function()
				scripts.event_handlers["SettlementSelected"][event] = function(context)
					log:debug("SettlementSelected")
					local region = context:garrison_residence():region():name()
					log:debug("Increasing public order in: " .. region)
					consul._game():set_public_order_of_province_for_region(
						region,
						context:garrison_residence():region():public_order() + number
					)
				end
			end

			local stop = function()
				scripts.event_handlers["SettlementSelected"][event] = nil
			end

			return {
				setup = scripts2.__wrap_setup(setup, log),
				start = scripts2.__wrap_start(start, log),
				stop = scripts2.__wrap_stop(stop, log),
			}
		end,
		create_increase_growth_points_func = function(number)
			local scripts2 = consul.consul_scripts_v2
			local scripts = consul.consul_scripts

			local log = scripts2.__get_logger("increase_growth_points_by_" .. tostring(number))
			local event = "increase_growth_points_by_" .. tostring(number)

			local setup = function()
				scripts.event_handlers["SettlementSelected"][event] = nil
			end

			local start = function()
				scripts.event_handlers["SettlementSelected"][event] = function(context)
					log:debug("SettlementSelected")
					local region = context:garrison_residence():region():name()
					log:debug("Increasing growth points in: " .. region)
					consul._game():add_development_points_to_region(region, number)
				end
			end

			local stop = function()
				scripts.event_handlers["SettlementSelected"][event] = nil
			end

			return {
				setup = scripts2.__wrap_setup(setup, log),
				start = scripts2.__wrap_start(start, log),
				stop = scripts2.__wrap_stop(stop, log),
			}
		end,

		create_two_faction_script = function(name, action_func, log_text)
			local scripts2 = consul.consul_scripts_v2
			local scripts = consul.consul_scripts
			local log = scripts2.__get_logger(name)

			local faction1 = nil
			local faction2 = nil

			local reset_factions = function()
				faction1 = nil
				faction2 = nil
			end

			local perform_action = function()
				if faction1 and faction2 then
					log:debug(log_text .. ": " .. faction1 .. " and " .. faction2)
					action_func(faction1, faction2)
					reset_factions()
					log:debug("Action performed and factions reset.")
				end
			end

			local setup = function()
				scripts.event_handlers["SettlementSelected"][name] = nil
				scripts.event_handlers["CharacterSelected"][name] = nil
				reset_factions()
			end

			local start = function()
				local handler = function(context)
					local faction_name
					if context.character then
						faction_name = context:character():faction():name()
					elseif context.garrison_residence then
						faction_name = context:garrison_residence():faction():name()
					end

					if faction_name then
						if not faction1 then
							faction1 = faction_name
						else
							faction2 = faction_name
						end
						perform_action()
					end
				end

				scripts.event_handlers["SettlementSelected"][name] = handler
				scripts.event_handlers["CharacterSelected"][name] = handler
			end

			local stop = function()
				setup()
			end

			return {
				setup = scripts2.__wrap_setup(setup, log),
				start = scripts2.__wrap_start(start, log),
				stop = scripts2.__wrap_stop(stop, log),
			}
		end,
	},

	-- consul scripts window
	consul_scripts = {

		-- scripts register their event handlers here
		-- just add empty ones here so other scripts don't
		-- have to check if they exist before adding
		event_handlers = {
			["CharacterSelected"] = {},
			["SettlementSelected"] = {},
			["ComponentLClickUp"] = {},
		},

		-- dispatches an event
		event_dispatcher = function(event_name)
			local log = consul.new_log("consul_scripts:event_dispatcher")

			return function(context)
				local eh = consul.consul_scripts.event_handlers[event_name]
				for _, v in pairs(eh) do
					if v then
						log:debug("Dispatching event: " .. event_name)
						v(context)
					end
				end
			end
		end,

		-- setup only once
		_is_ready = false,

		-- setup the script, should be called once
		setup = function()
			local log, scripts = consul.new_log("consul_scripts:setup"), consul.consul_scripts
			local scripts2 = consul.consul_scripts_v2

			log:debug("Setting up scripts")

			-- skip if already set up
			if scripts._is_ready then
				log:debug("Scripts are already set up")
				return
			end

			scripts2.initialize()
			-- call all scripts setup
			scripts.exterminare.setup()
			scripts.transfer_settlement.setup()
			scripts.force_rebellion.setup()
			scripts.force_exchange_garrison.setup()
			scripts.replenish_action_point.setup()
			scripts2.instances.vexatio_provinciae.setup()
			scripts2.instances.sedatio_provinciae.setup()
			scripts2.instances.incrementum_regio.setup()

			log:debug("Finished setting up scripts")

			-- setup the event handlers
			local ok, scripting = pcall(require, "lua_scripts.EpisodicScripting")
			if not ok then
				log:warn("Could not load EpisodicScripting, it's ok if we are in frontend")
				return
			end

			log:debug("Setting up event handlers")
			for k, _ in pairs(scripts.event_handlers) do
				log:debug("Setting up event handler: " .. k)
				scripting.AddEventCallBack(k, scripts.event_dispatcher(k))
			end

			-- mark as ready
			log:debug("Setup finished")
			scripts._is_ready = true
		end,

		_on_click = function(script, component)
			if component:CurrentState() == "active" then
				script.stop()
				component:SetState("default")
			else
				script.start()
				component:SetState("active")
			end
		end,

		OnComponentLClickUp = function(context)
			local log = consul.new_log("consul_scripts:OnComponentLClickUp")
			local scripts = consul.consul_scripts
			local scripts2 = consul.consul_scripts_v2
			local ui = consul.ui

			local click_map = {
				[ui.consul_exterminare_entry] = {
					script = scripts.exterminare,
					component = ui.consul_exterminare_script,
					log_msg = "Clicked on consul_exterminare",
				},
				[ui.consul_transfersettlement_entry] = {
					script = scripts.transfer_settlement,
					component = ui.consul_transfersettlement_script,
					log_msg = "Clicked on consul_transfersettlement",
				},
				[ui.consul_adrebellos_entry] = {
					script = scripts.force_rebellion,
					component = ui.consul_adrebellos_script,
					log_msg = "Clicked on consul_forcerebellion",
				},
				[ui.consul_force_make_peace_entry] = {
					script = scripts2.instances.force_make_peace,
					component = ui.consul_force_make_peace_script,
					log_msg = "Clicked on consul_force_make_peace",
				},
				[ui.consul_force_make_war_entry] = {
					script = scripts2.instances.force_make_war,
					component = ui.consul_force_make_war_script,
					log_msg = "Clicked on consul_force_make_war",
				},
				[ui.consul_force_make_vassal_entry] = {
					script = scripts2.instances.force_make_vassal,
					component = ui.consul_force_make_vassal_script,
					log_msg = "Clicked on consul_force_make_vassal",
				},
				[ui.consul_force_exchange_garrison_entry] = {
					script = scripts.force_exchange_garrison,
					component = ui.consul_force_exchange_garrison_script,
					log_msg = "Clicked on consul_force_exchange_garrison",
				},
				[ui.consul_replenish_action_points_entry] = {
					script = scripts.replenish_action_point,
					component = ui.consul_replenish_action_points_script,
					log_msg = "Clicked on consul_replenish_action_point",
				},
				[ui.consul_vexatio_provinciae_entry] = {
					script = scripts2.instances.vexatio_provinciae,
					component = ui.consul_vexatio_provinciae_script,
					log_msg = "Clicked on consul_vexatio_provinciae",
				},
				[ui.consul_sedatio_provinciae_entry] = {
					script = scripts2.instances.sedatio_provinciae,
					component = ui.consul_sedatio_provinciae_script,
					log_msg = "Clicked on consul_sedatio_provinciae",
				},
				[ui.consul_incrementum_regio_entry] = {
					script = scripts2.instances.incrementum_regio,
					component = ui.consul_incrementum_regio_script,
					log_msg = "Clicked on consul_incrementum_regio",
				},
			}

			local clicked_script = click_map[context.string]
			if clicked_script then
				log:debug(clicked_script.log_msg)
				scripts._on_click(clicked_script.script, ui.find(clicked_script.component))
			end
		end,

		exterminare = {

			get_logger = function()
				return consul.new_log("consul_scripts:exterminare")
			end,

			setup = function()
				local scripts = consul.consul_scripts
				local log = scripts.exterminare.get_logger()
				log:debug("Setting up...")

				scripts.event_handlers["CharacterSelected"]["exterminare"] = nil
			end,

			start = function()
				local scripts = consul.consul_scripts
				local log = scripts.exterminare.get_logger()
				log:debug("Starting...")

				-- register event handler
				-- script and concepts modded by: Jake Armitage and ivanpera from TWC
				scripts.event_handlers["CharacterSelected"]["exterminare"] = function(context)
					log:debug("CharacterSelected")

					-- get the faction and forename
					local faction = context:character():faction():name()
					local forename = context:character():get_forename()

					-- build the target
					local target = "faction:"
						.. tostring(faction)
						.. ","
						.. "forename:"
						.. string.gsub(forename, "names_name_", "")

					-- destroy
					log:debug("Target: " .. target)

					-- TODO we can switch flag to only kill character (now it kills the whole army)
					consul._game():kill_character(target, true, true)
				end

				log:debug("Started.")
			end,

			stop = function()
				local scripts = consul.consul_scripts
				local log = scripts.exterminare.get_logger()
				log:debug("Stopping...")

				-- unregister event handler
				scripts.event_handlers["CharacterSelected"]["exterminare"] = nil
				log:debug("Stopped.")
			end,
		},

		transfer_settlement = {

			get_logger = function()
				return consul.new_log("consul_scripts:transfer_settlement")
			end,

			setup = function()
				local scripts = consul.consul_scripts
				local log = scripts.transfer_settlement.get_logger()
				log:debug("Setting up...")

				scripts.event_handlers["SettlementSelected"]["transfersettlement"] = nil
				scripts.event_handlers["ComponentLClickUp"]["transfersettlement"] = nil
				scripts.event_handlers["CharacterSelected"]["transfersettlement"] = nil
			end,

			_faction = nil,
			_region = nil,

			_transfer = function()
				local script = consul.consul_scripts.transfer_settlement
				local log = script.get_logger()

				-- transfer only if ready
				if not script._region or not script._faction then
					return
				end

				log:debug("Transferring: " .. script._region .. " to " .. script._faction)
				consul._game():transfer_region_to_faction(script._region, script._faction)

				script._faction = nil
				script._region = nil
			end,

			start = function()
				local log = consul.consul_scripts.transfer_settlement.get_logger()
				local script = consul.consul_scripts.transfer_settlement
				local scripts = consul.consul_scripts
				log:debug("Starting...")

				scripts.event_handlers["SettlementSelected"]["transfersettlement"] = function(context)
					log:debug("SettlementSelected")

					if not script._region then
						script._region = context:garrison_residence():region():name()
					else
						script._faction = context:garrison_residence():faction():name()
					end
					script._transfer()
				end

				scripts.event_handlers["ComponentLClickUp"]["transfersettlement"] = function(context)
					log:debug("ComponentLClickUp")

					-- if we clicked radar_icon in the strategic view
					if string.sub(context.string, 1, 21) == "radar_icon_settlement" then
						log:debug("Clicked on radar_icon_settlement")

						-- split string by :
						local parts = {}
						for part in string.gmatch(context.string, "[^:]+") do
							table.insert(parts, part)
						end

						-- we need 3 parts
						if #parts ~= 3 then
							return
						end

						-- grab the region name
						local region = parts[2]

						if not script._region then
							-- if region is nil, we can just set it
							script._region = region
						else
							-- otherwise query for faction
							script._faction = consul.game.region(region):owning_faction():name()
						end

						script._transfer()
					end
				end
				scripts.event_handlers["CharacterSelected"]["transfersettlement"] = function(context)
					log:debug("CharacterSelected")
					-- if you select a character, its always the target of the transfer
					if not script._faction then
						script._faction = context:character():faction():name()
					end
					script._transfer()
				end
			end,

			stop = function()
				local log = consul.consul_scripts.transfer_settlement.get_logger()
				local script = consul.consul_scripts.transfer_settlement
				local scripts = consul.consul_scripts
				log:debug("Stopping...")

				scripts.event_handlers["SettlementSelected"]["transfersettlement"] = nil
				scripts.event_handlers["ComponentLClickUp"]["transfersettlement"] = nil
				scripts.event_handlers["CharacterSelected"]["transfersettlement"] = nil
				script._faction = nil
				script._region = nil

				log:debug("Stopped.")
			end,
		},

		force_rebellion = {

			get_logger = function()
				return consul.new_log("consul_scripts:force_rebellion")
			end,

			setup = function()
				local scripts = consul.consul_scripts
				local log = scripts.force_rebellion.get_logger()
				log:debug("Setting up...")
				scripts.event_handlers["SettlementSelected"]["forcerebellion"] = nil
			end,

			start = function()
				local log = consul.consul_scripts.force_rebellion.get_logger()
				log:debug("Starting...")

				local scripts = consul.consul_scripts
				scripts.event_handlers["SettlementSelected"]["forcerebellion"] = function(context)
					log:debug("SettlementSelected")
					local region = context:garrison_residence():region():name()
					consul.game.force_rebellion(region, 4, "", 0, 0, true)
					log:debug("Forced rebellion in: " .. region)
				end
			end,

			stop = function()
				local scripts = consul.consul_scripts
				local log = scripts.force_rebellion.get_logger()
				log:debug("Stopping...")
				scripts.event_handlers["SettlementSelected"]["forcerebellion"] = nil
			end,
		},

		force_exchange_garrison = {

			_character = nil,
			_settlement = nil,

			-- function to exchange garrison
			_exchange = function(char_from, char_to)
				consul
					._game()
					:seek_exchange("character_cqi:" .. char_from:cqi(), "character_cqi:" .. char_to:cqi(), true, false)
			end,
			_get_colonel_for_garrison = function(garrison, is_army, is_navy)
				if (not is_army) and not is_navy then
					return
				end

				local characters = garrison:faction():character_list()
				local characters_count = garrison:faction():character_list():num_items()
				local settlement_name = garrison:settlement_interface():region():name()

				for i = 0, characters_count - 1 do
					local char = characters:item_at(i)

					local ok, result = pcall(function()
						if
							char:character_type("colonel")
							and char:garrison_residence():settlement_interface():region():name() == settlement_name
							and (
								(is_army and char:military_force():is_army())
								or (is_navy and char:military_force():is_navy())
							)
						then
							return char
						end
					end)

					if ok and result ~= nil then
						return result
					end
				end
				return nil
			end,

			get_logger = function()
				return consul.new_log("consul_scripts:force_exchange_garrison")
			end,

			setup = function()
				local scripts = consul.consul_scripts
				local script = scripts.force_exchange_garrison
				local log = script.get_logger()
				log:debug("Setting up...")
				script._character = nil
				script._settlement = nil
				scripts.event_handlers["CharacterSelected"]["forceexchangegarrison"] = nil
				scripts.event_handlers["SettlementSelected"]["forceexchangegarrison"] = nil
			end,

			start = function()
				local scripts = consul.consul_scripts
				local script = scripts.force_exchange_garrison
				local log = script.get_logger()
				log:debug("Starting...")

				scripts.event_handlers["CharacterSelected"]["forceexchangegarrison"] = function(context)
					log:debug("CharacterSelected")
					if not context:character():faction():is_human() then
						return
					end
					script._character = context:character()
				end

				scripts.event_handlers["SettlementSelected"]["forceexchangegarrison"] = function(context)
					log:debug("SettlementSelected")

					if script._character == nil and script._settlement == nil then
						log:debug("No character selected, transfering settlements?")
						script._settlement = context:garrison_residence()
						return
					end

					-- transfer between settlements
					-- TODO THIS IS TRICKY DOES NOT WORK
					-- I ONCE MANAGED TO DO THAT SO IDK
					if script._settlement ~= nil then
						log:debug("Exchanging garrison between settlements...")
						local colonel1 = script._get_colonel_for_garrison(script._settlement, true, false)
						if colonel1 == nil then
							return
						end
						local colonel2 = script._get_colonel_for_garrison(context:garrison_residence(), true, false)
						if colonel2 == nil then
							return
						end
						log:debug("Exchanging garrison between 2 colonels...")
						script._exchange(colonel1, colonel2)
						return
					end

					-- transfer to character
					if script._character ~= nil and script._character:has_military_force() == true then
						log:debug("Exchanging garrison with character...")
						local colonel = script._get_colonel_for_garrison(
							context:garrison_residence(),
							script._character:military_force():is_army(),
							script._character:military_force():is_navy()
						)
						if colonel == nil then
							return
						end
						log:debug("Exchanging garrison between character and colonel...")
						script._exchange(colonel, script._character)
						return
					end
				end
			end,
			stop = function()
				return consul.consul_scripts.force_exchange_garrison.setup()
			end,
		},
		replenish_action_point = {

			get_logger = function()
				return consul.new_log("consul_scripts:replenish_action_point")
			end,

			setup = function()
				local scripts = consul.consul_scripts
				local log = scripts.replenish_action_point.get_logger()
				log:debug("Setting up...")
				scripts.event_handlers["CharacterSelected"]["replenishactionpoint"] = nil
			end,

			start = function()
				local log = consul.consul_scripts.replenish_action_point.get_logger()
				local scripts = consul.consul_scripts
				log:debug("Starting...")

				scripts.event_handlers["CharacterSelected"]["replenishactionpoint"] = function(context)
					log:debug("CharacterSelected")
					local char = context:character()
					log:debug("Replenished action points for character: " .. char:get_forename())
					consul._game():replenish_action_points("character_cqi:" .. char:cqi())
				end
			end,

			stop = function()
				local scripts = consul.consul_scripts
				local log = scripts.replenish_action_point.get_logger()
				log:debug("Stopping...")
				scripts.event_handlers["CharacterSelected"]["replenishactionpoint"] = nil
			end,
		},
	},

	-- wrapper for the CliExecute function
	_cliExecute = function(...)
		return CliExecute(...)
	end,

	--- Return active game interface `scripting.game_interface` or `nil`.<br>
	--- This may be unavailable in Frontend/Battle contexts.
	--- @function consul._game
	--- @usage consul._game():force_make_peace(faction1, faction2)
	_game = function()
		-- !!
		-- I do not try to import the `EpisodicScripting` module
		-- from my observation this can cause dragons to appear
		-- we can safely assume that the game will do that for us
		-- overall trying to import any module is not a good idea
		-- do not mess with other scripts / people / mods

		-- if we have the game interface, return it
		-- works fine in grand campaign and cig
		if scripting and scripting.game_interface then
			return scripting.game_interface
		end

		-- this is still ok
		consul.log:debug("Could not find scripting.game_interface, trying to locate...")

		-- this can happen in campaigns other than grand campaign and cig
		-- try locating scripting in preloaded modules
		local scripting = package.loaded["lua_scripts.EpisodicScripting"]
		if scripting and scripting.game_interface then
			return scripting.game_interface
		end

		-- this can also happen in some campaigns
		-- the lowercase version can be problematic in other cases...
		-- it may not contain the game_interface at all :D
		local scripting = package.loaded["lua_scripts.episodicscripting"]
		if scripting and scripting.game_interface then
			return scripting.game_interface
		end

		consul.log:error("Could not find scripting.game_interface, consul will not work properly")
		return nil
	end,

	-- neat shortcuts for game functions
	-- they should be used in the scripts
	-- they should be a fixed api that never breaks

	game = {

		--- A function that returns the model of the game.
		--- @function game.model
		--- @return Model The model of the game.
		--- @usage
		--- local model = consul.game.model()
		model = function()
			return consul._game():model()
		end,

		--- A function that returns the world of the game.
		--- @function game.world
		--- @return World The world of the game.
		--- @usage
		--- local world = consul.game.world()
		world = function()
			return consul._game():model():world()
		end,

		--- A function that returns a region by key.
		--- @function game.region
		--- @tparam string key The key of the region to return.
		--- @return Region The region found.
		--- @usage
		--- local region = consul.game.region("region_key")
		--- consul.console.write(region:name())
		region = function(key)
			return consul._game():model():world():region_manager():region_by_key(key)
		end,

		--- A function that returns a settlement by key.
		--- @function game.settlement
		--- @tparam string key The key of the settlement to return.
		--- @return Settlement The settlement found.
		--- @usage
		--- local settlement = consul.game.settlement("settlement_key")
		--- consul.console.write(settlement:name())
		settlement = function(key)
			return consul._game():model():world():region_manager():settlement_by_key(key)
		end,

		--- A function that returns a list of all regions.
		--- @function game.region_list
		--- @return table The list of regions.
		--- @usage
		--- local regions = consul.game.region_list()
		--- consul.console.write(regions[1])
		region_list = function()
			local region_list = consul._game():model():world():region_manager():region_list()

			local regions = {}
			for i = 0, region_list:num_items() - 1 do
				table.insert(regions, region_list:item_at(i):name())
			end

			return regions
		end,

		--- A function that returns a faction by key.
		--- @function game.faction
		--- @tparam string key The key of the faction to return.
		--- @return Faction The faction found.
		--- @usage
		--- local faction = consul.game.faction("faction_key")
		--- consul.console.write(faction:name())
		faction = function(key)
			return consul._game():model():world():faction_by_key(key)
		end,

		faction_list = function()
			local faction_list = consul._game():model():world():faction_list()

			local factions = {}
			for i = 0, faction_list:num_items() - 1 do
				table.insert(factions, faction_list:item_at(i):name())
			end

			return factions
		end,

		force_rebellion = function(region, units, unit_list, x, y, supress_message)
			if not region then
				return "region is nil"
			end
			if not units then
				return "units is nil"
			end
			if not unit_list then
				return "unit_list is nil"
			end
			if not x then
				return "x is nil"
			end
			if not y then
				return "y is nil"
			end
			if supress_message == nil then
				return "supress_message is nil"
			end
			return consul._game():force_rebellion_in_region(region, units, unit_list, x, y, supress_message)
		end,
	},

	pprinter = {

		-- formatting for all pprints
		pretty = function(_tbl)
			local table_sorter = function(keys, original_table)
				local sizes = {}

				local function get_size(k, v)
					if type(v) ~= "table" then
						return -1
					end

					if sizes[k] == nil then
						local count = 0
						for _ in pairs(v) do
							count = count + 1
						end
						sizes[k] = count
					end
					return sizes[k]
				end

				table.sort(keys, function(a, b)
					local val_a = original_table[a]
					local val_b = original_table[b]

					local size_a = get_size(a, val_a)
					local size_b = get_size(b, val_b)

					if size_a ~= size_b then
						return size_a < size_b
					end

					local type_a, type_b = type(a), type(b)
					if type_a ~= type_b then
						if type_a == "number" then
							return true
						end
						if type_b == "number" then
							return false
						end
						return type_a < type_b
					end

					if type_a == "number" then
						return a < b
					end
					return tostring(a) < tostring(b)
				end)
			end

			return consul.serpent.block(_tbl, {
				indent = consul.tab,
				sortkeys = table_sorter,
				comment = false,
				nocode = true,
				compact = false,
			})
		end,

		-- a shortcut function that will route to the correct
		-- function based on the string representation of the object
		format = function(_any, _opts)
			local log = consul.new_log("consul:pprinter:print")
			log:debug("print called")

			if _any == nil then
				return nil
			end

			if _opts == nil then
				_opts = {}
			end

			local map = {
				GARRISON_RESIDENCE_SCRIPT_INTERFACE = consul.pprinter.garrison_script_interface,
				UNIT_SCRIPT_INTERFACE = consul.pprinter.unit_script_interface,
				UNIT_LIST_SCRIPT_INTERFACE = consul.pprinter.unit_list_script_interface,
				MILITARY_FORCE_SCRIPT_INTERFACE = consul.pprinter.military_force_script_interface,
				CHARACTER_SCRIPT_INTERFACE = consul.pprinter.character_script_interface,
				FACTION_SCRIPT_INTERFACE = consul.pprinter.faction_script_interface,
				SETTLEMENT_SCRIPT_INTERFACE = consul.pprinter.settlement_script_interface,
				REGION_SCRIPT_INTERFACE = consul.pprinter.region_script_interface,
				BUILDING_SCRIPT_INTERFACE = consul.pprinter.building_script_interface,
				SLOT_SCRIPT_INTERFACE = consul.pprinter.slot_script_interface,
				SLOT_LIST_SCRIPT_INTERFACE = consul.pprinter.slot_list_script_interface,
			}

			local type_str = tostring(_any)
			local func = nil
			for k, v in pairs(map) do
				if string.sub(type_str, 1, string.len(k)) == k then
					func = v
					break
				end
			end
			if func == nil then
				log:debug("No function found for type: " .. type_str)
				return nil
			end
			return consul.pprinter.pretty(func(_any, _opts))
		end,

		_is_null = function(_any)
			return string.sub(tostring(_any), 1, 21) == "NULL_SCRIPT_INTERFACE"
		end,

		garrison_script_interface = function(...)
			local log = consul.new_log("consul:pprinter:garrison_script_interface")
			log:debug("Garrison script interface called")

			local func = nil
			if consul_build == "Rome2" then
				func = consul.pprinter.garrison_script_interface_rome
			elseif consul_build == "Attila" then
				func = consul.pprinter.garrison_script_interface_attila
			end
			return func(...)
		end,
		garrison_script_interface_rome = function(_garrison, _opts)
			if _opts == nil then
				_opts = {}
			end

			_opts._dont_print__garrison_residence = true

			if consul.pprinter._is_null(_garrison) then
				return {}
			end

			return {
				["army"] = _garrison:army(),
				["buildings"] = _garrison:buildings(),
				["faction"] = _garrison:faction(),
				["has_army"] = _garrison:has_army(),
				["has_navy"] = _garrison:has_navy(),
				["is_settlement"] = _garrison:is_settlement(),
				["is_slot"] = _garrison:is_slot(),
				["is_under_siege"] = _garrison:is_under_siege(),
				["model"] = _garrison:model(),
				["navy"] = _garrison:navy(),
				["region"] = _garrison:region(),
				["settlement_interface"] = consul.pprinter.settlement_script_interface(
					_garrison:settlement_interface(),
					_opts
				),
				["slot_interface"] = _garrison:slot_interface(),
				["unit_count"] = _garrison:unit_count(),
			}
		end,
		garrison_script_interface_attila = function(_garrison, _opts)
			if _opts == nil then
				_opts = {}
			end

			_opts._dont_print__garrison_residence = true

			if consul.pprinter._is_null(_garrison) then
				return {}
			end

			return {
				["army"] = _garrison:army(),
				["buildings"] = _garrison:buildings(),
				["can_assault"] = _garrison:can_assault(),
				["faction"] = _garrison:faction(),
				["has_army"] = _garrison:has_army(),
				["has_navy"] = _garrison:has_navy(),
				["is_settlement"] = _garrison:is_settlement(),
				["is_slot"] = _garrison:is_slot(),
				["is_under_siege"] = _garrison:is_under_siege(),
				["model"] = _garrison:model(),
				["navy"] = _garrison:navy(),
				["region"] = _garrison:region(),
				["settlement_interface"] = consul.pprinter.settlement_script_interface(
					_garrison:settlement_interface(),
					_opts
				),
				["slot_interface"] = _garrison:slot_interface(),
				["unit_count"] = _garrison:unit_count(),
			}
		end,

		unit_script_interface = function(...)
			local log = consul.new_log("consul:pprinter:unit_script_interface")
			log:debug("Unit script interface called")

			local func = nil
			if consul_build == "Rome2" then
				func = consul.pprinter.unit_script_interface_rome
			elseif consul_build == "Attila" then
				func = consul.pprinter.unit_script_interface_attila
			end
			return func(...)
		end,
		unit_script_interface_rome = function(_unit, _opts)
			if _opts == nil then
				_opts = {}
			end
			if consul.pprinter._is_null(_unit) then
				return {}
			end
			return {
				["faction"] = _unit:faction(),
				["force_commander"] = _unit:force_commander(),
				["has_force_commander"] = _unit:has_force_commander(),
				["has_unit_commander"] = _unit:has_unit_commander(),
				["is_land_unit"] = _unit:is_land_unit(),
				["is_naval_unit"] = _unit:is_naval_unit(),
				["military_force"] = _unit:military_force(),
				["unit_commander"] = _unit:unit_commander(),
				["unit_key"] = _unit:unit_key(),
				["unit_category"] = _unit:unit_category(),
				["unit_class"] = _unit:unit_class(),
				["percentage_proportion_of_full_strength"] = _unit:percentage_proportion_of_full_strength(),
			}
		end,
		unit_script_interface_attila = function(_unit, _opts)
			if _opts == nil then
				_opts = {}
			end
			if consul.pprinter._is_null(_unit) then
				return {}
			end
			return {
				["faction"] = _unit:faction(),
				["force_commander"] = _unit:force_commander(),
				["has_force_commander"] = _unit:has_force_commander(),
				["has_unit_commander"] = _unit:has_unit_commander(),
				["is_land_unit"] = _unit:is_land_unit(),
				["is_naval_unit"] = _unit:is_naval_unit(),
				["military_force"] = _unit:military_force(),
				["unit_commander"] = _unit:unit_commander(),
				["unit_key"] = _unit:unit_key(),
				["unit_category"] = _unit:unit_category(),
				["unit_class"] = _unit:unit_class(),
				["can_upgrade_unit"] = _unit:can_upgrade_unit(),
				["can_upgrade_unit_equipment"] = _unit:can_upgrade_unit_equipment(),
				["percentage_proportion_of_full_strength"] = _unit:percentage_proportion_of_full_strength(),
			}
		end,

		unit_list_script_interface = function(_unitlist, _opts)
			if _opts == nil then
				_opts = {}
			end

			local log = consul.new_log("consul:pprinter:unit_list_script_interface")
			log:debug("Unit list script interface called")

			if consul.pprinter._is_null(_unitlist) then
				return {}
			end

			local units = {}
			for i = 0, _unitlist:num_items() - 1 do
				table.insert(units, consul.pprinter.unit_script_interface(_unitlist:item_at(i)))
			end
			return units
		end,

		military_force_script_interface = function(...)
			local log = consul.new_log("consul:pprinter:military_force_script_interface")
			log:debug("Military force script interface called")

			local func = nil
			if consul_build == "Rome2" then
				func = consul.pprinter.military_force_script_interface_rome
			elseif consul_build == "Attila" then
				func = consul.pprinter.military_force_script_interface_attila
			end
			return func(...)
		end,
		military_force_script_interface_rome = function(_force, _opts)
			if _opts == nil then
				_opts = {}
			end
			if consul.pprinter._is_null(_force) then
				return {}
			end
			return {
				["character_list"] = _force:character_list(),
				["faction"] = _force:faction(),
				["garrison_residence"] = _force:garrison_residence(),
				["general_character"] = _force:general_character(),
				["contains_mercenaries"] = _force:contains_mercenaries(),
				["has_garrison_residence"] = _force:has_garrison_residence(),
				["has_general"] = _force:has_general(),
				["is_army"] = _force:is_army(),
				["is_navy"] = _force:is_navy(),
				["upkeep"] = _force:upkeep(),
				["unit_list"] = consul.pprinter.unit_list_script_interface(_force:unit_list()),
			}
		end,
		military_force_script_interface_attila = function(_force, _opts)
			if _opts == nil then
				_opts = {}
			end
			if consul.pprinter._is_null(_force) then
				return {}
			end
			return {
				["active_stance"] = _force:active_stance(),
				["building_exists"] = _force:building_exists(),
				["buildings"] = "?",
				["can_activate_stance"] = _force:can_activate_stance(),
				["character_list"] = _force:character_list(),
				["command_queue_index"] = _force:command_queue_index(),
				["contains_mercenaries"] = _force:contains_mercenaries(),
				["faction"] = _force:faction(),
				["garrison_residence"] = _force:garrison_residence(),
				["general_character"] = _force:general_character(),
				["has_garrison_residence"] = _force:has_garrison_residence(),
				["has_general"] = _force:has_general(),
				["is_army"] = _force:is_army(),
				["is_horde"] = _force:is_horde(),
				["is_navy"] = _force:is_navy(),
				["upkeep"] = _force:upkeep(),
				["unit_list"] = consul.pprinter.unit_list_script_interface(_force:unit_list()),
			}
		end,

		character_script_interface = function(...)
			local log = consul.new_log("consul:pprinter:character_script_interface")
			log:debug("Character script interface called")

			local func = nil
			if consul_build == "Rome2" then
				func = consul.pprinter.character_script_interface_rome
			elseif consul_build == "Attila" then
				func = consul.pprinter.character_script_interface_attila
			end
			return func(...)
		end,
		character_script_interface_rome = function(_char, _opts)
			if _opts == nil then
				_opts = {}
			end
			if consul.pprinter._is_null(_char) then
				return {}
			end
			return {
				["action_points_per_turn"] = _char:action_points_per_turn(),
				["action_points_remaining_percent"] = _char:action_points_remaining_percent(),
				["age"] = _char:age(),
				["battles_fought"] = _char:battles_fought(),
				["battles_won"] = _char:battles_won(),
				["body_guard_casulties"] = "will crash game in campaign",
				["character_type"] = _char:character_type(),
				["cqi"] = _char:cqi(),
				["defensive_ambush_battles_fought"] = _char:defensive_ambush_battles_fought(),
				["defensive_ambush_battles_won"] = _char:defensive_ambush_battles_won(),
				["defensive_battles_fought"] = _char:defensive_battles_fought(),
				["defensive_battles_won"] = _char:defensive_battles_won(),
				["defensive_naval_battles_fought"] = _char:defensive_naval_battles_fought(),
				["defensive_naval_battles_won"] = _char:defensive_naval_battles_won(),
				["defensive_sieges_fought"] = _char:defensive_sieges_fought(),
				["defensive_sieges_won"] = _char:defensive_sieges_won(),
				["display_position_x"] = _char:display_position_x(),
				["display_position_y"] = _char:display_position_y(),
				["logical_position_x"] = _char:logical_position_x(),
				["logical_position_y"] = _char:logical_position_y(),
				["faction"] = consul.pprinter.faction_script_interface(_char:faction()),
				["forename"] = _char:forename(),
				["fought_in_battle"] = _char:fought_in_battle(),
				["garrison_residence"] = _char:garrison_residence(),
				["get_forename"] = _char:get_forename(),
				["get_political_party_id"] = _char:get_political_party_id(),
				["get_surname"] = _char:get_surname(),
				["has_ancillary"] = _char:has_ancillary(),
				["has_garrison_residence"] = _char:has_garrison_residence(),
				["has_military_force"] = _char:has_military_force(),
				["has_recruited_mercenaries"] = _char:has_recruited_mercenaries(),
				["has_region"] = _char:has_region(),
				["has_skill"] = _char:has_skill(),
				["has_spouse"] = _char:has_spouse(),
				["has_trait"] = _char:has_trait(),
				["in_port"] = _char:in_port(),
				["in_settlement"] = _char:in_settlement(),
				["is_ambushing"] = _char:is_ambushing(),
				["is_besieging"] = _char:is_besieging(),
				["is_blockading"] = _char:is_blockading(),
				["is_carrying_troops"] = "will crash agent in campaign",
				["is_deployed"] = _char:is_deployed(),
				["is_embedded_in_military_force"] = _char:is_embedded_in_military_force(),
				["is_faction_leader"] = _char:is_faction_leader(),
				["is_hidden"] = _char:is_hidden(),
				["is_male"] = _char:is_male(),
				["is_polititian"] = _char:is_polititian(),
				["military_force"] = consul.pprinter.military_force_script_interface(_char:military_force()),
				["model"] = _char:model(),
				["number_of_traits"] = _char:number_of_traits(),
				["offensive_ambush_battles_fought"] = _char:offensive_ambush_battles_fought(),
				["offensive_ambush_battles_won"] = _char:offensive_ambush_battles_won(),
				["offensive_battles_fought"] = _char:offensive_battles_fought(),
				["offensive_battles_won"] = _char:offensive_battles_won(),
				["offensive_naval_battles_fought"] = _char:offensive_naval_battles_fought(),
				["offensive_naval_battles_won"] = _char:offensive_naval_battles_won(),
				["offensive_sieges_fought"] = _char:offensive_sieges_fought(),
				["offensive_sieges_won"] = _char:offensive_sieges_won(),
				["percentage_of_own_alliance_killed"] = _char:percentage_of_own_alliance_killed(),
				["performed_action_this_turn"] = _char:performed_action_this_turn(),
				["rank"] = _char:rank(),
				["region"] = _char:region(),
				["routed_in_battle"] = "will crash game in campaign",
				["spouse"] = _char:spouse(),
				["surname"] = _char:surname(),
				["trait_level"] = _char:trait_level(),
				["trait_points"] = _char:trait_points(),
				["turns_at_sea"] = _char:turns_at_sea(),
				["turns_in_enemy_regions"] = _char:turns_in_enemy_regions(),
				["turns_in_own_regions"] = _char:turns_in_own_regions(),
				["turns_without_battle_in_home_lands"] = _char:turns_without_battle_in_home_lands(),
				["won_battle"] = _char:won_battle(),
			}
		end,
		character_script_interface_attila = function(_char, _opts)
			if _opts == nil then
				_opts = {}
			end
			if consul.pprinter._is_null(_char) then
				return {}
			end
			return {
				["action_points_per_turn"] = _char:action_points_per_turn(),
				["action_points_remaining_percent"] = _char:action_points_remaining_percent(),
				["age"] = _char:age(),
				["battles_fought"] = _char:battles_fought(),
				["battles_won"] = _char:battles_won(),
				["body_guard_casulties"] = "will crash game in campaign",
				["character_type"] = _char:character_type(),
				["command_queue_index"] = _char:command_queue_index(),
				["cqi"] = _char:cqi(),
				["defensive_ambush_battles_fought"] = _char:defensive_ambush_battles_fought(),
				["defensive_ambush_battles_won"] = _char:defensive_ambush_battles_won(),
				["defensive_battles_fought"] = _char:defensive_battles_fought(),
				["defensive_battles_won"] = _char:defensive_battles_won(),
				["defensive_naval_battles_fought"] = _char:defensive_naval_battles_fought(),
				["defensive_naval_battles_won"] = _char:defensive_naval_battles_won(),
				["defensive_sieges_fought"] = _char:defensive_sieges_fought(),
				["defensive_sieges_won"] = _char:defensive_sieges_won(),
				["display_position_x"] = _char:display_position_x(),
				["display_position_y"] = _char:display_position_y(),
				["logical_position_x"] = _char:logical_position_x(),
				["logical_position_y"] = _char:logical_position_y(),
				["faction"] = consul.pprinter.faction_script_interface(_char:faction()),
				["family_member"] = _char:family_member(),
				["father"] = _char:father(),
				["forename"] = _char:forename(),
				["fought_in_battle"] = _char:fought_in_battle(),
				["garrison_residence"] = _char:garrison_residence(),
				["get_forename"] = _char:get_forename(),
				["get_surname"] = _char:get_surname(),
				["gravitas"] = _char:gravitas(),
				["has_ancillary"] = _char:has_ancillary(),
				["has_father"] = _char:has_father(),
				["has_mother"] = _char:has_mother(),
				["has_garrison_residence"] = _char:has_garrison_residence(),
				["has_military_force"] = _char:has_military_force(),
				["has_recruited_mercenaries"] = _char:has_recruited_mercenaries(),
				["has_region"] = _char:has_region(),
				["has_skill"] = _char:has_skill(),
				["has_trait"] = _char:has_trait(),
				["in_port"] = _char:in_port(),
				["in_settlement"] = _char:in_settlement(),
				["is_ambushing"] = _char:is_ambushing(),
				["is_besieging"] = _char:is_besieging(),
				["is_blockading"] = _char:is_blockading(),
				["is_carrying_troops"] = "will crash agent in campaign",
				["is_deployed"] = _char:is_deployed(),
				["is_embedded_in_military_force"] = _char:is_embedded_in_military_force(),
				["is_faction_leader"] = _char:is_faction_leader(),
				["is_hidden"] = _char:is_hidden(),
				["is_male"] = _char:is_male(),
				["is_politician"] = _char:is_politician(),
				["loyalty"] = _char:loyalty(),
				["military_force"] = consul.pprinter.military_force_script_interface(_char:military_force()),
				["mother"] = _char:mother(),
				["number_of_traits"] = _char:number_of_traits(),
				["offensive_ambush_battles_fought"] = _char:offensive_ambush_battles_fought(),
				["offensive_ambush_battles_won"] = _char:offensive_ambush_battles_won(),
				["offensive_battles_fought"] = _char:offensive_battles_fought(),
				["offensive_battles_won"] = _char:offensive_battles_won(),
				["offensive_naval_battles_fought"] = _char:offensive_naval_battles_fought(),
				["offensive_naval_battles_won"] = _char:offensive_naval_battles_won(),
				["offensive_sieges_fought"] = _char:offensive_sieges_fought(),
				["offensive_sieges_won"] = _char:offensive_sieges_won(),
				["percentage_of_own_alliance_killed"] = _char:percentage_of_own_alliance_killed(),
				["performed_action_this_turn"] = _char:performed_action_this_turn(),
				["rank"] = _char:rank(),
				["region"] = _char:region(),
				["routed_in_battle"] = "will crash game in campaign",
				["surname"] = _char:surname(),
				["trait_level"] = _char:trait_level(),
				["trait_points"] = _char:trait_points(),
				["turns_at_sea"] = _char:turns_at_sea(),
				["turns_in_enemy_regions"] = _char:turns_in_enemy_regions(),
				["turns_in_own_regions"] = _char:turns_in_own_regions(),
				["won_battle"] = _char:won_battle(),
			}
		end,

		faction_script_interface = function(...)
			local log = consul.new_log("consul:pprinter:faction_script_interface")
			log:debug("Faction script interface called")

			local func = nil
			if consul_build == "Rome2" then
				func = consul.pprinter.faction_script_interface_rome
			elseif consul_build == "Attila" then
				func = consul.pprinter.faction_script_interface_attila
			end
			return func(...)
		end,
		faction_script_interface_rome = function(_fac, _opts)
			if _opts == nil then
				_opts = {}
			end
			if consul.pprinter._is_null(_fac) then
				return {}
			end
			return {
				["allied_with"] = _fac:allied_with(),
				["ancillary_exists"] = _fac:ancillary_exists(),
				["at_war"] = _fac:at_war(),
				["character_list"] = _fac:character_list(),
				["culture"] = _fac:culture(),
				["difficulty_level"] = _fac:difficulty_level(),
				["ended_war_this_turn"] = _fac:ended_war_this_turn(),
				["faction_attitudes"] = _fac:faction_attitudes(),
				["faction_leader"] = _fac:faction_leader(),
				["government_type"] = _fac:government_type(),
				["has_faction_leader"] = _fac:has_faction_leader(),
				["has_food_shortage"] = _fac:has_food_shortage(),
				["has_home_region"] = _fac:has_home_region(),
				["has_researched_all_technologies"] = _fac:has_researched_all_technologies(),
				["has_technology"] = _fac:has_technology(),
				["home_region"] = _fac:home_region(),
				["imperium_level"] = _fac:imperium_level(),
				["is_human"] = _fac:is_human(),
				["losing_money"] = _fac:losing_money(),
				["military_force_list"] = _fac:military_force_list(),
				["model"] = _fac:model(),
				["name"] = _fac:name(),
				["new"] = _fac:new(),
				["num_allies"] = _fac:num_allies(),
				["num_enemy_trespassing_armies"] = _fac:num_enemy_trespassing_armies(),
				["num_factions_in_war_with"] = _fac:num_factions_in_war_with(),
				["num_generals"] = _fac:num_generals(),
				["num_trade_agreements"] = _fac:num_trade_agreements(),
				["politics"] = _fac:politics(),
				["politics_party_add_loyalty_modifier"] = _fac:politics_party_add_loyalty_modifier(),
				["region_list"] = _fac:region_list(),
				["research_queue_idle"] = (function()
					-- wont work for rebels
					if _fac:name() == "rebels" then
						return "will crash game in campaign"
					end
					return _fac:research_queue_idle()
				end)(),
				["sea_trade_route_raided"] = _fac:sea_trade_route_raided(),
				["started_war_this_turn"] = _fac:started_war_this_turn(),
				["state_religion"] = _fac:state_religion(),
				["subculture"] = _fac:subculture(),
				["tax_category"] = _fac:tax_category(),
				["tax_level"] = _fac:tax_level(),
				["total_food"] = _fac:total_food(),
				["trade_resource_exists"] = _fac:trade_resource_exists(),
				["trade_route_limit_reached"] = (function()
					-- wont work for rebels
					if _fac:name() == "rebels" then
						return "will crash game in campaign"
					end
					return _fac:trade_route_limit_reached()
				end)(),
				["trade_ship_not_in_trade_node"] = _fac:trade_ship_not_in_trade_node(),
				["trade_value"] = _fac:trade_value(),
				["trade_value_percent"] = _fac:trade_value_percent(),
				["treasury"] = _fac:treasury(),
				["treasury_percent"] = _fac:treasury_percent(),
				["treaty_details"] = _fac:treaty_details(),
				["unused_international_trade_route"] = function()
					-- wont work for rebels
					if _fac:name() == "rebels" then
						return "will crash game in campaign"
					end
					return _fac:unused_international_trade_route()
				end,
				["upkeep_expenditure_percent"] = _fac:upkeep_expenditure_percent(),
			}
		end,
		faction_script_interface_attila = function(_fac, _opts)
			if _opts == nil then
				_opts = {}
			end
			if consul.pprinter._is_null(_fac) then
				return {}
			end
			return {
				["allied_with"] = _fac:allied_with(),
				["ancillary_exists"] = _fac:ancillary_exists(),
				["at_war"] = _fac:at_war(),
				["at_war_with"] = _fac:at_war_with(),
				["character_list"] = _fac:character_list(),
				["command_queue_index"] = _fac:command_queue_index(),
				["culture"] = _fac:culture(),
				["ended_war_this_turn"] = _fac:ended_war_this_turn(),
				["faction_leader"] = _fac:faction_leader(),
				["has_faction_leader"] = _fac:has_faction_leader(),
				["has_food_shortage"] = _fac:has_food_shortage(),
				["has_home_region"] = _fac:has_home_region(),
				["has_technology"] = _fac:has_technology(),
				["home_region"] = _fac:home_region(),
				["imperium_level"] = _fac:imperium_level(),
				["is_horde"] = _fac:is_horde(),
				["is_human"] = _fac:is_human(),
				["is_null_interface"] = _fac:is_null_interface(),
				["is_trading_with"] = _fac:is_trading_with(),
				["losing_money"] = _fac:losing_money(),
				["military_force_list"] = _fac:military_force_list(),
				["model"] = _fac:model(),
				["name"] = _fac:name(),
				["new"] = _fac:new(),
				["num_allies"] = _fac:num_allies(),
				["num_generals"] = _fac:num_generals(),
				["region_list"] = _fac:region_list(),
				["research_queue_idle"] = (function()
					-- wont work for rebels
					if _fac:name() == "rebels" then
						return "will crash game in campaign"
					end
					return _fac:research_queue_idle()
				end)(),
				["sea_trade_route_raided"] = _fac:sea_trade_route_raided(),
				["started_war_this_turn"] = _fac:started_war_this_turn(),
				["state_religion"] = _fac:state_religion(),
				["state_religion_percentage"] = _fac:state_religion_percentage(),
				["subculture"] = _fac:subculture(),
				["tax_level"] = _fac:tax_level(),
				["trade_resource_exists"] = _fac:trade_resource_exists(),
				["trade_route_limit_reached"] = (function()
					-- wont work for rebels
					if _fac:name() == "rebels" then
						return "will crash game in campaign"
					end
					return _fac:trade_route_limit_reached()
				end)(),
				["trade_ship_not_in_trade_node"] = _fac:trade_ship_not_in_trade_node(),
				["trade_value"] = _fac:trade_value(),
				["trade_value_percent"] = _fac:trade_value_percent(),
				["treasury"] = _fac:treasury(),
				["treasury_percent"] = _fac:treasury_percent(),
				["unused_international_trade_route"] = (function()
					-- wont work for rebels
					if _fac:name() == "rebels" then
						return "will crash game in campaign"
					end
					return _fac:unused_international_trade_route()
				end)(),
				["upkeep_expenditure_percent"] = _fac:upkeep_expenditure_percent(),
			}
		end,

		settlement_script_interface = function(...)
			local log = consul.new_log("consul:pprinter:settlement_script_interface")
			log:debug("Settlement script interface called")

			local func = nil
			if consul_build == "Rome2" then
				func = consul.pprinter.settlement_script_interface_rome
			elseif consul_build == "Attila" then
				func = consul.pprinter.settlement_script_interface_attila
			end
			return func(...)
		end,
		settlement_script_interface_rome = function(_settl, _opts)
			if _opts == nil then
				_opts = {}
			end
			_opts._dont_print__slot_list = true

			if consul.pprinter._is_null(_settl) then
				return {}
			end
			return {
				["castle_slot"] = _settl:castle_slot(),
				["commander"] = _settl:commander(),
				["display_position_x"] = _settl:display_position_x(),
				["display_position_y"] = _settl:display_position_y(),
				["logical_position_x"] = _settl:logical_position_x(),
				["logical_position_y"] = _settl:logical_position_y(),
				["faction"] = consul.pprinter.faction_script_interface(_settl:faction(), _opts),
				["has_castle_slot"] = _settl:has_castle_slot(),
				["has_commander"] = _settl:has_commander(),
				["region"] = consul.pprinter.region_script_interface(_settl:region(), _opts),
				["slot_list"] = consul.pprinter.slot_list_interface(_settl:slot_list()),
			}
		end,
		settlement_script_interface_attila = function(_settl, _opts)
			if _opts == nil then
				_opts = {}
			end
			_opts._dont_print__slot_list = true

			if consul.pprinter._is_null(_settl) then
				return {}
			end
			return {
				["commander"] = _settl:commander(),
				["display_position_x"] = _settl:display_position_x(),
				["display_position_y"] = _settl:display_position_y(),
				["logical_position_x"] = _settl:logical_position_x(),
				["logical_position_y"] = _settl:logical_position_y(),
				["faction"] = consul.pprinter.faction_script_interface(_settl:faction(), _opts),
				["has_commander"] = _settl:has_commander(),
				["is_null_interface"] = _settl:is_null_interface(),
				["region"] = consul.pprinter.region_script_interface(_settl:region(), _opts),
				["slot_list"] = consul.pprinter.slot_list_interface(_settl:slot_list()),
			}
		end,

		region_script_interface = function(...)
			local log = consul.new_log("consul:pprinter:region_script_interface")
			log:debug("Region script interface called")

			local func = nil
			if consul_build == "Rome2" then
				func = consul.pprinter.region_script_interface_rome
			elseif consul_build == "Attila" then
				func = consul.pprinter.region_script_interface_attila
			end
			return func(...)
		end,
		region_script_interface_rome = function(_region, _opts)
			if _opts == nil then
				_opts = {}
			end
			if consul.pprinter._is_null(_region) then
				return {}
			end
			return {
				["adjacent_region_list"] = _region:adjacent_region_list(),
				["building_exists"] = _region:building_exists(),
				["building_superchain_exists"] = _region:building_superchain_exists(),
				["garrison_residence"] = (function()
					if _opts and _opts._dont_print__garrison_residence then
						return _region:garrison_residence()
					end
					return consul.pprinter.garrison_script_interface(_region:garrison_residence())
				end)(),
				["last_building_constructed_key"] = _region:last_building_constructed_key(),
				["majority_religion"] = _region:majority_religion(),
				["name"] = _region:name(),
				["num_buildings"] = _region:num_buildings(),
				["owning_faction"] = _region:owning_faction(),
				["province_name"] = _region:province_name(),
				["public_order"] = _region:public_order(),
				["region_wealth"] = _region:region_wealth(),
				["region_wealth_change_percent"] = _region:region_wealth_change_percent(),
				["resource_exists"] = _region:resource_exists(),
				["sanitation"] = _region:sanitation(),
				["settlement"] = _region:settlement(),
				["slot_list"] = (function()
					if _opts and _opts._dont_print__slot_list then
						return _region:slot_list()
					end
					return consul.pprinter.slot_list_interface(_region:slot_list())
				end)(),
				["slot_type_exists"] = _region:slot_type_exists(),
				["squalor"] = _region:squalor(),
				["tax_income"] = _region:tax_income(),
				["town_wealth_growth"] = _region:town_wealth_growth(),
			}
		end,
		region_script_interface_attila = function(_region, _opts)
			if _opts == nil then
				_opts = {}
			end
			if consul.pprinter._is_null(_region) then
				return {}
			end
			return {
				["adjacent_region_list"] = _region:adjacent_region_list(),
				["building_exists"] = _region:building_exists(),
				["building_superchain_exists"] = _region:building_superchain_exists(),
				["garrison_residence"] = (function()
					if _opts and _opts._dont_print__garrison_residence then
						return _region:garrison_residence()
					end
					return consul.pprinter.garrison_script_interface(_region:garrison_residence())
				end)(),
				["governor"] = _region:governor(),
				["has_governor"] = _region:has_governor(),
				["is_null_interface"] = _region:is_null_interface(),
				["last_building_constructed_key"] = _region:last_building_constructed_key(),
				["majority_religion"] = _region:majority_religion(),
				["majority_religion_percentage"] = _region:majority_religion_percentage(),
				["name"] = _region:name(),
				["num_buildings"] = _region:num_buildings(),
				["owning_faction"] = _region:owning_faction(),
				["public_order"] = _region:public_order(),
				["region_wealth_change_percent"] = _region:region_wealth_change_percent(),
				["resource_exists"] = _region:resource_exists(),
				["sanitation"] = _region:sanitation(),
				["settlement"] = _region:settlement(),
				["slot_list"] = (function()
					if _opts and _opts._dont_print__slot_list then
						return _region:slot_list()
					end
					return consul.pprinter.slot_list_interface(_region:slot_list())
				end)(),
				["slot_type_exists"] = _region:slot_type_exists(),
				["squalor"] = _region:squalor(),
				["town_wealth_growth"] = _region:town_wealth_growth(),
			}
		end,

		building_script_interface = function(...)
			local log = consul.new_log("consul:pprinter:building_script_interface")
			log:debug("Building script interface called")

			local func = nil
			if consul_build == "Rome2" then
				func = consul.pprinter.building_script_interface_rome
			elseif consul_build == "Attila" then
				func = consul.pprinter.building_script_interface_attila
			end
			return func(...)
		end,
		building_script_interface_rome = function(_build, _opts)
			if _opts == nil then
				_opts = {}
			end
			if consul.pprinter._is_null(_build) then
				return {}
			end
			return {
				["chain"] = _build:chain(),
				["faction"] = _build:faction(),
				["name"] = _build:name(),
				["region"] = _build:region(),
				["slot"] = _build:slot(),
				["superchain"] = _build:superchain(),
			}
		end,
		building_script_interface_attila = function(_build, _opts)
			if _opts == nil then
				_opts = {}
			end
			if consul.pprinter._is_null(_build) then
				return {}
			end
			return {
				["chain"] = _build:chain(),
				["faction"] = _build:faction(),
				["name"] = _build:name(),
				["percent_health"] = _build:percent_health(),
				["region"] = _build:region(),
				["slot"] = _build:slot(),
				["superchain"] = _build:superchain(),
			}
		end,

		slot_script_interface = function(_slot, _opts)
			local log = consul.new_log("consul:pprinter:slot_script_interface")
			log:debug("Slot script interface called")

			if _opts == nil then
				_opts = {}
			end

			if consul.pprinter._is_null(_slot) then
				return {}
			end
			return {
				["name"] = _slot:name(),
				["building"] = consul.pprinter.building_script_interface(_slot:building()),
				["faction"] = _slot:faction(),
				["has_building"] = _slot:has_building(),
				["region"] = _slot:region(),
				["type"] = _slot:type(),
			}
		end,

		slot_list_interface = function(_slotlist, _opts)
			local log = consul.new_log("consul:pprinter:slot_list_interface")
			log:debug("Slot list script interface called")

			if _opts == nil then
				_opts = {}
			end

			if consul.pprinter._is_null(_slotlist) then
				return {}
			end

			local slots = {}

			for i = 0, _slotlist:num_items() - 1 do
				slots[tostring(i)] = consul.pprinter.slot_script_interface(_slotlist:item_at(i), _opts)
			end

			return {
				["buliding_type_exists"] = _slotlist:buliding_type_exists(),
				["is_empty"] = _slotlist:is_empty(),
				["num_items"] = _slotlist:num_items(),
				["slot_type_exists"] = _slotlist:slot_type_exists(),
				["_consul_slots"] = slots,
			}
		end,
	},
}

return consul
