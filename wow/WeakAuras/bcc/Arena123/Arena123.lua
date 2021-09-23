--trigger state updater: event(s): NAME_PLATE_UNIT_ADDED, NAME_PLATE_UNIT_REMOVED
function(allstates, event, unit)
    if unit and event == 'NAME_PLATE_UNIT_ADDED' then
        for i = 1, 5 do
            local slot = string.format('arena%d',i)
            if UnitIsUnit(slot, unit) then
                allstates[slot] = {
                    changed = true,
                    show = true,
                    name = string.format('>%d<', i),
                    progressType = 'static',
                    value = 1,
                    total = 1,
                    autoHide = false,
                    -- appendix
                    unit = unit
                }
                break
            end
        end
    end

    if unit and event == 'NAME_PLATE_UNIT_REMOVED' then
        for i = 1, 5 do
            local slot = string.format('arena%d',i)
            if allstates[slot].unit and allstates[slot].unit == unit then
                allstates[slot] = {
                    changed = true,
                    show = false,
                    -- appendix
                    unit = nil
                }
                break
            end
        end
    end

    return true
end


--custom text
function()
    return aura_env and aura_env.state and aura_env.state.name or ''
end


--custom anchor
function()
    return aura_env.state and aura_env.state.unit and C_NamePlate.GetNamePlateForUnit(aura_env.state.unit) or nil
end
