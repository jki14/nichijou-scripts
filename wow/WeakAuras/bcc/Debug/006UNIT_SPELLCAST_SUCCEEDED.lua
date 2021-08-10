--trigger custom event: UNIT_SPELLCAST_SUCCEEDED
function(e, unitTarget, castGUID, spellID)
    local function emit(key, value)
        print(key .. ': ' .. (value or 'nil'))
    end
    emit('unitTarget', unitTarget)
    emit('castGUID', castGUID)
    emit('spellID', spellID)
end
