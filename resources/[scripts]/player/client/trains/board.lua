-- Painel DUI 3D "proximo trem em" no trem de Sandy Shores.
-- Renderiza web/trains/board.html numa runtime texture e desenha como painel holografico
-- (billboard, sempre de frente pra camera) flutuando acima do trem. O estado
-- (idle/boarding/departing + segundos) vem do statebag do trem quando ele esta em scope.
-- Roda so quando o player esta perto da estacao (leve pra servidor cheio).

local metroHash = GetHashKey(TrainConfig.model)
local cfg = TrainConfig.board

local aspect = cfg.duiHeight / cfg.duiWidth

local TXD_PREFIX = 'sx_trains_board_txd_'
local TEX_PREFIX = 'sx_trains_board_tex_'
local SCAN_DISTANCE = 180.0
local DUI_UNLOAD_DELAY_MS = 10000

local dui = nil
local txdName = nil
local texName = nil
local duiVersion = 0
local lastKey = nil
local lastEntity = 0
local trackedEntity = 0

---@return void
local function resetDui()
    if (dui) then
        DestroyDui(dui)
        dui = nil
    end

    txdName = nil
    texName = nil
    lastKey = nil
end

---@return table
local function getDuiLabels()
    return {
        boarding = _t('trains_dui_boarding'),
        departing = _t('trains_dui_departing')
    }
end

---@return boolean
local function ensureDui()
    if (dui) then
        return IsDuiAvailable(dui)
    end

    duiVersion = duiVersion + 1
    txdName = ('%s%s'):format(TXD_PREFIX, duiVersion)
    texName = ('%s%s'):format(TEX_PREFIX, duiVersion)

    dui = CreateDui(('nui://%s/web/trains/board.html?v=%s'):format(GetCurrentResourceName(), GetGameTimer()), cfg.duiWidth, cfg.duiHeight)
    local runtimeTxd = CreateRuntimeTxd(txdName)
    CreateRuntimeTextureFromDuiHandle(runtimeTxd, texName, GetDuiHandle(dui))
    lastKey = nil

    return IsDuiAvailable(dui)
end

---@return void
local function destroyDui()
    resetDui()
    lastEntity = 0
    trackedEntity = 0
end

---@param entity number
---@return vector3
local function getBoardCoords(entity)
    return GetOffsetFromEntityInWorldCoords(entity, cfg.offset.x, cfg.offset.y, cfg.offset.z)
end

AddEventHandler('player:trains:trackBoard', function(entity)
    trackedEntity = entity or 0
    resetDui()
    lastEntity = 0
end)

---@return number -- entity do trem do passeio perto da estacao (0 = nenhum)
local function findStationTrain()
    if (trackedEntity ~= 0
        and DoesEntityExist(trackedEntity)
        and GetEntityModel(trackedEntity) == metroHash
        and Entity(trackedEntity).state['sx_train_ride']) then
        return trackedEntity
    end

    for _, veh in ipairs(GetGamePool('CVehicle')) do
        if (GetEntityModel(veh) == metroHash
            and Entity(veh).state['sx_train_ride']
            and #(GetEntityCoords(veh) - TrainConfig.station.coords) < 150.0) then
            return veh
        end
    end

    return 0
end

---@param entity number
---@return boolean
local function pushState(entity)
    if (entity == 0 or not DoesEntityExist(entity)) then
        lastEntity = 0
        return false
    end

    if (entity ~= lastEntity) then
        resetDui()
        lastEntity = entity
    end

    local depart = Entity(entity).state['sx_train_depart']
    if (not depart) then
        return false
    end

    local status, seconds = 'departing', nil
    local remaining = (depart - GetNetworkTime()) / 1000
    if (remaining > 0) then
        status = 'boarding'
        seconds = math.floor(remaining + 0.5)
    end

    local key = ('%s:%s:%s'):format(lang, status, tostring(seconds))
    if (dui and IsDuiAvailable(dui) and key ~= lastKey) then
        lastKey = key
        SendDuiMessage(dui, json.encode({
            type = 'trainState',
            status = status,
            seconds = seconds,
            destination = 'LOS SANTOS',
            language = lang,
            labels = getDuiLabels()
        }))
    end

    return true -- so desenha o painel quando ha um trem chamado
end

---@param entity number
---@return void
local function drawBoard(entity)
    local boardCoords = getBoardCoords(entity)

    -- corrige o esticamento: DrawSprite usa largura em fracao da LARGURA da tela e altura
    -- em fracao da ALTURA, entao a altura precisa compensar o aspecto da tela (16:9 etc).
    local sw, sh = GetActiveScreenResolution()
    local height = cfg.size * aspect * (sw / sh)

    SetDrawOrigin(boardCoords.x, boardCoords.y, boardCoords.z, 0)
    DrawSprite(txdName, texName, 0.0, 0.0, cfg.size, height, 0.0, 255, 255, 255, 255)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    if (not TrainConfig.enabled) then
        return
    end

    local nextUpdate = 0
    local active = false
    local entity = 0
    local lastActiveAt = 0

    while true do
        local sleep = 800
        local now = GetGameTimer()
        local visible = false

        if (now >= nextUpdate) then
            local pedCoords = GetEntityCoords(PlayerPedId())
            local nearStation = #(pedCoords - TrainConfig.station.coords) <= SCAN_DISTANCE

            if (nearStation or (entity ~= 0 and DoesEntityExist(entity))) then
                nextUpdate = now + 300
                entity = findStationTrain()
            else
                nextUpdate = now + 1000
                entity = 0
            end

            active = pushState(entity)
        end

        if (entity ~= 0 and DoesEntityExist(entity)) then
            local distance = #(GetEntityCoords(PlayerPedId()) - getBoardCoords(entity))

            if (active and distance <= cfg.renderDistance) then
                visible = true
                lastActiveAt = now

                if (ensureDui()) then
                    active = pushState(entity)

                    if (active) then
                        sleep = 0
                        drawBoard(entity) -- so aparece em cima do trem chamado (boarding/departing)
                    else
                        visible = false
                        sleep = 250
                    end
                else
                    sleep = 50
                end
            else
                sleep = 250 -- perto mas sem trem/fora de alcance: so poll, nao desenha
            end
        else
            active = false
        end

        if (dui and not visible and (now - lastActiveAt) >= DUI_UNLOAD_DELAY_MS) then
            destroyDui()
        end

        Citizen.Wait(sleep)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if (resource == GetCurrentResourceName()) then
        destroyDui()
    end
end)
