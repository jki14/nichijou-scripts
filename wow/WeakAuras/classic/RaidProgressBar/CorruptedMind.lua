function corruptedMindStart()
    local healerList = wa_global and wa_global.loatheb and wa_global.loatheb.healerList or { }

    local myname, _ = UnitName('player')

    if healerList[myname] then
        local idx = healerList[myname]
        local cur = tostring(idx) .. ' - ' .. myname
        local nxt = ''
        for name, offset in pairs(healerList) do
            if offset == 1 then
                nxt = tostring(offset) .. ' - ' .. name
            end
            if offset == idx + 1 then
                nxt = tostring(offset) .. ' - ' .. name
                break
            end
        end
        local msg = cur .. ' 已治疗; ' .. nxt .. ' 准备'
        SendChatMessage(msg, 'RAID')
        SendChatMessage(msg, 'RAID')
        SendChatMessage(msg, 'RAID')
    end
end

corruptedMindStart()
