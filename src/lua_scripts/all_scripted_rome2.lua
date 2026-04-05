--[[
Import all the lua scripts
--]]

local triggers = require "data.lua_scripts.export_triggers"
local ancillaries  = require "data.lua_scripts.export_ancillaries"
local historic_characters = require "data.lua_scripts.export_historic_characters"
local missions = require "data.lua_scripts.export_missions"
local encyclopedia = require "data.lua_scripts.export_encyclopedia"
local experience = require "data.lua_scripts.export_experience"
local political = require "data.lua_scripts.export_political_triggers"

events = triggers.events
--[[
print(events, #events)

for n,v in ipairs(events.historical_events) do print(n, v) end
--]]

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
