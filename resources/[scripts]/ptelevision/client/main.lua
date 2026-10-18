DEFAULT_URL = "https://cfx-nui-ptelevision/html/index.html"
duiUrl = DEFAULT_URL
duiObj = nil
tvObj = nil
gGlobalVolume = 0.5
CURRENT_SCREEN = nil

local Locations = Config.Locations
local whitelistTelevisions = {}

local TELEVISION_INTERACT_DISTANCE = 5.5
local TELEVISION_INTERACT_HEIGHT_TOLERANCE = 20.0
local TELEVISION_INTERACT_COOLDOWN_MS = 2500
local TELEVISION_SCAN_INTERVAL_MS = 250
local TELEVISION_SCREEN_SCAN_INTERVAL_MS = 2500
local TELEVISION_ACTIVE_SCREEN_CHECK_MS = 500

local gLockedInteractTelevision = nil
local gLastTelevisionInteractAt = 0
local gLastTelevisionScanAt = 0
local gLastScreenScanAt = 0
local gLastActiveScreenCheckAt = 0

function getDuiURL()
	return duiUrl
end

function SetVolume(coords, num)
    gGlobalVolume = num 
    SetTelevisionLocal(coords, "volume", num)
end

function isCoordsWhitelisted(coords)
    for i=1, #whitelistTelevisions do
        local whitelist = whitelistTelevisions[i]
        if #(coords - v3(whitelist.coords)) < whitelist.range then
            return true
        end
    end
    return false
end

function addWhitelistTelevision(coords, range)
    table.insert(whitelistTelevisions, {coords = coords, range = range})
end

function removeWhitelistTelevision(coords)
    for i=1, #whitelistTelevisions do
        local whitelist = whitelistTelevisions[i]
        if #(coords - v3(whitelist.coords)) < whitelist.range then
            table.remove(whitelistTelevisions, i)
        end
    end
end

local function ComputeVolumeFalloff( volume, dist, range )
    local rem = tonumber((dist / range))
    volume = tonumber(volume)
    rem = rem > volume and volume or rem
    local _vol = math.floor((volume - rem) * 100)
    return _vol
end

function GetVolume(coords, dist, range)

    local index, data = GetTelevisionLocal(coords)

    if index then

        local volume = data['volume']

        if volume then

            return ComputeVolumeFalloff( volume, dist, range )
        end
    end

    return ComputeVolumeFalloff( gGlobalVolume, dist, range )
end

function setDuiURL(url)
	duiUrl = url
	SetDuiUrl(duiObj, duiUrl)
end

local sfName = 'generic_texture_renderer'

local width = 1280
local height = 720

local sfHandle = nil
local txdHasBeenSet = false


function loadScaleform(scaleform)
    local scaleformHandle = RequestScaleformMovie(scaleform)

    while not HasScaleformMovieLoaded(scaleformHandle) do 
        scaleformHandle = RequestScaleformMovie(scaleform)
        Citizen.Wait(0) 
    end
    return scaleformHandle
end

function ShowScreen(data)
    CURRENT_SCREEN = data
    sfHandle = loadScaleform(sfName)
    runtimeTxd = 'ptelevision_b_dict'

    local txd = CreateRuntimeTxd('ptelevision_b_dict')
    duiObj = CreateDui(duiUrl, width, height)
    local dui = GetDuiHandle(duiObj)
    local tx = CreateRuntimeTextureFromDuiHandle(txd, 'ptelevision_b_txd', dui)
    
    Citizen.Wait(10)

    PushScaleformMovieFunction(sfHandle, 'SET_TEXTURE')

    PushScaleformMovieMethodParameterString('ptelevision_b_dict')
    PushScaleformMovieMethodParameterString('ptelevision_b_txd')

    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(width)
    PushScaleformMovieFunctionParameterInt(height)

    PopScaleformMovieFunctionVoid()
    Citizen.CreateThread(function()
        TriggerServerEvent("ptelevision:requestSync", data.coords)
        local tvObj = data.entity
        local screenModel = Config.Models[data.model]
        while duiObj do
            if (tvObj and sfHandle ~= nil and HasScaleformMovieLoaded(sfHandle)) then
                local pos = GetEntityCoords(tvObj)
                local scale = screenModel.Scale
                local scaleX = screenModel.ScaleX or scale
                local scaleY = screenModel.ScaleY or (scale * (9 / 16))
                local offset = GetOffsetFromEntityInWorldCoords(tvObj, screenModel.Offset.x, screenModel.Offset.y, screenModel.Offset.z)
                local rotation = screenModel.rotation or 0
                if (screenModel.Target) then 
                    local id = CreateNamedRenderTargetForModel(screenModel.Target, data.model)
                    if (id ~= -1) then
                        RenderScaleformTV(id, sfHandle, tvObj)
                    end
                else
                    local hz = GetEntityHeading(tvObj)
                    DrawScaleformMovie_3dSolid(sfHandle, offset, 0.0, 0.0, -hz + rotation, 2.0, 2.0, 2.0, scaleX, scaleY, 2)
                end
            end
            Citizen.Wait(0)
        end
    end)
    Citizen.CreateThread(function()
        local screen = CURRENT_SCREEN
        local modelData = Config.Models[screen.model]
        local coords = screen.coords
        local range = modelData.Range
        local _, lstatus = GetTelevisionLocal(coords)
        if (lstatus and lstatus.volume) then 
            SetVolume(coords, lstatus.volume)
        else
            SetVolume(coords, modelData.DefaultVolume)
        end
        while duiObj do 
            local pcoords = GetEntityCoords(PlayerPedId())
            local dist = #(coords - pcoords)
            SendDuiMessage(duiObj, json.encode({
                setVolume = true,
                data = GetVolume(coords, dist, range)
            }))
            Citizen.Wait(100)
        end
    end)
end

function HideScreen()
    CURRENT_SCREEN = nil
    if (duiObj) then 
        DestroyDui(duiObj)
        SetScaleformMovieAsNoLongerNeeded(sfHandle)
        duiObj = nil
        sfHandle = nil 
    end
end

--- Fração 0–1 no eixo Z do bbox do modelo (`GetModelDimensions`); 0.5 = meio na altura.
local TELEVISION_POSITION_CENTER_Z_OFFSET = 0.09
local televisionInteractLzByModel = {}

local function getTelevisionInteractLocalZ(model)
    local lz = televisionInteractLzByModel[model]
    if lz then
        return lz
    end

    local minDim, maxDim = GetModelDimensions(model)
    
    lz = minDim.z + (maxDim.z - minDim.z) * TELEVISION_POSITION_CENTER_Z_OFFSET
    televisionInteractLzByModel[model] = lz
    
    return lz
end

function ConvertInteractionCoords(object, coords, model)
    local heading = GetEntityHeading(object)
    local customCoords = GetOffsetFromCoordAndHeadingInWorldCoords(coords.x,coords.y, coords.z, heading, 0.0, -3.0, 0.0, 0.0)

    local lz = getTelevisionInteractLocalZ(model)
    local interactionZ = GetOffsetFromEntityInWorldCoords(object, 0.0, 0.0, lz).z

    return vec3(customCoords.x, customCoords.y, interactionZ)
end

local function getTelevisionInteractDistance(playerCoords, targetCoords)
    local horizontalDist = #(vec2(playerCoords.x, playerCoords.y) - vec2(targetCoords.x, targetCoords.y))
    local verticalDist = math.abs(playerCoords.z - targetCoords.z)

    return horizontalDist, verticalDist
end

local function isWithinTelevisionInteractRange(playerCoords, targetCoords)
    local horizontalDist, verticalDist = getTelevisionInteractDistance(playerCoords, targetCoords)

    return horizontalDist <= TELEVISION_INTERACT_DISTANCE and verticalDist <= TELEVISION_INTERACT_HEIGHT_TOLERANCE
end

local function scanTelevisionObjects(playerCoords, scanScreen)
    local objPool = GetGamePool('CObject')
    local closestInteract = nil
    local closestScreen = nil
    local closestScreenDist = -1

    for i = 1, #objPool do
        local entity = objPool[i]
        local model = GetEntityModel(entity)
        local modelData = Config.Models[model]

        if modelData then
            local coords = GetEntityCoords(entity)
            local entityDist = #(playerCoords - coords)
            local interactCoords = ConvertInteractionCoords(entity, coords, model)
            local horizontalDist = select(1, getTelevisionInteractDistance(playerCoords, interactCoords))

            if isWithinTelevisionInteractRange(playerCoords, interactCoords) and (not closestInteract or horizontalDist < closestInteract.dist) then
                closestInteract = {
                    dist = horizontalDist,
                    coords = coords,
                    model = model,
                    entity = entity,
                    range = modelData.Range,
                }
            end

            if scanScreen and entityDist < modelData.Range and isCoordsWhitelisted(coords) then
                if entityDist < closestScreenDist or closestScreenDist < 0 then
                    closestScreenDist = entityDist
                    closestScreen = {
                        dist = entityDist,
                        coords = coords,
                        model = model,
                        entity = entity,
                    }
                end
            end
        end
    end

    return closestInteract, closestScreen
end

local function refreshLockedInteractTelevision(playerCoords)
    local locked = gLockedInteractTelevision

    if not locked then
        return nil
    end

    if not DoesEntityExist(locked.entity) then
        gLockedInteractTelevision = nil
        TriggerEvent("hoverfy:removeHoverfy")
        return nil
    end

    local coords = GetEntityCoords(locked.entity)
    local interactCoords = ConvertInteractionCoords(locked.entity, coords, locked.model)
    local horizontalDist = select(1, getTelevisionInteractDistance(playerCoords, interactCoords))

    if not isWithinTelevisionInteractRange(playerCoords, interactCoords) then
        gLockedInteractTelevision = nil
        TriggerEvent("hoverfy:removeHoverfy")
        return nil
    end

    locked.coords = coords
    locked.dist = horizontalDist

    return locked
end

local function updateTelevisionHoverfy(television)
    if not television then
        TriggerEvent("hoverfy:toggle", false)
        return
    end

    local whitelisted = isCoordsWhitelisted(television.coords)

    TriggerEvent("hoverfy:toggle", true, {
        title = whitelisted and _t("stop_television") or _t("start_television"),
        key = "E",
        legend = whitelisted and _t("to_stop_television") or _t("to_start_television"),
    })
end

local function tickTelevisionInteract(television)
    if GetFrameCount() % 100 == 0 then
        updateTelevisionHoverfy(television)
    end

    if IsControlJustPressed(0, 38) or IsDisabledControlJustPressed(0, 38) then
        local now = GetGameTimer()

        if now - gLastTelevisionInteractAt >= TELEVISION_INTERACT_COOLDOWN_MS then
            gLastTelevisionInteractAt = now

            if isCoordsWhitelisted(television.coords) then
                HideScreen()
                removeWhitelistTelevision(television.coords)
            else
                addWhitelistTelevision(television.coords, television.range)
                gLastScreenScanAt = 0
            end

            updateTelevisionHoverfy(television)
        end
    end
end

local function tickActiveScreen(playerCoords)
    if not duiObj or not CURRENT_SCREEN then
        return
    end

    local screen = CURRENT_SCREEN
    local modelData = Config.Models[screen.model]

    if not modelData then
        HideScreen()
        return
    end

    local coords = screen.coords
    local entity = screen.entity

    if entity and DoesEntityExist(entity) then
        coords = GetEntityCoords(entity)
        screen.coords = coords
    end

    local dist = #(playerCoords - coords)

    if dist >= modelData.Range or not isCoordsWhitelisted(coords) then
        HideScreen()
    end
end

CreateThread(function()
    Wait(2000)
    TriggerServerEvent("ptelevision:requestUpdate")

    while true do
        local wait = TELEVISION_SCAN_INTERVAL_MS

        if LocalPlayer["state"]["Route"] < 900000 then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local now = GetGameTimer()
            local lockedTelevision = refreshLockedInteractTelevision(playerCoords)

            if lockedTelevision then
                wait = 0
                tickTelevisionInteract(lockedTelevision)
            end

            local needsInteractScan = not lockedTelevision and now - gLastTelevisionScanAt >= TELEVISION_SCAN_INTERVAL_MS
            local needsScreenScan = not duiObj and #whitelistTelevisions > 0 and now - gLastScreenScanAt >= TELEVISION_SCREEN_SCAN_INTERVAL_MS

            if needsInteractScan or needsScreenScan then
                local closestInteract, closestScreen = scanTelevisionObjects(playerCoords, needsScreenScan)

                if needsInteractScan then
                    gLastTelevisionScanAt = now

                    if closestInteract then
                        gLockedInteractTelevision = closestInteract
                        wait = 0
                        tickTelevisionInteract(closestInteract)
                    end
                end

                if needsScreenScan then
                    gLastScreenScanAt = now

                    if closestScreen then
                        ShowScreen(closestScreen)
                    end
                end
            end

            if duiObj and now - gLastActiveScreenCheckAt >= TELEVISION_ACTIVE_SCREEN_CHECK_MS then
                gLastActiveScreenCheckAt = now
                tickActiveScreen(playerCoords)
            end
        elseif gLockedInteractTelevision then
            gLockedInteractTelevision = nil
            TriggerEvent("hoverfy:removeHoverfy")
        end

        Wait(wait)
    end
end)

Citizen.CreateThread(function()
    while true do 
        local wait = 2500
        for i=1, #Locations do 
            local data = Locations[i]
            local dist = #(GetEntityCoords(PlayerPedId()) - v3(data.Position)) 
            if not Locations[i].obj and dist < 20.0 then 
                LoadModel(data.Model)
                Locations[i].obj = CreateObject(data.Model, data.Position.x, data.Position.y, data.Position.z)
                SetEntityHeading(Locations[i].obj, data.Position.w)
                FreezeEntityPosition(Locations[i].obj, true)
            elseif Locations[i].obj and dist > 20.0 then
                DeleteEntity(Locations[i].obj)
                Locations[i].obj = nil
            end
        end
        Citizen.Wait(wait)
    end
end)

RegisterNetEvent("ptelevision:requestUpdate", function(data)
    Televisions = data.Televisions
    Channels = data.Channels
end)

RegisterNetEvent("ptelevision:requestSync", function(coords, data)
    local tvObj = data.entity
        
    local _, status = GetTelevision(coords)
    local screenModel = Config.Models[data.model]
    if status and status["ptv_status"] then
        local update_time = data.update_time or data.current_time
        local status = status["ptv_status"]
        Citizen.Wait(1000)
        if status.type == "play" then
            if (status.channel and Channels[status.channel]) then 
                PlayVideo({url = Channels[status.channel].url, channel = status.channel})
            elseif (status.url) then
                local time = math.floor(data.current_time - update_time)
                PlayVideo({url = status.url, time = time})
            end
        elseif (status.type == "browser") then 
            PlayBrowser({ url = status.url })
        end
    end
end)



RegisterNUICallback("pageLoaded", function(_,cb)
    waitForLoad = false
    if cb then cb() end
end)

AddEventHandler('onResourceStop', function(name)
    if name == GetCurrentResourceName() then
        gLockedInteractTelevision = nil
        TriggerEvent("hoverfy:removeHoverfy")
        HideScreen()
        for i=1, #Locations do 
            DeleteEntity(Locations[i].obj)
        end
    end
end)


RegisterNetEvent('net:routing_bucket_changed', function()
    Wait(1000)

    gLockedInteractTelevision = nil
    TriggerEvent("hoverfy:removeHoverfy")
    HideScreen()

    print("^2[ptelevision] Bucket changed, requesting update")
    TriggerServerEvent("ptelevision:requestUpdate")
end)
