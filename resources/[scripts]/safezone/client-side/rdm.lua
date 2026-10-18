Tunnel = module("vrp","lib/Tunnel")
Proxy = module("vrp","lib/Proxy")
vSERVER = Tunnel.getInterface("safezone")
-----------------------------------------------------------------------------------------------------------------------------------------
-- QG_SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
---@param point vector3
---@return boolean
function IsInRdmZoneByPoint(point)
    for zone,ZoneData in pairs(RDM_ZONES) do
        if ZoneData:isPointInside(point) then
            return true
        end
    end
    return false
end

---@param point vector3
---@return boolean
function IsAnyZone(point)
    for _,zone in pairs(RDM_ZONES) do
        if zone:isPointInside(point) then
            return true
        end
    end
    return false
end

---@param point vector3
---@return boolean
function IsInRdmZoneByPoint(point)
    for _,polyzone in pairs(RDM_ZONES) do
        if polyzone:isPointInside(point) then
            return true
        end
    end
    return false
end

exports("IsInRdmZoneByPoint",IsInRdmZoneByPoint)
exports("IsAnyZone",IsAnyZone)

CreateThread(function() -- utinhaaa
    Wait(2500)
    for Name, Info in pairs(RDM_ZONES) do
        local zone = PolyZone:Create(Info,{
            name=Name,
            debugGrid=false,
        })
        RDM_ZONES[Name] = zone
    end

    local Configs = exports["org_system"]:GetAllOfConfig("RDM_ZONES")
    for i=1,#Configs do
        local Config = Configs[i]
        for Name, Info in pairs(Config) do
            local zone = PolyZone:Create(Info[1],{
                name=Name,
                debugGrid=false,
            })

            RDM_ZONES[Name] = zone
            RDM_ZONES[Name] = zone
        end
    end
end)
-- DEBUG --
-- CreateThread(function()
--     Wait(1000)
--     local Ped = PlayerPedId()
--     while true do
--         for zone,ZoneData in pairs(Zones) do
--             if ZoneData:isPointInside(GetEntityCoords(Ped)) then
--                 TriggerEvent("Notify","vermelho","Entrou na zona "..zone)
--                 vSERVER.HasPermission(zone,1)
--             end
--         end
--         Wait(500)
--     end
-- end)


AddEventHandler("gameEventTriggered",function(name,args)
    if name ~= "CEventNetworkEntityDamage" then
        return
    end
    if not LocalPlayer["state"]["WorldPVP"] then 
        if LocalPlayer["state"]["Route"] ~= 1 and LocalPlayer["state"]["Route"] ~= 20 then
            return
        end
    end
    local Victim = PlayerPedId()
    local Attacker = tonumber(args[2])
    
    if args[1] ~= Victim then
        return
    end

    local VictimDied = GetEntityHealth(Victim) <= 100

    if not VictimDied then
        return
    end

    local AttackerInside = false
    local VictimInside = false
    local Zone = nil
    local Coords = GetEntityCoords(Victim)
    for zone,ZoneData in pairs(RDM_ZONES) do
        if ZoneData:isPointInside(GetEntityCoords(Victim)) then
            VictimInside = true
            Zone = zone
        end
    end

    if not Zone then
        return
    end

    if not VictimInside then
        return
    end

    local Weapon = tostring(args[7])
    if VictimDied then
        if IsEntityAPed(Attacker) then
            if IsPedAPlayer(Attacker) then
                local playerIndex = NetworkGetPlayerIndexFromPed(Attacker)
                local attackerServerId = GetPlayerServerId(playerIndex)
                -- Wait(100)
                -- vSERVER.HasPermission(Zone,attackerServerId)
            end
        end
    end
end)