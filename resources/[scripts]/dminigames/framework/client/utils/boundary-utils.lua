---@class BoundaryCheckConfig
---@field centerCoords vector3 Coordenadas do centro da área
---@field maxDistance number Distância máxima permitida em metros
---@field spawnCoords? table<number, vector4> Lista de spawn points para teleporte (opcional)
---@field showWarning? boolean Se deve mostrar avisos visuais (padrão: true)
---@field warnInterval? number Intervalo entre avisos em ms (padrão: 3000)
---@field teleportThreshold? number Tempo fora da área antes de teleportar em ms (padrão: 5000)
---@field warningDistance? number Percentual do limite para aviso (padrão: 0.85 = 85%)
---@field onViolation? fun(): nil Callback quando jogador viola o limite
---@field onReturn? fun(): nil Callback quando jogador retorna à área
---@field onTeleport? fun(coords: vector4): nil Callback quando vai teleportar

---@type table<string, function>
local activeBoundaryChecks = {}

local function frameworkText( key, ... )
    return FrameworkTranslations.get( key, ... )
end

---@param id string ID único para este boundary check
---@param config BoundaryCheckConfig Configuração do boundary check
---@return function abortFunction Função para parar a verificação
function StartBoundaryCheck(id, config)
    if activeBoundaryChecks[id] then
        activeBoundaryChecks[id]()
        activeBoundaryChecks[id] = nil
    end

    assert(config.centerCoords, 'centerCoords is required')
    assert(config.maxDistance, 'maxDistance is required')

    local showWarning = config.showWarning ~= false
    local warnInterval = config.warnInterval or 3000
    local teleportThreshold = config.teleportThreshold or config.respawnThreshold or 5000
    local warningDistancePercent = config.warningDistance or 0.85
    local warningDistance = config.maxDistance * warningDistancePercent
    local spawnCoords = config.spawnCoords or {}

    local isActive = true
    local warningCooldown = 0
    local lastViolationTime = 0
    local showedWarningZone = false

    CreateThread(function()
        while isActive do
            Wait(500)

            local playerPed = PlayerPedId()
            if not DoesEntityExist(playerPed) or not isActive then
                goto continue
            end

            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - config.centerCoords)

            if showWarning and distance > warningDistance and distance <= config.maxDistance then
                if not showedWarningZone then
                    showedWarningZone = true
                    TriggerEvent('Notify', 'aviso', frameworkText( 'boundary_title' ), frameworkText( 'boundary_near_limit' ), 2000)
                end
            elseif distance <= warningDistance then
                showedWarningZone = false
            end

            if distance > config.maxDistance then
                local currentTime = GetGameTimer()

                if lastViolationTime == 0 then
                    lastViolationTime = currentTime

                    if showWarning then
                        TriggerEvent('Notify', 'aviso', frameworkText( 'boundary_title' ), frameworkText( 'boundary_outside' ), warnInterval)
                    end

                    if config.onViolation then
                        config.onViolation()
                    end
                end

                if showWarning and currentTime - warningCooldown > warnInterval then
                    warningCooldown = currentTime
                    local timeRemaining = math.ceil((teleportThreshold - (currentTime - lastViolationTime)) / 1000)

                    if timeRemaining > 0 then
                        TriggerEvent('Notify', 'importante', frameworkText( 'boundary_title' ), frameworkText( 'boundary_return_seconds', timeRemaining ), 1000)
                    end
                end

                if currentTime - lastViolationTime >= teleportThreshold then
                    local teleportCoords = nil

                    if #spawnCoords > 0 then
                        local randomIndex = math.random(1, #spawnCoords)
                        teleportCoords = spawnCoords[randomIndex]
                    else
                        teleportCoords = vector4(config.centerCoords.x, config.centerCoords.y, config.centerCoords.z, 0.0)
                    end

                    if showWarning then
                        TriggerEvent('Notify', 'negado', frameworkText( 'boundary_title' ), frameworkText( 'boundary_teleported_back' ), 3000)
                    end

                    if config.onTeleport then
                        config.onTeleport(teleportCoords)
                    end

                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    if vehicle ~= 0 then
                        SetEntityCoords(vehicle, teleportCoords.x, teleportCoords.y, teleportCoords.z, false, false, false, false)
                        SetEntityHeading(vehicle, teleportCoords.w or 0.0)
                    else
                        SetEntityCoords(playerPed, teleportCoords.x, teleportCoords.y, teleportCoords.z, false, false, false, false)
                        SetEntityHeading(playerPed, teleportCoords.w or 0.0)
                    end

                    lastViolationTime = 0
                    warningCooldown = 0
                    showedWarningZone = false
                end
            else
                if lastViolationTime ~= 0 then
                    if showWarning then
                        TriggerEvent('Notify', 'sucesso', frameworkText( 'boundary_title' ), frameworkText( 'boundary_returned' ), 2000)
                    end

                    if config.onReturn then
                        config.onReturn()
                    end

                    lastViolationTime = 0
                    warningCooldown = 0
                end
            end

            ::continue::
        end
    end)

    if config.drawRadius then
        CreateThread(function()
            while isActive do
                Wait(1)

                local markerHeight = (config.centerCoords.z - 1.0) + 200.0
                DrawMarker(1, config.centerCoords.x, config.centerCoords.y, 1.0, 0, 0, 0, 0, 0, 0, config.maxDistance * 2.0, config.maxDistance * 2.0, markerHeight, 255, 0, 0, 100, false, false, 2, false, nil, nil, false)
            end
        end)
    end

    local abortFunction = function()
        isActive = false
        activeBoundaryChecks[id] = nil
    end

    activeBoundaryChecks[id] = abortFunction
    return abortFunction
end

---@param id string ID do boundary check a ser parado
function StopBoundaryCheck(id)
    if activeBoundaryChecks[id] then
        activeBoundaryChecks[id]()
        activeBoundaryChecks[id] = nil
    end
end

function StopAllBoundaryChecks()
    for id, abortFn in pairs(activeBoundaryChecks) do
        abortFn()
    end
    activeBoundaryChecks = {}
end

---@param id string ID do boundary check
---@return boolean isActive
function IsBoundaryCheckActive(id)
    return activeBoundaryChecks[id] ~= nil
end

---@return string[] activeIds
function GetActiveBoundaryChecks()
    local ids = {}
    for id, _ in pairs(activeBoundaryChecks) do
        table.insert(ids, id)
    end
    return ids
end
