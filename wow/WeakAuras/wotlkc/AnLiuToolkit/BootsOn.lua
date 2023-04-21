-- Trigger 1 / Custom / Event: ENCOUNTER_END
function(event, ...)
    local bootsLeather = 23824
    local bootsCloth = 35581

    if IsEquippedItem(bootsLeather) or IsEquippedItem(bootsCloth) then
        return false
    end

    local function switchOn(bootsId, retryNum)
        if not IsEquippedItem(bootsId) then
            if (InCombatLockdown() or nil ~= EquipItemByName(bootsId)) and retryNum > 0 then
                C_Timer.After(4.0, function()
                    switchOn(bootsId, retryNum - 1)
                end)
            end
        end
    end

    if 'ENCOUNTER_END' == event then
        local encounterId, encounterName, difficultyId, groupSize, success = ...
        local allows = {
            [1942] = 'Hydromancer Thespia',
            [754] = 'Mimiron',
            [757] = 'Algalon the Observer',
        }
        DEFAULT_CHAT_FRAME:AddMessage('|cFFFFF468[AnLiuToolkits-BootsOn] Encounter ' .. tostring(encounterId) .. (success and ' success.' or ' failed.'))
        if allows[encounterId] and success then
            if GetItemCount(bootsLeather) > 0 then
                C_Timer.After(0.4, function()
                    switchOn(bootsLeather, 8)
                end)
            elseif GetItemCount(bootsCloth) > 0 then
                C_Timer.After(0.4, function()
                    switchOn(bootsCloth, 8)
                end)
            end
        end
    end

    return false
end
