-- display
function ()
    if WA_FDS then
        return string.format("%i - %0.2fx", select(1, UnitAttackPower("player")) * (1.00 + GetCritChance() * 0.01) * WA_FDS.enhance.melee, WA_FDS.enhance.melee)
    else
        return "error"
    end
end

-- trigger
function(event, timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, ...)
    --
    if sourceGUID ~= UnitGUID("player") then
        return true
    end
    if type ~= "SPELL_AURA_APPLIED" and type ~= "SPELL_AURA_REFRESH" and type ~= "SPELL_MISSED" then
        return true
    end
    if spellId ~= 1079 and spellId ~= 106830 and spellId ~= 155722 and spellId ~= 155625 and spellId ~= 163505 then
        return true
    end
    --
    if WA_FDS then
        WA_FDS.enhance.melee = 1.00
        WA_FDS.enhance.range = 1.00
        WA_FDS.enhance.stealth = false
    else
        WA_FDS = {
            enhance = {
                melee = 1.00,
                range = 1.00,
                stealth = false
            },
            record = {},
            last_srake = 0.0
        }
    end
    local buffs = {}
    buffs[5217] = 1.15 -- Tigers Fury
    buffs[145152] = 1.25 -- Bloodtalons
    for i = 1, 40 do
        local buffId = select(10, UnitBuff("player", i, "HELPFUL"))
        if buffId then
            if buffs[buffId] then
                WA_FDS.enhance.melee = WA_FDS.enhance.melee * buffs[buffId]
            end
            if buffId == 5217 then
                WA_FDS.enhance.range = WA_FDS.enhance.range * buffs[buffId]
            end
            if buffId == 102543 then
                WA_FDS.enhance.stealth = true
            end
        else
            break
        end
    end
    -- 
    if sourceGUID == UnitGUID("player") then
        if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
            if spellId == 1079 then
                -- Rip
                WA_FDS.record[spellId] = WA_FDS.record[spellId] or {}
                WA_FDS.record[spellId][destGUID] = WA_FDS.enhance.melee
            elseif spellId == 106830 then
                -- Thrash
                WA_FDS.record[spellId] = WA_FDS.record[spellId] or {}
                WA_FDS.record[spellId][destGUID] = WA_FDS.enhance.melee
            elseif spellId == 155722 then
                -- Rake
                local score = WA_FDS.enhance.melee
                if WA_FDS.enhance.stealth or timestamp - WA_FDS.last_srake < 0.5 then
                    score = score * 2.0
                end
                WA_FDS.record[spellId] = WA_FDS.record[spellId] or {}
                WA_FDS.record[spellId][destGUID] = score
            elseif spellId == 155625 then
                -- Moonfire
                WA_FDS.record[spellId] = WA_FDS.record[spellId] or {}
                WA_FDS.record[spellId][destGUID] = WA_FDS.enhance.range
            end
        end
        if spellId == 163505 then
            if type == "SPELL_MISSED" or type == "SPELL_AURA_APPLIED" then
                WA_FDS.last_srake = timestamp
            end
        end
    end
    return true
end
