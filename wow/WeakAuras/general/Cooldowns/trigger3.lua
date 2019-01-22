function ()
    local foo = WA_CD and WA_CD[1]
    if foo and foo.cooldown == 0 then
        return true
    else
        return false
    end
end
