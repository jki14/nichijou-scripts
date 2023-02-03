--trigger custom event: ARENA_OPPONENT_UPDATE
function(e, unitToken, updateReason)
    local function emit(key, value)
        print(key .. ': ' .. (value or 'nil'))
    end
    emit('unitToken', unitToken)
    emit('updateReason', updateReason)
end
