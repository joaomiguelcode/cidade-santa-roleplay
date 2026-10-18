---@type boolean
local mecStart = false

---@type string
local mecName = ""
---@type number
local mecDistance = 999
---@type vector3
local mecCoords = vec3(0.0, 0.0, 0.0)
---@type number | nil
local mecBlip = nil

---@type table<number, number>
local rgbMec = { 190, 0, 0, 0.5 }

---@param text string
---@param color table<number, number>
AddEventHandler("player:acceptCallMec",function(text, color)
    -- SendNUIMessage({ action = "CallMec", data = { text = text, color = color } })
end)

---@param name string
---@param distance number
---@return string
function FormatTextDistance(name, distance)
    local text = name
    if distance then
        text = string.format(_t("waitMec"), name, parseInt(distance))
    end

    return text
end

---@param name string
---@param distance number
RegisterNetEvent("player:callMecStart", function(name, distance) -- target
    mecName = name
    mecDistance = distance
    mecStart = true

    CreateThread(function()
        while mecStart do
            TriggerEvent("player:acceptCallMec", FormatTextDistance(mecName, mecDistance), { 0, 175, 47, 0.5 })

            Wait(1000)
        end
    end)
end)

RegisterNetEvent("player:stopCallMec", function()
    mecStart = false
    mecName = ""
    mecDistance = 999
    mecCoords = vec3(0.0, 0.0, 0.0)

    if mecBlip and DoesBlipExist(mecBlip) then
        RemoveBlip(mecBlip)
    end

    mecBlip = nil
end)

---@param coords vector3
RegisterNetEvent("player:callMecUpdate", function(coords)
    local distance = #(GetEntityCoords(PlayerPedId()) - coords)

    mecDistance = distance
    mecCoords = coords

    if mecBlip and DoesBlipExist(mecBlip) then
        SetBlipCoords(mecBlip, coords.x, coords.y, coords.z)
    end
end)

---@param text string
---@param color table<number, number>
AddEventHandler("player:initCallMec", function(text, color)
    if mecBlip and DoesBlipExist(mecBlip) then
        RemoveBlip(mecBlip)
    end

    mecBlip = AddBlipForCoord(mecCoords.x, mecCoords.y, mecCoords.z)
    SetBlipSprite(mecBlip, 425)
    SetBlipAlpha(mecBlip, 255)
    SetBlipScale(mecBlip, 0.6)
    SetBlipColour(mecBlip, 1)
    SetBlipDisplay(mecBlip, 4)
    SetBlipFlashes(mecBlip, true)
    SetBlipRoute(mecBlip, true)
    SetBlipRouteColour(mecBlip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("ATENDIMENTO MECÂNICO")
    EndTextCommandSetBlipName(mecBlip)

    -- SendNUIMessage({ action = "CallPlayer", data = { text = text, color = color } })
end)

---@param name string
---@param distance number
---@return string
function FormatTextDistanceMec(name, distance)
    local text = name
    if distance then
        text = string.format(_t("mecDistance"), name, parseInt(distance))
    end
    
    return text
end

local function onShowInteractionMarker()
    CreateThread(function()
        while mecStart do
            local msec = 1000

            if mecDistance <= 60.0 then
                DrawMarker(2, mecCoords.x, mecCoords.y, mecCoords.z, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)  
                msec = 5
            end

            Wait(msec)
        end
    end)
end

---@param name string
---@param distance number
RegisterNetEvent("player:callPlayerStart", function(name, distance) -- mec
    mecName = name
    mecDistance = distance
    mecStart = true

    onShowInteractionMarker()

    CreateThread(function()
        while mecStart do
            if mecDistance >= 500 then
                rgbMec = { 190, 0, 0, 0.5}
            elseif mecDistance >= 250 and mecDistance < 500 then
                rgbMec = { 255, 255, 102, 0.5 }
            elseif mecDistance <= 100 then
                rgbMec = { 0, 175, 47, 0.5 }
            end

            TriggerEvent("player:initCallMec", FormatTextDistanceMec(mecName, mecDistance), rgbMec)

            -- if mecDistance <= 5 then
            --     mecStart = false
            --     SendNUIMessage({ action = "setVisible", data = false })
            -- end

            Wait(1000)
        end
    end)
end)