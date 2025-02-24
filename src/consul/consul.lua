consul = {

    VERSION = "0.1.0",
    URL = "http://github.com/bukowa/ConsulScriptum",
    AUTHOR = "Mateusz Kurowski",
    CONTACT = "gitbukowa@gmail.com",

    log = require 'consul_logging'.new(),

    -- game requires a char before a tab
    tab = string.char(1) .. '   ',

    serpent = require 'serpent',
    inspect = require 'inspect',

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

            -- try recreating the UIComponent in case something bad happened
            if not consul.ui._UIRoot then
                log:warn("Recreating UIComponent: " .. tostring(consul.ui._UIContext))
                consul.ui._UIRoot = UIComponent(consul.ui._UIContext.component)
            end

            -- make sure the key is of type string- if not, and you pass something
            -- that cannot be resolved to a string, it may break the upstream game code
            -- making all kind of weird things happen, like interacting with UIComponent methods
            -- won't work anymore - just return a string with error in this case
            if type(key) ~= "string" then
                return "error: key passed to find is not a string"
            end

            -- all fine
            return consul.ui._UIComponent(consul.ui._UIRoot:Find(key))
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
        -- keep them private in case something goes wrong with the globals
        OnUICreated = function(context)

            -- shorthand
            local ui = consul.ui
            local log = consul.log

            -- started!
            log:debug("UICreated start: " .. context.string)

            -- set the root and UIComponent
            ui._UIRoot = UIComponent(context.component)
            ui._UIComponent = UIComponent
            ui._UIContext = context

            -- finished!
            log:debug("UICreated end  : " .. context.string
                    .. ' m_root :' .. tostring(consul.ui._UIRoot)
                    .. 'UIComponent :' .. tostring(consul.ui._UIComponent))

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
                log:debug("History add")
                local c = ui.find(ui.console_input)
                local entry = c:GetStateText()
                hst.add(entry)
                return
            end

            if context.string == ui.history_up then
                log:debug("History up")
                hst.up()
                local c = ui.find(ui.console_input)
                c:SetStateText(hst.current)
                return

            elseif context.string == ui.history_down then
                log:debug("History down")
                hst.down()
                local c = ui.find(ui.console_input)
                c:SetStateText(hst.current)
                return
            end

        end,
    },

    console = {

        -- should hold current session pages
        pages = {},
        -- should hold the current page
        page = 1,

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

            -- setups the commands
            setup = function()
                cfg = consul.config.read()

                for k, v in pairs(consul.console.commands.exact) do
                    if v.setup then
                        v.setup(cfg)
                    end
                end
                for k, v in pairs(consul.console.commands.starts_with) do
                    if v.setup then
                        v.setup(cfg)
                    end
                end
            end,

            settings = {
                autoclear = false,
            },

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
                ['/autoclear'] = {
                    help = function()
                        return "Toggles console autoclear setting."
                    end,
                    func = function()
                        local commands = consul.console.commands
                        -- toggle the setting
                        commands.settings.autoclear = not commands.settings.autoclear
                        -- write the new setting to the config
                        local cfg = consul.config.read()
                        cfg.console.autoclear = commands.settings.autoclear
                        consul.config.write(cfg)
                    end,
                    exec = false,
                    returns = false,
                    setup = function(cfg)
                        consul.console.commands.settings.autoclear = cfg.console.autoclear
                    end
                },
            },
            exact = {
                ['/help'] = {
                    help = function()
                        return "displays help"
                    end,
                    func = function(...)

                        -- using raw \t doesn't work as it requires a string
                        local tab = consul.tab

                        -- build the help message from other commands
                        -- first section are the console commands
                        local help = "Console commands:\n"
                        for k, v in pairs(consul.console.commands.exact) do
                            help = help .. tab .. k .. " - " .. v.help() .. "\n"
                        end
                        for k, v in pairs(consul.console.commands.starts_with) do
                            help = help .. tab .. k .. " - " .. v.help() .. "\n"
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

            -- check for autoclear setting
            if console.commands.settings.autoclear then
                console.clear()
            end

            -- first write the command to the output window
            console.write("$ " .. cmd)

            -- exact
            for k, v in pairs(console.commands.exact) do
                if cmd == k then
                    local r = v.func()
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
                return
            end
        end,

    }
}
