-- Trigger 1: Custom / Status / Every Frame
function()
    local ffenable = false
    local latepot = false

    if IsModifierKeyDown() then
        aura_env.region:Color(0, 0, 0, 1)
        return true
    end

    if not IsMouseButtonDown('Button4') and not IsMouseButtonDown('Button5') then
        aura_env.region:Color(0, 0, 0, 1)
        return true
    end

    local currts = GetTime()

    local start, duration = GetSpellCooldown(27002)
    local castts = start > 0 and start + duration - 0.1 or currts - 0.1

    if currts < castts then
        aura_env.region:Color(0, 0, 0, 1)
        return true
    end

    local target = UnitGUID('target')
    if not target then
        aura_env.region:Color(0, 0, 0, 1)
        return true
    end

    local npcId = tonumber(select(6, strsplit("-", target))) or 0

    if 3 ~= GetShapeshiftForm() then
        aura_env.region:Color(1, 1, 1, 1)
        return true
    end

    local powershift = false

    local tickts = wa_global and wa_global.feral and wa_global.feral.next_gaints or currts + 1
    local power = UnitPower('player', 3)
    local pwrsts = castts + math.max(select(4, GetSpellInfo(2908)) / 1000, 1.0) + 0.2

    local rip_expire = wa_global and wa_global.feral and wa_global.feral.rips and wa_global.feral.rips[target] or 0
    local mng_expire = wa_global and wa_global.feral and wa_global.feral.mangles and wa_global.feral.mangles[target] or 0

    if GetComboPoints('player', 'target') == 5 then
        if castts > rip_expire and castts + 2.2 < mng_expire and UnitHealth('target') > 432000 and npcId ~= 22887 then
            -- Rip
            local cost = GetSpellPowerCost(27008)[1].cost
            if cost <= power then
                aura_env.region:Color(1, 0, 0, 1)
                return true
            elseif cost > power + 20 or (pwrsts < tickts and not IsMouseButtonDown('Button5')) then
                powershift = true
            end
        else
            -- Bite
            local cost = GetSpellPowerCost(24248)[1].cost
            if cost <= power then
                aura_env.region:Color(0, 1, 0, 1)
                return true
            elseif cost > power + 20 then
                powershift = true
            end
        end
    else
        if castts + 0.2 < mng_expire then
            -- Shard
            local cost = GetSpellPowerCost(27002)[1].cost
            if cost <= power then
                aura_env.region:Color(1, 1, 0, 1)
                return true
            elseif cost > power + 20 or (pwrsts < tickts and not IsMouseButtonDown('Button5')) then
                powershift = true
            end
        else
            -- Mangle
            local cost = GetSpellPowerCost(33983)[1].cost
            if cost <= power then
                aura_env.region:Color(0, 0, 1, 1)
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
            aura_env.region:Color(1, 0, 1, 1)
            return true
        elseif UnitLevel('target') == -1 then
            if not latepot and GetItemCooldown(33093) == 0 then
                aura_env.region:Color(1, 1 / 3, 1, 1)
                return true
            elseif GetItemCooldown(20520) == 0 then
                aura_env.region:Color(1, 2 / 3, 1, 1)
                return true
            elseif GetSpellCooldown(29166) == 0 then
                aura_env.region:Color(0, 1, 1, 1)
                return true
            elseif latepot and GetItemCooldown(33093) == 0 then
                aura_env.region:Color(1, 1 / 3, 1, 1)
                return true
            end
        end
    end

    if ffenable and castts + 1.2 < tickts then
        local ffs, ffd = GetSpellCooldown(27011)
        if ffs < 0.01 or ffs + ffd - 0.11 < castts then
            aura_env.region:Color(2 / 3, 2 / 3, 2 / 3, 1)
            return true
        end
    end

    aura_env.region:Color(0, 0, 0, 1)
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
    end
    return true
end
