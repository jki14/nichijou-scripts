-- Trigger Customer Event: COMBAT_LOG_EVENT_UNFILTERED
function(_, _, event, _, _, _, _, _, destGUID, _, _, _, spellId, ...)
    if event ~= 'SPELL_AURA_REMOVED' or UnitGUID('player') ~= destGUID then
        return false
    end

    local polymorphs = {
        [118]   = "incapacitate", -- Polymorph (Rank 1)
        [12824] = "incapacitate", -- Polymorph (Rank 2)
        [12825] = "incapacitate", -- Polymorph (Rank 3)
        [12826] = "incapacitate", -- Polymorph (Rank 4)
        [28271] = "incapacitate", -- Polymorph: Turtle
        [28272] = "incapacitate", -- Polymorph: Pig
    }
    if polymorphs[spellId] then
        return true
    end

    return false
end
