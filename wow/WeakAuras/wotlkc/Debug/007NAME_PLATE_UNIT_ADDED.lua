--trigger custom event: NAME_PLATE_UNIT_ADDED
function(e, unitToken)
    local function emit(key, value)
        print(key .. ': ' .. (value or 'nil'))
    end
    emit('unitToken', unitToken)
end
