package.path = package.path .. ";consul/?.lua"

require('consul')
pl = require 'pl.pretty'

-- Import the module
local consul_config = require('consul_config')

-- Remove the config file
os.remove(CONSUL.CONFIG.FILE)

-- Config logic tests
local function test_config_logic()

    -- Initialize the config
    consul_config.init_config()
    local t = consul_config.read_config()
    assert(t ~= nil, "Config should be initialized")

    -- Save some values
    local test_value = "consul.consul.minimized"

    -- Make sure the value is 0
    assert(t[test_value:gsub("%.", "_")] == 0, "Value should be 0")

    -- Change the value
    consul_config.write_config(test_value, 100)

    -- Intialize the config again
    consul_config.init_config()

    -- Read the config
    t = consul_config.read_config()

    -- Make sure the value is 100
    assert(t[test_value:gsub("%.", "_")] == 100, "Value should be 100")

    -- Read the config with k
    local value = consul_config.read_config(test_value)
    assert(value == 100, "Value should be 100: " .. tostring(value))
end


test_config_logic()
print('Test 1 passed!')
