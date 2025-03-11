-- CLEU:SPELL_DAMAGE:SPELL_MISSED:UNIT_DIED,NAME_PLATE_UNIT_REMOVED,PLAYER_TARGET_CHANGED

function(a, event, extra, subEvent, _, sourceGUID, _, _, _, destGUID, _, _, _, spellName)
  if event == "PLAYER_TARGET_CHANGED" then
    local flag = false
    local curr = UnitGUID("target")
    if aura_env.prev and aura_env.prev.guid and aura_env.prev.guid ~= curr then
      if aura_env.prev.exp > GetTime() and UnitGUID(aura_env.prev.unit) == aura_env.prev.guid then
        aura_env.timed(a, aura_env.prev.guid, 1, aura_env.prev.exp)
        a[aura_env.prev.guid].unit = aura_env.prev.unit
        flag = true
      end
    end
    if curr and a[curr] and a[curr].show then
      aura_env.prev = {
        guid = curr,
        exp = a[curr].expirationTime,
        unit = a[curr].unit,
      }
      aura_env.off(a, curr)
      flag = true
    else
      aura_env.prev = nil
    end
    return flag
  elseif subEvent == "SPELL_DAMAGE" and sourceGUID == UnitGUID("player")
  or subEvent == "SPELL_PERIODIC_DAMAGE" and sourceGUID == UnitGUID("player") then
    if WeakAuras.GetActiveTriggers(aura_env.id)[2] then
      local s2 = WeakAuras.GetTriggerStateForTrigger(aura_env.id, 2)
      local curr = UnitGUID("target")
      for _, state in pairs(s2) do
        if UnitGUID(state.unit) == destGUID then
          if destGUID and destGUID == curr then
            aura_env.prev = {
              guid = curr,
              unit = state.unit,
              exp = GetTime() + 1,
            }
          else
            aura_env.timed(a, destGUID, 1)
            a[destGUID].unit = state.unit
            return true
          end
        end
      end
    end
  elseif subEvent == "UNIT_DIED" then
    if WeakAuras.GetActiveTriggers(aura_env.id)[2] then
      if a[destGUID] then
        aura_env.off(a, destGUID)
        return true
      end
    end
  elseif event == "NAME_PLATE_UNIT_REMOVED" then
    if a[UnitGUID(extra)] then
      aura_env.off(a, UnitGUID(extra))
      return true
    end
  end
end
