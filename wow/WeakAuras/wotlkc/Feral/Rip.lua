-- Trigger 2 / Custom / Event(s): COMBAT_LOG_EVENT_UNFILTERED, PLAYER_TARGET_CHANGED
function(event, ...)
    local changed = false
    if 'COMBAT_LOG_EVENT_UNFILTERED' == event then
        local _, subevent, _, sourceGuid, _, _, _, guid, _, _, _, spellId = ...
        if UnitGUID('player') == sourceGuid then
            if 49800 == spellId then
                if subevent == 'SPELL_AURA_APPLIED' or subevent == 'SPELL_AURA_REFRESH' then
                    wa_global = wa_global or { }
                    wa_global.shreds = wa_global.shreds or { }
                    wa_global.shreds[guid] = 0
                    changed = true
                elseif subevent == 'SPELL_AURA_REMOVED' then
                    wa_global = wa_global or { }
                    wa_global.shreds = wa_global.shreds or { }
                    wa_global.shreds[guid] = nil
                    changed = true
                end
            elseif 48572 == spellId then
                if subevent == 'SPELL_DAMAGE' then
                    wa_global = wa_global or { }
                    wa_global.shreds = wa_global.shreds or { }
                    wa_global.shreds[guid] = wa_global.shreds[guid] and wa_global.shreds[guid] + 1 or nil
                    changed = true
                end
            end
        end
    end

    if changed or 'PLAYER_TARGET_CHANGED' == event then
        local guid = UnitGUID('target')
        if guid then
            local stacks = wa_global and wa_global.shreds and wa_global.shreds[guid] or 0
            for i, subregion in ipairs(aura_env.region.subRegions) do
                if subregion.type == 'subborder' then
                    if stacks == 0 then
                        subregion:SetBorderColor(173 / 255, 127 / 255, 168 / 255, 1)
                    elseif stacks == 1 then
                        subregion:SetBorderColor(113 / 255, 159 / 255, 207 / 255, 1)
                    elseif stacks == 2 then
                        subregion:SetBorderColor(154 / 255, 226 / 255, 52 / 255, 1)
                    else
                        subregion:SetBorderColor(1, 1, 1, 1)
                    end
                end
            end
        end
    end

    return false
end
