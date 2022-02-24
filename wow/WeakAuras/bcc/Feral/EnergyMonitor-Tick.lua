-- trigger state updater: event(s): UNIT_POWER_UPDATE:player,ENERGYTICK
function(allstates, event, unit, power)
    if event == 'UNIT_POWER_UPDATE' and power ~= 'ENERGY' then
        return false
    end

    wa_global = wa_global or { }
    wa_global.feral = wa_global.feral or { }
    wa_global.feral.last_energy = wa_global.feral.last_energy or 0

    local timestamp = GetTime()

    if event == 'UNIT_POWER_UPDATE' then
        local curr_energy = UnitPower('player', 3)
        local ignore = GetInventoryItemID('player', 1) == 8345 and 60 or 40
        if curr_energy ~= ignore and curr_energy > wa_global.feral.last_energy then
            wa_global.feral.last_gaints = timestamp
            wa_global.feral.last_energy = curr_energy
        end
    end

    if wa_global.feral.last_gaints then
        local lastms = math.floor(wa_global.feral.last_gaints * 1000)
        local currms = math.floor(timestamp * 1000)
        local tailms = (currms - lastms) % 2000
        local k = math.floor((currms - tailms - lastms) / 2000) + 1
        local nextms = lastms + k * 2000
        wa_global.feral.next_gaints = nextms * 0.001
    end

    local nextts = wa_global.feral.next_gaints or nil
    if nextts then
        if not allstates[''] or allstates[''].expirationTime ~= nextts then
            allstates[''] = {
                changed = true,
                show = true,
                progressType = 'timed',
                duration = 2,
                expirationTime = nextts,
            }
            C_Timer.After(nextts - GetTime(), function()
                WeakAuras.ScanEvents("ENERGYTICK", true)
            end)
            return true
        end
    end

    return false
end
