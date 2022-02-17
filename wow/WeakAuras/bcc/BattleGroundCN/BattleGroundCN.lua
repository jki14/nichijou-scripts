-- custom events: CHAT_MSG_INSTANCE_CHAT, CHAT_MSG_INSTANCE_CHAT_LEADER
function(e, text, _, _, _, _, _, _, _, _, _, _, guid, ...)
    if guid == UnitGUID('player') then
        local enCN = {
            ['Farm'] = '农场',
            ['Lumber Mill'] = '伐木场',
            ['Blacksmith'] = '铁匠铺',
            ['Gold Mine'] = '矿洞',
            ['Stables'] = '兽栏'
        }
        for key, value in pairs(enCN) do
            if string.find(text, key) then
                SendChatMessage(string.gsub(text, key, value), 'INSTANCE_CHAT')
                break
            end
        end
    end
    return false
end
