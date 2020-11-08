-- trigger-3 Every Frame
function()
    local foo = UnitPower('player', 0)
    local bar = GetSpellPowerCost(10181)[1].cost
    if foo < bar then
        return true
    end
    return false
end
