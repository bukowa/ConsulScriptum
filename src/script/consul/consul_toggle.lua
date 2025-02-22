require 'consul'

-- Create a logger for this script
local log_consul_toggle = require 'consul_logging'.new_logger("consul_toggle")

-- Toggles the visibility of the console
local function OnComponentLClickUp(context)
    if (context.string == CONSUL.COMPONENT.CONSOLE.TOGGLE_BUTTON) then
        log_consul_toggle:debug("Toggled visibility of console")
        local consul_console = UIComponent(m_root:Find(
                CONSUL.COMPONENT.CONSOLE.ROOT)
        )
        log_consul_toggle:debug("Current visibility: " .. tostring(consul_console:Visible()))
        consul_console:SetVisible(not consul_console:Visible())
        log_consul_toggle:debug("New visibility: " .. tostring(consul_console:Visible()))
    end
end

return {
    OnComponentLClickUp = OnComponentLClickUp
}
