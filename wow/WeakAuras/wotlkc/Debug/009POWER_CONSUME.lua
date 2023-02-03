--trigger custom event: UNIT_SPELLCAST_SUCCEEDED:player
function(e, unitTarget, castGUID, spellID)
    local function emit(key, value)
        print(key .. ': ' .. (value or 'nil'))
    end
    emit('unitTarget', unitTarget)
    emit('castGUID', castGUID)
    emit('spellID', spellID)
    local currEnergy = UnitPower('player', 3)
    print(currEnergy)
end
