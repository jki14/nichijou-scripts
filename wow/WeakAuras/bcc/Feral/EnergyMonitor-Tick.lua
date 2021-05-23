-- Trigger: UNIT_POWER_FREQUENT:player,ENERGYTICK
function(event, unit, power)
  local flag = false
  local currMana = UnitPower('player', 0)
  local currEnergy = UnitPower('player', 3)
  if event == 'ENERGYTICK' then
    flag = true
  elseif unit == 'player' then
    if power == 'MANA' and
        11 == select(2, UnitClassBase('player')) and
        currMana > (aura_env.lastMana or 0) + 36 then
      flag = true
    elseif power == 'ENERGY' and currEnergy > (aura_env.lastEnergy or 0) then
      flag = true
    end
  end
  aura_env.lastMana = currMana
  aura_env.lastEnergy = currEnergy
  return flag
end
