-- trigger trigger
function()
  return UnitIsFriend("player", "target")
end

-- trigger duration
function()
  local index = 10
  local foo = wa_global and wa_global.touch and wa_global.touch.predicted and
              wa_global.touch.predicted[index] or 0
  local bar = UnitHealthMax("target")
  return foo, bar, true
end

-- display text-1
function()
  local foo = UnitHealthMax("target") - UnitHealth("target")
  if foo > 100 then
    return tostring(foo)
  end
  return ''
end
