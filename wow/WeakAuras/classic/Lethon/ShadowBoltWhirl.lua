-- trigger 1
function(e, timestamp, event, hideCaster, sourceGUID, sourceName,
         sourceFlags, sourceRaidFlags, destGUID, destName, destFlags,
         destRaidFlags, spellId, spellName, ...)
    if string.find(event, 'SPELL') then
      local registered = { }
      registered[24820] = -3
      registered[24821] = -2
      registered[24823] = -1
      registered[24822] = 4
      registered[24835] = 3
      registered[24836] = 2
      registered[24837] = 1
      registered[24838] = -4
      registered[5416] = 7
      local src = select(6, strsplit("-", sourceGUID))
      -- if src == '14888' and spellId and registered[spellId] then
      if src == '3127' and spellId and registered[spellId] then
        wa_global = wa_global or { }
        wa_global.lethon = registered[spellId]
      end
    end

    if wa_global and wa_global.lethon then
      return true
    end
    return false
end


-- trigger 2
function()
  if wa_global and wa_global.lethon and wa_global.lethon > 0 then
    return true
  end
  return false
end


-- text
function()
  if wa_global and wa_global.lethon then
    return math.abs(wa_global.lethon)
  end
  return ''
end
