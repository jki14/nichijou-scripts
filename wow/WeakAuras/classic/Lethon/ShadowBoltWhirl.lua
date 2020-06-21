-- release
!TEvBZjUnq4FnzsY0EmaH276hsNHWXLlP8sMiNM2VySWwgRRgjgjzYX1P63E3vYgmVM0o3eMGEDF5zFwTlHTcdcjZdjj4hyOSWKZfSqY4NcgC3O(HKyzUubBnQL7t7WrndhDLBCh8)g4MC9IC6Qa2xHjNfd3PqBKZ9ZtleXgUuCXL27Tr2iEQn6f6Kz5YP0CBevKuBEJCMjtkoYYnILfcJnYKXeEHH)PyMcfCfJuBuCXSl6yJENn6IJD7ZSrDUS0yyGAUVUqo)C79WIHKvJtt1md4WnBgsOI4mP6bjxaEuV(Jc6)yDV8PfjudaAfLFtlGnOgE8Z8etwiPlmhw1HdAeM1gQYadaPXfCCejroXlWWBQe9gWZgja1mW5hvazUmgbqH8fB012OBzMa(CwDy2T1bHICQgqcPYg18sB0VcisJM7IRhd)U(eyBLe)bBuRtijV6V2BH(arUMvlK4Jl3VX9vmiyST)Fc7R1AjuJPD9w8o0s)BB0)u7iRjFxFig5XVqdNX5UwnZ8aNZtp8o(6WjYbsbsGoZXhGzalE2mMs7t6cwVGB4Qfa)ITKHeXcnBcxelNpLAqwtHOCddqeaoSUyQBbsrAk)RHKjFS7WU3c50jfkkIRHKwDwlTEo5yJgiNHIcyLemRg0lrqNZ0E6kQt9cwE(DjOklhwBt3nVzJYFqXCkN8q)bd8hXTUZt2iHqs7oFOnKQLWMcMBGZp)C)bp8PNg4eTydkGOe8q02iZUo)wi1UkzpKz4Des)pUN796a1HDZdzWxDQq5RAG7h6A2O1HnP3C06i0LDJyBrfqjgNlfmqItF7rRo)xC(DnS3GpFc2wn)FhJ)ySGd5a)0jDGDfuVUKGjKGUpgSN1dXgnDgBICbdwhkTIz)jxC(z6ZV8O(r5LcjpZnzq1r1CTnknNUybuW7hTrRKf2iO8xHb3eEhmP03LfQy2iGqG(7oUFfoMHO4WknGhQsDh4nLABhuMbxFkP3N7gmzi52j9hooO)HGsSDHV4EyFjwQuSYxzCjlWFSHYegME7QnAykbn)3HxdreCu7FbVbFUhqRviTmEiKyVlmQMbXkMygu8fY7whcM4pLMflfqwG7GbBUiOX5uU47O4w)W(3jbIIuIrdORK22OBK5(82hzZkBTa2lxsD9Ybe)yx7Df5gEf4hd1E17TQM)n2UlwQlcU1OFgE(tNrtKV8hvngbjQkNA9wOX1T3lsvYZk6cGPUE0xGMz4PR204KrgVSkI2Q1vnbzZb)OSEi4(5PLTADZ4GGXdbdrbuyaYOgkwtSSFSpHR61oP3J97pkK81Awxbk0Bgmv9TFR1WPlFFLh8N1odc08Q2Y8vBJZyX)v9SDi3NSKQ40P5yWjt(copVGv2(BCgvmJTra(9c20f3HBy4IlXlVqHpeywvD6yK9BQvIBFZ5DTRBpJFS8m73VasToHHVDju4j6tDyZ)pp13YZR6QMQytVA)AJM1(1gn38RnG3fzj(gR9nNdXWu(mp3h68gigJxywNoGIgYxA069n(ayXGq60gLt4)(d

-- action on-init
function nextLethon()
  local now = GetTime()
  if now - (wa_global.lethon.last or 0) > 4.0 then
    wa_global.lethon.count = (wa_global.lethon.count or 0) + 1
    wa_global.lethon.last = now
  else
  end
end

function resetLethon()
  wa_global.lethon.count = 1
end

wa_global = wa_global or { }
wa_global.lethon = wa_global.lethon or { }
wa_global.lethon.reset = resetLethon
wa_global.lethon.update = nextLethon

-- text
function()
  if wa_global and wa_global.lethon and wa_global.lethon.count then
    return tostring(4 - (wa_global.lethon.count % 4))
  end
  return ''
end

--[====[
-- trigger 1
function(e, timestamp, event, hideCaster, sourceGUID, sourceName,
         sourceFlags, sourceRaidFlags, destGUID, destName, destFlags,
         destRaidFlags, spellId, spellName, ...)
    if string.find(event, 'SPELL') then
      local registered = { }
      registered[24820] = -3
      registered[24821] = -2
      registered[24823] = -1
      registered[24822] = 4
      registered[24835] = 3
      registered[24836] = 2
      registered[24837] = 1
      registered[24838] = -4
      registered[5416] = 7
      local src = select(6, strsplit("-", sourceGUID))
      -- if src == '14888' and spellId and registered[spellId] then
      if src == '3127' and spellId and registered[spellId] then
        wa_global = wa_global or { }
        wa_global.lethon = registered[spellId]
      end
    end

    if wa_global and wa_global.lethon then
      return true
    end
    return false
end


-- trigger 2
function()
  if wa_global and wa_global.lethon and wa_global.lethon > 0 then
    return true
  end
  return false
end


-- text
function()
  if wa_global and wa_global.lethon then
    return math.abs(wa_global.lethon)
  end
  return ''
end
--]====]
