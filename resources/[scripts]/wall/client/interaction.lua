--- Raycast da câmera, caixa de destaque em entidades miradas, NUI de administração
--- (Player/Vehicle) e handlers de gerenciamento de jogador/veículo.
---
--- Expõe `WallClient.StartInteraction(gen)` e os globais `RayCastGamePlayCamera`
--- (usado por client/events.lua) e `DrawBoxAroundEntity` (usado pelo export
--- `exports.wall:DrawBoxAroundEntity`, consumido pelo gamemaster).

--- Raycast a partir da câmera do jogo, na direção em que ela está olhando.
---@param distance number? Distância do raycast (padrão 200.0).
---@return boolean hit
---@return vector3 coords
---@return number entity
function RayCastGamePlayCamera(distance)

    distance = distance or 200.0

    local camCoords = GetFinalRenderedCamCoord()
    local camRot = GetFinalRenderedCamRot()

    local radX = (math.pi / 180) * camRot.x
    local radZ = (math.pi / 180) * camRot.z

    local dirX = -math.sin(radZ) * math.abs(math.cos(radX))
    local dirY = math.cos(radZ) * math.abs(math.cos(radX))
    local dirZ = math.sin(radX)

    local destCoords = vec3(
        camCoords.x + dirX * distance,
        camCoords.y + dirY * distance,
        camCoords.z + dirZ * distance
    )

    local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(camCoords, destCoords, -1, PlayerPedId(), 4)
    local _, hit, coords, _, entity = GetShapeTestResult(rayHandle)

    return hit, coords, entity
end

--- Desenha uma caixa (8 cantos, 12 arestas) ao redor da entidade, a partir de
--- meia-largura/meio-comprimento e dos limites inferior/superior em Z.
---@param entity number
---@param halfWidth number
---@param halfLength number
---@param zBottom number
---@param zTop number
---@param r number
---@param g number
---@param b number
---@param a number
---@return nil
local function DrawEntityBox(entity, halfWidth, halfLength, zBottom, zTop, r, g, b, a)

    local bottomFrontLeft = GetOffsetFromEntityInWorldCoords(entity, -halfWidth, halfLength, zBottom)
    local bottomFrontRight = GetOffsetFromEntityInWorldCoords(entity, halfWidth, halfLength, zBottom)
    local bottomRearRight = GetOffsetFromEntityInWorldCoords(entity, halfWidth, -halfLength, zBottom)
    local bottomRearLeft = GetOffsetFromEntityInWorldCoords(entity, -halfWidth, -halfLength, zBottom)

    local topFrontLeft = GetOffsetFromEntityInWorldCoords(entity, -halfWidth, halfLength, zTop)
    local topFrontRight = GetOffsetFromEntityInWorldCoords(entity, halfWidth, halfLength, zTop)
    local topRearRight = GetOffsetFromEntityInWorldCoords(entity, halfWidth, -halfLength, zTop)
    local topRearLeft = GetOffsetFromEntityInWorldCoords(entity, -halfWidth, -halfLength, zTop)

    -- Face inferior
    DrawLine(bottomFrontLeft.x, bottomFrontLeft.y, bottomFrontLeft.z, bottomFrontRight.x, bottomFrontRight.y, bottomFrontRight.z, r, g, b, a)
    DrawLine(bottomFrontRight.x, bottomFrontRight.y, bottomFrontRight.z, bottomRearRight.x, bottomRearRight.y, bottomRearRight.z, r, g, b, a)
    DrawLine(bottomRearRight.x, bottomRearRight.y, bottomRearRight.z, bottomRearLeft.x, bottomRearLeft.y, bottomRearLeft.z, r, g, b, a)
    DrawLine(bottomRearLeft.x, bottomRearLeft.y, bottomRearLeft.z, bottomFrontLeft.x, bottomFrontLeft.y, bottomFrontLeft.z, r, g, b, a)

    -- Face superior
    DrawLine(topFrontLeft.x, topFrontLeft.y, topFrontLeft.z, topFrontRight.x, topFrontRight.y, topFrontRight.z, r, g, b, a)
    DrawLine(topFrontRight.x, topFrontRight.y, topFrontRight.z, topRearRight.x, topRearRight.y, topRearRight.z, r, g, b, a)
    DrawLine(topRearRight.x, topRearRight.y, topRearRight.z, topRearLeft.x, topRearLeft.y, topRearLeft.z, r, g, b, a)
    DrawLine(topRearLeft.x, topRearLeft.y, topRearLeft.z, topFrontLeft.x, topFrontLeft.y, topFrontLeft.z, r, g, b, a)

    -- Arestas verticais
    DrawLine(bottomFrontLeft.x, bottomFrontLeft.y, bottomFrontLeft.z, topFrontLeft.x, topFrontLeft.y, topFrontLeft.z, r, g, b, a)
    DrawLine(bottomFrontRight.x, bottomFrontRight.y, bottomFrontRight.z, topFrontRight.x, topFrontRight.y, topFrontRight.z, r, g, b, a)
    DrawLine(bottomRearRight.x, bottomRearRight.y, bottomRearRight.z, topRearRight.x, topRearRight.y, topRearRight.z, r, g, b, a)
    DrawLine(bottomRearLeft.x, bottomRearLeft.y, bottomRearLeft.z, topRearLeft.x, topRearLeft.y, topRearLeft.z, r, g, b, a)
end

--- Desenha uma linha do meu ped até a entidade mirada e uma caixa ao redor dela
--- (jogador ou veículo). Usado pela thread de raycast e pelo export consumido
--- pelo gamemaster (modo espectador).
---@param entity number
---@param lookingAtCoords vector3? Não utilizado (mantido para compatibilidade de assinatura).
---@param r number?
---@param g number?
---@param b number?
---@param a number?
---@return nil
function DrawBoxAroundEntity(entity, lookingAtCoords, r, g, b, a)

    if not entity or not DoesEntityExist(entity) or not (IsEntityAVehicle(entity) or (IsEntityAPed(entity) and IsPedAPlayer(entity))) then
        return
    end

    r = r or 255
    g = g or 255
    b = b or 255
    a = a or 255

    local myCoords = GetEntityCoords(PlayerPedId())
    local entityCoords = GetEntityCoords(entity)

    DrawLine(myCoords.x, myCoords.y, myCoords.z, entityCoords.x, entityCoords.y, entityCoords.z, r, g, b, a)

    if IsEntityAPed(entity) then
        DrawEntityBox(entity, 0.3, 0.3, -0.9, 0.8, r, g, b, a)
    elseif IsEntityAVehicle(entity) then
        local minVec, maxVec = GetModelDimensions(GetEntityModel(entity))
        local width = maxVec.x - minVec.x
        local length = maxVec.y - minVec.y
        local height = (maxVec.z - minVec.z) / 2

        DrawEntityBox(entity, width / 2, length / 2, -height, height, r, g, b, a)
    end
end

exports('DrawBoxAroundEntity', DrawBoxAroundEntity)

---@type string
local gOpenedType = ''
---@type number
local gOpenedEntity = 0

--- Abre a NUI de administração para o tipo de entidade informado.
---@param entityType string 'Player' | 'Vehicle'
---@param entityId number
---@param menuTitle string?
---@return nil
local function OpenAdminNUI(entityType, entityId, menuTitle)

    gOpenedType = entityType
    gOpenedEntity = entityId

    local configToOpen = WallClient.MenuConfig[entityType]
    configToOpen.title = menuTitle or 'Gerenciador de Entidades'

    SendNUIMessage({ name = 'updateData', payload = configToOpen })
    SendNUIMessage({ name = 'visibility', payload = true })
    SetNuiFocus(true, true)
    SetCursorLocation(0.8, 0.4)
end

--- Fecha a NUI de administração.
---@return nil
local function CloseNUI()

    SetNuiFocus(false, false)
    SendNUIMessage({ name = 'visibility', payload = false })
end

--- Adaptação simples para conseguir usar essas funções do wall
--- a partir de outros scripts.
---@param handlerName 'GetPlayerBans'
---@param passport Passport
AddEventHandler('wall.trigger_manage_player_handler', function(handlerName, passport)

    server._ManagePlayer(passport, handlerName)
end)

RegisterNetEvent('wall:spec', function(source, passport)

    ExecuteCommand(('spec %s'):format(passport))
end)

--- Callback da NUI para seleção de opção do menu (Player/Vehicle).
--- Sempre resolve `cb`, mesmo em caminhos de erro (o front trava esperando
--- a promise se `cb` não for chamado).
RegisterNUICallback('selectOption', function(data, cb)

    if gOpenedType == 'Player' then
        local playerInfo = WallClient.Players[gOpenedEntity]

        if not playerInfo or not playerInfo.identity or not playerInfo.identity.id then
            TriggerEvent('Notify', 'vermelho', 'Jogador não encontrado, reconecte no servidor.', 5000)
            CloseNUI()
            cb(true)
            return
        end

        server._ManagePlayer(playerInfo.identity.id, data)
    elseif gOpenedType == 'Vehicle' then
        local vehNet = NetworkGetNetworkIdFromEntity(gOpenedEntity)

        if not NetworkDoesNetworkIdExist(vehNet) then
            CloseNUI()
            cb(true)
            return
        end

        server._ManageVehicle(vehNet, gOpenedEntity, data)
    end

    CloseNUI()
    cb(true)
end)

--- Callback da NUI para fechamento do menu.
RegisterNUICallback('closeUI', function(data, cb)

    CloseNUI()
    cb(true)
end)

--- Thread de raycast/interação: desenha a caixa na entidade mirada e trata
--- a abertura dos menus de administração (Player via espectador / Vehicle via NUI).
---@param gen number
---@return nil
function WallClient.StartInteraction(gen)

    CreateThread(function()

        while WallClient.IsRunning(gen) do

            local threadDelay = 250
            local hit, entityCoords, entity = RayCastGamePlayCamera(200.0)

            if hit and entity and DoesEntityExist(entity) then

                DrawBoxAroundEntity(entity, entityCoords)

                local isVehicle = IsEntityAVehicle(entity)
                local isPlayerPed = IsEntityAPed(entity) and IsPedAPlayer(entity)

                -- Delay rápido só quando mira veículo ou ped de player (NPC não precisa).
                if isVehicle or isPlayerPed then
                    threadDelay = 1
                end

                if isPlayerPed and IsDisabledControlJustReleased(0, 38) then
                    local playerIndex = NetworkGetPlayerIndexFromPed(entity)

                    if playerIndex and playerIndex ~= -1 then
                        local serverId = GetPlayerServerId(playerIndex)
                        local playerInfo = WallClient.Players[serverId]

                        if playerInfo and not LocalPlayer.state.WallStreet then
                            local customPlayerId = WallClient.GetPassportLabel(playerInfo.identity.id) or tostring(playerInfo.identity.id)

                            ---@type gamemaster.SpectatorData
                            local spectatorData = {
                                [1] = 'small',
                                [2] = playerInfo.identity.id,
                                [3] = serverId,
                                [4] = playerInfo.identity.name,
                                [6] = playerInfo.kdRatio,
                                [7] = playerInfo.discordId,
                                [9] = 0,
                                [10] = nil,
                                [11] = nil,
                                [12] = customPlayerId,
                            }

                            TriggerEvent('gamemaster.spectatingReceivedData', spectatorData)
                        end
                    end
                elseif isVehicle and IsDisabledControlJustReleased(0, 38) then
                    local vehicleModel = GetEntityArchetypeName(entity) or 'N/E'
                    local menuTitle = ('%s | %s'):format(tostring(vehicleModel):upper(), GetVehicleNumberPlateText(entity))

                    OpenAdminNUI('Vehicle', entity, menuTitle)
                end
            end

            Wait(threadDelay)
        end
    end)
end
