--trigger state updater: event(s): UNIT_SPELLCAST_SUCCEEDED
function(allstates, event, unitTarget, castGUID, spellID)
    local icons = {}
    icons[2457] = 132349
    icons[2458] = 132275
    icons[71] = 132341
    if icons[spellID] and string.sub(unitTarget, 1, 5) == 'arena' then
        allstates[unitTarget] = {
            changed = true,
            show = true,
            name = unitTarget,
            progressType = "static",
            value = 1,
            total = 1,
            icon = icons[spellID],
            autoHide = false
        }
        return true
    end
    return false
end

--trigger state updater: event(s): ARENA_OPPONENT_UPDATE
function(allstates, event, token, reason)
    if allstates[token] and select(3, UnitClass(token)) ~= 1 then
        allstates[toekn].show = false
        allstates[toekn].changed = true
        return true
    end
    return false
end
