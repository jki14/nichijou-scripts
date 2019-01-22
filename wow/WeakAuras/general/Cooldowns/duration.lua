function ()
    local foo = WA_CD and WA_CD[1]
    if foo then
        return  foo.duration, foo.expiration
    else
        return 0.0, 0.0
    end
end