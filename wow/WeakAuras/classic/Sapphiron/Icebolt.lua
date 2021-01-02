-- release
!WA:2!9vv3UnXru4AzHOScPsnsHuGwgLwCCcbxBJcT5IGeBWHMQ8xx7au10Ap7UZApW6zwnZSjXTQvQwOQEDUGhaFxV1pc8aunkQQpa5rGl619mZ6KaimwY7oZzoZ58D(o)S5wTqVcHfc)Zze8uvmLreBTtZ1xBZ6Eb8yU4BZNlF(rHuzsmUFtYbQzUzWWGuPI3ZSl5VIszbkkNvAoheIgH2h3Qtm3hhJWSWZ2vwIts6sfC2KKxoGNYuivxcdSecjiQubdP4sLGY6uQ0IOBJkn5lEt0IZnN9jCDcl05utm7SoW(JKDXH89)(TIIKevUrywqxUyBoLP8xP(MnR7LCPZcSDscXkIFQ91X4uqmwrdEmnu119(Wwb2g2Y76jvyHYXpIYOYUoUWlvXdd5TYmwB)S3hK7VpHQqmWbnob(wIdHI5baNX47Jwg9qIQjThz8jaPAepHGpglviUavzo09qvlx5mc08BY01YVpUmZE3cv99AiRRx2aoRAgo383504uqaM(Td03hKQKzGZQHw(1QNaq9lOF15DvsT87SqBYxOCwE1a(xpv8ov1geGMVzW44makl70HiK)wrX4L)NRQFcXJShHPeYesC8AHE1(6fRv7yzQVvCJ0Oi6bIwp4(BC)hwxKYSs9uq6oCqyQaBiUzUtf90dxH3ZhRqRZ7mivsALc1vTDnp9n9IeXiJ0XEP9GXlKoN6QTfeWvEn2U(6R7XW9isNJmxXEObOTFPzlLfyDu7HHq9Euut4eX3uF9TxDN1peslzHMtr9u)H(AIwBSwJg1FG(k6P1FI(Q6pv)z6VOT(gwiRr6I6z132O8)(gQCJAvkx1QWm6p3CHB6OVM(66soMByJKGyoJSwyx9T0lKzIx8MMq)LN6bWav6cgOmOOz40tTvC7rQHz9t(ySDDZmGVbpKCUxbn5ebdh)iiFbe83DOKehL177UvZMBTHBeNPoSwLk1qU84WHaj6r6yAWDCJ54WxCObJXa3f32xHJbkCkVEPXkQZicZw)se0q3QvRU0RSS8zcBFS9ET4aXIHjhfUNlKTcMsVSJN9Kcl5fantsJexj9NjMfdmiQbS53hp56jJNCnuybMjp5QGYx)aolI2X5iykfmrBRe7CjhXtH5o0O(6lmuXd2llW)WfMFgAyYLpToggRSwaXNhRgcflKq7aUNFXrrcOGPHcWlo)RYgvUQrKXR(nwXRE9nfhmgq1sPHJw9r4oFLAj5JyBi6NDWZV4G95IWhlWjdE84fJYILvSFBjxUC5hcOpKAH88f9c6scE2D1tTWhmypSGI9JjZSLNVvSCE4G86DDLD577ThooLKdKCo9U6Fs3kNiOlM1HiVArDRP0xo5AtSzU0CdseMKHQ)4pLfafjf1)G1X6DbpQ)rJZoFMPZdlVW4L62Ny)Rp55kLMt7RdgrzrCrpBh9ujtt7W4cY4StDtpyDHGlKTpeZOzADx9hT6ljyPH4jSoQUNxFfxg0wC0jtgAz6BfsIH0KdmQAsiAQBpmLTQ2Cbnv)u9Z0XW7l92ski9Ut5QLxSWE)Zt()

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
