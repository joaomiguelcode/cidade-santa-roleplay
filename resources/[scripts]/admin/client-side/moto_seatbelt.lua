local KNOCK_OFF_NEVER = eKnockOffVehicle and eKnockOffVehicle.NEVER or 1
local bikeThreadId = 0
local active = false
local seatbeltPending = false

local function isActive()
    return seatbeltPending or active
end

local function isOnBike(ped)
    return IsPedInAnyVehicle(ped, false) and IsPedOnAnyBike(ped)
end

local function restoreDefaultBikeBehavior(ped)
    if not ped or ped == 0 or not DoesEntityExist(ped) then
        return
    end

    if sx and sx.vehicles and sx.vehicles.GetKnockOffVehicleFlag then
        SetPedCanBeKnockedOffVehicle(ped, sx.vehicles.GetKnockOffVehicleFlag())
    else
        SetPedCanBeKnockedOffVehicle(ped, 0)
    end

    SetPedConfigFlag(ped, 32, true)
    SetPedConfigFlag(ped, 281, false)
    SetPedCanRagdoll(ped, true)
    SetPedCanRagdollFromPlayerImpact(ped, true)
    SetPedCanBeDraggedOut(ped, true)
end

local function applyMotoSeatbelt(ped)
    if not ped or ped == 0 or not DoesEntityExist(ped) or not isOnBike(ped) then
        return
    end

    SetPedCanBeKnockedOffVehicle(ped, KNOCK_OFF_NEVER)
    SetPedConfigFlag(ped, 32, false)
    SetPedConfigFlag(ped, 281, true)
    SetPedCanRagdoll(ped, false)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    SetPedCanBeDraggedOut(ped, false)
    SetPedStayInVehicleWhenJacked(ped, true)

    if IsPedRagdoll(ped) or IsPedGettingUp(ped) then
        ClearPedTasksImmediately(ped)
    end
end

local function stopBikeThread()
    bikeThreadId = bikeThreadId + 1
end

local function startBikeThread()
    stopBikeThread()

    local id = bikeThreadId

    CreateThread(function()
        while id == bikeThreadId and isActive() do
            local ped = PlayerPedId()

            if isOnBike(ped) then
                applyMotoSeatbelt(ped)
                Wait(0)
            else
                Wait(250)
            end
        end

        if id == bikeThreadId then
            restoreDefaultBikeBehavior(PlayerPedId())
        end
    end)
end

local function setActive(enabled)
    seatbeltPending = false
    active = enabled == true

    if not active then
        stopBikeThread()
        restoreDefaultBikeBehavior(PlayerPedId())
        return
    end

    applyMotoSeatbelt(PlayerPedId())
    startBikeThread()
end

local function applyAfterVehicleEnter()
    applyMotoSeatbelt(PlayerPedId())
    startBikeThread()

    CreateThread(function()
        for _, delay in ipairs({ 100, 100, 150, 250 }) do
            Wait(delay)

            if not isActive() then
                return
            end

            applyMotoSeatbelt(PlayerPedId())
        end
    end)
end

RegisterNetEvent("net.admin.motoSeatbelt:sync", function(enabled)
    setActive(enabled)
end)

RegisterNetEvent("net.admin.motoSeatbelt:requestToggle", function()
    local ped = PlayerPedId()

    if not isActive() then
        if not isOnBike(ped) then
            TriggerEvent("Notify2", "#motoSeatbeltNotOnBike")
            return
        end

        seatbeltPending = true
        applyMotoSeatbelt(ped)
        startBikeThread()
        TriggerServerEvent("net.admin.motoSeatbelt:set", true)
        TriggerEvent("sounds:Private", "belt", 0.5)
        return
    end

    seatbeltPending = false
    stopBikeThread()
    restoreDefaultBikeBehavior(ped)
    TriggerServerEvent("net.admin.motoSeatbelt:set", false)
    TriggerEvent("sounds:Private", "unbelt", 0.5)
end)

RegisterNetEvent("net.disable.motoseatbelt", function()
    setActive(false)
end)

AddEventHandler("gameEventTriggered", function(eventName, args)
    if not isActive() then
        return
    end

    if eventName == "CEventNetworkPlayerEnteredVehicle" then
        if tonumber(args[1]) ~= PlayerId() then
            return
        end

        applyAfterVehicleEnter()
        return
    end

    if eventName == "CEventNetworkEntityDamage" then
        local ped = PlayerPedId()

        if not isOnBike(ped) then
            return
        end

        applyMotoSeatbelt(ped)
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    seatbeltPending = false
    active = false
    stopBikeThread()
    restoreDefaultBikeBehavior(PlayerPedId())
end)
