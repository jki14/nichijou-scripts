-- trigger state updater: event(s): FROST_BEACON_LEFT
function(allstates, ...)
    wa_global = wa_global or { }
    wa_global.frostBeacons = wa_global.frostBeacons or { }
    wa_global.frostBeacons.inflight = wa_global.frostBeacons.inflight or { }
    local flag = false

    local indexes, reverse = { }, { }
    local now = GetTime()
    for k, _ in pairs(wa_global.frostBeacons.inflight) do
        if wa_global.frostBeacons.inflight[k].expirationTime < now + 0.4 then
            wa_global.frostBeacons.inflight[k] = nil
        else
            table.insert(indexes, k)
        end
    end
    table.sort(indexes)
    local show = false
    for i, k in ipairs(indexes) do
        if UnitIsUnit(wa_global.frostBeacons.inflight[k].unit, 'player') then
            local show = math.fmod(i, 2) == 1
            allstates[''] = {
                changed = true,
                show = show,
                unit = unit,
                progressType = "timed",
                duration = wa_global.frostBeacons.inflight[k].duration,
                expirationTime = wa_global.frostBeacons.inflight[k].expirationTime,
                autoHide = true,
            }
            reverse[''] = {
                show = wa_global.frostBeacons.inflight[k].show and not show,
                unit = unit,
                duration = allstates[''].duration,
                expirationTime = allstates[''].expirationTime,
            }
            flag = true
            break
        end
    end

    if not flag and allstates[''] then
        allstates[''].changed = true
        allstates[''].show = false
    end

    wa_global.frostBeacons.reverse = reverse
    WeakAuras.ScanEvents('FROST_BEACON_RIGHT')
    return true
end
