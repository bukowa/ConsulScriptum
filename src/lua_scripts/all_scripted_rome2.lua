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
-- On macOS the working directory may be the filesystem root (protected),
-- so fall back to the user's home directory.
local __log_path
do
    local sep = package.config:sub(1, 1)
    if sep ~= '\\' then
        local function find_base_path()
            -- CWD writable? Use relative path (covers Linux/Proton where CWD is set correctly).
            local test = io.open('consul.log', 'a')
            if test then test:close(); return '' end

            local home = os.getenv('HOME') or '/tmp'

            -- Detect macOS vs Linux: /proc/version exists only on Linux.
            local pv = io.open('/proc/version', 'r')
            local is_linux = pv ~= nil
            if pv then pv:close() end

            -- Read all library paths from Steam's libraryfolders.vdf.
            local function read_library_paths(vdf_path)
                local f = io.open(vdf_path, 'r')
                if not f then return {} end
                local content = f:read('*all')
                f:close()
                local paths = {}
                for p in content:gmatch('"path"%s+"([^"]+)"') do
                    table.insert(paths, p)
                end
                return paths
            end

            -- Return the Rome II game path if installed in this Steam library, nil otherwise.
            -- Uses appmanifest_214950.acf (Rome II app ID) as the presence check.
            local function find_rome2(lib_root)
                local f = io.open(lib_root .. '/steamapps/appmanifest_214950.acf', 'r')
                if not f then return nil end
                f:close()
                return lib_root .. '/steamapps/common/Total War Rome II/'
            end

            -- Steam installation directories to probe, in priority order.
            local steam_bases = is_linux
                and { home .. '/.local/share/Steam', home .. '/.steam/steam' }
                or  { home .. '/Library/Application Support/Steam' }

            for _, steam_base in ipairs(steam_bases) do
                local libs = read_library_paths(steam_base .. '/steamapps/libraryfolders.vdf')
                table.insert(libs, 1, steam_base)  -- Steam base is always an implicit library
                for _, lib in ipairs(libs) do
                    local path = find_rome2(lib)
                    if path then return path end
                end
            end

            return '/tmp/'
        end
        __log_path = find_base_path() .. 'consul.log'
    else
        __log_path = 'consul.log'
    else
        -- macOS / Linux: write to the user's home directory
        local home = os.getenv('HOME') or '/tmp'
        __log_path = home .. '/Library/Application Support/Steam/steamapps/common/Total War Rome II/' .. '/consul.log'
       
    end
end

local __write = function(line)
    local f = io.open(__log_path, 'a')
    if f then
        f:write(line)
        f:close()
    end
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
