require 'consul'

-- Create a logger
local log = require 'consul_logging'.new_logger("consul_config")

-- Initialize the config file
local init_config = function()
    if not io.open(CONSUL.CONFIG.FILE, "r") then
        log:info("Creating config file: " .. CONSUL.CONFIG.FILE)
        local f = io.open(CONSUL.CONFIG.FILE, "w")
        f:write(CONSUL.CONFIG.DEFAULT)
        f:close()
    end
end

-- Read the config file
local read_config = function(k)
    local t = require 'pl.config'.read(CONSUL.CONFIG.FILE)
    if not t then
        log:error("Could not read config file: " .. CONSUL.CONFIG.FILE)
    end
    if not k then
        return t
    end
    return t[k:gsub("%.", "_")]
end

-- Write to the config file
local write_config = function(k, v)
    local f = io.open(CONSUL.CONFIG.FILE, "r")
    if not f then
        log:error("Could not open file: " .. CONSUL.CONFIG.FILE)
        return
    end

    local lines = {}
    for line in f:lines() do
        if line:find(k) then
            line = k .. "=" .. v
        end
        table.insert(lines, line)
    end
    f:close()
    f = io.open(CONSUL.CONFIG.FILE, "w")
    for _, line in ipairs(lines) do
        f:write(line .. "\n")
    end
    f:close()
end


return {
    init_config = init_config,
    read_config = read_config,
    write_config = write_config
}
