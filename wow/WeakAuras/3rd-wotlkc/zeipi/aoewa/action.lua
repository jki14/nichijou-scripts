aura_env.spells = {
  [GetSpellInfo(47836)] = true, -- Cleave
}
function aura_env.timed(a, aid, duration, exp)
  exp = exp or GetTime() + duration
  a[aid] = {
    show = true,
    changed = true,
    autoHide = true,
    progressType = "timed",
    duration = duration,
    expirationTime = exp,
  }
end

function aura_env.off(a, aid)
  a[aid] = {
    show = false,
    changed = true,
  }
end
