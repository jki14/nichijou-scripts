-- actions oninit
WA_RFA_MASKS = { }

function aura_env.execute()
    local specific_frame = "^ElvUF_Raid40Group"
    local mapping = { }
    local function recursive(frame)
        if type(frame) == 'table' and not frame:IsForbidden() then
            local objecttype = frame:GetObjectType()
            if objecttype == 'Button' then
                if frame:IsVisible() and frame:GetName() and (frame:GetName()):find(specific_frame) then
                    local objectunit = frame:GetAttribute('unit')
                    if objectunit then
                        local name, realm = UnitName(objectunit)
                        if name then
                            local unitname = name
                            if realm then
                                unitname = unitname..' - '..realm
                            end
                            mapping[unitname] = frame
                        end
                    end
                    return
                end
            end
            if objecttype == 'Frame' or objecttype == 'Button' then
                for _, child in pairs({frame:GetChildren()}) do
                    recursive(child)
                end
            end
        end
    end
    recursive(UIParent)
    WA_RFA_MAPPING = mapping
end

aura_env.execute()

-- trigger
-- GROUP_ROSTER_UPDATE,ROLE_CHANGED_INFORM
function()
    aura_env.execute()
    return false
end
