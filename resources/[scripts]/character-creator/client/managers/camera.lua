Camera = {
    target = nil, ---@type vector3?
    pointTargetOffset = nil, ---@type vector3?
    position = vector3(0.0, 0.0, 0.0),
    forward = vector3(0.0, 0.0, 0.0), ---@type vector3
}

function Camera.getTargetPoint()
    if Camera.target then
        return Camera.target
    end
    return GetEntityCoords(PlayerPedId())
end

function Camera.getPointTargetOffset()
    if Camera.pointTargetOffset then
        return Camera.pointTargetOffset
    end
    return nil
end

---@param offset vector3
function Camera.setPointTargetOffset(offset)
    local pedPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), offset.x, offset.y, offset.z)

    Camera.target = pedPos
    Camera.pointTargetOffset = offset
    PointCamAtCoord(gCamera, pedPos.x, pedPos.y, pedPos.z)
end

---@param zoom number
function Camera.zoom(zoom)
    local distance = CREATOR_CONFIG.CAMERA_CONFIG.MIN_ZOOM +
        (CREATOR_CONFIG.CAMERA_CONFIG.MAX_ZOOM - CREATOR_CONFIG.CAMERA_CONFIG.MIN_ZOOM) * zoom
    local targetPos = Camera.getTargetPoint()
    local camCoords = GetCamCoord(gCamera)
    local _, fwd = GetCamMatrix(gCamera)

    local newPos = vector3(
        targetPos.x - fwd.x * distance,
        targetPos.y - fwd.y * distance,
        camCoords.z
    )

    SetCamCoord(gCamera, newPos.x, newPos.y, newPos.z)
end

local function ProcessCameraTransitionQueue()
    ---@type character-creator.CameraTransition?
    local transtion = table.remove(gCameraTransitionQueue, 1)

    -- caso não exista mais transições ou a camera não exista, para a transição
    if not (transtion and gCamera and DoesCamExist(gCamera)) then
        gCurrentTransition = nil
        return --print('no transition or camera not exists')
    end

    -- se a camera já está no destino, para a transição (existem categorias com o mesmo target.)
    if transtion.targetPos == GetCamCoord(gCamera) then
        return -- print('already in target position')
    end

    gCurrentTransition = transtion

    local startPos = GetCamCoord(gCamera)
    local startTime = GetGameTimer()

    -- função que detecta se existe algum lerp diferente do atual.
    local function isDifferentLerpTarget()
        return gCurrentTransition and gCurrentTransition.targetPos ~= transtion.targetPos
    end

    CreateThread(function()
        while gCamera and DoesCamExist(gCamera) do
            -- caso possua um lerp diferente do atual, o atual vai decidir se continua ou não.
            if isDifferentLerpTarget() then
                return --print('different lerp target')
            end

            local now = GetGameTimer()
            local t = math.min((now - startTime) / transtion.duration, 1.0)

            t = 1 - (1 - t) * (1 - t) -- ease

            local lerped = startPos + (transtion.targetPos - startPos) * t
            SetCamCoord(gCamera, lerped.x, lerped.y, lerped.z)

            if t >= 1.0 then
                break
            end
            Wait(0)
        end

        ProcessCameraTransitionQueue()
    end)
end

---@return boolean
function Camera.isLerpingTransition()
    return gCurrentTransition ~= nil
end

---Adiciona uma transição de câmera na fila (baseado em QueueCameraDirectorTransition)
---@param target vector3 posição de destino
---@param duration number? duração em ms (padrão: 1000)
local function QueueCameraTransition(target, duration)
    table.insert(gCameraTransitionQueue, {
        targetPos = target,
        duration = duration or 1000
    })
    ProcessCameraTransitionQueue()
end

local function ClearCameraTransitionQueue()
    gCameraTransitionQueue = {}
    gCurrentTransition = nil
end

-- ---@param duration number? tempo de interpolação (ms)
function Camera.focusOnPart(part, duration)
    local config = CREATOR_CONFIG.CAMERA_PARTS[part]
    local ped = PlayerPedId()

    local offset = config.offsetCamera or vector3(0.0, 0.0, 0.0)
    local pedPos = GetOffsetFromEntityInWorldCoords(ped, offset.x, offset.y, offset.z)
    local bonePos = GetPedBoneCoords(ped, config.bone, 0.0, 0.0, config.heightOffset)

    local newPos = vector3(
        pedPos.x + (Camera.forward.x) * config.distance,
        pedPos.y + (Camera.forward.y) * config.distance,
        bonePos.z
    )

    StopCamPointing(gCamera)
    Camera.setPointTargetOffset(config.offset)

    if duration and duration > 0 then
        return QueueCameraTransition(newPos, duration)
    end

    return SetCamCoord(gCamera, newPos.x, newPos.y, newPos.z)
end

-- -- Reseta a câmera para a posição inicial
function Camera.resetToDefault(duration)
    Camera.target = nil
    Camera.setPointTargetOffset(CREATOR_CONFIG.CAMERA_CONFIG.POINT_AT_ENTITY)

    if duration and duration > 0 then
        return QueueCameraTransition(Camera.position, duration)
    end

    return SetCamCoord(gCamera, Camera.position.x, Camera.position.y, Camera.position.z)
end

function Camera.create()
    local player = PlayerPedId()
    local playerCoords = GetEntityCoords(player)
    local forward = playerCoords + GetEntityForwardVector(player) * 1.8

    Camera.position = vector3(forward.x, forward.y, forward.z) + CREATOR_CONFIG.CAMERA_CONFIG.ADJUSTED_POSITION
    Camera.target = nil
    Camera.forward = GetEntityForwardVector(player)

    gCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
    SetCamCoord(gCamera, Camera.position.x, Camera.position.y, Camera.position.z)

    Camera.setPointTargetOffset(CREATOR_CONFIG.CAMERA_CONFIG.POINT_AT_ENTITY)

    SetCamActive(gCamera, true)
    RenderScriptCams(true, true, 0, true, true)
end

function Camera.destroy()
    if gCamera and DoesCamExist(gCamera) then
        DestroyCam(gCamera, false)
    end
    RenderScriptCams(false, false, 0, true, true)
    gCamera = nil
    ClearCameraTransitionQueue()
end
