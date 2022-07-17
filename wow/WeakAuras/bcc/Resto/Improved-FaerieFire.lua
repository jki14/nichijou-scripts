-- Trigger State Updater: Event(s): COMBAT_LOG_EVENT_UNFILTERED, ENCOUNTER_START
-- PLAYER_REGEN_DISABLED
function(allstates, event, ...)
    if event == 'COMBAT_LOG_EVENT_UNFILTERED' then
        local _, subevent, _, sourceGUID, _, _, _, destGUID, _, _, _, spellId = ...
        if UnitGUID('player') == sourceGUID and 26993 == spellId then
            if subevent == 'SPELL_AURA_APPLIED' or subevent == 'SPELL_AURA_REFRESH' then
                allstates[''] = {
                    changed = true,
                    show = true,
                    name = 'ImprovedFaerieFire',
                    progressType = 'timed',
                    duration = 47,
                    expirationTime = GetTime() + 47,
                    autoHide = true
                }
                return true
            end
        end
    else
        allstates[''] = {
            changed = true,
            show = true,
            name = 'ImprovedFaerieFire',
            progressType = 'timed',
            duration = 14,
            expirationTime = GetTime() + 14,
            autoHide = true
        }
        return true
    end
    return false
end

-- Custom Variables
{
    expirationTime = true,
    duration = true
}

-- Custom Text
function()
    local p = aura_env.state.expirationTime and math.floor(aura_env.state.expirationTime - GetTime() - 7) or -1
    p = tostring(p)
    return p
end
