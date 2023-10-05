-- Trigger 1 / trigger state updater: event(s): FATAL_DEFILE
function(allstates, ...)
    local show = wa_global and wa_global.defile and wa_global.defile.decision and wa_global.defile.decision.show or false
    local expiration = wa_global and wa_global.defile and wa_global.defile.decision and wa_global.defile.decision.expiration or 0.0
    local flag = false
    if allstates[''] or show then
        if allstates[''] then
            flag = allstates[''].show ~= show
            flag = flag or math.abs(allstates[''].expirationTime - expiration) > 1e-4
        else
            flag = true
        end
        if flag then
            allstates[''] = {
                changed = true,
                show = show,
                unit = 'player',
                progressType = 'timed',
                duration = 2.0,
                expirationTime = expiration,
                autoHide = true,
            }
        end
    end
    return flag
end

-- Trigger 2 / Customer / Event(s): UNIT_SPELLCAST_START, CLEU:SPELL_CAST_START
function(event, ...)
    local DefaultChatFrame = DefaultChatFrame or { AddMessage = function(...) end }

    local unit,  spellId = '', 0
    if event == 'UNIT_SPELLCAST_START' then
        local unit2, _, spellId2 = ...
        unit, spellId = unit2, spellId2
    elseif event == 'COMBAT_LOG_EVENT_UNFILTERED' then
        local _, subevent, _, srcGUID, _, _, _, _, _, _, _, spellId2 = ...
        if subevent == 'SPELL_CAST_START' then
            spellId = spellId2
            for i = 1, 40 do
                local candidate = string.format('raid%dtarget', i)
                if UnitGUID(candidate) == srcGUID then
                    unit = candidate
                    break
                end
            end
        end
    end
    if spellId ~= 0 then
        -- DefaultChatFrame:AddMessage('|cFFAD7FA8[FATAL_DEFLITE] "' .. unit .. '" spellcast ' .. spellId .. ' start.')
        wa_global = wa_global or { }
        wa_global.defile = wa_global.defile or { }
        -- wa_global.defile.spellname = wa_global.defile.spellname or GetSpellInfo(5401)
        -- if spellId == 5401 or spellId == wa_global.defile.spellname then
        wa_global.defile.spellname = wa_global.defile.spellname or GetSpellInfo(72762)
        if spellId == 72762 or spellId == wa_global.defile.spellname then
            wa_global.defile.prioritized = wa_global.defile.prioritized or { }
            wa_global.defile.prioritized[unit] = GetTime() + 2.0
            wa_global.defile.control = wa_global.defile.control or CreateFrame('Frame')
            if wa_global.defile.control:GetScript('OnUpdate') == nil then
                wa_global.defile.control:SetScript('OnUpdate', function(self, elapsed)
                    self.stacked = (self.stacked or 0) + elapsed
                    if self.stacked > 0.05 then
                        self.stacked = 0
                        local show, expiration = false, 0.0
                        local fallback = true
                        local curr = GetTime()
                        if wa_global and wa_global.defile then
                            for unit, _ in pairs(wa_global.defile.prioritized) do
                                if wa_global.defile.prioritized[unit] < curr then
                                    wa_global.defile.prioritized[unit] = nil
                                else
                                    expiration = math.max(wa_global.defile.prioritized[unit], expiration)
                                    if UnitCastingInfo(unit) == wa_global.defile.spellname then
                                        show = show or UnitIsUnit(unit .. 'target', 'player')
                                        fallback = false
                                    end
                                end
                            end
                        end
                        if expiration < 1e-4 then
                            self:SetScript("OnUpdate", nil)
                            fallback = false
                            -- DefaultChatFrame:AddMessage('|cFFAD7FA8[FATAL_DEFLITE] OnUpdate checking end.')
                        elseif fallback and wa_global and wa_global.defile and wa_global.defile.spellname then
                            for i = 1, 40 do
                                local unit = string.format('raid%dtarget', i)
                                if UnitCastingInfo(unit) == wa_global.defile.spellname then
                                    show = show or UnitIsUnit(unit .. 'target', 'player')
                                    fallback = false
                                    break
                                end
                            end
                        end
                        if wa_global and wa_global.defile then
                            show = show or (wa_global.defile.decision and wa_global.defile.decision.show and fallback)
                            wa_global.defile.decision = {
                                show = show,
                                expiration = expiration
                            }
                        end
                        -- DefaultChatFrame:AddMessage('|cFFAD7FA8[FATAL_DEFLITE] Decision Updated: show = ' .. tostring(show) .. ' expiration = ' .. tostring(expiration) .. '.')
                        WeakAuras.ScanEvents('FATAL_DEFILE')
                    end
                end)
                -- DefaultChatFrame:AddMessage('|cFFAD7FA8[FATAL_DEFLITE] OnUpdate checking begin.')
            end
        end
    end
    return false
end
