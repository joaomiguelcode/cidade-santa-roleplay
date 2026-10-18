local handlers = {
    ---@param entity number
    ---@param taskId number
    ---@param oldTaskId number
    ---@return boolean, string
    ['reset'] = function(entity, taskId, oldTaskId, isOwner)
        ClearPedTasks(entity)

        local task = tasks[oldTaskId]

        if (task and task.action == 'follow') then
            setPedFollowingPed(entity, nil, false)
        end
        return true, 'Reset task'
    end,
    ---@param entity number
    ---@param taskData table
    ---@param oldTaskId number
    ---@return boolean, string
    ['animation'] = function(entity, taskData, oldTaskId, isOwner)
        local modelName = GetEntityArchetypeName(entity)
        local animation = taskData.animation.override and taskData.animation.override[modelName] or taskData.animation.default

        if (not animation) then
            return false, 'No animation found for model: ' .. modelName
        end

        loadAnim(animation.dict)
        TaskPlayAnim(entity, animation.dict, animation.name, 8.0, -8.0, -1, 1, 0, false, false, false)
        RemoveAnimDict(animation.dict)
        return true, 'Animation task'
    end,
    ---@param entity number
    ---@param taskId number
    ---@param oldTaskId number
    ---@return boolean, string
    ['follow'] = function(entity, taskId, oldTaskId, isOwner)
        local netId = NetworkGetNetworkIdFromEntity(entity)
        local task = tasks[taskId]
        local petName = Entity(entity).state.pet_name

        if (not task) then
            return false, 'Invalid taskId: ' .. taskId
        end

        local owner = Entity(entity).state.pet_owner
        local pid   = GetPlayerFromServerId(owner)
        local ped   = GetPlayerPed(pid)

        setPedFollowingPed(entity, ped, true)

        if (not isOwner) then
            return true, 'Follow task'
        end

        if Entity(entity).state.pet_temporary then
            return true, 'Temporary pet follow task'
        end

        local modelName = GetEntityArchetypeName(entity)
        local texture = config.textures['track']

        if (not texture) then
            return false, 'No texture found for model: ' .. modelName
        end

        loadTexture(texture)

        setPetFound(entity)

        setSpriteRunning(texture, ped, entity, taskId, oldTaskId, isOwner)

        return true, 'Follow task'
    end
}

---@param entity number
---@param taskId number
---@param oldTaskId number
---@param isOwner boolean
---@return boolean, string
---@diagnostic disable-next-line: lowercase-global
handleTasks = function(entity, taskId, oldTaskId, isOwner)
    if (not taskId) then
        return handlers['reset'](entity, taskId,  oldTaskId, isOwner)
    end

    local task = tasks[taskId]

    if (not task) then
        return false, 'Invalid taskId: ' .. taskId
    end

    local taskData = task.data

    if (taskData.animation) then
        return handlers['animation'](entity, taskData, oldTaskId, isOwner)
    end

    if (not handlers[taskData.action]) then
        return false, 'No handler found for action: ' .. taskData.action
    end

    return handlers[taskData.action](entity, taskId, oldTaskId, isOwner)
end
