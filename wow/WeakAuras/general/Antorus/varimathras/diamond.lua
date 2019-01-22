function(progress, r1, g1, b1, a1, r2, g2, b2, a2)
    if GetRaidTargetIndex("player")==3 then
        return r2, g2, b2, a2
    else
        return r1, g1, b1, a1
    end
end
