function(progress, r1, g1, b1, a1, r2, g2, b2, a2)
    local charged = select(1, GetSpellCharges(22842)) or 0
    local fullcha = select(2, GetSpellCharges(22842)) or 0
    if charged < fullcha then
        if charged == 3 then
            return r1, g1, b1, a1
        elseif charged == 2 then
            return r1, g2, b1, a1
        elseif charged == 1 then
            return r2, g2, b2, a1
        elseif charged == 0 then
            return 0.3, 0.3, 0.3, 0.6
        end
    end
    return 0, 0, 0, 0
end
