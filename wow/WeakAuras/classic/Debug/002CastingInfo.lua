-- trigger
function(e, timestamp, event, hideCaster, sourceGUID, sourceName,
         sourceFlags, sourceRaidFlags, destGUID, destName, destFlags,
         destRaidFlags, spellId, spellName, ...)
    local function emit(key, value)
        print(key .. ': ' .. (value or 'nil'))
    end
    if event == 'SPELL_CAST_START' and sourceGUID == UnitGUID('player') then
        name, text, texture, startTime, endTime,
        isTradeSkill, castID, notInterruptible, spellID = CastingInfo()
        emit('name', name)
        emit('text', text)
        emit('texture', texture)
        emit('startTime', startTime)
        emit('endTime', endTime)
        emit('isTradeSkill', isTradeSkill)
        emit('castID', castID)
        emit('notInterruptible', notInterruptible)
        emit('spellID', spellID)
        local ts = GetTime() * 1000
        emit('localTime', ts)
    end
    return false
end
