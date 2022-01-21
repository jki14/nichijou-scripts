function()
    local unit = IsControlKeyDown() and 'focus' or 'target'
    local casttime = select(4, GetSpellInfo(33786))
    local expirationTime = select(6, WA_GetUnitDebuff(unit, 33786))
    if casttime and expirationTime then
        return GetTime() + casttime * 0.001 <= expirationTime
    end
    return false
end
