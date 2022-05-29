-- Trigger State Updater: Event(s): UNIT_SPELLCAST_START, MD_CONFLAGRATION
function(allstates, event, ...)
    if 'UNIT_SPELLCAST_START' == event then
        local unit, token, spellId = ...
        if spellId == 45342 or spellId == 5401 and string.find(unit, '^nameplate') then
            C_Timer.After(0.2, function()
                WeakAuras.ScanEvents('MD_CONFLAGRATION', token, unit .. 'target')
            end)
        end
    else
        local token, dest = ...
        local guid = UnitGUID(dest)
        local frame = wa_global and wa_global.mostDamaged and wa_global.mostDamaged.guidframes and wa_global.mostDamaged.guidframes[guid] or nil
        if frame and not allstates[token] then
            local duration = 3.5 - 0.2
            allstates[token] = {
                changed = true,
                show = true,
                name = token,
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
