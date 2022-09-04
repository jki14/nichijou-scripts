-- trigger: PLAYER_TARGET_CHANGED
function()
    local officiers = { }
    officiers['14438'] = 2
    officiers['14423'] = 6
    officiers['14439'] = 3
    officiers['14363'] = 2
    officiers['14367'] = 6
    officiers['14365'] = 3

    local guid = UnitGUID('target')
    guid = guid and select(6, strsplit('-', guid)) or ''
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
/targetexact Thief Catcher Farmountain
/targetexact Thief Catcher Thunderbrew
/targetexact Thief Catcher Shadowdelve
