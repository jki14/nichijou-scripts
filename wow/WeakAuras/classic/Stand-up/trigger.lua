function (event, code, msg)
  if msg == ERR_ATTACK_MOUNTED
  or msg == ERR_MOUNT_ALREADYMOUNTED
  or msg == ERR_NOT_WHILE_MOUNTED
  or msg == ERR_TAXIPLAYERALREADYMOUNTED
  or msg == SPELL_FAILED_NOT_MOUNTED then
    Dismount()
  elseif msg == SPELL_FAILED_NOT_STANDING then
    DoEmote("STAND")
  end
  return false
end
