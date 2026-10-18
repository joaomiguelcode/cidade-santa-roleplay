Tunnel = module('vrp','lib/Tunnel')
Proxy = module('vrp','lib/Proxy')
vRP = Proxy.getInterface('vRP')
vRPServer = Tunnel.getInterface("vRP")
Client = {}
Tunnel.bindInterface("painel", Client)
vSERVER = Tunnel.getInterface("painel")
cityName = GetConvar("cityName", "")

GroupCoordinates = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("painel:OpenNew")
AddEventHandler("painel:OpenNew", function(Info)
    local Ped = PlayerPedId()
    local Health = GetEntityHealth(Ped)
    if Health <= 100 then
        return
    end
    -- TriggerEvent("vrp:createObjects","amb@code_human_in_bus_passenger_idles@female@tablet@base","base","prop_cs_tablet",50,28422)
    SendNUIMessage({
        action = 'openPainel',
        data = Info
    })
    SetNuiFocus(true, true)

    exports.scripted_interactions:startScriptedInteraction( 'tablet' )

    TriggerEvent('survey:set-kvp', 'already_entered_organization:'..LocalPlayer["state"]["Passport"], true)
end)

--- Callback for hiring a player.
--- @param Data table - The data sent from the client, containing the passport ID.
--- @param Callback function - The callback function to return the result to the client.
RegisterNUICallback("hire", function(Data, Callback)
    print("[DEBUG] - HIRE, Data: " .. json.encode(Data))
    local Status = vSERVER.Hire(parseInt(Data))
    print("[DEBUG] - Status, Data: ", tostring(Status))
    Callback(Status)
end)

local function requestRecruitClosest()
    local nearbyPlayers = sx.client.spatial.findPlayersNearby( 3.0, 1 )

    if #nearbyPlayers <= 0 then
        return
    end

    TriggerServerEvent( "net.painel.tryHireClosest", nearbyPlayers )
end

AddEventHandler( "net.painel.reqHireClosest", requestRecruitClosest )

--- Callback for sending farm data.
--- @param Data table - The data sent from the client, containing farm information.
--- @param Callback function - The callback function to return the result to the client.
RegisterNUICallback("sendFarm", function(Data, Callback)
    print("[DEBUG] - SEND FARM, Data: " .. json.encode(Data))
    local Status = vSERVER.DeliverFarm(Data)
    Callback(Status)
end)

--- Callback for updating permissions.
--- @param Data table - The data sent from the client, containing passport and role information.
--- @param Callback function - The callback function to return the result to the client.
RegisterNUICallback("updatePermission", function(Data, Callback)
    print("[DEBUG] - UPDATE PERMISSION, Data: " .. json.encode(Data))
    if Data and Data.passport then
        local Status = vSERVER.UpdatePermission(Data.passport, parseInt(Data.role))
        Callback(Status)
    end
end)

--- Callback for updating team.
--- @param Data table - The data sent from the client, containing passport and team information.
--- @param Callback function - The callback function to return the result to the client.
RegisterNUICallback("updateTeam", function(Data, Callback)
    print("[DEBUG] - UPDATE TEAM, Data: " .. json.encode(Data))
    if Data and Data.passport then
        local Status = vSERVER.UpdateTeam(Data.passport, parseInt(Data.team))
        Callback(Status)
    end
end)

--- Callback for changing farm settings.
--- @param Data table - The data sent from the client, containing reward, daily, and perFarm information.
--- @param Callback function - The callback function to return the result to the client.
RegisterNUICallback("changeMeta", function(Data, Callback)
    print("[DEBUG] - changeMeta, Data: " .. json.encode(Data))
    if Data and Data.reward then
        if Data.reward == "" or Data.reward == nil or Data.daily == "" or Data.daily == nil or Data.perFarm == "" or Data.perFarm == nil then
            return
        end
        vSERVER.UpdateFarmSettings(Data.reward or 0, Data.daily or 0, Data.perFarm or 0)
    end
end)

--- Callback for firing a player.
--- @param Data table - The data sent from the client, containing the passport ID.
--- @param Callback function - The callback function to return the result to the client.
RegisterNUICallback("fire", function(Data, Callback)
    print("[DEBUG] - FIRE, Data: " .. json.encode(Data))
    local Status = vSERVER.Fire(Data)
    Callback(Status)
end)

--- Callback for marking the organization location.
--- @param Data table - The data sent from the client.
--- @param Callback function - The callback function to return the result to the client.
RegisterNUICallback("orgLocation", function(Data, Callback)
    vSERVER.MarkGroupCoords()
    Callback(true)
end)

--- @param Data table - The data sent from the client: { x, y, z }.
--- @param Callback
RegisterNUICallback( 'setQgWaypoint', function( Data, Callback )
    
    local ok = vSERVER.SetQGWaypoint( Data )

    Callback( ok )
end)

--- @param Data table - The data sent from the client.
--- @param Callback
RegisterNUICallback( 'clearQgWaypoint', function( Data, Callback )

    local ok = vSERVER.ClearQGWaypoint()

    Callback( ok )
end)

--- Callback for opening the organization's Discord link.
--- @param Data table - The data sent from the client.
--- @param Callback function - The callback function to return the result to the client.
RegisterNUICallback("clickDiscord", function(Data, Callback)
    vSERVER.ClickGroupDiscord()
    Callback(true)
end)

--- Callback for saving male clothes for the organization.
--- @param Data table - The data sent from the client.
--- @param Callback function - The callback function to return the result to the client.
RegisterNUICallback("saveMale", function(Data, Callback)
    local customization = vSERVER.SaveUniform(Data.roleId, Data.gender, Data.customization)

    if not customization then
        return Callback(false)
    end

    TriggerEvent("skinshop:Apply", customization)
    Callback(true)
end)

--- Callback for saving female clothes for the organization.
--- @param Data table - The data sent from the client.
--- @param Callback function - The callback function to return the result to the client.
RegisterNUICallback("saveFemale", function(Data, Callback)
    local customization = vSERVER.SaveUniform(Data.roleId, Data.gender, Data.customization)

    if not customization then
        return Callback(false)
    end

    TriggerEvent("skinshop:Apply", customization)
    Callback(true)
end)

--- Callback for deleting male clothes.
--- @param Data table - The data sent from the client.
--- @param Callback function - The callback function to return the result to the client.
RegisterNUICallback("deleteMale", function(Data, Callback)
    print("[DEBUG] - deleteMale, Data: " .. json.encode(Data))
    Callback(true)
end)

--- Callback for deleting female clothes.
--- @param Data table - The data sent from the client.
--- @param Callback function - The callback function to return the result to the client.
RegisterNUICallback("deleteFemale", function(Data, Callback)
    print("[DEBUG] - deleteFemale, Data: " .. json.encode(Data))
    Callback(true)
end)

--- Callback for changing group settings.
--- @param Data table - The data sent from the client, containing color, banner, and radio information.
--- @param Callback function - The callback function to return the result to the client.
RegisterNUICallback("changeSettings", function(Data, Callback)
    print("[DEBUG] - changeSettings, Data: " .. json.encode(Data))
    Callback(vSERVER.UpdateGroupSettings(Data.color, Data.banner, tonumber(Data.radio)))
end)

--- Callback for buying VIP.
--- @param Data table - The data sent from the client.
--- @param Callback function - The callback function to return the result to the client.
RegisterNUICallback("buyVip", function(Data, Callback)
    print("[DEBUG] - buyVip, Data: " .. json.encode(Data))
    Callback(true)
end)

--- Callback for sending an announcement.
--- @param Data table - The data sent from the client.
--- @param Callback function - The callback function to return the result to the client.
RegisterNUICallback("sendAnnounce", function(Data, Callback)
    print("[DEBUG] - sendAnnounce, Data: " .. json.encode(Data))
    vSERVER.UpdateAnnounce(Data)
    Callback(true)
end)

--- Callback for inserting a rating.
--- @param Data table - The data sent from the client.
--- @param Callback function - The callback function to return the result to the client.
RegisterNUICallback("clickRating", function(Data, Callback)
    print("[DEBUG] - clickRating, Data: " .. json.encode(Data))
    toggleNuiFrame(false)
    vSERVER.EvaluateOrganization()
    Callback(true)
end)

--- Callback for rescuing farm data.
--- @param Data table - The data sent from the client.
--- @param Callback function - The callback function to return the result to the client.
RegisterNUICallback("rescueFarm", function(Data, Callback)
    print("[DEBUG] - rescueFarm")
    vSERVER.RewardFarm()
    Callback(true)
end)

--- Callback for updating an announcement.
--- @param Data table - The data sent from the client.
--- @param Callback function - The callback function to return the result to the client.
RegisterNUICallback("updateAnnounce", function(Data, Callback)
    print("[DEBUG] - updateAnnounce, Data: " .. json.encode(Data))
    Callback(true)
end)

--- Callback for applying a ban.
--- @param Data table - The data sent from the client, containing passport and reason information.
--- @param Callback function - The callback function to return the result to the client.
RegisterNUICallback("applyBan", function(Data, Callback)
    print("[DEBUG] - applyBan, Data: " .. json.encode(Data))
    if Data.passport and Data.reason then
        local Status = vSERVER.InsertBanned(Data)
        Callback(Status)
    end
end)

--- Callback for removing a ban.
--- @param Data table - The data sent from the client, containing the passport ID.
--- @param Callback function - The callback function to return the result to the client.
RegisterNUICallback("removeBan", function(Data, Callback)
    vSERVER.RemoveBanned(Data)
    print("[DEBUG] - removeBan, Data: " .. json.encode(Data))
    Callback(true)
end)

exports('GetWearUniform', function()
    return vSERVER.WearUniform()
end)


--- Callback for setting clothes for the organization.
RegisterNUICallback('setCloth', function(Data, Callback)
    local customization = vSERVER.WearUniform()

    toggleNuiFrame(false)
    Callback(customization and true or false)
    exports["dynamic"]:wearUniform(customization)
    
end)

local function IsRecruitCommitmentOpen()
    local ok, open = pcall(function()
        return exports.hud:IsQualityRecruitmentOpen()
    end)

    return ok and open
end

RegisterNetEvent("painel:applyRecruitUniform", function(customization)
    TriggerEvent("skinshop:Apply", customization, nil, nil, true)
    Wait(1500)

    if IsRecruitCommitmentOpen() then
        repeat Wait(500) until not IsRecruitCommitmentOpen()
        Wait(5000)
    end

    TriggerServerEvent("painel:recruitUniformApplied")
end)

RegisterNUICallback('getServerHost', function(Data, Callback)
    local api_url = GetConvar("api_url", "")
    print("[DEBUG] - GET SERVER HOST, api_url: " .. api_url)
    Callback(api_url)
end)

--- Callback for entering the radio channel.
RegisterNUICallback('enterRadio', function(Data, Callback)
    print("[DEBUG] - ENTER RADIO")
    TriggerServerEvent("painel:EnterRadio")
    toggleNuiFrame(false)
    TriggerEvent("vrp:removeObjects")
    Callback(true)
end)

local gFarmScreenOpen = false

--- Toggle the NUI frame visibility.
--- @param shouldShow boolean - Whether to show or hide the NUI frame.
function toggleNuiFrame(shouldShow)
    SetNuiFocus(shouldShow, shouldShow)
    SendReactMessage('setVisible', shouldShow)
    if not shouldShow then
        gFarmScreenOpen = false
        TriggerEvent("hud:Active", true)
        exports.scripted_interactions:stopScriptedInteraction({ interactionName = 'tablet' })
    end
end

--- Send a message to the NUI frame.
--- @param action string - The action to perform.
--- @param data table - The data to send with the action.
function SendReactMessage(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end

AddEventHandler( "ui:exclusiveModalOpened", function()
    toggleNuiFrame( false )
end )

RegisterNUICallback('hideFrame', function(_, cb)
    toggleNuiFrame(false)
    cb({})
end)

--- Callback para obter lista de uniformes
--- Retorna: Array de uniformes no formato [{roleId, roleName, roleNumber, male, female}]
RegisterNUICallback("getUniforms", function(Data, Callback)
    Callback(vSERVER.GetUniforms()) --[[vSERVER.GetUniforms()]]
end)

--- Callback para resetar preset de uniforme
--- Envia: {roleId: number, gender: "male"|"female"}
RegisterNUICallback("resetUniformPreset", function(Data, Callback)
    TriggerEvent("vrp:removeObjects")
    toggleNuiFrame(false)

    local model = Data.gender == 'male' and `mp_m_freemode_01` or `mp_f_freemode_01`

    local skinshopData = {
        flags = eSkinshopOpenFlags.TEMPORARY_CUSTOMIZATION,
        customModel = model,
        callback = function(cloth)
            ExecuteCommand(_t("painel.Command"))
                
            if not next(cloth) then
                return Callback(false)
            end
                
            Callback(vSERVER.SaveUniform(Data.roleId, Data.gender, cloth))
        end
    }

    TriggerEvent("skinshop:open-with-flags", skinshopData)
end)

RegisterNetEvent("painel:Notify")
AddEventHandler("painel:Notify", function(Table)
    SendNUIMessage({
        action = 'Notify',
        data = Table
    })
end)

function CheckIfIlegal()
    local Job = LocalPlayer.state['Job']
    if not Job then
        return false
    end
    local Groups = GetGroups()
    if Groups["Ilegal"] and Groups["Ilegal"]["Parent"] and Groups["Ilegal"]["Parent"][Job] then
        return true
    end
    return false
end
exports('CheckIfIlegal', CheckIfIlegal)

function CheckIfNotPolice()
    local Job = LocalPlayer.state['Job']
    if not Job then
        return false
    end
    local Groups = GetGroups()
    if Groups["Policia"] and Groups["Policia"]["Parent"] and Groups["Policia"]["Parent"][Job] then
        return true
    end
    return false
end

RegisterNUICallback('getNewFarmStatus', function(_, Callback)
    local hasNewFarm = false
    if GlobalState["NewFarmPVP"] then
        if CheckIfIlegal() then
            hasNewFarm = true
        else
            if not CheckIfNotPolice() then
                hasNewFarm = true
            end
        end
    end
    Callback(hasNewFarm)
end)

local DefaultFarmCoords = {
    vector3(5213.0,-5130.88,6.84),
    vector3(5212.67,-5128.15,6.86),
    vector3(5212.49,-5125.92,6.82),
    vector3(4987.43,-5883.61,18.14),
    vector3(4986.64,-5879.45,18.14),
    vector3(4990.48,-5878.29,18.14),
    vector3(4991.13,-5882.86,18.14),
    vector3(4926.02,-5244.05,2.53),
    vector3(4924.01,-5245.46,2.53),
    vector3(5067.34,-4591.35,2.85),
    vector3(5064.33,-4590.27,2.85),
    vector3(5132.46,-4612.87,2.48),
    vector3(4435.5,-4446.81,5.26),
    vector3(4438.29,-4445.8,5.27),
    ----
    vector3(1055.71,2306.84,47.68),
    vector3(1056.04,2293.86,47.68),       
    vector3(1060.33,2301.91,47.68),
    vector3(1071.8,2306.66,47.68),
    vector3(1063.18,2297.6,47.68),
    vector3(1069.11,2297.57,47.68),
    vector3(1073.58,2298.03,47.68),
    vector3(1062.98,2293.67,47.68),
    vector3(1086.32,2299.97,47.68),
    vector3(1080.7,2306.42,47.68),
    vector3(1079.98,2311.06,47.68),
    vector3(1079.02,2324.81,47.68),
    vector3(1091.13,2322.06,47.68),
    vector3(1095.74,2318.23,47.68),
    vector3(1098.37,2308.22,47.68),
    vector3(1094.0,2298.14,47.68),      
    vector3(1082.39,2293.5,47.68),
    vector3(1071.05,2292.91,47.68),  
    vector3(1075.47,2318.58,47.68),  
    vector3(1071.53,2311.13,47.68),  
    vector3(1091.62,2312.79,47.68),
    vector3(154.16,-3075.05,8.26),
    vector3(147.43,-3075.58,7.53),
    vector3(140.77,-3075.27,7.28),
    vector3(129.3,-3077.56,6.72),
    vector3(120.8,-3075.53,7.62),
    vector3(122.11,-3082.48,6.91),
    vector3(129.25,-3083.44,7.18),
    vector3(133.13,-3083.78,7.01),
    vector3(141.39,-3084.47,6.96),
    vector3(142.19,-3099.27,7.45),
    vector3(125.79,-3099.25,5.93),
    vector3(122.67,-3103.63,8.17),
    vector3(128.44,-3110.08,7.72),
    vector3(143.46,-3112.29,6.87),
}

local AtmCoords = {
    vector3(265.9130,212.8171,105.4062),
    vector3(-1415.4801,-212.3324,45.4954),
    vector3(1153.1111,-326.9019,68.2050),
    vector3(-537.8052,-854.9357,28.2754),
    vector3(-1206.1417,-325.0316,36.8510),     
    vector3(-1570.7653,-547.7035,33.9322),
    vector3(-3144.8875,1127.8110,19.8380),
    vector3(-1410.1830,-100.6454,51.3965),
    vector3(145.8392,-1035.6254,28.3678),
    vector3(-2958.9771,487.3071,14.4780),
    vector3(1167.0601,-455.6541,65.8186),
    vector3(112.4761,-819.8080,30.3396),
    vector3(236.9777,219.8758,105.4062),
    vector3(-867.9745,-186.3419,36.8822),
    vector3(1137.8113,-468.8625,65.6987),
    vector3(-1315.4160,-834.4310,15.9523),
    vector3(-1205.3783,-326.5286,36.8510),
    vector3(1968.3923,3743.0784,31.3437),
    vector3(-132.6663,6366.8765,30.4726),
    vector3(285.3485,142.9751,103.1623),
    vector3(-1091.8875,2709.0535,17.9194),
    vector3(-97.6372,6455.7319,30.4679),
    vector3(357.1284,174.0836,102.0597),
    vector3(-95.8703,6457.4619,30.4739),
    vector3(-1430.6633,-211.3587,45.4716),
    vector3(-596.1251,-1160.8503,21.3336),
    vector3(156.1886,6643.2002,30.5937),
    vector3(-2956.8481,487.2158,14.4780),
    vector3(-594.6144,-1160.8519,21.3335),
    vector3(-1410.7357,-98.9279,51.3970),
    vector3(1735.0105,6410.0098,34.0372),
    vector3(-526.7791,-1223.3737,17.4527),
    vector3(147.4731,-1036.2175,28.3678),
    vector3(-2071.9285,-317.2862,12.3181),
    vector3(-282.7141,6226.4302,30.4965),
    vector3(173.8246,6638.2173,30.5937),
    vector3(-3040.2046,593.2969,6.9089),
    vector3(265.5650,211.8610,105.4062),
    vector3(1700.6941,6426.7622,31.6330),
    vector3(-867.0130,-187.9928,36.8822),
    vector3(-1569.8396,-547.0309,33.9322),
    vector3(-1314.4659,-835.6913,15.9523),
    vector3(266.2610,213.7733,105.4062),
    vector3(-2974.5864,380.1269,14.0000),
    vector3(237.8378,218.0314,105.4062),
    vector3(238.2678,217.1092,105.4062),
    vector3(238.6978,216.1870,105.4062),
    vector3(118.6416,-883.5695,30.1395),
    vector3(237.4077,218.9536,105.4062),
    vector3(264.8689,209.9486,105.4062),
    vector3(158.7965,234.7452,105.6433),
    vector3(-3043.8347,594.1639,6.7328),
    vector3(265.2169,210.9048,105.4062),
}

function GetClosestAtm()
    local Ped = PlayerPedId()
    local AtmCoords = AtmCoords
    local MaxDistance = 9999
    local Selected = nil
    for i = 1, #AtmCoords do
        local Coords = AtmCoords[i]
        local Distance = #(Coords - GetEntityCoords(Ped))
        if Distance < MaxDistance then  
            MaxDistance = Distance
            Selected = Coords
        end
    end
    return Selected
end

function GetClosestRobbery()
    local Ped = PlayerPedId()
    local RobberyCoords = exports.player:GetTypeRobberys("pequena")
    local MaxDistance = 9999
    local Selected = nil
    for i = 1, #RobberyCoords do
        local Coords = RobberyCoords[i]
        local Distance = #(Coords - GetEntityCoords(Ped))
        if Distance < MaxDistance then
            MaxDistance = Distance
            Selected = Coords
        end
    end
    return Selected
end

function GetClosestWorldPVP()
    local Ped = PlayerPedId()
    local WorldPVPCoords = exports.warsystem:GetWorldPVPStart()
    local MaxDistance = 75.0
    local Selected = nil
    for i = 1, #WorldPVPCoords do
        local Coords = vector3(WorldPVPCoords[i][1]["x"], WorldPVPCoords[i][1]["y"], WorldPVPCoords[i][1]["z"])
        local Distance = #(Coords - GetEntityCoords(Ped))
        if Distance < MaxDistance then
            MaxDistance = Distance
            Selected = WorldPVPCoords[i]
        end
    end
    return Selected
end

local newFarmsHookSent = false
RegisterNUICallback('newFarmsViewed', function(_, Callback)

    --[[ 
        NOTE: como temos que fazer em "gambi", vamos garantir que o hook 
        seja enviado apenas uma vez, para evitar spam de eventos no servidor

        - @TkzDev
    --]]

    if not newFarmsHookSent then
        newFarmsHookSent = true
        TriggerServerEvent( 'painel:server:newFarmsViewed' )
    end

    Callback({})
end)

RegisterNUICallback('openNewFarm', function(Data, Callback)
    local Type = Data.type

    if Type == "active_farm" then
        local Coords = GetClosestFarm()
        if Coords then
            toggleNuiFrame(false)
            Wait(100)
            SetNewWaypoint(Coords.x, Coords.y)
            TriggerEvent("Notify2","#active_farm")
        end
    elseif Type == "afk_farm" then
        toggleNuiFrame(false)
        Wait(100)
        ExecuteCommand("afk")
    elseif Type == "atm" then
        local Coords = GetClosestAtm()
        if Coords then
            toggleNuiFrame(false)
            Wait(100)
            exports.missions:AddWaypointToMission(
                {
                    key    = "atm",
                    coords = Coords,
                    title  = "Caixa Eletrônico",
                }
            )
            TriggerEvent("Notify","Confirmed", "O caixa eletrônico mais próximo está marcado no mapa.", 7500, "Caixa Eletronico")
        end
    elseif Type == "lojinha" then
        local Coords = GetClosestRobbery()
        if Coords then
            toggleNuiFrame(false)
            Wait(100)
            exports.missions:AddWaypointToMission(
                {
                    key    = "lojinha",
                    coords = Coords,
                    title  = "Lojinha",
                }
            )
            TriggerEvent("Notify","Confirmed", "A lojinha mais próxima está marcada no mapa.", 7500, "Lojinha")
        end
    elseif Type == "pista" then
        local Info = GetClosestWorldPVP()
        if Info then
            toggleNuiFrame(false)
            Wait(100)
            TriggerServerEvent("WorldPVP:Start", Info[2])
        else
            toggleNuiFrame(false)
            Wait(100)
            TriggerEvent("Notify","Warning", "Você não esta proximo a sua facção, posicao marcada no mapa.", 7500, "Pista")
            vSERVER.MarkGroupCoords()
        end
    elseif Type == "1x1" then
        toggleNuiFrame(false)
        Wait(100)
        ExecuteCommand("x1")
    elseif Type == "domination_farm" then
        -- O seletor de bases e aberto pelo dminigames apos a validacao server-side.
        toggleNuiFrame(false)
        Wait(100)
        TriggerServerEvent("painel:server:joinDomination")
    end
    Callback(true)
end)

function GetClosestFarm()
    local Ped = PlayerPedId()
    local FarmCoords = exports.farmer:GetDefCoords()
    local Job = LocalPlayer.state['Job']
    local MaxDistance = 50.0
    local Selected = nil
    if Job then
        for i = 1, #FarmCoords do
            local Coords = FarmCoords[i]
            local GroupCoords = GroupCoordinates[Job]
            local Distance = #(Coords - GroupCoords)
            if Distance < MaxDistance then
                MaxDistance = Distance
                Selected = Coords
            end
        end
    end
    if not Selected then
        for i = 1, #DefaultFarmCoords do
            local Coords = DefaultFarmCoords[i]
            local Distance = #(Coords - GetEntityCoords(Ped))
            local MaxDistance = 99999
            if Distance < MaxDistance then
                MaxDistance = Distance
                Selected = Coords
            end
        end
    end
    return Selected
end

function GetGroupFac(Group)
    local groupCache = GlobalState["GROUP_CACHE"]
    if not groupCache or type(groupCache) ~= "table" then
        return Group
    end
    local RevertThisShit = {}
    for gName, fName in pairs(groupCache) do
        RevertThisShit[fName] = gName
    end
    if RevertThisShit[Group] then
        return RevertThisShit[Group]
    end
    return Group
end

CreateThread(function()
    Wait(2500)
    local CacheCoordinates = exports["org_system"]:GetAllOfConfig("RISK_ZONES")
    for i = 1, #CacheCoordinates do
        local Config = CacheCoordinates[i]
        for j = 1, #Config do
            local Coords = Config[j][1]
            local Group = Config[j][2]
            local HasFacSystem = string.find(Group, "QG_")
            if HasFacSystem then
                local Fac = GetGroupFac(Group)
                if Fac then
                    Group = Fac
                end
            end
            GroupCoordinates[Group] = Config[j][1]
        end
    end
end)

---@return boolean active
local function IsAffiliateCommercialActive()

    if GetResourceState( 'dashboard' ) ~= 'started' then
        return false
    end

    local ok, active = pcall( function()
        return exports.dashboard:IsAffiliateCommercialActive()
    end )

    return ok and active == true
end

RegisterNetEvent("painel:OpenFarmScreen", function(Info)

    if IsAffiliateCommercialActive() then
        return
    end

    gFarmScreenOpen = true
    SendNUIMessage({
        action = 'openPainelNewFarms',
        data = Info
    })
    SetNuiFocus(true, true)
end)

AddEventHandler( 'dashboard:affiliateCommercialActiveChanged', function( active )

    if active ~= true or not gFarmScreenOpen then
        return
    end

    gFarmScreenOpen = false
    toggleNuiFrame( false )
end )

RegisterCommand("openpanel", function()
    if exports.dashboard:BlockIfInRestrictWorld() then
        return
    end

    if GetResourceState("new_hub") == "started" and exports.new_hub:IsAffiliateWorldClientActive() then
        return
    end

    ExecuteCommand(_t("command.painel"))
end)

RegisterKeyMapping("openpanel", "Abrir o painel", "keyboard", "O")
