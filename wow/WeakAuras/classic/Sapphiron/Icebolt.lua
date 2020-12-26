-- release
!WA:2!9vv3UnXru4AzHOScP26wfO8tzuAJJd)4ABk0IudsSbhAQsijRDi0RSND3z3DG1ZSAMzZpTQvQwiuVox0haFxV1pc8aunkQQpa8iWf96EMzDsaegl5DN5mN57CoFNF2slxzqLWkH)XScEUkLYiI13Q7QR8W2Eb8uU4hlxQC5XHuzwkE)UK9uZoxWOGCPIpWSl7VIYzbkkNvBbheIgH2f3loL7Jtryw4j7QlXzzjubNnn51d45mfsLqyasiKGOYfmKIlvcklUwTBHUbQ20V4COBTWc2NW1jSqNJHy(5DG9hktWH8D)P1JIKevPXywqcxSbNYu(l1(HDB7L9XNeyBLfIve)C7RxIZbXyfnyBAOkX9EWwb2g2YB7jvyHYXLYOQQheY7vasF)I37v6VpIIqma4oh52wcdHs5baxX47Iwe9aIQlDazYjazAepLGoflviUa1yb0DrnR34eIZ8B600IVpoSaVRHA(EbYA6fnoNvndxB(7CCCkiad)2b67ZLAuaWj1ol(A1rGt9lOF15DvkT47SaB6xOEr(048VEQ4DQQnianFZGXXXpcY0YeNHqzzCmri)TQIjl)px1(zepYoeMsiZiPPRe6167UvRwICMvQNcYVHVuM7B32jpkIUNO39V3A37bThgMlWgcC2B2qF(rlXh4JvOv5XdZLKE5q9vFpgEar6m2iyIb6pCYcPZX4UHGa461zJ2RUQR5I(M2xI4qZ9SAyC0(VWSLYcSgQ)OqOEpkQlCI4hAV6glV1QhaPNIqZPQEMNRVSO3AR0Pt77RpN(86pxFb9f1xs)L91xX6YAKEoDv9nmk)VVHkxPvJ6nTkmRJr)VYrFz9xy1EEDnB4eKYzKvct0xtF9ci(Z3ec9xFSfaeAKaiuhu0mC6j2kVDiTWS9Z(eSDD3chFnEi5uVcAYjcgo9rq(ci4npqssJk69DxVB31xZnIZuh0QrJwixEA4iGj9iXMgCh3uoo85Us6ptMXBqEQI64LcKyAL7CGXXTR7)s7RECG8WW0Hk31la6tKZO)ENXeMTqNiOHUnB28oUqglWCYRS5JtoT)qJB0bS0VpzC1JNmUAKW6nMKJRcQD9d4SiASZWD5IWTf4SHBpzH4jWChA0(6ZmsXd2PiG)WRF1zPHzF6X1XWyLvci(8u1iaPqQDw2vR6fKqcE6T1ZC9py4oybf7NsMDDpFRy5vHdkR30vMW31BhCAoPei5u6n1D0DljcsWSyI8cv1DNrxj7ItTRQ2cdZegMsT)KVLeazPQ6nSgwVjyrTNXyNUa6YWYZmzPERJW)stVbV2c6T1pECKa6w6OGecU8RkM3VSrKHf97SKx72puS3ecUvonC8Ypch)TQ7iFeBnX(fh8SZEim9hU56zwoYzCrIzj7xhlvQu5rqRgj0(LHND2XuwexmW2gpt25PXmUGm5QTnnETfcUq2)amJwO1T1F0Y6Z5YGQ)xqWsJ)syXQKtF4rJd6zAwfsIjrjhA0Xea6y3bykdURowNCAnv)e9tHLF2BlPI07M1Bw)BQSZ)84))

-- action on-init
function nextSapphiron()
  local now = GetTime()
  if now - (wa_global.sapphiron.last or 0) > 1.0 then
    wa_global.sapphiron.count = (wa_global.sapphiron.count or 0) + 1
    wa_global.sapphiron.last = now
  end
end

function resetSapphiron()
  wa_global.sapphiron.count = 0
end

wa_global = wa_global or { }
wa_global.sapphiron = wa_global.sapphiron or { }
wa_global.sapphiron.update = nextSapphiron
wa_global.sapphiron.reset = resetSapphiron

-- text
function()
  if wa_global and wa_global.sapphiron and wa_global.sapphiron.count then
    return tostring((5 - (wa_global.sapphiron.count % 5)) % 5)
  end
  return ''
end
