local STAFFGANG_RUNTIME_STATE_KEY = 'farmer:staffgang:runtime'
local RuntimeZones = {}
local IsStartingFarm = false
local gHoverfyIsHiddenByFarm = false

local function notify(message, notifyType)
    lib.notify({ title = _t('staffgang.title'), description = message, type = notifyType or 'inform' })
end

local function removeRuntimeZones()
    for _, zone in pairs(RuntimeZones) do
        zone:remove()
    end

    RuntimeZones = {}
    gHoverfyIsHiddenByFarm = false
    TriggerEvent('hoverfy:removeHoverfy')
end

local function toVector3(coords)
    if type(coords) ~= 'table' or not coords.x or not coords.y or not coords.z then
        return nil
    end

    local x = tonumber(coords.x)
    local y = tonumber(coords.y)
    local z = tonumber(coords.z)

    if not x or not y or not z then
        return nil
    end

    return vec3(x, y, z)
end

local function toPolygonVertices(vertices)
    if type(vertices) ~= 'table' then
        return nil
    end

    local points = {}
    local normalizedZ

    for _, vertex in ipairs(vertices) do
        local point = toVector3(vertex)

        if not point then
            return nil
        end

        normalizedZ = normalizedZ or point.z
        points[#points + 1] = vec3(point.x, point.y, normalizedZ)
    end

    if #points < STAFFGANG_POLYZONE_LIMITS.minPoints then
        return nil
    end

    return points
end

local function buildRuntimeZoneKey(farmId, pointId)
    return ('staffgang:%s:%s'):format(farmId, pointId)
end

local function shouldTryStartFarm()
    if IsStartingFarm then
        return false
    end

    if GetActiveMinigame and GetActiveMinigame() then
        return false, _t('staffgang.runtime.activeMinigame')
    end

    if vRP and vRP.ReturnNoClip and vRP.ReturnNoClip() then
        return false, _t('staffgang.runtime.noclipBlocked')
    end

    return true
end

local function isRuntimeFarmActive()
    return GetActiveMinigame and GetActiveMinigame() ~= nil
end

local function shouldShowRuntimeHoverfy()
    if isRuntimeFarmActive() then
        if not gHoverfyIsHiddenByFarm then
            TriggerEvent('hoverfy:removeHoverfy')
            gHoverfyIsHiddenByFarm = true
        end

        return false
    end

    gHoverfyIsHiddenByFarm = false

    return true
end

local function startRuntimeFarm(farm, point)
    local canStart, message = shouldTryStartFarm()

    if not canStart then
        if message then
            notify(message, 'error')
        end

        return
    end

    IsStartingFarm = true

    local result = lib.callback.await('farmer:staffgang:start-farm', false, farm.id, point.id)

    IsStartingFarm = false

    if not result or result.ok ~= true then
        notify(result and result.message or _t('staffgang.generic.noServerResponse'), 'error')
    end
end

local function handleRuntimeZoneInside(farm, point)
    if not shouldShowRuntimeHoverfy() then
        return
    end

    if GetFrameCount() % 100 == 0 then
        TriggerEvent('hoverfy:toggle', true, {
            title = tostring(farm.title or _t('staffgang.title')):upper(),
            key = 'E',
            legend = _t('press_to_start'),
        })
    end

    if IsControlJustPressed(0, 38) or IsDisabledControlJustPressed(0, 38) then
        startRuntimeFarm(farm, point)
    end
end

local function createRuntimeZone(farm, point)
    local template = StaffgangGetFarmTemplate(farm.templateId)

    if not template then
        return
    end

    local zoneKey = buildRuntimeZoneKey(farm.id, point.id)

    if point.type == 'polygon' then
        local zoneDefinition = type(point.zone) == 'table' and point.zone or {}
        local vertices = toPolygonVertices(zoneDefinition.vertices)

        if not vertices then
            return
        end

        RuntimeZones[zoneKey] = lib.zones.poly({
            points = vertices,
            thickness = 1000.0,
            inside = function()
                handleRuntimeZoneInside(farm, point)
            end,
            onExit = function()
                TriggerEvent('hoverfy:removeHoverfy')
            end,
        })

        return
    end

    if point.type == 'sphere' then
        local coords = toVector3(point.position)

        if not coords then
            return
        end

        RuntimeZones[zoneKey] = lib.zones.sphere({
            coords = coords,
            radius = template.minigame.distance,
            inside = function()
                handleRuntimeZoneInside(farm, point)
            end,
            onExit = function()
                TriggerEvent('hoverfy:removeHoverfy')
            end,
        })
    end
end

local function applyRuntimeSnapshot(snapshot)
    removeRuntimeZones()

    if type(snapshot) ~= 'table' or type(snapshot.farms) ~= 'table' then
        return
    end

    for _, farm in ipairs(snapshot.farms) do
        if type(farm) == 'table' and type(farm.points) == 'table' then
            for _, point in ipairs(farm.points) do
                if type(point) == 'table' then
                    createRuntimeZone(farm, point)
                end
            end
        end
    end
end

AddStateBagChangeHandler(STAFFGANG_RUNTIME_STATE_KEY, nil, function(_, _, value)
    applyRuntimeSnapshot(value)
end)

CreateThread(function()
    applyRuntimeSnapshot(GlobalState[STAFFGANG_RUNTIME_STATE_KEY])
end)
