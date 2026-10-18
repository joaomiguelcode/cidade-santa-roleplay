AddStateBagChangeHandler('pet_task', nil, function(bagName, key, value, reserved, replicated)
    local oldTask = GetStateBagValue(bagName, 'pet_task')
    repeat Wait(1) until DoesEntityExist(GetEntityFromStateBagName(bagName))

    local entity = GetEntityFromStateBagName(bagName)

    if (value == nil) then
        local success, err = handleTasks(entity, nil, oldTask, isOwner)

        if (not success) then print(err) end

        return
    end

    local task = tasks[value] and tasks[value].action

    if (not task) then
        return
    end

    local isOwner = Entity(entity).state.pet_owner == GetPlayerServerId(PlayerId())
    local success, err = handleTasks(entity, value, oldTask, isOwner)

    if (not success) then print(err) end
end)