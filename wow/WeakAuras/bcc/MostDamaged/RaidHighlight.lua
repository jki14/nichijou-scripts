-- actions oninit
function aura_env.show()
    local frame = wa_global and wa_global.mostDamaged and wa_global.mostDamaged.frames and wa_global.mostDamaged.frames[aura_env.state.unit] or nil
    if frame then
        local r, g, b, a = aura_env.region:GetColor()
        aura_env.region:Color(r, g, b, 0.1)
        aura_env.region:SetAnchor("CENTER", frame, "CENTER")
    end
end

-- actions onshow
aura_env.show()
