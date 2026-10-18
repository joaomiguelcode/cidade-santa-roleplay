Tunnel = module("vrp","lib/Tunnel")
Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPS = Tunnel.getInterface("vRP")
vSERVER = Tunnel.getInterface("farmer")
Creative = {}
Tunnel.bindInterface("farmer",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Displayed = {}
LocalPlayer["state"]["AnyJob"] = false
LocalPlayer["state"]["JobAutoPilot"] = false
local Mining = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- INPUTTARGETPOSITION
-----------------------------------------------------------------------------------------------------------------------------------------
function InputTargetPosition(Number,v)
	if v["Model"] == "prop_money_bag_01" then
		exports["target"]:AddBoxZone("Farmer:"..Number,v["Coords"],v["Width"],v["Width"],{
			name = "Farmer:"..Number,
			heading = v["Heading"],
			minZ = v["Coords"]["z"] - 1.0,
			maxZ = v["Coords"]["z"] - 0.5
		},{
			shop = Number,
			Distance = v["Distance"],
			options = {
				{
					event = v["Event"],
					label = v["Label"],
					tunnel = "server"
				}
			}
		})
	else
		exports["target"]:AddCircleZone("Farmer:"..Number,v["Coords"],v["Width"],{
			name = "Farmer:"..Number,
			heading = v["Heading"]
		},{
			shop = Number,
			Distance = v["Distance"],
			options = {
				{
					event = v["Event"],
					label = v["Label"],
					tunnel = "server"
				}
			}
		})
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)

		for Number,v in pairs(Objects) do
			if #(Coords - v["Coords"]) <= v["Show"] then
                async(function()
                    Wait(5000)
                    if not Displayed[Number] and LoadModel(v["Model"]) then
                        Displayed[Number] = CreateObjectNoOffset(v["Model"],v["Coords"]["x"],v["Coords"]["y"],v["Coords"]["z"] - v["Height"],false,false,false)
                        SetEntityHeading(Displayed[Number],v["Heading"])
                        FreezeEntityPosition(Displayed[Number],true)
                        SetModelAsNoLongerNeeded(v["Model"])
                        --InputTargetPosition(Number,v)
                    end
                end)
			else
				if Displayed[Number] then
					exports["target"]:RemCircleZone("Farmer:"..Number)

					if DoesEntityExist(Displayed[Number]) then
						DeleteEntity(Displayed[Number])
						Displayed[Number] = nil
					end
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FARMER:REMOVER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("farmer:Remover")
AddEventHandler("farmer:Remover",function(Number,Timers)
	if Objects[Number] then
		Objects[Number]["Time"] = Timers

		if Displayed[Number] then
			exports["target"]:RemCircleZone("Farmer:"..Number)

			if DoesEntityExist(Displayed[Number]) then
				DeleteEntity(Displayed[Number])
				Displayed[Number] = nil
			end
		end
	end
end)

RegisterNUICallback("getCityName",function(Data,Callback)
    cityName = GetConvar("cityName", "")
    Callback(string.lower(cityName))
end)

CreateThread(function()
    Wait(1000)
    local Table = {}
    for i=1, #MinerCoord do
        Table[i] = {
            MinerCoord[i]["x"],
            MinerCoord[i]["y"],
            MinerCoord[i]["z"],
            5.0,
            "E",
            _t("start_mining"),
            _t("press_to_start"),
        }
    end
    TriggerEvent("hoverfy:Insert",Table)
    while true do 
        local idle = 2500
        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)
        for i=1,#MinerCoord do
            local Start = vector3(MinerCoord[i]["x"],MinerCoord[i]["y"],MinerCoord[i]["z"])
            local Distance = #(Coords - Start)
            if Distance < 5 then
                idle = 1
                if IsControlJustPressed(0,38) and not Mining then
                    Mining = true
                    TriggerServerEvent("farmer:Minerman")
                    --if exports["hud"]:Request("Gostaria de utilizar a roupa do emprego?", 30) then
                        -- TriggerServerEvent("player:PresetJob","Minerador")
                    --end
                    --TriggerEvent("Notify:Text","F6 Para Cancelar Coleta")
                end
            end
        end
        Wait(idle)
    end
end)

RegisterNetEvent("farmer:RemMiner")
AddEventHandler("farmer:RemMiner",function()
    Mining = false
    TriggerEvent("hoverfy:returnHoverfy")
end)

AddEventHandler("actions:Cancel",function()
    if Mining then
        LocalPlayer["state"]:set("Buttons",false,true)
        LocalPlayer["state"]:set("Cancel",false,true)
        TriggerEvent("hoverfy:returnHoverfy")
        TriggerEvent("Notify:Text","")
        Mining = false
        InZoneMiner = false
        TriggerServerEvent("farmer:CancelMining")
        TriggerEvent("Progress","Cancelando",0)
    end
end)

RegisterNetEvent("farmer:MinerSound")
AddEventHandler("farmer:MinerSound",function()
    Wait(800)
    TriggerEvent("sounds:Private","miner3",0.2)
    local Timer = 7
    while Timer > 0 do
        Timer = Timer - 1.75
        Wait(2050)
        TriggerEvent("sounds:Private","miner3",0.2)
    end
    Mining = false
    TriggerEvent("hoverfy:returnHoverfy")
end)


local JobVehicles = {
    [tostring(GetHashKey("bus"))] = true,
    [tostring(GetHashKey("tractor2"))] = true,
    [tostring(GetHashKey("boxville2"))] = true,
    [tostring(GetHashKey("sprint2"))] = true,
    [tostring(GetHashKey("benson2"))] = true,
}

AddEventHandler("gameEventTriggered",function(eventName,args)
    if eventName ~= "CEventNetworkPlayerEnteredVehicle" then
        return
    end

    local Ped = PlayerPedId()
    
    if tonumber(args[1]) ~= PlayerId() or not LocalPlayer["state"]["Active"] then
        return
    end

    if not LocalPlayer["state"]["AnyJob"] then
        return
    end

    Wait(250)

    local Vehicle = GetVehiclePedIsIn(Ped,false)
    local Model = GetEntityModel(Vehicle)

    if not JobVehicles[tostring(Model)] then
        return
    end

    SetLocalPlayerAsGhost(true)
    SetGhostedEntityAlpha(254)

    CreateThread(function()
        while true do
            if not IsPedInAnyVehicle(Ped) then
                SetLocalPlayerAsGhost(false)
                break
            end
            if not LocalPlayer["state"]["AnyJob"] then
                SetLocalPlayerAsGhost(false)
                break
            end
            Wait(500)
        end
    end)
end)


-- RegisterKeyMapping("autopilot", _t("autopilot"), "keyboard", "H")
-- RegisterCommand("autopilot",function()
--     -- if not LocalPlayer["state"]["AnyJob"] then
--     --     return
--     -- end
--     Wait(100)
--     if LocalPlayer["state"]["JobAutoPilot"] then
--         EndJobAutoPilot()
--     else
--         StartJobAutoPilot(LocalPlayer["state"]["AnyJob"])
--     end
-- end)

-- function StartJobAutoPilot(Coords)
--     LocalPlayer["state"]["JobAutoPilot"] = true
--     local player = GetPlayerPed(-1)
--     local vehicle = GetVehiclePedIsIn(player)
--     if Coords then
--         SetEntityMaxSpeed(vehicle,0.28 * 20)
--         TaskVehicleDriveToCoordLongrange(player, vehicle, Coords.x, Coords.y, Coords.z, 3516854.5, 32, 5.0)
--     end
-- end

-- function EndJobAutoPilot()
--     LocalPlayer["state"]["JobAutoPilot"] = false
--     local player = GetPlayerPed(-1)
--     local vehicle = GetVehiclePedIsIn(player)
--     SetEntityMaxSpeed(vehicle,0.28 * 500)
--     local player = GetPlayerPed(-1)
--     ClearPedTasks(player)
-- end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
local Harvesting = false
local NearHarvest = false
CreateThread(function()
    Wait(1000)
    local Table = {}
    for i=1, #FruitCoords do
        Table[i] = {
            FruitCoords[i].x,
            FruitCoords[i].y,
            FruitCoords[i].z,
            2.5,
            "E",
            _t("collect_fruits"),
            _t("press_to_collect"),
        }
    end
    TriggerEvent("hoverfy:Insert",Table)

    while true do
        local Idle = 1000
        if not InJob then
            local Ped = PlayerPedId()
            local Coords = GetEntityCoords(Ped)
            local Near = 5
            local isNear = false
            for i=1,#FruitCoords do
                local Start = vector3(FruitCoords[i]["x"],FruitCoords[i]["y"],FruitCoords[i]["z"])
                local Distance = #(Coords - Start)
                if Distance < Near then
                    Near = Distance
                    NearHarvest = i
                    isNear =  true
                end
            end
            if not isNear then
                NearHarvest = false
            end
        end
        Wait(Idle)
    end
end)

CreateThread(function()
    local Table = {}
    for i=1, #FruitCoords do
        Table[i] = {
            FruitCoords[i]["x"],
            FruitCoords[i]["y"],
            FruitCoords[i]["z"],
            5.0,
            "E",
            _t("start_collection"),
            _t("press_to_start"),
        }
    end
    TriggerEvent("hoverfy:Insert",Table)
    while true do 
        local idle = 2500
        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)
        if NearHarvest then
            idle = 1
            if NearHarvest and IsControlJustPressed(0,38) and not Harvesting and not vRP.ReturnNoClip() then
                Harvesting = true
                --if exports["hud"]:Request("Gostaria de utilizar a roupa do emprego?", 30) then
                    -- TriggerServerEvent("player:PresetJob","Fazendeiro")
                --end
                TriggerServerEvent("farmer:Harvesting")
                TriggerEvent("Notify:Text", _t("cancelCollection"))
            end
        end
        Wait(idle)
    end
end)

AddEventHandler("actions:Cancel",function()
    if Harvesting then
        LocalPlayer["state"]:set("Buttons",false,true)
        LocalPlayer["state"]:set("Cancel",false,true)
        TriggerEvent("hoverfy:returnHoverfy")
        TriggerEvent("Notify:Text","")
        Harvesting = false
        InZone = false
        TriggerServerEvent("farmer:CancelHarvesting")
        TriggerEvent("Progress","Cancelando",0)
    end
end)

RegisterNetEvent("farmer:NewHarvesting")
AddEventHandler("farmer:NewHarvesting",function()
    if Harvesting then
        TriggerServerEvent("farmer:Harvesting")
    end
end)

function DrawText3D(x,y,z,text)
	local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)

	if onScreen then
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringKeyboardDisplay(text)
		SetTextColour(255,255,255,150)
		SetTextScale(0.35,0.35)
		SetTextFont(4)
		SetTextCentre(1)
		EndTextCommandDisplayText(_x,_y)

		local width = string.len(text) / 160 * 0.45
		DrawRect(_x,_y + 0.0125,width,0.03,38,42,56,200)
	end
end

AddEventHandler('onResourceStart', function(resource)
    Wait(1500)
    if resource == "sleepless_interact" then
        StartInteractionRoutes()
    end
    
    if resource == GetCurrentResourceName() then
        StartInteractionRoutes()
    end
end)

AddEventHandler('playerSpawned', function(resource)
    StartInteractionRoutes()
end)

function StartInteractionRoutes()
    for i=1,#RoutesInteractions do
        local Coords = RoutesInteractions[i]
        interact.addCoords({
            id = "RoutesInteractions:"..tostring(i),
            coords = vec3(Coords.x,Coords.y,Coords.z),
            options = {
                {
                    label = _t("routesNorth"),
                    icon = "code-fork",
                    onSelect = function(data)
                        TriggerEvent("routes:NPCStart","North")
                    end,
                    canInteract = function(entity, distance, coords, id)
                        return true
                    end
                },
                {
                    label = _t("routesSouth"),
                    icon = "code-fork",
                    onSelect = function(data)
                        TriggerEvent("routes:NPCStart","South")
                    end,
                    canInteract = function(entity, distance, coords, id)
                        return true
                    end
                }
            },
            renderDistance = 7.5,
            activeDistance = 1.5,
            cooldown = 1500
        })
    end
    for i=1,#DeliveryInteractions do
        local Coords = DeliveryInteractions[i]
        interact.addCoords({
            id = "DeliveryInteractions:"..tostring(i),
            coords = vec3(Coords.x,Coords.y,Coords.z),
            options = {
                {
                    label = _t("deliverNorth"),
                    icon = "child",
                    onSelect = function(data)
                        TriggerEvent("deliver:Starting","Drugsmannorth")
                    end,
                    canInteract = function(entity, distance, coords, id)
                        return true
                    end
                },
                {
                    label = _t("deliverSouth"),
                    icon = "child",
                    onSelect = function(data)
                        TriggerEvent("deliver:Starting","Drugsmansouth")
                    end,
                    canInteract = function(entity, distance, coords, id)
                        return true
                    end
                }
            },
            renderDistance = 7.5,
            activeDistance = 1.5,
            cooldown = 1500
        })
    end
end
