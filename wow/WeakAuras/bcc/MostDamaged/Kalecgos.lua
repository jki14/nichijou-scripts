-- Trigger State Updater: Event(s): COMBAT_LOG_EVENT_UNFILTERED, MD_KALECGOS
function(allstates, event, ...)
    local function update(allstates, unit, guid, spellId, tick)
        local name, _, _, _, duration, expirationTime = WA_GetUnitDebuff(unit, spellId)
        local show = name and expirationTime - GetTime() < 18.0
        local frame = show and wa_global and wa_global.mostDamaged and wa_global.mostDamaged.guidframes and wa_global.mostDamaged.guidframes[guid] or nil
        if show then
            if tick then
                C_Timer.After(0.2, function()
                    WeakAuras.ScanEvents('MD_KALECGOS', unit, guid, spellId)
                end)
            end
            if not allstates[guid] or not allstates[guid].show or allstates[guid].expirationTime ~= expirationTime then
                allstates[guid] = {
                    changed = true,
                    show = true,
                    name = unit,
                    progressType = 'timed',
                    duration = duration,
                    expirationTime = expirationTime,
                    autoHide = true,
                    anchor = frame
                }
                return true
            end
        else
            if allstates[guid] and allstates[guid].show then
                allstates[guid].changed = true
                allstates[guid].show = false
                return true
            end
        end
        return false
    end

    if 'COMBAT_LOG_EVENT_UNFILTERED' == event then
        local _, subevent, _, _, _, _, _, guid = ...
        if string.find(subevent, '^SPELL_PERIODIC_') or subevent == 'SPELL_AURA_REMOVED' then
            local spellId = select(12, ...)
            if spellId == 5416 or spellId == 45032 or spellId == 45034 then
                local unit = wa_global and wa_global.mostDamaged and wa_global.mostDamaged.guidunits and wa_global.mostDamaged.guidunits[guid] or nil
                if unit then
                    return update(allstates, unit, guid, spellId, true)
                end
            end
        end
    else
        local unit, guid, spellId = ...
        return update(allstates, unit, guid, spellId, false)
    end
    return false
end

-- Custom Anchor
function()
    return aura_env and aura_env.state and aura_env.state.anchor or nil
end
