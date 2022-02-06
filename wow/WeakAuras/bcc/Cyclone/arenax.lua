--trigger state updater: event(s): COMBAT_LOG_EVENT_UNFILTERED
function(allstates, event, ...)
    local _, subevent, _, _, _, _, _, destGUID = ...
    if string.sub(subevent, 1, 6) ~= 'SPELL_' then
        return false
    else
        local modifiedBy = { }
        modifiedBy[2825] = 'Bloodlust'
        modifiedBy[32182] = 'Heroism'
        modifiedBy[11719] = 'Curse of Tongues'
        modifiedBy[1714] = 'Curse of Tongues'
        local spellId = select(12, ...)
        if spellId ~= 33786 and (not modifiedBy[spellId] or destGUID ~= UnitGUID('player')) then
            return false
        end
    end
    local flag = false
    local castTime = select(4, GetSpellInfo(33786)) * 0.001
    for i = 1, 5 do
        local unit = string.format('arena%d', i)
        local guid = UnitGUID(unit)
        if guid and (destGUID == guid or (spellId ~= 33786 and allstates[unit] and allstates[unit].show)) then
            local _, _, _, _, duration, expirationTime = WA_GetUnitDebuff(unit, 33786)
            duration = duration and duration - castTime > 0 and duration - castTime or nil
            expirationTime = duration and expirationTime and expirationTime - castTime or nil
            local show = expirationTime and expirationTime > GetTime() or false
            if show or allstates[unit] then
                if not allstates[unit] or (allstates[unit].show ~= show) or (expirationTime and allstates[unit].expirationTime ~= expirationTime) then
                    allstates[unit] = {
                        changed = true,
                        show = show,
                        name = unit,
                        progressType = "timed",
                        duration = duration,
                        expirationTime = expirationTime,
                        icon = 136022,
                        tooltip = 'pending',
                        autoHide = true,
                        anchor = string.format('GladdyButton%d', i)
                    }
                    flag = true
                end
            end
        end
    end
    return flag
end

--custom anchor
function()
    return aura_env.state and aura_env.state.anchor
end
