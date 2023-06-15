-- Trigger 1 / Custom / Event: ENCOUNTER_START, ENCOUNTER_END, PLAYER_REGEN_ENABLED, PLAYER_TARGET_CHANGED
function(event, ...)
    if IsEquippedItem(38365) then
        return false
    end

    local function rotate(relicId, retryNum)
        if not IsEquippedItem(relicId) then
            if (InCombatLockdown() or nil ~= EquipItemByName(relicId)) and retryNum > 0 then
                C_Timer.After(0.4, function()
                    rotate(relicId, retryNum - 1)
                end)
            else
                WeakAuras.ScanEvents('RELICROTATE_SWITCHED')
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
            [745] = 'Ignis the Furnace Master',
            [746] = 'Razorscale',
            [748] = 'The Iron Council',
            [753] = 'Freya',
            [755] = 'General Vezax',
            [756] = 'Yogg-Saron',
            [757] = 'Algalon the Observer',
            [629] = 'Northrend Beasts',
            [633] = 'Lord Jaraxxus',
            [637] = 'Faction Champions',
            [641] = 'Val\'kyr Twins',
            [645] = 'Anub\'arak',
        }
        DEFAULT_CHAT_FRAME:AddMessage('|cFFFFF468[RelicRotate] Encounter ' .. tostring(encounterId) .. ' end.')
        if not blocks[encounterId] or GetItemCount(45509) > 0 then
            local start_time = wa_global and wa_global.relicrotate and wa_global.relicrotate.encounter_start or 2147483647
            local duration = GetTime() - start_time
            DEFAULT_CHAT_FRAME:AddMessage('|cFFFFF468[RelicRotate] Encounter duration = ' .. tostring(duration) .. ' secs.')
            if duration >= 40 and duration <= 660 then
                if GetItemCount(45509) > 0 then
                    C_Timer.After(0.4, function()
                        rotate(45509, 4)
                    end) -- Idol of the Corruptor
                else
                    C_Timer.After(0.4, function()
                        rotate(38295, 4)
                    end) -- Idol of the Wastes
                end
            end
        end
    elseif 'ENCOUNTER_START' == event then
        local encounterId, encounterName, difficultyId, groupSize = ...
        wa_global = wa_global or { }
        wa_global.relicrotate = wa_global.relicrotate or { }
        wa_global.relicrotate.encounter_start = GetTime()
    elseif 'PLAYER_REGEN_ENABLED' == event then
        if not IsEquippedItem(45509) then
            C_Timer.After(0.4, function()
                rotate(45509, 4)
            end) -- Idol of the Corruptor
        end
    else
        -- PLAYER_TARGET_CHANGED
        if not IsEquippedItem(45509) then
            C_Timer.After(0.4, function()
                rotate(45509, 4)
            end) -- Idol of the Corruptor
        end
    end

    return false
end

-- Trigger 2 / Custom / Event: RELICROTATE_SWITCHED
function()
    -- setglobal('tg_wheel', IsEquippedItem(40713) and 1 or -1)
    -- WeakAuras.ScanEvents('TG_WHEEL')
    return false
end
