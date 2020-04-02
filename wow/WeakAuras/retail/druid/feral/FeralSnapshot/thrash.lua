-- display
function()
    local score = WA_FDS and WA_FDS.record[106830] and WA_FDS.record[106830][UnitGUID("target")]
    if score then
        return string.format("%0.2fx", score)
    else
        return "error"
    end
end

-- animations
function(progress, r1, g1, b1, a1, r2, g2, b2, a2)
    local score = WA_FDS and WA_FDS.record[106830] and WA_FDS.record[106830][UnitGUID("target")]
    if score then
        local refresh = WA_FDS.enhance.melee
        if refresh > score + 1e-7 then
            return r2, g2, b2, a2
        end
        if refresh < score - 1e-7 then
            return g2, r2, b2, a2
        end
    end
    return r1, g1, b1, a1
end
