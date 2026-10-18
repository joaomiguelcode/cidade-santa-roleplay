-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("tablet")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Open = "Santos"
local cityName = GetConvar("cityName", "")
local Discount = 1
local LogosDealership = {
    ["Dev-Season3"] = "./assets/images/logo.webp",
    ["Santa"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/santanew.png",
	["Grande"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/grande2.png",
	["Alexandria"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/alexandria2.png",
	["Maresia"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/newmaresia.png",
	["Galaxy"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/galaxy.png",
    ["Universo"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/universo2.png",
    ["Gaules"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/santanew.png",
    ["Fronteira"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/fronteira.png",
    ["CidadeNobre"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/nobre_2.png",
    ["Boomerang"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/boomerang.webp",
    ["Malta"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/maltarp.png",
    ["Kingdom"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/knglogo.png",
    ["Imperium"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/imperium.png",
    ["GoatRP"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/goatrp.png",
    ["District99"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/District99.png",
    ["Krown"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/krown.png",
    ["Orizon"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/Orizon.png",
    ["Liberty99"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/Liberty99.png",
    ["Royal"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/new_royal.png",
    ["Real"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/real.webp",
    ["Prime"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/prime.png",
}

local gDealershipVehicleInfoDatabaseCars   = { }
local gDealershipVehicleInfoDatabaseBikes  = { }
local gDealershipVehicleInfoDatabaseRental = { }

---@param opts dealership.VehicleInfoDatabaseInitOptions | nil
local function InitClientDealershipVehicleInfoDatabase( opts )

    assert( opts )

    return InitDealershipVehicleInfoDatabase( opts )
end

---@type dealership.VehicleInfoDatabaseInitOptions | nil
local initOpts = GlobalState[ DEALERSHIP_VEHICLE_INFO_DATABASE_INIT_OPTIONS_STATE_BAG_KEY ]

-- Iniciar banco de dados caso a gente já tenha
-- as opções de inicialização, caso contrario, o statebagchangehandler
-- será executado.

if initOpts then

    gDealershipVehicleInfoDatabaseCars,
    gDealershipVehicleInfoDatabaseBikes,
    gDealershipVehicleInfoDatabaseRental = InitClientDealershipVehicleInfoDatabase( initOpts )
end

AddStateBagChangeHandler( 'global', DEALERSHIP_VEHICLE_INFO_DATABASE_INIT_OPTIONS_STATE_BAG_KEY, function ( _, __, value )

    ---@type dealership.VehicleInfoDatabaseInitOptions | nil
    local opts = value

    InitClientDealershipVehicleInfoDatabase( opts )
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TABLET:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("tablet:Open")
AddEventHandler("tablet:Open",function(Select)
	if LocalPlayer["state"]["Route"] < 900000 then
		local Ped = PlayerPedId()
        local VipDiscount = vSERVER.TabletHasVip()
        Discount = VipDiscount
        local HasLauncher = vSERVER.TabletHasLauncher()
        Discount = HasLauncher
		if not LocalPlayer["state"]["Buttons"] and not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and GetEntityHealth(Ped) > 100 then
			Open = Select
			SetNuiFocus(true,true)
			SetCursorLocation(0.5,0.5)
			SendNUIMessage({
                action = 'setVisible',
                data = 'dealership'
            })
            TriggerEvent("talknpc:closeTalk")
		end
	end
end)

---@type table<string, vector3[]>
local StartCoordsCitys = {
    ["Santa"] = {
        vector3(-43.09,-1104.63,26.42),
        vector3(-58.18,-1097.76,26.42),
        vector3(-30.39,-1104.88,26.42),
        vector3(1472.01,6584.89,18.64), -- Pier Norte
    },
    ["CidadeNobre"] = {
        vector3(-52.40,-1091.53,28.00),
        vector3(-43.23,-1083.28,28.00),
        vector3(-34.88,-1086.36,28.00),
        vector3(-38.94,-1096.44,28.00),
        vector3(-27.00,-1101.38,28.00),
    },
    ["Grande"] = {
        vector3(-43.09,-1104.63,26.42),
        vector3(-58.18,-1097.76,26.42),
        vector3(-30.39,-1104.88,26.42),
        vector3(1472.01,6584.89,18.64), -- Pier Norte
    },
    ["Malta"] = {
        vector3(-52.40,-1091.53,28.00),
        vector3(-43.23,-1083.28,28.00),
        vector3(-34.88,-1086.36,28.00),
        vector3(-38.94,-1096.44,28.00),
        vector3(-27.00,-1101.38,28.00),
    },
    ["Universo"] = {
        vector3(-43.09,-1104.63,26.42),
        vector3(-58.18,-1097.76,26.42),
        vector3(-30.39,-1104.88,26.42),
        vector3(1472.01,6584.89,18.64), -- Pier Norte
    },
    ["Maresia"] = {
        vector3(-43.09,-1104.63,26.42),
        vector3(-58.18,-1097.76,26.42),
        vector3(-30.39,-1104.88,26.42),
        vector3(1472.01,6584.89,18.64), -- Pier Norte
    },
    ["Alexandria"] = {
        vector3(-43.09,-1104.63,26.42),
        vector3(-58.18,-1097.76,26.42),
        vector3(-30.39,-1104.88,26.42),
        vector3(1472.01,6584.89,18.64), -- Pier Norte
    },
    ["Fronteira"] = {
        vector3(-43.09,-1104.63,26.42),
        vector3(-58.18,-1097.76,26.42),
        vector3(-30.39,-1104.88,26.42),
        vector3(1472.01,6584.89,18.64), -- Pier Norte
    },
    ["Orizon"] = {
        vector3(-43.09,-1104.63,26.42),
        vector3(-58.18,-1097.76,26.42),
        vector3(-30.39,-1104.88,26.42),
        vector3(1472.01,6584.89,18.64), -- Pier Norte
    },
    ["Boomerang"] = {
        vector3(-43.09,-1104.63,26.42),
        vector3(-58.18,-1097.76,26.42),
        vector3(-30.39,-1104.88,26.42),
    },
    ["Galaxy"] = {
        vector3(-43.09,-1104.63,26.42),
        vector3(-58.18,-1097.76,26.42),
        vector3(-30.39,-1104.88,26.42),
    },
    ["Kingdom"] = {
        vector3(-43.09,-1104.63,26.42),
        vector3(-58.18,-1097.76,26.42),
        vector3(-30.39,-1104.88,26.42),
    },
    ["Imperium"] = {
        vector3(-43.09,-1104.63,26.42),
        vector3(-58.18,-1097.76,26.42),
        vector3(-30.39,-1104.88,26.42),
    },
    ["GoatRP"] = {
        vector3(-43.09,-1104.63,26.42),
        vector3(-58.18,-1097.76,26.42),
        vector3(-30.39,-1104.88,26.42),
    },
    ["District99"] = {
        vector3(-43.09,-1104.63,26.42),
        vector3(-58.18,-1097.76,26.42),
        vector3(-30.39,-1104.88,26.42),
    },
    ["Krown"] = {
        vector3(-43.09,-1104.63,26.42),
        vector3(-58.18,-1097.76,26.42),
        vector3(-30.39,-1104.88,26.42),
    },
    ["Liberty99"] = {
        vector3(-43.09,-1104.63,26.42),
        vector3(-58.18,-1097.76,26.42),
        vector3(-30.39,-1104.88,26.42),
    },
    ["Royal"] = {
        vector3(-43.09,-1104.63,26.42),
        vector3(-58.18,-1097.76,26.42),
        vector3(-30.39,-1104.88,26.42),
    },
    ["Real"] = {
        vector3(-43.09,-1104.63,26.42),
        vector3(-58.18,-1097.76,26.42),
        vector3(-30.39,-1104.88,26.42),
    },
    ["Prime"] = {
        vector3(-43.09,-1104.63,26.42),
        vector3(-58.18,-1097.76,26.42),
        vector3(-30.39,-1104.88,26.42),
    },
    ["Gaules"] = {
        vector3(-43.09,-1104.63,26.42),
        vector3(-58.18,-1097.76,26.42),
        vector3(-30.39,-1104.88,26.42),
    },
}

local StartCoords = StartCoordsCitys[cityName] or {}

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
    for i=1, #StartCoords do
        interact.addCoords({
            id = "dealership:"..tostring(i),
            coords = vec3(StartCoords[i]["x"],StartCoords[i]["y"],StartCoords[i]["z"]),
            options = {
                {
                    label = _t("dealership"),
                    icon = "car",
                    onSelect = function(data)
                        Open = "shop"
                        SetNuiFocus(true,true)
                        SetCursorLocation(0.5,0.5)
                        SendNUIMessage({
                            action = 'setVisible',
                            data = 'dealership'
                        })
                        TriggerEvent("talknpc:closeTalk")
                    end,
                    canInteract = function(entity, distance, coords, id)
                        local Ped = PlayerPedId()
                        return not LocalPlayer["state"]["Buttons"] and not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not exports.combatsystem:IsInCombat( { showHint = true } ) and GetEntityHealth(Ped) > 100
                    end
                }
            },
            renderDistance = 7.5,
            activeDistance = 1.5,
            cooldown = 1500
        })
    end
end
RegisterNUICallback("getCityId",function(Data,Callback)
    cityName = GetConvar("cityName", "")
    Callback(string.lower(cityName))
end)


RegisterNUICallback("getCityName",function(Data,Callback)
    cityName = GetConvar("cityName", "")
    Callback(string.lower(cityName))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TABLET:LOGO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("getLogoUrl", function(data, cb)
    local logoLink = LogosDealership[cityName]
    print(logoLink)
    cb(logoLink)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("hideFrame",function(Data,Callback)
	SetNuiFocus(false,false)
	SetCursorLocation(0.5,0.5)
    SendNUIMessage({
        action = 'setVisible',
        data = false
    })

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CARROS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("getCars",function(Data,Callback)
    local Data = gDealershipVehicleInfoDatabaseCars
    for i=1,#Data do
        local Info = VehicleInfo(Data[i]["k"])
        if Info["Mode"] == "rental" then
            Discount = 1
        end
        if Discount < 1 then
            Data[i]["price"] = Data[i]["price"] - (Data[i]["price"] * Discount)
        end
    end
	Callback(Data)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOTOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("getMotorcycles",function(Data,Callback)
    local Data = gDealershipVehicleInfoDatabaseBikes
    for i=1,#Data do
        local Info = VehicleInfo(Data[i]["k"])
        if Info["Mode"] == "rental" then
            Discount = 1
        end
        if Discount < 1 then
            Data[i]["price"] = Data[i]["price"] - (Data[i]["price"] * Discount)
        end
    end
	Callback(Data)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ALUGUEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("getVips",function(Data,Callback)
    -- local Data = GlobalState["Rental"]
    -- for i=1,#Data do
    --     Data[i]["price"] = Data[i]["price"] * Discount
    -- end
	Callback(gDealershipVehicleInfoDatabaseRental)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("buyVehicle",function(Data,Callback)
    if not IsModelValid(GetHashKey(Data["spawn"])) then
        Callback("Ok")
        return TriggerEvent("Notify2","#veh_not_found")
    end

	vSERVER.Buy(Data["spawn"])
	SetNuiFocus(false,false)
	SetCursorLocation(0.5,0.5)
    SendNUIMessage({
        action = 'setVisible',
        data = false
    })
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RENTAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("buyVIP",function(Data,Callback)
	--vSERVER.Rental(Data["spawn"])
    local cityName = GetConvar("cityName", "")
    TriggerEvent("player:OpenURL", StoreLink[cityName])
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RENTAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("buyVehicleWithDiamonds",function(Data,Callback)
	vSERVER.RentalDiamonds(Data["spawn"])
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TABLET:CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("tablet:Close")
AddEventHandler("tablet:Close",function()
    SetNuiFocus(false,false)
    SetCursorLocation(0.5,0.5)
    SendNUIMessage({
        action = 'setVisible',
        data = false
    })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRIVEABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local vehDrive = nil
local benDrive = false
local benCoords = { 0.0,0.0,0.0 }
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("testDrive",function(Data,Callback)
    SetNuiFocus(false,false)
    SetCursorLocation(0.5,0.5)
    SendNUIMessage({
        action = 'setVisible',
        data = false
    })
    local Ped = PlayerPedId()
    local Coords = GetEntityCoords(Ped)
    benCoords = { Coords["x"],Coords["y"],Coords["z"] }

    if not IsModelValid(GetHashKey(Data["spawn"])) then
        Callback("Ok")
        return TriggerEvent("Notify2","#veh_not_found")
    end

	if vSERVER.startDrive() then
		local Ped = PlayerPedId()

		LocalPlayer["state"]["Race"] = true
		LocalPlayer["state"]["Commands"] = true
		--TriggerEvent("Notify","azul","Teste iniciado, para finalizar saia do veículo.",5000)

        TriggerEvent("Notify2","#testDrive")
		Wait(1000)

		vehCreate(Data["spawn"])
		benDrive = true
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHCREATE
-----------------------------------------------------------------------------------------------------------------------------------------
function vehCreate(vehName)
    local hash = GetHashKey(vehName)
    local BoostList = exports['variables']:GetVariable('variables','BoostList') or {}
    local Ped = PlayerPedId()

    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(100)
    end

		if Open == "Santos" then
			vehDrive = CreateVehicle(hash,-53.28,-1110.93,26.47,68.04,false,false)
		elseif Open == "Sandy" then
			vehDrive = CreateVehicle(hash,1209.74,2713.49,37.81,175.75,false,false)
        else
            vehDrive = CreateVehicle(hash,-53.28,-1110.93,26.47,68.04,false,false)
		end

        while not DoesEntityExist(vehDrive) do
            Wait(100)
        end

		SetModelAsNoLongerNeeded(vehName)
		SetEntityInvincible(vehDrive,true)
		SetPedIntoVehicle(Ped,vehDrive,-1)
        SetVehicleModKit(veh,0)
        TriggerServerEvent("CleanVehicle",VehToNet(vehDrive))
        if isModelNative(vehName) then
            local Init = GetVehicleHandlingFloat(vehDrive,"CHandlingData","fInitialDriveForce")
            local InitStering = GetVehicleHandlingFloat(vehDrive,"CHandlingData","fSteeringLock")
            local InitCurveMax = GetVehicleHandlingFloat(vehDrive,"CHandlingData","fTractionCurveMax")
            local InitCurveMin = GetVehicleHandlingFloat(vehDrive,"CHandlingData","fTractionCurveMin")
            local InitDriveInertia = GetVehicleHandlingFloat(vehDrive,"CHandlingData","fDriveInertia")    
            local InitBrakeForce = GetVehicleHandlingFloat(vehDrive,"CHandlingData","fBrakeForce")                
            SetVehicleHandlingFloat(vehDrive, "CHandlingData", "fInitialDriveForce",Init + 0.3 )
            SetVehicleHandlingFloat(vehDrive,"CHandlingData","fSteeringLock",InitStering + 0.3 )
            SetVehicleHandlingFloat(vehDrive,"CHandlingData","fTractionCurveMax",InitCurveMax + 0.3 )
            SetVehicleHandlingFloat(vehDrive,"CHandlingData","fTractionCurveMin",InitCurveMin + 0.3 )
            SetVehicleHandlingFloat(vehDrive,"CHandlingData","fDriveInertia",InitDriveInertia + 0.3)
            SetVehicleHandlingFloat(vehDrive,"CHandlingData","fBrakeForce",InitBrakeForce + 1.0)
            SetVehicleModKit(vehDrive,0)
            SetVehicleMod(vehDrive,11,GetVehicleMod(vehDrive,11),true)
        end
        if BoostList[vehName] then
            local Init = GetVehicleHandlingFloat(vehDrive,"CHandlingData","fInitialDriveForce")
            SetVehicleHandlingFloat(vehDrive, "CHandlingData", "fInitialDriveForce",Init + BoostList[vehName])
            SetVehicleModKit(vehDrive,0)
            SetVehicleMod(vehDrive,11,GetVehicleMod(vehDrive,11),true)
        end
        if VehicleVip(vehName) then
            SetVehicleMod(vehDrive,0,GetNumVehicleMods(vehDrive,0)-1,false)
            SetVehicleMod(vehDrive,1,GetNumVehicleMods(vehDrive,1)-1,false)
            SetVehicleMod(vehDrive,2,GetNumVehicleMods(vehDrive,2)-1,false)
            SetVehicleMod(vehDrive,3,GetNumVehicleMods(vehDrive,3)-1,false)
            SetVehicleMod(vehDrive,4,GetNumVehicleMods(vehDrive,4)-1,false)
            SetVehicleMod(vehDrive,5,GetNumVehicleMods(vehDrive,5)-1,false)
            SetVehicleMod(vehDrive,6,GetNumVehicleMods(vehDrive,6)-1,false)
            SetVehicleMod(vehDrive,7,GetNumVehicleMods(vehDrive,7)-1,false)
            SetVehicleMod(vehDrive,8,GetNumVehicleMods(vehDrive,8)-1,false)
            SetVehicleMod(vehDrive,9,GetNumVehicleMods(vehDrive,9)-1,false)
            SetVehicleMod(vehDrive,10,GetNumVehicleMods(vehDrive,10)-1,false)
            SetVehicleMod(vehDrive,11,GetNumVehicleMods(vehDrive,11)-1,false)
            SetVehicleMod(vehDrive,12,GetNumVehicleMods(vehDrive,12)-1,false)
            SetVehicleMod(vehDrive,13,GetNumVehicleMods(vehDrive,13)-1,false)
            SetVehicleMod(vehDrive,14,16,false)
            SetVehicleMod(vehDrive,15,GetNumVehicleMods(vehDrive,15)-2,false)
            SetVehicleMod(vehDrive,16,GetNumVehicleMods(vehDrive,16)-1,false)
            ToggleVehicleMod(vehDrive,17,true)
            ToggleVehicleMod(vehDrive,18,true)
            ToggleVehicleMod(vehDrive,19,true)
            ToggleVehicleMod(vehDrive,20,true)
            ToggleVehicleMod(vehDrive,21,true)
            ToggleVehicleMod(vehDrive,22,true)
            SetVehicleMod(vehDrive,25,GetNumVehicleMods(vehDrive,25)-1,false)
            SetVehicleMod(vehDrive,27,GetNumVehicleMods(vehDrive,27)-1,false)
            SetVehicleMod(vehDrive,28,GetNumVehicleMods(vehDrive,28)-1,false)
            SetVehicleMod(vehDrive,30,GetNumVehicleMods(vehDrive,30)-1,false)
            SetVehicleMod(vehDrive,33,GetNumVehicleMods(vehDrive,33)-1,false)
            SetVehicleMod(vehDrive,34,GetNumVehicleMods(vehDrive,34)-1,false)
            SetVehicleMod(vehDrive,35,GetNumVehicleMods(vehDrive,35)-1,false)
            SetVehicleMod(vehDrive,38,GetNumVehicleMods(vehDrive,38)-1,true)
            SetVehicleTyreSmokeColor(vehDrive,155,0,0)
            SetVehicleWindowTint(vehDrive,1)
            SetVehicleTyresCanBurst(vehDrive,false)
            SetVehicleNumberPlateTextIndex(vehDrive,5)
            SetVehicleModColor_1(vehDrive,155,0,0)
            SetVehicleModColor_2(vehDrive,135,135)
            SetVehicleColours(vehDrive,1,0)
            SetVehicleExtraColours(vehDrive,1,0)
            SetVehicleNeonLightEnabled(vehDrive,0,true)
            SetVehicleNeonLightEnabled(vehDrive,1,true)
            SetVehicleNeonLightEnabled(vehDrive,2,true)
            SetVehicleNeonLightEnabled(vehDrive,3,true)
            SetVehicleNeonLightsColour(vehDrive,155,0,0)
        end
        benDrive = true
        local TestDriveTimer = GetGameTimer() + 1000*60*5
        CreateThread(function()
            while benDrive do
                --DisableControlAction(1,69,false)
                if GetGameTimer() >= TestDriveTimer then
                    Wait(100)
                    benDrive = false
                    vSERVER.removeDrive()
                    LocalPlayer["state"]["Race"] = false
                    LocalPlayer["state"]["Commands"] = false
                    SetEntityCoords(Ped,benCoords[1],benCoords[2],benCoords[3],false,false,false,false)
                    FreezeEntityPosition(Ped,true)
                    Wait(2500)
                    FreezeEntityPosition(Ped,false)
                    if DoesEntityExist(vehDrive) then
                        DeleteEntity(vehDrive)
                    end
                end
                if not IsPedInAnyVehicle(Ped) then
                    Wait(100)
                    benDrive = false
                    vSERVER.removeDrive()
                    LocalPlayer["state"]["Race"] = false
                    LocalPlayer["state"]["Commands"] = false
                    SetEntityCoords(Ped,benCoords[1],benCoords[2],benCoords[3],false,false,false,false)
                    FreezeEntityPosition(Ped,true)
                    Wait(2500)
                    FreezeEntityPosition(Ped,false)
                    if DoesEntityExist(vehDrive) then
                        DeleteEntity(vehDrive)
                    end
                end
                Wait(1)
            end
        end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local initVehicles = {}
local Vehicles = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------

if cityName == "Santa" then
    Vehicles = {
        {
            ["Coords"] = vec3(-2545.6,3762.85,17.90), -- ARCHIHOME PK
            ["heading"] = 232.45,
            ["Model"] = "rmodpagani",
            ["Distance"] = 100
        },{
            ["Coords"] = vec3(-2548.29,3733.89,17.85), -- ARCHIHOME PK
            ["heading"] = 300.48,
            ["Model"] = "bdivo",
            ["Distance"] = 100
        },{
            ["Coords"] = vec3(-3248.17,-1185.04,7.87), -- ILHA YURI
            ["heading"] = 187.09,
            ["Model"] = "yurirrmansory",
            ["Color"] = { 255,255,255 },
            ["Rotate"] = true,
            ["Distance"] = 100
        },{
            ["Coords"] = vec3(46.46,813.6,192.80), -- LAGO ALPHAVILLE
            ["heading"] = 198.43,
            ["Model"] = "luxury1",
            ["Color"] = { 0,0,0 },
            ["Distance"] = 200
        },{
            ["Coords"] = vec3(-161.44,760.48,192.80), -- LAGO ALPHAVILLE
            ["heading"] = 237.12,
            ["Model"] = "luxury1",
            ["Color"] = { 255,255,255 },
            ["Distance"] = 200
        },{
            ["Coords"] = vec3(154.86,-966.84,29.82), -- kart
            ["heading"] = 158.75,
            ["Model"] = "mariokart7",
            ["Distance"] = 100
        },
    }
elseif cityName == "CidadeNobre" then    
    Vehicles = {
        {
            ["Coords"] = vec3(-27.61,-1096.52,27.53), -- concessinaria
            ["heading"] = 155.91,
            ["Model"] = "luxwellroyal",
            ["Distance"] = 50
        },
        {
            ["Coords"] = vec3(-51.7,-1096.39,27.5), -- concessinaria
            ["heading"] = 155.91,
            ["Model"] = "bellmontvelora",
            ["Distance"] = 50
        },
        {
            ["Coords"] = vec3(-37.89,-1101.44,27.67), -- concessinaria
            ["heading"] = 155.91,
            ["Model"] = "cavalcadesuperabs",
            ["Distance"] = 50
        },
        {
            ["Coords"] = vec3(-15.23,-1101.62,27.65), -- concessinaria
            ["heading"] = 153.08,
            ["Model"] = "cavalcadelimoabs",
            ["Distance"] = 50
        },
    }
elseif cityName == "Boomerang" then    
    Vehicles = {
        {
            ["Coords"] = vec3(154.86,-966.84,29.82), -- kart
            ["heading"] = 158.75,
            ["Model"] = "mariokart7",
            ["Distance"] = 100
        },
    }
elseif cityName == "Grande" then    
    Vehicles = {
        {
            ["Coords"] = vec3(154.86,-966.84,29.82), -- kart
            ["heading"] = 158.75,
            ["Model"] = "mariokart7",
            ["Distance"] = 100
        },
        {
            ["Coords"] = vec3(3104.09,5429.08,23.51),
            ["heading"] = 272.13,
            ["Model"] = "insurgent3",
            ["Distance"] = 100
        },
        {
            ["Coords"] = vec3(3102.23,5432.35,23.52),
            ["heading"] = 272.13,
            ["Model"] = "insurgent2",
            ["Distance"] = 100
        },
        {
            ["Coords"] = vec3(3100.19,5435.64,23.51),
            ["heading"] = 272.13,
            ["Model"] = "insurgent3",
            ["Distance"] = 100
        },
        {
            ["Coords"] = vec3(3115.03,5435.42,23.51),
            ["heading"] = 150.24,
            ["Model"] = "insurgent3",
            ["Distance"] = 100
        },
        {
            ["Coords"] = vec3(3113.11,5438.72,23.52),
            ["heading"] = 150.24,
            ["Model"] = "insurgent2",
            ["Distance"] = 100
        },
        {
            ["Coords"] = vec3(3111.14,5441.97,23.51),
            ["heading"] = 150.24,
            ["Model"] = "insurgent3",
            ["Distance"] = 100
        },
    }
elseif cityName == "Malta" then    
    Vehicles = {
        {
            ["Coords"] = vec3(154.86,-966.84,29.82), -- kart
            ["heading"] = 158.75,
            ["Model"] = "mariokart7",
            ["Distance"] = 100
        },
        {
            ["Coords"] = vec3(-1914.74,3045.86,32.81),
            ["heading"] = 359.31,
            ["Model"] = "rhino",
            ["Distance"] = 100
        },
        {
            ["Coords"] = vec3(-2319.39,3414.09,30.66),
            ["heading"] = 359.31,
            ["Model"] = "rhino",
            ["Distance"] = 100
        },
        {
            ["Coords"] = vec3(-27.61,-1096.52,27.53), -- concessinaria
            ["heading"] = 155.91,
            ["Model"] = "luxwellroyal",
            ["Distance"] = 50
        },
        {
            ["Coords"] = vec3(-51.7,-1096.39,27.5), -- concessinaria
            ["heading"] = 155.91,
            ["Model"] = "bellmontvelora",
            ["Distance"] = 50
        },
        {
            ["Coords"] = vec3(-37.89,-1101.44,27.67), -- concessinaria
            ["heading"] = 155.91,
            ["Model"] = "cavalcadesuperabs",
            ["Distance"] = 50
        },
        {
            ["Coords"] = vec3(-15.23,-1101.62,27.65), -- concessinaria
            ["heading"] = 153.08,
            ["Model"] = "cavalcadelimoabs",
            ["Distance"] = 50
        },
    }
elseif cityName == "Kingdom" then    
    Vehicles = {
        {
            ["Coords"] = vec3(154.86,-966.84,29.82), -- kart
            ["heading"] = 158.75,
            ["Model"] = "mariokart7",
            ["Distance"] = 100
        },
    }
elseif cityName == "Imperium" then    
    Vehicles = {
        {
            ["Coords"] = vec3(154.86,-966.84,29.82), -- kart
            ["heading"] = 158.75,
            ["Model"] = "mariokart7",
            ["Distance"] = 100
        },
    }
elseif cityName == "GoatRP" then    
    Vehicles = {
        {
            ["Coords"] = vec3(154.86,-966.84,29.82), -- kart
            ["heading"] = 158.75,
            ["Model"] = "mariokart7",
            ["Distance"] = 100
        },
    }
elseif cityName == "District99" then    
    Vehicles = {
        {
            ["Coords"] = vec3(154.86,-966.84,29.82), -- kart
            ["heading"] = 158.75,
            ["Model"] = "mariokart7",
            ["Distance"] = 100
        },
    }
elseif cityName == "Krown" then    
    Vehicles = {
        {
            ["Coords"] = vec3(154.86,-966.84,29.82), -- kart
            ["heading"] = 158.75,
            ["Model"] = "mariokart7",
            ["Distance"] = 100
        },
    }
elseif cityName == "Orizon" then    
    Vehicles = {
        {
            ["Coords"] = vec3(154.86,-966.84,29.82), -- kart
            ["heading"] = 158.75,
            ["Model"] = "mariokart7",
            ["Distance"] = 100
        },
    }
elseif cityName == "Liberty99" then    
    Vehicles = {
        {
            ["Coords"] = vec3(154.86,-966.84,29.82), -- kart
            ["heading"] = 158.75,
            ["Model"] = "mariokart7",
            ["Distance"] = 100
        },
    }
elseif cityName == "Royal" then    
    Vehicles = {
        {
            ["Coords"] = vec3(154.86,-966.84,29.82), -- kart
            ["heading"] = 158.75,
            ["Model"] = "mariokart7",
            ["Distance"] = 100
        },
    }
elseif cityName == "Real" then    
    Vehicles = {
        {
            ["Coords"] = vec3(154.86,-966.84,29.82), -- kart
            ["heading"] = 158.75,
            ["Model"] = "mariokart7",
            ["Distance"] = 100
        },
    }
elseif cityName == "Universo" then    
    Vehicles = {
        {
            ["Coords"] = vec3(154.86,-966.84,29.82), -- kart
            ["heading"] = 158.75,
            ["Model"] = "mariokart7",
            ["Distance"] = 100
        },
    }
elseif cityName == "Galaxy" then
    Vehicles = {
        {
            ["Coords"] = vec3(154.86,-966.84,29.82), -- kart
            ["heading"] = 158.75,
            ["Model"] = "mariokart7",
            ["Distance"] = 100
        },
    }
elseif cityName == "Maresia" then
    Vehicles = {
        {
            ["Coords"] = vec3(154.86,-966.84,29.82), -- kart
            ["heading"] = 158.75,
            ["Model"] = "mariokart7",
            ["Distance"] = 100
        },
        {
            ["Coords"] = vec3(-3839.03,-4441.28,15.76),
            ["heading"] = 321.71,
            ["Model"] = "lazer",
            ["Distance"] = 100
        },
        {
            ["Coords"] = vec3(-3845.58,-4428.81,15.77),
            ["heading"] = 321.27,
            ["Model"] = "lazer",
            ["Distance"] = 100
        },
        {
            ["Coords"] = vec3(-3849.91,-4410.34,15.77),
            ["heading"] = 322.98,
            ["Model"] = "lazer",
            ["Distance"] = 100
        },
        {
            ["Coords"] = vec3(-3823.44,-4484.73,15.76),
            ["heading"] = 290.23,
            ["Model"] = "lazer",
            ["Distance"] = 100
        },
        {
            ["Coords"] = vec3(-3773.86,-4455.13,15.77),
            ["heading"] = 125.01,
            ["Model"] = "lazer",
            ["Distance"] = 100
        },
        {
            ["Coords"] = vec3(-3788.64,-4408.05,15.77),
            ["heading"] = 134.27,
            ["Model"] = "lazer",
            ["Distance"] = 100
        },
        {
            ["Coords"] = vec3(-3805.71,-4342.39,15.76),
            ["heading"] = 129.09,
            ["Model"] = "lazer",
            ["Distance"] = 100
        },
        {
            ["Coords"] = vec3(-3821.68,-4278.94,15.77),
            ["heading"] = 137.31,
            ["Model"] = "lazer",
            ["Distance"] = 100
        },
        {
            ["Coords"] = vec3(-3817.72,-4292.29,15.77),
            ["heading"] = 140.23,
            ["Model"] = "lazer",
            ["Distance"] = 100
        },
    }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
local rotatingVehicles = {}

-- Spawn/despawn thread — runs every 1000ms regardless of rotation
CreateThread(function()
    while true do
        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)
        if Vehicles then
            for i = 1, #Vehicles do
                local Distance = #(Coords - Vehicles[i]["Coords"])
                if Distance <= Vehicles[i]["Distance"] then
                    if not initVehicles[i] then
                        if LoadModel(Vehicles[i]["Model"]) then
                            local Colors = Vehicles[i]["Colors"] or vector3(0, 0, 0)
                            initVehicles[i] = CreateVehicle(Vehicles[i]["Model"], Vehicles[i]["Coords"], Vehicles[i]["heading"], false, false)
                            SetVehicleCustomPrimaryColour(initVehicles[i], Colors)
                            SetVehicleCustomSecondaryColour(initVehicles[i], Colors)
                            SetVehicleNumberPlateText(initVehicles[i], "SANTA")
                            FreezeEntityPosition(initVehicles[i], true)
                            SetVehicleDoorsLocked(initVehicles[i], 2)
                            SetModelAsNoLongerNeeded(Vehicles[i]["Model"])
                            SetVehicleEngineOn(initVehicles[i], false, false, true)

                            if Vehicles[i]["Rotation"] then
                                SetEntityRotation(initVehicles[i], Vehicles[i]["Rotation"], 2, true)
                            end

                            if Vehicles[i]["Color"] then
                                SetVehicleCustomPrimaryColour(initVehicles[i], Vehicles[i]["Color"][1], Vehicles[i]["Color"][2], Vehicles[i]["Color"][3])
                            end

                            if Vehicles[i]["Rotate"] then
                                rotatingVehicles[i] = true
                            end
                        end
                    end
                else
                    if initVehicles[i] then
                        if DoesEntityExist(initVehicles[i]) then
                            DeleteEntity(initVehicles[i])
                            initVehicles[i] = nil
                            rotatingVehicles[i] = nil
                        end
                    end
                end
            end
        end
        Wait(1000)
    end
end)

-- Rotation thread — only active when rotating vehicles are in range
CreateThread(function()
    while true do
        local hasRotating = false
        if Vehicles then
            for i = 1, #Vehicles do
                if rotatingVehicles[i] and initVehicles[i] then
                    hasRotating = true
                    SetEntityHeading(initVehicles[i], GetEntityHeading(initVehicles[i]) + 0.10)
                end
            end
        end
        Wait(hasRotating and 16 or 1000)
    end
end)