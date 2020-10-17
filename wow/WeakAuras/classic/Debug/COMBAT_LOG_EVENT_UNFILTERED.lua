-- trigger
function(e, timestamp, event, hideCaster, sourceGUID, sourceName,
         sourceFlags, sourceRaidFlags, destGUID, destName, destFlags,
         destRaidFlags, spellId, spellName, ...)
    local function emit(key, value)
      print(key .. ': ' .. (value or 'nil'))
    end
    emit('timestamp', timestamp)
    emit('event', event)
    emit('hideCaster', hideCaster)
    emit('sourceGUID', sourceGUID)
    emit('sourceName', sourceName)
    emit('sourceFlags', sourceFlags)
    emit('sourceRaidFlags', sourceRaidFlags)
    emit('destGUID', destGUID)
    emit('destName', destName)
    emit('destFlags', destFlags)
    emit('destRaidFlags', destRaidFlags)
    emit('spellId', spellId)
    emit('spellName', spellName)
    return false
end
