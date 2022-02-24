--trigger custom event: UNIT_SPELLCAST_SUCCEEDED
function(e, unitTarget, powerType)
    local function emit(key, value)
        print(key .. ': ' .. (value or 'nil'))
    end
    emit('unitTarget', unitTarget)
    emit('powerType', powerType)
    local currEnergy = UnitPower('player', 3)
    print(currEnergy)
end

