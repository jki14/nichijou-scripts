-- Trigger: Custom / Event: COMBAT_LOG_EVENT_UNFILTERED
function(_, _, event, _, sourceGUID, _, _, _, destGUID, _, _, _, spellId, ...)
    if UnitGUID('player') == sourceGUID and 26993 == spellId then
        if event == 'SPELL_AURA_APPLIED' or event == 'SPELL_AURA_REFRESH' then
            return true
        end
    end
    return false
end

-- Custom Text
function()
    local p = aura_env.state.expirationTime and math.floor(aura_env.state.expirationTime - GetTime() - 7) or -1
    p = p >= 0 and tostring(p) or ''
    return p
end
