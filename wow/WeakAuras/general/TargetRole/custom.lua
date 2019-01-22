function ()
    if UnitIsPlayer('target') then
        local spec = GetInspectSpecialization('target')
        if spec > 0 then
            spec = select(2, GetSpecializationInfoByID(spec)):sub(1, 5)
        else
            spec = nil
        end
        local role = UnitGroupRolesAssigned('target')
        if role ~= 'NONE' then
            role = role:sub(1, 1)
        else
            role = nil
        end
        local name, realm = UnitName('target')
        if not realm then
            realm = GetRealmName()
        end
        local foo = ''
        if spec then
            foo = spec
        end
        if role then
            if foo:len() > 0 then
                foo = foo .. ' - '
            end
            foo = foo .. role
        end
        if realm and string.len(realm) > 0 then
            if foo:len() > 0 then
                foo = foo .. ' - '
            end
            foo = foo .. realm
        end
        return foo
    else
        return ''
    end
end
