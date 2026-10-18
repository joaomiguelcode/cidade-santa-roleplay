-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
Tunnel = module("vrp","lib/Tunnel")
Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("player",Creative)
vSERVER = Tunnel.getInterface("player")
vRPS = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Drunk = 0
local Energetic = 0
local Residuals = nil
LocalPlayer["state"]["Tea"] = 3600
LocalPlayer["state"]["Handcuff"] = false
LocalPlayer["state"]["disablePhone"] = false
LocalPlayer["state"]["Commands"] = false
local sitting = false
--- [geesy] : Entity da cadeira ao sentar (para descongelar ao levantar; evita usar variável global indefinida)
local chairSitEntity = nil
local oldCoordsSit = nil
local gChairSitOffsets = {
    ["prop_bench_06"] = vec3( 0.0, -0.1, 0.0 )
}
local cityName = GetConvar("cityName", "")
local gChairInteractionBlocklist = {
    Grande = {
        { coords = vec3(1842.91, 2583.72, 46.01), searchRadius = 3.0, model = -501934650 },
        { coords = vec3(-1727.81,-1087.39,13.01), searchRadius = 3.0, model = -403891623 },
    },
    Santa = {
        -- { coords = vec3(-1695.71, -1060.07, 13.04), searchRadius = 3.0, model = -403891623 },
    },
}

local function IsChairInteractionBlocked(entity)

    if not entity or entity == 0 or not DoesEntityExist(entity) then
        return false
    end

    local blockedLocations = gChairInteractionBlocklist[cityName]

    if not blockedLocations then
        return false
    end

    for _, location in ipairs(blockedLocations) do
        local blockedEntity = GetClosestObjectOfType(location.coords.x, location.coords.y, location.coords.z, location.searchRadius, location.model, false, false, false)

        if blockedEntity == entity then
            return true
        end
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:COMMANDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:Commands")
AddEventHandler("player:Commands",function(status)
    LocalPlayer["state"]["Commands"] = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PLAYERCARRY
-----------------------------------------------------------------------------------------------------------------------------------------
local playerCarry = false
RegisterNetEvent("player:remPlayerCarry")
AddEventHandler("player:remPlayerCarry",function()

    error( '"player:remPlayerCarry" is deprecated! use "exports[ \'sx\' ]:DetachPlayer( source )"' )

    if playerCarry then
        DetachEntity(PlayerPedId(),false,false)
        playerCarry = false
    end
end)
RegisterNetEvent("player:playerCarry")
AddEventHandler("player:playerCarry",function(entity,mode,Status)

    error( '"player:playerCarry" is deprecated! use "exports[ \'sx\' ]:AttachPlayerToPlayer( entity, source )"' )

    if not Status then
        DetachEntity(PlayerPedId(),false,false)
        playerCarry = false
    else
        if OnesyncEnableRemoteAttachmentSanitization then -- Remover validação quando essa native for para release
            OnesyncEnableRemoteAttachmentSanitization( false )
        end
        if mode == "handcuff" then
            AttachEntityToEntity(PlayerPedId(),GetPlayerPed(GetPlayerFromServerId(entity)),11816,0.0,0.5,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
        else
            AttachEntityToEntity(PlayerPedId(),GetPlayerPed(GetPlayerFromServerId(entity)),11816,0.6,0.0,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
        end
        if OnesyncEnableRemoteAttachmentSanitization then -- Remover validação quando essa native for para release
            OnesyncEnableRemoteAttachmentSanitization( true )
        end
        CreateThread(function()
            while playerCarry do
                DisableControlAction(0,245,true)
                DisableControlAction(0,309,true)
                DisableControlAction(0,1,true)
                DisableControlAction(0,2,true)
                DisableControlAction(0,24,true)
                DisableControlAction(0,257,true)
                DisableControlAction(0,25,true)
                DisableControlAction(0,263,true)
                DisableControlAction(0,32,true)
                DisableControlAction(0,34,true)
                DisableControlAction(0,31,true)
                DisableControlAction(0,30,true)
                DisableControlAction(0,45,true)
                --DisableControlAction(0,22,true)
                DisableControlAction(0,44,true)
                DisableControlAction(0,37,true)
                DisableControlAction(0,23,true)
                DisableControlAction(0,288,true)
                DisableControlAction(0,289,true)
                DisableControlAction(0,170,true)
                DisableControlAction(0,167,true)
                DisableControlAction(0,0,true)
                DisableControlAction(0,26,true)
                DisableControlAction(0,73,true)
                DisableControlAction(2,199,true)
                DisableControlAction(0,59,true)
                DisableControlAction(0,71,true)
                DisableControlAction(0,72,true)
                DisableControlAction(2,36,true)
                DisableControlAction(0,47,true)
                DisableControlAction(0,264,true)
                DisableControlAction(0,257,true)
                DisableControlAction(0,140,true)
                DisableControlAction(0,141,true)
                DisableControlAction(0,142,true)
                --DisableControlAction(0,143,true)
                DisableControlAction(0,75,true)
                DisableControlAction(27,75,true)
                DisableFirstPersonCamThisFrame()
                Wait(1)
            end
        end)
        
        playerCarry = true
    end
end)
local playerInspect = false
RegisterNetEvent("player:playerInspectCarry")
AddEventHandler("player:playerInspectCarry",function(entity,mode)

    error( '"player:playerInspectCarry" is deprecated! use "exports[ \'sx\' ]:AttachPlayerToPlayer( entity, source )"' )

    if playerInspect then
        DetachEntity(PlayerPedId(),false,false)
        playerInspect = false
    else
        if OnesyncEnableRemoteAttachmentSanitization then -- Remover validação quando essa native for para release
            OnesyncEnableRemoteAttachmentSanitization( false )
        end
        if mode == "handcuff" then
            AttachEntityToEntity(PlayerPedId(),GetPlayerPed(GetPlayerFromServerId(entity)),11816,0.0,0.5,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
        else
            AttachEntityToEntity(PlayerPedId(),GetPlayerPed(GetPlayerFromServerId(entity)),11816,0.6,0.0,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
        end
        if OnesyncEnableRemoteAttachmentSanitization then -- Remover validação quando essa native for para release
            OnesyncEnableRemoteAttachmentSanitization( true )
        end
        CreateThread(function()
            while playerInspect do
                DisableControlAction(0,245,true)
                DisableControlAction(0,309,true)
                DisableControlAction(0,1,true)
                DisableControlAction(0,2,true)
                DisableControlAction(0,24,true)
                DisableControlAction(0,257,true)
                DisableControlAction(0,25,true)
                DisableControlAction(0,263,true)
                DisableControlAction(0,32,true)
                DisableControlAction(0,34,true)
                DisableControlAction(0,31,true)
                DisableControlAction(0,30,true)
                DisableControlAction(0,45,true)
                --DisableControlAction(0,22,true)
                DisableControlAction(0,44,true)
                DisableControlAction(0,37,true)
                DisableControlAction(0,23,true)
                DisableControlAction(0,288,true)
                DisableControlAction(0,289,true)
                DisableControlAction(0,170,true)
                DisableControlAction(0,167,true)
                DisableControlAction(0,0,true)
                DisableControlAction(0,26,true)
                DisableControlAction(0,73,true)
                DisableControlAction(2,199,true)
                DisableControlAction(0,59,true)
                DisableControlAction(0,71,true)
                DisableControlAction(0,72,true)
                DisableControlAction(2,36,true)
                DisableControlAction(0,47,true)
                DisableControlAction(0,264,true)
                DisableControlAction(0,257,true)
                DisableControlAction(0,140,true)
                DisableControlAction(0,141,true)
                DisableControlAction(0,142,true)
                --DisableControlAction(0,143,true)
                DisableControlAction(0,75,true)
                DisableControlAction(27,75,true)
                DisableFirstPersonCamThisFrame()
                Wait(1)
            end
        end)
        
        playerInspect = true
    end
end)

CreateThread(function()
    while true do
        local idle = 500
        if LocalPlayer.state.Carregar then
            idle = 0
            if IsDisabledControlJustPressed(1,22) or IsControlJustPressed(1,22) then
                TaskJump(PlayerPedId())
                idle = 1000
            end
        end
        Wait(idle)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:ROPECARRY
-----------------------------------------------------------------------------------------------------------------------------------------
local ropeCarry = false

RegisterNetEvent("player:remPlayerCarregar")
AddEventHandler("player:remPlayerCarregar",function()

    error( '"player:remPlayerCarregar" is deprecated! use "exports[ \'sx\' ]:DetachPlayer( source )"' )

    if ropeCarry then
        DetachEntity(PlayerPedId(),false,false)
        ropeCarry = false
    end
end)

RegisterNetEvent("player:ropeCarry")
AddEventHandler("player:ropeCarry",function(entity,Status)

    error( '"player:ropeCarry" is deprecated! use "exports[ \'sx\' ]:AttachPlayerToPlayer( entity, source )"' )

    if not Status then
        DetachEntity(PlayerPedId(),false,false)
        ropeCarry = false
    else
        if OnesyncEnableRemoteAttachmentSanitization then -- Remover validação quando essa native for para release
            OnesyncEnableRemoteAttachmentSanitization( false )
        end
        AttachEntityToEntity(PlayerPedId(),GetPlayerPed(GetPlayerFromServerId(entity)),0,0.20,0.12,0.63,0.5,0.5,0.0,false,false,false,false,2,false)
        if OnesyncEnableRemoteAttachmentSanitization then -- Remover validação quando essa native for para release
            OnesyncEnableRemoteAttachmentSanitization( true )
        end
        ropeCarry = true

        CreateThread(function()
            while ropeCarry do
                DisableControlAction(0,245,true)
                DisableControlAction(0,309,true)
                DisableControlAction(0,1,true)
                DisableControlAction(0,2,true)
                DisableControlAction(0,24,true)
                DisableControlAction(0,257,true)
                DisableControlAction(0,25,true)
                DisableControlAction(0,263,true)
                DisableControlAction(0,32,true)
                DisableControlAction(0,34,true)
                DisableControlAction(0,31,true)
                DisableControlAction(0,30,true)
                DisableControlAction(0,45,true)
                DisableControlAction(0,22,true)
                DisableControlAction(0,44,true)
                DisableControlAction(0,37,true)
                DisableControlAction(0,23,true)
                DisableControlAction(0,288,true)
                DisableControlAction(0,289,true)
                DisableControlAction(0,170,true)
                DisableControlAction(0,167,true)
                DisableControlAction(0,0,true)
                DisableControlAction(0,26,true)
                DisableControlAction(0,73,true)
                DisableControlAction(2,199,true)
                DisableControlAction(0,59,true)
                DisableControlAction(0,71,true)
                DisableControlAction(0,72,true)
                DisableControlAction(2,36,true)
                DisableControlAction(0,47,true)
                DisableControlAction(0,264,true)
                DisableControlAction(0,257,true)
                DisableControlAction(0,140,true)
                DisableControlAction(0,141,true)
                DisableControlAction(0,142,true)
                DisableControlAction(0,143,true)
                DisableControlAction(0,75,true)
                DisableControlAction(27,75,true)
                DisableFirstPersonCamThisFrame()
                Wait(1)
            end
        end)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADROPEANIM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        local TimeDistance = 999
        if ropeCarry then
            TimeDistance = 1
            local Ped = PlayerPedId()
            if not IsEntityPlayingAnim(Ped,"nm","firemans_carry",3) then
                vRP.playAnim(false,{"nm","firemans_carry"},true)
            end
            
            DisableControlAction(1,23,true)
        end
        
        Wait(TimeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATSHUFFLE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        local Ped = PlayerPedId()
        if IsPedInAnyVehicle(Ped) then
            TimeDistance = 100
            
            if not GetPedConfigFlag(Ped,184,true) then
                SetPedConfigFlag(Ped,184,true)
            end
            
            local Vehicle = GetVehiclePedIsIn(Ped)
            if GetPedInVehicleSeat(Vehicle,0) == Ped then
                if GetIsTaskActive(Ped,165) then
                    SetPedIntoVehicle(Ped,Vehicle,0)
                end
            end
        else
            if GetPedConfigFlag(Ped,184,true) then
                SetPedConfigFlag(Ped,184,false)
            end
        end
        
        Wait(100)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DETACH HANDCUFF CARRY WHEN PARENT ENTERS VEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler( "gameEventTriggered", function( eventName, args )
    if eventName ~= "CEventNetworkPlayerEnteredVehicle" then
        return
    end
   
    if not IsPedInAnyVehicle( PlayerPedId(), false ) then
        return
    end

    local attachment = sx.player.attachment.getAttachment( LOCALPLAYER_SOURCE )

    if not attachment or attachment.relationKind ~= ePlayerAttachmentRelationKind.Parent then
        return
    end

    TriggerServerEvent( "player:request_detach_handcuff_carry_in_vehicle" )
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETENERGETIC
-----------------------------------------------------------------------------------------------------------------------------------------
local AdminEnergetic = false
RegisterNetEvent("setEnergetic")
AddEventHandler("setEnergetic",function(Timer,Number,Bool)
    if LocalPlayer.state["minigame:active"] == "deathstatue" and tonumber(Number) and tonumber(Number) > 1.10 then
        return
    end

    Energetic = Timer
    SetRunSprintMultiplierForPlayer(PlayerId(),Number)
    AdminEnergetic = Bool or false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETENERGETIC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("resetEnergetic")
AddEventHandler("resetEnergetic",function()
    if Energetic > 0 then
        SetRunSprintMultiplierForPlayer(PlayerId(),1.10)
        Energetic = 0
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADENERGETIC
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        -- print(Energetic)
        if Energetic > 0 then
            Energetic = Energetic - 1
            RestorePlayerStamina(PlayerId(),1.0)
            
            if not AdminEnergetic then
                if Energetic <= 0 or GetEntityHealth(PlayerPedId()) <= 100 then
                    SetRunSprintMultiplierForPlayer(PlayerId(),1.10)
                    Energetic = 0
                end
            end
        end
        
        Wait(1000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETDRUGEFFECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("setDrugEffect")
AddEventHandler("setDrugEffect",function(Timer)
    drugThread(Timer)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDRUGEFFECT
-----------------------------------------------------------------------------------------------------------------------------------------
local DRUG_ANIM_SET = "move_m@drunk@verydrunk"

local DRUG_DRIVING_EFFECTS = {
	1, -- brake
	7, --turn left + accelerate
	8, -- turn right + accelerate
	23, -- accelerate
	4, -- turn left 90 + braking
	5, -- turn right 90 + braking
}

local function getRandomDrunkCarTask()
	math.randomseed(GetGameTimer())

	return DRUG_DRIVING_EFFECTS[math.random(#DRUG_DRIVING_EFFECTS)]
end

-- NOTE: We might want to check if a player already has an effect
function drugThread(Timer)
	local playerPed = PlayerPedId()
	local isDrug = true

	LoadMovement(DRUG_ANIM_SET)

	SetPedMovementClipset(playerPed, DRUG_ANIM_SET)
	ShakeGameplayCam("DRUNK_SHAKE", 3.0)
	SetPedIsDrunk(playerPed, true)
	SetTransitionTimecycleModifier("spectator5", 10.00)

	CreateThread(function()
		while isDrug do
			local vehPedIsIn = GetVehiclePedIsIn(playerPed)
			local isPedInVehicleAndDriving = (vehPedIsIn ~= 0) and (GetPedInVehicleSeat(vehPedIsIn, -1) == playerPed)

			if isPedInVehicleAndDriving then
				local randomTask = getRandomDrunkCarTask()
				TaskVehicleTempAction(playerPed, vehPedIsIn, randomTask, 500)
			end

            if not IsEntityPlayingAnim(playerPed, DRUG_ANIM_SET, "idle", 3) then
                SetPedMovementClipset(playerPed, DRUG_ANIM_SET)
            end

			Wait(3000)
		end
	end)

	Wait(Timer * 1000)
	isDrug = false
	SetTransitionTimecycleModifier("default", 10.00)
	StopGameplayCamShaking(true)
	ResetPedMovementClipset(playerPed)
	RemoveAnimSet(DRUG_ANIM_SET)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETDRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("setDrunkTime")
AddEventHandler("setDrunkTime",function(Timer)
    Drunk = Drunk + Timer
    
    LocalPlayer["state"]["Drunk"] = true
    
    if LoadMovement("move_m@drunk@verydrunk") then
        SetPedMovementClipset(PlayerPedId(),"move_m@drunk@verydrunk",0.25)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        if Drunk > 0 then
            Drunk = Drunk - 1
            
            if Drunk <= 0 or GetEntityHealth(PlayerPedId()) <= 100 then
                ResetPedMovementClipset(PlayerPedId(),0.25)
                LocalPlayer["state"]["Drunk"] = false
            end
        end
        
        Wait(1000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCHOODOPTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:syncHoodOptions")
AddEventHandler("player:syncHoodOptions",function(Network,Active)
    if NetworkDoesNetworkIdExist(Network) then
        local Vehicle = NetToEnt(Network)
        if DoesEntityExist(Vehicle) then
            if Active == "open" then
                SetVehicleDoorOpen(Vehicle,4,0,0)
            elseif Active == "close" then
                SetVehicleDoorShut(Vehicle,4,0)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCDOORSOPTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:syncDoorsOptions")
AddEventHandler("player:syncDoorsOptions",function(Network,Active)
    if NetworkDoesNetworkIdExist(Network) then
        local Vehicle = NetToEnt(Network)
        if DoesEntityExist(Vehicle) then
            if Active == "open" then
                SetVehicleDoorOpen(Vehicle,5,0,0)
            elseif Active == "close" then
                SetVehicleDoorShut(Vehicle,5,0)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:seatPlayer")
AddEventHandler("player:seatPlayer",function(Index)
    local Ped = PlayerPedId()
    if IsPedInAnyVehicle(Ped) then
        local Vehicle = GetVehiclePedIsUsing(Ped)
        
        if Index == "0" then
            if IsVehicleSeatFree(Vehicle,-1) then
                SetPedIntoVehicle(Ped,Vehicle,-1)
            end
        elseif Index == "1" then
            if IsVehicleSeatFree(Vehicle,0) then
                SetPedIntoVehicle(Ped,Vehicle,0)
            end
        else
            for Seat = 1,10 do
                if IsVehicleSeatFree(Vehicle,Seat) then
                    SetPedIntoVehicle(Ped,Vehicle,Seat)
                    break
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHANDCUFF
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        local TimeDistance = 100
        if LocalPlayer["state"]["Handcuff"] or LocalPlayer["state"]["Target"] then
            TimeDistance = 1
            DisableControlAction(1,18,true)
            DisableControlAction(1,21,true)
            DisableControlAction(1,55,true)
            DisableControlAction(1,102,true)
            DisableControlAction(1,179,true)
            DisableControlAction(1,203,true)
            DisableControlAction(1,76,true)
            DisableControlAction(1,23,true)
            DisableControlAction(1,24,true)
            DisableControlAction(1,25,true)
            DisableControlAction(1,140,true)
            DisableControlAction(1,142,true)
            DisableControlAction(1,143,true)
            DisableControlAction(1,75,true)
            DisableControlAction(1,22,true)
            DisableControlAction(1,243,true)
            DisableControlAction(1,257,true)
            DisableControlAction(1,263,true)
            DisableControlAction(1,311,true)
            DisablePlayerFiring(PlayerPedId(),true)
        end
        
        Wait(TimeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHANDCUFF
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        local TimeDistance = 999
        local Ped = PlayerPedId()
        if LocalPlayer["state"]["Handcuff"] and GetEntityHealth(Ped) > 100 and not ropeCarry and not playerCarry then
            if not IsEntityPlayingAnim(Ped,"mp_arresting","idle",3) then
                if LoadAnim("mp_arresting") then
                    TaskPlayAnim(Ped,"mp_arresting","idle",8.0,8.0,-1,49,0,0,0,0)
                end
                
                TimeDistance = 1
            end
        end
        
        Wait(TimeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOTDISTANCE
-----------------------------------------------------------------------------------------------------------------------------------------
local losSantos = PolyZone:Create({
    vector2(-2153.08,-3131.33),
    vector2(-1581.58,-2092.38),
    vector2(-3271.05,275.85),
    vector2(-3460.83,967.42),
    vector2(-3202.39,1555.39),
    vector2(-1642.50,993.32),
    vector2(312.95,1054.66),
    vector2(1313.70,341.94),
    vector2(1739.01,-1280.58),
    vector2(1427.42,-3440.38),
    vector2(-737.90,-3773.97)
},{ name = "santos" })

local sandyShores = PolyZone:Create({
    vector2(-375.38,2910.14),
    vector2(307.66,3664.47),
    vector2(2329.64,4128.52),
    vector2(2349.93,4578.50),
    vector2(1680.57,4462.48),
    vector2(1570.01,4961.27),
    vector2(1967.55,5203.67),
    vector2(2387.14,5273.98),
    vector2(2735.26,4392.21),
    vector2(2512.33,3711.16),
    vector2(1681.79,3387.82),
    vector2(258.85,2920.16)
},{ name = "sandy" })

local paletoBay = PolyZone:Create({
    vector2(-529.40,5755.14),
    vector2(-234.39,5978.46),
    vector2(278.16,6381.84),
    vector2(672.67,6434.39),
    vector2(699.56,6877.77),
    vector2(256.59,7058.49),
    vector2(17.64,7054.53),
    vector2(-489.45,6449.50),
    vector2(-717.59,6030.94)
},{ name = "paleto" })
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSHOTSFIRED
-----------------------------------------------------------------------------------------------------------------------------------------
local ShotDelay = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- GRIDCHUNK
-----------------------------------------------------------------------------------------------------------------------------------------
local GridSize = 256
function gridChunk(x)
    return math.floor((x + 8192) / GridSize)
end

function toChannel(v)
    return (v["x"] << 8) | v["y"]
end

function getGridzone(x,y)
    local gridChunk = vector2(gridChunk(x),gridChunk(y))
    return toChannel(gridChunk)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSHOT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        local TimeDistance = 999
        if LocalPlayer["state"]["Route"] < 900000 then
            local Ped = PlayerPedId()
            if IsPedArmed(Ped,6) then
                TimeDistance = 1
                
                if IsPedShooting(Ped) then
                    if GetGameTimer() >= ShotDelay then
                        ShotDelay = GetGameTimer() + 60000
                        --TriggerEvent("player:Residuals","Resíduo de Pólvora.")
                        
                        local Vehicle = false
                        local Coords = GetEntityCoords(Ped)
                        local Grid = getGridzone(Coords["x"],Coords["y"])


                        -- if vRP.GetCurrentRoutingBucket() == 1 --[[ Mundo PADRAO ]] and exports.new_hub:GetPlaytimeHours() <= 5 then

                        --     -- Track shots fired streak and apply misconduct if needed
                        --     local streak = sx.client.stats.v2.get('shots_fired_streak')
                        --     local lastStreakTime = sx.client.stats.v2.get('shots_fired_streak_last_time')
                        --     local utcnow = utctime()

                        --     -- If last streak was more than 10 minutes ago, reset streak
                        --     if lastStreakTime == 0 or (utcnow - lastStreakTime) > (10 * 60 * 1000) then
                        --         streak = 0
                        --     end

                        --     streak = streak + 1
                        --     sx.client.stats.v2.set('shots_fired_streak', streak)
                        --     sx.client.stats.v2.set('shots_fired_streak_last_time', utcnow)

                        --     if streak >= 10 then
                        --         -- Reset streak and give misconduct point
                        --         sx.client.stats.v2.set('shots_fired_streak', 0)
                        --         sx.client.stats.v2.increment('misconduct_points', 5)
                        --         sx.client.stats.v2.set('misconduct_punished_by', 'shots_fired_streak')
                        --         sx.client.stats.v2.set('misconduct_punished_at_world', vRP.GetCurrentRoutingBucket())
                        --         sx.logger:info(('Player reached shots fired streak of 10 in less than 10 minutes, misconduct applied: +20 points'))
                        --     end
                        -- end

                        if not IsPedCurrentWeaponSilenced(Ped) then
                            -- if (losSantos:isPointInside(Coords) or sandyShores:isPointInside(Coords) or paletoBay:isPointInside(Coords)) and not LocalPlayer["state"]["Policia"] then
                            -- 	TriggerServerEvent("evidence:dropEvidence","blue")
                            if LocalPlayer["state"]["Policia"] then return end
                            if IsPedInAnyVehicle(Ped) then
                                Vehicle = true
                            end
                            
                            vSERVER._shotsFired(Vehicle,Grid)
                            -- end
                        else
                            if math.random(40) >= 20 then
                                -- if (losSantos:isPointInside(Coords) or sandyShores:isPointInside(Coords) or paletoBay:isPointInside(Coords)) and not LocalPlayer["state"]["Policia"] then
                                -- 	TriggerServerEvent("evidence:dropEvidence","blue")
                                if LocalPlayer["state"]["Policia"] then return end
                                if IsPedInAnyVehicle(Ped) then
                                    Vehicle = true
                                end
                                
                                vSERVER._shotsFired(Vehicle,Grid)
                                -- end
                            end
                        end
                    end
                end
            end
        end
        
        Wait(TimeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHAKESHOTTING
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        local TimeDistance = 999
        local Ped = PlayerPedId()
        if IsPedInAnyVehicle(Ped) and IsPedArmed(Ped,6) then
            TimeDistance = 1
            
            local Vehicle = GetVehiclePedIsUsing(Ped)
            if IsPedShooting(Ped) and (GetVehicleClass(Vehicle) ~= 15 and GetVehicleClass(Vehicle) ~= 16) then
                ShakeGameplayCam("SMALL_EXPLOSION_SHAKE",0.05)
            end
        end
        
        Wait(TimeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSOAP
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkSoap()
    return Residuals
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:RESIDUALS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:Residuals")
AddEventHandler("player:Residuals",function(Informations)
    if Informations then
        if not Residuals then
            Residuals = {}
        end
        
        Residuals[Informations] = true
    else
        Residuals = nil
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:inBennys")
AddEventHandler("player:inBennys",function(status)
    inBennys = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.removeVehicle()

    local Ped = PlayerPedId()

    if inBennys then
        return
    end

    if not IsPedInAnyVehicle( Ped ) then
        return
    end

    TaskLeaveVehicle(Ped,GetVehiclePedIsUsing(Ped),16)
    

    --[[
        INFO: Por algum motivo precisamos fazer a gambiarra abaixo
        para limpar as tasks do client do usuario que esta saindo do veiculo
        pois a native TaskLeaveVehicle não faz isso syncada dos os demais
        client's

        - @TkzDev
    ]]

    Wait( 50 )

    ClearPedTasksImmediately( Ped )
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PUTVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.putVehicle(Network)
    if NetworkDoesNetworkIdExist(Network) then
        local Vehicle = NetToEnt(Network)
        if DoesEntityExist(Vehicle) then
            local vehSeats = 10
            local Ped = PlayerPedId()
            
            repeat
                vehSeats = vehSeats - 1
                
                if IsVehicleSeatFree(Vehicle,vehSeats) then
                    ClearPedTasks(Ped)
                    ClearPedSecondaryTask(Ped)
                    SetPedIntoVehicle(Ped,Vehicle,vehSeats)
                    
                    vehSeats = true
                end
            until vehSeats == true or vehSeats == 0
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRUISER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cr",function(source,Message)
    local Ped = PlayerPedId()
    if IsPedInAnyVehicle(Ped) then
        local Vehicle = GetVehiclePedIsUsing(Ped)
        if GetPedInVehicleSeat(Vehicle,-1) == Ped and not IsEntityInAir(Vehicle) then
            local speed = GetEntitySpeed(Vehicle) * 3.6
            
            if speed >= 10 then
                if not Message[1] then
                    SetEntityMaxSpeed(Vehicle,GetVehicleEstimatedMaxSpeed(Vehicle))
                    --TriggerEvent("Notify","amarelo","Controle de cruzeiro desativado.",3000)
                    TriggerEvent("Notify2","#controleCruzeiroDesativado")
                else
                    if parseInt(Message[1]) > 10 then
                        SetEntityMaxSpeed(Vehicle,0.28 * Message[1])
                        --TriggerEvent("Notify","verde","Controle de cruzeiro ativado.",3000)
                        TriggerEvent("Notify2","#controleCruzeiroAtivado")
                    end
                end
            end
        end
    end
end)

---@class CEventNetworkEntityDamage
---@field victim number
---@field damager number
---@field unk0 number
---@field unk1 number
---@field unk2 number
---@field isFatal boolean
---@field weaponHash number
---@field unk3 number
---@field unk4 number
---@field unk5 number
---@field unk6 number
---@field unk7 number
---@field isMelee boolean
---@field vehicleDamageTypeFlag number

---@type fun(): string | nil, any | nil
CEventNetworkEntityDamageRaw =
{
    function( v ) return 'victim', v end,
    function( v ) return 'damager', v end,
    function( v ) return 'unk0', v end,
    function( v ) return GetGameBuildNumber() >= 2060 and 'unk1', v or nil end,
    function( v ) return GetGameBuildNumber() >= 2189 and 'unk2', v or nil end,
    function( v ) return 'isFatal', v == 1 and true or false end,
    function( v ) return 'weaponHash', v & 0xFFFFFFFF end,
    function( v ) return 'unk3', v end,
    function( v ) return 'unk4', v end,
    function( v ) return 'unk5', v end,
    function( v ) return 'unk6', v end,
    function( v ) return 'unk7', v end,
    function( v ) return 'isMelee', v == 1 and true or false end,
    function( v ) return 'vehicleDamageTypeFlag', v end,
}

---@param rawEvent CEventNetworkEntityDamageRaw[]
---@return CEventNetworkEntityDamage
function ConstructCEventNetworkEntityDamage( rawEvent )

    local event = { }

    for i = 1, #rawEvent do

        local rawValue = rawEvent[ i ]

        local name, value = CEventNetworkEntityDamageRaw[ i ]( rawValue )

        if name == nil then

            i = i - 1
        else

            event[ name ] = value
        end
    end

    return event
end

-- TOOD , MOVER TUDO DE MISCONDUCT PARA O NEW_HUB

local STAT_MISCONDUCT_POINTS = 'misconduct_points'

local STAT_KILLSTREAK_KILLS = 'killstreak_kills'
local STAT_KILLSTREAK_START_DATE = 'killstreak_start_date'
local STAT_KILLSTREAK_LAST_KILL_DATE = 'killstreak_last_kill_date'

-----------------------------------------------------------------------------------------------------------------------------------------
-- GAMEEVENTTRIGGERED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("gameEventTriggered",function( eventName, rawEvent )
    if eventName == "CEventNetworkEntityDamage" then

        local event = ConstructCEventNetworkEntityDamage( rawEvent )

        -- sx.logger:debug( json.encode( event, { indent = true } ) )

        local Ped = PlayerPedId()
        local OtherPed = rawEvent[2]
        if rawEvent[1] == Ped and GetEntityHealth(Ped) <= 100 and IsEntityAPed(Ped) and IsPedAPlayer(OtherPed) then
            local Index = NetworkGetPlayerIndexFromPed(OtherPed)
            local PedIndex = GetPlayerServerId(PlayerId())
            local OtherIndex = GetPlayerServerId(Index)
            local Weapon = rawEvent[7]
            local MurderWeapon = tostring(rawEvent[7])

            local weaponInfoIndex = WEAPONINFO_INDEX_BY_HASH[ Weapon & 0xFFFFFFFF ]

            TriggerServerEvent( "player:Death", OtherIndex, weaponInfoIndex )
        end

        -- So trackeamos para quem tem menos de 2 horas de playtime
        local canTrackMisconduct = exports.new_hub:IsPlaysessionReady() and exports.new_hub:GetPlaytimeHours() <= 5

        if canTrackMisconduct then

            local isDamager = event.damager == PlayerPedId()

            if isDamager and event.isFatal and vRP.GetCurrentRoutingBucket() == 1 /* Mundo PADRAO */ then

                -- if exports.new_hub:GetPlaytimeMinutes() <= 15 then

                --     MISCONDUCT_EARLY_KILL_PUNISH_BY = 30

                --     sx.client.stats.v2.increment( STAT_MISCONDUCT_POINTS, MISCONDUCT_EARLY_KILL_PUNISH_BY )
                --     sx.client.stats.v2.set( 'misconduct_punished_by', 'early_kill' )
                --     sx.client.stats.v2.set( 'misconduct_punished_at_world', vRP.GetCurrentRoutingBucket() )
                -- end

                -- local prevNumKills = sx.client.stats.v2.get( 'kills' )

                -- sx.client.stats.v2.increment( STAT_KILLSTREAK_KILLS, 1 )

                -- local utcnow = utctime()

                -- -- Track killstreak: store number of kills and last kill timestamp
                -- local prevKillstreakKills = sx.client.stats.v2.get( STAT_KILLSTREAK_KILLS )
                -- local prevKillstreakStartDate = sx.client.stats.v2.get( STAT_KILLSTREAK_START_DATE )
                -- local prevKillstreakLastKillDate = sx.client.stats.v2.get( STAT_KILLSTREAK_LAST_KILL_DATE )

                -- local newKillstreakKills = prevKillstreakKills + 1

                -- local killstreakHasEnded = prevKillstreakLastKillDate ~= 0 and utcnow - prevKillstreakLastKillDate > 3 * 60 * 1000

                -- -- If last kill was more than 10 minutes ago, clear the killstreak and start a new one
                -- if killstreakHasEnded then

                --     sx.logger:info(('Killstreak broken: time since last kill was %d ms, resetting killstreak'):format(utcnow - prevKillstreakLastKillDate))

                --     newKillstreakKills = 1
                -- else
                --     -- Continue the current killstreak
                --     -- Check if killstreak of 3 in last 10 minutes is achieved
                --     if newKillstreakKills == 1 then

                --         sx.logger:info(('Killstreak achieved: %d kills in last 10 minutes'):format(newKillstreakKills))

                --         MISCONDUCT_SUS_KILLSTREAK_PUNISH_BY = 40

                --         sx.client.stats.v2.increment( STAT_MISCONDUCT_POINTS, MISCONDUCT_SUS_KILLSTREAK_PUNISH_BY )
                --     end
                -- end

                -- if newKillstreakKills == 1 then

                --     -- Novo killstreak!

                --     sx.client.stats.v2.set( STAT_KILLSTREAK_START_DATE, utcnow )
                -- end

                -- sx.client.stats.v2.set( STAT_KILLSTREAK_KILLS, newKillstreakKills )
                -- sx.client.stats.v2.set( STAT_KILLSTREAK_LAST_KILL_DATE, utcnow )
            end
        end
    end
end)

-- Misconduct degradation loop moved to server-side (stats_host_v2.lua)

-- RegisterCommand('test', function()

--     TriggerEvent( 'gameEventTriggered', 'CEventNetworkEntityDamage', {
--         0,
--         PlayerPedId(),
--         0,
--         0,
--         0,
--         1,
--     })
-- end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNKABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local inTrunk = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:ENTERTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:enterTrunk")
AddEventHandler("player:enterTrunk",function(Entitys)
    if not inTrunk and not Entity(Entitys[3])["state"]["inTrunk"] then
        LocalPlayer["state"]["Commands"] = true
        LocalPlayer["state"]["Invisible"] = true
        SetEntityVisible(PlayerPedId(),false,false)
        Entity(Entitys[3])["state"]:set("inTrunk",true,true)
        AttachEntityToEntity(PlayerPedId(),Entitys[3],-1,0.0,-2.2,0.5,0.0,0.0,0.0,false,false,false,false,20,true)
        inTrunk = true
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CHECKTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:checkTrunk")
AddEventHandler("player:checkTrunk",function()
    if inTrunk then
        local Ped = PlayerPedId()
        local Vehicle = GetEntityAttachedTo(Ped)
        if DoesEntityExist(Vehicle) then
            inTrunk = false
            local VSpeed = GetEntitySpeed(Vehicle) * 3.6
            if not VSpeed or VSpeed <= 20 then
                DetachEntity(Ped,false,false)
                SetEntityVisible(Ped,true,false)
                LocalPlayer["state"]["Invisible"] = false
                LocalPlayer["state"]["Commands"] = false
                Entity(Vehicle)["state"]:set("inTrunk",nil,true)
                SetEntityCoords(Ped,GetOffsetFromEntityInWorldCoords(Ped,0.0,-1.25,-0.25),false,false,false,false)
                LocalPlayer["state"]["Commands"] = true
                Wait(2000)
                LocalPlayer["state"]["Commands"] = false
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADINTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        local TimeDistance = 999
        
        if inTrunk then
            local Ped = PlayerPedId()
            local Vehicle = GetEntityAttachedTo(Ped)
            if DoesEntityExist(Vehicle) then
                TimeDistance = 1
                
                DisablePlayerFiring(Ped,true)
                
                if IsEntityVisible(Ped) then
                    LocalPlayer["state"]["Invisible"] = true
                    SetEntityVisible(Ped,false,false)
                end
                
                if IsControlJustPressed(1,38) then
                    inTrunk = false
                    DetachEntity(Ped,false,false)
                    SetEntityVisible(Ped,true,false)
                    LocalPlayer["state"]["Invisible"] = false
                    LocalPlayer["state"]["Commands"] = false
                    Entity(Vehicle)["state"]:set("inTrunk",nil,true)
                    SetEntityCoords(Ped,GetOffsetFromEntityInWorldCoords(Ped,0.0,-1.25,-0.25),false,false,false,false)
                end
            else
                inTrunk = false
                DetachEntity(Ped,false,false)
                SetEntityVisible(Ped,true,false)
                LocalPlayer["state"]["Invisible"] = false
                LocalPlayer["state"]["Commands"] = false
                Entity(Vehicle)["state"]:set("inTrunk",nil,true)
                SetEntityCoords(Ped,GetOffsetFromEntityInWorldCoords(Ped,0.0,-1.25,-0.25),false,false,false,false)
            end
        end
        
        Wait(TimeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANCORAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ancorar",function()
    local Ped = PlayerPedId()
    if IsPedInAnyBoat(Ped) then
        local Vehicle = GetVehiclePedIsUsing(Ped)
        if CanAnchorBoatHere(Vehicle) then
            --TriggerEvent("Notify","verde","Embarcação desancorada.",5000)
            TriggerEvent("Notify2","#embarcDesancorada")
            SetBoatAnchor(Vehicle,false)
        else
            --TriggerEvent("Notify","verde","Embarcação ancorada.",5000)
            TriggerEvent("Notify2","#embarcAncorada")
            SetBoatAnchor(Vehicle,true)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COWCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local Cows = {
    { 2440.58,4736.35,34.29 },
    { 2432.5,4744.58,34.31 },
    { 2424.47,4752.37,34.31 },
    { 2416.28,4760.8,34.31 },
    { 2408.6,4768.88,34.31 },
    { 2400.32,4777.48,34.53 },
    { 2432.46,4802.66,34.83 },
    { 2440.62,4794.22,34.66 },
    { 2448.65,4786.57,34.64 },
    { 2456.88,4778.08,34.49 },
    { 2464.53,4770.04,34.37 },
    { 2473.38,4760.98,34.31 },
    { 2495.03,4762.77,34.37 },
    { 2503.13,4754.08,34.31 },
    { 2511.34,4746.04,34.31 },
    { 2519.56,4737.35,34.29 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    for Index,v in pairs(Cows) do
        exports["target"]:AddCircleZone("Cows:"..Index,vec3(v[1],v[2],v[3]),0.5,{
            name = "Cows:"..Index,
            heading = 3374176
        },{
            Distance = 1.25,
            options = {
                {
                    event = "inventory:MakeProducts",
                    label = "Retirar Leite",
                    tunnel = "products",
                    service = "milkBottle"
                }
            }
        })
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNKABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local inTrash = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:ENTERTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:enterTrash")
AddEventHandler("player:enterTrash",function(Entity)
    if not inTrash then
        LocalPlayer["state"]["Commands"] = true
        
        local Ped = PlayerPedId()
        LocalPlayer["state"]["Invisible"] = true
        SetEntityCoords(Ped,Entity[4],false,false,false,false)
        
        inTrash = GetOffsetFromEntityInWorldCoords(Entity[1],0.0,-1.5,0.0)
        
        while inTrash do

            Ped = PlayerPedId()

            FreezeEntityPosition(Ped,true)
            SetEntityVisible(Ped,false,false)    

            -- Bloquear uso da primeira pessoa enquanto estiver dentro da lixeira!
            DisableFirstPersonCamThisFrame()

            -- Bloquear disparo enquanto estiver dentro da lixeira!
            DisableControlAction(0,25,true)
            DisablePlayerFiring(Ped,true)

            if IsControlJustPressed(1,38) then
                FreezeEntityPosition(Ped,false)
                SetEntityVisible(Ped,true,false)
                LocalPlayer["state"]["Invisible"] = false
                SetEntityCoords(Ped,inTrash,false,false,false,false)
                LocalPlayer["state"]["Commands"] = false
                
                inTrash = false
            end

            Wait(1)
        end
    end
end)

function Creative.inTrash()
    return inTrash
end

AddEventHandler( "player.attempt_check_player_in_trash", function( )
 
    local nearbyPlayers = sx.client.spatial.findPlayersNearby( 3.0, 1 )

    if #nearbyPlayers <= 0 then
        return
    end

    TriggerServerEvent( "net.player.req_check_player_in_trash", nearbyPlayers )
end)


RegisterNetEvent( "net.player.player_in_trash", function( )

    if not inTrash then

        -- esta dentro da lixeira ?

        return
    end

    local pedId = PlayerPedId( )
    
    FreezeEntityPosition( pedId, false )

    SetEntityVisible( pedId, true, false )

    SetEntityCoords( pedId, inTrash, false, false, false, false )
    
    LocalPlayer.state.Invisible = false
    LocalPlayer.state.Commands = false
    
    inTrash = false

end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- MEGAPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
local Megaphone = false
RegisterNetEvent("player:Megaphone")
AddEventHandler("player:Megaphone",function()
    Megaphone = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADMEGAPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        if Megaphone then
            local Ped = PlayerPedId()
            if not IsEntityPlayingAnim(Ped,"anim@random@shop_clothes@watches","base",3) then
                TriggerServerEvent("pma-voice:Megaphone",false)
                TriggerEvent("pma-voice:Megaphone",false)
                Megaphone = false
            end
        end
        
        Wait(1000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DUIVARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local DuiTextures = {}
local InnerTexture = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:DUITABLE
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterNetEvent("player:DuiTable")
-- AddEventHandler("player:DuiTable",function(Table)
--     DuiTextures = Table
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADMEGAPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
-- CreateThread(function()
--     while true do
--         local Ped = PlayerPedId()
--         if not IsPedInAnyVehicle(Ped) then
--             local Coords = GetEntityCoords(Ped)

--             for Line,v in pairs(DuiTextures) do
--                 if #(Coords - v["Coords"]) <= 15 then
--                     if not InnerTexture[Line] then
--                         InnerTexture[Line] = true

--                         local Texture = CreateRuntimeTxd("Texture"..Line)
--                         local TextureObject = CreateDui(v["Link"],v["Width"],v["Weight"])
--                         local TextureHandle = GetDuiHandle(TextureObject)

--                         CreateRuntimeTextureFromDuiHandle(Texture,"Back"..Line,TextureHandle)
--                         AddReplaceTexture(v["Dict"],v["Texture"],"Texture"..Line,"Back"..Line)

--                         exports["target"]:AddCircleZone("Texture"..Line,v["Coords"],v["Dimension"],{
--                             name = "Texture"..Line,
--                             heading = 3374176
--                         },{
--                             shop = Line,
--                             Distance = v["Distance"],
--                             options = {
--                                 {
--                                     event = "player:Texture",
--                                     label = v["Label"],
--                                     tunnel = "server"
--                                 }
--                             }
--                         })
--                     end
--                 else
--                     if InnerTexture[Line] then
--                         exports["target"]:RemCircleZone("Texture"..Line)
--                         RemoveReplaceTexture(v["Dict"],v["Texture"])
--                         InnerTexture[Line] = nil
--                     end
--                 end
--             end
--         end

--         Wait(1000)
--     end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:DUIUPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterNetEvent("player:DuiUpdate")
-- AddEventHandler("player:DuiUpdate",function(Name,Table)
--     DuiTextures[Name] = Table

--     local Ped = PlayerPedId()
--     local Fast = DuiTextures[Name]
--     local Coords = GetEntityCoords(Ped)
--     if #(Coords - Fast["Coords"]) <= 15 then
--         local Texture = CreateRuntimeTxd("Texture"..Name)
--         local TextureObject = CreateDui(Fast["Link"],Fast["Width"],Fast["Weight"])
--         local TextureHandle = GetDuiHandle(TextureObject)

--         CreateRuntimeTextureFromDuiHandle(Texture,"Back"..Name,TextureHandle)
--         AddReplaceTexture(Fast["Dict"],Fast["Texture"],"Texture"..Name,"Back"..Name)
--     end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:RELATIONSHIP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:Relationship")
AddEventHandler("player:Relationship",function(Group)
    if Group == "Ballas" then
        SetRelationshipBetweenGroups(1,GetHashKey("AMBIENT_GANG_BALLAS"),GetHashKey("PLAYER"))
        SetRelationshipBetweenGroups(1,GetHashKey("PLAYER"),GetHashKey("AMBIENT_GANG_BALLAS"))
    elseif Group == "Families" then
        SetRelationshipBetweenGroups(1,GetHashKey("AMBIENT_GANG_FAMILY"),GetHashKey("PLAYER"))
        SetRelationshipBetweenGroups(1,GetHashKey("PLAYER"),GetHashKey("AMBIENT_GANG_FAMILY"))
    elseif Group == "Vagos" then
        SetRelationshipBetweenGroups(1,GetHashKey("AMBIENT_GANG_MEXICAN"),GetHashKey("PLAYER"))
        SetRelationshipBetweenGroups(1,GetHashKey("PLAYER"),GetHashKey("AMBIENT_GANG_MEXICAN"))
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CARWASH
-----------------------------------------------------------------------------------------------------------------------------------------
local WashProgress = false
local Wash = {
    { 24.27,-1391.96,28.7 },
    { 170.59,-1718.43,28.66 },
    { 167.69,-1715.92,28.66 },
    { -699.86,-932.84,18.38 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCARWASH
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        local TimeDistance = 999
        local Ped = PlayerPedId()
        if IsPedInAnyVehicle(Ped) and not WashProgress then
            local Coords = GetEntityCoords(Ped)
            local Vehicle = GetVehiclePedIsUsing(Ped)
            if GetPedInVehicleSeat(Vehicle,-1) == Ped then
                for _,v in pairs(Wash) do
                    local Distance = #(Coords - vec3(v[1],v[2],v[3]))
                    if Distance <= 2.5 then
                        TimeDistance = 1
                        
                        if IsControlJustPressed(1,38) then
                            WashProgress = true
                            
                            FreezeEntityPosition(Vehicle,true)
                            
                            UseParticleFxAssetNextCall("core")
                            local Particle01 = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p",v[1],v[2],v[3],0.0,0.0,0.0,1.0,false,false,false,false)
                            
                            UseParticleFxAssetNextCall("core")
                            local Particle02 = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p",v[1] + 2.5,v[2],v[3],0.0,0.0,0.0,1.0,false,false,false,false)
                            
                            SetTimeout(15000,function()
                                TriggerServerEvent("CleanVehicle",VehToNet(Vehicle))
                                
                                FreezeEntityPosition(Vehicle,false)
                                StopParticleFxLooped(Particle01,0)
                                StopParticleFxLooped(Particle02,0)
                                WashProgress = false
                            end)
                        end
                    end
                end
            end
        end
        
        Wait(TimeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FPS
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand("fps",function(source,args)
--     if args[1] == "on" then
--         SetTimecycleModifier("cinema")
--     else
--         ClearTimecycleModifier()
--     end
-- end)


local function requestToCarryTheNearestPlayer()
    
    local pedId = PlayerPedId()

    if IsPedInAnyVehicle( pedId, true ) then
        return  
    end

    if LocalPlayer["state"]["Cancel"] then
        return
    end

    if LocalPlayer["state"]["Handcuff"] then
        return
    end

    if LocalPlayer["state"]["minigame:active"] == "deathstatue" then
        return
    end

    local nearbyPlayers = sx.client.spatial.findPlayersNearby( 2.0, 1 )

    if #nearbyPlayers <= 0 then
        return
    end

    TriggerServerEvent( "player.carry.try_to_carry_the_nearest_player", nearbyPlayers )
end

AddEventHandler( "player.carry.request_to_carry_the_nearest_player", requestToCarryTheNearestPlayer )

RegisterCommand( "carry", requestToCarryTheNearestPlayer )

RegisterKeyMapping("carry", "Carry Player", "keyboard", "H")

RegisterCommand( _t("search"), function( )
	
    local pedId = PlayerPedId( )

    local isInsideAnyVehicle = IsPedInAnyVehicle( pedId, true )

    if isInsideAnyVehicle then

        -- esta dentro de algum veiculo ?

        return
    end

    local nearbyPlayers = sx.client.spatial.findPlayersNearby( 2.0, 1 )

    if #nearbyPlayers <= 0 then
        return
    end

    TriggerServerEvent( "net.player.req_inspect_player", nearbyPlayers )
end)

RegisterCommand( _t("finish"), function( )
	
    local pedId = PlayerPedId( )

    local isInsideAnyVehicle = IsPedInAnyVehicle( pedId, true )

    if isInsideAnyVehicle then

        -- esta dentro de algum veiculo ?

        return
    end

    local nearbyPlayers = sx.client.spatial.findPlayersNearby( 2.0, 1 )

    if #nearbyPlayers <= 0 then
        return
    end

    TriggerServerEvent( "net.player.req_finish_player", nearbyPlayers )
end)

-- CreateThread(function()
--     while true do
--         local timeDistance = 500
--         if LocalPlayer.state.Carregar then
--             timeDistance = 1
--             DisableControlAction(1,23,true)
--         end
--         Wait(timeDistance)
--     end
-- end)

local function requestToForcePlayerInto( )

    local pedId = PlayerPedId( )

    if IsPedInAnyVehicle( pedId, true ) then

        -- esta dentro do veiculo ?

        return  
    end

    if LocalPlayer.state.InSafeZone then
        return
    end

    local nearbyPlayers = sx.client.spatial.findPlayersNearby( 5.0, 1 )

    if #nearbyPlayers <= 0 then
        return
    end

    local vehicleId, vehicleNetworkId, _, _, _, vehicleSpeed = vRP.VehicleList( 3.0 )

    local vehicleDoorState = tonumber( GetVehicleDoorLockStatus( vehicleId ) )

    if not vehicleId then

        sx.logger:debug( 'player.vehicle.try_to_force_player_into -> vehicleId does not exist' )

        return
    end
    
    if vehicleSpeed > 5.0 or vehicleDoorState ~= 1 then

        -- garantir que o veiculo não esteja em movimento ou trancado 

        return
    end
    
    TriggerServerEvent( "net.vehicles.try_force_player_into", nearbyPlayers, vehicleNetworkId )

end

AddEventHandler( "net.vehicles.req_force_player_into", requestToForcePlayerInto )

RegisterCommand( "cv", function( )
    requestToForcePlayerInto( )
end)

local function requestToRemovePlayerFromVehicle()
    local pedId = PlayerPedId( )

    if IsPedInAnyVehicle( pedId, true ) then
        return  
    end

    if LocalPlayer.state.InSafeZone then
        return
    end

    local nearbyPlayers = sx.client.spatial.findPlayersNearby( 5.0, 1 )

    if #nearbyPlayers <= 0 then
        return
    end

    local vehicleId, vehicleNetworkId, _, _, _, vehicleSpeed = vRP.VehicleList( 3.0 )
    local vehicleDoorState = tonumber( GetVehicleDoorLockStatus( vehicleId ) )

    if not vehicleId then
        return
    end
    
    if vehicleSpeed > 5.0 or vehicleDoorState ~= 1 then
        return
    end
    
    TriggerServerEvent( "net.vehicles.try_remove_player_from", nearbyPlayers, vehicleNetworkId )
end

AddEventHandler( "net.vehicles.req_remove_player_from", requestToRemovePlayerFromVehicle )

RegisterCommand( "rv", function( )
    requestToRemovePlayerFromVehicle( )
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CL
-----------------------------------------------------------------------------------------------------------------------------------------
local inCL = true
local ProximityCL = {}
local CLCooldown = GetGameTimer()

RegisterNetEvent("player:CL")
AddEventHandler("player:CL",function( passport, position, reason )
    if LocalPlayer.state.Home then
        return
    end

    local Info =
    {
        Player = passport,
        Coords = position,
        Reason = reason,
        Timer = 120,
    }

    table.insert(ProximityCL,Info)
end)

RegisterNetEvent("player:CLClean")
AddEventHandler("player:CLClean",function(Info)
    for i=1,#ProximityCL do
        if ProximityCL[i] then
            table.remove(ProximityCL,i)
        end
    end
    ProximityCL = {}
end)

RegisterCommand("cl",function(source)
    inCL = not inCL
end)

-- RegisterCommand("testcl",function(source)
--     local Coords = GetEntityCoords(PlayerPedId())
--     TriggerEvent("player:CL",{Player = 68, Coords = Coords, Reason = "Banido: Teste CL", Timer = 120})
-- end)

CreateThread(function()
    Wait(10000)

    local Idle = 1000

    while true do
    
        Wait(Idle)

        Idle = 1000

        if inCL and not LocalPlayer.state.Home and not LocalPlayer["state"]["character-creator-state"] or LocalPlayer['state']['snowball:match'] or LocalPlayer["state"]["minigame:active"] then

            local Coords = (sx and sx.client and sx.client.player and sx.client.player.getFocusPosition) and sx.client.player.getFocusPosition() or GetEntityCoords(PlayerPedId())

            for i=1,#ProximityCL do
                if ProximityCL[i] then
                    if #(Coords - ProximityCL[i]["Coords"]) <= 25.0 then
                        Idle = 0
                        local Pattern = _t("cl_id"):format(ProximityCL[i]["Player"]).." ".._t("cl_reason"):format(ProximityCL[i]["Reason"])
                        
                        if string.find(ProximityCL[i]["Reason"]:lower(),"banido: ") then
                            local Reason = string.gsub(ProximityCL[i]["Reason"],"Banido: ","")
                            Pattern = _t("cl_banned_pattern"):format(ProximityCL[i]["Player"], Reason)
                        end

                        DrawTextCL(ProximityCL[i]["Coords"]["x"],ProximityCL[i]["Coords"]["y"],ProximityCL[i]["Coords"]["z"],Pattern)
                    end
                end
            end
        end
    end
end)

function splitMessageToLines(message, maxLen)
    local lines = {}
    local current = ""
    for word in message:gmatch("%S+") do
        if #current + #word + 1 > maxLen then
            table.insert(lines, current)
            current = word
        else
            if current ~= "" then
                current = current .. " " .. word
            else
                current = word
            end
        end
    end
    if current ~= ""  then
        if message:lower():find("banido") or message:lower():find("banned") then
            table.insert(lines, "~r~"..current.."~w~")
        else
            table.insert(lines, current)
        end
    end
    return lines
end

function DrawTextCL(x, y, z, Message)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    if onScreen then
        local maxLen = 45
        local lines = splitMessageToLines(Message, maxLen)
        local lineHeight = 0.025
        local totalHeight = #lines * lineHeight

        SetTextScale(0.35, 0.35)
        SetTextFont(4)

        local maxWidth = 0
        for i, line in ipairs(lines) do
            BeginTextCommandWidth("STRING")
            if i > 1 and (Message:lower():find("banido") or Message:lower():find("banned")) then
                line = "~r~"..line
            end

            AddTextComponentSubstringKeyboardDisplay(line)
            local width = EndTextCommandGetWidth(4)
            if width > maxWidth then
                maxWidth = width
            end
        end

        local padding = 0.02
        local rectWidth = maxWidth + padding

        for i, line in ipairs(lines) do
            BeginTextCommandDisplayText("STRING")
            AddTextComponentSubstringKeyboardDisplay(line)
            SetTextColour(255, 255, 255, 200)
            SetTextScale(0.35, 0.35)
            SetTextFont(4)
            SetTextCentre(1)
            EndTextCommandDisplayText(_x, _y + ((i - 1) * lineHeight))
        end
        DrawRect(_x, _y + (totalHeight / 2), rectWidth, totalHeight + 0.01, 15, 15, 15, 200)
    end
end

CreateThread(function()
    while true do
        for i=1,#ProximityCL do
            if ProximityCL[i] and ProximityCL[i]["Timer"] then
                ProximityCL[i]["Timer"] = ProximityCL[i]["Timer"] - 1
                if ProximityCL[i]["Timer"] <= 0 then
                    table.remove(ProximityCL,i)
                end
            end
        end
        Wait(1000)
    end
end)

local StoreURL = {
    ["Santa"] = "https://loja.cidadesantarp.com/",
    ["Galaxy"] = "https://lojagalaxy.santagroup.gg/",
    ["Universo"] = "https://loja.universoroleplay.com/",
    ["CidadeNobre"] = "https://loja.cidadenobre.com/",
    ["Boomerang"] = "https://storee.boomerangroleplay.com/",
    ["Malta"] = "https://loja.maltarp.com/",
    ["Kingdom"] = "https://storee.kngestate.com/?currency=GBP",
    ["Imperium"] = "https://store.imperium.com/",
    ["GoatRP"] = "https://boutique.goatrp.gg/",
    ["District99"] = "https://store.district99.gg/?currency=USD",
    ["Krown"] = "https://store.krownrp.com/?currency=USD",
    ["Orizon"] = "https://store.orizonrp.gg/",
    ["Liberty99"] = "https://store.liberty99rp.com/",
    ["Royal"] = "https://storee.royalukrp.com/",
    ["Real"] = "https://tienda.realrp.es/",
    ["Grande"] = "https://loja.cidadegrande.com/",
    ["Prime"] = "https://tienda.primerp.gg/",
    ["Maresia"] = "https://loja.maresiarp.com/?currency=BRL",
    ["Gaules"] = "https://lojagaules.santagroup.gg/",
    ["Fronteira"] = "https://fronteiraroleplay.hydrus.gg/",
    ["Alexandria"] = "https://loja.alexandriarp.com/",
}

local discordURL = {
    ["Santa"] = "https://discord.gg/cidadesanta",
    ["Galaxy"] = "https://discord.gg/galaxy-rp",
    ["Universo"] = "https://discord.gg/universorp",
    ["CidadeNobre"] = "https://discord.gg/cidadenobre",
    ["Boomerang"] = "https://discord.gg/boomerang-rp",
    ["Malta"] = "https://discord.gg/malta-rp",
    ["Kingdom"] = "https://discord.gg/kngestate",
    ["Imperium"] = "https://discord.gg/imperium",
    ["GoatRP"] = "https://discord.gg/goatrp",
    ["Royal"] = "https://discord.gg/royaluk",
    ["District99"] = "https://discord.gg/d-99",
    ["Krown"] = "https://discord.gg/krownrp",
    ["Orizon"] = "https://discord.gg/taaGvEtbMv",
    ["Liberty99"] = "https://discord.gg/l99",
    ["Real"] = "https://discord.gg/realrp",
    ["Grande"] = "https://discord.gg/granderp",
    ["Prime"] = "https://discord.gg/ciudadprime",
    ["Maresia"] = "https://discord.gg/cidademaresia",
    ["Gaules"] = "https://discord.gg/",
    ["Fronteira"] = "https://discord.gg/fronteiraroleplay",
    ["Alexandria"] = "https://discord.gg/alexandria-rp",
}


RegisterNetEvent("player:OpenURL")
AddEventHandler("player:OpenURL",function(url)
    print(url)
    SendNUIMessage({ url = url })
end)

RegisterNetEvent("player:MarkWayPoint")
AddEventHandler("player:MarkWayPoint",function(Coords)
    -- TriggerEvent("talknpc:closeTalk")
    SetNewWaypoint(Coords["x"] + 0.0001,Coords["y"] + 0.0001)
    Wait(500)
    ExecuteCommand("Map")
end)

RegisterCommandLocalized("command.vipstore",function(source,args)
    TriggerServerEvent("player:EnterLojaVip")
    SendNUIMessage({ url = StoreURL[cityName] })
end)

RegisterCommandLocalized("command.community",function(source,args)
    SendNUIMessage({ url = "https://discord.gg/santagroup" })
end)

RegisterCommand("discord",function(source,args)
    SendNUIMessage({ url = discordURL[cityName] })
end)

RegisterNUICallback("getCityName",function(Data,Callback)
    cityName = GetConvar("cityName", "")
    Callback(string.lower(cityName))
end)

function DrawText(x,y,z,text,color)
    local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)
    
    if onScreen then
        if string.len(text) > 45 then
            text = string.sub(text,1,45).." ..."
        end
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringKeyboardDisplay(text)
        
        if color then
            SetTextColour(150,196,172,255)
        else
            SetTextColour(204,204,204,175)
        end
        SetTextScale(0.35,0.35)
        SetTextFont(4)
        SetTextCentre(1)
        EndTextCommandDisplayText(_x,_y)
       
        local width = string.len(text) / 300

        if color then
            DrawRect(_x,_y + 0.0125,width,0.03,162,124,219,200)
        else
            DrawRect(_x,_y + 0.0125,width,0.03,15,15,15,200)
        end
    end
end

-- local VIPObjects = {
--     `nikit0_vips_totem_01`,
--     `nikit0_vips_totem_02`,
-- }

-- CreateThread(function()
--     while true do
--         local Idle = 2500
--         for i=1,#VIPObjects do
--             local Ped = PlayerPedId()
--             local Coords = GetEntityCoords(Ped)
--             local Object = GetClosestObjectOfType(Coords["x"],Coords["y"],Coords["z"], 10.0, VIPObjects[i], false, false, false)
--             print(Object)
--             if Object then
--                 local ObjCoords = GetEntityCoords(Object)
--                 local Distance = #(Coords - ObjCoords)
--                 Idle = 1000
--                 if Distance <= 3.0 then
--                     DrawText(Coords["x"],Coords["y"],Coords["z"]+0.5,"PRESSIONE ~g~E~w~  PARA ABRIR A LOJA E APROVEITEM O CUPOM!",false)
--                     if IsControlJustPressed(0,38) then
--                         TriggerServerEvent("VIP:PROPS",i)
--                     end
--                 end
--             end
--         end
--         Wait(Idle)
--     end
-- end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CROUCH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("Crouch", _t("Crouch"), "keyboard", "LCONTROL")
local Crouch = false

local function forceStandFromCrouch()
    local ped = PlayerPedId()
    if GetPedStealthMovement(ped) then
        SetPedStealthMovement(ped, false, "DEFAULT_ACTION")
    end

    if not Crouch then
        return
    end

    ResetPedMovementClipset(ped, 0.25)
    ResetPedStrafeClipset(ped)
    Crouch = false
end

AddEventHandler("player:forceStand", forceStandFromCrouch)

RegisterCommand("Crouch",function()
    if LocalPlayer["state"]["minigame:active"] == "deathstatue" then return end
    DisableControlAction(0,36,true)
    
    local Ped = PlayerPedId()
    local PlayerId = PlayerId()
    if not LocalPlayer["state"]["Buttons"] and not IsPedInAnyVehicle(Ped) and GetEntityHealth(Ped) > 100 and not IsPedReloading(Ped) then
        -- Verifica se o jogador está correndo ou em alta velocidade (previne bug de movimento brusco)
        local IsSprinting = IsControlPressed(0, 21) or IsDisabledControlPressed(0, 21) -- Left Shift
        local PedSpeed = GetEntitySpeed(Ped)
        local SpeedKmh = PedSpeed * 3.6
        
        if not Crouch and (IsSprinting or SpeedKmh > 5.0) then
            local CurrentVelocity = GetEntityVelocity(Ped)
            local ReducedVelocity = vector3(CurrentVelocity.x * 0.3, CurrentVelocity.y * 0.3, CurrentVelocity.z)
            SetEntityVelocity(Ped, ReducedVelocity)
            
            Wait(50)
        end
        
        RequestAnimSet("move_ped_crouched")
        while not HasAnimSetLoaded("move_ped_crouched") do
            Wait(1)
        end
        
        if Crouch then
            ResetPedMovementClipset(Ped,0.25)
            ResetPedStrafeClipset(Ped)
            Crouch = false
        else
            SetPedUsingActionMode(Ped, false, -1, 0)
            SetPedMovementClipset(Ped,"move_ped_crouched",0.25)
            SetPedStrafeClipset(Ped,"move_ped_crouched_strafing")
            Crouch = true
        end
        
        CreateThread(function()
            while Crouch do
                DisablePlayerFiring(PlayerId,true)
                Wait(1)
            end
        end)
    end
end)


CreateThread(function()
    while true do
        Wait(15000)
        if LocalPlayer["state"]["Active"] then
            local WrongCoords = vector3(0,0,0)
            local Ped = PlayerPedId()
            local Coords = GetEntityCoords(Ped)
            local Distance = #(Coords - WrongCoords)
            if Distance <= 30.0 then
                TriggerEvent("admin:Teleport",vector3(-1607.34,-1054.58,13.02))
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
local InSpectate = false
local OldCoords = false
local Spectated = false
local LoadingNext = false
local IN_NOCLIP_BEFORCE_SPECTATE = false

function spectatePlayer(targetPed,target,Boolean)
    local playerPed = PlayerPedId()
    SetEntityVisible(playerPed, false, 0)
    SetEntityCollision(playerPed, false, false)
    SetEntityInvincible(playerPed, true)
    -- Wait(200)
    if targetPed == playerPed then
        -- Wait(500)
        targetPed = GetPlayerPed(target)
    end
    local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
    RequestCollisionAtCoord(targetx,targety,targetz)
    if not Boolean then
        Spectated = targetPed
    end
    LocalPlayer["state"]:set("SpectatePed",targetPed,true)
    FreezeEntityPosition(playerPed,true)
    NetworkSetInSpectatorMode(true, targetPed)
    LocalPlayer["state"]:set("Spectate",true,true)
end


RegisterKeyMapping("Next","Next Spectate","MOUSE_BUTTONANY","MOUSE_LEFT")
RegisterKeyMapping("Previous","Previous Spectate","MOUSE_BUTTONANY","MOUSE_RIGHT")

RegisterCommand("Next",function()
    if not InSpectate then
        return
    end
    -- print("Click Next")
    -- if not LoadingNext then
    LoadingNext = true
    vSERVER._Spectate("Next")
    --     LoadingNext = false
    -- else
    --     TriggerEvent("Notify","vermelho","Aguarde o carregamento",5000,"Spectate")
    -- end
end)

RegisterCommand("Previous",function()
    print("Click Previous")
    if not InSpectate then
        return
    end
    -- if not LoadingNext then
    --     LoadingNext = true
    vSERVER._Spectate("Previous")
    --     LoadingNext = false
    -- else
    --     TriggerEvent("Notify","vermelho","Aguarde o carregamento",5000,"Spectate")
    -- end
end)

local SPECTATE_Z_OFFSET_EXIT = 80.0

function CancelSpectate()
    local ped = PlayerPedId()
    local isInMatchmaking = exports.dashboard:GetStatusAffiliatesAgentMatchmakingTicket() ~= 'none'
    local wasInNoclip = IN_NOCLIP_BEFORCE_SPECTATE or vRP.ReturnNoClip()

    if not InSpectate then
        return
    end

    TriggerServerEvent("player:ExitSpectateServer")

    InSpectate = false
    Spectated = false
    LocalPlayer["state"]:set("SpectatePed", false, false)
    TriggerEvent("Notify:Text", "")

    if not isInMatchmaking then
        local returnCoords = OldCoords
        OldCoords = false

        if returnCoords then
            SetEntityCoords(ped, returnCoords.x, returnCoords.y, returnCoords.z, 0, 0, 0, false)
        end
    else
        OldCoords = false

        local position = GetEntityCoords(ped)

        SetEntityCoords(ped, position.x, position.y, position.z - SPECTATE_Z_OFFSET_EXIT, 0, 0, 0, false)
    end

    TriggerEvent("player:ExitSpectate")

    FreezeEntityPosition(ped, false)
    SetPlayerControl(PlayerId(), true, 0)

    if wasInNoclip then
        vRP.EnsureNoClipEnabled()
    else
        SetEntityCollision(ped, true, true)
        SetEntityInvincible(ped, false)
        SetEntityVisible(ped, true, false)
    end

    IN_NOCLIP_BEFORCE_SPECTATE = false
end

AddEventHandler("actions:Cancel",function()
    CancelSpectate()
end)

RegisterNetEvent('net.player.cancel_spectate', function()
    CancelSpectate()
end)


RegisterNetEvent("player:StartSpectate")
AddEventHandler("player:StartSpectate",function(Coords)
    InSpectate = true

    local pedId = PlayerPedId()

    local pedPos = GetEntityCoords( pedId )

    local differentLocation = OldCoords and #( OldCoords - pedPos ) > 3.0
    if differentLocation then

        --[[
            Dessa forma não se eu tiver spectando jogador
            e eu mudar para outro não mudar a coordenada
            de onde ele iniciou o spectate desde o primeiro
            player que ele spectou

            - @TkzDev
        ]]
        
        return
    end

    OldCoords = GetEntityCoords( pedId )
    -- while InSpectate do
    --     if Spectated then
    --         local Coords = GetEntityCoords(Spectated)
    --         SetEntityCoords(Ped, Coords.x + 30.0, Coords.y + 50.0, Coords.z + 99.0, 0, 0, 0, false)
    --     end
    --     Wait(1)
    -- end
end)

RegisterNetEvent("player:Spectate")
AddEventHandler("player:Spectate",function(playerServerId, Name, tgtCoords,Boolean, visibleTextName)
    IN_NOCLIP_BEFORCE_SPECTATE = vRP.ReturnNoClip()
    Spectated = false
    local localPlayerPed = PlayerPedId()
    TriggerEvent("Notify:Text","")
    -- Wait(100)
    if not Boolean then
        SetEntityCoords(localPlayerPed, tgtCoords.x, tgtCoords.y, tgtCoords.z + 99.0, 0, 0, 0, false)
    end
    local playerId = GetPlayerFromServerId(playerServerId)

    -- print('setting insible before player is found!')
    SetEntityVisible(localPlayerPed, false, 0)

    repeat
        Wait(0)
        playerId = GetPlayerFromServerId(playerServerId)
    until ((GetPlayerPed(playerId) > 0) and (playerId ~= -1))
    spectatePlayer(GetPlayerPed(playerId),playerId,Boolean)
    if visibleTextName then
        TriggerEvent("Notify:Text",Name)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:RESETSPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:ExitSpectate")
AddEventHandler("player:ExitSpectate",function()
    NetworkSetInSpectatorMode(false)
    LocalPlayer["state"]:set("Spectate",false,true)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:RESETSPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
local LastVDM = GetGameTimer()
local VDMCount = 0
-- AddEventHandler("entityDamaged", function(entity, attacker, weapon, damage)
--     if IsEntityAPed(entity) and attacker == PlayerPedId() then
--         if weapon == 0 or weapon == -1553120962 then
--             if IsPedInAnyVehicle(attackerPed, false) and GetPedInVehicleSeat(attackerPed, -1) then
--                 if GetGameTimer() - LastVDM < 60000 then
--                     VDMCount = VDMCount + 1
--                 else
--                     VDMCount = 0
--                 end
--                 LastVDM = GetGameTimer()
--                 if VDMCount == 5 then
--                     TriggerServerEvent("nova_antivdm:warn")
--                 end
--             end
--         end
--     end
-- end)

---@param vehicleId number
---@param doorId    number
---@return boolean
local function IsVehicleDoorShut( vehicleId, doorId )

    local doorAngleRatio = GetVehicleDoorAngleRatio( vehicleId, doorId )

    local isShut = doorAngleRatio <= 0.0

    return isShut
end

---@param vehicleId number
---@param doorId    number
---@param shut      boolean
---@return boolean
local function SetVehicleDoorShutState( vehicleId, doorId, shut )

    assert( GetIsDoorValid( vehicleId, doorId ), ( 'Invalid doorId=%d' ):format( doorId ) )

    if NetworkGetEntityOwner( vehicleId ) ~= PlayerId() then

        -- Somos o dono da entidade?

        return false
    end

    local isShut = IsVehicleDoorShut( vehicleId, doorId )

    if isShut ~= shut then

        -- O estado que queremos é diferente do atual?

        if shut then
            SetVehicleDoorShut( vehicleId, doorId, 0 )

        else
            SetVehicleDoorOpen( vehicleId, doorId, 0, 0 )
        end
    end

    if isShut == shut then

        print( ('Door shut state for vehicleId=%s already is %s.'):format( vehicleId, isShut ) )
    end

    -- print( ('Door shut state for vehicleId=%s is now %s.'):format( vehicleId, IsVehicleDoorShut( vehicleId, doorId ) ) )

    return true
end

---@param vehicleId number
---@return boolean
local function SetVehicleWindowState(vehicleId)

    local windowsIntact = false

    for i = 0, 3 do

        local windowIntact = IsVehicleWindowIntact( vehicleId, i )

        if not windowIntact then

            RollUpWindow( vehicleId, i )
            windowsIntact = true

        else

            RollDownWindow( vehicleId, i )

        end
        
    end

    if windowsIntact then

        sx.logger:debug( ('All windows for vehicleId=%s are already intact.'):format( vehicleId ) )

    end

    return true
end

---@param _doorId string -- "dynamic" envia parametros como string...
AddEventHandler(  'player.prepare_set_vehicle_door_shut_state_request', function( _doorId )

    local doorId = tonumber( _doorId )

    local vehicleId, vehicleNetworkId = vRP.VehicleList( 5.0 )

    if not vehicleId then
        return
    end

    if not GetIsDoorValid( vehicleId, doorId ) then
        return
    end

    local doorLock = GetVehicleDoorLockStatus( vehicleId )
    if doorLock >= 2 then return end

    local shut = not IsVehicleDoorShut( vehicleId, doorId )

    -- Tentar alterar o estado localmente antes de enviar um broadcast
    if SetVehicleDoorShutState( vehicleId, doorId, shut ) then
        return
    end

    local playersNearby = sx.client.spatial.findPlayersNearby( -1, -1 )

    TriggerServerEvent( 'net.player.request_set_vehicle_door_shut_state', vehicleNetworkId, doorId, shut, playersNearby )
end)

---@param vehicleNetworkId  number
---@param doorId    number
---@param shut              boolean
RegisterNetEvent( 'net.player.set_vehicle_door_shut_state', function( vehicleNetworkId, doorId, shut )

    local vehicleId = NetworkGetEntityFromNetworkId( vehicleNetworkId )

    if not DoesEntityExist( vehicleId ) then
        return
    end

    SetVehicleDoorShutState( vehicleId, doorId, shut )
end)

---@param vehicleNetworkId number
---@param doorId number
---@param shut boolean
RegisterNetEvent(  'net.player.set_vehicle_door_shut_state_request', function( vehicleNetworkId, doorId, shut )

    local doorId = tonumber( doorId )

    local vehicleId = NetworkGetEntityFromNetworkId( vehicleNetworkId )

    if not DoesEntityExist( vehicleId ) then
        return
    end

    if not GetIsDoorValid( vehicleId, doorId ) then
        return
    end

    -- Tentar alterar o estado localmente antes de enviar um broadcast
    if SetVehicleDoorShutState( vehicleId, doorId, shut ) then
        return
    end

    local playersNearby = sx.client.spatial.findPlayersNearby( -1, -1 )

    TriggerServerEvent( 'net.player.request_set_vehicle_door_shut_state', vehicleNetworkId, doorId, shut, playersNearby )
end)

AddEventHandler(  'player.prepare_set_vehicle_window_state_request', function( )

    local vehicleId, vehicleNetworkId = vRP.VehicleList( 5.0 )

    if not vehicleId then
        return
    end

    SetVehicleWindowState( vehicleId )

    local playersNearby = sx.client.spatial.findPlayersNearby( -1, -1 )

    TriggerServerEvent( 'net.player.request_set_vehicle_window_state_request', vehicleNetworkId, playersNearby )
end)

---@param vehicleNetworkId  number
RegisterNetEvent( 'net.player.set_vehicle_window_state', function( vehicleNetworkId )

    local vehicleId = NetworkGetEntityFromNetworkId( vehicleNetworkId )

    if not DoesEntityExist( vehicleId ) then
        return
    end

    SetVehicleWindowState( vehicleId )
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANCASH
-----------------------------------------------------------------------------------------------------------------------------------------
local CleanCashCoords = {
    vector3(40.46,3714.95,39.68),
}

CreateThread(function()
    local Table = {}
    for i=1, #CleanCashCoords do
        Table[i] = {
            CleanCashCoords[i].x,
            CleanCashCoords[i].y,
            CleanCashCoords[i].z,
            5.0,
            "E",
            _t("cleanCash"),
            _t("pressToOpen"),
        }
    end
    TriggerEvent("hoverfy:Insert",Table)
    while true do 
        local idle = 2500
        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)
        for i=1, #CleanCashCoords do
            local Distance = #(Coords - CleanCashCoords[i])
            local _,Ground = GetGroundZFor_3dCoord(CleanCashCoords[i].x,CleanCashCoords[i].y,CleanCashCoords[i].z)
            if Distance <= 50.0 then
                idle = 1
                DrawMarker(29,CleanCashCoords[i].x,CleanCashCoords[i].y,CleanCashCoords[i].z-0.10, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0,THEME.rgb.r, THEME.rgb.g, THEME.rgb.b, 100, 0, 0, 0, 1)
                DrawMarker(23, CleanCashCoords[i].x,CleanCashCoords[i].y, Ground + 0.03, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5,THEME.rgb.r, THEME.rgb.g, THEME.rgb.b, 100, 0, 0, 0, 0)
            end
            if Distance <= 5.0 then
                idle = 1
                if IsControlJustPressed(0,38) then
                    vSERVER.StartCleanCash()
                    LastCoord = Coords
                end
            end
        end
        Wait(idle)
    end
end)

-- local TesteN = false
-- RegisterNetEvent("getN")
-- AddEventHandler("getN",function(status)
--     local ped = PlayerPedId()
--     if status then
--         TesteN = true
--         LocalPlayer["state"]["Novato"] = true
--     else
--         LocalPlayer["state"]["Novato"] = false
--         TesteN = false
--     end
-- end)

-- CreateThread(function()
--     while true do
--         local Idle = 1000
--         if LocalPlayer["state"]["Route"] == 1 then
--             if TesteN then
--                 local Ped = PlayerPedId()
--                 Idle = 1
--                 SetPedConfigFlag(Ped, 186, true)
--                 DisableControlAction(0,140,true)
--                 SetCanPedEquipAllWeapons(Ped, false)
--                 DisablePlayerFiring(Ped,true)
--                 TriggerEvent("inventory:CleanWeapons")
--             end
--         end
--         Wait(Idle)
--     end
-- end)


function PointCameraAtPed(ped)
    -- Get the ped's position
    local pedPos = GetEntityCoords(ped)

    -- Create a camera and point it at the ped
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, true)

    -- Position the camera a certain distance away from the ped
    local camOffset = { x = 0.0, y = 2.5, z = 0.75 } -- Adjust these values as needed
    local camPos = {
        x = pedPos.x + camOffset.x,
        y = pedPos.y + camOffset.y,
        z = pedPos.z + camOffset.z
    }

    -- Point the camera towards the ped
    PointCamAtCoord(cam, pedPos.x, pedPos.y, pedPos.z)
end

Cam = {
	Active = nil,
	IsNaked = false,
	Sets = {
		-- [1] = offset, [2] = pointAt
		["default"] = {
			vector3(0.0, 2.2, 0.3),
			vector3(0.0, 0, -0.05),
		},
		["inheritance"] = {
			vec3(0, 0.8, 0.65),
			vec3(0, 0, 0.6),
		},
		["face"] = {
			vec3(0, 0.6, 0.65),
			vec3(0, 0, 0.6),
		},
		["head"] = {
			vec3(0, 0.8, 0.65),
			vec3(0, 0, 0.6),
		},
		["upper"] = {
			vector3(0, 1.6, 0.2),
			vector3(0, 0, 0.2),
		},
		["lower"] = {
			vector3(0, 1.38, -0.3),
			vector3(0, 0, -0.5),
		},
		["accessories"] = {
			vector3(0, 1.2, 0.55),
			vector3(0, 0, 0.5),
		},
	},
}

local isTalking = false
RegisterCommandLocalized("command.speaking",function(source,args)
    isTalking = not isTalking
    local Ped = PlayerPedId()
    if isTalking then
        --TriggerEvent("Notify","verde","Ativou blip de voz",8000,"Fala")
        TriggerEvent("Notify2","#blipVoz")
        CreateThread(function()
            while isTalking do
                local Players = GetActivePlayers()
                for i=1,#Players do
                    local SelectedPlayer = Players[i]
                    if NetworkIsPlayerTalking(SelectedPlayer) then
                        local PlayerPed = GetPlayerPed(SelectedPlayer)
                        local Coords = GetEntityCoords(PlayerPed)
                        local Distance = #(GetEntityCoords(Ped) - Coords)
                        if Distance <= 20 then
                            DrawMarker(23,Coords["x"],Coords["y"],Coords["z"] - 0.97,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,0.0,46,110,76,100,0,0,0,0)
                        end
                    end
                end
                Wait(1)
            end
        end)
    else
        --TriggerEvent("Notify","vermelho","Desativou blip de voz",8000,"Fala")
        TriggerEvent("Notify2","#blipOff")
    end
end)


local isLeaping = false
local dict = 'anim@sports@ballgame@handball@'

local function doLeap()
    lib.requestAnimDict(dict, 2000)
    TaskPlayAnim(cache.ped, dict, 'ball_rstop_r_slide', 8.0, 8.0, -1, 2, 0, false, false, false)
    local Tackle = {}
    local Coords = GetEntityForwardVector(cache.ped)
    print("doLeap")	
    for _,v in ipairs(GetPlayers()) do
        local TargetPed = GetPlayerPed(v)
        print("[Tackle] - PED ",TargetPed,cache.ped)
        if TargetPed ~= cache.ped then
            local TargetCoords = GetEntityCoords(TargetPed)
            local Distance = #(GetEntityCoords(cache.ped) - TargetCoords)
            print("[Tackle Distance] - ",Distance)
            if Distance <= 5.0 then
                TriggerEvent("inventory:Cancel")
                TriggerServerEvent("tackle:Update",GetPlayerServerId(v),Coords)
                print("[Tackle] - ",GetPlayerServerId(v))
            end
        end
    end
    Wait(GetAnimDuration(dict, 'ball_rstop_r_slide') * 1000)
    TaskPlayAnim(cache.ped, dict, 'ball_get_up', 8.0, 8.0, -1, 01, 0, false, false, false)
    Wait(GetAnimDuration(dict, 'ball_get_up') * 500)
    StopAnimTask(cache.ped, dict, 'ball_get_up', 1.0)
    RemoveAnimDict(dict)
    isLeaping = false
end

lib.addKeybind({
    name = 'doleap',
    description = 'Yeeeeeeeeeeet',
    defaultKey = 'E',
    onPressed = function()

        if LocalPlayer["state"]["snowball:match"] then 
            return
        end

        if LocalPlayer["state"]["minigame:active"] then
            return
        end

        if cache.vehicle then return end
        -- SHIFT + E
        if IsControlPressed(1, 21) and not isLeaping and LocalPlayer["state"]["Policia"] then
            isLeaping = true
            doLeap()
        end
    end,
})


RegisterCommand("testwheel",function(source,args)
    TriggerEvent("rewardsAnimation","wheelTicket",60*30)
end)	

RegisterCommand('me', function( source, args, raw )

    if not ConsumeMeCooldown( 0 ) then
        return
    end

    local message = table.concat( args, ' ' )

    local isValid, validationError = ValidateMeMessage( message )

    if not isValid then

        if validationError then

            TriggerEvent( 'Notify', 'negado', validationError )
        end

        return
    end

    local targets = vRP.Players()

    -- Não enviar para o player local sem necessidade
    for i, target in ipairs( targets ) do

        if target == GetPlayerServerId( PlayerId() ) then

            table.remove( targets, i )

            break
        end
    end

    -- Só enviar para o servidor caso tenha outros jogadores proximos
    if #targets >= 1 then

        TriggerServerEvent( 'me:message', message, targets )
    end

    -- Mostrar a mensagem para o player local
    TriggerEvent( 'showme:pressMe', GetPlayerServerId( PlayerId() ), message )
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANCASH
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler('onResourceStart', function(resource)
    Wait(1500)
    if resource == "sleepless_interact" then
        StartInteractionCore(true)
    end
    
    if resource == GetCurrentResourceName() then
        StartInteractionCore()
    end
end)

local inBed = false
local HOSPITAL_BED_STATE_KEY = "hospitalBedId"
local HOSPITAL_BED_MODEL = joaat("v_med_bed2")
local currentHospitalBedEntity = nil
local interactionCoreInitialized = false
local hospitalBedDebugEnabled = false
local hospitalBedLastDecisionLogAt = 0
local hospitalBedLastDecisionKey = nil

local function hospitalBedDebugLog(message)
    if hospitalBedDebugEnabled then
        print(("[hospitalBeds] %s"):format(message))
    end
end

local function hospitalBedDebugDecision(key, message)
    if not hospitalBedDebugEnabled then
        return
    end

    local now = GetGameTimer()
    if hospitalBedLastDecisionKey ~= key or (now - hospitalBedLastDecisionLogAt) >= 750 then
        hospitalBedLastDecisionKey = key
        hospitalBedLastDecisionLogAt = now
        hospitalBedDebugLog(message)
    end
end

RegisterCommand("beddebug", function()
    hospitalBedDebugEnabled = not hospitalBedDebugEnabled

    print(("[hospitalBeds] Debug %s"):format(hospitalBedDebugEnabled and "ON" or "OFF"))

    if hospitalBedDebugEnabled then
        local currentBedId = LocalPlayer.state[HOSPITAL_BED_STATE_KEY]
        hospitalBedDebugLog(("Current local state: %s"):format(currentBedId or "nil"))
        hospitalBedDebugLog(("Interaction core initialized: %s"):format(interactionCoreInitialized and "true" or "false"))
    end
end)

local function quantizeBedCoord(value)
    return math.floor((value * 100.0) + 0.5) / 100.0
end

local function getHospitalBedId(entity)
    local coords = GetEntityCoords(entity)
    local model = GetEntityModel(entity)

    return string.format(
        "bed:%s:%.2f:%.2f:%.2f",
        model,
        quantizeBedCoord(coords.x),
        quantizeBedCoord(coords.y),
        quantizeBedCoord(coords.z)
    )
end

local function setCurrentHospitalBedState(bedId, bedEntity)
    currentHospitalBedEntity = bedEntity
    LocalPlayer.state:set(HOSPITAL_BED_STATE_KEY, bedId, true)
    hospitalBedDebugLog(("Set local state to %s"):format(bedId))
end

function clearCurrentHospitalBedState()
    currentHospitalBedEntity = nil

    if LocalPlayer.state[HOSPITAL_BED_STATE_KEY] ~= nil then
        hospitalBedDebugLog(("Clearing local state (%s)"):format(LocalPlayer.state[HOSPITAL_BED_STATE_KEY]))
        LocalPlayer.state:set(HOSPITAL_BED_STATE_KEY, nil, true)
    end
end

AddEventHandler('playerSpawned', function(resource)
    clearCurrentHospitalBedState()
end)

local function getCurrentHospitalBedEntity(ped, bedId)
    if currentHospitalBedEntity and DoesEntityExist(currentHospitalBedEntity) then
        if getHospitalBedId(currentHospitalBedEntity) == bedId then
            return currentHospitalBedEntity
        end
    end

    currentHospitalBedEntity = nil

    local pedCoords = GetEntityCoords(ped)
    local closestBed = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, 3.0, HOSPITAL_BED_MODEL, false, false, false)
    if closestBed ~= 0 and DoesEntityExist(closestBed) and getHospitalBedId(closestBed) == bedId then
        currentHospitalBedEntity = closestBed
        return closestBed
    end

    return nil
end

local function shouldClearHospitalBedState(ped)
    local currentBedId = LocalPlayer.state[HOSPITAL_BED_STATE_KEY]
    if not currentBedId then
        return false
    end

    if IsPedInAnyVehicle(ped, false) or IsEntityDead(ped) then
        hospitalBedDebugLog("Clearing local state because ped entered a vehicle or died")
        return true
    end

    local bedEntity = getCurrentHospitalBedEntity(ped, currentBedId)
    if not bedEntity then
        hospitalBedDebugLog("Clearing local state because tracked bed entity was not found")
        return true
    end

    local pedCoords = GetEntityCoords(ped)
    local bedCoords = GetEntityCoords(bedEntity)
    if #(pedCoords - bedCoords) > 2.2 then
        hospitalBedDebugLog(("Clearing local state because ped is too far from bed (%.2f)"):format(#(pedCoords - bedCoords)))
        return true
    end

    return false
end

CreateThread(function()
    while true do
        local waitTime = 3500
        if LocalPlayer.state[HOSPITAL_BED_STATE_KEY] ~= nil then
            waitTime = 1000

            local ped = PlayerPedId()
            if shouldClearHospitalBedState(ped) then
                clearCurrentHospitalBedState()
            end
        end

        Wait(waitTime)
    end
end)

local function isHospitalBedOccupied(entity, selfPed)
    local bedId = getHospitalBedId(entity)
    local objectCoords = GetEntityCoords(entity)
    local players = GetActivePlayers()

    for i = 1, #players do
        local playerIndex = players[i]
        local nearbyPed = GetPlayerPed(playerIndex)

        if nearbyPed ~= selfPed and nearbyPed > 0 and DoesEntityExist(nearbyPed) then
            local pedCoords = GetEntityCoords(nearbyPed)
            local dist = #(objectCoords - pedCoords)

            if dist <= 1.8 then
                local playerServerId = GetPlayerServerId(playerIndex)
                if playerServerId and playerServerId > 0 then
                    local playerObj = Player(playerServerId)
                    if playerObj and playerObj.state then
                        local occupiedBedId = playerObj.state[HOSPITAL_BED_STATE_KEY]
                        if occupiedBedId == bedId then
                            hospitalBedDebugLog(("Bed occupied by serverId=%s (dist=%.2f, bedId=%s)"):format(playerServerId, dist, bedId))
                            return true
                        end
                    end
                end
            end
        end
    end

    return false
end

local function canUseHospitalBed(entity)
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)
    local bedId = getHospitalBedId(entity)

    if LocalPlayer.state[HOSPITAL_BED_STATE_KEY] == bedId then
        local pedCoords = GetEntityCoords(ped)
        local bedCoords = GetEntityCoords(entity)
        if #(pedCoords - bedCoords) <= 2.2 then
            hospitalBedDebugDecision("blocked:same-bed:" .. bedId, ("Blocked interaction: same local bed state (%s)"):format(bedId))
            return false
        end
    end

    local bedInUse = isHospitalBedOccupied(entity, ped)
    if bedInUse then
        hospitalBedDebugDecision("blocked:occupied:" .. bedId, ("Blocked interaction: bed in use (%s)"):format(bedId))
    end

    if inBed ~= false then
        hospitalBedDebugDecision("blocked:inBed", ("Blocked interaction: inBed=%s"):format(tostring(inBed)))
    end

    if health <= 100 then
        hospitalBedDebugDecision("blocked:health", ("Blocked interaction: health=%s"):format(health))
    end

    local canUse = inBed == false and health > 100 and not bedInUse
    if canUse then
        hospitalBedDebugDecision("allowed:" .. bedId, ("Allowed interaction: health=%s inBed=%s bedInUse=%s bedId=%s"):format(health, tostring(inBed), tostring(bedInUse), bedId))
    end

    return canUse
end

function StartInteractionCore(force)
    if interactionCoreInitialized and not force then
        hospitalBedDebugLog("StartInteractionCore skipped (already initialized)")
        return
    end

    interactionCoreInitialized = true
    hospitalBedDebugLog(("StartInteractionCore running (force=%s)"):format(force and "true" or "false"))

    interact.addGlobalModel({
        id = "trashInteraction",
        models = {
            {model = -206690185, offset = vec3(0, 0, 1.0)},
            {model = 666561306, offset = vec3(0, 0, 1.0)},
            {model = 218085040, offset = vec3(0, 0, 1.0)},
            {model = -58485588, offset = vec3(0, 0, 1.0)},
            {model = 1511880420, offset = vec3(0, 0, 1.0)},
            {model = 682791951, offset = vec3(0, 0, 1.0)},
        },
        options = {
            {
                label = _t("enterBin"),
                icon = "trash",
                onSelect = function(data)
                    local Coords = GetEntityCoords(data.entity)
                    local Info = {
                        data.entity,
                        0,
                        0,
                        Coords,
                    }
                    Wait(100)
                    TriggerEvent("player:enterTrash",Info)
                end,
                canInteract = function(entity, distance, coords, id)
                    return inTrash == false
                        and not LocalPlayer.state['minigame:active']
                end
            },
            {
                label = _t("checkBin"),
                icon = "trash",
                onSelect = function( data )

                    TriggerEvent( "player.attempt_check_player_in_trash" )

                end,
                canInteract = function(entity, distance, coords, id)
                    return inTrash == false
                        and not LocalPlayer.state['minigame:active']
                end
            },
        },
        renderDistance = 5.0,
        activeDistance = 1.5,
        cooldown = 1500
    })
    interact.addGlobalModel({
        id = "hospitalBeds",
        models = {
            {model = "v_med_bed2", offset = vec3(0, 0, 0.35)},
            {model = 652832010, offset = vec3(0, 0, 1.0)},
        },
        options = {
            {
                label = _t("layDown"),
                icon = "bed",
                onSelect = function(data)
                    local ped = PlayerPedId()
                    local object = data.entity
                    setCurrentHospitalBedState(getHospitalBedId(object), object)
                    local objectcoords = GetEntityCoords(object)
                    SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
                    SetEntityHeading(ped, GetEntityHeading(object))
                    vRP.playAnim(false,{"amb@world_human_sunbathe@female@back@idle_a","idle_a"},true)
                end,
                canInteract = function(entity, distance, coords, id)
                    return canUseHospitalBed(entity)
                end
            },
            {
                label = _t("treatment"),
                icon = "bed",
                onSelect = function(data)
                    TriggerEvent("target:Treatment")
                    local ped = PlayerPedId()
                    local object = data.entity
                    setCurrentHospitalBedState(getHospitalBedId(object), object)
                    local objectcoords = GetEntityCoords(object)
                    SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
                    SetEntityHeading(ped, GetEntityHeading(object))
                    vRP.playAnim(false,{"amb@world_human_sunbathe@female@back@idle_a","idle_a"},true)
                end,
                canInteract = function(entity, distance, coords, id)
                    return canUseHospitalBed(entity)
                end
            },
        },
        renderDistance = 1.5,
        activeDistance = 1.0,
        cooldown = 1500
    })
    hospitalBedDebugLog("hospitalBeds interaction registered")
    interact.addGlobalModel({
        id = "atmInteraction",
        models = {
            {model = -1364697528, offset = vec3(0, 0, 1.0)},
            {model = -870868698, offset = vec3(0, 0, 1.0)},
            {model = -1126237515, offset = vec3(0, 0, 1.0)},
            {model = 506770882, offset = vec3(0, 0, 1.0)},
        },
        options = {
            {
                label = _t("atmAccess"),
                icon = "usd",
                onSelect = function(data)
                    TriggerEvent("target:OpenBank")
                end,
                canInteract = function(entity, distance, coords, id)
                    return true
                end
            },
            {
                label = _t("atmRobbery"),
                icon = "ban",
                onSelect = function(data)
                    local coords = GetEntityCoords(data.entity)
                    vSERVER.InitRobberyATM(coords)
                end,
                canInteract = function(entity, distance, coords, id)
                    return true
                end
            },
        },
        renderDistance = 5.0,
        activeDistance = 1.5,
        cooldown = 1500
    })
    local ChairsModels = {}
    for i=1,#configChairs do
        table.insert(ChairsModels,{model = configChairs[i], offset = vec3(0, 0, 0.5)})
    end
    interact.addGlobalModel({
        id = "chairsInteraction",
        models = ChairsModels,
        options = {
            {
                label = _t("sit"),
                icon = "fas fa-chair",
                onSelect = function(data)
                    local Coords = GetEntityCoords(data.entity)
                    TriggerEvent("keyText:open", "F6", _t("leaveChair"))
                    sit(data.entity, Coords)
                end,
                canInteract = function(entity, distance, coords, id)
                    if LocalPlayer.state['minigame:active'] or IsChairInteractionBlocked(entity) then
                        return false
                    end

                    return sitting == false
                end
            }
        },
        renderDistance = 2.5,
        activeDistance = 1.5,
        cooldown = 1500
    })
    interact.addGlobalModel({
        id = "sodaMachineInteraction",
        models = {
            {model = 992069095, offset = vec3(0, -0.4, 0.0)},
            {model = 1114264700, offset = vec3(0, -0.4, 0.0)},
        },
        options = {
            {
                label = _t("openSodaMachine"),
                icon = "glass",
                onSelect = function(data)
                    TriggerEvent("shops:sodaMachine")
                end,
                canInteract = function(entity, distance, coords, id)
                    return true
                end
            }
        },
        renderDistance = 2.0,
        activeDistance = 1.3,
        cooldown = 1500
    })
    interact.addGlobalModel({
        id = "CoffeeMachine",
        models = {
            {model = 690372739, offset = vec3(0, -0.2, 1.0)}
        },
        options = {
            {
                label = _t("buy"),
                icon = "glass",
                onSelect = function(data)
                    TriggerEvent("shops:coffeeMachine")
                end,
                canInteract = function(entity, distance, coords, id)
                    return true
                end
            }
        },
        renderDistance = 2.0,
        activeDistance = 1.3,
        cooldown = 1500
    })
end

CreateThread(function()
    Wait(2500)

    if not interactionCoreInitialized then
        StartInteractionCore()
        hospitalBedDebugLog("Fallback StartInteractionCore executed")
    end
end)

function sit(entity,newCoords)
    local playerPed = PlayerPedId()
    local entityCoords = GetEntityCoords(entity)
    local name = GetEntityArchetypeName(entity)
    local heading = GetEntityHeading(entity) + 180.0

    if string.find(name, "bench") then
        entityCoords = newCoords
    end

    local offset = gChairSitOffsets[ name ]

    if offset then
        entityCoords = GetOffsetFromEntityInWorldCoords( entity, offset.x, offset.y, offset.z )
    end

    if name == "prop_table_01_chr_b" then heading += 90 end
    
    TaskStartScenarioAtPosition(playerPed, "PROP_HUMAN_SEAT_BENCH", entityCoords.x, entityCoords.y, entityCoords.z + 0.38, heading, 0, true, true)
    sitting = true
end

RegisterKeyMapping('sit:stand_up_x', 'Stand Up X', 'keyboard', "X")
RegisterKeyMapping('sit:stand_up_space', 'Stand Up SPACE', 'keyboard', "SPACE")

RegisterCommand('sit:stand_up_x', function() standUp() end)
RegisterCommand('sit:stand_up_space', function() standUp() end)

function standUp()
	if sitting then
		sitting = false
		ClearPedTasks(PlayerPedId())
		if attachedEntity ~= nil then
			DetachEntity(PlayerPedId(), true, false)
			attachedEntity = nil
		end
	end
end

AddEventHandler("actions:Cancel",function()
    clearCurrentHospitalBedState()
    if sitting then
        standUp()
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        clearCurrentHospitalBedState()
    end
end)

function ApplyTaserEffect()
    local playerPed = PlayerPedId()
    SetPedCanRagdoll(playerPed, true)
    SetPedToRagdoll(playerPed, 5000, 5000, 0, true, true, false)
    Wait(7500)
    SetPedCanRagdoll(playerPed, false)
end

AddEventHandler('gameEventTriggered', function(event, args)
    if event == "CEventNetworkEntityDamage" then
        local weaponHash = args[7]

        if weaponHash ~= `WEAPON_STUNGUN` then
            return
        end

        local playerPed = PlayerPedId()
        local attacker = args[2]

        if playerPed == args[1] and attacker ~= -1 then
            ApplyTaserEffect()
        end
    end
end)

local musicCommands = {
    "music",
    "sound",
}
for i=1,#musicCommands do
    RegisterCommand(musicCommands[i],function()
        ExecuteCommand("som")
    end)
end

local voiceState = false
RegisterCommand("vervozes", function()
	voiceState = not voiceState
	if voiceState then
		CreateThread(function() 
			while voiceState do
				local myCoords = GetEntityCoords(PlayerPedId())
				for k,v in pairs(GetActivePlayers()) do
					if MumbleIsPlayerTalking(v) then
						local ped = GetPlayerPed(v)
						local distance = #(myCoords - GetEntityCoords(ped))
						if distance > 15.0 then
							print(("[^2%s^7] %s | src: %s | dist: %.2f "):format(GetPlayerName(v), GetPlayerServerId(v), distance))
						end
					end
				end
				Wait(1000)
			end
		end)
	end
end, false)

AddEventHandler("actions:Cancel", function()
    TriggerEvent("keyText:remove")
end)

-- Helper function to convert camera rotation to direction vector
local function RotationToDirection(rotation)
    local adjustedRotation = vector3(
        math.rad(rotation.x), 
        math.rad(rotation.y), 
        math.rad(rotation.z)
    )
    
    local direction = vector3(
        -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        math.sin(adjustedRotation.x)
    )
    
    return direction
end

local gCanSkydive = false

local gTaskedSkydiveFallAt = 0
local gHasSkydiveFall = false
local gStoppingSkydiveFall = false
local gIsSkydiving = false

local function CleanupSkydive()

    local pedId = PlayerPedId()

    SetPlayerInvincible( pedId, false )

    print( 'stopped skydiving!' )
end

RegisterNetEvent( 'net.toggle_can_skydive', function()

    gCanSkydive = not gCanSkydive

    print( ( 'toggle_can_skydive -> gCanSkydive: %s' ):format( gCanSkydive ) )

    if not gCanSkydive then

        CleanupSkydive()
    end
end)


RegisterNetEvent('net.disable_skydive', function()
    gCanSkydive = false
    CleanupSkydive()
end)

-- @type nil | 'jump_to_skydive' | 'skydiving'
-- local gSkydivingState = nil 

CreateThread(
    function()
        while true do

            Wait(0)

            if gCanSkydive then

                local pedId = PlayerPedId()

                if not gIsSkydiving then

                    gIsSkydiving = ( not gHasSkydiveFall ) and IsPedInParachuteFreeFall( pedId )

                    if gIsSkydiving then

                        SetPlayerInvincible( pedId, true )

                        print( 'started skydiving!' )
                    end
                else
                    gIsSkydiving = IsPedInParachuteFreeFall( pedId )

                    if not gIsSkydiving then

                        CleanupSkydive()
                    end
                end

                -- Parachute handling
                if IsPedFalling(pedId) and not GetIsPedGadgetEquipped(pedId, `GADGET_PARACHUTE`) then

                    GiveWeaponToPed(pedId, `GADGET_PARACHUTE`, 0, true, true)
                    SetPedGadget(pedId, `GADGET_PARACHUTE`, true)

                    -- print( 'give parachute!' )
                end

                -- Hide parachute component
                SetPedComponentVariation(pedId, 5, 0)

                if IsControlJustPressed( 0, 22 ) and not IsPedInParachuteFreeFall( pedId ) and not gHasSkydiveFall then

                    local pedFwd = GetEntityForwardVector( pedId )

                    local skydiveFallSpeed = 50.0

                    SetEntityVelocity( pedId, vector3( pedFwd.x * ( skydiveFallSpeed / 2 ), pedFwd.y * ( skydiveFallSpeed / 2 ), 1 * 50.0 ) )

                    TaskSkyDive( pedId )

                    gHasSkydiveFall      = true
                    gTaskedSkydiveFallAt = GetGameTimer()

                    -- print( 'sky dive tasked!' )
                end

                if gHasSkydiveFall then

                    local isFalling = IsPedFalling(pedId)

                    if      not gStoppingSkydiveFall and     isFalling then

                        gStoppingSkydiveFall = true

                        -- print( 'sky dive fall stopping!' )

                    elseif      gStoppingSkydiveFall and not isFalling and GetGameTimer() - gTaskedSkydiveFallAt > 1000 then

                        gStoppingSkydiveFall = false

                        gHasSkydiveFall = false

                        -- print( 'sky dive fall stopped!' )
                    end
                end


                local wishSpeed = 50.0
                local wishVelocity = vector3( 0.0, 0.0, 0.0 )
                -- local maxSpeed = 50.0
                
                -- Get camera rotation and convert to direction
                local camRot = GetGameplayCamRot( 2 )
                local camDir = RotationToDirection( camRot )

                if gIsSkydiving then

                    -- 144	INPUT_PARACHUTE_DEPLOY	F / LEFT MOUSE BUTTON	Y
                    DisableControlAction( 0, 144, true )

                    -- Handle sprint
                    if IsDisabledControlPressed(0, 21) then -- Left Shift

                        wishSpeed *= 2
                        -- maxSpeed = 75.0
                    end
                    
                    -- Forward movement (W)
                    if IsDisabledControlPressed(0, 32) then

                        wishVelocity += camDir * wishSpeed
                    end

                    -- Backward movement (S)
                    if IsDisabledControlPressed(0, 33) then

                        wishVelocity -= camDir * wishSpeed
                    end
                end

                -- local isIdle = #wishVelocity <= 0.1

                -- if      not isIdle then

                    local rotX = math.deg( math.asin( camDir.z ) )
                    local rotZ = math.deg( math.atan2( -camDir.x, camDir.y ) )

                    local rot = vector3( rotX + 20.0, 0.0, rotZ )

                    -- print( ('rot.x= %0.2f, rot.z= %0.2f'):format( rot.x, rot.z ) )

                -- elseif  isIdle then

                --     vel = vector3( 0.0, 0.0, 0.0 )
                --     rot = vector3( 50.0, 0.0, rot.y )
                -- end

                if gHasSkydiveFall or gIsSkydiving then

                    SetEntityRotation( pedId, rot.x, 0.0, rot.z, 2, true)
                end

                if gIsSkydiving then

                    SetEntityVelocity( pedId, wishVelocity )
                end
            end
        end
    end
)

AddEventHandler( 'onResourceStop', function( resource )

    if resource == GetCurrentResourceName() and gIsSkydiving then

        local pedId = PlayerPedId()

        CleanupSkydive()
    end
end)


RegisterCommand("send_max_stats",function(source)
    Wait(100)
    TriggerServerEvent("send_max_stats")
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- MANSAOPERTO
-----------------------------------------------------------------------------------------------------------------------------------------
local mansaoPertoCD = 0
RegisterCommand("mansaoperto", function()
    if GetGameTimer() - mansaoPertoCD < 10000 then return end

    local ped = PlayerPedId()
    local playerCoords = GetEntityCoords(ped)

    local nearestDist = math.huge
    local nearestName = nil
    local nearestX, nearestY = 0, 0

    for i = 1, #Homes do
        local home = Homes[i]
        local zone = home["Zone"]

        if zone and #zone > 0 and string.find(home["Name"], "^Mansao") then
            local cx, cy = 0, 0
            for j = 1, #zone do
                cx = cx + zone[j].x
                cy = cy + zone[j].y
            end
            cx = cx / #zone
            cy = cy / #zone

            local dist = #(vector2(playerCoords.x, playerCoords.y) - vector2(cx, cy))

            if dist < nearestDist then
                nearestDist = dist
                nearestName = home["Name"]
                nearestX = cx
                nearestY = cy
            end
        end
    end

    if nearestName then
        mansaoPertoCD = GetGameTimer()
        local distFormatted = string.format("%.0f", nearestDist)
        TriggerEvent("Notify2", "#mansaoPerto", { msg = nearestName, msg2 = distFormatted })
        SetNewWaypoint(nearestX + 0.0001, nearestY + 0.0001)
    end
end)
