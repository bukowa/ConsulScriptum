-- Default log file path
local default_log_file_path = "consul.log"

-- Path to this file
local PACKAGE_PATH = debug.getinfo(1, 'S').source

-- Define logging levels
local levels = {
    DISABLED = -2,
    TRACE = -1,
    INTERNAL = 0,
    DEBUG = 1,
    INFO = 2,
    WARN = 3,
    ERROR = 4,
    CRITICAL = 5,
}

-- Logger class-like structure
local Logger = {}
Logger.__index = Logger

-- Export all levels
Logger.levels = levels

-- Constructor for creating a new logger instance
function Logger.new(name, log_level, log_file_path)
    local self = setmetatable({}, Logger)

    -- Assign name
    self.name = name or "main"

    -- Assign log file path
    self.log_file_path = log_file_path or default_log_file_path

    -- Ensure `set_level` is called correctly
    self:set_level(log_level or levels.INFO)

    -- Internal Libraries
    self._require_func = require

    -- Are we already logging all events?
    self._is_logging_all_events = false

    -- Are we logging game events?
    self._is_logging_game_events = false

    return self
end

function Logger:pretty_table(table)
    self:raw(self.lib_pl__pretty.write(table))
end

-- Internal method to write directly to the log file
function Logger:_write_to_file(text)
    local logfile, err = io.open(self.log_file_path, "a")
    if not logfile then
        error("Failed to open log file: " .. (err or "Unknown error"))
    end
    logfile:write(text .. "\n")
    logfile:close()
end

-- Internal method to write a log entry with level and formatting
function Logger:_write_log_entry(level, text)

    if #level == 4 then
        level = level .. " "  -- Add extra space for alignment
    elseif #level > 6 then
        level = string.sub(level, 1, 7)
    end

    local timestamp = os.date("[%Y-%m-%d %H:%M:%S]")
    local log_entry = string.format("%s [%s] %s: %s", timestamp, level, self.name, text)
    self:_write_to_file(log_entry)
end

-- Public method to write raw text to the log file
function Logger:raw(text)
    self:_write_to_file(text)
end

-- Generic log function
function Logger:log(level, text)
    text = tostring(text or "")

    -- Convert level to a numeric value
    local level_num = levels[level] or tonumber(level) or levels.INFO

    -- Skip logging if the logger is disabled or the level is below the current threshold
    if self.log_level == levels.DISABLED or level_num < self.log_level then
        return
    end

    -- Write the log entry
    self:_write_log_entry(level, text)
end

-- Convenience methods for specific log levels
function Logger:debug(text)
    self:log("DEBUG", text)
end

function Logger:info(text)
    self:log("INFO", text)
end

function Logger:warn(text)
    self:log("WARN", text)
end

function Logger:error(text)
    self:log("ERROR", text)
end

function Logger:internal(text)
    self:log("INTERNAL", text)
end

function Logger:critical(text)
    self:log("CRITICAL", text)
end

function Logger:trace(text)
    self:log("TRACE", text)
end

-- Safely execute a function and log errors if it fails
function Logger:pcall(func, ...)
    -- Skip error logging if the logger is disabled
    if self.log_level == levels.DISABLED then
        return pcall(func, ...)
    end

    local success, result = pcall(func, ...)
    if not success then
        self:error("Error during execution: " .. tostring(result))
    end
    return success, result
end

function Logger:require(moduleName, is_critical_module)
    self:debug("Loading module: '" .. moduleName .. "'")
    local success, result = pcall(self._require_func, moduleName)
    if not success then

        if is_critical_module then
            self:critical("Critical error loading module: '" .. moduleName .. "'")
            -- Quit
            if CliExecute ~= nil then
                CliExecute('quit')
            end
        else
            self:error("Error loading module: '" .. moduleName .. "': " .. tostring(result))
        end

        return nil
    end

    self:internal("Module loaded: " .. moduleName)
    return result
end

-- Set the logging level dynamically
function Logger:set_level(level)
    if type(level) == "string" then
        level = levels[level]
    else
        level = tonumber(level)
    end
    self.log_level = level
end

-- todo: do not log if source is in this file <<
function Logger:start_trace(mask, write_log_entry, callback)
    mask = (mask == nil) and "c" or mask
    write_log_entry = (write_log_entry == nil) and true or write_log_entry

    debug.sethook(function(event)

        -- Gather info
        local info = debug.getinfo(3, 'nSluf')

        -- Add event to info table
        if info == nil then
            info = {
                ["event"] = event,
            }
        else
            info['event'] = event
        end

        -- Skip if source is this file
        if info.source ~= nil and info.source == PACKAGE_PATH then
            return
        end

        local message = string.format(
                "Event: %s | Function: %s | Source: %s | Line: %d",
                event,
                info.name or "?",
                info.source or "?",
                info.currentline or "-1"
        )

        if write_log_entry then
            --self:trace(message)
            self:_write_to_file(message)
        end
        if callback then
            self:pcall(callback, event, info)
        end
    end, mask)
end

-- Method to stop the trace hook
function Logger:stop_trace()
    -- Remove the hook by passing nil
    debug.sethook()
end

-- Log events based on a filter function, with always-filtered events
function Logger:log_events(_events, filter_func)

    -- Define events to always filter out
    local always_filtered = {
        ["_PACKAGE"] = true,
        ["_M"] = true,
        ["_NAME"] = true,
    }

    -- Loop through all events and apply the filter
    for _, event in ipairs(_events) do

        -- Skip always filtered events
        if not always_filtered[event] and filter_func(event) then

            -- Attempt to register the event callback with error handling
            local success, err = pcall(function()

                if events[event] == nil then
                    events[event] = {}
                end

                table.insert(events[event], function(context)

                    -- build a better looking context table
                    local context_log = {
                        _event = event,
                    }

                    -- grab original
                    local context_metatable = debug.getmetatable(context)

                    -- add each key inside __index as key
                    for k, v in pairs(context_metatable.__index) do
                        context_log[k] = v
                    end

                    if context_log.string == "" then
                        context_log.string = nil
                    end

                    -- log the event
                    self:_write_to_file(consul.pretty(context_log));
                end)

            end)

            -- If callback registration fails, log the error
            if not success then
                self:error("Failed to register logging for event: " .. event .. " Error: " .. err)
            end
        end
    end
end

function Logger:get_all_events()
    return consul.utils.merge_and_deduplicate(
            consul._events.base,
            consul._events.decompiled
    )
end

-- Log all events
function Logger:log_events_all()

    -- Check if already logging all events
    if self._is_logging_all_events then
        self:warn("Already logging all events, skipping...")
        return
    end

    self:log_events(self:get_all_events(), function()
        return true
    end)
end

-- Log all events excluding
-- Component events, TimeTrigger events, and ShortcutTriggered events
function Logger:log_game_events()

    -- Check if already logging all events
    if self._is_logging_game_events then
        self:warn("Already logging game events, skipping...")
        return
    end

    -- Create a filter function that excludes Component events
    local function filter_func(event)
        -- Skip events containing "Component"
        if string.match(event, "Component") then
            return false
        end
        -- skip TimeTrigger
        if string.match(event, "TimeTrigger") then
            return false
        end
        -- skip ShortcutTriggered
        if event == "ShortcutTriggered" then
            return false
        end
        return true
    end

    -- Log events with the custom filter
    self:log_events(self:get_all_events(), filter_func)
end

-- Log all events excluding specified events
function Logger:log_events_all_excluding(excluded_events_list)
    -- Import all events
    local all_events = self:require('data.lua_scripts.events')

    -- Convert list to a lookup table for quick filtering
    local excluded_events = {}
    for _, event in ipairs(excluded_events_list) do
        excluded_events[event] = true
    end

    -- Create a filter function that excludes the specified events
    local function filter_func(event)
        return not excluded_events[event]  -- Only log events not in the excluded list
    end

    -- Log events with the custom filter
    self:log_events(all_events, filter_func)
end

-- Module return
return {
    Logger = Logger,
    levels = levels,
}