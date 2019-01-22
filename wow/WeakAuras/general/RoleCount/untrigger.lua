function()
    if UnitInRaid('player') or UnitInParty('player') then
        return false
    end
    return true
end
