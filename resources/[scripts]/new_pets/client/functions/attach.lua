---@param entity number
---@return void
---@diagnostic disable-next-line: lowercase-global
attachPetToPlayer = function(entity)
    local playerPed    = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local entityCoords = GetEntityCoords(entity)
    local distance     = #(playerCoords - entityCoords)

    if (distance > 2.0) then
        return false, 'Pet is too far away.'
    end

    local attached = IsEntityAttachedToAnyPed(entity)

    if OnesyncEnableRemoteAttachmentSanitization then
        OnesyncEnableRemoteAttachmentSanitization(false)
    end

    NetworkRequestControlOfEntity(entity)

    repeat
        Wait(0)
    until NetworkHasControlOfEntity(entity)

    NetworkAllowRemoteAttachmentModification(playerPed, true)
    NetworkAllowRemoteAttachmentModification(entity, true)
    
    SetEntityAsMissionEntity(entity, not attached, not attached)

    if (attached) then
        DetachEntity(entity, true, true)
        FreezeEntityPosition(entity, false)

        if OnesyncEnableRemoteAttachmentSanitization then
            OnesyncEnableRemoteAttachmentSanitization(true)
        end

        return false, 'Pet is already attached.'
    end

    FreezeEntityPosition(entity, true)
    AttachEntityToEntity(entity, playerPed, GetPedBoneIndex(playerPed, 0), 0.5, 0.0, -0.5, 0.0, 0.0, 0.0, true, true, false, true, 2, true)


    if OnesyncEnableRemoteAttachmentSanitization then
        OnesyncEnableRemoteAttachmentSanitization(true)
    end

    return true, 'Pet attached.'
end