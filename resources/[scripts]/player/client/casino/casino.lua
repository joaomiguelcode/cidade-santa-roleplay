Config = {
    CustomPlate = true,
    Plate = "STAR",
    LockVehicles = "NoInteract",
    FuelSystem = "none",
    FuelLevel = "0",
    MaxDistance = 80.0,
    Freeze = true,
    Shadow = true,

    ShowroomVehicles = {
        {
            Model = "nero2",
            Colors = { 44 },
            Livery = 0,
            Extra = { 1,2 },
            Coords = vector4(-3663.36, 2754.67, 36.37, 0.0),
        },
    },
}

Elevators = {
    {
        name = "Star Club 1",
        floors = {
           { label = "Helipontos", coords = vector3(-3672.39, 2796.31, 63.09) },
		   { label = "Boate", coords = vector3(-3634.78, 2726.78, 45.62) },
           { label = "Cassino", coords = vector3(-3649.37, 2725.58, 36.26) },
           { label = "Terreo", coords = vector3(-3644.83, 2738.45, 18.06) },
        },
        marker = { type = 1, size = 0.8, color = { r = 0, g = 150, b = 255 } }
    },
    {
        name = "Star Club 2",
        floors = {
           { label = "Helipontos", coords = vector3(-3668.8, 2790.02, 63.09) },
		   { label = "Boate", coords = vector3(-3641.41, 2728.83, 45.62) },
           { label = "Cassino", coords = vector3(-3653.11, 2731.71, 36.26) },
           { label = "Terreo", coords = vector3(-3648.47, 2744.5, 18.06) },
        },
        marker = { type = 1, size = 0.8, color = { r = 0, g = 150, b = 255 } }
    },    
	{
        name = "Star Club 3",
        floors = {
           { label = "Helipontos", coords = vector3(-3683.44, 2770.94, 63.09) },
		   { label = "Boate", coords = vector3(-3623.66, 2751.79, 45.62) },
           { label = "Cassino", coords = vector3(-3638.33, 2750.6, 36.26) },
           { label = "Terreo", coords = vector3(-3633.71, 2763.29, 18.06) },
        },
        marker = { type = 1, size = 0.8, color = { r = 0, g = 150, b = 255 } }
    },
	{
        name = "Star Club 4",
        floors = {
           { label = "Helipontos", coords = vector3(-3690.04, 2773.27, 63.09) },
		   { label = "Boate", coords = vector3(-3620.19, 2745.77, 45.62) },
           { label = "Cassino", coords = vector3(-3631.42, 2748.78, 36.26) },
           { label = "Terreo", coords = vector3(-3626.98, 2761.65, 18.06) },
        },
        marker = { type = 1, size = 0.8, color = { r = 0, g = 150, b = 255 } }
    }
}

if cityName == "Malta" then
    table.insert(Elevators, {
        name = "Star Club 5",
        floors = {
            { label = "Térreo", coords = vector3(-3787.42,263.66,22.81) },
            { label = "Garagem", coords = vector3(-3787.5,293.78,16.36) },
            { label = "Cobertura", coords = vector3(-3795.83,284.79,155.54) },
        },
        marker = { type = 1, size = 0.8, color = { r = 0, g = 150, b = 255 } }
    })
end

Config.RotateVehicles = true                     -- true/false para rotacionar todos
Config.RotateSpeed    = 6.0                      -- graus por segundo (valor baixo = mais lento)

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local LockVehicle = Config["LockVehicles"] == "Unlocked" and 1 or Config["LockVehicles"] == "Locked" and 2 or Config["LockVehicles"] == "NoInteract" and 3 or false
local UseFuel = Config["FuelSystem"] ~= "none"
local FuelExport = UseFuel and Config["FuelSystem"] or nil
local FuelLevel = UseFuel and Config["FuelLevel"] or "0"

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD (SPAWN / DESPAWN)
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)

        for Number,Vehicle in pairs(Config.ShowroomVehicles) do
            local Distance = #(Vehicle["Coords"]["xyz"] - Coords)

            if Vehicle["Entity"] and DoesEntityExist(Vehicle["Entity"]) and Distance >= Config["MaxDistance"] then
                DeleteEntity(Vehicle["Entity"])
                Config.ShowroomVehicles[Number]["Entity"] = nil
            end

            if Distance <= Config["MaxDistance"] and not Vehicle["Entity"] then
                if not LoadModel(Vehicle["Model"]) then
                    Config.ShowroomVehicles[Number] = nil -- Stop consume on loop
                    return 
                end

                Vehicle["Entity"] = CreateVehicle(Vehicle["Model"],Vehicle["Coords"],false,false)
                SetVehicleOnGroundProperly(Vehicle["Entity"])
                SetEntityInvincible(Vehicle["Entity"], true)
                SetVehicleDirtLevel(Vehicle["Entity"], 0.0)

                if Vehicle["Colors"] then
                    SetVehicleColours(Vehicle["Entity"], Vehicle["Colors"][1], Vehicle["Colors"][2])
                end

                if LockVehicle then
                    SetVehicleDoorsLocked(Vehicle["Entity"], LockVehicle)
                end

                if Config["Freeze"] then
                    FreezeEntityPosition(Vehicle["Entity"], true)
                end

                if Config["CustomPlate"] then
                    SetVehicleNumberPlateText(Vehicle["Entity"], Config["Plate"])
                end

                if UseFuel then
                    exports[FuelExport]:SetFuel(Vehicle["Entity"], FuelLevel)
                end

                if Vehicle["Livery"] then
                    if GetNumVehicleMods(Vehicle["Entity"], 48) == 0 and GetVehicleLiveryCount(Vehicle["Entity"]) ~= 0 then
                        SetVehicleLivery(Vehicle["Entity"], Vehicle["Livery"])
                        SetVehicleMod(Vehicle["Entity"], 48, -1, false)
                    else
                        SetVehicleMod(Vehicle["Entity"], 48, (Vehicle["Livery"] - 1), false)
                        SetVehicleLivery(Vehicle["Entity"], -1)
                    end
                end

                if Vehicle["Extra"] then
                    for Index,Extra in pairs(Vehicle["Extra"]) do
                        SetVehicleExtra(Vehicle["Entity"],Extra,0)
                    end
                end

                if not Config["Shadow"] then
                    SetVehicleShadowEffect(Vehicle["Entity"], Config["Shadow"])
                end

                -- Armazena um heading inicial, se quiser usar depois (opcional)
                Vehicle.__baseHeading = GetEntityHeading(Vehicle["Entity"])
            end
        end

        Wait(8000)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD (ROTAÇÃO LENTA DOS VEÍCULOS)
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local dt = GetFrameTime() -- segundos por frame
        -- Atualiza todo frame para rotação suave
        for _, Vehicle in pairs(Config.ShowroomVehicles) do
            local ent = Vehicle["Entity"]
            if ent and DoesEntityExist(ent) then
                -- Checa se deve rotacionar: por veículo ou global
                local rotateFlag = Vehicle["Rotate"]
                if rotateFlag == nil then
                    rotateFlag = Config.RotateVehicles
                end

                if rotateFlag then
                    -- Velocidade: por veículo ou global (graus/segundo)
                    local speed = tonumber(Vehicle["RotateSpeed"]) or tonumber(Config.RotateSpeed) or 0.0
                    if speed > 0.0 then
                        local heading = GetEntityHeading(ent)
                        -- incrementa com base no tempo do frame
                        heading = heading + (speed * dt)
                        -- mantém dentro de 0..360
                        if heading >= 360.0 then heading = heading - 360.0 end
                        SetEntityHeading(ent, heading)
                    end
                end
            end
        end
        -- Wait 0 garante update por frame; se quiser economizar, mude para 1~5
        Wait(0)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADMODEL
-----------------------------------------------------------------------------------------------------------------------------------------
function LoadModel(Model)
    local Timeout = GetGameTimer() + 5000

    RequestModel(Model)
    while not HasModelLoaded(Model) and GetGameTimer() < Timeout do
        Wait(100)
    end

    return HasModelLoaded(Model)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ONRESOURCESTOP
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStop",function(Resource)
    if Resource == GetCurrentResourceName() then
        for Number,Vehicle in pairs(Config.ShowroomVehicles) do
            if Vehicle["Entity"] and DoesEntityExist(Vehicle["Entity"]) then
                DeleteEntity(Vehicle["Entity"])
                Config.ShowroomVehicles[Number]["Entity"] = nil
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONRESOURCESTOP
-----------------------------------------------------------------------------------------------------------------------------------------

local currentElevator = nil
local currentFloorIndex = nil
local lastNotifiedFloor = nil
local activeFx = {}

-----Machines cassino entity set on/off ------------
local state = false
local interior = GetInteriorAtCoordsWithType(-3665.918, 2756.838, 39.55107, "vertexgroup_lvi_cassino_mlo")

CreateThread(function()
    Wait(2500)
    while not interior do
        interior = GetInteriorAtCoordsWithType(-3665.918, 2756.838, 39.55107, "vertexgroup_lvi_cassino_mlo")
        Wait(2000)
    end
    EnableInteriorProp(interior, "lvi_machines")
    RefreshInterior(interior)
end)

-- RegisterCommand("lvicassino", function()
--     print(interior)
--     if interior == 0 then 
--         print("Interior not found")
--         return 
--     end

--     state = not state

--     if state then
--         EnableInteriorProp(interior, "lvi_machines")
--         print("Interior enabled")
--     else
--         DisableInteriorProp(interior, "lvi_machines")
--         print("Interior disabled")
--     end

--     RefreshInterior(interior)
-- end, false)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(_x, _y)
end

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local wait = 1000
        local foundFloor = false

        for _, elevator in pairs(Elevators) do
            for i, floor in ipairs(elevator.floors) do
                local dist = #(coords - floor.coords)

                if dist < 10.0 then
                    wait = 0
                    foundFloor = true

                    local mType = elevator.marker and elevator.marker.type or 1
                    local mSize = elevator.marker and elevator.marker.size or 1.0
                    local mColor = elevator.marker and elevator.marker.color or { r = 0, g = 150, b = 255 }

                    DrawMarker(mType, floor.coords.x, floor.coords.y, floor.coords.z - 1.0,
                        0.0, 0.0, 0.0, 0, 0, 0,
                        mSize, mSize, 0.5,
                        mColor.r, mColor.g, mColor.b, 150,
                        false, true, 2, false, nil, nil, false)
                end

                if dist < 1.5 then
                    -- Mostrar o nome do andar apenas se for diferente do último
                    if lastNotifiedFloor ~= floor.label then
                        lastNotifiedFloor = floor.label

                        lib.notify({
                            title = 'Elevador',
                            description = 'Andar Atual: ' .. floor.label,
                            type = 'inform'
                        })
                    end

                    DrawText3D(floor.coords.x, floor.coords.y, floor.coords.z + 0.5, "[E] Usar Elevador")

                    if IsControlJustReleased(0, 38) then
                        currentElevator = elevator
                        currentFloorIndex = i
                        OpenElevatorMenu(elevator, i)
                    end
                end
            end
        end

        if not foundFloor then
            lastNotifiedFloor = nil
        end

        Wait(wait)
    end
end)

function OpenElevatorMenu(elevator, currentIndex)
    local options = {}

    for i, floor in ipairs(elevator.floors) do
        if i ~= currentIndex then
            table.insert(options, {
                title = floor.label,
                description = "Ir para este andar",
                icon = "arrow-up",
                onSelect = function()
                    TeleportToFloor(floor.coords)
                end
            })
        end
    end

    lib.registerContext({
        id = 'elevator_menu',
        title = 'Elevador - ' .. elevator.name,
        options = options
    })

    lib.showContext('elevator_menu')
end

function TeleportToFloor(coords)
    DoScreenFadeOut(500)
    Wait(700)
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
    Wait(700)
    DoScreenFadeIn(500)
end

--------------------PARTICULAS----------------------
--[[
local particles = {
    { dict="scr_xs_celebration", name="scr_xs_money_rain", coords=vector3(-3076.43,2702.16,32.58), rot={x=0.0,y=90.0,z=20.0}, scale=8.0, colour={1.0,3.0,2.0} },
    { dict="scr_xs_celebration", name="scr_xs_money_rain", coords=vector3(-3073.81,2742.1,32.74), rot={x=0.0,y=90.0,z=-30.0}, scale=8.0, colour={1.0,3.0,2.0} },
    { dict="scr_xs_celebration", name="scr_xs_money_rain", coords=vector3(-3076.43,2702.16,32.58), rot={x=0.0,y=90.0,z=20.0}, scale=8.0, colour={1.0,3.0,2.0} },
    { dict="scr_xs_celebration", name="scr_xs_money_rain", coords=vector3(-3073.81,2742.1,32.74), rot={x=0.0,y=90.0,z=-30.0}, scale=8.0, colour={1.0,3.0,2.0} }
}

local activeFx, active = {}, false
local centerPos, distMax = vector3(-3069.68,2720.96,16.69), 200.0

local function startFx()
    active = true
    for i, fx in ipairs(particles) do
        RequestNamedPtfxAsset(fx.dict)
        while not HasNamedPtfxAssetLoaded(fx.dict) do Citizen.Wait(10) end
        UseParticleFxAssetNextCall(fx.dict)
        local h = StartParticleFxLoopedAtCoord(fx.name, fx.coords.x, fx.coords.y, fx.coords.z, fx.rot.x, fx.rot.y, fx.rot.z, fx.scale, false, false, false, false)
        activeFx[i] = h
        SetParticleFxLoopedColour(h, fx.colour[1], fx.colour[2], fx.colour[3], false)
        SetParticleFxLoopedRange(h, 50.0)
    end
end

local function stopFx()
    active = false
    for i, h in pairs(activeFx) do
        if h then StopParticleFxLooped(h, true) end
        activeFx[i] = nil
    end
end

Citizen.CreateThread(function()
    while true do
        local dist = #(GetEntityCoords(PlayerPedId()) - centerPos)
        if dist <= distMax and not active then startFx()
        elseif dist > distMax and active then stopFx() end
        Citizen.Wait(1000)
    end
end)

AddEventHandler("onResourceStop", function(res)
    if res == GetCurrentResourceName() then stopFx() end
end)
--]]