--trigger: GOSSIP_SHOW
function(e, ...)
    if not IsModifierKeyDown() then
        local subZoneText = GetSubZoneText()
        if subZoneText == 'Expedition Base Camp' then
            C_GossipInfo.SelectOption(94200)
        elseif subZoneText == 'Iron Concourse' then
            C_GossipInfo.SelectOption(94199)
        elseif subZoneText == 'The Scrapyard' then
            C_GossipInfo.SelectOption(94197)
        elseif subZoneText == 'The Observation Ring' then
            C_GossipInfo.SelectOption(94192)
        elseif subZoneText == 'The Spark of Imagination' then
            C_GossipInfo.SelectOption(94196)
        end
    end
    return false
end
