--trigger state updater: event(s): NAME_PLATE_UNIT_ADDED, NAME_PLATE_UNIT_REMOVED, COMBAT_LOG_EVENT_UNFILTERED
function(allstates, event, ...)
    if event == 'NAME_PLATE_UNIT_ADDED' or event == 'NAME_PLATE_UNIT_REMOVED' then
        local unit = ...
        local guid = unit and UnitGUID(unit) or nil
        if guid and allstates[guid] then
            allstates[guid].changed = true
            allstates[guid].unit = event == 'NAME_PLATE_UNIT_ADDED' and unit or nil
        end
    else
        local _, subevent, _, sourceGuid, _, _, _, guid, _, _, _, spellId = ...
        if UnitGUID('player') == sourceGuid then
            if 49800 == spellId then
                if subevent == 'SPELL_AURA_APPLIED' or subevent == 'SPELL_AURA_REFRESH' then
                    local _, _, _, _, duration, expirationTime = WA_GetUnitDebuff('target', 52610, 'PLAYER')
                    allstates[guid] = {
                        changed = true,
                        show = true,
                        progressType = 'timed',
                        duration = duration or 20,
                        expirationTime = expirationTime or GetTime() + 20,
                        name = guid .. '_GlyphOfShred',
                        icon = 136231,
                        stacks = 3,
                        autoHide = true,
                        unit = wa_global and wa_global.nameplates[guid] and UnitGUID(wa_global.nameplates[guid]) == guid and wa_global.nameplates[guid] or nil,
                    }
                elseif subevent == 'SPELL_AURA_REMOVED' then
                    allstates[guid] = {
                        changed = true,
                        show = false,
                        progressType = 'timed',
                        duration = 0,
                        expirationTime = GetTime(),
                        name = guid .. '_GlyphOfShred',
                        icon = 136231,
                        stacks = 0,
                        autoHide = true,
                        unit = wa_global and wa_global.nameplates[guid] and UnitGUID(wa_global.nameplates[guid]) == guid and wa_global.nameplates[guid] or nil,
                    }
                end
            elseif 48572 == spellId then
                if subevent == 'SPELL_DAMAGE' and allstates[guid] and GetTime() <= (allstates[guid].expirationTime or 0) then
                    if allstates[guid].stacks > 1 then
                        allstates[guid] = {
                            changed = true,
                            show = true,
                            progressType = 'timed',
                            duration = allstates[guid].duration + 2,
                            expirationTime = allstates[guid].expirationTime + 2,
                            name = guid .. '_GlyphOfShred',
                            icon = 136231,
                            stacks = allstates[guid].stacks - 1,
                            autoHide = true,
                            unit = wa_global and wa_global.nameplates[guid] and UnitGUID(wa_global.nameplates[guid]) == guid and wa_global.nameplates[guid] or nil,
                        }
                    else
                        allstates[guid] = {
                            changed = true,
                            show = false,
                            progressType = 'timed',
                            duration = 0,
                            expirationTime = GetTime(),
                            name = guid .. '_GlyphOfShred',
                            icon = 136231,
                            stacks = 0,
                            autoHide = true,
                            unit = wa_global and wa_global.nameplates[guid] and UnitGUID(wa_global.nameplates[guid]) == guid and wa_global.nameplates[guid] or nil,
                        }
                    end
                end
            end
        end
    end

    return true
end

--custom variables
{
    stacks = true,
}
