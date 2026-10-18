-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Fuel = 0
local Speed = 0
local Locked = false
local Headlights = false
local ActualVehicle = nil
local EngineHealth = 0
cityName = GetConvar("cityName", "")
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATBELT
-----------------------------------------------------------------------------------------------------------------------------------------
local SeatbeltLock = false

---@param enabled boolean
local function SetSeatbeltEnabled( enabled )
    if GetConvar( 'game_enableFlyThroughWindscreen', 'false' ) ~= 'true' then
        SetPedConfigFlag( PlayerPedId(), 32, not enabled )
        SeatbeltLock = enabled
        return
    end

    pcall(SetFlyThroughWindscreenParams,
        enabled and 1000.0 or 25.0,
        enabled and 1000.0 or 2.0,
        enabled and 0.0    or 15.0,
        enabled   and 0.0    or 15.0
    )

    SetPedConfigFlag( PlayerPedId(), 32, not enabled )
    SeatbeltLock = enabled
end

-- Inicialiar padrões
SetSeatbeltEnabled( false )

RegisterNetEvent("hud:setSeatbelt", function(enabled)
    enabled = enabled == true
    SetSeatbeltEnabled(enabled)
    SendNUIMessage({ action = "Seatbelt", data = { Status = enabled } })
    if enabled then TriggerEvent("keyText:remove") end
end)

local VehicleWeapons = {
    "VEHICLE_WEAPON_ROTORS", 
    "VEHICLE_WEAPON_TANK", 
    "VEHICLE_WEAPON_SEARCHLIGHT",
    "VEHICLE_WEAPON_RADAR",
    "VEHICLE_WEAPON_PLAYER_BULLET",
    "VEHICLE_WEAPON_PLAYER_LAZER",
    "VEHICLE_WEAPON_ENEMY_LASER",
    "VEHICLE_WEAPON_PLAYER_BUZZARD",
    "VEHICLE_WEAPON_PLAYER_HUNTER",
    "VEHICLE_WEAPON_PLANE_ROCKET",
    "VEHICLE_WEAPON_SPACE_ROCKET",
    "VEHICLE_WEAPON_TURRET_INSURGENT",
    "VEHICLE_WEAPON_PLAYER_SAVAGE",
    "VEHICLE_WEAPON_TURRET_TECHNICAL",
    "VEHICLE_WEAPON_NOSE_TURRET_VALKYRIE",
    "VEHICLE_WEAPON_TURRET_VALKYRIE",
    "VEHICLE_WEAPON_CANNON_BLAZER",
    "VEHICLE_WEAPON_TURRET_BOXVILLE",
    "VEHICLE_WEAPON_RUINER_BULLET",
    "VEHICLE_WEAPON_RUINER_ROCKET",
    "VEHICLE_WEAPON_HUNTER_MG",
    "VEHICLE_WEAPON_HUNTER_MISSILE",
    "VEHICLE_WEAPON_HUNTER_CANNON",
    "VEHICLE_WEAPON_HUNTER_BARRAGE",
    "VEHICLE_WEAPON_TULA_NOSEMG",
    "VEHICLE_WEAPON_TULA_MG",
    "VEHICLE_WEAPON_TULA_DUALMG",
    "VEHICLE_WEAPON_TULA_MINIGUN",
    "VEHICLE_WEAPON_SEABREEZE_MG",
    "VEHICLE_WEAPON_MICROLIGHT_MG",
    "VEHICLE_WEAPON_DOGFIGHTER_MG",
    "VEHICLE_WEAPON_DOGFIGHTER_MISSILE",
    "VEHICLE_WEAPON_MOGUL_NOSE",
    "VEHICLE_WEAPON_MOGUL_DUALNOSE",
    "VEHICLE_WEAPON_MOGUL_TURRET",
    "VEHICLE_WEAPON_MOGUL_DUALTURRET",
    "VEHICLE_WEAPON_ROGUE_MG",
    "VEHICLE_WEAPON_ROGUE_CANNON",
    "VEHICLE_WEAPON_ROGUE_MISSILE",
    "VEHICLE_WEAPON_BOMBUSHKA_DUALMG",
    "VEHICLE_WEAPON_BOMBUSHKA_CANNON",
    "VEHICLE_WEAPON_HAVOK_MINIGUN",
    "VEHICLE_WEAPON_VIGILANTE_MG",
    "VEHICLE_WEAPON_VIGILANTE_MISSILE",
    "VEHICLE_WEAPON_TURRET_LIMO",
    "VEHICLE_WEAPON_DUNE_MG",
    "VEHICLE_WEAPON_DUNE_GRENADELAUNCHER",
    "VEHICLE_WEAPON_DUNE_MINIGUN",
    "VEHICLE_WEAPON_TAMPA_MISSILE",
    "VEHICLE_WEAPON_TAMPA_MORTAR",
    "VEHICLE_WEAPON_TAMPA_FIXEDMINIGUN",
    "VEHICLE_WEAPON_TAMPA_DUALMINIGUN",
    "VEHICLE_WEAPON_HALFTRACK_DUALMG",
    "VEHICLE_WEAPON_HALFTRACK_QUADMG",
    "VEHICLE_WEAPON_APC_CANNON",
    "VEHICLE_WEAPON_APC_MISSILE",
    "VEHICLE_WEAPON_APC_MG",
    "VEHICLE_WEAPON_ARDENT_MG",
    "VEHICLE_WEAPON_TECHNICAL_MINIGUN",
    "VEHICLE_WEAPON_INSURGENT_MINIGUN",
    "VEHICLE_WEAPON_TRAILER_QUADMG",
    "VEHICLE_WEAPON_TRAILER_MISSILE",
    "VEHICLE_WEAPON_TRAILER_DUALAA",
    "VEHICLE_WEAPON_NIGHTSHARK_MG",
    "VEHICLE_WEAPON_OPPRESSOR_MG",
    "VEHICLE_WEAPON_OPPRESSOR_MISSILE",
    "VEHICLE_WEAPON_MOBILEOPS_CANNON",
    "VEHICLE_WEAPON_AKULA_TURRET_SINGLE",
    "VEHICLE_WEAPON_AKULA_MISSILE",
    "VEHICLE_WEAPON_AKULA_TURRET_DUAL",
    "VEHICLE_WEAPON_AKULA_MINIGUN",
    "VEHICLE_WEAPON_AKULA_BARRAGE",
    "VEHICLE_WEAPON_AVENGER_CANNON",
    "VEHICLE_WEAPON_BARRAGE_TOP_MG",
    "VEHICLE_WEAPON_BARRAGE_TOP_MINIGUN",
    "VEHICLE_WEAPON_BARRAGE_REAR_MG",
    "VEHICLE_WEAPON_BARRAGE_REAR_MINIGUN",
    "VEHICLE_WEAPON_BARRAGE_REAR_GL",
    "VEHICLE_WEAPON_CHERNO_MISSILE",
    "VEHICLE_WEAPON_COMET_MG",
    "VEHICLE_WEAPON_DELUXO_MG",
    "VEHICLE_WEAPON_DELUXO_MISSILE",
    "VEHICLE_WEAPON_KHANJALI_CANNON",
    "VEHICLE_WEAPON_KHANJALI_CANNON_HEAVY",
    "VEHICLE_WEAPON_KHANJALI_MG",
    "VEHICLE_WEAPON_KHANJALI_GL",
    "VEHICLE_WEAPON_REVOLTER_MG",
    "VEHICLE_WEAPON_WATER_CANNON",
    "VEHICLE_WEAPON_SAVESTRA_MG",
    "VEHICLE_WEAPON_SUBCAR_MG",
    "VEHICLE_WEAPON_SUBCAR_MISSILE",
    "VEHICLE_WEAPON_SUBCAR_TORPEDO",
    "VEHICLE_WEAPON_THRUSTER_MG",
    "VEHICLE_WEAPON_THRUSTER_MISSILE",
    "VEHICLE_WEAPON_VISERIS_MG",
    "VEHICLE_WEAPON_VOLATOL_DUALMG"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
SeedometerFormula = {
    ["KM/H"] = 2.236936,
    ["MP/H"] = 3.6,
}

local onEnableWeaponsVehicle = false

local function ToggleVehicleWeaponsEnabled( enabled, overrideWeaponHash )

    local disabled = not enabled

    onEnableWeaponsVehicle = enabled

    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsUsing(ped)

    local weapon, weaponhash = GetCurrentPedVehicleWeapon(ped)

    DisableVehicleWeapon( disabled, weaponhash, vehicle, ped)
end

RegisterNetEvent("hud:enable-weapons-vehicle", function( enabled )

    ToggleVehicleWeaponsEnabled( enabled )

    AddEventHandler( 'onResourceStop', function( resourceName )

        ToggleVehicleWeaponsEnabled( false )
    end)
end)

RegisterNetEvent("hud:explosion-last-vehicle", function( vehicleNetId )
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if not DoesEntityExist(vehicle) then
        return
    end

    local coords = GetEntityCoords(vehicle)
    local netId = NetworkGetNetworkIdFromEntity(vehicle)

    -- NetworkRequestControlOfEntity(vehicle)
    -- NetworkRequestControlOfNetworkId(netId)

    -- local timeout = GetGameTimer() + 3000

    -- while GetGameTimer() < timeout and (not NetworkHasControlOfEntity(vehicle) and not NetworkHasControlOfNetworkId(netId)) do

    --     Wait(0)

    --     NetworkRequestControlOfEntity(vehicle)
    --     NetworkRequestControlOfNetworkId(netId)
    -- end


    if NetworkHasControlOfEntity(vehicle) or NetworkHasControlOfNetworkId(netId) then

        NetworkExplodeVehicle(vehicle, true, false, 0)
    end


end)


Formula = SeedometerFormula[SpeedometerUnit[cityName] or "KM/H"] or 3.6
AddEventHandler("gameEventTriggered",function(eventName,args)
    if eventName ~= "CEventNetworkPlayerEnteredVehicle" then
        return
    end

    local Ped = PlayerPedId()
    
    if tonumber(args[1]) ~= PlayerId() or not LocalPlayer["state"]["Active"] then
        return
    end
    
    SetPedConfigFlag(Ped,35,false)
    SendNUIMessage({ action = "Speed", data = { Number = 0 }})

    CreateThread(function()
        while true do
            if IsPedInAnyVehicle(Ped) then
                wait = 0
                local veh = GetVehiclePedIsUsing(Ped)
                if DoesVehicleHaveWeapons(veh) == 1 and vehicleweaponhash ~= 1422046295 then
                    vehicleweapon, vehicleweaponhash = GetCurrentPedVehicleWeapon(Ped)
                    if vehicleweapon == 1 then
                        local atual_veh = GetPlayersLastVehicle()

                        if not IsVehicleModel(atual_veh,GetHashKey("firetruk")) and not onEnableWeaponsVehicle then
                            DisableVehicleWeapon(true, vehicleweaponhash, veh, Ped)
                        end
                    end
                end
            else
                break
            end
            Wait(500)
        end
    end)

    Wait(100)
    if IsPedOnAnyBike(Ped) then

        local eKnockOffVehicleFlag = sx.vehicles.GetKnockOffVehicleFlag()

        SetPedCanBeKnockedOffVehicle(Ped, eKnockOffVehicleFlag )
    end

    if not IsEntityVisible(Ped) then
        SetEntityVisible(Ped,true,false)
    end

    if not IsPedOnAnyBike(Ped) and not IsPedInAnyHeli(Ped) and not IsPedInAnyPlane(Ped) and not LocalPlayer.state.Racing then
        if not SeatbeltLock and LocalPlayer.state["minigame:active"] ~= "cargame" then
            TriggerEvent("keyText:open", "G", _t("seatbelt"))
            SendNUIMessage({ action = "Seatbelt", data = { Status = false }})
        end
    end

     CreateThread(function()
        while true do
            local update = 120
            if hudConfiguration and hudConfiguration.speedometerUpdate then
                update = hudConfiguration.speedometerUpdate
            end
            local waitTime = math.max(0, math.floor(1000 - (update * 28.67)))
            if Display then
                local Ped = PlayerPedId()
                if IsPedInAnyVehicle(Ped) and not hudConfiguration.hideSpeedometer then
                    if not IsMinimapRendering() then
                        if not IsHudBigmapForced() then
                            SetBigmapActive(false,false)
                        end

                        DisplayRadar(true)
                    end
        
                    local Vehicle = GetVehiclePedIsUsing(Ped)
                    local Rpm = GetVehicleCurrentRpm(Vehicle)
                    local VFuel = GetVehicleFuelLevel(Vehicle)
                    local VSpeed = GetEntitySpeed(Vehicle) * 3.6
                    local Plate = GetVehicleNumberPlateText(Vehicle)
                    local VLocked = GetVehicleDoorLockStatus(Vehicle) == 2 and true or false

                    local _,_,VHeadlight = GetVehicleLightsState(Vehicle)
                    local VEngineHealth = math.floor(GetVehicleEngineHealth(Vehicle) / 10)
        
                    if ActualVehicle ~= Vehicle then
                        SendNUIMessage({ action = "Vehicle", data = { Status = true } })
                        ActualVehicle = Vehicle
                    end
        
                    if Locked ~= VLocked then
                        SendNUIMessage({ action = "Locked", data = { Status = VLocked } })
                        Locked = VLocked
                    end
        
                    if Headlights ~= VHeadlight then
                        SendNUIMessage({ action = "Headlight", data = { Status = VHeadlight } })
                        Headlights = VHeadlight
                    end
        
                    if Fuel ~= VFuel then
                        SendNUIMessage({ action = "Fuel",data = { Number = 100 } })
                        Fuel = VFuel
                    end
        
                    if Speed ~= VSpeed then
                        SendNUIMessage({ action = "Speed", data = { Number = VSpeed }})
                        Speed = VSpeed
                    end

                    if EngineHealth ~= VEngineHealth then
                        SendNUIMessage({ action = "Engine", data = { Number = VEngineHealth } })
                        EngineHealth = VEngineHealth
                    end
        
                    SendNUIMessage({ action = "Rpm", data = { Number = Rpm} })
                else
                    if IsHudMinimapForced() then
                        if not IsMinimapRendering() then
                            if not IsHudBigmapForced() then
                                SetBigmapActive(false,false)
                            end

                            DisplayRadar(true)
                        end
                    elseif hudConfiguration.minimapStyle == 0 and IsMinimapRendering() then
                        DisplayRadar(false)
                    end

                    if ActualVehicle then
                        ActualVehicle = nil
                        SendNUIMessage({ action = "Vehicle", data = { Status = false} })
        
                        Drift = false
                        SendNUIMessage({ action = "Drift", data = { Status = false }})
        
                        Locked = false
                        SendNUIMessage({ action = "Locked", data = { Status = false }})
        
                        Headlights = false
                        SendNUIMessage({ action = "Headlight", data = { Status = 0, Beam = 0 }})
        
                        Speed = 0
                        SendNUIMessage({ action = "Speed", data = { Number = 0 }})

                        EngineHealth = 0
                        SendNUIMessage({ action = "Engine", data = { Number = 0 }})

                         
                        break
                    end
                end
            end
            Wait(waitTime)
        end
    end)

    CreateThread(function()
        while true do
            if IsPedInAnyVehicle(Ped) then
                local veh = GetVehiclePedIsUsing(Ped)
                if DoesVehicleHaveWeapons(veh) then
                    for i=1, #VehicleWeapons do
                        local Weapon = GetHashKey(VehicleWeapons[i])
                        local atual_veh = GetPlayersLastVehicle()
                        if not IsVehicleModel(atual_veh,GetHashKey("firetruk")) and not onEnableWeaponsVehicle then
                            DisableVehicleWeapon(true, Weapon, veh, Ped)	
                        end
                    end
                end
            else
                TriggerEvent("keyText:remove")
                break
            end
            Wait(500)
        end
    end)
    CreateThread(function()
        while true do
            if IsPedInAnyVehicle(Ped) then
                SetPedCanRagdoll(Ped, true)
            else
                TriggerEvent('gameEventTriggered', 'CEventNetworkPlayerLeaveVehicle')
                break
            end
            Wait(500)
        end
        Wait(35000)
        -- SetPedCanRagdoll(Ped, false)
    end)

    if not IsPedOnAnyBike(Ped) and not IsPedInAnyHeli(Ped) and not IsPedInAnyPlane(Ped) then
        CreateThread(function()
            while true do
                if IsPedInAnyVehicle(Ped) and not LocalPlayer.state.inKart then
                    local Vehicle = GetVehiclePedIsUsing(Ped)
                else
    
                    if SeatbeltLock then
                        SendNUIMessage({ action = "Seatbelt", data = { Status = false }})

                        SetSeatbeltEnabled( false )
                    end

                    break
                end
                SetPedCanBeDraggedOut(Ped, false)
                Wait( 0 )
            end
        end)
    end
    CreateThread(function()
        while true do
            Wait(0)
            if IsPedInAnyVehicle(Ped) and not onEnableWeaponsVehicle then
                DisableControlAction(0, 24, true)  -- INPUT_ATTACK (Left Click / RT)
                DisableControlAction(0, 69, true)  -- INPUT_VEH_ATTACK
                DisableControlAction(0, 70, true)  -- INPUT_VEH_ATTACK2
                DisableControlAction(0, 92, true)  -- INPUT_VEH_PASSENGER_ATTACK
                DisableControlAction(0, 114, true) -- INPUT_VEH_FLY_ATTACK
                DisableControlAction(0, 257, true) -- INPUT_ATTACK2
                DisableControlAction(0, 331, true) -- INPUT_VEH_MELEE_ATTACK'

                if IsPedOnAnyBike(Ped) then
                    DisableControlAction(0, 345, true) -- INPUT_VEH_MELEE_HOLD
                end
            else
                break
            end
        end
    end)
    if not GlobalState["DropBike"] then
        -- CreateThread(function()
        --     while true do
        --         if IsPedInAnyVehicle(Ped) then
        --             if IsPedOnAnyBike(Ped) then
        --                 SetPedConfigFlag(Ped, 32, false)
        --                 SetPedCanBeKnockedOffVehicle(Ped,true)
        --             end
        --         else
        --             SetPedCanBeKnockedOffVehicle(Ped,false)
        --             break
        --         end
        --         Wait(1)
        --     end
        -- end)
    end
    if GlobalState["DriveBy"] then 
        CreateThread(function()
            local Player = PlayerId()
            while true do
                if IsPedInAnyVehicle(Ped) then
                    if not IsPedOnAnyBike(Ped) then
                        local Vehicle = GetVehiclePedIsUsing(Ped)
                        local Speed = GetEntitySpeed(Vehicle) * 3.6
                        if Speed < 150 and not onEnableWeaponsVehicle then
                            DisablePlayerFiring(Ped, true)
                            DisableControlAction(0, 24,  true)
                            DisableControlAction(0, 92,  true)
                        end
                    end
                else
                    break
                end
                Wait(1)
            end
        end)
    end

    CreateThread(function()
        local startCoords = GetEntityCoords(Ped)

        while true do
            local playerPed = PlayerPedId()
            
            if IsPedInAnyVehicle(playerPed) then
                local vehicle = GetVehiclePedIsUsing(playerPed)
                local distance = #(GetEntityCoords(playerPed) - startCoords)
                if distance > 100 then
                    TriggerServerEvent("player:server:playerEnteredVehicle", VehToNet(vehicle))
                    break
                end
            else
                break
            end

            Wait(500)
        end
    end)
end)

RegisterCommand("seat",function(_,args)
    local Ped = PlayerPedId()
    local Vehicle = GetVehiclePedIsUsing(Ped)
    local Seat = args[1]
    if IsPedInAnyVehicle(Ped) then
        SetPedIntoVehicle(Ped,Vehicle,tonumber(Seat))
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATBELT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("Betzado",function(source)
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) and not IsPedOnAnyBike(Ped) and not IsPedInAnyHeli(Ped) and not IsPedInAnyPlane(Ped) then
        local Vehicle = GetVehiclePedIsUsing(Ped)
        if LocalPlayer.state["minigame:active"] == "cargame"
            or Entity(Vehicle).state["cargame:vehicle"] == true
        then
            return
        end

        if SeatbeltLock then
            TriggerEvent("sounds:Private","unbelt",0.5)
            SendNUIMessage({ action = "Seatbelt", data = { Status = false }})

            SetSeatbeltEnabled( false )
        else
            TriggerEvent("sounds:Private","belt",0.5)
            SendNUIMessage({ action = "Seatbelt", data = { Status = true }})

            SetSeatbeltEnabled( true )
            TriggerEvent("keyText:remove")
        end
	end
end)
RegisterKeyMapping("Betzado", _t("Seatbelt") or "Cinto de segurança.", "keyboard", "G")
