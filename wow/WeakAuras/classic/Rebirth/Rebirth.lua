local start, duration, _, _ = GetSpellCooldown(20748)
local cooldown = math.floor(start + duration - GetTime())
if cooldown > 2 then
    local minutes = math.floor(cooldown / 60.0)
    local seconds = cooldown - minutes * 60
    local remain = tostring(minutes) .. '分' .. tostring(seconds) .. '秒'
    local msg = '**复生**冷却中，剩余**' .. remain .. '**'
    local chat = IsInRaid() and 'RAID' or (IsInGroup() and 'PARTY' or 'YELL')
    SendChatMessage(msg, chat)
    SendChatMessage(msg, chat)
    SendChatMessage(msg, chat)
end


--
local tar = select(1, UnitName('target'))
local msg = '起来吧我的**' .. tar .. '**!起来, 再为主人尽忠一次!'
local chat = IsInRaid() and 'RAID' or (IsInGroup() and 'PARTY' or 'YELL')
SendChatMessage(msg, chat)
SendChatMessage(msg, chat)
SendChatMessage(msg, chat)
