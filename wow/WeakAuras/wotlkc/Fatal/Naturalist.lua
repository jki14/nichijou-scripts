-- Trigger 1 / Custom / Event: ENCOUNTER_END
function(event, ...)
    if 'ENCOUNTER_END' == event then
        local encounterId, _, _, _, success = ...
        return encounterId == 641 and success
    end
    return false
end
