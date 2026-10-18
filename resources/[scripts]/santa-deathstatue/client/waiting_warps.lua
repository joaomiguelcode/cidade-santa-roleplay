local waitingWarpBlips = {}
local waitingWarpCooldownUntil = 0
local waitingWarpsActive = false

local function canUseWaitingWarps()
    return gameStarted == true and roundFinished == true
end

local function drawWaitingWarpText(x, y, z, text)
    local onScreen, screenX, screenY = World3dToScreen2d(x, y, z)
    if not onScreen then
        return
    end

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(true)
    SetTextColour(255, 255, 255, 215)
    SetTextOutline()
    SetTextCentre(true)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(screenX, screenY)
end

local function drawWaitingWarpMarker(x, y, z)
    local marker = Config.WaitingSideWarps and Config.WaitingSideWarps.Marker
    local scale = marker and marker.scale or vector3(1.0, 1.0, 0.45)
    local color = marker and marker.color or { r = 255, g = 255, b = 255, a = 140 }

    DrawMarker(
        marker and marker.type or 1,
        x, y, z - 0.95,
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        scale.x, scale.y, scale.z,
        color.r or 255, color.g or 255, color.b or 255, color.a or 140,
        marker and marker.bobUpAndDown == true,
        marker and marker.faceCamera == true,
        2,
        marker and marker.rotate == true,
        nil, nil, false
    )
end

local function clearWaitingWarpBlips()
    for i = 1, #waitingWarpBlips do
        local blip = waitingWarpBlips[i]
        if blip and DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    waitingWarpBlips = {}
end

local function createWaitingWarpBlips()
    if #waitingWarpBlips > 0 then
        return
    end

    local cfg = Config.WaitingSideWarps
    local points = cfg and cfg.Points
    if not points or #points == 0 then
        return
    end

    local blipCfg = cfg.Blip or {}
    local label = _t("waiting_side_warp_label")

    for i = 1, #points do
        local point = points[i]
        local coords = point.coords
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, blipCfg.sprite or 36)
        SetBlipColour(blip, blipCfg.color or 3)
        SetBlipScale(blip, blipCfg.scale or 0.75)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(label)
        EndTextCommandSetBlipName(blip)
        waitingWarpBlips[#waitingWarpBlips + 1] = blip
    end
end

local function setWaitingWarpsActive(active)
    if waitingWarpsActive == active then
        return
    end

    waitingWarpsActive = active
    if active then
        createWaitingWarpBlips()
    else
        clearWaitingWarpBlips()
    end
end

local function tryUseWaitingWarp(destination)
    local now = GetGameTimer()
    local remainingMs = waitingWarpCooldownUntil - now
    if remainingMs > 0 then
        local remainingSecs = math.max(1, math.ceil(remainingMs / 1000))
        TriggerEvent("Notify2", "#deathstatueSideWarpCooldown", { secs = remainingSecs })
        return
    end

    local cooldownSecs = (Config.WaitingSideWarps and Config.WaitingSideWarps.CooldownSecs) or 15
    waitingWarpCooldownUntil = now + (cooldownSecs * 1000)

    local ped = PlayerPedId()
    DoScreenFadeOut(250)
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end

    SetEntityCoords(ped, destination.x, destination.y, destination.z, false, false, false, false)
    SetEntityHeading(ped, destination.w or 0.0)
    ClearPedTasksImmediately(ped)

    Citizen.Wait(200)
    DoScreenFadeIn(250)
end

Citizen.CreateThread(function()
    while true do
        local active = canUseWaitingWarps()
        setWaitingWarpsActive(active)

        if not active then
            Citizen.Wait(500)
        else
            local cfg = Config.WaitingSideWarps
            local points = cfg and cfg.Points
            if not points or #points == 0 then
                Citizen.Wait(1000)
            else
                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                local drawDist = tonumber(cfg.DrawDist) or 12.0
                local interactDist = tonumber(cfg.InteractDist) or 1.8
                local label = _t("waiting_side_warp_label")
                local nearest = nil
                local nearestDist = interactDist
                local sleep = 500

                for i = 1, #points do
                    local point = points[i]
                    local pointCoords = point.coords
                    local dist = #(coords - vector3(pointCoords.x, pointCoords.y, pointCoords.z))
                    if dist <= drawDist then
                        sleep = 0
                        drawWaitingWarpMarker(pointCoords.x, pointCoords.y, pointCoords.z)
                        drawWaitingWarpText(pointCoords.x, pointCoords.y, pointCoords.z + 0.45, label)
                        if dist < nearestDist then
                            nearest = point
                            nearestDist = dist
                        end
                    end
                end

                if nearest and IsControlJustReleased(0, 38) then
                    tryUseWaitingWarp(nearest.destination)
                end

                Citizen.Wait(sleep)
            end
        end
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end
    clearWaitingWarpBlips()
end)
