-- Trigger 1 / Custom / Event: ENCOUNTER_END, PLAYER_REGEN_ENABLED, PLAYER_TARGET_CHANGED
function(event, ...)
    local function rotate(relicId, retryNum)
        if not IsEquippedItem(relicId) then
            if (InCombatLockdown() or nil ~= EquipItemByName(relicId)) and retryNum > 0 then
                C_Timer.After(0.4, function()
                    rotate(relicId, retryNum - 1)
                end)
            end
        end
    end

    if 'ENCOUNTER_END' == event then
        local encounterId, encounterName, difficultyId, groupSize, success = ...
        local blocks = {
            [1112] = 'Heigan the Unclean',
            [1111] = 'Grobbulus',
            [1120] = 'Thaddius',
            [1119] = 'Sapphiron',
            [1114] = 'Kel\'Thuzad',
        }
        DEFAULT_CHAT_FRAME:AddMessage('|cFFFFF468[RelicRotate] Encounter ' .. tostring(encounterId) .. ' end.')
        if not blocks[encounterId] then
            C_Timer.After(0.4, function()
                rotate(38295, 4)
            end) -- Idol of the Wastes
        end
    elseif 'PLAYER_REGEN_ENABLED' == event then
        if -1 == UnitLevel('target') then
            C_Timer.After(0.4, function()
                rotate(39757, 4)
            end) -- Idol of Worship
        end
    else
        if not InCombatLockdown() and -1 == UnitLevel('target') then
            rotate(39757, 0) -- Idol of Worship
        end
    end

    return false
end
