--trigger: GOSSIP_SHOW
function()
    local npcId = select(6, strsplit('-', UnitGUID('target') or ''))
    if npcId ~= '35909' and npcId ~= '35642' then
        SelectGossipOption(1)
        SelectGossipOption(1)
        SelectGossipOption(1)
        SelectGossipOption(1)
    end
    return false
end
