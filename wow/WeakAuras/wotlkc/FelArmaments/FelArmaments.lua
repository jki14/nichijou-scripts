--trigger: GOSSIP_SHOW,QUEST_PROGRESS
function(e, ...)
    local guid = select(6, strsplit("-", UnitGUID('target')))
    if guid ~= '18538' and guid ~= '18530' and guid ~= '32540' then
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