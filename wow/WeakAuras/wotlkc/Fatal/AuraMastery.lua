--trigger state updater: event(s): UNIT_SPELLCAST_SUCCEEDED, COMBAT_LOG_EVENT_UNFILTERED
function(allstates, event, ...)
    local pa_auras = {
        -- [48441] = 136081, -- Dummy
        [19746] = 135933, -- Concentration Aura
    }
    if event == 'UNIT_SPELLCAST_SUCCEEDED' then
        local unit, _, spellId = ...
        if spellId == 31821 then
        -- if spellId == 18562 then
            local guid = UnitGUID(unit)
            allstates[guid] = {
                changed = true,
                show = false,
                progressType = 'timed',
                duration = 6,
                expirationTime = GetTime() + 6,
                name = guid .. '_aura-mastery',
                icon = 135872,
                autoHide = true,
            }
            for i = 1, 40 do
                local _, icon, _, _, _, _, source, _, _, spellId = UnitBuff('player', i)
                if not spellId then
                    break
                end
                if pa_auras[spellId] and UnitGUID(source) == guid then
                    allstates[guid].show = true
                    allstates[guid].icon = icon
                end
            end
            return true
        end
    else
        --[[
        local subevent = select(2, ...)
        if subevent == 'SPELL_AURA_REMOVED' or subevent == 'SPELL_AURA_APPLIED' then
            local _, _, _, src, _, _, _, dst, _, _, _, spellId = ...
            if pa_auras[spellId] and dst == UnitGUID('player') and allstates[src] then
                allstates[src].changed = true
                allstates[src].show = allstates[src].expirationTime > GetTime() and subevent == 'SPELL_AURA_APPLIED'
                allstates[src].icon = pa_auras[spellId]
                return true
            end
        end
        --]]
    end
    return false
end
