-- on-init
local healerList = { }
healerList['游城哈子'] = 1
healerList['怀旧黑莲花'] = 2
healerList['犇犇萌牛丶'] = 3
healerList['假女乃亮'] = 4
healerList['霪雨滑人'] = 5
healerList['一株小盆栽'] = 6
healerList['颂神乐'] = 7
healerList['你的小野兽'] = 8
healerList['皮皮卡'] = 9
healerList['Llxx'] = 10
healerList['盼望'] = 11

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
