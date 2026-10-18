-- local DAMAGEGRAV_WEAPON_HASH = 453432689

local damageGravEnabled = false

local activeZeroGravPlayers = {}

local GRAV_EARTH = 0
local GRAV_ZERO = 3

local function applyZeroGravToPed(ped)
    if not ped or ped == 0 or not DoesEntityExist(ped) then
        return
    end

    SetEntityHasGravity(ped, false)

    if SetGravityLevel then
        SetGravityLevel(ped, GRAV_ZERO)
    elseif SetPedGravity then
        SetPedGravity(ped, GRAV_ZERO)
    elseif SetPedGravityLevel then
        SetPedGravityLevel(ped, GRAV_ZERO)
    end

    if SetPedCanRagdoll then
        SetPedCanRagdoll(ped, true)
    end

    if SetPedToRagdoll then
        SetPedToRagdoll(ped, 3500, 3500, 0, 0, 0, 0)
    end
end

local function restoreGravityToPed(ped)
    if not ped or ped == 0 or not DoesEntityExist(ped) then
        return
    end

    SetEntityHasGravity(ped, true)

    if SetGravityLevel then
        SetGravityLevel(ped, GRAV_EARTH)
    elseif SetPedGravity then
        SetPedGravity(ped, GRAV_EARTH)
    elseif SetPedGravityLevel then
        SetPedGravityLevel(ped, GRAV_EARTH)
    end

    if SetPedCanRagdoll then
        SetPedCanRagdoll(ped, true)
    end

    --[[
        NOTE: Tentativa de forçar uma estabilizacao fisica para evitar ficar "preso" flutuando.
        - geesy
    ]]

    ClearPedTasksImmediately(ped)
    SetEntityVelocity(ped, 0.0, 0.0, -1.0)

    if IsPedInAnyVehicle(ped, false) then

        local veh = GetVehiclePedIsIn(ped, false)

        if veh and DoesEntityExist(veh) then

            SetEntityHasGravity(veh, true)

            if SetVehicleGravityAmount then

                SetVehicleGravityAmount(veh, 9.81)
            end
        end
    end
end

local activeZeroGravVehicles = {}

local function applyZeroGravToVehicle(veh)
    if not veh or veh == 0 or not DoesEntityExist(veh) or not IsEntityAVehicle(veh) then
        return
    end

    SetEntityHasGravity(veh, false)

    if SetVehicleGravityAmount then
        SetVehicleGravityAmount(veh, 0.0)
    end

    for seat = -1, GetVehicleModelNumberOfSeats(GetEntityModel(veh)) - 1 do
        local pedInSeat = GetPedInVehicleSeat(veh, seat)
        if pedInSeat ~= 0 then
            SetEntityHasGravity(pedInSeat, false)
        end
    end
end

local function restoreGravityToVehicle(veh)
    if not veh or veh == 0 or not DoesEntityExist(veh) or not IsEntityAVehicle(veh) then
        return
    end

    SetEntityHasGravity(veh, true)

    if SetVehicleGravityAmount then
        SetVehicleGravityAmount(veh, 9.81)
    end

    for seat = -1, GetVehicleModelNumberOfSeats(GetEntityModel(veh)) - 1 do
        local pedInSeat = GetPedInVehicleSeat(veh, seat)
        if pedInSeat ~= 0 then
            SetEntityHasGravity(pedInSeat, true)
        end
    end
end

RegisterNetEvent("admin:toggleDamageGrav", function(enabled)
    damageGravEnabled = enabled == true
end)

RegisterNetEvent("admin:damageGravDebug", function(msg)
    sx.logger:info(("[damagegrav] server debug: %s"):format(tostring(msg)))
end)

RegisterNetEvent("admin:damageGravResult", function(ok, reasonOrVictimId)
    if ok then
        sx.logger:info(("[damagegrav] aplicado na vitima serverId=%s"):format(tostring(reasonOrVictimId)))
    else
        sx.logger:warn(("[damagegrav] ignorado pelo server: %s"):format(tostring(reasonOrVictimId or "?")))
    end
end)

RegisterNetEvent("admin:damageGravVehicleReset", function()
    for networkId, _ in pairs(activeZeroGravVehicles) do
        local veh = NetworkGetEntityFromNetworkId(networkId)
        if veh and veh ~= 0 and DoesEntityExist(veh) then
            restoreGravityToVehicle(veh)
        end
        activeZeroGravVehicles[networkId] = nil
    end
end)

RegisterNetEvent("admin:damageGravHardReset", function()
    local myServerId = GetPlayerServerId(PlayerId())
    activeZeroGravPlayers[myServerId] = nil

    restoreGravityToPed(PlayerPedId())

    for networkId, _ in pairs(activeZeroGravVehicles) do

        local veh = NetworkGetEntityFromNetworkId(networkId)

        if veh and DoesEntityExist(veh) then

            restoreGravityToVehicle(veh)
        end

        activeZeroGravVehicles[networkId] = nil
    end
end)

AddEventHandler("gameEventTriggered", function(name, args)

    if not damageGravEnabled then
        return
    end

    if name ~= "CEventNetworkEntityDamage" then
        return
    end

    local victim = args[1]
    local attacker = args[2]
    local weaponHash = tonumber(args[7]) or args[7]

    if not attacker or attacker == -1 then
        return
    end

    local myPed = PlayerPedId()
    if attacker ~= myPed then
        return
    end

    -- if weaponHash ~= DAMAGEGRAV_WEAPON_HASH then
    --     return
    -- end

    if IsEntityAVehicle(victim) then
        local vehNet = VehToNet(victim)
        if vehNet and vehNet ~= 0 then
            TriggerServerEvent("admin:damageGravHitVehicle", vehNet, weaponHash)
        end
        return
    end

    if not IsEntityAPed(victim) or not IsPedAPlayer(victim) then
        return
    end

    local victimPlayerIndex = NetworkGetPlayerIndexFromPed(victim)
    if victimPlayerIndex == -1 then
        return
    end

    local victimServerId = GetPlayerServerId(victimPlayerIndex)
    if not victimServerId or victimServerId == 0 then
        return
    end

    TriggerServerEvent("admin:damageGravHitPlayer", victimServerId, weaponHash)
end)

AddStateBagChangeHandler("zeroGrav", nil, function(bagName, key, value, reserved, replicated)
    local prefix, serverIdStr = string.match(bagName, "^(player):(%d+)$")
    if prefix ~= "player" or not serverIdStr then
        return
    end

    local serverId = tonumber(serverIdStr)
    if not serverId then
        return
    end

    if not value then
        activeZeroGravPlayers[serverId] = nil
    end

    Wait(0)

    local playerIndex = GetPlayerFromServerId(serverId)
    if not playerIndex or playerIndex < 0 then
        return
    end

    local ped = GetPlayerPed(playerIndex)
    if not ped or ped == 0 or not DoesEntityExist(ped) then
        return
    end

    if value then
        activeZeroGravPlayers[serverId] = true
        applyZeroGravToPed(ped)
    else
        restoreGravityToPed(ped)
    end
end)

AddStateBagChangeHandler("zeroGravVehicle", nil, function(bagName, key, value, reserved, replicated)
    local networkId = tonumber(string.match(bagName, "entity:(%d+)"))
    if not networkId then
        return
    end

    Wait(0)

    local veh = NetworkGetEntityFromNetworkId(networkId)
    if not veh or veh == 0 or not DoesEntityExist(veh) then
        return
    end

    if value then
        activeZeroGravVehicles[networkId] = true
        applyZeroGravToVehicle(veh)
    else
        activeZeroGravVehicles[networkId] = nil
        restoreGravityToVehicle(veh)
    end
end)

CreateThread(function()
    while true do
        Wait(250)
        for networkId, _ in pairs(activeZeroGravVehicles) do
            local veh = NetworkGetEntityFromNetworkId(networkId)
            if veh and veh ~= 0 and DoesEntityExist(veh) then
                applyZeroGravToVehicle(veh)
            else
                activeZeroGravVehicles[networkId] = nil
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(250)
        for serverId, _ in pairs(activeZeroGravPlayers) do
            local playerIndex = GetPlayerFromServerId(serverId)
            if playerIndex and playerIndex >= 0 then
                local ped = GetPlayerPed(playerIndex)
                applyZeroGravToPed(ped)
            else
                activeZeroGravPlayers[serverId] = nil
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(500)
        local myServerId = GetPlayerServerId(PlayerId())
        local myState = Player(myServerId)["state"]
        if myState and myState["zeroGrav"] then
            applyZeroGravToPed(PlayerPedId())
        end
    end
end)

