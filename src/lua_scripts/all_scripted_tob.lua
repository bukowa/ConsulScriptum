

-- store the starting time of this session
lua_start_time = os.clock();

-- gets a timestamp string
function get_timestamp()
	return "<" .. string.format("%.1f", os.clock() - lua_start_time) .. "s>";
end;


-- re-mapping of all output functions so that they support timestamps
function remap_outputs(out_table)

	_G.out_impl = out_table;

	local out = {};

	-- add additional output tabs here if/when they get added
	local output_functions = {
		"shane",
		"dylan",
		"tom",
		"kostas",
		"ting",
		"scott_b",
		"design",
		"ui"
	};

	-- create a tab level record for each output function, and store it at out.tab_levels
	local tab_levels = {};
	for i = 1, #output_functions do
		tab_levels[output_functions[i]] = 0;
	end;
	tab_levels["out"] = 0;			-- default tab
	out.tab_levels = tab_levels;

	-- go through each output function
	for i = 1, #output_functions do
		local current_func_name = output_functions[i];

		out[current_func_name] = function(input)
			input = input or "";

			local timestamp = get_timestamp();
			local output_str = timestamp .. string.format("%" .. 11 - string.len(timestamp) .."s", " ");

			-- add in all required tab chars
			for i = 1, out["tab_levels"][current_func_name] do
				output_str = output_str .. "\t";
			end;

			output_str = output_str .. tostring(input);

			out_impl[current_func_name](output_str);

			-- logfile output
			if __write_output_to_logfile then
				local file = io.open(__logfile_path, "a");
				if file then
					file:write("[" .. current_func_name .. "] " .. output_str .. "\n");
					file:close();
				end;
			end;
		end;
	end;

	-- also allow out to be directly called

	setmetatable(
		out,
		{
			__call = function(t, input)
				input = input or "";

				local timestamp = get_timestamp();
				local output_str = timestamp .. string.format("%" .. 11 - string.len(timestamp) .."s", " ");

				-- add in all required tab chars
				for i = 1, out.tab_levels["out"] do
					output_str = output_str .. "\t";
				end;

				output_str = output_str .. input;
				print(output_str);

				-- logfile output
				if __write_output_to_logfile then
					local file = io.open(__logfile_path, "a");
					if file then
						file:write("[out] " .. output_str .. "\n");
						file:close();
					end;
				end;
			end
		}
	);

	-- add on functions inc, dec, cache and restore tab levels
	function out.inc_tab(func_name)
		func_name = func_name or "out";

		local current_tab_level = out.tab_levels[func_name];

		if not current_tab_level then
			script_error("ERROR: inc_tab() called but supplied output function name [" .. tostring(func_name) .. "] not recognised");
			return false;
		end;

		out.tab_levels[func_name] = current_tab_level + 1;
	end;

	function out.dec_tab(func_name)
		func_name = func_name or "out";

		local current_tab_level = out.tab_levels[func_name];

		if not current_tab_level then
			script_error("ERROR: dec_tab() called but supplied output function name [" .. tostring(func_name) .. "] not recognised");
			return false;
		end;

		if current_tab_level > 0 then
			out.tab_levels[func_name] = current_tab_level - 1;
		end;
	end;

	function out.cache_tab(func_name)
		func_name = func_name or "out";

		local current_tab_level = out.tab_levels[func_name];

		if not current_tab_level then
			script_error("ERROR: cache_tab() called but supplied output function name [" .. tostring(func_name) .. "] not recognised");
			return false;
		end;

		-- store cached tab level elsewhere in the tab_levels table
		out.tab_levels["cached_" .. func_name] = current_tab_level;
		out.tab_levels[func_name] = 0;
	end;

	function out.restore_tab(func_name)
		func_name = func_name or "out";

		local cached_tab_level = out.tab_levels["cached_" .. func_name];

		if not cached_tab_level then
			script_error("ERROR: restore_tab() called but could find no cached tab value for supplied output function name [" .. tostring(func_name) .. "]");
			return false;
		end;

		-- restore tab level, and clear the cached value
		out.tab_levels[func_name] = cached_tab_level;
		out.tab_levels["cached_" .. func_name] = nil;
	end;

	return out;
end;


-- call the remap function so that timestamped output is available immediately (script in other environments will have to re-call it)
out = remap_outputs(out);




function get_events()
	if _G.events then
		return _G.events;
	else
		local events = require "data.lua_scripts.events";
		_G.events = events;
		return events;
	end;
end;

--[[
Import all the lua scripts
--]]


local triggers = require "data.lua_scripts.export_triggers"
local ancillaries  = require "data.lua_scripts.export_ancillaries"
local historic_characters = require "data.lua_scripts.export_historic_characters"
local encyclopedia = require "data.lua_scripts.export_encyclopedia"
local experience = require "data.lua_scripts.export_experience"

events = get_events();

-- Ensure logging to a file if something goes wrong
local __write = function(line)
    local f = io.open('consul.log', 'a')
    f:write(line)
    f:close()
end

__write('Starting consul\n')
-- Add the consul path to the package path
-- Warning: This means that if the game directory
-- contains a consul directory, it will be prioritized.
package.path = package.path .. ";consul/?.lua"

-- Load the consul module
__write('Loading consul\n')
local ok, result = pcall(require, 'consul')
if not ok then
    __write('Failed to load consul: ' .. tostring(result) .. '\n')
else
    __write('Loaded consul\n')
    local success, err = pcall(consul.setup)
    if not success then
        __write('Setup error: ' .. tostring(err) .. '\n')
    else
        __write('Setup successful\n')
    end
end
