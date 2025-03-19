function log_ui_tree(component, depth)
    depth = depth or 0
    local indent = string.rep("\t", depth)

    -- Log component name with indentation
    consul.log:_write_to_file(indent .. tostring(component:Id()))

    -- Get child count
    local count = component:ChildCount()

    -- Iterate through children
    for i = 0, count - 1 do
        local child = UIComponent(component:Find(i))
        log_ui_tree(child, depth + 1)
    end
end

-- Usage example
local root = consul.ui._UIRoot
log_ui_tree(root)