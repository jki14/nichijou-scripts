-- actions oninit
function aura_env.show()
    local mapping = WA_RFA_MAPPING or { }
    if mapping[aura_env.state.name] then
        local frame = mapping[aura_env.state.name]
        local r, g, b, a = aura_env.region:GetColor()
        aura_env.region:Color(r, g, b, 0.3)
        aura_env.region:SetAnchor("CENTER", frame, "CENTER")
    end
end

-- actions onshow
aura_env.show()

-- actions onhide