--release
!TA1xpnooq8Vl7lfKoqnLYF6d3dbOfypOGQdlA11lTUXtsSW1oNTtl0vx(SFJDsARaECvJICM)pJNFZ04G4OyYYycZ9GhtucLgpmoW)0Z)(e)7(U32yY7pMMAaB84UXeQmjxPFsXLiJRgooA4eNnucMATKSMxaXxUJWqwgeVa1kXYvsJZFglvB9huLs2mnuauRZxeMAMqPkC675ftUtAbDknbMgYyO(tFbOVgwQPMPpPwdA)XhagNoL40Wm1KZlmRZ5gRaowLL5TAT1U0LkPCj3KJUhpJhT(t4zRMNLbAtDHiAlb3rk6fjDj0WKCzPwYLzvZdzAqsfCj4QBK75R8KVuTCHZMmupxAhtqLkDoJuiOVJgLWGfLPPrVJvlYTHtEy0Z3JjDUA9vcLeDewYSEMjLgRAPtDyf4k50sRQL8SCoBFzmWymmD1VgHVfOcB(wXRnzdVwTo6OQ5njB13tlL(BQdoS67vZR)jujur18uLQA(Fwn)xvZ)VDmrQ)DNZc6oOZ)452jCtPgYuMoFqMGENm48wHUxPzvZ)l6Mn0x)KG9V4Il2kiyZvYVsKToC4sqZnMVqMbDBLjIcAQ(RmZ2q6NgLeVo3tgxHPj07pyBeDTgOlXEyXRW(gSPiTGQ9IzabKyp4S)apA1Mcb3EW3o6B4NpJ9b388DxFqhehKb2ohE4E1AEATpr7G(ZMdYD8A)Pbl2a6U0kHDCbjB3hTIKsfgugWHLmLl838eSXJ)wmz2vHKOzKOWjoSybie3Xm1adVCMyYt3h(ZHtMHICZWOzxDB44BgEDmPfly3z0N0G3OKNgEp2j7AUjy38JY6U6hLHyB1kW3JoZdf8OXs5EWS2gYAaj1Rqun7huyF(4Jc6wdBXHciS7hiC1HUg3Bqm5vakcXSiXoXH58ZCK8L14V9N60ckBadgibV3nTWnjI(W8NAaCaaiZqWdol0tiANayqSKYL)gn32Xs)MmOB6dyOwNX8dGl0Qmnym4fvcVUS11F9nbYAMmxp3Bbcnb9m1Uj(num8nGFmTfEZoRDRHDl)pThz0fdop4IZpBq3(N3Rx)UdItp60((DlD3TBPr7vyqTq4ND1qbCRoiK)TKQHQ5Jkfi86LCoMon1cm4RfToFZbEwogXNHHOqr972WXXAvzrDCMiOg)gOLLclVDWVRHmbhyJ7Gw4XbjFseFM)bIizTVYvx25jUX8PAezGxmul1VOWt1TndePFyJjJBC7cUZjX4Gt6hC6P72AgHv4R5gkwqy(oz3mF3kbvYQ2M(GGt6Izkhr2VO0c2LkJbrLK32FxTOiVoswZzUwfxTb9ykpRUKu6u)MILBg9(zpxY(HRI58a04vCt)JfTBUTEDz89(U(pdmYL211bYvtgoCCmzJcrYJ9WvmM6DCW5hJ53kmw63ZDTh))p

-- trigger
function()
  local foo = { }
  foo['6109'] = 'Azuregos'
  foo['12397'] = 'Lord Kazzak'
  foo['14888'] = 'Lethon'
  foo['14889'] = 'Emeriss'
  foo['14890'] = 'Taerar'
  foo['14887'] = 'Ysondre'
  -- foo['12498'] = 'Dreamstalker'
  local bar = select(6, strsplit("-", UnitGUID('target')))
  if foo[bar] then
    return true
  end
  return false
end
