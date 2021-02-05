-- CHAT_MSG_EMOTE
function(e, text, _, _, _, _, _, _, _, _, _, _, guid, ...)
    local player = UnitGUID('player')
    if guid == player then
        local sets = { }

        sets['Player-4535-00679F69'] = { } -- 八六 - 比格沃斯
        sets['Player-4535-00679F69']['guard-raid'] = { }
        sets['Player-4535-00679F69']['feral-raid'] = { }
        sets['Player-4535-00679F69']['resto-raid'] = { }

        if sets[player] and sets[player][text] then
            sets['Player-4535-00679F69']['guard-raid'][1] = 21693
            sets['Player-4535-00679F69']['guard-raid'][2] = 22732
            sets['Player-4535-00679F69']['guard-raid'][3] = 19389
            sets['Player-4535-00679F69']['guard-raid'][5] = 19405
            sets['Player-4535-00679F69']['guard-raid'][6] = 21675
            sets['Player-4535-00679F69']['guard-raid'][7] = 23071
            sets['Player-4535-00679F69']['guard-raid'][8] = 19381
            sets['Player-4535-00679F69']['guard-raid'][9] = 21602
            sets['Player-4535-00679F69']['guard-raid'][10] = 21605
            sets['Player-4535-00679F69']['guard-raid'][11] = 17063
            sets['Player-4535-00679F69']['guard-raid'][12] = 23018
            sets['Player-4535-00679F69']['guard-raid'][13] = 11811
            sets['Player-4535-00679F69']['guard-raid'][14] = 13966
            sets['Player-4535-00679F69']['guard-raid'][15] = 19386
            sets['Player-4535-00679F69']['guard-raid'][16] = 21268
            sets['Player-4535-00679F69']['guard-raid'][17] = 17067
            sets['Player-4535-00679F69']['guard-raid'][18] = 23198
            sets['Player-4535-00679F69']['feral-raid'][1] = 8345
            sets['Player-4535-00679F69']['feral-raid'][2] = 18404
            sets['Player-4535-00679F69']['feral-raid'][3] = 21665
            sets['Player-4535-00679F69']['feral-raid'][5] = 21680
            sets['Player-4535-00679F69']['feral-raid'][6] = 20216
            sets['Player-4535-00679F69']['feral-raid'][7] = 23071
            sets['Player-4535-00679F69']['feral-raid'][8] = 19381
            sets['Player-4535-00679F69']['feral-raid'][9] = 21602
            sets['Player-4535-00679F69']['feral-raid'][10] = 21672
            sets['Player-4535-00679F69']['feral-raid'][11] = 17063
            sets['Player-4535-00679F69']['feral-raid'][12] = 21205
            sets['Player-4535-00679F69']['feral-raid'][13] = 13209 
            sets['Player-4535-00679F69']['feral-raid'][14] = 11815
            sets['Player-4535-00679F69']['feral-raid'][15] = 13340
            sets['Player-4535-00679F69']['feral-raid'][16] = 21268
            sets['Player-4535-00679F69']['feral-raid'][17] = 17067
            sets['Player-4535-00679F69']['feral-raid'][18] = 23197
            sets['Player-4535-00679F69']['resto-raid'][1] = 16900
            sets['Player-4535-00679F69']['resto-raid'][2] = 19885
            sets['Player-4535-00679F69']['resto-raid'][3] = 16902
            sets['Player-4535-00679F69']['resto-raid'][5] = 16897
            sets['Player-4535-00679F69']['resto-raid'][6] = 16903
            sets['Player-4535-00679F69']['resto-raid'][7] = 16901
            sets['Player-4535-00679F69']['resto-raid'][8] = 16898
            sets['Player-4535-00679F69']['resto-raid'][9] = 16904
            sets['Player-4535-00679F69']['resto-raid'][10] = 16899
            sets['Player-4535-00679F69']['resto-raid'][11] = 19920
            sets['Player-4535-00679F69']['resto-raid'][12] = 19863
            sets['Player-4535-00679F69']['resto-raid'][13] = 11819
            sets['Player-4535-00679F69']['resto-raid'][14] = 18470
            sets['Player-4535-00679F69']['resto-raid'][15] = 18208
            sets['Player-4535-00679F69']['resto-raid'][16] = 21275
            sets['Player-4535-00679F69']['resto-raid'][18] = 22399

            for slotId, itemId in pairs(sets[player][text]) do
                EquipItemByName(itemId, slotId)
            end
        end
    end
    return false
end
