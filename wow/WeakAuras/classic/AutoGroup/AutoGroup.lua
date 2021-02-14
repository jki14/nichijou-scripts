-- Actions: On-Init
SendChatMessage('123', 'WHISPER', nil, '二舅的姐夫')

-- Trigger Custom Event: PARTY_INVITE_REQUEST
function(...)
    AcceptGroup()
    StaticPopup_Hide('PARTY_INVITE')
    return false
end
