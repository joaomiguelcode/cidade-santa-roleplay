AddEventHandler("gameEventTriggered",function(name,args)
    if name ~= "CEventNetworkEntityDamage" then
        return
    end

    -- if not LocalPlayer["state"]["WarMode"] then 
    --     return
    -- end

    local Killer = PlayerPedId()
    if args[2] ~= Killer then
        return
    end

    if LocalPlayer["state"]["PVP"] then
        return
    end

    local Victim = args[1]
    local Attacker = tonumber(args[2])
    local VictimDied = GetEntityHealth(Victim) <= 100
    local Weapon = tostring(args[7])
    if VictimDied then
        if IsEntityAPed(Victim) then
            if IsPedAPlayer(Victim) then
                local VictimName = Entity(Victim)["state"]["Name"]
                local VictimServerId = GetPlayerServerId((NetworkGetPlayerIndexFromPed(Victim)))
                SendNUIMessage({ action = "warKillFeed", data = { weapon = Weapon, killerName = VictimName }})
            end
        end
    end
end)

local BLOCK_WEAPONS_VEHICLE_KILLFEED = {
    [`WEAPON_RAMMED_BY_CAR`] = true,
    [`WEAPON_RUN_OVER_BY_CAR`] = true,
}

---@param weapon number
---@param killer number
---@return boolean
local function BlockWeaponsVehicleKillFeed(weapon, killer)
    if not BLOCK_WEAPONS_VEHICLE_KILLFEED[weapon] then
        return false
    end

    local victim = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(victim, false)

    if vehicle == 0 then
        return false
    end
    
    local driver =  GetPedInVehicleSeat(vehicle, -1)

    if driver == PlayerPedId() then -- bloquear pois é uma replica de dano em dois lugares ( passageiro e motorista recebem o mesmo evento)
        return true
    end

    if GetPedInVehicleSeat(vehicle, 0) ~= victim then
        return false
    end
    
    return driver == killer
end

AddEventHandler("gameEventTriggered", function(name,args)
    if name ~= "CEventNetworkEntityDamage" then
        return
    end

    local Victim = PlayerPedId()

    if args[1] ~= Victim then
        return
    end

    local VictimDied = GetEntityHealth(Victim) <= 100

    if VictimDied then

        TriggerServerEvent( 'net.i_died' )
    end

    if LocalPlayer["state"]["PVP"] then
        return
    end

    local wasArmed = IsPedArmed(Victim, 4)
    local Killer = args[2]
    local Attacker = tonumber(args[1])
    local VictimDied = GetEntityHealth(Victim) <= 100
    local Weapon = tostring(args[7])

    if BlockWeaponsVehicleKillFeed(args[7], Killer) then
        -- sx.logger:info('[killfeed] block damage vehicle passanger or driver')
        return
    end

    if exports["safezone"]:IsAnyZone(GetEntityCoords(Victim)) then
        -- sx.logger:info('[killfeed] block damage rdm zone')
        return
    end

    if exports["warsystem"]:IsNearDomination(GetEntityCoords(Victim)) then
        -- sx.logger:info('[killfeed] block damage domination zone')
        return
    end

    if VictimDied then
        if IsEntityAPed(Victim) then
            if IsPedAPlayer(Victim) then
                local KillerServerId = GetPlayerServerId((NetworkGetPlayerIndexFromPed(Killer)))
                TriggerServerEvent("hud:KillFeed", KillerServerId, Weapon, wasArmed)
            end
        end
    end
end)


-- AddEventHandler("gameEventTriggered",function(name,args)
--     if name ~= "CEventNetworkEntityDamage" then
--         return
--     end

--     -- if not LocalPlayer["state"]["WarMode"] then 
--     --     return
--     -- end

--     local Killer = args[2]
--     local Victim = args[1]

--     if Victim ~= PlayerPedId() then
--         return
--     end

--     if LocalPlayer["state"]["PVP"] then
--         return
--     end

--     local Attacker = tonumber(args[2])
--     local VictimDied = GetEntityHealth(Victim) <= 100
--     local Weapon = tostring(args[7])
--     if VictimDied then
--         if IsEntityAPed(Attacker) then
--             if IsPedAPlayer(Attacker) then
--                 local AttackerServerId = GetPlayerServerId((NetworkGetPlayerIndexFromPed(Attacker)))
--                 TriggerServerEvent("hud:UpdateHealthInformation",AttackerServerId,Weapon)
--             end
--         end
--     end
-- end)