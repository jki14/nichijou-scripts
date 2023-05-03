-- Trigger 3 / Custom / Event(s): UNIT_SPELLCAST_SUCCEEDED, PLAYER_REGEN_ENABLED
function(event, ...)
    if event == 'UNIT_SPELLCAST_SUCCEEDED' then
        local potions = {
            [53908] = 60, -- Potion of Speed
            [53909] = 60, -- Potion of Wild Magic
            [53753] = 60, -- Potion of Nightmares
            [67490] = 60, -- Runic Mana Injector
            [67489] = 60, -- Runic Healing Injector
            [53762] = 120, -- Indestructible Potion
            [6615] = 60, -- Free Action Potion
        }
        local unit, _, spellId = ...
        if unit == 'player' and potions[spellId] then
            wa_global = wa_global or { }
            wa_global.pot = {
                pending = InCombatLockdown(),
                duration = potions[spellId],
                expiration = GetTime() + potions[spellId]
            }
            if not wa_global.pot.pending then
                return true
            end
        end
    else
        if wa_global and wa_global.pot and wa_global.pot.pending then
            wa_global.pot.pending = false
            wa_global.pot.expiration = GetTime() + wa_global.pot.duration
            return true
        end
    end
    return false
end

-- Trigger 3 / Custom / Duration Info
function()
    if wa_global and wa_global.pot and wa_global.pot.duration and wa_global.pot.expiration then
        return wa_global.pot.duration, wa_global.pot.expiration
    end
    return 0, 0
end

-- Trigger 4 / Status / Every Frame
function()
    return wa_global and wa_global.pot and wa_global.pot.pending
end
