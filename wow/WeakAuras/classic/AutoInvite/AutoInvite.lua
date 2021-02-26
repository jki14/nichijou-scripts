-- Actions: On-Init
local frame = CreateFrame('Frame')
frame:RegisterEvent('CHAT_MSG_WHISPER')
frame:SetScript("OnEvent", function(_, _, text, name)
    if text == '123' then
        InviteUnit(name)
        ConvertToRaid()
    end
end)
