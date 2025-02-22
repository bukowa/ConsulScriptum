package.path = package.path .. ";script/consul/?.lua"
require('consul')

-- Mock m_root
m_root = {
    Find = function(_, name)
        if name == CONSUL.COMPONENT.CONSOLE.ROOT then
            return CONSULSCRIPTUM_COMPONENT
        end
    end
}

-- Mock UIComponent
UIComponent = function(component)
    local obj = component or {
        SetVisible = function(self, visible)
            self.visible = visible
        end,
        Visible = function(self)
            return self.visible
        end
    }
    return obj
end


-- Mock UIComponent instance
CONSULSCRIPTUM_COMPONENT = UIComponent()
CONSULSCRIPTUM_COMPONENT:SetVisible(true)

-- Import the module
local TOGGLE = require('script.consul.consul_toggle')

-- Test function
local function test_can_toggle_visibility()

    -- Initial visibility check
    local visible = CONSULSCRIPTUM_COMPONENT:Visible()
    assert(visible == true, "Initial visibility should be true")

    -- Toggle visibility
    TOGGLE.OnComponentLClickUp({
        string = CONSUL.COMPONENT.CONSOLE.TOGGLE_BUTTON
    })
    visible = CONSULSCRIPTUM_COMPONENT:Visible()
    assert(visible == false, "Visibility should be false after toggling")

    -- Toggle visibility again
    TOGGLE.OnComponentLClickUp({
        string = CONSUL.COMPONENT.CONSOLE.TOGGLE_BUTTON
    })
    visible = CONSULSCRIPTUM_COMPONENT:Visible()
    assert(visible == true, "Visibility should be true after toggling again")

end

test_can_toggle_visibility()
print("All tests passed")