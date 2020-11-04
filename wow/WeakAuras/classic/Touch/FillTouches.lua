-- display custom-function
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

-- trigger-2
-- PLAYER_LEVEL_UP,PLAYER_TALENT_UPDATE,PLAYER_EQUIPMENT_CHANGED,PLAYER_TARGET_CHANGED
function()
  if wa_global and wa_global.touch and wa_global.touch.update then
    wa_global.touch.update()
    C_Timer.After(0.1, function()
        wa_global.touch.update()
    end)
  end
  return false
end

-- action on-init
function fillTouches()
  local function predictTouch(index)

    local function avg(lhs, rhs)
      return (lhs + rhs) / 2
    end

    local function GiftofNature()
      local keyName = GetSpellInfo(17104)
      for tabIndex = 1, GetNumTalentTabs() do
        for i = 1, GetNumTalents(tabIndex) do
          local name, _, _, _, spent = GetTalentInfo(tabIndex, i)
          if name == keyName then
            return 1.0 + spent * 0.02
          end
        end
      end
      return 1.0
    end

    local touches = {
      level = {
                      1,               8,              14,              20,
                     26,              32,              38,              44,
                     50,              56,              60
      },
      ctime = {
                    1.5,             2.0,             2.5,             3.0,
                    3.5,             3.5,             3.5,             3.5,
                    3.5,             3.5,             3.5
      },
      value = {
            avg(37, 51),    avg(88, 112),   avg(195, 243),   avg(363, 445),
          avg(572, 694),   avg(742, 894),  avg(936, 1120), avg(1199, 1427),
        avg(1516, 1796), avg(1890, 2230), avg(2267, 2677)
      }
    }

    local foo = touches.value[index] * GiftofNature()
    local ext = GetSpellBonusHealing() * min(touches.ctime[index] / 3.5, 1.0)
    local u20 = (touches.level[index] >= 20 and 1.0) or
                (1.0 - ((20 - touches.level[index]) * 0.0375))
    foo = foo + ext * u20

    return foo
  end

  local touch = wa_global and wa_global.touch or { }
  touch.predicted = { }
  for i = 1, 11 do
    table.insert(touch.predicted, math.floor(predictTouch(i)))
  end
  wa_global = wa_global or { }
  wa_global.touch = touch
end

wa_global = wa_global or { }
wa_global.touch = wa_global.touch or { }
wa_global.touch.update = fillTouches
wa_global.touch.update()
