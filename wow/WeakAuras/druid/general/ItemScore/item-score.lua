-- Triger
function()
  local foo = '';
  local itemName, itemLink = GameTooltip:GetItem();
  if itemName and IsEquippableItem(itemLink) then
    return true;
  end
  return false;
end

-- Content
function()
  local foo = '';
  local scoreTable = {
    m1 = {
      I = 1.00,
      C = 1.51,
      H = 1.23,
      M = 1.51,
      V = 1.35,
      L = 3.12
    },
    m3 = {
      I = 1.00,
      C = 1.44,
      H = 1.30,
      M = 1.85,
      V = 1.29,
      L = 3.37
    },
    ba = {
      I = 1.00,
      C = 1.77,
      H = 1.72,
      M = 1.65,
      V = 1.60,
      L = 0.00
    }
  };
  local envs = {};
  for env, scores in pairs(scoreTable) do
    local peak = 0.0;
    for k, v in pairs(scores) do
      if k ~= 'L' and peak < v then
        peak = v;
      end
    end
    scoreTable[env]['S'] = peak * 50;
    table.insert(envs, env);
  end
  table.sort(envs)
  local itemName, itemLink = GameTooltip:GetItem();
  if itemName and IsEquippableItem(itemLink) then
    local itemStats = GetItemStats(itemLink);
    local statValue = {
      I = itemStats['ITEM_MOD_INTELLECT_SHORT'] or 0.0,
      C = itemStats['ITEM_MOD_CRIT_RATING_SHORT'] or 0.0,
      H = itemStats['ITEM_MOD_HASTE_RATING_SHORT'] or 0.0,
      M = itemStats['ITEM_MOD_MASTERY_RATING_SHORT'] or 0.0,
      V = itemStats['ITEM_MOD_VERSATILITY'] or 0.0,
      L = itemStats['ITEM_MOD_CR_LIFESTEAL_SHORT'] or 0.0,
      S = itemStats['EMPTY_SOCKET_PRISMATIC'] or 0.0
    };
    for k, v in pairs(statValue) do
      foo = foo .. k;
      foo = foo .. ' = ';
      foo = foo .. v;
      foo = foo .. '\n';
    end
    for i, env in pairs(envs) do
      local scores = scoreTable[env];
      foo = foo .. env .. ': ';
      local score = 0.0;
      for k, v in pairs(statValue) do
        score = score + scores[k] * v;
      end
      foo = foo .. score;
      foo = foo .. '\n';
    end
  end
  return foo;
end
