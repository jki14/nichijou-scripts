--trigger state updater: event(s): NAME_PLATE_UNIT_ADDED, NAME_PLATE_UNIT_REMOVED, UNIT_SPELLCAST_SUCCEEDED, COMBAT_LOG_EVENT_UNFILTERED
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
    elseif event == 'UNIT_SPELLCAST_SUCCEEDED' or select(2, ...) == 'SPELL_CAST_SUCCESS' then
        local spells = {}
        -- Lizard Bolt
        spells[5401] = {
            cooldown = 15,
            icon = 136048
        }
        -- Blink
        spells[1953] = {
            cooldown = 15,
            icon = 135736
        }
        -- Shadowstep
        spells[36554] = {
            cooldown = 30,
            icon = 132303
        }
        -- Intercept
        spells[25275] = {
            cooldown = 15,
            icon = 132307
        }
        local guid = event == 'UNIT_SPELLCAST_SUCCEEDED' and UnitGUID(select(1, ...)) or select(4, ...)
        local spellID = event == 'UNIT_SPELLCAST_SUCCEEDED' and select(3, ...) or select(12, ...)
        if spells[spellID] then
            wa_global = wa_global or { }
            wa_global.nameplates = wa_global.nameplates or { }
            local timestamp = GetTime()
            if not allstates[guid] or allstates[guid].expirationTime - 0.2 < timestamp then
                allstates[guid] = {
                    changed = true,
                    show = true,
                    progressType = 'timed',
                    duration = spells[spellID].cooldown,
                    expirationTime = timestamp + spells[spellID].cooldown,
                    name = guid,
                    icon = spells[spellID].icon,
                    autoHide = true,
                    -- appendix
                    unit = wa_global.nameplates[guid] and UnitGUID(wa_global.nameplates[guid]) == guid and wa_global.nameplates[guid] or nil
                }
            end
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
