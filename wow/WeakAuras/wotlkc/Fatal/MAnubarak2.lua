-- Trigger 3 / Custom / Event: ACTIVE_TALENT_GROUP_CHANGED, ACTIONBAR_SLOT_CHANGED, ENCOUNTER_END
function(event, ...)
    return  GetActionText(10) ~= '&Anubarak2'
end
