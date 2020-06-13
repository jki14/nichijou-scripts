-- Trigger: UNIT_POWER_FREQUENT ENERGYTICK
function(a, event, unit, power)
  local flag = false
  local currMana = UnitPower('player', 0)
  local currEnergy = UnitPower('player', 3)
  if event == 'ENERGYTICK' then
    aura_env.inflight = aura_env.inflight - 1
    if currMana == UnitPowerMax('player', 0) then
      flag = true
    end
    if 3 == GetShapeshiftForm(true) and
        currEnergy == UnitPowerMax('player', 3) then
      flag = true
    end
  elseif unit == 'player' then
    if power == 'MANA' and currMana > (aura_env.lastMana or 0) then
      flag = true
    elseif power == 'ENERGY' and currEnergy > (aura_env.lastEnergy or 0) then
      flag = true
    end
  end
  if flag then
    local duration = 2
    if not a[""] then
      a[""] = {
        show = true,
        changed = true,
        duration = duration,
        expirationTime = GetTime() + duration,
        progressType = "timed"
      }
    else
      local s = a[""]
      s.changed = true
      s.duration = duration
      s.expirationTime = GetTime() + duration
      s.show = true
      aura_env.inflight = aura_env.inflight or 0
      if aura_env.inflight == 0 then
        C_Timer.After(duration, function()
          WeakAuras.ScanEvents("ENERGYTICK", true)
        end)
        aura_env.inflight = aura_env.inflight + 1
      end
    end
  end
  aura_env.lastMana = currMana
  aura_env.lastEnergy = currEnergy
  return true
end
