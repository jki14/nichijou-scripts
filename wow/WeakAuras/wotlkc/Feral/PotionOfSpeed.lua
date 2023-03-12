-- Trigger 3 / Custom / Event(s): UNIT_SPELLCAST_SUCCEEDED, PLAYER_REGEN_ENABLED
function(event, ...)
    if event == 'UNIT_SPELLCAST_SUCCEEDED' then
        local potions = {
            [53908] = 'Potion of Speed',
            [53909] = 'Potion of Wild Magic',
            [53753] = 'Potion of Nightmares',
            [67490] = 'Runic Mana Injector',
            [67489] = 'Runic Healing Injector',
        }
        local unit, _, spellId = ...
        if unit == 'player' and potions[spellId] then
            wa_global = wa_global or { }
            if InCombatLockdown() then
                wa_global.pot = true
            else
                wa_global.pot = false
                return true
            end
        end
    else
        if wa_global and wa_global.pot then
            wa_global.pot = false
            return true
        end
    end
    return false
end


-- Trigger 4 / Status / Every Frame
function()
    return wa_global and wa_global.pot
end
