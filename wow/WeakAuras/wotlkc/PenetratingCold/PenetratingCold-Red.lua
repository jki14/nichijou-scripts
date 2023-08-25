-- trigger state updater: event(s): PENETRATING_COLD_RED
function(allstates, ...)
    -- local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME or DefaultChatFrame or { AddMessage = function(...) end }

    wa_global = wa_global or { }
    wa_global.penetratingColds = wa_global.penetratingColds or { }
    wa_global.penetratingColds.inflight = wa_global.penetratingColds.inflight or { }
    wa_global.penetratingColds.flag = wa_global.penetratingColds.flag and wa_global.penetratingColds.flag + 1 or 0
    local flag = wa_global.penetratingColds.flag

    local indexes, reverse = { }, { }
    local now = GetTime()
    for k, _ in pairs(wa_global.penetratingColds.inflight) do
        if wa_global.penetratingColds.inflight[k].expirationTime < now + 0.4 then
            wa_global.penetratingColds.inflight[k] = nil
        else
            table.insert(indexes, k)
        end
    end
    table.sort(indexes)
    for i, k in ipairs(indexes) do
        local stoken = string.format('slot_%d', i)
        local unit = wa_global.penetratingColds.inflight[k].unit
        local show = wa_global.penetratingColds.inflight[k].show and aura_env.config[stoken] or false
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
            show = wa_global.penetratingColds.inflight[k].show and not show,
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
    WeakAuras.ScanEvents('PENETRATING_COLD_BLUE')
    return true
end

-- Custom / Event(s): CHAT_MSG_RAID, CHAT_MSG_RAID_LEADER
function(event, text, ...)
    if text == 'show me the slots' then
        local msg = ''
        for i = 1, 5 do
            local stoken = string.format('slot_%d', i)
            if aura_env.config[stoken] then
                if string.len(msg) > 0 then
                    msg = msg .. ', '
                end
                msg = msg .. tostring(i)
            end
        end
        msg = 'My Penetrating Cold Slots: [' .. msg .. ']'
        SendChatMessage(msg, 'RAID')
    end
    return false
end
