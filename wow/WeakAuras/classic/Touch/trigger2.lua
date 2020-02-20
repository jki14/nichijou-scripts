function()
  if wa_global and wa_global.touch and wa_global.touch.update then
    wa_global.touch.update()
  end
  return false
end
