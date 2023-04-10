-- Trigger-1 / Custom / Event: START_LOOT_ROLL
function(e, id, ...)
    if e == 'START_LOOT_ROLL' then
        local _, name, _, quality = GetLootRollItemInfo(id)
        -- DEFAULT_CHAT_FRAME:AddMessage('|cFFFF8000[ValanyrsFragment] texture = ' .. texture .. ', name = ' .. name .. '.')
        if name == GetItemInfo(45038) then
            -- Fragment of Val'anyr
            local num = GetItemCount(45038)
            RollOnLoot(id, num > 0 and num < 30 and 2 or 0)
        elseif name == GetItemInfo(45857) then
            -- Archivum Data Disc
            local completed = C_QuestLog.IsQuestFlaggedCompleted(13817)
            RollOnLoot(id, completed and 0 or 2)
        elseif name == GetItemInfo(46110) then
            -- Alchemist's Cache
            RollOnLoot(id, 2)
        else
            RollOnLoot(id, 0)
        end
    end
    return false
end
