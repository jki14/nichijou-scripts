--release
!Tw1wpnoou4)lZlLrAb1wkx6d7dHs5YSLcQomOrlBsDtojXcx7S2ofOR28BFp2oPP7apoQrPo2FNBF(CjAquyezDej1(GltKCPcxmFG7zO79XU3JSVnrK3VpltdMO59JiursHu9GKjWdMmDE40fwDi5PYxfKxzLq0fDBmnnhIwHsLyysH2ApTHQmUfYkrASckbQXAlsQmMlLLw5DNfrUvyavgnbEoinfL)5Na6lbvkQ(5hKVck3Y7Gug9zIvc9Z6cwP(1cM2WHJK55oT612f2qHjywJJRYWL6c3A8lJILNdkTNic3THDjfTIGUgAoKCrLsWe51ldsvGGYzcWYBKzSnUTVqUELvNPOC2WoIGc1Qa7(WQQSSW3rQICtWI7U6XzyexiFDcxkqqiFvPH5OaoQSsBKRJno4WgWY7v2OGuYPVJEi(vZ20kJChMBak3u4uvSdpQlVs8Aenz1kh2huqg7Tic5HPZM1iVoI8WSGFmDrCyWIRNggp5MG5xp9YoPiymyLkEsajmMGWqQYgyemsUx4JO7fb4n)g0O6sGZVnTHcADHdpSEzdtx)TSkHln5GVw)T6L(FCzcLxVmtkRx(71l)N6L)B3H4U)zVth0FCV)YDAVGTvkixQ79tygm84XN1cAMuLwV8pOB3sF5dahD(5NVdiykKIpdYodoDnOyA9NGzC)wmHuqrvFMA25s)qlfyU0EySetJRpA8op6sfqxJfq8xG9vydjTIQCW0ahsmhC6VHlnkDjNzo4lh(f8ZhX8GRF82lpOhweMdMEF9R7X1SmVnr9G2ZuaIUZA)PadM9BV0QGUtbrA3hTqYOCnIbSfYnjXfS0U8pxE8ELzT5e(csQlVj0F8DsuU5hoOVVegBkGLDFhlxTvxZhooI8caLbyowIzHTMZ1ZrWw7R)2VRJVeqGfADfOnfxAibVgWmFGQbSbaiYXciSxOBJWobrNynLj(fQUDnJ(fPqxxgn1yvGRbCPsMRaTgR1tyEARVRwEbK30z233BfwDaQynBl4Ak38TSBcGbEZe3o1WSdXhMJC15JpBW5ND64(JoB4Wr9hhLD4jJCZw63nBPr6nOtTI7A41SdyhDqi)Dfvb1lVQIJz4pvWWWPHJqN3d1hVfalVa9WtrNMlPUzB2ec34UkUH12QpHt16pSRlG)PnXTvo6XZTSeBV8kgMpFD56Tx9(PpwL(9iYwjM2AzMmf2ZgVyOgQBqH96I1o4Z0nvmezWlzAkgWPUmvBFB8FJmztBs9Gbh3hJeRXEsQ4Pxi1AC2G3jqwIYll8wXpr(kRT9(jzYIPtNhrEBVX2OuzSCVBWewRanwgL9(Y9CYuM2oy52eNxC8ObNCseoxp1MQz5wS7s2)F8VL9IidpAWzhHq3GsnAO9Un6)c

-- trigger
function()
  local foo = { }
  foo['6109'] = 'Azuregos'
  foo['12397'] = 'Lord Kazzak'
  foo['14888'] = 'Lethon'
  foo['14889'] = 'Emeriss'
  foo['14890'] = 'Taerar'
  foo['14887'] = 'Ysondre'
  -- foo['12498'] = 'Dreamstalker'
  local bar = select(6, strsplit("-", UnitGUID('target')))
  if foo[bar] then
    return true
  end
  return false
end
