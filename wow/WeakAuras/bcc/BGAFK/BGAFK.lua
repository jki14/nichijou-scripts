-- trigger CHAT_MSG_EMOTE
function(e, text, _, _, _, _, _, _, _, _, _, _, guid, ...)
    local player = UnitGUID('player')
    if guid == player and text == 'bgafk' then
        local bg = { }
        bg[30] = '奥特兰克山谷'
        bg[2107] = '阿拉希盆地'
        bg[529] = '阿拉希盆地'
        bg[1681] = '阿拉希盆地'
        bg[2177] = '阿拉希盆地'
        bg[566] = '风暴之眼'
        bg[968] = '风暴之眼'
        bg[489] = '战歌峡谷'
        bg = bg[select(8, GetInstanceInfo())] or 'unknown'
        local dt = C_DateAndTime.GetCurrentCalendarTime()
        dt = string.format('%04d-%02d-%02d %02d:%02d',
                           dt.year, dt.month, dt.monthDay,
                           dt.hour, dt.minute)
        local name, realm = UnitName('target')
        realm = realm and realm ~= '' and realm or GetRealmName()
        name = string.format('%s - %s', name, realm)
        local foo = '%s 于 %s 在 %s 中高度疑似利用第三方工具恶意战场挂机获利, 望严查.'
        foo = string.format(foo, name, dt, bg)
        print(foo)
    end
    return false
end
