local Tunnel = module("vrp", "lib/Tunnel")

local Client = {}
Tunnel.bindInterface("deathstatue", Client)

local Server = Tunnel.getInterface("deathstatue")

gameStarted = false
dollyIsWatching = false
announceActive = false
announceEndTime = 0
lobbyPlayers = 0
lobbyEndTime = 0
inDeathStatueLobby = false
lobbyStarting = false
roundFinished = false
betweenRounds = false

local insideGameZone = false
local insideFinishZone = false
local caughtCooldown = false
local finishCooldown = false
local finishScorePending = false
local redLightDetect = false
local redLightAnchor = nil
local redLightCamHeading
local redLightCamPitch
local function applyEventGodmode()
    SetEntityInvincible(PlayerPedId(), true)
end

local function clearEventGodmode()
    SetEntityInvincible(PlayerPedId(), false)
end

local LOOK_CONTROLS = { 1, 2 }

local function setEventHudHidden(hidden)
    exports["hud"]:hideAllButLogoAndNotifications(hidden == true)
end

local deathStatueEmotesBlocked = false
local deathStatueFirstPersonBlockRunning = false

local function isSpawninEmotesStarted()
    return GetResourceState("spawnin_emotes") == "started"
end

local function startDeathStatueFirstPersonBlock()
    if deathStatueFirstPersonBlockRunning then
        return
    end

    deathStatueFirstPersonBlockRunning = true

    CreateThread(function()
        while deathStatueFirstPersonBlockRunning do
            if GetFollowPedCamViewMode() == 4 then
                SetFollowPedCamViewMode(1)
            end

            DisableFirstPersonCamThisFrame()
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.10)
            Citizen.Wait(0)
        end
    end)
end

local function stopDeathStatueFirstPersonBlock()
    deathStatueFirstPersonBlockRunning = false
end

local function cancelDeathStatueEmote()
    if not isSpawninEmotesStarted() then
        return
    end

    pcall(function()
        exports.spawnin_emotes:EmoteCancel()
    end)
end

local function setDeathStatueWalkstyleLocked(locked)
    if not isSpawninEmotesStarted() then
        return
    end

    pcall(function()
        exports.spawnin_emotes:toggleWalkstyle(
            not locked,
            locked and "Animações bloqueadas durante o evento." or nil
        )
    end)
end

local function resetDeathStatueWalkstyle()
    ResetPedMovementClipset(PlayerPedId(), 0.0)
end

local function restoreDeathStatueWalkstyle()
    if not isSpawninEmotesStarted() then
        return
    end

    local ok, walkstyle = pcall(function()
        return exports.spawnin_emotes:getWalkstyle()
    end)

    if not ok or not walkstyle or walkstyle == "" then
        return
    end

    pcall(function()
        exports.spawnin_emotes:setWalkstyle(walkstyle, true)
    end)
end

local function setDeathStatueEmotesBlocked(blocked)
    blocked = blocked == true

    if deathStatueEmotesBlocked == blocked then
        if blocked then
            cancelDeathStatueEmote()
            resetDeathStatueWalkstyle()
            startDeathStatueFirstPersonBlock()
        end
        return
    end

    deathStatueEmotesBlocked = blocked

    if blocked then
        cancelDeathStatueEmote()
        resetDeathStatueWalkstyle()
        LocalPlayer.state:set("canEmote", false, true)
        setDeathStatueWalkstyleLocked(true)
        startDeathStatueFirstPersonBlock()
    else
        LocalPlayer.state:set("canEmote", true, true)
        setDeathStatueWalkstyleLocked(false)
        restoreDeathStatueWalkstyle()
        stopDeathStatueFirstPersonBlock()
    end
end

local function clearLocalDeathStatueBlocks()
    if LocalPlayer.state["minigame:active"] == "deathstatue" then
        LocalPlayer.state:set("minigame:active", nil, true)
    end
    if LocalPlayer.state["isLafyMuted"] then
        LocalPlayer.state:set("isLafyMuted", false, true)
    end
    setDeathStatueEmotesBlocked(false)
    setEventHudHidden(false)
end


local dollyPed
local dollyTargetHeading = Config.Dolly.WatchingHeading
local dollyRotating = false
local barrierObjects = {}

local zoneOpts = { minZ = 285.0, maxZ = 298.0 }

local finishZoneBounds
local wasInFinishZone = false

local function getFinishZoneBounds()
    if finishZoneBounds then return finishZoneBounds end

    local fz = Config.FinishZone
    local minX = fz[1].x
    local maxX = fz[1].x
    local minY = fz[1].y
    local maxY = fz[1].y

    for i = 2, #fz do
        local p = fz[i]
        minX = math.min(minX, p.x)
        maxX = math.max(maxX, p.x)
        minY = math.min(minY, p.y)
        maxY = math.max(maxY, p.y)
    end

    finishZoneBounds = {
        minX = minX,
        maxX = maxX,
        minY = minY,
        maxY = maxY,
        minZ = zoneOpts.minZ,
        maxZ = zoneOpts.maxZ,
    }
    return finishZoneBounds
end

local function getFinishLineX()
    local b = getFinishZoneBounds()
    return math.max(b.minX, b.maxX)
end

local function isInFinishLane(coords)
    local b = getFinishZoneBounds()
    return coords.y >= b.minY and coords.y <= b.maxY
        and coords.z >= b.minZ and coords.z <= b.maxZ
end

local function hasCrossedFinishLine(coords)
    if not isInFinishLane(coords) then
        return false
    end

    if finishZone:isPointInside(coords) then
        return true
    end

    return coords.x <= getFinishLineX()
end

local function endRedLightDetection()
    redLightDetect = false
    redLightAnchor = nil
    redLightCamHeading = nil
    redLightCamPitch = nil
end

local function tryScoreFinishLap(crossed)
    if not gameStarted or roundFinished or betweenRounds or caughtCooldown then return end
    if finishCooldown or finishScorePending or not crossed then return end
    if wasInFinishZone then return end

    finishScorePending = true
    local delayMs = Config.FinishScoreDelayMs or 500

    Citizen.SetTimeout(delayMs, function()
        finishScorePending = false
        if not gameStarted or roundFinished or betweenRounds or wasInFinishZone then
            return
        end

        if not hasCrossedFinishLine(GetEntityCoords(PlayerPedId())) then
            return
        end

        finishCooldown = true
        local ok = Server.playerEnteredFinishZone()
        if ok then
            wasInFinishZone = true
            roundFinished = true
            endRedLightDetection()
        else
            Citizen.SetTimeout(250, function()
                finishCooldown = false
            end)
            return
        end

        Citizen.SetTimeout(1500, function() finishCooldown = false end)
    end)
end

local function updateFinishZoneDetection(coords)
    coords = coords or GetEntityCoords(PlayerPedId())
    local crossed = hasCrossedFinishLine(coords)
    insideFinishZone = crossed
    tryScoreFinishLap(crossed)
end

gameZone = PolyZone:Create(Config.GameZone, { name = "gameZone", minZ = zoneOpts.minZ, maxZ = zoneOpts.maxZ })

finishZone = PolyZone:Create(Config.FinishZone, { name = "finishZone", minZ = zoneOpts.minZ, maxZ = zoneOpts.maxZ })

gameZone:onPlayerInOut(function(isPointInside)
    local wasInside = insideGameZone
    insideGameZone = isPointInside
    if gameStarted and not betweenRounds and not roundFinished and wasInside and not isPointInside then
        if hasCrossedFinishLine(GetEntityCoords(PlayerPedId())) or wasInFinishZone then
            tryScoreFinishLap(true)
            return
        end

        Server.playerLeftZone()
    end
end)

local function refreshZoneState()
    local coords = GetEntityCoords(PlayerPedId())
    insideGameZone = gameZone:isPointInside(coords)
    updateFinishZoneDetection(coords)
end

local barrierConfig = Config.LobbyBarrier
local barrierYMin = math.min(barrierConfig.yMin, barrierConfig.yMax)
local barrierYMax = math.max(barrierConfig.yMin, barrierConfig.yMax)

local function isOnGameField()
    local coords = GetEntityCoords(PlayerPedId())
    return coords.x <= barrierConfig.x and coords.y >= barrierYMin and coords.y <= barrierYMax
        and coords.z >= barrierConfig.z - 2.0 and coords.z <= barrierConfig.z + 5.0
end

local function angleDelta(a, b)
    return math.abs((a - b + 180.0) % 360.0 - 180.0)
end

local function armRedLightDetection()
    redLightDetect = false
    redLightAnchor = GetEntityCoords(PlayerPedId())
    redLightCamHeading = GetGameplayCamRelativeHeading()
    redLightCamPitch = GetGameplayCamRelativePitch()
    redLightDetect = true
end

local function beginRedLightGrace()
    redLightDetect = false
    redLightAnchor = nil
    redLightCamHeading = nil
    redLightCamPitch = nil
    local graceMs = Config.RedLightGraceMs or 1000
    Citizen.SetTimeout(graceMs, function()
        if not dollyIsWatching then return end
        armRedLightDetection()
    end)
end

local function disableRedLightLookControls()
    for i = 1, #LOOK_CONTROLS do
        DisableControlAction(0, LOOK_CONTROLS[i], true)
    end
end

local function isPlayingActiveRound()
    return gameStarted and not betweenRounds and not roundFinished
end

local function hasLookInput()
    local threshold = Config.CameraInputThreshold or 0.02
    for i = 1, #LOOK_CONTROLS do
        if math.abs(GetDisabledControlNormal(0, LOOK_CONTROLS[i])) > threshold then
            return true
        end
    end
    return false
end

local function hasCameraMoved()
    if not redLightCamHeading or not redLightCamPitch then return false end

    local threshold = Config.CameraDetectDelta or 1.5
    local heading = GetGameplayCamRelativeHeading()
    local pitch = GetGameplayCamRelativePitch()
    return angleDelta(heading, redLightCamHeading) > threshold
        or math.abs(pitch - redLightCamPitch) > threshold
end

local function playCaughtGunshot()
    SendNUIMessage({
        action = "deathstatue:playCaughtShot",
        data = {
            volume = tonumber(Config.CaughtShotVolume) or 1.0,
        },
    })
end

local function forceCaughtRagdoll(ped, durationMs)
    if not ped or ped == 0 or not DoesEntityExist(ped) then
        return
    end

    local forward = GetEntityForwardVector(ped)
    SetPedCanRagdoll(ped, true)
    SetPedCanRagdollFromPlayerImpact(ped, true)
    SetPedToRagdollWithFall(
        ped,
        durationMs,
        durationMs,
        0,
        forward.x,
        forward.y,
        forward.z,
        1.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0
    )

    if not IsPedRagdoll(ped) then
        SetPedToRagdoll(ped, durationMs, durationMs, 0, 0, 0, 0)
    end
end

local function triggerCaught(ped, reason)
    caughtCooldown = true
    endRedLightDetection()

    local accepted = Server.playerCaught(reason or "movement")
    if not accepted then
        caughtCooldown = false
        if dollyIsWatching and isPlayingActiveRound() then
            armRedLightDetection()
        end
        return
    end

    local sniperStarted = playDeathStatueCaughtSniper()
    if not sniperStarted then
        playCaughtGunshot()
    end

    local ragdollMs = math.max(500, tonumber(Config.CaughtRagdollMs) or 1500)
    local ragdollDelayMs = math.max(0, tonumber(Config.CaughtShotRagdollDelayMs) or 90)
    if sniperStarted then
        local sniperCfg = Config.CaughtSniper
        local aimMs = math.max(0, tonumber(sniperCfg and sniperCfg.AimMs) or 380)
        ragdollDelayMs = aimMs + ragdollDelayMs
    end
    ped = PlayerPedId()
    SetEntityVelocity(ped, 0.0, 0.0, 0.0)
    ClearPedTasksImmediately(ped)

    CreateThread(function()
        if ragdollDelayMs > 0 then
            Wait(ragdollDelayMs)
        end

        local currentPed = PlayerPedId()
        forceCaughtRagdoll(currentPed, ragdollMs)

        local endsAt = GetGameTimer() + ragdollMs
        local nextForceAt = 0

        while GetGameTimer() < endsAt and caughtCooldown do
            currentPed = PlayerPedId()
            DisableControlAction(0, 21, true)
            DisableControlAction(0, 22, true)
            DisableControlAction(0, 30, true)
            DisableControlAction(0, 31, true)
            DisableControlAction(0, 32, true)
            DisableControlAction(0, 33, true)
            DisableControlAction(0, 34, true)
            DisableControlAction(0, 35, true)
            DisableControlAction(0, 36, true)

            if not IsPedRagdoll(currentPed) and GetGameTimer() >= nextForceAt then
                forceCaughtRagdoll(currentPed, math.max(400, endsAt - GetGameTimer()))
                nextForceAt = GetGameTimer() + 250
            end

            Wait(0)
        end
    end)

    Citizen.SetTimeout(ragdollDelayMs + ragdollMs + 750, function()
        caughtCooldown = false
    end)
end

local function tickRedLightDetection(ped, coords)
    if not isPlayingActiveRound() then
        return
    end

    if not redLightDetect or not dollyIsWatching or caughtCooldown then
        return
    end

    if not insideGameZone or wasInFinishZone or finishScorePending then
        return
    end

    ped = ped or PlayerPedId()

    if Config.DetectCameraOnRedLight then
        disableRedLightLookControls()
    end

    local pos = coords or GetEntityCoords(ped)
    local moved = redLightAnchor and #(pos - redLightAnchor) > (Config.MovementDetectDist or 0.45)
    local pressing = IsControlPressed(0, 32) or IsControlPressed(0, 33) or IsControlPressed(0, 34) or IsControlPressed(0, 35)
    local movedBody = moved
        or (pressing and GetEntitySpeed(ped) > 0.35)
        or IsControlJustPressed(0, 36)
    local lookedAround = Config.DetectCameraOnRedLight and (hasLookInput() or hasCameraMoved())

    if movedBody then
        triggerCaught(ped, "movement")
    elseif lookedAround then
        triggerCaught(ped, "camera")
    end
end

local function stripPlayerWeapons(ped)
    if IsPedArmed(ped, 7) then
        SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
        RemoveAllPedWeapons(ped, true)
    end
end

local function shouldRestrictLobbyOrGame()
    return inDeathStatueLobby or gameStarted
end

local function applyParticipationBlocks(ped)
    stripPlayerWeapons(ped)
    DisableControlAction(2, 37, true)
    DisablePlayerFiring(ped, true)
    DisableControlAction(0, 45, true)
    DisableControlAction(0, 24, true)
    DisableControlAction(0, 263, true)
    DisableControlAction(0, 140, true)
    DisableControlAction(0, 142, true)
end

local function gameLoopOnTick()
    local ped = PlayerPedId()

    if isPlayingActiveRound() then
        local coords = GetEntityCoords(ped)
        insideGameZone = gameZone:isPointInside(coords)
        updateFinishZoneDetection(coords)
        tickRedLightDetection(ped, coords)
    end

    if shouldRestrictLobbyOrGame() then
        applyParticipationBlocks(ped)
    end
end

Citizen.CreateThread(function()
    while true do
        if isPlayingActiveRound() or shouldRestrictLobbyOrGame() then
            gameLoopOnTick()
            Citizen.Wait(0)
        else
            Citizen.Wait(500)
        end
    end
end)

local function notify(notifyKey, vars)
    TriggerEvent("Notify2", notifyKey, vars or {})
end

local gEnterLobbyGeneration = 0

local function settleEventCollision(durationMs)
    local waitMs = math.max(0, tonumber(durationMs) or tonumber(Config.JoinSettleMs) or 3000)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    FreezeEntityPosition(ped, true)
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)

    local deadline = GetGameTimer() + waitMs
    while GetGameTimer() < deadline do
        if not inDeathStatueLobby then
            FreezeEntityPosition(PlayerPedId(), false)
            return false
        end

        ped = PlayerPedId()
        coords = GetEntityCoords(ped)
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        Citizen.Wait(100)
    end

    FreezeEntityPosition(PlayerPedId(), false)
    return inDeathStatueLobby == true
end

local function teleportToStartPoint()
    caughtCooldown = false
    local spawn = Config.LobbySpawns[math.random(#Config.LobbySpawns)]
    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped)
    SetEntityCoords(ped, spawn.x, spawn.y, spawn.z, false, false, false, false)
    SetEntityHeading(ped, spawn.w or 0.0)
    FreezeEntityPosition(ped, false)
    wasInFinishZone = false
    insideFinishZone = false
    finishScorePending = false
    refreshZoneState()
end

local function teleportToWaitingArea()
    local spawn = Config.WaitingArea or Config.LobbySpawns[1]
    local ped = PlayerPedId()
    SetEntityCoords(ped, spawn.x, spawn.y, spawn.z, false, false, false, false)
    SetEntityHeading(ped, spawn.w or 0.0)
    FreezeEntityPosition(ped, false)
    wasInFinishZone = false
    insideFinishZone = false
    roundFinished = true
    finishScorePending = false
    endRedLightDetection()
    refreshZoneState()
end

local function loadModel(model)
    local hash = type(model) == "string" and GetHashKey(model) or model
    RequestModel(hash)
    local timeout = GetGameTimer() + 10000
    while not HasModelLoaded(hash) and GetGameTimer() < timeout do Citizen.Wait(0) end
    return hash
end

local function createLobbyBarrier()
    if #barrierObjects > 0 then return end

    local hash = loadModel("prop_mp_barrier_02b")
    local b = Config.LobbyBarrier
    local yStart = math.min(b.yMin, b.yMax)
    local yEnd = math.max(b.yMin, b.yMax)
    local heights = b.heights or { 0.0, 1.2, 2.4, 3.6 }
    local y = yStart

    while y <= yEnd do
        for i = 1, #heights do
            local obj = CreateObjectNoOffset(hash, b.x, y, b.z + heights[i], false, false, false)
            SetEntityHeading(obj, 90.0)
            SetEntityVisible(obj, false, false)
            SetEntityCollision(obj, true, true)
            FreezeEntityPosition(obj, true)
            barrierObjects[#barrierObjects + 1] = obj
        end
        y = y + 2.0
    end
end

local function removeLobbyBarrier()
    for i = 1, #barrierObjects do
        local obj = barrierObjects[i]
        if DoesEntityExist(obj) then DeleteEntity(obj) end
    end
    barrierObjects = {}
end

local function pushBackFromBarrier()
    local ped = PlayerPedId()
    local entry = Config.EntryPoint
    SetEntityCoords(ped, entry.x, entry.y, entry.z, false, false, false, false)
    SetEntityHeading(ped, entry.w)
end

Citizen.CreateThread(function()
    while true do
        if inDeathStatueLobby or gameStarted or betweenRounds then
            DisableControlAction(0, 36, true)
            local ped = PlayerPedId()
            if GetPedStealthMovement(ped) then
                SetPedStealthMovement(ped, false, "DEFAULT_ACTION")
            end

            if inDeathStatueLobby or betweenRounds then
                local coords = GetEntityCoords(ped)

                if coords.x < barrierConfig.x and coords.y >= barrierYMin and coords.y <= barrierYMax and coords.z >= barrierConfig.z - 2.0 and coords.z <= barrierConfig.z + 5.0 then
                    pushBackFromBarrier()
                end
            end

            Citizen.Wait(0)
        else
            Citizen.Wait(500)
        end
    end
end)

local OUTFIT_CLOTHING_SLOTS = {
    [1] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
    [8] = true,
    [9] = true,
    [10] = true,
    [11] = true,
}

local function applyOutfit(ped, outfits)
    if not Config.ChangeOutfitOnJoin then return end
    if not outfits or #outfits == 0 then return end

    local outfit = outfits[math.random(#outfits)]
    for slot, v in pairs(outfit) do
        if OUTFIT_CLOTHING_SLOTS[slot] then
            SetPedComponentVariation(ped, slot, v[1], v[2], 0)
        end
    end
end

local function getOwnOutfits()
    if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") then
        return Config.PlayerOutfits["male"]
    end
    return Config.PlayerOutfits["female"]
end

local dollySpawnZ

local function getDollySpawnZ()
    if dollySpawnZ then return dollySpawnZ end

    local dolly = Config.Dolly
    local scale = tonumber(dolly and dolly.Scale) or 1.0
    local groundZ = dolly.Coords.z
    local zOffset = tonumber(dolly.ScaleZOffset)
    if not zOffset then
        zOffset = math.max(0.0, (scale - 1.0) * 0.92)
    end
    dollySpawnZ = groundZ + zOffset
    return dollySpawnZ
end

local function applyDollyLod(ped)
    if not ped or ped == 0 or not DoesEntityExist(ped) then
        return
    end

    SetPedLodMultiplier(ped, 100.0)
    SetEntityLodDist(ped, 0xFFFF)
end

local function setDollyMatrix(ped, heading, scale)
    if not ped or ped == 0 then
        return
    end

    scale = tonumber(scale) or 1.0
    local rad = math.rad(heading)
    local sinH = math.sin(rad)
    local cosH = math.cos(rad)
    local coords = Config.Dolly.Coords
    local spawnZ = getDollySpawnZ()

    SetEntityMatrix(ped,
        -sinH * scale, cosH * scale, 0.0,
        cosH * scale, sinH * scale, 0.0,
        0.0, 0.0, scale,
        coords.x, coords.y, spawnZ)
    applyDollyLod(ped)
end

local function createDolly()
    if dollyPed and DoesEntityExist(dollyPed) then return end

    local dolly = Config.Dolly
    local hash = loadModel(dolly.Model)
    local spawnZ = getDollySpawnZ()
    dollyPed = CreatePed(4, hash, dolly.Coords.x, dolly.Coords.y, spawnZ, dolly.Coords.w, false, false)
    SetEntityHeading(dollyPed, dolly.WatchingHeading)
    SetEntityCoordsNoOffset(dollyPed, dolly.Coords.x, dolly.Coords.y, spawnZ, false, false, false)
    SetPedDefaultComponentVariation(dollyPed)
    ClearAllPedProps(dollyPed)
    SetEntityInvincible(dollyPed, true)
    SetBlockingOfNonTemporaryEvents(dollyPed, true)
    SetPedCanRagdoll(dollyPed, false)
    SetPedFleeAttributes(dollyPed, 0, false)
    SetPedCombatAttributes(dollyPed, 46, true)
    SetEntityCollision(dollyPed, false, false)
    SetPedCanPlayAmbientAnims(dollyPed, false)
    SetPedCanPlayGestureAnims(dollyPed, false)
    SetPedCanPlayVisemeAnims(dollyPed, false, false)
    SetPedDiesWhenInjured(dollyPed, false)
    SetPedConfigFlag(dollyPed, 104, true)
    ClearPedTasksImmediately(dollyPed)
    applyDollyLod(dollyPed)
    dollyTargetHeading = dolly.WatchingHeading
    setDollyMatrix(dollyPed, dolly.WatchingHeading, tonumber(dolly.Scale) or 1.0)
end

local function rotateDollyThread()
    if dollyRotating then return end
    dollyRotating = true
    local scale = tonumber(Config.Dolly and Config.Dolly.Scale) or 1.0
    Citizen.CreateThread(function()
        local heading = dollyTargetHeading
        while dollyPed and DoesEntityExist(dollyPed) do
            Citizen.Wait(0)
            local diff = (dollyTargetHeading - heading + 540) % 360 - 180
            if math.abs(diff) > 0.5 then
                local step = dollyIsWatching and 12.0 or 4.0
                if math.abs(diff) <= step then
                    heading = dollyTargetHeading
                else
                    heading = (heading + (diff > 0 and step or -step)) % 360
                end
            else
                heading = dollyTargetHeading
            end
            SetPedDesiredHeading(dollyPed, heading)
            setDollyMatrix(dollyPed, heading, scale)
        end
        dollyRotating = false
    end)
end

local function cleanupEntities()
    removeLobbyBarrier()
    if dollyPed and DoesEntityExist(dollyPed) then DeleteEntity(dollyPed) end
    dollyPed = nil
    clearDeathStatueCaughtSniper()
end

local function clearInviteState()
    local wasActive = announceActive
    announceActive = false
    announceEndTime = 0

    if wasActive then
        TriggerEvent('hud:deathstatueInviteOpen', false)
    end
end

local function isInviteOpen()
    return announceActive and announceEndTime > 0 and GetGameTimer() < announceEndTime
end

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
    clearEstatuaAnnounceUi()
end

RegisterNetEvent("deathstatue:client:clearInvite", function()
    Client.clearInvite()
end)

RegisterNetEvent("deathstatue:client:eventInvite", function(body, createdBy, duration, tempoAceitar)
    Client.eventInvite(body, createdBy, duration, tempoAceitar)
end)

RegisterNetEvent("deathstatue:client:updateLobby", function(players, secondsUntilStart)
    Client.updateLobby(players, secondsUntilStart)
end)

function Client.enterLobby(players, secondsUntilStart)
    clearInviteState()
    clearEstatuaAnnounceUi()

    gEnterLobbyGeneration = gEnterLobbyGeneration + 1
    local enterGeneration = gEnterLobbyGeneration

    lobbyPlayers = players or 0
    inDeathStatueLobby = true
    lobbyStarting = false
    lobbyEndTime = GetGameTimer() + (tonumber(secondsUntilStart) or 0) * 1000
    TriggerEvent("inventory:Close")
    TriggerEvent("toast.dismiss")
    TriggerEvent("net.hud.clear.announcements")
    TriggerEvent("dashboard:closeHelpCenter")
    TriggerEvent("missions:client:lockHud")
    setEventHudHidden(true)
    LocalPlayer.state:set("minigame:active", "deathstatue", true)
    LocalPlayer.state:set("isLafyMuted", true, true)
    setDeathStatueEmotesBlocked(true)
    ExecuteCommand("som off")
    TriggerEvent("resetEnergetic")
    TriggerEvent("setEnergetic", 1, 1.10, false)
    TriggerEvent("player:forceStand")
    stripPlayerWeapons(PlayerPedId())
    applyOutfit(PlayerPedId(), getOwnOutfits())

    if not settleEventCollision(Config.JoinSettleMs) then
        return
    end

    if not inDeathStatueLobby or enterGeneration ~= gEnterLobbyGeneration then
        return
    end

    TriggerEvent("player:forceStand")
    createLobbyBarrier()
    createDolly()
    createDeathStatueCaughtSniper()
    rotateDollyThread()

    if not inDeathStatueLobby or enterGeneration ~= gEnterLobbyGeneration then
        cleanupEntities()
        return
    end

    showEstatuaTutorial({
        name = _t("tutorial_leader_name"),
        text = _t("tutorial_text"),
        exitKey = Config.EventHudExitKey or "G",
        exitLabel = _t("tutorial_exit_label"),
    })
    showEstatuaLobby({
        startsIn = tonumber(secondsUntilStart) or 0,
        players = lobbyPlayers,
        maxPlayers = Config.MaxPlayersPerLobby or 20,
        exitKey = Config.EventHudExitKey or "G",
        exitLabel = _t("tutorial_exit_label"),
    })
end

function Client.updateEventHud(payload)
    updateDeathStatueEventHud(payload or {})
end

function Client.lobbyStarting()
    lobbyStarting = true
    hideEstatuaTutorial()
    hideEstatuaLobby()
end

function Client.updateLobby(players, secondsUntilStart)
    lobbyPlayers = players or 0
    if secondsUntilStart then
        lobbyEndTime = GetGameTimer() + tonumber(secondsUntilStart) * 1000
    end

    updateEstatuaLobby({
        startsIn = tonumber(secondsUntilStart) or 0,
        players = lobbyPlayers,
        maxPlayers = Config.MaxPlayersPerLobby or 20,
    })
end

function Client.eventInvite(body, createdBy, duration, tempoAceitar)
    if inDeathStatueLobby or gameStarted then return end
    -- Mundo Afiliado nao recebe o convite; retornar antes de armar o F3.
    if GetResourceState("new_hub") == "started" and exports.new_hub:IsAffiliateWorldClientActive() then return end
    -- ENG-3750: iniciante nos primeiros 15 min nao ve o convite nem arma o F3.
    if GetResourceState("hud") == "started" and exports.hud:IsNewbieAnnounceBlocked() then return end

    local minigame = LocalPlayer.state["minigame:active"]
    if minigame and minigame ~= "deathstatue" then return end
    if LocalPlayer.state["cargame:joined"] then return end

    local lobbySecs = math.max(1, tonumber(tempoAceitar) or tonumber(duration) or Config.NotifyDuration or 60)

    if isX1InviteProtected() then
        holdInviteUntilUnprotected(body, createdBy, lobbySecs)
        return
    end

    gHeldInviteGeneration = gHeldInviteGeneration + 1
    local durationMs = lobbySecs * 1000
    announceActive = true
    announceEndTime = GetGameTimer() + durationMs

    TriggerEvent('hud:deathstatueInviteOpen', true)
    TriggerEvent("sounds:Private", "recrutamento", 0.09)

    local announceCfg = Config.Announce or {}
    showEstatuaAnnounce({
        title = announceCfg.Title or _t("eventTitle"),
        sender = announceCfg.Sender or _t("eventPrefix"),
        description = body or _t("event_invite_body"),
        keyPrompt = announceCfg.KeyPrompt or "F3",
        keyLabel = _t("event_invite_key_label"),
        bgColor = announceCfg.BgColor or "rgb(96, 130, 203)",
        duration = durationMs,
    })
end

function Client.showMatchResult(payload)
    hideEstatuaLobby()
    hideEstatuaTutorial()
    closeDeathStatueEventHud()
    showEstatuaResult(payload or {})
end

function Client.gameStarted()
    gameStarted = true
    inDeathStatueLobby = false
    lobbyStarting = false
    betweenRounds = false
    roundFinished = false
    lobbyEndTime = 0
    wasInFinishZone = false
    finishCooldown = false
    finishScorePending = false
    endRedLightDetection()
    removeLobbyBarrier()
    clearInviteState()
    hideEstatuaTutorial()
    hideEstatuaLobby()
    setEventHudHidden(true)
    LocalPlayer.state:set("minigame:active", "deathstatue", true)
    LocalPlayer.state:set("isLafyMuted", true, true)
    setDeathStatueEmotesBlocked(true)
    ExecuteCommand("som off")
    TriggerEvent("resetEnergetic")
    TriggerEvent("setEnergetic", 1, 1.10, false)
    TriggerEvent("inventory:Close")
    TriggerEvent("dashboard:closeHelpCenter")
    stripPlayerWeapons(PlayerPedId())
    createDolly()
    createDeathStatueCaughtSniper()
    rotateDollyThread()
    refreshZoneState()

    applyEventGodmode()
end

function Client.prepareRound(roundNumber, totalRounds, tempoStart)
    betweenRounds = true
    roundFinished = false
    dollyIsWatching = false
    wasInFinishZone = false
    insideFinishZone = false
    finishCooldown = false
    finishScorePending = false
    endRedLightDetection()
    closeDeathStatueEventHud()
    createLobbyBarrier()
    lobbyStarting = false
    lobbyEndTime = GetGameTimer() + (tonumber(tempoStart) or Config.StartCountdownSecs or 10) * 1000
    runDeathStatueEventHudCountdown(tonumber(tempoStart) or Config.StartCountdownSecs or 10)
end

function Client.roundStarted(durationSecs, roundNumber, totalRounds)
    betweenRounds = false
    roundFinished = false
    lobbyStarting = false
    lobbyEndTime = 0
    wasInFinishZone = false
    insideFinishZone = false
    finishCooldown = false
    finishScorePending = false
    hideDeathStatueEventHudCountdown()
    removeLobbyBarrier()
    FreezeEntityPosition(PlayerPedId(), false)
    refreshZoneState()

    local base = buildDeathStatueEventHudBase()
    local duration = tonumber(durationSecs) or 120
    openDeathStatueEventHud({
        round = roundNumber,
        totalRounds = totalRounds or base.totalRounds,
        duration = duration,
        remainingTime = duration,
        light = "green",
        exitKey = base.exitKey,
        exitLabel = base.exitLabel,
        soundKey = base.soundKey,
        soundLabel = base.soundLabel,
    })
end

function Client.goToWaiting()
    roundFinished = true
    endRedLightDetection()
    teleportToWaitingArea()
    hideDeathStatueEventHudLight()
end

function Client.hideEventHudLight()
    hideDeathStatueEventHudLight()
end

local function playLightSound(light)
    if lightSoundsEnabled == false then
        return
    end

    SendNUIMessage({
        action = "deathstatue:playLightSound",
        data = {
            light = light,
            volume = tonumber(Config.LightSoundVolume) or 1.0,
        },
    })
end

function Client.roundPhase(phase)
    if betweenRounds then return end

    local watching = phase == "red"
    local light = watching and "red" or "green"
    dollyIsWatching = watching
    dollyTargetHeading = watching and Config.Dolly.WatchingHeading or Config.Dolly.NotWatchingHeading

    if roundFinished then
        return
    end

    updateDeathStatueEventHud({
        light = light,
    })
    playLightSound(light)

    if watching then
        beginRedLightGrace()
    else
        endRedLightDetection()
        FreezeEntityPosition(PlayerPedId(), false)
        refreshZoneState()
    end
end

function Client.left()
    gEnterLobbyGeneration = gEnterLobbyGeneration + 1
    lobbyPlayers = 0
    lobbyEndTime = 0
    inDeathStatueLobby = false
    gameStarted = false
    lobbyStarting = false
    betweenRounds = false
    roundFinished = false
    dollyIsWatching = false
    endRedLightDetection()
    clearInviteState()
    clearEstatuaAnnounceUi()
    clearLocalDeathStatueBlocks()
    resetDeathStatueLightSounds()
    closeDeathStatueEventHud()
    hideEstatuaTutorial()
    hideEstatuaLobby()
    clearEventGodmode()
    TriggerEvent("missions:client:unlockHud")
    FreezeEntityPosition(PlayerPedId(), false)
    cleanupEntities()
end

RegisterNetEvent("deathstatue:client:forceReset", function()
    Client.left()
end)

function Client.unfreezePlayer()
    FreezeEntityPosition(PlayerPedId(), false)
end

function Client.teleportToStart()
    teleportToStartPoint()
    if dollyIsWatching and gameStarted and not betweenRounds and not roundFinished then
        Citizen.SetTimeout(400, function()
            if dollyIsWatching and gameStarted and not betweenRounds and not roundFinished and isOnGameField() then
                armRedLightDetection()
            end
        end)
    end
end

function Client.gameOver()
    clearEventGodmode()
    if not gameStarted and not inDeathStatueLobby and not betweenRounds then
        clearInviteState()
        clearEstatuaAnnounceUi()
        TriggerEvent("missions:client:unlockHud")
        return
    end
    resetDeathStatueLightSounds()
    closeDeathStatueEventHud()
    hideEstatuaTutorial()
    hideEstatuaLobby()
    gameStarted = false
    inDeathStatueLobby = false
    lobbyStarting = false
    betweenRounds = false
    roundFinished = false
    lobbyEndTime = 0
    dollyIsWatching = false
    wasInFinishZone = false
    endRedLightDetection()
    clearInviteState()
    clearEstatuaAnnounceUi()
    lobbyPlayers = 0
    finishScorePending = false
    clearLocalDeathStatueBlocks()
    cleanupEntities()
    TriggerEvent("missions:client:unlockHud")
end

local acceptInProgress = false

RegisterCommand("deathstatue.accept", function()
    if not isInviteOpen() or inDeathStatueLobby or gameStarted or acceptInProgress then
        return
    end

    acceptInProgress = true

    CreateThread(function()
        local result = nil

        TriggerEvent("request.start", _t("event_join_confirm"), {
            onAccepted = function()
                result = true
            end,
            onRefused = function()
                result = false
            end,
        }, 15, "default")

        local deadline = GetGameTimer() + 18000
        while result == nil and GetGameTimer() < deadline do
            Wait(0)
        end

        local accepted = result == true
        acceptInProgress = false

        if not accepted then
            return
        end

        if not isInviteOpen() or inDeathStatueLobby or gameStarted then
            return
        end

        TriggerServerEvent("deathstatue:server:acceptFromInvite")
    end)
end, false)

RegisterKeyMapping("deathstatue.accept", "Aceitar Estátua Mortal", "keyboard", "F3")

Citizen.CreateThread(function()
    while true do
        if announceActive and announceEndTime > 0 and GetGameTimer() >= announceEndTime then
            clearInviteState()
        end

        Citizen.Wait(500)
    end
end)

AddEventHandler("onResourceStop", function(name)
    if GetCurrentResourceName() ~= name then return end
    -- ENG-3871: sem isso o hud fica com gDeathStatueInviteOpen = true e segura /adm e festa ate relogar.
    clearInviteState()
    closeDeathStatueEventHud()
    FreezeEntityPosition(PlayerPedId(), false)
    gameStarted = false
    inDeathStatueLobby = false
    betweenRounds = false
    roundFinished = false
    clearLocalDeathStatueBlocks()
    clearEventGodmode()
    cleanupEntities()
end)
