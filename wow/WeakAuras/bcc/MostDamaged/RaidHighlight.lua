-- Custom Anchor
function()
    local unit = aura_env and aura_env.state and aura_env.state.unit or nil
    local frame = unit and wa_global and wa_global.mostDamaged and wa_global.mostDamaged.raidframes and wa_global.mostDamaged.raidframes[unit] or nil
    return frame
end
