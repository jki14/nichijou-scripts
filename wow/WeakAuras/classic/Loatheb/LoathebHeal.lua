-- trigger: COMBAT_LOG_EVENT_UNFILTERED,PLAYER_REGEN_DISABLED
function(e, timestamp, event, hideCaster, sourceGUID, sourceName,
         sourceFlags, sourceRaidFlags, destGUID, destName, destFlags,
         destRaidFlags, spellId, spellName, ...)
    if e == 'PLAYER_REGEN_DISABLED' then
        wa_global = wa_global or { }
        wa_global.loatheb = {start = GetTime()}
        return false
    elseif wa_global and wa_global.loatheb and wa_global.loatheb.start then
        if GetTime() - wa_global.loatheb.start < 3 then
            return false
        end
    else
        return false
    end

    if event ~= 'SPELL_AURA_APPLIED' or spellName ~= 'Corrupted Mind' then
    -- if event ~= 'SPELL_AURA_APPLIED' or spellName ~= 'Rejuvenation' then
        return false
    end

    local healerList = { }
    healerList['霪雨滑人'] = 1
    healerList['丑尼娜萨德星'] = 2
    healerList['犇犇萌牛丶'] = 3
    healerList['小琪琪'] = 4
    healerList['假女乃亮'] = 5
    healerList['尐酒窝'] = 6
    healerList['依然活着'] = 7
    healerList['上古巨神'] = 8
    healerList['一株小盆栽'] = 9
    healerList['皮皮卡'] = 10
    healerList['Pioa'] = 11
    healerList['你的小野兽'] = 12

    local myname = destName
    if healerList[myname] then
        local idx = healerList[myname]
        local cur = tostring(idx) .. ' - ' .. myname
        local nxt = ''
        for name, offset in pairs(healerList) do
            if offset == 1 then
                nxt = tostring(offset) .. '-' .. name
            end
            if offset == idx + 1 then
                nxt = tostring(offset) .. '-' .. name
                break
            end
        end
        local msg = cur .. ' 已治疗; ' .. nxt .. ' 准备'
        SendChatMessage(msg, 'RAID')
        SendChatMessage(msg, 'RAID')
        SendChatMessage(msg, 'RAID')
    end

    return false
end