--trigger state updater: event(s): UNIT_SPELLCAST_SUCCEEDED, COMBAT_LOG_EVENT_UNFILTERED
function(allstates, event, ...)
    local pa_auras = {
        -- [48441] = 136081, -- Dummy
        -- [48451] = 134206, -- Dummy
        [19746] = 135933, -- Concentration Aura
        [32223] = 135890, -- Crusader Aura
        [54043] = 135873, -- Retribution Aura (Rank 7)
        [48942] = 135893, -- Devotion Aura (Rank 10)
        [48947] = 135824, -- Fire Resistance Aura (Rank 5)
        [48945] = 135865, -- Frost Resistance Aura (Rank 5)
        [48943] = 136192, -- Shadow Resistance Aura (Rank 5)
    }
    if event == 'UNIT_SPELLCAST_SUCCEEDED' then
        local unit, _, spellId = ...
        -- if spellId == 18562 then
        if spellId == 31821 then
            local guid = UnitGUID(unit)
            allstates[guid] = {
                changed = true,
                show = true,
                progressType = 'timed',
                duration = 6,
                expirationTime = GetTime() + 6,
                name = guid .. '_aura-mastery',
                icon = 135872,
                autoHide = true,
                stacks = 1,
            }
            for i = 1, 40 do
                local _, _, _, _, _, _, source, _, _, spellId = UnitBuff('player', i)
                if not spellId then
                    break
                end
                if pa_auras[spellId] and UnitGUID(source) == guid then
                    allstates[guid].icon = pa_auras[spellId]
                    break
                end
            end
            -- allstates[guid].stacks = allstates[guid].icon == 136081 and 2 or 1
            allstates[guid].stacks = allstates[guid].icon == 135933 and 2 or 1
            return true
        end
    else
        local subevent = select(2, ...)
        if subevent == 'SPELL_AURA_REMOVED' or subevent == 'SPELL_AURA_APPLIED' then
            local _, _, _, src, _, _, _, dst, _, _, _, spellId = ...
            if pa_auras[spellId] and dst == UnitGUID('player') and allstates[src] then
                DEFAULT_CHAT_FRAME:AddMessage('|cFFF48CBA[AURA_MASTERY] src = ' .. src .. ', dst = ' .. dst .. ', spellId = ' .. tostring(spellId))
                if subevent == 'SPELL_AURA_REMOVED' then
                    if allstates[src].icon == pa_auras[spellId] then
                        allstates[src].changed = true
                        allstates[src].icon = 135872
                    end
                else
                    allstates[src].changed = true
                    allstates[src].icon = pa_auras[spellId]
                end
                -- allstates[src].stacks = allstates[src].icon == 136081 and 2 or 1
                allstates[src].stacks = allstates[src].icon == 135933 and 2 or 1
                return true
            end
        end
    end
    return false
end


--custom variables
{
    stacks = true,
}
