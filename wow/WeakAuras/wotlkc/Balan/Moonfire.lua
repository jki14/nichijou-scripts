-- Trigger 2 / Custom / Event(s): BALAN_GSTARS_UPDATED
function()
    local stacks = wa_global and wa_global.balanRaid and wa_global.balanRaid.gstars or 0
    for i, subregion in ipairs(aura_env.region.subRegions) do
        if subregion.type == 'subborder' then
            if stacks == 3 then
                subregion:SetBorderColor(173 / 255, 127 / 255, 168 / 255, 1)
            elseif stacks == 2 then
                subregion:SetBorderColor(113 / 255, 159 / 255, 207 / 255, 1)
            elseif stacks == 1 then
                subregion:SetBorderColor(154 / 255, 226 / 255, 52 / 255, 1)
            else
                subregion:SetBorderColor(1, 1, 1, 1)
            end
        end
    end

    return false
end
