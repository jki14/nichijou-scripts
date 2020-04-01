-- trigger custom-trigger
function(_, timestamp, event, hideCaster, sourceGUID, sourceName,
         sourceFlags, sourceRaidFlags, destGUID, destName, destFlags,
         destRaidFlags, spellId, spellName, ...)
  if event ~= 'SPELL_AURA_APPLIED' and
      event ~= 'SPELL_AURA_REFRESH' and
      event ~= 'SPELL_AURA_REMOVED' then
    return false
  end

  if wa_global and wa_global.diminish and wa_global.diminish.getDRCategory then
    local category = wa_global.diminish.getDRCategory(spellName)
    if category and wa_global.diminish.records then
      local time = GetTime()
      local records = wa_global.diminish.records
      records[category] = records[category] or { }
      if not records[category][destGUID] or
          (event == 'SPELL_AURA_APPLIED' and
           records[category][destGUID].expiration < time) then
        records[category][destGUID] = { stack = 0, expiration = 0.0 }
      end
      if event ~= 'SPELL_AURA_REMOVED' then
        records[category][destGUID].stack =
          math.min(records[category][destGUID].stack + 1, 3)
      end
      records[category][destGUID].expiration = time + 18.0
    end
  end

  return false
end

-- action on-init
function loadDRList()
  wa_global = wa_global or { }
  wa_global.diminish = wa_global.diminish or { }
  wa_global.diminish.spellList = wa_global.diminish.spellList or {
    -- Controlled roots
    [GetSpellInfo(339)]     = { category = "root", spellID = 339 },      -- Entangling Roots
    [GetSpellInfo(19306)]   = { category = "root", spellID = 19306 },    -- Counterattack
    [GetSpellInfo(122)]     = { category = "root", spellID = 122 },      -- Frost Nova
    --  [GetSpellInfo(13099)]   = { category = "root", spellID = 13099 },    -- Net-o-Matic (These doesn't seem to DR here, maybe only with itself?)
    --  [GetSpellInfo(8312)]    = { category = "root", spellID = 8312 },     -- Trap

    -- Controlled stuns
    [GetSpellInfo(5211)]    = { category = "stun", spellID = 5211 },     -- Bash
    [GetSpellInfo(24394)]   = { category = "stun", spellID = 24394 },    -- Intimidation
    [GetSpellInfo(853)]     = { category = "stun", spellID = 853 },      -- Hammer of Justice
    [GetSpellInfo(22703)]   = { category = "stun", spellID = 22703 },    -- Inferno Effect (Summon Infernal) TODO: confirm
    [GetSpellInfo(9005)]    = { category = "stun", spellID = 9005 },     -- Pounce
    [GetSpellInfo(1833)]    = { category = "stun", spellID = 1833 },     -- Cheap Shot
    [GetSpellInfo(12809)]   = { category = "stun", spellID = 12809 },    -- Concussion Blow
    [GetSpellInfo(20253)]   = { category = "stun", spellID = 20253 },    -- Intercept Stun
    [GetSpellInfo(7922)]    = { category = "stun", spellID = 7922 },     -- Charge Stun (Afaik this now DRs with stuns but it shouldn't? may be a bug)
    [GetSpellInfo(20549)]   = { category = "stun", spellID = 20549 },    -- War Stomp (Racial)
    [GetSpellInfo(4068)]    = { category = "stun", spellID = 4068 },     -- Iron Grenade
    [GetSpellInfo(19769)]   = { category = "stun", spellID = 19769 },    -- Thorium Grenade
    [GetSpellInfo(13808)]   = { category = "stun", spellID = 13808 },    -- M73 Frag Grenade
    [GetSpellInfo(4069)]    = { category = "stun", spellID = 4069 },     -- Big Iron Bomb
    [GetSpellInfo(12543)]   = { category = "stun", spellID = 12543 },    -- Hi-Explosive Bomb
    [GetSpellInfo(4064)]    = { category = "stun", spellID = 4064 },     -- Rough Copper Bomb
    [GetSpellInfo(12421)]   = { category = "stun", spellID = 12421 },    -- Mithril Frag Bomb
    [GetSpellInfo(19784)]   = { category = "stun", spellID = 19784 },    -- Dark Iron Bomb
    [GetSpellInfo(4067)]    = { category = "stun", spellID = 4067 },     -- Big Bronze Bomb
    [GetSpellInfo(4066)]    = { category = "stun", spellID = 4066 },     -- Small Bronze Bomb
    [GetSpellInfo(4065)]    = { category = "stun", spellID = 4065 },     -- Large Copper Bomb
    [GetSpellInfo(13237)]   = { category = "stun", spellID = 13237 },    -- Goblin Mortar
    [GetSpellInfo(835)]     = { category = "stun", spellID = 835 },      -- Tidal Charm
    [GetSpellInfo(12562)]   = { category = "stun", spellID = 12562 },    -- The Big One

    -- Incapacitates
    [GetSpellInfo(2637)]    = { category = "incapacitate", spellID = 2637 },    -- Hibernate
    [GetSpellInfo(3355)]    = { category = "incapacitate", spellID = 3355 },    -- Freezing Trap
    [GetSpellInfo(19503)]   = { category = "incapacitate", spellID = 19503 },   -- Scatter Shot
    [GetSpellInfo(19386)]   = { category = "incapacitate", spellID = 19386 },   -- Wyvern Sting
    [GetSpellInfo(28271)]   = { category = "incapacitate", spellID = 28271 },   -- Polymorph: Turtle
    [GetSpellInfo(28272)]   = { category = "incapacitate", spellID = 28272 },   -- Polymorph: Pig
    [GetSpellInfo(118)]     = { category = "incapacitate", spellID = 118 },     -- Polymorph
    [GetSpellInfo(20066)]   = { category = "incapacitate", spellID = 20066 },   -- Repentance
    [GetSpellInfo(1776)]    = { category = "incapacitate", spellID = 1776 },    -- Gouge
    [GetSpellInfo(6770)]    = { category = "incapacitate", spellID = 6770 },    -- Sap
    [GetSpellInfo(1090)]    = { category = "incapacitate", spellID = 1090 },    -- Sleep
    [GetSpellInfo(13327)]   = { category = "incapacitate", spellID = 13327 },   -- Reckless Charge (Rocket Helmet)
    [GetSpellInfo(26108)]   = { category = "incapacitate", spellID = 26108 },   -- Glimpse of Madness

    -- Fears
    [GetSpellInfo(1513)]    = { category = "fear", spellID = 1513 },      -- Scare Beast
    [GetSpellInfo(8122)]    = { category = "fear", spellID = 8122 },      -- Psychic Scream
    [GetSpellInfo(5782)]    = { category = "fear", spellID = 5782 },      -- Fear
    [GetSpellInfo(5484)]    = { category = "fear", spellID = 5484 },      -- Howl of Terror
    [GetSpellInfo(6358)]    = { category = "fear", spellID = 6358 },      -- Seduction
    [GetSpellInfo(5246)]    = { category = "fear", spellID = 5246 },      -- Intimidating Shout
    [GetSpellInfo(5134)]    = { category = "fear", spellID = 5134 },      -- Flash Bomb Fear

    -- Random/short roots (TODO: confirm category exists)
    [GetSpellInfo(19229)]   = { category = "random_root", spellID = 19229 },   -- Improved Wing Clip
    [GetSpellInfo(23694)]   = { category = "random_root", spellID = 23694 },   -- Improved Hamstring
    [GetSpellInfo(27868)]   = { category = "random_root", spellID = 27868 },   -- Freeze (Item proc and set bonus)

    -- Random/short stuns (TODO: confirm category exists)
    [GetSpellInfo(16922)]   = { category = "random_stun", spellID = 16922 },   -- Improved Starfire
    [GetSpellInfo(19410)]   = { category = "random_stun", spellID = 19410 },   -- Improved Concussive Shot
    [GetSpellInfo(12355)]   = { category = "random_stun", spellID = 12355 },   -- Impact
    [GetSpellInfo(20170)]   = { category = "random_stun", spellID = 20170 },   -- Seal of Justice Stun
    --[GetSpellInfo(15269)]   = { category = "random_stun", spellID = 15269 }, -- Blackout
    [GetSpellInfo(18093)]   = { category = "random_stun", spellID = 18093 },   -- Pyroclasm
    [GetSpellInfo(12798)]   = { category = "random_stun", spellID = 12798 },   -- Revenge Stun
    [GetSpellInfo(5530)]    = { category = "random_stun", spellID = 5530 },    -- Mace Stun Effect (Mace Specialization)
    [GetSpellInfo(15283)]   = { category = "random_stun", spellID = 15283 },   -- Stunning Blow (Weapon Proc)
    [GetSpellInfo(56)]      = { category = "random_stun", spellID = 56 },      -- Stun (Weapon Proc)
    [GetSpellInfo(21152)]   = { category = "random_stun", spellID = 21152 },   -- Earthshaker (Weapon Proc)

    -- Silences (TODO: confirm category exists)
    [GetSpellInfo(18469)]   = { category = "silence", spellID = 18469 },      -- Counterspell - Silenced
    [GetSpellInfo(15487)]   = { category = "silence", spellID = 15487 },      -- Silence
    [GetSpellInfo(18425)]   = { category = "silence", spellID = 18425 },      -- Kick - Silenced
    [GetSpellInfo(24259)]   = { category = "silence", spellID = 24259 },      -- Spell Lock
    [GetSpellInfo(18498)]   = { category = "silence", spellID = 18498 },      -- Shield Bash - Silenced
    [GetSpellInfo(19821)]   = { category = "silence", spellID = 19821 },      -- Arcane Bomb Silence

    -- Spells that DRs with itself only
    --[GetSpellInfo(19675)] = { category = "feral_charge", spellID = 19675 },  -- Feral Charge Effect
    [GetSpellInfo(408)]     = { category = "kidney_shot", spellID = 408 },     -- Kidney Shot
    [GetSpellInfo(605)]     = { category = "mind_control", spellID = 605 },    -- Mind Control
    [GetSpellInfo(13181)]   = { category = "mind_control", spellID = 13181 },  -- Gnomish Mind Control Cap
    [GetSpellInfo(8056)]    = { category = "frost_shock", spellID = 8056 },    -- Frost Shock
  }
end

function getDRCategory(spellName)
  if wa_global and wa_global.diminish and wa_global.diminish.spellList then
    if wa_global.diminish.spellList[spellName] then
      return wa_global.diminish.spellList[spellName].category
    end
  end
  return nil
end

wa_global = wa_global or { }
wa_global.diminish = wa_global.diminish or { }
wa_global.diminish.records = wa_global.diminish.records or { }

loadDRList()
wa_global.diminish.getDRCategory = getDRCategory
