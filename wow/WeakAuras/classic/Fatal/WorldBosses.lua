--release
!TwvxUnUnq47Ycu4eGMaz5)lqFWjXoB2M1jW0zdw0uztlnsIi0KQKujBCr1jOOf9HTNJ(ypqTyVgDiLKLrsECHnSjNz4WVz43mtq7GfbKnbKi7xC5NUkowdMGPh1Fy)o((ED88861TN)WG4J65hqEQYGzEbeQimvQUwYeMaYPtMTyY8asOuYJKpkipYYGGtAemjkbcwhqyHsHvUrXssaLgV2zoyujWUKMROc6gOsj5KCLGjskwnosbckNjGGziAUK9Gt8jYnRdqquFgCzeSopoEXtiiiVD883p9Mldi6u5JNYLc0iejgNYWCTrUP()LLcHhaBqLly4VzC6tiUWDvIP5g5oBElq5MuuRgMHxVn0WLlDhfxRZx7mKGOH9PaYYthtwSKSy8Cmo1zaNFrufKRn9Af4mLC9KlrqBJdcc8ReLbWvIXHg2d1OuhqU(YXFCY8LOppFYILN(2XZoFYznr2rhvSQk5w8U4CbEAP4GdlExXQYpCziLxSkwklw99fR(LIv)AJsu6p2QFBVrT(jN2wJ3MRGePU1ZSPTFNrdQn6sPkQy1pq3ULE)lmS7WHd3ziysLIxZKDx4KnGIP1VInJ8QTzbfuu1R5MDq6JAPaPp7zJnXub9UJ2HOZuaDJ2q53d77WQK0AQYzMg4qO5G(FlU0O0zCM5G3C0BWT3GV8NFZfNDqldvLaMwhE4E5AwC5DI(bVptkiA0v)rbgKWBF0YHgTGiQztTjXuUgTb1TJbNYIAO1os8Evw1CcuHLi7islkv)EjEUzh12ZQbRPbfwP9bScfzly12OaY9aKng5SHM5uKdzRHOc2g7AH15ystzCLYUIibwOHfIyTS1GQklnG1)iJNaunG18GibREM1PuWIMdIGydLj(k6UyMGPt)65qxxgn1yDGR1wMsMOaTglGdzLPnpxz9Cib310QBnwDaQLA2wmJ3D3EztVvd8jZYqjxQk7nuzrTe0n2V(bthoAq7Hd6pYR7aF)UEJS9P7AXl6f01OvnN(beuR5UwuvsaBtzc5NZPkOy10CoYWVnLHHtvocbFPPLXBkWssXXdJ88g0Eu)Ed86mSF3o(4T2DqaHlPUXiytzLmpRe62UH2oNkBkYUje7wtn2DHCQw7gbLZnmN5gxxXWxk0MREMquSYLzlFwCtwiBLi)2McFrUY(Bh3V15f7tnZu90yAMvTaZ(NX0umzf5y52g(2jgYWhQliA3UJh(0XWcVBLkE0jsTgNRGeiE8ZMjgRWbdixIAOUXzLdoNALwICYPZNmzgMDSE78SnBN(u)BYJ(GdHXSKs0Xe2lhQae6HRY2d7pYIqI60UiDWBqp)(ThGmcpp7ltFKOY02Xyxe6GENUT71d9cplTcrH1EQPiosUKlLzw2covvttWxUQUhpFisD3Ow)3F8NF53)7)9F(RV85FZMq(ouwXQJpEx)Y2vniTJk3RbzvhmTmxeTubzaYpM1ZHHQ7Epyeq(MqNkN5UHSUfKlSnTIPHWDJJIWW5UBb69JXYt9DxlFeuULVhIy07i2tOVtNYY0pMY0goCSmjX52QOCDtCxwlGn1V8SYhcwDgANT73FPIBIKb)JBp4ymoEaZYD9TCUG)p

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

-- message
function()
  return '发现世界Boss: ' .. select(1, UnitName('target'))
end

-- macro
/tar Azuregos
/tar Lord Kazzak
/tar Lethon
/tar Emeriss
/tar Taerar
/tar Ysondre
/cast !Stealth
