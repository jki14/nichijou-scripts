-- Trigger 1: CHAT_MSG_RAID_LEADER
function(e, text, playerName, languageName, channelName, playerName2,
specialFlags, zoneChannelID, channelIndex, channelBaseName, unused, lineID,
guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons)
    if string.find(text, 'Hitem:34845:') then
        SendChatMessage('100', 'RAID')
    end
    return false
end
