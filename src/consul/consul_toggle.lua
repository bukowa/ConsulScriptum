require 'consul'

-- Create a logger for this script
local log = require 'consul_logging'.new_logger("consul_toggle")


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

    if (context.string == CONSUL.COMPONENT.SCRIPTUM.TOGGLE_BUTTON) then
        log:debug("Toggled visibility of console")
        local c = UIComponent(m_root:Find(
                CONSUL.COMPONENT.CONSOLE.ROOT
        ))
        c:SetVisible(not c:Visible())
        return
    end

    if (context.string == CONSUL.COMPONENT.BUTTON_TOGGLE.ROOT) then
        log:debug("Toggled visibility of consul root")
        local c = UIComponent(m_root:Find(
                CONSUL.COMPONENT.ROOT
        ))
        MoveConsulRootToCenter(c)
        c:SetVisible(not c:Visible())
        return
    end
end

local function OnUIComponentMoved(context)

    if context.string == CONSUL.COMPONENT.ROOT then
        log:debug("Moved consul root")
        local c = UIComponent(context.component)
        local x, y = c:Position()
        require 'consul_config'.write_config('consul.root.position.x', x)
        require 'consul_config'.write_config('consul.root.position.y', y)
    end

end


local function OnUICreated(context)

    if not m_root then
        log:error("m_root not found")
        return
    end

    -- Find the root component
    local consul_root = m_root:Find(CONSUL.COMPONENT.ROOT)

    -- Fail if the root component is not found
    if not consul_root then
        log:warn("Root component not found")
        return
    end

    -- Convert to UIComponent
    local c = UIComponent(consul_root)

    -- Open the config file
    local cfg = require 'consul_config'.read_config()

    -- Get the x and y positions from the config file
    local x = cfg['consul.root.position.x']
    local y = cfg['consul.root.position.y']

    -- Get the visibility from the config file
    local r_visible = cfg['consul.root.visible']
    local c_visible = cfg['consul.consul.visible']
    local s_visible = cfg['consul.scriptum.visible']

    -- Set the visibility of the root component
    c:SetVisible(r_visible)

    -- Set the visibility of the consul console
    local consul_console = UIComponent(m_root:Find(
            CONSUL.COMPONENT.CONSOLE.ROOT
    ))
    consul_console:SetVisible(c_visible)

    -- Set the minimized state of the consul
    local consul_
end


return {
    OnComponentLClickUp = OnComponentLClickUp,
    OnUIComponentMoved = OnUIComponentMoved,
}
