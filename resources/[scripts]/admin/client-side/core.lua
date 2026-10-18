-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
Tunnel = module("vrp","lib/Tunnel")
Proxy = module("vrp","lib/Proxy")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("admin",Creative)
vSERVER = Tunnel.getInterface("admin")
vRP = Proxy.getInterface("vRP")
cityName = GetConvar("cityName", "")
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVISIBLABLES
-----------------------------------------------------------------------------------------------------------------------------------------
LocalPlayer["state"]:set("Spectate",false,true)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECORDINGROCKSTAR
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.recordingRockstar()
    if IsRecording() then
        StopRecordingAndSaveClip()
    else
        StartRecording(1)
    end
end

-- CreateThread(function()
--     local status = (LocalPlayer["state"]["Carry"] or LocalPlayer["state"]["InCarregar"]) and true or false
    
--     if LocalPlayer["state"]["Carry"] or LocalPlayer["state"]["InCarregar"] then 
--         SetEntityCollision(PlayerPedId(),false,false)
--     end
-- end)

local MIN_TO_CONSIDER_GROUND = 1.844176

function Creative.isPedFalling()
    local pedId = PlayerPedId()

  return IsPedFalling(pedId) or IsPedInFlyingVehicle(pedId) or (GetEntityHeightAboveGround(pedId) > MIN_TO_CONSIDER_GROUND)
end

--- prevenção de crash com objetos jogados no mapa
CreateThread(function()
    local WAITABLE = 5 * 1000

    local BLACK_LIST_SCENARIO_DROPS = {
        [`prop_amb_ciggy_01`] = true, -- /e fumar2
        [`prop_weld_torch`] = true, -- /e consertar
        [`prop_amb_beer_bottle`] = true, -- /e cerveja
        [`p_cs_joint_01`] = true, -- /e fumar4
        [`p_s_scuba_tank_s`] = true, --  sistema de mergulho
     }

    while true do 
        for key, entity in pairs(GetGamePool('CObject')) do 
            if BLACK_LIST_SCENARIO_DROPS[GetEntityModel(entity)] and GetEntityAttachedTo(entity) == 0 then 
                SetEntityAsMissionEntity(entity, true, true)
                DeleteEntity(entity)
            end
        end
        Wait(WAITABLE)
    end
end)

function Creative.GetModelDimensions(models)
    local response = {}
    for i = 1, #models do
        local model = models[i]
        local min, max = GetModelDimensions(model) 
        local size_vec = max - min
        size = size_vec.x + size_vec.y + size_vec.z
        response[model] = size
    end
    return response
end

function Creative.GetCoords()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    return coords
end

---@param heading string
---@param rows string[] | InputDialogRowProps[]
---@param options InputDialogOptionsProps[]?
---@return string[] | number[] | boolean[] | nil
function Creative.inputDialog(heading, rows, options)
    local input = lib.inputDialog(heading, rows, options)
    return input
end

---@param heading AlertDialogProps
function Creative.alertDialog(heading)
    return lib.alertDialog(heading)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SUPERPOWER
-----------------------------------------------------------------------------------------------------------------------------------------
local jump = false
function Creative.superPower()
    if not jump then
        jump = true
        TriggerEvent("Notify2","#jumpIn")
        while jump do
            SetSuperJumpThisFrame(PlayerId(),1000)
            Wait(0)
        end
    else
        jump = false
        TriggerEvent("Notify2","#jumpOut")
        SetSuperJumpThisFrame(PlayerId(),0)
    end
end

RegisterNetEvent('net.disable.jump', function()
    if jump then
        jump = false
        TriggerEvent("Notify2","#jumpOut")
        SetSuperJumpThisFrame(PlayerId(),0)
    end
end)

RegisterNetEvent('admin:setJump', function(value)
    jump = value
    TriggerEvent("Notify2", value and "#jumpIn" or "#jumpOut")
    SetSuperJumpThisFrame(PlayerId(), value and 1000 or 0)

    CreateThread(function()
        while jump do
            SetSuperJumpThisFrame(PlayerId(),1000)
            Wait(0)
        end
    end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- APAGAO
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    Wait(15000)
    if GlobalState["Blackout"] and GlobalState["Blackout"] == 1 then
        SetArtificialLightsState(true)
    else
        SetArtificialLightsState(false)
    end
end)

RegisterNetEvent("SetBlackout")
AddEventHandler("SetBlackout", function(cond)
    -- print(cond)
    local status = false
    if cond == 1 then
        status = true
    end
    SetArtificialLightsState(status)
end)

RegisterNetEvent("SetFreeze")
AddEventHandler("SetFreeze", function()
    local Ped = PlayerPedId()
    if IsEntityPositionFrozen(Ped) then
        FreezeEntityPosition(Ped,false)
    else
        FreezeEntityPosition(Ped,true)
    end
end)
RegisterNetEvent("RemFreeze")
AddEventHandler("RemFreeze", function()
    local Ped = PlayerPedId()
    FreezeEntityPosition(Ped,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORTWAY
-----------------------------------------------------------------------------------------------------------------------------------------
local FIND_GROUND_POS_NUM_STEPS = 10

---@param pos vector3
---@return boolean, vector3
local function StartFindFarAwayGroundPos( pos )

    local heightmapTopZ = GetHeightmapTopZForPosition( pos.x, pos.y )
    local heightmapBottomZ = GetHeightmapBottomZForPosition( pos.x, pos.y )

    -- print( ('StartFindFarAwayGroundPos -> pos.x=%0.2f, pos.y=%0.2f, heightmapTopZ=%0.2f heightmapBottomZ=%0.2f'):format( pos.x, pos.y, heightmapTopZ, heightmapBottomZ ) )

    ---@type number | nil
    local foundGroundZ = nil

    local startedAt = GetGameTimer()

    local heightmapZPerStep = ( heightmapTopZ + heightmapBottomZ ) / FIND_GROUND_POS_NUM_STEPS

    while true do

        Wait( 0 )

        if GetGameTimer() - startedAt > 3000 then

            print( ('StartFindFarAwayGroundPos -> Timeout!'):format() )

            break
        end

        -- Every new frame we'll go to the next step
        local heightmapZStep = GetFrameCount() % FIND_GROUND_POS_NUM_STEPS

        local heightmapZ = heightmapBottomZ + ( heightmapZPerStep * heightmapZStep )

        RequestCollisionAtCoord( pos.x, pos.y, heightmapZ )

        local hasGround, groundZ = GetGroundZFor_3dCoord( pos.x, pos.y, heightmapZ )

        -- print( ('StartFindFarAwayGroundPos -> heightmapZ=%s, hasGround=%s, groundZ=%s'):format( heightmapZ, hasGround, groundZ ) )

        if hasGround then

            foundGroundZ = groundZ

            break
        end
    end

    local resultFoundGround     = foundGroundZ ~= nil
    local resultFoundGroundPos  = vector3( pos.x, pos.y, foundGroundZ or heightmapMiddleZ )

    -- print( ('StartFindFarAwayGroundPos -> resultFoundGround=%s, resultFoundGroundPos=%s'):format( resultFoundGround, json.encode( resultFoundGroundPos ) ) )

    return resultFoundGround, resultFoundGroundPos
end

function Creative.teleportWay()

    local waypointBlip = GetFirstBlipInfoId(8)

    if not waypointBlip or waypointBlip == 0  then
        return
    end

    local x,y,z = table.unpack(GetBlipInfoIdCoord(waypointBlip,Citizen.ResultAsVector()))

    local waypointPos = vector3( x, y, z )

    local foundGround, groundPos = StartFindFarAwayGroundPos( waypointPos )

    TriggerEvent( 'admin:Teleport', groundPos )

    if not foundGround then

        -- Case a gente não ache o chão, vamos tentar novamente após sermos teleportados
        CreateThread(
            function()

                -- CreateThread vai aguardar um tick e a gente aguarda mais um pouco para dar chance do ground ser carregado
                Wait( 100 )

                local foundGround, groundPos = StartFindFarAwayGroundPos( waypointPos )

                if foundGround then

                    TriggerEvent( 'admin:Teleport', groundPos )
                end
            end
        )
    end

    return groundPos
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORTWAY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.teleportLimbo()
    local Ped = PlayerPedId()
    local Coords = GetEntityCoords(Ped)
    local _,xCoords = GetNthClosestVehicleNode(Coords["x"],Coords["y"],Coords["z"],1,0,0,0)

    SetEntityCoordsNoOffset(Ped,xCoords["x"],xCoords["y"],xCoords["z"] + 1,false,false,false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLETUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:vehicleTuning")
AddEventHandler("admin:vehicleTuning",function()
    local Ped = PlayerPedId()
    if IsPedInAnyVehicle(Ped) then
        local vehicle = GetVehiclePedIsUsing(Ped)

        SetVehicleModKit(vehicle,0)
        SetVehicleMod(vehicle,11,GetNumVehicleMods(vehicle,11) - 1,false)
        SetVehicleMod(vehicle,12,GetNumVehicleMods(vehicle,12) - 1,false)
        SetVehicleMod(vehicle,13,GetNumVehicleMods(vehicle,13) - 1,false)
        SetVehicleMod(vehicle,15,GetNumVehicleMods(vehicle,15) - 1,false)
        ToggleVehicleMod(vehicle,18,true)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTONCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
-- CreateThread(function()
-- 	while true do
-- 		if IsControlJustPressed(1,38) then
-- 			vSERVER.buttonTxt()
-- 		end
-- 		Wait(1)
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTONMAKERACE
-----------------------------------------------------------------------------------------------------------------------------------------
-- CreateThread(function()
-- 	while true do
-- 		if IsControlJustPressed(1,38) then
-- 			local Ped = PlayerPedId()
-- 			local vehicle = GetVehiclePedIsUsing(Ped)
-- 			local vehCoords = GetEntityCoords(vehicle)
-- 			local leftCoords = GetOffsetFromEntityInWorldCoords(vehicle,5.0,0.0,0.0)
-- 			local rightCoords = GetOffsetFromEntityInWorldCoords(vehicle,-5.0,0.0,0.0)

-- 			vSERVER.raceCoords(vehCoords,leftCoords,rightCoords)
-- 		end

-- 		Wait(1)
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:INITSPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
function GetAimRotation(player)
    local entity = GetPlayerPed(player)
    local success, target = GetEntityPlayerIsFreeAimingAt(PlayerId())

    if success and target == entity then
        -- Get the target entity's rotation
        local rotation = GetEntityRotation(target)

        -- Calculate the yaw, pitch, and roll angles from the rotation
        local yaw = rotation.z
        local pitch = rotation.x
        local roll = rotation.y

        -- Return the rotation angles
        return yaw, pitch, roll
    end

    -- If the player is not aiming at the entity, return nil
    return nil
end


RegisterNetEvent("admin:initSpectate")
AddEventHandler("admin:initSpectate",function(source)
    if not NetworkIsInSpectatorMode() then
        local Pid = GetPlayerFromServerId(source)
        local Ped = GetPlayerPed(Pid)

        LocalPlayer["state"]:set("Spectate",true,true)
        NetworkSetInSpectatorMode(true,Ped)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:RESETSPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:resetSpectate")
AddEventHandler("admin:resetSpectate",function()
    if NetworkIsInSpectatorMode() then
        NetworkSetInSpectatorMode(false)
        LocalPlayer["state"]:set("Spectate",false,true)
    end
end)

local CustomAudio = {
    ["Kingdom"] = "https://youtu.be/wu6zv1Ykj-Y",
}

AddStateBagChangeHandler("Quake",nil,function(Name,Key,Value)
    ShakeGameplayCam("SKY_DIVING_SHAKE",0.0)
    TriggerEvent("promotion_button:OpenAudio",CustomAudio[cityName] or "https://www.youtube.com/watch?v=EEpkUaAL8c8")
end)

local enable = false
local aPed =  false
local FF = false
function openWeaponWheel()
    if enable then
        aPed = not aPed
    end
end
RegisterCommand("+useless",openWeaponWheel)
RegisterCommand("-useless",openWeaponWheel)
RegisterKeyMapping("+useless","Useless","MOUSE_BUTTONANY","MOUSE_EXTRABTN5")
local Friends = {}
function Creative.spawnPeds(Spawn,Boolean)
    FF = Boolean or false
    enable = not enable
    local FOV = 60
    if Spawn then
        FOV = Spawn
    end
    print(FOV)
    local Ped = PlayerPedId()
    local Player = PlayerId()
    while true do
        if enable then
            local Distance = 425
            local Peds = GetGamePool('CPed')
            local Coords = GetEntityCoords(Ped)
            local ped
            local resX,resY = GetActiveScreenResolution()

            for i = 1, #Peds do
                if Ped ~= Peds[i] and IsEntityVisible(Peds[i]) then
                    if IsPedAPlayer(Peds[i]) and HasEntityClearLosToEntity(Ped,Peds[i],17) then
                        local Source = GetPlayerServerId((NetworkGetPlayerIndexFromPed(Peds[i])))
                        if Friends[tostring(Source)] then
                            goto Next
                        end
                        if GetEntityHealth(Peds[i]) > 100 and IsEntityOnScreen(Peds[i]) then
                            local PedCoords = GetEntityCoords(Peds[i])
                            local PedDistance = #(Coords - PedCoords)
                            local MinDistance = PedDistance <= 425
                            if MinDistance and PedDistance < Distance then
                                local boneCDS = GetPedBoneCoords(Peds[i], 31086)
                                local _, x, y = GetScreenCoordFromWorldCoord(boneCDS["x"],boneCDS["y"],boneCDS["z"])
                                if inFOV(x,y,resX,resY,FOV) then
                                    Distance = PedDistance
                                    ped = Peds[i]
                                end
                            end
                        end
                    end
                end
                ::Next::
            end
            
            if IsAimCamActive() and aPed then
                local c = GetPedBoneCoords(ped, 31086)
                local _, _x, _y = GetScreenCoordFromWorldCoord(c["x"],c["y"],c["z"])
                local selfpos, rot = GetFinalRenderedCamCoord(), GetEntityRotation(Ped, 2)
                local angleX, angleY, angleZ = (c - selfpos).x, (c - selfpos).y, (c - selfpos).z
                local roll, pitch, yaw = -math.deg(math.atan2(angleX, angleY)) - rot.z, math.deg(math.atan2(angleZ+0.08, #vector3(angleX, angleY, 0.0))), 1.0
                roll = 0.0+(roll-0.0)*(1.0)
                if inFOV(_x,_y,resX,resY,FOV) then
                    SetGameplayCamRelativeRotation(roll, pitch, yaw)
                end
            end
        else
            break
        end
        Wait(1)
    end
end

function inFOV(_x,_y,resX,resY,FOV)
    if (_x > 0.5 - ((FOV / 2)/resX) and _x < 0.5 + ((FOV / 2)/resX) and _y > 0.5 - ((FOV / 2)/resY) and _y < 0.5 + ((FOV / 2)/resY)) then
        return true
    end
    return false
end


CreateThread(function()
    RegisterFontFile('Poppins')
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("syncarea")
AddEventHandler("syncarea",function(x,y,z,distance)
    ClearAreaOfVehicles(x,y,z,distance + 0.0,false,false,false,false,false)
    ClearAreaOfEverything(x,y,z,distance + 0.0,false,false,false,false)
end)



RegisterNetEvent("admin:AddFriends")
AddEventHandler("admin:AddFriends",function(Table)
    Friends = Table
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SANGUE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommandLocalized("command.blood",function(source,args)
    local ped = PlayerPedId()
    ClearPedBloodDamage(ped)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PISCAR GOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:Piscar")
AddEventHandler("admin:Piscar",function()
    LocalPlayer["state"]["Invisible"] = true
    SetEntityVisible(PlayerPedId(),false,false)

    SetTimeout(1000,function()
        SetEntityVisible(PlayerPedId(),true,false)
        LocalPlayer["state"]["Invisible"] = false
    end)
end)

RegisterNetEvent("admin:Mute")
AddEventHandler("admin:Mute",function(Mute)
    local Ped = PlayerPedId()
    if Mute then
        exports['pma-voice']:overrideProximityCheck(function(player)
            return false
        end)
        Entity(Ped)["state"]:set("Muted",true,true)
    else
        exports['pma-voice']:resetProximityCheck()
        Entity(Ped)["state"]:set("Muted",false,true)
    end
end)
------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
------------------------------------------------------------------------------------------------------------------------------
local dickheaddebug = false
local inFreeze = false
RegisterNetEvent("ToggleDebug")
AddEventHandler("ToggleDebug",function()
    dickheaddebug = not dickheaddebug
    if dickheaddebug then
        TriggerEvent("chatMessage","DEBUG",{255,0,0},"ON")
    else
        TriggerEvent("chatMessage","DEBUG",{255,0,0},"OFF")
    end
    CreateThread(function()
        while dickheaddebug do
            local idle = 1
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            
            local forPos = GetOffsetFromEntityInWorldCoords(ped,0,1.0,0.0)
            local backPos = GetOffsetFromEntityInWorldCoords(ped,0,-1.0,0.0)
            local LPos = GetOffsetFromEntityInWorldCoords(ped,1.0,0.0,0.0)
            local RPos = GetOffsetFromEntityInWorldCoords(ped,-1.0,0.0,0.0)
            
            local forPos2 = GetOffsetFromEntityInWorldCoords(ped,0,2.0,0.0)
            local backPos2 = GetOffsetFromEntityInWorldCoords(ped,0,-2.0,0.0)
            local LPos2 = GetOffsetFromEntityInWorldCoords(ped,2.0,0.0,0.0)
            local RPos2 = GetOffsetFromEntityInWorldCoords(ped,-2.0,0.0,0.0)
            
            local x, y, z = table.unpack(GetEntityCoords(ped,true))
            local currentStreetHash,intersectStreetHash = GetStreetNameAtCoord(x,y,z,currentStreetHash,intersectStreetHash)
            currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
            
            drawTxtS(0.8, 0.50, 0.4,0.4,0.30, "~g~HEADING: ~r~"..GetEntityHeading(ped))
            drawTxtS(0.8, 0.52, 0.4,0.4,0.30, "~g~COORDS: ~r~"..pos)
            drawTxtS(0.8, 0.54, 0.4,0.4,0.30, "~g~ATTACHED ENT: ~r~"..GetEntityAttachedTo(ped))
            drawTxtS(0.8, 0.56, 0.4,0.4,0.30, "~g~HEALTH: ~r~"..GetEntityHealth(ped))
            drawTxtS(0.8, 0.58, 0.4,0.4,0.30, "~g~H a G: ~r~"..GetEntityHeightAboveGround(ped))
            drawTxtS(0.8, 0.60, 0.4,0.4,0.30, "~g~HASH: ~r~"..GetEntityModel(ped))
            drawTxtS(0.8, 0.62, 0.4,0.4,0.30, "~g~SPEED: ~r~"..GetEntitySpeed(ped))
            drawTxtS(0.8, 0.64, 0.4,0.4,0.30, "~g~FRAME TIME: ~r~"..GetFrameTime())
            drawTxtS(0.8, 0.66, 0.4,0.4,0.30, "~g~STREET: ~r~"..currentStreetName)
            
            DrawLine(pos,forPos,255,0,0,115)
            DrawLine(pos,backPos,255,0,0,115)
            
            DrawLine(pos,LPos,255,255,0,115)
            DrawLine(pos,RPos,255,255,0,115)
            
            DrawLine(forPos,forPos2,255,0,255,115)
            DrawLine(backPos,backPos2,255,0,255,115)
            
            DrawLine(LPos,LPos2,255,255,255,115)
            DrawLine(RPos,RPos2,255,255,255,115)
            
            -- local nearped = getNPC()
            local veh = GetVehicle()
            local nearobj = GetObject()
            if IsControlJustReleased(0,38) and IsInputDisabled(0) then
                if inFreeze then
                    inFreeze = false
                    TriggerEvent("Notify2","#freezeIn")
                else
                    inFreeze = true
                    TriggerEvent("Notify2","#freezeOut")
                end
            end
            Wait(Idle)
        end
    end)
end)

function GetVehicle()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstVehicle()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords,pos,true)
        if canPedBeUsed(ped) and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped
            FreezeEntityPosition(ped, inFreeze)
            if IsEntityTouchingEntity(playerped,ped) then
                DrawText3Ds(pos["x"],pos["y"],pos["z"]+1,"~g~VEHICLE: ~w~"..ped.." ~g~HASH: ~w~"..GetEntityModel(ped).." ~r~IN CONTACT",350)
            else
                DrawText3Ds(pos["x"],pos["y"],pos["z"]+1,"~g~VEHICLE: ~w~"..ped.." ~g~HASH: ~w~"..GetEntityModel(ped).."",350)
            end
        end
        success, ped = FindNextVehicle(handle)
    until not success
    EndFindVehicle(handle)
    return rped
end

function GetObject()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstObject()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords,pos,true)
        if distance < 10.0 then
            distanceFrom = distance
            rped = ped
            FreezeEntityPosition(ped,inFreeze)
            if IsEntityTouchingEntity(playerped,ped) then
                DrawText3Ds(pos["x"],pos["y"],pos["z"]+1,"~g~OBJECT: ~w~"..ped.." ~g~HASH: ~w~"..GetEntityModel(ped).." ~r~IN CONTACT",350)
            else
                DrawText3Ds(pos["x"],pos["y"],pos["z"]+1,"~g~OBJECT: ~w~"..ped.." ~g~HASH: ~w~"..GetEntityModel(ped).."",350)
            end
        end
        success, ped = FindNextObject(handle)
    until not success
    EndFindObject(handle)
    return rped
end

function getNPC()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords,pos,true)
        if canPedBeUsed(ped) and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped
            
            if IsEntityTouchingEntity(playerped,ped) then
                DrawText3Ds(pos["x"],pos["y"],pos["z"],"~g~PED: ~w~"..ped.." ~g~HASH: ~w~"..GetEntityModel(ped).." ~g~RELATIONSHIP HASH: ~w~"..GetPedRelationshipGroupHash(ped).." ~r~IN CONTACT",350)
            else
                DrawText3Ds(pos["x"],pos["y"],pos["z"],"~g~PED: ~w~"..ped.." ~g~HASH: ~w~"..GetEntityModel(ped).." ~g~RELATIONSHIP HASH: ~w~"..GetPedRelationshipGroupHash(ped),350)
            end
            
            FreezeEntityPosition(ped,inFreeze)
        end
        success,ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return rped
end

function canPedBeUsed(ped)
    if ped == nil then
        return false
    end
    if ped == PlayerPedId() then
        return false
    end
    if not DoesEntityExist(ped) then
        return false
    end
    return true
end

function drawTxtS(x,y,width,height,scale,text)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.25,0.25)
    SetTextDropShadow(0,0,0,0,255)
    SetTextEdge(1,0,0,0,255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x-width/2,y-height/3)
end

function DrawText3Ds(x,y,z,text,size)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    SetTextFont(4)
    SetTextScale(0.35,0.35)
    SetTextColour(255,255,255,150)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text))/size
    DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,80)
end
function DrawText3Dss(x,y,z,text,size)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    SetTextFont(4)
    SetTextScale(0.35,0.35)
    SetTextColour(255,255,255,255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

local StateBlips = false
PlayersBlips = {}

local players = {}
local updateEventCookie = nil
local lastUpdate = 0
local elapsedTime = 0

-- ── Interpolação dos blips ──────────────────────────────────────
-- Posições chegam ~1x/s. Para mover liso e em velocidade constante (sem o
-- "anda e para"), cada blip desliza linearmente de onde está (`from`) até o
-- novo ponto (`to`) ao longo de uma janela do tamanho do intervalo entre
-- updates daquele jogador. Roda TODO frame. A janela é multiplicada por um
-- fator > 1 para que o blip ainda esteja em movimento quando o próximo ponto
-- chega (nunca chega ao fim e congela) -> handoff contínuo.
-- Limites (ms) da janela de interpolação, contra jitter de rede.
local BLIP_MIN_DURATION = 200.0
local BLIP_MAX_DURATION = 2000.0
-- >1 garante que o blip nunca alcance o destino antes do próximo update.
local BLIP_DURATION_FACTOR = 1.15
-- Acima desta distância (m) entre updates tratamos como teleporte/troca de
-- mundo e fixamos o blip direto, em vez de deslizar atravessando o mapa.
local BLIP_TELEPORT_DISTANCE = 400.0

local blipsFetchGeneration = 0

local function RemoveBlips()
    for _,Info in pairs(players) do
        RemoveBlip(Info["blip"])
    end
    players = {}
    lastUpdate = 0
    elapsedTime = 0
    blipsFetchGeneration = blipsFetchGeneration + 1
    StateBlips = false
end

local function CreatePlayerBlip(serverId, coords, number)
    local blip = AddBlipForCoord(coords.x, coords.y, 0.0)

    SetBlipSprite(blip,1)
    SetBlipAsShortRange(blip,true)
    SetBlipColour(blip,GetBlipColor(number))
    SetBlipScale(blip,0.7)

    local now = GetGameTimer()
    players[serverId] = {
        blip           = blip,
        current        = coords,
        from           = coords,
        to             = coords,
        moveStart      = now,
        moveDuration   = 1000.0,
        lastUpdateTime = now,
    }
end

local function UpdatePlayerBlip(serverId, coords)
    local player = players[serverId]
    local now = GetGameTimer()

    -- Mede o intervalo real desde o último ponto deste jogador e usa como
    -- janela de interpolação (com piso/teto e fator de folga). Por jogador,
    -- então cada cadência de update (presença online ~1s, peds reais 250ms)
    -- é respeitada automaticamente.
    local interval = now - (player.lastUpdateTime or now)
    player.lastUpdateTime = now

    if interval > 0 then
        player.moveDuration = Clamp(interval, BLIP_MIN_DURATION, BLIP_MAX_DURATION) * BLIP_DURATION_FACTOR
    end

    if #(coords - player.current) > BLIP_TELEPORT_DISTANCE then
        -- Salto muito grande (teleporte/troca de bucket): fixa direto.
        player.from = coords
        player.to = coords
        player.current = coords
    else
        player.from = player.current
        player.to = coords
    end

    player.moveStart = now
end

local function UpdatePlayersCoords(playersCoords)
    local gameTimer = GetGameTimer()
    elapsedTime = gameTimer - lastUpdate
    lastUpdate = gameTimer
    local Done = {}
    for serverId, Info in pairs(playersCoords) do
        local serverId = tostring(serverId)
        local Coords = vector3(Info[1][1],Info[1][2],0.0)
        if players[serverId] then
            UpdatePlayerBlip(serverId, Coords, Info[2])
            Done[serverId] = true
        else
            Done[serverId] = true
            CreatePlayerBlip(serverId, Coords, Info[2])
        end
    end
    local Remove = {}
    for serverId,_ in pairs(players) do
        if not Done[serverId] then
            Remove[#Remove + 1] = serverId
        end
    end
    for _,serverId in ipairs(Remove) do
        RemoveBlip(players[serverId]["blip"])
        players[serverId] = nil
    end
end

local ONLINE_PRESENCE_BLIPS_DEFAULT_INTERVAL_MS = 1000
local ONLINE_PRESENCE_BLIPS_MIN_INTERVAL_MS = 250
local ONLINE_PRESENCE_BLIPS_DEFAULT_PAGE_LIMIT = 500
local ONLINE_PRESENCE_BLIPS_DEFAULT_MAX_PAGES = 40

local function readPositiveIntegerConvar(name, fallback)
    local value = tonumber(GetConvar(name, tostring(fallback)))

    if not value or value ~= value or value < 1 then
        return fallback
    end

    return math.floor(value)
end

local function readOnlinePresenceApiUrl()
    local url = GetConvar('sx_online_presence_url', '')

    if url == '' then
        -- `gApiUrl` só é inicializada no server-side; no client deste resource
        -- ela é nil, então lê-se a convar replicada `api_url` diretamente
        -- (mesmo padrão do client do sx).
        local apiUrl = GetConvar('api_url', '')
        if apiUrl == '' then
            return nil
        end

        url = ('%s:4013'):format(apiUrl)
    end

    if not url:match('^%a[%w+%-%.]*://') then
        url = ('http://%s'):format(url)
    end

    return (url:gsub('/+$', ''))
end

local function readOnlinePresenceBlipsIntervalMs()
    if sx and sx.onlinePresence and sx.onlinePresence.resolveIntervalMs then
        return sx.onlinePresence.resolveIntervalMs(
            GetConvar('online_presence_blips_interval_ms', tostring(ONLINE_PRESENCE_BLIPS_DEFAULT_INTERVAL_MS)),
            ONLINE_PRESENCE_BLIPS_MIN_INTERVAL_MS,
            ONLINE_PRESENCE_BLIPS_DEFAULT_INTERVAL_MS
        )
    end

    local intervalMs = tonumber(GetConvar('online_presence_blips_interval_ms', tostring(ONLINE_PRESENCE_BLIPS_DEFAULT_INTERVAL_MS)))

    if not intervalMs or intervalMs ~= intervalMs then
        return ONLINE_PRESENCE_BLIPS_DEFAULT_INTERVAL_MS
    end

    if intervalMs < ONLINE_PRESENCE_BLIPS_MIN_INTERVAL_MS then
        return ONLINE_PRESENCE_BLIPS_MIN_INTERVAL_MS
    end

    return math.floor(intervalMs)
end

local function shortBlipsError(value)
    if value == nil then
        return ''
    end

    value = tostring(value)
    if #value > 300 then
        return value:sub(1, 300)
    end

    return value
end

local function encodeOnlinePresenceComponent(value)
    return tostring(value):gsub('([^%w%-_%.~])', function(char)
        return ('%%%02X'):format(string.byte(char))
    end)
end

local function roundBlipCoord(value)
    value = value * 100

    if value >= 0 then
        return math.floor(value + 0.5) / 100
    end

    return math.ceil(value - 0.5) / 100
end

local function getOnlinePresenceToken()
    local resourceName = LIB_RESOURCE_NAME or 'sx'
    local ok, tokenInfo = pcall(function()
        return exports[resourceName]:GetPlayerAuthTokenInfo()
    end)

    return ok and tokenInfo and tokenInfo.accessToken or nil
end

-- Igual ao authFetch do F1: sem token ou 401 pede um token novo ao servidor, uma vez por token
-- (o tokensystem limita a troca a 1 a cada 3s e só reenvia o atual se ainda for válido).
local onlinePresenceRefreshedToken = false

local function requestFreshOnlinePresenceToken(token)
    if onlinePresenceRefreshedToken == token then
        return
    end

    onlinePresenceRefreshedToken = token
    TriggerServerEvent('net.sx.requestPlayerToken', true)
end

local function getCurrentBlipsWorldId()
    if vRP and vRP.GetCurrentRoutingBucket then
        return tonumber(vRP.GetCurrentRoutingBucket()) or 0
    end

    if LocalPlayer and LocalPlayer.state then
        return tonumber(LocalPlayer.state.Route) or 0
    end

    return 0
end

local function fetchOnlinePresenceJson(url, headers)
    if not (sx and sx.client and sx.client.nui and sx.client.nui.fetch) then
        return nil, 'sx NUI fetch is not available'
    end

    local okStatus = eHttpStatus and eHttpStatus.OK or 200
    local getMethod = eHttpMethod and eHttpMethod.GET or 'GET'
    local ok, response = pcall(sx.client.nui.fetch, url, {
        method = getMethod,
        headers = headers,
    })

    if not ok then
        return nil, ('transport=%s'):format(shortBlipsError(response))
    end

    if not response or response.status ~= okStatus then
        return nil, ('status=%s error=%s'):format(
            tostring(response and response.status),
            shortBlipsError(response and response.error)
        ), response and response.status
    end

    if type(response.data) ~= 'table' then
        return nil, 'invalid OnlinePresenceAPI response'
    end

    return response.data
end

local function fetchOnlinePresenceCityPlayers(adminWorldId)
    local token = getOnlinePresenceToken()
    if not token then
        requestFreshOnlinePresenceToken(nil)
        return nil, 'player session token is not available'
    end

    local apiUrl = readOnlinePresenceApiUrl()
    if not apiUrl then
        return nil, 'OnlinePresenceAPI url is not configured'
    end
    local pageLimit = readPositiveIntegerConvar('online_presence_blips_page_limit', ONLINE_PRESENCE_BLIPS_DEFAULT_PAGE_LIMIT)
    local maxPages = readPositiveIntegerConvar('online_presence_blips_max_pages', ONLINE_PRESENCE_BLIPS_DEFAULT_MAX_PAGES)
    local playersOnline = {}
    local cursor = nil
    local headers = {
        ['Accept'] = 'application/json',
        ['Authorization'] = ('Bearer %s'):format(token),
    }

    for page = 1, maxPages do
        local url = ('%s/v1/cities/%s/players/online?limit=%d&worldId=%d'):format(
            apiUrl,
            encodeOnlinePresenceComponent(GetConvar('cityName', '')),
            pageLimit,
            adminWorldId
        )

        if cursor ~= nil then
            url = ('%s&cursor=%s'):format(url, encodeOnlinePresenceComponent(cursor))
        end

        local data, errorMessage, status = fetchOnlinePresenceJson(url, headers)
        if not data then
            if status == (eHttpStatus and eHttpStatus.UNAUTHORIZED or 401) then
                requestFreshOnlinePresenceToken(token)
            end
            return nil, errorMessage
        end

        if type(data.players) ~= 'table' then
            return nil, 'invalid OnlinePresenceAPI players response'
        end

        for _, player in ipairs(data.players) do
            playersOnline[#playersOnline + 1] = player
        end

        cursor = data.nextCursor
        if cursor == nil then
            return playersOnline
        end
    end

    return nil, 'OnlinePresenceAPI pagination limit exceeded'
end

local function getOnlinePresenceBlipKey(player)
    if player.source then
        return tostring(player.source)
    end

    if player.profileId then
        return ('profile:%s'):format(player.profileId)
    end

    if player.passport then
        return ('passport:%s'):format(player.passport)
    end

    return nil
end

local function getOnlinePresenceBlipNumber(player)
    return tonumber(player.blipNumber or player.blip or player.Blip) or 57
end

local function buildOnlinePresenceBlips(onlinePlayers, adminWorldId)
    adminWorldId = tonumber(adminWorldId) or getCurrentBlipsWorldId()
    local playersCoords = {}

    for _, player in ipairs(onlinePlayers) do
        if tonumber(player.worldId) == adminWorldId then
            local coords = player.coords
            local x = coords and tonumber(coords.x) or nil
            local y = coords and tonumber(coords.y) or nil

            if x and y then
                local key = getOnlinePresenceBlipKey(player)

                if key then
                    playersCoords[key] = { { roundBlipCoord(x), roundBlipCoord(y) }, getOnlinePresenceBlipNumber(player) }
                end
            end
        end
    end

    return playersCoords
end

local function UpdatePlayersBlipsFromOnlinePresence()
    local adminWorldId = getCurrentBlipsWorldId()
    local onlinePlayers = fetchOnlinePresenceCityPlayers(adminWorldId)

    if not onlinePlayers then
        return false
    end

    UpdatePlayersCoords(buildOnlinePresenceBlips(onlinePlayers, adminWorldId))
    return true
end

local function StartOnlinePresenceBlips()
    onlinePresenceRefreshedToken = false
    blipsFetchGeneration = blipsFetchGeneration + 1
    local generation = blipsFetchGeneration

    CreateThread(function()
        while StateBlips and generation == blipsFetchGeneration do
            UpdatePlayersBlipsFromOnlinePresence()
            Wait(readOnlinePresenceBlipsIntervalMs())
        end
    end)
end

function PlayersBlips:start()
    
end

function PlayersBlips:tick()
    local now = GetGameTimer()

    for _, player in pairs(players) do
        local dur = player.moveDuration > 0 and player.moveDuration or 1
        local t = Clamp((now - player.moveStart) / dur, 0, 1)

        player.current = vector3(
            player.from.x + (player.to.x - player.from.x) * t,
            player.from.y + (player.to.y - player.from.y) * t,
            player.current.z
        )

        SetBlipCoords(player.blip, player.current)
    end
end

function GetPlayers2()
	local Selected = {}
    local Peds = GetGamePool("CPed")
    for i=1,#Peds do
        local SelectedPed = Peds[i]
        if IsPedAPlayer(SelectedPed) then
            local Coords = GetEntityCoords(SelectedPed)
            local Player = NetworkGetPlayerIndexFromPed(SelectedPed)
            local serverId = tostring(GetPlayerServerId(Player))
            if players[serverId] then
                UpdatePlayerBlip(serverId, Coords)
            end
        end
    end
	return Selected
end

CreateThread(function()
    updateEventCookie = RegisterNetEvent("Blips:Update", UpdatePlayersCoords)
end)

RegisterNetEvent("Admin:Blips",function(Boolean, Options)
    local useOnlinePresence = Options ~= nil and Options.onlinePresence == true
    if Boolean then
        if StateBlips then return end

        StateBlips = true
        PlayersBlips:start()
        if useOnlinePresence then
            StartOnlinePresenceBlips()
        end
        CreateThread(function()
            while StateBlips do
                PlayersBlips:tick()
                Wait(0)
            end
        end)
        CreateThread(function()
            while StateBlips do
                GetPlayers2()
                Wait(250)
            end
        end)
    else
        RemoveBlips()
    end
end)

RegisterNetEvent("Blips:Disconnect",function(serverId)
    if players[tostring(serverId)] then
        RemoveBlip(players[tostring(serverId)]["blip"])
        players[tostring(serverId)] = nil
    end
end)

RegisterNUICallback("getCityName",function(Data,Callback)
    cityName = GetConvar("cityName", "")
    Callback(string.lower(cityName))
end)
local GodCoordinates = {
    vector3(1422.73,6595.01,19.53),
    vector3(-1644.17,-1098.94,14.01),
    vector3(-1071.62,-2797.72,21.33),
}

---@param coords vector3
---@param timeoutMs number
---@return boolean loaded
local function LoadSpawnScene(coords, timeoutMs)

    local autoFlag = 0 | 1 << 0
    local startedAt = GetGameTimer()

    if IsNewLoadSceneActive() then
        NewLoadSceneStop()
    end

    -- Libera qualquer foco explícito do sistema anterior antes de assumir o
    -- streaming. NewLoadScene gerencia o próprio foco; combinar SetFocusArea
    -- com NewLoadSceneStart cria dois donos concorrentes durante o spawn.
    ClearFocus()
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    NewLoadSceneStart(coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 150.0, autoFlag)

    while not IsNewLoadSceneLoaded() do
        Wait(0)
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)

        if GetGameTimer() - startedAt > timeoutMs then
            sx.logger:warn( ('admin:Teleport spawn -> TIMEOUT loadscene em %dms coords=%0.2f,%0.2f,%0.2f'):format( timeoutMs, coords.x, coords.y, coords.z ) )
            if IsNewLoadSceneActive() then
                NewLoadSceneStop()
            end
            ClearFocus()
            return false
        end
    end

    sx.logger:debug( ('admin:Teleport spawn -> loadscene ok em %dms coords=%0.2f,%0.2f,%0.2f'):format( GetGameTimer() - startedAt, coords.x, coords.y, coords.z ) )

    return true
end

---@param coords vector3
---@param ped number
local function SetPedToSpawnCoords(coords, ped)

    SetEntityCoords(ped, coords.x + 0.0001, coords.y + 0.0001, coords.z + 0.0001, false, false, false, false)
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
end

RegisterNetEvent("admin:Teleport")
AddEventHandler("admin:Teleport",function(Coords,Spawn,Ground)
    -- ENG-3756: quitou em NC. Mesmo X/Y, Z do chao (ou da agua) abaixo do ponto salvo.
    if Ground then
        local Timer = GetGameTimer() + 3000
        local GroundZ
        repeat
            RequestCollisionAtCoord(Coords.x, Coords.y, Coords.z)
            local Found, Z = GetGroundZFor_3dCoord(Coords.x, Coords.y, Coords.z, false)
            GroundZ = Found and Z or nil
            Wait(0)
        until GroundZ or GetGameTimer() > Timer
        if not GroundZ then
            local _, GroundPos = StartFindFarAwayGroundPos(Coords)
            GroundZ = GroundPos.z
        end
        local InWater, WaterZ = GetWaterHeight(Coords.x, Coords.y, Coords.z)
        if InWater and WaterZ > GroundZ then
            GroundZ = WaterZ
        end
        Coords = vector3(Coords.x, Coords.y, GroundZ + 0.5)
        sx.logger:debug( ('admin:Teleport spawn NC -> chao z=%0.2f'):format( Coords.z ) )
    end

    if IsUsingFreecam() then

        SetFreecamWishPosition( Coords )

        return
    end

    local Ped = PlayerPedId()
    if Ped then

        SetPedToSpawnCoords(Coords, Ped)

        if Spawn then
            -- Espera a collision carregar de fato antes de descongelar. Os 5s
            -- cegos anteriores nao bastavam sob carga (streaming lento) e o
            -- jogador ficava preso no ar. Re-busca PlayerPedId() a cada frame
            -- porque skinshop:Apply -> SetPlayerModel troca o ped no meio do
            -- spawn e invalida o handle capturado.
            local StartedAt = GetGameTimer()
            local FirstPed = Ped
            sx.logger:debug( ('admin:Teleport spawn -> aguardando loadscene/collision coords=%0.2f,%0.2f,%0.2f ped=%s'):format( Coords.x, Coords.y, Coords.z, Ped ) )
            LoadSpawnScene(Coords, 7000)
            local Timer = GetGameTimer() + 15000
            repeat
                Wait(0)
                Ped = PlayerPedId()
                SetPedToSpawnCoords(Coords, Ped)
                FreezeEntityPosition(Ped,true)
            until HasCollisionLoadedAroundEntity(Ped) or GetGameTimer() > Timer
            Ped = PlayerPedId()
            SetPedToSpawnCoords(Coords, Ped)
            local Elapsed = GetGameTimer() - StartedAt
            local Loaded = HasCollisionLoadedAroundEntity(Ped)
            if not Loaded then
                sx.logger:warn( ('admin:Teleport spawn -> TIMEOUT collision em %dms; descongelando mesmo assim ped=%s pedTrocado=%s'):format( Elapsed, Ped, tostring( Ped ~= FirstPed ) ) )
            else
                sx.logger:debug( ('admin:Teleport spawn -> collision ok em %dms ped=%s pedTrocado=%s'):format( Elapsed, Ped, tostring( Ped ~= FirstPed ) ) )
            end
            FreezeEntityPosition(Ped,false)
            if IsNewLoadSceneActive() then
                NewLoadSceneStop()
            end
            ClearFocus()
        end
    end
    Wait(5000)
    for i = 1,#GodCoordinates do
        local Distance = #(Coords - GodCoordinates[i])
        if Distance <= 100 then
            TriggerServerEvent("admin:SpawnTest")
        end
    end

    TriggerEvent('onTeleportedByAdminCommand')
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTONMAKERACE
-----------------------------------------------------------------------------------------------------------------------------------------
local CustomBlips = {}
RegisterNetEvent("blips:LoadBlips")
AddEventHandler("blips:LoadBlips",function(Table)
    if not Table or type(Table) ~= "table" then return end
    for k,v in pairs(Table) do
        if v and v["coordinates"] and v["name"] then
            local Coords = toVector3(v["coordinates"])
            if Coords then
                local blip = AddBlipForCoord(Coords)
                SetBlipSprite(blip,v["blip_id"] or 1)
                SetBlipColour(blip,v["color"] or 0)
                SetBlipAsShortRange(blip,true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(tostring(v["name"]))
                EndTextCommandSetBlipName(blip)
                CustomBlips[v["id"]] = blip
            end
        end
    end
end)

RegisterNetEvent("blips:NewBlip")
AddEventHandler("blips:NewBlip",function(Table)
    if not Table or type(Table) ~= "table" or not Table["coordinates"] or not Table["name"] then return end
    local Coords = toVector3(Table["coordinates"])
    if Coords then
        local blip = AddBlipForCoord(Coords)
        SetBlipSprite(blip,Table["blip_id"] or 1)
        SetBlipColour(blip,Table["color"] or 0)
        SetBlipAsShortRange(blip,true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(tostring(Table["name"]))
        EndTextCommandSetBlipName(blip)
        CustomBlips[Table["id"]] = blip
    end
end)

RegisterNetEvent("blips:RemoveBlip")
AddEventHandler("blips:RemoveBlip",function(id)
    if CustomBlips[id] then
        RemoveBlip(CustomBlips[id])
        CustomBlips[id] = nil
    end
end)

RegisterNetEvent("blips:UpdateBlip")
AddEventHandler("blips:UpdateBlip",function(Table)
    if CustomBlips[Table["id"]] then
        RemoveBlip(CustomBlips[Table["id"]])
        local Coords = toVector3(Table["coordinates"])
        local blip = AddBlipForCoord(Coords)
        SetBlipSprite(blip,Table["blip_id"])
        SetBlipColour(blip,Table["color"])
        SetBlipAsShortRange(blip,true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Table["name"])
        EndTextCommandSetBlipName(blip)
        CustomBlips[Table["id"]] = blip
    end
end)

---@param liveryId number
RegisterNetEvent('net.change.vehicle.livery', function(liveryId)
    SetVehicleLivery(GetVehiclePedIsIn(PlayerPedId(), false), liveryId)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RGBC
-----------------------------------------------------------------------------------------------------------------------------------------
local isRGB = false
RegisterNetEvent("admin:RGB")
AddEventHandler("admin:RGB",function(chamaleonId)
    local pedId = PlayerPedId()
    local vehicleId = GetVehiclePedIsIn(pedId, false)

    isRGB = not isRGB
    CreateThread(function()
        if isRGB and chamaleonId and DoesEntityExist(vehicleId) then 
            SetVehicleColours(vehicleId, 0, 0)
        end

        while isRGB do
            Wait(10)

            pedId = PlayerPedId()
            
            if IsPedInAnyVehicle(pedId, false) and GetPedInVehicleSeat(vehicleId, -1) == pedId then
                ChangeCarColorRainbow(vehicleId)
            end
        end

        if chamaleonId and DoesEntityExist(vehicleId) and GetPedInVehicleSeat(vehicleId, -1) == pedId then
            exports.hud:ApplyChamaleonColour(vehicleId, chamaleonId)
        end
    end)
end)

--- ChangeCarColorRainbow
---@param vehicle number
function ChangeCarColorRainbow(vehicle)
    local currentTime = GetGameTimer()
    local hue = (currentTime % 30000) / 30000.0
    local r, g, b = HSVToRGB(hue, 1, 1)
    SetVehicleCustomPrimaryColour(vehicle, r, g, b)
    SetVehicleCustomSecondaryColour(vehicle, r, g, b)
end

--- HSVToRGB
---@param h number
---@param s number
---@param v number
---@return number, number, number
function HSVToRGB(h, s, v)
    local r, g, b

    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)

    if i % 6 == 0 then
        r, g, b = v, t, p
    elseif i % 6 == 1 then
        r, g, b = q, v, p
    elseif i % 6 == 2 then
        r, g, b = p, v, t
    elseif i % 6 == 3 then
        r, g, b = p, q, v
    elseif i % 6 == 4 then
        r, g, b = t, p, v
    else
        r, g, b = v, p, q
    end

    return math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)
end
---@type table<number, {r: number, g: number, b: number, matte?: boolean}>
local gVehicleModelsRGBColorOverrides = {}

--- Aplica RGB custom + tipo de tinta (normal vs fosco). paintType 0 = normal, 3 = matte (GTA).
---@param vehicleEntityId number
---@param r number
---@param g number
---@param b number
---@param matte boolean
local function ApplyVehicleRgbFinish(vehicleEntityId, r, g, b, matte)
    SetVehicleModKit(vehicleEntityId, 0)
    local paintType = matte and 3 or 0
    SetVehicleModColor_1(vehicleEntityId, paintType, 0, 0)
    SetVehicleModColor_2(vehicleEntityId, paintType, 0)
    SetVehicleCustomPrimaryColour(vehicleEntityId, r, g, b)
    SetVehicleCustomSecondaryColour(vehicleEntityId, r, g, b)
end

---@param r number
---@param g number
---@param b number
---@param matte boolean|nil
RegisterNetEvent("admin:SetVehicleRgb", function(r, g, b, matte)
    local localPedId = PlayerPedId()
    local vehicleEntityId = GetVehiclePedIsIn(localPedId, false)

    assert(DoesEntityExist(vehicleEntityId), "Player must be in a vehicle to set RGB color")

    local vehicleModelHash = GetEntityModel(vehicleEntityId)
    local isMatte = matte == true
    gVehicleModelsRGBColorOverrides[vehicleModelHash] = { r = r, g = g, b = b, matte = isMatte }

    ApplyVehicleRgbFinish(vehicleEntityId, r, g, b, isMatte)
end)

---@param vehicleEntityId number
---@assert DoesEntityExist(vehicleEntityId) "vehicleEntityId must be a valid entity"
local function ApplyVehicleModelRGBColorOverride(vehicleEntityId)

    local vehicleModelHash = GetEntityModel(vehicleEntityId)
    local storedColor = gVehicleModelsRGBColorOverrides[vehicleModelHash]

    if storedColor then
        ApplyVehicleRgbFinish(
            vehicleEntityId,
            storedColor.r,
            storedColor.g,
            storedColor.b,
            storedColor.matte == true
        )
    end
end

exports("ApplyVehicleModelRGBColorOverride", ApplyVehicleModelRGBColorOverride)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPUNCH/PUNCH
-----------------------------------------------------------------------------------------------------------------------------------------
function RotationToDirection(Rotation)
    local X = math.rad(Rotation.x)
    local Z = math.rad(Rotation.z)
    local AbsCosX = math.abs(math.cos(X))
    return vector3(-math.sin(Z) * AbsCosX, math.cos(Z) * AbsCosX, math.sin(X))
end

local Punch = false
local PunchForce
RegisterNetEvent("admin:Punch")
AddEventHandler("admin:Punch",function(Force)
    Punch = not Punch
    PunchForce = Force
end)


local SuperPunch = false
local SForce = 0
local sDistance = 0
local SuperPunchExplosion = false
local SuperPunchExplosionPower = 1.0
local SuperPunchExplosionType = 18
local SuperPunchExplosionPrevInvincible = nil

local function GetEntityInvincibleState(entity)
    return Citizen.InvokeNative(0xC1213506D205EB3F,entity,Citizen.ResultAsInteger()) == 1
end

local function DisableSuperPunchPowers()
    if SuperPunch then
        TriggerEvent("Notify2","#spunchOut")
    end

    SuperPunch = false
    SForce = 0
    sDistance = 0

    local Ped = PlayerPedId()
    if SuperPunchExplosion and DoesEntityExist(Ped) and SuperPunchExplosionPrevInvincible ~= nil then
        SetEntityInvincible(Ped,SuperPunchExplosionPrevInvincible)
    end

    SuperPunchExplosion = false
    SuperPunchExplosionPower = 1.0
    SuperPunchExplosionType = 18
    SuperPunchExplosionPrevInvincible = nil
end

RegisterNetEvent("net.disable.spunch",DisableSuperPunchPowers)

RegisterNetEvent("admin:SPunch")
AddEventHandler("admin:SPunch",function(Force,Distance)
    if Force and Force > 0 then
        local NewDistance = (Distance and Distance > 0) and Distance or 10

        if SuperPunch then
            if SForce ~= Force or sDistance ~= NewDistance then
                TriggerEvent("Notify2","#spunchUpdated",{ msg = Force, msg2 = NewDistance })
            end
        else
            TriggerEvent("Notify2","#spunchIn")
        end

        SuperPunch = true
        SForce = Force
        sDistance = NewDistance
        return
    end

    SuperPunch = not SuperPunch
    TriggerEvent("Notify2",SuperPunch and "#spunchIn" or "#spunchOut")
end)

RegisterNetEvent("admin:SPunchExplosion")
AddEventHandler("admin:SPunchExplosion",function(Power,ExplosionType)
    SuperPunchExplosion = not SuperPunchExplosion
    local Ped = PlayerPedId()
    if SuperPunchExplosion then
        if Power and Power > 0 then
            SuperPunchExplosionPower = Power + 0.0
        end

        if ExplosionType and ExplosionType >= 0 then
            SuperPunchExplosionType = ExplosionType
        end

        if DoesEntityExist(Ped) then
            SuperPunchExplosionPrevInvincible = GetEntityInvincibleState(Ped)
            SetEntityInvincible(Ped,true)
        else
            SuperPunchExplosionPrevInvincible = nil
        end
    else
        if DoesEntityExist(Ped) and SuperPunchExplosionPrevInvincible ~= nil then
            SetEntityInvincible(Ped,SuperPunchExplosionPrevInvincible)
        end
        SuperPunchExplosionPrevInvincible = nil
    end
end)

local function DisableSuperPunchExplosionPowers()
    SuperPunchExplosion = false
    SuperPunchExplosionPower = 1.0
    SuperPunchExplosionType = 18
    SuperPunchExplosionPrevInvincible = nil
end

RegisterNetEvent("net.disable.spunch.explosion",DisableSuperPunchExplosionPowers)

local AutoSuperPunch = false
local autoForce = 0
local autoDistance = 3
local autoLastVehicle = nil
local autoLastTick = 0

RegisterNetEvent("admin:AutoSPunch")
AddEventHandler("admin:AutoSPunch",function(Force,Distance)
    AutoSuperPunch = not AutoSuperPunch

    if AutoSuperPunch then
        autoForce = Force and Force > 0 and Force or (autoForce > 0 and autoForce or 2500)
        autoDistance = Distance and Distance > 0 and Distance or autoDistance
        autoLastVehicle = nil
        autoLastTick = 0
    else
        autoLastVehicle = nil
        autoLastTick = 0
    end
end)

function SPunch(Spawn)
    if SuperPunch then
        local Vehicle = vRP.ClosestVehicle(sDistance)
        if IsEntityAVehicle(Vehicle) then
            local Rotation = GetGameplayCamRot()
            local Direction = RotationToDirection(Rotation)
            TriggerServerEvent("admin:PunchAdd",VehToNet(Vehicle),Direction,SForce)
        end
    end
end

RegisterCommand("5562",SPunch)
RegisterKeyMapping("5562","Spunch","MOUSE_BUTTONANY","MOUSE_EXTRABTN5")
AddEventHandler('gameEventTriggered', function(event, data)
	if event == 'CEventNetworkEntityDamage' and Punch then
        local Ped = PlayerPedId()
        local Entity, Attacker, _, Weapon = data[1], data[2], data[4], data[7]
        if IsEntityAVehicle(Entity) and Weapon == `WEAPON_UNARMED` and Attacker == Ped then
            local Rotation = GetGameplayCamRot()
            local Direction = RotationToDirection(Rotation)
            TriggerServerEvent("admin:PunchAdd",VehToNet(Entity),Direction,PunchForce)
        end
    end
end)

local ThrowModeActive = false
local ThrowModeForce = 7000.0
local ThrowActionCooldown = 0

local function AdminGetClosestPlayer(radius)
    radius = radius or 3.0

    if type(vRP) ~= "table" or type(vRP.ClosestPed) ~= "function" then
        return nil
    end

    local serverId = vRP.ClosestPed(radius)
    if not serverId or serverId <= 0 then
        return nil
    end

    local player = GetPlayerFromServerId(serverId)
    if not player or player == -1 then
        return nil
    end

    local ped = GetPlayerPed(player)
    if not DoesEntityExist(ped) then
        return nil
    end

    local pedCoords = GetEntityCoords(ped)
    local myPed = PlayerPedId()
    if not DoesEntityExist(myPed) then
        return nil
    end

    local myCoords = GetEntityCoords(myPed)
    local distance = #(pedCoords - myCoords)
    if distance > radius then
        return nil
    end

    return serverId, distance
end

local HeldPlayerServerId = nil


RegisterNetEvent("net.admin.ToggleThrowMode",function(State,Force)
    ThrowModeActive = State and true or false

    if Force and Force > 0 then

        ThrowModeForce = Force + 0.0
        
    end
    
    if not ThrowModeActive then

        if HeldPlayerServerId then

            TriggerServerEvent('sx.player_attachment.request_detach_child_or_parent')

        end

        HeldPlayerServerId = nil
    end
end)

RegisterNetEvent("net.admin.PlayerGrabbed",function(TargetServerId)
    HeldPlayerServerId = TargetServerId
end)

RegisterCommand("+adminThrowAction",function()
    if not ThrowModeActive then
        return
    end

    local CurrentTime = GetGameTimer()
    if CurrentTime - ThrowActionCooldown < 300 then
        return
    end
    ThrowActionCooldown = CurrentTime

    
    if HeldPlayerServerId then

        local CamDirection = RotationToDirection(GetGameplayCamRot(2))

        TriggerServerEvent("admin:ThrowRequest",HeldPlayerServerId,{ x = CamDirection.x, y = CamDirection.y, z = CamDirection.z })

        HeldPlayerServerId = nil


        return
    end

    local ClosestServerId, Distance = AdminGetClosestPlayer(3.0)

    if ClosestServerId and (not Distance or Distance <= 3.0) then

        TriggerServerEvent("admin:GrabPlayer",ClosestServerId)

    end
end,false)

RegisterCommand("-adminThrowAction",function()
end,false)

RegisterKeyMapping("+adminThrowAction","Agarra/Arremessa jogador","keyboard","L")

local function NormalizeDirection(Direction)
    if type(Direction) == "table" then
        local Vec = vector3(Direction.x or 0.0,Direction.y or 0.0,Direction.z or 0.0)
        local Length = #(Vec)
        if Length > 0.0 then
            return Vec / Length
        end
    end

    return vector3(0.0,1.0,0.6)
end

RegisterNetEvent("net.admin.ThrowPlayer",function(TargetNet,Direction,Force,TargetSource)
    local TargetEntity
    local IsSelf = false
    
    if TargetNet then
        

        TargetEntity = NetworkGetEntityFromNetworkId(TargetNet)

        if not DoesEntityExist(TargetEntity) then

            return

        end

        
        local MyPed = PlayerPedId()

        if TargetEntity == MyPed then

            IsSelf = true

        end
    else

        TargetEntity = PlayerPedId()
        IsSelf = true
    end
    
    if not DoesEntityExist(TargetEntity) then

        return

    end

    local MyPed = PlayerPedId()
    

    if HeldPlayerServerId == TargetSource then
        HeldPlayerServerId = nil
    end

    local DirVector = NormalizeDirection(Direction)
    local PushForce = Force and Force + 0.0 or ThrowModeForce
    local UpForce = math.max(PushForce * 0.8,4000.0)
    local ForwardForce = PushForce
    local ForceX = DirVector.x * PushForce
    local ForceY = DirVector.y * PushForce
    local ForceZ = DirVector.z * PushForce


    CreateThread(function()

        if not IsSelf then

            local attempts = 0

            while not NetworkHasControlOfEntity(TargetEntity) and attempts < 15 do
                NetworkRequestControlOfEntity(TargetEntity)
                Wait(10)
                attempts = attempts + 1
            end

        end

        
        if IsSelf or NetworkHasControlOfEntity(TargetEntity) then
            ClearPedTasksImmediately(TargetEntity)
        
            SetPedCanRagdoll(TargetEntity, true)
        end
    
    
        SetPedToRagdoll(TargetEntity,3500,3500,0,0,0,0)
        
        Wait(100)

        
        ApplyForceToEntity(TargetEntity,1,ForceX,ForceY,ForceZ,0.0,0.0,0.0,0,false,true,true,false,true)
        
    
        SetEntityVelocity(TargetEntity,ForceX / 60.0,ForceY / 60.0,ForceZ / 35.0)

    
        Wait(150)

        if DoesEntityExist(TargetEntity) then

            ApplyForceToEntity(TargetEntity,1,ForceX * 0.7,ForceY * 0.7,ForceZ * 0.75,0.0,0.0,0.0,0,false,true,true,false,true)

        end

        Wait(180)

        if DoesEntityExist(TargetEntity) then

            ApplyForceToEntity(TargetEntity,1,DirVector.x * (ForwardForce * 0.45),DirVector.y * (ForwardForce * 0.45),UpForce * 0.6,0.0,0.0,0.0,0,false,true,true,false,true)
            
        end
    end)
end)

AddEventHandler('gameEventTriggered', function(event, data)
    if event == 'CEventNetworkEntityDamage' and SuperPunchExplosion then
        local Ped = PlayerPedId()
        local Entity, Attacker, _, Weapon = data[1], data[2], data[4], data[7]
        
        if Weapon == `WEAPON_UNARMED` and Attacker == Ped and DoesEntityExist(Entity) and Entity ~= 0 then
            local Coords

            if IsEntityAPed(Entity) then


                local Hit, Bone = GetPedLastDamageBone(Entity)

                

                if not (Hit and Bone and Bone ~= 0) then
                    Wait(0)
                    Hit, Bone = GetPedLastDamageBone(Entity)
                end


                if Hit and Bone and Bone ~= 0 then
                    Coords = GetPedBoneCoords(Entity, Bone, 1.0, 0.0, 0.0)
                end
            end

            if not Coords then
                Coords = GetEntityCoords(Entity)
            end

            if Coords then
                AddOwnedExplosion(Ped, Coords.x, Coords.y, Coords.z, 18, 1.0, true, false, 1.0)
            end

            if IsEntityAVehicle(Entity) then

                TriggerServerEvent("net.admin.explodeVehicle", VehToNet(Entity))

                
            end
        end
    end
end)

AddStateBagChangeHandler("explodeVehicle", nil, function(bagName, key, value, reserved, replicated)
    if not value or value == 0 then
        return
    end
    local entity = GetEntityFromStateBagName(bagName)
    if entity and DoesEntityExist(entity) then
        driver = GetLastPedInVehicleSeat(entity,-1) 
        print("explodeVehicle::",json.encode({
            type = GetEntityType(entity),
            owner = NetworkGetEntityOwner(entity),
            value = value,
            driver = driver ~= 0 and NetworkGetEntityOwner(driver) or 'N/A'
        }))
    else
        print("explodeVehicle entity doesn't exist: ", bagName)
    end
end)

CreateThread(function()

    while true do

        if AutoSuperPunch then

            local Ped = PlayerPedId()

            if DoesEntityExist(Ped) and not IsPedDeadOrDying(Ped,true) then
                local Vehicle = vRP.ClosestVehicle(autoDistance)

                if IsEntityAVehicle(Vehicle) then

                    local PedCoords = GetEntityCoords(Ped)
                    local VehicleCoords = GetEntityCoords(Vehicle)
                    local Distance = #(PedCoords - VehicleCoords)

                    if Distance <= autoDistance then
                        local VehicleNet = VehToNet(Vehicle)
                        local CurrentTick = GetGameTimer()

                        if autoLastVehicle ~= VehicleNet or (CurrentTick - autoLastTick) > 750 then
                            local Direction = GetEntityForwardVector(Ped)
                            if Direction then
                                TriggerServerEvent("admin:PunchAdd",VehicleNet,Direction,autoForce)
                                autoLastVehicle = VehicleNet
                                autoLastTick = CurrentTick
                                Wait(200)
                            end
                        end


                    end


                end

            end

            Wait(150)
        end
        
        Wait(500)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:neymar")
AddEventHandler("admin:neymar",function(ForwardVectorX,ForwardVectorY,ForwardVectorZ,Tackler)
    SetPedCanRagdoll(PlayerPedId(), true)
    SetPedToRagdollWithFall(PlayerPedId(),1500,2000,0,ForwardVector,1.0,0.0,0.0,0.0,0.0,0.0,0.0)
    Wait(35000)
    SetPedCanRagdoll(PlayerPedId(), false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GODMODE
-----------------------------------------------------------------------------------------------------------------------------------------
local GodMode = false
RegisterNetEvent("admin:GodMode")
AddEventHandler("admin:GodMode",function()
    GodMode = not GodMode
    LocalPlayer["state"]["Invincible"] = GodMode

    local Msg = GodMode and "ativado" or "desativado"
    local MsgType = GodMode and "verde" or "vermelho"
    if GodMode then
        TriggerEvent("Notify2","#godModeIn")
    else
        TriggerEvent("Notify2","#godModeOut")
    end

    local Ped = PlayerPedId()
    while GodMode do
        Wait(3000)
        SetEntityInvincible(Ped,GodMode)
    end
end)

RegisterNetEvent('hey!', function(a, b)
    print('hey!', a, b)
end)

CreateThread(function()
    if cityName ~= "Kingdom" then
        while true do
            GetSoundId()
            Wait(1000)
        end
    end
end)

local bullying = false
RegisterNetEvent("admin:bullying2")
AddEventHandler("admin:bullying2", function(boolean)
    bullying = boolean
    CreateThread(function()
        while bullying do
            local Ped = PlayerPedId()
            if IsPedRunning(Ped) and not IsPedRagdoll(Ped) then
                TriggerServerEvent("admin:Bullying")
            end
            Wait(100)
        end
    end)
end)


function Creative.SelectedWeapon()
    local Ped = PlayerPedId()
    local Selected = GetSelectedPedWeapon(Ped)
    return Selected
end

local PickUpList = {
    `PICKUP_WEAPON_BULLPUPSHOTGUN`,
    `PICKUP_WEAPON_ASSAULTSMG`,
    `PICKUP_VEHICLE_WEAPON_ASSAULTSMG`,
    `PICKUP_WEAPON_PISTOL50`,
    `PICKUP_VEHICLE_WEAPON_PISTOL50`,
    `PICKUP_AMMO_BULLET_MP`,
    `PICKUP_AMMO_MISSILE_MP`,
    `PICKUP_AMMO_GRENADELAUNCHER_MP`,
    `PICKUP_WEAPON_ASSAULTRIFLE`,
    `PICKUP_WEAPON_CARBINERIFLE`,
    `PICKUP_WEAPON_ADVANCEDRIFLE`,
    `PICKUP_WEAPON_MG`,
    `PICKUP_WEAPON_COMBATMG`,
    `PICKUP_WEAPON_SNIPERRIFLE`,
    `PICKUP_WEAPON_HEAVYSNIPER`,
    `PICKUP_WEAPON_MICROSMG`,
    `PICKUP_WEAPON_SMG`,
    `PICKUP_ARMOUR_STANDARD`,
    `PICKUP_WEAPON_RPG`,
    `PICKUP_WEAPON_MINIGUN`,
    `PICKUP_HEALTH_STANDARD`,
    `PICKUP_WEAPON_PUMPSHOTGUN`,
    `PICKUP_WEAPON_SAWNOFFSHOTGUN`,
    `PICKUP_WEAPON_ASSAULTSHOTGUN`,
    `PICKUP_WEAPON_GRENADE`,
    `PICKUP_WEAPON_MOLOTOV`,
    `PICKUP_WEAPON_SMOKEGRENADE`,
    `PICKUP_WEAPON_STICKYBOMB`,
    `PICKUP_WEAPON_PISTOL`,
    `PICKUP_WEAPON_COMBATPISTOL`,
    `PICKUP_WEAPON_APPISTOL`,
    `PICKUP_WEAPON_GRENADELAUNCHER`,
    `PICKUP_WEAPON_MINIGUN`,
    `PICKUP_WEAPON_FIREWORK`,
    `PICKUP_WEAPON_CARROT`,
    `PICKUP_WEAPON_KATANA_CENOURA`,
    `PICKUP_MONEY_VARIABLE`,
    `PICKUP_GANG_ATTACK_MONEY`,
    `PICKUP_WEAPON_STUNGUN`,
    `PICKUP_WEAPON_PETROLCAN`,
    `PICKUP_WEAPON_KNIFE`,
    `PICKUP_WEAPON_NIGHTSTICK`,
    `PICKUP_WEAPON_HAMMER`,
    `PICKUP_WEAPON_BAT`,
    `PICKUP_WEAPON_BAT_KAWAI`,
    `PICKUP_WEAPON_GolfClub`,
    `PICKUP_WEAPON_CROWBAR`,
    `PICKUP_CUSTOM_SCRIPT`,
    `PICKUP_CAMERA`,
    `PICKUP_PORTABLE_PACKAGE`,
    `PICKUP_PORTABLE_CRATE_UNFIXED`,
    `PICKUP_PORTABLE_PACKAGE_LARGE_RADIUS`,
    `PICKUP_PORTABLE_CRATE_UNFIXED_INCAR`,
    `PICKUP_PORTABLE_CRATE_UNFIXED_INAIRVEHICLE_WITH_PASSENGERS`,
    `PICKUP_PORTABLE_CRATE_UNFIXED_INAIRVEHICLE_WITH_PASSENGERS_UPRIGHT`,
    `PICKUP_PORTABLE_CRATE_UNFIXED_INCAR_WITH_PASSENGERS`,
    `PICKUP_PORTABLE_CRATE_FIXED_INCAR_WITH_PASSENGERS`,
    `PICKUP_PORTABLE_CRATE_FIXED_INCAR_SMALL`,
    `PICKUP_PORTABLE_CRATE_UNFIXED_INCAR_SMALL`,
    `PICKUP_PORTABLE_CRATE_UNFIXED_LOW_GLOW`,
    `PICKUP_MONEY_CASE`,
    `PICKUP_MONEY_WALLET`,
    `PICKUP_MONEY_PURSE`,
    `PICKUP_MONEY_DEP_BAG`,
    `PICKUP_MONEY_MED_BAG`,
    `PICKUP_MONEY_PAPER_BAG`,
    `PICKUP_MONEY_SECURITY_CASE`,
    `PICKUP_VEHICLE_WEAPON_COMBATPISTOL`,
    `PICKUP_VEHICLE_WEAPON_APPISTOL`,
    `PICKUP_VEHICLE_WEAPON_PISTOL`,
    `PICKUP_VEHICLE_WEAPON_GRENADE`,
    `PICKUP_VEHICLE_WEAPON_MOLOTOV`,
    `PICKUP_VEHICLE_WEAPON_SMOKEGRENADE`,
    `PICKUP_VEHICLE_WEAPON_STICKYBOMB`,
    `PICKUP_VEHICLE_HEALTH_STANDARD`,
    `PICKUP_VEHICLE_HEALTH_STANDARD_LOW_GLOW`,
    `PICKUP_VEHICLE_ARMOUR_STANDARD`,
    `PICKUP_VEHICLE_WEAPON_MICROSMG`,
    `PICKUP_VEHICLE_WEAPON_SMG`,
    `PICKUP_VEHICLE_WEAPON_SAWNOFF`,
    `PICKUP_VEHICLE_CUSTOM_SCRIPT`,
    `PICKUP_VEHICLE_CUSTOM_SCRIPT_NO_ROTATE`,
    `PICKUP_VEHICLE_CUSTOM_SCRIPT_LOW_GLOW`,
    `PICKUP_VEHICLE_MONEY_VARIABLE`,
    `PICKUP_SUBMARINE`,
    `PICKUP_HEALTH_SNACK`,
    `PICKUP_PARACHUTE`,
    `PICKUP_AMMO_PISTOL`,
    `PICKUP_AMMO_SMG`,
    `PICKUP_AMMO_RIFLE`,
    `PICKUP_AMMO_MG`,
    `PICKUP_AMMO_SHOTGUN`,
    `PICKUP_AMMO_SNIPER`,
    `PICKUP_AMMO_GRENADELAUNCHER`,
    `PICKUP_AMMO_RPG`,
    `PICKUP_AMMO_MINIGUN`,
    `PICKUP_WEAPON_BOTTLE`,
    `PICKUP_WEAPON_SNSPISTOL`,
    `PICKUP_WEAPON_HEAVYPISTOL`,
    `PICKUP_WEAPON_SPECIALCARBINE`,
    `PICKUP_WEAPON_BULLPUPRIFLE`,
    `PICKUP_WEAPON_RAYPISTOL`,
    `PICKUP_WEAPON_RAYCARBINE`,
    `PICKUP_WEAPON_RAYMINIGUN`,
    `PICKUP_WEAPON_IRON`,
    `PICKUP_WEAPON_SKORPION`,
    `PICKUP_WEAPON_APPISTOL_MISTICDRAGON`,
    `PICKUP_WEAPON_SPECIALCARBINE_MK2_MISTICDRAGON`,
    `PICKUP_WEAPON_SNIPER_MISTICDRAGON`,
    `PICKUP_WEAPON_KNIFE_MISTICDRAGON`,
    `PICKUP_WEAPON_SPECIALCARBINE_MK2_ZEUS`,
    `PICKUP_WEAPON_APPISTOL_ZEUS`,
    `PICKUP_WEAPON_KARAMBIT_ZEUS`,
    `PICKUP_WEAPON_GGSPURPLEVVS`,
    `PICKUP_WEAPON_GGSGREYVVS`,
    `PICKUP_WEAPON_GGSBLUEVVS`,
    `PICKUP_WEAPON_GGSWHITEVVS`,
    `PICKUP_WEAPON_GGSREDVVS`,
    `PICKUP_WEAPON_BAT_ZEUS`,
    `PICKUP_WEAPON_APPISTOLPINK`,
    `PICKUP_WEAPON_APPISTOL_CHROME`,
    `PICKUP_WEAPON_APPISTOL_CROSSDIAMOND`,
    `PICKUP_WEAPON_APPISTOL_OUTLAW`,
    `PICKUP_WEAPON_APPISTOL_RETROPIXEL_BLUE`,
    `PICKUP_WEAPON_APPISTOL_RETROPIXEL_PURPLE`,
    `PICKUP_WEAPON_APPISTOL_RETROPIXEL_RED`,
    `PICKUP_WEAPON_APPISTOL_RETROPIXEL_WHITE`,
    `PICKUP_WEAPON_ASSAULTSMG_RETROPIXEL_BLUE`,
    `PICKUP_WEAPON_ASSAULTSMG_RETROPIXEL_PURPLE`,
    `PICKUP_WEAPON_ASSAULTSMG_RETROPIXEL_RED`,
    `PICKUP_WEAPON_ASSAULTSMG_RETROPIXEL_WHITE`,
    `PICKUP_WEAPON_CARBINERIFLE_MK2_RETROPIXEL_BLUE`,
    `PICKUP_WEAPON_CARBINERIFLE_MK2_RETROPIXEL_PURPLE`,
    `PICKUP_WEAPON_CARBINERIFLE_MK2_RETROPIXEL_RED`,
    `PICKUP_WEAPON_CARBINERIFLE_MK2_RETROPIXEL_WHITE`,
    `PICKUP_WEAPON_SPECIALCARBINE_MK2_RETROPIXEL_BLUE`,
    `PICKUP_WEAPON_SPECIALCARBINE_MK2_RETROPIXEL_PURPLE`,
    `PICKUP_WEAPON_SPECIALCARBINE_MK2_RETROPIXEL_RED`,
    `PICKUP_WEAPON_SPECIALCARBINE_MK2_RETROPIXEL_WHITE`,
    `PICKUP_WEAPON_BULLPUPMK2_RETROPIXEL_BLUE`,
    `PICKUP_WEAPON_BULLPUPMK2_RETROPIXEL_PURPLE`,
    `PICKUP_WEAPON_BULLPUPMK2_RETROPIXEL_RED`,
    `PICKUP_WEAPON_BULLPUPMK2_RETROPIXEL_WHITE` ,
    `PICKUP_WEAPON_MACHETTE_RETROPIXEL_BLUE`,
    `PICKUP_WEAPON_MACHETTE_RETROPIXEL_PURPLE`,
    `PICKUP_WEAPON_MACHETTE_RETROPIXEL_RED`,
    `PICKUP_WEAPON_MACHETTE_RETROPIXEL_WHITE`,
    `PICKUP_WEAPON_CARBINERIFLE_MK2_STEAMPUNK`,
    `PICKUP_WEAPON_KNIFE_VORTEX`,
    `PICKUP_WEAPON_APPISTOL_STEAMPUNK`,
    `PICKUP_WEAPON_APPISTOL_IRONDUST`,
    `PICKUP_WEAPON_SPECIALCARBINE_MK2_WINTERFLOWER`,
    `PICKUP_WEAPON_SNIPER_DRAGONREDRUSTIC`,
    `PICKUP_WEAPON_SPECIALCARBINE_MK2_DRAGONREDRUSTIC`,
    `PICKUP_WEAPON_KATANA_DRAGONREDRUSTIC`,
    `PICKUP_WEAPON_APPISTOL_DRAGONREDRUSTIC`,
    `PICKUP_WEAPON_SPECIALCARBINE_MK2_KAWAI`,
    `PICKUP_WEAPON_CARBINERIFLE_MK2_KAWAI`,
    `PICKUP_WEAPON_ASSAULTRIFLE_MK2_KAWAI`,
    `PICKUP_WEAPON_COMBATPDW_KAWAI`,
    `PICKUP_WEAPON_BULLPUPMK2_KAWAI`,
    `PICKUP_WEAPON_SWITCHBLADE_KAWAI`,
    `PICKUP_WEAPON_PISTOL50_KAWAI`,
    `PICKUP_WEAPON_PISTOLMK2_KAWAI`,
    `PICKUP_WEAPON_APPISTOL`,
    `PICKUP_WEAPON_BATTLEAXE`,
    `PICKUP_WEAPON_CARBINERIFLE_MK2`,
    `PICKUP_WEAPON_SPECIALCARBINE_MK2`,
    `PICKUP_WEAPON_CENOURA`,
    `PICKUP_WEAPON_KATANA_CENOURA`,
    `PICKUP_WEAPON_PL_PENHASHOP_G3_PCJ_V2`,
    `PICKUP_WEAPON_BLACKSNAKE`,
    `PICKUP_WEAPON_BULLPUP_ANIME`,
    `PICKUP_WEAPON_PINKFIRE`,
    `PICKUP_WEAPON_SPECIALCARBINE_TOXIC`,
    `PICKUP_WEAPON_BULLPUPRIFLE_MK2_LOBO`,
    `PICKUP_WEAPON_WOLFSTORM`,
    `PICKUP_WEAPON_G3LCHELLFIRE`,
    `PICKUP_WEAPON_ONI`,
    `PICKUP_WEAPON_TIGER`,
    `PICKUP_WEAPON_ABISSAL`,
    `PICKUP_WEAPON_RAIJIN`,
    `PICKUP_WEAPON_APPISTOL_SHOCKVOLT`,
    `PICKUP_WEAPON_APPISTOL_KAWAI`,
    `PICKUP_WEAPON_APPISTOL_DARKMATTER`,
    `PICKUP_WEAPON_APPISTOL_SNAGDRAGON`,
    `PICKUP_WEAPON_TIGER_PISTOLL`,
    `PICKUP_WEAPON_SHINIGAMI`,
    `PICKUP_WEAPON_SKORPION_SNIPER`,
    `PICKUP_WEAPON_SHOCKVOLT_SNIPER`,
    `PICKUP_WEAPON_SNIPERRIFLE_CYBERTRIBAL`,
    `PICKUP_WEAPON_DRAGONRED_SNIPER`,
    `PICKUP_WEAPON_HEAVYSNIPER_MK2_LOBO`,
    `PICKUP_WEAPON_THYZUK_SNIPER`,
    `PICKUP_WEAPON_TIGER_SNIPER`,
    `PICKUP_WEAPON_PARAFAL`,
    `PICKUP_WEAPON_PABSS`,
    `PICKUP_WEAPON_BULLPUPRIFLE_MK2`,
    `PICKUP_WEAPON_DOUBLEACTION`,
    `PICKUP_WEAPON_MARKSMANRIFLE_MK2`,
    `PICKUP_WEAPON_PUMPSHOTGUN_MK2`,
    `PICKUP_WEAPON_REVOLVER_MK2`,
    `PICKUP_WEAPON_SNSPISTOL_MK2`,
    `PICKUP_WEAPON_SPECIALCARBINE_MK2`,
    `PICKUP_WEAPON_PROXMINE`,
    `PICKUP_WEAPON_HOMINGLAUNCHER`,
    `PICKUP_AMMO_HOMINGLAUNCHER`,
    `PICKUP_WEAPON_GUSENBERG`,
    `PICKUP_WEAPON_DAGGER`,
    `PICKUP_WEAPON_VINTAGEPISTOL`,
    `PICKUP_WEAPON_FIREWORK`,
    `PICKUP_WEAPON_MUSKET`,
    `PICKUP_AMMO_FIREWORK`,
    `PICKUP_AMMO_FIREWORK_MP`,
    `PICKUP_PORTABLE_DLC_VEHICLE_PACKAGE`,
    `PICKUP_WEAPON_HATCHET`,
    `PICKUP_WEAPON_RAILGUN`,
    `PICKUP_WEAPON_HEAVYSHOTGUN`,
    `PICKUP_WEAPON_MARKSMANRIFLE`,
    `PICKUP_WEAPON_CERAMICPISTOL`,
    `PICKUP_WEAPON_HAZARDCAN`,
    `PICKUP_WEAPON_NAVYREVOLVER`,
    `PICKUP_WEAPON_COMBATSHOTGUN`,
    `PICKUP_WEAPON_GADGETPISTOL`,
    `PICKUP_WEAPON_MILITARYRIFLE`,
    `PICKUP_WEAPON_FLAREGUN`,
    `PICKUP_AMMO_FLAREGUN`,
    `PICKUP_WEAPON_KNUCKLE`,
    `PICKUP_WEAPON_MARKSMANPISTOL`,
    `PICKUP_WEAPON_COMBATPDW`,
    `PICKUP_PORTABLE_CRATE_FIXED_INCAR`,
    `PICKUP_WEAPON_COMPACTRIFLE`,
    `PICKUP_WEAPON_DBSHOTGUN`,
    `PICKUP_WEAPON_MACHETE`,
    `PICKUP_WEAPON_MACHINEPISTOL`,
    `PICKUP_WEAPON_FLASHLIGHT`,
    `PICKUP_WEAPON_REVOLVER`,
    `PICKUP_WEAPON_SWITCHBLADE`,
    `PICKUP_WEAPON_AUTOSHOTGUN`,
    `PICKUP_WEAPON_BATTLEAXE`,
    `PICKUP_WEAPON_COMPACTLAUNCHER`,
    `PICKUP_WEAPON_MINISMG`,
    `PICKUP_WEAPON_PIPEBOMB`,
    `PICKUP_WEAPON_POOLCUE`,
    `PICKUP_WEAPON_WRENCH`,
    `PICKUP_WEAPON_ASSAULTRIFLE_MK2`,
    `PICKUP_WEAPON_CARBINERIFLE_MK2`,
    `PICKUP_WEAPON_COMBATMG_MK2`,
    `PICKUP_WEAPON_HEAVYSNIPER_MK2`,
    `PICKUP_WEAPON_PISTOL_MK2`,
    `PICKUP_WEAPON_GADGETPISTOL`,
    `PICKUP_WEAPON_SMG_MK2`,
    `PICKUP_WEAPON_STONE_HATCHET`,
    `PICKUP_WEAPON_METALDETECTOR`,
    `PICKUP_WEAPON_TACTICALRIFLE`,
    `PICKUP_WEAPON_PRECISIONRIFLE`,
    `PICKUP_WEAPON_EMPLAUNCHER`,
    `PICKUP_AMMO_EMPLAUNCHER`,
    `PICKUP_WEAPON_HEAVYRIFLE`,
    `PICKUP_WEAPON_PETROLCAN_SMALL_RADIUS`,
    `PICKUP_WEAPON_FERTILIZERCAN`,
    `PICKUP_WEAPON_STUNGUN_MP`,
}

CreateThread(function()
    while true do
        for i=1,#PickUpList do
            RemoveAllPickupsOfType(PickUpList[i])
        end
        Wait(1500)
    end
end)


local function ApplyVIPBoost(Vehicle, VipBoost)
    if not Vehicle or Vehicle == 0 or not DoesEntityExist(Vehicle) then
        return
    end
    
    local Init = GetVehicleHandlingFloat(Vehicle,"CHandlingData","fInitialDriveForce")
    local InitStering = GetVehicleHandlingFloat(Vehicle,"CHandlingData","fSteeringLock")
    local InitCurveMax = GetVehicleHandlingFloat(Vehicle,"CHandlingData","fTractionCurveMax")
    local InitCurveMin = GetVehicleHandlingFloat(Vehicle,"CHandlingData","fTractionCurveMin")
    local InitDriveInertia = GetVehicleHandlingFloat(Vehicle,"CHandlingData","fDriveInertia")    
    local InitBrakeForce = GetVehicleHandlingFloat(Vehicle,"CHandlingData","fBrakeForce")
    
    SetVehicleHandlingFloat(Vehicle, "CHandlingData", "fInitialDriveForce", Init + VipBoost)
    SetVehicleHandlingFloat(Vehicle, "CHandlingData", "fSteeringLock", InitStering + VipBoost)
    SetVehicleHandlingFloat(Vehicle, "CHandlingData", "fTractionCurveMax", InitCurveMax + VipBoost)
    SetVehicleHandlingFloat(Vehicle, "CHandlingData", "fTractionCurveMin", InitCurveMin + VipBoost)
    SetVehicleHandlingFloat(Vehicle, "CHandlingData", "fDriveInertia", InitDriveInertia + VipBoost)
    SetVehicleHandlingFloat(Vehicle, "CHandlingData", "fBrakeForce", InitBrakeForce + 1.0)
    SetVehicleModKit(Vehicle, 0)
    SetVehicleMod(Vehicle, 11, GetVehicleMod(Vehicle, 11), true)
end

AddStateBagChangeHandler("VIPBoost", nil, function(bagName, key, value, reserved, replicated)
    if value == nil then
        return
    end
    
    local entityId = GetEntityFromStateBagName(bagName)
    
    if not entityId or entityId == 0 then
        return
    end
    
    while not DoesEntityExist(entityId) do
        Wait(100)
    end
    
    if GetEntityType(entityId) == 2 then
        ApplyVIPBoost(entityId, value)
    end
end)

local function ApplyVolanteAviao(Vehicle, SteeringDownforceValue)
    if not Vehicle or not DoesEntityExist(Vehicle) then

        return
    end

    local InitSteering = GetVehicleHandlingFloat(Vehicle, "CHandlingData", "fSteeringLock")
    local InitDownforce = GetVehicleHandlingFloat(Vehicle, "CHandlingData", "fDownforceModifier")

    SetVehicleHandlingFloat(Vehicle, "CHandlingData", "fSteeringLock", InitSteering + SteeringDownforceValue)
    SetVehicleHandlingFloat(Vehicle, "CHandlingData", "fDownforceModifier", InitDownforce + SteeringDownforceValue)
end

AddStateBagChangeHandler("VolanteAviao", nil, function(bagName, key, value, reserved, replicated)
    if value == nil then 
        
        return
    end

    local entityId = GetEntityFromStateBagName(bagName)

    if not entityId then

        return
    end

    while not DoesEntityExist(entityId) do

        Wait(100)
    end

    if GetEntityType(entityId) == 2 then

        ApplyVolanteAviao(entityId, value)
    end
end)

RegisterNetEvent("admin:VIPBoost")
AddEventHandler("admin:VIPBoost", function(VipBoost, AllowNotify)
    local Ped = PlayerPedId()
    local Vehicle = GetVehiclePedIsIn(Ped, false)
    if Vehicle and Vehicle ~= 0 then
        local vehicleNetId = VehToNet(Vehicle)
        TriggerServerEvent("admin:VIPBoost:SetStateBag", vehicleNetId, VipBoost)
        
        if AllowNotify then
            TriggerEvent("Notify2", "#boost")
        end
    end
end)

RegisterNetEvent("admin:VolanteAviao")
AddEventHandler("admin:VolanteAviao", function(SteeringDownforceValue, AllowNotify)
    local Ped = PlayerPedId()
    local Vehicle = GetVehiclePedIsIn(Ped, false)

    if Vehicle and Vehicle ~= 0 then

        local vehicleNetId = VehToNet(Vehicle)
        
        TriggerServerEvent("admin:VolanteAviao:SetStateBag", vehicleNetId, SteeringDownforceValue)

        if AllowNotify then

            TriggerEvent("Notify", "verde", "Volante de avião aplicado com valor: "..SteeringDownforceValue, 5000)
        end
    end
end)

CreateThread(function()
    local lastVehicle = 0
    while true do
        Wait(1000)
        local Ped = PlayerPedId()
        local Vehicle = GetVehiclePedIsIn(Ped, false)
        
        if Vehicle and Vehicle ~= 0 and Vehicle ~= lastVehicle then
            lastVehicle = Vehicle
            local vipBoost = Entity(Vehicle)["state"]["VIPBoost"]
            if vipBoost and vipBoost > 0 then
                ApplyVIPBoost(Vehicle, vipBoost)
            end

            local volanteAviao = Entity(Vehicle)["state"]["VolanteAviao"]
            if volanteAviao and volanteAviao > 0 then
                ApplyVolanteAviao(Vehicle, volanteAviao)
            end
        elseif not Vehicle or Vehicle == 0 then
            lastVehicle = 0
        end
    end
end)


RegisterNetEvent("admin:FreezeVehicle")
AddEventHandler("admin:FreezeVehicle", function()
    local Ped = PlayerPedId()
    local Vehicle = GetVehiclePedIsIn(Ped,false)
    if Vehicle then
        local IsFrozen = IsEntityPositionFrozen(Vehicle) or false
        FreezeEntityPosition(Vehicle, not IsFrozen)
        Wait(500)
        FreezeEntityPosition(Vehicle,isFrozen)
    end
end)

RegisterNetEvent("admin:InviVehicle")
AddEventHandler("admin:InviVehicle", function()
    local Ped = PlayerPedId()
    local Vehicle = GetVehiclePedIsIn(Ped,false)
    if Vehicle then
        local IsVisible = IsEntityVisible(Vehicle) or false
        SetEntityVisible(Vehicle, not IsVisible)
        SetEntityVisible(Ped, not IsVisible)
    end
end)

local BaseValue = {}
RegisterNetEvent("admin:TurnVehicle")
AddEventHandler("admin:TurnVehicle", function()
    local Ped = PlayerPedId()
    local Vehicle = GetVehiclePedIsIn(Ped,false)
    if Vehicle then
        SetVehicleHandlingFloat(Vehicle,"CHandlingData","fSteeringLock",80.0)
        SetVehicleHandlingFloat(Vehicle,"CHandlingData","fTractionCurveMax",12.0)
        SetVehicleHandlingFloat(Vehicle,"CHandlingData","fTractionCurveMin",12.0)
        -- SetVehicleHandlingFloat(Vehicle,"CHandlingData","fRollCentreHeightFront",0.2)
        -- SetVehicleHandlingFloat(Vehicle,"CHandlingData","fRollCentreHeightRear",0.2)
        -- SetVehicleHandlingFloat(Vehicle,"CHandlingData","fSuspensionForce",10.0)
        -- SetVehicleHandlingFloat(Vehicle,"CHandlingData","fSuspensionCompDamp",10.0)
    end
end)

-- CreateThread(function()
--     while true do
--         local Ped = PlayerPedId()
--         DisableOcclusionThisFrame()
--         SetDisableDecalRenderingThisFrame()
--         RemoveParticleFxInRange(GetEntityCoords(Ped), 10.0)
--         SetArtificialLightsState(true)
--         OverrideLodscaleThisFrame(0.4)
--         Wait(0)
--     end
-- end)

-- CreateThread(function()
--     while true do
--         local Ped = PlayerPedId()
--         local Peds = GetGamePool("CPed")
--         for i=1,#Peds do
--             local SelectedPed = Peds[i]
--             if SelectedPed ~= Ped then
--                 if not IsEntityOnScreen(SelectedPed) then
--                     SetEntityAlpha(SelectedPed, 0)
--                     SetEntityAsNoLongerNeeded(SelectedPed)
--                 else
--                     SetEntityAlpha(SelectedPed, 255)
--                 end
--             end 
--             SetPedAoBlobRendering(SelectedPed, false)
--             Wait(1)
--         end
--         Wait(100)
--     end
-- end)

-- CreateThread(function()
--     while true do
--         ClearAllBrokenGlass()
--         ClearAllHelpMessages()
--         LeaderboardsReadClearAll()
--         ClearBrief()
--         ClearGpsFlags()
--         ClearPrints()
--         ClearSmallPrints()
--         ClearReplayStats()
--         LeaderboardsClearCacheData()
--         ClearFocus()
--         ClearHdArea()
--         ClearPedBloodDamage(PlayerPedId())
--         ClearPedWetness(PlayerPedId())
--         ClearPedEnvDirt(PlayerPedId())
--         ResetPedVisibleDamage(PlayerPedId())
--         ClearExtraTimecycleModifier()
--         ClearTimecycleModifier()
--         ClearOverrideWeather()
--         ClearHdArea()
--         DisableVehicleDistantlights(false)
--         DisableScreenblurFade()
--         SetRainLevel(0.0)
--         SetWindSpeed(0.0)
--         Wait(1500)
--     end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPAIRPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
local DRUNK_DRIVING_EFFECTS = {
    1, -- brake
    7, --turn left + accelerate
    8, -- turn right + accelerate
    23, -- accelerate
    4, -- turn left 90 + braking
    5, -- turn right 90 + braking
}

local function getRandomDrunkCarTask()
    math.randomseed(GetGameTimer())
    return DRUNK_DRIVING_EFFECTS[math.random(#DRUNK_DRIVING_EFFECTS)]
end

RegisterNetEvent("inventory:DestroyPlayerVehicle")
AddEventHandler("inventory:DestroyPlayerVehicle",function(Index)
	if NetworkDoesNetworkIdExist(Index) then
		local Vehicle = NetToEnt(Index)
        local Ped = PlayerPedId()
        local VehiclePedIn = GetPedInVehicleSeat(Vehicle,-1)
        if DoesEntityExist(Vehicle) then
            if VehiclePedIn == Ped then
                local randomTask = getRandomDrunkCarTask()
                TaskVehicleTempAction(Ped, Vehicle, randomTask, 500)
            end
            Wait(1000)
            SetVehicleEngineHealth(Vehicle, 0)
            SetVehicleEngineOn(Vehicle, false, true, true)
            for doorIndex = 0, GetNumberOfVehicleDoors(Vehicle) do
                RemoveVehicleWindow(Vehicle, doorIndex)
                SetVehicleDoorBroken(Vehicle, tonumber(doorIndex), true)
            end
            SetVehicleFuelLevel(Vehicle, 0)
		end
	end
end)

RegisterNetEvent("inventory:DestroyPlayerTyres")
AddEventHandler("inventory:DestroyPlayerTyres",function(Index)
	if NetworkDoesNetworkIdExist(Index) then
		local Vehicle = NetToEnt(Index)
        local Ped = PlayerPedId()
        local VehiclePedIn = GetPedInVehicleSeat(Vehicle,-1)
        if DoesEntityExist(Vehicle) then
            for i = 0, 7 do
                SetVehicleTyreBurst(Vehicle, i, true, 1000)
                Wait(50)
            end
		end
	end
end)

function Creative.CheckIfPedOnGround()
    local Ped = PlayerPedId()
    return IsPedCloseToGround(Ped, 10.0)
end

-- Function to check if a ped is close to the ground or any surface
-- @param ped: the ped entity to check
-- @param threshold: the height threshold to consider 'close' to the ground (in meters)
-- @return: boolean true if close, false otherwise
function IsPedCloseToGround(ped, threshold)
    if ped and DoesEntityExist(ped) then
        local height = GetEntityHeightAboveGround(ped)
        print("[DEBUG] Height above ground: " ..height)
        if height <= threshold then
            return true
        else
            return false
        end
    else
        return false
    end
end

RegisterCommand("closeground",function()
    local isCloseToGround = IsPedCloseToGround(PlayerPedId(), 10.0)
    print("[DEBUG] Is ped close to ground: " ..tostring(isCloseToGround))
end)

RegisterCommand('cds', function()
    if LocalPlayer.state['minigame:active']
        and not (LocalPlayer.state['minigame:active'] == 'neighbor'
            and tonumber(vRP.GetPlayerGroups()['Admin']) == 1) then
        return
    end
    
    local focusPos = sx.client.player.getFocusPosition()

    local focusHeading = sx.client.player.getFocusHeading()

    exports[ 'keyboard' ]:keyCopy(
        _t("coordinates"),
        ( '%0.2f,%0.2f,%0.2f,%0.2f' ):format( focusPos.x, focusPos.y, focusPos.z, focusHeading )
    )
end, false )


RegisterCommand( "id", function( )
    if LocalPlayer.state['minigame:active']
        and not (LocalPlayer.state['minigame:active'] == 'neighbor'
            and tonumber(vRP.GetPlayerGroups()['Admin']) == 1) then
        return
    end

    local nearbyPlayers = sx.client.spatial.findPlayersNearby( 10.0, 1 )

    local playerSource = nearbyPlayers?[ 1 ]

    local playerServerId = Player( playerSource ).state.Passport

    TriggerEvent( "Notify2", "#id", { msg = playerServerId } )
    
end)

RegisterCommand( "psul", function( )

    local nearbyPlayers = sx.client.spatial.findPlayersNearby( 20.0, 15 )

    if #nearbyPlayers <= 0 then
        return
    end

    TriggerServerEvent( 'net.psul.teleport_nearbyplayers', nearbyPlayers )
end)

RegisterCommand( "ppraca", function( )

    local nearbyPlayers = sx.client.spatial.findPlayersNearby( 20.0, 15 )

    if #nearbyPlayers <= 0 then
        return
    end

    TriggerServerEvent( 'net.ppraca.teleport_nearbyplayers', nearbyPlayers )
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COR
-----------------------------------------------------------------------------------------------------------------------------------------
---@type number
local gLastCorUpdate = GetGameTimer()

-- RegisterCommand( 'cor', function( _, args )

--     local tintIndex = tonumber( args[ 1 ] )
--     local authorizedGroups = sx.vipsystem.GetVipsScriptsConfig("cor","cor_command_authorized_vips")
--     local COR_COMMAND_AUTHORIZED_VIPS = {}

--     for group, vip in ipairs( authorizedGroups ) do
--         table.insert( COR_COMMAND_AUTHORIZED_VIPS, group )
--     end

--     for _, vip in ipairs( COR_COMMAND_AUTHORIZED_VIPS ) do

--     -- print('"/cor" :: tintIndex=', tintIndex)

--     if tintIndex == nil or tintIndex < 0 then
--         return
--     end

--     ---#unsafe - Não deveria confiar no cliente para fazer essa verificação! Mas é coisa boba...
--     ---@type boolean
--     local isAuthorized = false

--     for _, vip in ipairs( COR_COMMAND_AUTHORIZED_VIPS ) do

--         -- print('"/cor" :: LocalPlayer.state[ vip ]=', LocalPlayer.state[ vip ])

--         if LocalPlayer.state[ vip ] then

--             isAuthorized = true

--             break
--         end
--     end

--     -- print('"/cor" :: isAuthorized=', isAuthorized)

--     if not isAuthorized then
--         TriggerEvent( 'Notify2', '#comandoNpermitido' )
--         return
--     end
--     ---#unsafe end

--     -- print('"/cor" :: gLastCorUpdate=', gLastCorUpdate)
--     -- print('"/cor" :: GetGameTimer=', GetGameTimer())

--     -- Alguns segundos de cooldown
--     if gLastCorUpdate + 5000 > GetGameTimer() then
--         return
--     end

--     gLastCorUpdate = GetGameTimer()

--     TriggerEvent( 'inventory:WeaponColor', tintIndex )

--     -- print('"/cor" :: applied!')
-- end)

RegisterCommand("debugvoip",function()
    local isMumbleActive = MumbleIsActive()
    local isMumbleConnected = MumbleIsConnected()
    print("[DEBUG] Mumble active: " ..tostring(isMumbleActive))
    print("[DEBUG] Mumble connected: " ..tostring(isMumbleConnected))
end)

RegisterNetEvent("vRP:Active")
AddEventHandler("vRP:Active",function(Passport,Name)
    local isMumbleActive = MumbleIsActive()
    local isMumbleConnected = MumbleIsConnected()
end)

CreateThread(function()
    while true do
        Wait(5000)
        local isMumbleActive = MumbleIsActive()
        local isMumbleConnected = MumbleIsConnected()
    end
end)

RegisterCommand("cycleeditor",function()
    ActivateTimecycleEditor()
end)



local boxCreation = {
    active = false,
    startCoords = vector3(0,0,0),
    endCoords = vector3(0,0,0),
    selectedAxis = "x", -- "x", "y", or "z"
    color = {r = 255, g = 0, b = 0, a = 100}
}

function createBox()
    boxCreation.active = not boxCreation.active
    
    if boxCreation.active then
        local ped = PlayerPedId()
        boxCreation.startCoords = GetEntityCoords(ped)
        boxCreation.endCoords = boxCreation.startCoords + vector3(5.0, 5.0, 5.0)
        while boxCreation.active do
            local pedCoords = GetEntityCoords(ped)
            DrawBox(
                boxCreation.startCoords.x, boxCreation.startCoords.y, boxCreation.startCoords.z,
                boxCreation.endCoords.x, boxCreation.endCoords.y, boxCreation.endCoords.z,
                boxCreation.color.r, boxCreation.color.g, boxCreation.color.b, boxCreation.color.a
            )

            DwText("Selected Axis: " .. string.upper(boxCreation.selectedAxis) .. "\nUse Mouse Wheel to adjust\nPress E to change axis\nPress F to cancel",4,0.015,0.70,0.38,255,255,255,255)
            
            if IsControlJustReleased(0, 14) then -- Mouse wheel down
                local change = boxCreation.selectedAxis == "x" and vector3(1.0, 0.0, 0.0) or
                                boxCreation.selectedAxis == "y" and vector3(0.0, 1.0, 0.0) or
                                vector3(0.0, 0.0, 1.0)
                boxCreation.endCoords = boxCreation.endCoords - change
            elseif IsControlJustReleased(0, 15) then -- Mouse wheel up
                local change = boxCreation.selectedAxis == "x" and vector3(1.0, 0.0, 0.0) or
                                boxCreation.selectedAxis == "y" and vector3(0.0, 1.0, 0.0) or
                                vector3(0.0, 0.0, 1.0)
                boxCreation.endCoords = boxCreation.endCoords + change
            end
            
            if IsControlJustPressed(0, 38) then
                boxCreation.selectedAxis = boxCreation.selectedAxis == "x" and "y" or
                                        boxCreation.selectedAxis == "y" and "z" or "x"
            end

            -- press F to cancel
            if IsControlJustPressed(0, 49) then
                boxCreation.active = false
            end
            
            Wait(0)
        end
    end
    
    return boxCreation.startCoords, boxCreation.endCoords
end

RegisterCommand("createbox", function()
    local startCoords, endCoords = createBox()
    boxCreation = {
        active = false,
        startCoords = vector3(0,0,0),
        endCoords = vector3(0,0,0),
        selectedAxis = "x", -- "x", "y", or "z"
        color = {r = 255, g = 0, b = 0, a = 100}
    }
    print("[DEBUG] Start coords: " ..startCoords.x .."," ..startCoords.y .."," ..startCoords.z)
    print("[DEBUG] End coords: " ..endCoords.x .."," ..endCoords.y .."," ..endCoords.z)
end)

function DwText(Text,Font,x,y,Scale,R,G,B,A)
    SetTextFont(Font)
    SetTextScale(Scale,Scale)
    SetTextColour(R,G,B,A)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(Text)
    DrawText(x,y)
end


RegisterCommand("testdryvolume",function(source, args)
    -- Example coordinates
    local x1, y1, z1 =  -3279.5581054688,581.23388671875,2.1283178329468
    local x2, y2, z2 =   -3269.5581054688,565.23388671875,10.1283187866211

    -- Calculate dimensions
    local width = math.abs(x2 - x1)
    local length = math.abs(y2 - y1)
    local height = math.abs(z2 - z1)

    -- Calculate center points
    local centerX = x1 + (width / 2)
    local centerY = y1 + (length / 2)
    local centerZ = z1 + (height / 2)

    print("=== Box Dimensions ===")
    print("Width: " .. width)
    print("Length: " .. length)
    print("Height: " .. height)
    print("\n=== Center Point ===")
    print("X: " .. centerX)
    print("Y: " .. centerY)
    print("Z: " .. centerZ)
    print("\n=== Formatted Vector3 ===")
    print(string.format("vector3(%f, %f, %f)", centerX, centerY, centerZ))
    local dryvolume = CreateDryVolume(x1, y1, z1, x2, y2, z2)
    print("[DEBUG] Dryvolume created: " ..tostring(dryvolume))
end)

local waterQuadDebug = false
RegisterCommand("waterquaddebug",function(source, args)
    waterQuadDebug = not waterQuadDebug
    if waterQuadDebug then
        while waterQuadDebug do
            local currentPedPosition = GetEntityCoords(PlayerPedId())
            local waterQuadIndex  = GetWaterQuadAtCoords(currentPedPosition.x, currentPedPosition.y)
            local waterQuadType = GetWaterQuadType(waterQuadIndex)
            local success, minX, minY, maxX, maxY = GetWaterQuadBounds(waterQuadIndex)
            if success then
                DwText("Water quadindex: " ..tostring(waterQuadIndex) .."\nType: " ..tostring(waterQuadType) .."\nMin:" ..minX .."," ..minY .."\nMax: " ..maxX .."," ..maxY,4,0.015,0.70,0.38,255,255,255,255)
            else
                DwText("No water quad found",4,0.015,0.70,0.38,255,255,255,255)
            end 
            Wait(0)
        end
    end
end)

RegisterCommand("setquadbounds",function(source, args)
    local success = SetWaterQuadType(tonumber(args[1]), tonumber(args[6]))
    print("[DEBUG] Set water quad type: " ..tostring(success))
    local Quadtype = GetWaterQuadType(tonumber(args[1]))
    print("[DEBUG] Quad type: " ..tostring(Quadtype))
    local success = SetWaterQuadBounds(tonumber(args[1]), tonumber(args[2]), tonumber(args[3]), tonumber(args[4]), tonumber(args[5]))
    -- local success = SetWaterQuadBounds(500, 536.0, -806.0, 650.0, -708.0)
    print("[DEBUG] Set water quad bounds: " ..tostring(success))
end)

---@alias TickAbortSignal fun()

---TODO: Mover para sx
---@param fn fun()
---@return TickAbortSignal
local function setTick( fn )

    local abort = false

    CreateThread(
        function()
            while not abort do

                fn()

                Wait(0)
            end
        end
    )

    return function()

        abort = true
    end
end

local FREECAM_NETWORK_POSITION_UPDATE_DEFAULT_INTERVAL_MS = 5000
local FREECAM_NETWORK_POSITION_UPDATE_SCHEDULED_INTERVAL_MS = 500

local FREECAM_NETWORK_POSITION_UPDATE_THRESHOLD   = 0.25

---@type boolean
local gIsUsingFreecam = false

---@type TickAbortSignal | nil
local gFreecamUpdateAbortSignal = nil

---@type number | nil
local gFreecamCamId = nil

---@type vector3 | nil
local gFreecamWishPosition = nil

---@type number
local gFreecamCurrInteriorId = 0

---@type number
local gFreecamLastNetworkedTime = GetGameTimer()

---@type vector3 | nil
local gFreecamLastNetworkedPos = nil

---@type number | nil
local gFreecamNetworkedUpdateScheduledTo = nil

---@type vector3 | nil
local gFreecamExitPosition = nil

---@type Source | nil
local gFreecamSpectatorModeSpectateSource = nil

---@type number | nil
local gFreecamSpectatorModeOrbitYaw   = nil
---@type number | nil
local gFreecamSpectatorModeOrbitPitch = nil

---@type boolean
local gFreecamMumbleIsTalking = false

function IsUsingFreecam()
    return gIsUsingFreecam
end

-- A gente força a terceira pessoa quando o script inicia
-- porque quando o player sai do servidor, não da tempo do game salvar
-- o novo contexto de camera alterado com SetFreecamEnabled( false )
SetCamViewModeForContext( GetCamActiveViewModeContext(), 1 --[[ eCamViewMode.THIRD_PERSON_MEDIUM  ]])

---@param enabled boolean
local function SetFreecamEnabled( enabled )

    assert( gIsUsingFreecam ~= enabled, 'Freecam is already ' ..tostring(enabled) )

    gIsUsingFreecam = enabled

    local pedId = PlayerPedId()

    if gIsUsingFreecam then

        local pedPos = GetEntityCoords( pedId )

        local camId = CreateCam( 'DEFAULT_SCRIPTED_CAMERA', true )

        local camPos = GetFinalRenderedCamCoord()

        local camRot = GetFinalRenderedCamRot( 2 )

        SetCamCoord( camId, camPos.x, camPos.y, camPos.z )
        SetCamRot( camId, camRot.x, camRot.y, camRot.z, 2 )
        SetCamActive( camId, true )
        SetCamFov( camId, 50.0 )

        RenderScriptCams(true, false, 5000, true, true)

        SetCamControlsMiniMapHeading( camId, true )

        gFreecamCamId = camId

        gFreecamSpectatorModeOrbitYaw = 0.0
        gFreecamSpectatorModeOrbitPitch = 0.0

        -- Forçar primeira pessoa para que o mumble use a camera/viewport
        -- para definir de qual posição o audio do player deve ser emitido
        SetCamViewModeForContext( GetCamActiveViewModeContext(), 1 --[[ eCamViewMode.THIRD_PERSON_MEDIUM ]])

        gFreecamUpdateAbortSignal = setTick(
            function()

                UpdateFreecam( camId )
            end
        )

    else
        local camPos = GetCamCoord( gFreecamCamId )

        gFreecamUpdateAbortSignal()
        gFreecamUpdateAbortSignal = nil

        local exitPos = gFreecamExitPosition or camPos

        SetEntityCoordsNoOffset( pedId, exitPos.x, exitPos.y, exitPos.z )

        DestroyCam(gFreecamCamId, false)
        gFreecamCamId = nil

        RenderScriptCams(false, false, 5000, true, true)

        ClearFocus()

        UnlockMinimapPosition()

        gFreecamSpectatorModeSpectateSource = nil

        SetCamViewModeForContext( GetCamActiveViewModeContext(), 1 --[[ eCamViewMode.THIRD_PERSON_MEDIUM  ]])

        gFreecamMumbleTalkingPedLastPos = nil
        gFreecamMumbleIsTalking = false

        if gFreecamCurrInteriorId ~= 0 then

            UnpinInterior( gFreecamCurrInteriorId )
        end

        gFreecamCurrInteriorId = 0
    end

    NetworkSetInSpectatorMode( gIsUsingFreecam, pedId )

    SetEntityInvincible( pedId, gIsUsingFreecam )
    SetEntityVisible( pedId, not gIsUsingFreecam, false )
    SetEntityCollision( pedId, not gIsUsingFreecam, true )
    FreezeEntityPosition( pedId, gIsUsingFreecam )

    SetPlayerControl( PlayerId(), not gIsUsingFreecam, 0 )

    CreateThread(
        function()
    
            DisplayRadar(  gIsUsingFreecam)

            Wait(10)

            SetBigmapActive( gIsUsingFreecam, false )
        end
    )
end

---@param enabled boolean
RegisterNetEvent( 'freecam.set_enabled', function( enabled )

    SetFreecamEnabled( enabled )
end)


local MAX_ATTEMPTS_NOCLIP = 30
local INTERVAL_ATTEMPTS_NOCLIP_MS = 100

RegisterNetEvent( 'net.force_noclip', function()
    for i = 1, MAX_ATTEMPTS_NOCLIP do -- estamos tentando forçar mesmo o mesmo estado de noclip que o player está ( doidera )
        SetEntityVisible(PlayerPedId(), not vRP.ReturnNoClip(), false)
        Wait(INTERVAL_ATTEMPTS_NOCLIP_MS)
    end
end)

AddEventHandler( 'onResourceStop', function( resourceName )

    if resourceName == GetCurrentResourceName() then
        -- Soltar qualquer jogador que estiver sendo segurado usando o sistema sx
        if HeldPlayerServerId then
            TriggerServerEvent('sx.player_attachment.request_detach_child_or_parent')
        end
        HeldPlayerServerId = nil

        if gIsUsingFreecam then

            SetFreecamEnabled( false )
        end
    end
end)

local LOOK_SENSITIVITY_X = 10
local LOOK_SENSITIVITY_Y = 10

local BASE_MOVE_MULTIPLIER = 1
local FAST_MOVE_MULTIPLIER = 10
local SLOW_MOVE_MULTIPLIER = 10

local INPUT_MOVE_UD = 31
local INPUT_MOVE_LR = 30
function Clamp(x, min, max)
    return math.min(math.max(x, min), max)
end
function ClampCameraRotation(rotX, rotY, rotZ)
    local x = Clamp(rotX, -90.0, 90.0)
    local y = rotY % 360
    local z = rotZ % 360
    return x, y, z
end

local function GetFreecamSpeedMultiplier()
    local fastNormal = GetDisabledControlNormal( 0, 21 --[[ INPUT_SPRINT ]])
    local slowNormal = GetDisabledControlNormal( 0, 19 --[[ INPUT_CHARACTER_WHEEL ]])

    local baseSpeed = BASE_MOVE_MULTIPLIER
    local fastSpeed = 1 + ((FAST_MOVE_MULTIPLIER - 1) * fastNormal)
    local slowSpeed = 1 + ((SLOW_MOVE_MULTIPLIER - 1) * slowNormal)

    local frameMultiplier = GetFrameTime() * 60
    local speedMultiplier = baseSpeed * fastSpeed / slowSpeed

    return speedMultiplier * frameMultiplier
end

function EulerToMatrix(rotX, rotY, rotZ)
    local radX = math.rad(rotX)
    local radY = math.rad(rotY)
    local radZ = math.rad(rotZ)

    local sinX = math.sin(radX)
    local sinY = math.sin(radY)
    local sinZ = math.sin(radZ)
    local cosX = math.cos(radX)
    local cosY = math.cos(radY)
    local cosZ = math.cos(radZ)

    local vecX = {}
    local vecY = {}
    local vecZ = {}

    vecX.x = cosY * cosZ
    vecX.y = cosY * sinZ
    vecX.z = -sinY

    vecY.x = cosZ * sinX * sinY - cosX * sinZ
    vecY.y = cosX * cosZ - sinX * sinY * sinZ
    vecY.z = cosY * sinX

    vecZ.x = -cosX * cosZ * sinY + sinX * sinZ
    vecZ.y = -cosZ * sinX + cosX * sinY * sinZ
    vecZ.z = cosX * cosY

    vecX = vector3(vecX.x, vecX.y, vecX.z)
    vecY = vector3(vecY.x, vecY.y, vecY.z)
    vecZ = vector3(vecZ.x, vecZ.y, vecZ.z)

    return vecX, vecY, vecZ
end

---@return boolean
local function IsPlayerUsingPausemap()

    return IsPauseMenuActive() and GetNumberOfReferencesOfScriptWithNameHash(`pausemenu_map`) > 0
end

---Putaria para conseguir falar pelo mumble com o spectatormode ativo
---já que o mumble nao aceita inputs de playesr que não existem localmente
---para os outros players ( que é o cado do nosso spectator mode )
---@param freecamCamPos vector3
local function UpdateFreecamMumbleTalking( freecamCamPos )

    local prevFreecamMumbleIsTalking = gFreecamMumbleIsTalking

    local isMumbleTalking = MumbleIsPlayerTalking( PlayerId() ) == 1

    if isMumbleTalking ~= prevFreecamMumbleIsTalking then

        local pedId = PlayerPedId()

        if isMumbleTalking then

            gFreecamMumbleTalkingPedLastPos = GetEntityCoords( pedId )

        else
            if gFreecamMumbleTalkingPedLastPos then

                SetEntityCoords( pedId, gFreecamMumbleTalkingPedLastPos.x, gFreecamMumbleTalkingPedLastPos.y, gFreecamMumbleTalkingPedLastPos.z )
            end

            gFreecamMumbleTalkingPedLastPos = nil
        end

        gFreecamMumbleIsTalking = isMumbleTalking
    end

    if isMumbleTalking then

        SetEntityCoords( PlayerPedId(), freecamCamPos.x, freecamCamPos.y, freecamCamPos.z )
    end
end

---@param camId number
function UpdateFreecam( camId )

    local pos = gFreecamWishPosition or GetCamCoord( camId )
    local rot = GetCamRot( camId )

    local wishPos = vector3( pos.x, pos.y, pos.z )

    if IsPauseMenuActive() then

        if IsPlayerUsingPausemap() and not IsPausemapInInteriorMode() then

            SetFakePausemapPlayerPositionThisFrame( wishPos.x, wishPos.y )
    
            -- SetFakeGPSPlayerPositionThisFrame
            Citizen.InvokeNative( 0xc8813dfdeca7bb27, wishPos.x, wishPos.y, wishPos.z )    
        end

        -- Não processar movimento da freecam enquanto
        -- o menu de pause está aberto

        return
    end

    gFreecamWishPosition = nil

    local isInSpectatorMode = gFreecamSpectatorModeSpectateSource ~= nil

    local vecX, vecY = EulerToMatrix(rot.x, rot.y, rot.z)
    local vecZ = vector3(0, 0, 1)

    -- Get speed multiplier for movement
    local speedMultiplier = GetFreecamSpeedMultiplier()

    local lookX = GetDisabledControlNormal( 0, 1 --[[ INPUT_LOOK_LR ]])
    local lookY = GetDisabledControlNormal( 0, 2 --[[ INPUT_LOOK_UD ]])

    if      not isInSpectatorMode then

        -- Get position input
        local moveX = GetDisabledControlNormal( 0, INPUT_MOVE_LR )
        local moveY = GetDisabledControlNormal( 0, INPUT_MOVE_UD )
        local moveZ = 0.0 -- GetDisabledControlNormal( 0, CONTROLS.MOVE_Z)

        local wishRotX = rot.x + ( -lookY * LOOK_SENSITIVITY_X )
        local wishRotZ = rot.z + ( -lookX * LOOK_SENSITIVITY_Y )
        local wishRotY = rot.y

        wishRotX, wishRotY, wishRotZ = ClampCameraRotation( wishRotX, wishRotY, wishRotZ )

        -- Adjust position relative to camera rotation.
        wishPos = wishPos + ( vecX *  moveX * speedMultiplier )
        wishPos = wishPos + ( vecY * -moveY * speedMultiplier )
        wishPos = wishPos + ( vecZ *  moveZ * speedMultiplier )

        SetCamRot( camId, wishRotX, wishRotY, wishRotZ )

    elseif isInSpectatorMode then

        local attachedToPlayerIndex = GetPlayerFromServerId( gFreecamSpectatorModeSpectateSource )

        if attachedToPlayerIndex ~= -1 then

            local attachedToPlayerPedId = GetPlayerPed( attachedToPlayerIndex )

            if DoesEntityExist( attachedToPlayerPedId ) then

                local attachedToPlayerVehicleId = GetVehiclePedIsIn( attachedToPlayerPedId, false )

                local isAttachedToPlayerInAVehicle = attachedToPlayerVehicleId ~= 0

                local attachedToPlayerBasePos = GetOffsetFromEntityInWorldCoords( isAttachedToPlayerInAVehicle and attachedToPlayerVehicleId or attachedToPlayerPedId, 0.0, 0.0, 1.5 )
    
                gFreecamSpectatorModeOrbitYaw   = gFreecamSpectatorModeOrbitYaw   - ( lookX * LOOK_SENSITIVITY_X --[[ sensitividade ]] )
                gFreecamSpectatorModeOrbitPitch = gFreecamSpectatorModeOrbitPitch + ( lookY * LOOK_SENSITIVITY_X --[[ sensitividade ]] )
    
                gFreecamSpectatorModeOrbitPitch = math.min(  89.0, gFreecamSpectatorModeOrbitPitch )
                gFreecamSpectatorModeOrbitPitch = math.max( -89.0, gFreecamSpectatorModeOrbitPitch )

                local pitchRad = math.rad( gFreecamSpectatorModeOrbitPitch )
                local yawRad   = math.rad( gFreecamSpectatorModeOrbitYaw   )

                local DISTANCE = not isAttachedToPlayerInAVehicle and 3.5 or 5.0

                local offsetX = DISTANCE * math.cos( pitchRad ) * math.cos( yawRad )
                local offsetY = DISTANCE * math.cos( pitchRad ) * math.sin( yawRad )
                local offsetZ = DISTANCE * math.sin( pitchRad )

                wishPos = vector3(
                    attachedToPlayerBasePos.x + offsetX,
                    attachedToPlayerBasePos.y + offsetY,
                    attachedToPlayerBasePos.z + offsetZ
                )

                PointCamAtEntity( camId, attachedToPlayerPedId, 0.0, 0.0, 0.0, true )
            end
        end
    end

    SetCamCoord( camId, wishPos.x, wishPos.y, wishPos.z )

    if not IsNewLoadSceneActive() then

        SetFocusPosAndVel( wishPos.x, wishPos.y, wishPos.z, 0.0, 0.0, 0.0 )
    end

    local int = GetInteriorAtCoords( wishPos.x, wishPos.y, wishPos.z )

    if int ~= gFreecamCurrInteriorId then

        UnpinInterior( gFreecamCurrInteriorId )

        gFreecamCurrInteriorId = int

        LoadInterior( int )
    end

    LockMinimapPosition( wishPos.x, wishPos.y )

    local now = GetGameTimer()

    local hasReachedNetworkUpdateThreshold = not gFreecamLastNetworkedPos or #( gFreecamLastNetworkedPos - wishPos ) > FREECAM_NETWORK_POSITION_UPDATE_THRESHOLD

    if hasReachedNetworkUpdateThreshold then

        if not gFreecamNetworkedUpdateScheduledTo then

            gFreecamNetworkedUpdateScheduledTo = now + FREECAM_NETWORK_POSITION_UPDATE_SCHEDULED_INTERVAL_MS
        end
    end

    if now > gFreecamLastNetworkedTime + FREECAM_NETWORK_POSITION_UPDATE_DEFAULT_INTERVAL_MS or ( gFreecamNetworkedUpdateScheduledTo and now >= gFreecamNetworkedUpdateScheduledTo ) then

        gFreecamNetworkedUpdateScheduledTo = nil

        local buffer = { }

        local worldlimitsposition = sx.msgpackextensions.packers.worldlimitsvector3( buffer, wishPos )
        local worldlimitspositionStr = table.concat( buffer )

        TriggerServerEvent( 'net.net_freecam.update_position', worldlimitspositionStr )

        gFreecamLastNetworkedPos  = wishPos
        gFreecamLastNetworkedTime = now
    end

    UpdateFreecamMumbleTalking( wishPos )
end

---@param pos vector3
function SetFreecamWishPosition( pos )

    gFreecamWishPosition = pos
end

---@param source number
function SetFreecamInSpectatorMode( source )

    gFreecamSpectatorModeSpectateSource = source
end

---@return boolean
function IsInSpectatorMode()

    return gFreecamSpectatorModeSpectateSource ~= nil
end

---@param attachedToSource          Source
---@param attachedToPlayerName      string
---@param attachedToPlayerLastPos   vector3
local function EnterSpectatorMode( attachedToSource, attachedToPlayerName, attachedToPlayerLastPos )

    -- print( 'EnterSpectatorMode', attachedToSource, attachedToPlayerName, attachedToPlayerLastPos )

    gFreecamExitPosition = IsUsingFreecam()
        and
            (
                not IsInSpectatorMode()
                    and GetFinalRenderedCamCoord()
                    or gFreecamExitPosition
            )
        or GetEntityCoords( PlayerPedId() )

    if not IsUsingFreecam() then

        SetFreecamEnabled( true )
    end

    SetFreecamWishPosition( attachedToPlayerLastPos )

    SetFreecamInSpectatorMode( attachedToSource )

    TriggerEvent( 'Notify:Text', attachedToPlayerName )
end

---@param silently? boolean
local function ExitSpectatorMode( silently )

    -- print( 'ExitSpectatorMode' )

    gFreecamSpectatorModeSpectateSource = nil

    StopCamPointing( gFreecamCamId )

    TriggerEvent( 'Notify:Text', '' )

    if not silently then

        TriggerServerEvent( 'net.exit_spectator_mode' )
    end

    gFreecamExitPosition = nil
end

exports( 'ExitSpectatorMode', ExitSpectatorMode )

---@param attachedToSource          Source
---@param attachedToPlayerName      string
---@param attachedToPlayerLastPos   vector3
RegisterNetEvent( 'net.enter_spectator_mode', function( attachedToSource, attachedToPlayerName, attachedToPlayerLastPos )

    EnterSpectatorMode( attachedToSource, attachedToPlayerName, attachedToPlayerLastPos )
end)

-- Cancelar o spectator com o F6
AddEventHandler( 'actions:Cancel', function( skipCheck )

    if IsInSpectatorMode() or skipCheck then

        ExitSpectatorMode()
    end
end)

WaterBounds = {}

if cityName == "Kingdom" then
    WaterBounds = {
        {   
            coordsCompare = vector2(618.03,-764.22),
            index = 499,
            min = vector2(542,-884),
            max = vector2(650,-742),
            quadType = 0
        },
        {
            coordsCompare = vector2(622.65,-722.63),
            index = 500,
            min = vector2(536,-806),
            max = vector2(650,-708),
            quadType = 0
        }
    }
elseif cityName == "Imperium" then
    WaterBounds = {
        {   
            coordsCompare = vector2(618.03,-764.22),
            index = 499,
            min = vector2(542,-884),
            max = vector2(650,-742),
            quadType = 0
        },
        {
            coordsCompare = vector2(622.65,-722.63),
            index = 500,
            min = vector2(536,-806),
            max = vector2(650,-708),
            quadType = 0
        }
    }
elseif cityName == "GoatRP" then
    WaterBounds = {
        {   
            coordsCompare = vector2(618.03,-764.22),
            index = 499,
            min = vector2(542,-884),
            max = vector2(650,-742),
            quadType = 0
        },
        {
            coordsCompare = vector2(622.65,-722.63),
            index = 500,
            min = vector2(536,-806),
            max = vector2(650,-708),
            quadType = 0
        }
    }
elseif cityName == "Royal" then
    WaterBounds = {
        {   
            coordsCompare = vector2(618.03,-764.22),
            index = 499,
            min = vector2(542,-884),
            max = vector2(650,-742),
            quadType = 0
        },
        {
            coordsCompare = vector2(622.65,-722.63),
            index = 500,
            min = vector2(536,-806),
            max = vector2(650,-708),
            quadType = 0
        }
    }
elseif cityName == "District99" then
    WaterBounds = {
        {   
            coordsCompare = vector2(618.03,-764.22),
            index = 499,
            min = vector2(542,-884),
            max = vector2(650,-742),
            quadType = 0
        },
        {
            coordsCompare = vector2(622.65,-722.63),
            index = 500,
            min = vector2(536,-806),
            max = vector2(650,-708),
            quadType = 0
        }
    }
elseif cityName == "Krown" then
    WaterBounds = {
        {   
            coordsCompare = vector2(618.03,-764.22),
            index = 499,
            min = vector2(542,-884),
            max = vector2(650,-742),
            quadType = 0
        },
        {
            coordsCompare = vector2(622.65,-722.63),
            index = 500,
            min = vector2(536,-806),
            max = vector2(650,-708),
            quadType = 0
        }
    }
elseif cityName == "Orizon" then
    WaterBounds = {
        {   
            coordsCompare = vector2(618.03,-764.22),
            index = 499,
            min = vector2(542,-884),
            max = vector2(650,-742),
            quadType = 0
        },
        {
            coordsCompare = vector2(622.65,-722.63),
            index = 500,
            min = vector2(536,-806),
            max = vector2(650,-708),
            quadType = 0
        }
    }
elseif cityName == "Liberty99" then
    WaterBounds = {
        {   
            coordsCompare = vector2(618.03,-764.22),
            index = 499,
            min = vector2(542,-884),
            max = vector2(650,-742),
            quadType = 0
        },
        {
            coordsCompare = vector2(622.65,-722.63),
            index = 500,
            min = vector2(536,-806),
            max = vector2(650,-708),
            quadType = 0
        }
    }
end

-- if cityName == "Kingdom" then
--     WaterBounds = {
--         "setquadbounds 499 542 -884 650 -742 0",
--         "setquadbounds 500 536 -806 650 -708 0",
--         -- "setquadbounds 49 -3268 500 -3092 588 0",
--     }
-- elseif cityName == "Royal" then
--     WaterBounds = {
--         "setquadbounds 499 542 -884 650 -742 0",
--         "setquadbounds 500 536 -806 650 -708 0",
--         -- "setquadbounds 49 -3268 500 -3092 588 0",
--     }
-- end

function StartWaterQuadCity()
    if WaterBounds and #WaterBounds > 0 then    
        for _, bounds in ipairs(WaterBounds) do
            ExecuteCommand(bounds)
        end
    end
end

AddEventHandler("onResourceStart",function(resourceName)
    if resourceName == GetCurrentResourceName() then
        StartWaterQuadCity()
    end
end)

AddEventHandler('playerSpawned', function(resource)
    StartWaterQuadCity()
end)

RegisterNetEvent("vRP:Active")
AddEventHandler("vRP:Active",function(Passport,Name)
    StartWaterQuadCity()
end)

RegisterNetEvent("admin:setBald")
AddEventHandler("admin:setBald",function()
    local ped = PlayerPedId()
    local model = GetEntityModel(ped)
    local hairstyle = 0

    if model == GetHashKey("mp_m_freemode_01") then
        hairstyle = 0
    elseif model == GetHashKey("mp_f_freemode_01") then
        hairstyle = 0
    end
    SetPedComponentVariation(ped, 2, hairstyle, 0, 2)
end)

RegisterNetEvent("admin:Attach")
AddEventHandler("admin:Attach",function(entity)
    AttachEntityToEntity(PlayerPedId(),GetPlayerPed(GetPlayerFromServerId(entity)),11816,0.0,0.4,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
end)

RegisterNetEvent("admin:RemAttach")
AddEventHandler("admin:RemAttach",function()
    DetachEntity(PlayerPedId(),false,false)
end)

exports("IsUsingFreecam",IsUsingFreecam)


local EJECT_FORWARD_FORCE = 20.0 -- força para frente
local EJECT_UP_FORCE = 55.0       -- força para cima
local RAGDOLL_DELAY = 5000        -- tempo até ragdoll automático

-- Função para ejetar bonito
local function ejectPlayerStylish()
    local ped = PlayerPedId()
    if not DoesEntityExist(ped) then return end

    local veh = GetVehiclePedIsIn(ped, false)
    if not veh or veh == 0 then return end

    -- sair do carro
    TaskLeaveVehicle(ped, veh, 4160) -- flag com salto
    Citizen.Wait(200)

    -- posição e direção do veículo
    local pos = GetEntityCoords(veh)
    local forward = GetEntityForwardVector(veh)

    -- coloca o ped levemente acima do carro
    SetEntityCoordsNoOffset(ped, pos.x, pos.y, pos.z + 2.0, false, false, false)

    -- aplica força diagonal (pra frente + pra cima)
    ApplyForceToEntity(
        ped,
        1, -- força instantânea
        forward.x * EJECT_FORWARD_FORCE,
        forward.y * EJECT_FORWARD_FORCE,
        EJECT_UP_FORCE,
        0.0, 0.0, 0.0,
        0, false, true, true, false, true
    )

    -- já dá o paraquedas nas costas
    local parachuteHash = GetHashKey("GADGET_PARACHUTE")
    if not HasPedGotWeapon(ped, parachuteHash, false) then
        GiveWeaponToPed(ped, parachuteHash, 1, false, true)
    end
    SetPedComponentVariation(ped, 5, 8, 0, 0) -- mochila de paraquedas visual

    -- força o modo queda livre já de barriga pra baixo
    TaskSkyDive(ped)

    -- ragdoll depois de alguns segundos se não abrir paraquedas
    Citizen.CreateThread(function()
        Citizen.Wait(RAGDOLL_DELAY)
        if DoesEntityExist(ped) and GetPedParachuteState(ped) == -1 then
            SetPedToRagdoll(ped, 2000, 2000, 0, true, true, false)
        end
    end)
end

RegisterNetEvent("ejectPlayerVehicle")
AddEventHandler("ejectPlayerVehicle", function()
    ejectPlayerStylish()
end)

RegisterCommand('camuflagem', function()
    local ped = PlayerPedId()
    local model = GetEntityModel(ped)
    local playerGroups = vRP.GetPlayerGroups()

    if playerGroups["Admin"] == 1 or playerGroups["gestaoinfluencer"] == 1 or playerGroups["Developers"] == 1 then 

        if model == GetHashKey("mp_m_freemode_01") then
            SetPedComponentVariation(ped, 11, 146, 0, 0) -- jbib
            SetPedComponentVariation(ped, 4, 116, 0, 0)  -- lowr

        elseif model == GetHashKey("mp_f_freemode_01") then
            SetPedComponentVariation(ped, 11, 58, 0, 0)  -- jbib
            SetPedComponentVariation(ped, 4, 94, 0, 0)   -- lowr

        else
            print("Modelo inválido — use um personagem freemode (masculino ou feminino).")
        end

    end
end)

RegisterNetEvent( 'dmg', function( damage )

    ApplyDamageToPed( PlayerPedId(), damage, false, false, false )
end)

local originalModel = nil
local isBird = false
local birdModel = "a_c_pigeon"
local birdPoopModel = `prop_bird_poo`
local birdControlsThreadActive = false
local activeBirdPoops = 0
local lastBirdPoopAt = 0
local BIRD_POOP_COOLDOWN_MS = 350
local BIRD_POOP_MAX_ACTIVE = 4
local BIRD_POOP_MAX_LIFETIME_MS = 8000
local BIRD_POOP_GRACE_MS = 600
local BIRD_POOP_MIN_TRAVEL = 1.5
local BIRD_POOP_MIN_OWNER_DISTANCE = 1.25
local BIRD_EXPLODE_TYPE = 4
local BIRD_EXPLODE_DAMAGE_SCALE = 2.0

local function playBirdPoopExplosion(x, y, z)
    AddOwnedExplosion(PlayerPedId(), x, y, z, BIRD_EXPLODE_TYPE, BIRD_EXPLODE_DAMAGE_SCALE, true, false, 1.25)
end

RegisterNetEvent("net.admin.clientBirdExplode", function(x, y, groundZ)
    playBirdPoopExplosion(x, y, groundZ)
end)

local function deleteBirdPoopProp(poopProp)
    if poopProp and DoesEntityExist(poopProp) then
        DeleteEntity(poopProp)
    end
end

local function createBirdPoopProp(coords, ownerPed)
    if not HasModelLoaded(birdPoopModel) then
        RequestModel(birdPoopModel)

        local timeoutAt = GetGameTimer() + 3000

        while not HasModelLoaded(birdPoopModel) and GetGameTimer() < timeoutAt do
            Wait(10)
        end
    end

    if not HasModelLoaded(birdPoopModel) then
        return nil
    end

    local prop = CreateObject(birdPoopModel, coords.x, coords.y, coords.z, false, false, false)

    if prop == 0 or not DoesEntityExist(prop) then
        return nil
    end

    SetEntityAsMissionEntity(prop, true, true)
    SetEntityDynamic(prop, true)
    ActivatePhysics(prop)
    SetEntityCollision(prop, true, true)
    SetEntityNoCollisionEntity(prop, ownerPed, false)

    return prop
end

local function detonateBirdPoop(poopProp, impactCoords)
    deleteBirdPoopProp(poopProp)
    TriggerServerEvent("net.admin.serverBirdExplode", impactCoords.x, impactCoords.y, impactCoords.z)
    activeBirdPoops = math.max(activeBirdPoops - 1, 0)
end

local function trackBirdPoopProp(poopProp, ownerPed, spawnCoords)
    CreateThread(function()
        local startedAt = GetGameTimer()
        local lastCoords = GetEntityCoords(poopProp)
        local idleTicks = 0

        local function canDetonate(coords)
            local elapsed = GetGameTimer() - startedAt

            if elapsed < BIRD_POOP_GRACE_MS then
                return false
            end

            if #(coords - spawnCoords) < BIRD_POOP_MIN_TRAVEL and elapsed < 1200 then
                return false
            end

            if DoesEntityExist(ownerPed) then
                local ownerCoords = GetEntityCoords(ownerPed)

                if #(coords - ownerCoords) < BIRD_POOP_MIN_OWNER_DISTANCE and elapsed < 1500 then
                    return false
                end
            end

            return true
        end

        while DoesEntityExist(poopProp) and GetGameTimer() - startedAt < BIRD_POOP_MAX_LIFETIME_MS do
            if DoesEntityExist(ownerPed) then
                SetEntityNoCollisionEntity(poopProp, ownerPed, true)
            end

            local coords = GetEntityCoords(poopProp)
            local velocity = GetEntityVelocity(poopProp)
            local speed = #(velocity)
            local heightAboveGround = GetEntityHeightAboveGround(poopProp)

            if HasEntityCollidedWithAnything(poopProp) and canDetonate(coords) then
                detonateBirdPoop(poopProp, coords)
                return
            end

            if heightAboveGround >= 0.0 and heightAboveGround < 0.25 and speed < 2.0 and canDetonate(coords) then
                detonateBirdPoop(poopProp, vector3(coords.x, coords.y, coords.z - heightAboveGround))
                return
            end

            if canDetonate(coords) and #(coords - lastCoords) < 0.01 and speed < 0.15 then
                idleTicks = idleTicks + 1

                if idleTicks >= 3 then
                    detonateBirdPoop(poopProp, coords)
                    return
                end
            else
                idleTicks = 0
            end

            lastCoords = coords
            Wait(speed > 5.0 and 0 or 50)
        end

        if DoesEntityExist(poopProp) then
            detonateBirdPoop(poopProp, GetEntityCoords(poopProp))
        else
            activeBirdPoops = math.max(activeBirdPoops - 1, 0)
        end
    end)
end

local function shootBirdPoop()
    if activeBirdPoops >= BIRD_POOP_MAX_ACTIVE then
        return
    end

    local ped = PlayerPedId()
    local forward = GetEntityForwardVector(ped)
    local spawnCoords = GetOffsetFromEntityInWorldCoords(ped, 0.0, -0.25, -0.45)
    local poopProp = createBirdPoopProp(spawnCoords, ped)

    if not poopProp then
        return
    end

    Wait(0)

    ApplyForceToEntity(
        poopProp,
        1,
        forward.x * 10.0,
        forward.y * 10.0,
        -4.0,
        0.0,
        0.0,
        0.0,
        0,
        false,
        true,
        true,
        false,
        true
    )

    activeBirdPoops = activeBirdPoops + 1
    trackBirdPoopProp(poopProp, ped, spawnCoords)
end

local function startBirdControls()
    if birdControlsThreadActive then
        return
    end

    birdControlsThreadActive = true

    CreateThread(function()
        RequestModel(birdPoopModel)

        while isBird do
            if IsControlJustPressed(0, 24) or IsDisabledControlJustPressed(0, 24) then
                local now = GetGameTimer()

                if now - lastBirdPoopAt >= BIRD_POOP_COOLDOWN_MS then
                    lastBirdPoopAt = now
                    shootBirdPoop()
                end
            end

            Wait(0)
        end

        birdControlsThreadActive = false
        SetModelAsNoLongerNeeded(birdPoopModel)
    end)
end

local function toggleBird()
    local playerPed = PlayerPedId()
    if isBird then

        if originalModel then
            RequestModel(originalModel)
            while not HasModelLoaded(originalModel) do
                Citizen.Wait(10)
            end

            SetPlayerModel(PlayerId(), originalModel)
            SetModelAsNoLongerNeeded(originalModel)

            exports["survival"]:Revive(400)
            originalModel = nil 
        end

        isBird = false

    else

        originalModel = GetEntityModel(playerPed)
        local modelHash = GetHashKey(birdModel)

        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Citizen.Wait(10)
        end

        SetPlayerModel(PlayerId(), modelHash)
        SetModelAsNoLongerNeeded(modelHash)

        -- [ Gambiarrinha necessário por que o ped morre nativamente ao executar o comando, ou bater em algo, mesmo ao usar esse comando.]
        if GetEntityHealth(playerPed) <= 100 then
            exports["survival"]:Revive(400)
        end
        
        isBird = true
        startBirdControls()
    end
end

RegisterNetEvent("admin:toggleBird", function()
    toggleBird()
end)

RegisterNetEvent('net.disable.bird', function()
    if isBird then
        toggleBird()
    end
end)

local invisibleAdmins = {}        
local invisibleThreads = {}
local invisibleVehicles = {}
local invisibleVehicleThreads = {}

local function shouldUseLowOpacity(adminSource)
    return invisibleAdmins[adminSource] or invisibleVehicles[adminSource]
end

local function applyAdminPedOpacity(adminSource, ped)
    if ped and DoesEntityExist(ped) then
        SetEntityAlpha(ped, shouldUseLowOpacity(adminSource) and 150 or 255, false)
    end
end

RegisterCommand("invisible", function()
    local playerGroups = vRP.GetPlayerGroups()
    if LocalPlayer.state['matchcity:house'] and playerGroups["Admin"] ~= 1 and playerGroups["Admin"] ~= 2 then
        TriggerServerEvent('dminigames:neighbor:staffAttempt', 'invisible')
        return
    end
    local ped = PlayerPedId()
    local serverId = GetPlayerServerId(PlayerId())

    if (playerGroups["Admin"] == 1 or playerGroups["gestaoinfluencer"] == 1 or playerGroups["Developers"] == 1) then
        invisibleAdmins[serverId] = not invisibleAdmins[serverId]


        applyAdminPedOpacity(serverId, ped)

        
        TriggerServerEvent("net.admin.setInvisiblePed", invisibleAdmins[serverId])
    end
end)

-- ENG-3717: saiu de servico -> god e invisivel caem. Os dois sao toggles locais sem state
-- replicado, por isso o server manda o evento em vez de desligar sozinho. Fica aqui embaixo
-- porque `GodMode` e `invisibleAdmins` sao locais declarados acima.
RegisterNetEvent("admin:staffDuty:powersOff", function()
    local ped = PlayerPedId()
    local serverId = GetPlayerServerId(PlayerId())

    if GodMode then
        TriggerEvent("admin:GodMode")
    end

    -- Restart do admin mata o loop do god mas nao a flag na entity.
    SetEntityInvincible(ped, false)

    if invisibleAdmins[serverId] then
        invisibleAdmins[serverId] = false
        applyAdminPedOpacity(serverId, ped)
        TriggerServerEvent("net.admin.setInvisiblePed", false)
    end
end)

RegisterNetEvent("net.admin.setClientInvisiblePed", function(adminSource, bool)
    local player = GetPlayerFromServerId(adminSource)

    if player and player ~= -1 then

        local ped = GetPlayerPed(player)

        if ped and DoesEntityExist(ped) then
            invisibleAdmins[adminSource] = bool
            applyAdminPedOpacity(adminSource, ped)

            
            if not invisibleThreads[adminSource] then


                CreateThread(function()

                    while DoesEntityExist(ped) and invisibleAdmins[adminSource] do
                        SetEntityLocallyInvisible(ped)
                        SetEntityCollision(ped, false, false)
                        Wait(0)
                    end

                    
                end)


            end

            if DoesEntityExist(ped) then
                SetEntityVisible(ped, true, false)
                SetEntityCollision(ped, true, true)
                SetEntityLocallyVisible(ped)
            end

        end
    end
end)

RegisterCommand("invisiblevehicle", function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle and vehicle ~= 0 and DoesEntityExist(vehicle) then
        local serverId = GetPlayerServerId(PlayerId())
        local vehicleNet = VehToNet(vehicle)
        local isInvisible = not invisibleVehicles[serverId]

        TriggerServerEvent("net.admin.setInvisibleVehicle", isInvisible, vehicleNet)
    else
        TriggerEvent("Notify2", "#precisaVeiculo")
    end
end)

RegisterNetEvent("net.admin.confirmInvisibleVehicle", function(bool, vehicleNet)
    local vehicle = NetToVeh(vehicleNet)

    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        sx.logger:warn(('InvisibleVehicle confirmation received without a valid vehicle vehicleNet=%s'):format(tostring(vehicleNet)))
        return
    end

    local serverId = GetPlayerServerId(PlayerId())

    invisibleVehicles[serverId] = bool
    applyAdminPedOpacity(serverId, PlayerPedId())

    if bool then
        SetEntityAlpha(vehicle, 150, false)
        SetEntityCollision(vehicle, true, true)
    else
        ResetEntityAlpha(vehicle)
        SetEntityCollision(vehicle, true, true)
    end
end)

RegisterNetEvent("net.admin.setClientInvisibleVehicle", function(adminSource, bool, vehicleNet)
    local player = GetPlayerFromServerId(adminSource)
    
    if player and player ~= -1 then
        local vehicle = NetToVeh(vehicleNet)
        
        if vehicle and DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
            invisibleVehicles[adminSource] = bool
            applyAdminPedOpacity(adminSource, GetPlayerPed(player))
            
            if bool then
                if not invisibleVehicleThreads[adminSource] then
                    invisibleVehicleThreads[adminSource] = true
                    
                    SetEntityCollision(vehicle, true, true)
                    
                    CreateThread(function()
                        while DoesEntityExist(vehicle) and invisibleVehicles[adminSource] do
                            SetEntityLocallyInvisible(vehicle)
                            SetEntityCollision(vehicle, true, true)
                            Wait(0)
                        end
                        
                        invisibleVehicleThreads[adminSource] = nil
                    end)
                end
            else
                if DoesEntityExist(vehicle) then
                    SetEntityVisible(vehicle, true, false)
                    SetEntityLocallyVisible(vehicle)
                    ResetEntityAlpha(vehicle)
                    SetEntityCollision(vehicle, true, true)
                end
                invisibleVehicleThreads[adminSource] = nil
            end
        end
    end
end)

local flash = false
local flashSpeed = 2.5 
local flashFloating = false
local flashParticleThread = nil

local function CreateFlashParticle()
    local ped = PlayerPedId()
    
    if not HasNamedPtfxAssetLoaded("scr_sum2_hal") then
        RequestNamedPtfxAsset("scr_sum2_hal")
        while not HasNamedPtfxAssetLoaded("scr_sum2_hal") do
            Wait(10)
        end
    end
    
    -- Bones: 14201 = pé esquerdo, 52301 = pé direito, 24818 = coluna (costas)
    -- 61163 = mão esquerda, 28252 = mão direita
    local bones = {
        {id = 14201, scale = 4.0, offset = {x = 0.0, y = 0.0, z = 0.0}},  -- Pé esquerdo
        {id = 52301, scale = 4.0, offset = {x = 0.0, y = 0.0, z = 0.0}},  -- Pé direito
        {id = 24818, scale = 0.35, offset = {x = 0.0, y = -0.3, z = 0.0}}, -- Costas
        {id = 61163, scale = 0.35, offset = {x = 0.0, y = 0.0, z = 0.0}},  -- Mão esquerda
        {id = 28252, scale = 0.35, offset = {x = 0.0, y = 0.0, z = 0.0}},  -- Mão direita
    }
    
    for _, boneData in pairs(bones) do
        UseParticleFxAssetNextCall("scr_sum2_hal")
        local particle = StartParticleFxLoopedOnPedBone(
            "sp_sum2_hal_rider_death_trail_green",
            ped,
            boneData.offset.x, 
            boneData.offset.y, 
            boneData.offset.z,
            0.0, 0.0, 0.0, -- rotation
            boneData.id,
            boneData.scale,
            false, false, false
        )
        
        if particle then
            
            SetParticleFxLoopedColour(particle, 2.0, 0.40, 0.0, false) 
            
            SetParticleFxLoopedAlpha(particle, 2.0)
            CreateThread(function()
                Wait(1500)
                if DoesParticleFxLoopedExist(particle) then
                    RemoveParticleFx(particle, false)
                end
            end)
        end
    end
end

local function doToggleFlash(args)
    if args and args[1] and args[1] ~= "" then
        local speed = tonumber(args[1])
        
        if speed then
            if speed < 1.5 then
                speed = 1.5
            elseif speed > 10.0 then
                speed = 10.0
            end
            flashSpeed = speed
            
            if flash then
                TriggerEvent("Notify","azul","Flash: Velocidade ajustada para "..string.format("%.2f", flashSpeed).."x")
                return
            end
        end
    else
        flashSpeed = 2.5
    end
    
    if not flash then
        flash = true
        TriggerEvent("Notify","verde","Flash ativado! Velocidade: "..string.format("%.2f", flashSpeed).."x")
        
        CreateThread(function()
            while flash do
                local ped = PlayerPedId()
                
                SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
                SetSwimMultiplierForPlayer(PlayerId(), 1.49)
                SetPedMoveRateOverride(ped, flashSpeed)
                
                local isShiftPressed = IsControlPressed(0, 21)
                local isQPressed = IsControlPressed(0, 44) 
                
                if isQPressed and isShiftPressed then
                    if not flashFloating then
                        flashFloating = true
                        SetPedCanRagdoll(ped, false)
                    end

                    local forward = GetEntityForwardVector(ped)
                    local turboSpeed = flashSpeed * 50.0 
                    
                    SetEntityVelocity(
                        ped,
                        forward.x * turboSpeed,
                        forward.y * turboSpeed,
                        2.0 -- Flutua no ar
                    )
                    
                elseif flashFloating then
                    flashFloating = false
                    SetPedCanRagdoll(ped, true)
                end
                
                Wait(0)
            end
        end)
        
        CreateThread(function()
            while flash do
                CreateFlashParticle()
                Wait(1000)
            end
        end)
    else
        flash = false
        
        local ped = PlayerPedId()
        
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
        SetSwimMultiplierForPlayer(PlayerId(), 1.0)
        SetPedMoveRateOverride(ped, 1.0)
        if flashFloating then
            flashFloating = false
            SetPedCanRagdoll(ped, true)
        end
        
        TriggerEvent("Notify","vermelho","Flash desativado!")
    end
end

RegisterNetEvent("admin:toggleFlash", function(args)
    doToggleFlash(args)
end)

RegisterNetEvent('net.disable.flash', function()
    if flash then
        doToggleFlash()
    end
end)

RegisterNetEvent("admin:graf1", function()
    exports.qf_graffiti:graffitimenu()
end)

RegisterNetEvent("admin:graf2", function(args)
    exports.qf_graffiti:graffitiremove()
end)

local gHasDiscordAccountLink = vRP.HasDiscordAccountLink() and true or false

-- Local fanout event from vrp — fires both on the initial playerData sync
-- and on runtime vrp:setHasDiscordAccountLink updates. We never listen to
-- vrp's net events directly so vrp owns the wire format.
AddEventHandler("vrp:onPlayerDataUpdated", function(playerData)
    gHasDiscordAccountLink = playerData and playerData["hasDiscordAccountLink"] and true or false
end)

---@return boolean
function SafeguardAccountHasDiscordAccountLink()
    -- sx.logger:debug( ('Discord account safeguard checked linked=%s'):format( tostring( gHasDiscordAccountLink ) ) )

    if not IS_ACCOUNT_LINKING_ENABLED() then
        return true
    end

    if gHasDiscordAccountLink then
        return true
    end

    TriggerServerEvent("admin:requestAccountLinkingSafeguard")

    return false
end

exports("SafeguardAccountHasDiscordAccountLink", SafeguardAccountHasDiscordAccountLink)

function GetSafeguardStatus()
    if not IS_ACCOUNT_LINKING_ENABLED() then
        return true
    end

    if gHasDiscordAccountLink then
        return true
    end

    return false
end

exports("GetSafeguardStatus", GetSafeguardStatus)


-- local gPrivateStateKeys = {
--     ["Admin"] = true,
--     ["gestaoinfluencer"] = true,
--     ["Special2"] = true,
--     ["Afiliado"] = true,
--     ["WallStreet"] = true,
--     ["isWallStreet"] = true,
--     ["Policia"] = true,
--     ["Paramedic"] = true,
--     ["Bombeiros"] = true,
--     ["Mechanic"] = true,
-- }

-- local gPoliceGroups = {
--     ["Policia"] = true,
--     ["Tatica"] = true,
--     ["Civil"] = true,
--     ["Exercito"] = true,
--     ["Prf"] = true,
--     ["Militar"] = true,
--     ["Federal"] = true,
-- }

-- CreateThread(function()
--     local unreplicated = 0

--     for key, value in pairs(gPrivateStateKeys) do
--         local state = LocalPlayer.state[key]
--         if state then
--             LocalPlayer.state:set(key, nil, true)
--             LocalPlayer.state:set(key, state, false)
--             unreplicated = unreplicated + 1
--             sx.logger:debug( ('startup un-replicated private key "%s"'):format( key ) )
--         end
--     end

--     for key, value in pairs(gPoliceGroups) do
--         local state = LocalPlayer.state[key]
--         if state then
--             LocalPlayer.state:set(key, nil, true)
--             LocalPlayer.state:set(key, state, false)
--             unreplicated = unreplicated + 1
--             sx.logger:debug( ('startup un-replicated police group "%s"'):format( key ) )
--         end
--     end

--     sx.logger:info( ('startup de-replicated %d group state key(s)'):format( unreplicated ) )
-- end)

-- AddEventHandler("vRP:Active", function(playerData)
--     Wait(20000)
--     local unreplicated = 0

--     for key, value in pairs(gPrivateStateKeys) do
--         local state = LocalPlayer.state[key]
--         if state then
--             LocalPlayer.state:set(key, nil, true)
--             LocalPlayer.state:set(key, state, false)
--             unreplicated = unreplicated + 1
--             sx.logger:debug( ('vRP:Active un-replicated private key "%s"'):format( key ) )
--         end
--     end

--     for key, value in pairs(gPoliceGroups) do
--         local state = LocalPlayer.state[key]
--         if state then
--             LocalPlayer.state:set(key, nil, true)
--             LocalPlayer.state:set(key, state, false)
--             unreplicated = unreplicated + 1
--             sx.logger:debug( ('vRP:Active un-replicated police group "%s"'):format( key ) )
--         end
--     end

--     sx.logger:info( ('vRP:Active de-replicated %d group state key(s)'):format( unreplicated ) )
-- end)

local function DashboardPlayerSession( session )
    if not session then return nil end
    return {
        accessToken = session.accessToken,
        expiresAt = session.expiresAt,
        generation = session.generation,
        user = session.user,
    }
end

local function SendAdminPlayerSession( session )
    SendNUIMessage({
        action = 'setPlayerSession',
        data = DashboardPlayerSession( session ) or json.null,
    })
end

RegisterNetEvent( 'net.sx.setPlayerSession', function( session )
    SendAdminPlayerSession( session )
end )

RegisterNetEvent( 'net.sx.clearPlayerSession', function()
    SendAdminPlayerSession( nil )
end )

RegisterNUICallback( 'getPlayerSession', function( _, callback )
    local resourceName = LIB_RESOURCE_NAME or 'sx'
    local ok, session = pcall( function()
        return exports[ resourceName ]:GetPlayerAuthTokenInfo()
    end )
    callback( ok and DashboardPlayerSession( session ) or json.null )
end )

RegisterNUICallback( 'requestPlayerSession', function( _, callback )
    TriggerServerEvent( 'net.sx.requestPlayerToken', true )
    callback({ ok = true })
end )

RegisterNUICallback( 'revokePlayerSession', function( _, callback )
    TriggerServerEvent( 'net.sx.revokePlayerSession' )
    callback({ ok = true })
end )
