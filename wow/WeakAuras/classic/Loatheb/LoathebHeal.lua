-- trigger: COMBAT_LOG_EVENT_UNFILTERED,PLAYER_REGEN_DISABLED
function(e, timestamp, event, hideCaster, sourceGUID, sourceName,
         sourceFlags, sourceRaidFlags, destGUID, destName, destFlags,
         destRaidFlags, spellId, spellName, ...)
    if e == 'PLAYER_REGEN_DISABLED' then
        wa_global = wa_global or { }
        wa_global.loatheb = wa_global.loatheb or { }
        wa_global.loatheb.start = GetTime()
        return false
    elseif wa_global and wa_global.loatheb and wa_global.loatheb.start then
        if GetTime() - wa_global.loatheb.start < 3 then
            return false
        end
    end

    if event ~= 'SPELL_AURA_APPLIED' or spellName ~= 'Corrupted Mind' then
    -- if event ~= 'SPELL_AURA_APPLIED' or spellName ~= 'Rejuvenation' then
        return false
    end

    local healerList = wa_global and
                       wa_global.loatheb and
                       wa_global.loatheb.healerList or { }

    local myname = destName
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
        if UnitIsGroupAssistant('player') or destGUID == UnitGUID('player') then
            SendChatMessage(msg, 'RAID')
            SendChatMessage(msg, 'RAID')
            SendChatMessage(msg, 'RAID')
        end
    end

    return false
end
