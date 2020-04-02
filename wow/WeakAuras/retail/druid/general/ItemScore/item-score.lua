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
  local ms = 1.7;
  local theoretic = {
    I = 10.0 / UnitStat("player", 4),
    C = 10.0 / 50.0 / (GetCombatRating(11) / 50.0 + 100.0),
    H = 10.0 / 70.0 / (GetCombatRating(20) / 70.0 + 100.0),
    V = 10.0 / 85.0 / (GetCombatRating(29) / 85.0 + 100.0),
    M = 10.0 * ms / 120.0 / (GetCombatRating(26) * ms / 120.0 + 100.0),
    L = 10.0 / 40.0 / (GetLifesteal() + 100.0)
  };
  theoretic['C'] = theoretic['C'] / theoretic['I'];
  theoretic['H'] = theoretic['H'] / theoretic['I'];
  theoretic['M'] = theoretic['M'] / theoretic['I'];
  theoretic['V'] = theoretic['V'] / theoretic['I'];
  theoretic['L'] = theoretic['L'] / theoretic['I'];
  theoretic['I'] = 1.0;
  local scoreTable = {
    smart = theoretic,
    balan = { I = 1.00, C = 1.61, H = 1.74, V = 1.50, M = 1.48, L = 0.00 }
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
    foo = foo .. 'I = ' .. string.format('%.4f', theoretic['I']) .. ' : ' .. statValue['I'] .. '\n';
    foo = foo .. 'C = ' .. string.format('%.4f', theoretic['C']) .. ' : ' .. statValue['C'] .. '\n';
    foo = foo .. 'H = ' .. string.format('%.4f', theoretic['H']) .. ' : ' .. statValue['H'] .. '\n';
    foo = foo .. 'M = ' .. string.format('%.4f', theoretic['M']) .. ' : ' .. statValue['M'] .. '\n';
    foo = foo .. 'V = ' .. string.format('%.4f', theoretic['V']) .. ' : ' .. statValue['V'] .. '\n';
    foo = foo .. 'L = ' .. string.format('%.4f', theoretic['L']) .. ' : ' .. statValue['L'] .. '\n';
    foo = foo .. 'S = ' .. statValue['S'] .. '\n';
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
