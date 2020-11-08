-- trigger-2
function()
    if wa_global and wa_global.touch and wa_global.touch.predicted then
        if UnitIsFriend("player", "target") then
            local foo = UnitHealthMax("target") - UnitHealth("target")
            local bar = wa_global.touch.predicted[4]
            if foo > bar then
                return true
            end
        end
    end
    return false
end
