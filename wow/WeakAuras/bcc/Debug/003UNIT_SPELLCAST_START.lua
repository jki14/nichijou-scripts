--trigger custom event: UNIT_SPELLCAST_START
function(e, unit, castGUID, spellID)
    local function emit(key, value)
            print(key .. ': ' .. (value or 'nil'))
    end
    emit('unit', unit)
    emit('castGUID', castGUID)
    emit('spellID', spellID)
    return false
end

