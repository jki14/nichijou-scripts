function(progress, r1, g1, b1, a1, r2, g2, b2, a2)
    local charged = select(1, GetSpellCharges(202028)) or 0
    if charged == 3 then
        return r1, g1, b1, a1
    elseif charged == 2 then
        return r1, g2, b1, a1
    elseif charged == 1 then
        return r2, g2, b2, a1
    end
    return r1, g1, b1, 0
end