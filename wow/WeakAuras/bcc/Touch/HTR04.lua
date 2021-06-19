-- trigger trigger
function()
  return UnitIsFriend("player", "target")
end

-- trigger duration
function()
  local foo = wa_global and wa_global.regrowth and
              wa_global.regrowth.predicted and
              wa_global.regrowth.predicted[#wa_global.regrowth.predicted] or 0
  local bar = UnitHealthMax("target")
  return foo, bar, true
end
