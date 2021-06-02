-- on-init
local healerList = { }
healerList['档里有杀气'] = 1
healerList['无情的工具萨'] = 2
healerList['莫棄'] = 3
healerList['嫂子不如饺子'] = 4
healerList['酆都大帝'] = 5
healerList['依然活着'] = 6
healerList['圣光要厚道'] = 7
healerList['依然在一起丶'] = 8
healerList['小熊餠干'] = 9
healerList['筱狐狸'] = 10
healerList['马苏'] = 11
healerList['漩渦'] = 12

wa_global = wa_global or { }
wa_global.loatheb = wa_global.loatheb or { }
wa_global.loatheb.healerList = healerList


-- trigger-1 run custom code
function corruptedMindCheck()
    local healerList = wa_global and wa_global.loatheb and wa_global.loatheb.healerList or { }

    local healers = { }
    for name, offset in pairs(healerList) do
        healers[offset] = name
    end

    for offset, name in pairs(healers) do
        local msg = tostring(offset) .. ' - ' .. name
        SendChatMessage(msg, 'RAID')
    end
end

corruptedMindCheck()


-- trigger-2 run custom code
function corruptedMindCompile()
    local priestList = { }
    local shamanList = { }
    local druidList = { }

    for i = 1, 40 do
        local unit = 'raid' .. i
        if UnitExists(unit) then
            local _, _, classId = UnitClass(unit)
            local name, _ = UnitName(unit)
            if classId == 5 or classId == 7 or classId == 11 then
                if GetPartyAssignment('MAINTANK', unit) or
                        GetPartyAssignment('MAINASSIST', unit) then
                    print('[Warning] skip ' .. name)
                else
                    if classId == 5 then
                        table.insert(priestList, name)
                    elseif classId == 7 then
                        table.insert(shamanList, name)
                    elseif classId == 11 then
                        table.insert(druidList, name)
                    end
                end
            end
        end
    end

    local numPriest = #priestList
    local numShaman = #shamanList
    local numDruid = #druidList
    local numHealer = numPriest + numShaman + numDruid

    local majorGap= math.floor(numHealer / numPriest + 0.5)
    local minorGap = math.floor((numHealer - numPriest) / numDruid + 0.5)

    local healers = { }
    local j = 0
    for i = 1, numHealer do
        local major = i - 1
        major = major - math.floor(major / majorGap) * majorGap
        if major == 0 and next(priestList) then
            healers[i] = priestList[1]
            table.remove(priestList, 1)
        else
            j = j + 1
            local minor = j - 1
            local minor = minor - math.floor(minor / minorGap) * minorGap
            if minor == 0 and next(druidList) then
                healers[i] = druidList[1]
                table.remove(druidList, 1)
            elseif next(shamanList) then
                healers[i] = shamanList[1]
                table.remove(shamanList, 1)
            elseif next(druidList) then
                healers[i] = druidList[1]
                table.remove(druidList, 1)
            else
                healers[i] = priestList[1]
                table.remove(priestList, 1)
            end
        end
    end

    local res = '\n'
    res = res .. '-- on-init\n'
    res = res .. 'local healerList = { }\n'
    for offset, name in pairs(healers) do
        local msg = 'healerList[\'' .. name .. '\'] = ' .. offset
        res = res .. msg .. '\n'
    end
    res = res .. '\n'
    res = res .. 'wa_global = wa_global or { }\n'
    res = res .. 'wa_global.loatheb = wa_global.loatheb or { }\n'
    res = res .. 'wa_global.loatheb.healerList = healerList\n'
    print(res)
end

corruptedMindCompile()
