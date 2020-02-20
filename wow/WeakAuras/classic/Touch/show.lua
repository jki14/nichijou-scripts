function()
  if wa_global and wa_global.touch and wa_global.touch.predicted then
    local foo = tostring(wa_global.touch.predicted[1])
    for i = 2, #wa_global.touch.predicted do
      foo = foo .. ' ,' .. tostring(wa_global.touch.predicted[i])
    end
    return foo
  end
  return ''
end
