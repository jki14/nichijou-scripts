function()
  local foo = UnitHealthMax("target") - UnitHealth("target")
  if foo > 100 then
    return tostring(foo)
  end
  return ''
end
