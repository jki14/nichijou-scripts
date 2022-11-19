-- Trigger / Custom / Event(s): UNIT_SPELLCAST_FAILED
function(_, unit, _, spellId)
    local flying = {
        [49193] = 'Vengeful Nether Drake',
        [58615] = 'Brutal Nether Drake',
    }
    if 'player' == unit and spellId and flying[spellId] then
        wa_global = wa_global or { }
        local lastts = wa_global.delaran_mount or 0
        if lastts < GetTime() - 2.0 then
            wa_global.delaran_mount = GetTime()
            CallCompanion('MOUNT', 3)
        end
    end
    return false
end
