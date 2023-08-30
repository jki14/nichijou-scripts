--trigger: GOSSIP_SHOW,QUEST_PROGRESS
function(e, ...)
    local guid = UnitGUID('target') and select(6, strsplit("-", UnitGUID('target'))) or ''
    if guid ~= '15070' and guid ~= '16205' and guid ~= '18538' and guid ~= '18530' and guid ~= '32540' then
        return false
    end
    if e == 'QUEST_PROGRESS' then
        CompleteQuest()
        C_Timer.After(0.8, function()
            QuestFrameCompleteQuestButton:Click()
        end)
        return false
    end
    local bar = {
        [8195] = {19698, 19699, 19700}, -- Zulian, Razzashi, and Hakkari Coins
        [8238] = {19701, 19702, 19703}, -- Gurubashi, Vilebranch, and Witherbark Coins
        [8239] = {19704, 19705, 19706}, -- Sandfury, Skullsplitter, and Bloodscalp Coins
        [9217] = {22641}, -- More Rotting Hearts
        [9219] = {22642}, -- More Spinal Dust
        [10419] = {29739}, -- Arcane Tomes
        [10421] = {29740}, -- Fel Armaments
        [13559] = {42780}, -- Hodir's Tribute
    }
    local n = C_GossipInfo.GetNumAvailableQuests()
    for i = 1, n do
        local questId = C_GossipInfo.GetAvailableQuests()[i].questID
        if bar[questId] then
            local req = bar[questId]
            local flag = true
            for j = 1, #req do
                if GetItemCount(req[j]) <= 1 then
                    flag = false
                    break
                end
            end
            if flag then
                C_GossipInfo.SelectAvailableQuest(questId)
                break
            end
        end
    end
    return false
end
