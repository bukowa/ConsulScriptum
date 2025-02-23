consul = {

    VERSION = "0.1.0",
    AUTHOR = "Mateusz Kurowski",
    CONTACT = "gitbukowa@gmail.com",

    log = require 'consul_logging'.new(),

    pl = {
        pretty = require 'pl.pretty',
        tablex = require 'pl.tablex',
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

        deepcopy = function()
            return consul.pl.tablex.deepcopy(consul.config.default)
        end,

        read = function()
            local pl, log, config = consul.pl, consul.log, consul.config

            log:debug("Reading config file: " .. config.path)

            local f = io.open(config.path, "r")
            if f then
                --
                log:debug("File exists: " .. config.path)
                local f_content = f:read("*all")
                f:close()
                log:debug("File content: " .. f_content)
                --
                local cfg = pl.pretty.read(f_content)
                if cfg then
                    return cfg
                end
                log:warn("Could not read config file: " .. config.path)
            end

            -- Create default config if file does not exist or is invalid
            log:debug("Creating default config file: " .. config.path)
            local cfg = config.deepcopy()
            pl.pretty.dump(cfg, config.path)
            return cfg
        end,

        write = function(cfg)
            consul.pl.pretty.dump(cfg, consul.config.path)
        end

    },

    ui = {
        -- contains all the components
        root = "consul_scriptum",
        -- turns visibility of the root component on and off
        button_toggle = "consul_scriptum_button_toggle",
        -- contains the console
        console = "consul_scriptum_console",
        -- contains the consul listview
        consul = "room_list",
        -- minimizes the consul listview
        consul_minimize = "room_list_button_minimize",
        -- contains the scriptum listview
        scriptum = "friends_list",
        -- minimizes the scriptum listview
        scriptum_minimize = "friends_list_button_minimize",

        -- when called, returns the element via find method
        find = function(key)
            return consul.ui._UIComponent(consul.ui._m_root:Find(key))
        end,

        -- keep internals private
        _m_root = nil,
        _UIComponent = nil,

        -- moves the consul root to the center of the screen
        MoveRootToCenter = function()

            -- shorthand
            local ui = consul.ui

            -- just move it!
            local x = ui._m_root:Width()
            local y = ui._m_root:Height()
            local w = 700
            local h = 500
            local cx = (x / 2) - (w / 2)
            local cy = (y / 2) - (h / 2)
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
            ui._m_root = UIComponent(context.component)
            ui._UIComponent = UIComponent

            -- finished!
            log:debug("UICreated end  : " .. context.string
                    .. ' m_root :' .. tostring(consul.ui._m_root)
                    .. 'UIComponent :' .. tostring(consul.ui._UIComponent))

            -- log errors
            if not consul.ui._m_root then
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

            log:debug("Clicked on component: " .. context.string)

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

                local c = ui.find(ui.console)
                c:SetVisible(not c:Visible())
                return
            end

        end,

        -- event handler to be set in the main script
        -- handles movement of the consul components
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

                -- write the config
                config.write(cfg)

            end
        end
    },
}
