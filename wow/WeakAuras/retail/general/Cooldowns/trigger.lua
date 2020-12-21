function (e_event, e_timestamp, e_type, e_hideCaster, e_sourceGUID, e_sourceName, e_sourceFlags, e_sourceRaidFlags, e_destGUID, e_destName, e_destFlags, e_destRaidFlags, e_spellId, ...)
    -- others buffs
    local othersBuffs = WA_CD_OB or { }
    if e_sourceGUID == UnitGUID("player") and e_destGUID ~= UnitGUID("player") then
        if (e_type == "SPELL_AURA_APPLIED" or e_type == "SPELL_AURA_REFRESH") then
            for i = 1, 40 do
                local name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId = UnitBuff(e_destName, i)
                if spellId then
                    if spellId == e_spellId and source == "player" then
                        if not othersBuffs[spellId]  then
                            othersBuffs[spellId] = {
                                icon = icon,
                                duration = duration,
                                expiration = expirationTime,
                                dests = { }
                            }
                        end
                        othersBuffs[spellId].dests[e_destName] = expirationTime
                        if othersBuffs[spellId].expiration < expirationTime then
                            othersBuffs[spellId].expiration = expirationTime
                        end
                        break
                    end
                else
                    break
                end
            end
        end
    end
    for k_spellId in pairs(othersBuffs) do
        for k_destname in pairs(othersBuffs[k_spellId].dests) do
            for i = 1, 40 do
                local name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId = UnitBuff(k_destname, i)
                if spellId then
                    if spellId == k_spellId and source == "player" then
                        othersBuffs[k_spellId].dests[k_destname] = expirationTime
                        if othersBuffs[k_spellId].expiration < expirationTime then
                            othersBuffs[k_spellId].expiration = expirationTime
                        end
                        break
                    end
                else
                    othersBuffs[k_spellId].dests[k_destname] = nil
                    break
                end
            end
        end
        if othersBuffs[k_spellId].expiration < GetTime() then
            othersBuffs[k_spellId] = nil
        end
    end
    WA_CD_OB = othersBuffs
    -- sequence generator
    local keySpells = {
        -- general
        { spellId = 208683, buffId = { } }, --Gladiator's Medallion
        { spellId = 20549, buffId = { } }, --War Stomp
        { spellId = 26297, buffId = {26297} }, --Berserking
        { spellId = 255654, buffId = { } }, --Bull Rush
        { spellId = 58984, buffId = {58984} }, --Shadowmeld
        { spellId = 68992, buffId = {68992} }, --Darkflight
        -- restro-druid
        { spellId = 88423, buffId = { }, specialization = 4 }, --Nature's Cure
        { spellId = 2908, buffId = { } }, --Soothe
        { spellId = 48438, buffId = {48438} }, --WildGrowth
        { spellId = 18562, buffId = {114108} }, --Swiftmend
        { spellId = 102351, buffId = {102352}, specialization = 4 }, --Cenarion Ward
        { spellId = 197721, buffId = {197721}, specialization = 4 }, --Flourish
        { spellId = 22812, buffId = {22812} }, --Barkskin
        { spellId = 102342, buffId = {102342}, specialization = 4 }, --Ironbark
        { spellId = 236696, buffId = {236696} }, --Thorns
        { spellId = 22842, buffId = {22842} }, --Frenzied Regeneration
        { spellId = 102401, buffId = { } }, --Wild Charge
        { spellId = 1850, buffId = {1850, 252216} }, --Tiger Dash
        { spellId = 5211, buffId = { } }, --Mighty Bash
        { spellId = 102359, buffId = { } }, --Mass Entanglement
        { spellId = 132469, buffId = { } }, --Typhoon
        { spellId = 102793, buffId = { }, specialization = 4 }, --Ursol's Vortex
        { spellId = 29166, buffId = {29166} }, --Innervate
        { spellId = 740, buffId = {157982}, specialization = 4 }, --Tranquility
        { spellId = 33891, buffId = { }, specialization = 4 }, --Incarnation: Tree of Life
        -- feral-druid
        { spellId = 106839, buffId = { } }, --Skull Bash
        { spellId = 2782, buffId = { } }, --Remove Corruption
        { spellId = 202028, buffId = { } }, --Brutal Slash
        { spellId = 5217, buffId = {5217}, specialization = 2 }, --Tiger's Fury
        { spellId = 22570, buffId = { }, specialization = 2 }, --Maim
        { spellId = 61336, buffId = {61336} }, --Survival Instincts
        { spellId = 77764, buffId = {77764} }, --Stampeding Roar
        { spellId = 106951, buffId = {106951}, specialization = 2 }, --Berserk
        { spellId = 102543, buffId = {102543}, specialization = 2 }, --Incarnation:King of the Jungle
        { spellId = 203242, buffId = { }, specialization = 2 }, --Rip and Tear
        -- guard-druid
        { spellId = 99, buffId = { }, specialization = 3 }, --Incapacitating Roar
        { spellId = 201664, buffId = { }, specialization = 3 }, --Demoralizing Roar
        { spellId = 33917, buffId = { } }, --Mangle
        { spellId = 77758, buffId = { } }, --Thrash
        { spellId = 102558, buffId = {102558}, specialization = 3 }, --Incarnation: Guardian of Ursoc
        -- balan-druid
        { spellId = 78675, buffId = { }, specialization = 1 }, --Solar Beam
        { spellId = 205636, buffId = { }, specialization = 1 }, --Force of Nature
        { spellId = 194223, buffId = {194223}, specialization = 1 }, --Celestial Alignment
        { spellId = 102560, buffId = {102560}, specialization = 1 }, --Incarnation: Chosen of Elune
    }
    local specId = GetSpecialization()
    local playerBuffs = {}
    for i = 1, 40 do
        local name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId = UnitBuff("player", i, "HELPFUL")
        if spellId then
            if source == "player"  then
                playerBuffs[spellId] = {
                    icon = icon,
                    duration = duration,
                    expiration = expirationTime
                }
            end
        else
            break
        end
    end
    local foo = {}
    for i, spell in pairs(keySpells) do
        if spell.specialization == nil or spell.specialization == specId then
            local obj = {
                icon = nil,
                charged = 0,
                duration = nil,
                cooldown = 0,
                expiration = nil,
                glow = nil
            }
            local currentCharges, maxCharges, cooldownStart, cooldownDuration, chargeModRate = GetSpellCharges(spell.spellId)
            if currentCharges == nil then
                local start, duration, enabled, modRate = GetSpellCooldown(spell.spellId)
                if duration > 2.0 then
                    obj.icon = select(3,  GetSpellInfo(spell.spellId))
                    obj.charged = 0
                    obj.duration = duration
                    obj.cooldown = duration - (GetTime() - start)
                    obj.expiration = start + duration
                    obj.glow = false
                end
            else
                if currentCharges < maxCharges then
                    obj.icon = select(3,  GetSpellInfo(spell.spellId))
                    obj.charged = currentCharges
                    obj.duration = cooldownDuration
                    obj.cooldown = cooldownDuration - (GetTime() - cooldownStart)
                    obj.expiration = cooldownStart + cooldownDuration
                    obj.glow = false
                end
            end
            for j, buffId in pairs(spell.buffId) do
                if playerBuffs[buffId] then
                    obj.icon = playerBuffs[buffId].icon
                    obj.duration = playerBuffs[buffId].duration
                    obj.expiration = playerBuffs[buffId].expiration
                    obj.glow = true
                elseif othersBuffs[buffId] then
                    obj.icon = othersBuffs[buffId].icon
                    obj.duration = othersBuffs[buffId].duration
                    obj.expiration = othersBuffs[buffId].expiration
                    obj.glow = true
                end
            end
            if obj.icon then
                table.insert(foo, obj)
            end
        end
    end
    local trinketBuffs= {}
    trinketBuffs[158164] = 273942 --Plunderbeard's Flask
    trinketBuffs[158368] = 271054 --Fangs of Intertwined Essence
    trinketBuffs[161902] = 277185 --Dread Gladiator's Badge
    trinketBuffs[161674] = 277179 --Dread Gladiator's Medallion
    for i = 13, 14 do
        local start, duration, enable = GetInventoryItemCooldown("player", i)
        if enable == 1 and duration > 2.0 then
            local itemId = GetInventoryItemID("player", i)
            local obj = {
                icon = GetItemIcon(itemId),
                charged = 0,
                duration = duration,
                cooldown = duration - (GetTime() - start),
                expiration = start + duration,
                glow = false
            }
            if trinketBuffs[itemId] and playerBuffs[trinketBuffs[itemId]] then
                obj.icon = playerBuffs[trinketBuffs[itemId]].icon
                obj.duration = playerBuffs[trinketBuffs[itemId]].duration
                obj.expiration = playerBuffs[trinketBuffs[itemId]].expiration
                obj.glow = true
            end
            table.insert(foo, obj)
        end
    end
    table.sort(foo, function (lhs, rhs)
            if lhs.glow ~= rhs.glow then
                if lhs.glow then
                    return true
                else
                    return false
                end
            elseif math.abs(lhs.cooldown - rhs.cooldown) > 0.01 then
                return lhs.cooldown < rhs.cooldown
            else
                return lhs.duration < rhs.duration
            end
        end
    )
    WA_CD = foo
    -- common trigger
    local foo = WA_CD and WA_CD[1]
    if foo then
        return true
    else
        return false
    end
end
