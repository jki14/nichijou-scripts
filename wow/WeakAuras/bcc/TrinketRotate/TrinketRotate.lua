-- action on-init
function checkTalent(spellId)
    local keyName = GetSpellInfo(spellId)
    for tabIndex = 1, GetNumTalentTabs() do
        for i = 1, GetNumTalents(tabIndex) do
            local name, _, _, _, spent = GetTalentInfo(tabIndex, i)
            if name == keyName then
                return spent > 0 and true or false
            end
        end
    end
    return false
end

wa_global = wa_global or { }
wa_global.spec5 = nil
if checkTalent(37116) then
    wa_global.spec5 = 'feral'
elseif checkTalent(17116) then
    wa_global.spec5 = 'resto'
end


-- Trigger: PLAYER_REGEN_ENABLED
function()
    local function rotate(trinkets, slotId)
        local effectiveWindow = { }
        -- Feral Trinkets
        effectiveWindow[34578] = 167 -- Battlemaster's Determination
        effectiveWindow[34428] = 287 -- Steely Naaru Sliver
        effectiveWindow[33831] = 102 -- Berserker's Call
        effectiveWindow[29383] = 102 -- Bloodlust Brooch
        effectiveWindow[23041] = 102 -- Slayer's Crest
        effectiveWindow[21180] = 102 -- Earthstrike
        effectiveWindow[21670] = 162 -- Badge of the Swarmguard
        effectiveWindow[19949] = 102 -- Zandalarian Hero Medallion
        effectiveWindow[23558] = 102 -- The Burrower's Shell
        -- Resto Trinkets
        effectiveWindow[38288] = 102 -- Direbrew Hops
        effectiveWindow[29376] = 102 -- Essence of the Martyr
        effectiveWindow[28370] = 102 -- Bangle of Endless Blessings
        effectiveWindow[23047] = 92  -- Eye of the Dead
        effectiveWindow[20636] = 77  -- Hibernation Crystal
        effectiveWindow[19955] = 167 -- Wushoolay's Charm of Nature
        -- General Trinkets
        effectiveWindow[4397] = 3590 -- Gnomish Cloaking Device

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
                    if cooldown < 40 or i == #trinkets then
                        EquipItemByName(itemId, slotId)
                        break
                    end
                end
            end
        end
    end

    local function rocketboots()
        if IsEquippedItem(23824) then
            local startTime, duration, _ = GetItemCooldown(23824)
            local cooldown = startTime + duration - GetTime()
            if cooldown > 40 then
                local foo = {34999, 35135, 31048, 0, 35002, 34556, 35000, 34573, 34444, 34998, 34887, 33496, 33831, 37865, 34241, 34198, 0, 29390}
                for i=1, 18 do
                    EquipItemByName(foo[i], i)
                end
            end
        end
    end

    if not wa_global or not wa_global.spec5 then
        return false
    end

    C_Timer.After(0.2, function()
        if InCombatLockdown() then
            return false
        end

        if wa_global.spec5 == 'feral' then
            local feral_offensive = {
                33831, -- Berserker's Call
                29383, -- Bloodlust Brooch
                34578, -- Battlemaster's Determination
                30627 -- Tsunami Talisman
            }
            rotate(feral_offensive, 13)

            local feral_defensive = {
                37865, -- Insignia of the Horde
                34428, -- Steely Naaru Sliver
                34473 -- Commendation of Kael'thas
            }
            rotate(feral_defensive, 14)

            rocketboots()
        elseif wa_global.spec5 == 'resto' then
            local resto_active = {
                29376, -- Essence of the Martyr
                23047  -- Eye of the Dead
            }
            rotate(resto_active, 13)

            local resto_passive = {
                38288, -- Direbrew Hops
                19394  -- Rejuvenating Gem
            }
            rotate(resto_passive, 14)
        end
    end)

    return false
end
