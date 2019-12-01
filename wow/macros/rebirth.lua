--#showtooltip Rebirth
--/cast Rebirth
--/run
local s,d=GetSpellCooldown("Rebirth")
local msg=d<3 and "Raising up [%t]!"or"Rebirth is in cooling down with "..\
                                      ceil(s+d-GetTime()).." secs"
SendChatMessage(msg,"party")
SendChatMessage(msg,"say")
