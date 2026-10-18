-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("garages",Creative)
vSERVER = Tunnel.getInterface("garages")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DECOR
-----------------------------------------------------------------------------------------------------------------------------------------
DecorRegister("PlayerVehicle",3)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local Opened = nil
local Searched = nil
local Cooldown = GetGameTimer()
local Anim = "machinic_loop_mechandplayer"
local Dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
cityName = GetConvar("cityName", "")
local Updated = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEMODS
-----------------------------------------------------------------------------------------------------------------------------------------
function VehicleMods(Vehicle,Customize)
    local vehModel = GetEntityModel(Vehicle)
	if Customize then
		SetVehicleModKit(Vehicle,0)

		if Customize["wheeltype"] ~= nil then
			SetVehicleWheelType(Vehicle,Customize["wheeltype"])
		end

		if Customize["mods"] then
			for i = 0,16 do
				if Customize["mods"][tostring(i)] ~= nil then
					SetVehicleMod(Vehicle,i,Customize["mods"][tostring(i)])
				end
			end

			for i = 17,22 do
				if Customize["mods"][tostring(i)] ~= nil then
					ToggleVehicleMod(Vehicle,i,Customize["mods"][tostring(i)])
				end
			end

			for i = 23,24 do
				if Customize["mods"][tostring(i)] ~= nil then
					if not Customize["var"] then
						Customize["var"] = {}
					end
					
				
					local varValue = Customize["var"][i] or Customize["var"][tostring(i)] or 0
					
					SetVehicleMod(Vehicle,i,Customize["mods"][tostring(i)],varValue)
				end
			end

			for i = 25,48 do
				if Customize["mods"][tostring(i)] ~= nil then
					SetVehicleMod(Vehicle,i,Customize["mods"][tostring(i)])
				end
			end
		end

		if Customize["neon"] ~= nil then
            for Index,Value in pairs(Customize["neon"]) do
                SetVehicleNeonLightEnabled(Vehicle,Index,Value)
            end
		end

		if Customize["extras"] ~= nil then
			for i = 1,12 do
				local onoff = tonumber(Customize["extras"][i])
				if onoff == 1 then
					SetVehicleExtra(Vehicle,i,0)
				else
					SetVehicleExtra(Vehicle,i,1)
				end
			end
		end

        print('vehicle livery: ', Customize["liverys"])

        if Customize["liverys"] ~= nil and Customize["liverys"] ~= 24  then
            SetVehicleLivery(Vehicle,Customize["liverys"])
        end

        if not Customize["liverys"] then

            local isParamedic = LocalPlayer["state"]["Paramedic"]

            local liveryToApply = nil

            if vehModel == `maverick2` or  vehModel == `polmav` then
                if LocalPlayer["state"]["Policia"] then

                    liveryToApply = 0

                elseif isParamedic then

                    liveryToApply = 1
                end
            end

            if vehModel == `rvjoggerall` and isParamedic and cityName == 'Orizon' then

                -- é só da Orizon?
                
                liveryToApply = 6
            end

            if liveryToApply then

                SetVehicleLivery(Vehicle,liveryToApply)
            end
        end
		if Customize["plateIndex"] ~= nil and Customize["plateIndex"] ~= 4 then
			SetVehicleNumberPlateTextIndex(Vehicle,Customize["plateIndex"])
		end

        if Customize[ 'colors' ]?[ 1 ] then 
            SetVehicleColours( Vehicle, Customize[ 'colors' ][ 1 ], Customize[ 'colors' ][ 2 ] )
        end
        
		SetVehicleXenonLightsColour(Vehicle,Customize["xenonColor"])
		SetVehicleExtraColours(Vehicle,Customize["extracolors"][1],Customize["extracolors"][2])
		SetVehicleNeonLightsColour(Vehicle,Customize["lights"][1],Customize["lights"][2],Customize["lights"][3])
		SetVehicleTyreSmokeColor(Vehicle,Customize["smokecolor"][1],Customize["smokecolor"][2],Customize["smokecolor"][3])

		if Customize["tint"] ~= nil then
			SetVehicleWindowTint(Vehicle,Customize["tint"])
		end

		if Customize["dashColour"] ~= nil then
			SetVehicleDashboardColour(Vehicle,Customize["dashColour"])
		end

		if Customize["interColour"] ~= nil then
			SetVehicleInteriorColour(Vehicle,Customize["interColour"])
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHEDIT2 PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("garages:saveVehedit2Preset",function(model,mods)
	if type(model) ~= "string" or type(mods) ~= "table" then
		return
	end

	SetResourceKvp(('vehedit2:%s'):format(model:lower()),json.encode(mods))
end)

RegisterNetEvent("garages:applyVehedit2Preset")
AddEventHandler("garages:applyVehedit2Preset",function(Network,model)
	if type(Network) ~= "number" or type(model) ~= "string" then
		return
	end

	local presetJson = GetResourceKvpString(('vehedit2:%s'):format(model:lower()))
	if not presetJson then
		return
	end

	local Count = 0
	while not NetworkDoesNetworkIdExist(Network) do
		Count = Count + 1
		if Count >= 1000 then
			return
		end

		Wait(10)
	end

	local Vehicle = NetToEnt(Network)
	Count = 0
	while not DoesEntityExist(Vehicle) do
		Count = Count + 1
		if Count >= 1000 then
			return
		end

		Wait(10)
		Vehicle = NetToEnt(Network)
	end

	local success,preset = pcall(json.decode,presetJson)
	if not success or type(preset) ~= "table" then
		return
	end

	VehicleMods(Vehicle,preset)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNPOSITION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.SpawnPosition(Select)
	local Slot = "0"
	local Checks = 0
	local Selected = {}
	local Position = nil
	repeat
		Checks = Checks + 1

		Slot = Checks
		if Garages[Select]["Spawns"]["Positions"][Slot] ~= nil then
			local _,Groundz = GetGroundZAndNormalFor_3dCoord(Garages[Select]["Spawns"]["Positions"][Slot]["x"],Garages[Select]["Spawns"]["Positions"][Slot]["y"],Garages[Select]["Spawns"]["Positions"][Slot]["z"])
			Selected = { Garages[Select]["Spawns"]["Positions"][Slot]["x"],Garages[Select]["Spawns"]["Positions"][Slot]["y"],Groundz,Garages[Select]["Spawns"]["Positions"][Slot]["w"] }
			Position = GetClosestVehicle(Selected["x"],Selected["y"],Selected["z"],2.501,0,71)
		end
	until not DoesEntityExist(Position) or not Garages[Select]["Spawns"]["Positions"][Slot]

	if not Garages[Select]["Spawns"]["Positions"][Checks] then
        local RandomPosition = Garages[Select]["Spawns"]["Positions"][math.random(1, #Garages[Select]["Spawns"]["Positions"])]
        Selected = { RandomPosition["x"],RandomPosition["y"],RandomPosition["z"],RandomPosition["w"] }
	end

	return Selected
end


local function UnpackVehicleCustomization(data)
	local unpacked = { }

	do
		unpacked['neon'] = { }

		local enabledNeonLightsFlag = data[eVehicleCustomizationPart.NeonLightsFlag] or 0

		for neonIndex = 0, 3 do
			local isEnabled = ( enabledNeonLightsFlag & (1 << (neonIndex)) ) ~= 0
			unpacked['neon'][neonIndex] = isEnabled
		end
	end

	do
		unpacked['xenonColor'] = data[eVehicleCustomizationPart.XenonColor]
	end

	do
		unpacked['lights'] = { }

		if data[eVehicleCustomizationPart.NeonLightsColor] then
			local r, g, b = Int2rgb(data[eVehicleCustomizationPart.NeonLightsColor])

			unpacked['lights'][1] = r
			unpacked['lights'][2] = g
			unpacked['lights'][3] = b
		end
	end

	do
		unpacked['colors'] = data[eVehicleCustomizationPart.Colors] or { }
	end

	do
		unpacked['extracolors'] = data[eVehicleCustomizationPart.ExtraColors] or { }
	end

	do
		unpacked['smokecolor'] = { }

		if data[eVehicleCustomizationPart.TyreSmokeColor] then
			local r, g, b = Int2rgb(data[eVehicleCustomizationPart.TyreSmokeColor])

			unpacked['smokecolor'][1] = r
			unpacked['smokecolor'][2] = g
			unpacked['smokecolor'][3] = b
		end
	end

	do
		unpacked['tint'] = data[eVehicleCustomizationPart.Tint]
	end

	do
		unpacked['dashColour'] = data[eVehicleCustomizationPart.DashboardColour]
	end

	do
		unpacked['interColour'] = data[eVehicleCustomizationPart.InteriorColour]
	end

	do
		unpacked['wheeltype'] = data[eVehicleCustomizationPart.WheelType]
	end

	do

		local enabledExtrasFlag = data[eVehicleCustomizationPart.ExtrasFlag] or 0

        if enabledExtrasFlag ~= 0 then 

            unpacked['extras'] = { }

            

            for extraIndex = 1, 12 do
                local isEnabled = ( enabledExtrasFlag & (1 << (extraIndex)) ) ~= 0

                local isEnabledAsInteger = isEnabled and 1 or 0

                unpacked['extras'][extraIndex] = isEnabledAsInteger         
                
            end
        end
	end

	do
		unpacked['liverys'] = data[eVehicleCustomizationPart.Livery]
	end

	do
		unpacked['plateIndex'] = data[eVehicleCustomizationPart.NumberPlateTextIndex]
	end

	do
		unpacked['mods'] = data[eVehicleCustomizationPart.Mods]
	end

	do
		unpacked['var'] = { }

		unpacked['var'][23] = data[eVehicleCustomizationPart.ModWheelsVariation]
		unpacked['var'][24] = data[eVehicleCustomizationPart.ModRearWheelsVariation]
	end

	-- print('unpacked', json.encode(unpacked, { indent = true }))

	return unpacked
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
local VEHICLE_DAMAGE_MULTIPLIER_COLLISION_DAMAGE = 1.4
local VEHICLE_DAMAGE_MULTIPLIER_ENGINE_DAMAGE = 1.05

-- RegisterCommand('setvehicledamage', function(_, args, rawCommand)
--     local collisionDamageMult = tonumber(args[1]) or VEHICLE_DAMAGE_MULTIPLIER_COLLISION_DAMAGE
--     local engineDamageMult = tonumber(args[2]) or VEHICLE_DAMAGE_MULTIPLIER_ENGINE_DAMAGE
--     VEHICLE_DAMAGE_MULTIPLIER_COLLISION_DAMAGE = collisionDamageMult
--     VEHICLE_DAMAGE_MULTIPLIER_ENGINE_DAMAGE = engineDamageMult
--     TriggerEvent("Notify","azul","VEHICLE_DAMAGE_MULTIPLIER_COLLISION_DAMAGE: "..string.format("%.2f", VEHICLE_DAMAGE_MULTIPLIER_COLLISION_DAMAGE).."x")
--     TriggerEvent("Notify","azul","VEHICLE_DAMAGE_MULTIPLIER_ENGINE_DAMAGE: "..string.format("%.2f", VEHICLE_DAMAGE_MULTIPLIER_ENGINE_DAMAGE).."x")
-- end)

-- RegisterCommand('getvehicledamage', function(_, args, rawCommand)
--     TriggerEvent("Notify","azul","VEHICLE_DAMAGE_MULTIPLIER_COLLISION_DAMAGE: "..string.format("%.2f", VEHICLE_DAMAGE_MULTIPLIER_COLLISION_DAMAGE).."x")
--     TriggerEvent("Notify","azul","VEHICLE_DAMAGE_MULTIPLIER_ENGINE_DAMAGE: "..string.format("%.2f", VEHICLE_DAMAGE_MULTIPLIER_ENGINE_DAMAGE).."x")
-- end)

-- -- Debug: checar vida e resistência do veículo atual (identificar se bulletproof está ok)
-- RegisterCommand("checkveh", function()
--     local ped = PlayerPedId()
--     if not IsPedInAnyVehicle(ped, false) then
--         if sx and sx.logger then sx.logger:info("checkveh: você precisa estar dentro de um veículo") end
--         return
--     end
--     local veh = GetVehiclePedIsIn(ped, false)
--     local bodyHealth = GetEntityHealth(veh)
--     local engineHealth = GetVehicleEngineHealth(veh)
--     local modelHash = GetEntityModel(veh)
--     local collisionMult = GetVehicleHandlingFloat(veh, "CHandlingData", "fCollisionDamageMult")
--     local engineMult = GetVehicleHandlingFloat(veh, "CHandlingData", "fEngineDamageMult")
--     local isBulletProof = IsBulletProofByHash(modelHash)
--     local msg = ("checkveh | Vida: %d | Motor: %.0f | CollisionMult: %.2f | EngineMult: %.2f | Resistente (bulletproof): %s"):format(bodyHealth, engineHealth, collisionMult, engineMult, isBulletProof and "SIM" or "NAO")
--     if sx and sx.logger then sx.logger:info(msg) end
-- end, false)

function CreateClientVehicle(Network,Engine,Health, packedCustomization, brokenWindowsFlag, burstTyresFlag,Degrade,Owner, Model, Color, serverCreatedEntity )

    local Count = 0
    -- local VipBoost = 0
    local Player = GetPlayerServerId(PlayerId())

    if not serverCreatedEntity then
        if Owner and Player == Owner then
            while not NetworkDoesNetworkIdExist(Network) do
                Count = Count + 1
                if Count >= 1000 then
                    Count = 0
                    break
                end
                Wait(10)
            end
            local Vehicle = NetToEnt(Network)
            while not DoesEntityExist(Vehicle) do
                Count = Count + 1
                if Count >= 1000 then
                    Count = 0
                    break
                end
                Wait(10)
            end
            local Vehicle = NetToEnt(Network)
            SetVehicleFuelLevel(Vehicle,100.0)
            -- VipBoost = vSERVER.HasVipBooster()
        end
    end
	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) then
            -- if Owner and GetPlayerServerId(PlayerId()) == Owner then
                SetEntityInvincible(Vehicle, false)
                SetNetworkVehicleAsGhost(Vehicle, true)
                SetEntityAlpha(Vehicle, 255)
                local vehList = GetGamePool('CVehicle')
        
                for k,v in pairs(vehList) do
                    SetEntityNoCollisionEntity(v, Vehicle, true)
                end
                SetTimeout(10000, function()
                    SetNetworkVehicleAsGhost(Vehicle, false)
                    SetEntityAlpha(Vehicle, 255)
                    ResetEntityAlpha(Vehicle)
                    SetEntityCanBeDamaged(Vehicle, true)
                    local vehList = GetGamePool('CVehicle')
        
                    for k,v in pairs(vehList) do
                        SetEntityNoCollisionEntity(v, Vehicle, false)
                    end
                end)
			-- end

            if Color then
                local R,G,B = Color:match("([^,]+),([^,]+),([^,]+)")
                SetVehicleCustomPrimaryColour(Vehicle,parseInt(R),parseInt(G),parseInt(B))
                SetVehicleCustomSecondaryColour(Vehicle,parseInt(R),parseInt(G),parseInt(B))
            end

			if packedCustomization ~= nil then
				local Customize = UnpackVehicleCustomization(packedCustomization)

                -- print('packedCustomization', json.encode(packedCustomization, { indent = true }))
                -- print('Customize', json.encode(Customize, { indent = true }))

				VehicleMods(Vehicle, Customize)    
			end

            -- SG-x-2
            local _, bulletProof, fireProof, explosionProof, collisionProof, meleeWeaponProof, steamProof, p7Proof, drownProof, drownProof = GetEntityProofs( Vehicle )
            SetEntityProofs( Vehicle, bulletProof, fireProof, true, collisionProof, meleeWeaponProof, steamProof, p7Proof, drownProof, drownProof )

            SetVehicleFuelLevel(Vehicle,100.0)
			SetVehicleEngineHealth(Vehicle,Engine + 0.0)
			SetEntityHealth(Vehicle,Health)
            local Name = Model
			local Model = GetEntityModel(Vehicle)

			-- print('brokenWindowsFlag', brokenWindowsFlag)

			for doorIndex = 0, GetNumberOfVehicleDoors(Vehicle) - 1 do
				local isBroken = ( brokenWindowsFlag & (1 << (doorIndex)) ) ~= 0

				-- print('isBroken', doorIndex, isBroken)

				if isBroken then
					RemoveVehicleWindow(Vehicle, doorIndex)
				end
			end

			-- print('burstTyresFlag', burstTyresFlag)

			for tyreIndex = 0, 7 do
				local isBurst = ( burstTyresFlag & (1 << (tyreIndex)) ) ~= 0

				-- print('isBurst', tyreIndex, isBurst)

				if isBurst then
					SetVehicleTyreBurst(Vehicle, tyreIndex, true, 1000.0)
				end
			end
            -- if VehicleVip(Model) then
            --     ModifyVehicleTopSpeed(Vehicle,30.0)
            -- end
            --if GetVehicleClass(Vehicle) ~= 18 then
                if Degrade ~= 0 then
                    local Init = GetVehicleHandlingFloat(Vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
                    local Result = Init / 100 * Degrade

                    SetVehicleHandlingFloat(Vehicle,"CHandlingData","fInitialDriveMaxFlatVel",Init - Result + 0.0)
                    SetVehicleModKit(Vehicle,0)
                    SetVehicleMod(Vehicle,11,GetVehicleMod(Vehicle,11),true)
                end
            --end
            local BoostList = exports['variables']:GetVariable('variables','BoostList') or {}
            if BoostList[Name] then
                local Init = GetVehicleHandlingFloat(Vehicle,"CHandlingData","fInitialDriveForce")
                SetVehicleHandlingFloat(Vehicle, "CHandlingData", "fInitialDriveForce",Init + BoostList[Name])
                SetVehicleModKit(Vehicle,0)
                SetVehicleMod(Vehicle,11,GetVehicleMod(Vehicle,11),true)
            end
            --if GetVehicleClass(Vehicle) ~= 18 then
            if isModelNative(Name) and cityName ~= "Fronteira" then
                local Init = GetVehicleHandlingFloat(Vehicle,"CHandlingData","fInitialDriveForce")
                local InitStering = GetVehicleHandlingFloat(Vehicle,"CHandlingData","fSteeringLock")
                local InitCurveMax = GetVehicleHandlingFloat(Vehicle,"CHandlingData","fTractionCurveMax")
                local InitCurveMin = GetVehicleHandlingFloat(Vehicle,"CHandlingData","fTractionCurveMin")
                local InitDriveInertia = GetVehicleHandlingFloat(Vehicle,"CHandlingData","fDriveInertia")    
                local InitBrakeForce = GetVehicleHandlingFloat(Vehicle,"CHandlingData","fBrakeForce")                
                SetVehicleHandlingFloat(Vehicle, "CHandlingData", "fInitialDriveForce",Init + 0.3 )
                SetVehicleHandlingFloat(Vehicle,"CHandlingData","fSteeringLock",InitStering + 0.3 )
                SetVehicleHandlingFloat(Vehicle,"CHandlingData","fTractionCurveMax",InitCurveMax + 0.3 )
                SetVehicleHandlingFloat(Vehicle,"CHandlingData","fTractionCurveMin",InitCurveMin + 0.3 )
                SetVehicleHandlingFloat(Vehicle,"CHandlingData","fDriveInertia",InitDriveInertia + 0.3)
                SetVehicleHandlingFloat(Vehicle,"CHandlingData","fBrakeForce",InitBrakeForce + 1.0)
                SetVehicleModKit(Vehicle,0)
                SetVehicleMod(Vehicle,11,GetVehicleMod(Vehicle,11),true)
            end
            --end

            --SetVehicleDirtLevel(Vehicle,0.0)
			if not DecorExistOn(Vehicle,"PlayerVehicle") then
				DecorSetInt(Vehicle,"PlayerVehicle",-1)
			end

            -- if not serverCreatedEntity then
            --     if Owner and GetPlayerServerId(PlayerId()) == Owner then
            --         SetPedIntoVehicle(PlayerPedId(),Vehicle,-1)
            --     end
            -- end

            SetVehicleFuelLevel(Vehicle,100.0)
            local Model = GetEntityModel(Vehicle)
            if Model == GetHashKey("KVanVivo") then
                for i=1,6 do
                    SetVehicleExtra(Vehicle,i,false)
                end
            end
            -----------------------------------------------------------------------------------------------------------------
            -- MAKE VEHICLE STRONGER
            -----------------------------------------------------------------------------------------------------------------
            -- for i = 0, 5 do
            --     SetVehicleDoorCanBreak(Vehicle, i, false)
            -- end

            if not IsBulletProofByHash(Model) then
                SetVehicleHandlingFloat(Vehicle, "CHandlingData", "fCollisionDamageMult", VEHICLE_DAMAGE_MULTIPLIER_COLLISION_DAMAGE)
                SetVehicleHandlingFloat(Vehicle, "CHandlingData", "fEngineDamageMult", VEHICLE_DAMAGE_MULTIPLIER_ENGINE_DAMAGE)
            end
            -- SetVehicleHandlingFloat(Vehicle, "CHandlingData", "fPetrolTankVolume", 100.0)
            -- SetVehicleHandlingFloat(Vehicle, "CHandlingData", "fDeformationDamageMult", 0.0)
            -------------------------------------------------------------------------------------------------------------------
            SetVehicleDirtLevel(Vehicle,0.0)

            exports.admin:ApplyVehicleModelRGBColorOverride( Vehicle )
		end
	end
end

RegisterNetEvent('garage:createVehicle', CreateClientVehicle)


---@enum eVehicleCreatingFSMStatus
eVehicleCreatingFSMStatus =
{
    Continue = 0,
    Success  = 1,
    Failed   = 2,
}

---@type table<string, true | nil> -- A gente usa o bagName
local gOwnedVehiclesAlreadyEnteredIn = { }

AddStateBagChangeHandler( GARAGE_VEHICLE_IS_CREATING_STATEBAG_KEY, nil, function( bagName, key, value )

    sx.logger:debug( ('Handling vehicle creation -> "%s" value=%s'):format( bagName, value and json.encode( value ) or 'nil' ) )

    if value == nil then

        gOwnedVehiclesAlreadyEnteredIn[ bagName ] = nil

        return
    end

    local playerId = PlayerId()
    local localPlayerSource = GetPlayerServerId( playerId )

    ---@type VehicleCreationData
    local creationData = value

    local DEBUG_IS_VEHICLE_OWNER = creationData and creationData[ 1 ] == localPlayerSource

    ---@type number | nil
    local lastApplyAppearanceAttemptTime = nil

    local function UpdateVehicleCreating()

        -- print( ('garage:createVehicle aas -> "%s" value is %s'):format( bagName, value ) )

        if not value then

            if DEBUG_IS_VEHICLE_OWNER then

                local entityId = GetEntityFromStateBagName( bagName )

                local plateAppliedSuccessfully = creationData and GetVehicleNumberPlateText( entityId ) == creationData[ 2 ] or false

                sx.logger:debug( ('Handling My vehicle creation -> value is nil! netOwnerSource=%s plateAppliedSuccessfully=%s'):format( GetPlayerServerId( NetworkGetEntityOwner( entityId ) ), plateAppliedSuccessfully ) )
            end

            return eVehicleCreatingFSMStatus.Failed
        end

        local entityId = GetEntityFromStateBagName( bagName )

        if not DoesEntityExist( entityId ) then

            -- print( ('garage:createVehicle aas -> "%s" entityId does not exist'):format( bagName ) )

            if DEBUG_IS_VEHICLE_OWNER then

                sx.logger:debug( ('Handling My vehicle creation -> entityId does not exist!'):format( ) )
            end

            return eVehicleCreatingFSMStatus.Continue
        end

        assert( creationData )

        local vehicleOwnerSource = creationData[ 1 ]

        DEBUG_IS_VEHICLE_OWNER = vehicleOwnerSource == localPlayerSource

        local isVehicleOwner = vehicleOwnerSource == localPlayerSource

        local vehicleOwnerPlayerIdx = GetPlayerFromServerId( vehicleOwnerSource )

        if vehicleOwnerPlayerIdx ~= -1 then

            local vehicleOwnerPedId = GetPlayerPed( vehicleOwnerPlayerIdx )

            if vehicleOwnerPedId ~= 0 then

                SetEntityNoCollisionEntity( entityId, vehicleOwnerPedId, true )
            end
        end

        Citizen.InvokeNative(`ADD_VEHICLE_DELETION_TRACE` & 0xFFFFFFFF, entityId )
        if isVehicleOwner then

            if not gOwnedVehiclesAlreadyEnteredIn[ bagName ] then

                if GetPedInVehicleSeat( entityId, -1 ) ~= PlayerPedId() then

                    -- Previnir `Teleportar para o Veiculo` do AC
                    LocalPlayer.state.forcedJoin_time = GetGameTimer()

                    SetPedIntoVehicle( PlayerPedId(), entityId, -1 )

                    gOwnedVehiclesAlreadyEnteredIn[ bagName ] = true
                end
            end
        end

        -- sx.logger:info( ('garage:createVehicle -> "%s" playerId= %s NetworkGetEntityOwner= %s'):format( bagName, playerId, NetworkGetEntityOwner( entityId ) ) )

        if NetworkGetEntityOwner( entityId ) ~= playerId then

            -- print( ('garage:createVehicle aas -> "%s" entityId is not owned by playerId'):format( bagName ) )

            if DEBUG_IS_VEHICLE_OWNER then

                sx.logger:debug( ('Handling My vehicle creation -> we are not the owner of the entity!'):format( GetPlayerServerId( NetworkGetEntityOwner( GetEntityFromStateBagName( bagName ) ) ) ) )
            end

            return eVehicleCreatingFSMStatus.Continue
        end

        -- print( ('garage:createVehicle aas -> "%s" entityId is %s'):format( bagName, entityId ) )

        if GetVehicleNumberPlateText( entityId ) == creationData[2] then

            -- sx.logger:debug( ('Handling vehicle creation -> "%s" vehicle plate is already applied'):format( bagName ) )

            return eVehicleCreatingFSMStatus.Continue
        end

        if lastApplyAppearanceAttemptTime and ( GetGameTimer() - lastApplyAppearanceAttemptTime < 300 --[[ os SyncNode de aparencia a atualiza a cada 400-1000ms ]] ) then

            -- Aguardar 100ms a cada tentativa

            -- sx.logger:debug( ('Handling vehicle creation -> "%s" vehicle plate is already applied'):format( bagName ) )

            return eVehicleCreatingFSMStatus.Continue
        end

        lastApplyAppearanceAttemptTime = GetGameTimer()

        assert( creationData, ('garage:createVehicle aas -> "%s" value is nil'):format( bagName ) )

        local plate = creationData[ 2 ]

        local entityId = GetEntityFromStateBagName( bagName )

        assert( entityId, ('garage:createVehicle aas -> "%s" entityId is nil'):format( bagName ) )

        sx.logger:debug( ('Handling vehicle creation -> "%s" vehicle creating applying stuff netOwnerSource=%s entityId= %s creationData=%s'):format( bagName, GetPlayerServerId( NetworkGetEntityOwner( entityId ) ), entityId, json.encode( creationData ) ) )

        SetVehicleNumberPlateText( entityId, plate )

        SetVehRadioStation(entityId, 'OFF' )
        SetVehicleFuelLevel( entityId, 100.0 )

        if GetEntityModel( entityId ) ~= `wheelchair` then

            SetVehicleDoorsLocked( entityId, 2 )
        end

        local vehicleAppearanceData = creationData[ 3 ]

        -- sx.logger:debug( ('Handling vehicle creation -> "%s" vehicleAppearanceData=%s'):format( bagName, json.encode( vehicleAppearanceData, { indent = true } ) ) )

        if vehicleAppearanceData then

            local networkId = VehToNet( entityId )

            vehicleAppearanceData.engineHealth = vehicleAppearanceData.hasMaxEngineHealth and 1000 or vehicleAppearanceData.engineHealth
            vehicleAppearanceData.bodyHealth   = vehicleAppearanceData.hasMaxBodyHealth and 1000 or vehicleAppearanceData.bodyHealth

            local modelName = GetEntityArchetypeName( entityId )

            CreateClientVehicle( networkId, vehicleAppearanceData.engineHealth, vehicleAppearanceData.bodyHealth, vehicleAppearanceData.customize, vehicleAppearanceData.brokenWindowsFlag, vehicleAppearanceData.burstTyresFlag, vehicleAppearanceData.degrade, creationData[ 1 ], modelName, vehicleAppearanceData.color, true )
        end

        if isVehicleOwner then
            exports.admin:ApplyVehicleModelRGBColorOverride( entityId )
        end

        sx.logger:debug( ('Handling vehicle creation -> "%s" vehicle created successfully'):format( bagName ) )

        -- Continuar ate o valor ser nullo!
        return eVehicleCreatingFSMStatus.Continue
    end

    ---@type eVehicleCreatingFSMStatus | nil
    local status = nil

    repeat

        Wait( 0 )

        -- sx.logger:debug( ('Awaiting vehicle creating! bagName=%s status=%s value=%s'):format( bagName, status, json.encode( value ) ) )

        value = GetStateBagValue( bagName, GARAGE_VEHICLE_IS_CREATING_STATEBAG_KEY )

        creationData = value

        status = UpdateVehicleCreating()

    until status ~= eVehicleCreatingFSMStatus.Continue

    -- TODO: REMOVEME
    -- sx.logger:expect( status == eVehicleCreatingFSMStatus.Success, ('status is not success status= %s'):format( status ) )

    if DEBUG_IS_VEHICLE_OWNER then

        sx.logger:debug( ('Handling My vehicle creation -> "%s" status is success status= %s'):format( bagName, status ) )
    end

    -- if status ~= eVehicleCreatingFSMStatus.Success then
    --     return
    -- end
end)

-- AddStateBagChangeHandler( GARAGE_VEHICLE_IS_CREATING_STATEBAG_KEY, nil, function( bagName, key, value )

--     --[[

--     Logica separada da criaçao/sem colisao do veiculo pois aqui
--     nao ligamos se o statebag for removido, so queremos entrar no veiculo
--     ou dar timeout!

--     --]]
    
--     -- print( ('garage:createVehicle asda -> "%s" value is %s'):format( bagName, value ) )

--     sx.logger:debug( ('Entering vehicle -> "%s" value is %s'):format( bagName, json.encode( value ) ) )

--     if value == nil then
--         return
--     end

--     ---@type VehicleCreationData
--     local creationData = value

--     local ownedBySource = creationData[ 1 ]
--     local plate = creationData[ 2 ]

--     local source = ToSource( GetPlayerServerId( PlayerId() ) )

--     sx.logger:debug( ('Entering vehicle -> "%s" source= %s type= %s ownedBySource= %s type= %s'):format( bagName, source, type(source), ownedBySource, type(ownedBySource) ) )

--     if source ~= ownedBySource then
--         return
--     end

--     local timeoutAt = GetGameTimer() + 10000

--     ---@return eVehicleCreatingFSMStatus
--     local function AttemptSetVehicleOwnerIntoVehicle()

--         if GetGameTimer() > timeoutAt then

--             -- Falhamos totalmente, vamos ignorar essa entidade :(

--             -- TODO: Tell the server we failed to moount the vehicle :(

--             sx.logger:debug( ('Entering vehicle -> "%s" timeout'):format( bagName ) )

--             return eVehicleCreatingFSMStatus.Failed
--         end

--         local entityId = GetEntityFromStateBagName( bagName )

--         if not DoesEntityExist( entityId ) then
--             return eVehicleCreatingFSMStatus.Continue
--         end

--         if GetVehicleNumberPlateText( entityId ) ~= plate then

--             -- Aguardar a placa ser aplicada por alguem!

--             return eVehicleCreatingFSMStatus.Continue
--         end

--         return eVehicleCreatingFSMStatus.Success
--     end

--     ---@type eVehicleCreatingFSMStatus | nil
--     local status = nil

--     repeat

--         Wait( 0 )

--         status = AttemptSetVehicleOwnerIntoVehicle()

--     until status ~= eVehicleCreatingFSMStatus.Continue

--     assert( status == eVehicleCreatingFSMStatus.Success, ('garage:createVehicle asda -> "%s" status is not success status= %s'):format( bagName, status ) )

--     local entityId = GetEntityFromStateBagName( bagName )

--     assert( entityId, ('garage:createVehicle asda -> "%s" entityId is nil'):format( bagName ) )

--     SetPedIntoVehicle( PlayerPedId(), entityId, -1 )
-- end)

AddStateBagChangeHandler( 'Spawned', nil, function( bagName, key, value )

    --[[

    Hack para manter a blindagem das rodas dos veiculos blindados criados pelo servidor!

    Veiculos criados pelo servidor definem "m_tyresDontBurst" como "false" por padrao, o que em
    no caso normal ( veiculos criados pelo client ) nao aconteceria, o client seria responsavel por definir essa valor baseado
    nas flags dos veiculos.

    E o creationData nao aceita updates, entao mesmo que a gente use "SetVehicleTyresCanBurst" com os veiculos criados pelo servidor, esse update
    nao sera replicado para os demais jogadores...

    ]]

    -- sx.logger:debug( ('bulletproof wheels -> "%s" value is %s'):format( bagName, value ) )

    local timeoutAt = GetGameTimer() + 10000

    local entityId = nil

    while true do

        entityId = GetEntityFromStateBagName( bagName )

        if GetGameTimer() > timeoutAt then

            -- sx.logger:error( ('bulletproof wheels error -> "%s" timeout'):format( bagName ) )

            return
        end

        if DoesEntityExist( entityId ) then
            break
        end

        Wait( 0 )
    end

    assert( entityId, ('bulletproof wheels error -> "%s" entityId is nil'):format( bagName ) )

    local modelFlags = GetVehicleHandlingInt( entityId, 'CHandlingData', 'strModelFlags' )

    -- sx.logger:info( ('bulletproof wheels -> "%s" modelFlags= %s'):format( bagName, modelFlags ) )

    if ( modelFlags & 0x2000000 --[[ MF_NO_WHEEL_BURST ]] ) ~= 0 then

        -- Tem a flag de blindagem nas rodas?
        -- A gente precisa desse "hack" porque parece que o CreateVehicleServerSetter
        -- causa algum problema em replicar a flag de nao estourar as rodas

        -- sx.logger:info( ('bulletproof wheels -> "%s" modelFlags & MF_NO_WHEEL_BURST ~= 0'):format( bagName ) )

        SetVehicleTyresCanBurst( entityId, false )
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:DELETE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("garages:Delete")
AddEventHandler("garages:Delete",function(Vehicle,Admin)
	if not Vehicle or Vehicle == "" then
		Vehicle = vRP.ClosestVehicle(15)
	end

	if IsEntityAVehicle(Vehicle) then
		local Tyres = {}
		local Doors = {}
		local Windows = {}

		for i = 0,5 do
			Doors[i] = IsVehicleDoorDamaged(Vehicle,i)
		end

		for i = 0,5 do
			Windows[i] = IsVehicleWindowIntact(Vehicle,i)
		end

		for i = 0,7 do
			local Status = false

			if GetTyreHealth(Vehicle,i) ~= 1000.0 then
				Status = true
			end

			Tyres[i] = Status
		end

		if DecorExistOn(Vehicle,"PlayerVehicle") then
			DecorRemove(Vehicle,"PlayerVehicle")
		end

		if Admin then
			TriggerServerEvent("garages:Dv",GetVehicleNumberPlateText(Vehicle))
		end

		vSERVER._Delete(VehToNet(Vehicle),GetEntityHealth(Vehicle),GetVehicleEngineHealth(Vehicle),GetVehicleBodyHealth(Vehicle),GetVehicleFuelLevel(Vehicle),Doors,Windows,Tyres,Admin)
	end
end)
RegisterNetEvent("garages:Delete2")
AddEventHandler("garages:Delete2",function(Area)
    local Range = Area or 15
    local vehiclePool = GetGamePool('CVehicle')
    local Ped = PlayerPedId()
    local Coords = GetEntityCoords(Ped)
    for i = 1, #vehiclePool do 
        local Vehicle = vehiclePool[i]
        local VehCoords = GetEntityCoords(Vehicle) 
        local Distance = #(Coords - VehCoords)
        if Distance <= Range then
            TriggerServerEvent("garages:Dv2",GetVehicleNumberPlateText(Vehicle))
            DeleteEntity(Vehicle)
            -- print( ('DeleteEntity :: 3') )
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEARCHBLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.SearchBlip(Coords)
	if DoesBlipExist(Searched) then
		RemoveBlip(Searched)
		Searched = nil
	end

	Searched = AddBlipForCoord(Coords["x"],Coords["y"],Coords["z"])
	SetBlipSprite(Searched,225)
	SetBlipColour(Searched,2)
	SetBlipScale(Searched,0.6)
	SetBlipAsShortRange(Searched,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Veículo")
	EndTextCommandSetBlipName(Searched)

	SetTimeout(30000,function()
		RemoveBlip(Searched)
		Searched = nil
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEARCHBLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.GetVeicleType(Model)
    requestModel(Model, 5000)
    local VehicleType = getVehicleType(Model)
    return VehicleType
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:IMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("garages:Impound")
AddEventHandler("garages:Impound",function()
	local Impound = vSERVER.Impound()
	if parseInt(#Impound) > 0 then
		for k,v in pairs(Impound) do
			exports["dynamic"]:AddButton(v["name"],"Clique para iniciar a liberação.","garages:Impound",v["Model"],false,true)
		end

		exports["dynamic"]:openMenu()
	else
		--TriggerEvent("Notify","amarelo","Não possui veículos apreendidos.",5000)
		TriggerEvent("Notify2","#semCarroApreendido")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:PROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("garages:Propertys")
AddEventHandler("garages:Propertys",function(Table)
    Garages[Table[1]] = {
        ["Spawns"] = {
            ["Open"] = Table[2],
            ["Positions"] = {
                Table[3],
            }
        } 
    }
end)

RegisterNetEvent("garages:RemProperty")
AddEventHandler("garages:RemProperty",function(Number)
    Garages[Number] = {}
end)

RegisterNetEvent("garages:AllPropertys")
AddEventHandler("garages:AllPropertys",function(Table)
    for Name,Info in pairs(Table) do
        Garages[Info[1]] = {
            ["Spawns"] = {
                ["Open"] = Info[2],
                ["Positions"] = {
                    Info[3],
                }
            } 
        }
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
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

---@type number?
local gOpenGarageId = nil

-- Phone verification gate: when the player interacts with a garage without a
-- validated phone, we open the WhatsApp QR modal instead. The garage index is
-- parked here and resumes once register:phoneModalClosed fires (even if the
-- player dismisses the modal — it's a nudge, not a hard gate).
local PendingGarageIndex = nil

local function OpenGarageForIndex(i)
    if IsGarageBlockedByMinigame() then
        return false
    end

    local garagem = vSERVER.Vehicles(i)
    if not garagem then
        return false
    end

    print(json.encode(garagem))
    Opened = i
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "Visible", data = true })
                                gOpenGarageId = i
    SendNUIMessage({ action = "OpenGarage", data = garagem })

    CreateThread(function()
        while Opened do
            local idle = 100
            local Spawn = Garages[i]["Spawns"]["Open"]
            local Ped = PlayerPedId()
            local Coords = GetEntityCoords(Ped)
            local Distance = #(Coords - vec3(Spawn["x"], Spawn["y"], Spawn["z"]))
            if Distance >= 2.5 then
                Opened = nil
                SetNuiFocus(false, false)
                SendNUIMessage({ action = "Visible", data = false })
            end
            Wait(idle)
        end
    end)

    return true
end

AddEventHandler("register:phoneModalClosed", function(validated)
    local pending = PendingGarageIndex
    if not pending then return end
    PendingGarageIndex = nil
    OpenGarageForIndex(pending)
end)

function StartInteraction()
    local Table = {}
    for i=1,#Garages do
        if Garages[i] and Garages[i]["Spawns"] then
            local Spawn = Garages[i]["Spawns"]["Open"]
            interact.addCoords({
                id = "garage:"..tostring(i),
                coords = vec3(Spawn["x"],Spawn["y"],Spawn["z"]),
                options = {
                    {
                        label = _t("openGarages"),
                        icon = "car",
                        onSelect = function(data)
                            local needsPhone = false
                            -- local ok = pcall(function()
                            --     needsPhone = exports["register"]:NeedToValidatePhone()
                            -- end)
                            -- if not ok then
                            --     needsPhone = false
                            -- end

                            if needsPhone then
                                PendingGarageIndex = i
                                TriggerServerEvent("register:requestPhoneValidation")
                                return
                            end

                            OpenGarageForIndex(i)
                        end,
                        canInteract = function(entity, distance, coords, id)
                            return Opened == nil
                                and PendingGarageIndex == nil
                                and not IsGarageBlockedByMinigame()
                        end
                    }
                },
                renderDistance = 25.0,
                activeDistance = 1.5,
                cooldown = 1500
            })
        end
    end
end

RegisterNUICallback("GetGarage",function(Data,callback)
    if not gOpenGarageId then
        return callback({})
    end

    local vehicles = vSERVER.Vehicles(gOpenGarageId)

    if not vehicles then
        return callback({})
    end

    callback(vehicles)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
local NearGarage = false
local LastDistance = 999
CreateThread(function()
	while true do
		local TimeDistance = 999
        local Ped = PlayerPedId()
		if not IsGarageBlockedByMinigame() and LocalPlayer["state"]["Route"] < 900000 and NearGarage then
            -- local Info = Garages[NearGarage]
            local Info = Garages[NearGarage]["Spawns"]["Open"]
			if not IsPedInAnyVehicle(Ped) then
				local Coords = GetEntityCoords(Ped)
                local Distance = #(Coords - vec3(Info["x"],Info["y"],Info["z"]))
                if Distance <= 50.0 then
                    LastDistance = Distance
                    TimeDistance = 0
                    DrawMarker(36,Info["x"],Info["y"],Info["z"],0,0,0,vec3(0.0, 0.0, 0.0),vec3(1.0, 1.0, 1.0),THEME.rgb.r, THEME.rgb.g, THEME.rgb.b, 94,false,false,2,true,nil,nil,false)
                    DrawMarker(27,Info["x"],Info["y"],Info["z"]- 0.9,0,0,0,vec3(0.0, 0.0, 0.0),vec3(1.0, 1.0, 1.0),THEME.rgb.r, THEME.rgb.g, THEME.rgb.b, 94,false,false,2,true,nil,nil,false)
                else
                    NearGarage = false
                    LastDistance = 999
                end
			end
		end
		Wait(TimeDistance)
	end
end)

CreateThread(function()
    while true do
        local idle = 1500
        local ped = PlayerPedId()
        local Coords = GetEntityCoords(ped)
        for i=1,#Garages do
            if Garages[i] and Garages[i]["Spawns"] then
                local Info = Garages[i]["Spawns"]["Open"]
                local Distance = #(Coords - vec3(Info["x"],Info["y"],Info["z"]))
                if Distance <= 50 then
                    if LastDistance > Distance then
                        NearGarage = i
                        LastDistance = Distance
                    end
                end
            end
        end
        Wait(idle)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	SendNUIMessage({ action = "Visible", data = false })
	SetNuiFocus(false,false)
    Opened = nil

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FAVORITE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("favoriteVehicle",function(Data,Callback)
    local response = vSERVER.SetFavorite(Data["model"])
	Callback(true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("garages:Close")
AddEventHandler("garages:Close",function()
	SendNUIMessage({ action = "Visible", data = false })
	SetNuiFocus(false,false)
    Opened = nil
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------


local spawningVehicle = false
RegisterNUICallback("takeVehicle",function(Data,Callback)
    if spawningVehicle then
        return Callback("Ok")
    end

    if GetGameTimer() >= Cooldown then
		Cooldown = GetGameTimer() + 5000
        spawningVehicle = true
        if requestModel(Data["model"], 5000) then
            vSERVER.Spawn(Data["model"],Opened)
        end
        spawningVehicle = false
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("storeVehicle",function(Data,Callback)
	if GetGameTimer() >= Cooldown then
		Cooldown = GetGameTimer() + 10000
		TriggerEvent("garages:Delete")
	end

	Callback("Ok")
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- SELLVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("sellVehicle",function(Data,Callback)
	SendNUIMessage({ action = "Visible", data = false })
	SetNuiFocus(false,false)
    Opened = nil
	vSERVER.Sell(Data["model"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFERVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("transferVehicle",function(Data,Callback)
	SendNUIMessage({ action = "Visible", data = false })
	SetNuiFocus(false,false)
    Opened = nil
	vSERVER.Transfer(Data["model"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAXVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("taxVehicle",function(Data,Callback)
	SendNUIMessage({ action = "Visible", data = false })
	SetNuiFocus(false,false)
    Opened = nil
	vSERVER.Tax(Data["model"])

	Callback("Ok")
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORT LIMBO
-----------------------------------------------------------------------------------------------------------------------------------------
function CreatePeds()
    for i=1,#Garages do
        if Garages[i] and Garages[i]["Ped"] then
            local TablePed = Garages[i]["Ped"]
            local TableSpawn = Garages[i]["Spawns"]["Open"]
            TablePed["Coords"] = {TableSpawn["x"],TableSpawn["y"],TableSpawn["z"],TableSpawn["w"]}
            exports["player"]:AddPedToList(TablePed)
        end
    end
end
CreateThread(function()
    CreatePeds()
	while true do
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)
		local Vehicle = GetVehiclePedIsIn(Ped)

        if IsEntityVisible(Ped) and Coords["z"] < -100 then
            --  ()
            if Vehicle and Vehicle ~= 0 then
                TriggerEvent("garages:Delete",Vehicle)
            end
        end
		
		Wait(1000)
	end
end)

function teleportProximityLimbo()
    local Ped = PlayerPedId()
    local AvailableGarages = Garages
    local InitialCoords = GetEntityCoords(Ped)
    local Coords = vector2(InitialCoords["x"],InitialCoords["y"])
    local Selected = false
    local Closest = 750
    for i=1,#Garages do
        if Garages[i] and Garages[i]["Spawns"] and not Garages[i]["Teleport"] then
            if not Garages[Number]["Info"]["Perm"] then
                local Info = Garages[i]["Spawns"]["Open"]
                local GarageCoords = vector2(Info["x"],Info["y"])
                local Distance = #(Coords - GarageCoords)
                if Distance <= Closest then
                    Closest = Distance
                    Selected = vector3(Info["x"],Info["y"],Info["z"])
                end
            end
        end
    end
    if Selected then
        DoScreenFadeOut(2500)
        while not IsScreenFadedOut() do 
            Wait(5) 
        end
        SetEntityCoords(Ped,Selected)
        FreezeEntityPosition(Ped,true)
        RequestCollisionAtCoord(Selected.x,Selected.y,Selected.z)
        while not HasCollisionLoadedAroundEntity(Ped) do
            Wait(1)
        end
        FreezeEntityPosition(Ped,false)
        DoScreenFadeIn(5000)
        --TriggerEvent("Notify","vermelho","Você caiu no limbo e foi teleportado para a garagem mais próxima.",10000,"LIMBO")
    end
	    TriggerEvent("Notify2","#tpGaragem")
end

RegisterNUICallback("getCityName",function(Data,Callback)
    cityName = GetConvar("cityName", "")
    Callback(string.lower(cityName))
end)

RegisterNUICallback("getCityId",function(Data,Callback)
    cityName = GetConvar("cityName", "")
    Callback(string.lower(cityName))
end)

function LoadModel(Hash)
	local Hash = GetHashKey(Hash)

	while not HasModelLoaded(Hash) do
		RequestModel(Hash)
		Wait(1)
	end

	return true
end

RegisterCommand("generateconfig",function()
    local models = GetAllVehicleModels()
    local Message = ""
    for i=1,#models do
        local Hash = GetHashKey(models[i])
        local vType = ""
        --if LoadModel(Hash) then
            if IsThisModelACar(Hash) then
                vType = 'automobile'
            elseif IsThisModelABicycle(Hash) then
                vType = 'bicycle'
            elseif IsThisModelABike(Hash) then
                vType = 'bike'
            elseif IsThisModelABoat(Hash) then
                vType = 'boat'
            elseif IsThisModelAHeli(Hash) then
                vType = 'heli'
            elseif IsThisModelAPlane(Hash) then
                vType = 'plane'
            elseif IsThisModelAQuadbike(Hash) then
                vType = 'quadbike'
            elseif IsThisModelAnAmphibiousCar(Hash) then
                vType = 'amphibious_automobile'
            elseif IsThisModelAnAmphibiousQuadbike(Hash) then
                vType = 'amphibious_quadbike'
            elseif IsThisModelATrain(Hash) then
                vType = 'train'
            else
                vType = (class == 5 and 'submarinecar') or (class == 14 and 'submarine') or (class == 16 and 'blimp') or 'trailer'
            end
            Message = Message .. "['"..models[i]:lower().."'] = { ['type'] = '"..vType.."' },\n"
        --end
    end
    print(Message)

end)

function getVehicleType(model)
    print(model)
    if IsThisModelABike(model) then
        return 'bike'
    end

    -- Not really sure if quadbike is considered an automobile or a bike
    if IsThisModelACar(model) or IsThisModelAQuadbike(model) then
        return 'automobile'
    end

    if IsThisModelABoat(model) or IsThisModelAJetski(model) then
        return 'boat'
    end

    if IsThisModelAPlane(model) then
        return 'plane'
    end

    if IsThisModelAHeli(model) then
        return 'heli'
    end
end


function requestModel(model, timeout)
    if not tonumber(model) then model = joaat(model) end
    ---@cast model -string
    if HasModelLoaded(model) then return model end

    if not IsModelValid(model) then
        return sx.logger:error(("attempted to load invalid model '%s'"):format(model))
    end

    RequestModel(model)

    if not coroutine.isyieldable() then return model end

    return waitFor(function()
        if HasModelLoaded(model) then return model end
    end, ("failed to load model '%s'"):format(model), timeout)
end

function waitFor(cb, errMessage, timeout)
    local value = cb()

    if value ~= nil then return value end


    if timeout or timeout == nil then
        if type(timeout) ~= 'number' then timeout = 1000 end

        if IsDuplicityVersion() then
            timeout /= 50;
        else
            timeout -= GetFrameTime() * 1000;
        end
    end


    local start = GetGameTimer()
    local i = 0

    while value == nil do
        if timeout then
            i += 1

            if i > timeout then
                return error(('%s (waited %.1fms)'):format(errMessage or 'failed to resolve callback', (GetGameTimer() - start) / 1000), 2)
            end
        end

        Wait(0)
        value = cb()
    end

    return value
end

function Creative.SpawnVehicle(model, coords,heading, isnetworked, teleportInto)
    local ped = PlayerPedId()
    model = type(model) == 'string' and joaat(model) or model
    if not IsModelInCdimage(model) then return end
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end
    isnetworked = isnetworked == nil or isnetworked
    requestModel(model,5000)
    --print( ('Creative.SpawnVehicle :: isnetworked="%s"'):format( isnetworked ) )
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, heading, isnetworked, false)

    Citizen.InvokeNative(`ADD_VEHICLE_DELETION_TRACE` & 0xFFFFFFFF, veh )

    local Count = 0
    while not DoesEntityExist(veh) do
        Count = Count + 1
        if Count >= 1000 then
            Count = 0
            break
        end
        Wait(10)
    end
    local Network = VehToNet(veh)
    --print( ('Creative.SpawnVehicle :: Network="%s"'):format( Network ) )
    local Class = GetVehicleClass(veh)
    local Model = GetEntityArchetypeName(veh)
    local Plate = GetVehicleNumberPlateText(veh)
    local Speed = GetEntitySpeed(veh)
    local netid = NetworkGetNetworkIdFromEntity(veh)
    SetVehicleHasBeenOwnedByPlayer(veh, true)
    SetNetworkIdCanMigrate(netid, true)
    SetVehicleNeedsToBeHotwired(veh, false)
    SetVehRadioStation(veh, 'OFF')
    SetVehicleFuelLevel(veh, 100.0)
    SetModelAsNoLongerNeeded(model)

    if teleportInto then

        -- Previnir `Teleportar para o Veiculo` do AC
        LocalPlayer.state.forcedJoin_time = GetGameTimer()

        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    end

    if GetEntityModel(veh) ~= GetHashKey("wheelchair") then
        SetVehicleDoorsLocked(veh, 2)
    end

    return netid
end

---@param isLocked boolean
RegisterNetEvent( 'vehicle.on_doors_lock_state_changed', function( isLocked )

    TriggerEvent( 'Notify2'       , isLocked and '#lockVeic' or '#openVeic'      )
    TriggerEvent( 'sounds:Private', isLocked and 'locked'    or 'unlocked' , 0.7 )

	if GetVehiclePedIsIn( PlayerPedId() ) == 0 then

		vRP.playAnim( true, { 'anim@mp_player_intmenu@key_fob@','fob_click' }, false )

		Wait(350)

		vRP.stopAnim()
	end
end)


local GEN_VEHICLE_META_BATCH_SIZE = 1
local GEN_VEHICLE_META_BATCH_ENTRY_UPDATE_TIMEOUT = 30000

---@class GenVehicleMetaBatchEntry
---@field isValid boolean
---@field modelName string | nil
---@field processed boolean
---@field createdAt number | nil

---@class VehicleMetaEntry
---@field Name string
---@field Weight number
---@field Price number
---@field Mode string | nil
---@field Gems number
---@field VehicleType? string

---@type string[] | nil
local gVehicleMetaModels = nil

---@type table<string, string> | nil
local gVehicleMetaModelsVehicleType = nil
local gVehicleMetaModelsVehicleTypeKnownSize = 0

local gGenVehicleMetaIsActive = false

local gGenVehicleMetaBatchNextModelIndex = 1

---@type GenVehicleMetaBatchEntry[] | nil
local gGenVehicleMetaBatchEntries = nil

-- Batching variables for sending updates every 100 entries
local gVehicleMetaSendBatchSize = 100
local gVehicleMetaPendingBatch = {}
local gVehicleMetaBatchCounter = 0

---@param entryIndex number
---@param entry GenVehicleMetaBatchEntry
---@return boolean
local function UpdateGenVehicleMetaBatchEntry( entryIndex, entry )

    local modelName = entry.modelName

    if not entry.processed then

        if entry.createdAt and ( ( GetGameTimer() - entry.createdAt ) > GEN_VEHICLE_META_BATCH_ENTRY_UPDATE_TIMEOUT ) then

            print( 'Model processing timeouted!', modelName )

            return true
        end

        if not HasModelLoaded( modelName ) then

            -- print( 'Model not loaded', modelName )

            return false
        end

        local modelHash = GetHashKey( modelName )

        local createPos = GetEntityCoords( PlayerPedId() )

        if 		entryIndex == 1 then
            createPos = createPos + vector3( 1.0, 0.0, 0.0 )
        elseif entryIndex == 2 then
            createPos = createPos + vector3( 0.0, 1.0, 0.0 )
        elseif entryIndex == 3 then
            createPos = createPos + vector3( 2.0, 0.0, 0.0 )
        elseif entryIndex == 4 then
            createPos = createPos + vector3( 0.0, 2.0, 0.0 )
        elseif entryIndex == 5 then
            createPos = createPos + vector3( 3.0, 0.0, 0.0 )
        end

        local entityId = CreateVehicle( modelHash, createPos.x, createPos.y, createPos.z, 0.0, false, false )

        SetModelAsNoLongerNeeded( entry.modelName )

        local vehicleType = GetVehicleType( entityId )

        gVehicleMetaModelsVehicleType[ modelName ] = vehicleType
        gVehicleMetaModelsVehicleTypeKnownSize += 1

        -- Add to pending batch for sending updates
        gVehicleMetaPendingBatch[ modelName ] = vehicleType
        gVehicleMetaBatchCounter += 1

        -- Send batch when we reach the batch size
        if gVehicleMetaBatchCounter >= gVehicleMetaSendBatchSize then
            sx.logger:info(('Sending batch update with %d entries'):format(gVehicleMetaBatchCounter))
            TriggerServerEvent('net.vehicle_metas.gen_types_response', gVehicleMetaPendingBatch)
            
            -- Reset batch
            gVehicleMetaPendingBatch = {}
            gVehicleMetaBatchCounter = 0
        end

        DeleteEntity( entityId )

        entry.processed = true

        return false
    end

    print( 'is processed waint to unload', modelName, HasModelLoaded( modelName ) )

    if entry.processed then

        SetModelAsNoLongerNeeded( modelName )

        if HasModelLoaded( modelName ) --[[ and ( ( GetFrameCount() - entry.atFrame ) < 2 ) --]] then

            -- Aguardar o modelo ser liberado!
            -- Aguardar pelomenos X frames antes de liberar essa entry para ir para o proximo modelo

            return false
        end
    end

	return true
end

---@return boolean
function UpdateGenVehicleMetaBatch()

    local allValid = true

    for i= 1, GEN_VEHICLE_META_BATCH_SIZE do

        local entry = gGenVehicleMetaBatchEntries[ i ]

        if not entry.isValid then

            allValid = false

            if gGenVehicleMetaBatchNextModelIndex > #gVehicleMetaModels then
                goto continue
            end

            local modelName = gVehicleMetaModels[ gGenVehicleMetaBatchNextModelIndex ]

            gGenVehicleMetaBatchNextModelIndex += 1

            if not IsModelValid( modelName ) then

                goto continue
            end

            entry.isValid 	= true
            entry.modelName = modelName
            entry.createdAt   = GetGameTimer()

            RequestModel( modelName )
        end

        if entry.isValid then

            if UpdateGenVehicleMetaBatchEntry( i, entry ) then

                entry.isValid 	= false
                entry.modelName = nil
                entry.processed = false
                entry.createdAt   = nil
            end
        end

        ::continue::
    end

    -- print( 'All invalid and all models processed', allValid, gVehicleMetaModelsVehicleTypeKnownSize, #gVehicleMetaModels )

    if not allValid and gGenVehicleMetaBatchNextModelIndex > #gVehicleMetaModels then

        -- Ja gerou e percorreu todos os modelos, entao acabou

        print( 'All invalid and all models processed', allValid, gVehicleMetaModelsVehicleTypeKnownSize, #gVehicleMetaModels )

        return false
    end

	return true
end

function InitGenVehicleMeta()

    print( 'Starting vehicle meta generation' )

    assert( not gGenVehicleMetaIsActive, 'Vehicle meta generation is already active' )

    gVehicleMetaModels = { }
    gVehicleMetaModelsVehicleType = { }
    gVehicleMetaModelsVehicleTypeKnownSize = 0

    gGenVehicleMetaIsActive = true

    gGenVehicleMetaBatchNextModelIndex = 1
    gGenVehicleMetaBatchEntries = { }

    -- Initialize batching variables
    gVehicleMetaPendingBatch = {}
    gVehicleMetaBatchCounter = 0

	for i= 1, GEN_VEHICLE_META_BATCH_SIZE do

		gGenVehicleMetaBatchEntries[ i ] = { isValid = false, processed = false, createdAt = nil, modelName = nil }
	end

    a = 0

	for modelName, vehicleMetaEntry in pairs( VehicleGlobal() ) do

        if vehicleMetaEntry.VehicleType and vehicleMetaEntry.VehicleType ~= 'unknown' then
            goto continue
        end

        if not IsModelValid( modelName ) then
            goto continue
        end

        if a < 10 then
            print( 'Vehicle meta entry already has a vehicle type', modelName, json.encode( vehicleMetaEntry ) )

            a += 1
        end

        if gVehicleMetaModelsVehicleType[ modelName ] then
            goto continue
        end

        table.insert( gVehicleMetaModels, modelName )
        gVehicleMetaModelsVehicleType[ modelName ] = 'unknown'

        ---#DEBUG
        -- if #gVehicleMetaModels > 50 then
        --     break
        -- end
        ---#DEBUG end

        ::continue::
	end

    print( 'Vehicle meta models', #gVehicleMetaModels )

    function DrawText(x,y,z,Message)
        local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)
        if onScreen then
            BeginTextCommandDisplayText("STRING")
            AddTextComponentSubstringKeyboardDisplay(Message)
            SetTextColour(0,255,0,255)
            SetTextScale(0.35,0.35)
            SetTextFont(4)
            SetTextCentre(1)
            EndTextCommandDisplayText(_x,_y)
        end
    end

    while UpdateGenVehicleMetaBatch() do

        local fwrd = GetEntityForwardVector( PlayerPedId() )
        local pos = GetEntityCoords( PlayerPedId() )
        local pos2 = pos + fwrd * 1.0

        DrawText( pos2.x, pos2.y, pos2.z, 'Vehicle meta types generated: ' .. gVehicleMetaModelsVehicleTypeKnownSize .. ' / ' .. #gVehicleMetaModels)

        Wait( 0 )
    end

    -- Send final batch if there are remaining entries
    if gVehicleMetaBatchCounter > 0 then
        sx.logger:info(('Sending final batch with %d remaining entries'):format(gVehicleMetaBatchCounter))
        TriggerServerEvent('net.vehicle_metas.gen_types_response', gVehicleMetaPendingBatch)
    end

    gGenVehicleMetaIsActive = false

    gVehicleMetaModels = nil
    gVehicleMetaModelsVehicleType = nil
    gVehicleMetaModelsVehicleTypeKnownSize = 0

    gGenVehicleMetaIsActive = false

    gGenVehicleMetaBatchNextModelIndex = 1
    gGenVehicleMetaBatchEntries = nil
end

RegisterNetEvent( 'net.vehicle_metas.gen_types', InitGenVehicleMeta )


print( 'Vehicle meta generation client script loaded' )


function IsBulletProof(model)
    if type(model) ~= "string" then return false end
    model = model:lower()
    for i = 1, #BulletProofList do
        if BulletProofList[i]:lower() == model then
            return true
        end
    end
    return false
end

function IsBulletProofByHash(modelHash)
    if not modelHash or type(modelHash) ~= "number" then return false end
    for i = 1, #BulletProofList do
        if GetHashKey(BulletProofList[i]) == modelHash then
            return true
        end
    end
    return false
end

function Creative.GetVehicleModels()
    local vehiclesModels = GetAllVehicleModels()
    local formattedModels = {}
    for i=1,#vehiclesModels do
        local model = vehiclesModels[i]

        local isBaseGame = isModelNative(model)

        table.insert(formattedModels, { model, isBaseGame })
    end
    return formattedModels
end

exports('IsResourceFocusedUi', function()
    return IsNuiFocused()
end)

---@param models string[]
---@return table<string, string> vehicleTypes
exports("GetVehicleTypes", function(models)
	if type(models) ~= "table" then
		return {}
	end

	local definitions = VehicleGlobal()
	local vehicleTypes = {}

	for _, model in ipairs(models) do
		if type(model) == "string" then
			local definition = definitions[model] or definitions[string.lower(model)]
			local vehicleType = definition and definition.VehicleType or VehicleType(model)

			if type(vehicleType) == "string" then
				vehicleTypes[model] = vehicleType
			end
		end
	end

	return vehicleTypes
end)

--- Cria um mission train no contexto do resource de garages.
--- O native cria a composição completa (locomotiva e vagões), diferente do
--- fluxo de veículos comuns exposto pelo server-side da garagem.
---@param configIndex number
---@param x number
---@param y number
---@param z number
---@param direction boolean
---@param isNetwork boolean
---@param scriptHost boolean
---@return number entity
exports('CreateMissionTrain', function(configIndex, x, y, z, direction, isNetwork, scriptHost)
    return CreateMissionTrain(configIndex, x, y, z, direction, isNetwork, scriptHost)
end)
