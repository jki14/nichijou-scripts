-- Actions / On Init
LibBonus = { }
LibBonus.Check = function(name)
    wa_global = wa_global or { }
    wa_global.libbonus = wa_global.libbonus or { }
    if wa_global.libbonus[name] then
        return wa_global.libbonus[name]
    else
        local db = {
            ['T7F'] = {39553, 39556, 39554, 39557, 39555, 40473, 40494, 40471, 40472, 40493},
            ['T8F'] = {45356, 45359, 45358, 45355, 45357, 46161, 46157, 46159, 46158, 46160},
            ['T9F'] = {48188, 48191, 48189, 48192, 48190, 48194, 48197, 48196, 48193, 48195, 48201, 48198, 48199, 48202, 48200},
        }
        local cnt = 0
        if db[name] then
            for _, itemId in ipairs(db[name]) do
                if IsEquippedItem(itemId) then
                    cnt = cnt + 1
                end
            end
            wa_global.libbonus[name] = cnt
            DEFAULT_CHAT_FRAME:AddMessage('|cFFFFFFFF[LibBonus] The total matches for ' .. name .. ' is ' .. cnt .. '.')
        else
            DEFAULT_CHAT_FRAME:AddMessage('|cFFFFFFFF[LibBonus] No entry is found in the db for ' .. name .. '.')
        end

        wa_global.libbonus[name] = cnt
        return cnt
    end
end

-- Trigger 1 / Custom / Event: PLAYER_REGEN_DISABLED
function()
    wa_global = wa_global or { }
    wa_global.libbonus = nil
end
