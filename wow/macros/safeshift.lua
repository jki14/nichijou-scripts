#showtooltip
/run if GetSpellCooldown(9634)+GetItemCooldown(22849)>0 or UnitPower("player",0)<GetSpellPowerCost(9634)[1].cost then SetCVar("autoUnshift",0) end;
/use Ironshield Potion
/cast [nostance:1]!Dire Bear Form
/run SetCVar("autoUnshift",1)
