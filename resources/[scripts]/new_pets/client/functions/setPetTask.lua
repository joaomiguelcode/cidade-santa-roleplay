---@param netId number
---@param task string
---@return void
---@diagnostic disable-next-line: lowercase-global
handlePetInteraction = function(netId, task)
    local entity = NetworkGetEntityFromNetworkId(netId)

    if (not DoesEntityExist(entity)) then
        return false, 'Entity does not exist.'
    end

    local minHunger = tasks[task] and tasks[task].data.minHunger
    local minThirst = tasks[task] and tasks[task].data.minThirst
    local minLevel  = tasks[task] and tasks[task].data.minLevel

    if (minLevel and Entity(entity).state.pet_level < minLevel) then
        TriggerEvent('Notify', 'Attention', _t('pet_too_low_level', minLevel .. '%'), 5000)
        return false, 'Pet level is too low.'
    end

    if (minHunger and Entity(entity).state.pet_hunger <= minHunger) then
        TriggerEvent('Notify', 'Attention', _t('pet_too_hungry', minHunger .. '%'), 5000)
        return false, 'Pet is too hungry.'
    end

    if (minThirst and Entity(entity).state.pet_thirst >= minThirst) then
        TriggerEvent('Notify', 'Attention', _t('pet_too_thirsty', minThirst .. '%'), 5000)
        return false, 'Pet is too unhappy.'
    end

    local closeUI = tasks[task] and tasks[task].closeUI

    if (closeUI) then
        toggleInfoUI(false)
    end

    local taskId = tasks[task] and tasks[task].id

    if (not taskId) then
        return false, 'Invalid task.'
    end

    local isOwnerTask = tasks[task] and tasks[task].ownerOnly
    local petOwner = Entity(entity).state.pet_owner

    if (isOwnerTask and petOwner ~= GetPlayerServerId(PlayerId())) then
        return false, 'You do not own this pet.'
    end

    if (task == 'retrieve') then
        TriggerServerEvent('pets.server:retrieve', netId)
        PED_BEING_FOLLOWED = nil
        PED_FOLLOWING = nil
        return true, 'Retrieved pet.'
    end

    if (task == 'cuddle') then
        TriggerServerEvent('pets.server:cuddlePet', netId)
        return true, 'Cuddled pet.'
    end

    if (task == 'carry') then
        attachPetToPlayer(entity)
        return true, 'Carried pet.'
    end

    if (task == 'feed') then
        TriggerServerEvent('pets.server:feedPet', netId)
        return true, 'Fed pet.'
    end

    TriggerServerEvent('pets.server:setTask', netId, taskId)

    return true, 'Task set.'
end