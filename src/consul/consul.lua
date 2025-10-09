consul = {

    VERSION = "0.5.0",
    URL = "http://github.com/bukowa/ConsulScriptum",
    AUTHOR = "Mateusz Kurowski",
    CONTACT = "gitbukowa@gmail.com",

    -- game requires a char before /t
    -- it also makes /t very long, so just use spaces
    tab = string.char(1) .. '   ',

    -- a flag indicating if the script is running in battle
    -- this is used for various battle-script related handling
    is_in_battle_script = false,
    bm = nil,

    -- attribute holding stuff selected by debug
    debug = {
        -- character selected in debug mode
        character = nil,
        -- return a cqi for lookups
        character_cqi = function()
            return 'character_cqi:' .. consul.debug.character:cqi()
        end,
        -- hide the character
        character_hide = function(queue)
            queue = (queue == nil) and true or queue
            return consul._game():hide_character(consul.debug.character_cqi(), queue)
        end,
        --character_unhide = function(queue, x, y, cqi)
        --    queue = (queue == nil) and true or queue
        --    x   = x   or consul.debug.character:logical_position_x()
        --    y   = y   or consul.debug.character:logical_position_y()
        --    cqi = cqi or consul.debug.character_cqi()
        --    consul.log:info("")
        --    return consul._game():unhide_character(cqi, x, y, queue)
        --end,
        settlement = nil,
        faction = nil,
    };

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
        table.insert(events.UICreated, consul.battle.setup)
        table.insert(events.ComponentLClickUp, consul.consul_scripts.OnComponentLClickUp)
        table.insert(events.UICreated, consul.scriptum.setup)
        table.insert(events.ComponentLClickUp, consul.scriptum.OnComponentLClickUp)
    end,

    -- logging
    log = require('consul_logging').Logger.new();

    -- shortcut to create a new logger
    new_log = function(name)
        return require('consul_logging').Logger.new(name, consul.log.log_level);
    end,

    -- contrib
    serpent = require 'serpent.serpent',
    inspect = require 'inspect.inspect',
    pretty = require 'penlight.pretty'.write,

    pretty_inspect = function(_obj)
        return consul.inspect(_obj, { newline = '\n' })
    end,

    -- table with base game events and decompiled game events
    -- decompiled events are these only found in game source but not in game pack files
    _events = require('consul_game_events'),

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

    utils = {
        -- merges multiple tables and removes duplicates
        merge_and_deduplicate = function(...)
            local seen = {}
            local unique_items = {}
            local arg_tables = { ... }

            for _, input_table in ipairs(arg_tables) do
                -- Ensure the input is actually a table
                if type(input_table) == "table" then
                    for _, item in ipairs(input_table) do
                        -- We only handle strings here, as per your original request's data type
                        if type(item) == "string" and not seen[item] then
                            table.insert(unique_items, item)
                            seen[item] = true
                        end
                    end
                end
            end

            -- Optionally sort the final list for consistent output
            table.sort(unique_items)

            return unique_items
        end
    },

    battle = {
        script_identifier = 'consul_battle',
        script_path = 'consul/consul_battle.lua',
        battle_path = '',

        setup = function()
            local log = consul.new_log('battle:setup')
            log:debug('Setting up battle stuff')

            local cfg = consul.config.read()
            if cfg.battle.use_in_battle then
                log:debug('Using consul in battle')
                consul.battle.init()
            else
                log:debug('Not using consul in battle')
                consul.battle.deinit()
            end
        end,

        deinit = function()
            consul._game():remove_custom_battlefield(consul.battle.script_identifier)
        end,

        init = function()
            local log = consul.new_log('battle:init')
            log:debug('Initializing battle stuff')

            consul.battle.deinit()
            consul._game():add_custom_battlefield(
                    consul.battle.script_identifier, -- string identifier
                    0, -- x co-ord
                    0, -- y co-ord
                    1000000, -- radius around position
                    false, -- will campaign be dumped
                    "", -- loading override
                    consul.battle.script_path, -- script override
                    consul.battle.battle_path, -- entire battle override
                    0   -- human alliance when battle override
            );
        end
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
                },
                battle = {
                    use_in_battle = false,
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

                    and type(_config.battle) == "table"
                    and type(_config.battle.use_in_battle) == "boolean"
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
        consul_force_make_vassal_entry = "consul_force_make_vassal_entry",
        consul_force_make_vassal_script = "consul_force_make_vassal_script",
        consul_force_exchange_garrison_entry = "consul_force_exchange_garrison_entry",
        consul_force_exchange_garrison_script = "consul_force_exchange_garrison_script",
        consul_replenish_action_points_entry = "consul_replenish_action_points_entry",
        consul_replenish_action_points_script = "consul_replenish_action_points_script",
        consul_vexatio_provinciae_entry = "consul_vexatio_provinciae_entry",
        consul_vexatio_provinciae_script = "consul_vexatio_provinciae_script",
        consul_sedatio_provinciae_entry = "consul_sedatio_provinciae_entry",
        consul_sedatio_provinciae_script = "consul_sedatio_provinciae_script",
        consul_incrementum_regio_entry = "consul_incrementum_regio_entry",
        consul_incrementum_regio_script = "consul_incrementum_regio_script",

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
                ['/p2 '] = {
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
                ['/log_game_event '] = {
                    help = function()
                        return "Logs event Example: /log_game_event CharacterCreated"
                    end,
                    func = function(_cmd)
                        local event = string.sub(_cmd, 17)
                        if event == "" then
                            return "No event specified"
                        end
                        consul.log:log_events({ event }, function()
                            return true
                        end)
                    end,
                    exec = false,
                    returns = true,
                }
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
                            consul.debug.settlement = context:garrison_residence()
                            consul.debug.faction = context:garrison_residence():faction()
                        end))

                        table.insert(events.CharacterSelected, wrap({ clean = true }, function(context)
                            console.write(pretty(pprinter.character_script_interface(context:character())))
                            consul.debug.character = context:character()
                            consul.debug.faction = context:character():faction()
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
                                consul.debug.faction = faction
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
                },
                ['/show_shroud'] = {
                    _flag = false,

                    help = function()
                        return "Shows/Hides the shroud on the map."
                    end,
                    func = function()
                        local command = consul.console.commands.exact['/show_shroud']
                        consul._game():show_shroud(command._flag)
                        command._flag = not command._flag
                    end,
                    exec = false,
                    returns = false,
                    setup = function()
                        -- shroud turns to true when FactionTurnEnds
                        -- meaning we have to trigger it again, for the user to
                        -- heave a pleasant experience
                        table.insert(events.FactionTurnEnd, function(context)
                            local command = consul.console.commands.exact['/show_shroud']

                            -- function is not turned on
                            if command._flag == false then
                                return
                            end

                            -- just do it once
                            if not context:faction():is_human() then
                                return
                            end

                            -- disable shroud
                            consul._game():show_shroud(false)
                        end)
                    end,
                },
                ['/cli_help'] = {
                    help = function()
                        return "Prints info about the CliExecute functions in the base game."
                    end,
                    func = function()
                        return [[
This is some information about the CliExecute functions in the base game.

-- CliExecute('dump_render_stats <filename>') - Dumps render stats to a file in AppData dir.

-- CliExecute('terrain_write_html_around_camera') - Writes the terrain html around the camera in campaign map in AppData dir.

-- CliExecute('terrain_write_html') - Writes the terrain html in battle map (partial data in the campaign map) in AppData dir.

-- CliExecute('report_rigid_models') - Reports rigid models into a file in AppData dir.

-- CliExecute('compile_all_shaders') - Compiles all shaders.

-- CliExecute('frame_rate_test_fps <fps>') - Runs the game engine at different fps values (slower/faster game). Lower values means faster.

-- CliExecute('docudemon') - Runs the docudemon tool saving the documentation for game code in the Game folder.

-- CliExecute('toggle_terrain_vtex') - Toggles the terrain vtex.

-- CliExecute('force_rigid_lod <int>') - Forces rigid LOD , try values from -1 to 3 and up.

-- CliExecute('add_unit_experience') - When in battle, triggers the add unit experience animation on selected unit.

-- CliExecute('add_unit_effect_icon <index>') - When in battle, triggers the add unit effect icon animation on selected unit.

-- CliExecute('set_battle_size <int>') - Sets the battle size to the specified value.
]]
                    end,
                    exec = false,
                    returns = true,
                },
                ['/start_trace'] = {
                    _is_running = false,
                    help = function()
                        return "Starts/stops the lua trace log. Saves into consul.log file."
                    end,
                    func = function()
                        local command = consul.console.commands.exact['/start_trace']
                        command._is_running = not command._is_running
                        if command._is_running then
                            consul.log:start_trace('clr')
                        else
                            consul.log:stop_trace()
                        end
                    end,
                    exec = false,
                    returns = false,
                },
                ['/use_in_battle'] = {
                    help = function()
                        return "Toggles use of Consul in campaign battles."
                    end,
                    func = function()
                        local r
                        consul.config.process(function(cfg)
                            cfg.battle.use_in_battle = not cfg.battle.use_in_battle
                            if cfg.battle.use_in_battle then
                                consul.battle.init()
                            else
                                consul.battle.deinit()
                            end
                            r = cfg.battle.use_in_battle
                        end)
                        return tostring(r)
                    end,
                    exec = false,
                    returns = true,
                },
                ['/log_events_all'] = {
                    help = function()
                        return "Log all game events to the consul.log file"
                    end,
                    func = function()
                        consul.log:info("Logging all game events")
                        consul.log:log_events_all()
                    end,
                },
                ['/log_events_game'] = {
                    help = function()
                        return "Log game events (excluding component and time trigger)"
                    end,
                    func = function()
                        consul.log:info("Logging game events")
                        consul.log:log_game_events()
                    end,
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
                log:debug("Clicked on: console_send")

                if (consul.is_in_battle_script) then
                    log:debug("In battle script, registering singleshot timer")
                    function __consul_single_shot_timer()
                        consul.console.execute(console.read())
                    end
                    consul.bm:register_singleshot_timer('__consul_single_shot_timer', 0)
                else
                    log:debug("Normal script, executing immediately")
                    console.execute(console.read())
                end
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

            -- check if we clicked on the scriptum entry
            if string.sub(context.string, 1, 14) == ui.scriptum_entry then
                log:debug("Clicked on scriptum entry: " .. context.string)
            else
                -- fail fast
                return
            end

            -- wrap the command so it can executed from inside battle
            local _execute_scriptum_entry = function()
                local script = consul.scriptum.ui_scripts_map[context.string]

                if script then
                    log:debug("Executing script: " .. script)

                    -- WARNING loadfile breaks the game again...
                    local success, err = pcall(dofile, script)
                    if not success then
                        log:error("Error executing script: " .. script .. " " .. err)
                        consul.console.write("error: " .. script .. " " .. err)
                    else
                        log:debug("Executed script: " .. script)
                    end

                end
            end

            -- handle click in battle
            if consul.is_in_battle_script then
                log:debug("In battle script, registering singleshot timer")
                function __consul_single_shot_timer()
                    _execute_scriptum_entry()
                end
                consul.bm:register_singleshot_timer('__consul_single_shot_timer', 0)
            else
                log:debug("Normal script, executing immediately")
                _execute_scriptum_entry()
            end
        end,
    },

    -- new version that should be more flexible with better patterns and less code
    consul_scripts_v2 = {

        -- initialize all scripts
        initialize = function()
            local scripts = consul.consul_scripts_v2
            scripts.instances["vexatio_provinciae"] = scripts.create_change_public_order_by_func(-10)
            scripts.instances["sedatio_provinciae"] = scripts.create_change_public_order_by_func(10)
            scripts.instances["incrementum_regio"] = scripts.create_increase_growth_points_func(1)

            -- two faction scripts
            scripts.instances["force_make_peace"] = scripts.create_two_faction_script(
                "force_make_peace",
                function(faction1, faction2)
                    consul._game():force_make_peace(faction1, faction2)
                end,
                "Forcing peace between"
            )
            scripts.instances["force_make_war"] = scripts.create_two_faction_script(
                "force_make_war",
                function(faction1, faction2)
                    consul._game():force_declare_war(faction1, faction2)
                end,
                "Forcing war between"
            )
            scripts.instances["force_make_vassal"] = scripts.create_two_faction_script(
                "force_make_vassal",
                function(faction1, faction2)
                    consul._game():force_make_vassal(faction2, faction1)
                end,
                "Forcing vassal"
            )
        end,

        instances = {
            vexatio_provinciae = nil,
            sedatio_provinciae = nil,
            incrementum_regio = nil,
            force_make_peace = nil,
            force_make_war = nil,
            force_make_vassal = nil,
        },

        __wrap_func_with_log = function(func, log, text)
            return function()
                log:debug(text)
                func()
            end
        end,

        __wrap_setup = function(setup, log)
            return function()
                log:debug("Setting up...")
                setup()
            end
        end,

        __wrap_start = function(start, log)
            return function()
                log:debug("Starting...")
                start()
            end
        end,

        __wrap_stop = function(stop, log)
            return function()
                log:debug("Stopping...")
                stop()
            end
        end,

        __get_logger = function(name)
            return consul.new_log('consul_scripts:' .. name)
        end,

        create_change_public_order_by_func = function(number)
            local scripts2 = consul.consul_scripts_v2
            local scripts = consul.consul_scripts

            local log = scripts2.__get_logger('change_public_order_by_' .. tostring(number))
            local event = 'change_public_order_by_' .. tostring(number)

            local setup = function()
                scripts.event_handlers['SettlementSelected'][event] = nil
            end

            local start = function()
                scripts.event_handlers['SettlementSelected'][event] = function(context)
                    log:debug("SettlementSelected")
                    local region = context:garrison_residence():region():name()
                    log:debug("Increasing public order in: " .. region)
                    consul._game():set_public_order_of_province_for_region(region, context:garrison_residence():region():public_order() + number)
                end
            end

            local stop = function()
                scripts.event_handlers['SettlementSelected'][event] = nil
            end

            return {
                setup = scripts2.__wrap_setup(setup, log),
                start = scripts2.__wrap_start(start, log),
                stop = scripts2.__wrap_stop(stop, log),
            }

        end,
        create_increase_growth_points_func = function(number)
            local scripts2 = consul.consul_scripts_v2
            local scripts = consul.consul_scripts

            local log = scripts2.__get_logger('increase_growth_points_by_' .. tostring(number))
            local event = 'increase_growth_points_by_' .. tostring(number)

            local setup = function()
                scripts.event_handlers['SettlementSelected'][event] = nil
            end

            local start = function()
                scripts.event_handlers['SettlementSelected'][event] = function(context)
                    log:debug("SettlementSelected")
                    local region = context:garrison_residence():region():name()
                    log:debug("Increasing growth points in: " .. region)
                    consul._game():add_development_points_to_region(region, number)
                end
            end

            local stop = function()
                scripts.event_handlers['SettlementSelected'][event] = nil
            end

            return {
                setup = scripts2.__wrap_setup(setup, log),
                start = scripts2.__wrap_start(start, log),
                stop = scripts2.__wrap_stop(stop, log),
            }

        end,

        create_two_faction_script = function(name, action_func, log_text)
            local scripts2 = consul.consul_scripts_v2
            local scripts = consul.consul_scripts
            local log = scripts2.__get_logger(name)

            local faction1 = nil
            local faction2 = nil

            local reset_factions = function()
                faction1 = nil
                faction2 = nil
            end

            local perform_action = function()
                if faction1 and faction2 then
                    log:debug(log_text .. ": " .. faction1 .. " and " .. faction2)
                    action_func(faction1, faction2)
                    reset_factions()
                    log:debug("Action performed and factions reset.")
                end
            end

            local setup = function()
                scripts.event_handlers['SettlementSelected'][name] = nil
                scripts.event_handlers['CharacterSelected'][name] = nil
                reset_factions()
            end

            local start = function()
                local handler = function(context)
                    local faction_name
                    if context.character then
                        faction_name = context:character():faction():name()
                    elseif context.garrison_residence then
                        faction_name = context:garrison_residence():faction():name()
                    end

                    if faction_name then
                        if not faction1 then
                            faction1 = faction_name
                        else
                            faction2 = faction_name
                        end
                        perform_action()
                    end
                end

                scripts.event_handlers['SettlementSelected'][name] = handler
                scripts.event_handlers['CharacterSelected'][name] = handler
            end

            local stop = function()
                setup()
            end

            return {
                setup = scripts2.__wrap_setup(setup, log),
                start = scripts2.__wrap_start(start, log),
                stop = scripts2.__wrap_stop(stop, log),
            }
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
            local scripts2 = consul.consul_scripts_v2

            log:debug("Setting up scripts")

            -- skip if already set up
            if scripts._is_ready then
                log:debug("Scripts are already set up")
                return
            end

            scripts2.initialize()
            -- call all scripts setup
            scripts.exterminare.setup()
            scripts.transfer_settlement.setup()
            scripts.force_rebellion.setup()
            scripts.force_exchange_garrison.setup()
            scripts.replenish_action_point.setup()
            scripts2.instances.vexatio_provinciae.setup()
            scripts2.instances.sedatio_provinciae.setup()
            scripts2.instances.incrementum_regio.setup()

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
            local scripts2 = consul.consul_scripts_v2
            local ui = consul.ui

            local click_map = {
                [ui.consul_exterminare_entry] = {
                    script = scripts.exterminare,
                    component = ui.consul_exterminare_script,
                    log_msg = "Clicked on consul_exterminare"
                },
                [ui.consul_transfersettlement_entry] = {
                    script = scripts.transfer_settlement,
                    component = ui.consul_transfersettlement_script,
                    log_msg = "Clicked on consul_transfersettlement"
                },
                [ui.consul_adrebellos_entry] = {
                    script = scripts.force_rebellion,
                    component = ui.consul_adrebellos_script,
                    log_msg = "Clicked on consul_forcerebellion"
                },
                [ui.consul_force_make_peace_entry] = {
                    script = scripts2.instances.force_make_peace,
                    component = ui.consul_force_make_peace_script,
                    log_msg = "Clicked on consul_force_make_peace"
                },
                [ui.consul_force_make_war_entry] = {
                    script = scripts2.instances.force_make_war,
                    component = ui.consul_force_make_war_script,
                    log_msg = "Clicked on consul_force_make_war"
                },
                [ui.consul_force_make_vassal_entry] = {
                    script = scripts2.instances.force_make_vassal,
                    component = ui.consul_force_make_vassal_script,
                    log_msg = "Clicked on consul_force_make_vassal"
                },
                [ui.consul_force_exchange_garrison_entry] = {
                    script = scripts.force_exchange_garrison,
                    component = ui.consul_force_exchange_garrison_script,
                    log_msg = "Clicked on consul_force_exchange_garrison"
                },
                [ui.consul_replenish_action_points_entry] = {
                    script = scripts.replenish_action_point,
                    component = ui.consul_replenish_action_points_script,
                    log_msg = "Clicked on consul_replenish_action_point"
                },
                [ui.consul_vexatio_provinciae_entry] = {
                    script = scripts2.instances.vexatio_provinciae,
                    component = ui.consul_vexatio_provinciae_script,
                    log_msg = "Clicked on consul_vexatio_provinciae"
                },
                [ui.consul_sedatio_provinciae_entry] = {
                    script = scripts2.instances.sedatio_provinciae,
                    component = ui.consul_sedatio_provinciae_script,
                    log_msg = "Clicked on consul_sedatio_provinciae"
                },
                [ui.consul_incrementum_regio_entry] = {
                    script = scripts2.instances.incrementum_regio,
                    component = ui.consul_incrementum_regio_script,
                    log_msg = "Clicked on consul_incrementum_regio"
                },
            }

            local clicked_script = click_map[context.string]
            if clicked_script then
                log:debug(clicked_script.log_msg)
                scripts._on_click(clicked_script.script, ui.find(clicked_script.component))
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

                -- transfer only if ready
                if not script._region or not script._faction then
                    return
                end

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
                    script._transfer()
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

                        script._transfer()
                    end
                end
                scripts.event_handlers['CharacterSelected']['transfersettlement'] = function(context)
                    log:debug('CharacterSelected')
                    -- if you select a character, its always the target of the transfer
                    if not script._faction then
                        script._faction = context:character():faction():name()
                    end
                    script._transfer()
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

        force_exchange_garrison = {

            _character = nil,
            _settlement = nil,

            -- function to exchange garrison
            _exchange = function(char_from, char_to)
                consul._game():seek_exchange(
                        'character_cqi:' .. char_from:cqi(),
                        'character_cqi:' .. char_to:cqi(),
                        true,
                        false
                )
            end,
            _get_colonel_for_garrison = function(garrison, is_army, is_navy)
                if (not is_army) and (not is_navy) then
                    return
                end

                local characters = garrison:faction():character_list()
                local characters_count = garrison:faction():character_list():num_items()
                local settlement_name = garrison:settlement_interface():region():name()

                for i = 0, characters_count - 1 do
                    local char = characters:item_at(i)

                    local ok, result = pcall(function()
                        if
                        ---@diagnostic disable-next-line: unnecessary-if
                        char:character_type("colonel") and
                                char:garrison_residence():settlement_interface():region():name() == settlement_name and
                                (
                                        (is_army and char:military_force():is_army()) or
                                                (is_navy and char:military_force():is_navy())
                                )
                        then
                            return char
                        end
                    end)

                    if ok and result ~= nil then
                        return result
                    end
                end
                return nil
            end,

            get_logger = function()
                return consul.new_log('consul_scripts:force_exchange_garrison')
            end,

            setup = function()
                local scripts = consul.consul_scripts
                local script = scripts.force_exchange_garrison
                local log = script.get_logger()
                log:debug("Setting up...")
                script._character = nil
                script._settlement = nil
                scripts.event_handlers['CharacterSelected']['forceexchangegarrison'] = nil
                scripts.event_handlers['SettlementSelected']['forceexchangegarrison'] = nil
            end,

            start = function()
                local scripts = consul.consul_scripts
                local script = scripts.force_exchange_garrison
                local log = script.get_logger()
                log:debug("Starting...")

                scripts.event_handlers['CharacterSelected']['forceexchangegarrison'] = function(context)
                    log:debug("CharacterSelected")
                    if not context:character():faction():is_human() then
                        return
                    end
                    script._character = context:character()
                end

                scripts.event_handlers['SettlementSelected']['forceexchangegarrison'] = function(context)
                    log:debug("SettlementSelected")

                    if script._character == nil and script._settlement == nil then
                        log:debug("No character selected, transfering settlements?")
                        script._settlement = context:garrison_residence()
                        return
                    end

                    -- transfer between settlements
                    -- TODO THIS IS TRICKY DOES NOT WORK
                    -- I ONCE MANAGED TO DO THAT SO IDK
                    if script._settlement ~= nil then
                        log:debug("Exchanging garrison between settlements...")
                        local colonel1 = script._get_colonel_for_garrison(
                                script._settlement,
                                true,
                                false
                        )
                        if colonel1 == nil then
                            return
                        end
                        local colonel2 = script._get_colonel_for_garrison(
                                context:garrison_residence(),
                                true,
                                false
                        )
                        if colonel2 == nil then
                            return
                        end
                        log:debug("Exchanging garrison between 2 colonels...")
                        script._exchange(colonel1, colonel2)
                        return
                    end

                    -- transfer to character
                    if script._character ~= nil and script._character:has_military_force() == true then
                        log:debug("Exchanging garrison with character...")
                        local colonel = script._get_colonel_for_garrison(
                                context:garrison_residence(),
                                script._character:military_force():is_army(),
                                script._character:military_force():is_navy()
                        )
                        if colonel == nil then
                            return
                        end
                        log:debug("Exchanging garrison between character and colonel...")
                        script._exchange(colonel, script._character)
                        return
                    end
                end
            end,
            stop = function()
                return consul.consul_scripts.force_exchange_garrison.setup()
            end,
        },
        replenish_action_point = {

            get_logger = function()
                return consul.new_log('consul_scripts:replenish_action_point')
            end,

            setup = function()
                local scripts = consul.consul_scripts
                local log = scripts.replenish_action_point.get_logger()
                log:debug("Setting up...")
                scripts.event_handlers['CharacterSelected']['replenishactionpoint'] = nil
            end,

            start = function()
                local log = consul.consul_scripts.replenish_action_point.get_logger()
                local scripts = consul.consul_scripts
                log:debug("Starting...")

                scripts.event_handlers['CharacterSelected']['replenishactionpoint'] = function(context)
                    log:debug("CharacterSelected")
                    local char = context:character()
                    log:debug("Replenished action points for character: " .. char:get_forename())
                    consul._game():replenish_action_points('character_cqi:' .. char:cqi())
                end
            end,

            stop = function()
                local scripts = consul.consul_scripts
                local log = scripts.replenish_action_point.get_logger()
                log:debug("Stopping...")
                scripts.event_handlers['CharacterSelected']['replenishactionpoint'] = nil
            end,
        },
    },

    -- wrapper for the CliExecute function
    _cliExecute = function(...)
        return CliExecute(...)
    end,

    -- consul._game is shorten
    ---@type GAME
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
        _wont_print = "CONSUL_WONT_PRINT",

        _is_null = function(_any)
            return string.sub(tostring(_any), 1, 21) == "NULL_SCRIPT_INTERFACE"
        end,

        garrison_script_interface = function(_garrison)
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
                ['settlement_interface'] = consul.pprinter.settlement_script_interface(_garrison:settlement_interface()),
                ['slot_interface'] = _garrison:slot_interface(),
                ['unit_count'] = _garrison:unit_count(),
            }
        end,

        unit_script_interface = function(_unit, _index)
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
            if consul.pprinter._is_null(_force) then
                return {}
            end
            return {
                ["character_list"] = consul.pprinter._wont_print,
                ["faction"] = consul.pprinter._wont_print,
                ["garrison_residence"] = consul.pprinter._wont_print,
                ["general_character"] = consul.pprinter._wont_print,
                ["contains_mercenaries"] = _force:contains_mercenaries(),
                ["has_garrison_residence"] = _force:has_garrison_residence(),
                ["has_general"] = _force:has_general(),
                ["is_army"] = _force:is_army(),
                ["is_navy"] = _force:is_navy(),
                --["model"] = "function: 57178350",
                ["upkeep"] = _force:upkeep(),
                ['unit_list'] = consul.pprinter.unit_list_script_interface(_force:unit_list())
            }
        end,

        character_script_interface = function(_char)
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
                ["research_queue_idle"] = (function()
                    -- wont work for rebels
                    if _fac:name() == "rebels" then
                        return "will crash game in campaign"
                    end
                    return _fac:research_queue_idle()
                end)(),
                ["sea_trade_route_raided"] = _fac:sea_trade_route_raided(),
                ["started_war_this_turn"] = _fac:started_war_this_turn(),
                ["state_religion"] = _fac:state_religion(),
                ["subculture"] = _fac:subculture(),
                ["tax_category"] = _fac:tax_category(),
                ["tax_level"] = _fac:tax_level(),
                ["total_food"] = _fac:total_food(),
                ["trade_resource_exists"] = _fac:trade_resource_exists(),
                ["trade_route_limit_reached"] = (function()
                    -- wont work for rebels
                    if _fac:name() == "rebels" then
                        return "will crash game in campaign"
                    end
                    return _fac:trade_route_limit_reached()
                end)(),
                ["trade_ship_not_in_trade_node"] = _fac:trade_ship_not_in_trade_node(),
                ["trade_value"] = _fac:trade_value(),
                ["trade_value_percent"] = _fac:trade_value_percent(),
                ["treasury"] = _fac:treasury(),
                ["treasury_percent"] = _fac:treasury_percent(),
                ["treaty_details"] = _fac:treaty_details(),
                ["unused_international_trade_route"] = (function()
                    -- wont work for rebels
                    if _fac:name() == "rebels" then
                        return "will crash game in campaign"
                    end
                    return _fac:unused_international_trade_route()
                end),
                ["upkeep_expenditure_percent"] = _fac:upkeep_expenditure_percent(),
            }
        end,

        settlement_script_interface = function(_settl)
            if consul.pprinter._is_null(_settl) then
                return {}
            end
            return {
                ["castle_slot"] = _settl:castle_slot(),
                ["commander"] = _settl:commander(),
                ["display_position_x"] = _settl:display_position_x(),
                ["display_position_y"] = _settl:display_position_y(),
                ["logical_position_x"] = _settl:logical_position_x(),
                ["logical_position_y"] = _settl:logical_position_y(),
                ["faction"] = _settl:faction(),
                ["has_castle_slot"] = _settl:has_castle_slot(),
                ["has_commander"] = _settl:has_commander(),
                ["region"] = consul.pprinter.region_script_interface(_settl:region(), {
                    -- do not print slot list
                    -- it is printed in `slot_list_interface` below
                    _print__slot_list = false,
                }),
                ["slot_list"] = consul.pprinter.slot_list_interface(_settl:slot_list())
            }
        end,

        region_script_interface = function(_region, _opts)
            if consul.pprinter._is_null(_region) then
                return {}
            end
            return {
                ["adjacent_region_list"] = _region:adjacent_region_list(),
                ["building_exists"] = _region:building_exists(),
                ["building_superchain_exists"] = _region:building_superchain_exists(),
                ["garrison_residence"] = _region:garrison_residence(),
                ["last_building_constructed_key"] = _region:last_building_constructed_key(),
                ["majority_religion"] = _region:majority_religion(),
                ["name"] = _region:name(),
                ["num_buildings"] = _region:num_buildings(),
                ["owning_faction"] = _region:owning_faction(),
                ["province_name"] = _region:province_name(),
                ["public_order"] = _region:public_order(),
                ["region_wealth"] = _region:region_wealth(),
                ["region_wealth_change_percent"] = _region:region_wealth_change_percent(),
                ["resource_exists"] = _region:resource_exists(),
                ["sanitation"] = _region:sanitation(),
                ["settlement"] = _region:settlement(),
                ["slot_list"] = (function()
                    if (_opts and _opts._print__slot_list) then
                        return consul.pprinter.slot_list_interface(_region:slot_list())
                    end
                    return consul.pprinter._wont_print
                end)(),
                ["slot_type_exists"] = _region:slot_type_exists(),
                ["squalor"] = _region:squalor(),
                ["tax_income"] = _region:tax_income(),
                ["town_wealth_growth"] = _region:town_wealth_growth()
            }
        end,

        building_script_interface = function(_build)
            if consul.pprinter._is_null(_build) then
                return {}
            end
            return {
                ["chain"] = _build:chain(),
                ["faction"] = _build:faction(),
                ["name"] = _build:name(),
                ["region"] = _build:region(),
                ["slot"] = _build:slot(),
                ["superchain"] = _build:superchain()
            }
        end,

        slot_script_interface = function(_slot)
            if consul.pprinter._is_null(_slot) then
                return {}
            end
            return {
                ["name"] = _slot:name(),
                ["building"] = consul.pprinter.building_script_interface(_slot:building()),
                ["faction"] = _slot:faction(),
                ["has_building"] = _slot:has_building(),
                ["region"] = _slot:region(),
                ["type"] = _slot:type()
            }
        end,

        slot_list_interface = function(_slotlist)
            if consul.pprinter._is_null(_slotlist) then
                return {}
            end

            local slots = {}

            for i = 0, _slotlist:num_items() - 1 do
                slots[tostring(i)] = consul.pprinter.slot_script_interface(_slotlist:item_at(i))
            end

            return {
                ['buliding_type_exists'] = _slotlist:buliding_type_exists(),
                ['is_empty'] = _slotlist:is_empty(),
                ['num_items'] = _slotlist:num_items(),
                ['slot_type_exists'] = _slotlist:slot_type_exists(),
                ['_consul_slots'] = slots
            }
        end
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

return consul
