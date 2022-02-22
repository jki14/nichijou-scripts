-- Trigger Customer Event: COMBAT_LOG_EVENT_UNFILTERED
function(_, _, event, _, _, _, _, _, destGUID, _, _, _, spellId, ...)
    if event ~= 'SPELL_AURA_REMOVED' or UnitGUID('player') ~= destGUID then
        return false
    end

    local kidneyshots = {
        [408]   = "kidney_shot",         -- Kidney Shot (Rank 1)
        [8643]  = "kidney_shot",         -- Kidney Shot (Rank 2)
    }
    if kidneyshots[spellId] then
        return true
    end

    return false
end
