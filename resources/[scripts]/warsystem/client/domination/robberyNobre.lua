cityName = GetConvar("cityName", "")
local ROBBERY_SELECTED = false
local ROBBERY_NOBRE_BLIPS = {}
local ROBBERY_GOING = {}
local WARNING_DOM_CUSTOM = {
    background = "rgba(255,145,0)",
}
local GoingDomination = {
    ["CidadeNobre"] = true,
    ["Boomerang"] = true,
    ["Grande"] = true,
    ["Fronteira"] = true,
    ["Malta"] = true,
    ["Kingdom"] = true,
    ["Imperium"] = true,
    ["GoatRP"] = true,
    ["District99"] = true,
    ["Krown"] = true,
    ["Orizon"] = true,
    ["Royal"] = true,
    ["Real"] = true,
    ["Prime"] = true,
    ["Universo"] = true,
    ["Santa"] = true,
    ["Maresia"] = true,
    ["Alexandria"] = true,
}
local ROBBERY_NOBRE_RADIUS_BLIPS = {}
local ROBBERY_ROBBERY_AREA = false
local ROBBERY_NOBRE_DEBUG = false

local CachedBlips = {}
function CreateBlipsRobbery()

    if not gLegacyDominationEnabled then
        return
    end

    for i=1,#robberyNobre do
        local Blip = AddBlipForCoord(robberyNobre[i]["Start"])
        local Text = _t("domination").." "
        CachedBlips[i] = Blip
        local BlipId = 546
        local Color = 5
        SetBlipSprite(Blip, BlipId)
        SetBlipDisplay(Blip, 4)
        SetBlipScale(Blip, 0.8)
        SetBlipColour(Blip, Color)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Text)
        EndTextCommandSetBlipName(Blip)
        ROBBERY_NOBRE_BLIPS[i] = Blip
    end
end

function DeleteBlipsRobbery()
    for k,v in pairs(CachedBlips) do
        RemoveBlip(v)
        CachedBlips[k] = nil
    end
    CachedBlips = {}
end

AddEventHandler("misc:CreateBlips",function(resource)
    CreateBlipsRobbery()
end)

AddEventHandler("misc:DeleteBlips",function(resource)
    DeleteBlipsRobbery()
end)

-- Mantém o legado abaixo intacto, sem registrar captura/recompensas nesta fase.
if not gLegacyDominationEnabled then
    exports("CheckIfDomination", function()
        return false
    end)

    CreateThread(function()
        if #robberyNobre == 0 then
            return
        end

        Wait(250)
        CreateBlipsRobbery()
        local noticeShown = false

        while true do
            local coords = GetEntityCoords(PlayerPedId())
            local nearestDistance = math.huge

            for _, area in ipairs(robberyNobre) do
                nearestDistance = math.min(nearestDistance, #(coords - area.Start))
            end

            -- Margem de saída evita reabrir o aviso oscilando na borda de 150m.
            if nearestDistance > 165.0 then
                noticeShown = false
            elseif nearestDistance <= 150.0 and not noticeShown
                and GetResourceState('dminigames') == 'started' then
                noticeShown = exports.dminigames:ShowDominationMigrationNotice()
            end

            Wait(1000)
        end
    end)

    return
end


function BlinkBlip(Number)
    local Blip2 = false
    --if cityName == "Santa" then
        if not ROBBERY_NOBRE_RADIUS_BLIPS[Number] then
            Blip2 = AddBlipForRadius(robberyNobre[Number]["Start"],100.0)
            SetBlipColour(Blip2, 1)
            SetBlipAlpha(Blip2, 125)
            SetBlipAsShortRange(Blip2, true)
            ROBBERY_NOBRE_RADIUS_BLIPS[Number] = Blip2
        else
            Blip2 = ROBBERY_NOBRE_RADIUS_BLIPS[Number]
        end
    --end 
    local Blip = ROBBERY_NOBRE_BLIPS[Number]
    SetBlipColour(Blip, 85)
    if Blip2 then
        SetBlipColour(Blip2, 85)
    end
    Wait(500)
    SetBlipColour(Blip, 1)
    if Blip2 then
        SetBlipColour(Blip2, 1)
    end
end

CreateThread(function()
    while true do
        local Idle = 1000
        for Number,_ in pairs(ROBBERY_GOING) do
            BlinkBlip(Number)
        end
        Wait(Idle)
    end
end)

RegisterNetEvent("robberyNobre:Started")
AddEventHandler("robberyNobre:Started",function(Number,Group,Value)
    if not ROBBERY_NOBRE_DEBUG and not GoingDomination[cityName] then
        return
    end
    ROBBERY_GOING[Number] = true
    local Table = GlobalState["AliasGroup"] or {}
    Group = Table[Group] or Group
    --TriggerEvent("chat:ClientMessage","","A DOMINAÇÃO [".. robberyNobre[Number]["Name"].."] Foi [INÍCIADA] pelo grupo ["..Group.."] valendo [R$"..parseFormat(Value).."]","DOMINAÇÃO",false,WARNING_DOM_CUSTOM)
    TriggerEvent("chat:ClientMessage2","#theDomi",{
        msg1 = robberyNobre[Number]["Name"],
        msg2 = Group,
        msg3 = parseFormat(Value)
    },false, WARNING_DOM_CUSTOM)
end)

RegisterNetEvent("robberyNobre:OwnerStarted")
AddEventHandler("robberyNobre:OwnerStarted",function(Number)
    if not ROBBERY_NOBRE_DEBUG and not GoingDomination[cityName] then
        return
    end
    TriggerEvent("Progress","Mundo",robberyNobre[Number]["DominationTimer"]*1000)
    ROBBERY_SELECTED = Number
    local DominationCoords = robberyNobre[Number]["Coords"]
    local Ped = PlayerPedId()
    local Radius = robberyNobre[Number]["Radius"]
    local Options = robberyNobre[Number]["Options"]
    ROBBERY_AREA = CircleZone:Create(DominationCoords, Radius,Options)
    while ROBBERY_SELECTED do
        local Coords = GetEntityCoords(Ped)
        local Health = GetEntityHealth(Ped)
        if not ROBBERY_AREA:isPointInside(Coords) or Health <= 100 then
            ROBBERY_SELECTED = false
            ROBBERY_AREA:destroy()
            ROBBERY_AREA = false
            TriggerServerEvent("robberyNobre:Exit",Number)
            TriggerEvent("Progress","Cancelando",0)
        end
        if IsPedInAnyVehicle(Ped) then
            ROBBERY_SELECTED = false
            ROBBERY_AREA:destroy()
            ROBBERY_AREA = false
            TriggerServerEvent("robberyNobre:Exit",Number)
            TriggerEvent("Progress","Cancelando",0)
        end
        Wait(1000)
    end
end)

RegisterNetEvent("robberyNobre:Canceled")
AddEventHandler("robberyNobre:Canceled",function(Number)
    if not ROBBERY_NOBRE_DEBUG and not GoingDomination[cityName] then
        return
    end
    ROBBERY_GOING[Number] = nil
    if ROBBERY_SELECTED == tonumber(Number) then
        ROBBERY_SELECTED = false
    end
    Wait(500)
    --TriggerEvent("chat:ClientMessage","","A DOMINAÇÃO [".. robberyNobre[Number]["Name"].."] foi [CANCELADA].","DOMINAÇÃO",false,WARNING_DOM_CUSTOM)
    TriggerEvent("chat:ClientMessage2","#cancelDomi",{
        msg = robberyNobre[Number]["Name"]
    },false, WARNING_DOM_CUSTOM)

    local Blip = ROBBERY_NOBRE_BLIPS[Number]
    SetBlipColour(Blip, 1)
end)

RegisterNetEvent("robberyNobre:Finished")
AddEventHandler("robberyNobre:Finished",function(Number)
    if not ROBBERY_NOBRE_DEBUG and not GoingDomination[cityName] then
        return
    end
    ROBBERY_GOING[Number] = nil
    if ROBBERY_SELECTED == tonumber(Number) then
        ROBBERY_SELECTED = false
        ROBBERY_AREA:destroy()
        ROBBERY_AREA = false
        TriggerEvent("Progress","Cancelando",0)
    end
end)

CreateThread(function()
    if not ROBBERY_NOBRE_DEBUG and not GoingDomination[cityName] then
        return
    end
    Wait(250)
    CreateBlipsRobbery()
    while true do
        local Idle = 2500
        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)
        local Health = GetEntityHealth(Ped)
        if Health > 100 then 
            if not ROBBERY_SELECTED then
                for i=1,#robberyNobre do
                    local Distance = #(Coords - robberyNobre[i].Start)
                    if Distance <= 50 then
                        Idle = 0
                        DrawMarker(42,robberyNobre[i].Start.x, robberyNobre[i].Start.y, robberyNobre[i].Start.z,0,0,0,vec3(0.0, 0.0, 0.0),vec3(1.0, 1.0, 1.0),THEME.rgb.r, THEME.rgb.g, THEME.rgb.b, 100,false,false,2,true,nil,nil,false)
                    end
                    if not IsPedInAnyVehicle(Ped) then
                        if Distance <= 1.5 then
                            DrawText3D(robberyNobre[i].Start.x, robberyNobre[i].Start.y, robberyNobre[i].Start.z, "~g~E~w~ - ".._t("init_domination"))
                            if IsControlJustPressed(0, 38) then
                                TriggerServerEvent("robberyNobre:RequestStart", i)
                            end
                        end
                    end
                end
            end
        end
        Wait(Idle)
    end
end)

function CheckIfDomination()
    local Ped = PlayerPedId()
    local isOnAnyDomination = false
    for i=1,#robberyNobre do
        local Name = robberyNobre[i]["Name"]
        -- print("[DEBUG] - Verificando Dominação: "..Name)
        local DominationCoords = robberyNobre[i]["Coords"]
        local Radius = robberyNobre[i]["Radius"]
        local Options = robberyNobre[i]["Options"]
        local Area = CircleZone:Create(DominationCoords, Radius,Options)
        local Coords = GetEntityCoords(Ped)
        if Area:isPointInside(Coords) then
            -- print("[DEBUG] - Está na Dominação: "..Name)
            isOnAnyDomination = true
        -- else
        --     print("[DEBUG] - Não está na Dominação: "..Name)
        end
        Area:destroy()
    end
    return isOnAnyDomination
end
exports("CheckIfDomination",CheckIfDomination)
