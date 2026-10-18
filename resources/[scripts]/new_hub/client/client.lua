
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPS = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Client = {}
Tunnel.bindInterface("new_hub",Client)
vSERVER = Tunnel.getInterface("new_hub")
cityName = GetConvar("cityName", "")
PlayerData = {}
local isRadarActive = false

local DISABLED_PAGES_BY_CITIES = {
    Real = { "/skins" },
    Prime = { "/skins" },
    District99 = { "/skins" },
    Liberty99 = { "/skins" },
    Krown = { "/skins" },
    GoatRP = { "/skins" },
    Kingdom = { "/skins" },
    Royal = { "/skins" },
    Boomerang = { "/skins" },
    Malta = { "/skins" },
	Orizon = { "/skins","/promotions" }
}

---@return string[]
local function GetDisabledHubPages()

    return DISABLED_PAGES_BY_CITIES[GetConvar("cityName", "")] or {}
end

local function IsPvpChallengeBetConfirmOpen()
    if GetResourceState('dminigames') ~= 'started' then
        return false
    end

    local ok, isOpen = pcall(function()
        return exports['dminigames']:IsChallengeBetConfirmOpen()
    end)

    return ok and isOpen == true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local PlayerBattlePass = {}
local Pause = false

CreateThread(function()
    local wasPaused = false
    while true do
        local isPaused = IsPauseMenuActive() and GetPauseMenuState() ~= 30
        if isPaused and not wasPaused then
            TriggerEvent("hud:Active",false)
            TriggerEvent("chat:Toggle",false)
            wasPaused = true
        elseif not isPaused and wasPaused then
            TriggerEvent("hud:Active",true)
            TriggerEvent("chat:Toggle",true)
            wasPaused = false
        end
        Wait(250)
    end
end)

local BONE_ID__SKEL_Head = 0x322C

local HUB_CAMERA_DISTANCE = 3.0

local HUB_CAMERA_BONE_OFFSET__SKEL_Head = vec3( 0.10, 0.0, 0.0 - 0.15 )

local gHubCameraId = nil
local gHubCameraShapeTestHandle = nil
local gHubCameraShapeTestLastResultPos = nil
gOpenMicSetup = false

---@param camId number
---@param overridePos? vector3
local function ResetHubCameraPosition( camId, overridePos )

    local pedId = PlayerPedId()
    local pedPos = GetEntityCoords( pedId )

    local wishCamPos =
        overridePos
            and overridePos
            or  GetEntityForwardVector( pedId ) * HUB_CAMERA_DISTANCE + pedPos

    -- if not IsCamActive( camId ) then

        SetCamCoord( camId, wishCamPos.x, wishCamPos.y, wishCamPos.z )
    -- end

    -- InterpolateCamWithParams( camId, wishCamPos.x, wishCamPos.y, wishCamPos.z, 0.0, 0.0, 0.0, 20.0, 1000,1, 1, 2, 1)

    PointCamAtPedBone( camId, pedId, BONE_ID__SKEL_Head, HUB_CAMERA_BONE_OFFSET__SKEL_Head.x, HUB_CAMERA_BONE_OFFSET__SKEL_Head.y, HUB_CAMERA_BONE_OFFSET__SKEL_Head.z, true )

    TaskLookAtCoord( pedId, wishCamPos.x, wishCamPos.y, wishCamPos.z, 0.0, 0.0, 0.0, 20.0, 1000, 1, 1, 2, 1 )
end

---@param fc number
---@return boolean
local function UpdateHubCamera( fc )

    local camId = gHubCameraId

    if not camId then
        return false
    end

    -- if fc % 10 == 0 then

        ResetHubCameraPosition( camId --[[, gHubCameraShapeTestLastResultPos )]])
    -- end

    --[=[
    if fc % 10 == 0 then

        if not gHubCameraShapeTestHandle then

            local camPos = GetCamCoord( camId )

            local pedId = PlayerPedId()

            local bonePos = GetPedBoneCoords( pedId, BONE_ID__SKEL_Head, HUB_CAMERA_BONE_OFFSET__SKEL_Head.x, HUB_CAMERA_BONE_OFFSET__SKEL_Head.y, HUB_CAMERA_BONE_OFFSET__SKEL_Head.z, true )

            print('bonePos', bonePos)

            gHubCameraShapeTestHandle = StartShapeTestLosProbe( camPos.x, camPos.y, camPos.z, bonePos.x, bonePos.y, bonePos.z, -1 --[[ Everything ]], 0, 4 )

            print( 'started shaptest camPos=', camPos)
        end
    end

    if gHubCameraShapeTestHandle then

        local status, hit, hitPos, hitNormal, hitEntity = GetShapeTestResult( gHubCameraShapeTestHandle )

        if status ~= 1 --[[ Pending ]] then

            gHubCameraShapeTestLastResultPos =
                hit
                    and hitPos
                    or  nil

            gHubCameraShapeTestHandle = nil

            print('shapetest results', status, hit, hitPos, hitNormal, hitEntity)
        end
    end
    --]=]

    return true
end

local function PreEnableHubCamera()

    local pedId = PlayerPedId()

    if IsPedRunning(pedId ) then   
        ClearPedTasksImmediately( pedId )
    end
end

---@param enabled boolean
local function EnableHubCamera( enabled )

    if gHubCameraId then

        DestroyCam( gHubCameraId )

        RenderScriptCams( false, true, 250, true, true )

        TaskClearLookAt( PlayerPedId() )

        gHubCameraId = nil
        gHubCameraShapeTestHandle = nil
        gHubCameraShapeTestLastResultPos = nil
    end

    if enabled then

        PreEnableHubCamera()

        local pedId = PlayerPedId()
        local pedPos = GetEntityCoords( pedId )

        local camId = CreateCam( 'DEFAULT_SCRIPTED_CAMERA', true)

        SetCamFov( camId, 20.0 )

        ResetHubCameraPosition( camId )

        SetCamActive( camId, true )
        RenderScriptCams( true, true, 250, true, true )

        gHubCameraId = camId

        CreateThread(function()

            while UpdateHubCamera( GetFrameCount() ) do
                Wait( 0 )
            end

            EnableHubCamera( false )
        end)
    end
end

---@param heading string
---@param rows string[] | InputDialogRowProps[]
---@param options InputDialogOptionsProps[]?
---@return string[] | number[] | boolean[] | nil
function Client.inputDialog(heading, rows, options)
    local input = lib.inputDialog(heading, rows, options)
    return input
end

RegisterCommand( 'hubcam', function()
    EnableHubCamera( not gHubCameraId )
end, false)

RegisterNUICallback("changeInsta",function(Data,Callback)
    TransitionFromBlurred(0)
    SetNuiFocus(false,false)
    SendNUIMessage({
        action = 'setVisible',
        data = false
    })
    InHub = false
    Wait(250)
    ExecuteCommand("instagram")
    Callback(true)
end)

RegisterNUICallback("changeTiktok",function(Data,Callback)
    TransitionFromBlurred(0)
    SetNuiFocus(false,false)
    SendNUIMessage({
        action = 'setVisible',
        data = false
    })
    InHub = false
    Wait(250)
    ExecuteCommand("TikTok")
    Callback(true)
end)

local KEY_STATE_CITY_OFFER = 'city_offer'
local gCityOffer = Promotion[cityName]

local function AddCityOfferByState(state)
    if type(state.currencySymbol) ~= "string" or not state.currencySymbol:match("%S") or state.currencySymbol == "default" then
        local cityOffer = Promotion[cityName]
        state.currencySymbol = cityOffer and cityOffer.currencySymbol or nil
    end

    if not state.hide_timer then 
        state.timer = generateTimer()
    end
    
    gCityOffer = state
end

local function GetCityOffer()
    return gCityOffer
end

CreateThread(function()
    local stateOffer = GlobalState[KEY_STATE_CITY_OFFER]

    if not stateOffer then 
        return
    end

    AddCityOfferByState(stateOffer)
end)

AddStateBagChangeHandler(KEY_STATE_CITY_OFFER, 'global', function( _, _, state )
    if not (state and type(state) == 'table') then 
        return
    end

    AddCityOfferByState(state)
end)

function OpenHub(openMissions, rankingTarget, storeCategoryName)
    SendNUIMessage({ action = "setVoicePreferencesEnabled", data = sx.featureflags.enableVoicePreferences() })

    if LocalPlayer.state['matchcity:house'] == true then return end

    print("function OpenHub", gMicSetupStarted)

    if not LocalPlayer["state"]["Active"] then
        print("function OpenHub1", gMicSetupStarted)
        return
    end

    if LocalPlayer["state"]["Cancel"] then
        print("function OpenHub2", gMicSetupStarted)
        return
    end

    if gMicSetupStarted then
        print("function OpenHub3", gMicSetupStarted)
        return
    end

    if IsPvpChallengeBetConfirmOpen() then
        return
    end

    if exports.gamemaster:IsInGamemasterMode() then
        print("function OpenHub4", gMicSetupStarted)
        return
    end

    if LocalPlayer['state']['snowball:match'] then
        print("function OpenHub5", gMicSetupStarted)
        return
    end

    if LocalPlayer["state"]["minigame:active"] then
        print("function OpenHub6", gMicSetupStarted)
        return
    end

	if not Pause and ( not IsPauseMenuActive() or GetPauseMenuState() == 30 --[[ PM_SHUTTING_DOWN ]] ) then

    print("function OpenHub7", gMicSetupStarted)
        TriggerEvent("chat:DisablePreview",true)
        if IsMinimapRendering() then
            DisplayRadar(false)
            isRadarActive = true
        end
        TriggerEvent("hud:Active",false)
        -- TransitionToBlurred(1000)
        TransitionFromBlurred(0)
        local Data = {
            passport = PlayerData["passport"],
            cityId = cityName,
            promotions = GetCityOffer(),
            -- Social Ranking screens consume RankingAPI :4040 directly from NUI.
            -- Replicated convars (setr) so the client can read them; token is sent to the client
            -- by design here (Open item #5: alternative is to front it behind a Lua proxy).
            rankingApiUrl = GetConvar( 'ranking_api_url', '' ),
            rankingApiToken = GetConvar( 'ranking_api_token', '' ),
            rankingTarget = rankingTarget,
            storeCategoryName = storeCategoryName,
        }
        print("[DEBUG] Pause command, sending data to NUI", json.encode(Data))
        if openMissions then
            Data.taskId = openMissions
            SendNUIMessage({
                action = 'openMissions',
                data = Data
            })
        else
            SendNUIMessage({
                action = 'Open',
                data = Data
            })

            SendNUIMessage({
                action = "setNavbarPagesVisibility",
                data = GetDisabledHubPages()
            })
        end

        SetNuiFocus(true,true)
        TriggerEvent('hud:jobsDiscovery:hubOpened')
        TriggerEvent('hub:visibilityChanged', true)
        TriggerEvent("missions:welcomeCityNotify:close")
        if storeCategoryName then
            return true
        end
        if LocalPlayer["state"]["playerPromotion"] then
            if PromotionFirstOpen then
                PromotionFirstOpen = false
                local productId = LocalPlayer["state"]["playerPromotion"]
                local promotion = GetPromotionByProductId(productId)
                if promotion then
                    if not exports.tutorial:CanStartUiTutorial('tutorial.ui.hub') then
                        print("function OpenHub7", gMicSetupStarted)
                        return
                    end
                    if gStateMicTutorialStarted or gMicSetupStarted then
                        return
                    end
                    if PromotionCountdown and PromotionCountdown > 0 then
                        SendNUIMessage({
                            action = "startPromotionModal",
                            data =  {
                                productId = productId,
                                image = promotion.background,
                                background = promotion.background,
                                background_color = promotion.background_color,
                                countDown = PromotionCountdown,
                                itens = promotion.itens,
                                description = promotion.description,
                                link = TebexStoreLink[cityName].."/package/"..productId,
                                price = promotion.price,
                                canCancel = true,
                            }
                        })
                    else
                        SendNUIMessage({
                            action = "openWhatsAppInvite",
                            data = {
                                url = WhatsAppGroups[cityName]
                            }
                        })
                    end
                else
                    SendNUIMessage({
                        action = "openWhatsAppInvite",
                        data = {
                            url = WhatsAppGroups[cityName]
                        }
                    })
                end
            else
                local productId = LocalPlayer["state"]["playerPromotion"]
                local promotion = GetPromotionByProductId(productId)
                if promotion then
                    if not exports.tutorial:CanStartUiTutorial('tutorial.ui.hub') then
                        return
                    end
                    if PromotionCountdown and PromotionCountdown > 0 then
                        SendNUIMessage({
                            action = "openPromotionCountDown",
                            data =  {
                                image = promotion.background,
                                countDown = PromotionCountdown,
                                background_color = promotion.background_color,
                                timerStatus = PromotionTimerStatus
                            }
                        })
                    else
                        SendNUIMessage({
                            action = "openWhatsAppInvite",
                            data = {
                                url = WhatsAppGroups[cityName]
                            }
                        })
                    end
                else
                    SendNUIMessage({
                        action = "openWhatsAppInvite",
                        data = {
                            url = WhatsAppGroups[cityName]
                        }
                    })
                end
            end
        else
            SendNUIMessage({
                action = "openWhatsAppInvite",
                data = {
                    url = WhatsAppGroups[cityName]
                }
            })
        end
        --EnableHubCamera( true )
	end
end

exports("OpenVipStore", function()
    return OpenHub(nil, nil, "vip") == true
end)

local function CloseHub(skipMicSetup)
    CloseTutorial()
    --assert( InHub, 'Hub is not active' )

    TriggerEvent("hud:markHubEscSeen")

    if (IsScreenFadedOut()) then
        DoScreenFadeIn(500)
    end

    TransitionFromBlurred(0)

    SetNuiFocus(false,false)

    SendNUIMessage({
        action = 'setVisible',
        data = false
    })

    TriggerEvent('hud:syncConfig')

    exports['radialmenu']:closeProfile()

    print("[DEBUG] CloseHub")
    --EnableHubCamera( false )

    -- InHub = false

    WeaponView.cleanup()
    LeaveCursorMode()

    SetNuiFocus(false, false)
    TriggerEvent("chat:DisablePreview",false)

    if isRadarActive then
        DisplayRadar(true)
        isRadarActive = false
    end

    if gOpenMicSetup and not skipMicSetup and not sx.featureflags.enableVoicePreferences() then
        StartMicSetup()
        gOpenMicSetup = false
    end
    Wait(250)
    TriggerEvent("hud:Active", true)
    TriggerEvent('hub:visibilityChanged', false)
end

RegisterNetEvent('hub:close', function()
    print("[DEBUG] hub:close")
    CloseHub()
end)

AddEventHandler( "ui:exclusiveModalOpened", function()
    CloseHub( true )
end )

-- Deep-link from the plaza podium interact: open the Hub straight on the Social Ranking route.
RegisterNetEvent('hub:OpenRanking', function(data)
    OpenHub(nil, data or {})
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMAND
-----------------------------------------------------------------------------------------------------------------------------------------
---
RegisterCommand("Pause",function()
    if LocalPlayer.state['matchcity:house'] == true then return end
    -- if CanShowDetailedHubTutorial() then
        -- return StartHubTutorial()
    -- end
    if LocalPlayer["state"]["Creating"] then
        return
    end
    if LocalPlayer["state"]["FirstLogin"] then
        return
    end
    -- end
    if LocalPlayer["state"]["newHubTutorial"] then
        return
    end
    if gStateMicTutorialStarted then
        return
    end

    if exports.hud:isActiveEventNotify() then
        TriggerEvent("hud:hideEventNotify")
    end

    StartHubTutorial()
    OpenHub()
end)

-- RegisterCommand("openMap",function()
--     TriggerEvent("hud:inMap")
--     ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_MP_PAUSE"),0,-1)
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("Pause", _t("settings"), "keyboard", "Escape")
RegisterKeyMapping("openMap", _t("settings"), "keyboard", "P")
RegisterKeyMapping("BattlePass", _t("battlePass"), "keyboard", "F4")

CreateThread(function()
    while true do
        Wait(0)
        DisableControlAction(0, 200, true)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CALLBACKS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("openConfig",function(Data,Callback)

    CloseHub()

    ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_LANDING_MENU"),0,-1)

    TriggerEvent("hud:inMap")

    Callback(true)
end)

RegisterNUICallback("help",function(Data,Callback)
    if gStateMicTutorialStarted then
        return Callback(false)
    end

    CloseHub()

    ExecuteCommand("calladm")

    Callback(true)
end)

RegisterNUICallback("openMap",function(Data,Callback)
    if gStateMicTutorialStarted then
        return Callback(false)
    end

    print("[DEBUG] openMap")

    CloseHub()

    ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_MP_PAUSE"),0,-1)

    TriggerEvent("hud:inMap")

    
    Callback(true)
    Citizen.Wait(400)
    TriggerEvent("hud:Active",false)
end)

RegisterNUICallback("openMinigames",function(Data,Callback)

    CloseHub()

    TriggerServerEvent("pvp.server:openPanel", "hub")

    Callback(true)
end)

local DELAY_TO_EXECUTE_COMMAND_WORLD_AFFILIATE_MS = 200

RegisterNUICallback("afiliadoGoToWorld", function(Data, Callback)
    local sessionType = type(Data) == "table" and Data.sessionType or nil

    if sessionType ~= "individual" and sessionType ~= "public" then
        Callback(false)
        return
    end

    CloseHub(true)
    Callback(true)

    SetTimeout(DELAY_TO_EXECUTE_COMMAND_WORLD_AFFILIATE_MS, function()
        ExecuteCommand(("%s %s %s"):format(_t("command.world"), _t("AFILIADO"), sessionType))
    end)
end)

local function OpenAffiliateWorldEntry()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "openAfiliadoEntry", data = { cityId = GetConvar("cityName", "") } })
end

RegisterNetEvent("new_hub:openAfiliadoEntry", OpenAffiliateWorldEntry)
RegisterCommandLocalized("command.store", OpenAffiliateWorldEntry)

RegisterNUICallback("afiliadoCloseEntry", function(_, Callback)
    SetNuiFocus(false, false)
    Callback(true)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SPLITSTRING
-----------------------------------------------------------------------------------------------------------------------------------------
function splitString(Full,Symbol)
	local Table = {}

	if not Symbol then
		Symbol = "-"
	end

    if not Full then
        return Table
    end

	for Full in string.gmatch(Full,"([^"..Symbol.."]+)") do
		Table[#Table + 1] = Full
	end

	return Table
end

RegisterNUICallback("goEvent",function(Data,Callback)
    local Coords = splitString(Data.coords,",")
    Coords = vec3(tonumber(Coords[1]),tonumber(Coords[2]),tonumber(Coords[3]))
    local Ped = PlayerPedId()

    CloseHub()

    DoScreenFadeOut(2500)
    while not IsScreenFadedOut() do 
        Wait(5) 
    end
    SetEntityCoords(Ped,Coords.x,Coords.y,Coords.z-1,false,false,false,false)
    FreezeEntityPosition(Ped,true)
    RequestCollisionAtCoord(Coords.x,Coords.y,Coords.z)
    while not HasCollisionLoadedAroundEntity(Ped) do
        Wait(1)
    end

    FreezeEntityPosition(Ped,false)
    DoScreenFadeIn(5000)
    while not IsScreenFadedIn() do
        Wait(5)
    end


    ExecuteCommand("mundo Evento")
    Callback(true)
end)


-- RegisterNUICallback("openBuySkin",function(Data,Callback)
--     print("openBuySkin",json.encode(Data, {indent = true}))
--     CloseHub()

--     ExecuteCommand("skins")

--     Callback(true)
-- end)

RegisterNUICallback("help",function(Data,Callback)
    if gStateMicTutorialStarted then
        return Callback(false)
    end

    CloseHub()

    Wait(250)

    ExecuteCommand("createNewCall")

    Callback(true)
end)


RegisterNUICallback("getPromotions",function(Data,Callback)
    Callback(GetCityOffer())
end)

RegisterNUICallback("openPromotion",function(Data,Callback)
    print("openPromotion",json.encode(Data))
    TriggerEvent("player:OpenURL",Data.link)
    Callback(true)
end)

RegisterNUICallback("openPanel",function(Data,Callback)
    if gStateMicTutorialStarted then
        return Callback(false)
    end

    CloseHub()

    if not vSERVER.hasJob() then
        TriggerEvent("hud:Active",true)
        --TriggerEvent("Notify","vermelho","Você ainda não está em nenhuma organização, entre em uma para abrir o painel.",10000,"PAINEL")
        TriggerEvent("Notify2","#semOrg")
    end
    ExecuteCommand(_t("panel"))
    Callback(true)
end)

RegisterNUICallback('getServerHost', function(Data, Callback)
    local api_url = GetConvar("api_url", "")
    print("[DEBUG] - GET SERVER HOST, api_url: " .. api_url)
    Callback(api_url)
end)

RegisterNUICallback('getHomeInfo', function(data, callback)
    local passport = (PlayerData and PlayerData["passport"]) or 1
    local name = (PlayerData and PlayerData["name"]) or "Cidadão"
    local name2 = (PlayerData and PlayerData["name2"]) or ""
    local job = (PlayerData and PlayerData["job"]) or "Desempregado"
    local phone = (PlayerData and PlayerData["phone"]) or "Nenhum"

    local homeInfo = {
        playerInfo = {
            passport = passport,
            customPassport = passport,
            name = name,
            name2 = name2,
            job = job,
            avatar = "https://avatar.vercel.sh/avatar.png",
            phone = phone,
            country_code = "br",
            relationship = "Solteiro",
            description = "",
            timePlayed = "1h",
            gems = 0,
            coins = 0,
            like = 0,
            score = 0,
            createdAt = "",
            partner = { name = "", avatar = "", passport = 0 },
            groups = {}
        },
        serverInfo = {
            police = 0,
            med = 0,
            mechanic = 0,
            players = #GetActivePlayers()
        },
        news = vSERVER.getNews and vSERVER.getNews() or {},
        events = {},
        lastStoreTransactions = {}
    }
    callback(homeInfo)
end)

RegisterNUICallback('get-home-info', function(data, callback)
    local passport = (PlayerData and PlayerData["passport"]) or 1
    local name = (PlayerData and PlayerData["name"]) or "Cidadão"
    local name2 = (PlayerData and PlayerData["name2"]) or ""
    local job = (PlayerData and PlayerData["job"]) or "Desempregado"
    local phone = (PlayerData and PlayerData["phone"]) or "Nenhum"

    local homeInfo = {
        playerInfo = {
            passport = passport,
            customPassport = passport,
            name = name,
            name2 = name2,
            job = job,
            avatar = "https://avatar.vercel.sh/avatar.png",
            phone = phone,
            country_code = "br",
            relationship = "Solteiro",
            description = "",
            timePlayed = "1h",
            gems = 0,
            coins = 0,
            like = 0,
            score = 0,
            createdAt = "",
            partner = { name = "", avatar = "", passport = 0 },
            groups = {}
        },
        serverInfo = {
            police = 0,
            med = 0,
            mechanic = 0,
            players = #GetActivePlayers()
        },
        news = vSERVER.getNews and vSERVER.getNews() or {},
        events = {},
        lastStoreTransactions = {}
    }
    callback(homeInfo)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)

    print('Close', gStateMicTutorialStarted)
    if gStateMicTutorialStarted then
        print('bloqueando close por causa do mic tutorial')
        return Callback(false)
    end
    
    CloseHub()
    
    TriggerEvent("hud:Active",true)

    Callback(true)
end)

RegisterNUICallback("openStore",function(Data,Callback)
    TriggerEvent("player:OpenURL",StoreLink[cityName])
    Callback(true)
end)

RegisterNUICallback("addBlur",function(Data,Callback)
    TransitionToBlurred(0)
    Callback(true)
end)

RegisterNUICallback("buyDiamonds",function(Data,Callback)
    local url = DiamondLink[cityName]
    if url and url ~= "" then
        TriggerEvent("player:OpenURL",url)
    else
        TriggerEvent("player:OpenURL",StoreLink[cityName])
    end
    Callback(true)
end)


RegisterNetEvent("playerData")
AddEventHandler("playerData",function(Data)
    if type(FormatPlayerData) == "function" then
        PlayerData = FormatPlayerData(Data)
    else
        PlayerData = Data or PlayerData or {}
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        PlayerData = vRP.GetPlayerData()
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEWS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("sendNews",function(Data,Callback)
    local Success = vSERVER.AddNews(Data.message)
    Callback(Success)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEWS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hub:Notify")
AddEventHandler("hub:Notify", function(Table)
    SendNUIMessage({
        action = 'Notify',
        data = Table
    })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPEN PLAYER PERFIL
-----------------------------------------------------------------------------------------------------------------------------------------
local lastSelected = nil
RegisterNetEvent('hub:openPlayerPerfil', function(Data, isRadialMenu)
    local Passport = Player(Data).state.Passport
    print("hub:openPlayerPerfil",json.encode(Data),Passport)
    
    SendNUIMessage({
        action = 'setVisible',
        data = true
    })
    Wait(100)
    SendNUIMessage({
        action = 'openPerfil',
        data = {
            passport = Passport,
            cityId = cityName
        }
    })
    lastSelected = Data

    if (not isRadialMenu) then
        print("[DEBUG] SetNuiFocus(true,true) - isRadialMenu")
        SetNuiFocus(true,true)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST PHONE
-----------------------------------------------------------------------------------------------------------------------------------------
local requestInformationsCooldown = GetGameTimer()
RegisterNUICallback("requestPhone",function(Data,Callback)
    local Cooldown = requestInformationsCooldown - GetGameTimer()
    if Cooldown > 0 then
        TriggerEvent("Notify2","#cooldownRequests",{msg = Cooldown / 1000 })
        return
    end
    requestInformationsCooldown = GetGameTimer() + 2500
    local Success = vSERVER.RequestPhone(Data)
    Callback(Success)
end)

RegisterNUICallback("requestGroup",function(Data,Callback)
    local Cooldown = requestInformationsCooldown - GetGameTimer()
    if Cooldown > 0 then
        TriggerEvent("Notify2","#cooldownRequests",{msg = Cooldown / 1000 })
        return
    end
    requestInformationsCooldown = GetGameTimer() + 2500
    local Success = vSERVER.RequestGroup(Data)
    Callback(Success)
end)

RegisterNUICallback("createEvent",function(Data,Callback)
    local Success = vSERVER.CreateEvent(Data.name,Data.icon,Data.coordinates,Data.time,Data.date)
    Callback(Success)
end)


RegisterNUICallback("savePerfil",function(Data,Callback)
    print('savePerfil')
    print(json.encode(Data))
    local Success = vSERVER.SaveInfos(Data.tiktok or "",Data.instagram or "",Data.description or "")
    Callback(Success)
end)

RegisterCommand("teste",function()
    local Source = GetPlayerServerId(PlayerId())
    TriggerEvent("hub:openPlayerPerfil",Source)
end)

RegisterNUICallback("openInstagram",function(instagramUser,Callback)
    TriggerEvent("player:OpenURL","https://www.instagram.com/"..instagramUser)
end)

RegisterNUICallback("openTikTok",function(tiktokUser,Callback)
    TriggerEvent("player:OpenURL","https://www.tiktok.com/@"..tiktokUser)
end)

RegisterNUICallback("sendRelationship",function(Data,Callback)
    TriggerServerEvent("player:Relationship",lastSelected)
    Callback(true)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- GET OFFERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("getOffers",function(Data,Callback)
    local exclusiveLink = GlobalState["exclusive_link"] or {}
    local Offers = {
        ["flashOffer"] = GlobalState["flash_offer"] or {},
        ["monthlyVip"] = GlobalState["monthly_vip"] or {},
        ["exclusiveLink"] = GlobalState["exclusive_link"] or {},
    }
    print("getOffers",json.encode(Offers, {indent = true}))
    Callback(Offers)
end)

RegisterNUICallback("getRelationship",function(Data,Callback)
    Callback(vSERVER.GetRelationship())
end)

RegisterNUICallback("breakRelationship",function(Data,Callback)
    local Success = vSERVER.BreakRelationShip(Data)
    Callback(Success)
end)

RegisterNUICallback("requestRelationship",function(Data,Callback)
    local Success = vSERVER.UpdateRelationShip(Data)
    Callback(Success)
end)

--[=[
local function VoiceSettingsInputToggleOnOff()

    -- Forçar input para desabilitar/habilitar o botão do voip

    BeginScaleformMovieMethodOnFrontend( 'SET_INPUT_EVENT' )
    ScaleformMovieMethodAddParamInt( 11 --[[ PAD_DPADRIGHT ]])
    EndScaleformMovieMethod()
end
--]=]

---@enum eGotoVoiceSettingsState
local eGotoVoiceSettingsState =
{
    START                   = 0,
    WAIT_FRONTEND           = 1,
    WAIT_INPUT_EVENT        = 2,
    WAIT_MENU_SHIFT_DEPTH   = 3,
    IDLE                    = 4,
    CLEANUP                 = 5,
}

---@class GotoVoiceSettingsFSMContext
---@field private state             eGotoVoiceSettingsState
---@field private stateChangedAt    number
---@field public  getState          fun( self ): eGotoVoiceSettingsState
---@field public  setState          fun( self, newState: eGotoVoiceSettingsState )

local NUM_MILLISECONDS_AFTER_LAYOUT_EVENT_UPDATE = 200
local NUM_MILLISECONDS_AFTER_INPUT_EVENT_UPDATE = 200

local once = true

---@param ctx GotoVoiceSettingsFSMContext
---@return boolean keepRunning
local function UpdateGotoVoiceSettingsFSM( ctx )

    -- Esconder o menu do game enquanto não estivermos no estado desejado ( página de configuração de voz )
    if ctx:getState() ~= eGotoVoiceSettingsState.IDLE then

        -- SUPPRESS_FRONTEND_RENDERING_THIS_FRAME
        N_0xba751764f0821256()
    end

    -- HasMenuTriggerEventOccurred
    -- local hasMenuTriggerEventOccurredThisFrame =  ( N_0xf284ac67940c6812() == 1 and GetPauseMenuSelection() ) ~= nil

    -- HasMenuLayoutChangedEventOccurred
    -- local hasMenuLayoutChangedEventOccurred = ( N_0x2e22fefa0100275e() == 1 and GetPauseMenuSelectionData() ) ~= nil

    if      ctx:getState() == eGotoVoiceSettingsState.START then
        -- Inicializar o menu do game

        ActivateFrontendMenu( `FE_MENU_VERSION_LANDING_MENU`, false, -1 )

        ctx:setState( eGotoVoiceSettingsState.WAIT_FRONTEND )

    elseif  ctx:getState() == eGotoVoiceSettingsState.WAIT_FRONTEND then

        if not IsPauseMenuActive() then
            return true -- Continue
        end

        if GetGameTimer() - ctx.stateChangedAt < NUM_MILLISECONDS_AFTER_LAYOUT_EVENT_UPDATE then
            return true -- Continue
        end

        -- TakeControlOfFrontend()

        ctx:setState( eGotoVoiceSettingsState.WAIT_INPUT_EVENT )

    elseif  ctx:getState() == eGotoVoiceSettingsState.WAIT_INPUT_EVENT then

        if GetGameTimer() - ctx.stateChangedAt < NUM_MILLISECONDS_AFTER_INPUT_EVENT_UPDATE then
            return true -- Continue
        end

        -- Focar "Rockstar Editor"
        BeginScaleformMovieMethodOnFrontend( 'SET_INPUT_EVENT' )
            ScaleformMovieMethodAddParamInt( 8 --[[ SCALEFORM_INPUT_EVENT_UP ]] )
        EndScaleformMovieMethodReturnValue()

        -- Focar "Voice Chat"
        BeginScaleformMovieMethodOnFrontend( 'SET_INPUT_EVENT' )
            ScaleformMovieMethodAddParamInt( 8 --[[ SCALEFORM_INPUT_EVENT_UP ]] )
        EndScaleformMovieMethodReturnValue()

        ctx:setState( eGotoVoiceSettingsState.WAIT_MENU_SHIFT_DEPTH )

    elseif  ctx:getState() == eGotoVoiceSettingsState.WAIT_MENU_SHIFT_DEPTH then

        if GetGameTimer() - ctx.stateChangedAt < NUM_MILLISECONDS_AFTER_INPUT_EVENT_UPDATE then
            return true -- Continue
        end

        -- Focar "Voice Chat" -> "Voice Chat Enabled"
        BeginScaleformMovieMethodOnFrontend( 'MENU_SHIFT_DEPTH' )
            ScaleformMovieMethodAddParamInt( 1 )
        EndScaleformMovieMethod()

        ctx:setState( eGotoVoiceSettingsState.IDLE )

    elseif  ctx:getState() == eGotoVoiceSettingsState.IDLE then

        if
                not IsPauseMenuActive()
            or  IsControlJustPressed( 0, 202 --[[ INPUT_FRONTEND_CANCEL ]] )
        then

            ctx:setState( eGotoVoiceSettingsState.CLEANUP )
        end

    elseif  ctx:getState() == eGotoVoiceSettingsState.CLEANUP then

        ReleaseControlOfFrontend()

        SetFrontendActive( false )

        return false -- Bail
    end

    return true -- Continua
end

---@class GotoVoiceSettingsOptions
---@field public onTerminated fun()

---@param opts? GotoVoiceSettingsOptions
local function GotoVoiceSettings( opts )

    ---@type GotoVoiceSettingsFSMContext
    local ctx =
    {
        state               = 0,
        stateChangedAt      = 0,

        getState = function( self )
            return self.state
        end,

        setState = function( self, newState )

            self.state  = newState
            self.stateChangedAt = GetGameTimer()
        end
    }

    CreateThread(
        function()

            while UpdateGotoVoiceSettingsFSM( ctx ) do

                Wait( 0 )
            end

            if opts then

                opts.onTerminated()
            end
        end
    )
end

RegisterNUICallback( 'getVoicePreferencesEnabled', function( _, cb )
    local enabled = false
    if sx and sx.featureflags and sx.featureflags.enableVoicePreferences then
        enabled = sx.featureflags.enableVoicePreferences()
    end
    cb( enabled )
end )

RegisterNUICallback( 'openMic', function( data, cb )

    if sx and sx.featureflags and sx.featureflags.enableVoicePreferences and sx.featureflags.enableVoicePreferences() then
        cb({ ok = false })
        return
    end

    CloseHub(true)
    CloseTutorial()

    GotoVoiceSettings({
        onTerminated = function()
            if gStateMicTutorialStarted then
                StartMicSetup()
            end
        end
    })

    cb({ ok = true })
end)

exports('IsResourceFocusedUi', function()
    return IsNuiFocused()
end)
--[=[

RegisterCommand('newhub:debug_voice', function()
    GotoVoiceSettings()
end, false )

RegisterCommand('newhub:debug_hasvoip', function()
    print('hasvoip', GetProfileSetting( 302 --[[ AUDIO_VOICE_OUTPUT ]]) )
end, false )

--]=]

RegisterNUICallback("getCityName",function(Data,Callback)
    cityName = GetConvar("cityName", "")
    Callback(string.lower(cityName))
end)

RegisterNUICallback( 'CAN_VIPMODAL', function( data, callback )
    local cityName = GetConvar( 'cityName', '' )
    if exports.tutorial:CanStartUiTutorial('tutorial.ui.hub') then
        return callback({ canOpen = false })
    end

    --[[ 
        NOTE: isForced: quando o usuario forçar 
        a abertura do modal clicando no botão de VIP.
        
        - @TkzDev
    ]]
    
    local response = { 
        canOpen = data?.isForced or false
    }

    local offerConfig = GetOfferVipModal(vSERVER.GetOsTime() --[[data.brazilTimestamp / 1000]]) 

    assert( offerConfig, ('offerVipModal not found for city: %s'):format( cityName ) )

    --[[ 
        NOTE: caso for o dia 7 ou depois de cada mes, 
        e o modal ainda nao foi aberto nesse mes, abrir o modal 
        
        - @TkzDev
    ]]

    local year, month, day = GetLocalTime()
    local currentMonthKey = ('%d-%02d'):format( year, month )

    local KEY = ('new_hub:offer_vip_modal_opened_%s_%s'):format( cityName, offerConfig.videoSrc )

    local savedMonthKey = GetResourceKvpString( KEY )
    
    -- Show modal on day 7 or later if it hasn't been shown this month yet
    if day >= 7 and savedMonthKey ~= currentMonthKey then
        SetResourceKvp( KEY, currentMonthKey )
        response.canOpen = true
    end
    
    -- Save the date when modal is forced open, so it won't show again automatically this month
    if data?.isForced and savedMonthKey ~= currentMonthKey then
        SetResourceKvp( KEY, currentMonthKey )
    end

    response.config = offerConfig

    callback( response )
end)

RegisterNUICallback( 'promotionalUrlOpened' , function( data, cb )
    TriggerServerEvent('net.hud.url_opened', data.url)
end)

SetNuiZindex(99999)
local customConfigs = {}
RegisterNUICallback("getCustomConfigs",function(Data,Callback)
    Callback(customConfigs[cityName] or {})
end)


-- show ESC help action
