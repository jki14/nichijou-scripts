-- on-init
local healerList = { }
healerList['尐酒窝'] = 1
healerList['霪雨滑人'] = 2
healerList['丑尼娜萨德星'] = 3
healerList['依然活着'] = 4
healerList['菅田将晖'] = 5
healerList['假女乃亮'] = 6
healerList['犇犇萌牛丶'] = 7
healerList['盼望'] = 8
healerList['一株小盆栽'] = 9
healerList['元气森林'] = 10
healerList['暮雪宸'] = 11
healerList['Pioa'] = 12

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
