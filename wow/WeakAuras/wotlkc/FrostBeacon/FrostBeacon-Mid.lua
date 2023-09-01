-- trigger state updater: event(s): FROST_BEACON_MID
function(allstates, ...)
    wa_global = wa_global or { }
    wa_global.frostBeacons = wa_global.frostBeacons or { }
    wa_global.frostBeacons.inflight = wa_global.frostBeacons.inflight or { }

    local flag = false
    for i = 3, 4 do
        if wa_global.frostBeacons.inflight[i] and UnitIsUnit(wa_global.frostBeacons.inflight[i].unit, 'player') then
            if not allstates[''] or
                    not allstates[''].show or
                    (allstates[''].expirationTime and
                            math.abs(allstates[''].expirationTime - wa_global.frostBeacons.inflight[i].expirationTime) > 1e-4) then
                allstates[''] = {
                    changed = true,
                    show = true,
                    unit = unit,
                    progressType = "timed",
                    duration = wa_global.frostBeacons.inflight[i].duration,
                    expirationTime = wa_global.frostBeacons.inflight[i].expirationTime,
                    autoHide = true,
                }
                flag = true
            end
        end
    end

    if not flag and allstates[''] then
        allstates[''].changed = true
        allstates[''].show = false
    end

    WeakAuras.ScanEvents('FROST_BEACON_RIGHT')
    return true
end
