-- Trigger 1: Custom / Status / Every Frame
function()
    local currts = GetTime()

    local holdts = wa_global and wa_global.feralRaid and wa_global.feralRaid.holdts or 0
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

    local castts = math.max(spell_ready(48572), currts)
    if currts < castts - 0.50 then
        aura_env.region:Color(unpack(colors[13]))
        return false
    end

    local target = UnitGUID('target')
    if not target then
        aura_env.region:Color(unpack(colors[13]))
        return false
    end

    local power = UnitPower('player', 3) + 2
    local rage = UnitPower('player', 1)
    local combo = GetComboPoints('player', 'target')

    local berserk_expire = wa_global and wa_global.feralRaid and wa_global.feralRaid.berserk or 0
    local roar_expire = wa_global and wa_global.feralRaid and wa_global.feralRaid.roar or 0
    local rip_expire = wa_global and wa_global.feralRaid and wa_global.feralRaid.rips and wa_global.feralRaid.rips[target] or 0
    local rake_expire = wa_global and wa_global.feralRaid and wa_global.feralRaid.rakes and wa_global.feralRaid.rakes[target] or 0
    local mangle_expire = wa_global and wa_global.feralRaid and wa_global.feralRaid.mangles and wa_global.feralRaid.mangles[target] or 0
    local faerie_expire = wa_global and wa_global.feralRaid and wa_global.feralRaid.ffs and wa_global.feralRaid.ffs[target] or 0
    local lacerate_expire = wa_global and wa_global.feralRaid and wa_global.feralRaid.lacerates and wa_global.feralRaid.lacerates[target] and wa_global.feralRaid.lacerates[target][1] or 0
    local lacerate_stacks = wa_global and wa_global.feralRaid and wa_global.feralRaid.lacerates and wa_global.feralRaid.lacerates[target] and wa_global.feralRaid.lacerates[target][2] or 0
    local clarity_expire = wa_global and wa_global.feralRaid and wa_global.feralRaid.clearcasting or 0

    local ending = 2147483647
    if wa_global and wa_global.DTPS and wa_global.DTPS[target] then
        local prev = math.floor(time() / 5.0) - 1
        local dt = wa_global.DTPS[target] and wa_global.DTPS[target][prev]
        if dt and dt > 0 then
            local remain = UnitHealth('target')
            if remain then
                ending = GetTime() + remain / dt
            end
        end
    end

    local rip_more = math.max(rip_expire, castts) + 10 < ending

    local low_mode = IsRightControlKeyDown()

    if 1 == GetShapeshiftForm() and IsEquippedItem(38365) then
        -- Guard
        if lacerate_stacks >= 1 and lacerate_expire < castts + 4.6 then
            -- Lacerate (Refresh)
            local cost = select(4, GetSpellInfo(48568))
            if cost <= rage and currts > castts - 0.16 then
                aura_env.region:Color(unpack(colors[8]))
                return false
            end
        elseif spell_ready(48564) < castts + 0.1 then
            -- MangleB
            local cost = select(4, GetSpellInfo(48564))
            if cost <= rage and currts > castts - 0.16 then
                aura_env.region:Color(unpack(colors[10]))
                return false
            end
        elseif IsMouseButtonDown('Button4') and IsMouseButtonDown('Button5') and spell_ready(50334) < castts + 0.1 then
            -- Berserk
            aura_env.region:Color(unpack(colors[12]))
            return false
        elseif spell_ready(16857) < castts + 0.1 and currts > castts - 0.16 then
            -- Faerie Fire (Feral)
            aura_env.region:Color(unpack(colors[11]))
            return false
        elseif lacerate_stacks < 5 and currts > castts - 0.16 then
            -- Lacerate (Stack)
            local cost = select(4, GetSpellInfo(48568))
            if cost <= rage then
                aura_env.region:Color(unpack(colors[8]))
                return false
            end
        else
            -- Swipe Bear
            if 50 <= rage and currts > castts - 0.16 then
                aura_env.region:Color(unpack(colors[20]))
                return false
            end
        end
        -- Maul
        if currts < castts - 0.35 then
            if lacerate_stacks == 5 and 25 <= rage or 40 <= rage then
                aura_env.region:Color(unpack(colors[9]))
                return false
            end
        end
        aura_env.region:Color(unpack(colors[13]))
        return false
    end

    if currts < castts - 0.35 then
        if 3 == GetShapeshiftForm() and berserk_expire < currts and power + (castts - currts) * 10 + (clarity_expire > castts and 10 or 0) < 40 and spell_ready(50213) < currts + 0.1 then
            -- Tiger's Fury
            aura_env.region:Color(unpack(colors[7]))
            return false
        elseif 1 == GetShapeshiftForm() and rage >= 25 then
            -- Maul
            -- TODO: Improve the rage check
            aura_env.region:Color(unpack(colors[9]))
            return false
        end
        aura_env.region:Color(unpack(colors[13]))
        return false
    elseif currts < castts - 0.15 then
        aura_env.region:Color(unpack(colors[13]))
        return false
    end

    local pveinstances = {
        ['party'] = true,
        ['raid'] = true,
    }
    if not IsMouseButtonDown('Button4') and (IsEquippedItem(38295) or pveinstances[select(2, IsInInstance())]) and -1 ~= UnitLevel('target') then
        -- Swipe Loop
        if castts < clarity_expire or power + (castts - currts) * 10 > 69 or 3 == GetShapeshiftForm() then
            if combo >= 1 and roar_expire < castts then
                -- Roar
                local cost = select(4, GetSpellInfo(52610))
                if cost <= power then
                    aura_env.region:Color(unpack(colors[6]))
                    return false
                end
            elseif roar_expire < castts then
                -- Rake
                local cost = select(4, GetSpellInfo(48574))
                if cost <= power then
                    aura_env.region:Color(unpack(colors[2]))
                    return false
                end
            else
                -- Swipe Cat
                local cost = select(4, GetSpellInfo(62078))
                if cost <= power then
                    aura_env.region:Color(unpack(colors[20]))
                    return false
                end
            end
        end
        if UnitPower('player', 1) >= 124000 then
            aura_env.region:Color(unpack(colors[19]))
            return false
        elseif 3 ~= GetShapeshiftForm() then
            aura_env.region:Color(unpack(colors[20]))
            return false
        end
        aura_env.region:Color(unpack(colors[13]))
        return false
    end

    -- if lacerate_stacks >= 1 and (1 == GetShapeshiftForm() and lacerate_expire < castts + 3.2 or lacerate_expire < castts + 2.6) and lacerate_expire < ending then
    if lacerate_stacks >= 1 and lacerate_expire < castts + 3.2 and lacerate_expire < ending and not low_mode then
        -- Lacerate (Refresh)
        aura_env.region:Color(unpack(colors[8]))
        return false
    elseif faerie_expire < castts + 3.0 and -1 == UnitLevel('target') and spell_ready(16857) < castts + 0.1 then
        -- Faerie Fire (Feral)
        aura_env.region:Color(unpack(colors[11]))
        return false
    elseif 0 == GetShapeshiftForm() and clarity_expire < castts and low_mode then
        -- Gift Weave (Continue)
        if UnitPower('player', 0) >= 1240 and power + (castts - currts) * 10 <= 69 then
            aura_env.region:Color(unpack(colors[19]))
            return false
        else
            aura_env.region:Color(unpack(colors[1]))
            return false
        end
    elseif 1 == GetShapeshiftForm() then
        -- Bear Weave (Continue)
        if power + (castts - currts) * 10 > 69 or (rip_more and rip_expire < castts + 3.0) or rage < 10 or low_mode then
            -- Cat
            aura_env.region:Color(unpack(colors[1]))
            return false
        elseif lacerate_stacks < 5 or lacerate_expire < castts + 10 or (rage < 38 or power + (castts - currts) * 10 > 54  or (rip_more and rip_expire < castts + 4.5)) and lacerate_expire < ending then
            -- Lacerate
            aura_env.region:Color(unpack(colors[8]))
            return false
        elseif clarity_expire > castts then
            -- Cat (Low Bearwave Priority)
            aura_env.region:Color(unpack(colors[1]))
            return false
        elseif spell_ready(48564) < castts + 0.1 then
            -- MangleB
            aura_env.region:Color(unpack(colors[10]))
            return false
        else
            -- Lacerate (Fullfill)
            aura_env.region:Color(unpack(colors[8]))
            return false
        end
    elseif IsMouseButtonDown('Button4') and IsMouseButtonDown('Button5') and spell_ready(50334) < castts + 0.1 and castts + 18 < spell_ready(50213) and not low_mode then
        -- Berserk
        aura_env.region:Color(unpack(colors[12]))
        return false
    elseif combo >= 1 and roar_expire < castts then
        -- Roar
        local cost = select(4, GetSpellInfo(52610))
        if cost <= power then
            aura_env.region:Color(unpack(colors[6]))
            return false
        end
    elseif combo >= 5 and rip_expire < castts and castts + 10 < ending and clarity_expire < castts then
        -- Rip
        local cost = select(4, GetSpellInfo(49800))
        if cost <= power then
            aura_env.region:Color(unpack(colors[3]))
            return false
        end
    elseif combo >= 1 and castts + 10 < rip_expire and roar_expire <= rip_expire and castts + 9 + combo * 5 - 14 >= rip_expire then
        -- Roar (Clip)
        local cost = select(4, GetSpellInfo(52610))
        if cost <= power then
            aura_env.region:Color(unpack(colors[6]))
            return false
        end
    elseif combo >= 5 and (not rip_more or castts + 10 <= math.min(roar_expire, rip_expire)) and clarity_expire < castts and (berserk_expire < castts or power <= 30) then
        -- Bite
        local cost = select(4, GetSpellInfo(48577))
        if cost <= power then
            aura_env.region:Color(unpack(colors[5]))
            return false
        end
    elseif rake_expire < castts and castts + 9 < ending and clarity_expire < castts then
        -- Rake
        local cost = select(4, GetSpellInfo(48574))
        if cost <= power then
            aura_env.region:Color(unpack(colors[2]))
            return false
        end
    elseif mangle_expire < castts then
        -- MangleC
        local cost = select(4, GetSpellInfo(48566))
        if cost <= power then
            aura_env.region:Color(unpack(colors[4]))
            return false
        end
    elseif berserk_expire < castts and power <= 38 and (not rip_more or rip_expire >= castts + 4.7) and clarity_expire < castts then
        if low_mode then
            -- Gift Weave
            if UnitPower('player', 0) >= 1240 then
                aura_env.region:Color(unpack(colors[19]))
                return false
            elseif 3 ~= GetShapeshiftForm() then
                aura_env.region:Color(unpack(colors[1]))
                return false
            end
        else
            -- Bear Weave
            aura_env.region:Color(unpack(colors[9]))
            return false
        end
    else
        local pendingActions = { }
        if not (roar_expire < castts) then
            table.insert(pendingActions, {roar_expire, roar_expire < berserk_expire and 12 or 25})
        end
        if not (rip_expire < castts) and rip_more then
            table.insert(pendingActions, {rip_expire, rip_expire < berserk_expire and 15 or 30})
        end
        if not (rake_expire < castts) and rake_expire + 9 < ending then
            table.insert(pendingActions, {rake_expire, rake_expire < berserk_expire and 18 or 35})
        end
        if not (mangle_expire < castts) and mangle_expire + 1 < ending then
            table.insert(pendingActions, {mangle_expire, mangle_expire < berserk_expire and 20 or 40})
        end
        table.sort(pendingActions, function(lhs, rhs)
            return lhs[1] < rhs[1]
        end)
        local reserved, prev = 0, 0
        for i, action in pairs(pendingActions) do
            local stocked = math.floor((action[1] - currts) * 10.0) + reserved - prev
            reserved = reserved + math.max(action[2] - stocked, 0)
            prev = prev + action[2]
        end
        -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFFF468[TG-FeralRaid] Reserved power = ' .. reserved .. '.')

        if IsMouseButtonDown('Button4') then
            -- Shred
            local cost = select(4, GetSpellInfo(48572))
            if cost + reserved <= power or cost == 0 then
                aura_env.region:Color(unpack(colors[1]))
                return false
            end
        else
            -- MangleC (Fullfill)
            local cost = select(4, GetSpellInfo(48566))
            if cost + reserved <= power or cost == 0 then
                aura_env.region:Color(unpack(colors[4]))
                return false
            end
        end

        if 0 == GetShapeshiftForm() then
            aura_env.region:Color(unpack(colors[1]))
            return false
        end
    end

    aura_env.region:Color(unpack(colors[13]))
    return false
end

-- Trigger 2: Custom / Event: COMBAT_LOG_EVENT_UNFILTERED
function(_, _, event, sourceGUID, _, _, destGUID, _, _, spellId, ...)
    if UnitGUID('player') == sourceGUID then
        if 50334 == spellId then
            -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFFF468[TG-FeralRaid] Berserk found with ' .. event .. '.')
            if event == 'SPELL_AURA_APPLIED' then
                wa_global = wa_global or { }
                wa_global.feralRaid = wa_global.feralRaid or { }
                wa_global.feralRaid.berserk = GetTime() + 15
            elseif event == 'SPELL_AURA_REMOVED' then
                wa_global = wa_global or { }
                wa_global.feralRaid = wa_global.feralRaid or { }
                wa_global.feralRaid.berserk = nil
            end
        elseif 52610 == spellId then
            -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFFF468[TG-FeralRaid] Savage Roar found with ' .. event .. '.')
            if event == 'SPELL_AURA_APPLIED' or event == 'SPELL_AURA_REFRESH' then
                wa_global = wa_global or { }
                wa_global.feralRaid = wa_global.feralRaid or { }
                local roar = wa_global.feralRaid.roar or { }
                local _, _, _, _, _, _, expirationTime = WA_GetUnitBuff('player', 52610, 'PLAYER')
                if expirationTime then
                    -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFFF468[TG-FeralRaid] Savage Roar found for ' .. string.format('%.3f', expirationTime - GetTime()) .. ' secs.')
                else
                    DEFAULT_CHAT_FRAME:AddMessage('|cFFFFF468[TG-FeralRaid] Savage Roar expiration time is unknown.')
                end
                wa_global.feralRaid.roar = expirationTime
            elseif event == 'SPELL_AURA_REMOVED' then
                wa_global = wa_global or { }
                wa_global.feralRaid = wa_global.feralRaid or { }
                wa_global.feralRaid.roar = nil
            end
        elseif 49800 == spellId then
            -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFFF468[TG-FeralRaid] Rip found with ' .. event .. '.')
            if event == 'SPELL_AURA_APPLIED' or event == 'SPELL_AURA_REFRESH' then
                wa_global = wa_global or { }
                wa_global.feralRaid = wa_global.feralRaid or { }
                local rips = wa_global.feralRaid.rips or { }
                rips[destGUID] = GetTime() + 12 + 4 + 4 + 6
                wa_global.feralRaid.rips = rips
            elseif event == 'SPELL_AURA_REMOVED' then
                wa_global = wa_global or { }
                wa_global.feralRaid = wa_global.feralRaid or { }
                local rips = wa_global.feralRaid.rips or { }
                rips[destGUID] = nil
                wa_global.feralRaid.rips = rips
            end
        elseif 48574 == spellId then
            -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFFF468[TG-FeralRaid] Rake found with ' .. event .. '.')
            if event == 'SPELL_AURA_APPLIED' or event == 'SPELL_AURA_REFRESH' then
                wa_global = wa_global or { }
                wa_global.feralRaid = wa_global.feralRaid or { }
                local rakes = wa_global.feralRaid.rakes or { }
                rakes[destGUID] = GetTime() + 9
                wa_global.feralRaid.rakes = rakes
            elseif event == 'SPELL_AURA_REMOVED' then
                wa_global = wa_global or { }
                wa_global.feralRaid = wa_global.feralRaid or { }
                local rakes = wa_global.feralRaid.rakes or { }
                rakes[destGUID] = nil
                wa_global.feralRaid.rakes = rakes
            end
        elseif 48568 == spellId then
            -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFFF468[TG-FeralRaid] Lacerate found with ' .. event .. '.')
            if event == 'SPELL_AURA_APPLIED' or event == 'SPELL_AURA_REFRESH' then
                wa_global = wa_global or { }
                wa_global.feralRaid = wa_global.feralRaid or { }
                local lacerates = wa_global.feralRaid.lacerates or { }
                lacerates[destGUID] = { GetTime() + 15, math.min(lacerates[destGUID] and lacerates[destGUID][2] + 1 or 1, 5) }
                -- DEFAULT_CHAT_FRAME:AddMessage(string.format('|cFFFFF468[TG-FeralRaid] Lacerate found for %.3f secs with %d stacks.', lacerates[destGUID][1] - GetTime(), lacerates[destGUID][2]))
                wa_global.feralRaid.lacerates = lacerates
            elseif event == 'SPELL_AURA_REMOVED' then
                wa_global = wa_global or { }
                wa_global.feralRaid = wa_global.feralRaid or { }
                local lacerates = wa_global.feralRaid.lacerates or { }
                lacerates[destGUID] = nil
                wa_global.feralRaid.lacerates = lacerates
            end
        elseif 16870 == spellId then
            -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFFF468[TG-FeralRaid] Clearcasting found with ' .. event .. '.')
            if event == 'SPELL_AURA_APPLIED' or event == 'SPELL_AURA_REFRESH' then
                wa_global = wa_global or { }
                wa_global.feralRaid = wa_global.feralRaid or { }
                wa_global.feralRaid.clearcasting = GetTime() + 15
            elseif event == 'SPELL_AURA_REMOVED' then
                wa_global = wa_global or { }
                wa_global.feralRaid = wa_global.feralRaid or { }
                wa_global.feralRaid.clearcasting = nil
            end
        end
    end

    local mangleIds = {
        [33876] = true, -- Mangle (Cat) (Rank 1)
        [33982] = true, -- Mangle (Cat) (Rank 2)
        [33983] = true, -- Mangle (Cat) (Rank 3)
        [48565] = true, -- Mangle (Cat) (Rank 4)
        [48566] = true, -- Mangle (Cat) (Rank 5)
        [33878] = true, -- Mangle (Bear) (Rank 1)
        [33986] = true, -- Mangle (Bear) (Rank 2)
        [33987] = true, -- Mangle (Bear) (Rank 3)
        [48563] = true, -- Mangle (Bear) (Rank 4)
        [48564] = true, -- Mangle (Bear) (Rank 5)
        [46857] = true, -- Trauma (Rank 2)
    }
    if mangleIds[spellId] then
        -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFFF468[TG-FeralRaid] Mangle found with ' .. event .. '.')
        if event == 'SPELL_AURA_APPLIED' or event == 'SPELL_AURA_REFRESH' then
            wa_global = wa_global or { }
            wa_global.feralRaid = wa_global.feralRaid or { }
            local mangles = wa_global.feralRaid.mangles or { }
            mangles[destGUID] = GetTime() + 60
            wa_global.feralRaid.mangles = mangles
        elseif event == 'SPELL_AURA_REMOVED' then
            wa_global = wa_global or { }
            wa_global.feralRaid = wa_global.feralRaid or { }
            local mangles = wa_global.feralRaid.mangles or { }
            mangles[destGUID] = nil
            wa_global.feralRaid.mangles = mangles
        end
    elseif 770 == spellId or 16857 == spellId then
        -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFFF468[TG-FeralRaid] Faerie Fire found with ' .. event .. '.')
        if event == 'SPELL_AURA_APPLIED' or event == 'SPELL_AURA_REFRESH' then
            wa_global = wa_global or { }
            wa_global.feralRaid = wa_global.feralRaid or { }
            local ffs = wa_global.feralRaid.ffs or { }
            ffs[destGUID] = GetTime() + 300
            wa_global.feralRaid.ffs = ffs
        elseif event == 'SPELL_AURA_REMOVED' then
            wa_global = wa_global or { }
            wa_global.feralRaid = wa_global.feralRaid or { }
            local ffs = wa_global.feralRaid.ffs or { }
            ffs[destGUID] = nil
            wa_global.feralRaid.ffs = ffs
        end
    end
    return false
end

-- Trigger 3: Custom / Event: UNIT_SPELLCAST_SUCCEEDED
function(_, unit, spellId)
    if 'player' == unit then
        if 'Cat Form' == spellId and not IsStealthed() then
            CallCompanion('CRITTER', 1)
            if InCombatLockdown() and -1 == UnitLevel('target') then
                local target = UnitGUID('target')
                local rip_expire = target and wa_global and wa_global.feralRaid and wa_global.feralRaid.rips and wa_global.feralRaid.rips[target] or 0
                if rip_expire < GetTime() + 8.0 then
                    ActionButtonDown(11);ActionButtonUp(11);
                elseif IsMouseButtonDown('Button4') then
                    ActionButtonDown(12);ActionButtonUp(12);
                else
                    ActionButtonDown(8);ActionButtonUp(8);
                end
            end
        elseif 'Prowl' == spellId or 'Dire Bear Form' == spellId or 'Gift of the Wild' == spellId then
            DismissCompanion('CRITTER')
        end
    end
    return false
end
