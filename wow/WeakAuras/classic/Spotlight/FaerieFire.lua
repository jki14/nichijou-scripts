-- trigger
function(_, timestamp, event, hideCaster, sourceGUID, sourceName,
         sourceFlags, sourceRaidFlags, destGUID, destName, destFlags,
         destRaidFlags, spellId, spellName, ...)
    if event ~= 'SPELL_AURA_APPLIED' and event ~= 'SPELL_AURA_REFRESH' then
      return false
    end

    if sourceGUID == UnitGUID("player") and spellName == 'Faerie Fire' then
      return true
    end

    return false
end
