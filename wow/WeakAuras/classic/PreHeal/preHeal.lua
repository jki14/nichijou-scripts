-- trigger2
function(_, timestamp, event, hideCaster, sourceGUID, sourceName,
         sourceFlags, sourceRaidFlags, destGUID, destName, destFlags,
         destRaidFlags, spellId, spellName, ...)
    if event ~= 'SPELL_CAST_START' then
      return false
    end

    local keySpell = { }
    keySpell['10184'] = {spellName = 'Flame Breath', castTime = 2.0}
    keySpell['13020'] = {spellName = 'Flame Breath', castTime = 2.0}
    keySpell['11983'] = {spellName = 'Shadow Flame', castTime = 2.0}
    keySpell['14601'] = {spellName = 'Shadow Flame', castTime = 2.0}
    keySpell['11981'] = {spellName = 'Shadow Flame', castTime = 2.0}
    keySpell['11583'] = {spellName = 'Shadow Flame', castTime = 2.0}
    keySpell['3131'] = {spellName = 'Lizard Bolt', castTime = 2.0}
    local npcId = select(6, strsplit("-", sourceGUID))
    if npcId and keySpell[npcId] and spellName == keySpell[npcId].spellName then
      local preheal = wa_global and wa_global.preheal or { }
      preheal.window_start = timestamp + keySpell[npcId].castTime
      preheal.window_end = timestamp + keySpell[npcId].castTime + 3.5
      wa_global = wa_global or { }
      wa_global.preheal = preheal
    end

    if sourceGUID == UnitGUID("player") and spellName == 'Healing Touch' then
      local preheal = wa_global and wa_global.preheal or { }
      preheal.castdone = timestamp + 3.0
      wa_global = wa_global or { }
      wa_global.preheal = preheal
    end

    return false
end

-- trigger3
function()
  if wa_global and wa_global.preheal then
    local preheal = wa_global.preheal
    if preheal.window_start and preheal.window_end and preheal.castdone then
      if preheal.castdone > preheal.window_start and
         preheal.castdone < preheal.window_end then
        return true
      end
    end
  end
  return false
end
