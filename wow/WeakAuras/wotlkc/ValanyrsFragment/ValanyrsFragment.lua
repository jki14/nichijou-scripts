-- Trigger-1 / Custom / Event: START_LOOT_ROLL
function(e, id, ...)
    if e == 'START_LOOT_ROLL' then
        local _, _, _, quality = GetLootRollItemInfo(id)
        if quality == 5 then
            RollOnLoot(id, 2)
        else
            RollOnLoot(id, 0)
        end
    end
    return false
end
