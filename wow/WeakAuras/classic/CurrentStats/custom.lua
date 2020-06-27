function()
    local armor = select(2, UnitResistance('player', 0))
    local foo = 'Armor: ' .. tostring(armor) .. ' (' .. string.format('%.2f', min(armor * 100.0 / (armor + 5755), 75.0)) .. '%)'
    foo = foo .. '\n' .. 'Fire Resistance: ' .. tostring(select(2, UnitResistance('player', 2)))
    foo = foo .. '\n' .. 'Nature Resistance: ' .. tostring(select(2, UnitResistance('player', 3)))
    foo = foo .. '\n' .. 'Speed: ' .. string.format('%.0f', select(1, GetUnitSpeed('player')) / 7.0 * 100.0)
    return foo
end
