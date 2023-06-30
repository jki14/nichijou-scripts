-- Trigger / Custom / Event(s): UNIT_SPELLCAST_FAILED
function(_, unit, _, spellId)
    local flying = {
        [49193] = 'Vengeful Nether Drake',
        [58615] = 'Brutal Nether Drake',
        [59569] = 'Bronze Drake',
        [60021] = 'Plagued Proto-Drake',
        [63963] = 'Rusted Proto-Drake',
    }
    if 'player' == unit and spellId and flying[spellId] then
        wa_global = wa_global or { }
        local lastts = wa_global.delaran_mount or 0
        if lastts < GetTime() - 2.0 then
            local offset = wa_global and wa_global.ground_mount or nil
            if not offset then
                local num = GetNumCompanions('MOUNT')
                for i = 1, num + 1 do
                    if i == num + 1 or 'Crusader\'s Black Warhorse' == select(2, GetCompanionInfo('MOUNT', i)) or 'Great White Kodo' == select(2, GetCompanionInfo('MOUNT', i)) then
                        offset = i ~= num + 1 and i or 1
                        wa_global = wa_global or { }
                        wa_global.ground_mount = offset
                        break
                    end
                end
            end
            wa_global.delaran_mount = GetTime()
            CallCompanion('MOUNT', offset)
        end
    end
    return false
end
