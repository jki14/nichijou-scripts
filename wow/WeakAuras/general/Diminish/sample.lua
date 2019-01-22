-- oninit
aura_env.unitmask = 'player'
aura_env.category = 'taunt'

-- trigger
function()
    local unitguid = UnitGUID(aura_env.unitmask)
    local archive = WA_DIMINISH and WA_DIMINISH[unitguid] and WA_DIMINISH[unitguid][aura_env.category]
    if archive then
        local timestamp = GetTime()
        if archive.stack > 0 and archive.timeout > timestamp then
            return true
        end
    end
    return false
end

-- duration
function()
    local unitguid = UnitGUID(aura_env.unitmask)
    local archive = WA_DIMINISH and WA_DIMINISH[unitguid] and WA_DIMINISH[unitguid][aura_env.category]
    if archive then
        return 18, archive.timeout 
    end
    return 0, 0
end

-- stack
function()
    local unitguid = UnitGUID(aura_env.unitmask)
    local archive = WA_DIMINISH and WA_DIMINISH[unitguid] and WA_DIMINISH[unitguid][aura_env.category]
    if archive then
        return archive.stack
    end
    return 0
end
