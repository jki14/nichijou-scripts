-- on-init
local healerList = { }
healerList['霪雨滑人'] = 1
healerList['犇犇萌牛丶'] = 2
healerList['尐酒窝'] = 3
healerList['Pioa'] = 4
healerList['一株小盆栽'] = 5
healerList['依然活着'] = 6
healerList['上古巨神'] = 7
healerList['皮皮卡'] = 8
healerList['大源之爹'] = 9
healerList['游城哈子'] = 10
healerList['假女乃亮'] = 11

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
