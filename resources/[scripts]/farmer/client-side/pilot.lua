local SELECTED_ROUTE = nil
local CURRENT_WAYPOINT = nil
local START_AIRPORT = nil
local ON_DELIVERY = false
local AIRPORT_BLIP = nil

--- @return nil or string if closest aiport
function GetClosestAirport()
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    local closest = nil
    local distance = 1000
    for k,v in pairs(START_COORDS_AIRPORT) do 
        local dist = #(vector3(v.Coords) - pcoords)
        if dist < distance then 
            distance = dist
            closest = v.Airport
        end
    end
    return closest
end

CreateThread(function()
    while true do
        local Idle = 1500
        if not ON_DELIVERY then
            local pcoords = GetEntityCoords(PlayerPedId())
            for k,v in pairs(START_COORDS_AIRPORT) do 
                local distance = #(vector3(v.Coords) - pcoords)
                if distance <= 20.0 then
                    Idle = 0
                    DrawMarker(6, v.Coords.x, v.Coords.y, v.Coords.z - 1.0, 0, 0, 0, -90, 0, 0, 1.0, 1.0, 1.0, THEME.rgb.r, THEME.rgb.g, THEME.rgb.b, 200, 0, 0, 0, 0, 0, 0, 0)
                end
                if distance <= 5.5 then 
                    DrawText3D(v.Coords.x, v.Coords.y, v.Coords.z, _t("pilotMenu"))
                    if IsControlJustPressed(0, 38) then 
                        START_AIRPORT = v.Airport
                        OpenStartMenu()
                    end
                end
            end
        end
        Wait(Idle)
    end
end)

--- @param 
function CreateBlipPilot(Coords)
    if AIRPORT_BLIP and DoesBlipExist(AIRPORT_BLIP) then
        RemoveBlip(AIRPORT_BLIP)
    end
    local blip = AddBlipForCoord(Coords.x, Coords.y, Coords.z)
    SetBlipSprite(blip, 865)
    SetBlipColour(blip, 5)
    SetBlipScale(blip, 0.8)
    SetBlipRoute(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_t("route"))
    EndTextCommandSetBlipName(blip)
    AIRPORT_BLIP = blip
end

function CheckMinimumRange(Coords, Range)
    local pcoords = GetEntityCoords(PlayerPedId())
    if #(vector3(Coords) - pcoords) <= Range then 
        return true
    end
end

-- Opens the start menu for the pilot.
-- This function hides the current menu, registers a new menu for the pilot, and shows the pilot menu.
-- It also checks if the pilot is within the minimum range of the delivery location and starts the pilot job if not.
-- If the pilot is too close to the delivery location, it displays a notification.
function OpenStartMenu()
    lib.hideMenu()
    lib.registerMenu({
        id = 'pilot-menu',
        title = 'Piloto',
        position = 'top-left',
        onSideScroll = function(selected, scrollIndex, args)
        end,
        onSelected = function(selected, scrollIndex, args) 
        end,
        onClose = function(keyPressed)
        end,
        options = AIRPORT_ROUTES
    }, function(selected, scrollIndex, args)
        local Coords = AIRPORT_ROUTES[selected]["coordinates"][START_AIRPORT][#AIRPORT_ROUTES[selected]["coordinates"][START_AIRPORT]]
        if not CheckMinimumRange(Coords, 300) then
            CURRENT_WAYPOINT = 1
            SELECTED_ROUTE = selected
            StartPilotJob()
        else
            --TriggerEvent("Notify", "vermelho", "Você está muito perto do local de entrega.")
            TriggerEvent("Notify2","#pertoLocalEntrega")
        end
    end)
    lib.showMenu('pilot-menu')
end

-- CheckHeight function calculates the height difference between the player's coordinates and the given coordinates.
-- It returns a text message indicating whether the player needs to descend or ascend to reach the given height.
-- 
-- Parameters:
--   - Coords: A table containing the x, y, and z coordinates to compare with the player's coordinates.
-- 
-- Returns:
--   - Text: A string message indicating whether the player needs to descend or ascend to reach the given height.
function CheckHeight(Coords)
    local pcoords = GetEntityCoords(PlayerPedId())
    local height = pcoords.z - Coords.z
    local Text = "Mantenha Altura"
    if height >= 20.0 then
        Text = "Desca para "..tD(Coords.z).. " pés <br> Atual: "..tD(pcoords.z).. " pés"
    elseif height <= -20.0 then
        Text = "Suba para "..tD(Coords.z).. " pés <br> Atual: "..tD(pcoords.z).. " pés"
    end
    return Text
end

function StartPilotJob()
    exports['hint']:Show("Entre em um avião e prossiga para a rota.", "Piloto", true)
    ON_DELIVERY = true
    TriggerServerEvent("pilot:StartJob", SELECTED_ROUTE, START_AIRPORT)
    CreateThread(function()
        while ON_DELIVERY do
            local Ped = PlayerPedId()
            local Coords = GetEntityCoords(Ped)
            local Veh = GetVehiclePedIsIn(Ped, false)
            local vehModel = GetEntityModel(Veh)
            local currentCoords = AIRPORT_ROUTES[SELECTED_ROUTE]["coordinates"][START_AIRPORT][CURRENT_WAYPOINT]
            local Text = "Entre em um avião e prossiga para a rota."
            local isInPlane = false
            if not Veh then
                Text = "Entre em um avião e prossiga para a rota."
            else
                isInPlane = IsThisModelAPlane(vehModel)
                if isInPlane then
                    Text = "Prossiga para a rota."
                    if CURRENT_WAYPOINT and CURRENT_WAYPOINT > 1 then
                        local heightText = CheckHeight(currentCoords)
                        if heightText then
                            Text = heightText
                        end
                    end
                end
            end

            local currentText = exports['hint']:currentText()
            local isOpen = exports['hint']:isOpen()

            if isOpen then
                exports['hint']:UpdateText(Text, "Piloto")
            else
                exports['hint']:Show(Text, "Piloto")
            end
            DrawMarker(6,  currentCoords.x, currentCoords.y, currentCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 10.0, 10.0, 10.0, THEME.rgb.r, THEME.rgb.g, THEME.rgb.b , 220, 0, 1, 2, 0, nil, nil, 0)
            local Distance = #(Coords - vector3(currentCoords))
            if Distance <= 10.0 and isInPlane then
                --print("Distance: "..Distance.." Waypoint: "..CURRENT_WAYPOINT.." Total: "..#AIRPORT_ROUTES[SELECTED_ROUTE]["coordinates"][START_AIRPORT])
                if CURRENT_WAYPOINT == #AIRPORT_ROUTES[SELECTED_ROUTE]["coordinates"][START_AIRPORT] then
                    TriggerServerEvent("pilot:NextCoord")
                    CURRENT_WAYPOINT = 1
                else
                    CURRENT_WAYPOINT = CURRENT_WAYPOINT + 1
                    TriggerServerEvent("pilot:NextCoord")
                end
            end
            Wait(1)
        end
    end)
end


RegisterNetEvent("pilot:NextCoord")
AddEventHandler("pilot:NextCoord",function(Next)
    CURRENT_WAYPOINT = Next
    local Coords = AIRPORT_ROUTES[SELECTED_ROUTE]["coordinates"][START_AIRPORT][CURRENT_WAYPOINT]
    CreateBlipPilot(Coords)
end)

RegisterNetEvent("pilot:FinishJob")
AddEventHandler("pilot:FinishJob",function()
    ON_DELIVERY = false
    SELECTED_ROUTE = nil
    CURRENT_WAYPOINT = nil
    START_AIRPORT = nil
    if AIRPORT_BLIP and DoesBlipExist(AIRPORT_BLIP) then
        RemoveBlip(AIRPORT_BLIP)
    end
    local airport = GetClosestAirport()
    if airport then
        START_AIRPORT = airport
        OpenStartMenu()
    end
end)