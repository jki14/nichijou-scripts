-- trigger-1
function()
    if wa_global and wa_global.sapphiron and wa_global.sapphiron.ts then
        if GetTime() - wa_global.sapphiron.ts < 8 then
            return true
        end
    end
    local targetGUID = UnitGUID('target')
    if targetGUID and '15989' == select(6, strsplit("-", targetGUID)) then
        local aimed = UnitGUID('targettarget')
        if aimed and UnitGUID('player') == aimed then
            wa_global = wa_global or { }
            wa_global.sapphiron = wa_global.sapphiron or { }
            wa_global.sapphiron.ts = GetTime()
            return true
        end
    end
    return false
end
