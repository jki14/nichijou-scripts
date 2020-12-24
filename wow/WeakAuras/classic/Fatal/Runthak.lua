--release
!WA:2!9AvZVTXXvCl7wy3vgo2mUc(RKSGTXuQvsquuwgficjCLOevG(klPIRDKa5SCgU7eTCMTZmR(W9laDkN1Fc8qakqpXZbjak)bKbcb9Aa0HaKRcOf9uuFZUKu0TQff5q2l7(EVzEZ79B(9EVDOfZ0kdod(t(LTPn4Sk8yrdYqI9xVztjrv(l(NEV25NF(FxCqQIH6Gync4In4uMYB(sRvTK7jn48qmFpwL9OrK6h3tSe2Ne4y8A9dvcQVpri)8hl6(5FZrDqeXRrSuXB1j9vnJkxYUeMQNMakMOVP(wELjOqvWz4dyOw0glelqkkNf4eZOkVOq0beHlyIiT8sCGmA0nwP4Zl5wRAr3LkvT28LlU2sLwyC3IlVqpDBUXcfRwsFZOVAIjS7gywWN))UtRMXSgM4y0XSSHhAt79q18d5EOqBedFH0KIyMkaTZLRDYgbKg7yRciSe)yEeevSG9FBTDpqcdBnWIBIcLelq5HYisy4YyP1PY4uaPsCZM097uB(IvQwRcKgv7BAdbbm5wzJsRSsBmXdwzv4MquU0kBS4MRCeCWPyZiau9xa8PVIFeaagx9deeES26B1d7jvivSe2ysU6GIv8dJLKAgMt9dXDzszYRVvhxeZNypVX367APVV(b6mEkKWNO03Z6iZUeMLux)q9JCt(mBHNCAYh14aIHuCr23zo9BOFt9BnIoJohee)d9W6BLOkRRI2IGp14izsP2AaLTU(TZwyk9ToE(aKYEvIuI8j6hEvrR0pJUTdXNYmOJTGQIrHGJF92x4GO7(cavrHibfXSl1IcBtCq0T7U)(rw7MugE0CVTm3yDmHqx7113)QNnGS5UVENbeI(5qjq1ARwzPARU(AvGA(AphOk63YcYUp526z1pnjfNsNxNv)Rb3LMrtRlaPHEYtQcrUtiNJTxIJnbVE86W6Nqpt9JnhmMivMejq)K6PyNvhmv(XjKRDHgarzs7hunL2Tc3N2iA7(KVETxgBqEqFTFu(TtyD9LNE7XS5IlKlS9RioZ2g2t0DqjhE3JCvoM8xVYzqBpIGHc)qyHWj)bNTdHeveQ2AOCn8OGJqmAReg1SUaZtOwupSdJZiN0JPL0LtijqJrS8ycssQOeeMVk46hAKmiU2XPfIYG9QD0ZRxqx666f1oEWfivg8VRgQzLahhCpjOnuu7c0fot(GD1dFei6XfyI4K0x14PnYBRi7RQ1GhYfwh31uI07FTYV73K88DdDTt7AzxQK6fcSIUYeO3E0DQ87IrcI9IXHH2plGQi9mlPVK8Z8ciu)av53B9ZpV(vUYpbiai8NkOmFbpokTAkeQjddCEjGprpADHVG2QfsmoaiqjvirbJAy2FikK4yG4rCBfhQOwjLVM9u)0ehmyPNBJqKuoI(fwUj2Yo9ujNKP6xe4yImJX2IemkbRVX0XuCNdWV)lEkn)MVCNPob6raN86rMRlP1H9MOf02CNrt1cbnV1qr3TNXQaEUavIaychO)fbTv8g7MYsUX4)QSuSWnT3L7EuSkO87TXxE7)85N)9DAkaMVjJvORDw641fnQmXMxL5DlvAn3U3mWJhecnP(waoA8ojWffgfGUMaLukiNvx8tfyEnOAlQ(P96aKw9C1J7jBOGhvzvyiGzOwBy9DTeON8Q6BM1Y6qqh0HHHR7M8k6Dw2q9BIAq2QigVotU1ZiODkcSo5wRsWu0wvmRtULdFF4oUiqPrjAMK77Fe4T0yi44e3vtqIii1WoaHw9y9FOU(M7p0NbJwstdBoBcJL(ZxStA43fbVyyZseOSJIRM0IEzgMS)O5s7xNBm7)0C2ZEPJusNqm4OJqEdyGvto3Eo7FV9Fmrhi9r5YptHFZ052guNBDaVHBbSD3Oi3GR6Ptpv6QkdCE7(lTckgGmMFUbofpKawOKec9mgD2XTLkHmkKQgn7ezh3EtiRxAZLx4I8yS(zR5SGDV9LMukrm5)54qlRlgnp3aJPHwFMu()Cs9CxU(UZQN7vUsSS0Lt6zB(vSLboQx(cZK)jf6qzn5I0gIJeDpQpJliDlSkzMhxsi4cz9Ja8OzYFvQ)PzKUfMm)KZKz3V(3(V(d

-- trigger combination: custom function
function(triggers)
    return (triggers[1] and triggers[2]) or triggers[3] or triggers[4]
end

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
