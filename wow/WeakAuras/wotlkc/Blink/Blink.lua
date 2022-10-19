--trigger state updater: event(s): NAME_PLATE_UNIT_ADDED, NAME_PLATE_UNIT_REMOVED, UNIT_SPELLCAST_SUCCEEDED, COMBAT_LOG_EVENT_UNFILTERED
function(allstates, event, ...)
    if event == 'NAME_PLATE_UNIT_ADDED' or event == 'NAME_PLATE_UNIT_REMOVED' then
        local unit = ...
        local guid = unit and UnitGUID(unit) or ''
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
            icon = 136048,
            postrick = 3
        }
        -- Blink
        spells[1953] = {
            cooldown = 15,
            icon = 135736,
            postrick = 1
        }
        -- Shadowstep
        spells[36554] = {
            cooldown = 30,
            icon = 132303,
            postrick = 1
        }
        -- Intercept
        spells[20252] = {
            cooldown = 15,
            icon = 132307,
            postrick = 1
        }
        -- Death Grip
        spells[49576] = {
            cooldown = 35,
            icon = 237532,
            postrick = 1
        }
        -- Counterspell
        spells[2139] = {
            cooldown = 24,
            icon = 135856,
            postrick = 2
        }
        -- Spell Lock
        spells[19647] = {
            cooldown = 24,
            icon = 136174,
            postrick = 2
        }
        -- Spell Lock
        spells[19647] = {
            cooldown = 24,
            icon = 136174,
            postrick = 2
        }
        -- Silence
        spells[15487] = {
            cooldown = 45,
            icon = 136164,
            postrick = 2
        }
        -- Kick
        spells[1766] = {
            cooldown = 10,
            icon = 132219,
            postrick = 2
        }
        -- Feral Charge - Bear
        spells[16979] = {
            cooldown = 15,
            icon = 132183,
            postrick = 2
        }
        -- Wind Shear
        spells[57994] = {
            cooldown = 6,
            icon = 136018,
            postrick = 2
        }
        -- Silencing Shot
        spells[34490] = {
            cooldown = 20,
            icon = 132323,
            postrick = 2
        }
        -- Pummel
        spells[6552] = {
            cooldown = 10,
            icon = 132938,
            postrick = 2
        }
        -- Shield Bash
        spells[72] = {
            cooldown = 12,
            icon = 132357,
            postrick = 2
        }
        -- Mind Freeze
        spells[47528] = {
            cooldown = 10,
            icon = 237527,
            postrick = 2
        }
        -- Deep Freeze
        spells[44572] = {
            cooldown = 30,
            icon = 236214,
            postrick = 3
        }
        -- Psychic Scream
        spells[10890] = {
            cooldown = 30,
            icon = 136184,
            postrick = 3
        }
        -- Death Coil
        spells[47860] = {
            cooldown = 120,
            icon = 136145,
            postrick = 3
        }
        -- Kidney Shot
        spells[8643] = {
            cooldown =20,
            icon = 132298,
            postrick = 3
        }
        -- Scatter Shot
        spells[19503] = {
            cooldown = 30,
            icon = 132153,
            postrick = 3
        }
        -- Strangulate
        spells[47476] = {
            cooldown = 120,
            icon = 136214,
            postrick = 3
        }
        local guid = event == 'UNIT_SPELLCAST_SUCCEEDED' and select(1, ...) and UnitGUID(select(1, ...)) or select(4, ...)
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
                    stacks = spells[spellID].postrick,
                    autoHide = true,
                    -- appendix
                    unit = wa_global.nameplates[guid] and UnitGUID(wa_global.nameplates[guid]) == guid and wa_global.nameplates[guid] or nil
                }
            end
        end
    end

    return true
end


--custom variables
{
    stacks = true,
}


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
