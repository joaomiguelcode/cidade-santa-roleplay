---Variables
local missions = exports.missions
local skillLevelUpData = nil

---@param resource string
---@param exportName string
---@return boolean
local function HasExport(resource, exportName)
    return pcall(function()
        return exports[resource][exportName]
    end)
end

---Tasks
local function UpdateTasks()
    if HasExport("missions", "GetTasksData") then
        local tasksData = missions:GetTasksData()

        -- print("UpdateTasks", json.encode(tasksData, { indent = true }))

        SendNUIMessage({
            action = "tasks.update",
            data = tasksData
        })
    end
end exports("UpdateTasks", UpdateTasks)

RegisterNUICallback("tasks.get", function(Data, Callback)
    -- print("tasks.get")

    local tasksData = {}
    if HasExport("missions", "GetTasksData") then
        tasksData = missions:GetTasksData()

        for i = 1, #tasksData do
            if tasksData[i].hideHub then
                tasksData[i] = nil
            end
        end
    end

    Callback(tasksData)
end)

RegisterNUICallback("tasks.start", function(Data, Callback)
    print("tasks.start", json.encode(Data, { indent = true }))

    Callback(true)
end)

RegisterNUICallback("tasks.subTask.start", function(Data, Callback)
    -- print("tasks.subTask.start", json.encode(Data, { indent = true }))

    if HasExport("missions", "StartMission") then
        local success = missions:StartMission(Data.subTaskId)
        if success then
            UpdateTasks()
        end
    end

    Callback(true)
end)

RegisterNUICallback("tasks.activate", function(Data, Callback)
    -- print("tasks.activate", json.encode(Data, { indent = true }))

    if HasExport("missions", "ActivateGroup") then
        local success = missions:ActivateGroup(Data.taskId)
        if success then
            UpdateTasks()
        end
    end

    Callback(true)
end)

---Achievements
local achievementsData = {
    definitions = {
        {
            achievementId = "first_kill",
            kind = "challenge", -- "challenge" | "daily" | "goals" | "popularity" | "playtime" | "commercial" | "legendary"
            displayName = "Primeiro Abate",
            description = "Elimine seu primeiro oponente.",
            opts = {
                rewards = {
                    { kind = "item", itemKey = "weapon_pistol", itemAmount = "1" }
                },
                stats = {
                    { name = "kills", threshold = 1 }
                }
            }
        }
    },
    progress = {
        {
            achievementId = "first_kill",
            status = "unlocked", -- "not_started" | "in_progress" | "unlocked" | "claimed"
            progressValue = 1,
            maxProgress = 1
        }
    }
}

RegisterNUICallback("achievements.get", function(Data, Callback)
    print("achievements.get")

    Callback(achievementsData)
end)

RegisterNUICallback("achievements.claim", function(Data, Callback)
    print("achievements.claim", json.encode(Data, { indent = true }))

    Callback(true)
end)

local function UpdateAchievements(Data)
    achievementsData = Data

    SendNUIMessage({
        action = "achievements.update",
        data = achievementsData
    })
end exports("UpdateAchievements", UpdateAchievements)

---Skills
RegisterNUICallback("skills.get", function(Data, Callback)
    -- print("skills.get")

    local skillsData = {}

    if HasExport("missions", "GetSkillsData") then
        skillsData = missions:GetSkillsData()
    end

    if skillLevelUpData then
        CreateThread(function()
            Wait(1000)

            SendNUIMessage({
                action = "skills.levelUp",
                data = {
                    level  = skillLevelUpData.level,
                    xp     = skillLevelUpData.progress,
                    maxXp  = skillLevelUpData.needed,
                    duration = 7000
                }
            })

            skillLevelUpData = nil
        end)
    end

    Callback(skillsData)
end)

RegisterNUICallback("skills.levelUp.close", function(Data, Callback)
    print("skills.levelUp.close", json.encode(Data, { indent = true }))

    Callback(true)
end)

RegisterNUICallback("skills.ped.rotate", function(Data, Callback)
    print("skills.ped.rotate", json.encode(Data, { indent = true }))

    Callback(true)
end)

local function UpdateSkills(skillsData)
    SendNUIMessage({
        action = "skills.update",
        data = skillsData
    })
end exports("UpdateSkills", UpdateSkills)

RegisterNetEvent("missions:skill_levelup", function(id, level, name, progress, needed)
    local level = tonumber(level) or 1
    local name = name or id or ""
    local progress = progress or 0
    local needed = needed or 0

    skillLevelUpData = {
        level = level,
        name = name,
        progress = progress,
        needed = needed
    }
end)

RegisterNUICallback("tasks.subTask.locate", function(Data, Callback)
    local missionId = Data.subTaskId

    if HasExport("missions", "MarkMissionCoords") then
        missions:MarkMissionCoords(missionId)
    end

    Callback(true)
end)