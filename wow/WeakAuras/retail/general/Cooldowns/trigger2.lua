function ()
    local foo = WA_CD and WA_CD[1]
    if foo then
        return foo.glow
    else
        return false
    end
end