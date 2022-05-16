-- Trigger State Updater: Event(s): COMBAT_LOG_EVENT_UNFILTERED, MD_CONFLAGRATION
function(allstates, event, _, subevent, _, _, _, _, _, _, _, _, _, spellId, ...)
    if 'COMBAT_LOG_EVENT_UNFILTERED' == event and 'SPELL_CAST_START' == subevent and 45342 == spellId then
        C_Timer.After(0.2, function()
            WeakAuras.ScanEvents('MD_CONFLAGRATION', true)
        end)
    elseif 'MD_CONFLAGRATION' == event then
        local destGUID = UnitGUID('focustarget')
        local frame = wa_global and wa_global.mostDamaged and wa_global.mostDamaged.guidframes and wa_global.mostDamaged.guidframes[destGUID] or nil
        if frame then
            local duration = 3.3
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
