--trigger
function(event, timestamp, etype, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, ...)

    if etype ~= 'SPELL_AURA_APPLIED' and etype ~= 'SPELL_AURA_REFRESH' and etype ~= 'SPELL_AURA_REMOVED' then
        return false
    end

    local spellset = {

    --[[ TAUNT ]]--
    --taunt = {
        -- Death Knight
        [ 56222] = 'taunt', -- Dark Command
        [ 57603] = 'taunt', -- Death Grip
        -- I have also seen this spellID used for the Death Grip debuff in MoP:
        [ 51399] = 'taunt', -- Death Grip
        -- Demon Hunter
        [185245] = 'taunt', -- Torment
        -- Druid
        [  6795] = 'taunt', -- Growl
        -- Hunter
        [ 20736] = 'taunt', -- Distracting Shot
        -- Monk
        [116189] = 'taunt', -- Provoke @115546
        [118635] = 'taunt', -- Provoke via the Black Ox Statue -- NEED TESTING @115546
        -- Paladin
        [ 62124] = 'taunt', -- Reckoning
        -- Warlock
        [ 17735] = 'taunt', -- Suffering (Voidwalker)
        -- Warrior
        [   355] = 'taunt', -- Taunt
        -- Shaman
        [ 36213] = 'taunt', -- Angered Earth (Earth Elemental)
    --},

    --[[ INCAPACITATES ]]--
    --incapacitate = {
        -- Druid
        [    99] = 'incapacitate', -- Incapacitating Roar (talent)
        [  2637] = 'incapacitate', -- Hibernate TODO: check
        [203126] = 'incapacitate', -- Maim (with blood trauma pvp talent)
        -- Hunter
        [  3355] = 'incapacitate', -- Freezing Trap @187650
        [ 19386] = 'incapacitate', -- Wyvern Sting
        [209790] = 'incapacitate', -- Freezing Arrow
        [213691] = 'incapacitate', -- Scatter Shot
        -- Mage
        [   118] = 'incapacitate', -- Polymorph
        [ 28272] = 'incapacitate', -- Polymorph (pig)
        [ 28271] = 'incapacitate', -- Polymorph (turtle)
        [ 61305] = 'incapacitate', -- Polymorph (black cat)
        [ 61721] = 'incapacitate', -- Polymorph (rabbit)
        [ 61780] = 'incapacitate', -- Polymorph (turkey)
        [126819] = 'incapacitate', -- Polymorph (procupine)
        [161353] = 'incapacitate', -- Polymorph (bear cub)
        [161354] = 'incapacitate', -- Polymorph (monkey)
        [161355] = 'incapacitate', -- Polymorph (penguin)
        [161372] = 'incapacitate', -- Polymorph (peacock)
        [ 82691] = 'incapacitate', -- Ring of Frost
        -- Monk
        [115078] = 'incapacitate', -- Paralysis
        -- Paladin
        [ 20066] = 'incapacitate', -- Repentance
        -- Priest
        [   605] = 'incapacitate', -- Dominate Mind
        [  9484] = 'incapacitate', -- Shackle Undead
        [ 64044] = 'incapacitate', -- Psychic Horror (Horror effect)
        [200196] = 'incapacitate', -- Holy Word: Chastise
        -- Rogue
        [  1776] = 'incapacitate', -- Gouge
        [  6770] = 'incapacitate', -- Sap
        -- Shaman
        [ 51514] = 'incapacitate', -- Hex
        [211004] = 'incapacitate', -- Hex (spider)
        [210873] = 'incapacitate', -- Hex (raptor)
        [211015] = 'incapacitate', -- Hex (cockroach)
        [211010] = 'incapacitate', -- Hex (snake)
        -- Warlock
        [   710] = 'incapacitate', -- Banish
        [  6789] = 'incapacitate', -- Mortal Coil
        -- Pandaren
        [107079] = 'incapacitate', -- Quaking Palm
        -- Demon Hunter
        [217832] = 'incapacitate', -- Imprison
        [221527] = 'incapacitate', -- Improve Imprison
    --},

    --[[ SILENCES ]]--
    --silence = {
        -- Death Knight
        [ 47476] = 'silence', -- Strangulate
        -- Demon Hunter
        [204490] = 'silence', -- Sigil of Silence
        -- Druid
        -- Hunter
        [202933] = 'silence', -- Spider Sting (pvp talent)
        -- Mage
        -- Paladin
        [ 31935] = 'silence', -- Avenger's Shield
        -- Priest
        [ 15487] = 'silence', -- Silence
        [199683] = 'silence', -- Last Word (SW: Death silence)
        -- Rogue
        [  1330] = 'silence', -- Garrote
        -- Blood Elf
        [ 25046] = 'silence', -- Arcane Torrent (Energy version)
        [ 28730] = 'silence', -- Arcane Torrent (Priest/Mage/Lock version)
        [ 50613] = 'silence', -- Arcane Torrent (Runic power version)
        [ 69179] = 'silence', -- Arcane Torrent (Rage version)
        [ 80483] = 'silence', -- Arcane Torrent (Focus version)
        [129597] = 'silence', -- Arcane Torrent (Monk version)
        [155145] = 'silence', -- Arcane Torrent (Paladin version)
        [202719] = 'silence', -- Arcane Torrent (DH version)
    --},

    --[[ DISORIENTS ]]--
    --disorient = {
        -- Death Knight
        [207167] = 'disorient', -- Blinding Sleet (talent) -- FIXME: is this the right category?
        -- Demon Hunter
        [207685] = 'disorient', -- Sigil of Misery
        -- Druid
        [ 33786] = 'disorient', -- Cyclone
        [209753] = 'disorient', -- Cyclone (Balance)
        -- Hunter
        [186387] = 'disorient', -- Bursting Shot
        [224729] = 'disorient', -- Bursting Shot
        -- Mage
        [ 31661] = 'disorient', -- Dragon's Breath
        -- Monk
        [198909] = 'disorient', -- Song of Chi-ji -- FIXME: is this the right category( tooltip specifically says disorient, so I guessed here)
        [202274] = 'disorient', -- Incendiary Brew -- FIXME: is this the right category( tooltip specifically says disorient, so I guessed here)
        -- Paladin
        [105421] = 'disorient', -- Blinding Light -- FIXME: is this the right category? Its missing from blizzard's list
        -- Priest
        [  8122] = 'disorient', -- Psychic Scream
        -- Rogue
        [  2094] = 'disorient', -- Blind
        -- Warlock
        [  5782] = 'disorient', -- Fear -- probably unused
        [118699] = 'disorient', -- Fear -- new debuff ID since MoP @5782
        [130616] = 'disorient', -- Fear (with Glyph of Fear) @5782
        [  5484] = 'disorient', -- Howl of Terror (talent)
        [115268] = 'disorient', -- Mesmerize (Shivarra)
        [  6358] = 'disorient', -- Seduction (Succubus)
        -- Warrior
        [  5246] = 'disorient', -- Intimidating Shout (main target)
    --},

    --[[ STUNS ]]--
    --stun = {
        -- Death Knight
        -- Abomination's Might note: 207165 is the stun, but is never applied to players,
        -- so I haven't included it.
        [108194] = 'stun', -- Asphyxiate (talent for unholy)
        [221562] = 'stun', -- Asphyxiate (baseline for blood)
        [ 91800] = 'stun', -- Gnaw (Ghoul)
        [ 91797] = 'stun', -- Monstrous Blow (Dark Transformation Ghoul)
        [207171] = 'stun', -- Winter is Coming (Remorseless winter stun)
        -- Demon Hunter
        [179057] = 'stun', -- Chaos Nova
        [200166] = 'stun', -- Metamorphosis
        [205630] = 'stun', -- Illidan's Grasp, primary effect
        [208618] = 'stun', -- Illidan's Grasp, secondary effect
        [211881] = 'stun', -- Fel Eruption
        -- Druid
        [203123] = 'stun', -- Maim
        [236025] = 'stun', -- Maim (Honor talent)
        [236026] = 'stun', -- Maim (Honor talent)
        [ 22570] = 'stun', -- Maim (Honor talent)
        [  5211] = 'stun', -- Mighty Bash
        [163505] = 'stun', -- Rake (Stun from Prowl) @1822
        -- Hunter
        [117526] = 'stun', -- Binding Shot @109248
        [ 24394] = 'stun', -- Intimidation @19577
        -- Mage

        -- Monk
        [120086] = 'stun', -- Fists of Fury (with Heavy-Handed Strikes, pvp talent)
        [232055] = 'stun', -- Fists of Fury (new ID in 7.1)
        [119381] = 'stun', -- Leg Sweep
        -- Paladin
        [   853] = 'stun', -- Hammer of Justice
        -- Priest
        [200200] = 'stun', -- Holy word: Chastise
        [226943] = 'stun', -- Mind Bomb
        -- Rogue
        -- Shadowstrike note: 196958 is the stun, but it never applies to players,
        -- so I haven't included it.
        [  1833] = 'stun', -- Cheap Shot
        [   408] = 'stun', -- Kidney Shot
        [199804] = 'stun', -- Between the Eyes
        -- Shaman
        [118345] = 'stun', -- Pulverize (Primal Earth Elemental)
        [118905] = 'stun', -- Static Charge (Capacitor Totem)
        --[204399] = 'stun', -- Earthfury (pvp talent)
        -- Warlock
        [ 89766] = 'stun', -- Axe Toss (Felguard)
        [ 30283] = 'stun', -- Shadowfury
        [ 22703] = 1122, -- Summon Infernal
        -- Warrior
        [132168] = 'stun', -- Shockwave
        [132169] = 'stun', -- Storm Bolt
        [237744] = 'stun', -- Warbringer
        -- Tauren
        [ 20549] = 'stun', -- War Stomp
    --},

    --[[ ROOTS ]]--
    --root = {
        -- Death Knight
        [ 96294] = 'root', -- Chains of Ice (Chilblains Root)
        [204085] = 'root', -- Deathchill (pvp talent)
        -- Druid
        [   339] = 'root', -- Entangling Roots
        [102359] = 'root', -- Mass Entanglement (talent)
        [ 45334] = 'root', -- Immobilized (wild charge, bear form)
        -- Hunter
        [ 53148] = 'root', -- Charge (Tenacity pet) @61685
        [162480] = 'root', -- Steel Trap
        [190927] = 'root', -- Harpoon
        [200108] = 'root', -- Ranger's Net
        [212638] = 'root', -- tracker's net
        [201158] = 'root', -- Super Sticky Tar (Expert Trapper, Hunter talent, Tar Trap effect)
        -- Mage
        [   122] = 'root', -- Frost Nova
        [ 33395] = 'root', -- Freeze (Water Elemental)
        -- [157997] = 'root', -- Ice Nova -- since 6.1, ice nova doesn't DR with anything
        [228600] = 'root', -- Glacial spike (talent)
        -- Monk
        [116706] = 'root', -- Disable @116095
        -- Priest
        -- Shaman
        [ 64695] = 'root', -- Earthgrab Totem
    --},

    --[[ KNOCKBACK ]]--
    --knockback = {
        -- Death Knight
        [108199] = 'knockback', -- Gorefiend's Grasp
        -- Druid
        [102793] = 'knockback', -- Ursol's Vortex
        [132469] = 'knockback', -- Typhoon
        -- Hunter
        -- Shaman
        [ 51490] = 'knockback', -- Thunderstorm
        -- Warlock
        [  6360] = 'knockback', -- Whiplash
        [115770] = 'knockback', -- Fellash
    --},

    }

    if spellset[spellId] then
        local category = spellset[spellId]
        local wowtime = GetTime()
        if not WA_DIMINISH then
            WA_DIMINISH = { }
        end
        if not WA_DIMINISH[destGUID] then
            WA_DIMINISH[destGUID] = { }
        end
        if not WA_DIMINISH[destGUID][category] or WA_DIMINISH[destGUID][category].timeout < wowtime then
            WA_DIMINISH[destGUID][category] = {
                stack = 0,
                timeout = 0.0,
            }
        end
        if etype == 'SPELL_AURA_APPLIED' or etype == 'SPELL_AURA_REFRESH' then
            WA_DIMINISH[destGUID][category].stack = WA_DIMINISH[destGUID][category].stack + 1
        end
        WA_DIMINISH[destGUID][category].timeout = wowtime + 18.0
    end
    return false 

end
