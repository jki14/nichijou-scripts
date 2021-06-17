-- display custom-function
function()
  local foo = ''
  if wa_global and wa_global.touch and wa_global.touch.predicted then
    foo = 'T: ' .. tostring(wa_global.touch.predicted[1])
    for i = 2, #wa_global.touch.predicted do
      foo = foo .. ', ' .. tostring(wa_global.touch.predicted[i])
    end
  end
  if wa_global and wa_global.rejuv and wa_global.rejuv.predicted then
    if foo ~= '' then
      foo = foo .. '\n'
    end
    foo = foo .. 'R: ' .. tostring(wa_global.rejuv.predicted)
  end
  if wa_global and wa_global.regrowth and wa_global.regrowth.predicted then
    if foo ~= '' then
      foo = foo .. '\n'
    end
    foo = foo .. 'R: ' .. tostring(wa_global.regrowth.predicted[1])
    for i = 2, #wa_global.regrowth.predicted do
      foo = foo .. ', ' .. tostring(wa_global.regrowth.predicted[i])
    end
  end
  return foo
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
  local function getTalentSpent(spellId)
    local keyName = GetSpellInfo(spellId)
    for tabIndex = 1, GetNumTalentTabs() do
      for i = 1, GetNumTalents(tabIndex) do
        local name, _, _, _, spent = GetTalentInfo(tabIndex, i)
        if name == keyName then
          return spent
        end
      end
    end
    return 0
  end

  local function predictTouch(index, playerLevel, healingPower,
                              giftOfNatureCoefficient,
                              empoweredTouchCoefficient)
    local touches = {
      level = {1, 8, 14, 20, 26, 32, 38, 44, 50, 56, 60, 62, 69},
      ctime = {1.5, 2.0, 2.5, 3.0, 3.5, 3.5, 3.5, 3.5, 3.5, 3.5, 3.5, 3.5, 3.5},
      value = {{44, 44, 46, 46, 48},
               {100, 102, 102, 104, 106, 106},
               {219, 220, 222, 224, 226, 228},
               {404, 406, 410, 412, 414, 418},
               {633, 636, 640, 644, 647, 650},
               {818, 822, 826, 830, 834, 838},
               {1028, 1032, 1037, 1042, 1046, 1050},
               {1313, 1318, 1324, 1328, 1334, 1339},
               {1656, 1662, 1668, 1674, 1680, 1686},
               {2060, 2066, 2074, 2080, 2086, 2093},
               {2472, 2480, 2486, 2494, 2502, 2508},
               {2577, 2584, 2592, 2600, 2606, 2614},
               {2952, 2960}}
    }

    if not touches.level[index] or touches.level[index] > playerLevel then
        return nil
    end

    local requiresLevel = touches.level[index]

    local foo = touches.value[index]
    foo = foo[min(playerLevel - requiresLevel + 1, #foo)]

    local ext = healingPower * min(touches.ctime[index] / 3.5, 1.0)
    local bar = healingPower * (empoweredTouchCoefficient - 1.0)
    bar = bar * min(1.0, (requiresLevel + 11) / playerLevel)

    local penalty = (requiresLevel >= 20 and 1.0) or
                    (1.0 - ((20 - requiresLevel) * 0.0375))
    penalty = penalty * min(1.0, (requiresLevel + 11) / playerLevel)

    foo = foo + ext * penalty
    foo = foo * giftOfNatureCoefficient
    foo = foo + bar
    foo = math.floor(foo + 0.5)

    return foo
  end

  local function predictRejuv(playerLevel, healingPower,
                              improvedRejuvCoefficient,
                              giftOfNatureCoefficient,
                              empoweredRejuvCoefficient)
    local rejuvs = {
      level = {4, 10, 16, 22, 28, 34, 40, 46, 52, 58, 60, 63, 69},
      value = {32, 56, 116, 180, 244, 304, 388, 488, 608, 756, 888, 932, 1060}
    }

    local index = 1
    while rejuvs.level[index + 1] and rejuvs.level[index + 1] <= playerLevel do
        index = index + 1
    end
    if not rejuvs.level[index] or rejuvs.level[index] > playerLevel then
        return nil
    end

    local foo = rejuvs.value[index]

    local ext = healingPower * 0.8 * empoweredRejuvCoefficient

    foo = foo + ext
    foo = foo * (giftOfNatureCoefficient + improvedRejuvCoefficient - 1.0)
    foo = math.floor(foo + 0.5)

    return foo
  end

  local function predictRegrowth(index, playerLevel, healingPower,
                                 giftOfNatureCoefficient,
                                 improvedRegrowthCoefficient)
    local regrowthes = {
      level = {12, 18, 24, 30, 36, 42, 48, 54, 60, 65},
      value = {{91, 92, 94, 96, 98, 100},
               {176, 178, 181, 184, 186, 188},
               {257, 260, 264, 266, 270, 272},
               {339, 342, 346, 350, 354, 357},
               {431, 436, 440, 444, 448, 452},
               {543, 548, 552, 558, 562, 566},
               {685, 690, 696, 700, 706, 712},
               {857, 863, 869, 875, 881, 887},
               {1061, 1068, 1074, 1082, 1088, 1095},
               {1285, 1292, 1300, 1308, 1316, 1324}}
    }

    if not regrowthes.level[index] or regrowthes.level[index] > playerLevel then
        return nil
    end

    local requiresLevel = regrowthes.level[index]

    local foo = regrowthes.value[index]
    foo = foo[min(playerLevel - requiresLevel + 1, #foo)]

    local ext = healingPower * 0.5 * 2.0 / 3.5

    local penalty = (requiresLevel >= 20 and 1.0) or
                    (1.0 - ((20 - requiresLevel) * 0.0375))
    penalty = penalty * min(1.0, (requiresLevel + 11) / playerLevel)

    foo = (foo + ext * penalty) * giftOfNatureCoefficient
    foo = foo * improvedRegrowthCoefficient
    foo = math.floor(foo + 0.5)

    return foo
  end

  local playerLevel = UnitLevel('player')
  local healingPower = GetSpellBonusHealing()
  local improvedRejuvCoefficient = 1.0 + getTalentSpent(17111) * 0.05
  local giftOfNatureCoefficient = 1.0 + getTalentSpent(17104) * 0.02
  local improvedRegrowthCoefficient = 1.0 + getTalentSpent(17074) * 0.10
  local empoweredTouchCoefficient = 1.0 + getTalentSpent(33879) * 0.10
  local empoweredRejuvCoefficient = 1.0 + getTalentSpent(33886) * 0.04

  local touch = wa_global and wa_global.touch or { }
  touch.predicted = { }
  for i = 1, 13 do
    local foo = predictTouch(i, playerLevel, healingPower,
                             giftOfNatureCoefficient,
                             empoweredTouchCoefficient)
    if not foo then
        break
    end
    table.insert(touch.predicted, foo)
  end

  local rejuv = {predicted = predictRejuv(playerLevel, healingPower,
                                          improvedRejuvCoefficient,
                                          giftOfNatureCoefficient,
                                          empoweredRejuvCoefficient)}

  local regrowth = wa_global and wa_global.regrowth or { }
  regrowth.predicted = { }
  for i = 1, 10 do
    local foo = predictRegrowth(i, playerLevel, healingPower,
                                giftOfNatureCoefficient,
                                improvedRegrowthCoefficient)
    if not foo then
        break
    end
    table.insert(regrowth.predicted, foo)
  end

  wa_global = wa_global or { }
  wa_global.touch = touch
  wa_global.rejuv = rejuv
  wa_global.regrowth = regrowth
end

wa_global = wa_global or { }
wa_global.touch = wa_global.touch or { }
wa_global.regrowth = wa_global.regrowth or { }
wa_global.touch.update = fillTouches
wa_global.touch.update()
