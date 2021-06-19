-- trigger trigger
function()
  return UnitIsFriend("player", "target")
end

-- trigger duration
function()
  local foo = wa_global and wa_global.rejuv and wa_global.rejuv.predicted or 0
  local bar = UnitHealthMax("target")
  return foo, bar, true
end
