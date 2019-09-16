function (event, code, msg)
  local mounted = {
    ERR_ATTACK_MOUNTED = true,
    ERR_MOUNT_ALREADYMOUNTED = true,
    ERR_NOT_WHILE_MOUNTED = true,
    ERR_TAXIPLAYERALREADYMOUNTED = true,
    SPELL_FAILED_NOT_MOUNTED = true
  };
  if mounted[msg] ~= nil then
    Dismount();
  elseif msg == SPELL_FAILED_NOT_STANDING then
    DoEmote("STAND");
  end
  return false;
end
