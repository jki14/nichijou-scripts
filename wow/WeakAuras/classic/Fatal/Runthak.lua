--release
!WA:2!9AvZRXXrwClPeStlHSSSTytIx2gLypsbjH(WwMawepZOrFy0xPNr2X2smt1tvt3vupv1UQQ1hEzZc6KpR)eMdgceYH5CGak)bKcrixdOdbYvbbYPv7R6UNrAtuwc5q6lD)E1REV69E)E)QUJ56VE)4(XV69BqRYzf5rIQKoocfP85IvdvuotAj2B1A1KevhnrSQG(14uMYnFHvkvW5OQCEaMVdR4o0qsLdBjwa7r8Zz8zL9vcQNhri)Y7is)87ZP2lK4wnsQ41BM8QSrLdzBct1atCJQvReOqSqHLwBU1xs3R7ceuGY)e8EmuDA1zJeiZXZ)yzKB8UwtqQr31P4AfwAP2klc(HUBZY5ZwSu5ILY6ukrVmCO1wk7tl4ug0nFHsLZVq2vMVWSJ4KDXzBPB91MnBPc7ldjbblILw6Ec)2rh1onjSGp)J6dRArSQMJ7qdBzdp0A27Gk7fWDrb2ig(mPXermLpARlw7yv9jv3Yw5tyX(X8iiQib73Z20asyyRZzCnuGKybkDGIjrALlIrvUHbO9iIw9dFkMO75aWzj57aq6)5qo3wXFbjfJR(tMy3rB9J6UDLkKksQVPEahbI5rgCQ7Tpof60)e6EB6y0AN34r9TCviHhrbXjgKKdMd4631s)2whejjLJ9qL9nFAQxv0xxFJJJvwMdqvKIlg8bZOVQUp9)ya9T03goeVQVMqbwI8ig4C4nbmsPYlxC(YlV6kfHbOYpfGRnKXdERa9IWB8mOiHcqckIzxOof2RyVJnX8mJQOVzN674OO1jy97n4uJh2xAqAFqAuJYWdL52YmddNK)UiD9Jk5tSZfW5y755y917u3TUxDVhM3hPSxoXMMMGLAFLdncyIuzIR)jNBjt(ujjzTAIPYpngnSnGzc7pbcvkbNSe3JwnCL2OLw8bdF(gxBTpFInJHjTLNCZHT5IZKNAtt)n8AO4OLgJL5yYxCPtaIjIGHcEmyieQp(KTiKWSWaCvLJPN7FaIrRh39N2bWgc1Ch1coetajKeGZcl1DNJXzKdjijPOsqyEk)lVVrYK2685QJOS50z15GcyE9SxwxqN3fQ5uP)VwnqNjbuiefIFdGyYH4z4vFNTpYLlWerzEc9QU7dGvt01qr2vvUkpGlSom1SyPh11cF0pe)8tD01XPRSnvsDdivAMkta23WRv8fribXEUOGa7N4tvKwllPVK8wU(eQNVAHhU6PNw5sx6naqbc)AbL5j4rHja(aymiWp3lHkr4Twv4jO1RJeJafea0hqmxsWSFmkGKZuIhWPEuGIAfpGy2tfNQbiPCa9tToo2vNFmXjwZGtoECKmdCc)CMtMX8gI4AuCT(kUqhPg1Z6ajjOw8Lp63SjLvJls6Kde(3OEmUGKEHvbZSBbHGlKvmatdT2IGpCNyQ7oX9MsGIHHYP1p81cmVmmmew54wZpji3opSLSbuCqXLHlomS6na7txXxpvN6Eg0YAFqhmAYWvom(vzbjKGuD7elf(GfnyYAOQKnYIXRYKB8ecARSaCqUXYemfTrrJDYnYX3fk(zbSgkwZyCpVdaFNCI81ZBLdGxQ7OFrfDp72XxbuXjzInNnQzL28X2XeKojSLNroppbgcO4sXCClYWKDhktcHxMHT)SzSN(cPGtyuppvBaVkqWxJZTNX(FA)VI1bsppZe3DQpCYmBcQZSk0ob0k2o9uK58wD)jhpXQfaeODBtlIIG6eZlZ5IIlsagcnEycEOPhXwQeq)KQgAWrhCe71HSE(1xC2ZYJHBNTMyb7EZlmPakEY)3RpSSo7QSzo31AarKjL)T3SnZfRp9UTz(FAjwwH3O1pkvcMZNLkrW4l2mPXR3HoJFdfV62jCyxzKpyqkwKUvhuqOpQRM1eaDSzouH6Yzhkw5VWdx7B67FF6P)hNuEc4zYikU5E4h9S7tNy9xU14W0TXRapEYFYnNXlMHm3I5DkuyLggUpAYF9TFRtOVy3K))BHV(xCV6PNE6p3V0zQXMyS72)2F3N8F)d

-- trigger combination: custom function
function(triggers)
    return (triggers[1] and triggers[2]) or triggers[3]
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
