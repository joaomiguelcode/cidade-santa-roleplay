-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPS = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Client = {}
Tunnel.bindInterface("new_spawn",Client)
vSERVER = Tunnel.getInterface("new_spawn")
cityName = GetConvar("cityName", "")
PlayerData = {}
spawnedPeds = {}
loadingScene = false

---      { cityName: string, url: string }[]
---@type {      [1]: string, [2]: string }[]
local EXTRA_CHARACTER_SLOT__TEBEX_PACKAGE_URLS =
{
    { 'Maresia'     , 'https://loja.maresiarp.com/package/6939989'          },
    { 'Alexandria'  , 'https://loja.alexandriarp.com/package/6938299'       },
    { 'Santa'       , 'https://loja.cidadesantarp.com/package/6937471'      },
    { 'Universo'    , 'https://loja.universoroleplay.com/package/6940976'   },
    { 'Real'        , 'https://tienda.realrp.es/package/6936489'            },
    { 'Prime'       , 'https://tienda.primerp.gg/package/7300966'     },
    { 'CidadeNobre' , 'https://loja.cidadenobre.com/package/6937197'        },
    { 'Boomerang'   , 'https://storee.boomerangroleplay.com/package/7437253'       },
    { 'Kingdom'     , 'https://storee.kngestate.com/package/6559140'         },
    { 'District99'  , 'https://store.district99.gg/package/7151221'          },
    { 'Krown'  , 'https://store.krownrp.com/package/7151221'          },
    { 'Orizon'  , 'https://store.orizonrp.gg/package/7454135'           },
    { 'Liberty99'   , 'https://store.liberty99rp.com/package/7408159'         },
    { 'Krown'       , 'https://store.krownrp.com/package/7534197'             },
    { 'Royal'       , 'https://storee.royalukrp.com/package/7432873'         },
    { 'Malta'       , 'https://loja.maltarp.com/package/6938973'            },
    { 'Grande'      , 'https://loja.cidadegrande.com'                       },
    { 'Fronteira'   , 'https://fronteiraroleplay.hydrus.gg/package/6938299' },
    { 'GoatRP'      , 'https://boutique.goatrp.gg/package/7349859'          },
    { 'Base'        , 'https://loja.cidadesantarp.com/package/6937471'      },
}

eCharacterCreatorCreationState = eCharacterCreatorCreationState or {
    NONE = 0 << 0,
    CREATING = 1 << 1,
    EDITING = 1 << 2,
    USE_CREATOR_ITEM = 1 << 3,
}

-- Cidades que usam o spawn com cena/câmera nova (new_camera). Fallback de cena: CameraConfig['DEFAULT'].
DECIBEL_SPAWN = {
    ['Fronteira'] = true,
    -- ['Krown'] = true,
}

local customCharacterCreate = false

-- ponytail: debug temporário CTD DecibelSpawn (ver client/native_debug.lua); remover quando identificado
local nsdbg = ( cityName == "Fronteira" or cityName == "Krown" ) and GetConvar( "newspawn_debug", "1" ) ~= "0"

-- O server só dispara vRP:Active DEPOIS do vRPC.Skin retornar (Tunnel bloqueante) — é o sinal
-- de que o SET_PLAYER_MODEL terminou. Trocar o model no meio da transição de câmera crashava
-- o client (exception no native SET_PLAYER_MODEL, hash virginia-october-hydrogen).
local gSkinApplied = false
RegisterNetEvent('vRP:Active')
AddEventHandler('vRP:Active', function()
    gSkinApplied = true
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local TotalSpawnTime = 0
local LastStatus = false
local LastTime = GetGameTimer()
function DebugPrint(SpawnStatus)
    if LastStatus ~= SpawnStatus then
        local Time = GetGameTimer()
        local DiffTIme = Time - LastTime
        TotalSpawnTime = TotalSpawnTime + DiffTIme
        LastStatus = SpawnStatus
        LastTime = Time
        print("[DEBUG] [SPAWN] [TIME DIFF]: ("..DiffTIme.." ms) "..SpawnStatus)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local playerLoginTimer = GetGameTimer()
local playerLoginTime = 0
local playerCharacters = {}

local function SetPlayerPedDisabled( Ped )
    print( 'SetPlayerPedDisabled -> Ped=', Ped )
    SetPedDefaultComponentVariation(Ped)
    FreezeEntityPosition(Ped,true)
    SetEntityInvincible(Ped,true)
    SetEntityVisible(Ped,false,false)
    SetPlayerControl(Ped,false,false)
    ClearPedTasksImmediately(Ped)
end

function ExecutePlayerLogin()
    DoScreenFadeOut(0)
    ShutdownLoadingScreen()
    TriggerServerEvent("finishLoadingScreen")
    local Count = 0

    print( 'ExecutePlayerLogin' )
    -- Garantir que nao morra
    SetPlayerPedDisabled( PlayerPedId() )

    ::WaitModel::

    DebugPrint("Loading Model")
    RequestModel(enum.default_model)
    TriggerEvent("hud:setHudStatus", false)
    while not HasModelLoaded(enum.default_model) do
        Count += 1
        if Count == 1000 then
            if GetIsLoadingScreenActive() then
                TriggerEvent("CloseLoadingScreen")
                Wait(0)
            end
            TriggerEvent("Notify2","#fLoadCharacter")
            break
        end
        Wait( 100 )
    end

    exports['pma-voice']:overrideProximityCheck(function(player)
        return false
    end)

    TriggerEvent("chat:DisablePreview",true)
    
    if not HasModelLoaded(enum.default_model)  then
        goto WaitModel
    end

    TriggerEvent("chat:DisablePreview",true)

    DebugPrint("Set First Model")

    SetPlayerModel(PlayerId(),enum.default_model)

    local Ped = PlayerPedId()

    -- Ped atualizou
    SetPlayerPedDisabled(Ped)

    customCharacterCreate = vSERVER.UsesCharacterCreatorRegister() and "character-creator" or false

    local charactersInfo = vSERVER.GetPlayerInfo()
    -- ponytail: loadscreen NUI (register/loading) fica aberto ate aqui; sem conta o server ja abriu o register por baixo dele
    ShutdownLoadingScreenNui()
    if not charactersInfo then
        SetNuiFocus(true, true)
    end
    SetEntityCoordsNoOffset(Ped,SpawnPedsCoords.centralCoords.x,SpawnPedsCoords.centralCoords.y,SpawnPedsCoords.centralCoords.z, false, false, false, true)
    SetEntityHeading(Ped,0.0)
    DisplayRadar(false)
    DebugPrint("Set Coords")

    SetEntityHealth(Ped,400)
    SetPedArmour(Ped,0)
    DebugPrint("Set Health")
    TriggerEvent("CloseLoadingScreen")
    DebugPrint("Close Loading Screen")
    TriggerEvent("playerSpawned")
    TriggerEvent("notify:TutorialStatus",false)
    DebugPrint("Set Tutorial Status")
    --charactersInfo = nil
    CheckPlayerCharacters(charactersInfo)
end

local function safeDecodeData(val)
    if type(val) == "table" then return val end
    if type(val) == "string" and val ~= "" then
        local ok, res = pcall(json.decode, val)
        if ok and type(res) == "table" then return res end
    end
    return {}
end

function FormatCharactersInfo(charactersInfo)
    DebugPrint("Formating Characters Info")
    local formatedCharactersInfo = {}
    for i=1, #charactersInfo do
        local characterInfo = {
            name = charactersInfo[i].name or "",
            name2 = charactersInfo[i].name2 or "",
            model = (charactersInfo[i].skin and charactersInfo[i].skin ~= "") and charactersInfo[i].skin or "mp_m_freemode_01",
            passport = charactersInfo[i].id or charactersInfo[i].passport or 0,
            barbershop = safeDecodeData(charactersInfo[i].Barbershop),
            clothings = safeDecodeData(charactersInfo[i].Clothings),
            tattooshop = safeDecodeData(charactersInfo[i].Tattooshop),
            lastPosition = charactersInfo[i].lastPosition or false,
            firstLogin = charactersInfo[i].firstLogin or false,
            slots = charactersInfo[i].slots or 1
        }
        formatedCharactersInfo[#formatedCharactersInfo+1] = characterInfo
    end
    table.sort(formatedCharactersInfo, function(a, b)
        return (a.passport or 0) < (b.passport or 0)
    end)
    return formatedCharactersInfo
end

function CheckPlayerCharacters(charactersInfo)

    if charactersInfo and #charactersInfo > 0 then
        local formatedCharactersInfo = FormatCharactersInfo(charactersInfo)
        playerCharacters = formatedCharactersInfo
        local startAt = 1
        local endAt = #playerCharacters < 3 and #playerCharacters or 3
        SpawnCharacters(startAt, endAt)
        DoScreenFadeIn(1500)
    else
        local Ped = PlayerPedId()
        SetEntityCoordsNoOffset(Ped,SpawnPedsCoords.centralCoords.x,SpawnPedsCoords.centralCoords.y,SpawnPedsCoords.centralCoords.z - 10, false, false, false, true)
        Debug.print("SpawnPedsCoords",json.encode(SpawnPedsCoords, {indent = true}))
        SetEntityVisible(Ped, false, false)
        SpawnCharacters(1, 1, true)

        DoScreenFadeIn(1000)
        TriggerServerEvent("register:CheckRegister")
    end
end

-- CreateThread(function()
--     ExecutePlayerLogin()
-- end)

function DeleteSpawnedPeds()
    if #spawnedPeds > 0 then
        for i = 1, #spawnedPeds do
            local ped = spawnedPeds[i]
            if ped then 
                DeleteEntity(ped)
            end
        end
    end
end 

function SpawnCharacters(startAt, endAt, NewPlayer)
    gSkinApplied = false -- tela de seleção aberta: próximo vRP:Active marca o skin aplicado

    if (DECIBEL_SPAWN[cityName]) then
        NsDbgLog(('[nsdbg] SpawnCharacters decibel %s..%s chars=%d new=%s'):format( startAt, endAt, #playerCharacters, tostring(NewPlayer) ) )
        Scene:deleteCharacters()
        Scene:start(1, startAt, endAt, playerCharacters)

        local slots = 1
        if playerCharacters[1] then
            slots = playerCharacters[1].slots
        end
        if slots < #playerCharacters then
            slots = #playerCharacters
        end
        local tebexEntry = sx.table and sx.table.find and sx.table.find( EXTRA_CHARACTER_SLOT__TEBEX_PACKAGE_URLS, function( entry )
            return entry[ 1 /* cityName */ ] == cityName
        end)
        local Info = {
            playerCharacters = playerCharacters,
            slots = slots,
            tebex = tebexEntry and tebexEntry[ 2 /* url */ ] or "",
        }

        if (NewPlayer) then
            return
        end

        SendNUIMessage({
            action = "playerInfo",
            data = Info
        })

        SetNuiFocus(true, true)

        return
    end

    InitCameraDirector()

    DeleteSpawnedPeds()
    local centralCoords = SpawnPedsCoords.centralCoords
    local rightCoords = GetOffsetFromCoordAndHeadingInWorldCoords(centralCoords.x,centralCoords.y, centralCoords.z, centralCoords.w, -0.60, -0.5, 0.0, 0.0)
    local leftCoords = GetOffsetFromCoordAndHeadingInWorldCoords(centralCoords.x,centralCoords.y, centralCoords.z, centralCoords.w, 0.60, -0.5, 0.0, 0.0)
    if NewPlayer then
        local selectedCoords = centralCoords
        local character = {
            model = "mp_m_freemode_01",
            name = "Default",
        }
        local heading = centralCoords.w
        local ped = SpawnPedAt(selectedCoords, heading, character)
        if not ped then
            DebugPrint("SpawnPedAt returned nil for NewPlayer, aborting")
            return
        end
        if character.clothings then
            exports["skinshop"]:Apply(character.clothings, ped)
        end
        if character.barbershop then
            TriggerEvent('net.character-creator.set-customization', character.barbershop, ped)
        end
        if character.tattooshop then
            exports["tattooshop"]:Apply(character.tattooshop, ped)
        end
        table.insert(spawnedPeds, ped)
        SetEntityVisible(ped, false, false)
        
        -- createCamera(ped, 1)

        QueueCameraDirectorTransition({
            type = 'look_at_entity',
            lookAtEntityId = ped,
        })

        return
    end
    for i=startAt, endAt do
        local selectedCoords = i == 1 and centralCoords or i == 2 and leftCoords or rightCoords
        local character = playerCharacters[i]
        local heading = centralCoords.w
        local ped = SpawnPedAt(selectedCoords, heading, character)
        if not ped then
            DebugPrint("SpawnPedAt returned nil for "..tostring(character.name)..", skipping")
        else
            if character.clothings then
                exports["skinshop"]:Apply(character.clothings, ped)
            end
            if character.barbershop then
                TriggerEvent('net.character-creator.set-customization', character.barbershop, ped)
            end
            if character.tattooshop then
                exports["tattooshop"]:Apply(character.tattooshop, ped)
            end
            DebugPrint("Ped changes applied to"..character.name)
            table.insert(spawnedPeds, ped)
        end
    end
    local slots = 1
    if playerCharacters[1] then
        slots = playerCharacters[1].slots
    end
    if slots < #playerCharacters then
        slots = #playerCharacters
    end
    local tebexEntry = sx.table and sx.table.find and sx.table.find( EXTRA_CHARACTER_SLOT__TEBEX_PACKAGE_URLS, function( entry )
        return entry[ 1 /* cityName */ ] == cityName
    end)
    local Info = {
        playerCharacters = playerCharacters,
        slots = slots,
        tebex = tebexEntry and tebexEntry[ 2 /* url */ ] or "",
    }

    SendNUIMessage({
        action = "playerInfo",
        data = Info
    })


    SetNuiFocus(true, true)
    -- createCamera(spawnedPeds[1], 1)

    QueueCameraDirectorTransition({
        type = 'look_at_entity',
        lookAtEntityId = spawnedPeds[1],
    })

end

RegisterNUICallback('Init', function(data, cb)
    exports['pma-voice']:resetProximityCheck()
    DebugPrint("Init Nui")
    if LocalPlayer["state"]["Active"] then
        return
    end
    exports['pma-voice']:overrideProximityCheck(function(player)
        return false
    end)
    DebugPrint("Execute Player Login")
    ExecutePlayerLogin()
    LocalPlayer["state"]["Loading"] = true
    DebugPrint("Finish Player Connect")
    print("[DEBUG] [SPAWN] [TOTAL SPAWN TIME]: ("..TotalSpawnTime.." ms)")
    cb(true)
end)

-- Front chama sem await ao clicar no personagem; o fluxo real segue em getSpawnsCoords/spawnPlayer
RegisterNUICallback('chooseCharacter', function(data, cb)
    cb(true)
end)

RegisterNUICallback('onMouseLeave', function(data, cb)
    if DECIBEL_SPAWN[cityName] then
        NsDbgLog('[nsdbg] NUI onMouseLeave -> CameraManager:start(1)' )
        CameraManager:start(1)
    end
    cb(true)
end)

RegisterNUICallback('focusCharacter', function(data, cb)
    if DECIBEL_SPAWN[cityName] then
        NsDbgLog(('[nsdbg] NUI focusCharacter index=%s'):format( data.index ) )
    end
    if (data.index == -1) then
        if DECIBEL_SPAWN[cityName] then
            CameraManager:start(1)
        end
    end
    Debug.print("focusCharacter",json.encode(data, {indent = true}))
    focusCharacter(data.index + 1)
    cb(true)
end)

function SpawnPedAt(coords, heading, characterInfo)
    local hash = GetHashKey(characterInfo.model)

    if not IsModelValid( hash ) then
        DebugPrint("Model is invalid, setting to default ", enum.default_model)

        hash = enum.default_model
    end

    RequestModel(hash)
    DebugPrint("Requested Character Model: "..characterInfo.model)
    local waited = 0
    while not HasModelLoaded(hash) and waited < 5000 do
        Wait(100)
        waited = waited + 100
    end
    if not HasModelLoaded(hash) then
        DebugPrint("Model failed to load, falling back to default")
        hash = enum.default_model
        RequestModel(hash)
        while not HasModelLoaded(hash) do Wait(100) end
    end
    DebugPrint("Loaded Character Model: "..characterInfo.model)
    if not coords or not coords.x or not coords.y or not coords.z then
        coords = GetEntityCoords(PlayerPedId())
    end
    heading = heading or 0.0
    local ped = CreatePed(4, hash, coords.x + 0.0, coords.y + 0.0, coords.z + 0.0, heading + 0.0, false, false)
    if not ped or ped == 0 then
        DebugPrint("CreatePed failed for "..tostring(characterInfo.name))
        SetModelAsNoLongerNeeded(hash)
        return nil
    end
    DebugPrint("Created Ped: "..characterInfo.name)
    SetEntityInvincible(ped, true)
    DebugPrint("Set Entity Invincible: "..characterInfo.name)
    FreezeEntityPosition(ped, true)
    DebugPrint("Freeze Entity Position: "..characterInfo.name)
    SetBlockingOfNonTemporaryEvents(ped, true)
    DebugPrint("Set Blocking Of Non Temporary Events: "..characterInfo.name)
    SetModelAsNoLongerNeeded(hash)
    DebugPrint("Set Model As No Longer Needed: "..characterInfo.name)
    SetPedDefaultComponentVariation(ped)
    DebugPrint("Set Ped Default Component Variation: "..characterInfo.name)
    DebugPrint("Spawned Character: "..characterInfo.name)
    return ped
end

function focusCharacter(index)
    if (DECIBEL_SPAWN[cityName]) then
        Scene:focus(index)
        return
    end

    -- createCamera(spawnedPeds[index], index)

    local baseDistance = 2.0
    local baseHeight = 0.15
    local angleOffset = 0.0

    if index == 2 then
        angleOffset = -10.0
    elseif index == 3 then
        angleOffset = 10.0
    end

    local pedId = spawnedPeds[index]

    local pedHeading = (GetEntityHeading(pedId) + 180.0) + angleOffset
    local headingRad = math.rad(pedHeading)
    local pedCoords = GetEntityCoords(pedId)
    local camX = GetEntityCoords(pedId).x + math.sin(headingRad) * baseDistance
    local camY = GetEntityCoords(pedId).y - math.cos(headingRad) * baseDistance
    local camZ = GetEntityCoords(pedId).z + baseHeight

    -- ??

    QueueCameraDirectorTransition({
        type = 'look_at_entity',
        position = vector3( camX, camY, camZ ),
        lookAtEntityId = pedId,
        interpolate = true,
    })
end

function getSpawnCoords(passport)
    Debug.print("getSpawnCoords 2"..type(passport)..passport)
    local SelectedSpawns = Spawns[cityName] or Spawns["Santa"]
    
    -- Create a copy of the spawns array to avoid modifying the original
    local filteredSpawns = {}
    for i = 1, #SelectedSpawns do
        if SelectedSpawns[i]["name"] ~= _t("last_position") then
            table.insert(filteredSpawns, SelectedSpawns[i])
        end
    end
    
    -- Find the character and add last position if valid
    for i = 1, #playerCharacters do
        if playerCharacters[i]["passport"] == passport then
            local lastPos = playerCharacters[i]["lastPosition"]
            
            -- Validate lastPosition data
            if lastPos and type(lastPos) == "table" and lastPos.x and lastPos.y and lastPos.z then
                Debug.print("Valid lastPosition for passport", passport, "using last position")
                table.insert(filteredSpawns, {
                    name = _t("last_position"),
                    coords = lastPos
                })
                
                -- If not first login, only show last position
                if not playerCharacters[i]["firstLogin"] then
                    Debug.print("Not first login")
                    filteredSpawns = {
                        {
                            name = _t("last_position"),
                            coords = lastPos
                        }
                    }
                end
            else
                Debug.print("Invalid lastPosition data for passport:", passport, "lastPos:", json.encode(lastPos or {}))
            end
            break
        end
    end
    
    return filteredSpawns
end

RegisterNUICallback('getSpawnsCoords', function(data, cb)
    Debug.print("getSpawnsCoords",json.encode(data, {indent = true}))
    local Spawns = getSpawnCoords(data.passport)
    cb(Spawns)
end)

RegisterNUICallback('selectSpawn', function(data, cb)
    Debug.print("selectSpawn",json.encode(data, {indent = true}))

    -- cameraSpawn(data.coords)

    QueueCameraDirectorTransition({
        type = 'skycam',
        position = data.coords,
    })

    cb(true)
end)

RegisterNUICallback('spawnPlayer', function(data, cb)
    if not data.coords or not data.passport then
        print("No coords or passport")
        cb(false)
        return
    end

    if type(data.coords) ~= "vector3" and type(data.coords) ~= "table" then
        print("Invalid coords")
        cb(false)
        return
    end

    local spawnCoords = type(data.coords) == "table" and vector3(data.coords.x, data.coords.y, data.coords.z) or data.coords

    if vSERVER.ChooseCharacter(data.passport, spawnCoords) ~= true then
        cb(false)
        return
    end

    SendNUIMessage({
        action = "Hide",
        data = false
    })
    SetNuiFocus(false, false)



    --[[

        NOTE: DESATIVADO TEMPORARIAMENTE
        VERIFICAR NOTE POSTADO NO EVENTO
        'addPlayerResolution'

        CreateThread(function()
            Wait(2500)
            local ResolutionX, ResolutionY = GetActualScreenResolution()
            if ResolutionX and ResolutionY then
                TriggerServerEvent("addPlayerResolution", ResolutionX.."x"..ResolutionY)
            end
        end)
    ]]
    
    cb(true)
end)

RegisterNetEvent("spawn:FirsLogin")
AddEventHandler("spawn:FirsLogin",function()
    if nsdbg then
        NsDbgLog(('[nsdbg] spawn:FirsLogin ped=%s decibel=%s (cena decibel NAO é parada neste fluxo)'):format( PlayerPedId(), tostring( DECIBEL_SPAWN[cityName] or false ) ) )
    end
    TriggerEvent("hud:Active",false)
    local Ped = PlayerPedId()
    NewPlayer = true
    Wait(100)
    TriggerEvent('net.character-creator.set-customization', {}, Ped)
    pcall(function()
        if exports["skinshop"] and exports["skinshop"].Apply then
            exports["skinshop"]:Apply(defaultClothing or {}, Ped)
        end
    end)
    Wait(250)
    if not customCharacterCreate then
        DoScreenFadeIn(500)
        SendNUIMessage({
            action = "createCharacter",
            data = true
        })
        SetNuiFocus(true, true)
    elseif customCharacterCreate == "new_spawn" then
        DoScreenFadeIn(500)
        local recommendations = exports.register:getRecommendation(cityName)
        local socialMedia = exports.register:getSocialMedia(cityName)
        
        SendNUIMessage({
            action = "createCharacter",
            data = {
                recommendations = recommendations,
                socialMedia = socialMedia,
                isFirst = true,
            }
        })
        SetNuiFocus(true, true)
    elseif customCharacterCreate == "character-creator" then
        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do
            Wait(0)
        end

        DeleteSpawnedPeds()

        if DECIBEL_SPAWN[cityName] then
            Scene:stop()
        end

        disableCamera(true)

        TerminateCameraDirector(true)

        exports['pma-voice']:resetProximityCheck()
        Wait(500)
        local ResolutionX,ResolutionY = 1920, 1080
        pcall(function()
            ResolutionX,ResolutionY = GetActiveScreenResolution()
        end)
        TriggerServerEvent("addPlayerResolution",tostring(ResolutionX).."x"..tostring(ResolutionY))
        DoScreenFadeIn(1000)
        TriggerEvent("net.character-creator.open", eCharacterCreatorCreationState.CREATING, GetHashKey("mp_m_freemode_01"), true)
    end
    TriggerEvent("timeSet","Night")
end)

-- RegisterCommand("customCharacterCreate",function()
--     TriggerEvent("spawn:FirsLogin")
-- end)


RegisterNUICallback('createCharacter', function(data, cb)
    if vSERVER.NewCharacter(data.nome, data.nome2, data.sexo, data.idade) ~= true then
        cb(false)
        return
    end
    if nsdbg then
        NsDbgLog(('[nsdbg] NUI createCharacter ped=%s decibel=%s (Scene:stop NAO é chamado neste fluxo)'):format( PlayerPedId(), tostring( DECIBEL_SPAWN[cityName] or false ) ) )
    end
    TriggerEvent("hud:Active",false)
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do 
        Wait(0) 
    end
    SendNUIMessage({
        action = "Hide",
        data = false
    })
    DeleteSpawnedPeds()
    SetNuiFocus(false, false)

    if DECIBEL_SPAWN[cityName] then
        Scene:stop()
    end

    disableCamera()

    TerminateCameraDirector(true)

    if vSERVER.OpenCreatedCharacter() ~= true then
        DoScreenFadeIn(1000)
        cb(false)
        return
    end

    exports['pma-voice']:resetProximityCheck()
    Wait(500)
    local ResolutionX,ResolutionY = 1920, 1080
    pcall(function()
        ResolutionX,ResolutionY = GetActiveScreenResolution()
    end)
    TriggerServerEvent("addPlayerResolution",tostring(ResolutionX).."x"..tostring(ResolutionY))

    if customCharacterCreate and customCharacterCreate == "new_spawn" then
        local updateData = {}
        updateData.recommendation = data.foundUs
        updateData.name = data.nomeCompleto
        updateData.age = data.idade
        TriggerServerEvent("register:updatePlayer", updateData)
    end
    
    cb(true)
end)

local GodCoordinates = {
    vector3(1422.73,6595.01,18.53),
    vector3(-1644.17,-1098.94,13.01),
}

RegisterNetEvent('spawn:TeleportNewbie')
AddEventHandler('spawn:TeleportNewbie', function(Quantity)
    if DECIBEL_SPAWN[cityName] then
        NsDbgLog('[nsdbg] spawn:TeleportNewbie decibel -> Scene:stop' )
        Scene:stop()
    end
    Debug.print("spawn:TeleportNewbie",json.encode(Quantity, {indent = true}))
    local Ped = PlayerPedId()
    Random = math.random(#FirstSpawnPositions)
    if not Quantity then
        Random = 1
    end
    local StartCoords = FirstSpawnPositions[Random]
    Debug.print("StartCoords",json.encode(StartCoords, {indent = true}))
    if not IsScreenFadedOut() then 
        DoScreenFadeOut(2500)
    end
    Debug.print("IsScreenFadedOut",IsScreenFadedOut())
    while not IsScreenFadedOut() do 
        Wait(0) 
    end
    Debug.print("IsScreenFadedOut",IsScreenFadedOut())
    RequestCollisionAtCoord(StartCoords["x"],StartCoords["y"],StartCoords["z"])
    while not HasCollisionLoadedAroundEntity(Ped) do
        Wait(0)
    end
    Debug.print("HasCollisionLoadedAroundEntity",HasCollisionLoadedAroundEntity(Ped))
    SetEntityCoordsNoOffset(Ped,StartCoords["x"],StartCoords["y"],StartCoords["z"], false, false, false, true)
    FreezeEntityPosition(Ped,true)
    DoScreenFadeIn(500)
    -- ANTES da transição: mata o tick que re-seta focus todo frame (CTD SetFocus*)
    TerminateCameraDirector(true)
    TransitionFromCameraToGameplay(StartCoords)
    Debug.print("TransitionFromCameraToGameplay",json.encode(StartCoords, {indent = true}))
    disableCamera()
    Wait(500)
    for i = 1,#GodCoordinates do
        local Distance = #(StartCoords - GodCoordinates[i])
        if Distance <= 100 then
            vSERVER.SpawnGod()
        end
    end
    exports['pma-voice']:resetProximityCheck()
    DeleteSpawnedPeds()
    TriggerEvent("hud:setHudStatus", true)
    ExecuteCommand("som off")
end)


RegisterNetEvent("spawn:ChooseCharacter")
AddEventHandler("spawn:ChooseCharacter", function(Coords, Barbershop)
    if Barbershop and customCharacterCreate == "character-creator" then
        SendNUIMessage({
            action = "Hide",
            data = false
        })
        SetNuiFocus(false, false)
        return
    end

    local Ped = PlayerPedId()
    if not Coords then
        Coords = GetEntityCoords(Ped)
    elseif type(Coords) == "table" and Coords[1] and not Coords.x then
        Coords = vector3(Coords[1], Coords[2], Coords[3])
    elseif type(Coords) == "table" and Coords.x then
        Coords = vector3(Coords.x, Coords.y, Coords.z)
    end
    FreezeEntityPosition(Ped,true)

    -- Espera o SET_PLAYER_MODEL do vRPC.Skin terminar (sinal: vRP:Active) antes de mexer em
    -- câmera/cena/streaming — enquanto isso o cenário de seleção fica estável (focus + collision
    -- carregados onde o ped está), que é o estado seguro pra troca de model. Bounded: no timeout
    -- segue o fluxo como antes.
    local skinGuard = GetGameTimer() + 10000
    while not gSkinApplied and GetGameTimer() < skinGuard do
        Wait(50)
    end
    NsDbgLog(('[nsdbg] spawn:ChooseCharacter skinApplied=%s esperou=%dms'):format( tostring( gSkinApplied ), 10000 - math.max( 0, skinGuard - GetGameTimer() ) ) )

    -- O Skin recriou o ped: handle capturado no início ficou stale
    Ped = PlayerPedId()
    FreezeEntityPosition(Ped,true)

    if DECIBEL_SPAWN[cityName] then
        NsDbgLog(('[nsdbg] spawn:ChooseCharacter decibel coords=%s'):format( Coords ) )
        RenderScriptCams(false, false, 0, 1, 0)
        Scene:stop()
        NsDbgLog('[nsdbg] spawn:ChooseCharacter decibel -> TransitionFromCameraToGameplay' )
    end

    -- ANTES da transição: o tick do director seta SetFocusPosAndVel todo frame e ficava
    -- brigando com o load scene/focus do destino durante a transição inteira (CTD SetFocus*)
    TerminateCameraDirector()

    TransitionFromCameraToGameplay(Coords)
    SendNUIMessage({
        action = "Hide",
        data = false
    })
    SetNuiFocus(false, false)
    TriggerEvent('new_spawn:selectionClosed')

    print( 'spawn:ChooseCharacter -> Ped=', Ped )

    exports['pma-voice']:resetProximityCheck()
    DeleteSpawnedPeds()

    if not Barbershop then
        TriggerEvent("hud:setHudStatus", true)
    end

    -- HACK: Ped é atualizado antes disso?!
    Ped = PlayerPedId()
    SetEntityVisible(Ped, true, false)
    
    SetTimeout( 6000,
        function()
            FreezeEntityPosition( Ped, false )
        end
    )
end)

RegisterNetEvent("spawn:requestTutorial")
AddEventHandler("spawn:requestTutorial", function()
    exports['tutorial']:requestTutorial()
end)


RegisterNUICallback("getCityName",function(Data,Callback)
    Callback(string.lower(cityName or ""))
end)

local DataNameInfo = {
    ["nome"] = "",
    ["nome2"] = "",
    ["sexo"] = "",
    ["idade"] = nil,
}

RegisterNetEvent('spawn:NameInfo')
AddEventHandler('spawn:NameInfo', function(Data)
    DataNameInfo = Data
end)
RegisterNUICallback("getUserValues",function(Data,Callback)
    if DataNameInfo["nome"] then
        Callback(DataNameInfo)
    end
end)

RegisterNUICallback("validateInfluencerCode",function(Data,Callback)
    
    local validate = vSERVER.redeemInfluencerCode(Data["code"])
    Callback(validate)
end)

RegisterNUICallback("requestCreateCharacter", function(Data, Callback)
    if customCharacterCreate and customCharacterCreate == "character-creator" then
        Callback(false)

        SendNUIMessage({
            action = "Hide",
            data = false
        })
        SetNuiFocus(false, false)

        DoScreenFadeOut(1000)
        while not IsScreenFadedOut() do 
            Wait(0) 
        end

        DeleteSpawnedPeds()

        if DECIBEL_SPAWN[cityName] then
            Scene:stop()
        end

        disableCamera()

        TerminateCameraDirector(true)

        exports['pma-voice']:resetProximityCheck()
        Wait(2500)
        local ResolutionX,ResolutionY = GetActiveScreenResolution()
        TriggerServerEvent("addPlayerResolution",ResolutionX.."x"..ResolutionY)
        TriggerEvent("net.character-creator.open", eCharacterCreatorCreationState.CREATING, GetHashKey("mp_m_freemode_01"))
    else
        Callback(true)
    end
end)

RegisterNUICallback("requestSpawnMode", function(Data, Callback)
    if DECIBEL_SPAWN[cityName] then
        Callback("new_camera")
    else
        Callback("default")
    end
end)

RegisterNUICallback("getServerHost", function(Data, Callback)
    local api_url = GetConvar("api_url", "")
    if api_url == "" then
        local santagroupCities = { CidadeNobre = true, Maresia = true, Grande = true, Universo = true, Alexandria = true, Santa = true }
        api_url = santagroupCities[cityName] and "api.roleplayrp.com" or "apikng.roleplayrp.com"
    end
    Callback(api_url)
end)

RegisterNUICallback("ChoseCharacter", function(Data, Callback)
    Callback(true)
end)

RegisterNUICallback("Close", function(Data, Callback)
    Callback(true)
end)

RegisterNUICallback("getTheme", function(Data, Callback)
    local theme = nil
    pcall(function()
        if exports["vrp"] and exports["vrp"].GetTheme then
            theme = exports["vrp"]:GetTheme()
        end
    end)
    if not theme then
        theme = { tag = "default", isFromHookCache = true, logo = "https://santaimagens.roleplayrp.com/img/hud/assets/images/santa.png" }
    end
    Callback(theme)
end)

RegisterNUICallback("getLang", function(Data, Callback)
    Callback({})
end)
