-- release
!1AvBVTTnq4FnbjbB1WYXBT7dza2PUPjZVeeQSS9fzrlrzZozsdskN4om(BF3rkzP4y72v0HeKisE8Hp3ZDK3ffefgrwgrsXFHpLfMCUGfrM8q4WBgpiIqlmlKQjRmCPqdMyal56v50nHSNHbNKersk0g5s)4ScrcA7zNBV1gBJ5z24NOtNNlNrZTXurAJXTYza6IdmDRezHWyJnlycpy4pkMPqbBXi1gfxm)SU243yJp7q7(eBC3ZljddoMBBcYPNAVfMmISzswMMzIg3PDBWPfjGtFNKlap6QbJdhCFtV8HvPudisfL)h0i5sQHN8ip1SiI0dgdZMuPzeTHQmEXJl44xKu5upGr9RGUw8SXc4yg68JkHmxMGcOq(Kn(sB81mtiFjRPm7wAVsrovdkHuzJBFUn(xbfPv7D11dPFxEeTTcXFWghCeK8h)LEg6de5AwJqIpUCBT7RyqW4L()r4xWweAKPD5lY7qM(324)PHjBt(UCFzKhEdTCKZTTg0Cp25tp8o(2WjMdKbjb6fU8byeKfpFotHjkJD3hlNW95Mvq(fBndte1Ry553ajRD6(UoqwQUyMBfsrwg)5iY033BuVRH7SfA2u3kUTd5xPfkkkSrKGUBH7k5YzuWpgkNxJ1DkMdlYDdgoeqcZwj4TDGpoCRir)T8P8vbbDjR8t0o3o7JiuECgiBn1VgxK4oBh1yZa6h68Zpoy4DF4HHoie1QaQsJ7SJY8kNF0neYG3)fKS9XMgE03QoTpcFX)Lq5U8QMiTBfSFMSJEFW4YldHhmN5qjaa0j5sbdGE2xF0Q7)Zo)ryBdHyhYFOuM95a)0ooGdzzHkHng0DeTVswVa58iMwtNZoiVxwT(JCZcOAOAP2gNLtxTckW9J24nYcBmuURWGlcV7LUhV5QEKWPKWE3h(kpVe)PYvmGKsL7jO0Zo9e9PN7nUIb93jw1yTWYhtAoKC1h7foDe56PdgnjCW(KsSDHp5EyFnwQuSXxzCnl0B2izkdVE7QnAykbn)3HxdrLCCNFjI8KuL(OIUceNTFLjrUbLQ7yJ7lZ9QX9S519OKlPUgAGSHexpof5gEfJsGcs6xnRM)z2UtA8NfbxA8pdVjOxqtLp9hvDlazVk3X6vdJRfinlpRS3H(tcdNmkI8jOappBtDZegzY6kVmi4I2a0CWnkRraYeFPpBQr3dLrgHeBqJr1mibLjMdDCap2Sn)BQ3knlrkG3aCggwVrGulPCX3r42wn77eGiKk4sgSBQHI1el7h7d4SEtjxD)GbJJip3iqa4LXN7d)(W0F(Yvt5vnK5RZMSGL8xnVNd36jRPkoDwoYWfYNWX5fmCdyEZcQyoRga)AH19VT)wfo7CCZRu4TpZMkRtW8EtJIBVMoVPtt(m5(sBEDNcO(EeI)YINWJZhZyZ3MN6B25l6QBJnxjZLkp(q4byi(3lC)TBPCdpRXs9Tu7BlVaVI0F4m1N)TGrZw)wmQwJsqduc2IcEGWtfTcEBR3b(bmz3o48r)7d

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
