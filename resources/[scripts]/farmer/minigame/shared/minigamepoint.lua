---@enum eMinigameVolumeType
eMinigameVolumeType =
{
    Sphere  = 0,
    Polygon = 1,
}

---@alias MinigameVolume CZone

-- Remover completamente a definição e uso de MinigamePoint. Operar só com volumeLocalIdx.

DEFAULT_MINIGAME_POINT_MAX_DISTANCE = 5.0

---@param minigameDef MinigameDef
---@param volumeDef   MinigameVolumeDef
---@return CZone
function CreateMinigameVolume(minigameDef, volumeDef)
    if IsDuplicityVersion() or not lib or type(lib) ~= 'table' or not lib.zones then
        return {
            coords = volumeDef.coords,
            radius = volumeDef.radius,
            points = volumeDef.vertices
        }
    end

    if volumeDef.type == eMinigameVolumeType.Sphere then
        return lib.zones.sphere({
            coords = volumeDef.coords,
            radius = volumeDef.radius,
            inside = IS_CLIENT and function()
                OnUpdateMinigamePoint( volumeDef )
            end or nil,
            onExit = IS_CLIENT and function()
                OnExitMinigamePoint( volumeDef )
            end or nil,
        })
    elseif volumeDef.type == eMinigameVolumeType.Polygon then
        return lib.zones.poly({
            points = volumeDef.vertices,
            thickness = 1000.0,
            inside = IS_CLIENT and function()
                OnUpdateMinigamePoint( volumeDef )
            end or nil,
            onExit = IS_CLIENT and function()
                OnExitMinigamePoint( volumeDef )
            end or nil,
        })
    else
        error(('Invalid volume type: %s !'):format(json.encode(volumeDef)))
    end
end