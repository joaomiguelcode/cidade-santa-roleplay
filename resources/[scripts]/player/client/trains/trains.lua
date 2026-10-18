-- Passeio de trem ate Los Santos (client faz todo o trabalho).
-- Aperta E na estacao -> chama/embarca no trem. Depois da janela de embarque, um jogo
-- de camera + fade leva todos os embarcados ate a cidade e o trem e removido.

local metroHash = GetHashKey(TrainConfig.model)
local aboard = nil     -- entity em que o player esta viajando (nil = fora)
local departing = false
local gLocalTrainRideId = 0

---@param hash number
---@return boolean
local function loadModel(hash)
    if (not IsModelValid(hash)) then
        return false
    end

    RequestModel(hash)

    local timeout = GetGameTimer() + 10000
    while (not HasModelLoaded(hash)) do
        if (GetGameTimer() > timeout) then
            return false
        end
        Citizen.Wait(50)
    end

    return true
end

---@param entity number
---@return table
local function trainCars(entity)
    local cars = { entity }

    for i = 0, 14 do
        local car = GetTrainCarriage(entity, i)
        if (not car or car == 0) then
            break
        end
        if (car ~= entity) then
            cars[#cars + 1] = car
        end
    end

    return cars
end

---@param entity number
---@return void
local function openDoors(entity)
    SetTrainsForceDoorsOpen(false)

    for _, car in ipairs(trainCars(entity)) do
        local doors = GetTrainDoorCount(car)
        for door = 0, doors - 1 do
            SetTrainDoorOpenRatio(car, door, 1.0)
        end
    end
end

---@param entity number
---@param coords vector3
---@return number
local function distToTrain(entity, coords)
    local best = math.huge

    for _, car in ipairs(trainCars(entity)) do
        local d = #(coords - GetEntityCoords(car))
        if (d < best) then
            best = d
        end
    end

    return best
end

---@param entity number
---@return boolean
local function seatPlayer(entity)
    local ped = PlayerPedId()

    for _, car in ipairs(trainCars(entity)) do
        local seats = GetVehicleMaxNumberOfPassengers(car)
        for seat = 0, seats - 1 do
            if (IsVehicleSeatFree(car, seat)) then
                TaskWarpPedIntoVehicle(ped, car, seat)
                return true
            end
        end
    end

    return false
end

-- Acha o trem do passeio no scope (pra quem embarca sem ter criado).
---@return number
local function findTrain()
    local station = TrainConfig.station.coords

    for _, veh in ipairs(GetGamePool('CVehicle')) do
        if (GetEntityModel(veh) == metroHash and #(GetEntityCoords(veh) - station) < 120.0 and Entity(veh).state['sx_train_ride']) then
            return veh
        end
    end

    return 0
end

-- ----------------------------------------------------------------------------
-- Sequencia de chegada: jogo de camera + fade + teleporte pra cidade.
-- ----------------------------------------------------------------------------

TrainRide = class()

---@class TrainRide
---@field entity number
function TrainRide:__init(entity)
    self.entity = entity
    self.cams = {}
end

---@param name string
---@param x number
---@param y number
---@param z number
---@param fov number
---@return number
function TrainRide:makeCam(name, x, y, z, fov)
    local cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', x, y, z, 0.0, 0.0, 0.0, fov, true, 2)
    self.cams[#self.cams + 1] = cam
    return cam
end

---@return void
function TrainRide:departCam()
    -- Ancora na FRENTE do trem (engine = cabine fechada). O trem fica PARADO durante o
    -- shot; a arrancada acontece so depois (no fade), entao a traseira aberta nunca
    -- entra em quadro. Ambas as cameras ficam na frente/mesmo lado: nao clipa por dentro.
    local coords = GetEntityCoords(self.entity)
    local h = math.rad(GetEntityHeading(self.entity))
    local fwd = vector3(-math.sin(h), math.cos(h), 0.0)
    local right = vector3(math.cos(h), math.sin(h), 0.0)

    -- quase de FRENTE pra cabine: bem pouco lateral (so pra nao ficar chapado) e baixo
    local posA = coords + fwd * 11.0 + right * 1.5 + vector3(0.0, 0.0, 1.8)
    local posB = coords + fwd * 16.0 + right * 3.0 + vector3(0.0, 0.0, 3.2)

    local a = self:makeCam('a', posA.x, posA.y, posA.z, 46.0)
    PointCamAtEntity(a, self.entity, 0.0, 0.0, 1.0, true)
    SetCamActive(a, true)
    RenderScriptCams(true, true, 600, true, true)

    local b = self:makeCam('b', posB.x, posB.y, posB.z, 42.0)
    PointCamAtEntity(b, self.entity, 0.0, 0.0, 1.0, true)
    SetCamActiveWithInterp(b, a, TrainConfig.departCinematic, 1, 1)

    Citizen.Wait(TrainConfig.departCinematic)
end

---@return void
function TrainRide:driveCam()
    local coords = GetEntityCoords(self.entity)
    local h = math.rad(GetEntityHeading(self.entity))
    local fwd = vector3(-math.sin(h), math.cos(h), 0.0)
    local right = vector3(math.cos(h), math.sin(h), 0.0)

    local from = coords + fwd * 22.0 + right * 0.7 + vector3(0.0, 0.0, 3.0)
    local to = coords + fwd * 34.0 + right * 0.9 + vector3(0.0, 0.0, 3.5)
    local lookFrom = coords + fwd * 6.0 + vector3(0.0, 0.0, 1.4)
    local lookTo = coords + fwd * 18.0 + vector3(0.0, 0.0, 1.7)

    local a = self:makeCam('drive_a', from.x, from.y, from.z, 43.0)
    PointCamAtCoord(a, lookFrom.x, lookFrom.y, lookFrom.z)
    SetCamActive(a, true)

    local b = self:makeCam('drive_b', to.x, to.y, to.z, 39.0)
    PointCamAtCoord(b, lookTo.x, lookTo.y, lookTo.z)
    SetCamActiveWithInterp(b, a, TrainConfig.departDriveTime, 1, 1)
end

---@return void
function TrainRide:arriveCam()
    local d = TrainConfig.destination.coords

    local a = self:makeCam('c', d.x - 7.0, d.y + 7.0, d.z + 6.0, 45.0)
    PointCamAtCoord(a, d.x, d.y, d.z)
    SetCamActive(a, true)
    RenderScriptCams(true, false, 0, true, true)

    local b = self:makeCam('d', d.x - 3.0, d.y + 3.5, d.z + 2.0, 40.0)
    PointCamAtCoord(b, d.x, d.y, d.z + 0.5)
    SetCamActiveWithInterp(b, a, TrainConfig.arriveCinematic + 800, 1, 1)
end

---@return void
function TrainRide:removeTrain()
    if (not DoesEntityExist(self.entity)) then
        return
    end

    SetEntityAsMissionEntity(self.entity, true, true)
    DeleteMissionTrain(self.entity)
end

---@return void
function TrainRide:cleanup()
    for _, cam in ipairs(self.cams) do
        DestroyCam(cam, false)
    end
    RenderScriptCams(false, true, 600, true, true)
end

---@return void
function TrainRide:play()
    local ped = PlayerPedId()
    DisplayRadar(false)

    local controls = true

    -- quem controla fecha as portas (visivel na cena da cabine)
    if (controls) then
        for _, car in ipairs(trainCars(self.entity)) do
            local doors = GetTrainDoorCount(car)
            for door = 0, doors - 1 do
                SetTrainDoorOpenRatio(car, door, 0.0)
            end
        end
    end

    -- 1. shot da cabine com o trem PARADO (portas fechando)
    self:departCam()

    -- 2. da a arrancada e deixa o trem andar um pouco antes do fade/teleporte
    self:driveCam()

    if (controls) then
        SetTrainCruiseSpeed(self.entity, TrainConfig.moveSpeed)
    end

    local driveEndsAt = GetGameTimer() + TrainConfig.departDriveTime
    while (GetGameTimer() < driveEndsAt) do
        if (controls and DoesEntityExist(self.entity)) then
            SetTrainCruiseSpeed(self.entity, TrainConfig.moveSpeed)
        end

        Citizen.Wait(250)
    end

    DoScreenFadeOut(TrainConfig.fadeTime)
    Citizen.Wait(TrainConfig.fadeTime + 100)

    -- 3. remove o trem AINDA na sessao principal (pro delete replicar pra todos)
    self:removeTrain()

    -- 4. isola o player numa sessao solo: evita ver os outros empilhados no destino
    NetworkStartSoloTutorialSession()

    ClearPedTasksImmediately(ped)
    FreezeEntityPosition(ped, true)

    -- 5. teleporta pro destino
    local dest = TrainConfig.destination
    RequestCollisionAtCoord(dest.coords.x, dest.coords.y, dest.coords.z)
    SetEntityCoords(ped, dest.coords.x, dest.coords.y, dest.coords.z, false, false, false, false)
    SetEntityHeading(ped, dest.heading)
    Citizen.Wait(400)

    -- 6. camera de chegada + fade in
    self:arriveCam()
    DoScreenFadeIn(TrainConfig.fadeTime)
    Citizen.Wait(TrainConfig.arriveCinematic)

    -- 7. libera controle e sai da sessao solo
    self:cleanup()
    Citizen.Wait(600)
    FreezeEntityPosition(ped, false)
    NetworkEndTutorialSession()
    DisplayRadar(true)
end

-- ----------------------------------------------------------------------------
-- Embarque e loop de espera.
-- ----------------------------------------------------------------------------

---@param entity number
---@return void
local function startRide(entity)
    aboard = entity

    Citizen.CreateThread(function()
        while (aboard == entity and not departing) do
            if (not DoesEntityExist(entity)) then
                aboard = nil
                return
            end

            if (distToTrain(entity, GetEntityCoords(PlayerPedId())) > 25.0) then
                -- se afastou do trem = desistiu da viagem
                aboard = nil
                return
            end

            local depart = Entity(entity).state['sx_train_depart']

            if (depart and GetNetworkTime() >= depart) then
                departing = true
                TrainRide(entity):play()
                aboard = nil
                departing = false
                return
            end

            Citizen.Wait(250)
        end
    end)
end

---@param departInMs number
---@param shouldBoard boolean
---@param preferredIndex number|nil
---@return number
local function spawnLocalTrain(departInMs, shouldBoard, preferredIndex)
    if (not loadModel(metroHash)) then
        return 0
    end

    local st = TrainConfig.station
    local entity = 0
    local usedIndex = nil
    local configIndices = preferredIndex and { preferredIndex } or TrainConfig.configIndices

    for _, index in ipairs(TrainConfig.configIndices) do
        entity = CreateMissionTrain(index, st.coords.x, st.coords.y, st.coords.z, true, true, true)

        if (entity ~= 0 and DoesEntityExist(entity) and GetEntityModel(entity) == metroHash) then
            usedIndex = index
            break
        end

        if (entity ~= 0) then
            DeleteMissionTrain(entity)
            entity = 0
        end
    end

    SetModelAsNoLongerNeeded(metroHash)

    if (entity == 0) then
        return 0
    end

    -- diagnostico: config usada e numero de vagoes (1 = metro simples/ponta aberta, 2 = duplo)
    sx.logger:debug(('[trains] spawn configIndex=%s vagoes=%d'):format(tostring(usedIndex), #trainCars(entity)))

    SetTrainCruiseSpeed(entity, 0.0)
    SetTrainSpeed(entity, 0.0)

    local departAt = GetNetworkTime() + math.max(0, departInMs or 0)
    Entity(entity).state:set('sx_train_ride', true, false)
    Entity(entity).state:set('sx_train_depart', departAt, false)
    TriggerEvent('player:trains:trackBoard', entity)

    openDoors(entity)

    if (shouldBoard) then
        seatPlayer(entity) -- best-effort: senta se houver assento (cosmetico)
        startRide(entity)
    else
        Citizen.CreateThread(function()

            while (DoesEntityExist(entity) and GetNetworkTime() < departAt) do
                Citizen.Wait(250)
            end

            if (not DoesEntityExist(entity)) then
                return
            end

            SetTrainCruiseSpeed(entity, TrainConfig.moveSpeed)
            SetTrainSpeed(entity, TrainConfig.moveSpeed)
            Citizen.Wait(TrainConfig.departDriveTime + TrainConfig.fadeTime + 1000)

            if (DoesEntityExist(entity)) then
                SetEntityAsMissionEntity(entity, true, true)
                DeleteMissionTrain(entity)
            end
        end)
    end

    return entity
end

---@param departInMs number
---@return void
local function spawnAndBoard(departInMs)
    spawnLocalTrain(departInMs, true)
end

---@param departInMs number
---@return void
local function boardExisting(departInMs)
    local entity = findTrain()

    if (entity == 0) then
        entity = spawnLocalTrain(departInMs, true, TrainConfig.configIndices[1])
    else
        TriggerEvent('player:trains:trackBoard', entity)
        seatPlayer(entity) -- best-effort: senta se houver assento (cosmetico)
        startRide(entity)
    end
end

RegisterNetEvent('player:trains:spawnLocal', function(rideId, configIndex, departInMs)

    if (rideId <= gLocalTrainRideId) then
        return
    end

    if (#(GetEntityCoords(PlayerPedId()) - TrainConfig.station.coords) > 300.0) then
        return
    end

    gLocalTrainRideId = rideId
    spawnLocalTrain(departInMs, false, configIndex)
end)

---@return void
local function board()
    if (aboard or departing) then
        return
    end

    local success, mode, departInMs = vSERVER.trainBoard()

    if (not success) then
        return
    end

    if (mode == 'spawn') then
        spawnAndBoard(departInMs)
    else
        boardExisting(departInMs)
    end
end

-- ----------------------------------------------------------------------------
-- Estacao: blip + interacao (sleepless_interact).
-- ----------------------------------------------------------------------------

Citizen.CreateThread(function()
    if (not TrainConfig.enabled) then
        return
    end

    local st = TrainConfig.station
    local stationLabel = _t(st.labelKey)

    local blip = AddBlipForCoord(st.coords.x, st.coords.y, st.coords.z)
    SetBlipSprite(blip, st.blip.sprite)
    SetBlipColour(blip, st.blip.color)
    SetBlipScale(blip, st.blip.scale)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(stationLabel)
    EndTextCommandSetBlipName(blip)

    interact.addCoords({
        id = 'sx_train_station',
        coords = st.coords,
        options = {
            {
                label = stationLabel,
                icon = 'train',
                onSelect = function()
                    board()
                end,
                canInteract = function(entity, distance, coords, id)
                    return not aboard and not departing
                end
            }
        },
        renderDistance = 12.0,
        activeDistance = 3.0,
        cooldown = 1000
    })
end)
