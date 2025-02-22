require 'consul'

-- Create a logger for this script
local log_consul_position = require 'consul_logging'.new_logger("consul_position")

-- The name of the file to save the position to
local FILENAME = "consul_scriptum_persistence"

local function _remove_file()
    os.remove(FILENAME)
end

local function OnUIComponentMoved(context)
    if context.string == CONSUL.COMPONENT.ROOT then
        log_consul_position:debug("Saving position to file")
        local c = UIComponent(context.component)
        local x, y = c:Position()
        log_consul_position:debug("Position: " .. x .. "," .. y)
        local f, err = io.open(FILENAME, "w")
        if f then
            f:write(x .. "," .. y)
            f:close()
        else
            log_consul_position:warn("Error opening file for writing: " .. err)
            print("Error opening file for writing: " .. err)
        end
    end
end

local function OnUICreated(context)

    if not m_root then
        log_consul_position:error("m_root not found")
        return
    end

    -- Find the root component
    local consul_root = m_root:Find(CONSUL.COMPONENT.ROOT)

    -- Fail if the root component is not found
    if not consul_root then
        log_consul_position:warn("Root component not found")
        return
    end

    -- Convert to UIComponent
    local c = UIComponent(consul_root)

    -- Open the file for reading
    local f, err = io.open(FILENAME, "r")
    if f then
        local line = f:read()
        f:close()

        -- If there is a line, extract the x and y coordinates
        if line then
            local x, y = line:match("([^,]+),([^,]+)")

            -- Convert to numbers and set position
            log_consul_position:debug("Setting position to " .. x .. "," .. y)
            c:MoveTo(tonumber(x), tonumber(y))

            -- We are done
            return

        end
    else
        log_consul_position:warn("Error opening file for reading: " .. err)
    end
end

return {
    OnUIComponentMoved = OnUIComponentMoved,
    OnUICreated = OnUICreated,
    _remove_file = _remove_file
}
