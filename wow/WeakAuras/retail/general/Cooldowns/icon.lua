function ()
    local foo = WA_CD and WA_CD[1]
    if foo then
        return foo.icon
    else
        return 0
    end
end