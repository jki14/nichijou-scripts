-- Trigger Custom Event: CHAT_MSG_PARTY, CHAT_MSG_PARTY_LEADER, CHAT_MSG_RAID_LEADER, CHAT_MSG_RAID
function(event, text, playerName, languageName, channelName, playerName2,
         specialFlags, zoneChannelID, channelIndex, channelBaseName, unused,
         lineID, guid, ...)
    local startFlag = {
        ['1'] = true,
        ['11'] = true,
        ['111'] = true
    }
    local stopFlag = {
        ['2'] = true,
        ['22'] = true,
        ['222'] = true
    }
    if guid ~= UnitGUID('player') then
        if startFlag[text] then
            FollowUnit(playerName2)
        elseif stopFlag[text] then
            FollowUnit('player')
        end
    end
    return false
end
