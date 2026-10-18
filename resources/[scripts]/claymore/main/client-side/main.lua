local resourceName = GetCurrentResourceName()

local Proxy = module('vrp', 'lib/Proxy')
local Tunnel = module('vrp', 'lib/Tunnel')
local api = {}
Tunnel.bindInterface(resourceName, api)

local apiServer = Tunnel.getInterface(resourceName)

local config = module(resourceName, 'shared/config')
local claymoreOnFloor = false 
local claymoreLastCoords = {}
local OnTableFloor = {}
local headingTable = {}
local numberOfClaymores, HighDiffPerTyre = 1, 0.35
LocalPlayer['state']['BlockButtons'] = false


CreateThread(function()
    
    while true do

        local idle = 1000

        Player:Set()
        
        if claymoreOnFloor then

            idle = 1
            
            local hit, hitCoords, entityHit = RayCastGamePlayCamera(7.0)
            
            if hit > 0 then

                local moveProps = false

                local entityHitType = GetEntityType(entityHit)
                
                if entityHitType == 3 then
                    
                    local entityHitHash = GetEntityModel(entityHit)
                    
                    if entityHitHash ~= TablePropHash then
                        
                        moveProps = true

                    end

                elseif entityHitType == 0 then

                    moveProps = true

                end

                if moveProps then
                    
                    -- DrawLine(Player.Coords.x, Player.Coords.y, Player.Coords.z, hitCoords.x, hitCoords.y, hitCoords.z, 0, 100, 0, 255)
    
                    for i = 1, #OnTableFloor, 1 do
                        
                        local tyre = OnTableFloor[i]
                        
                        if GetEntityAlpha(tyre) == 0 then
                            
                            SetEntityAlpha(tyre, 153, true)
                            
                        end

                        if claymoreLastCoords[i] and CheckNewHitCoords(claymoreLastCoords[i], hitCoords) then

                            local x, y, z = table.unpack(hitCoords)

                            local groundZ = z + 0.1
        
                            if i > 1 and claymoreLastCoords[i] then
                                
                                groundZ = claymoreLastCoords[i - 1].z + HighDiffPerTyre
        
                            end
                            
                            SetEntityCoords(tyre, x, y, groundZ, false, false, false, false)
    
                            FreezeEntityPosition(tyre, true)

                            claymoreLastCoords[i] = vec3(x, y, groundZ)
                
                        end
        
                    end

                end

            end

            if IsControlJustPressed(0, 38) then

                if claymoreLastCoords[1] then

                    exports.scripted_interactions:startScriptedInteraction( 'c4' )

                    CreateServerClaymore(claymoreLastCoords)

                end

            end
            
        end

        Wait(idle)

    end

end)


function CreateClayMoreOnFloor()

    local playerForwardCoords = Player.Coords + GetEntityForwardVector(Player.Ped)
    local pedHeading = GetEntityHeading(Player.Ped)

    local x, y, z = table.unpack(playerForwardCoords)

    z = z - 1

    for i = 1, numberOfClaymores, 1 do

        local obj = CreateObject(config.claymoreProp, x, y, z, false, false, false)

        table.insert(OnTableFloor, obj)
        
        SetEntityAlpha(obj, 0, true)

        SetEntityHeading(obj, pedHeading)

        SetEntityCollision(obj, false, false)

        z = z + HighDiffPerTyre

        claymoreLastCoords[i] = vec3(x, y, z)
    end

end

function CreateServerClaymore(TablesLastCoords)

    claymoreOnFloor = false
    
    headingTable = GetEntityHeading(OnTableFloor[1])
    DeleteEntity(OnTableFloor[1]) 
    
    if IsPedFarAwayFromBlockedAreas() then
        
        TriggerServerEvent("net.claymore.createClaymore", claymoreLastCoords, headingTable )
        
    else

        print('Muito perto da area bloqueada')

    end

    -- TablesLastCoords = {}

    headingTable = {}

    OnTableFloor = {}

end



function IsPedFarAwayFromBlockedAreas()
    
    for _, area in pairs(config.blockedAreas) do

        local distToBlockedArea = #(Player.Coords - area.Coords)

        if distToBlockedArea <= area.Radius then

            return false

        end

    end

    return true

end

function CheckNewHitCoords(tyreLastCoords, hitCoords)

    return tyreLastCoords.x ~= hitCoords.x and tyreLastCoords.y ~= hitCoords.y

end

function RayCastGamePlayCamera(distance)
    
    local cameraRotation = GetGameplayCamRot(0)
    
    local cameraCoord = GetGameplayCamCoord()
    
    local direction = RotationToDirection(cameraRotation)
    
    local destination = {
        
        x = cameraCoord.x + direction.x * distance,
        
        y = cameraCoord.y + direction.y * distance,
        
        z = cameraCoord.z + direction.z * distance

    }

    local retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
    
    return hit, endCoords, entityHit

end

function RotationToDirection(rotation)
	
    local adjustedRotation = { 
	
        x = (math.pi / 180) * rotation.x, 
	
        y = (math.pi / 180) * rotation.y, 
	
        z = (math.pi / 180) * rotation.z 
	}

	local direction = {
	
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
	
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
	
        z = math.sin(adjustedRotation.x)
	}

	return direction
end


RegisterNetEvent('net.claymore.initTableThread', function()
    
    if LocalPlayer['state']['BlockButtons'] then
        
        return false

    end

    if not claymoreOnFloor then

        if IsPedFarAwayFromBlockedAreas() then

            claymoreOnFloor = true

            CreateClayMoreOnFloor()
            
            return

        end

        
    end

end)


RegisterCommand('claymore', function()
    local playerGroups = vRP.GetPlayerGroups()
	local isAdmin = playerGroups["Admin"] == 1 or playerGroups["gestaoinfluencer"] == 1 or playerGroups["Developers"] == 1

    if isAdmin then 
        TriggerEvent('net.claymore.initTableThread')


    end
    
end)

RegisterCommand('deleteclaymore', function()
    local playerGroups = vRP.GetPlayerGroups()
    local isAdmin = playerGroups["Admin"] == 1 or playerGroups["gestaoinfluencer"] == 1 or playerGroups["Developers"] == 1

    if isAdmin then
        apiServer.deleteClaymore()
    end
end)

local gClaymoreMonitors = {}
local gClaymoreMonitorThreadRunning = false

local function DrawClaymoreLasers(entity)

    local entityHeading = GetEntityHeading(entity)
    local laserLength = config.detection.laserLength

    for _, line in pairs(config.detection.laserLines) do
        local offsetFromCenterRelativeToRotation = line[1]
        local lineRotationInDegrees = line[2]
        local lineStartPos = GetOffsetFromEntityInWorldCoords(entity, 0.45, offsetFromCenterRelativeToRotation, 0.150)
        local totalHeading = entityHeading + lineRotationInDegrees
        local headingRadians = math.rad(totalHeading)
        local dx = math.cos(headingRadians) * laserLength
        local dy = math.sin(headingRadians) * laserLength
        local lineEndPos = vector3(lineStartPos.x + dx, lineStartPos.y + dy, lineStartPos.z)

        DrawLine(lineStartPos.x, lineStartPos.y, lineStartPos.z, lineEndPos.x, lineEndPos.y, lineEndPos.z, 255, 0, 0, 255)
    end
end

local function GetClaymoreSensorOrigin(entity)

    return GetOffsetFromEntityInWorldCoords(entity, 0.45, 0.0, 0.150)
end

local function GetHorizontalDistance(fromCoords, toCoords)

    local offset = toCoords - fromCoords

    return math.sqrt((offset.x * offset.x) + (offset.y * offset.y))
end

local function NormalizeAngle(angle)

    while angle > 180.0 do
        angle = angle - 360.0
    end

    while angle < -180.0 do
        angle = angle + 360.0
    end

    return angle
end

local function IsPedInClaymoreDetectionZone(entity, pedCoords)

    local sensorOrigin = GetClaymoreSensorOrigin(entity)
    local offset = pedCoords - sensorOrigin
    local dist = math.sqrt((offset.x * offset.x) + (offset.y * offset.y))
    local maxRange = config.detection.range

    if dist > maxRange or dist < 0.01 then
        return false
    end

    local entityHeading = GetEntityHeading(entity)
    local pedAngle = math.deg(math.atan(offset.y, offset.x))
    local relativeAngle = NormalizeAngle(pedAngle - entityHeading)

    return math.abs(relativeAngle) <= config.detection.coneHalfAngle
end

local function RemoveClaymoreMonitor(netId)

    gClaymoreMonitors[netId] = nil
end

local function EnsureClaymoreMonitorThread()

    if gClaymoreMonitorThreadRunning then
        return
    end

    gClaymoreMonitorThreadRunning = true

    CreateThread(function()

        while next(gClaymoreMonitors) do
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            local myServerId = GetPlayerServerId(PlayerId())
            local tickMs = 500

            for netId, monitor in pairs(gClaymoreMonitors) do
                local entity = NetworkGetEntityFromNetworkId(netId)

                if not entity or entity == 0 or not DoesEntityExist(entity) then
                    RemoveClaymoreMonitor(netId)
                else
                    local claymoreState = Entity(entity).state.claymoreData

                    if not claymoreState or not claymoreState.active then
                        RemoveClaymoreMonitor(netId)
                    else
                        local dist2d = GetHorizontalDistance(GetEntityCoords(entity), pedCoords)

                        if dist2d < config.detection.visibleDistance then
                            DrawClaymoreLasers(entity)
                        end

                        if dist2d < config.detection.aggressivePollDistance then
                            tickMs = 0

                            if IsPedInClaymoreDetectionZone(entity, pedCoords) then
                                if myServerId ~= monitor.ownerSource or GetGameTimer() > monitor.safeUntil then
                                    TriggerServerEvent("net.claymore.explode", netId, monitor.ownerSource)
                                    RemoveClaymoreMonitor(netId)
                                end
                            end
                        elseif dist2d < config.detection.visibleDistance then
                            tickMs = math.min(tickMs, 50)
                        end
                    end
                end
            end

            Wait(tickMs)
        end

        gClaymoreMonitorThreadRunning = false
    end)
end

local function RegisterClaymoreMonitor(netId, ownerSource)

    if gClaymoreMonitors[netId] then
        return
    end

    gClaymoreMonitors[netId] = {
        ownerSource = ownerSource,
        safeUntil = GetGameTimer() + config.detection.ownerSafeMs,
    }

    EnsureClaymoreMonitorThread()
end

local function HandleClaymoreStateBag(bagName, value)

    if type(value) ~= "table" then
        return
    end

    if value.active == false then
        local entity = GetEntityFromStateBagName(bagName)

        if entity and DoesEntityExist(entity) then
            RemoveClaymoreMonitor(NetworkGetNetworkIdFromEntity(entity))
        end

        return
    end

    if not value.active or not value.netId or not value.owner then
        return
    end

    CreateThread(function()
        local tries = 0
        local entity = GetEntityFromStateBagName(bagName)

        while (not entity or entity == 0 or not DoesEntityExist(entity)) and tries < 50 do
            entity = NetworkGetEntityFromNetworkId(value.netId)
            Wait(200)
            tries = tries + 1
        end

        if not entity or not DoesEntityExist(entity) then
            return
        end

        SetEntityAsMissionEntity(entity, true, true)
        RegisterClaymoreMonitor(value.netId, value.owner)
    end)
end

AddStateBagChangeHandler("claymoreData", nil, function(bagName, key, value, reserved, replicated)
    HandleClaymoreStateBag(bagName, value)
end)

RegisterNetEvent("net.claymore.clientExplode", function(coords, owner)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local dist = #(playerCoords - vec3(coords.x, coords.y, coords.z))

    
    AddExplosion(coords.x, coords.y, coords.z, 29, 2.0, true, false, 1.0)
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if dist < 5.0 then
        ApplyDamageToPed(playerPed, math.floor((5.0 - dist) * 50), false)

        if vehicle ~= 0 then
            NetworkExplodeVehicle(vehicle, true, false, 0)
        end
    end
end)

RegisterCommand("closeInteraction", function()
    if claymoreOnFloor then 
        
        claymoreOnFloor = false

        DeleteEntity(OnTableFloor[1])
        
        OnTableFloor = {}
    end
end)

local leftPressed = false
RegisterCommand('+left', function()
    for i = 1, #OnTableFloor, 1 do
        if OnTableFloor and DoesEntityExist(OnTableFloor[i]) then
            leftPressed = true

            CreateThread(function()

                while leftPressed do
                    Wait(0)
                    local entityHeading = GetEntityHeading(OnTableFloor[i])
                    SetEntityHeading(OnTableFloor[i], entityHeading + 1)
                end

            end)
        end
    end
end)

RegisterCommand('-left', function()
    if leftPressed then
        leftPressed = false
    end
end)

local rightPressed = false
RegisterCommand('+right', function()
    for i = 1, #OnTableFloor, 1 do 
        if OnTableFloor and DoesEntityExist(OnTableFloor[i]) then
            rightPressed = true

            CreateThread(function()
                while rightPressed do
                    Wait(0)
                    local entityHeading = GetEntityHeading(OnTableFloor[i])
                    SetEntityHeading(OnTableFloor[i], entityHeading - 1)
                end
            end)
            
        end
    end
end)

RegisterCommand('-right', function()
    if rightPressed then
        rightPressed = false
    end
end)

RegisterKeyMapping("closeInteraction","Fechar Interaction","keyboard","F")
RegisterKeyMapping('+left', 'Movimentar o objeto', 'keyboard', 'pagedown')
RegisterKeyMapping('+right', 'Movimentar o objeto', 'keyboard', 'pageup')