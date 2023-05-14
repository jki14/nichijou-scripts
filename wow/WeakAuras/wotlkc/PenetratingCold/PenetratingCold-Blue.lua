-- trigger state updater: event(s): PENETRATING_COLD_BLUE
function(allstates, ...)
    wa_global = wa_global or { }
    wa_global.penetratingColds = wa_global.penetratingColds or { }
    wa_global.penetratingColds.flag = wa_global.penetratingColds.flag and wa_global.penetratingColds.flag + 1 or 0
    local flag = wa_global.penetratingColds.flag
    local reverse = wa_global.penetratingColds.reverse or { }

    for unit, state in pairs(reverse) do
        allstates[unit] = {
            changed = true,
            show = state.show,
            unit = unit,
            progressType = "timed",
            duration = state.duration,
            expirationTime = state.expirationTime,
            autoHide = true,
            flag = flag
        }
    end

    for k, _ in pairs(allstates) do
        if allstates[k].flag ~= flag then
            allstates[k].changed = true
            allstates[k].show =false
        end
    end

    return true
end
