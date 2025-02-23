require 'consul'

-- Create a logger for this script
local log_consul_toggle = require 'consul_logging'.new_logger("consul_toggle")


-- Moves the consul root to the center of the screen
local function MoveConsulRootToCenter(component)

    -- Get the screen dimensions
    local screenWidth = m_root:Width()
    local screenHeight = m_root:Height()

    -- Element dimensions
    local elementWidth = 700
    local elementHeight = 500

    -- Calculate the center position
    local centerX = (screenWidth / 2) - (elementWidth / 2)
    local centerY = (screenHeight / 2) - (elementHeight / 2)

    -- Move the element to the calculated position
    component:MoveTo(centerX+elementWidth, centerY)
end

-- Toggles the visibility of the console
local function OnComponentLClickUp(context)

    if (context.string == CONSUL.COMPONENT.CONSOLE.TOGGLE_BUTTON) then
        log_consul_toggle:debug("Toggled visibility of console")
        local consul_console = UIComponent(m_root:Find(
                CONSUL.COMPONENT.CONSOLE.ROOT
        ))
        log_consul_toggle:debug("Current visibility: " .. tostring(consul_console:Visible()))
        consul_console:SetVisible(not consul_console:Visible())
        log_consul_toggle:debug("New visibility: " .. tostring(consul_console:Visible()))
        return
    end

    if (context.string == CONSUL.COMPONENT.BUTTON_TOGGLE.ROOT) then
        log_consul_toggle:debug("Toggled visibility of consul root")
        local consul_root = UIComponent(m_root:Find(
                CONSUL.COMPONENT.ROOT
        ))
        log_consul_toggle:debug("Current visibility: " .. tostring(consul_root:Visible()))
        MoveConsulRootToCenter(consul_root)
        consul_root:SetVisible(not consul_root:Visible())
        log_consul_toggle:debug("New visibility: " .. tostring(consul_root:Visible()))
        return
    end
end

return {
    OnComponentLClickUp = OnComponentLClickUp
}
