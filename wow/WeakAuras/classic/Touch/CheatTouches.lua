-- actions on-init
for i = 1, 11 do
  SetBindingSpell('CTRL-F' .. tostring(i), 'Healing Touch(Rank ' .. tostring(i) .. ')')
end

-- animations main color
function()
  if wa_global and wa_global.touch and wa_global.touch.predicted then
    if UnitIsFriend("player", "target") then
      local foo = UnitHealthMax("target") - UnitHealth("target")
      if foo > 0 then
        local bar = 1
        while bar < 11 and wa_global.touch.predicted[bar + 1] <= foo do
          bar = bar + 1
        end
        local r = (bar / 9) / 3.0
        local g = ((bar % 9) / 3) / 3.0
        local b = (bar % 3) / 3.0
        return r, g, b
      end
    end
  end
  return 0.0, 0.0, 0.0
end
