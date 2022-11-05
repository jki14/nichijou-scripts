-- Trigger Combination Custom Function
function(triggers)
    return not triggers[1] and (triggers[2] or triggers[3])
end
