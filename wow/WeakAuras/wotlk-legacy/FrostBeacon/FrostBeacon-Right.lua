-- trigger state updater: event(s): FROST_BEACON_RIGHT
function(allstates, ...)
    wa_global = wa_global or { }
    wa_global.frostBeacons = wa_global.frostBeacons or { }
    local reverse = wa_global.frostBeacons.reverse or { }

    if reverse[''] then
        allstates[''] = {
            changed = true,
            show = reverse[''].show,
            unit = reverse[''].unit,
            progressType = "timed",
            duration = reverse[''].duration,
            expirationTime = reverse[''].expirationTime,
            autoHide = true,
            flag = flag
        }
    elseif allstates[''] then
        allstates[''].changed = true
        allstates[''].show = false
    end

    return true
end
