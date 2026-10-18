local propHuntToggleKey = "K"
local propHuntSpawnOffset = { x = 0.0, y = 0.0, z = -0.95 }
local propHuntRotationStep = 5.0
local propHuntVerticalStep = 0.05

local function ensureEntityControl(entity)
    if not entity or entity == 0 then
        return false
    end

    local attempts = 0
    while not NetworkHasControlOfEntity(entity) and attempts < 50 do
        NetworkRequestControlOfEntity(entity)
        Wait(50)
        attempts = attempts + 1
    end

    return NetworkHasControlOfEntity(entity)
end

local propHuntState = {
    enabled = false,
    active = false,
    pending = false,
    object = nil,
    model = nil,
    sourceObject = nil,
    sourceObjectState = nil,
    originalHeading = nil,
    offset = { x = propHuntSpawnOffset.x, y = propHuntSpawnOffset.y, z = propHuntSpawnOffset.z },
    followThreadActive = false
}

local propHuntRemotes = {}

local function stopPropHuntFollowThread()
    propHuntState.followThreadActive = false
end

local function startPropHuntFollowThread()
    if propHuntState.followThreadActive then
        return
    end

    propHuntState.followThreadActive = true

    CreateThread(function()
    while propHuntState.followThreadActive do
            local object = propHuntState.object
            if not object or not DoesEntityExist(object) then
                break
            end

            local ped = PlayerPedId()
            if not DoesEntityExist(ped) then
                break
            end

            local offset = propHuntState.offset
        local targetCoords = GetOffsetFromEntityInWorldCoords(ped, offset.x, offset.y, offset.z)
        SetEntityCoordsNoOffset(object, targetCoords.x, targetCoords.y, targetCoords.z, false, false, false)
            SetEntityHeading(object, GetEntityHeading(ped))

            Wait(0)
        end

        propHuntState.followThreadActive = false
    end)
end

local function stopPropHuntRemote(serverId)
    local remote = propHuntRemotes[serverId]
    if not remote then
        return
    end
    remote.active = false
    propHuntRemotes[serverId] = nil
end

local function startPropHuntRemote(serverId, netId, offset)
    local myServerId = GetPlayerServerId(PlayerId())
    if serverId == myServerId then
        return
    end

    stopPropHuntRemote(serverId)

    local data = {
        active = true,
        netId = netId,
        offset = {
            x = offset and type(offset.x) == "number" and offset.x or propHuntSpawnOffset.x,
            y = offset and type(offset.y) == "number" and offset.y or propHuntSpawnOffset.y,
            z = offset and type(offset.z) == "number" and offset.z or propHuntSpawnOffset.z
        }
    }

    propHuntRemotes[serverId] = data

    CreateThread(function()
        local disguiseObject = NetToObj(netId)
        local timeout = GetGameTimer() + 5000
        while data.active and (not disguiseObject or not DoesEntityExist(disguiseObject)) and GetGameTimer() <= timeout do
            Wait(50)
            disguiseObject = NetToObj(netId)
        end

        if not data.active then
            return
        end

        if not disguiseObject or not DoesEntityExist(disguiseObject) then
            propHuntRemotes[serverId] = nil
            return
        end

        SetEntityCollision(disguiseObject, false, false)
        SetEntityVisible(disguiseObject, true, false)

        while data.active do
            local player = GetPlayerFromServerId(serverId)
            if not player or player == -1 then
                break
            end

            local ped = GetPlayerPed(player)
            if not ped or not DoesEntityExist(ped) then
                break
            end

            local coords = GetOffsetFromEntityInWorldCoords(ped, data.offset.x, data.offset.y, data.offset.z)
            SetEntityCoordsNoOffset(disguiseObject, coords.x, coords.y, coords.z, false, false, false)
            SetEntityHeading(disguiseObject, GetEntityHeading(ped))
            Wait(0)
        end

        if propHuntRemotes[serverId] == data then
            propHuntRemotes[serverId] = nil
        end
    end)
end

local function hasPropHuntPermission()
    local playerGroups = vRP.GetPlayerGroups()
    if not playerGroups or type(playerGroups) ~= "table" then
        return false
    end
    return playerGroups["Admin"] == 1 or playerGroups["gestaoinfluencer"] == 1 or playerGroups["Developers"] == 1
end

local function restoreSourceProp()
    if propHuntState.sourceObject and DoesEntityExist(propHuntState.sourceObject) then
        SetEntityVisible(propHuntState.sourceObject, true, false)
        SetEntityAlpha(propHuntState.sourceObject, 255, false)
        SetEntityCollision(propHuntState.sourceObject, true, true)
    end

    propHuntState.sourceObject = nil
    propHuntState.sourceObjectState = nil
end

local function hideSourceProp(entity)
    if not entity or not DoesEntityExist(entity) then
        return
    end

    propHuntState.sourceObject = entity
    propHuntState.sourceObjectState = {
        visible = IsEntityVisible(entity),
        alpha = GetEntityAlpha(entity)
    }

    SetEntityVisible(entity, false, false)
    SetEntityAlpha(entity, 0, false)
    SetEntityCollision(entity, false, false)
end

local function applyPropHuntPedState(active)
    local ped = PlayerPedId()
    if active then
        SetEntityVisible(ped, false, false)
        SetEntityAlpha(ped, 0, false)
        SetEntityInvincible(ped, true)
        SetPedCanRagdoll(ped, false)
    else
        SetEntityVisible(ped, true, false)
        SetEntityAlpha(ped, 255, false)
        SetEntityInvincible(ped, false)
        SetPedCanRagdoll(ped, true)
    end
end

local function resetPropHunt(noServerCallback)
    if propHuntState.pending then
        propHuntState.pending = false
    end

    if not noServerCallback then
        TriggerServerEvent("net.admin.propHunt.deactivate")
    end

    if propHuntState.object and DoesEntityExist(propHuntState.object) then
        stopPropHuntFollowThread()
        DetachEntity(propHuntState.object, true, true)
        DeleteEntity(propHuntState.object)
    end

    restoreSourceProp()
    applyPropHuntPedState(false)

    propHuntState.active = false
    propHuntState.object = nil
    propHuntState.model = nil
    propHuntState.offset = { x = propHuntSpawnOffset.x, y = propHuntSpawnOffset.y, z = propHuntSpawnOffset.z }
    if propHuntState.originalHeading then
        SetEntityHeading(PlayerPedId(), propHuntState.originalHeading)
        propHuntState.originalHeading = nil
    end
end

local function getClosestProp(radius)
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local handle, object = FindFirstObject()
    if handle == -1 then
        return nil
    end

    local closestObject = nil
    local closestDistance = radius or 2.0
    local success = true

    repeat
        if DoesEntityExist(object) then
            local modelHash = GetEntityModel(object)
            if IsEntityAnObject(object) and IsModelValid(modelHash) then
                local objCoords = GetEntityCoords(object)
                local dx = objCoords.x - pedCoords.x
                local dy = objCoords.y - pedCoords.y
                local dz = objCoords.z - pedCoords.z
                local distance = math.sqrt(dx * dx + dy * dy + dz * dz)
                if distance <= closestDistance then
                    closestDistance = distance
                    closestObject = object
                end
            end
        end
        success, object = FindNextObject(handle)
    until not success

    EndFindObject(handle)
    return closestObject
end

local function requestPropHunt(modelHash, sourceObject)
    if propHuntState.pending then
        return
    end

    propHuntState.pending = true
    propHuntState.model = modelHash
    propHuntState.originalHeading = GetEntityHeading(PlayerPedId())
    propHuntState.offset = { x = propHuntSpawnOffset.x, y = propHuntSpawnOffset.y, z = propHuntSpawnOffset.z }
    if sourceObject then
        hideSourceProp(sourceObject)
    else
        propHuntState.sourceObject = nil
        propHuntState.sourceObjectState = nil
    end

    TriggerServerEvent("net.admin.propHunt.activate", modelHash, propHuntSpawnOffset)
end

local function togglePropHunt()
    if not hasPropHuntPermission() then
        return
    end

    if not propHuntState.enabled then
        
        return

    end

    if propHuntState.active or propHuntState.pending then
        resetPropHunt()
        TriggerEvent("Notify","verde","Transformação desativada.")
        return
    end

    local closestObject = getClosestProp(2.5)
    if not closestObject or not DoesEntityExist(closestObject) then
        TriggerEvent("Notify","vermelho","Nenhum objeto próximo identificado.")
        return
    end

    local modelHash = GetEntityModel(closestObject)

    requestPropHunt(modelHash, closestObject)
end

local function adjustPropHuntHeading(delta)
    if not propHuntState.active or propHuntState.pending then
        return
    end

    local ped = PlayerPedId()
    if not DoesEntityExist(ped) then
        return
    end

    local heading = GetEntityHeading(ped)
    local newHeading = (heading + delta) % 360.0
    SetEntityHeading(ped, newHeading)
    if propHuntState.object and DoesEntityExist(propHuntState.object) then
        SetEntityRotation(propHuntState.object, 0.0, 0.0, newHeading, 2, true)
    end
end

local function adjustPropHuntVertical(delta)
    if not propHuntState.active or propHuntState.pending then
        return
    end

    propHuntState.offset.z = propHuntState.offset.z + delta
end

local function resetPropHuntHeading()
    if not propHuntState.active or propHuntState.pending then
        return
    end

    if propHuntState.originalHeading then
        SetEntityHeading(PlayerPedId(), propHuntState.originalHeading)
        if propHuntState.object and DoesEntityExist(propHuntState.object) then
            SetEntityRotation(propHuntState.object, 0.0, 0.0, propHuntState.originalHeading, 2, true)
        end
    end
end

RegisterCommand("prophunt_toggle", function()
    togglePropHunt()
end, false)

RegisterKeyMapping("prophunt_toggle", "Prop Hunt: Ativar/Desativar transformação", "keyboard", propHuntToggleKey)

RegisterCommand("prophunt", function()
    if not hasPropHuntPermission() then
        return
    end

    propHuntState.enabled = not propHuntState.enabled

    if propHuntState.enabled then
        TriggerEvent("Notify","verde","Modo Prop Hunt habilitado. Use a tecla atribuída para transformar.")
    else
        resetPropHunt()
        TriggerEvent("Notify","verde","Modo Prop Hunt desabilitado.")
    end
end, false)

local function handlePropHuntTransform(args)
    if not hasPropHuntPermission() then
        return
    end

    local target = args[1]
    if not target or target == "" then
        TriggerEvent("Notify","amarelo","Uso: /prophunt_transform <modelo|reset>")
        return
    end

    local mode = string.lower(target)
    if mode == "reset" or mode == "off" then
        if propHuntState.active or propHuntState.pending then
            resetPropHunt()
            TriggerEvent("Notify","verde","Transformação desativada.")
        else
            TriggerEvent("Notify","amarelo","Nenhuma transformação ativa.")
        end
        return
    end

    local modelHash = GetHashKey(target)
    if not IsModelValid(modelHash) or IsModelAPed(modelHash) or IsModelAVehicle(modelHash) then
        TriggerEvent("Notify","vermelho","Modelo inválido para transformação.")
        return
    end

    if propHuntState.active or propHuntState.pending then
        resetPropHunt()
    end

    requestPropHunt(modelHash, nil)
end


RegisterCommand("transform", function(source, args)
    handlePropHuntTransform(args)
end, false)

RegisterNetEvent("net.admin.propHunt.activated", function(netId, offset)
    local wasPending = propHuntState.pending
    propHuntState.pending = false

    if not wasPending then
        if netId then
            TriggerServerEvent("net.admin.propHunt.deactivate")
        end
        restoreSourceProp()
        return
    end

    if not netId then
        restoreSourceProp()
        TriggerEvent("Notify","vermelho","Falha ao completar a transformação.")
        return
    end

    local disguiseObject = NetToObj(netId)
    local timeout = GetGameTimer() + 4000
    while (not disguiseObject or disguiseObject == 0 or not DoesEntityExist(disguiseObject)) and GetGameTimer() <= timeout do
        Wait(25)
        disguiseObject = NetToObj(netId)
    end

    if not disguiseObject or disguiseObject == 0 or not DoesEntityExist(disguiseObject) then
        restoreSourceProp()
        TriggerEvent("Notify","vermelho","Objeto de transformação indisponível.")
        return
    end

    local ped = PlayerPedId()
    propHuntState.offset = {
        x = offset and type(offset.x) == "number" and offset.x or propHuntSpawnOffset.x,
        y = offset and type(offset.y) == "number" and offset.y or propHuntSpawnOffset.y,
        z = offset and type(offset.z) == "number" and offset.z or propHuntSpawnOffset.z
    }

    ensureEntityControl(disguiseObject)

    DetachEntity(disguiseObject, true, true)
    SetEntityCollision(disguiseObject, false, false)
    SetEntityNoCollisionEntity(disguiseObject, ped, false)
    SetEntityNoCollisionEntity(ped, disguiseObject, false)
    SetEntityVisible(disguiseObject, true, false)
    FreezeEntityPosition(disguiseObject, false)
    SetEntityDynamic(disguiseObject, true)

    propHuntState.object = disguiseObject
    propHuntState.active = true
    applyPropHuntPedState(true)
    startPropHuntFollowThread()
    TriggerEvent("Notify","verde","Transformação ativada.")
end)

RegisterNetEvent("net.admin.propHunt.deactivated", function()
    propHuntState.pending = false

    if propHuntState.object and DoesEntityExist(propHuntState.object) then
        stopPropHuntFollowThread()
        DetachEntity(propHuntState.object, true, true)
        DeleteEntity(propHuntState.object)
    end

    restoreSourceProp()
    applyPropHuntPedState(false)

    propHuntState.active = false
    propHuntState.object = nil
    propHuntState.model = nil
end)

RegisterNetEvent("net.admin.propHunt.remoteActivated", function(serverId, netId, offset)
    startPropHuntRemote(serverId, netId, offset)
end)

RegisterNetEvent("net.admin.propHunt.remoteDeactivated", function(serverId)
    stopPropHuntRemote(serverId)
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    resetPropHunt(true)
    for serverId in pairs(propHuntRemotes) do
        stopPropHuntRemote(serverId)
    end
end)

RegisterCommand("prophunt_rotate_left", function()
    if not hasPropHuntPermission() then
        return
    end
    adjustPropHuntHeading(-propHuntRotationStep)
end, false)

RegisterCommand("prophunt_rotate_right", function()
    if not hasPropHuntPermission() then
        return
    end
    adjustPropHuntHeading(propHuntRotationStep)
end, false)

RegisterCommand("prophunt_rotate_reset", function()
    if not hasPropHuntPermission() then
        return
    end
    resetPropHuntHeading()
end, false)

RegisterKeyMapping("prophunt_rotate_left", "Prop Hunt: girar objeto para esquerda", "keyboard", "NUMPAD4")
RegisterKeyMapping("prophunt_rotate_right", "Prop Hunt: girar objeto para direita", "keyboard", "NUMPAD6")
RegisterKeyMapping("prophunt_rotate_reset", "Prop Hunt: resetar rotação do objeto", "keyboard", "NUMPAD5")

RegisterCommand("prophunt_offset_up", function()
    if not hasPropHuntPermission() then
        return
    end
    adjustPropHuntVertical(propHuntVerticalStep)
end, false)

RegisterCommand("prophunt_offset_down", function()
    if not hasPropHuntPermission() then
        return
    end
    adjustPropHuntVertical(-propHuntVerticalStep)
end, false)

RegisterKeyMapping("prophunt_offset_up", "Prop Hunt: elevar objeto", "keyboard", "PAGEUP")
RegisterKeyMapping("prophunt_offset_down", "Prop Hunt: abaixar objeto", "keyboard", "PAGEDOWN")

