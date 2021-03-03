-- Actions: On-Init
C_Timer.After(2, function()
    if not UnitInRaid('player') then
        SendChatMessage('123', 'WHISPER', nil, '二舅的姐夫')
    end
end)

-- Trigger Custom Event: PARTY_INVITE_REQUEST
function(...)
    AcceptGroup()
    StaticPopup_Hide('PARTY_INVITE')
    return false
end
