-- release
!1EvBVjYnq4FnrjrTfbeAVRFGtIWXLlP8su8MM2VSSMD9c(QxBKxVKWvv)BVZyVlSH3UOQRkOGF9XZ8mp2ZqyRWGqswijb)anvfgbxYcjtEmy4TJhesOfMfk9KLgUsMdlXaRKNVuqxhWEb6CwCijUi3OY89tlKX4AV4s7D2iBep1g9mD6CHAgvyJOYKA9Biya6YJmCJyvH0yJmlyspy4FAMPqdBXOYnAUC(fDSr)Kn6IJT7ZSrDUS0yyWXCxDqo)C7DWGHK1tstZzMWXTB2eCAzm403R4sWJ6pyCWGhQ7LpUmHAasQO8BGJuzudp(jEIzriPh0hgnUIZi5gQ24jVuUKNVW3gAIJssut9GhED1XSLiTrs4ih68PksvOIrYuQE2g11gDdZeWZy1PC3uhKwe0CGvuABuZlTrFayNgn3LJpgx29e8CfI)GnQ1jqYF8D9wOpOiYz1cp(y0DBDFndcmV2)pH91Adc1uDDFLgeT0)2g9p1wYgHy3dPop(gA4mo32QzMhyDEPI3X3eobnaOcav885mnkug7UpwoGR56LG(ITIHcXIC2uUmwLnJAqLsEXm3mKI0u(lHKPFS3OE3a3zlKL7WaQc8QDHMICziPvNnO13HJnAOAoUdqjsWB1W5Ub471mhWK7hmCO)8ZxYeIBtChVVz5Jc4KouGzK0mwTHDy58KT7kK0UZ7Bdx1syZaZpW5NFEWW7)0JdD7tULfqwAC7DyMD9XxXu7Ei7XuJULqg8X9CPVnrDyQ5qg8vNkuURbE8iwZgTElHStgBoQqPwG6eX8yHsYaCN92JwD(F25FBk0Dm(JPcoKd8ZN8I4BZGxGM7iwEoDo7OMCw18pXnlGeH6SCBuQGUCjKB7hTrRvf2iitxHbNeEMlP0nvf6y2yiaIUgosjsbLx0k7ovTKbwNs7s9KCX5NLF(LVAdh8PK(9ibtjb9EiypAS(5q6)5EbthrUz6GrtcgCiQelx4lUhZxHPkLR9zgxXc8lBKkHHxVD5dnmTKk(D41qKoh3(xbtJjslZeF9KGGjJahrH9Gm1TTrxRejo7)b28TLOiuux9mOPlaptGoPVbbWmgYc5smNvim8kd1nFn(6doPA8ERlN)v2UdA8wfbNA8VapEKVGMOE(pQkRaK5ANb6PnJRwPxQn7xG0(801Bl3WOIxvXdTADvtato4PLzoiXkzkFEznfAqgaQvQHIPqklF5t4O(JJ0)HbdgJBsO0(8m4N24jdpuHT7G)hdF4HC9Wz6V(BTgnB17Q8K)SMTcsewIVwhF9s(L0Vg6nRHEZTOdwDcVQSiF2U4fS4)Q(Tn4UhzfvZPZe41MfQNX(IcwfglOY5STa4NlyBLthoj9fxIBEPgJVM1vRogvFMAPy23C(P21TNjpuUM9Zxd(6Pm8xNcdOKtTyZ)np1xMX30vnOgHN5F0Qw9Pegnhfsm5Cm2Ev17Esf(BcQEMBQFWCggnZ9Bky76aWZOC53r42uZ83jabiFwPtEstxcV7w1cVzdVQ0O17A8EGRboVtBmue(Vp

-- action on-init
function nextLethon()
  local now = GetTime()
  if now - (wa_global.lethon.last or 0) > 4.0 then
    wa_global.lethon.count = (wa_global.lethon.count or 0) + 1
    wa_global.lethon.last = now
  else
  end
end

function resetLethon()
  wa_global.lethon.count = 1
end

wa_global = wa_global or { }
wa_global.lethon = wa_global.lethon or { }
wa_global.lethon.reset = resetLethon
wa_global.lethon.update = nextLethon

-- text
function()
  if wa_global and wa_global.lethon and wa_global.lethon.count then
    return tostring(4 - (wa_global.lethon.count % 4))
  end
  return ''
end

--[====[
-- trigger 1
function(e, timestamp, event, hideCaster, sourceGUID, sourceName,
         sourceFlags, sourceRaidFlags, destGUID, destName, destFlags,
         destRaidFlags, spellId, spellName, ...)
    if string.find(event, 'SPELL') then
      local registered = { }
      registered[24820] = -3
      registered[24821] = -2
      registered[24823] = -1
      registered[24822] = 4
      registered[24835] = 3
      registered[24836] = 2
      registered[24837] = 1
      registered[24838] = -4
      registered[5416] = 7
      local src = select(6, strsplit("-", sourceGUID))
      -- if src == '14888' and spellId and registered[spellId] then
      if src == '3127' and spellId and registered[spellId] then
        wa_global = wa_global or { }
        wa_global.lethon = registered[spellId]
      end
    end

    if wa_global and wa_global.lethon then
      return true
    end
    return false
end


-- trigger 2
function()
  if wa_global and wa_global.lethon and wa_global.lethon > 0 then
    return true
  end
  return false
end


-- text
function()
  if wa_global and wa_global.lethon then
    return math.abs(wa_global.lethon)
  end
  return ''
end
--]====]
