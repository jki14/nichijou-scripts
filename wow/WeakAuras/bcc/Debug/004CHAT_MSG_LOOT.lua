function(e, text, playerName, languageName, channelName, playerName2,
specialFlags, zoneChannelID, channelIndex, channelBaseName, unused, lineID,
guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons)
    local function emit(key, value)
        print(key .. ': ' .. (value or 'nil'))
    end
    emit('text', text)
    emit('playerName', playerName)
    emit('languageName', languageName)
    emit('channelName', channelName)
    emit('playerName2', playerName2)
    emit('specialFlags', specialFlags)
    emit('zoneChannelID', zoneChannelID)
    emit('channelIndex', channelIndex)
    emit('channelBaseName', channelBaseName)
    emit('unused', unused)
    emit('lineID', lineID)
    emit('guid', guid)
    emit('bnSenderID', bnSenderID)
    emit('isMobile', isMobile)
    emit('isSubtitle', isSubtitle)
    emit('hideSenderInLetterbox', hideSenderInLetterbox)
    emit('supressRaidIcons', supressRaidIcons)
end
