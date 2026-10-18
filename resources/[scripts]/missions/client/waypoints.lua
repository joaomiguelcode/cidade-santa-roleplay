-- Waypoints do HUD (`exports.hud:waypointCreate` / `waypointRemove`) por missao ativa.
-- Cria um HUD waypoint por entrada em `metadata.waypoints`, com `groupId = missionId`.
-- HUD (`hud/client/waypoint/manager.lua`) filtra: 1 ativo por grupo + 1 indicador 3D global.

local resourceName = GetCurrentResourceName()

---@type table<string, number[]>
-- byMission é populado durante a criação (não só no fim) para que removeMission
-- conseguir limpar in-flight ids se outro apply interromper no meio do loop.
local byMission = {}

-- Token bump invalida threads de apply antigas. Cada apply captura seu token
-- pós-removeMission e re-checa entre creates pra abortar limpo.
local waypointApplyCoalesce = {}

local gCityName = GetConvar("cityName", "")
local gShouldFollowMissionHudLock = gCityName == "Krown"
local gMissionWaypointsLocked = false
local gPendingMissionWaypoints = {}

local function ShouldDeferMissionWaypoints()
    if not gShouldFollowMissionHudLock then
        return false
    end

    return gMissionWaypointsLocked
end

local function removeMission(missionId)
    gPendingMissionWaypoints[missionId] = nil
    waypointApplyCoalesce[missionId] = (waypointApplyCoalesce[missionId] or 0) + 1
    local ids = byMission[missionId]
    if not ids then return end
    byMission[missionId] = nil
    for i = 1, #ids do
        pcall(function()
            exports.hud:waypointRemove(ids[i])
        end)
    end
end

local function DeferMissionWaypoints(missionId)
    removeMission(missionId)
    gPendingMissionWaypoints[missionId] = true
end

local function LockMissionWaypoints()
    if not gShouldFollowMissionHudLock then
        return
    end

    gMissionWaypointsLocked = true

    local missionIds = {}
    for missionId in pairs(byMission) do
        missionIds[#missionIds + 1] = missionId
    end

    for i = 1, #missionIds do
        DeferMissionWaypoints(missionIds[i])
    end

    sx.logger:debug(('waypoints: locked with mission HUD pending=%d'):format(#missionIds))
end

local function waypointListFromDef(def)
    local md = def and def.metadata
    if not md then return end
    if md.waypoints and #md.waypoints > 0 then return md.waypoints end
    if md.waypoint then return { md.waypoint } end
end

---@param entry table
---@param missionId string
---@param missionOrder number
---@param def table
local function buildHudPayload(entry, missionId, missionOrder, def)
    local payload = {}
    for k, v in pairs(entry) do
        payload[k] = v
    end
    payload.missionId = missionId
    payload.missionOrder = missionOrder or 0
    payload.groupId = missionId
    payload.family = entry.family or 'mission'
    -- Fallback: indicator uses mission-level icon when the waypoint entry
    -- doesn't define its own. Lets a mission declare metadata.icon once
    -- instead of repeating it on every coord (e.g. primeiras_rodas garages).
    if not payload.icon and def and def.metadata then
        payload.icon = def.metadata.icon
    end
    return payload
end

local function applyMissionWaypoints(missionId)
    if ShouldDeferMissionWaypoints() then
        DeferMissionWaypoints(missionId)
        sx.logger:debug(('waypoints: deferred missionId=%s while mission HUD is locked'):format(tostring(missionId)))
        return
    end

    waypointApplyCoalesce[missionId] = (waypointApplyCoalesce[missionId] or 0) + 1
    local entryToken = waypointApplyCoalesce[missionId]

    CreateThread(function()
        -- Debounce curto: coalesce missionStarted + updatePlayerData no mesmo frame.
        Wait(50)
        if waypointApplyCoalesce[missionId] ~= entryToken then
            return
        end

        local def = GetMissionDefinition(missionId)
        local list = waypointListFromDef(def)
        if not list then return end

        local deadline = GetGameTimer() + 30000
        while GetResourceState("hud") ~= "started" and GetGameTimer() < deadline do
            Wait(100)
        end
        if GetResourceState("hud") ~= "started" then
            sx.logger:warn(('waypoints: hud not started for missionId=%s'):format(missionId))
            return
        end

        -- removeMission limpa ids prévios E bumpa o token. Re-snapshotar após o remove
        -- pra que apenas calls externos posteriores invalidem nossa thread.
        removeMission(missionId)
        local token = waypointApplyCoalesce[missionId]

        local missionOrder = def and def.order or 0
        -- Tracking live: novos ids vão direto pro byMission, então remove externo
        -- consegue cancelar in-flight creates.
        local ids = {}
        byMission[missionId] = ids

        for i = 1, #list do
            -- Apply mais novo invalidou esse: aborta. Os ids já em byMission serão
            -- removidos pelo proximo removeMission do novo apply.
            if waypointApplyCoalesce[missionId] ~= token then
                return
            end

            local entry = list[i]
            local payload = buildHudPayload(entry, missionId, missionOrder, def)

            if entry.onWaypointEnter then
                payload.onWaypointEnter = {
                    distance = entry.onWaypointEnter.distance,
                    action = function(hudId)
                        pcall(function()
                            exports.hud:waypointRemove(hudId)
                        end)

                        local st = byMission[missionId]
                        if not st then return end
                        for j = 1, #st do
                            if st[j] == hudId then
                                table.remove(st, j)
                                break
                            end
                        end
                        if #st == 0 then
                            byMission[missionId] = nil
                        end
                    end,
                }
            end

            local ok, hudIdOrErr = pcall(function()
                return exports.hud:waypointCreate(payload)
            end)

            if ok and hudIdOrErr then
                -- Re-checa após o create caso outro apply tenha entrado durante a chamada;
                -- se sim, devolve o id que acabamos de criar e sai.
                if waypointApplyCoalesce[missionId] ~= token or byMission[missionId] ~= ids then
                    pcall(function() exports.hud:waypointRemove(hudIdOrErr) end)
                    return
                end
                ids[#ids + 1] = hudIdOrErr
            else
                sx.logger:warn(('waypoints: waypointCreate failed missionId=%s idx=%d'):format(missionId, i))
            end
        end

        if #ids == 0 then
            byMission[missionId] = nil
        else
            sx.logger:debug(('waypoints: applied missionId=%s total=%d'):format(missionId, #ids))
        end
    end)
end

local function UnlockMissionWaypoints()
    if not gShouldFollowMissionHudLock then
        return
    end

    if not gMissionWaypointsLocked then
        return
    end

    gMissionWaypointsLocked = false

    local missionIds = {}
    for missionId in pairs(gPendingMissionWaypoints) do
        missionIds[#missionIds + 1] = missionId
    end
    gPendingMissionWaypoints = {}

    sx.logger:debug(('waypoints: unlocked with mission HUD pending=%d'):format(#missionIds))

    for i = 1, #missionIds do
        applyMissionWaypoints(missionIds[i])
    end
end

RegisterNetEvent("missions:client:lockHud", function()
    LockMissionWaypoints()
end)

RegisterNetEvent("missions:client:unlockHud", function()
    UnlockMissionWaypoints()
end)

RegisterNetEvent("missions:client:missionStarted", function(missionId)
    sx.logger:debug(('waypoints: missionStarted event missionId=%s'):format(tostring(missionId)))
    applyMissionWaypoints(missionId)
end)

AddEventHandler("missions:updatePlayerData", function(playerData)
    if not playerData then
        sx.logger:debug("waypoints: updatePlayerData nil payload")
        return
    end
    local missions = playerData.missions or {}

    local wanted = {}
    if playerData.enabled ~= false then
        for missionId, row in pairs(missions) do
            if type(row) == "table" and not row.completed_at and waypointListFromDef(GetMissionDefinition(missionId)) then
                wanted[missionId] = true
                applyMissionWaypoints(missionId)
            end
        end
    end

    local function purge(state)
        for missionId in pairs(state) do
            if not wanted[missionId] then removeMission(missionId) end
        end
    end
    purge(byMission)
    purge(gPendingMissionWaypoints)
end)

RegisterNetEvent("missions:client:missionCompleted", function(missionId)
    removeMission(missionId)
end)

AddEventHandler("onResourceStop", function(res)
    if res ~= resourceName then return end
    local mids = {}
    for mid in pairs(byMission) do
        mids[#mids + 1] = mid
    end
    for i = 1, #mids do
        removeMission(mids[i])
    end
end)
