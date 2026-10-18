---@type string
local tutorialWaypointIcon = "https://cdn.santagroup.gg/onboarding/pequeno.svg"

---@type table<string, table<number, {title: string, coords: vec3}>>
local tutorialWaypoints = {
    ["tutorial.ui.chest"] = {
        {
            title = _t("tutorial.waypoint.point_of_interest"),
            coords = vec3(118.92, -1088.46, 29.23),
        },
        {
            title = _t("tutorial.waypoint.point_of_interest"),
            coords = vec3(1419.60, 6566.65, 18.54),
        }
    },
}

---@type table<string, table<number, number>>
local activeWaypoints = {}

local function StartTutorialWaypoints()
    Wait(1000)

    local deadline = GetGameTimer() + 30000
    while GetResourceState("hud") ~= "started" and GetGameTimer() < deadline do
        Wait(100)
    end

    if GetResourceState("hud") ~= "started" then
        sx.logger:warn("waypoints: hud not started")
        return
    end

    for tutorialId, waypoints in pairs(tutorialWaypoints) do
        if exports.tutorial:CanStartUiTutorial(tutorialId) then
            activeWaypoints[tutorialId] = {}

            for i = 1, #waypoints do
                local waypoint = waypoints[i]

                local id = exports.hud:waypointCreate({
                    coords = waypoint.coords,
                    title = waypoint.title,
                    icon = tutorialWaypointIcon,
                    indicatorDistance = 80.0,
                    seeThroughWalls = true,
                    markerDistance = 9999.0,
                    showDistance = 200.0,
                })

                activeWaypoints[tutorialId][#activeWaypoints[tutorialId] + 1] = id
            end
        end
    end
end
RegisterNetEvent("vRP:Active", StartTutorialWaypoints)

---@param tutorialId string
function RemoveTutorialWaypoints(tutorialId)
    if not activeWaypoints[tutorialId] then return end

    for i = 1, #activeWaypoints[tutorialId] do
        exports.hud:waypointRemove(activeWaypoints[tutorialId][i])
    end

    activeWaypoints[tutorialId] = nil
end

---@param resource string
AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end

    for tutorialId, waypoints in pairs(tutorialWaypoints) do
        RemoveTutorialWaypoints(tutorialId)
    end
end)