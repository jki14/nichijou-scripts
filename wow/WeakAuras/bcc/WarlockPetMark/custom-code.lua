local function warlock_pet_mark()
    if not GetRaidTargetIndex('pet') then
        SetRaidTarget('pet', 4)
    end
end

warlock_pet_mark()
C_Timer.After(1.0, warlock_pet_mark)
C_Timer.After(2.0, warlock_pet_mark)
