-- actions on-init
for i = 1, 10 do
  SetBindingSpell('CTRL-NUMPAD' .. tostring(i % 10), 'Regrowth(Rank ' .. tostring(i) .. ')')
end

-- animations main color
function()
  if wa_global and wa_global.regrowth and wa_global.regrowth.predicted then
    if UnitIsFriend("player", "target") then
      local foo = UnitHealthMax("target") - UnitHealth("target")
      if foo > 0 then
        local bar = 1
        while bar < 9 and wa_global.regrowth.predicted[bar + 1] < foo do
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
