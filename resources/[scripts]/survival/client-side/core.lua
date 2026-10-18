-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPS = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("survival",Creative)
local Server = Tunnel.getInterface("survival")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Death = false
local DeathTimer = GlobalState["DeathTimer"]
local Cooldown = GetGameTimer()
cityName = GetConvar("cityName", "")
local VIP = false
local Admin = false
local Vip = {}
local CALLMEDIC_COOLDOWN = GetGameTimer()
MedicStart = false
local NuiFocus = false
local CallMedicPrice = 50000
local gKillPhraseDisplaying = false

AddEventHandler( "survival:KillPhraseDisplayState", function( displaying )
	gKillPhraseDisplaying = displaying
end)

---@param enableCinematicPresentation boolean
AddEventHandler( "survival:KillPhraseFinished", function( enableCinematicPresentation )
	if Death and enableCinematicPresentation then
		TriggerEvent( "survival:Open" )
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    Wait(5000)
    --print('oiii3')
    SendNUIMessage({ action = "ModalMedic", data = {text = _t("callMedicCust"):format(parseFormat(CallMedicPrice))} })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------

---@type number | nil
local gVIPDeathTimer = nil

RegisterNetEvent('vrp:update_vip_death_timer', function( timer )

    gVIPDeathTimer = timer
end)

---@param allowed boolean
local function SetDeathPlayerControlAllowed( allowed )

    assert( Death )

    local flags = 0
        | 1 << 8 --[[ SPC_LEAVE_CAMERA_CONTROL_ON ]]

    SetNuiFocus( not allowed, not allowed )
    SetPlayerControl( PlayerId(), allowed, flags )

    -- --print( ('SetDeathControlOverrideEnabled -> allowed=%s'):format( allowed ), debug.traceback() ) 
end

---@return boolean
local function IsDeathPlayerControlAllowed()

    return Death and IsPlayerControlOn( PlayerId() )
end

local function ToggleDeathPlayerControlAllowed()

    if GetEntityHealth( PlayerPedId() ) <= 100 then

        SetDeathPlayerControlAllowed( not IsDeathPlayerControlAllowed() )
    end
end

local ReplacePlayersId = {}
local ReplacePlayersIdText = {}
cityName = GetConvar("cityName", "")
CreateThread(function()
    Wait(100)
    if cityName == "CidadeNobre" then
        ReplacePlayersIdText = {
            [6] = 'Domn',
            [888] = 'VOVO',
            [38] = 'MARCOLA',
        }
    end
    if cityName == "Santa" then
        ReplacePlayersIdText = {
            [2] = 'Domn',
        }
    end
    if cityName == "District99" then
        ReplacePlayersIdText = {
            [3333] = 'ATL',
        }
    end
    --print("ReplacePlayersId: " .. json.encode(ReplacePlayersId))
end)

CreateThread(function()
    Wait(1000)
	while true do
		local TimeDistance = 999

		if LocalPlayer["state"]["Active"] and not  LocalPlayer["state"]["minigame:active"] then
			local Ped = PlayerPedId()
            local Health = GetEntityHealth(Ped)
			if Health <= 100 then
				if not Death then
					Death = true

					local Coords = GetEntityCoords(Ped)
					NetworkResurrectLocalPlayer(Coords,0.0)
                    -- TriggerEvent("player:remPlayerCarry")
                    -- TriggerEvent("player:remPlayerCarregar")
                    -- TriggerServerEvent("player:remPlayerCarry")
                    -- TriggerServerEvent("player:remPlayerCarregar")
					NetworkSetFriendlyFireOption(false)
					LocalPlayer["state"]["Invincible"] = true

                    exports.combatsystem:SetInCombat( eCombatReasons.DEATH )

                    if GetResourceState("target") == "started" then
						exports.target:StopTreatment()
					end

					SetEntityInvincible(Ped,true)
					SetEntityHealth(Ped,100)
                    if GetResourceState("lb-phone") == "started" then
                        exports["lb-phone"]:ToggleDisabled(true)
                    end

					if LocalPlayer["state"]["Route"] < 900000 then
						DeathTimer = GlobalState["DeathTimer"]
                        if LocalPlayer["state"]["Iniciante"] then
                            DeathTimer = 10
                            --TriggerEvent("Notify","azul","Putzz, você acabou desmaiando né? Fica tranquilo que cuidei das suas coisas! Tome mais cuidado da próxima vez e tente não se meter em encrencas.",28000,"Iniciante")
							TriggerEvent("Notify2","#deathWarning")
                        end

                        if gVIPDeathTimer then
                            DeathTimer = gVIPDeathTimer
                        end

						TriggerEvent("hud:RemoveHood")
						TriggerEvent("hud:ScubaRemove")
						TriggerEvent("radio:RadioClean")
						TriggerEvent("inventory:Cancel")
                        CreateThread(function()
                            -- delay para enviar que o player deve desequipar a arma (consultar antes de retirar)
                            Wait(500)
                            TriggerEvent("inventory:CleanWeapons")
                            TriggerEvent("inventory:preventWeapon",false)
                        end)
						TriggerServerEvent("paramedic:bloodDeath")

						TriggerServerEvent( 'net.inspect.resetInspect' )
                        
                        TriggerServerEvent("admin:server:addAccountEvent", "first.death")
                        exports['pma-voice']:overrideProximityCheck(function(player)
                            return false
                        end)
                        Vip = Server.GetUserVip()
					else
						DeathTimer = 5
					end

                    if LocalPlayer["state"]["WorldPVP"] then
                        DeathTimer = 10
                    end

                    if not gKillPhraseDisplaying and not LocalPlayer["state"]["minigame:active"] and not LocalPlayer["state"]["Arena"] and not LocalPlayer["state"]["FFA"] and not LocalPlayer["state"]["PVP"] and not LocalPlayer["state"]["WarSystemSpec"] and not LocalPlayer["state"]["Event"] and not LocalPlayer["state"]["1x1"] then
                        TriggerEvent("hud:Active",false)

                        SendNUIMessage({ action = "setVisible", data = true })
                        SetDeathPlayerControlAllowed( false )

                        if not MedicStart then
                            SendNUIMessage({ action = "CallMedic", data = {text = _t("callMedic"), color = {0,0,0,0.5}} })
                        end
                        SendNUIMessage({ action = "CallMedic", data = {text = _t("callMedic"), color = {0,0,0,0.5}} })
                        VIP = Server.GroupVIP()
                        --print('oiiii')
                        SendNUIMessage({ action = "ModalMedic", data = {text = _t("callMedicCust"):format(parseFormat(CallMedicPrice))} })


                        if GetResourceState("warsystem") == "started" then
                            local domination = exports["warsystem"]:CheckIfDomination() 
                            SendNUIMessage({
                                action = "DominationArea",
                                data = domination
                            })
                        end
                    end

					SetPedCanRagdoll(Ped, false)
					SetPedCanRagdollFromPlayerImpact(Ped, false)
					vRP.playAnim(false,{"misstrevor3_beatup","guard_beatup_exit_dockworker"},true)
					TriggerEvent("inventory:Close")
				else
					TimeDistance = 1
                    
                    if Health < 100 then
                        local Coords = GetEntityCoords(Ped)
                        NetworkResurrectLocalPlayer(Coords,0.0)
                    end

                    SetEntityHealth(Ped,100)
					SetPedCanRagdoll(Ped, false)
					SetPedCanRagdollFromPlayerImpact(Ped, false)

					if not IsEntityPlayingAnim(Ped,"misstrevor3_beatup","guard_beatup_exit_dockworker",3) and not IsPedInAnyVehicle(Ped) and not sx.player.attachment.hasAttachment( LOCALPLAYER_SOURCE ) then
						vRP.playAnim(false,{"misstrevor3_beatup","guard_beatup_exit_dockworker"},true)
					end
					
					if IsPedRagdoll(Ped) then
						ClearPedTasksImmediately(Ped)
						vRP.playAnim(false,{"misstrevor3_beatup","guard_beatup_exit_dockworker"},true)
					end

					if IsPedInAnyVehicle(Ped) then
						local Vehicle = GetVehiclePedIsUsing(Ped)
						if GetPedInVehicleSeat(Vehicle,-1) == Ped then
							SetVehicleEngineOn(Vehicle,false,true,true)
						end
					end
                    
                    if LocalPlayer["state"]["Arena"] then
                        TriggerEvent("arena:Death")
                    end

                    if LocalPlayer["state"]["FFA"] then
                        TriggerEvent("freeforall:Death")
                    end

                    if LocalPlayer["state"]["GunGame"] then
                        TriggerEvent("gungame:Death")
                    end

					if not LocalPlayer["state"]["Arena"] and LocalPlayer["state"]["Route"] > 900000 then
						TriggerEvent("arena:ResetStreek")
						TriggerEvent("arena:Respawn")
					end

					if GetGameTimer() >= Cooldown then
						Cooldown = GetGameTimer() + 1000

						local deathTimerType = type( DeathTimer )
						if deathTimerType ~= "number" then
							sx.logger:error( ( "[survival] DeathTimer must be a number before tick; got %s (%s)" ):format( deathTimerType, tostring( DeathTimer ) ) )
						end
						assert(
							deathTimerType == "number",
							( "[survival] DeathTimer must be a number before tick; got %s (%s)" ):format( deathTimerType, tostring( DeathTimer ) )
						)

						if DeathTimer > 0 then
							DeathTimer = DeathTimer - 1

							if LocalPlayer["state"]["Route"] < 900000 then
                                local KillerName = LocalPlayer["state"]["Name"]
                                local KillerID = LocalPlayer["state"]["Passport"]

                                local killer = Entity(Ped)["state"]["Killer"]

                                if killer then
                                    KillerName = killer[ 1 /* killerFullname */ ]
                                    KillerID   = killer[ 2 /* killerPassport */ ]
                                end

                                local customKillerID = exports.admin:GetCustomPassportLabel(KillerID)
                                if customKillerID then
                                    KillerID = customKillerID
                                end

                                local ListVIP = {}
                                local DeathTimerVips = sx.vipsystem.GetVipsScriptsConfig("vrp","death_timer")
                                for vipName, vipTimer in pairs(DeathTimerVips) do
                                    local CharVipTimer = gVIPDeathTimer
                                    if (not CharVipTimer) then
                                        ListVIP[vipName] = DeathTimer - (GlobalState["DeathTimer"] - vipTimer)
                                    elseif ((CharVipTimer - vipTimer) >= vipTimer) then
                                        ListVIP[vipName] = DeathTimer - (GlobalState["DeathTimer"] - vipTimer)
                                    end
                                end

                                if DeathTimer <= 0 then
                                    ListVIP = {}

                                    SendNUIMessage({ action = "setVisible", data = true })
                                    SetDeathPlayerControlAllowed( false )

                                    if not MedicStart then
                                        SendNUIMessage({ action = "CallMedic", data = {text = _t("callMedic"), color = {0,0,0,0.5}} })
                                        -- --print("DeathTimer 2")
                                    end
                                    -- SetNuiFocus(true,true)
                                    NuiFocus = true
                                    if LocalPlayer["state"]["WorldPVP"] then
                                        Wait(1000)
                                        --TriggerServerEvent("WorldPVP:Spawn")
                                    end
                                    --print('oiii2')
                                    SendNUIMessage({ action = "ModalMedic", data = {text = _t("callMedicCust"):format(parseFormat(CallMedicPrice))} })
                                end

                                
                                SendNUIMessage({
                                    action = "Time",
                                    data = {
                                        name = KillerName,
                                        time = DeathTimer,
                                        id = KillerID,
                                        playerId = LocalPlayer["state"]["Passport"] or 0,
                                        list = ListVIP
                                    }
                                })
							end
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)

local Locations = {
	[_t("revive")] = vec3(1454.67,6596.19,20.17)
}
if cityName == "Santa" then
    Locations = {
        -- ["Pier"] = vec3(-1643.64,-1010.26,13.01),
        -- ["Dp"] = vec3(2504.85,-384.38,94.12),
        [_t("revive")] = vec3(1454.67,6596.19,20.17)
    }
elseif cityName == "Maresia" then
    Locations = {
        -- ["Praça"] = vec3(162.4,-1003.25,29.35),
        -- ["HP"] = vec3(1153.89,-1520.65,34.83),
        -- ["DP"] = vec3(-923.26,-2068.12,9.4)
		[_t("revive")] = vec3(207.05,-960.36,29.76)
    }
elseif cityName == "Universo" then
    Locations = {
        -- ["Praça"] = vec3(162.4,-1003.25,29.35),
        -- ["HP"] = vec3(1153.89,-1520.65,34.83),
        -- ["DP"] = vec3(-923.26,-2068.12,9.4)
		[_t("revive")] = vec3(207.05,-960.36,29.76)
    }
elseif cityName == "Fronteira" then
    Locations = {
        -- ["Praça"] = vec3(162.4,-1003.25,29.35),
        -- ["HP"] = vec3(1153.89,-1520.65,34.83),
        [_t("revive")] = vec3(207.05,-960.36,29.76)
    }
elseif cityName == "Alexandria" then
    Locations = {
        -- ["Praça"] = vec3(162.4,-1003.25,29.35),
        -- ["HP"] = vec3(1153.89,-1520.65,34.83),
        [_t("revive")] = vec3(207.05,-960.36,29.76)
    }
elseif cityName == "Kingdom" then
    Locations = {
        [_t("revive")] = vec3(170.54,-996.21,30.53)
    }
elseif cityName == "Imperium" then
    Locations = {
        [_t("revive")] = vec3(170.54,-996.21,30.53)
    }
elseif cityName == "GoatRP" then
    Locations = {
        [_t("revive")] = vec3(170.54,-996.21,30.53)
    }
elseif cityName == "District99" then
    Locations = {
        [_t("revive")] = vec3(170.54,-996.21,30.53)
    }
elseif cityName == "Krown" then
    Locations = {
        [_t("revive")] = vec3(170.54,-996.21,30.53)
    }
elseif cityName == "Orizon" then
    Locations = {
        [_t("revive")] = vec3(170.54,-996.21,30.53)
    }
elseif cityName == "Liberty99" then
    Locations = {
        [_t("revive")] = vec3(170.54,-996.21,30.53)
    }
elseif cityName == "Royal" then
    Locations = {
        [_t("revive")] = vec3(170.54,-996.21,30.53)
    }
elseif cityName == "Malta" then
    Locations = {
        [_t("revive")] = vec3(-313.91,-604.97,32.77)
    }
elseif cityName == "Real" then
    Locations = {
        [_t("revive")] = vec3(154.66,-981.46,30.58)
    }
elseif cityName == "Prime" then
    Locations = {
        [_t("revive")] = vec3(154.66,-981.46,30.58)
    }
end

function CallMedic()
    if not LocalPlayer["state"]["InX1"] then
        local Ped = PlayerPedId()
        local Health = GetEntityHealth(Ped)
        if Health <= 100 then
            --TriggerServerEvent("survival:CallMedic")
        end
    end
end
RegisterKeyMapping("callmedic", _t("callmedic"), "keyboard", "E")
RegisterCommand("callmedic",CallMedic)
RegisterNUICallback('Locations',function(Data,CallBack)
    local Callbuttons = {}
    VIP = Server.GroupVIP()
    for Index,v in pairs(Locations) do
        Callbuttons[#Callbuttons + 1] = { name = Index }
    end
	
	Callbuttons[#Callbuttons + 1] = { name = _t("faction"), vip = VIP }
    Callbuttons[#Callbuttons + 1] = { name = _t("custom"), vip = true }

    CallBack(Callbuttons)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CALLMEDIC
-----------------------------------------------------------------------------------------------------------------------------------------
local PlayerTextPattern = _t("waitMedic")
function FormatTextDistance(Name,Distance)
    local Text = Name
    if Distance then
        Text = string.format(PlayerTextPattern,Name,parseInt(Distance))
    end
    return Text
end

local MedicName = ""
local MedicDistance = 999
local MedicCoords = vec3(0.0, 0.0, 0.0)
local MedicBlip = nil
RegisterNetEvent("survival:CallMedicStart")
AddEventHandler("survival:CallMedicStart",function(Name,Distance)
    MedicName = Name
    MedicDistance = Distance
    MedicStart = true
    -- --print("survival:CallMedicStart: "..Name.." "..Distance)
    local Ped = PlayerPedId()
    CreateThread(function()
        while MedicStart do
            local Health = GetEntityHealth(Ped)
            if Health > 100 then
                MedicName = ""
                MedicDistance = 999
                TriggerEvent("Notify:Text","")
                MedicStart = false
            else
                TriggerEvent("survival:AcceptCallMedic",FormatTextDistance(MedicName,MedicDistance),{0, 175, 47, 0.5})
            end
            -- --print(tostring(MedicStart).." "..MedicDistance.." "..MedicName)
            Wait(1000)
        end
    end)
end)

RegisterNetEvent("survival:StopCallMedic")
AddEventHandler("survival:StopCallMedic",function()
    MedicStart = false
    MedicName = ""
    MedicDistance = 999
    MedicCoords = vec3(0.0, 0.0, 0.0)

    if MedicBlip and DoesBlipExist(MedicBlip) then
        RemoveBlip(MedicBlip)
    end

    MedicBlip = nil
    ClearGpsPlayerWaypoint()

    if GetEntityHealth(PlayerPedId()) > 100 then
        return SendNUIMessage({ action = "setVisible", data = false })
    end

    SendNUIMessage({ action = "CallMedic", data = {text = _t("callMedic"), color = {0,0,0,0.5}} })
end)

RegisterNetEvent("survival:CallMedicUpdate")
AddEventHandler("survival:CallMedicUpdate",function(Coords)
    local Distance = #(GetEntityCoords(PlayerPedId()) - Coords)

    MedicDistance = Distance
    MedicCoords = Coords

    if MedicBlip and DoesBlipExist(MedicBlip) then
        SetBlipCoords(MedicBlip, Coords.x, Coords.y, Coords.z)
        SetNewWaypoint(Coords.x, Coords.y)
    end
end)

RegisterNetEvent("survival:InitCallMedic")
AddEventHandler("survival:InitCallMedic",function(Text,Color)

    if MedicBlip and DoesBlipExist(MedicBlip) then
        RemoveBlip(MedicBlip)
        ClearGpsPlayerWaypoint()
    end

    MedicBlip = AddBlipForCoord(MedicCoords.x, MedicCoords.y, MedicCoords.z)
    SetBlipSprite(MedicBlip, 425)
    SetBlipAlpha(MedicBlip, 255)
    SetBlipScale(MedicBlip, 0.6)
    SetBlipColour(MedicBlip, 1)
    SetBlipDisplay(MedicBlip, 4)
    SetBlipFlashes(MedicBlip, true)
    SetBlipRoute(MedicBlip, true)
    SetBlipRouteColour(MedicBlip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("ATENDIMENTO MEDICO")
    EndTextCommandSetBlipName(MedicBlip)

    SendNUIMessage({ action = "CallPlayer", data = {text = Text, color = Color} })
end)

local MedicTextPattern = _t("medicDistance")
function FormatTextDistanceMedic(Name,Distance)
    local Text = Name
    if Distance then
        Text = string.format(MedicTextPattern,Name,parseInt(Distance))
    end
    return Text
end

local function onShowInteractionMarker()
    CreateThread(function()
        while MedicStart do
            local msec = 1000

            if MedicDistance <= 60.0 then
                DrawMarker(2, MedicCoords.x, MedicCoords.y, MedicCoords.z, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)  
                msec = 5
            end

            Wait(msec)
        end
    end)
end

local RGBMedic = {190, 0, 0,0.5}
RegisterNetEvent("survival:CallPlayerStart")
AddEventHandler("survival:CallPlayerStart",function(Name,Distance)
    MedicName = Name
    MedicDistance = Distance
    MedicStart = true
    local Ped = PlayerPedId()

    onShowInteractionMarker()
    -- --print("survival:CallPlayerStart: NAME "..MedicDistance)
    CreateThread(function()
        while MedicStart do
            -- --print("survival:CallPlayerStart: 2  "..MedicDistance)
            if MedicDistance >= 500 then
                RGBMedic = {190, 0, 0,0.5}
            elseif MedicDistance >= 250 and MedicDistance < 500 then
                RGBMedic = {255,255,102,0.5}
            elseif MedicDistance <= 100 then
                RGBMedic = {0, 175, 47, 0.5}
            end
            TriggerEvent("survival:InitCallMedic",FormatTextDistanceMedic(MedicName,MedicDistance),RGBMedic)

            if MedicDistance <= 5 then
                -- MedicStart = false
                -- SendNUIMessage({ action = "setVisible", data = false })
                -- SetDeathPlayerControlAllowed( true )
            end
            Wait(1000)
        end
    end)
end)



local CooldownKeypress = GetGameTimer()

RegisterNUICallback("keyPress",function(Data,Callback)

    Callback({ ok = true })

    ToggleDeathPlayerControlAllowed()
end)

RegisterCommand("survivalfocus",function()

    ToggleDeathPlayerControlAllowed()
end)

RegisterKeyMapping("survivalfocus", "Focus NUI.", "keyboard", "F2")
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("handleF5",function(Data,Callback)
    
end)
RegisterNUICallback("Spawn",function(Data,Callback)
    --print("[SPAWN-DEBUG] NUI Spawn recebido | Data =", tostring(Data), "| tipo =", type(Data))
    --print("[SPAWN-DEBUG] CustomSpawn state =", tostring(LocalPlayer["state"]["CustomSpawn"]))
    --print("[SPAWN-DEBUG] VIP =", tostring(VIP), "| WorldPVP =", tostring(LocalPlayer["state"]["WorldPVP"]), "| Inspect =", tostring(LocalPlayer["state"]["Inspect"]))
    --print("[SPAWN-DEBUG] CALLMEDIC_COOLDOWN =", tostring(CALLMEDIC_COOLDOWN), "| GameTimer =", tostring(GetGameTimer()))

    if CALLMEDIC_COOLDOWN > GetGameTimer() then
        --print("[SPAWN-DEBUG] Bloqueado: cooldown médico ativo, restam", parseInt((CALLMEDIC_COOLDOWN - GetGameTimer()) / 1000), "s")
        TriggerEvent("Notify2","#chamouMedico",{msg=parseInt((CALLMEDIC_COOLDOWN - GetGameTimer()) / 1000)})
        return
    end
    if (Data == _t("faction")) and (not VIP) then
        --print("[SPAWN-DEBUG] Bloqueado: Data == faction mas sem VIP")
        return
    end

    local isCustomSpawn = Data == "Custom" or Data == _t("custom")
    if isCustomSpawn and not LocalPlayer["state"]["CustomSpawn"] then
        --print("[SPAWN-DEBUG] Bloqueado: spawn Custom sem CustomSpawn setado")
        return
    end

    if IsEntityAttached(PlayerPedId()) then
        --print("[SPAWN-DEBUG] Bloqueado: jogador está attached a entidade")
        TriggerEvent("Notify2","#dont_spawn_while_attached")
        return
    end

    if LocalPlayer["state"]["Inspect"] then
        --print("[SPAWN-DEBUG] Bloqueado: jogador está sendo inspecionado")
        TriggerEvent("Notify2","#naoPodeMexer")
        return
    end

    if LocalPlayer["state"]["WorldPVP"] then
        --print("[SPAWN-DEBUG] Redirecionado para WorldPVP:Spawn")
        TriggerServerEvent("WorldPVP:Spawn")
        return
    end

	if (Data == _t("faction")) then
        --print("[SPAWN-DEBUG] Chamando Server.GG2() — spawn Facção | _t(faction) =", _t("faction"))
        Server.GG2()
    elseif isCustomSpawn then
        --print("[SPAWN-DEBUG] Chamando Server.GG2(true) — spawn Custom | CustomSpawn =", tostring(LocalPlayer["state"]["CustomSpawn"]))
		Server.GG2(true)
    else
        --print("[SPAWN-DEBUG] Chamando vRPS.GG(Data) — spawn padrão | Data =", tostring(Data))
		vRPS.GG(Data)
	end

	Callback("Ok")
end)

---@type table | nil
local gSquads = nil

RegisterNetEvent( 'painel:update_player_squads', function( squads )

    gSquads = squads
end)

function PlayerSquads()
    local Timer = false
    if gSquads then
        if #gSquads > 1 then
            for Group,Time in pairs(gSquads) do
                if GlobalState["SquadsDT"][Group] then
                    Timer = GlobalState["SquadsDT"][Group] 
                end
            end
        end
    end
    return Timer
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKDEATH
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckDeath()
	if Death and DeathTimer >= 0 then
		return DeathTimer
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETSECONDS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ResetSeconds()
	DeathTimer = 60
end

local RiskArea = {
    ["Santa"] = {
        
    },
    ["Grande"] = {
        
    },
	["Galaxy"] = {
		{vec3(1215.54,-288.4,68.16),"Barragem"}, -- Barragem
		{vec3(1906.09,512.37,172.58),"Amarelos"}, -- Amarelos
		{vec3(-646.77,-1635.13,24.97),"Overdrive"}, -- Overdrive
		{vec3(1301.08,1424.76,103.86),"Gang9"}, -- Gang9
		{vec3(2567.52,2748.36,42.6),"Sindicato"}, -- Sindicato
		{vec3(1117.26,3515.41,34.96),"Umbrella"}, -- Umbrella
		{vec3(2092.03,3862.58,33.58),"Verdes"}, -- Verdes
		{vec3(3053.95,5047.51,25.27),"China"}, -- China
		{vec3(1303.24,-717.78,64.8),"Brancos"}, -- Brancos
		{vec3(103.47,-1938.9,20.79),"Ballas"}, -- Ballas
		{vec3(306.44,-2016.92,19.7),"Vagos"}, -- Vagos
		{vec3(3416.14,3750.07,30.58),"Laranjas"}, -- Laranjas
		{vec3(-1888.62,2044.84,141.84),"Russia"}, -- Russia
		{vec3(-587.26,197.54,71.48),"Gang7"}, -- Gang7
		{vec3(918.3,48.78,81.13),"Bellagio"}, -- Bellagio
		-- {vec3(135.71,583.94,185.13),"Bahamas"}, -- Bahamas
		{vec3(124.22,577.21,183.26),"Galaxy"}, -- Galaxy
		{vec3(-293.59,234.77,88.46),"Luxor"}, -- Luxor
		{vec3(-174.51,-1669.87,33.8),"Groove"}, -- Groove
		{vec3(1360.42,-2017.6,51.37),"Redline"}, -- Redline
		{vec3(-252.6,-1305.52,32.22),"Bennys"}, -- Bennys
		{vec3(-1136.84,-1590.48,5.36),"DriftKing"}, -- DriftKing
		{vec3(-3012.87,105.05,11.66),"Gang2"}, -- Gang2
		{vec3(247.44,1178.42,225.5),"SonsofAnarchy"}, -- SonsofAnarchy
		{vec3(1021.31,907.35,213.49),"Gang8"}, -- Gang8
		{vec3(-2189.57,-287.63,34.76),"Gang5"}, -- Gang5
		{vec3(302.19,-2732.79,7.38),"Warlocks"}, -- Warlocks
		{vec3(-1559.76,-415.68,42.38),"Gang1"}, -- Gang1
		{vec3(-950.94,301.79,70.9),"Mercenarios"}, -- Mercenarios
		{vec3(-1547.86,349.98,87.25),"Franca"}, -- Franca
		{vec3(403.53,-1502.24,29.28),"Italia"}, -- Italia
		{vec3(96.98,3616.94,48.88),"Israel"}, -- Israel
		{vec3(-1487.15,877.85,182.89),"Mexico"}, -- Mexico
		{vec3(1068.39,-1898.45,31.64),"Gringa"}, -- Gringa
		{vec3(835.44,-2361.77,30.36),"TopGear"}, -- TopGear
		{vec3(-815.02,-2606.61,13.93),"Outlaws"}, -- Outlaws
		{vec3(2068.44,12.27,214.23),"Vermelhos"}, -- Vermelhos
		{vec3(-1471.22,64.77,53.19),"Playboy"}, -- Playboy
		{vec3(2459.93,5407.57,52.87),"sinaloa"}, -- sinaloa
		{vec3(1276.12,-1734.34,52.13),"LosAztecas"}, -- LosAztecas		
		{vec3(531.78,361.43,147.2),"Roxos"}, -- Roxos
		{vec3(2236.07,3275.31,47.68),"Cinzas"}, -- Cinzas
		{vec3(1756.79,6395.62,36.38),"Marrons"}, -- Marrons
		{vec3(1366.26,-2263.29,61.37),"Rosas"}, -- Rosas
		{vec3(-2756.25,2267.33,22.39),"Noxus"}, -- Noxus
		{vec3(2442.65,4975.51,46.81),"Hollywood"}, -- Hollywood
    },
	["Gaules"] = {
		{vec3(1215.54,-288.4,68.16),"Barragem"}, -- Barragem
		{vec3(1906.09,512.37,172.58),"Amarelos"}, -- Amarelos
		{vec3(2460.56,5404.99,54.0),"Overdrive"}, -- Overdrive
		{vec3(1301.08,1424.76,103.86),"Gang9"}, -- Gang9
		{vec3(2567.52,2748.36,42.6),"Sindicato"}, -- Sindicato
		{vec3(1117.26,3515.41,34.96),"Umbrella"}, -- Umbrella
		{vec3(2092.03,3862.58,33.58),"Verdes"}, -- Verdes
		{vec3(3053.95,5047.51,25.27),"China"}, -- China
		{vec3(1303.24,-717.78,64.8),"Brancos"}, -- Brancos
		{vec3(103.47,-1938.9,20.79),"Ballas"}, -- Ballas
		{vec3(306.44,-2016.92,19.7),"Vagos"}, -- Vagos
		{vec3(3416.14,3750.07,30.58),"Laranjas"}, -- Laranjas
		{vec3(-1888.62,2044.84,141.84),"Russia"}, -- Russia
		{vec3(-587.26,197.54,71.48),"Gang7"}, -- Gang7
		{vec3(918.3,48.78,81.13),"Bellagio"}, -- Bellagio
		-- {vec3(-1381.02,-579.73,30.13),"Bahamas"}, -- Bahamas
		{vec3(-293.59,234.77,88.46),"Luxor"}, -- Luxor
		{vec3(-174.51,-1669.87,33.8),"Groove"}, -- Groove
		{vec3(1360.42,-2017.6,51.37),"Redline"}, -- Redline
		{vec3(-252.6,-1305.52,32.22),"Bennys"}, -- Bennys
		{vec3(-1136.84,-1590.48,5.36),"DriftKing"}, -- DriftKing
		{vec3(-2916.68,51.28,12.27),"Gang2"}, -- Gang2
		{vec3(247.44,1178.42,225.5),"SonsofAnarchy"}, -- SonsofAnarchy
		{vec3(995.53,-2458.23,28.63),"Gang8"}, -- Gang8
		{vec3(616.59,-2748.68,6.05),"Gang5"}, -- Gang5
		{vec3(302.19,-2732.79,7.38),"Warlocks"}, -- Warlocks
		{vec3(-1559.76,-415.68,42.38),"Gang1"}, -- Gang1
		{vec3(-2916.68,51.28,12.27),"Mercenarios"}, -- Mercenarios
		{vec3(-1805.61,457.11,128.28),"Franca"}, -- Franca
		{vec3(403.53,-1502.24,29.28),"Italia"}, -- Italia
		{vec3(96.98,3616.94,48.88),"Israel"}, -- Israel
		{vec3(-1487.15,877.85,182.89),"Mexico"}, -- Mexico
		{vec3(-1487.23,250.88,61.54),"Playboy"}, -- Playboy só santa
		{vec3(1068.39,-1898.45,31.64),"Gringa"}, -- Gringa
		{vec3(835.44,-2361.77,30.36),"TopGear"}, -- TopGear
		{vec3(-815.02,-2606.61,13.93),"Outlaws"}, -- Outlaws
		{vec3(2068.44,12.27,214.23),"Vermelhos"}, -- Vermelhos
		{vec3(1276.12,-1734.34,52.13),"LosAztecas"}, -- LosAztecas
		{vec3(531.41,2602.95,42.5),"Azuis"}, -- Azuis
		{vec3(531.78,361.43,147.2),"Roxos"}, -- Roxos
		{vec3(2236.07,3275.31,47.68),"Cinzas"}, -- Cinzas
		{vec3(1756.79,6395.62,36.38),"Marrons"}, -- Marrons
		{vec3(1366.26,-2263.29,61.37),"Rosas"}, -- Rosas
		{vec3(-2756.25,2267.33,22.39),"Noxus"}, -- Noxus
		{vec3(2442.65,4975.51,46.81),"Hollywood"}, -- Hollywood
    },
	["Fronteira"] = {
		
    },
	["Alexandria"] = {
		
    },
	["CidadeNobre"] = {
		
    },
    ["Malta"] = {
		
    },
    ["Krown"] = {
		
    },
    ["Kingdom"] = {
		
    },
    ["District99"] = {
		
    },
    ["Orizon"] = {
		
    },
    ["GoatRP"] = {
		
    },
    ["Royal"] = {
		
    },
    ["Real"] = {
		
    },
    ["Prime"] = {
		
    },
	["Universo"] = {
		
    },
	["Maresia"] = {
		
    },
	["Boomerang"] = {
		
    },
    ["Liberty99"] = {
        
    },
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- QG_SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    local Configs = exports["org_system"]:GetAllOfConfig("RISK_ZONES")
    for i=1,#Configs do
        local Config = Configs[i]
        for j=1,#Config do
            table.insert(RiskArea[cityName],Config[j])
        end
    end
end)

local Blips = {}
function MakeBlips(Facs)
    for k,v in pairs(Blips) do
        RemoveBlip(v)
    end
    for k,v in pairs(RiskArea[cityName]) do
		Blips[k] = AddBlipForCoord(v[1]["x"],v[1]["y"],v[1]["z"])
		SetBlipSprite(Blips[k],362)
        if not Facs[v[2]] then
		    SetBlipColour(Blips[k],2)
        else
		    SetBlipColour(Blips[k],1)
        end
		SetBlipScale(Blips[k],0.4)
        BeginTextCommandSetBlipName("STRING")
        if not Facs[v[2]] then
            AddTextComponentString(_t("gangFree"))
        else
            if type(Facs[v[2]]) == "string" then
                AddTextComponentString(Facs[v[2]])
            else
                AddTextComponentString(_t("activeFamily"))
            end
        end
        EndTextCommandSetBlipName(Blips[k])
        SetBlipAsShortRange(Blips[k],true)
	end
end

local BlipRadius = {}
local StartColor = 0
RegisterCommand("TestRadius",function(_,args)
    if args[1] and args[1] == "clear" then
        StartColor = 0
        for i=1,#BlipRadius do
            RemoveBlip(BlipRadius[i])
        end
    elseif args[2] and args[2] == "risk" then
        local SelectedCity = cityName
        if args[3] then
            SelectedCity = args[3]
        end
        if not RiskArea[SelectedCity][1] then
            return
        end
        for i=1,#RiskArea[SelectedCity][1] do
            local CacheBlip = AddBlipForRadius(RiskArea[SelectedCity][1][i],parseInt(args[1])+0.001)
            StartColor = StartColor + 1
            SetBlipAlpha(CacheBlip,100)
            SetBlipColour(CacheBlip,StartColor)
            table.insert(BlipRadius,CacheBlip)
        end
    else
        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)
        local CacheBlip = AddBlipForRadius(Coords,parseInt(args[1])+0.001)
        SetBlipAlpha(CacheBlip,100)
        StartColor = StartColor + 1
    	SetBlipColour(CacheBlip,StartColor)
        table.insert(BlipRadius,CacheBlip)
    end
end)

local Mansions = {
    ["Mansao01"] = vector3(0,0,0)
}
function GetCoordsRisk(Fac)
    for k,v in pairs(RiskArea[cityName]) do
        if v[2]:lower() == Fac:lower() then
            return v[1]
        end
    end
    return
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
local DefaultHealth = 160
if cityName == "Santa" then
    DefaultHealth = 400
end
function Creative.Respawn(Group,Locate,Mansion,Custom,OverrideCoords)

	SendNUIMessage({ action = "setVisible", data = false })
    SetDeathPlayerControlAllowed( true )

	Death = false
	DeathTimer = GlobalState["DeathTimer"]
    local Ped = PlayerPedId()
	ClearPedTasksImmediately(Ped)
	ClearPedSecondaryTask(Ped)
	SetPedCanRagdoll(Ped, true)
	SetPedCanRagdollFromPlayerImpact(Ped, true)
	if IsPedRagdoll(Ped) then
		SetPedToRagdoll(Ped, 0, 0, 0, false, false, false)
		Wait(100)
	end
	ClearPedTasksImmediately(Ped)
	FreezeEntityPosition(Ped, false)
	SetEntityCollision(Ped, true, true)
	NetworkSetFriendlyFireOption(true)
	ClearPedBloodDamage(Ped)
	SetEntityHealth(Ped,DefaultHealth)
	SetEntityInvincible(Ped,false)
	LocalPlayer["state"]["Invincible"] = false

    exports.combatsystem:RemoveCombat( eCombatReasons.DEATH )

	TriggerEvent("paramedic:Reset")
	TriggerEvent("inventory:CleanWeapons")
	TriggerServerEvent("net:inventory:reset_ammos_on_death")
	LocalPlayer["state"]["Handcuff"] = false
	LocalPlayer["state"]["disablePhone"] = false
	exports['pma-voice']:resetProximityCheck()
    if GetResourceState("lb-phone") == "started" then
        exports["lb-phone"]:ToggleDisabled(false)
    end

	DoScreenFadeOut(0)
    --print("[RESPAWN-DEBUG] Respawn executado | Locate =", tostring(Locate), "| CustomSpawn =", tostring(LocalPlayer["state"]["CustomSpawn"]))
    if OverrideCoords then
        SetEntityCoords(Ped, OverrideCoords.x, OverrideCoords.y, OverrideCoords.z)
    elseif Locate == "PERSONALIZADO" then
        if LocalPlayer["state"]["CustomSpawn"] then
            --print("[RESPAWN-DEBUG] Aplicando CustomSpawn coords:", tostring(LocalPlayer["state"]["CustomSpawn"]))
            SetEntityCoords(Ped,LocalPlayer["state"]["CustomSpawn"])
        else
            --print("[RESPAWN-DEBUG] PROBLEMA: Locate == 'PERSONALIZADO' mas CustomSpawn é nil — sem coordenadas para teleportar!")
        end
    else
        if Mansion then
            SetEntityCoords(Ped,Mansions[Mansion])
        else
            if Group then
                local Fac = GlobalState["GROUP_CACHE"][Group] or Group
                local CoordsFac = GetCoordsRisk(Fac)
                if not CoordsFac then
                    if GROUP_COORDS and GROUP_COORDS[Group] then
                        CoordsFac = GROUP_COORDS[Group]
                    else
                        CoordsFac = Locations[Locate] or vec3(-1643.64,-1010.26,13.01)
                    end
                end
                SetEntityCoords(Ped,CoordsFac)
            else
                SetEntityCoords(Ped,Locations[Locate] or vec3(-1643.64,-1010.26,13.01))
            end
        end
    end
    TriggerEvent("survival:GhostSpawn")
    FreezeEntityPosition(Ped,true)
    
    TriggerEvent( "survival:RestoreKillPhraseHud" )

    if not LocalPlayer["state"]["Arena"] then
        TriggerEvent("hud:Active",true)
    end

	Wait(1000)
	DoScreenFadeIn(1000)
    Wait(2000)
    FreezeEntityPosition(Ped,false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REVIVE
-----------------------------------------------------------------------------------------------------------------------------------------

exports('IsLocalPlayerDead', function()

    return Death == true
end)

exports("Revive",function(Health,Arena)
	local Ped = PlayerPedId()

	SetEntityHealth(Ped,Health)
	SetEntityInvincible(Ped,false)

    for i = 0, 5 do 
        ClearPedDamageDecalByZone(Ped, i, "scar")
    end

	LocalPlayer["state"]["Invincible"] = false
    
    exports.combatsystem:RemoveCombat( eCombatReasons.DEATH )

	if Arena then
		SetPedArmour(Ped,100)
	end

	if Death then

		SendNUIMessage({ action = "setVisible", data = false })
        SetDeathPlayerControlAllowed( true )

		Death = false
		DeathTimer = GlobalState["DeathTimer"]

		ClearPedTasksImmediately(Ped)
		ClearPedSecondaryTask(Ped)
		SetPedCanRagdoll(Ped, true)
		SetPedCanRagdollFromPlayerImpact(Ped, true)
		if IsPedRagdoll(Ped) then
			SetPedToRagdoll(Ped, 0, 0, 0, false, false, false)
			Wait(100)
		end
		ClearPedTasksImmediately(Ped)
		FreezeEntityPosition(Ped, false)
		SetEntityCollision(Ped, true, true)
		NetworkSetFriendlyFireOption(true)

		TriggerEvent( "survival:RestoreKillPhraseHud" )
		TriggerEvent("hud:Active",true)
        if GetResourceState("lb-phone") == "started" then
            exports["lb-phone"]:ToggleDisabled(false)
        end

		if LocalPlayer["state"]["Route"] < 900000 then
			TriggerEvent("paramedic:Reset")
			exports['pma-voice']:resetProximityCheck()
		end
        SetEntityInvincible(Ped,false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REVIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Revive(Health,Arena)
	exports["survival"]:Revive(Health,Arena)
    TriggerServerEvent("net.player.revive_status_changed")
end

RegisterNetEvent("vrp:removeMute")
AddEventHandler("vrp:removeMute",function()
    exports['pma-voice']:resetProximityCheck()
end)

RegisterNUICallback("getCityName",function(Data,Callback)
    cityName = GetConvar("cityName", "")
    Callback(string.lower(cityName))
end)

RegisterNetEvent("survival:Facs")
AddEventHandler("survival:Facs",function(Facs)
    MakeBlips(Facs)
end)

RegisterNetEvent("survival:GhostSpawn")
AddEventHandler("survival:GhostSpawn",function()
    SetLocalPlayerAsGhost(true)
    SetGhostedEntityAlpha(254)
    Wait(15000)
    SetLocalPlayerAsGhost(false)
end)

RegisterNUICallback('CallMedic',function(Data,CallBack)
    if not LocalPlayer["state"]["Route"] == 1 then
        return
    end
    local Status = exports["warsystem"]:CheckIfDomination()
    if Status then
        --TriggerEvent("Notify","vermelho","Você não pode chamar um medico em uma area de dominacao")
        TriggerEvent("Notify2","#naoPodeChamarMed")
        return
    end
    if not LocalPlayer["state"]["InX1"] then
        CALLMEDIC_COOLDOWN = GetGameTimer() + 60000*2
        TriggerServerEvent("survival:CallMedic")
    end
end)

RegisterNetEvent("survival:SetWaypoint")
AddEventHandler("survival:SetWaypoint",function(Coords)
    SetNewWaypoint(Coords["x"],Coords["y"])
    --TriggerEvent("Notify","verde","Você marcou um ponto no GPS.")
    TriggerEvent("Notify2","#marcaGPS")
end)

RegisterNetEvent("survival:AcceptCallMedic")
AddEventHandler("survival:AcceptCallMedic",function(Text,Color)
    local Ped = PlayerPedId()
    local Health = GetEntityHealth(Ped)
    if Health <= 100 then
        MedicStart = true
        SendNUIMessage({ action = "CallMedic", data = {text = Text, color = Color} })
    end
end)

local FormatedRisk = {}

---@param riskGroup string
---@return string group
---@return string alias
---@return string qg
local function GetRiskIdentity( riskGroup )

    local groupCache = GlobalState["GROUP_CACHE"] or {}
    local aliases    = GlobalState["AliasGroup"] or {}
    local group      = nil
    local qg         = riskGroup

    for candidateGroup, candidateQG in pairs( groupCache ) do

        if candidateQG == riskGroup then
            group = candidateGroup
            break
        end
    end

    if not group and groupCache[ riskGroup ] then
        group = riskGroup
        qg = groupCache[ riskGroup ]
    end

    if not group then
        return "N/A", "N/A", qg
    end

    return group, aliases[ group ] or group, qg
end

function ClosestRisk()
    local Coords = sx.client.player.getFocusPosition()
    local Distance = 9999
    local Selected = false
    for i=1,#RiskArea[cityName] do
        local Cache = RiskArea[cityName][i][1]
        local DistanceCheck = #(Coords - Cache)
        if DistanceCheck < Distance then
            Distance = DistanceCheck
            Selected = i
        end
    end
    return Selected, Distance
end

RegisterCommandLocalized("command.closegang",function(source,args)
    local selected, distance = ClosestRisk()

    if selected then
        local risk = RiskArea[cityName][selected]
        local coords = risk[1]
        local group, alias, qg = GetRiskIdentity( risk[2] )

        SetNewWaypoint(coords["x"],coords["y"])
        --TriggerEvent("Notify","verde","Você marcou um ponto no GPS.")
        TriggerEvent("Notify2","#marcaGPS")
        TriggerEvent("Notify2", "#facProxima", {
            group = group,
            alias = alias,
            qg = qg,
            distance = parseInt( distance ),
        })
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKDEATH
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ClosestRisk()
    local Selected = ClosestRisk()
    if Selected then
       return RiskArea[cityName][Selected][2]
    end
    return
end

--- Client-side closest risk faction name for the local player.
--- Mirrors the server `survival:GetClosestRisk(source)` export for self-checks.
exports( "GetClosestRisk", function()
    return Creative.ClosestRisk()
end )

-- /fac
RegisterCommandLocalized("command.gang",function(source,args)
    if not args[1] then
        args = {}
        args[1] = Server.Group() or ""
    end
    if args and args[1] then
        Server.MarkGroupCoords(args[1])
    end
end)

RegisterNetEvent("survival:Close")
AddEventHandler("survival:Close",function(Data)

    SendNUIMessage({ action = "setVisible", data = false })
    SetDeathPlayerControlAllowed( true )
end)


RegisterNetEvent("survival:Open")
AddEventHandler("survival:Open",function(Data)

    TriggerEvent("hud:Active",false)

    SendNUIMessage({ action = "setVisible", data = true })
    SetDeathPlayerControlAllowed( false )

    if not MedicStart then
        SendNUIMessage({ action = "CallMedic", data = {text = _t("callMedic"), color = {0,0,0,0.5}} })
        -- --print("survival:Open")
    end
end)

---@return boolean, string
local function isEnabledReportRDM()
    local Status = exports["warsystem"]:CheckIfDomination()
    local InsideDomination = exports["warsystem"]:IsInsideDomination()

    if InsideDomination or Status then
        return false, "#naoPodeChamarMed"
    end

    if LocalPlayer["state"]["Arena"] or vRP.GetCurrentRoutingBucket() ~= 1 or LocalPlayer["state"]["Event"] then
        return false, "#no_report_rdm_another_world"
    end

    return true, ""
end

RegisterNUICallback("reportPlayer",function( Data, Callback )

    local isEnabled, message = isEnabledReportRDM( )

    if not isEnabled then
        return TriggerEvent( "Notify2", message )
    end

    if LocalPlayer.state.Event then
        return TriggerEvent( "Notify2", "#no_report_rdm_another_world" )
    end

    if LocalPlayer.state.InX1 then
        return TriggerEvent( "Notify2", "#no_report_rdm_another_world" )
    end

    TriggerServerEvent( "survival:ReportRDM", Data.id )
end)


local BLOCKED_WEAPONS_NETWORK_ENTITY_DAMAGE = {

	[`WEAPON_RAMMED_BY_CAR`]    = true,

    [`WEAPON_RUN_OVER_BY_CAR`]  = true,

    [`WEAPON_UNARMED`]          = true,
	
}

AddEventHandler("gameEventTriggered",function( name, args )
    if name ~= 'CEventNetworkEntityDamage' then
		return
	end

	local victim = args[ 1 ]
	local attacker = args[ 2 ]
    local blockedWeapon = BLOCKED_WEAPONS_NETWORK_ENTITY_DAMAGE[ args[ 7 ] ]
    local pedId = PlayerPedId()

    if not ( IsEntityAPed( victim ) and IsPedAPlayer( attacker ) ) or blockedWeapon then
		return
	end

    if pedId ~= attacker and pedId ~= victim then

        -- garantir que somente o attacker ou o victim recebem o evento

        return
    end

	exports.combatsystem:SetInCombat( eCombatReasons.TOOK_DAMAGE )
end)

RegisterNetEvent("survival:reviveAnim",function(Time)
    TriggerEvent("vrp:removeObjects")
    
    local dict = "mini@cpr@char_a@cpr_str"
    local anim = "cpr_pumpchest"

    RequestAnimDict(dict)
    repeat Wait(100) until HasAnimDictLoaded(dict)

    local now = GetGameTimer()

    repeat
        Wait(1)

        if (GetResourceState("smartphone") == "started" and exports.smartphone) then
            if (exports.smartphone.close) then
                exports.smartphone:close()
            end
        end

        if not IsEntityPlayingAnim(PlayerPedId(), dict, anim, 3) then
            TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, 8.0, -1, 1, 0, 0, 0, 0)
        end
    until GetGameTimer() > (now + Time)

    ClearPedTasks(PlayerPedId())

    RemoveAnimDict(dict)
end)

-- RegisterCommand("reviveAnim",function()
--     local Time = 10000
--     TriggerEvent("survival:reviveAnim", Time)
-- end)
