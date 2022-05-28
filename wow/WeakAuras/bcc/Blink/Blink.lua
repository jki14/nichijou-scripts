--trigger state updater: event(s): NAME_PLATE_UNIT_ADDED, NAME_PLATE_UNIT_REMOVED, UNIT_SPELLCAST_SUCCEEDED
function(allstates, event, ...)
    if event == 'NAME_PLATE_UNIT_ADDED' or event == 'NAME_PLATE_UNIT_REMOVED' then
        local unit = ...
        local guid = UnitGUID(unit)
        if allstates[guid] then
            allstates[guid].changed = true
            allstates[guid].unit = event == 'NAME_PLATE_UNIT_ADDED' and unit or nil
        end
        wa_global = wa_global or { }
        wa_global.nameplates = wa_global.nameplates or { }
        wa_global.nameplates[guid] = event == 'NAME_PLATE_UNIT_ADDED' and unit or nil
    end

    if event == 'UNIT_SPELLCAST_SUCCEEDED' then
        local spells = {}
        spells[5401] = {
            cooldown = 15,
            icon = 136048
        }
        local unit, castGUID, spellID = ...
        if spells[spellID] then
            wa_global = wa_global or { }
            wa_global.nameplates = wa_global.nameplates or { }
            local guid = UnitGUID(unit)
            allstates[guid] = {
                changed = true,
                show = true,
                progressType = 'timed',
                duration = spells[spellID].cooldown,
                expirationTime = GetTime() + spells[spellID].cooldown,
                name = unit,
                icon = spells[spellID].icon,
                autoHide = true,
                -- appendix
                unit = wa_global.nameplates[guid] and UnitIsUnit(wa_global.nameplates[guid], unit) and wa_global.nameplates[guid] or nil
            }
        end
    end

    return true
end


--custom anchor
function()
    local nameplate = aura_env.state and aura_env.state.unit and C_NamePlate.GetNamePlateForUnit(aura_env.state.unit) or nil
    if nameplate then
        aura_env.region:Color(1,1,1,1)
        aura_env.region:SetCooldownSwipe(true)
    else
        aura_env.region:Color(1,1,1,0)
        aura_env.region:SetCooldownSwipe(false)
    end
    return nameplate
end
