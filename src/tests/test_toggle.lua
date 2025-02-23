package.path = package.path .. ";consul/?.lua"
require('consul')

-- Mock m_root
m_root = {
    Find = function(_, name)
        if name == CONSUL.COMPONENT.CONSOLE.ROOT then
            return CONSULSCRIPTUM_CONSOLE_COMPONENT
        end
        if name == CONSUL.COMPONENT.ROOT then
            return CONSULSCRIPTUM_ROOT_COMPONENT
        end
        if name == CONSUL.COMPONENT.ROOT then
            return CONSULSCRIPTUM_COMPONENT
        end
    end,
    Width = function()
        return 1920
    end,
    Height = function()
        return 1080
    end
}

-- Mock UIComponent
UIComponent = function(component)
    local obj = component or {
        x = 0,
        y = 0,
        SetVisible = function(self, visible)
            self.visible = visible
        end,
        Visible = function(self)
            return self.visible
        end,
        MoveTo = function(self, x, y)
            self.x = x
            self.y = y
        end,
        Position = function(self)
            return self.x, self.y
        end
    }
    return obj
end

-- Mock UIComponent instance
CONSULSCRIPTUM_COMPONENT = UIComponent()
CONSULSCRIPTUM_COMPONENT:MoveTo(0, 0)


-- Mock UIComponent instance
CONSULSCRIPTUM_CONSOLE_COMPONENT = UIComponent()
CONSULSCRIPTUM_CONSOLE_COMPONENT:SetVisible(true)

-- Import the module
local TOGGLE = require('consul.consul_toggle')

-- When you minimize the Scriptum listview it should also minimize the console
local function test_can_toggle_visibility_of_console_scriptum()

    -- Initial visibility check
    local visible = CONSULSCRIPTUM_CONSOLE_COMPONENT:Visible()
    assert(visible == true, "Initial visibility should be true")

    -- Toggle visibility
    TOGGLE.OnComponentLClickUp({
        string = CONSUL.COMPONENT.SCRIPTUM.TOGGLE_BUTTON
    })
    visible = CONSULSCRIPTUM_CONSOLE_COMPONENT:Visible()
    assert(visible == false, "Visibility should be false after toggling")

    -- Toggle visibility again
    TOGGLE.OnComponentLClickUp({
        string = CONSUL.COMPONENT.SCRIPTUM.TOGGLE_BUTTON
    })
    visible = CONSULSCRIPTUM_CONSOLE_COMPONENT:Visible()
    assert(visible == true, "Visibility should be true after toggling again")

end


CONSULSCRIPTUM_ROOT_COMPONENT = UIComponent()
CONSULSCRIPTUM_ROOT_COMPONENT:SetVisible(false)

-- When you toggle the Consul Scriptum root it should work
local function test_can_toggle_visibility_of_consul_scriptum_root()

    -- Initial visibility check
    local visible = CONSULSCRIPTUM_ROOT_COMPONENT:Visible()
    assert(visible == false, "Initial visibility should be false")

    -- Toggle visibility
    TOGGLE.OnComponentLClickUp({
        string = CONSUL.COMPONENT.BUTTON_TOGGLE.ROOT
    })
    visible = CONSULSCRIPTUM_ROOT_COMPONENT:Visible()
    assert(visible == true, "Visibility should be true after toggling")

    -- Toggle visibility again
    TOGGLE.OnComponentLClickUp({
        string = CONSUL.COMPONENT.BUTTON_TOGGLE.ROOT
    })
    visible = CONSULSCRIPTUM_ROOT_COMPONENT:Visible()
    assert(visible == false, "Visibility should be false after toggling again")

end


test_can_toggle_visibility_of_console_scriptum()
print("Test 1 passed!")
test_can_toggle_visibility_of_consul_scriptum_root()
print("Test 2 passed!")