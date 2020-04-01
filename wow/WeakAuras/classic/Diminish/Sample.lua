-- trigger
function()
  local category = 'root'
  local unitguid = UnitGUID('target')
  if wa_global and wa_global.diminish and wa_global.diminish.records then
    local records = wa_global.diminish.records
    if records[category] and records[category][unitguid] then
      if records[category][unitguid].expiration > GetTime() then
        return true
      end
    end
  end
  return false
end

-- duration
function()
  local category = 'root'
  local unitguid = UnitGUID('target')
  if wa_global and wa_global.diminish and wa_global.diminish.records then
    local records = wa_global.diminish.records
    if records[category] and records[category][unitguid] then
      return 18.0, records[category][unitguid].expiration
    end
  end
  return 0, 0
end

-- stack
function()
  local category = 'root'
  local unitguid = UnitGUID('target')
  if wa_global and wa_global.diminish and wa_global.diminish.records then
    local records = wa_global.diminish.records
    if records[category] and records[category][unitguid] then
      return records[category][unitguid].stack
    end
  end
  return 0
end
