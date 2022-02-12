--custom anchor
function()
    local unit = aura_env and aura_env.state and aura_env.state.unit or nil
    local mapping = { }
    mapping['player'] = 'ElvUF_PartyGroup1UnitButton1'
    mapping['party1'] = 'ElvUF_PartyGroup1UnitButton2'
    mapping['party2'] = 'ElvUF_PartyGroup1UnitButton3'
    mapping['party3'] = 'ElvUF_PartyGroup1UnitButton4'
    mapping['party4'] = 'ElvUF_PartyGroup1UnitButton5'
    for k, v in pairs(mapping) do
        if unit and UnitIsUnit(unit, k) then
            return v
        end
    end
    return nil
end
