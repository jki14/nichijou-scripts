-- Trigger 1 / Custom / Event: NAME_PLATE_UNIT_ADDED, NAME_PLATE_UNIT_REMOVED
function(event, unit)
    local guid = unit and UnitGUID(unit) or nil
    if guid then
        wa_global = wa_global or { }
        wa_global.nameplates = wa_global.nameplates or { }
        wa_global.nameplates[guid] = event == 'NAME_PLATE_UNIT_ADDED' and unit or nil
    end
    return false
end
