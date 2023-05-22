-- Trigger 3 / Custom / Event: ACTIVE_TALENT_GROUP_CHANGED, GLYPH_ADDED, GLYPH_REMOVED, GLYPH_UPDATED, ENCOUNTER_END
function(event, ...)
    local glyphSpellId = event == 'ACTIVE_TALENT_GROUP_CHANGED' and select(3, GetGlyphSocketInfo(4, select(1, ...))) or select(3, GetGlyphSocketInfo(4))
    return glyphSpellId ~= 54825
end
