-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-- print("vRP initialized successfully")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Client = {}
Tunnel.bindInterface("organization_war", Client)
Server = Tunnel.getInterface("organization_war")
-- print("Tunnel connection established")

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
InEvent = false
selectedMap = nil
selectedTeam = nil
local isNuiOpen = false
local confirmationCallback = nil
local timer = nil
local responseReceived = false

local function GetWarLocale()
    local lang = GetConvar( 'language', 'pt-br' )
    local fileUrl = ( 'locales/frontend-i18n-config/%s/organization_war.json' ):format( lang )
    local contents = LoadResourceFile( 'localization', fileUrl )
    if not contents then
        contents = LoadResourceFile( 'localization', 'locales/frontend-i18n-config/pt-br/organization_war.json' )
    end
    return contents and json.decode( contents ) or nil
end

local function BuildTranslatedWarMaps(locale)
    local out = {}
    for mapKey, def in pairs(WAR_MAPS) do
        local nameKey = "mapName_" .. mapKey
        local descKey = "mapDesc_" .. mapKey
        out[mapKey] = {
            name = (locale and locale[nameKey]) or def.name,
            description = (locale and locale[descKey]) or def.description,
            image = def.image,
            spawn_points = def.spawn_points,
        }
    end
    return out
end

--- Lista de modos na mesma ordem de WAR_MODES, com rótulos traduzidos para o NUI.
local function BuildTranslatedWarModes(locale)
    local t = {}
    for _, id in ipairs(WAR_MODES) do
        local k = "weaponMode_" .. id
        t[#t + 1] = (locale and locale[k]) or id
    end
    return t
end

function openRequest(info)
    -- -- print("Opening request with info:", json.encode(info))
    if not isNuiOpen then
        isNuiOpen = true
        SetNuiFocus(true, true)
        local locale = GetWarLocale()
        if locale then
            SendNUIMessage({ action = "locale", data = locale })
        end
        SendNUIMessage({
            action = "openRequest",
            data = info
        })

        timer = GetGameTimer() + 60000

        Citizen.CreateThread(function()
            while isNuiOpen do
                Citizen.Wait(0)
                if GetGameTimer() > timer and not responseReceived then
                    -- print("Timer expired, closing NUI")
                    closeNui(false)
                end
            end
        end)
    end
end

function closeNui(result)
    -- print("Closing NUI with result:", result)
    if isNuiOpen then
        isNuiOpen = false
        SetNuiFocus(false, false)
        SendNUIMessage({
            action = "setVisible",
            data = false
        })
        if confirmationCallback then
            confirmationCallback(result)
            confirmationCallback = nil
        end
    end
end

function Client.SendRequest(Info)
    local result = nil
    local waiting = true
    print("Client.SendRequest called with Info:", json.encode(Info, {indent = true}))
    confirmationCallback = function(response)
        result = response
        responseReceived = true
        waiting = false
        -- print("Confirmation callback result:", result)
    end

    openRequest(Info)

    while waiting do
        Citizen.Wait(0)
    end

    return result
end

RegisterNUICallback("requestResponse", function(data, cb)
    -- print("NUICallback: requestResponse, Data:", data)
    closeNui(data)
end)

RegisterCommand("testconfirm", function()
    -- print("Test confirm command executed")
    local Info = {
        ["map"] = "1x1",
        ["eventType"] = "Pistola",
        ["minPlayersQuantity"] = 2,
        ["rounds"] = 1,
        ["bet"] = 1000,
        ["leader"] = "Teste",
        ["rival"] = "Teste"
    }
    local result = Client.SendRequest(Info)
    
    if result then
        -- print("User confirmed.")
    else
        -- print("User denied or timer expired.")
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local function OpenWarScreen( screen )
    local locale = GetWarLocale()
    if locale then
        SendNUIMessage({ action = "locale", data = locale })
    end
    SendNUIMessage({ action = "setVisible", data = screen })
    SetNuiFocus( true, true )
end

RegisterCommand("facxfac", function()
    OpenWarScreen( "war" )
end)

RegisterCommand("gangxgang", function()
    OpenWarScreen( "war" )
end)

function SetSameTeam(TeamName)
    -- print("Setting same team with TeamName:", TeamName)
    local Ped = PlayerPedId()
    AddRelationshipGroup(TeamName)
    local TeamHash = GetHashKey(TeamName)
    SetPedRelationshipGroupHash(Ped,TeamHash)
    SetEntityCanBeDamagedByRelationshipGroup(Ped,false,TeamHash)
end

RegisterCommand("screen2", function()
    -- print("Screen 2 command executed")
    SendNUIMessage({
        action = "setVisible",
        data = "team"
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback("getEventInfo", function(data, cb)
    local locale = GetWarLocale()
    local eventInfo = {
        ['modes'] = BuildTranslatedWarModes(locale),
        ['maps'] = BuildTranslatedWarMaps(locale),
        ['labels'] = locale
    }
    cb(eventInfo)
end)

RegisterNUICallback("createEvent", function(data, cb)
    local eventType = ResolveWarWeaponModeFromLocale(data.eventType)
    Server._CreateEvent(data.map, eventType, data.playersQuantity, data.rounds, data.bet)
    if cb then cb({ ok = true }) end
end)

RegisterNUICallback("getRivals", function(data, cb)
    -- print("NUICallback: getRivals")
    local organizations = Server.GetOrganizations()
    cb(organizations)
end)

RegisterNUICallback("sendRival", function(data, cb)
    -- print("NUICallback: sendRival, Data:", json.encode(data))
    Server._SelectRival(data)
    SendNUIMessage({
        action = "setVisible",
        data = false
    })
    SetNuiFocus(false, false)
end)

RegisterNUICallback("getTeam", function(data, cb)
    -- print("NUICallback: getTeam")
    local members = Server.GetOrganizationMembers()
    cb(members)
end)

RegisterNUICallback("sendTeam", function(data, cb)
    -- print("NUICallback: sendTeam, Data:", json.encode(data))
    Server._SelectPlayers(data.time)
    cb(true)
end)

RegisterNetEvent("organization_war:GetPlayers")
AddEventHandler("organization_war:GetPlayers", function(minPlayers)
    local locale = GetWarLocale()
    if locale then
        SendNUIMessage({ action = "locale", data = locale })
    end
    SendNUIMessage({
        action = "GetPlayers",
        data = minPlayers
    })
    SetNuiFocus(true, true)
end)

RegisterNetEvent("organization_war:GetRivals")
AddEventHandler("organization_war:GetRivals", function()
    local locale = GetWarLocale()
    if locale then
        SendNUIMessage({ action = "locale", data = locale })
    end
    SendNUIMessage({
        action = "GetRivals",
        data = minPlayers
    })
    SetNuiFocus(true, true)
end)

AddEventHandler("gameEventTriggered", function(name, args)
    ---- print("Game Event Triggered: Name:", name, "Args:", json.encode(args))
    if name ~= "CEventNetworkEntityDamage" then
        return
    end
    local Victim = PlayerPedId()
    
    if args[1] ~= Victim then
        return
    end 

    ---- print("Entity Damage Event triggered on Victim:", Victim)
    
    if not InEvent then
        return
    end
    
    local Attacker = tonumber(args[2])
    local VictimDied = GetEntityHealth(Victim) <= 100
    local Weapon = tostring(args[7])
    if VictimDied then
        ---- print("Victim Died: Attacker:", Attacker, "Weapon:", Weapon)
        if IsEntityAPed(Victim) then
            if IsPedAPlayer(Attacker) then
                local KillerServerId = GetPlayerServerId((NetworkGetPlayerIndexFromPed(Attacker)))
                local VictimServerId = GetPlayerServerId(PlayerId())
                local KillerCoordinate = GetEntityCoords(Attacker)
                ---- print("KillerServerId:", KillerServerId, "VictimServerId:", VictimServerId)
                TriggerServerEvent("organization_war:KillEvent", KillerServerId, VictimServerId, Weapon)
            end
        end
    end
end)

RegisterNetEvent("organization_war:Start")
AddEventHandler("organization_war:Start", function(map, number, Table, mode)
    -- print("Event: organization_war:Start with Map:", map, "Team:", number, "Mode:", mode)
    SetSameTeam(Table[number].name)
    local Ped = PlayerPedId()
    local Player = PlayerId()
    selectedMap = map
    selectedTeam = number
    selectedMode = mode
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "setVisible",
        data = "countdown"
    })
    InEvent = true
    local Test = {
        ["myTeam"] = {
            ["name"] = Table[1].name,
            ["score"] = Table[1].wins
        },
        ["theirTeam"] = {
            ["name"] = Table[2].name,
            ["score"] = Table[2].wins
        }
    }
    -- print("Game Stats:", json.encode(Test, {indent = true}))
    SetEntityCoords(Ped, WAR_MAPS[selectedMap].spawn_points[selectedTeam].x, WAR_MAPS[selectedMap].spawn_points[selectedTeam].y, WAR_MAPS[selectedMap].spawn_points[selectedTeam].z)
    FreezeEntityPosition(Ped, true)
    StartingEvent = true
    SetRunSprintMultiplierForPlayer(Player, 1.15)
    SetEntityCollision(Ped, true, true)
    Wait(100)
    exports["survival"]:Revive(400)
    Wait(100)
    SendNUIMessage({
        action = "UpdateGameStats",
        data = Test
    })
    ClearPedTasks(Ped)
    TriggerEvent("hud:Active", true)
    TriggerEvent("Notify:Remkey", true)
    -- print("Weapons loaded for mode:", selectedMode)
    -- local _,currentWeapon = GetCurrentPedWeapon(Ped)
    -- if currentWeapon ~= GetHashKey(WAR_MODES_ITENS[selectedMode]) then
    --     exports["inventory"]:putWeaponHands(WAR_MODES_ITENS[selectedMode], 250, {}, false)
    -- end
    Wait(2500)
    SendNUIMessage({
        action = "setVisible",
        data = "gameplay"
    })
    if StartingEvent then
        StartingEvent = false
        FreezeEntityPosition(Ped, false)
    end 
end)

RegisterNetEvent("organization_war:NextRound")
AddEventHandler("organization_war:NextRound", function(Table)
    -- print("Event: organization_war:NextRound")
    local Ped = PlayerPedId()
    local Player = PlayerId()
    SetEntityCoords(Ped, WAR_MAPS[selectedMap].spawn_points[selectedTeam].x, WAR_MAPS[selectedMap].spawn_points[selectedTeam].y, WAR_MAPS[selectedMap].spawn_points[selectedTeam].z)
    FreezeEntityPosition(Ped, true)
    StartingEvent = true
    SetRunSprintMultiplierForPlayer(Player, 1.15)
    SendNUIMessage({
        action = "UpdateGameStats",
        data = {
            ["myTeam"] = {
                ["name"] = Table[1].name,
                ["score"] = Table[1].wins
            },
            ["theirTeam"] = {
                ["name"] = Table[2].name,
                ["score"] = Table[2].wins
            }
        }
    })
    SetEntityCollision(Ped, true, true)
    Wait(100)
    exports["survival"]:Revive(400)
    Wait(100)
    ClearPedTasks(Ped)
    TriggerEvent("hud:Active", true)
    TriggerEvent("Notify:Remkey", true)
    Wait(5000)
    -- print("Weapons loaded for next round:", selectedMode)
    -- local _,currentWeapon = GetCurrentPedWeapon(Ped)
    -- if currentWeapon ~= GetHashKey(WAR_MODES_ITENS[selectedMode]) then
    --     exports["inventory"]:putWeaponHands(WAR_MODES_ITENS[selectedMode], 250, {}, false)
    -- end
    if StartingEvent then
        StartingEvent = false
        FreezeEntityPosition(Ped, false)
    end 
end)

RegisterNetEvent("organization_war:Finish")
AddEventHandler("organization_war:Finish", function(Table)
    -- print("Event: organization_war:Finish")
    InEvent = false
    local Ped = PlayerPedId()
    local Player = PlayerId()
    SetEntityCoords(Ped, WAR_FINISH_COORDS.x, WAR_FINISH_COORDS.y, WAR_FINISH_COORDS.z)
    SetNuiFocus(false, false)
    TriggerEvent("Notify:Remkey", false)
    SendNUIMessage({
        action = "setVisible",
        data = false
    })
    Wait(1500)
    exports["survival"]:Revive(400)
end)

RegisterNUICallback('hideFrame', function(_, cb)
    -- print("NUICallback: hideFrame")
    SendNUIMessage({
        action = "setVisible",
        data = false
    })
    SetNuiFocus(false, false)
end)