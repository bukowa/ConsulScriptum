--[[
    ConsulScriptum: Custom Commands

    This file demonstrates how to add your own custom commands to the ConsulScriptum console.
    When ConsulScriptum starts, it will automatically detect this file and merge your commands.

    Two ways to install:
    1. Local Override: Name your file `consul_custom_commands.lua` and place it directly in the game's root directory (where the game .exe is).
       Commands in this file will MERGE with and OVERRIDE any existing mod pack commands!
    2. Mod Pack: Create a mod pack file (e.g. "My Custom Commands Pack") to distribute on Steam Workshop. 
       Inside your pack, name your file `consul_commands.lua` and place it at: consul/consul_commands.lua

    Command Properties:
    - exec (boolean)    : If true, the string returned by `func` is dynamically executed by the console as raw Lua code (or another command).
    - returns (boolean) : If true, the string returned by `func` is printed directly to the visual console output.
    - help (function)   : Returns a string that gets automatically appended into the `/help` command output.
    - func (function)   : The logic of your command. For `starts_with` commands, `_cmd` (the raw string) is passed in.
    - setup (function)  : (Optional) A function called once at startup. Resolves the console `cfg` configuration state.
]]

local _is_logging_settlements = false

return {
    exact = {
        -- Advanced Example: Background Event Hook
        -- This example demonstrates how custom commands can safely hook into 
        -- the Total War engine's background event system instead of just returning text.
        -- 
        -- 1. We use a local boolean (_is_logging_settlements) to track the state.
        -- 2. During setup(), we inject a listener into the 'SettlementSelected' event.
        -- 3. The actual '/ex_settlement_log' command simply flips the boolean!
        ['/ex_settlement_log'] = {
            setup = function(cfg)
                -- Register the event listener using our exact command string as the unique key
                consul.consul_scripts.event_handlers['SettlementSelected']['/ex_settlement_log'] = function(context)
                    if _is_logging_settlements then
                        local region = context:garrison_residence():region():name()
                        consul.console.write("Settlement Selected: " .. region)
                    end
                end
                consul.log:debug("/ex_settlement_log event hook initialized!")
            end,
            help = function()
                return "[Example] Toggle player-selected settlement log."
            end,
            func = function()
                _is_logging_settlements = not _is_logging_settlements
                return "Settlement logging enabled: " .. tostring(_is_logging_settlements)
            end,
            exec = false,
            returns = true,
        },

        -- Example of a standard strict command utilizing the Consul game wrappers
        ['/ex_local_faction'] = {
            help = function()
                return "[Example] Print stats for human faction."
            end,
            func = function()
                -- Getting raw Total War engine objects using consul._game() 
                local faction_list = consul._game():model():world():faction_list()
                
                for i = 0, faction_list:num_items() - 1 do
                    local fac = faction_list:item_at(i)
                    if fac:is_human() then
                        -- You can explicitly write lines to the console
                        consul.console.write("Human faction detected: " .. fac:name())
                        consul.console.write("Current Treasury: " .. fac:treasury())
                        
                        -- The final return string is also printed because `returns = true`
                        return "Command complete."
                    end
                end
                
                return "No human faction found."
            end,
            exec = false,
            returns = true,
        }
    },

    starts_with = {
        -- Example of a parameterized command utilizing `returns = true`
        ['/ex_echo '] = {
            help = function()
                return "[Example] Echo input text."
            end,
            func = function(_cmd)
                local msg = string.sub(_cmd, 7)
                return "Server says: " .. msg
            end,
            exec = false,
            returns = true,
        },
        
        -- Example of an EXEC mode command utilizing `exec = true`
        ['/ex_run_lua '] = {
            help = function()
                return "[Example] Execute raw Lua code string."
            end,
            func = function(_cmd)
                local codeSnippet = string.sub(_cmd, 10)
                
                -- Because exec=true, we return a STRING OF LUA CODE. 
                -- The console will then dynamically interpret and run this code!
                return codeSnippet
            end,
            exec = true,
            returns = false,
        }
    }
}
