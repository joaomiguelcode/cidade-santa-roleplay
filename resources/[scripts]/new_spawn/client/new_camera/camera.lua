CameraManager = class()

local CAMERA_CONFIG = {
    FOCUS = {
        FOV            = 35.0,
        SPEED          = 1000,
        DISTANCE_AHEAD = 1.0,
    },
    DOF = {
        ENABLED  = false,
        NEAR     = 1.2,
        FAR      = 4.78,
        STRENGTH = 1.0,
    },
    THREADS = {
        DOF_UPDATE_INTERVAL      = 1,
        RESPONSE_CHECK_INTERVAL  = 1,
    },
    DEBUG = {
        -- ponytail: ligado temporariamente pra caçar CTD no DecibelSpawn; reverter quando identificado
        ENABLED              = true,
        SHOW_THREAD_LIFECYCLE = true,
        SHOW_OPERATION_LOOPS  = false,
    },
}

-- ==========================================
-- DEBUG
-- ==========================================

local function debugLog(category, message, ...)
    if not CAMERA_CONFIG.DEBUG.ENABLED then return end
    if select('#', ...) > 0 then message = message:format(...) end
    NsDbgLog( ('[nsdbg] [Camera:%s] %s'):format( category, message ) )
end

local function logThreadLifecycle(action, threadType, opId)
    if CAMERA_CONFIG.DEBUG.SHOW_THREAD_LIFECYCLE then
        debugLog('Thread', '%s %s - OpID: %d', action, threadType, opId)
    end
end

local function logOperationLoop(threadType, opId, currentId)
    if CAMERA_CONFIG.DEBUG.SHOW_OPERATION_LOOPS then
        debugLog('Loop', '%s - OpID: %d, Current: %d', threadType, opId, currentId)
    end
end

-- ==========================================
-- INIT / ESTADO
-- ==========================================

function CameraManager:__init()
    self:_resetState()
end

function CameraManager:_resetState()
    self.camera          = nil
    self.index           = nil

    self.focused         = false
    self.playing         = false

    self.dofActive       = false
    self.transitionActive = false
    self.dofThread       = nil
    self.transitionThread = nil

    self.processing      = false
    self.currentOperation = nil
    self.operationId     = 0

    self.currentNearDof  = CAMERA_CONFIG.DOF.NEAR
    self.currentFarDof   = CAMERA_CONFIG.DOF.FAR
end

-- ==========================================
-- MUTEX
-- ==========================================

function CameraManager:_generateOperationId()
    self.operationId = self.operationId + 1
    debugLog('Operation', 'Nova operação ID: %d', self.operationId)
    return self.operationId
end

function CameraManager:_acquireLock(operation)
    if self.processing then
        debugLog('Mutex', 'Operação "%s" bloqueada - processando "%s"', operation, self.currentOperation or 'unknown')
        return false
    end
    self.processing      = true
    self.currentOperation = operation
    return true
end

function CameraManager:_releaseLock()
    self.processing      = false
    self.currentOperation = nil
end

-- ==========================================
-- CONTROLE DE THREADS
-- ==========================================

function CameraManager:_isThreadValid(originalOpId)
    return self.operationId == originalOpId
end

function CameraManager:_terminateThread(threadRef, threadName)
    if threadRef then
        TerminateThread(threadRef)
        logThreadLifecycle('TERMINADA', threadName, self.operationId)
        return nil
    end
    return threadRef
end

function CameraManager:_stopExistingThread(threadType)
    if threadType == 'dof' and self.dofActive then
        self.dofActive = false
        self.dofThread = self:_terminateThread(self.dofThread, 'DOF')
        Wait(0)
    elseif threadType == 'transition' and self.transitionActive then
        self.transitionActive = false
        self.transitionThread = self:_terminateThread(self.transitionThread, 'Transition')
        Wait(0)
    end
end

function CameraManager:_stopAllThreads()
    self.dofActive        = false
    self.transitionActive = false
    self.dofThread        = self:_terminateThread(self.dofThread, 'DOF')
    self.transitionThread = self:_terminateThread(self.transitionThread, 'Transition')
    Wait(0)
end

function CameraManager:_responsiveWait(duration, originalOpId, additionalCheck)
    local totalWait = 0
    local interval  = CAMERA_CONFIG.THREADS.RESPONSE_CHECK_INTERVAL

    while totalWait < duration and self:_isThreadValid(originalOpId) do
        if additionalCheck and not additionalCheck() then break end
        Wait(interval)
        totalWait = totalWait + interval
    end

    return self:_isThreadValid(originalOpId)
end

-- ==========================================
-- VALIDAÇÃO
-- ==========================================

---@param id number índice em Scene.config.CAMERAS
function CameraManager:_validateCameraConfig(id)
    local cameras = Scene.config.CAMERAS

    if not cameras or not cameras[id] then
        return false, string.format('Configuração da câmera não encontrada: %s', id)
    end

    local camConfig  = cameras[id]
    local required   = { 'nodes', 'fov', 'pointAt' }

    for _, field in ipairs(required) do
        if not camConfig[field] then
            return false, string.format('%s não encontrado para câmera: %s', field, id)
        end
    end

    if not camConfig.nodes[1] then
        return false, string.format('Primeiro node não encontrado para câmera: %s', id)
    end

    return true, camConfig
end

---@param id number índice em Scene.spawned
function CameraManager:_validatePed(id)
    if not Scene.spawned or not Scene.spawned[id] then
        return false, string.format('Ped não encontrado com ID: %s', id)
    end
    return true, Scene.spawned[id]
end

function CameraManager:_validateFocusConfig()
    local cameras = Scene.config.CAMERAS

    if not cameras or not cameras[1] or not cameras[1].pointAt then
        return false, 'Configuração de focus inválida'
    end

    return true, cameras[1]
end

-- ==========================================
-- CRIAÇÃO DE CÂMERAS
-- ==========================================

function CameraManager:_createSplineCamera(camConfig)
    local cam       = CreateCam('DEFAULT_SPLINE_CAMERA', true)
    local startNode = camConfig.nodes[1]
    local speed     = camConfig.speed or 2000

    SetCamFov(cam, camConfig.fov)
    SetCamCoord(cam, startNode.x, startNode.y, startNode.z)
    PointCamAtCoord(cam, camConfig.pointAt.x, camConfig.pointAt.y, camConfig.pointAt.z)

    for _, node in pairs(camConfig.nodes) do
        AddCamSplineNode(cam, node.x, node.y, node.z, 0.0, 0.0, 0.0, speed, 50, 1)
    end

    SetCamSplineSmoothingStyle(cam, 3)
    RenderScriptCams(true, true, 1, false, true)

    return cam
end

function CameraManager:_createFocusCamera(ped)
    local cam        = CreateCam('DEFAULT_SPLINE_CAMERA', true)
    local focus      = CAMERA_CONFIG.FOCUS
    local pedCoords  = GetPedBoneCoords(ped, 31086)
    local forward    = GetEntityForwardVector(ped)

    local targetX = pedCoords.x + (forward.x * focus.DISTANCE_AHEAD)
    local targetY = pedCoords.y + (forward.y * focus.DISTANCE_AHEAD)
    local targetZ = pedCoords.z + (forward.z * focus.DISTANCE_AHEAD)

    local isValid, camConfigOrError = self:_validateFocusConfig()

    if isValid then
        local startNode = camConfigOrError.pointAt

        SetCamFov(cam, focus.FOV)
        SetCamCoord(cam, startNode.x, startNode.y, startNode.z)
        PointCamAtCoord(cam, pedCoords.x, pedCoords.y, pedCoords.z)

        AddCamSplineNode(cam, startNode.x, startNode.y, startNode.z, 0.0, 0.0, 0.0, focus.SPEED, 50, 1)
        AddCamSplineNode(cam, targetX, targetY, targetZ, 0.0, 0.0, 0.0, focus.SPEED, 50, 1)

        SetCamSplineSmoothingStyle(cam, 3)
    else
        debugLog('Warning', camConfigOrError)
        SetCamFov(cam, focus.FOV)
        SetCamCoord(cam, targetX, targetY, targetZ)
        PointCamAtCoord(cam, pedCoords.x, pedCoords.y, pedCoords.z)
    end

    RenderScriptCams(true, true, 1, false, true)
    return cam
end

-- ==========================================
-- DOF
-- ==========================================

function CameraManager:_configureDOF()
    if not CAMERA_CONFIG.DOF.ENABLED then return end
    SetCamUseShallowDofMode(self.camera, true)
    SetCamNearDof(self.camera, self.currentNearDof)
    SetCamFarDof(self.camera, self.currentFarDof)
    SetCamDofStrength(self.camera, CAMERA_CONFIG.DOF.STRENGTH)
end

function CameraManager:_setupDOF()
    if not CAMERA_CONFIG.DOF.ENABLED then return end

    self:_stopExistingThread('dof')

    self.dofActive   = true
    local currentOpId = self.operationId

    self:_configureDOF()
    logThreadLifecycle('INICIADA', 'DOF', currentOpId)

    self.dofThread = CreateThread(function()
        while self.dofActive and self:_isThreadValid(currentOpId) do
            SetUseHiDof()
            logOperationLoop('DOF', currentOpId, self.operationId)

            local stillValid = self:_responsiveWait(
                CAMERA_CONFIG.THREADS.DOF_UPDATE_INTERVAL,
                currentOpId,
                function() return self.dofActive end
            )

            if not stillValid then break end
        end
        logThreadLifecycle('FINALIZADA', 'DOF', currentOpId)
    end)
end

-- ==========================================
-- TRANSIÇÃO (loop spline)
-- ==========================================

function CameraManager:_setupTransition()
    self:_stopExistingThread('transition')

    self.transitionActive = true
    local currentOpId     = self.operationId

    logThreadLifecycle('INICIADA', 'Transition', currentOpId)

    self.transitionThread = CreateThread(function()
        while self:_isThreadValid(currentOpId) and self.transitionActive do
            DoScreenFadeIn(500)

            repeat
                local stillValid = self:_responsiveWait(
                    1000,
                    currentOpId,
                    function() return self.transitionActive end
                )

                if not stillValid then return end

                logOperationLoop('Transition', currentOpId, self.operationId)
            until GetCamSplinePhase(self.camera) == 1.0
                or self.focused
                or not self.transitionActive
                or not self:_isThreadValid(currentOpId)

            if self.focused or not self:_isThreadValid(currentOpId) then return end

            DoScreenFadeOut(0)
            SetCamSplinePhase(self.camera, 0.0)
            RenderScriptCams(true, true, 1, false, true)

            if not self.camera or not self:_isThreadValid(currentOpId) then return end
        end
        logThreadLifecycle('FINALIZADA', 'Transition', currentOpId)
    end)
end

-- ==========================================
-- DESTROY
-- ==========================================

function CameraManager:destroy()
    debugLog('API', 'destroy cam=%s', tostring(self.camera))
    if not self.camera then return end

    self:_generateOperationId()
    self:_stopAllThreads()

    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(self.camera, false)
    DestroyAllCams(true)

    self:_resetState()
end

-- ==========================================
-- API PÚBLICA
-- ==========================================

---Inicia a câmera spline da cena.
---@param id number índice em Scene.config.CAMERAS
function CameraManager:start(id)
    debugLog('API', 'start id=%s', tostring(id))
    if not self:_acquireLock('start') then return self end

    if self.camera then self:destroy() end

    self:_generateOperationId()

    local isValid, camConfigOrError = self:_validateCameraConfig(id)
    if not isValid then
        debugLog('Error', camConfigOrError)
        self:_releaseLock()
        return self
    end

    self.index  = id
    self.camera = self:_createSplineCamera(camConfigOrError)

    self:_setupDOF()
    self:_setupTransition()

    self:_releaseLock()
    return self
end

---Foca a câmera num ped específico.
---@param id number índice em Scene.spawned
function CameraManager:focus(id)
    debugLog('API', 'focus id=%s', tostring(id))
    if not self:_acquireLock('focus') then return self end

    local isValid, pedOrError = self:_validatePed(id)
    if not isValid then
        debugLog('Error', pedOrError)
        self:_releaseLock()
        return self
    end

    DoScreenFadeOut(0)

    if self.camera then self:destroy() end
    debugLog('API', 'focus: camera anterior destruida')

    self:_generateOperationId()

    self.camera  = self:_createFocusCamera(pedOrError)
    debugLog('API', 'focus: camera criada cam=%s ped=%s', tostring(self.camera), tostring(pedOrError))
    self.focused = true

    DoScreenFadeIn(1000)
    self:_setupDOF()
    self:_releaseLock()
    debugLog('API', 'focus: done')
    return self
end

---Retoma o loop de transição após um foco.
function CameraManager:play()
    debugLog('API', 'play cam=%s', tostring(self.camera))
    if not self.camera then return self end

    self.playing  = true
    self.focused  = false

    DoScreenFadeIn(1000)
    self:_setupTransition()
    self:_setupDOF()

    return self
end

CameraManager = CameraManager()

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    debugLog('Lifecycle', 'onResourceStop cleanup')

    -- Threads são finalizadas automaticamente pelo FiveM;
    -- só precisamos limpar o estado do game engine
    NewLoadSceneStop()
    ClearFocus()
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyAllCams(true)
end)
