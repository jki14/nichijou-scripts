-- actions oninit
function mapFrames()
  local frames = { }
  local raid40_frame = "^ElvUF_Raid40Group"
  local raidpet_frame= "^ElvUF_RaidpetGroup"
  local function recursive(frame)
    if type(frame) == 'table' and not frame:IsForbidden() then
      local objecttype = frame:GetObjectType()
      if objecttype == 'Button' then
        if frame:IsVisible() and frame:GetName() and
            ((frame:GetName()):find(raid40_frame) or
             (frame:GetName()):find(raidpet_frame)) then
          local objectunit = frame:GetAttribute('unit')
          if objectunit then
            frames[objectunit] = frame
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
  if wa_global and wa_global.mostDamaged then
    wa_global.mostDamaged.frames = frames
  end
end

wa_global = wa_global or { }
wa_global.mostDamaged = wa_global.mostDamaged or { }
wa_global.mostDamaged.map = mapFrames
wa_global.mostDamaged.map()

-- trigger1 custom-trigger
-- GROUP_ROSTER_UPDATE,ROLE_CHANGED_INFORM
function()
  if wa_global and wa_global.mostDamaged and wa_global.mostDamaged.map then
    wa_global.mostDamaged.map()
    C_Timer.After(0.2, function()
        wa_global.mostDamaged.map()
    end)
  end
  return false
end

-- trigger2 custom-trigger
function()
  if wa_global and wa_global.mostDamaged and wa_global.mostDamaged.frames then
    local frames = wa_global.mostDamaged.frames
    local top3 = { }
    for unit, frame in pairs(frames) do
      if UnitIsFriend("player", unit) then
        local foo = UnitHealth(unit)
        local bar = UnitHealthMax(unit)
        if foo and bar and UnitIsConnected(unit)
            and not UnitIsDeadOrGhost(unit) then
          foo = bar - foo
          if foo > 0 then
            if (not top3[1]) or (foo >= top3[1].value) then
              top3[3] = top3[2]
              top3[2] = top3[1]
              top3[1] = {
                frame = frame,
                value = foo
              }
            elseif (not top3[2]) or (foo >= top3[2].value) then
              top3[3] = top3[2]
              top3[2] = {
                frame = frame,
                value = foo
              }
            elseif (not top3[3]) or (foo >= top3[3].value) then
              top3[3] = {
                frame = frame,
                value = foo
              }
            end
          end
        end
      end
    end
    wa_global.mostDamaged.top3 = top3
  end
  return false
end
