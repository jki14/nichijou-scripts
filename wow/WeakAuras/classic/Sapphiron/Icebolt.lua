-- release
!WA:2!9vv3UTrruySSqLUQsaguAvlfgc0e70wJT7pqLivQBQtjO87ANMYv2ZU7S7oTRNz1mZMFabsyvvX15cEa8DCRFe6daAueIhG(i0l4AoZSojTv11sE3zoZ58nNZ35NT0YvgujSs4FmRGNRsPmIyJT7U6kR32lGNYf)y5sLlpoKkZsXh0LSVA2RemkixQ4dm7Y(ROCwGIYzvR5Gq0i0E4EXPCFCkcZcpDxDjollHk4SPjVEapNPqQecdqcHeevUGHuCPsqzXvREl01rvNUHxbDRA1SpbZjSqNtGy(5DG9hjtWH89(PnIIKevPXywqcxSjNYu(l1E9UT9Y(OtdSTZcXkIFU91lW5GySIgSdnuL4EpyRaBdB5T9KkSq54szu1ChgY7vasF)I37x6VpMIqma4oh72wcdHs5baxX47Hwe9aIQlDazYjazAepLGoflviUa1Og6UOM1BCkXz(nDAAX3fhwG3vrnFNazV6fnoNvndxB(7CsCkiad)Mb67YLAuaWP1ol(k1rGt9lOF15TvkT4BTaB6guViFAC(xnv8wv1geGMVEW444hbzAzIZqOSmoMiK)2CIjl)px1bzepYUeM655sspklGpWhR6lYzwPEki)gEK5m7EJ(9hgMlWgIB2B0qFHrlznbTkp2JHhqKoVqM7B1EtbjIUVxNnBV6QJnyiZiPPRe2F4Kfsh3COm030SsednQy23)ee6Khbii6D)7T29EqBXeZ8ADZVRvJrHq9EuuxWLe)q7v3C5Tx9qi9ueAoZPN5z65f9wBLoDAFF951xqxtVG(I6lPNTV(Ywxx)5AK(l1x3O8)(AQC5wnQ30QWx4y0)RC0ZRRA1(R1xXglbPCgzLWe9v1xRaI)81Hq)nNCdacnsaeQdkAgo9yBL3UKwy2bzFm2UUBHJVgpK8(VeAYjcgo9Hq(ci6ToussJk69D3OB3nwZnIZuh2QrJwixEA4iGW8iXMgCh3uoo8zUs6ptMXBqEQI64LcSzAL7COXXTR7)c7RECG8WW0Hk31la6tKZO)ENXeMTqNiOHUnB28oUaVhyo5L2cHtpT)qJB0bUPFFY4QhnzC1iH1Bmjhxfu76hWzr0yNH7XfH7iWzd3zYcXJH5o0Od0NDKIhSBra)bxBHzPHzFYj1XWyLvci(8u1iaPqQDw2cZ5fKqcEYT1ZCT3B4Uybf7NsMDdpFRy5cWbL1B5kt475TlonNucK8(6T0D0DljcsWSyI8IZP7oJUs2LMAxv1AdZegMsDWKVLeazP50BAVy9wWnQ9mx2zkGUmS8StwQ3(y8)SP3GxTMEh9JghjG(NokiHGl)YI59lBezyr)ol51U96I9NqWTYPHJx(H44VvDh5dzRjoO4GNEUJGP)GLBKz5iNXfjMLSFDSuPsLhbDuKq7xgE65gtzrCXaB78mzxGgZ4cYetBB6aBleCHS)HygTqRBR)WL1N3Lbv)pNGLg)LWIvjN5OJhl0ZmLqijMeLCOrhtaOJDhGPmWwDSo5mAQ(X6Nal)03usfP3nQ3S(nRS7)8O))p

-- action on-init
function nextSapphiron()
  local now = GetTime()
  if now - (wa_global.sapphiron.last or 0) > 1.0 then
    wa_global.sapphiron.count = (wa_global.sapphiron.count or 0) + 1
    wa_global.sapphiron.last = now
  end
end

function resetSapphiron()
  wa_global.sapphiron.count = 0
end

wa_global = wa_global or { }
wa_global.sapphiron = wa_global.sapphiron or { }
wa_global.sapphiron.update = nextSapphiron
wa_global.sapphiron.reset = resetSapphiron

-- text
function()
  if wa_global and wa_global.sapphiron and wa_global.sapphiron.count then
    return tostring((5 - (wa_global.sapphiron.count % 5)) % 5)
  end
  return ''
end
