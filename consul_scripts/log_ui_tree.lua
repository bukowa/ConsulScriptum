--
-- This script logs the UI tree to the consul log file.
--
function log_ui_tree(component, depth)
    depth = depth or 0
    local indent = string.rep("\t", depth)

    local state_text = component:GetStateText()
    local id = component:Id()

    consul.log:_write_to_file(indent .. tostring(id) .. ' | ' .. tostring(state_text))

    local count = component:ChildCount()

    -- Iterate through children
    for i = 0, count - 1 do
        local child = UIComponent(component:Find(i))
        log_ui_tree(child, depth + 1)
    end
end

-- Usage example
log_ui_tree(consul.ui._UIRoot)
