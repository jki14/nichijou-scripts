-- trigger combination: custom function
function(triggers)
    return not triggers[1] or (triggers[1] and triggers[2] and triggers[3])
end
