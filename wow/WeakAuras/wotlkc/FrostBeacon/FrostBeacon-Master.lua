-- Actions / On Show / Custom
local function fbshow()
    if aura_env and aura_env.state and aura_env.state.unit then
        wa_global = wa_global or { }
        wa_global.frostBeacons = wa_global.frostBeacons or { }
        wa_global.frostBeacons.inflight = wa_global.frostBeacons.inflight or { }
        for p, _ in pairs(wa_global.frostBeacons.inflight) do
            if wa_global.frostBeacons.inflight[p].expirationTime - 0.4 < GetTime() then
                wa_global.frostBeacons.inflight[p] = nil
            end
        end
        local pos = #wa_global.frostBeacons.inflight + 1
        wa_global.frostBeacons.inflight[pos] = {
            unit = aura_env.state.unit,
            duration = aura_env.state.duration,
            expirationTime = aura_env.state.expirationTime,
        }
        WeakAuras.ScanEvents('FROST_BEACON_LEFT')
    end
    return false
end

fbshow()

-- Actions / On Hide / Custom
local function fbhide()
    if aura_env and aura_env.state and aura_env.state.unit then
        wa_global = wa_global or { }
        wa_global.frostBeacons = wa_global.frostBeacons or { }
        wa_global.frostBeacons.inflight = wa_global.frostBeacons.inflight or { }
        for p, _ in pairs(wa_global.frostBeacons.inflight) do
            if wa_global.frostBeacons.inflight[p].expirationTime - 0.4 < GetTime() then
                wa_global.frostBeacons.inflight[p] = nil
            end
        end
        WeakAuras.ScanEvents('FROST_BEACON_LEFT')
    end
    return false
end

fbhide()
