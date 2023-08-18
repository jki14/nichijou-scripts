-- Actions / On Show / Custom
local function fbshow()
    if aura_env and aura_env.state and aura_env.state.unit then
        -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFF00FF[AnLiu-FrostBeacon] Frost Beacon at ' .. aura_env.state.unit .. ' starts.')
        local pos = UnitGUID(aura_env.state.unit)
        -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFF00FF[AnLiu-FrostBeacon]         The position is ' .. pos .. '.')
        if pos then
            wa_global = wa_global or { }
            wa_global.frostBeacons = wa_global.frostBeacons or { }
            wa_global.frostBeacons.inflight = wa_global.frostBeacons.inflight or { }
            wa_global.frostBeacons.inflight[pos] = {
                show = true,
                unit = aura_env.state.unit,
                duration = aura_env.state.duration,
                expirationTime = aura_env.state.expirationTime,
            }
            WeakAuras.ScanEvents('FROST_BEACON_LEFT')
            aura_env.showts = GetTime()
            return true
        end
    end
    return false
end

fbshow()

-- Actions / On Hide / Custom
local function fbhide()
    if aura_env and aura_env.state and aura_env.state.unit then
        -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFF00FF[AnLiu-FrostBeacon] Frost Beacon at ' .. aura_env.state.unit .. ' ends.')
        local pos = UnitGUID(aura_env.state.unit)
        -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFF00FF[AnLiu-FrostBeacon]         The position is ' .. pos .. '.')
        if pos then
            wa_global = wa_global or { }
            wa_global.frostBeacons = wa_global.frostBeacons or { }
            wa_global.frostBeacons.inflight = wa_global.frostBeacons.inflight or { }
            if wa_global.frostBeacons.inflight[pos] then
                wa_global.frostBeacons.inflight[pos].show = false
            end
            WeakAuras.ScanEvents('FROST_BEACON_LEFT')
            return true
        end
    end
    return false
end

fbhide()
