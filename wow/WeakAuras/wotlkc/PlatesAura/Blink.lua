--trigger state updater: event(s): NAME_PLATE_UNIT_ADDED, NAME_PLATE_UNIT_REMOVED, UNIT_SPELLCAST_SUCCEEDED, COMBAT_LOG_EVENT_UNFILTERED
function(allstates, event, ...)
    if event == 'NAME_PLATE_UNIT_ADDED' or event == 'NAME_PLATE_UNIT_REMOVED' then
        local unit = ...
        local guid = unit and UnitGUID(unit) or nil
        if guid and allstates[guid] then
            allstates[guid].changed = true
            allstates[guid].unit = event == 'NAME_PLATE_UNIT_ADDED' and unit or nil
        end
    elseif event == 'UNIT_SPELLCAST_SUCCEEDED' or select(2, ...) == 'SPELL_CAST_SUCCESS' then
        local spells = {}
        -- Lizard Bolt
        spells[5401] = {
            cooldown = 15,
            icon = 136048,
        }
        -- Blink
        spells[1953] = {
            cooldown = 15,
            icon = 135736,
        }
        -- Shadowstep
        spells[36554] = {
            cooldown = 30,
            icon = 132303,
        }
        -- Feral Charge - Bear
        spells[16979] = {
            cooldown = 15,
            icon = 132183,
        }
        -- Feral Charge - Cat
        spells[49376] = {
            cooldown = 30,
            icon = 304501,
        }
        -- Typhoon
        spells[236170] = {
            cooldown = 20,
            icon = 304501,
        }
        -- Thunderstorm
        spells[59159] = {
            cooldown = 45,
            icon = 237589,
        }
        -- Intercept
        spells[20252] = {
            cooldown = 15,
            icon = 132307,
        }
        -- Death Grip
        spells[49576] = {
            cooldown = 35,
            icon = 237532,
        }
        -- Counterspell
        spells[2139] = {
            cooldown = 24,
            icon = 135856,
        }
        -- Spell Lock
        spells[19647] = {
            cooldown = 24,
            icon = 136174,
        }
        -- Silence
        spells[15487] = {
            cooldown = 45,
            icon = 136164,
        }
        -- Kick
        spells[1766] = {
            cooldown = 10,
            icon = 132219,
        }
        -- Wind Shear
        spells[57994] = {
            cooldown = 6,
            icon = 136018,
        }
        -- Silencing Shot
        spells[34490] = {
            cooldown = 20,
            icon = 132323,
        }
        -- Pummel
        spells[6552] = {
            cooldown = 10,
            icon = 132938,
        }
        -- Shield Bash
        spells[72] = {
            cooldown = 12,
            icon = 132357,
        }
        -- Mind Freeze
        spells[47528] = {
            cooldown = 10,
            icon = 237527,
        }
        -- Deep Freeze
        spells[44572] = {
            cooldown = 30,
            icon = 236214,
        }
        -- Psychic Scream
        spells[10890] = {
            cooldown = 27,
            icon = 136184,
        }
        -- Death Coil
        spells[47860] = {
            cooldown = 120,
            icon = 136145,
        }
        -- Kidney Shot
        spells[8643] = {
            cooldown =20,
            icon = 132298,
        }
        -- Maim
        spells[49802] = {
            cooldown =10,
            icon = 49802,
        }
        -- Scatter Shot
        spells[19503] = {
            cooldown = 30,
            icon = 132153,
        }
        -- Strangulate
        spells[47476] = {
            cooldown = 120,
            icon = 136214,
        }
        local guid = event == 'UNIT_SPELLCAST_SUCCEEDED' and select(1, ...) and UnitGUID(select(1, ...)) or select(4, ...)
        local spellId = event == 'UNIT_SPELLCAST_SUCCEEDED' and select(3, ...) or select(12, ...)
        if spells[spellId] then
            local currts = GetTime()
            if not allstates[guid] or allstates[guid].expirationTime - 0.2 < currts then
                allstates[guid] = {
                    changed = true,
                    show = true,
                    progressType = 'timed',
                    duration = spells[spellId].cooldown,
                    expirationTime = currts + spells[spellId].cooldown,
                    name = guid .. '_' .. tostring(spells[spellId].icon),
                    icon = spells[spellId].icon,
                    autoHide = true,
                    unit = wa_global and wa_global.nameplates and wa_global.nameplates[guid] and UnitGUID(wa_global.nameplates[guid]) == guid and wa_global.nameplates[guid] or nil
                }
            end
        end
    end

    return true
end
