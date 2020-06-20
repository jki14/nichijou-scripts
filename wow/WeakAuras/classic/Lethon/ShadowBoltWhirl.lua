-- release
!TE16YjUnu4NMmjzAxgGq7U9h0zawVztkxYe500(hJf2YyT1iXijtcBN6N9Eos2Gd32n7KjmbD7C778jDoe0kWpGSiGeJFGHYCtgxWcitEWF4nJ9cirYmPc2ACl7N2bJBgm(k74o4)nGKC9Ym6AF2ZWKZIazY1g5c38KCrKHlfxCzXTfHfH8KIWNOtNNjNrZkcPI4AZBKXmPsXrwUrKmxykcnPmHtz4FkMjxbIyKAJIlMFrNIW3veEXXK(SIWoxw6mmWm3wxjNFEXTWIbK1tss0mdeWnBgqOIOuP6ojxar0aVX(E3xpkFyzm1aGwE530CydQHh9ip2Kgq6bZHvT4GgHzTHQmWaqBCbhhrILtDkmOFLQ3cEfHcWmdTXrfqMjJqauiFQiSBr41mJpFbRomB36GqrgvdiHuve28YIWFhqKgn3fxpg(19eyBLg)PIWwNqtoZ315HUerMMvlL4Yl3Un8vmiz8Y4)e(xRnAOgtR7l4DON(VfH)xTJSH819qmYJlqdRZzfRMBEGZ5OhUaFt6e5ajajqNA5dWmGfpFotPDx683SGD46La)ITIHer9sww2nazTDNp0gyP5A2u7w2tb0iD(m7CsEsc)5aY0p2BuVRHl1X5kkcSbKwD2OUbYfZOqCmuoFRO3Pywrj35nCiycKTsWB7G)ynyLt0FJ)ODeBbDbRCiEoRK9rnuAodWwJD7XfrwBJ7hZMbERVno)S3W7(0ddTQqSffqucEi6LiZU69Ki1EaZOBieVpUxe9JIthYHV61Kk)oYCnB061L6ovYAN86oy5oPYOmPGbAz23F2QZRIhVJ5FZI5DC(JXcoua8lNma2vrd6r8Ns87DV)EEpGKA6C2u5sgSouAfV9hFX5NPp)YJghLcfqEKBsHQJQf6IWKm6YLqbVFUiCTmViek)LBWnH3bJp8fTAbFfkMIy4Ok9JhQYyLaMwMRIyJbkakwTd4x(kt9PKbFUN)0rKRN6nAIV3HGsSDHVyFyFfwQuS2vzCfZ3DSrYygE92wB0WucA2FcVgIi442)gkbFHdqRviTmFiKyVlmQMb5kMyou8fU3Tjfm1DknlskaMV9G(BfeS4ckx8gQUnpS)gPquLsmTbDL0UiSVml2YzUNnVS1cyVmj12lhq8JST3LNz4vGFeu7vV3QA(xz7UyPTi4wJ)v45pDknw(0Fv1yeCrvznRZdn2U9EsQIFurxcm1nJ(c0mdpz92gNmYOvvz0wTUQjOBoehL1dHWplPSvR(t89NmcCefq)aiJAOynXY(X(eUQZ6Kb375noG8CnVlhvA)HZuF9pAnA2Q3xfb)DTZGanVQTmx12Ouw0)u)2oC3NSIQ40zzyYjv(eoplNv2(BukvmNTvbU9832f3HBy4IlrHxQWhcmRRoDeY(n1kXTV78U219Nj3xEM97xaPwNWXFzju4j6tDyZpwK6A55BgQMQCZGA)AJM1(1gn3(RnG3fzXUgRDnNd5We(Ch3h68gigtwA2CDavnCFPrR334dGhdkPtBupb))p

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
