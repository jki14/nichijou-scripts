function()
    local DefaultChatFrame = DefaultChatFrame or { AddMessage = function(...) end }

    wa_global = wa_global or { }
    wa_global.debug = wa_global.debug or { }
    wa_global.debug.bear = wa_global.debug.bear or 0
    wa_global.debug.rage = wa_global.debug.rage or 0

    if 1 == GetShapeshiftForm() then
        local ts = GetTime()
        if ts > wa_global.debug.bear + 1.0 then
            DefaultChatFrame:AddMessage('|cFFFF7C0A[Debug] Shapeshift at ' .. tostring(ts))
        end
        wa_global.debug.bear = ts
    end

    if 5 <= UnitPower('player', 1) then
        local ts = GetTime()
        if ts > wa_global.debug.rage + 1.0 then
            DefaultChatFrame:AddMessage('|cFFFF7C0A[Debug] Furor at ' .. tostring(ts))
        end
        wa_global.debug.rage = ts
    end

    return false
end
