-- Trigger 1: Custom / Status / Every Frame
function()
    local ffenable = true
    local latepot = nil

    local powerColors = {
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
    }

    if not IsMouseButtonDown('Button4') and not IsMouseButtonDown('Button5') or IsModifierKeyDown() then
        aura_env.region:Color(unpack(powerColors[13]))
        return true
    end

    local currts = GetTime()

    local start, duration = GetSpellCooldown(27002)
    local castts = start > 0 and start + duration - 0.1 or currts - 0.1

    if currts < castts then
        aura_env.region:Color(unpack(powerColors[13]))
        return true
    end

    local target = UnitGUID('target')
    if not target then
        aura_env.region:Color(unpack(powerColors[13]))
        return true
    end

    local npcId = select(6, strsplit("-", target))
    local npcId = tonumber(npcId) or 0
    if latepot == nil then
        latepot = npcId == 17767 or npcId == 22947
    end

    local powershift = false

    local tickts = wa_global and wa_global.feral and wa_global.feral.next_gaints or currts + 1
    local power = UnitPower('player', 3)
    local pwrsts = castts + math.max(select(4, GetSpellInfo(2908)) / 1000, 1.0) + 0.2

    local rip_expire = wa_global and wa_global.feral and wa_global.feral.rips and wa_global.feral.rips[target] or 0
    local mng_expire = wa_global and wa_global.feral and wa_global.feral.mangles and wa_global.feral.mangles[target] or 0
    local ff_expire = wa_global and wa_global.feral and wa_global.feral.ffs and wa_global.feral.ffs[target] or 0

    if ffenable and castts >= ff_expire then
        local ffs, ffd = GetSpellCooldown(27011)
        if ffs < 0.01 or ffs + ffd - 0.11 < castts then
            aura_env.region:Color(unpack(powerColors[6]))
            return true
        end
    end

    if GetComboPoints('player', 'target') == 5 then
        if castts > rip_expire and castts + 2.2 < mng_expire and UnitHealth('target') > 471000 and npcId ~= 22887 then
            -- Rip
            local cost = GetSpellPowerCost(27008)[1].cost
            if cost <= power then
                aura_env.region:Color(unpack(powerColors[4]))
                return true
            elseif cost > power + 20 or (pwrsts < tickts and not IsMouseButtonDown('Button5')) then
                powershift = true
            end
        else
            -- Bite
            local cost = GetSpellPowerCost(24248)[1].cost
            if cost <= power then
                aura_env.region:Color(unpack(powerColors[5]))
                return true
            elseif cost > power + 20 then
                powershift = true
            end
        end
    else
        if castts + 0.2 < mng_expire and not IsMouseButtonDown('Button5') then
            -- Shard
            local cost = GetSpellPowerCost(27002)[1].cost
            if cost <= power then
                aura_env.region:Color(unpack(powerColors[1]))
                return true
            elseif cost > power + 20 or (pwrsts < tickts and not IsMouseButtonDown('Button5')) then
                powershift = true
            end
        else
            -- Mangle
            local cost = GetSpellPowerCost(33983)[1].cost
            if cost <= power then
                aura_env.region:Color(unpack(powerColors[3]))
                return true
            elseif cost > power + 20 or (pwrsts < tickts and not IsMouseButtonDown('Button5')) then
                powershift = true
            end
        end
    end

    if powershift then
        local cost = GetSpellPowerCost(768)[1].cost
        local mana = UnitPower('player', 0)
        if cost <= mana then
            aura_env.region:Color(unpack(powerColors[2]))
            return true
        elseif UnitLevel('target') == -1 then
            if not latepot and GetItemCooldown(33093) == 0 then
                aura_env.region:Color(unpack(powerColors[7]))
                return true
            elseif GetItemCooldown(20520) == 0 then
                aura_env.region:Color(unpack(powerColors[8]))
                return true
            elseif GetSpellCooldown(29166) == 0 then
                aura_env.region:Color(unpack(powerColors[9]))
                return true
            elseif latepot and GetItemCooldown(33093) == 0 then
                aura_env.region:Color(unpack(powerColors[7]))
                return true
            end
        end
    end

    if ffenable and castts + 1.2 < tickts then
        local ffs, ffd = GetSpellCooldown(27011)
        if ffs < 0.01 or ffs + ffd - 0.11 < castts then
            aura_env.region:Color(unpack(powerColors[6]))
            return true
        end
    end

    aura_env.region:Color(unpack(powerColors[13]))
    return true
end

-- Trigger 2: Custom / Event: COMBAT_LOG_EVENT_UNFILTERED
function(_, _, event, _, sourceGUID, _, _, _, destGUID, _, _, _, spellId, ...)
    local mangleIds = {
        [33876] = true, -- Mangle (Cat) (Rank 1)
        [33982] = true, -- Mangle (Cat) (Rank 2)
        [33983] = true, -- Mangle (Cat) (Rank 3)
        [33878] = true, -- Mangle (Bear) (Rank 3)
        [33986] = true, -- Mangle (Bear) (Rank 3)
        [33987] = true, -- Mangle (Bear) (Rank 3)
    }
    if UnitGUID('player') == sourceGUID and 27008 == spellId then
        if event == 'SPELL_AURA_APPLIED' or event == 'SPELL_DAMAGE' then
            wa_global = wa_global or { }
            wa_global.feral = wa_global.feral or { }
            local rips = wa_global.feral.rips or { }
            rips[destGUID] = GetTime() + 12
            wa_global.feral.rips = rips
        elseif event == 'SPELL_AURA_REMOVED' then
            wa_global = wa_global or { }
            wa_global.feral = wa_global.feral or { }
            local rips = wa_global.feral.rips or { }
            rips[destGUID] = nil
            wa_global.feral.rips = rips
        end
    elseif mangleIds[spellId] then
        if event == 'SPELL_AURA_APPLIED' or event == 'SPELL_DAMAGE' then
            wa_global = wa_global or { }
            wa_global.feral = wa_global.feral or { }
            local mangles = wa_global.feral.mangles or { }
            mangles[destGUID] = GetTime() + 12
            wa_global.feral.mangles = mangles
        elseif event == 'SPELL_AURA_REMOVED' then
            wa_global = wa_global or { }
            wa_global.feral = wa_global.feral or { }
            local mangles = wa_global.feral.mangles or { }
            mangles[destGUID] = nil
            wa_global.feral.mangles = mangles
        end
    elseif 27011 == spellId or 26993 == spellId then
        if event == 'SPELL_AURA_APPLIED' or event == 'SPELL_AURA_REFRESH' then
            wa_global = wa_global or { }
            wa_global.feral = wa_global.feral or { }
            local ffs = wa_global.feral.ffs or { }
            ffs[destGUID] = GetTime() + 40
            wa_global.feral.ffs = ffs
        elseif event == 'SPELL_AURA_REMOVED' then
            wa_global = wa_global or { }
            wa_global.feral = wa_global.feral or { }
            local ffs = wa_global.feral.ffs or { }
            ffs[destGUID] = nil
            wa_global.feral.ffs = ffs
        end
    end
    return true
end
