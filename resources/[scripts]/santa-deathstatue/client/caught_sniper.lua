local caughtSnipers = {}
local caughtSniperShotToken = 0
local caughtSniperRunning = false
local caughtSniperPtfxReady = false
local cachedWeaponHash = joaat("WEAPON_HEAVYSNIPER")

local cachedCfg
local cachedScale = 2.0
local cachedZOffset = 0.92
local cachedLaser = { r = 255, g = 32, b = 32, a = 220 }
local cachedAimMs = 380
local cachedLaserAfterShotMs = 280
local cachedPrimeDelayMs = 400
local cachedPrimeMs = 260
local LASER_TARGET_BONES = { 31086, 24818 }

local function refreshCaughtSniperCache()
    cachedCfg = Config.CaughtSniper
    if not cachedCfg then
        return false
    end

    cachedScale = tonumber(cachedCfg.Scale) or 2.0
    local zOffset = tonumber(cachedCfg.ScaleZOffset)
    if not zOffset then
        zOffset = math.max(0.0, (cachedScale - 1.0) * 0.92)
    end
    cachedZOffset = zOffset
    cachedLaser = cachedCfg.LaserColor or cachedLaser
    cachedAimMs = math.max(100, tonumber(cachedCfg.AimMs) or 380)
    cachedLaserAfterShotMs = math.max(50, tonumber(cachedCfg.LaserAfterShotMs) or 280)
    cachedPrimeDelayMs = math.max(0, tonumber(cachedCfg.PrimeDelayMs) or 400)
    cachedPrimeMs = math.max(50, tonumber(cachedCfg.PrimeMs) or 260)
    cachedWeaponHash = joaat(cachedCfg.Weapon or "WEAPON_HEAVYSNIPER")
    return true
end

local function getCaughtSniperCoordsList(cfg)
    local coords = cfg and cfg.Coords
    if type(coords) ~= "table" then
        return {}
    end

    if coords.x and coords.y and coords.z then
        return { coords }
    end

    local list = {}
    for i = 1, #coords do
        local entry = coords[i]
        if entry and entry.x and entry.y and entry.z then
            list[#list + 1] = entry
        end
    end
    return list
end

local function loadCaughtSniperModel(model)
    local hash = type(model) == "string" and joaat(model) or model
    if not IsModelInCdimage(hash) or not IsModelValid(hash) then
        return nil
    end

    RequestModel(hash)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(hash) and GetGameTimer() < timeout do
        Citizen.Wait(0)
    end

    if not HasModelLoaded(hash) then
        return nil
    end

    return hash
end

local function ensureCaughtSniperPtfx()
    if caughtSniperPtfxReady then
        return true
    end

    RequestNamedPtfxAsset("core")
    local timeout = GetGameTimer() + 1000
    while not HasNamedPtfxAssetLoaded("core") and GetGameTimer() < timeout do
        Citizen.Wait(0)
    end

    caughtSniperPtfxReady = HasNamedPtfxAssetLoaded("core")
    return caughtSniperPtfxReady
end

local function setCaughtSniperMatrix(sniper, heading)
    local ped = sniper and sniper.ped
    if not ped or ped == 0 or not DoesEntityExist(ped) then
        return
    end

    local rad = math.rad(heading)
    local sinH = math.sin(rad)
    local cosH = math.cos(rad)
    local coords = sniper.coords

    SetEntityMatrix(ped,
        -sinH * cachedScale, cosH * cachedScale, 0.0,
        cosH * cachedScale, sinH * cachedScale, 0.0,
        0.0, 0.0, cachedScale,
        coords.x, coords.y, sniper.spawnZ)

    if not sniper.aiming then
        SetCurrentPedWeapon(ped, cachedWeaponHash, true)
        SetPedCurrentWeaponVisible(ped, true, false, false, false)
    end
end

local function headingToward(sniper, toCoords)
    local coords = sniper.coords
    return GetHeadingFromVector_2d(toCoords.x - coords.x, toCoords.y - coords.y)
end

local function pickLaserTargetBone()
    return LASER_TARGET_BONES[math.random(#LASER_TARGET_BONES)]
end

local function isValidWorldPos(pos)
    return pos and not (pos.x == 0.0 and pos.y == 0.0 and pos.z == 0.0)
end

local function getLaserStart(sniper, heading)
    local ped = sniper.ped
    if ped and DoesEntityExist(ped) then
        local weapon = GetCurrentPedWeaponEntityIndex(ped)
        if weapon and weapon ~= 0 and DoesEntityExist(weapon) then
            local muzzleBone = GetEntityBoneIndexByName(weapon, "gun_muzzle")
            if muzzleBone and muzzleBone ~= -1 then
                local muzzle = GetWorldPositionOfEntityBone(weapon, muzzleBone)
                if isValidWorldPos(muzzle) then
                    return muzzle, GetEntityHeading(weapon)
                end
            end

            local nose = GetOffsetFromEntityInWorldCoords(weapon, 0.0, 0.85, 0.0)
            if isValidWorldPos(nose) then
                return nose, GetEntityHeading(weapon)
            end
        end

        local hand = GetPedBoneCoords(ped, 57005, 0.0, 0.0, 0.0)
        if isValidWorldPos(hand) then
            local rad = math.rad(heading)
            return vector3(
                hand.x - math.sin(rad) * (0.45 * cachedScale),
                hand.y + math.cos(rad) * (0.45 * cachedScale),
                hand.z
            ), heading
        end
    end

    local rad = math.rad(heading)
    local coords = sniper.coords
    return vector3(
        coords.x - math.sin(rad) * (0.40 * cachedScale),
        coords.y + math.cos(rad) * (0.40 * cachedScale),
        coords.z + (1.15 * cachedScale)
    ), heading
end

local function getLaserTarget(targetPed, boneId)
    local target = GetPedBoneCoords(targetPed, boneId or 31086, 0.0, 0.0, 0.0)
    if not isValidWorldPos(target) then
        local fallbackZ = (boneId == 24818) and 0.55 or 0.75
        target = GetEntityCoords(targetPed) + vector3(0.0, 0.0, fallbackZ)
    end
    return target
end

local function getLaserEndpoints(sniper, heading, targetPed, boneId)
    return getLaserStart(sniper, heading), getLaserTarget(targetPed, boneId)
end

local function playCaughtSniperGunshot()
    SendNUIMessage({
        action = "deathstatue:playCaughtShot",
        data = {
            volume = tonumber(Config.CaughtShotVolume) or 1.0,
        },
    })
end

local function playCaughtSniperMuzzleFlash(sniper, heading)
    if not ensureCaughtSniperPtfx() then
        return
    end

    local from, flashHeading = getLaserStart(sniper, heading)
    UseParticleFxAssetNextCall("core")
    StartParticleFxNonLoopedAtCoord(
        "muz_assault_rifle",
        from.x, from.y, from.z,
        0.0, 0.0, flashHeading or heading,
        1.2,
        false, false, false
    )
end

local function regiveCaughtSniperWeapon(ped)
    if not ped or ped == 0 or not DoesEntityExist(ped) then
        return
    end

    RemoveAllPedWeapons(ped, true)
    GiveWeaponToPed(ped, cachedWeaponHash, 30, true, true)
    SetCurrentPedWeapon(ped, cachedWeaponHash, true)
    SetPedCurrentWeaponVisible(ped, true, false, false, false)
end

local function startCaughtSniperAim(sniper, targetPed)
    local ped = sniper.ped
    if not ped or not DoesEntityExist(ped) or not targetPed or not DoesEntityExist(targetPed) then
        return
    end

    SetCurrentPedWeapon(ped, cachedWeaponHash, true)
    SetPedCurrentWeaponVisible(ped, true, false, false, false)
    TaskAimGunAtEntity(ped, targetPed, -1, false)
    sniper.aiming = true
end

local function stopCaughtSniperAim(sniper)
    sniper.aiming = false

    local ped = sniper.ped
    if not ped or not DoesEntityExist(ped) then
        return
    end

    ClearPedTasks(ped)
    regiveCaughtSniperWeapon(ped)
end

local function isCaughtSniperOnDuty()
    return gameStarted == true and betweenRounds ~= true and roundFinished ~= true
end

local function hasAliveCaughtSnipers()
    for i = 1, #caughtSnipers do
        local ped = caughtSnipers[i].ped
        if ped and DoesEntityExist(ped) then
            return true
        end
    end
    return false
end

local function getClosestCaughtSniper(playerCoords)
    local best
    local bestDist = nil

    for i = 1, #caughtSnipers do
        local sniper = caughtSnipers[i]
        local ped = sniper.ped
        if ped and DoesEntityExist(ped) then
            local coords = sniper.coords
            local dx = playerCoords.x - coords.x
            local dy = playerCoords.y - coords.y
            local dz = playerCoords.z - sniper.spawnZ
            local dist = (dx * dx) + (dy * dy) + (dz * dz)
            if not bestDist or dist < bestDist then
                bestDist = dist
                best = sniper
            end
        end
    end

    return best
end

local function startCaughtSniperMaintainThread()
    if caughtSniperRunning then
        return
    end

    caughtSniperRunning = true
    CreateThread(function()
        while hasAliveCaughtSnipers() do
            local onDuty = isCaughtSniperOnDuty()

            for i = 1, #caughtSnipers do
                local sniper = caughtSnipers[i]
                local ped = sniper.ped
                if ped and DoesEntityExist(ped) and not sniper.shotActive then
                    if onDuty then
                        SetPedDesiredHeading(ped, sniper.heading)
                        setCaughtSniperMatrix(sniper, sniper.heading)
                    else
                        SetPedDesiredHeading(ped, sniper.restHeading)
                        setCaughtSniperMatrix(sniper, sniper.restHeading)
                        sniper.heading = sniper.restHeading
                    end
                end
            end

            Citizen.Wait(0)
        end
        caughtSniperRunning = false
    end)
end

local function primeCaughtSniperWeapons()
    local token = caughtSniperShotToken

    CreateThread(function()
        Citizen.Wait(cachedPrimeDelayMs)

        local targetPed = PlayerPedId()
        if token ~= caughtSniperShotToken or not DoesEntityExist(targetPed) then
            return
        end

        local primed = {}

        for i = 1, #caughtSnipers do
            local sniper = caughtSnipers[i]
            if sniper.ped and DoesEntityExist(sniper.ped) and not sniper.primed then
                sniper.primed = true
                sniper.shotActive = true
                primed[#primed + 1] = sniper
                startCaughtSniperAim(sniper, targetPed)
            end
        end

        if #primed == 0 then
            return
        end

        local endsAt = GetGameTimer() + cachedPrimeMs

        while GetGameTimer() < endsAt and token == caughtSniperShotToken do
            for i = 1, #primed do
                local sniper = primed[i]
                if sniper.ped and DoesEntityExist(sniper.ped) then
                    setCaughtSniperMatrix(sniper, sniper.restHeading)
                end
            end

            Citizen.Wait(0)
        end

        if token ~= caughtSniperShotToken then
            return
        end

        for i = 1, #primed do
            local sniper = primed[i]
            sniper.shotActive = false
            if sniper.ped and DoesEntityExist(sniper.ped) then
                stopCaughtSniperAim(sniper)
                setCaughtSniperMatrix(sniper, sniper.restHeading)
            end
        end
    end)
end

function clearDeathStatueCaughtSniper()
    caughtSniperShotToken = caughtSniperShotToken + 1

    for i = 1, #caughtSnipers do
        local sniper = caughtSnipers[i]
        sniper.shotActive = false
        if sniper.ped and DoesEntityExist(sniper.ped) then
            DeleteEntity(sniper.ped)
        end
    end

    caughtSnipers = {}
end

function createDeathStatueCaughtSniper()
    local cfg = Config.CaughtSniper
    if not cfg or cfg.Enabled == false then
        return
    end

    if hasAliveCaughtSnipers() then
        return
    end

    if not refreshCaughtSniperCache() then
        return
    end

    local coordsList = getCaughtSniperCoordsList(cfg)
    if #coordsList == 0 then
        return
    end

    local modelHash = loadCaughtSniperModel(cfg.Model or "s_m_y_blackops_01")
    if not modelHash then
        return
    end

    for i = 1, #coordsList do
        local coords = coordsList[i]
        local restHeading = coords.w or 180.0
        local spawnZ = coords.z + cachedZOffset
        local ped = CreatePed(4, modelHash, coords.x, coords.y, spawnZ, restHeading, false, false)

        if ped and ped ~= 0 and DoesEntityExist(ped) then
            local sniper = {
                ped = ped,
                coords = coords,
                spawnZ = spawnZ,
                restHeading = restHeading,
                heading = restHeading,
                shotActive = false,
            }

            SetEntityHeading(ped, restHeading)
            SetEntityCoordsNoOffset(ped, coords.x, coords.y, spawnZ, false, false, false)
            SetEntityAsMissionEntity(ped, true, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            SetPedCanRagdoll(ped, false)
            SetPedFleeAttributes(ped, 0, false)
            SetPedCombatAttributes(ped, 46, true)
            SetEntityCollision(ped, false, false)
            SetPedCanPlayAmbientAnims(ped, false)
            SetPedCanPlayGestureAnims(ped, false)
            SetPedCanPlayVisemeAnims(ped, false, false)
            SetPedDiesWhenInjured(ped, false)
            SetPedConfigFlag(ped, 104, true)
            ClearPedTasksImmediately(ped)

            GiveWeaponToPed(ped, cachedWeaponHash, 30, true, true)
            SetCurrentPedWeapon(ped, cachedWeaponHash, true)
            SetPedCurrentWeaponVisible(ped, true, false, false, false)

            setCaughtSniperMatrix(sniper, restHeading)
            caughtSnipers[#caughtSnipers + 1] = sniper
        end
    end

    SetModelAsNoLongerNeeded(modelHash)

    if #caughtSnipers == 0 then
        return
    end

    ensureCaughtSniperPtfx()
    startCaughtSniperMaintainThread()
    primeCaughtSniperWeapons()
end

function playDeathStatueCaughtSniper()
    if not cachedCfg and not refreshCaughtSniperCache() then
        return false
    end

    if not cachedCfg or cachedCfg.Enabled == false then
        return false
    end

    if not hasAliveCaughtSnipers() then
        createDeathStatueCaughtSniper()
    end

    local targetPed = PlayerPedId()
    if not DoesEntityExist(targetPed) then
        return false
    end

    local sniper = getClosestCaughtSniper(GetEntityCoords(targetPed))
    if not sniper or not sniper.ped or not DoesEntityExist(sniper.ped) then
        return false
    end

    for i = 1, #caughtSnipers do
        caughtSnipers[i].shotActive = false
    end

    caughtSniperShotToken = caughtSniperShotToken + 1
    local token = caughtSniperShotToken
    sniper.shotActive = true

    CreateThread(function()
        local ped = sniper.ped
        local shotDone = false
        local laserBone = pickLaserTargetBone()
        local shotAt = GetGameTimer() + cachedAimMs
        local laserEndsAt = shotAt + cachedLaserAfterShotMs

        startCaughtSniperAim(sniper, targetPed)

        while GetGameTimer() < laserEndsAt and token == caughtSniperShotToken and DoesEntityExist(ped) do
            targetPed = PlayerPedId()
            if not DoesEntityExist(targetPed) then
                break
            end

            sniper.heading = headingToward(sniper, GetEntityCoords(targetPed))
            SetPedDesiredHeading(ped, sniper.heading)
            setCaughtSniperMatrix(sniper, sniper.heading)

            local from, to = getLaserEndpoints(sniper, sniper.heading, targetPed, laserBone)
            DrawLine(
                from.x, from.y, from.z,
                to.x, to.y, to.z,
                cachedLaser.r or 255,
                cachedLaser.g or 32,
                cachedLaser.b or 32,
                cachedLaser.a or 220
            )

            if not shotDone and GetGameTimer() >= shotAt then
                shotDone = true
                playCaughtSniperGunshot()
                playCaughtSniperMuzzleFlash(sniper, sniper.heading)
            end

            Citizen.Wait(0)
        end

        sniper.shotActive = false
        if token == caughtSniperShotToken then
            stopCaughtSniperAim(sniper)
            sniper.heading = sniper.restHeading
            if DoesEntityExist(ped) then
                setCaughtSniperMatrix(sniper, sniper.restHeading)
            end
        end
    end)

    return true
end

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end
    clearDeathStatueCaughtSniper()
end)
