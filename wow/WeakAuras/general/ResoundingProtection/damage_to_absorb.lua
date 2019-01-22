function()
    for i = 1, 40 do
        local name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, nameplateShowAll, timeMod, value1, value2, value3 = UnitBuff("player", i, "HELPFUL")
        if spellId then
            if spellId == 269279 then
                local absorbAmount = value2 * 0.001
                return string.format("%.1fk", absorbAmount)
            end
        else
            break
        end
    end
end
