---@module consul_uidebug

local uidebug = {
    is_active = true,
    last_hovered_address = nil
}

local SEPARATOR = "==============================[CONSUL_UI_NODE]=============================="

-- Safe call wrapper logic similar to the one in consul.ui.debug
local function safe_call(obj, method)
    if not obj or not obj[method] then return "nil" end
    if type(obj[method]) ~= "function" then return tostring(obj[method]) end

    local ok, val1, val2, val3, val4 = pcall(function() return obj[method](obj) end)
    if not ok then return "error" end
    
    if val4 ~= nil then return string.format("%s,%s,%s,%s", tostring(val1), tostring(val2), tostring(val3), tostring(val4)) end
    if val3 ~= nil then return string.format("%s,%s,%s", tostring(val1), tostring(val2), tostring(val3)) end
    if val2 ~= nil then return string.format("%s,%s", tostring(val1), tostring(val2)) end
    
    if val1 == nil then return "nil" end
    return tostring(val1)
end

-- Sanitizes newlines to allow line-by-line reading in JS
local function sanitize_text(text)
    if type(text) ~= "string" then return tostring(text) end
    return string.gsub(text, "\n", "\\n")
end

-- Main recursive function
local function traverse_ui(component, depth, output, hovered_address)
    if not component then return end

    -- Gather properties
    local id = safe_call(component, "Id")
    local address = safe_call(component, "Address")
    local priority = safe_call(component, "Priority")
    local visible = safe_call(component, "Visible")
    local interactive = safe_call(component, "IsInteractive")
    local position = safe_call(component, "Position")
    local bounds = safe_call(component, "Bounds")
    local dimensions = safe_call(component, "Dimensions")
    local text = sanitize_text(safe_call(component, "GetStateText"))
    local tooltip = sanitize_text(safe_call(component, "GetTooltipText"))
    local is_hovered = (address == hovered_address) and "true" or "false"

    -- Output block (13 lines exactly per component)
    table.insert(output, SEPARATOR)
    table.insert(output, tostring(depth))
    table.insert(output, id)
    table.insert(output, address)
    table.insert(output, priority)
    table.insert(output, visible)
    table.insert(output, interactive)
    table.insert(output, position)
    table.insert(output, bounds)
    table.insert(output, dimensions)
    table.insert(output, text)
    table.insert(output, tooltip)
    table.insert(output, is_hovered)

    -- Recurse children
    local child_count_raw = safe_call(component, "ChildCount")
    local child_count = tonumber(child_count_raw) or 0

    for i = 0, child_count - 1 do
        local child_ptr = component:Find(i)
        if child_ptr then
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
    -- consul.log:info("uidebug: Starting UI tree dump...")
    
    local ok, err = pcall(function()
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
    file:write(table.concat(output, "\n"))
    file:close()
    
    -- consul.log:info("uidebug: UI tree dump completed (" .. tostring(#output) .. " lines written).")
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

return uidebug
