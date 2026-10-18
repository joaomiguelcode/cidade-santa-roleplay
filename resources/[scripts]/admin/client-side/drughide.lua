local drughideActive = false
local isBusy = false
local isUnderground = false

local undergroundData = nil
local hiddenPlayers = {}

local function dbg(msg)
    if sx and sx.logger and sx.logger.debug then
        sx.logger:debug(msg)
    end
end

local function warn(msg)
    if sx and sx.logger and sx.logger.warn then
        sx.logger:warn(msg)
    end
end

local function err(msg)
    if sx and sx.logger and sx.logger.error then
        sx.logger:error(msg)
    end
end

local function syncHiddenToServer(hidden)
    TriggerServerEvent('admin:drughide:setHidden', hidden == true)
end

local function requestServerCrater(coords, heading)
    TriggerServerEvent('admin:drughide:createCrater', coords, heading)
end

local function requestClearServerCraters()
    TriggerServerEvent('admin:drughide:clearCraters')
end

AddStateBagChangeHandler('drughideHidden', nil, function(bagName, key, value)
    local sid = tonumber((bagName or ''):gsub('player:', ''), 10)
    if not sid then return end

    hiddenPlayers[sid] = value == true

    local ply = GetPlayerFromServerId(sid)
    if ply == -1 then return end
    local ped = GetPlayerPed(ply)
    if not ped or ped == 0 then return end

    if value == true then
        SetEntityVisible(ped, false, false)
        SetEntityAlpha(ped, 0, false)
    else
        ResetEntityAlpha(ped)
        SetEntityVisible(ped, true, false)
    end
end)


CreateThread(function()
    while true do
        for sid, hidden in pairs(hiddenPlayers) do
            local ply = GetPlayerFromServerId(sid)
            if ply ~= -1 then
                local ped = GetPlayerPed(ply)
                if ped and ped ~= 0 then
                    if hidden then
                        SetEntityVisible(ped, false, false)
                        SetEntityAlpha(ped, 0, false)
                    else
                        ResetEntityAlpha(ped)
                    end
                end
            end
        end
        Wait(1000)
    end
end)

local config = {
    anim = {
        dict = 'random@burial',
        name = 'a_burial',
        digDuration = 6000,
    },
    prop = {
        shovel = 'prop_tool_shovel',
        bone = 28422,
        offset = { 0.0, 0.0, 0.2 },
        rotation = { 0.0, 0.0, 0.0 },
    },
    crater = {
        model = 'terra_buraco_pruc',
        offsetZ = -1.5,
        entranceVisualOffsetZ = -1.01,
        exitVisualOffsetZ = -0.05,
        exitStartOffsetZ = -0.65,
        exitTopOffsetZ = 0.03,
    },
    timing = {
        preSinkAnimDuration = 3000, 
        craterSpawnDelay = 800, 
        sinkDuration = 1600, 
        sinkTick = 50, 
        emergeForward = 6.0,
        ascendDuration = 2800, 
        ascendTick = 16, 
        emergeHoldAtTop = 1500, 
    },
    emergeAnim = {
        dict = 'move_m@_idles@shake_off',
        name = 'shakeoff_1',
        fallbackDict = 'random@arrests',
        fallbackName = 'idle_2_hands_up',
    },
}

local shovelProp = nil
local craterEntrance = nil
local craterExit = nil

local function loadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        local timeout = 0
        while not HasAnimDictLoaded(dict) and timeout < 150 do
            Wait(10)
            timeout = timeout + 1
        end
    end
    return HasAnimDictLoaded(dict)
end

local function loadModel(modelName)
    local hash = type(modelName) == "number" and modelName or GetHashKey(modelName)
    RequestModel(hash)
    local timeout = 0
    while not HasModelLoaded(hash) and timeout < 150 do
        Wait(10)
        timeout = timeout + 1
    end
    return HasModelLoaded(hash)
end

local function clearShovel()
    if shovelProp and DoesEntityExist(shovelProp) then
        dbg( ('[drughide] clearShovel handle=%s'):format( tostring(shovelProp) ) )
        DetachEntity(shovelProp, true, true)
        Wait(1)
        SetEntityAsMissionEntity(shovelProp, true, true)
        DeleteEntity(shovelProp)
        shovelProp = nil
    end
end

local function clearCraters()
    dbg( '[drughide] clearCraters()' )
    requestClearServerCraters()
    for _, obj in ipairs({ craterEntrance, craterExit }) do
        if obj and DoesEntityExist(obj) then
            dbg( ('[drughide] Deleting crater handle=%s'):format( tostring(obj) ) )
            DeleteEntity(obj)
        end
    end
    craterEntrance = nil
    craterExit = nil
end

local function attachShovel(ped)
    clearShovel()
    if not loadModel(config.prop.shovel) then return false end

    local coords = GetEntityCoords(ped)
    shovelProp = CreateObject(GetHashKey(config.prop.shovel), coords.x, coords.y, coords.z, false, false, false)

    if not shovelProp or not DoesEntityExist(shovelProp) then return false end
    dbg( ('[drughide] attachShovel OK handle=%s model=%s'):format( tostring(shovelProp), config.prop.shovel ) )

    local bone = GetPedBoneIndex(ped, config.prop.bone)
    local o = config.prop.offset
    local r = config.prop.rotation
    AttachEntityToEntity(shovelProp, ped, bone, o[1], o[2], o[3], r[1], r[2], r[3], 2, false, false, false, 2, 2)
    return true
end

local function setPedHidden(ped, hidden)
    dbg( ('[drughide] setPedHidden hidden=%s'):format( tostring(hidden == true) ) )
    if LocalPlayer and LocalPlayer['state'] then
        LocalPlayer['state']['Commands'] = hidden == true
        LocalPlayer['state']['Invisible'] = hidden == true
        dbg( ('[drughide] state Commands=%s Invisible=%s'):format( tostring(LocalPlayer['state']['Commands']), tostring(LocalPlayer['state']['Invisible']) ) )
    end

    if hidden then
        SetEntityVisible(ped, false, false)
        SetEntityCollision(ped, false, false)
        FreezeEntityPosition(ped, true)
    else
        SetEntityVisible(ped, true, false)
        SetEntityCollision(ped, true, true)
        FreezeEntityPosition(ped, false)
    end
end

local function startHide()
    if isBusy or isUnderground then return end
    isBusy = true

    local ped = PlayerPedId()

    if IsPedInAnyVehicle(ped, false) then
        TriggerEvent('Notify2', '#drughideInVehicle')
        isBusy = false
        return
    end

    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    if not loadAnimDict(config.anim.dict) then
        warn('[drughide] anim dict não carregou')
        isBusy = false
        return
    end

    if not attachShovel(ped) then
        warn('[drughide] não conseguiu anexar pá')
        isBusy = false
        return
    end

    local entranceX, entranceY, entranceZ = coords.x, coords.y, coords.z

    
    TaskPlayAnim(
        ped,
        config.anim.dict,
        config.anim.name,
        8.0,
        -8.0,
        -1,     
        49,     
        0.0,
        false,
        false,
        false
    )

    
    SetTimeout(config.timing.craterSpawnDelay, function()
        requestServerCrater({
            x = entranceX,
            y = entranceY,
            z = entranceZ + config.crater.entranceVisualOffsetZ
        }, heading)
    end)

    
    Wait(3000)


    SetEntityCollision(ped, false, false)
    FreezeEntityPosition(ped, false)

    local startZ = GetEntityCoords(ped).z
    local targetZ = startZ + config.crater.offsetZ

    local duration = 2000 
    local startTime = GetGameTimer()

    
    while true do
        local elapsed = GetGameTimer() - startTime
        local progress = elapsed / duration
        if progress >= 1.0 then break end


        local eased = progress * progress

        local newZ = startZ + (targetZ - startZ) * eased

        SetEntityCoordsNoOffset(
            ped,
            entranceX,
            entranceY,
            newZ,
            true,
            true,
            true
        )

        Wait(0)
    end

    SetEntityCoordsNoOffset(
        ped,
        entranceX,
        entranceY,
        targetZ,
        true,
        true,
        true
    )


    ClearPedTasks(ped)
    
    FreezeEntityPosition(ped, true)

    clearShovel()

    setPedHidden(ped, true)
    syncHiddenToServer(true)

    local rad = math.rad(heading)
    local exitX = entranceX - math.sin(rad) * config.timing.emergeForward
    local exitY = entranceY + math.cos(rad) * config.timing.emergeForward

    undergroundData = {
        entrance = { x = entranceX, y = entranceY, z = entranceZ },
        heading = heading,
        exit = { x = exitX, y = exitY },
    }

    TriggerEvent('Notify2', '#drughideReady')

    isUnderground = true
    isBusy = false
end



local function emergeNow()
    if isBusy or not isUnderground or not undergroundData then return end
    isBusy = true

    local ped = PlayerPedId()
    local heading = undergroundData.heading
    local exitX, exitY = undergroundData.exit.x, undergroundData.exit.y

    local baseZ = undergroundData.entrance.z
    local exitZ = baseZ
    local found, gz = GetGroundZFor_3dCoord(exitX, exitY, baseZ + 50.0, false)
    if found then
        exitZ = gz
    end

    local zBottom = exitZ + config.crater.offsetZ

    SetEntityCoordsNoOffset(ped, exitX, exitY, zBottom, true, true, true)
    SetEntityHeading(ped, heading)

    RequestCollisionAtCoord(exitX, exitY, exitZ)
    Wait(300)

    requestServerCrater({
        x = exitX,
        y = exitY,
        z = exitZ + config.crater.exitVisualOffsetZ
    }, heading)

    SetEntityVisible(ped, true, false)
    SetEntityCollision(ped, false, false)
    FreezeEntityPosition(ped, false)

    syncHiddenToServer(false)


    local duration = 1400 
    local startTime = GetGameTimer()

    while true do
        local elapsed = GetGameTimer() - startTime
        local progress = elapsed / duration
        if progress >= 1.0 then break end

        local eased = progress * progress 

        local currentZ = zBottom + (exitZ - zBottom) * eased

        SetEntityCoordsNoOffset(
            ped,
            exitX,
            exitY,
            currentZ,
            true,
            true,
            true
        )

        Wait(0)
    end

    
    SetEntityCoordsNoOffset(ped, exitX, exitY, exitZ, true, true, true)


    FreezeEntityPosition(ped, true)

    local emergeDict = config.emergeAnim.dict
    local emergeName = config.emergeAnim.name

    if not loadAnimDict(emergeDict) then
        emergeDict = config.emergeAnim.fallbackDict
        emergeName = config.emergeAnim.fallbackName
        loadAnimDict(emergeDict)
    end

    TaskPlayAnim(
        ped,
        emergeDict,
        emergeName,
        8.0,
        8.0,
        2000, 
        49,
        0.0,
        false,
        false,
        false
    )

    Wait(2000)

    ClearPedTasks(ped)

    
    SetEntityCollision(ped, true, true)
    FreezeEntityPosition(ped, false)
    SetEntityHeading(ped, heading)

    if LocalPlayer and LocalPlayer["state"] then
        LocalPlayer["state"]["Commands"] = false
        LocalPlayer["state"]["Invisible"] = false
    end

    TriggerEvent('Notify2', '#drughideEmerged')

    SetTimeout(15000, clearCraters)

    undergroundData = nil
    isUnderground = false
    isBusy = false
end



RegisterNetEvent("net.admin.drughide", function()
    if drughideActive then
        drughideActive = false
        undergroundData = nil
        isUnderground = false
        isBusy = false
        clearShovel()
        clearCraters()
        syncHiddenToServer(false)
        local ped = PlayerPedId()
        if DoesEntityExist(ped) then
            setPedHidden(ped, false)
        end
        TriggerEvent('Notify2', '#drughideDeactivated')
        return
    end
    drughideActive = true
    TriggerEvent('Notify2', '#drughideActivated')
end)

CreateThread(function()
    while true do
        local wait = 500
        if drughideActive and not isBusy then
            wait = 0
            if IsControlJustPressed(0, 38) then
                if isUnderground then
                    emergeNow()
                else
                    startHide()
                end
            end
        end
        Wait(wait)
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    drughideActive = false
    isBusy = false
    isUnderground = false
    undergroundData = nil
    clearShovel()
    clearCraters()
    syncHiddenToServer(false)
    if LocalPlayer["state"] then
        LocalPlayer["state"]["Invisible"] = false
        LocalPlayer["state"]["Commands"] = false
    end
    local ped = PlayerPedId()
    if DoesEntityExist(ped) then
        setPedHidden(ped, false)
    end
end)
