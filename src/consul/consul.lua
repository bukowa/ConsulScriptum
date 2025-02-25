consul = {

    VERSION = "0.1.0",
    URL = "http://github.com/bukowa/ConsulScriptum",
    AUTHOR = "Mateusz Kurowski",
    CONTACT = "gitbukowa@gmail.com",

    -- game requires a char before /t
    -- it also makes /t very long, so just use spaces
    tab = string.char(1) .. '   ',

    -- setup consul
    setup = function()
        consul.console.commands.setup()
        table.insert(events.UICreated, consul.ui.OnUICreated)
        table.insert(events.ComponentMoved, consul.ui.OnComponentMoved)
        table.insert(events.ComponentLClickUp, consul.ui.OnComponentLClickUp)
        table.insert(events.UICreated, consul.history.OnUICreated)
        table.insert(events.ComponentLClickUp, consul.history.OnComponentLClickUp)
        table.insert(events.ComponentLClickUp, consul.console.OnComponentLClickUp)
    end,

    -- logging
    log = require 'consul_logging'.new(),

    -- contrib
    serpent = require 'serpent',
    inspect = require 'inspect',

    -- helper function to pretty print a table
    pretty = function(_obj)
        return consul.inspect(_obj, { newline = '\n', indent = consul.tab })
    end,

    -- compatibility patches for other mods
    compat = {

        -- DEI removes the Prologue button in main menu
        -- it is done by modifying the sp_frame ui file which we override
        -- just disable the Prologue button in the main menu
        dei = function()
            -- todo first check if DEI is loaded
            consul.ui.find('button_introduction'):SetState('inactive')
        end,
    },

    config = {
        path = "consul.config",

        default = {
            ui = {
                position = {
                    x = 0,
                    y = 0
                },
                visibility = {
                    root = 1,
                    consul = 1,
                    scriptum = 1,
                }
            },
            console = {
                autoclear = false,
                autoclear_after = 1,
            }
        },

        new = function()
            return {
                ui = {
                    position = {
                        x = 0,
                        y = 0
                    },
                    visibility = {
                        root = 1,
                        consul = 1,
                        scriptum = 1,
                    }
                },
                console = {
                    autoclear = false,
                    autoclear_after = 1,
                }
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
        end,


        read = function()
            local serpent, log, config = consul.serpent, consul.log, consul.config

            log:debug("Reading config file: " .. config.path)

            local f = io.open(config.path, "r")
            if f then
                log:debug("File exists: " .. config.path)
                local f_content = f:read("*all")
                f:close()
                --log:debug("File content: " .. f_content)

                local ok, cfg = serpent.load(f_content)
                if ok then
                    if config.validate(cfg) then
                        return cfg
                    else
                        log:error("Config file is invalid: " .. config.path)
                    end
                else
                    log:warn("Could not load config: " .. cfg)  -- Log the error message from serpent.load
                end
            end

            log:debug("Creating default config file: " .. config.path)
            local cfg = config.new()
            config.write(cfg)

            return cfg
        end,

        write = function(cfg)
            consul.log:debug("Writing config file: " .. consul.config.path)
            local f = io.open(consul.config.path, "w")
            if f then
                -- remember to pass maxlevel as Rome2 LUA has no math.huge defined
                f:write(consul.serpent.dump(cfg, { maxlevel = 10000, comment = false, indent = '\t' }))
                f:close()
            end
        end
    },

    ui = {
        -- contains all the components
        root = "consul_scriptum",
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

        -- keep internals private
        _UIRoot = nil,
        _UIComponent = nil,
        _UIContext = nil,

        -- shortcut to find a UIComponent with some guards
        find = function(key)

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
            if (not consul.ui._UIRoot) or (not consul.ui._UIComponent) then
                log:error("No access to UIComponent")
                return nil
            end

            -- try to find locally and check if it still works
            local c = consul.ui._UIComponent(consul.ui._UIRoot:Find(key))

            -- check if component handling is still functional
            if (not consul.ui._UIRoot) or (not consul.ui._UIComponent) then
                log:error('Something went wrong with the UIComponent handling; UIComponent is nil')
                return nil
            end

            -- c is nil
            if not c then
                log:warn('Could not find component: ' .. key)
                return nil
            end

            -- even if the component is found, some actions may not work
            -- assume that everything works if Visible is not nil (it may be any method)
            if c:Visible() == nil then
                log:error('Something went wrong with the UIComponent handling; visible is nil')
                return nil
            end

            -- all fine
            return c
        end,

        -- moves the consul root to the center of the screen
        -- trying to make docking work in the ui files is a pain
        -- so we just move it to the center of the screen
        -- lets calculate the proper position - resolution can vary
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

            -- if UIComponent is nil grab it from package.loaded
            if not UIComponent then
                log:warn('UIComponent is nil; trying to grab it from other modules')

                -- when in campaign
                if package.loaded ~= nil then
                    if package.loaded.CoreUtils ~= nil then
                        log:debug("Finding UIComponent in CoreUtils")
                        UIComponent = package.loaded.CoreUtils.UIComponent
                    end
                end
            end

            log:debug("UIComponent: " .. tostring(UIComponent))

            -- shorthand
            local ui = consul.ui
            local log = consul.log

            -- set the root and UIComponent
            ui._UIRoot = UIComponent(context.component)
            ui._UIComponent = UIComponent
            ui._UIContext = context

            -- log errors
            if not consul.ui._UIRoot then
                log:error("Could not find the root component")
                return
            end

            -- log errors
            if not consul.ui._UIComponent then
                log:error("Could not find the UIComponent")
                return
            end

        end,

        -- event handler to be set in the main script
        -- handles any click event for the consul
        OnComponentLClickUp = function(context)

            -- shorthand
            local ui = consul.ui
            local log = consul.log

            -- top menu toggle button
            if context.string == ui.button_toggle then
                log:debug("Toggled visibility of: consul root")

                -- find the root component
                local r = ui.find(ui.root)

                -- read position from config
                local cfg = consul.config.read()
                local x = cfg.ui.position.x
                local y = cfg.ui.position.y

                -- if they are 0 then move to center
                if x == 0 and y == 0 then
                    ui.MoveRootToCenter()
                else
                    r:MoveTo(x, y)
                end

                -- toggle visibility
                r:SetVisible(not r:Visible())

                return
            end

            -- scriptum listview minimized
            if context.string == ui.scriptum_minimize then
                log:debug("Toggled visibility of: scriptum listview")

                -- find the component
                local c = ui.find(ui.console)

                -- toggle visibility
                c:SetVisible(not c:Visible())

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
            local log = consul.log
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
            local log = consul.log
            local hst = consul.history

            if context.string == ui.console_send then
                local c = ui.find(ui.console_input)
                local entry = c:GetStateText()
                hst.add(entry)
                return
            end

            if context.string == ui.history_up then
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

        -- clears the console output
        clear = function()
            local ui = consul.ui
            ui.find(ui.console_output_text_1):SetStateText('')
        end,

        -- reads the input from the console
        read = function()
            local ui = consul.ui
            local c = ui.find(ui.console_input)
            return c:GetStateText()
        end,

        -- writes a message to the console
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
                c:SetStateText(text .. '\n' .. msg)
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

            -- setups the commands
            setup = function()
                local cfg = consul.config.read()
                local commands = consul.console.commands

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
            end,

            -- these should include extra space if they take params
            starts_with = {
                ['/r '] = {
                    help = function()
                        return "Shorthand for 'return <Lua code>. "
                                .. "Example: /r 2 + 2"
                    end,
                    func = function(_cmd)
                        return 'return ' .. string.sub(_cmd, 4)
                    end,
                    exec = true,
                    returns = true,
                },
                ['/p '] = {
                    help = function()
                        return "Pretty-prints a Lua value using 'inspect'. "
                                .. "Example: /p _G"
                    end,
                    func = function(_cmd)
                        return 'return consul.inspect(' .. string.sub(_cmd, 4) .. ', {newline=\'\\n\', indent=\'' .. consul.tab .. '\'})'
                    end,
                    exec = true,
                    returns = true,
                },
                ['/autoclear_after'] = {
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
                    end
                },
            },
            exact = {
                ['/help'] = {
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
                            local v = consul.console.commands.exact[k]
                                    or consul.console.commands.starts_with[k]
                            local padding = string.rep(' ', max - string.len(k) + 1)
                            help = help .. tab .. k .. padding .. " - " .. v.help() .. "\n"
                        end

                        -- strip the last newline
                        return string.sub(help, 1, string.len(help) - 1)
                    end,
                    exec = false,
                    returns = true,
                },
                ['/clear'] = {
                    help = function()
                        return "Clears the console output."
                    end,
                    func = function()
                        consul.console.clear()
                    end,
                    exec = false,
                    returns = false,
                },
                ['/history'] = {
                    help = function()
                        return "Prints the history of the console."
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
                ['/autoclear'] = {
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
                    end
                },
            },
        },

        -- internal function to execute a command
        _execute = function(cmd)

            -- make function from string
            local f, err = loadstring(cmd)
            if err then
                return tostring('lua loadstring: ' .. tostring(err))
            end

            -- execute the function
            local success, result = pcall(f)

            -- if cmd did not start with 'return' statement
            -- then lua will just return nil as the result
            -- we don't want to print it as this is not the standard lua behavior
            if success and (not result) and (string.sub(cmd, 1, 7) ~= "return ") then
                assert(false, "this value should not be returned")
            end

            -- return error message if failed
            if not success then
                return tostring('lua pcall: ' .. tostring(result))
            end

            return tostring(result)
        end,

        -- executes a command from the console
        execute = function(cmd)

            local console = consul.console
            local settings = console.commands.settings

            -- check for autoclear setting
            if settings.autoclear then
                if settings._autoclear_current >= settings.autoclear_after then
                    console.clear()
                    settings._autoclear_current = 0
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
            local ui = consul.ui
            local console = consul.console

            if context.string == ui.console_send then
                console.execute(console.read())

                -- put the cursor back to the input field
                ui.find(ui.console_input):SimulateClick()
                return
            end
        end,

    },

    -- custom event handlers
    -- in order to dynamically delete events
    -- we need to keep track of them and delete when needed
    -- so we attach to the game events only once and then
    -- we call anything that is registered in the event_handlers
    event_handlers = {
        ['SettlementSelected'] = {
            ['transfer_settlement'] = nil,
        }
    },

    -- dispatches an event
    event_dispatcher = function(event_name)
        return function(context)
            local eh = consul.event_handlers[event_name]
            for _, v in pairs(eh) do
                if v then
                    v(context)
                end
            end
        end
    end,

    -- scripts to be run from 'consul' listview
    scripts = {
        _is_ready = false,

        -- setup the script, should be called once
        setup = function()
            if consul.scripts._is_ready then
                return
            end
            -- setup the event handlers
            scripting = require 'lua_scripts.EpisodicScripting'
            for k, _ in pairs(consul.event_handlers) do
                scripting.AddEventCallBack(k, consul.event_dispatcher(k))
            end

            consul.scripts._is_ready = true
        end,

        -- transfer a region to a faction
        transfer_settlement = {

            _region = nil,
            _faction = nil,

            stop = function()
                consul.scripts.transfer_settlement._region = nil
                consul.scripts.transfer_settlement._faction = nil
                consul.event_handlers[ev][en] = nil
            end,

            start = function()

                -- there can be multiple events
                -- you can click on settlement or army
                -- or even click from the strategic view?
                local ev = {
                    'SettlementSelected',
                    'CharacterSelected',
                }

                local en = 'transfer_settlement'

                local eh_settlement = function(context)

                    local console = consul.console
                    local script = consul.scripts.transfer_settlement

                    -- first we pick the settlement to transfer
                    if not script._region then
                        script._region = context.settlement:region():name()
                        console.write("Selected settlement to transfer: " .. script._region)
                        return
                    end

                    -- then we pick the faction to transfer to
                    if not script._faction then
                        tf = context.settlement():faction():name()
                        consul.console.write("Transferring settlement: " .. tr .. " to faction: " .. tf .. "?")
                    end

                    -- if both are set, transfer the region
                    if tr and tf then
                        scripting.game_interface:transfer_region_to_faction(tr, tf)
                        consul.console.write("Transferred settlement: " .. tr .. " to faction: " .. tf)
                    end

                    consul.scripts.transfer_settlement.stop()

                end,

                consul.console.write("Select a settlement to transfer")
            end
        }
        --
    }
}
