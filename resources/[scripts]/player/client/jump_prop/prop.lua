-- local isProp = false
-- local attachedProp = nil
-- local propModel = nil

-- -- Função para achar o objeto mais próximo
-- function GetClosestObject(ped, radius)
--     local playerCoords = GetEntityCoords(ped)
--     local handle, object = FindFirstObject()
--     local success
--     local closestObject = 0
--     local minDistance = radius

--     repeat
--         local objCoords = GetEntityCoords(object)
--         local dist = #(playerCoords - objCoords)
--         if dist < minDistance and DoesEntityExist(object) then
--             minDistance = dist
--             closestObject = object
--         end
--         success, object = FindNextObject(handle)
--     until not success

--     EndFindObject(handle)
--     return closestObject
-- end

-- -- Função para transformar no prop mais próximo
-- function TransformIntoProp()
--     local ped = PlayerPedId()
--     local closestProp = GetClosestObject(ped, 3.0)

--     if closestProp == 0 or not DoesEntityExist(closestProp) then
--         TriggerEvent("chat:addMessage", { args = { "^1Nenhum prop próximo encontrado!" } })
--         return
--     end

--     propModel = GetEntityModel(closestProp)
--     local coords = GetEntityCoords(ped)

--     RequestModel(propModel)
--     while not HasModelLoaded(propModel) do
--         Wait(10)
--     end

--     SetEntityVisible(ped, false, false)

--     attachedProp = CreateObject(propModel, coords.x, coords.y, coords.z - 1.0, true, true, false)
--     AttachEntityToEntity(attachedProp, ped, GetPedBoneIndex(ped, 0), 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
--     SetModelAsNoLongerNeeded(propModel)

--     isProp = true
--     TriggerEvent("chat:addMessage", { args = { "^2Você virou um prop!" } })
-- end

-- -- Função para voltar ao normal
-- function ReturnToNormal()
--     local ped = PlayerPedId()
--     if DoesEntityExist(attachedProp) then
--         DeleteEntity(attachedProp)
--         attachedProp = nil
--     end

--     SetEntityVisible(ped, true, false)
--     isProp = false
--     TriggerEvent("chat:addMessage", { args = { "^2Você voltou ao normal!" } })
-- end

-- -- Loop principal: tecla E
-- CreateThread(function()
--     while true do
--         Wait(0)
--         if IsControlJustPressed(0, 38) then -- E
--             if not isProp then
--                 TransformIntoProp()
--             else
--                 ReturnToNormal()
--             end
--         end
--     end
-- end)



-- local isProp = false
-- local attachedProp = nil
-- local propModel = nil
-- local lastVehicle = nil -- Guarda o veículo do jogador
-- local inVehicleBefore = false

-- -- Função para achar o objeto mais próximo
-- function GetClosestObject(ped, radius)
--     local playerCoords = GetEntityCoords(ped)
--     local handle, object = FindFirstObject()
--     local success
--     local closestObject = 0
--     local minDistance = radius

--     repeat
--         local objCoords = GetEntityCoords(object)
--         local dist = #(playerCoords - objCoords)
--         if dist < minDistance and DoesEntityExist(object) then
--             minDistance = dist
--             closestObject = object
--         end
--         success, object = FindNextObject(handle)
--     until not success

--     EndFindObject(handle)
--     return closestObject
-- end

-- -- Função para transformar no prop mais próximo
-- function TransformIntoProp()
--     local ped = PlayerPedId()

--     -- Checa se está em um veículo
--     if IsPedInAnyVehicle(ped, false) then
--         lastVehicle = GetVehiclePedIsIn(ped, false)
--         inVehicleBefore = true
--         SetEntityVisible(lastVehicle, false, false) -- Torna o carro invisível
--     else
--         inVehicleBefore = false
--     end

--     local closestProp = GetClosestObject(ped, 3.0)

--     if closestProp == 0 or not DoesEntityExist(closestProp) then
--         TriggerEvent("chat:addMessage", { args = { "^1Nenhum prop próximo encontrado!" } })
--         return
--     end

--     propModel = GetEntityModel(closestProp)
--     local coords = GetEntityCoords(ped)

--     RequestModel(propModel)
--     while not HasModelLoaded(propModel) do
--         Wait(10)
--     end

--     SetEntityVisible(ped, false, false)

--     attachedProp = CreateObject(propModel, coords.x, coords.y, coords.z - 1.0, true, true, false)
--     AttachEntityToEntity(attachedProp, ped, GetPedBoneIndex(ped, 0), 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
--     SetModelAsNoLongerNeeded(propModel)

--     isProp = true
--     TriggerEvent("chat:addMessage", { args = { "^2Você virou um prop!" } })
-- end

-- -- Função para voltar ao normal
-- function ReturnToNormal()
--     local ped = PlayerPedId()

--     if DoesEntityExist(attachedProp) then
--         DeleteEntity(attachedProp)
--         attachedProp = nil
--     end

--     SetEntityVisible(ped, true, false)

--     -- Se estava em um veículo antes, restaura visibilidade
--     if inVehicleBefore and DoesEntityExist(lastVehicle) then
--         SetEntityVisible(lastVehicle, true, false)
--         lastVehicle = nil
--         inVehicleBefore = false
--     end

--     isProp = false
--     TriggerEvent("chat:addMessage", { args = { "^2Você voltou ao normal!" } })
-- end

-- -- Loop principal: tecla E
-- CreateThread(function()
--     while true do
--         Wait(0)
--         if IsControlJustPressed(0, 38) then -- E
--             if not isProp then
--                 TransformIntoProp()
--             else
--                 ReturnToNormal()
--             end
--         end
--     end
-- end)

local isProp = false
local attachedProp = nil
local propModel = nil
local lastVehicle = nil
local inVehicleBefore = false

--[[ 
    Configuração dos props:
    - model: nome do modelo do objeto
    - rot: rotação padrão
    - zOffset: ajuste manual de altura (positivo = sobe, negativo = desce)
--]]
local propsConfig = {
    { model = "prop_plant_cane_01b", rot = vector3(0.0, 0.0, 0.0), zOffset = -0.60 },  
    { model = "prop_tree_birch_04",     rot = vector3(0.0, 0.0, 0.0), zOffset = -0.60 }, 
    { model = "prop_plant_int_05a",    rot = vector3(0.0, 0.0, 0.0), zOffset = -0.60 }, 
    { model = "prop_plant_int_01a",       rot = vector3(0.0, 0.0, 0.0), zOffset = -0.60 }  
}

-- Função para transformar em prop
function TransformIntoProp(propIndex)
    local ped = PlayerPedId()

    -- Checa se está em veículo
    if IsPedInAnyVehicle(ped, false) then
        lastVehicle = GetVehiclePedIsIn(ped, false)
        inVehicleBefore = true
        SetEntityVisible(lastVehicle, false, false) -- carro invisível
    else
        inVehicleBefore = false
    end

    -- Remove prop antigo
    if DoesEntityExist(attachedProp) then
        DeleteEntity(attachedProp)
        attachedProp = nil
    end

    -- Configura o prop
    local propConfig = propsConfig[propIndex] or propsConfig[1]
    propModel = GetHashKey(propConfig.model)
    local rotation = propConfig.rot
    local coords = GetEntityCoords(ped)

    -- Carrega modelo
    RequestModel(propModel)
    while not HasModelLoaded(propModel) do
        Wait(10)
    end

    SetEntityVisible(ped, false, false)

    -- Ajusta altura automática + offset manual
    local min, max = GetModelDimensions(propModel)
    local zPos = coords.z - min.z + propConfig.zOffset

    -- Cria prop final
    attachedProp = CreateObject(propModel, coords.x, coords.y, zPos, true, true, false)
    SetEntityRotation(attachedProp, rotation.x, rotation.y, rotation.z, 2, true)

    -- Prop colide com o mundo, mas não com o carro
    SetEntityCollision(attachedProp, true, true)
    if inVehicleBefore and DoesEntityExist(lastVehicle) then
        SetEntityNoCollisionEntity(attachedProp, lastVehicle, true)
    end

    -- Se não estiver em veículo, anexa ao ped
    if not inVehicleBefore then
        AttachEntityToEntity(attachedProp, ped, GetPedBoneIndex(ped, 0),
            0.0, 0.0, propConfig.zOffset,
            rotation.x, rotation.y, rotation.z,
            false, false, false, false, 2, true)
    end

    SetModelAsNoLongerNeeded(propModel)
    isProp = true

    TriggerEvent("chat:addMessage", { args = { "^2Você virou um prop: ^7" .. propConfig.model } })
end

-- Função para voltar ao normal
function ReturnToNormal()
    local ped = PlayerPedId()

    if DoesEntityExist(attachedProp) then
        DeleteEntity(attachedProp)
        attachedProp = nil
    end

    SetEntityVisible(ped, true, false)

    if inVehicleBefore and DoesEntityExist(lastVehicle) then
        SetEntityVisible(lastVehicle, true, false)
        lastVehicle = nil
        inVehicleBefore = false
    end

    isProp = false
    TriggerEvent("chat:addMessage", { args = { "^2Você voltou ao normal!" } })
end

-- Loop principal: mantém o prop alinhado e de pé
CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()

        -- Mantém prop de pé e centralizado mesmo no carro
        if isProp and DoesEntityExist(attachedProp) then
            local coords = GetEntityCoords(ped)
            local min, max = GetModelDimensions(propModel)

            -- Pega o offset do prop atual
            local currentProp
            for _, p in ipairs(propsConfig) do
                if GetHashKey(p.model) == propModel then
                    currentProp = p
                    break
                end
            end

            local offset = currentProp and currentProp.zOffset or 0.0
            local zPos = coords.z - min.z + offset

            SetEntityCoords(attachedProp, coords.x, coords.y, zPos, false, false, false, true)
            SetEntityRotation(attachedProp, 0.0, 0.0, 0.0, 2, true) -- sempre de pé
        end
    end
end)








-- -- Comandos F8
-- RegisterCommand("prop1", function()
--     TransformIntoProp(1)
-- end)

-- RegisterCommand("prop2", function()
--     TransformIntoProp(2)
-- end)

-- RegisterCommand("prop3", function()
--     TransformIntoProp(3)
-- end)

-- RegisterCommand("prop4", function()
--     TransformIntoProp(4)
-- end)

-- -- Comando para voltar ao normal
-- RegisterCommand("propreset", function()
--     if isProp then
--         ReturnToNormal()
--     end
-- end)


RegisterNetEvent("prop:skp")
AddEventHandler("prop:skp",function(index,returnToNormal)
    if index then
        TransformIntoProp(index)
    elseif returnToNormal then
        ReturnToNormal()
    end
end)