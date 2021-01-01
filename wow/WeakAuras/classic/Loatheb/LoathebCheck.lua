-- on-init
local healerList = { }
healerList['碧萝守护神'] = 1
healerList['插完就走丶'] = 2
healerList['灬暗影萨满灬'] = 3
healerList['寇斯'] = 4
healerList['枫叶飞舞'] = 5
healerList['皮皮卡'] = 6
healerList['秋林'] = 7
healerList['满大街哪都是'] = 8
healerList['你是真的狗'] = 9
healerList['凯瑞甘女王'] = 10
healerList['尐尾巴'] = 11
healerList['小手好红'] = 12
healerList['大灬雪'] = 13

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
