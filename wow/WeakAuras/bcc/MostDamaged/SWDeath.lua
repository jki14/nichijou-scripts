-- Trigger State Updater: Event(s): COMBAT_LOG_EVENT_UNFILTERED
function(allstates, _, _, event, _, sourceGUID, _, _, _, _, _, _, _, spellId, ...)
    if 'SPELL_CAST_SUCCESS' == event and 32996 == spellId then
        local frame = wa_global and wa_global.mostDamaged and wa_global.mostDamaged.guidframes and wa_global.mostDamaged.guidframes[sourceGUID] or nil
        if frame then
            local duration = 12
            allstates[sourceGUID] = {
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
