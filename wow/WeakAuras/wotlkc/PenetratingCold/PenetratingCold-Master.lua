-- Actions / On Show / Custom
local function pcshow()
    -- local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME or DefaultChatFrame or { AddMessage = function(...) end }

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
                show = true,
                unit = aura_env.state.unit,
                duration = aura_env.state.duration,
                expirationTime = aura_env.state.expirationTime,
            }
            WeakAuras.ScanEvents('PENETRATING_COLD_RED')
            aura_env.showts = GetTime()
            return true
        end
    end
    -- TODO: Panic Mode
    return false
end

pcshow()

-- Actions / On Hide / Custom
local function pchide()
    -- local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME or DefaultChatFrame or { AddMessage = function(...) end }

    if aura_env and aura_env.state and aura_env.state.unit then
        -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFF00FF[AnLiu-PenetratingCold] Penetrating Cold at ' .. aura_env.state.unit .. ' ends.')
        local pos = string.sub(aura_env.state.unit, 5, -1)
        pos = pos and tonumber(pos) or 0
        -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFF00FF[AnLiu-PenetratingCold]     The position is ' .. tostring(pos) .. '.')
        if pos > 0 then
            wa_global = wa_global or { }
            wa_global.penetratingColds = wa_global.penetratingColds or { }
            wa_global.penetratingColds.inflight = wa_global.penetratingColds.inflight or { }
            if wa_global.penetratingColds.inflight[pos] then
                wa_global.penetratingColds.inflight[pos].show = false
            end
            WeakAuras.ScanEvents('PENETRATING_COLD_RED')
            return true
        end
    end
    -- TODO: Panic Mode
    return false
end

pchide()

-- Conditions / Trigger 1 Since Apply/Refresh > 0 / Run Custom Code
local function pcrefresh()
    -- local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME or DefaultChatFrame or { AddMessage = function(...) end }

    if aura_env and aura_env.state and aura_env.state.unit then
        if aura_env.showts and aura_env.showts + 0.4 > GetTime() then
            return false
        end
        -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFF00FF[AnLiu-PenetratingCold] Penetrating Cold at ' .. aura_env.state.unit .. ' refreshs.')
        local pos = string.sub(aura_env.state.unit, 5, -1)
        pos = pos and tonumber(pos) or 0
        -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFF00FF[AnLiu-PenetratingCold]         The position is ' .. tostring(pos) .. '.')
        if pos > 0 then
            wa_global = wa_global or { }
            wa_global.penetratingColds = wa_global.penetratingColds or { }
            wa_global.penetratingColds.inflight = wa_global.penetratingColds.inflight or { }
            wa_global.penetratingColds.inflight[pos] = {
                show = true,
                unit = aura_env.state.unit,
                duration = aura_env.state.duration,
                expirationTime = aura_env.state.expirationTime,
            }
            WeakAuras.ScanEvents('PENETRATING_COLD_RED')
            return true
        end
    end
    -- TODO: Panic Mode
    return false
end

pcrefresh()
