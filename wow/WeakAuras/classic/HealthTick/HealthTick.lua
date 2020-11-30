-- Trigger: UNIT_HEALTH_FREQUENT:player,HEALTHTICK
function(a, event, unit, power)
    local flag = false
    local currHealth = UnitHealth('player')
    if event == 'HEALTHTICK' then
        aura_env.inflight = aura_env.inflight - 1
        if currHealth == UnitHealthMax('player') then
            flag = true
        end
    elseif currHealth > (aura_env.lastHealth or 0) + 14 then
        flag = true
    end
    if flag then
        local duration = 2
        if not a[""] then
            a[""] = {
                show = true,
                changed = true,
                duration = duration,
                expirationTime = GetTime() + duration,
                progressType = "timed"
            }
        else
            local s = a[""]
            s.changed = true
            s.duration = duration
            s.expirationTime = GetTime() + duration
            s.show = true
            aura_env.inflight = aura_env.inflight or 0
            if aura_env.inflight == 0 then
                C_Timer.After(duration, function()
                        WeakAuras.ScanEvents("HEALTHTICK", true)
                end)
                aura_env.inflight = aura_env.inflight + 1
            end
        end
    end
    aura_env.lastHealth = currHealth
    return true
end
