local gCamera = nil
local gTargetEntity = nil
local gOrbitAngleRad = 0.0
local gOrbitAngleTargetRad = 0.0

--- Suavização exponencial: `t = 1 - exp(-k*dt)` — quanto menor, mais suave; quanto maior, mais rápido.
local gOrbitLerpSpeed = 8.0

local gOrbitLerpTickAbort = nil

local function StopChamaleonOrbitLerpTick()
    if gOrbitLerpTickAbort then
        gOrbitLerpTickAbort()
        gOrbitLerpTickAbort = nil
    end
end

local function EnsureChamaleonOrbitLerpTick()
    if gOrbitLerpTickAbort then
        return
    end
    gOrbitLerpTickAbort = sx.script.setTick(ChamaleonCameraUpdateOrbitLerp)
end

--- Distância horizontal do ponto de mira até a câmera (plano XY).
local ORBIT_RADIUS = 4.8

--- Altura extra da câmera em relação ao ponto de mira no veículo.
local CAMERA_HEIGHT_ABOVE_AIM = 1.15

--- Offset Z local no veículo para o centro visual (PointCamAtEntity).
local LOOK_AT_LOCAL_Z = 0.32

--- Ângulo inicial: diagonal à frente (mistura frente + lateral), em radianos.
local DEFAULT_ORBIT_ANGLE_RAD = math.rad(42.0)

--- Passo padrão de rotação por chamada (graus → rad internamente).
local DEFAULT_STEP_DEGREES = 22.0

local gOrbitStepRad = math.rad(DEFAULT_STEP_DEGREES)

-- Camera Fov
local CAMERA_FOV = 78.0

--- Vetores forward/right no plano horizontal (Z=0), normalizados.
---@param entity number
---@return vector3 forward2d
---@return vector3 right2d
local function GetEntityHorizontalBasis(entity)
    local f = GetEntityForwardVector(entity)
    local fx, fy = f.x, f.y
    local len = math.sqrt(fx * fx + fy * fy)
    if len < 1e-4 then
        return vector3(0.0, 1.0, 0.0), vector3(1.0, 0.0, 0.0)
    end
    fx, fy = fx / len, fy / len
    local forward2d = vector3(fx, fy, 0.0)
    local right2d = vector3(fy, -fx, 0.0)
    return forward2d, right2d
end

--- Atualiza posição da câmera e reaponta para a entidade (orbita em torno do veículo).
function RefreshChamaleonCameraPosition()
    if not gCamera or not DoesCamExist(gCamera) then
        return
    end
    if not gTargetEntity or not DoesEntityExist(gTargetEntity) then
        return
    end

    local aim = GetOffsetFromEntityInWorldCoords(gTargetEntity, 0.0, 0.0, LOOK_AT_LOCAL_Z)
    local forward2d, right2d = GetEntityHorizontalBasis(gTargetEntity)
    local c = math.cos(gOrbitAngleRad)
    local s = math.sin(gOrbitAngleRad)
    local hx = ORBIT_RADIUS * (c * forward2d.x + s * right2d.x)
    local hy = ORBIT_RADIUS * (c * forward2d.y + s * right2d.y)

    local camX = aim.x + hx
    local camY = aim.y + hy
    local camZ = aim.z + CAMERA_HEIGHT_ABOVE_AIM

    SetCamCoord(gCamera, camX, camY, camZ)
    PointCamAtEntity(gCamera, gTargetEntity, 0.0, 0.0, LOOK_AT_LOCAL_Z, true)
end

--- Só é chamado enquanto o tick está ativo (após Rotate*). Para o tick ao alcançar o alvo — zero custo em idle.
function ChamaleonCameraUpdateOrbitLerp()
    if not gCamera or not DoesCamExist(gCamera) or not gTargetEntity or not DoesEntityExist(gTargetEntity) then
        StopChamaleonOrbitLerpTick()
        return
    end

    local diff = gOrbitAngleTargetRad - gOrbitAngleRad
    if math.abs(diff) <= 1e-6 then
        StopChamaleonOrbitLerpTick()
        return
    end

    local dt = GetFrameTime()
    if dt <= 0.0 then
        dt = 0.016
    end

    local t = 1.0 - math.exp(-gOrbitLerpSpeed * dt)
    gOrbitAngleRad = gOrbitAngleRad + diff * t
    if math.abs(gOrbitAngleTargetRad - gOrbitAngleRad) < 1e-5 then
        gOrbitAngleRad = gOrbitAngleTargetRad
    end

    RefreshChamaleonCameraPosition()

    if math.abs(gOrbitAngleTargetRad - gOrbitAngleRad) <= 1e-6 then
        StopChamaleonOrbitLerpTick()
    end
end

function DestroyChamaleonCamera()
    StopChamaleonOrbitLerpTick()

    if gCamera and DoesCamExist(gCamera) then
        StopCamPointing(gCamera)
        SetCamActive(gCamera, false)
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(gCamera, false)
    end

    gCamera = nil
    gTargetEntity = nil
    gOrbitAngleRad = 0.0
    gOrbitAngleTargetRad = 0.0
end

---@param entityId number
---@return boolean
function CreateChamaleonCamera(entityId)
    DestroyChamaleonCamera()

    if not entityId or entityId == 0 or not DoesEntityExist(entityId) then
        return false
    end

    gTargetEntity = entityId
    gOrbitAngleRad = DEFAULT_ORBIT_ANGLE_RAD
    gOrbitAngleTargetRad = DEFAULT_ORBIT_ANGLE_RAD

    gCamera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    if not gCamera or gCamera == 0 then
        gTargetEntity = nil
        gOrbitAngleRad = 0.0
        gOrbitAngleTargetRad = 0.0
        return false
    end

    SetCamFov(gCamera, CAMERA_FOV)
    SetCamActive(gCamera, true)
    RenderScriptCams(true, false, 0, true, true)
    RefreshChamaleonCameraPosition()

    return true
end

--- Define o quanto cada RotateLeft/RotateRight move quando `stepRad` não é passado.
---@param degrees number
function SetChamaleonCameraOrbitStepDegrees(degrees)
    gOrbitStepRad = math.rad(degrees)
end

--- Quanto mais alto, mais rápido o ângulo alcança o alvo (exponencial `1-exp(-speed*dt)`).
---@param speed number
function SetChamaleonCameraOrbitLerpSpeed(speed)
    gOrbitLerpSpeed = speed
end

--- Gira a câmera no sentido horário ao redor do veículo (vista de cima). Só mexe no alvo; o lerp roda no Update.
---@param stepRad number? radianos; se nil, usa o passo padrão (ver SetChamaleonCameraOrbitStepDegrees).
function ChamaleonCameraRotateRight(stepRad)
    if not gCamera or not DoesCamExist(gCamera) or not gTargetEntity then
        return
    end
    local step = stepRad or gOrbitStepRad
    gOrbitAngleTargetRad = gOrbitAngleTargetRad - step
    EnsureChamaleonOrbitLerpTick()
end

--- Gira a câmera no sentido anti-horário ao redor do veículo (vista de cima).
---@param stepRad number?
function ChamaleonCameraRotateLeft(stepRad)
    if not gCamera or not DoesCamExist(gCamera) or not gTargetEntity then
        return
    end
    local step = stepRad or gOrbitStepRad
    gOrbitAngleTargetRad = gOrbitAngleTargetRad + step
    EnsureChamaleonOrbitLerpTick()
end

--- Mesmas funções acima, passo em graus (mais legível para UI). Com `nil`, usa o passo configurado.
---@param degrees number?
function ChamaleonCameraRotateRightDegrees(degrees)
    if degrees ~= nil then
        ChamaleonCameraRotateRight(math.rad(degrees))
    else
        ChamaleonCameraRotateRight(nil)
    end
end

---@param degrees number?
function ChamaleonCameraRotateLeftDegrees(degrees)
    if degrees ~= nil then
        ChamaleonCameraRotateLeft(math.rad(degrees))
    else
        ChamaleonCameraRotateLeft(nil)
    end
end
