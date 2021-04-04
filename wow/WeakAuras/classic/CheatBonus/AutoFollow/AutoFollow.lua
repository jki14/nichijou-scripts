-- Trigger Custom Event: PLAYER_TARGET_CHANGED
function(...)
    if UnitInRaid('target') then
        FollowUnit('target')
    else
        FollowUnit('player')
    end
    return false
end
