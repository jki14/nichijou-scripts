--trigger custom event: UNIT_SPELLCAST_SUCCEEDED
function(e, unitTarget, castGUID, spellID)
    if unitTarget == 'target' then
        aura_env.icon = select(3, GetSpellInfo(spellID))
        return true
    end
    return false
end

--icon info
function()
    return aura_env.icon
end

--trigger state updater: event(s): UNIT_SPELLCAST_SUCCEEDED
function(allstates, event, unitTarget, castGUID, spellID)
    if unitTarget == 'target' then
        local duration = 4
        allstates[castGUID] = {
            changed = true,
            show = true,
            progressType = "timed",
            duration = duration,
            expirationTime = GetTime() + duration,
            icon = select(3, GetSpellInfo(spellID)),
            autoHide = true
        }
        return true
    end
    return false
end
