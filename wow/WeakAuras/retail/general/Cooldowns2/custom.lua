function()
    local spellId = 18562
    local charged = select(1, GetSpellCharges(spellId))
    if charged == nil then
        local start, duration, enabled, modRate = GetSpellCooldown(spellId)
        if duration == 0 then
            charged = 1
        else
            charged = 0
        end
    end
    if charged > 0 then
        return charged
    else
        return ''
    end
end
