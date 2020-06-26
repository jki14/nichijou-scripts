function()
    foo = 'Armor: ' .. tostring(select(2, UnitResistance('player', 0)))
    foo = foo .. '\n' .. 'Speed: ' .. string.format('%.0f', select(1, GetUnitSpeed('player')) / 7.0 * 100.0)
    return foo
end
