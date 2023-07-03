-- Actions / On Init
LibBonus = { }
LibBonus.Check = function(name)
    wa_global = wa_global or { }
    wa_global.libbonus = wa_global.libbonus or { }
    if wa_global.libbonus[name] then
        return wa_global.libbonus[name]
    else
        local cnt = 0
        if string.sub(name, 1, 1) == 'G' then
            local gid = tonumber(string.sub(name, 1 - string.len(name)))
            for i = 1, 6 do
                if select(3, GetGlyphSocketInfo(4)) == gid then
                    cnt = 1
                    break
                end
            end
            DEFAULT_CHAT_FRAME:AddMessage('|cFFFFFFFF[LibBonus] The count for ' .. name .. ' is ' .. cnt .. '.')
        else
            local db = {
                ['T7F'] = {39553, 39556, 39554, 39557, 39555, 40473, 40494, 40471, 40472, 40493},
                ['T8F'] = {45356, 45359, 45358, 45355, 45357, 46161, 46157, 46159, 46158, 46160},
                ['T9F'] = {48188, 48191, 48189, 48192, 48190, 48194, 48197, 48196, 48193, 48195, 48201, 48198, 48199, 48202, 48200},
                ['T9B'] = {48184, 48187, 48186, 48183, 48185, 48181, 48178, 48179, 48182, 48180, 48174, 48177, 48176, 48173, 48175},
            }
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
