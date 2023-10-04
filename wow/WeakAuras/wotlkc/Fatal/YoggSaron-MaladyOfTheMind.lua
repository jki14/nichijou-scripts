-- Trigger 1 / Custom / Event(s): FATAL_MINDMALADY, CLEU:SPELL_AURA_APPLIED
function(event, ...)
    local DefaultChatFrame = DefaultChatFrame or { AddMessage = function(...) end }

    local unit, remain = nil, 0
    if event == 'COMBAT_LOG_EVENT_UNFILTERED' then
        local _, subevent, _, _, _, _, _, _, destName, _, _, spellId = ...
        if subevent == 'SPELL_AURA_APPLIED' then
            local debuffs = {
                -- [48441] = 40, -- Rejuvenation
                [63830] = 40, -- Malady of the Mind
                [63881] = 40, -- Malady of the Mind
            }
            unit = destName
            remain = spellId and debuffs[spellId] or 0
        end
    else
        unit, remain = ...
    end
    if unit and remain > 0 then
        C_Timer.After(0.1, function()
            WeakAuras.ScanEvents('FATAL_MINDMALADY', unit, remain - 1)
        end)
        local min_range, _ = WeakAuras.GetRange(unit)
        if remain % 10 == 0 then
            DefaultChatFrame:AddMessage('|cFFAD7FA8[FATAL_MINDMALADY] ' .. unit .. ' (' .. tostring(min_range) .. ', ' .. tostring(remain) .. ')')
        end
        return not min_range or min_range <= 10
    end
    return false
end

-- Trigger 1 / Custom Untrigger
function(event, ...)
    if event == 'FATAL_MINDMALADY' then
        local unit, remain = ...
        local min_range, _ = WeakAuras.GetRange(unit)
        return remain == 0 or (min_range and min_range > 10)
    end
    return false
end
