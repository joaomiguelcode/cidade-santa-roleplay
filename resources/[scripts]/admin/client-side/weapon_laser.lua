local gWeaponLaserPlayers = {}
local gWeaponLaserRays = {}
local gWeaponLaserStateKey = "admin:weaponLaser"
local gWeaponLaserRange = 250.0
local gWeaponLaserProbeInterval = 50

---@param ped number
---@return vector3? origin
---@return vector3? target
---@return number? weaponEntity
local function getWeaponLaserLine(ped)

    if not DoesEntityExist(ped) or not IsPedArmed(ped, 4) then
        return nil, nil, nil
    end

    local weaponEntity = GetCurrentPedWeaponEntityIndex(ped)

    if weaponEntity == 0 or not DoesEntityExist(weaponEntity) then
        return nil, nil, nil
    end

    local muzzleBone = GetEntityBoneIndexByName(weaponEntity, "gun_muzzle")
    local origin = muzzleBone ~= -1 and GetWorldPositionOfEntityBone(weaponEntity, muzzleBone) or GetEntityCoords(weaponEntity)
    local target = origin + GetEntityForwardVector(weaponEntity) * gWeaponLaserRange

    return origin, target, weaponEntity
end

---@param player number
---@param now number
---@return boolean drawn
local function drawWeaponLaser(player, now)

    local ped = GetPlayerPed(player)
    local origin, target, weaponEntity = getWeaponLaserLine(ped)

    if not origin then
        gWeaponLaserRays[player] = nil
        return false
    end

    local ray = gWeaponLaserRays[player]

    if not ray or ray.weaponEntity ~= weaponEntity then
        ray = {
            endCoords = target,
            nextProbe = 0,
            weaponEntity = weaponEntity,
        }
        gWeaponLaserRays[player] = ray
    end

    if ray.handle then
        local status, _, endCoords = GetShapeTestResult(ray.handle)

        if status == 2 then
            ray.endCoords = endCoords
            ray.handle = nil
            ray.nextProbe = now + gWeaponLaserProbeInterval
        elseif status == 0 then
            ray.endCoords = target
            ray.handle = nil
            ray.nextProbe = now
        end
    elseif now >= ray.nextProbe then
        ray.handle = StartShapeTestLosProbe(
            origin.x, origin.y, origin.z,
            target.x, target.y, target.z,
            511,
            ped,
            4
        )
    end

    local endCoords = ray.endCoords or target

    DrawLine(origin.x, origin.y, origin.z, endCoords.x, endCoords.y, endCoords.z, 255, 0, 0, 255)
    return true
end

CreateThread(function()

    while true do
        local players = {}
        local activePlayers = {}

        for _, player in ipairs(GetActivePlayers()) do
            local serverId = GetPlayerServerId(player)

            if Player(serverId).state[gWeaponLaserStateKey] == true then
                players[#players + 1] = player
                activePlayers[player] = true
            end
        end

        for player in pairs(gWeaponLaserRays) do

            if not activePlayers[player] then
                gWeaponLaserRays[player] = nil
            end
        end

        gWeaponLaserPlayers = players
        Wait(250)
    end
end)

CreateThread(function()

    while true do
        local sleep = 250
        local now = GetGameTimer()

        for _, player in ipairs(gWeaponLaserPlayers) do

            if drawWeaponLaser(player, now) then
                sleep = 0
            end
        end

        Wait(sleep)
    end
end)
