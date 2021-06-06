function()
    local level = UnitLevel('player') + 3
    local armor = select(2, UnitResistance('player', 0))
    local dr = level >= 60 and armor / (467.5 * level + armor - 22167.5) or
               armor / (85 * level + armor + 400)
    dr = min(dr * 100.0, 75.0)
    local foo = 'Armor: ' .. tostring(armor) .. ' (' .. string.format('%.2f', dr) .. '%)'
    -- foo = foo .. '\n' .. 'Fire Resistance: ' .. tostring(select(2, UnitResistance('player', 2)))
    -- foo = foo .. '\n' .. 'Frost Resistance: ' .. tostring(select(2, UnitResistance('player', 4)))
    foo = foo .. '\n' .. 'Speed: ' .. string.format('%.0f', select(1, GetUnitSpeed('player')) / 7.0 * 100.0)
    return foo
end
