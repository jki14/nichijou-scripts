function()
  local index = 10
  local foo = wa_global and wa_global.touch and wa_global.touch.predicted and
              wa_global.touch.predicted[index] or 0
  local bar = UnitHealthMax("target")
  return foo, bar, true
end
