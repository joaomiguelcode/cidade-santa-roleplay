local cam = nil
local lastCam = nil

---starts the animation again
---@param ped any
function pedAnimations(ped)
    TaskStartScenarioInPlace(ped, Animation, 0, true)
end

---@param ped any
---@param index number Optional parameter to specify which character is focused (1=center, 2=left, 3=right)
function createCamera(ped, index)
    -- Local Variables
    local baseDistance = 2.0
    local baseHeight = 0.15
    local angleOffset = 0.0
    if cam and DoesCamExist(cam) then
        lastCam = cam
    end

    if index == 2 then
        angleOffset = -10.0
    elseif index == 3 then
        angleOffset = 10.0
    end

    local pedHeading = (GetEntityHeading(ped) + 180.0) + angleOffset
    local headingRad = math.rad(pedHeading)
    local pedCoords = GetEntityCoords(ped)
    local camX = GetEntityCoords(ped).x + math.sin(headingRad) * baseDistance
    local camY = GetEntityCoords(ped).y - math.cos(headingRad) * baseDistance
    local camZ = GetEntityCoords(ped).z + baseHeight

    cam = CreateCamWithParams(
        "DEFAULT_SCRIPTED_CAMERA",
        camX, camY, camZ,
        2.5, 0.0, pedHeading,
        CameraFoV,
        false,
        0
    )
    if lastCam then
        SetCamActiveWithInterp(cam, lastCam, 1000, 1, 1)
        Citizen.SetTimeout(1100, function()
            if lastCam then
                if DoesCamExist(lastCam) then
                    DestroyCam(lastCam, false)
                end
                lastCam = nil
            end
        end)
    else
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    end

    ShakeCam(cam, ShakeType, CameraShake)

    cameraDoF(cam)
end

---applies the camera dof
---@param cam any
function cameraDoF(cam)
    SetCamUseShallowDofMode(cam, true)
    SetCamNearDof(cam, CameraNearDof)
    SetCamFarDof(cam, CameraFarDof)
    SetCamDofStrength(cam, CameraDofStrength)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
end

---disables the camera
---@param cam any
---@param notFreeze boolean
function disableCamera(notFreeze)
    if cam then
        SetCamActive(cam, false)
        RenderScriptCams(false, false, 1, true, true)
        if not notFreeze then
            FreezeEntityPosition(PlayerPedId(), false)
            ClearPedTasksImmediately(PlayerPedId())
        end
        if DoesCamExist(cam) then
            DestroyCam(cam, false)
        end
        cam = nil
    end
    ClearFocus()
end

RegisterCommand("testcam", function()
    local ped = PlayerPedId() -- Creates a variable called ped and sets it to the player's ped
    if cam then
        disableCamera()
        return
    end
    pedAnimations(ped) -- Calls the pedAnimations function and passes the ped variable as an argument
    createCamera(ped) -- Calls the createCamera function and passes the ped variable as an argument
end)

---@type boolean
local gIsCameraDirectorInitialized = false

---@type TickAbortSignal | nil
local gCameraDirectorUpdateAbortSignal = nil

---@alias CameraDirectorTransitionType 'skycam' | 'look_at_entity'

---@class BaseCameraDirectorTransition
---@field type CameraDirectorTransitionType
---@field interpolate boolean
---@field position? vector3
---@field idleFor? number
---@field fadeWhileTransitioning boolean

---@class CameraDirectorTransitionSkyCam : BaseCameraDirectorTransition
---@field type 'skycam'
---@field position vector3
--@field waitInterpolationBeforeComplete? boolean

---@class CameraDirectorTransitionLookAtEntity : BaseCameraDirectorTransition
---@field type 'look_at_entity'
---@field lookAtEntityId number

---@class CameraDirectorTransitionOptions
---@field type?             CameraDirectorTransitionType
---@field position?         vector3
---@field lookAtEntityId?   number
---@field interpolate?      boolean

---@type BaseCameraDirectorTransition[] | nil
local gCameraDirectorTransitionQueue = nil

---@enum eCameraDirectorState
eCameraDirectorState =
{
    IDLE = 'idle',

    TRANSITION_STARTING           = 'transition_load_scene',
    TRANSITION_SETUP_CAMERA = 'transition_setup_camera',
    TRANSITION_WAITING_SCENE_LOAD   = 'transition_waiting_scene_load',
    TRANSITION_WAITING_INTERPOLATION_END   = 'transition_waiting_interpolation_end',
    TRANSITION_COMPLETE             = 'transition_complete',
}

---@type eCameraDirectorState
local gCameraDirectorState = eCameraDirectorState.IDLE
local gCameraDirectorStateSetAt = GetGameTimer()

---@type number | nil
local gCameraDirectorCameraId = nil

---@type BaseCameraDirectorTransition | nil
local gCameraDirectorTransitionCurrent = nil

---@param state eCameraDirectorState
local function SetCameraDirectorState( state )

    gCameraDirectorState      = state
    gCameraDirectorStateSetAt = GetGameTimer()

    -- sx.logger:debug( ('Camera director state set to %s'):format( state ) )
end

-- local UpdateFSM = FSM(
--     { eCameraDirectorState.TRANSITION_LOAD_SCENE,
--         {
--             OnUpdate = function()

--             end
--         }
--     }
-- )

local gNextEase = 0

---@param transition BaseCameraDirectorTransition
---@return { position: vector3, rotation: vector3, fov: number }
local function GetCameraDirectorTransitionCameraSettings( transition )

    local camId = gCameraDirectorCameraId

    assert( camId )

    local settings =
    {
        position = GetCamCoord( camId ),
        rotation = GetCamRot( camId, 2 ),
        fov      = GetCamFov( camId ),
    }

    if      transition.type == 'skycam'        then

        ---@cast gCameraDirectorActiveTransition CameraDirectorTransitionSkyCam

        settings.position = vector3( gCameraDirectorTransitionCurrent.position.x, gCameraDirectorTransitionCurrent.position.y, 500.0 )
        settings.rotation = vector3( -90.0, 0.0, 0.0 )

        -- Limpar o estado de pointing, caso tenha sido aplicado por outro tipo de transição
        StopCamPointing( gCameraDirectorCameraId )

    elseif  transition.type == 'look_at_entity' then

        ---@cast gCameraDirectorActiveTransition CameraDirectorTransitionLookAtEntity

        local entity = gCameraDirectorTransitionCurrent.lookAtEntityId

        -- A entidade sempre tem que existir... ( lidar com isso de uma forma melhor? )
        assert( DoesEntityExist( entity ), 'lookAtEntityId is required for look_at_entity transitions' )

        settings.position = GetOffsetFromEntityInWorldCoords( entity, 0.0, 2.0, 0.32 )

        PointCamAtEntity( gCameraDirectorCameraId, entity, 0.0, 0.0, 0.32, true )
    end

    -- sx.logger:debug( ('Camera director transition camera settings: %s'):format( json.encode( settings, { indent = true } ) ) )

    return settings
end

local function UpdateCameraDirectorCameraInterpolatedPosition()

    local camId = gCameraDirectorCameraId

    assert( camId )

    local camPos = GetCamCoord( camId )

    -- Re-aplicar a posição da camera com a posição atual dela
    -- isso é util para quando começando interpolar enquanto uma interpolação
    -- já está acontecendo, se não fizermos isto, a camera vai pular 
    -- da posição inicial da inteporlação anterior para a nova posição da nova interpolação
    SetCamCoord( gCameraDirectorCameraId, camPos.x, camPos.y, camPos.z )
end

local function AttemptCameraDirectorInterpolationSceneFocus()

    if not IsNewLoadSceneActive() then

        -- NewLoadScene não está ativo e não vai finalizar de carregar, vamos abortar!

        sx.logger:error('NewLoadScene não está ativo e não vai finalizar de carregar, vamos abortar!')

        return true
    end

    if IsNewLoadSceneLoaded() then

        NewLoadSceneStop()

        assert( gCameraDirectorTransitionCurrent )

        local cameraSettings = GetCameraDirectorTransitionCameraSettings( gCameraDirectorTransitionCurrent )

        return true
    end

    return false
end

local function UpdateCameraDirector()

    assert( gIsCameraDirectorInitialized )

    assert( gCameraDirectorCameraId )

    if gCameraDirectorCameraId then

        -- Fixes #SG-159

        local camPos = GetCamCoord( gCameraDirectorCameraId )

        -- Cam recém-criada ainda sem posição reporta o limbo (±128000): jogava o
        -- streaming focus pra fora do mapa (visto no log do crash de Krown)
        -- NewLoadScene tem prioridade sobre o foco da câmera. Isso também cobre o
        -- handoff para admin:Teleport, que começa a carregar o destino antes do
        -- vRP:Active encerrar o CameraDirector.
        if not IsNewLoadSceneActive() and math.abs( camPos.x ) < 20000.0 and math.abs( camPos.y ) < 20000.0 then
            SetFocusPosAndVel( camPos.x, camPos.y, camPos.z, 0.0, 0.0, 0.0 )
        end
    end

    if      gCameraDirectorState == eCameraDirectorState.IDLE then

        local currTransition = gCameraDirectorTransitionCurrent

        if not currTransition or ( not currTransition.idleFor or ( GetGameTimer() - gCameraDirectorStateSetAt >= currTransition.idleFor ) ) then

            -- Aguardando uma nova transição!

            local nextTransition = table.remove( gCameraDirectorTransitionQueue, 1 )

            if nextTransition then

                gCameraDirectorTransitionCurrent = nextTransition

                SetCameraDirectorState( eCameraDirectorState.TRANSITION_STARTING )
            end
        end

        ShakeCam( gCameraDirectorCameraId, ShakeType, CameraShake )

    elseif  gCameraDirectorState == eCameraDirectorState.TRANSITION_STARTING then

        --[[
        if gCameraDirectorTransitionCurrent.fadeWhileTransitioning then

            DoScreenFadeOut( 1000 )
        end

        if not gCameraDirectorTransitionCurrent.fadeWhileTransitioning or IsScreenFadedOut() then
        --]]

            SetCameraDirectorState( eCameraDirectorState.TRANSITION_SETUP_CAMERA )
        --[[ end ]]

    elseif  gCameraDirectorState == eCameraDirectorState.TRANSITION_SETUP_CAMERA then

        -- Inicializando e aplicando as propriedades da camera ( posição, rotação, interpolação, etc...)

        assert( gCameraDirectorTransitionCurrent )

        UpdateCameraDirectorCameraInterpolatedPosition()

        local cameraSettings = GetCameraDirectorTransitionCameraSettings( gCameraDirectorTransitionCurrent )

        NewLoadSceneStartSphere( cameraSettings.position.x, cameraSettings.position.y, cameraSettings.position.z, 20.0, 2 )

        SetCamRot( gCameraDirectorCameraId, cameraSettings.rotation.x, cameraSettings.rotation.y, cameraSettings.rotation.z, 2 )

        if not gCameraDirectorTransitionCurrent.interpolate then

            -- É a primeira vez que essa camera vai ser renderizada
            -- então a gente assume que não precisa de interpolação!

            SetCamCoord( gCameraDirectorCameraId, cameraSettings.position.x, cameraSettings.position.y, cameraSettings.position.z )
        else

            -- A gente vai interpolar a camera para o novo destino
            -- mas a gente vai usar o easing para suavizar a transição

            InterpolateCamWithParams(
                gCameraDirectorCameraId,
                cameraSettings.position.x, cameraSettings.position.y, cameraSettings.position.z,
                cameraSettings.rotation.x, cameraSettings.rotation.y, cameraSettings.rotation.z,
                cameraSettings.fov,
                2500,
                15,
                15,
                2,
                15
            )
        end

        if not IsCamActive( gCameraDirectorCameraId ) then

            SetCamActive( gCameraDirectorCameraId, true )
            RenderScriptCams( true, false, 0, true, true )
        end

        SetCameraDirectorState( eCameraDirectorState.TRANSITION_WAITING_SCENE_LOAD )

    elseif  gCameraDirectorState == eCameraDirectorState.TRANSITION_WAITING_SCENE_LOAD then

        -- Aguardando a scena ( colisão, mapa, etc... ) carregar

        if AttemptCameraDirectorInterpolationSceneFocus() then

            SetCameraDirectorState( eCameraDirectorState.TRANSITION_WAITING_INTERPOLATION_END )
        end

    elseif  gCameraDirectorState == eCameraDirectorState.TRANSITION_WAITING_INTERPOLATION_END then

        --[[ if not gCameraDirectorTransitionCurrent.interpolate or not IsCamInterpolating( gCameraDirectorCameraId ) then ]]

            SetCameraDirectorState( eCameraDirectorState.TRANSITION_COMPLETE )
        --[[ end ]]

    elseif  gCameraDirectorState == eCameraDirectorState.TRANSITION_COMPLETE then

        -- Transição completa!

        --[[
        if gCameraDirectorTransitionCurrent.fadeWhileTransitioning then

            DoScreenFadeIn( 10 )
        end
        --]]

        SetCameraDirectorState( eCameraDirectorState.IDLE )
    else

        assert( ('Unhandled camera director state: %s'):format( gCameraDirectorState ) )
    end
end

local function safeSetTick( fn )
    if sx and sx.script and sx.script.setTick then
        return sx.script.setTick( fn )
    end
    local abort = false
    CreateThread(function()
        while not abort do
            fn()
            Wait(0)
        end
    end)
    return function()
        abort = true
    end
end

function InitCameraDirector()

    assert( not gIsCameraDirectorInitialized )

    gIsCameraDirectorInitialized = true

    gCameraDirectorTransitionQueue = { }

    gCameraDirectorUpdateAbortSignal = safeSetTick( UpdateCameraDirector )

    gCameraDirectorCameraId = CreateCam( 'DEFAULT_SCRIPTED_CAMERA', false )
    SetCamFov( gCameraDirectorCameraId, CameraFoV )
end

---@param cleanupStreaming? boolean
function TerminateCameraDirector(cleanupStreaming)

    -- assert( gIsCameraDirectorInitialized )

    gIsCameraDirectorInitialized = false

    gCameraDirectorTransitionQueue = nil

    if gCameraDirectorUpdateAbortSignal then
        gCameraDirectorUpdateAbortSignal()
    end
    gCameraDirectorUpdateAbortSignal = nil

    -- Alguns fluxos encerram a seleção antes de qualquer outro sistema assumir o streaming.
    -- No ChooseCharacter o admin:Teleport já pode ser o dono do load scene, então o caller
    -- mantém este cleanup desligado para não interromper o carregamento do spawn.
    if cleanupStreaming then
        if IsNewLoadSceneActive() then
            NewLoadSceneStop()
        end

        ClearFocus()
    end

    -- Idempotente: no fluxo decibel o director nunca inicializa e este handler
    -- roda mesmo assim; sem o guard, IsCamRendering/DestroyCam recebem nil
    if not gCameraDirectorCameraId then return end

    if IsCamRendering( gCameraDirectorCameraId ) then
        RenderScriptCams( false, false, 0, true, true )
    end

    DestroyCam( gCameraDirectorCameraId, false )
    gCameraDirectorCameraId = nil
end

---@param options CameraDirectorTransitionOptions
function QueueCameraDirectorTransition( options )

    assert( gCameraDirectorTransitionQueue )

    options.type = options.type or 'skycam'

    local prevTransition = gCameraDirectorTransitionCurrent

    ---@type BaseCameraDirectorTransition
    local transition =
    {
        type = options.type,
        interpolate = false,
        position = options.position,
        fadeWhileTransitioning = false,
    }

    if options.interpolate then
        transition.interpolate = true
    end

    if      transition.type == 'skycam' then

        ---@cast transition CameraDirectorTransitionSkyCam

        transition.position = assert( options.position, 'position is required for skycam transitions' )
        transition.interpolate = true

        if prevTransition and prevTransition.type == 'look_at_entity' then

            -- Estamos vindo de outro tipo de transição
            -- então primeiro vamos transicionar pro céu e depois para o destino

            table.insert( gCameraDirectorTransitionQueue, {
                type = 'skycam',
                position = GetEntityCoords( prevTransition.lookAtEntityId ),

                interpolate = true,

                -- Aguardar a interpolação acabar totalmente para poder
                -- começar uma nova transição
                -- waitInterpolationBeforeComplete = true,

                idleFor = 500,

            } --[[ @as CameraDirectorTransitionSkyCam ]] )
        end

    elseif  transition.type == 'look_at_entity' then

        ---@cast transition CameraDirectorTransitionLookAtEntity

        transition.lookAtEntityId = assert( options.lookAtEntityId, 'lookAtEntityId is required for look_at_entity transitions' )
        -- transition.fadeWhileTransitioning = true
    end

    -- sx.logger:debug( ('Queueing camera director transition: %s'):format( json.encode( transition, { indent = true } ) ) )

    table.insert( gCameraDirectorTransitionQueue, transition )
end

function cameraSpawn(coords)
    local lastCam = nil
    if cam then
        lastCam = cam
    end
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    NewLoadSceneStart(coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 150.0, 0)
    loadingScene = true
    local sceneLoadTimer = GetGameTimer()
	while not IsNewLoadSceneLoaded() do
        if GetGameTimer() >= sceneLoadTimer + 5000 then
            Debug.print("IsNewLoadSceneLoaded time limit reached")
            break
        end
        Wait(1)
	end
    loadingScene = false
    Debug.print("time to load scene: " .. GetGameTimer() - sceneLoadTimer.. " ms")
    SetFocusPosAndVel(coords.x, coords.y, coords.z, 0.00, 0.00, 0.00)
    NewLoadSceneStop()
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x, coords.y, coords.z + 500, 350.00,0.00,175.00, 90.00, false, 0)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z)
    if lastCam then
        SetCamActiveWithInterp(cam, lastCam, 2500, 1, 1)
        Citizen.SetTimeout(2600, function()
            if lastCam then
                if DoesCamExist(lastCam) then
                    DestroyCam(lastCam, false)
                end
                lastCam = nil
            end
        end)
    else
        SetCamActive(cam, true)
    end
    Wait(2600)
    local firstCam = cam
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x, coords.y, coords.z + 30, 350.00,0.00,175.00, 90.00, false, 0)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z)
    SetCamActiveWithInterp(cam, firstCam, 1500, 1, 1)
    Citizen.SetTimeout(1600, function()
        if firstCam then
            if DoesCamExist(firstCam) then
                DestroyCam(firstCam, false)
            end
            firstCam = nil
        end
    end)
end

function TransitionFromCameraToGameplay(coords)
    if not coords or not coords.x or not coords.y or not coords.z then
        return false
    end

    if cam then
        SetCamActive(cam, false)
        if DoesCamExist(cam) then
            DestroyCam(cam, true)
        end
        cam = nil
    end
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)

    -- O streaming do destino tem UM dono: o LoadSpawnScene do admin:Teleport (fluxo de spawn)
    -- ou o caller (TeleportNewbie já espera collision antes de chamar). O NewLoadSceneStart/Stop
    -- + ClearFocus próprios que existiam aqui derrubavam o load scene/focus do admin no meio do
    -- load (e vice-versa) — era a briga de streaming que crashava os players nos SetFocus*.
    local sceneLoadTimer = GetGameTimer()
    loadingScene = true
    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
        if IsNewLoadSceneActive() and IsNewLoadSceneLoaded() then break end
        if GetGameTimer() >= sceneLoadTimer + 5000 then
            Debug.print("collision/load scene time limit reached")
            break
        end
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        Wait(1)
    end
    loadingScene = false
    Debug.print("time to load scene: " .. GetGameTimer() - sceneLoadTimer.. " ms")
    local firstCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",
        coords.x, coords.y, coords.z + 500,
        350.00, 0.00, 175.00, 90.00, false, 0)
    
    if not firstCam or not DoesCamExist(firstCam) then
        Debug.print("Failed to create first transition camera")
        return false
    end
    SetCamActive(firstCam, true)
    RenderScriptCams(true, false, 0, true, true)
    PointCamAtCoord(firstCam, coords.x, coords.y, coords.z)
    Wait(1000)

    local secondCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 
        coords.x, coords.y, coords.z + 30,
        350.00, 0.00, 175.00, 90.00, false, 0)
    
    if not secondCam or not DoesCamExist(secondCam) then
        if DoesCamExist(firstCam) then
            DestroyCam(firstCam, true)
        end
        Debug.print("Failed to create second transition camera")
        return false    
    end

    PointCamAtCoord(secondCam, coords.x, coords.y, coords.z)

    SetCamActiveWithInterp(secondCam, firstCam, 1500, 1, 1)
    Wait(1600)

    if DoesCamExist(firstCam) then
        if DoesCamExist(firstCam) then
            DestroyCam(firstCam, true)
        end
    end
    if DoesCamExist(secondCam) then
        DestroyCam(secondCam, true)
    end
    RenderScriptCams(false, false, 0, true, true)
    SetGameplayCamRelativeHeading(0.0)
    disableCamera()
    return true
end
