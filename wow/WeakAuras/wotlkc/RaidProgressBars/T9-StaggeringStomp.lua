-- Event(s): UNIT_SPELLCAST_START, CLEU:SPELL_CAST_START
function(event, ...)
    aura_env.metadata = aura_env.metadata or { }

    local last = aura_env.metadata.last or 0
    if GetTime() > last + 4 then
        local spellId = (event == 'UNIT_SPELLCAST_START' and select(3, ...)) or select(12, ...)
        if spellId == 66330 then
            aura_env.metadata.last = GetTime()
            return true
        end
    end
    return false
end
