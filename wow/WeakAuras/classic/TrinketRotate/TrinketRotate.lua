-- Trigger: PLAYER_REGEN_ENABLED
function()
    local function rotate(trinkets, slotId)
        local effectiveWindow = { }
        effectiveWindow[21180] = 102 -- Earthstrike
        effectiveWindow[19949] = 102 -- Zandalarian Hero Medallion
        effectiveWindow[23558] = 102 -- The Burrower's Shell

        local itemId, _ = GetInventoryItemID('player', slotId)
        local startTime, duration, _ = GetItemCooldown(itemId)
        local cooldown = startTime + duration - GetTime()

        if cooldown > 40 then
            if effectiveWindow[itemId] and
                    cooldown > effectiveWindow[itemId] then
                return
            end
            local otherId, _ = GetInventoryItemID('player',
                                                  (slotId == 13) and 14 or 13)
            for i = 1, #trinkets do
                local itemId = trinkets[i]
                if itemId ~= otherId then
                    local startTime, duration, _ = GetItemCooldown(itemId)
                    local cooldown = startTime + duration - GetTime()
                    if cooldown < 40 then
                        EquipItemByName(itemId, slotId)
                        break
                    end
                end
            end
        end
    end

    if InCombatLockdown() then
        return false
    end
    
    local feral_offensive = { 
        21180, -- Earthstrike
        19949, -- Zandalarian Hero Medallion
        11815  -- Hand of Justice
    }
    rotate(feral_offensive, 13)

    local feral_defensive = {
        18853, -- Insignia of the Horde
        23558, -- The Burrower's Shell
        13966  -- Mark of Tyranny
    }
    rotate(feral_defensive, 14)

    return false
end
