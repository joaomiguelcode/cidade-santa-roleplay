IN_WORLD_PVP = false
WORLD_PVP_BLIPS = {}
WORLD_PVP_ZONES = {}
WORLD_PVP_SAFEZONE_STATE = false
WORLD_PVP_OLD_COORDS = false
FACTION_COORDS = false
local CollectingTag = false
Language = GetConvar("language", "") or "pt-br"
if Language == "" then Language = "pt-br" end

local LanguageConfig = {
    ["pt-br"] = {
        ["North"] = "~b~ [NORTE] ~w~",
        ["South"] = "~r~ [SUL] ~w~",
    },
    ["pt-pt"] = {
        ["North"] = "~b~ [NORTE] ~w~",
        ["South"] = "~r~ [SUL] ~w~",
    },
    ["en-us"] = {
        ["North"] = "~b~ [NORTH] ~w~",
        ["South"] = "~r~ [SOUTH] ~w~",
    },
    ["es-es"] = {
        ["North"] = "~b~ [NORTE] ~w~",
        ["South"] = "~r~ [SUL] ~w~",
    },
}

function GetPlayers()
	local Players = {}

	for _,v in ipairs(GetActivePlayers()) do
		Players[#Players + 1] = GetPlayerServerId(v)
	end

	return Players
end

function ClosestPeds(Radius)
	local Players = {}
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)

	for _,source in pairs(GetPlayers()) do
		local Player = GetPlayerFromServerId(source)
		if Player ~= PlayerId() and NetworkIsPlayerConnected(Player) then
			local OtherPed = GetPlayerPed(Player)
			local OtherCoords = GetEntityCoords(OtherPed)
			local Distance = #(Coords - OtherCoords)
            local Health = GetEntityHealth(OtherPed)
			if Health <= 100 and Distance <= Radius then
				Players[OtherPed] = { Distance,source }
			end
		end
	end

	return Players
end

function ClosestPed(Radius)
	local Selected = false
	local Min = Radius + 0.0001
	local Players = ClosestPeds(Radius)

	for ped,v in pairs(Players) do
		if v[1] <= Min then
			Selected = ped
			Min = v[1]
		end
	end

	return Selected
end

function DrawText3D(x,y,z,text, scale)
	local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)

	if onScreen then
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringKeyboardDisplay(text)
		SetTextColour(255,255,255,150)
		SetTextScale(scale or 0.35,scale or 0.35)
		SetTextFont(4)
		SetTextCentre(1)
		EndTextCommandDisplayText(_x,_y)

		local width = string.len(text) / 160 * 0.45
		DrawRect(_x,_y + 0.0125,width,0.03,0,0,0,200)
	end
end

CreateThread(function()
    while true do
        local Idle = 2500
        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)
        local Health = GetEntityHealth(Ped)
        if Health > 100 and not exports['player']:IsPlayerWanted() then 
            if not IN_WORLD_PVP and not LocalPlayer.state['minigame:active'] then
                for i=1,#WORLD_PVP_START do
                    local Distance = #(Coords - vector3(WORLD_PVP_START[i][1]["x"], WORLD_PVP_START[i][1]["y"], WORLD_PVP_START[i][1]["z"]))
                    if Distance <= 50 then
                        Idle = 0
                        DrawMarker(42,WORLD_PVP_START[i][1]["x"], WORLD_PVP_START[i][1]["y"], WORLD_PVP_START[i][1]["z"],0,0,0,vec3(0.0, 0.0, 0.0),vec3(1.0, 1.0, 1.0),THEME.rgb.r, THEME.rgb.g, THEME.rgb.b, 100,false,false,2,true,nil,nil,false)
                    end
                    if Distance <= 1.5 then
                        local entryLabel

                        if gWorldPvpDominationEntryEnabled then
                            entryLabel = _t("enter_domination")
                        else
                            entryLabel = _t("arena_track") .. LanguageConfig[Language][GlobalState["WorldPVP"]]
                        end

                        DrawText3D(WORLD_PVP_START[i][1]["x"], WORLD_PVP_START[i][1]["y"], WORLD_PVP_START[i][1]["z"], entryLabel)
                        if IsControlJustPressed(0, 38) and not vRP.ReturnNoClip() then
                            TriggerServerEvent("WorldPVP:Start", WORLD_PVP_START[i][2])
                        end
                    end
                end
            end
        end
        Wait(Idle)
    end
end)

CreateThread(function()
    while true do
        local Idle = 2500
        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)
        local Health = GetEntityHealth(Ped)
        if Health > 100 then 
            if IN_WORLD_PVP then
                for i=1,#WORLD_PVP_CHESTS do
                    local Distance = #(Coords - vector3(WORLD_PVP_CHESTS[i][1]["x"], WORLD_PVP_CHESTS[i][1]["y"], WORLD_PVP_CHESTS[i][1]["z"]))
                    if Distance <= 50 then
                        Idle = 0
                        DrawMarker(2,WORLD_PVP_CHESTS[i][1]["x"], WORLD_PVP_CHESTS[i][1]["y"], WORLD_PVP_CHESTS[i][1]["z"],0,0,0,vec3(180.0, 0.0, 0.0),vec3(0.5, 0.5, 0.5),THEME.rgb.r, THEME.rgb.g, THEME.rgb.b, 100,false,false,2,true,nil,nil,false)
                    end
                    if Distance <= 1.5 then
                        DrawText3D(WORLD_PVP_CHESTS[i][1]["x"], WORLD_PVP_CHESTS[i][1]["y"], WORLD_PVP_CHESTS[i][1]["z"], _t("deposit_dogtags"))
                        if IsControlJustPressed(0, 38) then
                            TriggerServerEvent("WorldPVP:DepositDogtags")
                        end
                    end
                end
            end
        end
        Wait(Idle)
    end
end)
local DOGTAG_CHEST = false
function MarkChest(Group)
    for i=1,#WORLD_PVP_CHESTS do
        local SelectedGroup = WORLD_PVP_CHESTS[i][2]
        if SelectedGroup:lower() == Group:lower() then
            local Blip = AddBlipForCoord(WORLD_PVP_CHESTS[i][1]["x"], WORLD_PVP_CHESTS[i][1]["y"], WORLD_PVP_CHESTS[i][1]["z"])
            DOGTAG_CHEST = Blip
            SetBlipSprite(Blip,587)
            SetBlipDisplay(Blip,4)
            SetBlipAsShortRange(Blip,false)
            SetBlipColour(Blip,5)
            SetBlipScale(Blip,1.0)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(_t("store_dogtags"))
            EndTextCommandSetBlipName(Blip)
            return
        end
    end
end

RegisterNetEvent("WorldPVP:StartClient")
AddEventHandler("WorldPVP:StartClient",function(OldCoords,Group)
    IN_WORLD_PVP = true
    local Ped = PlayerPedId()
    local PedCoords = GetEntityCoords(Ped)
    WORLD_PVP_OLD_COORDS = PedCoords
    TriggerEvent("admin:Teleport",OldCoords)
    for _,data in pairs(WORLD_PVP_SPAWN) do
        for __,Coords in ipairs(data) do
            local Zone = CircleZone:Create(Coords, 100.0,{ debugGrid = false, debugColors = { noLines = true, opacity = 25, walls = {0,255,0}}})
            local Blip = AddBlipForRadius(Coords,100.0)
            SetBlipColour(Blip, 2)
            SetBlipAlpha(Blip, 125)
            SetBlipAsShortRange(Blip, true)
            table.insert(WORLD_PVP_BLIPS,Blip)
            table.insert(WORLD_PVP_ZONES, Zone)
        end
    end
    TriggerEvent("misc:DeleteBlips")
    MarkChest(Group)
    CreateThread(function()
        while IN_WORLD_PVP do
            DisplayRadar(true)
            Wait(0)
        end
        local hudConfig = exports["hud"]:GetHudConfig()
        if hudConfig.minimapStyle ~= 1 then
            DisplayRadar(false)
        end
    end)

    CreateThread(function()
        while IN_WORLD_PVP do
            local Ped = PlayerPedId()
            local Vehicles = GetGamePool('CVehicle')
            local Coords = GetEntityCoords(Ped)
            for i=1, #Vehicles do
                local Vehicle = Vehicles[i]
                if #(Coords - GetEntityCoords(Vehicle)) < 60.0 then
                    SetEntityNoCollisionEntity(Vehicle, Ped, true)
                end
            end
            Wait(100)
        end
    end)

    CreateThread(function()
        local SelectedPed = false
        while IN_WORLD_PVP do
            local Idle = 1000
            local Ped = PlayerPedId()
            local Coords = GetEntityCoords(Ped)
            SelectedPed = ClosestPed(50.0)
            local Health = GetEntityHealth(Ped)
            if SelectedPed then
                Idle = 0
                local SelectedPedCoords = GetEntityCoords(SelectedPed)
                local Text = "⚰️"
                local Size = 0.35
                local Distance = #(Coords - SelectedPedCoords)
                if Distance <= 5 then
                    Text = "COLETAR DOGTAGS ~r~[E]~w~ "
                    Size = 0.35
                    if IsControlJustPressed(0, 38) then
                        CollectingTag = true
                        TriggerEvent("Progress","Coletando Dogtags",1000*5)
                        vRP.playAnim(false, { "amb@medic@standing@tendtodead@idle_a", "idle_a" }, true)
                        FreezeEntityPosition(Ped,true)
                        Wait(5000)
                        if CollectingTag then
                            FreezeEntityPosition(Ped,false)
                            TriggerEvent("vrp:removeObjects")
                            TriggerServerEvent("WorldPVP:CollectTags",GetPlayerServerId(NetworkGetPlayerIndexFromPed(SelectedPed)))
                            CollectingTag = false
                        end
                    end
                end
                DrawText3D(SelectedPedCoords["x"],SelectedPedCoords["y"],SelectedPedCoords["z"]-0.20,Text,Size)
            end
            Wait(Idle)
        end
    end)

    -- CreateThread(function()
    --     while IN_WORLD_PVP do
    --         if IsControlJustPressed(0, 52) then
    --             SetPedAmmo(Ped,GetSelectedPedWeapon(Ped),0)
    --             RemoveWeaponFromPed(Ped,GetSelectedPedWeapon(Ped))
    --             TriggerServerEvent("WorldPVP:Exit")
    --         end
    --         Wait(0)
    --     end
    -- end)
end)

RegisterNetEvent("WorldPVP:ExitClient")
AddEventHandler("WorldPVP:ExitClient",function()
    local Ped = PlayerPedId()
    IN_WORLD_PVP = false
    for i=1,#WORLD_PVP_BLIPS do
        RemoveBlip(WORLD_PVP_BLIPS[i])
    end
    TriggerEvent("misc:CreateBlips")
    for i=1,#WORLD_PVP_ZONES do
        WORLD_PVP_ZONES[i]:destroy()
    end
    WORLD_PVP_BLIPS = {}
    WORLD_PVP_ZONES = {}
    TriggerEvent("Notify:Text","")
    TriggerEvent("arena:DisplayRank",false)
    TriggerEvent("admin:Teleport",WORLD_PVP_OLD_COORDS)
    SetPedAmmo(Ped,GetSelectedPedWeapon(Ped),0)
    RemoveWeaponFromPed(Ped,GetSelectedPedWeapon(Ped))
    if DoesBlipExist(DOGTAG_CHEST) then
        RemoveBlip(DOGTAG_CHEST)
    end
    WORLD_PVP_SAFEZONE_STATE = false
end)


function EnterSafezone()
    local ped = PlayerPedId()
    SetLocalPlayerAsGhost(true)
    SetGhostedEntityAlpha(254)
    SetEntityInvincible(ped,true)
    CreateThread(function()
        while WORLD_PVP_SAFEZONE_STATE do
            SetCanPedEquipAllWeapons(ped, false)
            DisablePlayerFiring(ped,true)
            DisableControlAction(0,140,true)
            Wait(0)
        end
    end)
end

function ExitSafezone()
    local Ped = PlayerPedId()
    SetCanPedEquipAllWeapons(Ped, true)
    -- DisablePlayerFiring(Ped,false)
    SetEntityInvincible(Ped,false)
    SetLocalPlayerAsGhost(false)
    LocalPlayer.state:set("Invincicle",false,true)
end

CreateThread(function()
    while true do
        local Idle = 2500
        if LocalPlayer["state"]["Route"] == 20 then
            local Ped = PlayerPedId()
            local Coords = GetEntityCoords(Ped)
            if not WORLD_PVP_SAFEZONE_STATE then
                for i=1,#WORLD_PVP_ZONES do
                    if WORLD_PVP_ZONES[i]:isPointInside(Coords) then
                        if not WORLD_PVP_SAFEZONE_STATE then
                            WORLD_PVP_SAFEZONE_STATE = i
                            EnterSafezone()
                            --TriggerEvent("Notify","verde","Você entrou na zona segura da arena.")
                            TriggerEvent("Notify2","#arenaSafeZone")
                        end
                    end
                end
            else
                if WORLD_PVP_SAFEZONE_STATE and WORLD_PVP_ZONES[WORLD_PVP_SAFEZONE_STATE] then
                    if not WORLD_PVP_ZONES[WORLD_PVP_SAFEZONE_STATE]:isPointInside(Coords) then
                        WORLD_PVP_SAFEZONE_STATE = false
                        --TriggerEvent("Notify","vermelho","Você saiu da zona segura da arena.")
                        TriggerEvent("Notify2","#arenaSafeZoneOff")
                        ExitSafezone()
                    end
                end
            end
            Idle = 0
        end
        Wait(Idle)
    end
end)

RegisterCommandLocalized("command.exit_track",function()
    if IN_WORLD_PVP then
        local seconds = 30
        TriggerEvent("Notify:Text", _t("leaving_track"))
        TriggerEvent("Progress", _t("exiting_track"), 1000*seconds)
        Wait(1000*seconds)
        local Ped = PlayerPedId()
        SetPedAmmo(Ped,GetSelectedPedWeapon(Ped),0)
        RemoveWeaponFromPed(Ped,GetSelectedPedWeapon(Ped))
        TriggerServerEvent("WorldPVP:Exit")
        ExitSafezone()
    end
end)

AddEventHandler("gameEventTriggered",function(name,args)
    if name ~= "CEventNetworkEntityDamage" then
        return
    end
    local Victim = PlayerPedId()
    
    if args[1] ~= Victim then
        return
    end
    
    if not IN_WORLD_PVP then
        return
    end

    local Attacker = tonumber(args[2])
    local VictimDied = GetEntityHealth(Victim) <= 100
    local Weapon = tostring(args[7])
    if VictimDied then
        if IsEntityAPed(Victim) then
            if IsPedAPlayer(Attacker) then
                local KillerServerId = GetPlayerServerId((NetworkGetPlayerIndexFromPed(Attacker)))
                local KillerCoordinate = GetEntityCoords(Attacker)
                TriggerServerEvent("WorldPVP:killfeed",KillerServerId,Weapon)
            end
        end
    end
end)

local MARKERS_DOGTAGS = {}
RegisterNetEvent("WorldPVP:MarkPlayers")
AddEventHandler("WorldPVP:MarkPlayers",function(Data)
    for i=1,#MARKERS_DOGTAGS do
        RemoveBlip(MARKERS_DOGTAGS[i])
    end
    MARKERS_DOGTAGS = {}
    for Index,v in pairs(Data) do
        MARKERS_DOGTAGS[Index] = AddBlipForCoord(v["coords"])
        SetBlipSprite(MARKERS_DOGTAGS[Index],1)
        SetBlipDisplay(MARKERS_DOGTAGS[Index],4)
        SetBlipAsShortRange(MARKERS_DOGTAGS[Index],true)
        SetBlipColour(MARKERS_DOGTAGS[Index],1)
        SetBlipScale(MARKERS_DOGTAGS[Index],0.7)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("! "..v["amount"].."+ Dogtags")
        EndTextCommandSetBlipName(MARKERS_DOGTAGS[Index])
    end
end)

RegisterNetEvent("WorldPVP:markDeposit")
AddEventHandler("WorldPVP:markDeposit",function(Amount)
    local Closest = 9000
    local ClosestCoords = false
    local Ped = PlayerPedId()
    local Coords = GetEntityCoords(Ped)
    for i=1,#WORLD_PVP_CHESTS do
        local Distance = #(Coords - vector3(WORLD_PVP_CHESTS[i][1]["x"], WORLD_PVP_CHESTS[i][1]["y"], WORLD_PVP_CHESTS[i][1]["z"]))
        if Distance <= Closest then
            Closest = Distance
            ClosestCoords = WORLD_PVP_CHESTS[i][1]
        end
    end
    SetNewWaypoint(ClosestCoords["x"], ClosestCoords["y"])
    --TriggerEvent("Notify","verde","Você tem <b>"..Amount.."</b>x Dogtags no seu inventario, tenha cuidado uma localização foi marcada em seu mapa para fazer o deposito seguro de suas DOGTAGS.",5000,"pista")
    TriggerEvent("Notify2","#quantidadeDogtag",{msg=Amount})
end)

function Creative.GetCoords()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    return coords
end

AddEventHandler("actions:Cancel",function()
    if CollectingTag then
        local Ped = PlayerPedId()
        CollectingTag = false
        TriggerEvent("Progress","Cancelando",0)
        FreezeEntityPosition(Ped,false)
        TriggerEvent("vrp:removeObjects")
    end
end)
