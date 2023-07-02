-- Trigger 3 / Custom / Event: ENCOUNTER_END, GROUP_ROSTER_UPDATE
function(event)
    return select(3, GetRaidRosterInfo(1)) ~= 1
end
