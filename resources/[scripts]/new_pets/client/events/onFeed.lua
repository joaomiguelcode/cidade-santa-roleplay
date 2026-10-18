RegisterNetEvent('pets.client:onFeed', function(netId)
    local entity = NetworkGetEntityFromNetworkId(netId)

    repeat Wait(100) until DoesEntityExist(entity)

    local hunger = Entity(entity).state.pet_hunger

    TriggerEvent('Notify', 'Confirmed', _t('pet_fed', hunger), 5000)
end)