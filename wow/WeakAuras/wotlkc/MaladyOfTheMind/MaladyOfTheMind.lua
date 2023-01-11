-- Trigger 1 / Custom / Event(s): COMBAT_LOG_EVENT_UNFILTERED
function(event, _, subevent, _, _, _, _, _, destGuid, destName, ...)
    if subevent == "SPELL_AURA_APPLIED" then
        if spellId == 63830 or spellId == 63881 then
            if UnitIsGroupLeader('player') then
                SetRaidTarget(destName, 1)
            end
            if destGuid == UnitGUID('player') then
                if '1' ~= GetCVar('chatBubbles') then
                    SetCVar('chatBubbles', '1')
                end
                SendChatMessage('**!!!**', 'SAY')
                C_Timer.After(1.5, function()
                    SendChatMessage('**!!**', 'SAY')
                end)
                C_Timer.After(2.5, function()
                    SendChatMessage('**!**', 'SAY')
                end)
            end
        end
    elseif subevent == "SPELL_AURA_REMOVED" then
        if spellId == 63830 or spellId == 63881 then
            if UnitIsGroupLeader('player') then
                SetRaidTarget(destName, 0)
            end
        end
    end
    return false
end
