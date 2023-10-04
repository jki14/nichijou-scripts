-- Trigger 1 / Custom / Event(s): UNIT_SPELLCAST_SUCCEEDED, FATAL_SHADOWCRASH
function(event, ...)
    local DefaultChatFrame = DefaultChatFrame or { AddMessage = function(...) end }

    local remain = 0
    if event == 'UNIT_SPELLCAST_SUCCEEDED' then
        local _, _, spellId = ...
        if spellId == 62660 then
            remain = 14
        end
    else
        remain = ...
    end
    if remain > 0 then
        remain = remain - 1
        local ft = UnitHealthMax('focustarget') or 0
        if ft < 30000 then
            local min_range, _ = WeakAuras.GetRange('focustarget')
            DefaultChatFrame:AddMessage('|cFFAD7FA8[FATAL_SHADOWCRASH] ' .. tostring(min_range))
            return not min_range or min_range <= 10
        end
        if remain > 0 then
            C_Timer.After(0.05, function()
                WeakAuras.ScanEvents('FATAL_SHADOWCRASH', remain)
            end)
        end
    end
    return false
end
