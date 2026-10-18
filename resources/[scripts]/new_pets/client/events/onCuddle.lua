RegisterNetEvent('pets.client:onCuddle', function()
    TriggerEvent('Notify', 'Pets', _t('pet_cuddled'), 5000)
end)

-- Evento para notificar quando o pet sobe de nível
RegisterNetEvent('pets.client:onLevelUp', function(newLevel, oldLevel, petName)
    TriggerEvent('Notify', 'Confirmed', _t('pet_level_up', petName, newLevel), 5000)
end)