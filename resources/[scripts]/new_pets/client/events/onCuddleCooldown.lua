RegisterNetEvent('pets.client:onCuddleCooldown', function(type)

    if (type == 1) then
        TriggerEvent('Notify', 'Warning', _t('cuddle_cooldown'), 5000)
    elseif (type == 2) then
        TriggerEvent('Notify', 'Pets', _t('cuddle_cooldown_max'), 5000)
    end

end)