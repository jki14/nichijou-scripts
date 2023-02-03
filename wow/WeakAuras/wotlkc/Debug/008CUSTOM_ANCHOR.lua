--custom anchor
function()
    local offset = math.floor(GetTime() / 5) % 3 + 1
    local frameName = string.format('GladdyButton%d', offset)
    return frameName
end
