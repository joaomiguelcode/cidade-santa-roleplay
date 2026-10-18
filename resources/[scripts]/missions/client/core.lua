-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Client = {}
Tunnel.bindInterface("missions", Client)
vSERVER = Tunnel.getInterface("missions")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
gPlayerData = {}

---@return boolean
local function IsMissionUiBlocked()

    if GetConvar("cityName", "") ~= "CidadeNobre" then return false end

    local groups = vRP.GetPlayerGroups()

    return groups == nil or groups["Special3"] ~= nil or groups["Special5"] ~= nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPEN PANEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("missions:openPanel", function(playerData)
    if IsMissionUiBlocked() then return end
    -- print(json.encode(playerData, { indent = true }))
    if not playerData then return end
    playerData.missions = playerData.missions or {}
    playerData.groups = playerData.groups or {}

    local skillsOptions = {}

    if playerData.skills then
        for skillId, skillValue in pairs(playerData.skills) do
            local skillData = GetSkillDefinition(skillId)
            if skillData then
                skillsOptions[#skillsOptions + 1] = {
                    title = skillData.name,
                    description = FormatSkillProgress(skillValue),
                    icon = "fa-solid fa-star",
                    progress = GetSkillPercentage(skillValue),
                    colorScheme = "green"
                }
            end
        end

        table.sort(skillsOptions, function(a, b)
            return a.title < b.title
        end)
    end

    lib.registerContext({
        id = "skills_menu",
        title = "Skills",
        options = skillsOptions,
        menu = "missions_menu"
    })

    local groupsOptions = {}
    local groupMissionsOptions = {}
    
    for groupId, groupData in pairs(gMissionGroupDefinitionsByName) do
        if groupData.missions then
            groupMissionsOptions[groupId] = {}

            if not playerData.groups[groupId] then
                groupMissionsOptions[groupId][#groupMissionsOptions[groupId] + 1] = {
                    title = "Ativar Grupo",
                    description = "Ativar o grupo " .. groupData.name,
                    icon = "fa-solid fa-play",
                    onSelect = function()
                        local success = vSERVER.ActivateGroup(groupId)
                        if success then
                            TriggerEvent("Notify", "Confirmed", "Grupo ativado com sucesso", 5000)
                        end
                    end
                }
            else
                for i = 1, #groupData.missions do
                    local missionData = groupData.missions[i]
                    local missionId = missionData.id

                    if MissionRamoMatchesPlayer(playerData.ramo, missionData) then
                        groupMissionsOptions[groupId][#groupMissionsOptions[groupId] + 1] = {
                            title = missionData.name,
                            description = missionData.description,
                            icon = "fa-solid fa-tasks",
                            iconColor = playerData.missions[missionId] and (playerData.missions[missionId].completed_at and "green" or "yellow"),
                            onSelect = not playerData.missions[missionId] and function()
                                local success = vSERVER.StartMission(missionId)
                                if success then
                                    TriggerEvent("Notify", "Confirmed", _t("notify.mission_started"), 5000)
                                end
                            end,
                            order = missionData.order
                        }
                    end
                end

                if #groupMissionsOptions[groupId] > 1 then
                    table.sort(groupMissionsOptions[groupId], function(a, b)
                        return a.order < b.order
                    end)
                end
            end

            lib.registerContext({
                id = "group_missions_menu_" .. groupId,
                title = (_t("dialog.missions_group_title")):format(groupData.name),
                options = groupMissionsOptions[groupId],
                menu = "groups_menu"
            })
        end

        groupsOptions[#groupsOptions + 1] = {
            title = groupData.name,
            description = groupData.description,
            icon = "fa-solid fa-users",
            menu = "group_missions_menu_" .. groupId,
            index = groupData.index
        }
    end

    table.sort(groupsOptions, function(a, b)
        return a.index < b.index
    end)

    lib.registerContext({
        id = "groups_menu",
        title = "Groups",
        options = groupsOptions,
        menu = "missions_menu"
    })

    lib.registerContext({
        id = "missions_menu",
        title = "Missions",
        options = {
            {
                title = "Skills",
                icon = "fa-solid fa-star",
                menu = "skills_menu"
            },
            {
                title = _t("dialog.missions_title"),
                icon = "fa-solid fa-tasks",
                menu = "groups_menu"
            }
        }
    })

    lib.showContext("missions_menu")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKILLS
-----------------------------------------------------------------------------------------------------------------------------------------
local function GetSkillsData()
    local skillsData = {}

    local skills = gPlayerData.skills
    if skills then
        for skillId, skillValue in pairs(skills) do
            local skillData = GetSkillDefinition(skillId)
            if not skillData then goto continue end

            skillsData[#skillsData + 1] = {
                id = skillId,
                name = skillData.name,
                description = skillData.description,
                level = GetSkillLevel(skillValue),
                maxLevel = MAX_SKILL_LEVEL,
                progress = GetSkillPercentage(skillValue),
                showPercent = true
            }
            ::continue::
        end

        table.sort(skillsData, function(a, b)
            return a.name < b.name
        end)
    end

    return skillsData
end exports("GetSkillsData", GetSkillsData)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TASKS
-----------------------------------------------------------------------------------------------------------------------------------------
local _tasksDataCache = nil

---@param missionData table
---@param playerData table
---@return boolean visible
local function IsMissionVisibleForPlayer( missionData, playerData )

    local metadata = missionData.metadata

    if not metadata then
        return true
    end

    local isFacOwner = playerData.facMissionOwner == true

    if metadata.faction_owner_only and not isFacOwner then
        return false
    end

    if metadata.hide_for_faction_owner and isFacOwner then
        return false
    end

    if metadata.hide_when_employed and playerData.hasJob then
        return false
    end

    return true
end

---@param missionData table
---@param missionState table|nil
---@return number current
---@return number max
---@return string status
local function GetMissionTaskProgress(missionData, missionState)
    if missionData.metadata and missionData.metadata.recurring_count then
        local step = missionData.metadata.count_step or 10
        local multiplier = missionData.metadata.count_multiplier or 1
        local increment = missionData.metadata.count_increment
        local count = missionState and missionState.count or 0

        if increment and increment > 0 then
            local current = count
            local target = step

            while current >= target do
                current = current - target
                target = target + increment
            end

            return current, target, missionState and "in_progress" or "active"
        end

        if multiplier <= 1 then
            local target = (math.floor(count / step) + 1) * step
            return count, target, missionState and "in_progress" or "active"
        end

        local current = count
        local target = step

        while current >= target do
            current = current - target
            target = target * multiplier
        end

        return current, target, missionState and "in_progress" or "active"
    end

    local status = "active"
    if missionState then
        status = missionState.completed_at and "completed" or "in_progress"
    end

    return status == "completed" and 1 or 0, 1, status
end

---@return table
local function GetTasksData()
    if IsMissionUiBlocked() then return {} end
    if _tasksDataCache then return _tasksDataCache end

    local tasksData = {}

    local playerData = gPlayerData
    if playerData then
        local missions = playerData.missions or {}
        local groups = playerData.groups or {}
        -- print(json.encode(playerData, { indent = true }))
        -- print(json.encode(gMissionGroupDefinitionsByName, { indent = true }))

        for groupId, groupData in pairs(gMissionGroupDefinitionsByName) do
            local subTasks = {}

            local numMissions = 0
            local numCompleted = 0

            if groupData.missions then
                for i = 1, #groupData.missions do
                    local missionData = groupData.missions[i]

                    if IsMissionVisibleForPlayer( missionData, playerData )
                        and MissionRamoMatchesPlayer(playerData.ramo, missionData) then
                        numMissions = numMissions + 1

                        local current, max, subTaskStatus = GetMissionTaskProgress(missionData, missions[missionData.id])

                        if subTaskStatus == "completed" then
                            numCompleted = numCompleted + 1
                        elseif missionData.metadata and missionData.metadata.recurring_count then
                            numCompleted = numCompleted + math.min(current, max)
                            numMissions = numMissions + max - 1
                        end

                        local missionDescription = missionData.description

                        if missionData.metadata and (
                            missionData.metadata.count_multiplier or missionData.metadata.count_increment ) then
                            missionDescription = missionDescription:format(max)
                        end

                        subTasks[#subTasks + 1] = {
                            id = missionData.id,
                            name = missionData.name,
                            description = missionDescription,
                            icon = missionData.icon,
                            rewardIcon = missionData.rewardIcon,
                            current = current,
                            max = max,
                            status = subTaskStatus,
                            order = missionData.order,
                            waypoints = missionData.metadata and missionData.metadata.waypoints or nil,
                            hasMap = missionData.coords and #missionData.coords > 0 and true or false,
                        }
                    end
                end

                table.sort(subTasks, function(a, b)
                    return a.order < b.order
                end)
            end

            local taskStatus = "available"
            if groups[groupId] then
                taskStatus = groups[groupId] and groups[groupId].completed_at and "completed" or "active"
            end

            if groupData.locked then
                taskStatus = "locked"
            end

            if groupId == "criminal" and playerData.hasIllegalGroup ~= true then
                taskStatus = "locked"
            end

            tasksData[#tasksData + 1] = {
                index = groupData.index,
                id = groupId,
                name = groupData.name,
                description = groupData.description,
                icon = groupData.icon, -- Emoji ou URL de ícone
                current = numCompleted,
                max = numMissions,
                status = taskStatus, -- "active" | "completed" | "locked" | "available"
                rewards = groupData.rewardsIcons, -- Lista de emojis ou ícones
                subTasks = subTasks, -- Opcional
                hideHub = groupData.hideHub
            }
        end

        table.sort(tasksData, function(a, b)
            return a.index < b.index
        end)
    end

    -- print(json.encode(tasksData, { indent = true }))

    _tasksDataCache = tasksData
    return tasksData
end exports("GetTasksData", GetTasksData)

---@return boolean
local function IsFacMissionOwner()

    return gPlayerData and gPlayerData.facMissionOwner == true or false
end

exports("IsFacMissionOwner", IsFacMissionOwner)

---@param groupId string
---@return boolean success, string error message
local function ActivateGroup(groupId)
    if IsMissionUiBlocked() then return false end
    local success, err = vSERVER.ActivateGroup(groupId)
    return success, err
end exports("ActivateGroup", ActivateGroup)

---@param missionId string
---@return boolean success, string error message
local function StartMission(missionId)
    if IsMissionUiBlocked() then return false end
    local success, err = vSERVER.StartMission(missionId)
    return success, err
end exports("StartMission", StartMission)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE PLAYER DATA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("missions:updatePlayerData")
AddEventHandler("missions:updatePlayerData", function(playerData)
    if not playerData then return end
    playerData.missions = playerData.missions or {}
    playerData.groups = playerData.groups or {}
    playerData.skills = playerData.skills or {}
    gPlayerData = playerData
    _tasksDataCache = nil
end)

local function RefreshFacMissionAfterGroupChange()

    CreateThread( function()
        Wait( 250 )
        if IsMissionUiBlocked() then
            local context = lib.getOpenContextMenu()
            if context and (context == "missions_menu" or context:find("^group_missions_menu_")) then
                lib.hideContext(false)
            end
        end
        if GetResourceState("new_hub") == "started" then
            exports.new_hub:UpdateTasks()
        end
        TriggerServerEvent( "missions:server:refreshFacMission" )
    end )
end

AddEventHandler( "playerGroups:AddGroup", RefreshFacMissionAfterGroupChange )
AddEventHandler( "playerGroups:RemoveGroup", RefreshFacMissionAfterGroupChange )

-----------------------------------------------------------------------------------------------------------------------------------------
-- SKILL LEVEL UP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("missions:skill_levelup")
AddEventHandler("missions:skill_levelup", function()
    if IsMissionUiBlocked() then return end
    TriggerEvent('sounds:Private', 'https://cdn.santagroup.gg/493563ae-c648-4de4-b6cb-d8899b14c4b0-es_user_interface__alert__notification__video_game__positive__level_up__next_stage__achievement_02_-_epidemic_sound.mp3', 0.3)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MISSION IN PROGRESS
-----------------------------------------------------------------------------------------------------------------------------------------
---@param missionId string
---@return boolean
function MissionInProgress(missionId)
    if not gPlayerData then return false end

    local missions = gPlayerData.missions or {}
    local row = missions[missionId]

    return row ~= nil and row.completed_at == nil
end exports("MissionInProgress", MissionInProgress)

---@param missionId string
---@return boolean
function MissionNotCompleted(missionId)
    if not gPlayerData then
        return true
    end

    local row = (gPlayerData.missions or {})[missionId]
    return not (row and row.completed_at)
end
exports("MissionNotCompleted", MissionNotCompleted)

---@param missionId string
---@return boolean
function MissionCompleted(missionId)
    if not gPlayerData then return false end

    local missions = gPlayerData.missions or {}
    local row = missions[missionId]

    return row ~= nil and row.completed_at ~= nil
end exports("MissionCompleted", MissionCompleted)

--- Ramo escolhido no character creator (ex.: criminoso, empresario, produtor), vindo do sync `missions:updatePlayerData`.
---@return string|nil
function GetPlayerRamo()
    if not gPlayerData then
        return nil
    end
    local r = gPlayerData.ramo
    if type(r) ~= 'string' or r == '' then
        return nil
    end
    return r
end
exports("GetPlayerRamo", GetPlayerRamo)

---@type table<string, number>
local _waypointMarks = {}

---@param key string
local function RemWaypointMission( key )
    local id = _waypointMarks[ key ]

    if not id then
        return
    end

    _waypointMarks[ key ] = nil

    pcall(
        function()
            exports.hud:waypointRemove( id )
        end
    )
end

exports( 'RemWaypointMission', RemWaypointMission )

---@param coordsInput vector3|vector3[]
---@return vector3|nil
local function ResolveClosestCoord( coordsInput )
    if not coordsInput then
        return nil
    end

    if coordsInput.x then
        return coordsInput
    end

    if #coordsInput == 0 then
        return nil
    end

    local playerCoords = GetEntityCoords( PlayerPedId() )
    local closest      = nil
    local closestDist  = math.huge

    for i = 1, #coordsInput do
        local c        = coordsInput[ i ]
        local distance = #( playerCoords - vec3( c.x, c.y, c.z or 0.0 ) )

        if distance < closestDist then
            closestDist = distance
            closest     = c
        end
    end

    return closest
end

---@param opts { key: string, coords: vector3|vector3[], title?: string, icon?: string, missionId?: string, missionOrder?: number, groupId?: string, notify?: { type?: string, message: string, duration?: number, title?: string } }
---@return boolean
local function AddWaypointToMission( opts )
    if not opts or not opts.key then
        return false
    end

    local coords = ResolveClosestCoord( opts.coords )

    if not coords then
        return false
    end

    RemWaypointMission( opts.key )

    SetNewWaypoint( coords.x, coords.y )

    if opts.notify and opts.notify.message then
        TriggerEvent(
            'Notify',
            opts.notify.type or 'Confirmed',
            opts.notify.message,
            opts.notify.duration or 5000,
            opts.notify.title
        )
    end

    local key = opts.key

    local payload = {
        coords             = vec3( coords.x, coords.y, coords.z or 0.0 ),
        title              = opts.title or 'Marcador',
        icon               = opts.icon,
        missionId          = opts.missionId,
        missionOrder       = opts.missionOrder,
        groupId            = opts.groupId or ('waypoint_mark_%s'):format( key ),
        family             = 'mission',
        markerDistance     = 300.0,
        indicatorDistance  = 80.0,
        seeThroughWalls    = true,
        alwaysVisibleDui   = true,
        onWaypointEnter    = {
            distance = 2.0,
            action   = function()
                RemWaypointMission( key )
            end,
        },
    }

    local ok, idOrErr = pcall(
        function()
            return exports.hud:waypointCreate( payload )
        end
    )

    if not ok or not idOrErr then
        sx.logger:warn( ('AddWaypointToMission: waypointCreate falhou key=%s'):format( tostring( key ) ) )
        return false
    end

    _waypointMarks[ key ] = idOrErr

    return true
end

exports( 'AddWaypointToMission', AddWaypointToMission )

---@param missionId string
function MarkMissionCoords( missionId )
    local missionData = GetMissionDefinition( missionId )

    if not missionData then
        return
    end

    if not missionData.coords or #missionData.coords == 0 then
        return
    end

    AddWaypointToMission(
        {
            key          = missionId,
            coords       = missionData.coords,
            title        = missionData.name,
            icon         = missionData.icon or (missionData.metadata and missionData.metadata.icon),
            missionId    = missionId,
            missionOrder = missionData.order or 0,
            groupId      = ('hub_mark_%s'):format( missionId ),
            notify       = {
                type     = 'Confirmed',
                message  = _t("notify.mission_waypoint_marked"),
                duration = 5000
            },
        }
    )
end

exports( 'MarkMissionCoords', MarkMissionCoords )

---@param missionId string
RegisterNetEvent( 'missions:client:missionCompleted', function( missionId )
    RemWaypointMission( missionId )
end)

AddEventHandler( 'onResourceStop', function( res )
    if res ~= GetCurrentResourceName() then
        return
    end

    for key in pairs( _waypointMarks ) do
        RemWaypointMission( key )
    end
end)
