-- actions oninit
function mapGUID()
  local guids = { }
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
            local unitguid = UnitGUID(objectunit)
            guids[unitguid] = objectunit
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
  if wa_global and wa_global.touch and wa_global.touch.halt then
    wa_global.touch.halt.guids = guids
  end
end

wa_global = wa_global or { }
wa_global.touch = wa_global.touch or { }
wa_global.touch.halt = wa_global.touch.halt or { }
wa_global.touch.halt.map = mapGUID
wa_global.touch.halt.map()


-- trigger-2 Every Frame
function()
    if wa_global and wa_global.touch and wa_global.touch.halt then
        local cast = wa_global.touch.halt.cast or nil
        if cast and cast.unit and cast.guid == UnitGUID(cast.unit) then
            local ts = GetTime() * 1000
            local foo = UnitHealthMax(cast.unit) - UnitHealth(cast.unit)
            if ts < cast.expire and foo < cast.bar then
                return true
            end
        end
    end
    return false
end


-- trigger-3
-- UNIT_SPELLCAST_START,UNIT_SPELLCAST_STOP,UNIT_SPELLCAST_FAILED,UNIT_SPELLCAST_INTERRUPTED
function(e, unit, castGUID, spellID)
    local touches = { }
    touches[5185] = 1
    touches[5186] = 2
    touches[5187] = 3
    touches[5188] = 4
    touches[5189] = 5
    touches[6778] = 6
    touches[8903] = 7
    touches[9758] = 8
    touches[9888] = 9
    touches[9889] = 10
    touches[25297] = 11
    if unit ~= 'player' or not touches[spellID] then
        return false
    end
    wa_global = wa_global or { }
    wa_global.touch = wa_global.touch or { }
    wa_global.touch.halt = wa_global.touch.halt or { }
    local cast = wa_global.touch.halt.cast or {
        unit = nil,
        guid = nil,
        bar = nil,
        expire = nil
    }
    if e == 'UNIT_SPELLCAST_START' then
        local guid = UnitGUID('target')
        if IsAltKeyDown() then
            guid = UnitGUID('player')
        end
        if wa_global.touch.halt.guids and wa_global.touch.halt.guids[guid] then
            local unit = wa_global.touch.halt.guids[guid]
            local endTime = select(5, CastingInfo())
            if guid == UnitGUID(unit) and endTime then
                cast.unit = unit
                cast.guid = guid
                cast.bar = GetSpellPowerCost(spellID)[1].cost
                cast.expire = endTime - 100
            end
        end
    elseif e == 'UNIT_SPELLCAST_DELAYED' then
        local endTime = select(5, CastingInfo())
        if endTime then
            cast.expire = endTime - 100
        end
    else
        cast.unit = nil
        cast.guid = nil
        cast.bar = nil
        cast.expire = nil
    end
    wa_global.touch.halt.cast = cast
    return false
end


-- trigger-4
-- GROUP_ROSTER_UPDATE,ROLE_CHANGED_INFORM
function()
  if wa_global and wa_global.touch and wa_global.touch.halt then
    if wa_global.touch.halt.map then
        wa_global.touch.halt.map()
        C_Timer.After(0.2, function()
            wa_global.touch.halt.map()
        end)
    end
  end
  return false
end
