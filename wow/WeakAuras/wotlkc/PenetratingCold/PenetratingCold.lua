-- trigger state updater: event(s): PENETRATING_COLD
function(allstates, ...)
    wa_global = wa_global or { }
    wa_global.penetratingColds = wa_global.penetratingColds or { }
    wa_global.penetratingColds.inflight = wa_global.penetratingColds.inflight or { }
    wa_global.penetratingColds.flag = wa_global.penetratingColds.flag and wa_global.penetratingColds.flag + 1 or 0
    local flag = wa_global.penetratingColds.flag

    local indexes, reverse = { }, { }
    for k, _ in pairs(wa_global.penetratingColds.inflight) do
        table.insert(indexes, k)
    end
    table.sort(indexes)
    for i, k in ipairs(indexes) do
        local stoken = string.format('slot_%d', i)
        local unit = wa_global.penetratingColds.inflight[k].unit
        local show = aura_env.config[stoken] or false
        -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFF00FF[AnLiu-PenetratingCold]         The ' .. tostring(unit) .. ' at ' .. tostring(stoken) .. ' is configured as ' .. tostring(show) .. '.')
        allstates[unit] = {
            changed = true,
            show = show,
            unit = unit,
            progressType = "timed",
            duration = wa_global.penetratingColds.inflight[k].duration,
            expirationTime = wa_global.penetratingColds.inflight[k].expirationTime,
            autoHide = true,
            flag = flag
        }
        reverse[unit] = {
            show = not show,
            duration = allstates[unit].duration,
            expirationTime = allstates[unit].expirationTime,
        }
    end

    for k, _ in pairs(allstates) do
        if allstates[k].flag ~= flag then
            allstates[k].changed = true
            allstates[k].show =false
        end
    end

    wa_global.penetratingColds.reverse = reverse
    WeakAuras.ScanEvents('PENETRATING_COLD2')
    return true
end

-- trigger state updater: event(s): PENETRATING_COLD2
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

-- Actions / On Show / Custom
local function pcshow()
    if aura_env and aura_env.state and aura_env.state.unit then
        -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFF00FF[AnLiu-PenetratingCold] Penetrating Cold at ' .. aura_env.state.unit .. ' starts.')
        local pos = string.sub(aura_env.state.unit, 5, -1)
        pos = pos and tonumber(pos) or 0
        -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFF00FF[AnLiu-PenetratingCold]         The position is ' .. tostring(pos) .. '.')
        if pos > 0 then
            wa_global = wa_global or { }
            wa_global.penetratingColds = wa_global.penetratingColds or { }
            wa_global.penetratingColds.inflight = wa_global.penetratingColds.inflight or { }
            wa_global.penetratingColds.inflight[pos] = {
                unit = aura_env.state.unit,
                duration = aura_env.state.duration,
                expirationTime = aura_env.state.expirationTime,
            }
            WeakAuras.ScanEvents('PENETRATING_COLD')
            return true
        end
    end
    -- TODO: Panic Mode
    return false
end

pcshow()

-- Actions / On Hide / Custom
local function pchide()
    if aura_env and aura_env.state and aura_env.state.unit then
        -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFF00FF[AnLiu-PenetratingCold] Penetrating Cold at ' .. aura_env.state.unit .. ' ends.')
        local pos = string.sub(aura_env.state.unit, 5, -1)
        pos = pos and tonumber(pos) or 0
        -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFF00FF[AnLiu-PenetratingCold]     The position is ' .. tostring(pos) .. '.')
        if pos > 0 then
            wa_global = wa_global or { }
            wa_global.penetratingColds = wa_global.penetratingColds or { }
            wa_global.penetratingColds.inflight = wa_global.penetratingColds.inflight or { }
            wa_global.penetratingColds.inflight[pos] = nil
            WeakAuras.ScanEvents('PENETRATING_COLD')
            return true
        end
    end
    -- TODO: Panic Mode
    return false
end

pchide()
