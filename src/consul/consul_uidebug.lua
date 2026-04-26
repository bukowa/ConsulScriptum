---@module consul_uidebug

local uidebug = {
    is_active = true,
    last_hovered_address = nil,
    cache = {}
}

local SEPARATOR = "<||_CONSUL_SEP_||>"

uidebug.PROPERTIES = {
    "Id", "Address", "Priority", "Visible", "IsInteractive", 
    "Position", "Bounds", "Dimensions", "GetStateText", 
    "GetTooltipText", "Opacity", "CurrentState", "DockingPoint",
    "ChildCount", "Height", "Width", "TextDimensions", "CurrentAnimationId",
    "IsDragged", "IsMoveable", "IsMouseOverChildren", "Layout",
    "GetStateTextDetails", "CallbackId"
}

-- Methods that return multiple values but we only want the first one (usually text)
local SINGLE_RETURN_METHODS = {
    ["GetStateText"] = true,
    ["GetTooltipText"] = true,
}

-- Safe call wrapper logic similar to the one in consul.ui.debug
local function safe_call(obj, method)
    if not obj or not obj[method] then return "nil" end
    if type(obj[method]) ~= "function" then return tostring(obj[method]) end

    local ok, results = pcall(function()
        local function capture(...) return {n = select("#", ...), ...} end
        return capture(obj[method](obj))
    end)

    if not ok then return "error" end
    
    if SINGLE_RETURN_METHODS[method] then
        return tostring(results[1] or "nil")
    end

    if results.n == 0 then return "nil" end
    
    local str_vals = {}
    for i = 1, results.n do
        table.insert(str_vals, tostring(results[i]))
    end
    local res = table.concat(str_vals, ",")

    -- sanitize newlines to keep everything on one line
    res = string.gsub(res, "\n", "\\n")
    res = string.gsub(res, "\r", "")
    return res
end

-- Main recursive function
local function traverse_ui(component, depth, output, hovered_address)
    if not component then return end

    local address = safe_call(component, "Address")
    if address and address ~= "nil" and address ~= "error" then
        uidebug.cache[address] = component
    end

    local is_hovered = (address == hovered_address) and "true" or "false"

    local props = { tostring(depth), is_hovered }
    for i = 1, #uidebug.PROPERTIES do
        local prop = uidebug.PROPERTIES[i]
        local val = safe_call(component, prop)
        table.insert(props, val)
    end

    table.insert(output, table.concat(props, SEPARATOR))

    -- Recurse children
    local child_count_raw = safe_call(component, "ChildCount")
    local child_count = tonumber(child_count_raw) or 0

    for i = 0, child_count - 1 do
        local ok, child_ptr = pcall(function() return component:Find(i) end)
        if ok and child_ptr then
            local child = UIComponent(child_ptr)
            if child then
                traverse_ui(child, depth + 1, output, hovered_address)
            end
        end
    end
end

--- Dumps the entire UI tree starting from the given component to a file.
--- @function uidebug.dump_tree
--- @tparam UIComponent root_component The component to start traversing from.
--- @tparam[opt] string hovered_address The address of the currently hovered component.
uidebug.dump_tree = function(root_component, hovered_address)
    if not root_component then
        consul.log:error("uidebug: dump_tree called with nil root_component")
        return
    end

    if hovered_address then
        uidebug.last_hovered_address = hovered_address
    end

    local output = {}
    
    local ok, err = pcall(function()
        uidebug.cache = {} -- clear cache on new dump
        traverse_ui(root_component, 0, output, uidebug.last_hovered_address)
    end)
    
    if not ok then
        consul.log:error("uidebug: Error traversing UI tree: " .. tostring(err))
        return
    end

    local file, err_open = io.open("consul_debug_ui_state.txt", "w+")
    if not file then
        consul.log:error("uidebug: Could not open output file: " .. tostring(err_open))
        return
    end

    file:write("IS_ACTIVE:" .. (uidebug.is_active and "true" or "false") .. "\n")
    file:write("GAME:" .. tostring(consul_build or "Unknown") .. "\n")
    file:write(table.concat(output, "\n"))
    file:close()
end

--- Launches the UI debugger by copying the template to the game root and opening it.
--- @function uidebug.launch
--- @treturn string Status message.
uidebug.launch = function()
    local output_path = "consul_uidebug.html"
    
    -- Load template from embedded Lua string
    local ok, content = pcall(require, "consul_uidebug_template")
    if not ok then
        return "Error: Could not load UI template from consul_uidebug_template.lua"
    end
    
    local f_out = io.open(output_path, "w")
    if not f_out then
        return "Error: Could not write to " .. output_path
    end
    f_out:write(content)
    f_out:close()
    
    os.execute("start " .. output_path)
    
    return "UI Debugger launched! (File: " .. output_path .. ")"
end

uidebug.process_commands = function()
    local f = io.open("consul_debug_ui_command.txt", "r")
    if not f then return end

    local content = f:read("*a")
    f:close()

    if content and content ~= "" then
        -- clear the file immediately
        local fw = io.open("consul_debug_ui_command.txt", "w")
        if fw then fw:close() end
        
        -- execute the command
        local func, err = loadstring(content)
        if func then
            local ok, run_err = pcall(func)
            if not ok then
                consul.log:error("uidebug: Error running ui command: " .. tostring(run_err))
            end
        else
            consul.log:error("uidebug: Error parsing ui command: " .. tostring(err))
        end
        
        -- refresh the UI to reflect changes
        if consul.ui and consul.ui._UIRoot then
            uidebug.dump_tree(consul.ui._UIRoot, uidebug.last_hovered_address)
        end
    end
end

uidebug.init_hooks = function()
    if uidebug.is_hooked then
        return
    end

    table.insert(events.ComponentMouseOn, function(context)
        if not uidebug.is_active then
            return
        end
        if consul.ui.is_consul(context.string) then
            return
        end
        local c = UIComponent(context.component)
        if c then
            local address = tostring(c:Address())
            uidebug.dump_tree(consul.ui._UIRoot, address)
        end
    end)

    table.insert(events.ShortcutTriggered, function(context)
        local shortcut = context.string
        if shortcut == "standard_ping" then
            uidebug.is_active = not uidebug.is_active
            uidebug.dump_tree(consul.ui._UIRoot, uidebug.last_hovered_address)
        end
    end)

    table.insert(events.TimeTrigger, function(context)
        -- frontend just keeps going
        if consul.env.mode == 2 then
            uidebug.process_commands()
            return
        end

        -- campaign needs a trigger
        if consul.env.mode == 1 then
            if context.string == "uidebug_command_poll" then
                uidebug.process_commands()
                consul._game():add_time_trigger("uidebug_command_poll", 0.5)
            end
        end

        -- todo battle nothing yet
    end)

    uidebug.is_hooked = true
    consul.log:debug("UI Debugger hooks initialized!")
end

return uidebug
