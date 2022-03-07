--Trigger Combination: Custom Function
function(triggers)
    return (triggers[1] or triggers[2]) and not triggers[3] and triggers[4]
end
