if not Config.Enabled then return end

local Tunnel = module("vrp", "lib/Tunnel")

local function dbg(message)
    if Config.Debug then sx.logger:info(message) end
end

local function fail(message)
    sx.logger:error(message)
end

local Client = {}
Tunnel.bindInterface("cargame", Client)

local Server = Tunnel.getInterface("cargame")

gameStarted = false
announceActive = false
announceEndTime = 0
lobbyPlayers = 0
inCargameLobby = false
betweenRounds = false

local lobbyStarting = false
local keepFrozenUntilStart = false
local gRoundHudOpen = false
local acceptInProgress = false
local finalStandingsActive = false
local finalStandingsToken = 0
local localGhost = false
local gTargetDropAt = 0
local gColorDropToken = 0
local gEventNametagByServerId = {}
local GHOST_ALPHA = math.max(0, math.min(255, math.floor(tonumber(Config.GhostAlpha) or 150)))
local visibilityApplied = false
local nextVisibilityCheckAt = 0
local currentVehicle = 0
local currentGridRevision = 0
local currentGridLayout = ""
local currentGridRows = 0
local currentGridColumns = 0
local gridApplying = false
local eventBlocksApplied = false
local firstPersonTickAbort = nil
local lastInviteCheckAt = 0

local gridPool = {}
local poolByColor = {}
local activeByColor = {}
local loadedModels = {}
local entryTransitionActive = false

local function beginEntryTransition()
    entryTransitionActive = true
    if not IsScreenFadedOut() and not IsScreenFadingOut() then
        DoScreenFadeOut(Config.EntryFadeMs or 300)
    end
end

local function finishEntryTransition()
    entryTransitionActive = false
    if IsScreenFadedOut() or IsScreenFadingOut() then
        DoScreenFadeIn(Config.EntryFadeMs or 300)
    end
end

local function setEventHudHidden(hidden)
    if GetResourceState("hud") ~= "started" then return end
    exports.hud:hideAllButLogoAndNotifications(hidden == true)
end

---Trava/libera a hora do relogio local em `Config.NightLockHour` pra ficar escuro
---durante o evento e a HUD ficar legivel. Mesmo export usado por `dminigames`/`hud`
---(override global, sem pilha): so libera se este client foi quem travou.
---@param locked boolean
local function setEventNightLock(locked)
    local hour = tonumber(Config.NightLockHour)
    if not hour then return end
    if GetResourceState("worldstate") ~= "started" then return end

    dbg(("cargame: client travamento de horario locked=%s hour=%s"):format(tostring(locked), tostring(hour)))
    exports.worldstate:SetWorldClockOverride(locked and hour or nil)
end

local function isSpawninEmotesStarted()
    return GetResourceState("spawnin_emotes") == "started"
end

local function cancelEmote()
    if not isSpawninEmotesStarted() then return end
    pcall(function()
        exports.spawnin_emotes:EmoteCancel()
    end)
end

local function lockWalkstyle(locked)
    if not isSpawninEmotesStarted() then return end
    pcall(function()
        exports.spawnin_emotes:toggleWalkstyle(
            not locked,
            locked and _t("animations_blocked") or nil
        )
    end)
end

local function startFirstPersonBlock()
    if firstPersonTickAbort then return end

    firstPersonTickAbort = sx.script.setTick(function()
        if GetFollowPedCamViewMode() == 4 then
            SetFollowPedCamViewMode(1)
        end
        DisableFirstPersonCamThisFrame()
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.10)
    end)
end

local function stopFirstPersonBlock()
    if not firstPersonTickAbort then return end
    firstPersonTickAbort()
    firstPersonTickAbort = nil
end

local function applyEventBlocks()
    if eventBlocksApplied then return end
    eventBlocksApplied = true

    TriggerEvent("inventory:Close")
    TriggerEvent("toast.dismiss")
    TriggerEvent("net.hud.clear.announcements")
    TriggerEvent("deathstatue:client:clearInvite")
    TriggerEvent("dashboard:closeHelpCenter")
    TriggerEvent("missions:client:lockHud")
    TriggerEvent("resetEnergetic")
    TriggerEvent("setEnergetic", 1, 1.10, false)
    ExecuteCommand("som off")

    setEventHudHidden(true)
    cancelEmote()
    lockWalkstyle(true)
    ResetPedMovementClipset(PlayerPedId(), 0.0)
    LocalPlayer.state:set("canEmote", false, true)
    LocalPlayer.state:set("minigame:active", "cargame", true)
    LocalPlayer.state:set("isLafyMuted", true, true)
    startFirstPersonBlock()
    setEventNightLock(true)
end

local function clearEventBlocks()
    -- So libera o relogio se fomos nos que travamos: `onResourceStop` chama isto mesmo
    -- fora do evento e nao pode zerar o override de quem esta noutro sistema (ex.: PVP).
    local wasApplied = eventBlocksApplied

    if LocalPlayer.state["minigame:active"] == "cargame" then
        LocalPlayer.state:set("minigame:active", nil, true)
    end
    if LocalPlayer.state["isLafyMuted"] then
        LocalPlayer.state:set("isLafyMuted", false, true)
    end

    LocalPlayer.state:set("canEmote", true, true)
    lockWalkstyle(false)
    stopFirstPersonBlock()
    setEventHudHidden(false)
    TriggerEvent("missions:client:unlockHud")
    eventBlocksApplied = false
    if wasApplied then setEventNightLock(false) end
end

local function freezeEventVehicle(frozen)
    frozen = frozen == true
    local ped = PlayerPedId()
    local vehicle = currentVehicle
    if vehicle == 0 or not DoesEntityExist(vehicle) then
        vehicle = GetVehiclePedIsIn(ped, false)
        if vehicle ~= 0 then currentVehicle = vehicle end
    end

    if vehicle ~= 0 and DoesEntityExist(vehicle) then
        NetworkRequestControlOfEntity(vehicle)
        FreezeEntityPosition(vehicle, frozen)
        if frozen then
            SetEntityVelocity(vehicle, 0.0, 0.0, 0.0)
        else
            SetVehicleUndriveable(vehicle, false)
            SetEntityCollision(vehicle, true, true)
            SetEntityHasGravity(vehicle, true)
            ActivatePhysics(vehicle)
        end
    end
    FreezeEntityPosition(ped, frozen)
end

---@param object number
---@assert object ~= 0 and DoesEntityExist(object)
local function hideObject(object)
    assert(object ~= 0 and DoesEntityExist(object), "cargame: bloco invalido ao esconder")

    SetEntityCollision(object, false, false)
    SetEntityVisible(object, false, false)
    SetEntityAlpha(object, 0, false)
    local center = Config.Grid.Center
    SetEntityCoordsNoOffset(
        object,
        center.x,
        center.y,
        center.z - (Config.Grid.HiddenZOffset or 200.0),
        false,
        false,
        false
    )
end

local function cleanupGrid()
    for i = 1, #gridPool do
        local object = gridPool[i]
        if DoesEntityExist(object) then
            DeleteEntity(object)
        end
    end

    for _, modelHash in pairs(loadedModels) do
        SetModelAsNoLongerNeeded(modelHash)
    end

    gridPool = {}
    poolByColor = {}
    activeByColor = {}
    loadedModels = {}
    currentGridRevision = 0
    currentGridLayout = ""
    currentGridRows = 0
    currentGridColumns = 0
    gridApplying = false
end

local function loadGridModels()
    local timeoutAt = GetGameTimer() + ((Config.GridReadyTimeoutSecs or 10) * 1000)

    for colorId = 1, #Config.Colors do
        local modelHash = joaat(Config.Colors[colorId].model)
        loadedModels[colorId] = modelHash
        RequestModel(modelHash)
    end

    while GetGameTimer() < timeoutAt do
        local allLoaded = true
        for colorId = 1, #Config.Colors do
            if not HasModelLoaded(loadedModels[colorId]) then
                allLoaded = false
                break
            end
        end

        if allLoaded then
            dbg(("cargame: client modelos do grid carregados cores=%d"):format(#Config.Colors))
            return true
        end
        Wait(25)
    end

    local missing = {}
    for colorId = 1, #Config.Colors do
        if not HasModelLoaded(loadedModels[colorId]) then
            missing[#missing + 1] = ("%d:%s"):format(colorId, Config.Colors[colorId].model)
        end
    end
    fail(("cargame: client modelos do grid falharam missing=%s"):format(table.concat(missing, ",")))
    return false
end

local function createGridPool()
    if #gridPool > 0 then return true end
    if not loadGridModels() then return false end

    local center = Config.Grid.Center
    local hiddenZ = center.z - (Config.Grid.HiddenZOffset or 200.0)
    local perColor = Config.Grid.PoolPerColor
        or math.ceil((Config.Grid.Rows * Config.Grid.Columns) / #Config.Colors)

    for colorId = 1, #Config.Colors do
        poolByColor[colorId] = {}
        activeByColor[colorId] = {}

        for _ = 1, perColor do
            local object = CreateObjectNoOffset(
                loadedModels[colorId],
                center.x,
                center.y,
                hiddenZ,
                false,
                false,
                false
            )
            if object == 0 or not DoesEntityExist(object) then
                fail(("cargame: client CreateObject falhou color=%d"):format(colorId))
                cleanupGrid()
                return false
            end

            FreezeEntityPosition(object, true)
            hideObject(object)
            poolByColor[colorId][#poolByColor[colorId] + 1] = object
            gridPool[#gridPool + 1] = object
        end
    end

    return #gridPool == (#Config.Colors * perColor)
end

local function getCellCoords(index, rows, columns)
    local row = math.floor((index - 1) / columns)
    local column = (index - 1) % columns
    local localX = (column - ((columns - 1) / 2.0)) * Config.Grid.TileSizeX
    local localY = (row - ((rows - 1) / 2.0)) * Config.Grid.TileSizeY
    local radians = math.rad(Config.Grid.Center.w or 0.0)
    local cosHeading = math.cos(radians)
    local sinHeading = math.sin(radians)

    return vector3(
        Config.Grid.Center.x + (localX * cosHeading) - (localY * sinHeading),
        Config.Grid.Center.y + (localX * sinHeading) + (localY * cosHeading),
        Config.Grid.Center.z
    )
end

local function removedColorLookup(removedColors)
    local lookup = {}
    for i = 1, #(removedColors or {}) do
        local colorId = tonumber(removedColors[i])
        if colorId then lookup[colorId] = true end
    end
    return lookup
end

local function applyGridLayout(layout, revision, removedColors, rows, columns)
    rows = math.max(1, math.floor(tonumber(rows) or Config.Grid.Rows))
    columns = math.max(1, math.floor(tonumber(columns) or Config.Grid.Columns))
    dbg(("cargame: client applyGrid revision=%s rows=%d cols=%d layoutLen=%s"):format(
        tostring(revision),
        rows,
        columns,
        tostring(type(layout) == "string" and #layout or type(layout))
    ))
    if type(layout) ~= "string" or #layout ~= (rows * columns) then
        fail(("cargame: client grid recusado motivo=invalid_layout revision=%s"):format(tostring(revision)))
        Server.gridReady(revision, false, "invalid_layout")
        return
    end

    if not createGridPool() then
        fail(("cargame: client grid recusado motivo=models_unavailable revision=%s"):format(tostring(revision)))
        Server.gridReady(revision, false, "models_unavailable")
        return
    end

    gridApplying = true

    local cellsByColor = {}
    for colorId = 1, #Config.Colors do cellsByColor[colorId] = {} end

    for index = 1, #layout do
        local colorId = string.byte(layout, index)
        if not Config.Colors[colorId] then
            gridApplying = false
            fail(("cargame: client grid recusado motivo=invalid_color color=%s index=%d"):format(
                tostring(colorId),
                index
            ))
            Server.gridReady(revision, false, "invalid_color")
            return
        end
        cellsByColor[colorId][#cellsByColor[colorId] + 1] = index
    end

    local removed = removedColorLookup(removedColors)
    local batchSize = math.max(1, tonumber(Config.Grid.ApplyBatchSize) or 50)
    local applied = 0

    for colorId = 1, #Config.Colors do
        local handles = poolByColor[colorId]
        local cells = cellsByColor[colorId]
        if #cells > #handles then
            gridApplying = false
            fail(("cargame: client grid recusado motivo=pool_exhausted color=%d cells=%d handles=%d"):format(
                colorId,
                #cells,
                #handles
            ))
            Server.gridReady(revision, false, "pool_exhausted")
            return
        end

        activeByColor[colorId] = {}
        for poolIndex = 1, #handles do
            local object = handles[poolIndex]
            local cellIndex = cells[poolIndex]

            if cellIndex and not removed[colorId] then
                local coords = getCellCoords(cellIndex, rows, columns)
                SetEntityCoordsNoOffset(object, coords.x, coords.y, coords.z, false, false, false)
                SetEntityHeading(object, Config.Grid.Center.w or 0.0)
                ResetEntityAlpha(object)
                SetEntityVisible(object, true, false)
                SetEntityCollision(object, true, true)
                FreezeEntityPosition(object, true)
                activeByColor[colorId][#activeByColor[colorId] + 1] = object
            else
                if object == 0 or not DoesEntityExist(object) then
                    fail(("cargame: client bloco do pool sumiu color=%d pool=%d"):format(colorId, poolIndex))
                else
                    hideObject(object)
                end
            end

            applied = applied + 1
            if applied % batchSize == 0 then Wait(0) end
        end
    end

    currentGridLayout = layout
    currentGridRows = rows
    currentGridColumns = columns
    currentGridRevision = tonumber(revision) or 0
    gridApplying = false
    dbg(("cargame: client grid pronto revision=%d applied=%d"):format(currentGridRevision, applied))
    Server.gridReady(currentGridRevision, true)
end

local function collapseColor(colorId)
    colorId = tonumber(colorId)
    local handles = activeByColor[colorId] or {}
    for i = 1, #handles do
        local object = handles[i]
        if object == 0 or not DoesEntityExist(object) then
            fail(("cargame: client bloco sumiu antes do collapse color=%s index=%s"):format(tostring(colorId), tostring(i)))
        else
            hideObject(object)
        end
    end
    activeByColor[colorId] = {}
end

---Cor da celula sob o XY do carro. Inverse de `getCellCoords`.
---@param coords vector3
---@return number | nil
local function GetStandingCellColorId(coords)
    local layout = currentGridLayout
    local rows = currentGridRows
    local columns = currentGridColumns
    if type(layout) ~= "string" or layout == "" or rows < 1 or columns < 1 then return nil end

    local center = Config.Grid.Center
    local dx = coords.x - center.x
    local dy = coords.y - center.y
    local radians = math.rad(center.w or 0.0)
    local cosHeading = math.cos(radians)
    local sinHeading = math.sin(radians)
    local localX = (dx * cosHeading) + (dy * sinHeading)
    local localY = (-dx * sinHeading) + (dy * cosHeading)
    local column = math.floor((localX / Config.Grid.TileSizeX) + ((columns - 1) / 2.0) + 0.5)
    local row = math.floor((localY / Config.Grid.TileSizeY) + ((rows - 1) / 2.0) + 0.5)
    if column < 0 or column >= columns or row < 0 or row >= rows then return nil end

    return string.byte(layout, (row * columns) + column + 1)
end

---Depois do collapse, so pontua quem ficou numa cor que ainda tem bloco no piso.
---@return boolean
local function isLocalVehicleOnStandingTile()
    if not gameStarted then return false end

    local ped = PlayerPedId()
    local vehicle = currentVehicle
    if vehicle == 0 or not DoesEntityExist(vehicle) then
        vehicle = GetVehiclePedIsIn(ped, false)
        if vehicle ~= 0 then currentVehicle = vehicle end
    end
    if vehicle == 0 or not DoesEntityExist(vehicle) then return false end
    if GetPedInVehicleSeat(vehicle, -1) ~= ped then return false end

    local coords = GetEntityCoords(vehicle)
    local centerZ = Config.Grid.Center.z
    if coords.z < (centerZ - 0.5) or coords.z > (centerZ + 8.0) then return false end

    local colorId = GetStandingCellColorId(coords)
    if not colorId then return false end

    local handles = activeByColor[colorId]
    return type(handles) == "table" and #handles > 0
end

-- Veiculos completamente parados podem permanecer em sleep no motor de fisica
-- mesmo depois de a colisao que os sustentava desaparecer. Acordar a entidade e
-- aplicar um impulso vertical curto faz a gravidade ser reavaliada imediatamente,
-- sem alterar a velocidade horizontal de quem esta dirigindo.
local function wakeEventVehicleAfterCollapse()
    assert(
        currentVehicle ~= 0 and DoesEntityExist(currentVehicle),
        "cargame: veiculo do evento sumiu ao acordar a fisica"
    )

    SetEntityHasGravity(currentVehicle, true)
    ActivatePhysics(currentVehicle)
    ApplyForceToEntityCenterOfMass(
        currentVehicle,
        1,
        0.0,
        0.0,
        -0.35,
        0,
        false,
        true,
        true
    )
end

---@param vehicle number
---@return boolean
---@assert vehicle ~= 0 and DoesEntityExist(vehicle)
local function configureVehicle(vehicle)
    assert(vehicle ~= 0 and DoesEntityExist(vehicle), "cargame: veiculo invalido ao configurar")

    currentVehicle = vehicle
    SetEntityVisible(vehicle, true, false)
    SetEntityCollision(vehicle, true, true)
    SetEntityInvincible(vehicle, Config.Vehicle.Invincible ~= false)
    SetVehicleCanBeVisiblyDamaged(vehicle, false)
    SetVehicleTyresCanBurst(vehicle, Config.Vehicle.CanBurstTyres == true)
    SetVehicleEngineOn(vehicle, true, true, false)
    SetVehicleUndriveable(vehicle, false)
    SetVehicleRadioEnabled(vehicle, false)
    SetVehRadioStation(vehicle, "OFF")
    SetVehicleDoorsLocked(vehicle, Config.Vehicle.LockDoors == false and 1 or 4)
    SetPedCanBeDraggedOut(PlayerPedId(), false)
    SetPedStayInVehicleWhenJacked(PlayerPedId(), true)
    SetEntityInvincible(PlayerPedId(), true)
    if localGhost then SetEntityAlpha(vehicle, GHOST_ALPHA, false) end

    return true
end

-- Re-seat por frame fica limitado: cada entrada dispara `CEventNetworkPlayerEnteredVehicle`,
-- e o `hud` cria threads novas a cada uma (velocimetro em `Wait(0)`, vigia que desliga o cinto).
local SEAT_RETRY_MS = 1000
local SEAT_MAX_DISTANCE = 15.0
local gNextSeatAttemptAt = 0

---Devolve o ped ao banco do motorista se ele saiu do carro perto dele, no maximo 1x/s.
---Longe do carro quem resolve e o reset do server (`resetLobbyVehicle` leva ped e carro).
---@param vehicle number
---@assert vehicle ~= 0 and DoesEntityExist(vehicle)
local function KeepLocalPedSeated(vehicle)
    local ped = PlayerPedId()
    if GetPedInVehicleSeat(vehicle, -1) == ped then return end

    local now = GetGameTimer()
    if now < gNextSeatAttemptAt then return end
    gNextSeatAttemptAt = now + SEAT_RETRY_MS

    if #(GetEntityCoords(ped) - GetEntityCoords(vehicle)) > SEAT_MAX_DISTANCE then return end

    TriggerEvent("hud:setSeatbelt", true)
    SetPedIntoVehicle(ped, vehicle, -1)
end

-- Todos continuam vendo quem caiu; ped e veiculo do ghost usam alpha reduzido.
local VISIBILITY_INTERVAL_MS = 500
local touchedPlayers = {}

local function getPedVehicle(ped)
    if ped == 0 or not IsPedInAnyVehicle(ped, false) then return 0 end
    local vehicle = GetVehiclePedIsIn(ped, false)
    return (vehicle ~= 0 and DoesEntityExist(vehicle)) and vehicle or 0
end

---@param entity number
---@param alpha? number Alpha do ghost; nil restaura o alpha original.
---@assert entity ~= 0 and DoesEntityExist(entity)
local function applyEntityAlpha(entity, alpha)
    assert(entity ~= 0 and DoesEntityExist(entity), "cargame: entidade invalida ao aplicar alpha")

    if alpha then
        SetEntityAlpha(entity, alpha, false)
    else
        SetEntityAlpha(entity, 255, false)
        ResetEntityAlpha(entity)
    end
end

local function updateCargameVisibility()
    local localPlayerId = PlayerId()

    for _, player in ipairs(GetActivePlayers()) do
        if player ~= localPlayerId then
            local serverId = GetPlayerServerId(player)
            local playerState = Player(serverId).state

            if playerState["cargame:joined"] then
                local ped = GetPlayerPed(player)
                if ped ~= 0 and DoesEntityExist(ped) then
                    local vehicle = getPedVehicle(ped)
                    local isDown = playerState["cargame:down"] == true
                    touchedPlayers[serverId] = true

                    NetworkConcealPlayer(player, false, false)
                    SetEntityVisible(ped, true, false)
                    SetEntityCollision(ped, true, true)
                    applyEntityAlpha(ped, isDown and GHOST_ALPHA or nil)
                    if vehicle ~= 0 then
                        NetworkConcealEntity(vehicle, false)
                        SetEntityVisible(vehicle, true, false)
                        SetEntityCollision(vehicle, true, true)
                        applyEntityAlpha(vehicle, isDown and GHOST_ALPHA or nil)
                    end
                end
            end
        end
    end

    visibilityApplied = true
end

local function restoreCargameVisibility()
    if not visibilityApplied then
        touchedPlayers = {}
        return
    end
    visibilityApplied = false

    for serverId in pairs(touchedPlayers) do
        local player = GetPlayerFromServerId(serverId)
        if player ~= -1 and player ~= PlayerId() then
            local ped = GetPlayerPed(player)
            if ped ~= 0 and DoesEntityExist(ped) then
                local vehicle = getPedVehicle(ped)

                NetworkConcealPlayer(player, false, false)
                SetEntityVisible(ped, true, false)
                SetEntityCollision(ped, true, true)
                applyEntityAlpha(ped, nil)
                if vehicle ~= 0 then
                    NetworkConcealEntity(vehicle, false)
                    SetEntityVisible(vehicle, true, false)
                    SetEntityCollision(vehicle, true, true)
                    applyEntityAlpha(vehicle, nil)
                end
            end
        end
    end

    touchedPlayers = {}
end

local function showGhostNotification()
    SendCarEvent("carEvent:notify", {
        title = _t("ghost_notification_title"),
        message = _t("ghost_notification_message"),
        highlight = _t("ghost_notification_highlight"),
        durationMs = 0,
    })
end

---@param amount number
---@param bonus? number
---@param kind? string
local function showPointsNotification(amount, bonus, kind)
    local highlight = _t("points_notification_highlight", amount)
    local message
    if kind == "suddenDeath" then
        message = _t("points_notification_sudden_death", amount)
    elseif type(bonus) == "number" and bonus > 0 then
        message = _t("points_notification_message_bonus", amount, bonus)
    else
        message = _t("points_notification_message", amount)
    end

    SendCarEvent("carEvent:points", {
        title = _t("points_notification_title"),
        message = message,
        highlight = highlight,
        durationMs = 4000,
        sound = true,
    })
    PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", true)
end

local function hideGhostNotification()
    SendCarEvent("carEvent:notify:hide", {})
end

---@param enabled boolean
local function setLocalGhost(enabled)
    enabled = enabled == true
    localGhost = enabled

    local ped = PlayerPedId()
    assert(ped ~= 0 and DoesEntityExist(ped), "cargame: ped local invalido ao definir fantasma")
    -- O ghost nativo oculta o jogador dos vivos e remove colisao. Neste evento,
    -- "ghost" controla somente alpha, pontuacao e retorno apos o round seguinte.
    SetLocalPlayerAsGhost(false)
    SetEntityVisible(ped, true, false)
    SetEntityCollision(ped, true, true)
    applyEntityAlpha(ped, enabled and GHOST_ALPHA or nil)
    if currentVehicle ~= 0 and DoesEntityExist(currentVehicle) then
        SetEntityVisible(currentVehicle, true, false)
        SetEntityCollision(currentVehicle, true, true)
        applyEntityAlpha(currentVehicle, enabled and GHOST_ALPHA or nil)
    end

    if inCargameLobby or gameStarted then updateCargameVisibility() end
end

CargameSetTick(function()
    local now = GetGameTimer()
    if now < nextVisibilityCheckAt then return end
    nextVisibilityCheckAt = now + VISIBILITY_INTERVAL_MS

    if inCargameLobby or gameStarted then
        updateCargameVisibility()
    else
        restoreCargameVisibility()
    end
end)

local function clearInviteState()
    local wasActive = announceActive
    announceActive = false
    announceEndTime = 0
    if wasActive then
        TriggerEvent("hud:cargameInviteOpen", false)
    end
end

local function isInviteOpen()
    return announceActive and announceEndTime > GetGameTimer()
end

local function resetEventClient()
    clearInviteState()
    gameStarted = false
    inCargameLobby = false
    betweenRounds = false
    lobbyStarting = false
    keepFrozenUntilStart = false
    gRoundHudOpen = false
    lobbyPlayers = 0
    gColorDropToken = gColorDropToken + 1
    gTargetDropAt = 0
    finalStandingsActive = false
    finalStandingsToken = finalStandingsToken + 1
    setLocalGhost(false)
    hideGhostNotification()
    restoreCargameVisibility()
    currentVehicle = 0
    TriggerEvent("hud:setSeatbelt", false)

    hideCargameTutorial()
    hideCargameLobby()
    HideCargameCarEventCountdown()
    CloseCargameCarEvent()
    clearCargameAnnounceUi()
    clearEventBlocks()
    SetEntityInvincible(PlayerPedId(), false)
    FreezeEntityPosition(PlayerPedId(), false)
    cleanupGrid()
    finishEntryTransition()
    gEventNametagByServerId = {}
end

local function applyParticipationControls()
    if not inCargameLobby and not gameStarted then return end

    local ped = PlayerPedId()
    DisableControlAction(0, 24, true)
    DisableControlAction(0, 25, true)
    DisableControlAction(0, 37, true)
    DisableControlAction(0, 45, true)
    DisableControlAction(0, 75, true)
    DisableControlAction(0, 140, true)
    DisableControlAction(0, 141, true)
    DisableControlAction(0, 142, true)
    DisableControlAction(0, 263, true)
    DisablePlayerFiring(ped, true)

    if IsPedArmed(ped, 7) then
        SetCurrentPedWeapon(ped, joaat("WEAPON_UNARMED"), true)
        RemoveAllPedWeapons(ped, true)
    end

    SetEntityInvincible(ped, true)
    -- Nunca voar pelo para-brisa: o `hud` desliga o cinto (flag 32) toda vez que o ped sai
    -- de um carro, e se ele volta por outro caminho o cinto fica desligado ate a proxima batida.
    SetPedConfigFlag(ped, 32, false)
    if keepFrozenUntilStart and not gameStarted then
        FreezeEntityPosition(ped, true)
        if currentVehicle ~= 0 and DoesEntityExist(currentVehicle) then
            FreezeEntityPosition(currentVehicle, true)
            SetEntityVelocity(currentVehicle, 0.0, 0.0, 0.0)
        end
    end
    if currentVehicle ~= 0 and DoesEntityExist(currentVehicle) then
        configureVehicle(currentVehicle)
        KeepLocalPedSeated(currentVehicle)
    end
end

CargameSetTick(applyParticipationControls)

local function DrawCargameNametag(x, y, z, text, scale)
    SetDrawOrigin(x, y, z, 0)
    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextOutline()
    SetTextProportional(true)
    SetTextColour(255, 255, 255, 230)
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

CargameSetTick(function()
    if not inCargameLobby and not gameStarted then return end

    local nametagCfg = Config.Nametag or {}
    local maxDistance = tonumber(nametagCfg.MaxDistance) or 90.0
    local offsetZ = tonumber(nametagCfg.OffsetZ) or 1.7
    local scale = tonumber(nametagCfg.Scale) or 0.32
    local origin = GetEntityCoords(PlayerPedId())
    local localServerId = GetPlayerServerId(PlayerId())

    for serverId, name in pairs(gEventNametagByServerId) do
        local ped = 0
        if serverId == localServerId then
            ped = PlayerPedId()
        else
            local playerId = GetPlayerFromServerId(serverId)
            if playerId ~= -1 then ped = GetPlayerPed(playerId) end
        end
        if ped ~= 0 and DoesEntityExist(ped) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            local entity = (vehicle ~= 0 and DoesEntityExist(vehicle)) and vehicle or ped
            local coords = GetOffsetFromEntityInWorldCoords(entity, 0.0, 0.0, offsetZ)
            if #(origin - coords) <= maxDistance then
                DrawCargameNametag(coords.x, coords.y, coords.z, name, scale)
            end
        end
    end
end)

-- ENG-3748: nos 15 min do convite X1 o F3 nao abre; espera a protecao do hud e sai depois se ainda valer.
local gHeldInviteGeneration = 0

local function isX1InviteProtected()
    return GetResourceState("hud") == "started" and exports.hud:IsDominasProtected() == true
end

local function holdInviteUntilUnprotected(body, createdBy, lobbySecs)
    gHeldInviteGeneration = gHeldInviteGeneration + 1
    local generation = gHeldInviteGeneration
    local deadline = GetGameTimer() + lobbySecs * 1000

    CreateThread(function()
        while generation == gHeldInviteGeneration and isX1InviteProtected() do
            Wait(500)
        end

        local remainingSecs = math.floor((deadline - GetGameTimer()) / 1000)
        if generation ~= gHeldInviteGeneration or remainingSecs < 1 then return end

        Client.eventInvite(body, createdBy, remainingSecs, remainingSecs)
    end)
end

function Client.clearInvite()
    gHeldInviteGeneration = gHeldInviteGeneration + 1
    clearInviteState()
    clearCargameAnnounceUi()
end

function Client.syncNametags(tags)
    gEventNametagByServerId = {}
    if type(tags) ~= "table" then
        fail(("cargame: client nametags invalidas tipo=%s"):format(type(tags)))
        return
    end

    for i = 1, #tags do
        local row = tags[i]
        local serverId = tonumber(row and row.source)
        local name = row and row.name
        if serverId and type(name) == "string" and name ~= "" then
            gEventNametagByServerId[serverId] = name
        end
    end
end

function Client.eventInvite(body, createdBy, duration, acceptSecs)
    dbg(("cargame: client convite duration=%s acceptSecs=%s minigame=%s"):format(
        tostring(duration),
        tostring(acceptSecs),
        tostring(LocalPlayer.state["minigame:active"])
    ))
    if inCargameLobby or gameStarted then return end
    -- ENG-3750: iniciante nos primeiros 15 min nao ve o convite nem arma o F3.
    if GetResourceState("hud") == "started" and exports.hud:IsNewbieAnnounceBlocked() then return end

    local minigame = LocalPlayer.state["minigame:active"]
    if minigame and minigame ~= "cargame" then return end

    local lobbySecs = math.max(1, tonumber(acceptSecs) or tonumber(duration) or Config.NotifyDuration)

    if isX1InviteProtected() then
        holdInviteUntilUnprotected(body, createdBy, lobbySecs)
        return
    end

    gHeldInviteGeneration = gHeldInviteGeneration + 1
    announceActive = true
    announceEndTime = GetGameTimer() + (lobbySecs * 1000)
    TriggerEvent("hud:cargameInviteOpen", true)
    TriggerEvent("sounds:Private", "recrutamento", 0.09)

    local announceCfg = Config.Announce or {}
    showCargameAnnounce({
        title = announceCfg.Title or _t("eventTitle"),
        sender = announceCfg.Sender or _t("eventPrefix"),
        description = body or _t("event_invite_body"),
        keyPrompt = announceCfg.KeyPrompt or "F3",
        keyLabel = _t("event_invite_key_label"),
        bgColor = announceCfg.BgColor or "#6442BE",
        duration = lobbySecs * 1000,
    })
end

function Client.enterLobby(players, secondsUntilStart, layout, revision, removedColors, rows, columns)
    dbg(("cargame: client enterLobby players=%s startsIn=%s revision=%s"):format(
        tostring(players),
        tostring(secondsUntilStart),
        tostring(revision)
    ))
    if not entryTransitionActive then beginEntryTransition() end
    clearInviteState()
    clearCargameAnnounceUi()
    finalStandingsActive = false
    finalStandingsToken = finalStandingsToken + 1
    lobbyPlayers = tonumber(players) or 0
    inCargameLobby = true
    gameStarted = false
    lobbyStarting = false
    applyEventBlocks()

    showCargameTutorial({
        name = _t("tutorial_leader_name"),
        text = _t("tutorial_text"),
        skipLabel = _t("tutorial_skip_label"),
        exitKey = Config.EventHudExitKey or "G",
        exitLabel = _t("tutorial_exit_label"),
    })
    local startsIn = tonumber(secondsUntilStart) or 0
    if startsIn > 0 then
        showCargameLobby({
            startsIn = startsIn,
            players = lobbyPlayers,
            maxPlayers = Config.MaxPlayersPerLobby,
            exitKey = Config.EventHudExitKey or "G",
            exitLabel = _t("tutorial_exit_label"),
        })
    end

    CreateThread(function()
        applyGridLayout(layout, revision, removedColors, rows, columns)
    end)
end

function Client.beginEntryTransition()
    beginEntryTransition()
end

function Client.applyGrid(layout, revision, removedColors, rows, columns)
    -- Com lag, o collapse da janela anterior pode ainda estar esperando o 00s local; se
    -- disparar depois do rebuild, apaga cores do piso novo e o jogador cai sozinho.
    gColorDropToken = gColorDropToken + 1
    CreateThread(function()
        applyGridLayout(layout, revision, removedColors, rows, columns)
    end)
end

function Client.vehicleReady(networkId)
    dbg(("cargame: client vehicleReady networkId=%s bucket=%s"):format(
        tostring(networkId),
        tostring(LocalPlayer.state.bucket or "nil")
    ))
    local timeoutAt = GetGameTimer() + ((Config.VehicleReadyTimeoutSecs or 15) * 1000)
    local vehicle = NetworkGetEntityFromNetworkId(tonumber(networkId) or 0)
    while vehicle == 0 or not DoesEntityExist(vehicle) do
        if GetGameTimer() >= timeoutAt then
            sx.logger:error(("cargame: timeout aguardando veiculo networkId=%s"):format(tostring(networkId)))
            Server.vehicleReady(false)
            return
        end
        Wait(25)
        vehicle = NetworkGetEntityFromNetworkId(tonumber(networkId) or 0)
    end

    TriggerEvent("hud:setSeatbelt", true)
    configureVehicle(vehicle)
    local ped = PlayerPedId()
    local seatTimeoutAt = GetGameTimer() + 3000
    while GetPedInVehicleSeat(vehicle, -1) ~= ped and GetGameTimer() < seatTimeoutAt do
        SetPedIntoVehicle(ped, vehicle, -1)
        Wait(25)
    end

    if GetPedInVehicleSeat(vehicle, -1) ~= ped then
        sx.logger:error(("cargame: veiculo %s carregou, mas o jogador nao entrou no banco do motorista"):format(tostring(networkId)))
        Server.vehicleReady(false)
        return
    end

    dbg(("cargame: client veiculo confirmado networkId=%s entity=%s"):format(tostring(networkId), tostring(vehicle)))

    if keepFrozenUntilStart then
        freezeEventVehicle(true)
    else
        freezeEventVehicle(false)
        FreezeEntityPosition(ped, false)
    end
    TriggerEvent("hud:setSeatbelt", true)
    if Server.vehicleReady(true) then
        finishEntryTransition()
    end
end

function Client.setVehiclesFrozen(frozen)
    dbg(("cargame: client setVehiclesFrozen frozen=%s"):format(tostring(frozen)))
    frozen = frozen == true
    if frozen and gameStarted then return end
    keepFrozenUntilStart = frozen
    freezeEventVehicle(frozen)
end

function Client.queryStandingTile()
    Server._reportStanding(isLocalVehicleOnStandingTile(), currentGridRevision)
end

function Client.updateLobby(players, secondsUntilStart)
    if gameStarted or lobbyStarting then return end
    lobbyPlayers = tonumber(players) or 0
    updateCargameLobby({
        startsIn = tonumber(secondsUntilStart) or 0,
        players = lobbyPlayers,
        maxPlayers = Config.MaxPlayersPerLobby,
    })
end

function Client.lobbyStarting(seconds)
    dbg(("cargame: client lobbyStarting seconds=%s"):format(tostring(seconds)))
    if gameStarted then return end
    lobbyStarting = true
    keepFrozenUntilStart = true
    freezeEventVehicle(true)
    hideCargameTutorial()
    hideCargameLobby()
    CloseCargameCarEvent()
    RunCargameCarEventCountdown(seconds or Config.StartCountdownSecs, _t("countdown_start_label"))
end

function Client.gameStarted()
    dbg("cargame: client gameStarted")
    gameStarted = true
    keepFrozenUntilStart = false
    gRoundHudOpen = false
    freezeEventVehicle(false)
    inCargameLobby = false
    lobbyStarting = false
    betweenRounds = false
    hideCargameTutorial()
    hideCargameLobby()
    HideCargameCarEventCountdown()
    applyEventBlocks()
end

---@param seconds number Tempo restante para iniciar a morte súbita.
function Client.suddenDeathTutorial(seconds)
    dbg(("cargame: client suddenDeathTutorial seconds=%s ghost=%s"):format(tostring(seconds), tostring(localGhost)))
    setLocalGhost(false)
    hideGhostNotification()
    CloseCargameCarEvent()
    showCargameTutorial({
        name = _t("tutorial_leader_name"),
        text = _t("sudden_death_tutorial_text"),
        skipLabel = _t("tutorial_skip_label"),
        exitKey = Config.EventHudExitKey or "G",
        exitLabel = _t("tutorial_exit_label"),
    })
    RunCargameCarEventCountdown(seconds or Config.TutorialAutoHideSecs, _t("countdown_sudden_death_label"))
end

function Client.interRound(seconds)
    dbg(("cargame: client interRound seconds=%s"):format(tostring(seconds)))
    -- Entre rounds so fica o countdown central. `carEvent:close` zera HUD, ranking, notify e
    -- pontos; a 1a janela do round seguinte manda o ranking inteiro e reabre tudo.
    betweenRounds = true
    gRoundHudOpen = false
    CloseCargameCarEvent()
    RunCargameCarEventCountdown(seconds or Config.InterRoundCountdownSecs, _t("countdown_next_round_label"))
end

---@param colorIds number[]
---@param suddenDeath boolean
---@param round number
---@param totalRounds number
---@param seconds number Tempo ate o piso cair.
---@param ranking? table Presente so na primeira janela do round (abre o HUD).
---@param roundTime? number Segundos restantes do round; so na primeira janela.
function Client.safeColors(colorIds, suddenDeath, round, totalRounds, seconds, ranking, roundTime)
    dbg(("cargame: client safeColors round=%s/%s suddenDeath=%s seconds=%s roundTime=%s colors=%s openHud=%s"):format(
        tostring(round),
        tostring(totalRounds),
        tostring(suddenDeath),
        tostring(seconds),
        tostring(roundTime),
        tostring(type(colorIds) == "table" and #colorIds or 0),
        tostring(type(ranking) == "table")
    ))
    betweenRounds = false
    if type(colorIds) ~= "table" then colorIds = { colorIds } end
    local colors = {}
    for i = 1, #colorIds do
        local colorId = tonumber(colorIds[i])
        local color = colorId and Config.Colors[colorId]
        if color then
            colors[#colors + 1] = {
                name = _t(("color_%s"):format(colorId)),
                hex = color.hex,
            }
        end
    end
    if #colors == 0 then
        fail(("cargame: client safeColors sem cor valida round=%s ids=%s"):format(
            tostring(round),
            tostring(type(colorIds) == "table" and #colorIds or 0)
        ))
        return
    end

    local multiple = #colors > 1
    local duration = math.max(1, math.floor(tonumber(seconds) or 5))
    gColorDropToken = gColorDropToken + 1
    gTargetDropAt = GetGameTimer() + (duration * 1000)
    local payload = {
        mode = suddenDeath and "suddenDeath" or "colors",
        duration = duration,
        remainingTime = duration,
        round = tonumber(round) or 1,
        totalRounds = tonumber(totalRounds) or Config.TotalRounds,
        colors = colors,
        colorLabel = suddenDeath
            and _t(multiple and "unsafe_colors_label" or "unsafe_color_label")
            or _t(multiple and "safe_colors_label" or "safe_color_label"),
        timerLabel = _t(suddenDeath and "sudden_death_fall_in_label" or "colors_fall_in_label"),
        description = suddenDeath
            and _t("sudden_death_description")
            or _t(multiple and "safe_position" or "safe_position_single"),
        exitKey = Config.EventHudExitKey or "G",
        exitLabel = _t("tutorial_exit_label"),
    }

    -- Sem ranking e uma janela seguinte do mesmo round: so atualiza cor e timer.
    if type(ranking) == "table" then
        payload.ranking = ranking.ranking
        payload.currentPlayer = ranking.currentPlayer
        payload.players = ranking.players
        payload.maxPlayers = ranking.maxPlayers
        if roundTime ~= nil then
            payload.roundTime = math.max(0, math.floor(tonumber(roundTime) or 0))
        end
    end

    -- Lobby/tutorial no NUI bloqueiam cor+ranking (`visible && !lobby && !tutorial`).
    hideCargameTutorial()
    hideCargameLobby()
    HideCargameCarEventCountdown()
    if type(ranking) == "table" or not gRoundHudOpen then
        gRoundHudOpen = true
        OpenCargameCarEvent(payload)
        -- O `carEvent:close` da troca de round apagou o aviso de quem continua fantasma.
        if localGhost then showGhostNotification() end
        return
    end

    UpdateCargameCarEvent(payload)
end

---@param colorIds number[]
---@param seconds number Tempo em que o piso fica so com a cor exibida.
function Client.collapseColors(colorIds, seconds)
    dbg(("cargame: client collapseColors seconds=%s colors=%s waitMs=%s"):format(
        tostring(seconds),
        tostring(type(colorIds) == "table" and #colorIds or 0),
        tostring(math.max(0, gTargetDropAt - GetGameTimer()))
    ))
    if type(colorIds) ~= "table" then colorIds = { colorIds } end

    gColorDropToken = gColorDropToken + 1
    local token = gColorDropToken
    local holdSecs = math.max(1, math.floor(tonumber(seconds) or 5))

    CreateThread(function()
        -- O server comeca a esperar no envio; o timer da HUD so no receive.
        -- Espera o 00s local antes de esconder o bloco.
        local waitMs = math.max(0, gTargetDropAt - GetGameTimer())
        if waitMs > 0 then Wait(waitMs) end
        if token ~= gColorDropToken then
            dbg(("cargame: client collapse cancelado token=%s atual=%s"):format(tostring(token), tostring(gColorDropToken)))
            return
        end

        dbg(("cargame: client collapse aplicado colors=%s"):format(tostring(#colorIds)))

        for i = 1, #colorIds do collapseColor(colorIds[i]) end
        if currentVehicle == 0 or not DoesEntityExist(currentVehicle) then
            fail("cargame: client collapse sem veiculo para acordar")
        else
            wakeEventVehicleAfterCollapse()
        end
        UpdateCargameCarEvent({
            duration = holdSecs,
            remainingTime = holdSecs,
            description = _t("unsafe_collapsing"),
        })
    end)
end

---@param payload table
function Client.liveRanking(payload)
    if type(payload) ~= "table" then return end
    UpdateCargameCarEventRanking(payload)
end

---@param round number
function Client.down(round)
    dbg(("cargame: client down round=%s"):format(tostring(round)))
    setLocalGhost(true)
    showGhostNotification()
    sx.logger:debug(("cargame: caiu no round %s; ghost o proximo round inteiro"):format(tostring(round)))
end

---@param round number
function Client.revive(round)
    dbg(("cargame: client revive round=%s"):format(tostring(round)))
    setLocalGhost(false)
    hideGhostNotification()
    sx.logger:debug(("cargame: voltou como jogador no round %s"):format(tostring(round)))
end

function Client.eliminated()
    dbg("cargame: client eliminated")
    resetEventClient()
end

function Client.left()
    dbg("cargame: client left")
    resetEventClient()
end

function Client.gameOver()
    dbg("cargame: client gameOver")
    resetEventClient()
end

function Client.showFinalStandings()
    resetEventClient()
end

RegisterNetEvent("cargame:client:clearInvite", Client.clearInvite)
RegisterNetEvent("cargame:client:eventInvite", Client.eventInvite)
RegisterNetEvent("cargame:client:updateLobby", Client.updateLobby)
RegisterNetEvent("cargame:client:liveRanking", Client.liveRanking)
RegisterNetEvent("cargame:client:pointsEarned", function(amount, bonus, kind)
    if type(amount) ~= "number" or amount <= 0 then return end
    showPointsNotification(amount, bonus, kind)
end)
RegisterNetEvent("cargame:client:forceReset", function()
    resetEventClient()
end)

RegisterCommand("cargame.accept", function()
    if not isInviteOpen() or inCargameLobby or gameStarted or acceptInProgress then return end
    acceptInProgress = true

    CreateThread(function()
        local result = nil
        TriggerEvent("request.start", _t("event_join_confirm"), {
            onAccepted = function() result = true end,
            onRefused = function() result = false end,
        }, 15, "default")

        local deadline = GetGameTimer() + 18000
        while result == nil and GetGameTimer() < deadline do Wait(0) end
        acceptInProgress = false

        if result == true and isInviteOpen() and not inCargameLobby and not gameStarted then
            TriggerServerEvent("cargame:server:acceptFromInvite")
        end
    end)
end, false)

RegisterKeyMapping("cargame.accept", "Aceitar Colisão Cromática", "keyboard", "F3")

CargameSetTick(function()
    local now = GetGameTimer()
    if now < lastInviteCheckAt then return end
    lastInviteCheckAt = now + 500

    if announceActive and announceEndTime > 0 and now >= announceEndTime then
        clearInviteState()
    end
end)

AddEventHandler("onResourceStop", function(name)
    if GetCurrentResourceName() ~= name then return end
    resetEventClient()
end)
