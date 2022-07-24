-- Event(s): COMBAT_LOG_EVENT_UNFILTERED
function(event, ...)
    wa_global = wa_global or { }

    local _, _, _, _, _, _, _, guid, _, _, _, spellId = ...
    if spellId == 45185 and guid then
        if guid == UnitGUID('player') then
            wa_global.stomp = '>> HOLD <<'
            aura_env.region:Color(1.0, 0.0, 0.0)
        else
            wa_global.stomp = '>> READY <<'
            aura_env.region:Color(0.0, 1.0, 0.0)
        end
    end

    return true
end
