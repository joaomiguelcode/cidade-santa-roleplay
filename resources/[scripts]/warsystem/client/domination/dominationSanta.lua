local OnCooldown = {}
local GoingDomination = {}
local DominationAreas = {}
local InsideDomination = false
local DominationSantaBlip = {}
local Stopped = true
CreateThread(function()
    if Stopped then
        return
    end
    while true do
        local Idle = 1500
        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)
        for i=1,#santaDomination do
            local Distance = #(Coords - santaDomination[i].Start)
            if Distance <= 50 then
                Idle = 0
                DrawMarker(42,santaDomination[i].Start.x, santaDomination[i].Start.y, santaDomination[i].Start.z,0,0,0,vec3(0.0, 0.0, 0.0),vec3(1.0, 1.0, 1.0),THEME.rgb.r, THEME.rgb.g, THEME.rgb.b, 100,false,false,2,true,nil,nil,false)
            end
            if Distance <= 1.5 then
                DrawText3D(santaDomination[i].Start.x, santaDomination[i].Start.y, santaDomination[i].Start.z, "~g~E~w~ - Capturar")
                if IsControlJustPressed(0, 38) then
                    TriggerServerEvent("santaDomination:RequestStart", i)
                end
            end
        end
        Wait(Idle)
    end
end)

RegisterNetEvent("dominationsanta:Finished")
AddEventHandler("dominationsanta:Finished",function(Number)
    InsideDomination = false
    local Area = DominationAreas[Number]
    Area:destroy()
    DominationAreas[Number] = nil
end)

CreateThread(function()
    if Stopped then
        return
    end
    while true do
        local Idle = 1500
        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)
        for Number,Area in pairs(DominationAreas) do
            if Area:isPointInside(Coords) then
                if not InsideDomination then
                    InsideDomination = true
                    TriggerServerEvent("santaDomination:EnteredZone",Number)
                end
            else
                if InsideDomination then
                    TriggerServerEvent("santaDomination:ExitZone",Number)
                end
                InsideDomination = false
            end
        end
        Wait(Idle)
    end
end)

CreateThread(function()
    if Stopped then
        return
    end
    while true do
        local Idle = 2500
        local Ped = PlayerPedId()
        if InsideDomination then
            Idle = 1
            local Health = GetEntityHealth(Ped)
            if Health <= 100 then
                TriggerServerEvent("dominationsanta:Exited",Number)
            end
        end
        Wait(Idle)
    end
end)

function IsInsideDomination()
    return InsideDomination
end
exports("IsInsideDomination",IsInsideDomination)

function UpdateBlips(BlipsData)
    for Number,Table in pairs(BlipsData) do
        if DominationSantaBlip[Number] then
            RemoveBlip(DominationSantaBlip[Number])
        end
        local Group = tostring(Table["Group"])
        local Blip = AddBlipForCoord(santaDomination[Number]["Start"])
        local Text = santaDomination[Number]["Name"]
        local BlipId = 438
        local Color = 2
        if Group ~= "false" then
            Text = Text .. " | " .. Group
            BlipId = 429
            Color = 1
        end
        SetBlipSprite(Blip, BlipId)
        SetBlipDisplay(Blip, 4)
        SetBlipScale(Blip, 0.8)
        SetBlipColour(Blip, Color)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Text)
        EndTextCommandSetBlipName(Blip)
        DominationSantaBlip[Number] = Blip
    end
end


RegisterNetEvent("dominationsanta:UpdateBlips")
AddEventHandler("dominationsanta:UpdateBlips",function(BlipsData)
    UpdateBlips(BlipsData)
end)

RegisterNetEvent("dominationsanta:Started")
AddEventHandler("dominationsanta:Started",function(Number)
    InsideDomination = false
    local Area = false
    local Ped = PlayerPedId()
    local DominationCoords = santaDomination[Number]["Coords"]
    local Coords = GetEntityCoords(Ped)
    local Radius = santaDomination[Number]["Radius"]
    local Options = santaDomination[Number]["Options"]
    Area = CircleZone:Create(DominationCoords, Radius,Options)
    DominationAreas[Number] = Area
end)

RegisterNetEvent("dominationsanta:updateBlips")
AddEventHandler("dominationsanta:updateBlips",function(BlipsData)
    local Ped = PlayerPedId()
    local Coords = GetEntityCoords(Ped)
    for i=1,#WinnersBlip do
        RemoveBlip(WinnersBlip[i])
    end
    WinnersBlip = {}
    for Blip2, BlipData in pairs(BlipsData) do
        local Blip = AddBlipForCoord(BlipData["Coords"],0.0)
        local Text = BlipData["Name"]
        SetBlipSprite(Blip,546)
        SetBlipDisplay(Blip,4)
        SetBlipAsShortRange(Blip,true)
        SetBlipColour(Blip,4)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Text)
        EndTextCommandSetBlipName(Blip)
        table.insert(WinnersBlip,Blip)
    end
end)