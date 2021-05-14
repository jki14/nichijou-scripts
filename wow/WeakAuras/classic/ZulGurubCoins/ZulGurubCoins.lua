--trigger: GOSSIP_SHOW,QUEST_PROGRESS
function(e, ...)
    local guid = select(6, strsplit("-", UnitGUID('target')))
    if guid ~= '15070' then
        return false
    end
    if e == 'QUEST_PROGRESS' then
        CompleteQuest()
        C_Timer.After(0.3, function()
            QuestFrameCompleteQuestButton:Click()
        end)
        return false
    end
    local bar = { }
    bar['Zulian, Razzashi, and Hakkari Coins'] = {19698, 19699, 19700}
    bar['Gurubashi, Vilebranch, and Witherbark Coins'] = {19701, 19702, 19703}
    bar['Sandfury, Skullsplitter, and Bloodscalp Coins'] = {19704, 19705, 19706}
    local n = GetNumGossipAvailableQuests()
    for i = 1, n do
        local title = select(i * 7 - 6, GetGossipAvailableQuests())
        if bar[title] then
            local req = bar[title]
            local flag = true
            for j = 1, #req do
                if GetItemCount(req[j]) <= 1 then
                    flag = false
                    break
                end
            end
            if flag then
                SelectGossipAvailableQuest(i)
                break
            end
        end
    end
    return false
end
