-- Trigger 1: Custom / Status / Every Frame
function()
    local currts = GetTime()

    local holdts = wa_global and wa_global.balanRaid and wa_global.balanRaid.holdts or 0
    if currts < holdts then
        return false
    end

    local colors = {
        {0.00, 0.50, 1.00}, -- 1
        {0.00, 0.82, 1.00}, -- 2
        {0.10, 0.10, 0.98}, -- 3
        {0.30, 0.52, 0.90}, -- 4
        {0.40, 0.00, 0.80}, -- 5
        {0.50, 0.32, 0.55}, -- 6
        {0.52, 1.00, 0.52}, -- 7
        {0.71, 1.00, 0.92}, -- 8
        {0.788, 0.259, 0.992}, -- 9
        {0.80, 0.60, 0.00}, -- 10
        {0.95, 0.90, 0.60}, -- 11
        {1.00, 1.00, 0.00},  -- 12
        {0.00, 0.00, 0.00}, -- 0
        {0.50, 1.00, 0.00}, -- 14
        {0.82, 1.00, 0.00}, -- 15
        {0.10, 0.98, 0.10}, -- 16
        {0.52, 0.90, 0.30}, -- 17
        {0.00, 0.80, 0.40}, -- 18
        {0.32, 0.55, 0.50}, -- 19
        {1.00, 0.52, 0.52}, -- 20
    }

    if not IsMouseButtonDown('Button4') and not IsMouseButtonDown('Button5') then
        aura_env.region:Color(unpack(colors[13]))
        return false
    end

    local function spell_ready(spellId)
        local start, duration = GetSpellCooldown(spellId)
        return start + duration
    end

    local castts = math.max(spell_ready(8921), currts)
    local endMs = select(6, UnitCastingInfo('player'))
    if endMs then
        castts = math.max(castts, endMs / 1000.0)
    end

    if currts < castts - 0.20 then
        aura_env.region:Color(unpack(colors[13]))
        return false
    end

    local target = UnitGUID('target')
    if not target then
        aura_env.region:Color(unpack(colors[13]))
        return false
    end

    local npcId = select(6, strsplit("-", target))
    local noaction = {
        -- ['31146'] = 'Heroic Training Dummy',
        ['33488'] = 'Saronite Vapors',
    }
    if noaction[npcId] then
        aura_env.region:Color(unpack(colors[13]))
        return false
    end

    local iff_expire = wa_global and wa_global.balanRaid and wa_global.balanRaid.iffs and wa_global.balanRaid.iffs[target] or 0
    local insect_expire = wa_global and wa_global.balanRaid and wa_global.balanRaid.insects and wa_global.balanRaid.insects[target] or 0
    local moonfire_expire = wa_global and wa_global.balanRaid and wa_global.balanRaid.moonfires and wa_global.balanRaid.moonfires[target] or 0
    local mftick1 = wa_global and wa_global.balanRaid and wa_global.balanRaid.mftick1 and wa_global.balanRaid.mftick1[target] or 2147483647

    local lunar_expire = wa_global and wa_global.balanRaid and wa_global.balanRaid.lunar or 0
    local solar_expire = wa_global and wa_global.balanRaid and wa_global.balanRaid.solar or 0
    local elune_expire = wa_global and wa_global.balanRaid and wa_global.balanRaid.elune or 0
    local whide_expire = wa_global and wa_global.balanRaid and wa_global.balanRaid.whide or 0

    local next_wrath = castts + select(7, GetSpellInfo(48461)) / 1000
    local next_starfire = castts + select(7, GetSpellInfo(48465)) / 1000

    if castts + 3.0 > iff_expire and -1 == UnitLevel('target') then
        aura_env.region:Color(unpack(colors[5]))
        return false
    end

    local spell_gcd = select(7, GetSpellInfo(53308)) / 1000

    local phase3 = LibBonus.Check('T9B') >= 2

    if castts < elune_expire and castts + math.max(spell_gcd, 1.2) > elune_expire then
        aura_env.region:Color(unpack(colors[2]))
        return false
    elseif castts < whide_expire and castts + math.max(spell_gcd, 1.2) > whide_expire and IsMouseButtonDown('Button4') then
        aura_env.region:Color(unpack(colors[2]))
        return false
    end

    if next_wrath < solar_expire and IsMouseButtonDown('Button4') then
        local sp = GetSpellBonusDamage(7)
        local sbase = (1130 + 165 + sp * 1.2) / math.max(spell_gcd * 2.0, 1.0)
        local wbase = (592 + sp * 0.671) * (1.40 + (LibBonus.Check('T8B') >= 2 and 0.07 or 0))
        if wbase < sbase then
            aura_env.region:Color(unpack(colors[2]))
            return false
        end
    end

    local ending = UnitHealth('target')
    if ending then
        ending = GetTime() + ending / math.max(wa_global and wa_global.DTPS and wa_global.DTPS[target] and wa_global.DTPS[target][math.floor(time() / 5.0) - 1] or 0, 5000)
    else
        ending = 2147483647
    end

    if phase3 then
        if castts > moonfire_expire then
            aura_env.region:Color(unpack(colors[4]))
            return false
        end
    else
        -- if castts > insect_expire and (next_starfire > lunar_expire or castts + 9.524 < lunar_expire or not IsMouseButtonDown('Button4')) then
        if castts > insect_expire and ((castts + 10 < ending and (next_starfire > lunar_expire or castts + 7.143 < lunar_expire)) or (castts + 4 < ending and not IsMouseButtonDown('Button4'))) then
            aura_env.region:Color(unpack(colors[3]))
            return false
        end
    end

    if castts < elune_expire and not IsMouseButtonDown('Button4') then
        aura_env.region:Color(unpack(colors[2]))
        return false
    end

    if phase3 then
        if castts > insect_expire and not IsMouseButtonDown('Button4') then
            aura_env.region:Color(unpack(colors[3]))
            return false
        end
    else
        if castts > moonfire_expire and not IsMouseButtonDown('Button4') then
            aura_env.region:Color(unpack(colors[4]))
            return false
        end
    end

    if IsMouseButtonDown('Button4') then
        if next_wrath < solar_expire then
            aura_env.region:Color(unpack(colors[1]))
            return false
        elseif next_starfire < lunar_expire then
            if castts + 12 < lunar_expire or castts + 15 > ending then
                local noseven = {
                    -- ['31146'] = 'Heroic Training Dummy',
                    ['32927'] = 'Runemaster Molgeim',
                }
                if IsMouseButtonDown('Button4') and IsMouseButtonDown('Button5') then
                    aura_env.region:Color(unpack(colors[8]))
                    return false
                else
                    aura_env.region:Color(unpack(colors[noseven[npcId] and 2 or 7]))
                    return false
                end
            else
                aura_env.region:Color(unpack(colors[2]))
                return false
            end
        elseif next_wrath < lunar_expire + 15 then
            aura_env.region:Color(unpack(colors[2]))
            return false
        else
            aura_env.region:Color(unpack(colors[1]))
            return false
        end
    else
        if phase3 and castts > mftick1 then
            aura_env.region:Color(unpack(colors[4]))
        else
            aura_env.region:Color(unpack(colors[6]))
        end
        return false
    end

    aura_env.region:Color(unpack(colors[13]))
    return false
end

-- Trigger 2: Custom / Event: COMBAT_LOG_EVENT_UNFILTERED
function(_, _, event, sourceGUID, _, _, destGUID, _, _, spellId, ...)
    if UnitGUID('player') == sourceGUID then
        if 48518 == spellId then
            -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFFF468[TG-BalanRaid] Lunar Eclipse found with ' .. event .. '.')
            if event == 'SPELL_AURA_APPLIED' then
                wa_global = wa_global or { }
                wa_global.balanRaid = wa_global.balanRaid or { }
                wa_global.balanRaid.lunar = GetTime() + 15
            end
        elseif 48517 == spellId then
            -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFFF468[TG-BalanRaid] Solar Eclipse found with ' .. event .. '.')
            if event == 'SPELL_AURA_APPLIED' then
                wa_global = wa_global or { }
                wa_global.balanRaid = wa_global.balanRaid or { }
                wa_global.balanRaid.solar = GetTime() + 15
            end
        elseif 64823 == spellId then
            -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFFF468[TG-BalanRaid] Elune\'s Wrath found with ' .. event .. '.')
            if event == 'SPELL_AURA_APPLIED' or event == 'SPELL_AURA_REFRESH' then
                wa_global = wa_global or { }
                wa_global.balanRaid = wa_global.balanRaid or { }
                wa_global.balanRaid.elune = GetTime() + 10
            elseif event == 'SPELL_AURA_REMOVED' then
                wa_global = wa_global or { }
                wa_global.balanRaid = wa_global.balanRaid or { }
                wa_global.balanRaid.elune = nil
            end
        elseif 46833 == spellId then
            -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFFF468[TG-BalanRaid] Wrath of Elune found with ' .. event .. '.')
            if event == 'SPELL_AURA_APPLIED' or event == 'SPELL_AURA_REFRESH' then
                wa_global = wa_global or { }
                wa_global.balanRaid = wa_global.balanRaid or { }
                wa_global.balanRaid.whide = GetTime() + 15
            elseif event == 'SPELL_AURA_REMOVED' then
                wa_global = wa_global or { }
                wa_global.balanRaid = wa_global.balanRaid or { }
                wa_global.balanRaid.whide = nil
            end
        elseif 48468 == spellId then
            -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFFF468[TG-BalanRaid] Insect Swarm found with ' .. event .. '.')
            if event == 'SPELL_AURA_APPLIED' or event == 'SPELL_AURA_REFRESH' then
                wa_global = wa_global or { }
                wa_global.balanRaid = wa_global.balanRaid or { }
                wa_global.balanRaid.insects = wa_global.balanRaid.insects or { }
                wa_global.balanRaid.insects[destGUID] = GetTime() + 14
            elseif event == 'SPELL_AURA_REMOVED' then
                wa_global = wa_global or { }
                wa_global.balanRaid = wa_global.balanRaid or { }
                wa_global.balanRaid.insects = wa_global.balanRaid.insects or { }
                wa_global.balanRaid.insects[destGUID] = nil
            end
        elseif 48463 == spellId then
            -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFFF468[TG-BalanRaid] Moonfire found with ' .. event .. '.')
            if event == 'SPELL_AURA_APPLIED' or event == 'SPELL_AURA_REFRESH' then
                wa_global = wa_global or { }
                wa_global.balanRaid = wa_global.balanRaid or { }
                wa_global.balanRaid.moonfires = wa_global.balanRaid.moonfires or { }
                if destGUID == UnitGUID('target') then
                    local _, _, _, _, _, _, expirationTime = WA_GetUnitDebuff('target', 48463, 'PLAYER')
                    wa_global.balanRaid.moonfires[destGUID] = expirationTime
                else
                    wa_global.balanRaid.moonfires[destGUID] = GetTime() + 15
                end
                wa_global.balanRaid.mftick1 = wa_global.balanRaid.mftick1 or { }
                wa_global.balanRaid.mftick1[destGUID] = wa_global.balanRaid.moonfires[destGUID] - 12
            elseif event == 'SPELL_AURA_REMOVED' then
                wa_global = wa_global or { }
                wa_global.balanRaid = wa_global.balanRaid or { }
                wa_global.balanRaid.moonfires = wa_global.balanRaid.moonfires or { }
                wa_global.balanRaid.moonfires[destGUID] = nil
                wa_global.balanRaid.mftick1 = wa_global.balanRaid.mftick1 or { }
                wa_global.balanRaid.mftick1[destGUID] = nil
            end
        elseif 48465 == spellId then
            if event == 'SPELL_DAMAGE' then
                if wa_global and wa_global.balanRaid and wa_global.balanRaid.moonfires and wa_global.balanRaid.moonfires[destGUID] and wa_global.balanRaid.moonfires[destGUID] > GetTime() then
                    if wa_global.balanRaid.gstars and wa_global.balanRaid.gstars > 0 then
                        -- wa_global.balanRaid.moonfires[destGUID] = wa_global.balanRaid.moonfires[destGUID] + 3
                        wa_global.balanRaid.gstars = wa_global.balanRaid.gstars - 1
                        WeakAuras.ScanEvents('BALAN_GSTARS_UPDATED')
                    end
                end
            end
        end
    end

    if 770 == spellId or 16857 == spellId then
        -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFFF468[TG-BalanRaid] Improved Faerie Fire found with ' .. event .. '.')
        if event == 'SPELL_AURA_APPLIED' or event == 'SPELL_AURA_REFRESH' then
            wa_global = wa_global or { }
            wa_global.balanRaid = wa_global.balanRaid or { }
            wa_global.balanRaid.iffs = wa_global.balanRaid.iffs or { }
            wa_global.balanRaid.iffs[destGUID] = GetTime() + 300
        elseif event == 'SPELL_AURA_REMOVED' then
            wa_global = wa_global or { }
            wa_global.balanRaid = wa_global.balanRaid or { }
            wa_global.balanRaid.iffs = wa_global.balanRaid.iffs or { }
            wa_global.balanRaid.iffs[destGUID] = nil
        end
    end

    return false
end

-- Trigger 3: Custom / Event: UNIT_SPELLCAST_SUCCEEDED
function(_, unit, spellId)
    if unit == 'player' and (spellId == 'Moonfire' or spellId == 'æœˆç«æœ¯') and LibBonus.Check('G54845') >= 1 then
        wa_global = wa_global or { }
        wa_global.balanRaid = wa_global.balanRaid or { }
        wa_global.balanRaid.gstars = 3
        WeakAuras.ScanEvents('BALAN_GSTARS_UPDATED')
    end
    return false
end
