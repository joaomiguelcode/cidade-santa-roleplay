-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("bank")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ATMLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local Locations = {
	{ 150.32,-1040.88,29.37 },
	-- { 237.39,217.72,106.29 },
	{ -112.31,6469.4,31.63 },

	{ -2962.54,482.59,15.7 },
	{ -1212.68,-330.72,37.78 },
	{ -351.34,-49.76,49.03 },

	{ 313.9,-278.98,54.17 },

	{ 1473.55,6594.12,18.53 },
	{ 1470.24,6594.0,18.53 },

	{ 1470.33,6535.81,18.53 },
	{ 1473.53,6535.73,18.53 },
	-- tropadu7 santa
	-- { -3039.87,98.29,12.35 }, 
	-- nobre
	-- { -101.68,985.96,235.75 }, 
	-- { -636.45,-134.40,39.22 }, -- bombeiros
	{ 543.25,743.41,202.96 },

}

cityName = GetConvar("cityName", "")

if cityName == "Santa" then
    Locations[#Locations+1] = { -101.68,985.96,235.75 }
    Locations[#Locations+1] = { 237.39,217.72,106.29 }
    Locations[#Locations+1] = { -3039.87,98.29,12.35 }
elseif cityName == "CidadeNobre" then
    Locations[#Locations+1] = { -636.45,-134.40,39.22 }
    -- Locations[#Locations+1] = { -101.68,985.96,235.75 }
    Locations[#Locations+1] = { 237.39,217.72,106.29 }
    Locations[#Locations+1] = { -460.31,6003.30,32.39 } -- civil 
    Locations[#Locations+1] = { 2507.66,-327.34,93.16 } -- militar 
    Locations[#Locations+1] = { -2245.25,3285.72,32.81 } -- Exercito 
    Locations[#Locations+1] = { -3039.87,98.29,12.35 }

elseif cityName == "Boomerang" then
    Locations[#Locations+1] = { -636.45,-134.40,39.22 }
    Locations[#Locations+1] = { -101.68,985.96,235.75 }

elseif cityName == "Malta" then
    Locations[#Locations+1] = { -636.45,-134.40,39.22 }
    Locations[#Locations+1] = { -101.68,985.96,235.75 }
    Locations[#Locations+1] = { 237.39,217.72,106.29 }
    Locations[#Locations+1] = { -3039.87,98.29,12.35 }

elseif cityName == "Kingdom" then
    Locations[#Locations+1] = { -636.45,-134.40,39.22 }
    Locations[#Locations+1] = { -101.68,985.96,235.75 }
    Locations[#Locations+1] = { -579.91,-210.34,38.22 }
    Locations[#Locations+1] = { -3039.87,98.29,12.35 }

elseif cityName == "District99" then
    Locations[#Locations+1] = { -636.45,-134.40,39.22 }
    Locations[#Locations+1] = { -101.68,985.96,235.75 }
    Locations[#Locations+1] = { -3039.87,98.29,12.35 }

elseif cityName == "Krown" then
    Locations[#Locations+1] = { -636.45,-134.40,39.22 }
    Locations[#Locations+1] = { 237.39,217.72,106.29 }
    Locations[#Locations+1] = { -3039.87,98.29,12.35 }

elseif cityName == "Orizon" then
    Locations[#Locations+1] = { -636.45,-134.40,39.22 }
    Locations[#Locations+1] = { -101.68,985.96,235.75 }
    Locations[#Locations+1] = { 237.39,217.72,106.29 }
    Locations[#Locations+1] = { -3039.87,98.29,12.35 }

elseif cityName == "Liberty99" then
    Locations[#Locations+1] = { -636.45,-134.40,39.22 }
    Locations[#Locations+1] = { -101.68,985.96,235.75 }
    Locations[#Locations+1] = { 237.39,217.72,106.29 }
    Locations[#Locations+1] = { -3039.87,98.29,12.35 }

elseif cityName == "GoatRP" then
    Locations[#Locations+1] = { -636.45,-134.40,39.22 }
    Locations[#Locations+1] = { -101.68,985.96,235.75 }

elseif cityName == "Royal" then
    Locations[#Locations+1] = { -636.45,-134.40,39.22 }
    Locations[#Locations+1] = { -101.68,985.96,235.75 }
    Locations[#Locations+1] = { 237.39,217.72,106.29 }
    Locations[#Locations+1] = { -3039.87,98.29,12.35 }

elseif cityName == "Real" then
    Locations[#Locations+1] = { -636.45,-134.40,39.22 }
    Locations[#Locations+1] = { 237.39,217.72,106.29 }

elseif cityName == "Universo" then
    Locations[#Locations+1] = { -636.45,-134.40,39.22 }

elseif cityName == "Grande" then
    Locations[#Locations+1] = { 2630.21,5283.87,47.54 }
    Locations[#Locations+1] = { -1929.91,3019.92,34.00 } -- exercito
    Locations[#Locations+1] = { 2516.18,-414.62,94.09 } -- militar
    Locations[#Locations+1] = { -324.77,-625.84,32.82 } -- HP Sul
    Locations[#Locations+1] = { -624.51,-113.79,38.15 } -- Bombeiros
    Locations[#Locations+1] = { -101.68,985.96,235.75 }
    Locations[#Locations+1] = { 237.39,217.72,106.29 }
    Locations[#Locations+1] = { -550.16,-204.39,38.22 } -- juridico
    Locations[#Locations+1] = { -3039.87,98.29,12.35 }
    

elseif cityName == "Alexandria" then

elseif cityName == "Maresia" then
    Locations[#Locations+1] = { -2423.77,1749.26,187.96 } -- QG_84
    Locations[#Locations+1] = { -101.68,985.96,235.75 }
    Locations[#Locations+1] = { 237.39,217.72,106.29 }
    Locations[#Locations+1] = { -3039.87,98.29,12.35 }

end

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

local function TryStartTutorial()
    if not exports.tutorial:CanStartUiTutorial('tutorial.ui.bank') then
        return
    end

    SendNUIMessage({ action = "tutorialBank:start", data = exports.tutorial:GetTutorialById('tutorial.ui.bank') })
end


function StartInteraction()
    for Number = 1,#Locations do
        interact.addCoords({
            id = "bank:"..tostring(Number),
            coords = vec3(Locations[Number][1],Locations[Number][2],Locations[Number][3]),
            options = {
                {
                    label = _t("accessBank"),
                    icon = "university",
                    onSelect = function(data)
                        TriggerEvent("target:OpenBank", Number)
                    end,
                    canInteract = function(entity, distance, coords, id)
                        return not exports["hud"]:Wanted()
                    end
                }
            },
            renderDistance = 7.5,
            activeDistance = 1.5,
            cooldown = 1500
        })
    end
end

RegisterNetEvent("target:OpenBank")
AddEventHandler("target:OpenBank",function(Number)
    if not exports.admin:SafeguardAccountHasDiscordAccountLink() then
        return
    end

    SetNuiFocus(true,true)
    SendNUIMessage({ Action = "Open", name = LocalPlayer["state"]["Name"] })

    SendNUIMessage({
        action = "setVisible",
        data = true
    })

    TryStartTutorial()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
local debug = false

---@param message any
---@param data any
local function debugPrint(message, data)
    if debug then
        print("DEBUG - " .. message)
        if data then
            print(json.encode(data, {indent = true}))
        end
    end
end

RegisterNUICallback("Close",function(Data,Callback)
    debugPrint("Close callback called", Data)
    SendNUIMessage({
        action = "setVisible",
        data = false
    })
    SetNuiFocus(false,false)
    Callback(true)
end)

RegisterNUICallback("tutorialBank:finished",function(data,callback)
    exports.tutorial:SendFinishedUiTutorial('tutorial.ui.bank')
    callback(true)
end)

RegisterNUICallback("getCityId",function(Data,Callback)
    local city = GetConvar("cityName", "Santa")
    Callback(json.encode(string.lower(city)))
end)

RegisterNUICallback("getCityName",function(Data,Callback)
    local city = GetConvar("cityName", "Santa")
    Callback(json.encode(string.lower(city)))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Home",function(Data,Callback)
    local Info = vSERVER.Home()
    debugPrint("Home callback response", Info)
    Callback(Info)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEPOSIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Deposit",function(Data,Callback)
    debugPrint("Deposit callback called", Data)
    local Info = vSERVER.Deposit(parseInt(Data["value"]))
    debugPrint("Deposit callback response", Info)
    SendNUIMessage({
        action = "bank:update:transaction",
        data = Info
    })
    Callback(Info)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WITHDRAW
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Withdraw",function(Data,Callback)
    debugPrint("Withdraw callback called", Data)
    local Info = vSERVER.Withdraw(parseInt(Data["value"]))
    debugPrint("Withdraw callback response", Info)
    SendNUIMessage({
        action = "bank:update:transaction",
        data = Info
    })
    Callback(Info)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Transfer",function(Data,Callback)
    debugPrint("Transfer callback called", Data)
    if Data["targetId"] and Data["value"] then
        local Info = vSERVER.Transfer(Data["targetId"],parseInt(Data["value"]))
        debugPrint("Transfer callback response", Info)
        SendNUIMessage({
            action = "bank:update:transaction",
            data = Info
        })
        Callback(Info)
    else
        debugPrint("Transfer callback failed - missing data")
        Callback(false)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSACTIONHISTORY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("TransactionHistory",function(Data,Callback)
    debugPrint("TransactionHistory callback called", Data)
    local Info = vSERVER.TransactionHistory()
    debugPrint("TransactionHistory callback response", Info)
    Callback(Info)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINELIST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("getFines",function(Data,Callback)
    local Info = vSERVER.GetFines()
    local FormatedFines = FormatFines(Info)
    Callback(FormatedFines)
end)

RegisterNUICallback("payFine",function(Data,Callback)
    local Info = vSERVER.FinePayment(parseInt(Data))
    if Info then
        local FormatedFines = FormatFines(Info)
        SendNUIMessage({
            action = "setFines",
            data = FormatedFines
        })
    end
    Callback(true)
end)

RegisterNUICallback("PayAllFine",function(Data,Callback)
    local Info = vSERVER.FinePaymentAll()
    if Info then
        local FormatedFines = FormatFines(Info)
        SendNUIMessage({
            action = "setFines",
            data = FormatedFines
        })
    end
    Callback(true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINES
-----------------------------------------------------------------------------------------------------------------------------------------
function FormatFines(Fines)
    local Info = {}
    for i=1,#Fines do
        local Fine = Fines[i]
        Info[#Info + 1] = {
            fineId = Fine[1],
            value = Fine[2],
            type = "fines",
            description = Fine[3],
            date = Fine[4],
            status = Fine[5]
        }
    end
    return Info
end
