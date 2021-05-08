-- trigger-3 Every Frame
function()
    local ts = GetTime() * 1000
    if wa_global and wa_global.nourish and wa_global.nourish.window_start then
        if ts > wa_global.nourish.window_start then
            local foo = UnitHealthMax("target") - UnitHealth("target")
            local bar = GetSpellPowerCost(5188)[1].cost
            if foo < bar then
                return true
            end
        end
    end
    return false
end

-- trigger-4
-- UNIT_SPELLCAST_START,UNIT_SPELLCAST_DELAYED,UNIT_SPELLCAST_STOP,UNIT_SPELLCAST_FAILED,UNIT_SPELLCAST_INTERRUPTED
function(e, unit, castGUID, spellID)
    if unit ~= 'player' or spellID ~= 5188 then
        return false
    end
    wa_global = wa_global or { }
    wa_global.nourish = wa_global.nourish or { }
    if e == 'UNIT_SPELLCAST_START' or e == 'UNIT_SPELLCAST_DELAYED' then
        local endTime = select(5, CastingInfo())
        if endTime then
            wa_global.nourish.window_start = endTime - 500
            return false
        end
    end
    wa_global.nourish.window_start = nil
    return false
end
