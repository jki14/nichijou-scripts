-- trigger CHAT_MSG_EMOTE
function(e, text, _, _, _, _, _, _, _, _, _, _, guid, ...)
    local player = UnitGUID('player')
    if guid == player and text == 'equipmacro' then
        local bar = '/run local foo='
        for i = 1, 18 do
            if i > 1 then
                bar = bar .. ','
            else
                bar = bar .. '{'
            end
            local itemId = GetInventoryItemID('player', i) or 0
            bar = bar .. tostring(itemId)
        end
        bar = bar .. '};for i=1,18 do EquipItemByName(foo[i], i);end'
        print(bar)
    end
    return false
end
