-- actions oninit
function aura_env.show()
    local mapping = WA_RFA_MAPPING or { }
    if mapping[aura_env.state.unit] then
        local frame = mapping[aura_env.state.unit]
        local r, g, b, a = aura_env.region:GetColor()
        aura_env.region:Color(r, g, b, 0.3)
        aura_env.region:SetAnchor("CENTER", frame, "CENTER")
    end
end

-- actions onshow
aura_env.show()

-- actions onhide
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
