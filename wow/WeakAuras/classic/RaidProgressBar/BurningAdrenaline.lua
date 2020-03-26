-- trigger
function(e, timestamp, event, hideCaster, sourceGUID, sourceName,
         sourceFlags, sourceRaidFlags, destGUID, destName, destFlags,
         destRaidFlags, spellId, spellName, ...)
    if e == 'PLAYER_REGEN_DISABLED' then
      wa_global = wa_global or { }
      wa_global.vaelastrasz = {start = GetTime()}
      return false
    end

    local npcId = select(6, strsplit("-", sourceGUID))
    if npcId == '13020' and wa_global and wa_global.vaelastrasz then
      if wa_global.vaelastrasz.start then
        wa_global.vaelastrasz.expiration = wa_global.vaelastrasz.start + 15.0
        wa_global.vaelastrasz.start = nil
        return true
      end
    end

    return false
end

-- duration info
function()
  if wa_global and wa_global.vaelastrasz then
    return 15.0, wa_global.vaelastrasz.expiration
  end
end
