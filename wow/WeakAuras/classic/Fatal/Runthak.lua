--release
!WA:2!9A1ZVTrru4MgqTSjQqTQIkLFTkcvNiLeL40McsnIAN4eNQ0gR1ouGMI9S7mE3HSEMLzMn)OiaPCIZ(pbFOsiXjFgjKc)bWOiexrkhqIRrcjor4n7UojabeIdSx8mV3BFZ8(EVVV1dSuU25W5WFXB2L6Xz14XcpYaIDwRvljrv5B(v3x84Jp(xe7MAyGEiMxaxuLtzk3fk)W6LDoWJZdX8Tz12MgrAUF)TLX(KGsMS2CpLG67teYp8MISL)qj1UrexVyPI3Ux6pnmMCiBryQ(wcOyIEy9vCRqqHQGJW7YqTPElglqkkNfukMrvUrHODjchWfrA5MKaz0yvxT47x2Pr9IolxUEJfQu8HlxEXjCkUYI9TTE1flwVSE4OVBYjTZUywWY)TVPvRyMN5Em24w2WdTL92Og(HCxuOnIHpD3uIyMkaT55BDkVaI3M2QacljpMhbrfly)DXMDGeg26mb3cfkjwGX9KrKWWvWsRdLXPasT4wTO70RXcfRvVrnOmQFIRQcc4YPw1YRUAxmXfISo0jevkVA1LwF1oWbNInJaq1xc4Zjg(FaayC1)rq4MARFspKRuHuXs9lRVHJaX8jJo7T3dNn)KBg9v65ySAVGjJ7fljnmJunHdkbBkHIvC9ROFv91T6y8MKJM6CUkKWNO0xZ6Wetn4aIHuCXO3DE9RPFD9BmIoNE8EyQ8JsaPTifqHHrxfLSUEka(aoM8vx4iGnremu47cCe4AT2rBsirfHMONYXCrd6Gy02jx55CGcsOwspujgNroOFPKqEescW3WY9jijPMsqy(QGlTNzNPJQluQnIYG3vxqpR(w6BFj9C6cUTOmQm4pBggfKa0bPNe0fMvCi(W5iVXw6H6aBD5cmrCq6pn4P6dDvKDun84HCH1(zUs2D)bR8o)yYZppWGhM5zlQK6gsA2lBpbKmIUATpogji2lfhgA)OaQI03TK(uYl4gqO(bQk3BTJpU5fUWZvkKJWptqz(cECuApkeADHbLEkGpDwt4lOTBJeLmW5ioTJdvuRKgTXFZdtc(SDphVqKuoI((woj(gTW0jz1mqickzUfgNDfj4rcUE5dGXeqxCTitRqAjqjSc5C6zEMaZBeY5rnpeuNKiysjvB7I73FVPZ1P2dakPrIPleFMNar2IlQhEulR9apsEmd3SdSknlbojwIU7kMrOwipYgfX41yYnEebTzrO7j34bemfTrntCYnkX3bWQIWObkXYuCF)9tYrdbjIGudvcMgu3u)4M6H3zGVgO7PfJnNnPXZjCE7esOtkJ8ubGLjWmlfxpHEScdt2zS8PCL8JB)zZBp35sZtzTNLohY9arKwCU982FI9NMyd2948ZCRzF7c5Fcyo)AqhbgUW2z3I8NnQ7uy60OQadm2NeAnumGtm)8N5uCrciqjjeiCJn3e2sLqgfsvJn6KJoH96qvV86RS4P1X4NuTMZcE7NCUfLset(hLOSSovUC(ZiDYfjL8Fv9C(Z3EM(58)HwILL(TS6A0dOPtLrxN6Z4cs2uAzJ(wzHGlKn7a1ERKVQRFEG3WBpGoFqxf3BRufPlpX4JsXISmxiMI7Tl((FWDOZS(t3C6ETeWNEb9gKcn4rP)fHLmMmKd3Al4uU8dD2MIvbvUx1V9L(8Jp(3CH7vlQVfqCnhbjWjtMaECqHrbObnsNMVSVceQ7mZERzU9S71)pxeeDT(lRdkolsLiqibhKt6m7utp1C5267FVF)d

-- trigger-1
-- PLAYER_TARGET_CHANGED,RAID_TARGET_UPDATE
function()
    if wa_global and wa_global.runthak and wa_global.runthak.check then
        return wa_global.runthak.check()
    end
    return false
end
-- untrigger
function()
    if wa_global and wa_global.runthak and wa_global.runthak.check then
        return not wa_global.runthak.check()
    end
    return false
end

-- action on-init
function checkRunthak()
    if GetRaidTargetIndex('target') ~= 6 then
        return false
    end
    local foo = { }
    foo['14392'] = 'Overlord Runthak'
    foo['14720'] = 'High Overlord Saurfang'
    local bar = select(6, strsplit("-", UnitGUID('target')))
    if foo[bar] then
        return true
    end
    return false
end

wa_global = wa_global or { }
wa_global.runthak = { }
wa_global.runthak.check = checkRunthak
