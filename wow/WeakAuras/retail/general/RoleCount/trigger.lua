function()
    local nt, nh, nd = 0, 0, 0
    if UnitInRaid('player') then
        for i = 1, 40 do
            local role = UnitGroupRolesAssigned(string.format('raid%d', i))
            if role ~= 'NONE' then
                role = role:sub(1, 1)
                if role == 'T' then
                    nt = nt + 1
                elseif role == 'H' then
                    nh = nh + 1
                elseif role == 'D' then
                    nd = nd + 1
                end
            end
        end
    elseif UnitInParty('player') then
        for i = 0, 4 do
            local role = 'NONE'
            if i > 0 then
                role = UnitGroupRolesAssigned(string.format('party%d', i))
            else
                role = UnitGroupRolesAssigned('player')
            end
            if role ~= 'NONE' then
                role = role:sub(1, 1)
                if role == 'T' then
                    nt = nt + 1
                elseif role == 'H' then
                    nh = nh + 1
                elseif role == 'D' then
                    nd = nd + 1
                end
            end
        end
    else
        WA_RC_FOO = ''
        return false
    end
    WA_RC_FOO = string.format('%d/%d/%d', nt, nh, nd)
    return true
end
