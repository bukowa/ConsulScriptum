package.path = package.path .. ";script/consul/?.lua"
require('consul')

-- Mock m_root
m_root = {
    Find = function(_, name)
        if name == CONSUL.COMPONENT.ROOT then
            return CONSULSCRIPTUM_COMPONENT
        end
    end
}

-- Mock UIComponent
UIComponent = function(component)
    local obj = component or {
        x = 0,
        y = 0,
        SetPosition = function(self, x, y)
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
CONSULSCRIPTUM_COMPONENT:SetPosition(0, 0)

-- Import the module
local POSITION = require('script.consul.consul_position')
POSITION._remove_file()

-- Test function
local function test_can_save_and_load_position()

    -- Initial position check
    local x, y = CONSULSCRIPTUM_COMPONENT:Position()
    assert(x == 0 and y == 0, "Initial position should be (0,0)")

    -- Load position (should remain unchanged)
    POSITION.OnUICreated({ string = CONSUL.COMPONENT.ROOT })
    x, y = CONSULSCRIPTUM_COMPONENT:Position()
    assert(x == 0 and y == 0, "Position should still be (0,0) after loading")

    -- Move the component
    CONSULSCRIPTUM_COMPONENT:SetPosition(300, 400)
    POSITION.OnUIComponentMoved({
        string = CONSUL.COMPONENT.ROOT,
        component = CONSULSCRIPTUM_COMPONENT
    })

    -- Reset component position before loading
    CONSULSCRIPTUM_COMPONENT:SetPosition(0, 0)
    POSITION.OnUICreated({ string = CONSUL.COMPONENT.ROOT })

    -- Validate position persistence
    x, y = CONSULSCRIPTUM_COMPONENT:Position()
    assert(x == 300 and y == 400, "Position should be (300,400) after reloading")
end

test_can_save_and_load_position()
print("Test passed!")
