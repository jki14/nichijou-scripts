-- WT_ENGAGE, CHAT_MSG_PARTY, CHAT_MSG_PARTY_LEADER
function(e, ...)
    if e == 'WT_ENGAGE' then
    else
        local text = select(1, ...)
        if text == '[WT-MSG]Windfury Up' then
        elseif text == '[WT-MSG]Windfury Down' then
        end
    end
    return false
end
