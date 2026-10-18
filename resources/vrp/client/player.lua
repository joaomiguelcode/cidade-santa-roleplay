-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local FPS = {}
LocalPlayer["state"]["Name"] = ""
LocalPlayer["state"]["Active"] = false
cityName = GetConvar("cityName", "")
cityDiscord = GetConvar("cityDiscord", "")
PlayerData = {}
PlayerGroups = {
    passport = "",
    name = "",
    name2 = "",
    groups = {}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.SetHealth(Health)
	local Ped = PlayerPedId()
	SetEntityHealth(Ped,Health)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.updateHealth(Number)
	local Ped = PlayerPedId()
	local Health = GetEntityHealth(Ped)
	if Health > 100 then
		SetEntityHealth(Ped,Health + Number)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOWNHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.downHealth(Number)
	local Ped = PlayerPedId()
	local Health = GetEntityHealth(Ped)

	SetEntityHealth(Ped,Health - Number)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYINGANIM
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.PlayingAnim(Dict,Name)
	return IsEntityPlayingAnim(PlayerPedId(),Dict,Name,3)
end

---@param model string
function tvRP.Skin( model )

	-- ponytail: debug temporário CTD DecibelSpawn (ver new_spawn/client/native_debug.lua); remover quando identificado
	local nsdbgCity = GetConvar( 'cityName', '' )
	local nsdbg = ( nsdbgCity == 'Fronteira' or nsdbgCity == 'Krown' ) and GetConvar( 'newspawn_debug', '1' ) ~= '0'
	local function dbg( msg, ... )
		if nsdbg then sx.logger:debug( ('[nsdbg] tvRP.Skin: ' .. msg):format( ... ) ) end
	end

	dbg( 'inicio model=%s ped=%s', tostring( model ), PlayerPedId() )

	local defaultModel = 'mp_m_freemode_01'

	if not IsModelValid( model ) then
        sx.logger:debug( ('Model is invalid, setting to default --> %s'):format( defaultModel ) )

        model = defaultModel
    end

	if LoadModel( model ) then

		local playerId = PlayerId( )

		while not HasModelLoaded( model ) do
			RequestModel( model )
			Wait(100)
		end
		dbg( 'model carregado' )

		while not HasCollisionLoadedAroundEntity( PlayerPedId() ) do
			Wait(100)
		end
		dbg( 'collision ok ped=%s', PlayerPedId() )

		while IsPlayerSwitchInProgress() do
			Wait(100)
		end
		dbg( 'switch ok' )

		Wait(500)

		dbg( 'SetPlayerModel pedBefore=%s', PlayerPedId() )
		SetPlayerModel( playerId, model )
		dbg( 'SetPlayerModel pedAfter=%s', PlayerPedId() )

		local pedId = PlayerPedId( )
		local pedModel = GetEntityModel( pedId )
		local isFreemodePed = pedModel == GetHashKey( 'mp_m_freemode_01' )
			or pedModel == GetHashKey( 'mp_f_freemode_01' )

		if isFreemodePed then
			SetPedComponentVariation( pedId, 5, 0, 0, 1 )
		else
			SetPedDefaultComponentVariation( pedId )
		end

		SetModelAsNoLongerNeeded( model )

		dbg( 'ReloadCharacter inicio ped=%s', pedId )
		ReloadCharacter( playerId, pedId )
		dbg( 'ReloadCharacter fim' )
	else
		dbg( 'LoadModel falhou model=%s', tostring( model ) )
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:ACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
local CitysDiscord = {
    ["Santa"] = {
        ["Discord"] = "https://discord.gg/cidadesanta",
        ["Connect"] = "fivem://connect/santa.santagroup.gg",
        ["DiscordID"] = 1413603711061590158,
    },
	["Grande"] = {
        ["Discord"] = "https://discord.gg/granderp",
        ["Connect"] = "fivem://connect/jogar.cidadegrande.com",
        ["DiscordID"] = 1402709445653430433,
    },
	["Galaxy"] = {
        ["Discord"] = "https://discord.gg/galaxy-rp",
        ["Connect"] = "fivem://connect/galaxy.santagroup.gg",
        ["DiscordID"] = 1027851881298530325,
    },
	["Universo"] = {
        ["Discord"] = "https://discord.gg/universorp",
        ["Connect"] = "fivem://connect/universo.santagroup.gg",
        ["DiscordID"] = 1208904165246640201,
    },
	["Gaules"] = {
        ["Discord"] = "https://discord.gg/",
        ["Connect"] = "fivem://connect/gaules.santagroup.gg",
        ["DiscordID"] = 1155907056931455066,
    },
	["Fronteira"] = {
        ["Discord"] = "https://discord.gg/fronteirarp",
        ["Connect"] = "fivem://connect/cidadefronteira.fronteirarp.com.br",
        ["DiscordID"] = 1172600186569240656,
    },
	["CidadeNobre"] = {
        ["Discord"] = "https://discord.gg/cidadenobre",
        ["Connect"] = "fivem://connect/jogar.cidadenobre.com",
        ["DiscordID"] = 836178926341980170,
    },
	["Boomerang"] = {
        ["Discord"] = "https://discord.gg/boomerang-rp",
        ["Connect"] = "fivem://connect/play.boomerangrp.com",
        ["DiscordID"] = 1413603383625125898,
    },
	["Malta"] = {
        ["Discord"] = "https://discord.gg/malta-rp",
        ["Connect"] = "fivem://connect/jogarmalta.roleplayrp.com",
        ["DiscordID"] = 1346572347607482398,
    },
	["Kingdom"] = {
        ["Discord"] = "https://discord.gg/kngestate",
        ["Connect"] = "fivem://connect/play.kngestate.com",
        ["DiscordID"] = 1309202235527532605,
    },
	["Imperium"] = {
        ["Discord"] = "https://discord.gg/imperium",
        ["Connect"] = "fivem://connect/play.imperium.com",
        ["DiscordID"] = 1413603383625125898,
    },
	["GoatRP"] = {
        ["Discord"] = "https://discord.gg/goatrp",
        ["Connect"] = "fivem://connect/jouer.goatrp.gg",
        ["DiscordID"] = 1486845934536101988,
    },
	["District99"] = {
        ["Discord"] = "https://discord.gg/d-99",
        ["Connect"] = "fivem://connect/play.district99rp.com",
        ["DiscordID"] = 1444027268673437716,
    },
	["Krown"] = {
        ["Discord"] = "https://discord.gg/krownrp",
        ["Connect"] = "fivem://connect/play.krownrp.com",
        ["DiscordID"] = 1521957514898575532,
    },
	["Orizon"] = {
        ["Discord"] = "https://discord.gg/taaGvEtbMv",
        ["Connect"] = "fivem://connect/play.orizonrp.gg",
        ["DiscordID"] = 1507122590827806860,
    },
	["Liberty99"] = {
        ["Discord"] = "https://discord.gg/l99",
        ["Connect"] = "fivem://connect/play.liberty99rp.com",
        ["DiscordID"] = 1495832373944647900,
    },
	["Royal"] = {
        ["Discord"] = "https://discord.gg/royaluk",
        ["Connect"] = "fivem://connect/play.royalukrp.com",
        ["DiscordID"] = 1430227465044889620,
    },
	["Real"] = {
        ["Discord"] = "https://discord.gg/realrp",
        ["Connect"] = "fivem://connect/jugar.realrp.es",
        ["DiscordID"] = 1384963189514571908,
    },
	["Prime"] = {
        ["Discord"] = "https://discord.gg/ciudadprime",
        ["Connect"] = "fivem://connect/jugar.primerp.gg",
        ["DiscordID"] = 1475601370177339514,
    },
	["Alexandria"] = {
        ["Discord"] = "https://discord.gg/alexandria-rp",
        ["Connect"] = "fivem://connect/alexandria.santagroup.gg",
        ["DiscordID"] = 1413604338605232170,
    },
	["Maresia"] = {
        ["Discord"] = "https://discord.gg/cidademaresia",
        ["Connect"] = "fivem://connect/maresia.santagroup.gg",
        ["DiscordID"] = 1413607194477203486,
    }
}
RegisterNetEvent("vRP:Active")
AddEventHandler("vRP:Active",function(Passport,Name)
    NetworkEndTutorialSession()
	TriggerEvent("hud:Passport",Passport)
	LocalPlayer["state"]["Passport"] = Passport
	LocalPlayer["state"]["Name"] = Name
	LocalPlayer["state"]["Active"] = true
	LocalPlayer["state"]["Invincible"] = true
    LocalPlayer["state"]["Loading"] = false

	CreateThread(function()
		while true do
			local Count = GetFrameCount()
			Wait(1000)
			local fps = GetFrameCount() - Count
			setFPS(fps)
		end
	end)

    ClearAmbientZoneState("collision_ybmrar", false)
    SetAmbientZoneState("collision_ybmrar", false, false)

	SetDiscordAppId(CitysDiscord[cityName]["DiscordID"])
	SetDiscordRichPresenceAsset("santagroup")
	SetRichPresence("#"..Passport.." "..Name)
	SetDiscordRichPresenceAssetSmall("santagroup")
    SetDiscordRichPresenceAssetText(_t("City").." "..cityName)
    SetDiscordRichPresenceAssetSmallText(cityWarning)
    SetDiscordRichPresenceAction(0, _t("EnterDiscord"), CitysDiscord[cityName]["Discord"])
    SetDiscordRichPresenceAction(1, _t("ConnectCity"), CitysDiscord[cityName]["Connect"])

	local Pid = PlayerId()
	local Ped = PlayerPedId()

	ReloadCharacter(Pid,Ped)
	SetEntityInvincible(Ped,true)
	FreezeEntityPosition(Ped,false)
	NetworkSetFriendlyFireOption(true)
	SetCanAttackFriendly(Ped,true,false)
    local Player = PlayerId()
    SetRunSprintMultiplierForPlayer(Player,1.10)
    -- TriggerEvent("hud:Toggle", true)
	SetTimeout(10000,function()
		SetEntityInvincible(Ped,false)
		LocalPlayer["state"]["Invincible"] = false
	end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HEALTHRECHARGE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Pid = PlayerId()
		local Ped = PlayerPedId()
		if GetEntityMaxHealth(Ped) ~= 400 then
			SetEntityMaxHealth(Ped,400)
			SetPedMaxHealth(Ped,400)
		end

		if GetPlayerMaxArmour(Pid) ~= 200 then
			SetPlayerMaxArmour(Pid,200)
		end

		if GetPlayerMaxStamina(Pid) ~= 100.0 then
			SetPlayerMaxStamina(Pid,100.0)
		end
		Wait(1000)
	end
end)

CreateThread(function()
	while true do
		local Pid = PlayerId()
		local Ped = PlayerPedId()
		SetPlayerHealthRechargeMultiplier(Pid,0.0)
		SetPlayerHealthRechargeLimit(Pid,0.0)
		Wait(100)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RELOADCHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
function ReloadCharacter(Pid,Ped)
    print(cityDiscord)
    if cityDiscord and cityDiscord ~= "" then
        AddTextEntry("FE_THDR_GTAO",cityDiscord)
    end
	StopAudioScenes()
	SetMaxWantedLevel(0)
	SetRandomBoats(false)
	SetRandomTrains(false)
	SetGarbageTrucks(false)
	SetPedHelmet(Ped,false)
	SetDeepOceanScaler(0.0)
	-- SetPlayerTargetingMode( 2 )
	SetRandomEventFlag(false)
	SetPoliceRadarBlips(false)
	DistantCopCarSirens(false)
	SetWeaponsNoAutoswap(true)
	ClearPlayerWantedLevel(Pid)
	SetPoliceIgnorePlayer(Ped,true)
	SetArtificialLightsState(false)
	SetPlayerCanUseCover(Pid,false)
	SetPedSteersAroundPeds(Ped,true)
	DisableVehicleDistantlights(true)
	SetDispatchCopsForPlayer(Ped,false)
	SetAllVehicleGeneratorsActive(true)
	SetFlashLightKeepOnWhileMoving(true)
	SetPedDropsWeaponsWhenDead(Ped,false)
	SetPedCanLosePropsOnDamage(Ped,false,0)
	SetPedCanBeKnockedOffVehicle(Ped,false)
	SetPedCanRagdollFromPlayerImpact(Ped,false)

	-- SetPedConfigFlag(Ped,48,true)
	SetPedConfigFlag(Ped,33,false)
	SetPedConfigFlag(Ped,461,true)
	SetPedConfigFlag(Ped,438,true)
	SetPedConfigFlag(Ped,434,true)

	SetBlipAlpha(GetNorthRadarBlip(),0)

	local destHudColour = 116

	assert( destHudColour <= 234, 'Se esse valor for maior que 234, vai crashar os jogadores quando eles disconectarem!' )

    ReplaceHudColourWithRgba( destHudColour,THEME.rgb.r,THEME.rgb.g,THEME.rgb.b, 255)

	SetAudioFlag("DisableFlightMusic",true)
	SetAudioFlag("PoliceScannerDisabled",true)
	SetScenarioGroupEnabled("Heist_Island_Peds",true)
	SetScenarioTypeEnabled("WORLD_VEHICLE_EMPTY",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_MECHANIC",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_DRIVE_SOLO",true)
	SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_CAR",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_STREETRACE",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_BIKE",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_BUSINESSMEN",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON_DIRT_BIKE",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_BIKE_OFF_ROAD_RACE",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_NEXT_TO_CAR",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_BIG",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_SMALL",false)
	SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_01_STAGE",false)
	SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_02_MAIN_ROOM",false)
	SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_03_BACK_ROOM",false)
	SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Zones",false,true)
	SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Disabled_Zones",false,true)

	SetWeaponDamageModifierThisFrame("WEAPON_BAT",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_KATANA",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_KATANA_CENOURA",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_CENOURA",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_HAMMER",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_WRENCH",0.25)
	--SetWeaponDamageModifierThisFrame("WEAPON_UNARMED",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_HATCHET",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_CROWBAR",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_MACHETE",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_POOLCUE",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_KNUCKLE",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_KARAMBIT",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_CANDYCANE",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_GOLFCLUB",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_BATTLEAXE",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_FLASHLIGHT",0.25)
	SetWeaponDamageModifierThisFrame("WEAPON_NIGHTSTICK",0.35)
	SetWeaponDamageModifierThisFrame("WEAPON_SMOKEGRENADE",0.0)
	SetWeaponDamageModifierThisFrame("WEAPON_STONE_HATCHET",0.25)

	for Number = 0,121 do
		EnableDispatchService(Number,false)
	end
	SetPedCanRagdoll(PlayerPedId(), false)

    -- updateMapPosition()

	-- # OPTIMIZATION
	-- CPlayerGameStateDataNode envia 1bit ( boolean ) + 15bits ( bitset ) de informação
	-- caso o ped do player tenha alguma restrição de targetted por um time.
	--
	-- Então, a gente remover todas as restrições já que a gente não usa o subsistema de times do GTA.
	-- e economiza 15bits, yay
	for i = 0, 15 do

		SetPedCanBeTargettedByTeam( PlayerPedId(), i, false )
	end
	-- # OPTIMIZATION end
end

function getAverageFPS()
	local Total = 0
	for i=1,#FPS do
		Total = Total + FPS[i]
	end

	return math.floor(Total/#FPS)
end

function setFPS(fps)
	table.insert(FPS,fps)

	if #FPS > 60 then
		table.remove(FPS,1)
		-- LocalPlayer.state:set("FPS",getAverageFPS(), true) 
	end
end

-- function updateMapPosition()
--     local defaultAspectRatio = 1920/1080
--     local resolutionX, resolutionY = GetActiveScreenResolution()
--     local aspectRatio = resolutionX/resolutionY
--     local minimapXOffset,minimapYOffset = 0,0
--     if aspectRatio > defaultAspectRatio then
--         local aspectDifference = defaultAspectRatio-aspectRatio
--         minimapXOffset = aspectDifference/3.6
--     end
--     minimapXOffset = minimapXOffset + 0.008
--     minimapYOffset = minimapYOffset + 0.0
--     DisplayRadar(false)
    
--     RequestStreamedTextureDict("circleminimap",false)
--    while not HasStreamedTextureDictLoaded("circleminimap") do
--        Wait(100)
--    end
    
    -- SetMinimapClipType(1)
    -- AddReplaceTexture("platform:/textures/graphics","radarmasksm","circleminimap","radarmasksm")
    -- SetMinimapComponentPosition("minimap", "L", "B", -0.0045+minimapXOffset, 0.002+minimapYOffset-0.025, 0.150, 0.188888)
    -- SetMinimapComponentPosition("minimap_mask", "L", "B", 0.020+minimapXOffset, 0.030+minimapYOffset-0.025, 0.111, 0.159)
    -- SetMinimapComponentPosition("minimap_blur", "L", "B", -0.03+minimapXOffset, 0.022+minimapYOffset-0.025, 0.266, 0.237)
    
    -- SetBigmapActive(true,false)
    -- Wait(50)
    -- SetBigmapActive(false,false)
-- end
-- exports("updateMapPosition",updateMapPosition)

---@type number
local gBucketId = 0

---@type number
RegisterNetEvent( 'net:routing_bucket_changed', function( bucketId )

	gBucketId = bucketId
end)

---@return number
function tvRP.GetCurrentRoutingBucket()

	return gBucketId
end

RegisterNetEvent("playerData",function(Data)
    local Info = FormatPlayerData(Data)
    PlayerData["passport"] = Info["passport"]
    PlayerData["name"] = Info["name"]
    PlayerData["name2"] = Info["name2"]
    PlayerData["phone"] = Info["phone"]
    PlayerData["accountId"] = Info["accountId"]
    PlayerData["hasDiscordAccountLink"] = Info["hasDiscordAccountLink"]

	LocalPlayer.state:set( 'accountId', Info["accountId"] )

    TriggerEvent("vrp:onPlayerDataUpdated", PlayerData)
end)

RegisterNetEvent("vrp:setHasDiscordAccountLink", function(hasLink)
    PlayerData["hasDiscordAccountLink"] = hasLink and true or false
    TriggerEvent("vrp:onPlayerDataUpdated", PlayerData)
end)

---@return boolean
function tvRP.HasDiscordAccountLink()
    return PlayerData["hasDiscordAccountLink"] and true or false
end

--- Get Player Data
---@return table
function tvRP.GetPlayerData()
    local lbPhoneStatus = GetResourceState("lb-phone")
    local phoneNumber = PlayerData["phone"]
    if lbPhoneStatus ~= "missing" and lbPhoneStatus ~= "stopped" then
        phoneNumber = LocalPlayer["state"]["phoneNumber"]
        PlayerData["phone"] = phoneNumber
    end
    return PlayerData
end

---@return number | nil
function tvRP.GetPlayerAccountId()
    return PlayerData["accountId"]
end

RegisterNetEvent("playerGroups:Create",function(Data)
    if not PlayerData["groups"] then
        PlayerData["groups"] = {}
    end
    PlayerData["groups"] = Data or {}
end)

RegisterNetEvent("playerGroups:AddGroup",function(Group,Level)
    if not PlayerData["groups"] then
        PlayerData["groups"] = {}
    end
    PlayerData["groups"][Group] = Level
end)


RegisterNetEvent("playerGroups:RemoveGroup",function(Group)
    if not PlayerData["groups"] then
        PlayerData["groups"] = {}
    end
    PlayerData["groups"][Group] = nil
end)

--- Get Player Groups
---@return table
function tvRP.GetPlayerGroups()
    return PlayerData["groups"]
end

--- Get Player Job
---@return string | false, number | false, string | false, string
function tvRP.GetPlayerJob()
    if not PlayerData["groups"] then
        return false,false,false,false
    end
    local Results = false
    local Rank = false
    local Group = false
    local Hyerarchy = "Novato"
    for Permission,Level in pairs(PlayerData["groups"]) do
        if Groups[Permission]["Type"] and Groups[Permission]["Type"] == "Job" then
            Results = Permission
            Rank = Level
            Group = Permission..""..Level
            if Groups[Permission]["Hierarchy"] and Groups[Permission]["Hierarchy"][Level] then
                Hyerarchy = Groups[Permission]["Hierarchy"][Level]
            end
            
            break
        end
    end
    return Results,Rank,Group,Hyerarchy
end

---@return boolean
function tvRP.CheckIllegalGroup()
	if PlayerData["groups"] then
		for group, _ in pairs(PlayerData["groups"]) do
			if Groups["Ilegal"] and Groups["Ilegal"]["Parent"] and Groups["Ilegal"]["Parent"][group] then
				return true
			end
		end
	end
	
    return false
end
