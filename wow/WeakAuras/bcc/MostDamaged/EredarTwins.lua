-- Trigger State Updater: Event(s): COMBAT_LOG_EVENT_UNFILTERED
function(allstates, _, _, event, _, _, _, _, _, destGUID, _, _, _, spellId, ...)
    destGUID = destGUID or UnitGUID('focustarget')
    if 'SPELL_CAST_START' == event and 45342 == spellId then
        local frame = wa_global and wa_global.mostDamaged and wa_global.mostDamaged.guidframes and wa_global.mostDamaged.guidframes[destGUID] or nil
        if frame then
            local duration = 3.5
            allstates[destGUID] = {
                changed = true,
                show = true,
                name = '',
                progressType = 'timed',
                duration = duration,
                expirationTime = GetTime() + duration,
                autoHide = true,
                anchor = frame
            }
            return true
        end
    end
    return false
end

-- Custom Anchor
function()
    return aura_env and aura_env.state and aura_env.state.anchor or nil
end
