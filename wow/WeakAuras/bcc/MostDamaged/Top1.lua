-- trigger-1 custom states every frame
function ()
    local index = 1
    if wa_global and wa_global.mostDamaged and wa_global.mostDamaged.top3 then
        if wa_global.mostDamaged.top3[index] then
            local frame = wa_global.mostDamaged.top3[index].frame
            aura_env.region:SetAnchor("CENTER", frame, "CENTER")
            return true
        end
    end
    return false
end
