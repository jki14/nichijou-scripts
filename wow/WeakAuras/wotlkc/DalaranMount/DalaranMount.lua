-- Trigger: UI_ERROR_MESSAGE
function (event, code, msg)
    wa_global = wa_global or { }
    local lastts = wa_global.delaran_mount or 0
    if code == 50 and lastts < GetTime() - 2.0 then
        wa_global.delaran_mount = GetTime()
        CallCompanion('MOUNT', 3)
    end
    return false
end
