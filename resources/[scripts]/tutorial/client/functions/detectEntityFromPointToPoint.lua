glm_sincos = require 'glm'.sincos
glm_rad = require 'glm'.rad
math_abs = math.abs
DEFAULT_FLAGS = 4
DEFAULT_IGNORE = 0
DEFAULT_DISTANCE = 1000.0

pendingHandle = nil
lastResult = {
    hit = false,
    entityHit = 0,
    endCoords = vector3(0, 0, 0),
    surfaceNormal = vector3(0, 0, 0),
    materialHash = 0
}

detectEntityFromPointToPoint = function(origin, destination)
    if pendingHandle then
        local ret, hit, endCoords, surfNorm, matHash, ent = GetShapeTestResultIncludingMaterial(pendingHandle)
        if ret ~= 1 then
            lastResult.hit = hit
            lastResult.entityHit = ent
            lastResult.endCoords = endCoords
            lastResult.surfaceNormal = surfNorm
            lastResult.materialHash  = matHash
            pendingHandle = nil
        end
    end

    pendingHandle = StartShapeTestLosProbe(
        origin.x, origin.y, origin.z,
        destination.x, destination.y, destination.z,
        DEFAULT_FLAGS,
        0,
        DEFAULT_IGNORE
    )

    local hit, entity, target = lastResult.hit, lastResult.entityHit, lastResult.endCoords

    if (not hit) then
        return false
    end

    if (config.laser.debugEntityDetectionLine) then
        DrawLine(origin.x, origin.y, origin.z, destination.x, destination.y, destination.z, 255, 255, 255, 255)
    end

    return entity
end