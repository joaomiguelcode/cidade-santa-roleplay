local vSERVER = Tunnel.getInterface("inventory/chest")
local vCHESTPERMISSION = Tunnel.getInterface("inventory/chestpermission")
local DOMINATION_MINIGAME_NAME = "Domination"
local gPersonalChestOpenedByExport = false

---@return boolean blocked
local function IsChestActionBlocked()
    local activeMinigame = LocalPlayer["state"]["minigame:active"]
    local isDominationPersonalChest = gPersonalChestOpenedByExport
        and activeMinigame == DOMINATION_MINIGAME_NAME

    if isDominationPersonalChest then
        return false
    end

    if activeMinigame and activeMinigame ~= "Royale" then
        return true
    end

    return LocalPlayer["state"]["FFA"] == true
        or LocalPlayer["state"]["PVP"] == true
        or LocalPlayer["state"]["snowball:match"] == true
end

---@return boolean opened
local function OpenPersonalChest()
    local activeMinigame = LocalPlayer["state"]["minigame:active"]
    local isAllowedMinigame = activeMinigame == DOMINATION_MINIGAME_NAME or activeMinigame == "Royale"

    if not isAllowedMinigame
        or not LocalPlayer["state"]["Active"]
        or IsNuiFocused()
    then
        return false
    end

    if GlobalState["Restarting"] then
        TriggerEvent( "Notify", "vermelho", "Servidor em reinicialização, aguarde.", 8000 )
        return false
    end

    if not vSERVER.Permissions( "PlayerChest", "Personal", nil ) then
        return false
    end

    if LocalPlayer["state"]["minigame:active"] ~= activeMinigame then
        return false
    end

    gPersonalChestOpenedByExport = true

    if not toggleInventory( "chest" ) then
        gPersonalChestOpenedByExport = false
        return false
    end

    return true
end

---@return boolean closed
local function ClosePersonalChest()
    if not gPersonalChestOpenedByExport then
        return false
    end

    gPersonalChestOpenedByExport = false
    TriggerEvent( "inventory:Close" )

    return true
end

exports( "OpenPersonalChest", OpenPersonalChest )
exports( "ClosePersonalChest", ClosePersonalChest )

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
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
    local policeGroups = IsFactionPilotCity() and vCHESTPERMISSION.GetPoliceGroups() or {}

    if type(policeGroups) ~= "table" then
        policeGroups = {}
    end

    for k,v in pairs(Chests) do
        -- if not v["Alias"] then
        --     v["Alias"] = v["Name"]
        -- end
        local Options = {
            {
                label = _t("openChest"),
                icon = "archive",
                onSelect = function(data)
                    local Mode = v["Mode"]
                    if vSERVER.Permissions(v["Name"],Mode,i) then
                        if not GlobalState["Restarting"] then
                            toggleInventory("chest")
                        else
                            TriggerEvent("Notify","vermelho","Servidor em reinicialização, aguarde.",8000)
                        end
                
                    end
                end,
                canInteract = function(entity, distance, coords, id)
                    return LocalPlayer["state"]["Active"] and not LocalPlayer["state"]["PVP"] and not GlobalState["Restarting"]
                end
            }
        }

        local isPoliceChest = v["Name"] and not v["Name"]:find("-", 1, true)
            and policeGroups[v["Name"]] == true and (v["Mode"] == "1" or v["Mode"] == "2")

        if (IsManagedLeaderChest(v["Name"]) or isPoliceChest) and IsFactionPilotCity() then
            table.insert(Options, {
                label = _t("configureFactionChest"),
                icon = "cog",
                onSelect = function()
                    TriggerServerEvent("chestpermission:open", v["Name"])
                end,
                canInteract = function(entity, distance, coords, id)
                    return LocalPlayer["state"]["Active"] and not LocalPlayer["state"]["PVP"] and not GlobalState["Restarting"]
                end
            })
        end

        interact.addCoords({
            id = "chest:"..tostring(k),
            coords = vec3(v["Coords"][1],v["Coords"][2],v["Coords"][3]),
            options = Options,
            renderDistance = 10.0,
            activeDistance = 1.5,
            cooldown = 1500
        })
    end
    --TriggerEvent("hoverfy:Insert",Table)
end

function GetChests()
    return Chests
end
exports("GetChests",GetChests)

Objects = {
    -- ["1"] = { Coords = vec3(1265.79, -301.47, 84.05), Heading = 184.84, Object = "prop_ld_int_safe_01", Distance = 50},
    -- ["2"] = { Coords = vec3(1265.81, -301.53, 84.53), Heading = 185.17, Object = "apa_mp_h_acc_vase_flowers_01", Distance = 50}
}
Init = {}

function LoadModel(Hash)
	local Hash = GetHashKey(Hash)

	while not HasModelLoaded(Hash) do
		RequestModel(Hash)
		Wait(1)
	end

	return true
end

CreateThread(function()
    while true do
        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)
        for Number,v in pairs(Objects) do
            local Distance = #(Coords - v["Coords"])
            if Distance <= v["Distance"] then
                if not Init[Number] and LoadModel(v["Object"]) then
                    Init[Number] = CreateObjectNoOffset(v["Object"],v["Coords"],false,false,false)
                    FreezeEntityPosition(Init[Number],true)
                    SetEntityHeading(Init[Number],v["Heading"])
                    SetModelAsNoLongerNeeded(v["Object"])
                end
            else
                if Init[Number] then
                    if DoesEntityExist(Init[Number]) then
                        DeleteEntity(Init[Number])
                        Init[Number] = nil
                    else
                        Init[Number] = nil
                    end
                end
            end
        end
        Wait(1000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LABELS
-----------------------------------------------------------------------------------------------------------------------------------------
local Labels = {
	["1"] = {
		{
			event = "chest:Open",
            label = _t("general_compartment"),
			tunnel = "shop",
			service = "Normal"
		},{
			event = "chest:Upgrade",
			label = "Aumentar",
			tunnel = "server"
		}
	},
	["2"] = {
		{
			event = "chest:Open",
			label = "Abrir",
			tunnel = "shop",
			service = "Normal"
		},{
			event = "chest:Upgrade",
			label = "Aumentar",
			tunnel = "server"
		}
	},
	["Personal"] = {
		{
			event = "chest:Open",
			label = "Abrir",
			tunnel = "shop",
			service = "Personal"
		}
	},
	["3"] = {
		{
			event = "chest:Open",
			label = "Bandeja",
			tunnel = "shop",
			service = "Normal"
		}
	},
	["4"] = {
		{
			event = "chest:Open",
			label = "Abrir",
			tunnel = "shop",
			service = "Custom"
		}
	},
	["Custom"] = {
		{
			event = "chest:Open",
			label = "Abrir",
			tunnel = "shop",
			service = "Custom"
		}
	},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADINIT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Name,v in pairs(Chests) do
		exports["target"]:AddCircleZone("Chest:"..Name,v["Coords"],1.0,{
			name = "Chest:"..Name,
			heading = 3374176
		},{
			Distance = 1.5,
			shop = {v["Name"],Name},
			options = Labels[v["Mode"]],
            number = Name
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("chest:Open",function(Name,Init,Number)
    if LocalPlayer["state"]["PVP"] then
        return
    end
    if LocalPlayer["state"]["FFA"] then
        return
    end
    if GlobalState["Restarting"] then
        TriggerEvent("Notify","vermelho","Servidor em reinicialização, aguarde.",8000)
        return false
    end
	if LocalPlayer["state"]["Route"] < 900000 then
		if vSERVER.Permissions(Name[1],Init,Name[2]) then
			toggleInventory("chest")
		end
	end
end)

local NearChests = {}

-- CreateThread(function()
-- 	while true do
-- 		local TimeDistance = 500
--         local Ped = PlayerPedId()
--         for k,_ in pairs(NearChests) do
--             NearChest = tonumber(k)
--             if LocalPlayer["state"]["Route"] < 900000 and NearChest then
--                 local Chest = Chests[NearChest]
--                 local Ped = PlayerPedId()
--                 local Coords = GetEntityCoords(Ped)
--                 local Distance = #(Coords - Chest["Coords"])
--                 local Mode = Chest["Mode"]
--                 if Distance <= 50.0 then
--                     TimeDistance = 0
--                     local _,Ground = GetGroundZFor_3dCoord(Chest["Coords"].x,Chest["Coords"].y,Chest["Coords"].z)
--                     DrawMarker(22,Chest["Coords"]["x"], Chest["Coords"]["y"], Chest["Coords"]["z"],0,0,0,vec3(0.0, 180.0, 0.0),vec3(1.0, 1.0, 1.0),THEME.rgb.r, THEME.rgb.g, THEME.rgb.b, 100,false,false,2,true,nil,nil,false)
--                     DrawMarker(27, Chest["Coords"].x,Chest["Coords"].y, Ground + 0.03, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5,THEME.rgb.r, THEME.rgb.g, THEME.rgb.b, 100, 0, 0, 0, 0)
--                     if Distance <= 2.0 then
--                         if IsControlJustPressed(0,38) then
--                             if LocalPlayer["state"]["Active"] then
--                                 if not LocalPlayer["state"]["PVP"] then
--                                     if not GlobalState["Restarting"] then
--                                         if vSERVER.Permissions(Chest["Name"],Mode,i) then
--                                             if not GlobalState["Restarting"] then
--                                                 toggleInventory("chest")
--                                             else
--                                                 TriggerEvent("Notify","vermelho","Servidor em reinicialização, aguarde.",8000)
--                                             end
                                            
--                                         end
--                                     end
--                                 end
--                             end
--                         end
--                     end
--                 else
--                     NearChests[k] = nil
--                 end
--             end
--         end
-- 		Wait(TimeDistance)
-- 	end
-- end)

-- CreateThread(function()
--     while true do
--         local idle = 1000
--         local ped = PlayerPedId()
--         local Coords = GetEntityCoords(ped)
--         for i=1,#Chests do
--             local Chest = Chests[i]
--             if Chest and Chest["Coords"]then
--                 local Distance = #(Coords - Chest["Coords"])
--                 if Distance <= 50 and not NearChests[tostring(i)] then
--                     NearChests[tostring(i)] = true
--                 end
--             end
--         end
--         Wait(idle)
--     end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler( "inventory:Close", function()
    gPersonalChestOpenedByExport = false
end )

AddEventHandler("inventory:CloseAll",function()
	gPersonalChestOpenedByExport = false
	TriggerEvent("inventory:Close")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("pickupSlotChest",function(Data,Callback)
    if IsChestActionBlocked() then
        return
    end

    if not LocalPlayer["state"]["Active"] then
        return
    end
	vSERVER.Take(Data["item"],Data["slot"],Data["amount"],Data["target"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("dropSlotChest",function(Data,Callback)
    if not LocalPlayer["state"]["Active"] then
        return
    end

    if IsChestActionBlocked() then
        return
    end
	vSERVER.Store(Data["item"],Data["slot"],Data["amount"],Data["target"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateSlotChest",function(Data,Callback)
    if not LocalPlayer["state"]["Active"] then
        return
    end
    if IsChestActionBlocked() then
        return
    end
	vSERVER.Update(Data["slot"],Data["target"],Data["amount"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestUpgradeChest",function(Data,Callback)
    if IsChestActionBlocked() then
        return
    end
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestChest",function(Data,Callback)

    if exports.tutorial:CanStartUiTutorial('tutorial.ui.chest') then
        SendNUIMessage({ action = 'tutorialInventory:start', data = exports.tutorial:GetTutorialById('tutorial.ui.chest') })
    end

    if not LocalPlayer["state"]["Active"] then
        return
    end
    if GlobalState["Restarting"] then
        TriggerEvent("Notify","vermelho","Servidor em reinicialização, aguarde.",8000)
        return false
    end
    if IsChestActionBlocked() then
        return
    end
    local Chest,chestPeso,chestMaxpeso = vSERVER.Chest()
    if not Chest then
        return
    end
    for k,v in pairs(Chest) do
        Chest[k]["name"] = itemName(v["item"])
        Chest[k]["weight"] = itemWeight(v["item"])
        Chest[k]["index"] = itemIndex(v["item"])
        Chest[k]["max"] = itemMaxAmount(v["item"])
        Chest[k]["economy"] = parseFormat(itemEconomy(v["item"]))
        Chest[k]["desc"] = itemDescription(v["item"])
    end
	Callback({ items = Chest, type = "chest", weight = {
		current = chestPeso,
		max = chestMaxpeso
	}})
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chest:Update")
AddEventHandler("chest:Update",function(action,invPeso,invMaxpeso,chestPeso,chestMaxpeso)
	SendNUIMessage({ action = "updateInventory" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chest:Close")
AddEventHandler("chest:Close",function(Action)
	gPersonalChestOpenedByExport = false
	toggleInventory(nil)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:LOAD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chest:Load")
AddEventHandler("chest:Load",function(Table)
    local Hoverfy = {}
    for i=1,#Table do
        Table[i]["Coords"] = toVector3(Table[i]["Coords"])
        -- exports["target"]:AddCircleZone("Chest:"..Table[i]["Name"],Table[i]["Coords"],1.0,{
        --     name = "Chest:"..Table[i]["Name"],
        --     heading = 3374176
        -- },{
        --     Distance = 1.5,
        --     shop = {Table[i]["Name"]},
        --     options = Labels[Table[i]["Mode"]]
        -- })
        -- table.insert(Hoverfy,{ Table[i]["Coords"]["x"],Table[i]["Coords"]["y"],Table[i]["Coords"]["z"],1.25,"E","BAÚ","Para abrir o baú" })
        table.insert(Chests,Table[i])
        local v = Table[i]
        local k = #Chests
        interact.addCoords({
            id = "chest:"..tostring(k),
            coords = vec3(v["Coords"][1],v["Coords"][2],v["Coords"][3]),
            options = {
                {
                    label = _t("openChest"),
                    icon = "archive",
                    onSelect = function(data)
                        local Mode = v["Mode"]
                        if vSERVER.Permissions(v["Name"],Mode,nil) then
                            if not GlobalState["Restarting"] then
                                toggleInventory("chest")
                            else
                                TriggerEvent("Notify","vermelho","Servidor em reinicialização, aguarde.",8000)
                            end
                    
                        end
                    end,
                    canInteract = function(entity, distance, coords, id)
                        return LocalPlayer["state"]["Active"] and not LocalPlayer["state"]["PVP"] and not GlobalState["Restarting"]
                    end
                }
            },
            renderDistance = 10.0,
            activeDistance = 1.5,
            cooldown = 1500
        })
        v["_interactionId"] = "chest:"..tostring(k)
    end
    TriggerEvent("hoverfy:Insert",Hoverfy)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:ADD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chest:Add")
AddEventHandler("chest:Add",function(Table)
    local Hoverfy = {}
    Table["Coords"] = toVector3(Table["Coords"])
    table.insert(Chests,Table)
    -- exports["target"]:AddCircleZone("Chest:"..Table["Name"],Table["Coords"],1.0,{
    --     name = "Chest:"..Table["Name"],
    --     heading = 3374176
    -- },{
    --     Distance = 1.5,
    --     shop = {Table["Name"]},
    --     options = Labels[Table["Mode"]]
    -- })
    -- table.insert(Hoverfy,{ Table["Coords"][1],Table["Coords"][2],Table["Coords"][3],1.25,"E","BAÚ","Para abrir o baú" })
    -- TriggerEvent("hoverfy:Insert",Hoverfy)
    local v = Table
    local k = #Chests
    interact.addCoords({
        id = "chest:"..tostring(k),
        coords = vec3(v["Coords"][1],v["Coords"][2],v["Coords"][3]),
        options = {
            {
                label = _t("openChest"),
                icon = "archive",
                onSelect = function(data)
                    local Mode = v["Mode"]
                    if vSERVER.Permissions(v["Name"],Mode,i) then
                        if not GlobalState["Restarting"] then
                            toggleInventory("chest")
                        else
                            TriggerEvent("Notify","vermelho","Servidor em reinicialização, aguarde.",8000)
                        end
                
                    end
                end,
                canInteract = function(entity, distance, coords, id)
                    return LocalPlayer["state"]["Active"] and not LocalPlayer["state"]["PVP"] and not GlobalState["Restarting"]
                end
            }
        },
        renderDistance = 10.0,
        activeDistance = 1.5,
        cooldown = 1500
    })
    Table["_interactionId"] = "chest:"..tostring(k)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:REMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chest:Remove")
AddEventHandler("chest:Remove",function(Name)
    for k,v in pairs(Chests) do
        if v["Name"] == Name then
            interact.removeById(v["_interactionId"] or "chest:"..tostring(k))
            table.remove(Chests,k)
            break
        end
    end
end)

function AddChest(Name,Coords,Mode)
    table.insert(Chests,{Name = Name, Coords = Coords, Mode = Mode})
    local v = Table[i]
    local k = #Chests
    local ChestName = Name..":"..tostring(k)
    interact.addCoords({
        id = ChestName,
        coords = vec3(Coords.x,Coords.y,Coords.z),
        options = {
            {
                label = _t("openChest"),
                icon = "archive",
                onSelect = function(data)
                    local Mode = Mode
                    if vSERVER.Permissions(Name,Mode) then
                        if not GlobalState["Restarting"] then
                            toggleInventory("chest")
                        else
                            TriggerEvent("Notify","vermelho","Servidor em reinicialização, aguarde.",8000)
                        end
                
                    end
                end,
                canInteract = function(entity, distance, coords, id)
                    return LocalPlayer["state"]["Active"] and not LocalPlayer["state"]["PVP"] and not GlobalState["Restarting"]
                end
            }
        },
        renderDistance = 10.0,
        activeDistance = 1.5,
        cooldown = 1500
    })
    return ChestName
end
exports("AddChest",AddChest)

function RemoveChest(Name)
    for k,v in pairs(Chests) do
        if v["Name"] == Name then
            table.remove(Chests,k)
            interact.removeById(Name)
        end
    end
end
exports("RemoveChest",RemoveChest)

function GetClosestChest()
    local Ped = PlayerPedId()
    local Coords = GetEntityCoords(Ped)
    local Closest = nil
    local ClosestDistance = 100
	for Name,v in pairs(Chests) do
        local Distance = #(Coords - v["Coords"])
        if Distance < ClosestDistance then
            Closest = v["Name"]
            ClosestDistance = Distance
        end
    end
    return Closest
end

function GetClosestChestTable(Table)
    local Ped = PlayerPedId()
    local Coords = GetEntityCoords(Ped)
    local Closest = nil
    local ClosestDistance = 100
	for _,Number in pairs(Table) do
        local v = Chests[Number]
        if v then
            local Distance = #(Coords - v["Coords"])
            if Distance < ClosestDistance then
                Closest = Number
                ClosestDistance = Distance
            end
        end
    end
    return Closest
end


function GetClosestChests()
    local Ped = PlayerPedId()
    local Coords = GetEntityCoords(Ped)
    local Closest = {}
    local ClosestDistance = 50
	for Name,v in pairs(Chests) do
        local Distance = #(Coords - v["Coords"])
        if Distance < ClosestDistance then
            table.insert(Closest,Name)
        end
    end
    return Closest
end

RegisterCommandLocalized("command.chest",function()

    if GetEntityHealth(PlayerPedId()) <= 100 then
        
        TriggerEvent("Notify","vermelho","Você precisa estar vivo para abrir o baú.",8000)
        return false
    end

    
    local ClosestChests = GetClosestChests()
    if GlobalState["Restarting"] then
        TriggerEvent("Notify","vermelho","Servidor em reinicialização, aguarde.",8000)
        return false
    end
    if LocalPlayer["state"]["FFA"] then
        return
    end
    if LocalPlayer["state"]["PVP"] then
        return
    end
    while #ClosestChests > 0 do
        local Selected = GetClosestChestTable(ClosestChests)
        if not Selected then
            return
        end

		if vSERVER.Permissions(Chests[Selected]["Name"],Chests[Selected]["Mode"],Selected) then
			toggleInventory("chest")
            return
        else
            for Index,Number in ipairs(ClosestChests) do
                if Number == Selected then
                    table.remove(ClosestChests,Index)
                    break
                end
            end
		end
    end
end)

function CreativeChest.GetClosestChest()
    return GetClosestChest()
end
