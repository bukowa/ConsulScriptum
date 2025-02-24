consul = {

    VERSION = "0.1.0",
    AUTHOR = "Mateusz Kurowski",
    CONTACT = "gitbukowa@gmail.com",

    log = require 'consul_logging'.new(),

    pl = {
        serpent = require 'serpent',
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
        end,


        read = function()
            local serpent, log, config = consul.pl.serpent, consul.log, consul.config

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
                f:write(consul.pl.serpent.dump(cfg, { maxlevel = 10000, comment = false, indent = '\t' }))
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

                -- move it first
                ui.MoveRootToCenter()

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

                --elseif context.string == ui.console_input then
                --    log:debug("History click... ;(")
                --    -- click on input clears the text field
                --    local c = ui.find('textinput')
                --    c:SetStateText(hst.current)
                --    return
            end

        end,
    },

    console = {

        -- should hold current session pages
        pages = {},
        -- should hold the current page
        page = 1,

        -- reads the input from the console
        read = function()
            local ui = consul.ui

            local c = ui.find(ui.console_input)
            return c:GetStateText()
        end,

        -- writes a message to the console
        write = function(msg)
            local ui = consul.ui

            local c = ui.find(ui.console_output_text_1)
            text = c:GetStateText()
            c:SetStateText(text .. '\n' .. msg)
        end,

        commands = {
            -- these should include extra space if they take params
            starts_with = {
                ['/r '] = {
                    help = "shorthand for: return <statement>)",
                    func = function(_cmd)
                        return 'return ' .. _cmd
                    end,
                    exec = true,
                }
            },
            exact = {
                ['/help'] = {
                    help = "displays help",
                    func = function(...)
                        -- build the help message from other commands
                        local help = ""
                        for k, v in pairs(consul.console.commands.exact) do
                            help = help .. k .. " - " .. v.help .. "\n"
                        end
                        for k, v in pairs(consul.console.commands.starts_with) do
                            help = help .. k .. " - " .. v.help .. "\n"
                        end
                        return help
                    end,
                    exec = false,
                }
            }
        },

        -- todo
        execute = function(cmd)
            local console = consul.console

            -- first write the command to the output window
            console.write("$ " .. cmd)

            -- handle super cases or user provided commands
            for k, v in pairs(console.commands.exact) do
                if cmd == k then
                    local r = v.func()

                    if v.exec then
                        --todo exec command
                    else
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
                        --todo exec command
                    else
                        console.write(r)
                    end
                    return
                end
            end
        end,

        OnComponentLClickUp = function(context)
            local ui = consul.ui
            local console = consul.console

            if context.string == ui.console_send then
                log:debug("Console send")

                console.execute(console.read())
                return
            end
        end,

    }
}
