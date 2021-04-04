-- Trigger Custom Event: MAIL_SHOW
function(...)
    C_Timer.After(0.7, function()
        TakeInboxItem(1, 1)
        C_Timer.After(0.7, function()
            local cnt = select(4, GetInboxItem(1, 1)) or 0
            if cnt == 0 then
                DeleteInboxItem(1)
            end
        end)
    end)
    return false
end
