-- Trigger Combination Custom Function
function(triggers)
    return triggers[1] and not triggers[2] and not triggers[3]
end
