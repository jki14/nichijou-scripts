--custom trigger function
function(triggers)
    return triggers[1] or (triggers[2] and not triggers[3]) or (triggers[4] and triggers[3])
end

-- trigger 1 && trigger 2 - run custom code:
EquipItemByName(4984, 17)
