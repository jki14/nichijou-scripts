-- WT_ENGAGE, CHAT_MSG_PARTY, CHAT_MSG_PARTY_LEADER
function(e, ...)
    if e == 'WT_ENGAGE' then
        local curr = GetTime()
        local prev = wa_global and wa_global.windfury or 0
        if prev < curr - 3.9 then
            return true
        end
    else
        local text = select(1, ...)
        if text == '[WT-MSG]Windfury Up' then
            local curr = GetTime()
            wa_global = wa_global or { }
            wa_global.windfury = curr
        elseif text == '[WT-MSG]Windfury Down' then
            C_Timer.After(3.0, function()
                WeakAuras.ScanEvents('WT_ENGAGE', true)
            end)
        end
    end
    return false
end
