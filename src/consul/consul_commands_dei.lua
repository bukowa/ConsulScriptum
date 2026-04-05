-- ---------------------------------------------------------------------------------------------------------------------
-- CONSUL SCRIPTUM DEI MOD COMMANDS
-- ---------------------------------------------------------------------------------------------------------------------

-- Caching the DEI population module functions for better performance and readability.
-- These functions are part of the "Divide et Impera" mod's population system.
local function get_pop_script()
    return require("lua_scripts.population")
end

local function DEI_GetUIPopulation()
    return get_pop_script()["UIPopulation"]
end

local function DEI_GetRegionTable()
    return get_pop_script()["GetRegionPop"]
end

--- Retrieves the raw population table and UI population table for a given region.
-- @param region_key string The internal name of the region.
-- @return table, table The data table and UI table for the region.
local function get_pop_tables(region_key)
    local region_wrapper = { name = function() return region_key end }
    local reg_table = DEI_GetRegionTable()(region_wrapper)
    local ui_table = DEI_GetUIPopulation()[region_key]
    return reg_table, ui_table
end

--- Internal helper to set or reset population for a region.
-- @param region_key string The region name.
-- @param class_idx number|nil The population class (1-4). If nil, all classes are reset.
-- @param amount number The population count to set.
-- @return boolean, string Success status and an optional error/status message.
local function update_region_pop(region_key, class_idx, amount)
    local ok, reg_table, ui_table = pcall(get_pop_tables, region_key)
    
    if not ok or not reg_table or not ui_table then
        return false, string.format("Region '%s' not found or population system unavailable.", region_key)
    end

    if class_idx then
        reg_table[class_idx] = amount
        ui_table[class_idx] = amount
    else
        for i = 1, 4 do
            reg_table[i] = amount
            ui_table[i] = amount
        end
    end
    
    return true
end
emp_dacia_zarmizegetusa
return {
    exact = {
        -- /dei_reset_all_pop: Wipe population of all regions.
        ['/dei_reset_all_pop'] = {
            help = function() return "[DEI] Wipe population of all regions to 0." end,
            func = function()
                local world = consul._game():model():world()
                local region_list = world:region_manager():region_list()
                local count = 0

                for i = 0, region_list:num_items() - 1 do
                    local name = region_list:item_at(i):name()
                    local success = update_region_pop(name, nil, 0)
                    if success then count = count + 1 end
                end

                return string.format("Success: Population wiped for %d regions.", count)
            end,
            exec = false,
            returns = true,
        }
    },

    starts_with = {
        -- /dei_set_pop <region_key> <class_idx> <amount>: Set a specific class population.
        ['/dei_set_pop '] = {
            help = function() return "[DEI] Set pop: /dei_set_pop <region> <class> <amount>" end,
            func = function(_cmd)
                local region, class_idx, amount = _cmd:match("/dei_set_pop%s+(%S+)%s+(%d+)%s+(%d+)")
                
                if not (region and class_idx and amount) then
                    return "Usage: /dei_set_pop <region_key> <class_idx> <amount>"
                end

                class_idx, amount = tonumber(class_idx), tonumber(amount)
                if class_idx < 1 or class_idx > 4 then
                    return "Error: class_idx must be between 1 and 4."
                end

                local success, message = update_region_pop(region, class_idx, amount)
                if not success then return message end

                return string.format("Set %s (Class %d) to %d.", region, class_idx, amount)
            end,
            exec = false,
            returns = true,
        },

        -- /dei_reset_region_pop <region_key>: Reset population for a specific region.
        ['/dei_reset_region_pop '] = {
            help = function() return "[DEI] Wipe region pop: /dei_reset_region_pop <region_key>" end,
            func = function(_cmd)
                local region = _cmd:match("/dei_reset_region_pop%s+(%S+)")
                
                if not region then
                    return "Usage: /dei_reset_region_pop <region_key>"
                end

                local success, message = update_region_pop(region, nil, 0)
                if not success then return message end

                return string.format("Region '%s' population reset to 0.", region)
            end,
            exec = false,
            returns = true,
        }
    }
}
