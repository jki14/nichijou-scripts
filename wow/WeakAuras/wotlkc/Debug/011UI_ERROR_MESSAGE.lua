--trigger custom event: UI_ERROR_MESSAGE
function(e, errorType, message)
    local function emit(key, value)
        print(key .. ': ' .. (value or 'nil'))
    end
    emit('errorType', errorType)
    emit('message', message)
end
