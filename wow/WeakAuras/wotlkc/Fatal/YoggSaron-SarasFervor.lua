-- Trigger 1 / Custom / Event(s): UNIT_SPELLCAST_START, FATAL_FERVOR
function(event, ...)
    local DefaultChatFrame = DefaultChatFrame or { AddMessage = function(...) end }

    local remain = 0
    if event == 'UNIT_SPELLCAST_START' then
        local _, _, spellId = ...
        if spellId == 63138 or spellId == 63134 then
            remain = 14
        end
    else
        remain = ...
    end
    if remain > 0 then
        if UnitIsUnit('player', 'focustarget') then
            local min_range, _ = WeakAuras.GetRange('focustarget')
            DefaultChatFrame:AddMessage('|cFFAD7FA8[FATAL_FERVOR] It is on the player!')
            return true
        end
        if remain > 0 then
            C_Timer.After(0.10, function()
                WeakAuras.ScanEvents('FATAL_FERVOR', remain - 1)
            end)
        end
    end
    return false
end
