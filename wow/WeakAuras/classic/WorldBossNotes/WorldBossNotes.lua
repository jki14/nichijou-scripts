function(e, text, _, _, _, _, _, _, _, _, _, _, guid, ...)
  if guid == UnitGUID('player') then
    argv = { }
    for word in text:gmatch("%S+") do
      table.insert(argv, word)
    end

    if string.upper(argv[1]) ~= 'WBNOTE' then
      return false
    end

    boss = argv[2] or ''
    area = argv[3] or ''
    boss = string.upper(boss)
    area = string.upper(area)

    local guide = { }

    guide['A'] = {
      '艾索雷葛斯 (蓝龙) 注意事项:',
      '1. 提前对话开Boss, 单体或AOE技能激活Boss直接移除',
      '2. 蓝龙会不定期将周围30码目标传送至自己位置并清楚仇恨：',
      '   a. 所有成员必须时刻保持在Boss周围20码内;',
      '   b. 需要喝水回蓝必须等下一次传送后第一时间远离Boss脱离战斗;',
      '   c. 传送后所有DPS严格停止动作等待坦克重新建立仇恨, 建议避免使用HOT/DOT',
      '   d. 传送后坦克后退避免挤压模型但避免调整龙头, 其他成员自行让开龙头',
      '   e. 一次未吃到传送无拾取不分金;',
      '   f. 两次或两次以上未吃到传送移除+拉黑;',
      '3. 牧师以驱散坦克和近战魔法优先, 德萨缓慢维持坦克血线, DPS自保为主',
      '4. 坦克魔法超过5秒未被驱散情况下, 全程驱散总数排名后半牧师扣除半份工资',
      '5. 蓝龙冰奥抗性极高定期开启法术反射, 法系注意使用非冰奥技能输出并反射停手',
      '6. 蓝龙无扫尾, 龙尾是安全位置注意利用',
      '7. 物理DPS低于主坦伤害不分金',
      '8. 法系DPS低于主坦60%伤害不分金',
      '9. OT三次或以上不分金'
    }

    local nightmare_dragons = {
      '',
      '1. 绿龙前爪前端180度扇形半径30码以上范围吐息:',
      '   a. 每层可叠加高额自然伤害Dot',
      '   b. 每层可叠加使所有主动技能CD延长10秒',
      '   c. 由于坦克全身自然抗装备急吐息导致所有主动技能CD, 仇恨极为有限',
      '   d. OT一次不分金, 两次及以上移除+拉黑',
      '   e. 根据当前仇恨DPS可以选择远离Boss脱离战斗清零仇恨',
      '   f. 除当前坦克外叠加吐息导致死亡不分金',
      '   g. 吐息技能CD不会作用于同技能不动等级法术, 法系请合理使用技能书施法',
      '2. 绿龙有扫尾技能, 切勿站龙尾',
      '3. 不定期召唤绿雾缓慢向随机目标移动:',
      '   a. 接触后会被沉睡, 尽量规避, 远程治疗适当分散',
      '   b. 亡灵意志可以解除沉睡',
      '4. 全程主坦克会受到巨额伤害, 处于高压状态',
      '   a. 拥有恢复权/回春权德牧师奶德需保持主坦身上恢复/回春/愈合不断',
      '   b. 所有治疗保证坦克生存为最高优先',
      '5. 绿龙在自身血量75%,50%,25%左右会释放三次大招：'
    }

    guide['L'] = { }
    for i, v in ipairs(nightmare_dragons) do table.insert(guide['L'], v) end
    guide['L'][1] = '莱索恩 (绿龙: 暗影) 注意事项:'
    table.insert(guide['L'], '   莱索恩会昏迷所有人5秒并召唤影子向绿龙移动')
    table.insert(guide['L'], '   每个影子接触到Boss回为Boss恢复8k+血量')
    table.insert(guide['L'], '   a. 昏迷期间坦克持续受到伤害治疗无法抬血')
    table.insert(guide['L'], '      **大招前保证坦克血量健康并保持所有HOT**')
    table.insert(guide['L'], '   b. 每个影子拥有500血量, 不吃控制, 不吃AOE')
    table.insert(guide['L'], '      **近战提前离开Boss在远程治疗位置就位**')
    table.insert(guide['L'], '      **昏迷结束所有输出职业全力点杀影子**')
    table.insert(guide['L'], '6. 暗影龙周期对身体一侧释放高额伤害群体暗影箭')
    table.insert(guide['L'], '   a. 当前坦外所有人在Boss一侧垂直分布')
    table.insert(guide['L'], '   b. 坦克不断使Boss转向避免团队连续吃到伤害')
    table.insert(guide['L'], '   c. 由于Boss龙头位置持续调整, 时刻留意吐息扫尾')
    table.insert(guide['L'], '   d. 治疗切记以维持坦克血线为主, 空隙缓慢补团')

    guide['E'] = { }
    for i, v in ipairs(nightmare_dragons) do table.insert(guide['E'], v) end
    guide['E'][1] = '艾莫莉丝 (绿龙: 蘑菇) 注意事项:'
    table.insert(guide['E'], '   艾茉莉丝会释放一个在10秒内扣除100%血量的Dot')
    table.insert(guide['E'], '   a. 牧师需要在大招期间连续使用治疗祷言保全小队')
    table.insert(guide['E'], '      **非大招阶段牧师需保持蓝量健康**')
    table.insert(guide['E'], '   b. 坦克也会受到该技能影响, 德萨需要过量刷坦')
    table.insert(guide['E'], '      **非!常!重!要!**')
    table.insert(guide['E'], '   c. 奇数小队面向Boss左侧, 偶数右侧严格站边')
    table.insert(guide['E'], '      **错误站边导致减员无拾取不分金**')
    table.insert(guide['E'], '   d. 未正常接受治疗的团员需要使用大红/萝卜/糖自保')
    table.insert(guide['E'], '   e. 未分配牧师治疗的小队成员需要提前离场躲避大招')
    table.insert(guide['E'], '      **85%,60%,35%血量离场, 远离Boss 80码以上**')
    table.insert(guide['E'], '6. 蘑菇龙会随机目标释放疾病, 造成高额范围周期伤害')
    table.insert(guide['E'], '   a. 牧萨驱散疾病为最高优先级')
    table.insert(guide['E'], '   b. 疾病减员, 减员侧全程驱散总数排名后半牧萨不分')
    table.insert(guide['E'], '7. 蘑菇龙仇恨列表中目标死亡会变成一朵蘑菇')
    table.insert(guide['E'], '   a. 持续给10码内目标释放高额持续伤害')
    table.insert(guide['E'], '   b. 大范围！！远离！！！')
    table.insert(guide['E'], '   c. 很危险！！活下来！！！')

    guide['T'] = { }
    for i, v in ipairs(nightmare_dragons) do table.insert(guide['T'], v) end
    guide['T'][1] = '泰拉尔 (绿龙: 分身) 注意事项:'
    table.insert(guide['T'], '   泰拉尔会放逐本体并召唤三只中龙')
    table.insert(guide['T'], '   a. 三只中龙不继承Boss任何仇恨')
    table.insert(guide['T'], '      **所有坦克需要抢中龙, 建议起手尝试群拉**')
    table.insert(guide['T'], '      **所有DPS停手等待坦克接手**')
    table.insert(guide['T'], '      **大招期间注意控制仇恨, 切换目标输出**')
    table.insert(guide['T'], '      **主坦克身上仍然有Boss吐息, 仇恨有限**')
    table.insert(guide['T'], '   b. 中龙会对正前方喷吐, 造成可叠加中等伤害')
    table.insert(guide['T'], '      **非当前中龙坦克让开龙头**')
    table.insert(guide['T'], '   c. 中龙会不定期在地面留下毒圈, 造成高额伤害')
    table.insert(guide['T'], '      **与ZUG二号毒蛇Boss类似**')
    table.insert(guide['T'], '      **坦克和近战留意自己Debuff栏**')
    table.insert(guide['T'], '      **图标同RAQ瘙痒, 远离直至Debuff消失**')
    table.insert(guide['T'], '8. 分身龙会不定期的群体恐惧, 恐惧效果持续4秒')
    table.insert(guide['T'], '      **萨满有条件注意保持战栗图腾**')
    table.insert(guide['T'], '      **坦克有条件注意切姿态反恐**')
    table.insert(guide['T'], '      **恐惧结束后注意调整自己位置**')
    table.insert(guide['T'], '      **恐惧结束后注意坦克血量**')

    guide['Y'] = { }
    for i, v in ipairs(nightmare_dragons) do table.insert(guide['Y'], v) end
    guide['Y'][1] = '伊森德雷 (绿龙: 德鲁伊) 注意事项:'
    table.insert(guide['Y'], '   伊森德雷会召唤等同参战人数的德鲁伊之魂')
    table.insert(guide['Y'], '   a. 魂2500血量, 会沉默/月火/攻击目标')
    table.insert(guide['Y'], '   　 **所有输出飞当前主坦克最快速度清理魂**')
    table.insert(guide['Y'], '   　 **保持主坦健康, 治疗队友会有被沉默风险**')
    table.insert(guide['Y'], '   　 **非主坦谨慎使用群嘲, 以免Boss喷吐团队**')
    table.insert(guide['Y'], '8. 德鲁伊龙会释放闪电箭')
    table.insert(guide['Y'], '   　 **适当分散**')

    if guide[boss] then
      for i, v in ipairs(guide[boss]) do
        SendChatMessage(v, 'RAID_WARNING')
      end
    end

    local path = '艾萨拉 (找法师/飞机前往**奥格**或**东泉**, '..
                 '直飞艾萨拉飞行点后向艾萨拉东部移动。)'
    local route = { }
    route['D'] = '暮色森林 (奥格飞艇或飞机前往**荆棘谷**后向北移动)'
    route['H'] = '辛特兰 (**幽暗城**直飞**辛特兰**)'
    route['F'] = '菲拉斯 (**雷霆崖**直飞**凄凉之地：葬影村**'..
                 '或找**玛拉顿**飞机后向南移动。)'
    route['A'] = '灰谷 (奥格瑞玛后门出发, 沿河西岸骑行, 小心落水。)'
    if boss == 'K' then
      path = '诅咒之地 (飞机前往**悲伤沼泽**后向南移动。)'
    elseif boss ~= 'A' then
      path = route[area] or path
    end

    local general = {
      'YY: 6225-5763; 要求必须上语音, 否则无拾取不分金',
      '世界Boss争夺分秒必争, 等拉自重, 清尽快前往: ' .. path,
      '上述路线为最佳路线。'
    }

    for i, v in ipairs(general) do
      SendChatMessage(v, 'RAID_WARNING')
    end
  end

  return false
end
