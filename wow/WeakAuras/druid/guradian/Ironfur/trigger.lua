function(event, timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, ...)
    local queue = WA_IRONFUR
    if queue == nil then
        queue = {
            truck = {},
            head = 0,
            tail = -1
        }
    end
    while queue.head <= queue.tail and queue.truck[queue.head].expiration < GetTime() do
        queue.truck[queue.head] = nil
        queue.head = queue.head + 1
    end
    if sourceGUID == UnitGUID("player") and spellId == 192081 and type == "SPELL_CAST_SUCCESS" then
        for i = 1, 40 do
            local name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId = UnitBuff("player", i, "HELPFUL")
            if spellId then
                if spellId == 192081 then
                    if queue.tail < queue.head or expirationTime > queue.truck[queue.tail].expiration + 0.2 then
                        queue.tail = queue.tail + 1
                        queue.truck[queue.tail] = {
                            expiration = expirationTime,
                            duration = duration
                        }
                    else
                        queue.tail = queue.tail + 1
                        local expect = expirationTime - duration + 7.0
                        local j = queue.tail
                        while queue.head <= j - 1 and queue.truck[j - 1].expiration > expect do
                            queue.truck[j] = queue.truck[j - 1]
                            j = j - 1
                        end
                        queue.truck[j] = {
                            expiration = expect,
                            duration = 7.0
                        }
                    end
                end
            else
                break
            end
        end
    end
    WA_IRONFUR = queue
    --
    local queue = WA_IRONFUR
    if queue and queue.head + 0 <= queue.tail then
        return true
    else
        return false
    end
end