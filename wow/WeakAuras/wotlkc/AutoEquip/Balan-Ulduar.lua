-- Trigger 1 / Custom / Event: ENCOUNTER_START, ENCOUNTER_END, PLAYER_REGEN_ENABLED
function(event, ...)
    local function switchSet(foo, retryNum)
        if InCombatLockdown() and retryNum > 0 then
            C_Timer.After(2.0, function()
                switchSet(foo, retryNum - 1)
            end)
        else
            for i = 1, 18 do
                EquipItemByName(foo[i], i)
            end
        end
    end

    if 'ENCOUNTER_END' == event then
        aura_env.encounter_end = GetTime()

        local plan = {
            ['依然活著-逐風者'] = {
                -- XT-002 Deconstructor
                [747] = {46184,45447,45136,0,45519,45616,46049,0,45446,45462,45495,46096,45466,45518,44005,46017,45314,40321},
                -- Mimiron
                [754] = {46184,45447,45136,0,45519,45616,46049,0,45446,45462,45495,46096,45466,45518,44005,46017,45314,40321},
                -- Hodir
                [751] = {46191,45133,46196,0,45519,45616,46192,0,45446,46189,45495,46096,45466,45518,44005,46017,45314,40321},
                -- General Vezax
                [755] = {46191,45133,46196,0,45519,45616,46192,0,45446,46189,45495,46096,45466,45518,44005,46017,45314,40321},
            },
        }

        local name, realm = UnitFullName('player')
        local token = name .. '-' .. realm
        if plan[token] then
            local encounterId, encounterName, difficultyId, groupSize, success = ...
            local foo = plan[token][encounterId]
            if foo and success then
                local start_time = aura_env.encounter_start or 2147483647
                local duration = GetTime() - start_time
                if duration >= 40 and duration <= 600 then
                    switchSet(foo, 8)
                end
            end
        end
    elseif 'ENCOUNTER_START' == event then
        aura_env.encounter_start = GetTime()
    elseif 'PLAYER_REGEN_ENABLED' == event then
        local last_encounter = aura_env.encounter_end or 0
        if GetTime() - last_encounter < 30 then
            return false
        end

        local plan = {
            ['依然活著-逐風者'] = {
                ['The Assembly of Iron'] = {46191,45133,46196,0,45519,45616,46192,0,45446,46189,45495,46096,45466,45518,44005,46017,45314,40321},
                ['The Halls of Winter'] = {46191,45133,46196,0,45519,45616,46192,0,45446,46189,45495,46096,45490,45518,44005,46017,45314,40321},
                ['The Descent into Madness'] = {46191,45133,46196,0,45519,45616,46192,0,45446,46189,45495,46096,45490,45518,44005,46017,45314,40321},
            },
        }

        local name, realm = UnitFullName('player')
        local token = name .. '-' .. realm
        if plan[token] then
            local subZoneText = GetSubZoneText()
            local foo = plan[token][subZoneText]
            if foo then
                switchSet(foo, 8)
            end
        end
    end

    return false
end
