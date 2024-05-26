-- Actions / OnInit
local locale = GetLocale()

aura_env.locales = {
    ["enUS"] = {
        yellMsg = "So the Light's vaunted justice has finally arrived",
    },
    ["frFR"] = {
        yellMsg = "Voici donc qu’arrive la fameuse justice de la Lumière",
    },
    ["deDE"] = {
        yellMsg = "Der vielgerühmte Streiter des Lichts ist endlich hier",
    },
    ["esES"] = {
        yellMsg = "¿Así que por fin ha llegado la elogiada justicia de la Luz",
    },
    ["esMX"] = {
        yellMsg = "¿Así que por fin ha llegado la tan anunciada justicia de la Luz",
    },
    ["koKR"] = {
        yellMsg = "그러니까 성스러운 빛이 자랑하던 정의가 마침내 왔다 이건가",
    },
    ["ruRU"] = {
        yellMsg = "Неужели прибыли наконец хваленые силы Света",
    },
    ["zhCN"] = {
        yellMsg = "怎么，自诩正义的圣光终于来了",
    },
    ["zhTW"] = {
        yellMsg = "聖光所謂的正義終於來了嗎?我是否該把霜之哀傷放下，祈求你的寬恕呢，弗丁",
    },
}

aura_env.currentLocale = aura_env.locales[locale] or aura_env.locales["enUS"]

-- Trigger Combination / Custom Function
function(triggers)
    return (triggers[1] or triggers[2]) and triggers[3] and triggers[4]
end

-- Trigger 2 / Custom / Event: CHAT_MSG_MONSTER_YELL
function(event, msg)
    return msg and msg:find(aura_env.currentLocale.yellMsg)
end

-- Trigger 3 / Custom / Event: ACTIVE_TALENT_GROUP_CHANGED, GLYPH_ADDED, GLYPH_REMOVED, GLYPH_UPDATED, ENCOUNTER_END, CHAT_MSG_MONSTER_YELL
function(event, ...)
    local glyphSpellId = event == 'ACTIVE_TALENT_GROUP_CHANGED' and select(3, GetGlyphSocketInfo(2, select(1, ...))) or select(3, GetGlyphSocketInfo(2))
    return glyphSpellId ~= 62135
end
