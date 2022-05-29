-- Event(s): UNIT_SPELLCAST_START, F_CONFLAGRATION
function(event, ...)
    if 'UNIT_SPELLCAST_START' == event then
        local unit, _, spellId = ...
        if spellId == 45342 or spellId == 5401 then
            C_Timer.After(0.1, function()
                WeakAuras.ScanEvents('F_CONFLAGRATION', unit .. 'target')
            end)
        end
    else
        local dest = ...
        return UnitIsUnit('player', dest)
    end
    return false
end
