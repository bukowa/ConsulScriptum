-- ---------------------------------------------------------------------------------------------------------------------
-- CONSUL SCRIPTUM DEI MOD COMMANDS
-- ---------------------------------------------------------------------------------------------------------------------

return {
    exact = {
        -- 1. Reset all regions to zero
        ['/dei_reset_all_pop'] = {
            help = function() return "[DEI] Wipe population of all regions to 0." end,
            func = function()
                local region_list = consul._game():model():world():region_manager():region_list()
                for i = 0, region_list:num_items() - 1 do
                    local name = region_list:item_at(i):name()
                    DEAI.fn_get_region_table()[name] = {0, 0, 0, 0}
                    DEAI.fn_get_uipopulation()[name] = {0, 0, 0, 0}
                end
                return "pop reset ok"
            end,
            exec = false,
            returns = true,
        }
    },
    
    starts_with = {
        -- 2. Set specific population class for a region
        -- Format: /dei_set_pop <region_key> <class_idx> <amount>
        ['/dei_set_pop '] = {
            help = function() return "[DEI] Set pop: /dei_set_pop <region> <class> <amount>" end,
            func = function(_cmd)
                local region, class_idx, amount = _cmd:match("/dei_set_pop%s+(%S+)%s+(%d+)%s+(%d+)")
                if region and class_idx and amount then
                    class_idx = tonumber(class_idx)
                    amount = tonumber(amount)
                    local reg_table = DEAI.fn_get_region_table()
                    local ui_table = DEAI.fn_get_uipopulation()
                    if reg_table[region] then reg_table[region][class_idx] = amount end
                    if ui_table[region] then ui_table[region][class_idx] = amount end
                    return "Set " .. region .. " class " .. class_idx .. " to " .. amount
                end
                return "Usage: /dei_set_pop <region_key> <class_idx> <amount>"
            end,
            exec = false,
            returns = true,
        },
        
        -- 3. Reset population for a specific region
        -- Format: /dei_reset_region_pop <region_key>
        ['/dei_reset_region_pop '] = {
            help = function() return "[DEI] Wipe region pop: /dei_reset_region_pop <region_key>" end,
            func = function(_cmd)
                local region = _cmd:match("/dei_reset_region_pop%s+(%S+)")
                if region then
                    local reg_table = DEAI.fn_get_region_table()
                    local ui_table = DEAI.fn_get_uipopulation()
                    if reg_table[region] then
                        reg_table[region] = {0, 0, 0, 0}
                        ui_table[region] = {0, 0, 0, 0}
                        return "Reset population for " .. region
                    end
                    return "Region '" .. region .. "' not found."
                end
                return "Usage: /dei_reset_region_pop <region_key>"
            end,
            exec = false,
            returns = true,
        }
    }
}
