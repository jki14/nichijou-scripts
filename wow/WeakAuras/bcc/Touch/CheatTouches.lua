-- actions on-init
for i = 1, 10 do
  SetBindingSpell('ALT-CTRL-NUMPAD' .. tostring(i % 10), 'Healing Touch(Rank ' .. tostring(i) .. ')')
end
for i = 11, 13 do
  SetBindingSpell('ALT-CTRL-F' .. tostring(i % 10), 'Healing Touch(Rank ' .. tostring(i) .. ')')
end

-- animations main color
function()
  if wa_global and wa_global.touch and wa_global.touch.predicted then
    if UnitIsFriend("player", "target") then
      local foo = UnitHealthMax("target") - UnitHealth("target")
      if foo > 0 then
        local bar = 1
        while wa_global.touch.predicted[bar + 1] and wa_global.touch.predicted[bar + 1] < foo do
          bar = bar + 1
        end
        local r = math.floor(bar / 9) / 3.0
        local g = math.floor((bar % 9) / 3) / 3.0
        local b = (bar % 3) / 3.0
        return r, g, b
      end
    end
  end
  return 0.0, 0.0, 0.0
end
