AddStateBagChangeHandler('pet_owner', nil, function(bagName, key, value, reserved, replicated)
    if value == nil then
        return
    end

    repeat Wait(1) until DoesEntityExist(GetEntityFromStateBagName(bagName))

    local entity = GetEntityFromStateBagName(bagName)
    local ped    = PlayerPedId()

    if Entity(entity).state.pet_temporary then
        petSetters(entity)
        return
    end

    local netId = NetworkGetNetworkIdFromEntity(entity)

    local options = {
        {
            label = _t('open_menu'),
            icon = 'paw',
            onSelect = function(data)
                showPetInfo(data.netId)
            end,
            canInteract = function(entity, distance, coords, id)
                return DoesEntityExist(entity) and not Entity(entity).state.pet_temporary
            end
        }
    }

    if (IS_ADMIN) then
        table.insert(options, {
            label = _t('max_level_up'),
            icon = 'paw',
            onSelect = function(data)
                TriggerServerEvent('pets.server:admin.maxLevelUp', data.netId)
            end,
            canInteract = function(entity, distance, coords, id)
                return DoesEntityExist(entity) and not Entity(entity).state.pet_temporary
            end
        })
    end

    interact.addEntity(
        {
            id = ('pet:%s'):format(netId),
            netId = netId,
            options = options,
            renderDistance = 10.0,
            activeDistance = 2.0,
            cooldown = 1500
        }
    )

    petSetters(entity)
end)
