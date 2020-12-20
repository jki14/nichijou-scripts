--release
!WA:2!9AvqprYXv4LDtKTBqRX4Dro2RLBnj7oqcGbgwwfPfLDgyGHvWcUNbBV2GMP6UQP7k0tvDQQAwyJID8Kl(m)eMdwks50C2Yrc)diLqw5AK4qKYvKsKpzYR6UNHztwBz5dUV0D9Qx9E1RQVVVxp0QJ1Am8y4p9x0H6Xzv5XcpYqNIIvbCXwrkkNjTehTvZMsIAOUiMhyFBoLPCxU8JQv25upopeZFcR6tOrKgN0ByzSpjOKjMnAReuFFIq(f3rK95FVK6OiIRxSuXB1n9vDJjhYbeMQdM4g3SznWGOs5n2E1D2qFD3keuOk4C8rmulQ3kXcKz7fCMm2nzvBlinPh6uD7YBSrFJvH4qpSB9LlwTw9Q1k6ul1UmAIT3O4Jl7uhSTw5A1xUsXhTw5vMYP46R0Z2oBVsXALBlJiHHRJLw6rI(BtpTDwrybF(9ngwnJzEMT7etAzdp0M2pbv3pK7IcTrm8LJMreZubO9F(wNXlG4TVTkGWsIJ5rquXc23MVzjKWWwd4CtuOKybgDGdtI0QumJQCJcrhre9UpcOyIEKJHGLwVJdL)FgQ5(g(rOOyC1pWc7oAR)PEyxPcPIL6BQhxF9UoiMpXEzZQBJZWpJnNJWyoxH7QFdlidjWJsadGRVLRcj8jk9pZ64yjPEIJnAB(0CE1q)Q6BCwIX6CaQIuCrU7VK(L1JQFRX13sNh2e)h9WqMHZyjYNyq0NcOKA13S6A1Fmau138QNzINmH59i4YOH(NNRWSrJMTK(rUttkdpr(BlZpje63uKnF0OLi(uM50ZwqvXOq9REv9TDu0weS(6NSCaszVzQVDnzkBDn6CzkJUXhaxmOqKGIy2LBrbpehD(aEB24nslmlOO(0r1)k9u6PBykoOemBOKTTEg9BBY)SNwd2pLc5CS9ACS(U6f13wpp4Cb9cnoXezmrQmjpqFVErUlMk)TjyQdaKx0yPaXAPOTn4(uVO96J56PQm5Gx)9T(HZTxcyR)453BsBU4YXf27zgUWEgqt0RGssEwk3KJj)LRCoO2remu47cocz(DoFFcjQiOk4PCmyOGJLKWMjQI6FkODjbihCLrc6aQqoWTdiI(6hCQlxGjI68uTu9WhdZMARJICOQUhpKlSojZTKrp8Av(n)JKN)1qx7SSzoGkPUHKgDZgtaP2OxP6Vlgji2RghgA)EbufP30s6tjVKBaH6hOQ8GTU4Igx5k)e4MbH)mbL5l4XrPO7qa5hgu6PCgj6wBj8f0wTqIPQQmi8qIPJaZ(DrHKsMsFCNwXHkQvcBWSMgoEHiPCCTJ1zjHAqoHtILCZpBsMmCmrqjZoZ4EhrYzKbJPFrxOLrtQVL4W0Mov(RFT7lFXfx8V7szn5IwjK2XJEnQpJlizTOkB4SLfcUq2WaImczRdbYDUclm3Dliqjqg5IoGCGq9zcmVoanJACwpswks7QN0BSPx0Xv3eAxy0Y7a(NntGE2RQhjNLvBWgWGy4gNK8QUGerqQHpgSNgTaNKjIU)6g8ttKhz3Iy8wm5UVhbTFraIi3DtcMI2TQXp5UL4hcxiffegkXYmCFFxG1tLbwLGxQ7OPn0JC4qFoOcNws2C20Mz6lfBNOn6KkuEPU8AeaQsX1sKZwNHjhor(uTT8tA)rlzV4Zv9nvmDqv2qUhOT3KZTxY(3B)hsSbJ(W8ZTqHF9853dmNFl4YfWUy7SDr(b96EZpBQxva8ODFxRIIHtiMF(bYIlsaoculGNnXItzlvc4ILQMi305MYEhOQxBN1x5Y6yY(vRjxWQ375wukrm57SZHL1LDXwAGoAGCHPK))BQT0Z3EwBTLEMRelROB07FKQbS(vOseqMXgEhV1q67e0rX9oivP5fN6xMJIfzlTBtbixAOJk01CqHrbORDE6FKTQzgd)XT6YoLl)iNm1d4z(ykU7r4h(b3Jo3opD)zboVj6KaNNqXQGkpy7VC0p(Il(MoaDbtt)HV292HbhJy0uk3IA0QN2RPzc)acIzns9WLya))ecsA2DeMVk4fABgLWO)KsTqu2Q6pw)hHUfFIU9lO)tWRW)xlJjDkmZCZSWyh8vV))n

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
