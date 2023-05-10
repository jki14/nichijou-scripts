-- Trigger 1: Custom / Event: CLEU:SWING_DAMAGE, CLEU:RANGE_DAMAGE, CLEU:SPELL_DAMAGE, CLEU:SPELL_PERIODIC_DAMAGE, CLEU:SPELL_BUILDING_DAMAGE, CLEU:ENVIRONMENTAL_DAMAGE
function(_, timestamp, event, ...)
    local damageEvents = {
        ['SWING_DAMAGE'] = true,
        ['RANGE_DAMAGE'] = true,
        ['SPELL_DAMAGE'] = true,
        ['SPELL_PERIODIC_DAMAGE'] = true,
        ['SPELL_BUILDING_DAMAGE'] = true,
        ['ENVIRONMENTAL_DAMAGE'] = true,
    }
    if event and damageEvents[event] then
        if not wa_global or not wa_global.DTPS then
            wa_global = wa_global or { }
            wa_global.DTPS = wa_global.DTPS or { }
        end
        local offset = event == 'SWING_DAMAGE' and 10 or 13
        if event == 'ENVIRONMENTAL_DAMAGE' then
            offset = 11
        end
        local amount = select(offset, ...)
        local guid = select(6, ...)
        if amount and amount > 0 and guid then
            local bucket = math.floor(timestamp / 5.0)
            if not wa_global.DTPS[guid] then
                wa_global.DTPS[guid] = { }
            end
            local prev = wa_global.DTPS[guid][bucket] or 0
            wa_global.DTPS[guid][bucket] = prev + amount / 5.0
        end
    end
    return false
end

-- Trigger 2: Custom / Event: PLAYER_REGEN_ENABLED
function()
    if wa_global and wa_global.DTPS then
        local expired = math.floor(time() / 5.0) - 2
        for guid, _ in pairs(wa_global.DTPS) do
            local drop = true
            for bucket, _ in pairs(wa_global.DTPS[guid]) do
                if bucket <= expired then
                    wa_global.DTPS[guid][bucket] = nil
                else
                    drop = false
                end
            end
            if drop then
                wa_global.DTPS[guid] = nil
            end
        end
    end
    return false
end

-- Text 1: Custom Function
function()
    if wa_global and wa_global.DTPS then
        local guid = UnitGUID('target')
        if guid and wa_global.DTPS[guid] then
            local prev = math.floor(time() / 5.0) - 1
            if wa_global.DTPS[guid][prev] then
                local dt = wa_global.DTPS[guid][prev]
                local foo = tostring(math.floor(dt / 100.0) / 10.0) .. 'k'
                local remain = UnitHealth('target')
                if remain then
                    local ttl = math.floor(remain / dt + 0.5)
                    foo = foo .. ' / ' .. tostring(ttl) .. 's'
                end
                return foo
            end
        end
    end
    return ''
end
