--trigger state updater: event(s): UNIT_SPELLCAST_SUCCEEDED
function(allstates, event, unitTarget, castGUID, spellID)
    local icons = {}
    icons[42292] = select(1, UnitFactionGroup('player')) ~= 'Horde' and
            133452 or 133453
    icons[27089] = 132805
    icons[44166] = 134062
    if icons[spellID] and string.sub(unitTarget, 1, 5) == 'arena' then
        local duration = 4
        allstates[castGUID] = {
            changed = true,
            show = true,
            name = unitTarget,
            progressType = "timed",
            duration = duration,
            expirationTime = GetTime() + duration,
            icon = icons[spellID],
            autoHide = true
        }
        return true
    end
    return false
end

--animation on show: custom
local function text1ColorOverride()
    for i, subregion in ipairs(aura_env.region.subRegions) do
        if subregion.type == "subtext" then
            local classColor = {
                [1] = {0.78,0.61,0.43,1.0},
                [2] = {0.96,0.55,0.73,1.0},
                [3] = {0.67,0.83,0.45,1.0},
                [4] = {1.00,0.96,0.41,1.0},
                [5] = {1.00,1.00,1.00,1.0},
                [6] = {0.77,0.12,0.23,1.0},
                [7] = {0.00,0.44,0.87,1.0},
                [8] = {0.25,0.78,0.92,1.0},
                [9] = {0.53,0.53,0.93,1.0},
                [10] = {0.00,1.00,0.60,1.0},
                [11] = {1.00,0.49,0.04,1.0},
                [12] = {0.64,0.19,0.79,1.0}
            }
            local classId = select(2, UnitClassBase(aura_env.state.name))
            subregion:Color(unpack(classColor[classId]))
        end
    end
end
text1ColorOverride()
