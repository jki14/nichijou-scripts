-- Trigger 1 / Customer / Event(s): CLEU:SPELL_AURA_APPLIED, CLEU:SPELL_AURA_REFRESH
function(event, ...)
    local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME or DefaultChatFrame or { AddMessage = function(...) end }

    local _, subevent, _, _, _, _, _, destGUID, _, _, _, spellId = ...
    -- if spellId ~= 5401 and destGUID == UnitGUID('player') then
    if spellId == 71289 and destGUID == UnitGUID('player') then
        local _, _, classId = UnitClass('player')

        local disabled = {
            [5] = 'Priest',
            [8] = 'Mage',
            [9] = 'Warlock',
        }

        local talentGT = {
            [1] = {3, 20}, -- Warrior
        }

        local talentLT = {
            [2] = {3, 51}, -- Paladin
            [7] = {2, 51}, -- Shaman
            [11] = {2, 51}, -- Druid
        }

        if disabled[classId] or
           (talentGT[classId] and select(3, GetTalentTabInfo(talentGT[classId][1])) > talentGT[classId][2]) or
           (talentLT[classId] and select(3, GetTalentTabInfo(talentLT[classId][1])) < talentLT[classId][2]) then
            return false
        end

        PickupInventoryItem(16)
        PutItemInBackpack()
        PickupInventoryItem(17)
        PutItemInBackpack()

        if classId == 3 then -- Hunter
            PickupInventoryItem(18)
            PutItemInBackpack()
        end

        return false
    end
    return false
end
