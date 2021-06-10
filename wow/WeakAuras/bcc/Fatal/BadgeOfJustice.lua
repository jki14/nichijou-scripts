-- Trigger 1: CHAT_MSG_LOOT
function(e, text, playerName, languageName, channelName, playerName2,
specialFlags, zoneChannelID, channelIndex, channelBaseName, unused, lineID,
guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons)
    if string.find(text, 'Hitem:29434:') then
        return true
    end
    return false
end

-- Trigger 2: CHAT_MSG_LOOT
function(e, text, playerName, languageName, channelName, playerName2,
specialFlags, zoneChannelID, channelIndex, channelBaseName, unused, lineID,
guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons)
    if string.find(text, 'Hitem:29434:') then
        if select(1, UnitName('player')) == playerName2 then
            return true
        end
    end
    return false
end

-- trigger combination: custom function
function(triggers)
    return triggers[1] and not triggers[2]
end
