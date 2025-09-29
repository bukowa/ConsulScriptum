---
-- Converts display coordinates to logical coordinates using the pre-calculated model.
-- @param display_x (number) The display X-coordinate.
-- @param display_y (number) The display Y-coordinate.
-- @return number, number The logical X and logical Y coordinates (rounded integers).
--
function displayToLogical(display_x, display_y)
    -- 1. Model parameters found from your Python training
    -- These are the results you achieved:
    local scale_x = 1.4961
    local offset_x = 0.0703
    local scale_y = 1.2959
    local offset_y = -0.2867

    -- 2. Apply the transformation equations
    local logical_x_float = (scale_x * display_x) + offset_x
    local logical_y_float = (scale_y * display_y) + offset_y

    -- 3. Round to the nearest whole number
    -- Lua doesn't have a built-in math.round, so we use math.floor(n + 0.5)
    local logical_x = math.floor(logical_x_float + 0.5)
    local logical_y = math.floor(logical_y_float + 0.5)

    return logical_x, logical_y
end

consul.console.clear()
local aX, aY = debug.getfenv(debug.getregistry()[2])["CampaignUI"]:GetCameraPosition()
local marker_name = "mymarker"
consul._game():remove_marker(marker_name)
consul._game():add_marker(marker_name, "tutorial_marker", aX, aY, 2)
consul.console.write(consul.pretty({displayToLogical(aX, aY)}))
