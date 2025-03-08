consul = {

    VERSION = "0.1.6",
    URL = "http://github.com/bukowa/ConsulScriptum",
    AUTHOR = "Mateusz Kurowski",
    CONTACT = "gitbukowa@gmail.com",

    -- game requires a char before /t
    -- it also makes /t very long, so just use spaces
    tab = string.char(1) .. '   ',

    -- setup consul
    setup = function()
        table.insert(events.UICreated, consul.console.commands.setup)
        table.insert(events.UICreated, consul.ui.OnUICreated)
        table.insert(events.UICreated, consul.compat.setup)
        table.insert(events.ComponentMoved, consul.ui.OnComponentMoved)
        table.insert(events.ComponentLClickUp, consul.ui.OnComponentLClickUp)
        table.insert(events.UICreated, consul.history.OnUICreated)
        table.insert(events.ComponentLClickUp, consul.history.OnComponentLClickUp)
        table.insert(events.ComponentLClickUp, consul.console.OnComponentLClickUp)
        -- access to 'EpisodicScripting' may be required
        -- load later to avoid any issues with the game
        table.insert(events.UICreated, consul.consul_scripts.setup)
        table.insert(events.ComponentLClickUp, consul.consul_scripts.OnComponentLClickUp)
        table.insert(events.UICreated, consul.scriptum.setup)
        table.insert(events.ComponentLClickUp, consul.scriptum.OnComponentLClickUp)
    end,

    -- logging
    log = require 'consul_logging'.new(),

    -- shortcut to create a new logger
    new_log = function(name)
        return require 'consul_logging'.new(name)
    end,

    -- contrib
    serpent = require 'serpent.serpent',
    inspect = require 'inspect.inspect',
    pretty = require 'penlight.pretty'.write,

    pretty_inspect = function(_obj)
        return consul.inspect(_obj, { newline = '\n' })
    end,

    -- compatibility patches for other mods
    compat = {

        setup = function()
            local log = consul.new_log('compat:setup')
            log:debug("Setting up compatibility patches")

            -- pcall each and log errors
            for k, v in pairs(consul.compat.patches) do
                local ok, result = pcall(v)
                if not ok then
                    log:error("Error in patch: " .. k .. " " .. result)
                elseif result then
                    -- 'result' is expected to be a boolean
                    log:debug("Compat patch applied: " .. k)
                end
            end
        end,

        patches = {
            -- DEI removes the Prologue button in main menu
            -- it is done by modifying the sp_frame ui file which we override
            -- just disable the Prologue button in the main menu
            dei = function()
                local log = consul.new_log('compat:dei')

                -- this file has only tables, it should be safe to require
                local dei_script = 'script._lib.manpower.units'

                -- Attempt to require the script and check if DEI is loaded
                local ok, _ = pcall(require, dei_script)
                if not ok then
                    log:debug("DEI not detected, skipping patch")
                    return false
                end

                -- If DEI is loaded, apply the patch
                log:debug("DEI detected, applying compatibility patch")

                -- Find and disable the Prologue button
                local button = consul.ui.find('button_introduction')
                if button then
                    button:SetState('inactive')
                    log:debug("Disabled Prologue button")
                else
                    -- we may be in Campaign UI or Battle UI
                    -- just skip, the proper way would be to check
                    -- if we are in Frontend UI...
                end

                return true
            end,
        },

    },

    config = {
        path = "consul.config",

        new = function()
            return {
                ui = {
                    position = {
                        x = 0,
                        y = 0
                    },
                    visibility = {
                        root = 0,
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


        -- read and write in one go
        process = function(func)
            local log = consul.new_log('config:process')
            log:debug("Processing config file: " .. consul.config.path)
            local cfg = consul.config.read()
            func(cfg)
            consul.config.write(cfg)
        end,

        read = function()
            local log = consul.new_log('config:read')
            local serpent = consul.serpent
            local config = consul.config

            log:debug("Reading config file: " .. config.path)

            local f = io.open(config.path, "r")
            if f then
                log:debug("File exists: " .. config.path)
                local f_content = f:read("*all")
                f:close()

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
            local log = consul.new_log('config:write')
            log:debug("Writing config file: " .. consul.config.path)
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

        -- scriptum entry
        scriptum_entry = "scriptum_entry",
        scriptum_entry_text = "scriptum_entry_text",

        -- consul entries
        consul_exterminare_entry = "consul_exterminare_entry",
        consul_exterminare_script = "consul_exterminare_script",
        consul_transfersettlement_entry = "consul_transfersettlement_entry",
        consul_transfersettlement_script = "consul_transfersettlement_script",
        consul_adrebellos_entry = "consul_adrebellos_entry",
        consul_adrebellos_script = "consul_adrebellos_script",
        consul_force_make_peace_entry = "consul_force_make_peace_entry",
        consul_force_make_peace_script = "consul_force_make_peace_script",
        consul_force_make_war_entry = "consul_force_make_war_entry",
        consul_force_make_war_script = "consul_force_make_war_script",

        -- keep internals private
        _UIRoot = nil,
        _UIComponent = nil,
        _UIContext = nil,

        -- shortcut to find a UIComponent with some guards
        find = function(key)
            local log = consul.new_log('ui:find')

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
            local log = consul.new_log('ui:OnUICreated')
            log:debug("UI created")

            local ui = consul.ui

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
            local log = consul.new_log('ui:OnComponentLClickUp')

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

                -- save to config
                consul.config.process(function(_cfg)
                    _cfg.ui.visibility.root = r:Visible() and 1 or 0
                end)

                -- setup scriptum
                -- doing it here allows for
                -- reload each time the consul is toggled
                consul.scriptum.setup()
                return
            end

            -- scriptum listview minimized
            if context.string == ui.scriptum_minimize then
                log:debug("Toggled visibility of: scriptum listview")

                -- find the component
                local c = ui.find(ui.console)

                -- toggle visibility
                c:SetVisible(not c:Visible())

                -- save to config
                consul.config.process(function(cfg)
                    cfg.ui.visibility.scriptum = c:Visible() and 1 or 0
                end)

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
            local log = consul.new_log('ui:OnComponentMoved')
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
            local log = consul.new_log('history:OnComponentLClickUp')
            local hst = consul.history

            if context.string == ui.console_send then
                log:debug("Adding entry to history")

                local c = ui.find(ui.console_input)
                local entry = c:GetStateText()
                hst.add(entry)
                return
            end

            if context.string == ui.history_up then
                log:debug("Moving history up")

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
                log:debug("Moving history down")
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

            _is_setup = false,

            -- setups the commands
            setup = function()
                local log = consul.new_log('console:commands:setup')
                local cfg = consul.config.read()
                local commands = consul.console.commands

                log:debug("Setting up console commands")

                -- if already setup, skip
                if commands._is_setup then
                    log:debug("Already setup")
                    return
                end

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
                commands._is_setup = true
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
                        return "Pretty-prints a Lua value using 'penlight'. "
                                .. "Example: /p _G"
                    end,
                    func = function(_cmd)
                        return 'return consul.pretty(' .. string.sub(_cmd, 4) .. ')'
                    end,
                    exec = true,
                    returns = true,
                },
                ['/p2'] = {
                    help = function()
                        return "Pretty-prints a Lua value using 'inspect'. "
                                .. "Example: /p2 _G"
                    end,
                    func = function(_cmd)
                        return 'return consul.pretty_inspect(' .. string.sub(_cmd, 4) .. ')'
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
                ['/faction_list'] = {
                    help = function()
                        return "Prints the list of factions."
                    end,
                    func = function()
                        return consul.pretty(consul.game.faction_list())
                    end,
                    exec = false,
                    returns = true,
                },
                ['/region_list'] = {
                    help = function()
                        return "Prints the list of regions."
                    end,
                    func = function()
                        return consul.pretty(consul.game.region_list())
                    end,
                    exec = false,
                    returns = true,
                },
                ['/debug_onclick'] = {
                    _is_running = false,

                    help = function()
                        return "Prints debug information of the clicked component."
                    end,

                    func = function()
                        local command = consul.console.commands.exact['/debug_onclick']
                        local console = consul.console

                        if command._is_running then
                            command._is_running = false
                            return
                        end

                        table.insert(events.ComponentLClickUp, function(context)
                            if command._is_running then
                                console.clear()
                                console.write(consul.pretty(debug.getmetatable(context)))
                            end
                        end)

                        command._is_running = true
                    end,
                    exec = false,
                    returns = true,
                },
                ['/debug_mouseover'] = {
                    _is_running = false,
                    help = function()
                        return "Prints debug information of the mouseover component."
                    end,
                    func = function()
                        local command = consul.console.commands.exact['/debug_mouseover']
                        local console = consul.console

                        if command._is_running then
                            command._is_running = false
                            return
                        end

                        table.insert(events.ComponentMouseOn, function(context)
                            if command._is_running then
                                console.clear()
                                console.write(consul.pretty(debug.getmetatable(context)))
                            end
                        end)

                        command._is_running = true
                    end,
                    exec = false,
                    returns = true,
                },
                ['/debug'] = {
                    _is_running = false,

                    help = function()
                        return 'Prints debug information about characters,settlements,etc.'
                    end,

                    -- when you mouse over a unit after selecting a character
                    -- the game uses a callback, so each unit you mouse over
                    -- is just a 'LandUnit i' component string - we need to parse it
                    -- and then map to the actual unit index to the character unit list

                    _debug_character_unit_list = {
                        -- the unit list of the selected character
                        unit_list = nil,
                        OnCharacterSelected = function(context)
                            local command = consul.console.commands.exact['/debug']
                            if not command._is_running then
                                return
                            end
                            -- clear the unit list
                            command._debug_character_unit_list.unit_list = nil

                            -- character was selected, grab the unit list
                            local unit_list = context:character():military_force():unit_list()

                            local units = {}
                            for i = 0, unit_list:num_items() - 1 do
                                local unit = unit_list:item_at(i)
                                -- build it here, so nothing breaks later
                                units['LandUnit ' .. tostring(i)] = {
                                    ['unit_key'] = unit:unit_key(),
                                    ['unit_category'] = unit:unit_category(),
                                    ['unit_class'] = unit:unit_class(),
                                }
                            end

                            -- bind the unit list
                            command._debug_character_unit_list.unit_list = units
                        end,
                        ComponentMouseOn = function(context)
                            local command = consul.console.commands.exact['/debug']
                            if not command._is_running then
                                return
                            end

                            -- make sure mouseover was on a unit
                            if string.sub(context.string, 1, 9) == "LandUnit " then
                                local unit = command._debug_character_unit_list.unit_list[context.string]
                                if unit then
                                    consul.console.clear()
                                    consul.console.write(consul.pretty(unit))
                                end
                                return
                            end

                            -- Check if string ends with '_recruitable'
                            if context.string:match('_recruitable$') then
                                consul.log:info(consul.pretty(debug.getmetatable(context)))
                                consul.console.clear()
                                consul.console.write(consul.pretty({
                                    ['unit_key'] = context.string:sub(1, -#'_recruitable' - 1)
                                }))
                                return
                            end

                            -- Check if string ends with '_mercenary'
                            if context.string:match('_mercenary$') then
                                consul.log:info(consul.pretty(debug.getmetatable(context)))
                                consul.console.clear()
                                consul.console.write(consul.pretty({
                                    ['unit_key'] = context.string:sub(1, -#'_mercenary' - 1)
                                }))
                                return
                            end

                        end,
                    },

                    func = function()
                        local command = consul.console.commands.exact['/debug']
                        local pprinter = consul.pprinter
                        local console = consul.console
                        local pretty = function(_tbl)
                            return consul.pretty(_tbl, string.char(1) .. " ", true)
                        end

                        -- if already running, stop
                        if command._is_running then
                            command._is_running = false
                            return
                        end

                        -- wrap common actions
                        local wrap = function(opts, f)
                            return function(context)

                                -- skip if not running
                                if not command._is_running then
                                    return
                                end

                                -- clear the console
                                if opts.clean == true then
                                    console.clear()
                                end

                                -- run the function
                                f(context)
                            end
                        end

                        table.insert(events.SettlementSelected, wrap({ clean = true }, function(context)
                            console.write(pretty(pprinter.garrison_script_interface(context:garrison_residence())))
                        end))

                        table.insert(events.CharacterSelected, wrap({ clean = true }, function(context)
                            console.write(pretty(pprinter.character_script_interface(context:character())))
                        end))

                        table.insert(events.ComponentLClickUp, wrap({ clean = false }, function(context)
                            if string.sub(context.string, 1, 21) == "radar_icon_settlement" then
                                -- clear here - otherwise each click
                                -- on any component will clear the console
                                console.clear()

                                local parts = {}
                                for part in string.gmatch(context.string, "[^:]+") do
                                    table.insert(parts, part)
                                end
                                -- we need 3 parts
                                if #parts ~= 3 then
                                    return
                                end

                                -- grab the region name
                                local region = parts[2]
                                local faction = consul.game.region(region):owning_faction()
                                --
                                console.write(pretty(pprinter.faction_script_interface(faction)))
                            end
                        end))

                        -- _debug_character_unit_list
                        table.insert(events.CharacterSelected, command._debug_character_unit_list.OnCharacterSelected)
                        table.insert(events.ComponentMouseOn, command._debug_character_unit_list.ComponentMouseOn)

                        -- mark as running
                        command._is_running = true
                    end,
                    exec = false,
                    returns = false,
                }
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
                    -- clear output file
                    local f = io.open(console.output_path, "w")
                    if f then
                        f:close()
                    end
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
            local log = consul.new_log('console:OnComponentLClickUp')
            local ui = consul.ui
            local console = consul.console

            if context.string == ui.console_send then
                log:debug("Sending command from console")
                console.execute(console.read())

                -- put the cursor back to the input field
                -- WARNING this will break the history handling
                --ui.find(ui.console_input):SimulateClick()
                return
            end
        end,

    },

    -- scripts to be run from the 'scriptum' view
    scriptum = {

        path = "consul.scriptum",
        path_example = "scriptum.lua",
        example_script = [[
-- Example script for consul
require 'consul'
consul.console.clear()
consul.console.write(
    'Hello from scriptum.lua!\n\n' ..
    'This script runs from the Scriptum list menu when you click on it.\n' ..
    'Its content is located in the game folder in the scriptum.lua file.\n' ..
    'To add your own scripts, list their paths in the consul.scriptum file.\n' ..
    'After adding a new script, reopen the console to have it listed in the menu.\n' ..
    'It runs in the global scope, meaning you can access game functions and variables.\n\n' ..
    'Type /clear to clear the console.\n' ..
    'Type /help for more information.\n\n' ..
    'You can also run Lua commands here.\nTry typing: return 2+2\n'
)
-- Uncomment these lines to see what happens
--scripting = require 'lua_scripts.EpisodicScripting'
--scripting.AddEventCallBack('ComponentLClickUp', function(context)
--	consul.console.write('You clicked on: ' .. context.string)
--end)

-- Uncomment that line to see what happens
-- consul.console.write(consul.pretty({_G}))
]],
        -- because we don't know how to create elements
        -- dynamically, we have to set a maximum number of entries
        -- they are pre-created in the ui file
        max_entries = 10,

        -- this is a map of ui listview entries to the scripts
        -- example scriptum_text1 -> consul_example.lua
        ui_scripts_map = {},

        -- read paths to files from inside consul.scriptum file
        -- each lines is a path to a file that can be executed from the listview
        -- if the consul.scriptum file is not found, it will be created
        -- and then if consul_example.lua does not exist, it will be created
        -- and added to the list
        setup = function()
            local log = consul.new_log('scriptum:setup')
            log:debug("Setting up scriptum")

            local ui = consul.ui
            local path = consul.scriptum.path
            local max = consul.scriptum.max_entries

            local f = io.open(path, "r")
            if f then
                f:close()
            end

            if not f then

                -- create consul.scriptum
                f = io.open(path, "w")
                if f then
                    f:write(consul.scriptum.path_example .. "\n")
                    f:close()
                end

                -- create consul_example.lua
                f = io.open(consul.scriptum.path_example, "r")
                if f then
                    log:debug("Example script exists: " .. consul.scriptum.path_example)
                    f:close()
                else
                    log:debug("Creating example script: " .. consul.scriptum.path_example)
                    f = io.open(consul.scriptum.path_example, "w")
                    if f then
                        f:write(consul.scriptum.example_script)
                        f:close()
                    end
                end
            end

            -- at start just clean all the entries
            -- and set all the elements to invisible
            -- this can be reloaded while the game is running
            -- p.s this is required as setting any element in list
            -- as invisible by default in the ui file will break display of it
            -- just make sure they are always visible by default and turn them
            -- off ... this probably applies to all element based ui components
            for i = 1, max do
                local ui_root_name = ui.scriptum_entry .. tostring(i)
                local ui_state_name = ui.scriptum_entry_text .. tostring(i)
                local ui_root = ui.find(ui_root_name)
                local ui_state = ui.find(ui_state_name)

                if ui_root and ui_state then
                    ui_root:SetVisible(false)
                    ui_state:SetVisible(false)
                else
                    -- this is bad
                    log:error("Could not find scriptum entry: " .. ui_root_name)
                end
            end

            log:debug("Loading scriptum scripts from: " .. path)
            -- now we can open the file and read its lines
            -- each line is a path to a script that can be executed
            -- it will be added to the listview by toggling visibility flag
            -- we can support up to 10 scripts for now, and each script
            -- has to find ui element with index +1 after the scriptum_entry

            -- first read all lines to local var so we can close the file
            local lines = {}
            f = io.open(path, "r")
            if not f then
                log:error("Could not open scriptum file, this should never happen " .. path)
                return
            end
            for line in f:lines() do
                table.insert(lines, line)
            end
            f:close()

            log:debug("Loaded scriptum scripts: " .. consul.inspect(lines))

            -- now we can iterate over the lines
            local i = 1
            for _, line in pairs(lines) do
                log:debug("Adding script to the listview: " .. line)

                -- if we are over the limit notify and break
                if i > max then
                    log:warn("Too many scripts in the scriptum file, only first " .. max .. " will be loaded")
                    break
                end

                -- make sure the line is not empty
                if line ~= "" then
                    -- if the file exists, add it to the list
                    local f = io.open(line, "r")
                    if f then
                        f:close()

                        -- now find the elements
                        local ui_root_name = ui.scriptum_entry .. tostring(i)
                        local ui_state_name = ui.scriptum_entry_text .. tostring(i)
                        local ui_root = ui.find(ui_root_name)
                        local ui_state = ui.find(ui_state_name)

                        -- and switch the flags
                        if ui_root then
                            log:debug("Setting scriptum entries: " .. ui_root_name .. " " .. ui_state_name)
                            ui_root:SetVisible(true)
                            ui_state:SetStateText(line)
                            ui_state:SetVisible(true)
                            consul.scriptum.ui_scripts_map[ui_root_name] = line

                            -- only then increment the index
                            i = i + 1
                        end
                    end
                end
            end
        end,

        -- let's handle the event when we click on the scriptum entry
        OnComponentLClickUp = function(context)
            local log = consul.new_log('scriptum:OnComponentLClickUp')
            local ui = consul.ui

            if string.sub(context.string, 1, 14) == ui.scriptum_entry then
                log:debug("Clicked on scriptum entry: " .. context.string)

                local script = consul.scriptum.ui_scripts_map[context.string]

                if script then
                    log:debug("Executing script: " .. script)

                    -- WARNING loadfile breaks the game again...
                    local success, err = pcall(dofile, script)
                    if not success then
                        log:error("Error executing script: " .. script .. " " .. err)
                        -- write to console
                        consul.console.write("error: " .. script .. " " .. err)
                    else
                        log:debug("Executed script: " .. script)
                    end

                end
            end

        end,
    },

    -- consul scripts window
    consul_scripts = {

        -- scripts register their event handlers here
        -- just add empty ones here so other scripts don't
        -- have to check if they exist before adding
        event_handlers = {
            ["CharacterSelected"] = {},
            ["SettlementSelected"] = {},
            ["ComponentLClickUp"] = {},
        },

        -- dispatches an event
        event_dispatcher = function(event_name)
            local log = consul.new_log('consul_scripts:event_dispatcher')

            return function(context)
                local eh = consul.consul_scripts.event_handlers[event_name]
                for _, v in pairs(eh) do
                    if v then
                        log:debug("Dispatching event: " .. event_name)
                        v(context)
                    end
                end
            end
        end,

        -- setup only once
        _is_ready = false,

        -- setup the script, should be called once
        setup = function()
            local log, scripts = consul.new_log('consul_scripts:setup'), consul.consul_scripts
            log:debug("Setting up scripts")

            -- skip if already set up
            if scripts._is_ready then
                log:debug("Scripts are already set up")
                return
            end

            -- call all scripts setup
            scripts.exterminare.setup()
            scripts.transfer_settlement.setup()
            scripts.force_rebellion.setup()
            scripts.force_make_peace.setup()
            scripts.force_make_war.setup()

            log:debug("Finished setting up scripts")

            -- setup the event handlers
            local ok, scripting = pcall(require, 'lua_scripts.EpisodicScripting')
            if not ok then
                log:warn("Could not load EpisodicScripting, it's ok if we are in frontend")
                return
            end

            log:debug("Setting up event handlers")
            for k, _ in pairs(scripts.event_handlers) do
                log:debug("Setting up event handler: " .. k)
                scripting.AddEventCallBack(k, scripts.event_dispatcher(k))
            end

            -- mark as ready
            log:debug("Setup finished")
            scripts._is_ready = true
        end,

        _on_click = function(script, component)
            if component:CurrentState() == 'active' then
                script.stop()
                component:SetState('default')
            else
                script.start()
                component:SetState('active')
            end
        end,

        OnComponentLClickUp = function(context)
            local log = consul.new_log('consul_scripts:OnComponentLClickUp')
            local scripts = consul.consul_scripts
            local ui = consul.ui

            if context.string == ui.consul_exterminare_entry then
                log:debug("Clicked on consul_exterminare")
                scripts._on_click(scripts.exterminare, ui.find(ui.consul_exterminare_script))
                return
            end

            if context.string == ui.consul_transfersettlement_entry then
                log:debug("Clicked on consul_transfersettlement")
                scripts._on_click(scripts.transfer_settlement, ui.find(ui.consul_transfersettlement_script))
            end

            if context.string == ui.consul_adrebellos_entry then
                log:debug("Clicked on consul_forcerebellion")
                scripts._on_click(scripts.force_rebellion, ui.find(ui.consul_adrebellos_script))
            end

            if context.string == ui.consul_force_make_peace_entry then
                log:debug("Clicked on consul_force_make_peace")
                scripts._on_click(scripts.force_make_peace, ui.find(ui.consul_force_make_peace_script))
            end

            if context.string == ui.consul_force_make_war_entry then
                log:debug("Clicked on consul_force_make_war")
                scripts._on_click(scripts.force_make_war, ui.find(ui.consul_force_make_war_script))
            end
        end,

        exterminare = {

            get_logger = function()
                return consul.new_log('consul_scripts:exterminare')
            end,

            setup = function()
                local scripts = consul.consul_scripts
                local log = scripts.exterminare.get_logger()
                log:debug("Setting up...")

                scripts.event_handlers['CharacterSelected']['exterminare'] = nil
            end,

            start = function()
                local scripts = consul.consul_scripts
                local log = scripts.exterminare.get_logger()
                log:debug("Starting...")

                -- register event handler
                -- script and concepts modded by: Jake Armitage and ivanpera from TWC
                scripts.event_handlers['CharacterSelected']['exterminare'] = function(context)
                    log:debug("CharacterSelected")

                    -- get the faction and forename
                    local faction = context:character():faction():name()
                    local forename = context:character():get_forename()

                    -- build the target
                    local target = "faction:" .. tostring(faction) .. "," ..
                            "forename:" .. string.gsub(forename, "names_name_", "")

                    -- destroy
                    log:debug("Target: " .. target)

                    -- TODO we can switch flag to only kill character (now it kills the whole army)
                    consul._game():kill_character(target, true, true)
                end

                log:debug("Started.")
            end,

            stop = function()
                local scripts = consul.consul_scripts
                local log = scripts.exterminare.get_logger()
                log:debug("Stopping...")

                -- unregister event handler
                scripts.event_handlers['CharacterSelected']['exterminare'] = nil
                log:debug("Stopped.")
            end,
        },

        transfer_settlement = {

            get_logger = function()
                return consul.new_log('consul_scripts:transfer_settlement')
            end,

            setup = function()
                local scripts = consul.consul_scripts
                local log = scripts.transfer_settlement.get_logger()
                log:debug("Setting up...")

                scripts.event_handlers['SettlementSelected']['transfersettlement'] = nil
                scripts.event_handlers['ComponentLClickUp']['transfersettlement'] = nil
                scripts.event_handlers['CharacterSelected']['transfersettlement'] = nil
            end,

            _faction = nil,
            _region = nil,

            _transfer = function()
                local script = consul.consul_scripts.transfer_settlement
                local log = script.get_logger()

                log:debug("Transferring: " .. script._region .. " to " .. script._faction)
                consul._game():transfer_region_to_faction(script._region, script._faction)

                script._faction = nil
                script._region = nil
            end,

            start = function()
                local log = consul.consul_scripts.transfer_settlement.get_logger()
                local script = consul.consul_scripts.transfer_settlement
                local scripts = consul.consul_scripts
                log:debug("Starting...")

                scripts.event_handlers['SettlementSelected']['transfersettlement'] = function(context)
                    log:debug("SettlementSelected")

                    if not script._region then
                        script._region = context:garrison_residence():region():name()
                    else
                        script._faction = context:garrison_residence():faction():name()
                    end
                    if script._region and script._faction then
                        script._transfer()
                    end
                end

                scripts.event_handlers['ComponentLClickUp']['transfersettlement'] = function(context)
                    log:debug("ComponentLClickUp")

                    -- if we clicked radar_icon in the strategic view
                    if string.sub(context.string, 1, 21) == "radar_icon_settlement" then
                        log:debug("Clicked on radar_icon_settlement")

                        -- split string by :
                        local parts = {}
                        for part in string.gmatch(context.string, "[^:]+") do
                            table.insert(parts, part)
                        end

                        -- we need 3 parts
                        if #parts ~= 3 then
                            return
                        end

                        -- grab the region name
                        local region = parts[2]

                        if not script._region then
                            -- if region is nil, we can just set it
                            script._region = region
                        else
                            -- otherwise query for faction
                            script._faction = consul.game.region(region):owning_faction():name()
                        end

                        if script._region and script._faction then
                            script._transfer()
                        end
                    end
                end
            end,

            stop = function()
                local log = consul.consul_scripts.transfer_settlement.get_logger()
                local script = consul.consul_scripts.transfer_settlement
                local scripts = consul.consul_scripts
                log:debug("Stopping...")

                scripts.event_handlers['SettlementSelected']['transfersettlement'] = nil
                scripts.event_handlers['ComponentLClickUp']['transfersettlement'] = nil
                scripts.event_handlers['CharacterSelected']['transfersettlement'] = nil
                script._faction = nil
                script._region = nil

                log:debug("Stopped.")
            end
        },

        force_rebellion = {

            get_logger = function()
                return consul.new_log('consul_scripts:force_rebellion')
            end,

            setup = function()
                local scripts = consul.consul_scripts
                local log = scripts.force_rebellion.get_logger()
                log:debug("Setting up...")
                scripts.event_handlers['SettlementSelected']['forcerebellion'] = nil
            end,

            start = function()
                local log = consul.consul_scripts.force_rebellion.get_logger()
                log:debug("Starting...")

                local scripts = consul.consul_scripts
                scripts.event_handlers['SettlementSelected']['forcerebellion'] = function(context)
                    log:debug("SettlementSelected")
                    local region = context:garrison_residence():region():name()
                    consul.game.force_rebellion(region, 4, "", 0, 0, true)
                    log:debug("Forced rebellion in: " .. region)
                end
            end,

            stop = function()
                local scripts = consul.consul_scripts
                local log = scripts.force_rebellion.get_logger()
                log:debug("Stopping...")
                scripts.event_handlers['SettlementSelected']['forcerebellion'] = nil
            end,
        },

        force_make_peace = {

            _faction1 = nil,
            _faction2 = nil,

            get_logger = function()
                return consul.new_log('consul_scripts:force_make_peace')
            end,

            setup = function()
                local scripts = consul.consul_scripts
                local log = scripts.force_make_peace.get_logger()
                log:debug("Setting up...")
                scripts.event_handlers['SettlementSelected']['forcemakepeace'] = nil
                scripts.event_handlers['CharacterSelected']['forcemakepeace'] = nil
                scripts.force_make_peace._faction1 = nil
                scripts.force_make_peace._faction2 = nil
            end,

            start = function()
                local log = consul.consul_scripts.force_make_peace.get_logger()
                log:debug("Starting...")

                local scripts = consul.consul_scripts
                local script = scripts.force_make_peace

                local make_peace = function()
                    if script._faction1 and script._faction2 then
                        log:debug("Forcing peace between: " .. script._faction1 .. " and " .. script._faction2)
                        consul._game():force_make_peace(script._faction1, script._faction2)
                        script._faction1 = nil
                        script._faction2 = nil
                        log:debug("Forced peace.")
                    end
                end

                scripts.event_handlers['SettlementSelected']['forcemakepeace'] = function(context)
                    log:debug("SettlementSelected")

                    local faction = context:garrison_residence():faction():name()
                    if not script._faction1 then
                        script._faction1 = faction
                    else
                        script._faction2 = faction
                    end

                    make_peace()
                end

                scripts.event_handlers['CharacterSelected']['forcemakepeace'] = function(context)
                    log:debug("CharacterSelected")

                    local faction = context:character():faction():name()
                    if not script._faction1 then
                        script._faction1 = faction
                    else
                        script._faction2 = faction
                    end

                    make_peace()
                end

            end,

            stop = function()
                return consul.consul_scripts.force_make_peace.setup()
            end,

        },

        force_make_war = {

            _faction1 = nil,
            _faction2 = nil,

            get_logger = function()
                return consul.new_log('consul_scripts:force_make_war')
            end,

            setup = function()
                local scripts = consul.consul_scripts
                local log = scripts.force_make_war.get_logger()
                log:debug("Setting up...")
                scripts.event_handlers['SettlementSelected']['forcemakewar'] = nil
                scripts.event_handlers['CharacterSelected']['forcemakewar'] = nil
                scripts.force_make_war._faction1 = nil
                scripts.force_make_war._faction2 = nil
            end,

            start = function()
                local log = consul.consul_scripts.force_make_war.get_logger()
                log:debug("Starting...")

                local scripts = consul.consul_scripts
                local script = scripts.force_make_war

                local make_war = function()
                    if script._faction1 and script._faction2 then
                        log:debug("Forcing war between: " .. script._faction1 .. " and " .. script._faction2)

                        consul._game():force_declare_war(script._faction1, script._faction2)
                        script._faction1 = nil
                        script._faction2 = nil
                        log:debug("Forced war.")
                    end
                end

                scripts.event_handlers['SettlementSelected']['forcemakewar'] = function(context)
                    log:debug("SettlementSelected")

                    local faction = context:garrison_residence():faction():name()
                    if not script._faction1 then
                        script._faction1 = faction
                    else
                        script._faction2 = faction
                    end

                    make_war()
                end

                scripts.event_handlers['CharacterSelected']['forcemakewar'] = function(context)
                    log:debug("CharacterSelected")

                    local faction = context:character():faction():name()
                    if not script._faction1 then
                        script._faction1 = faction
                    else
                        script._faction2 = faction
                    end

                    make_war()
                end
            end,

            stop = function()
                return consul.consul_scripts.force_make_war.setup()
            end,
        }

    },

    -- consul._game is shorten
    _game = function()
        -- !!
        -- I do not try to import the `EpisodicScripting` module
        -- from my observation this can cause dragons to appear
        -- we can safely assume that the game will do that for us
        -- overall trying to import any module is not a good idea
        -- do not mess with other scripts / people / mods

        -- if we have the game interface, return it
        -- works fine in grand campaign and cig
        if scripting and scripting.game_interface then
            return scripting.game_interface
        end

        -- this is still ok
        consul.log:debug("Could not find scripting.game_interface, trying to locate...")

        -- this can happen in campaigns other than grand campaign and cig
        -- try locating scripting in preloaded modules
        local scripting = package.loaded['lua_scripts.EpisodicScripting']
        if scripting and scripting.game_interface then
            return scripting.game_interface
        end

        -- this can also happen in some campaigns
        -- the lowercase version can be problematic in other cases...
        -- it may not contain the game_interface at all :D
        local scripting = package.loaded['lua_scripts.episodicscripting']
        if scripting and scripting.game_interface then
            return scripting.game_interface
        end

        consul.log:error("Could not find scripting.game_interface, consul will not work properly")
        return nil
    end,

    -- neat shortcuts for game functions
    -- they should be used in the scripts
    -- they should be a fixed api that never breaks

    game = {

        model = function()
            return consul._game():model()
        end,

        world = function()
            return consul._game():model():world()
        end,

        region = function(key)
            return consul._game():model():world():region_manager():region_by_key(key)
        end,

        region_list = function()
            local region_list = consul._game():model():world():region_manager():region_list()

            local regions = {}
            for i = 0, region_list:num_items() - 1 do
                table.insert(regions, region_list:item_at(i):name())
            end

            return regions
        end,

        faction = function(key)
            return consul._game():model():world():faction_by_key(key)
        end,

        faction_list = function()
            local faction_list = consul._game():model():world():faction_list()

            local factions = {}
            for i = 0, faction_list:num_items() - 1 do
                table.insert(factions, faction_list:item_at(i):name())
            end

            return factions
        end,

        -- transfers a region to a faction
        force_rebellion = function(region, units, unit_list, x, y, supress_message)
            if not region then
                return "region is nil"
            end
            if not units then
                return "units is nil"
            end
            if not unit_list then
                return "unit_list is nil"
            end
            if not x then
                return "x is nil"
            end
            if not y then
                return "y is nil"
            end
            if supress_message == nil then
                return "supress_message is nil"
            end
            return consul._game():force_rebellion_in_region(region, units, unit_list, x, y, supress_message)
        end
    },

    pprinter = {
        _is_null = function(_any)
            return string.sub(tostring(_any), 1, 21) == "NULL_SCRIPT_INTERFACE"
        end,

        garrison_script_interface = function(_garrison)
            consul.log:debug("garrison_script_interface")
            if consul.pprinter._is_null(_garrison) then
                return {}
            end

            -- return faction only if army is null
            -- otherwise we will loop too much
            local faction = {}
            if consul.pprinter._is_null(_garrison:army()) then
                faction = consul.pprinter.faction_script_interface(_garrison:faction())
            end

            return {
                ['army'] = _garrison:army(),
                ['buildings'] = _garrison:buildings(),
                ['faction'] = faction,
                ['has_army'] = _garrison:has_army(),
                ['has_navy'] = _garrison:has_navy(),
                ['is_settlement'] = _garrison:is_settlement(),
                ['is_slot'] = _garrison:is_slot(),
                ['is_under_siege'] = _garrison:is_under_siege(),
                ['model'] = _garrison:model(),
                ['navy'] = _garrison:navy(),
                ['region'] = _garrison:region(),
                ['settlement_interface'] = _garrison:settlement_interface(),
                ['slot_interface'] = _garrison:slot_interface(),
                ['unit_count'] = _garrison:unit_count(),
            }
        end,

        unit_script_interface = function(_unit, _index)
            consul.log:debug("unit_script_interface")
            if consul.pprinter._is_null(_unit) then
                return {}
            end
            return {
                --["faction"] = "function: 571787B0",
                --["force_commander"] = "function: 571786B0",
                --["has_force_commander"] = "function: 571785B0",
                --["has_unit_commander"] = "function: 57178550",
                --["is_land_unit"] = "function: 57178590",
                --["is_naval_unit"] = "function: 571785D0",
                --["military_force"] = "function: 57178690",
                --["model"] = "function: 57178670",
                --["new"] = "function: 57145580",
                --["unit_commander"] = "function: 571786F0",
                ['unit_key'] = _unit:unit_key(),
                ['unit_category'] = _unit:unit_category(),
                ['unit_class'] = _unit:unit_class(),
                --['percentage_proportion_of_full_strength'] = _unit:percentage_proportion_of_full_strength(),
            }
        end,

        unit_list_script_interface = function(_unitlist)
            consul.log:debug("unit_list_script_interface")
            if consul.pprinter._is_null(_unitlist) then
                return {}
            end

            local units = {}
            for i = 0, _unitlist:num_items() - 1 do
                table.insert(units, consul.pprinter.unit_script_interface(_unitlist:item_at(i)))
            end
            return units
        end,

        military_force_script_interface = function(_force)
            consul.log:debug("military_force_script_interface")
            if consul.pprinter._is_null(_force) then
                return {}
            end
            return {
                --["character_list"] = "function: 57178390",
                --["contains_mercenaries"] = "function: 571783B0",
                --["faction"] = "function: 571783D0",
                --["garrison_residence"] = "function: 57178410",
                --["general_character"] = "function: 57178330",
                --["has_garrison_residence"] = "function: 57178370",
                --["has_general"] = "function: 571782B0",
                --["is_army"] = "function: 571782F0",
                --["is_navy"] = "function: 57178310",
                --["model"] = "function: 57178350",
                --["upkeep"] = "function: 57178450",
                ['unit_list'] = consul.pprinter.unit_list_script_interface(_force:unit_list())
            }
        end,

        character_script_interface = function(_char)
            consul.log:debug("character_script_interface")
            if consul.pprinter._is_null(_char) then
                return {}
            end
            return {
                ['action_points_per_turn'] = _char:action_points_per_turn(),
                ['action_points_remaining_percent'] = _char:action_points_remaining_percent(),
                ['age'] = _char:age(),
                ['battles_fought'] = _char:battles_fought(),
                ['battles_won'] = _char:battles_won(),
                ['body_guard_casulties'] = 'will crash game in campaign',
                ['character_type'] = _char:character_type(),
                ['cqi'] = _char:cqi(),
                ['defensive_ambush_battles_fought'] = _char:defensive_ambush_battles_fought(),
                ['defensive_ambush_battles_won'] = _char:defensive_ambush_battles_won(),
                ['defensive_battles_fought'] = _char:defensive_battles_fought(),
                ['defensive_battles_won'] = _char:defensive_battles_won(),
                ['defensive_naval_battles_fought'] = _char:defensive_naval_battles_fought(),
                ['defensive_naval_battles_won'] = _char:defensive_naval_battles_won(),
                ['defensive_sieges_fought'] = _char:defensive_sieges_fought(),
                ['defensive_sieges_won'] = _char:defensive_sieges_won(),
                ['display_position_x'] = _char:display_position_x(),
                ['display_position_y'] = _char:display_position_y(),
                ['faction'] = consul.pprinter.faction_script_interface(_char:faction()),
                ['forename'] = _char:forename(),
                ['fought_in_battle'] = _char:fought_in_battle(),
                ['garrison_residence'] = consul.pprinter.garrison_script_interface(_char:garrison_residence()),
                ['get_forename'] = _char:get_forename(),
                ['get_political_party_id'] = _char:get_political_party_id(),
                ['get_surname'] = _char:get_surname(),
                ['has_ancillary'] = _char:has_ancillary(),
                ['has_garrison_residence'] = _char:has_garrison_residence(),
                ['has_military_force'] = _char:has_military_force(),
                ['has_recruited_mercenaries'] = _char:has_recruited_mercenaries(),
                ['has_region'] = _char:has_region(),
                ['has_skill'] = _char:has_skill(),
                ['has_spouse'] = _char:has_spouse(),
                ['has_trait'] = _char:has_trait(),
                ['in_port'] = _char:in_port(),
                ['in_settlement'] = _char:in_settlement(),
                ['is_ambushing'] = _char:is_ambushing(),
                ['is_besieging'] = _char:is_besieging(),
                ['is_blockading'] = _char:is_blockading(),
                ['is_carrying_troops'] = 'will crash agent in campaign',
                ['is_deployed'] = _char:is_deployed(),
                ['is_embedded_in_military_force'] = _char:is_embedded_in_military_force(),
                ['is_faction_leader'] = _char:is_faction_leader(),
                ['is_hidden'] = _char:is_hidden(),
                ['is_male'] = _char:is_male(),
                ['is_polititian'] = _char:is_polititian(),
                ['logical_position_x'] = _char:logical_position_x(),
                ['logical_position_y'] = _char:logical_position_y(),
                ['military_force'] = consul.pprinter.military_force_script_interface(_char:military_force()),
                ['model'] = _char:model(),
                ['number_of_traits'] = _char:number_of_traits(),
                ['offensive_ambush_battles_fought'] = _char:offensive_ambush_battles_fought(),
                ['offensive_ambush_battles_won'] = _char:offensive_ambush_battles_won(),
                ['offensive_battles_fought'] = _char:offensive_battles_fought(),
                ['offensive_battles_won'] = _char:offensive_battles_won(),
                ['offensive_naval_battles_fought'] = _char:offensive_naval_battles_fought(),
                ['offensive_naval_battles_won'] = _char:offensive_naval_battles_won(),
                ['offensive_sieges_fought'] = _char:offensive_sieges_fought(),
                ['offensive_sieges_won'] = _char:offensive_sieges_won(),
                ['percentage_of_own_alliance_killed'] = _char:percentage_of_own_alliance_killed(),
                ['performed_action_this_turn'] = _char:performed_action_this_turn(),
                ['rank'] = _char:rank(),
                ['region'] = _char:region(),
                ['routed_in_battle'] = 'will crash game in campaign',
                ['spouse'] = _char:spouse(),
                ['surname'] = _char:surname(),
                ['trait_level'] = _char:trait_level(),
                ['trait_points'] = _char:trait_points(),
                ['turns_at_sea'] = _char:turns_at_sea(),
                ['turns_in_enemy_regions'] = _char:turns_in_enemy_regions(),
                ['turns_in_own_regions'] = _char:turns_in_own_regions(),
                ['turns_without_battle_in_home_lands'] = _char:turns_without_battle_in_home_lands(),
                ['won_battle'] = _char:won_battle(),
            }
        end,

        faction_script_interface = function(_fac)
            consul.log:debug("faction_script_interface")
            if consul.pprinter._is_null(_fac) then
                return {}
            end
            return {
                ["allied_with"] = _fac:allied_with(),
                ["ancillary_exists"] = _fac:ancillary_exists(),
                ["at_war"] = _fac:at_war(),
                ["character_list"] = _fac:character_list(),
                ["culture"] = _fac:culture(),
                ["difficulty_level"] = _fac:difficulty_level(),
                ["ended_war_this_turn"] = _fac:ended_war_this_turn(),
                ["faction_attitudes"] = _fac:faction_attitudes(),
                ["faction_leader"] = _fac:faction_leader(),
                ["government_type"] = _fac:government_type(),
                ["has_faction_leader"] = _fac:has_faction_leader(),
                ["has_food_shortage"] = _fac:has_food_shortage(),
                ["has_home_region"] = _fac:has_home_region(),
                ["has_researched_all_technologies"] = _fac:has_researched_all_technologies(),
                ["has_technology"] = _fac:has_technology(),
                ["home_region"] = _fac:home_region(),
                ["imperium_level"] = _fac:imperium_level(),
                ["is_human"] = _fac:is_human(),
                ["losing_money"] = _fac:losing_money(),
                ["military_force_list"] = _fac:military_force_list(),
                ["model"] = _fac:model(),
                ["name"] = _fac:name(),
                ["new"] = _fac:new(),
                ["num_allies"] = _fac:num_allies(),
                ["num_enemy_trespassing_armies"] = _fac:num_enemy_trespassing_armies(),
                ["num_factions_in_war_with"] = _fac:num_factions_in_war_with(),
                ["num_generals"] = _fac:num_generals(),
                ["num_trade_agreements"] = _fac:num_trade_agreements(),
                ["politics"] = _fac:politics(),
                ["politics_party_add_loyalty_modifier"] = _fac:politics_party_add_loyalty_modifier(),
                ["region_list"] = _fac:region_list(),
                ["research_queue_idle"] = _fac:research_queue_idle(),
                ["sea_trade_route_raided"] = _fac:sea_trade_route_raided(),
                ["started_war_this_turn"] = _fac:started_war_this_turn(),
                ["state_religion"] = _fac:state_religion(),
                ["subculture"] = _fac:subculture(),
                ["tax_category"] = _fac:tax_category(),
                ["tax_level"] = _fac:tax_level(),
                ["total_food"] = _fac:total_food(),
                ["trade_resource_exists"] = _fac:trade_resource_exists(),
                ["trade_route_limit_reached"] = _fac:trade_route_limit_reached(),
                ["trade_ship_not_in_trade_node"] = _fac:trade_ship_not_in_trade_node(),
                ["trade_value"] = _fac:trade_value(),
                ["trade_value_percent"] = _fac:trade_value_percent(),
                ["treasury"] = _fac:treasury(),
                ["treasury_percent"] = _fac:treasury_percent(),
                ["treaty_details"] = _fac:treaty_details(),
                ["unused_international_trade_route"] = _fac:unused_international_trade_route(),
                ["upkeep_expenditure_percent"] = _fac:upkeep_expenditure_percent(),
            }
        end,
    }

    -- scripts to be run from 'consul' listview
    --scripts = {
    --
    --    -- custom event handlers
    --    -- in order to dynamically delete events
    --    -- we need to keep track of them and delete when needed
    --    -- so we attach to the game events only once and then
    --    -- we call anything that is registered in the event_handlers
    --    event_handlers = {
    --        ['SettlementSelected'] = {
    --            ['transfer_settlement'] = nil,
    --        },
    --        ['CharacterSelected'] = {
    --            ['transfer_settlement'] = nil,
    --        },
    --        ['ComponentLClickUp'] = {
    --            ['transfer_settlement'] = nil,
    --        },
    --    },
    --
    --    -- dispatches an event
    --    event_dispatcher = function(event_name)
    --        log = consul.new_log('scripts:event_dispatcher')
    --        return function(context)
    --            local eh = consul.event_handlers[event_name]
    --            for _, v in pairs(eh) do
    --                if v then
    --                    log:debug("Dispatching event: " .. event_name)
    --                    v(context)
    --                end
    --            end
    --        end
    --    end,
    --
    --    _is_ready = false,
    --
    --    -- setup the script, should be called once
    --    setup = function()
    --        log = consul.new_log('scripts:setup')
    --        log:debug("Setting up scripts")
    --
    --        if consul.scripts._is_ready then
    --            return
    --        end
    --
    --        -- setup the event handlers
    --        scripting = require 'lua_scripts.EpisodicScripting'
    --        for k, _ in pairs(consul.event_handlers) do
    --            log:debug("Setting up event handler: " .. k)
    --            scripting.AddEventCallBack(k, consul.event_dispatcher(k))
    --        end
    --
    --        consul.scripts._is_ready = true
    --    end,
    --
    --    -- transfer a region to a faction
    --    transfer_settlement = {
    --        _region = nil,
    --        _faction = nil,
    --
    --        transfer = function()
    --            local scripting = require 'lua_scripts.EpisodicScripting'
    --        end,
    --
    --        OnComponentLClickUp = function(context)
    --            local log = consul.new_log('scripts:transfer_settlement:OnComponentLClickUp')
    --
    --            -- if we clicked radar_icon in the strategic view
    --            if string.sub(context.string, 1, 21) == "radar_icon_settlement" then
    --
    --                -- split string by :
    --                local parts = {}
    --                for part in string.gmatch(context.string, "[^:]+") do
    --                    table.insert(parts, part)
    --                end
    --
    --                -- we need 3 parts
    --                if #parts ~= 3 then
    --                    return
    --                end
    --
    --                -- grab the region name
    --                local region = parts[2]
    --
    --                -- if region is nil, we can just set it
    --                if not consul.scripts.transfer_settlement._region then
    --                    consul.scripts.transfer_settlement._region = region
    --                    consul.console.write("Selected region: " .. region)
    --                    return
    --                end
    --
    --                -- otherwise we have to query game for the faction
    --
    --            end
    --
    --        end,
    --
    --        -- scripting.AddEventCallBack('SettlementSelected', function(c)consul.write(c.garrison_residence:settlement_interface():region():name())end)
    --
    --        OnSettlementSelected = function(context)
    --            consul.log:debug(consul.pretty(debug.getmetatable(context)))
    --            consul.write(c.garrison_residence:settlement_interface():region():name())
    --        end,
    --
    --        OnCharacterSelected = function(context)
    --            consul.log:debug(consul.pretty(debug.getmetatable(context)))
    --        end,
    --
    --        OnStart = function()
    --            -- just make sure we are stopped :)
    --            consul.scripts.transfer_settlement.OnStop()
    --
    --            consul.log:debug("Starting transfer settlement script")
    --            consul.event_handlers['SettlementSelected']['transfer_settlement'] = consul.scripts.transfer_settlement.OnSettlementSelected
    --            consul.event_handlers['CharacterSelected']['transfer_settlement'] = consul.scripts.transfer_settlement.OnCharacterSelected
    --            consul.event_handlers['ComponentLClickUp']['transfer_settlement'] = consul.scripts.transfer_settlement.OnComponentLClickUp
    --        end,
    --
    --        OnStop = function()
    --            consul.log:debug("Stopping transfer settlement script")
    --            consul.event_handlers['SettlementSelected']['transfer_settlement'] = nil
    --            consul.event_handlers['CharacterSelected']['transfer_settlement'] = nil
    --            consul.event_handlers['ComponentLClickUp']['transfer_settlement'] = nil
    --
    --            local eh_settlement = function(context)
    --
    --                local console = consul.console
    --                local script = consul.scripts.transfer_settlement
    --
    --                -- first we pick the settlement to transfer
    --                if not script._region then
    --                    script._region = context.settlement:region():name()
    --                    console.write("Selected settlement to transfer: " .. script._region)
    --                    return
    --                end
    --
    --                -- then we pick the faction to transfer to
    --                if not script._faction then
    --                    tf = context.settlement():faction():name()
    --                    consul.console.write("Transferring settlement: " .. tr .. " to faction: " .. tf .. "?")
    --                end
    --
    --                -- if both are set, transfer the region
    --                if tr and tf then
    --                    scripting.game_interface:transfer_region_to_faction(tr, tf)
    --                    consul.console.write("Transferred settlement: " .. tr .. " to faction: " .. tf)
    --                end
    --
    --                consul.scripts.transfer_settlement.stop()
    --
    --            end,
    --
    --            consul.console.write("Select a settlement to transfer")
    --        end
    --    }
    --    --
    --}
}
