-- trigger: PLAYER_TARGET_CHANGED
function()
    local officiers = { }
    officiers['14438'] = 2
    officiers['14423'] = 6
    officiers['14439'] = 3

    local guid = select(6, strsplit("-", UnitGUID('target')))
    if guid and officiers[guid] then
        local iconId = officiers[guid]
        if GetRaidTargetIndex('target') ~= iconId then
            SetRaidTarget('target', iconId)
        end
    end

    return false
end

-- macro
/targetexact Officer Brady
/targetexact Officer Jaxon
/targetexact Officer Pomeroy
