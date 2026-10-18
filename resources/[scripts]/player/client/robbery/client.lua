SafeMode = GetConvar("SafeMode", "")
local isFronteira = cityName == "Fronteira"
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
local isActivated = false
local Blips = {}
IN_ROBBERY = false
local textRobberyNumber = nil
-- CreateThread(local IN_ROBBERY = false
-- function()
--     local Table = {}

--     for _,v in pairs(Robberys) do
--         table.insert(Table,{ v["Coords"][1],v["Coords"][2],v["Coords"][3],1.25,"E","Roubar","Pressione para roubar" })
--     end

--     TriggerEvent("hoverfy:Insert",Table)
--     while true do
--         local Idle = 1500
--         local Ped = PlayerPedId()
--         for _,v in pairs(Robberys) do
--             local Coords = GetEntityCoords(Ped)
--             local MarkerCoords = vec3(v["Coords"][1],v["Coords"][2],v["Coords"][3])
--             local Distance = #(Coords - MarkerCoords)
--             if Distance <= 20 then
--                 Idle = 1
--                 DrawMarker(29,MarkerCoords,0,0,0,vec3(0.0, 0.0, 0.0),vec3(1.0, 1.0, 1.0),255, 0, 0, 94,false,false,2,true,nil,nil,false)
--             end
--         end
--         Wait(Idle)
--     end
-- end)

AddEventHandler('onResourceStart', function(resource)
    Wait(1500)
    if resource == "sleepless_interact" then
        StartInteraction()
    end

    if resource == GetCurrentResourceName() then
        StartInteraction()
    end
end)

AddEventHandler('playerSpawned', function(resource)
    StartInteraction()
end)


function StartInteraction()
    local Table = {}
    Wait(1000)
    for Index,v in pairs(Robberys) do
        -- if not v["Alias"] then
        --     v["Alias"] = v["Name"]
        -- end
        -- if (Index == tostring(1)) then 
        --     print('roubo id',Index)
        -- end

        interact.addCoords({
            id = "robbery:"..tostring(Index),
            coords = vec3(v["Coords"].x,v["Coords"].y,v["Coords"].z),
            options = {
                {
                    label = _t("robbery"),
                    icon = "bullseye",
                    onSelect = function(data)
                        print('roubo id',Index)
                        if SafeMode == "true" then
                            if GlobalState["WarModeBucket"] and LocalPlayer["state"]["Route"] ~= 2 then
                                --TriggerEvent("Notify","vermelho","Você so pode roubar se estiver no MODO GUERRA.",8000,"Roubos")
                                TriggerEvent("Notify2","#roubarModoGuerra")
                                return
                            end
                        end
                        if LocalPlayer["state"]["Route"] ~= 1 then
                            --TriggerEvent("Notify","vermelho","Você não pode roubar se estiver no mundo safe",5000,"MODO SAFE")
                            TriggerEvent("Notify2","#naoRoubarSafe")
                            return
                        end
                        IN_ROBBERY = true
                        vSERVER.InitRobbery(Index)
                    end,
                    canInteract = function(entity, distance, coords, id)
                        return not IN_ROBBERY and not LocalPlayer.state['minigame:active']
                    end
                }
            },
            renderDistance = 25.0,
            activeDistance = 1.5,
            cooldown = 1500
        })
    end
    --TriggerEvent("hoverfy:Insert",Table)
end

local CachedBlips = {}
function DeleteBlipsRobbery()
    for k,v in pairs(CachedBlips) do
        RemoveBlip(v)
        CachedBlips[k] = nil
    end
    CachedBlips = {}
end

function CreateBlipsRobbery()
    local Whitelist = {
        -- ["pequena"] = true,
        -- ["media"] = true
    }
    for k,v in pairs(Robberys) do
        if Whitelist[v["type"]] then
            local Coords = vec3(v["Coords"][1],v["Coords"][2],v["Coords"][3])
            local Name = v["name"]
            local Blip = AddBlipForCoord(Coords,0.0)
            CachedBlips[k] = Blip
            local Text = "Roubo | Ação Blipada"
            SetBlipScale(Blip,0.5)
            SetBlipSprite(Blip,431) 	
            SetBlipDisplay(Blip,4)
            SetBlipAsShortRange(Blip,true)
            SetBlipColour(Blip,3)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Text)
            EndTextCommandSetBlipName(Blip)
        end
    end
end

CreateThread(function()
    local Table = {}
    CreateBlipsRobbery()
end)

AddEventHandler("misc:CreateBlips",function(resource)
    CreateBlipsRobbery()
end)

AddEventHandler("misc:DeleteBlips",function(resource)
    DeleteBlipsRobbery()
end)


robberyBlips = {}
RegisterCommandLocalized("command.robbery",function(source,args,rawCommand)
    if not isActivated then
        robberyBlips["blipsCoords"] = {}
        TriggerEvent("Notify","aviso","Marcações ativadas.",3000)
        -- TriggerEvent("Notify2","#marcacaoAtivada")
        for k,v in pairs(Robberys) do
            robberyBlips["blipsCoords"][k] = AddBlipForCoord(v["Coords"][1],v["Coords"][2],v["Coords"][3])
            SetBlipSprite(robberyBlips["blipsCoords"][k],1)
            SetBlipScale(robberyBlips["blipsCoords"][k],0.5)
            SetBlipColour(robberyBlips["blipsCoords"][k],1)
            SetBlipAsShortRange(robberyBlips["blipsCoords"][k],true)
            BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Roubo")
			EndTextCommandSetBlipName(robberyBlips["blipsCoords"][k])
        end
        isActivated = true
    else
        isActivated = false
        for k,v in pairs(robberyBlips["blipsCoords"]) do
            RemoveBlip(v)
        end
        TriggerEvent("Notify","amarelo","Marcações desativadas.",3000,"Roubos")
        -- TriggerEvent("Notify2","#marcacaoDesativada")
    end
end)


RegisterNetEvent("robbery:StartRobbery")
AddEventHandler("robbery:StartRobbery",function(Number)
    IN_ROBBERY = true
    local Ped = PlayerPedId()
    LocalPlayer["state"]:set("Buttons",true,true)
    LocalPlayer["state"]:set("Cancel",true,true)
    FreezeEntityPosition(Ped,true)
    local StartTimer = Robberys[Number]["awaitTimer"]
    exports['hint']:Show(string.format(_t("robbery_wait"), StartTimer), _t("robbery_title"), true, true)
    CreateThread(function()
        while StartTimer > 0 do
            if not IN_ROBBERY then
                break
            end
            StartTimer = StartTimer - 1
            local Ped = PlayerPedId()
            local Coords = GetEntityCoords(Ped)
            local RobberyCoords = Robberys[Number]["Coords"]
            local MaxDistance = Robberys[Number]["maxDistance"] or isFronteira and 50 or 100
            local Distance = #(Coords - RobberyCoords)
            local Text = string.format(_t("robbery_progress"), StartTimer, parseInt(Distance), MaxDistance)
            exports['hint']:UpdateText(Text)
            Wait(1000)
        end
        exports['hint']:Hide(true)
    end)
end)

RegisterNetEvent("robbery:TextRobbery")
AddEventHandler("robbery:TextRobbery",function(Number)
    if IN_ROBBERY then
        return
    end
    
    textRobberyNumber = Number

    local StartTimer = Robberys[Number]["awaitTimer"]
    exports['hint']:Show(string.format(_t("robbery_wait"), StartTimer), _t("robbery_title"), true, true)
    CreateThread(function()
        while StartTimer > 0 do
            if not textRobberyNumber then
                break
            end
            
            StartTimer = StartTimer - 1
            local Ped = PlayerPedId()
            local Coords = GetEntityCoords(Ped)
            local RobberyCoords = Robberys[Number]["Coords"]
            local MaxDistance = Robberys[Number]["maxDistance"] or 100
            local Distance = #(Coords - RobberyCoords)
            local Text = string.format(_t("robbery_progress"), StartTimer, parseInt(Distance), MaxDistance)
            exports['hint']:UpdateText(Text)
            Wait(1000)
        end
        exports['hint']:Hide(true)
    end)
end)

RegisterNetEvent("robbery:StopTextRobbery")
AddEventHandler("robbery:StopTextRobbery", function()
    textRobberyNumber = nil
end)

RegisterNetEvent("robbery:CanCancel")
AddEventHandler("robbery:CanCancel",function(Number)
    local Ped = PlayerPedId()
    vRP.stopAnim(false)
    LocalPlayer["state"]:set("Buttons",false,true)
    LocalPlayer["state"]:set("Cancel",false,true)
    FreezeEntityPosition(Ped,false)
end)

RegisterNetEvent("robbery:FinishRobbery")
AddEventHandler("robbery:FinishRobbery",function(Number)
    print("FinishRobbery")
    IN_ROBBERY = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
-- CreateThread(function()
-- 	while true do
-- 		local TimeDistance = 999
-- 		if LocalPlayer["state"]["Route"] < 900000 then
-- 			local Ped = PlayerPedId()
-- 			if not IsPedInAnyVehicle(Ped) then
-- 				local Coords = GetEntityCoords(Ped)
-- 				for Index,v in pairs(Robberys) do
-- 					local Distance = #(Coords - v["Coords"])
-- 					if Distance <= 1.25 then
-- 						TimeDistance = 1
--                         ::Back::
-- 						if IsControlJustPressed(1,38) and not exports["hud"]:Wanted() then
--                             if SafeMode == "true" then
--                                 if GlobalState["WarModeBucket"] and LocalPlayer["state"]["Route"] ~= 2 then
--                                     --TriggerEvent("Notify","vermelho","Você so pode roubar se estiver no MODO GUERRA.",8000,"Roubos")
--                                     TriggerEvent("Notify2","#roubarModoGuerra")
--                                     return
--                                 end
--                             end
--                             if LocalPlayer["state"]["Route"] ~= 1 then
--                                 --TriggerEvent("Notify","vermelho","Você não pode roubar se estiver no mundo safe",5000,"MODO SAFE")
--                                 TriggerEvent("Notify2","#naoRoubarSafe")
--                                 return
--                             end
--                             IN_ROBBERY = true
-- 							vSERVER.InitRobbery(Index)
-- 						end
-- 					end
-- 				end
-- 			end
-- 		end
--         ---
-- 		Wait(TimeDistance)
-- 	end
-- end)

AddEventHandler("actions:Cancel",function()
    if IN_ROBBERY then
        IN_ROBBERY = false
        vSERVER.CancelRobbery()
    end
end)

local ATM_ROBBERY_ENTITIES_MODELS = {-1364697528,-870868698,-1126237515,506770882}

AddEventHandler("actions:Cancel",function()
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)

    for k,v in pairs(ATM_ROBBERY_ENTITIES_MODELS) do
        local nearEntity = GetClosestObjectOfType(coords,5.0,v,0,0,0)
        if nearEntity then
            return vSERVER.CancelRobberyATM()
        end
    end
end)


RegisterNUICallback("getCityName",function(Data,Callback)
    cityName = GetConvar("cityName", "")
    Callback(string.lower(cityName))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKATM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkAtm(Coords)
	local BombZone = false
	local AtmSelected = false

	for Number,v in pairs(ATMList) do
		local Distance = #(vec3(Coords["x"],Coords["y"],Coords["z"]) - v)
		if Distance <= 1.0 then
			BombZone = vec3(v[1],v[2],v[3] - 1)
			AtmSelected = Number
			break
		end
	end

	return BombZone,AtmSelected
end
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

local atmsHash = { -1364697528,-870868698,-1126237515 }
RegisterNetEvent("target:ATMRobbery")
AddEventHandler("target:ATMRobbery",function()
    for k,hash in ipairs(atmsHash) do
        local object = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()),2.0,hash,0,0,0)
        if object then
            local coords = GetEntityCoords(object)
            vSERVER.InitRobberyATM(coords)
            break
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKATM
-----------------------------------------------------------------------------------------------------------------------------------------
-- CreateThread(function()
--     while true do
--         local idle = 2500
--         local Ped = PlayerPedId()
--         local Coords = GetEntityCoords(Ped)
--         for Number,v in pairs(ATMList) do
--             local Distance = #(vec3(Coords["x"],Coords["y"],Coords["z"]) - v)
--             if Distance <= 2.0 then
--                 idle = 1
--                 -- PRESS G
--                 DrawText3D(v.x, v.y, v.z,"[~g~G~w~] Roubar Caixa Eletrônico")
--                 if IsControlJustPressed(0,47) then
--                     vSERVER.InitRobberyATM(Number)
--                 end
--             end
--         end
--         Wait(idle)
--     end
-- end)

local timeBlips = {}
local showBlips = {}
CreateThread(function()
	while true do
		for k,v in pairs(timeBlips) do
			if timeBlips[k] > 0 then
				timeBlips[k] = timeBlips[k] - 1
				if timeBlips[k] <= 0 then
					RemoveBlip(showBlips[k])
					showBlips[k] = nil
					timeBlips[k] = nil
				end
			end
		end
		Wait(1000)
	end
end)

local id = 0
RegisterNetEvent("PushRobberyBlips")
AddEventHandler("PushRobberyBlips",function(Coords)
    id = id + 1
    if DoesBlipExist(showBlips[id]) then
        RemoveBlip(showBlips[id])
        showBlips[id] = nil
        timeBlips[id] = nil
    end
    local data = {}
    data["title"] = "Roubo"
    data["blipColor"] = 1
	timeBlips[id] = 60*2
	showBlips[id] = AddBlipForCoord(Coords["x"],Coords["y"],Coords["z"])
	SetBlipSprite(showBlips[id],10)
	SetBlipDisplay(showBlips[id],4)
    SetBlipColour(showBlips[id],5)
    SetBlipScale(showBlips[id],0.7)
    SetBlipAsShortRange(showBlips[id],true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(data["title"])
	EndTextCommandSetBlipName(showBlips[id])
end)
