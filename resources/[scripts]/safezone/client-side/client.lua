local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vADMIN = Tunnel.getInterface("admin")
vSERVER = Tunnel.getInterface("safezone")
Player = GetPlayerServerId(PlayerId())
cityName = GetConvar("cityName", "")
Creative = {}
Tunnel.bindInterface("safezone",Creative)
SafeMode = GetConvar("SafeMode", "")

local safeZoneName = ""
local safeMode = false

local safeZone = {}
for name, coords in pairs(SafeZoneCoords) do
    safeZone[name] = PolyZone:Create(coords, { name = name })
end

-- Pre-compute centroid + max radius for each safezone (distance pre-filter)
local safeZoneCache = {}
for k, v in pairs(safeZone) do
    local cx, cy = 0.0, 0.0
    local points = v.points
    if points then
        for i = 1, #points do
            cx = cx + points[i].x
            cy = cy + points[i].y
        end
        cx = cx / #points
        cy = cy / #points
        local maxDist = 0.0
        for i = 1, #points do
            local dx = points[i].x - cx
            local dy = points[i].y - cy
            local d = dx * dx + dy * dy
            if d > maxDist then maxDist = d end
        end
        safeZoneCache[k] = { center = vector2(cx, cy), radiusSq = maxDist + 2500.0 }
    elseif v.center then
        local c = v.center
        local s = v.size
        local r = math.max(s.x, s.y) * 0.5
        safeZoneCache[k] = { center = vector2(c.x, c.y), radiusSq = (r + 50.0) * (r + 50.0) }
    end
end

---@type table<string, string>
local spawnZones = {
    ["Pier"] = "initialzone.exit.criminoso", -- CRIMINOSO
    ["Policial"] = "initialzone.exit.policial", -- POLICIAL
    ["Mecanica"] = "initialzone.exit.mecanico", -- MECANICO
    ["Hospital"] = "initialzone.exit.paramedico", -- PARAMÉDICO
}

local Buckets = {
    ["Pier"] = 1,
    ["Hospital"] = 1,
}

safeCooldown = GetGameTimer()
safeuser = nil
isInside = false
updateEntity = GetGameTimer()
cooldownInside = GetGameTimer()
safeMode = false
SafeWarmode = false

---@param state boolean
local function SetSafeZoneLocal( state )

    TriggerServerEvent( 'safezone.state_changed', state )

    LocalPlayer.state:set( 'InSafeZone', state == true and true or nil )
end

function insidePoly()
    local Bucket = LocalPlayer["state"]["Route"]
    if not bucketSafe[Bucket] then
        if LocalPlayer["state"]["Route"] > 1 or LocalPlayer["state"]["PVP"] then
            safeuser = nil
            safeZoneName = false
            return
        end
    end
    local ped = PlayerPedId()


    TriggerEvent('survey:set-kvp', 'already_entered_safezone:'..LocalPlayer["state"]["Passport"], true)

    --TriggerEvent("Notify","amarelo","Você entrou na zona segura.",5000,"Safezone")
    -- TriggerEvent("Notify2","#safeZone")
    SetSafeZoneLocal( true )
    TriggerEvent("hud:Safe",true)
    -- TriggerEvent("Notify2","#enteredSafeZ")
    TriggerEvent("sounds:Private","entersafe",0.07)
    -- LocalPlayer.state:set("isLafyMuted", true, true)
    if SafeMode == "true" then
        if GlobalState["WarMode"] and Entity(ped)["state"]["WarMode"] then
            WarModeSafeZone(safeuser)
            SafeWarmode = true
        end
    end
    SetLocalPlayerAsGhost(true)
    SetGhostedEntityAlpha(254)
    LocalPlayer.state:set("Invincible", true, false)
    if LocalPlayer["state"]["WhatsappInvite"] then
        if not IsPedInAnyVehicle(ped) then
            TriggerEvent("WhatsappFunnel:CanShow", false)
            TriggerServerEvent("WhatsappFunnel:ShowServer")
        else
            CreateThread(function()
                while safeuser do
                    if not IsPedInAnyVehicle(ped) and LocalPlayer["state"]["WhatsappInvite"] then
                        TriggerEvent("WhatsappFunnel:CanShow", false)
                        TriggerServerEvent("WhatsappFunnel:ShowServer")
                        break
                    end
                    Wait(500)
                end
            end)
        end
    end

    CreateThread(function()
        local playerId = PlayerId()
        local cache = safeZoneCache[safeZoneName]
        local cacheCx, cacheCy, cacheRadiusSq
        if cache then
            cacheCx, cacheCy, cacheRadiusSq = cache.center.x, cache.center.y, cache.radiusSq
        end

        while safeuser do
            local hasWall = LocalPlayer.state["wall"]
            
            SetPlayerTargetingMode(3)
            SetPlayerLockon(PlayerId(), false)

            if not hasWall then
                local allPlayers = GetActivePlayers()
                local playerCount = #allPlayers

                for i = 1, playerCount do
                    local player = allPlayers[i]
                    if player ~= playerId then
                        local otherPed = GetPlayerPed(player)
                        local coords = GetEntityCoords(otherPed)
                        local isConcealed = NetworkIsPlayerConcealed(player)

                        local isInside = false
                        if cache then
                            local dx = coords.x - cacheCx
                            local dy = coords.y - cacheCy
                            if dx * dx + dy * dy <= cacheRadiusSq then
                                isInside = safeuser:isPointInside(coords)
                            end
                        else
                            isInside = safeuser:isPointInside(coords)
                        end

                        if isInside and isConcealed then
                            NetworkConcealPlayer(player, false, false)
                            FreezeEntityPosition(otherPed, false)
                        elseif not isInside and not isConcealed then
                            NetworkConcealPlayer(player, true, false)
                            FreezeEntityPosition(otherPed, true)
                        end
                    end
                end
            else
                local allPlayers = GetActivePlayers()
                for i = 1, #allPlayers do
                    local player = allPlayers[i]
                    if player ~= playerId and NetworkIsPlayerConcealed(player) then
                        local otherPed = GetPlayerPed(player)
                        NetworkConcealPlayer(player, false, false)
                        FreezeEntityPosition(otherPed, false)
                    end
                end
            end
            Wait(1000)
        end
        local allPlayers = GetActivePlayers()
        for i = 1, #allPlayers do
            local player = allPlayers[i]
            if NetworkIsPlayerConcealed(player) then
                local otherPed = GetPlayerPed(player)
                NetworkConcealPlayer(player, false, false)
                FreezeEntityPosition(otherPed, false)
            end
        end
    end)

    InSafeZone()
    -- if Buckets[safeZoneName] then
    --     if IsPedInAnyVehicle(ped) then
    --         local vehicle = GetVehiclePedIsIn(ped)
    --         if GetPedInVehicleSeat(vehicle,-1) == ped then
    --             TriggerServerEvent("Safe:Bucket",Buckets[safeZoneName])
    --         end
    --     else
    --         TriggerServerEvent("Safe:Bucket",Buckets[safeZoneName])
    --     end
    -- end
    while true do
        local coords = GetEntityCoords(ped)
        if safeuser and not safeuser:isPointInside(coords) then

            SetLocalPlayerAsGhost(false)
            DisablePlayerFiring(ped,false)
            SetPlayerTargetingMode(2)
            SetPlayerLockon(PlayerId(), true)
            SetEntityInvincible(ped,false)
            LocalPlayer["state"]["Invincible"] = false
            --TriggerEvent("Notify","vermelho","Você saiu da zona segura.",3000,"Safezone")
            -- TriggerEvent("Notify2","#foraSafeZone")
            SetSafeZoneLocal( false )
            TriggerEvent("hud:Safe",false)

            -- TriggerEvent("Notify2","#leaveSafeZ")
            -- ENG-1681: efeito sonoro de sair da safe removido (mantido só ao entrar).
            -- LocalPlayer.state:set("isLafyMuted", false, true)
            safeuser = false
            if safeMode then
                SetLocalPlayerAsGhost(true)
                SetGhostedEntityAlpha(254)
                if not LocalPlayer.state["inSafeMode"] then
                    vSERVER.setSafeMode(true)
                end
            else
                SetLocalPlayerAsGhost(false)
                if LocalPlayer.state["inSafeMode"] then
                    vSERVER.setSafeMode(false)
                end
            end

            if spawnZones[safeZoneName] then
                TriggerServerEvent("admin:server:addAccountEvent", spawnZones[safeZoneName])
            end

            if Buckets[safeZoneName] then
                safeZoneName = false
                if LocalPlayer["state"]["Route"] >= 900000 then
                    return
                end
                -- if IsPedInAnyVehicle(ped) then
                --     local vehicle = GetVehiclePedIsIn(ped)
                --     if GetPedInVehicleSeat(vehicle,-1) == ped or GetPedInVehicleSeat(vehicle,-1) == 0 then
                --         TriggerServerEvent("Safe:Bucket",1)
                --     end
                -- else
                --     TriggerServerEvent("Safe:Bucket",1)
                -- end
            end
            break
        else
            if not safeuser then
                break
            end
            if LocalPlayer["state"]["Route"] >= 900000 then
                return
            end
            if not IsPedInAnyVehicle(ped) then
                -- print('cleaning weapons')
                TriggerEvent("inventory:CleanWeapons")
            end
        end
        Wait(750)
    end
end

CreateThread(function()
    if GlobalState["SafeZone"] then
        while true do
            local idle = 2500
            if LocalPlayer["state"]["InSafeZone"] then
                idle = 1000
                local ped = PlayerPedId()
                local Coords = GetEntityCoords(ped)
                local px, py = Coords.x, Coords.y
                for k,v in pairs(safeZone) do
                    local cache = safeZoneCache[k]
                    if cache then
                        local dx = px - cache.center.x
                        local dy = py - cache.center.y
                        if dx * dx + dy * dy > cache.radiusSq then
                            goto continueGlobal
                        end
                    end
                    isInside = v:isPointInside(Coords)
                    if isInside then
                        -- if k == "Pier" then
                        --     Wait(2500)
                        --     exports["survival"]:Revive(400)
                        --     exports['pma-voice']:resetProximityCheck()
                        -- end
                    end
                    ::continueGlobal::
                end
            end
            Wait(idle)
        end
    end
end)

function Creative.IsInsideBannedsIsland()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local px, py = coords.x, coords.y

    for k, v in pairs(safeZone) do
        local cache = safeZoneCache[k]
        if cache then
            local dx = px - cache.center.x
            local dy = py - cache.center.y
            if dx * dx + dy * dy > cache.radiusSq then
                goto continueBanneds
            end
        end

        local isInside = v:isPointInside(coords)
        
        
        
        if isInside then
            if k == "Banneds" then
                return true
            end
        end
        ::continueBanneds::
    end

    return false
end

function InSafeZone()
    local ped = PlayerPedId()
    SetEntityInvincible(ped,true)
    SetCanPedEquipAllWeapons(ped, false)
    CreateThread(function()
        local lastWeaponCheck = 0
        local lastInvincibleRefresh = 0
        while safeuser do
            DisablePlayerFiring(ped,true)

            if not LocalPlayer["state"]["enable-weapons-vehicle"] then
                DisableControlAction(2, 37, true)
                DisableControlAction(0, 106, true)
                DisableControlAction(0, 140, true)
                DisableControlAction(0, 205, true)
                DisableControlAction(0, 263, true)
            end

            local now = GetGameTimer()
            if now - lastInvincibleRefresh >= 1000 then
                lastInvincibleRefresh = now
                SetEntityInvincible(ped, true)
                SetLocalPlayerAsGhost(true)
                SetGhostedEntityAlpha(254)
            end

            if now - lastWeaponCheck >= 500 then
                lastWeaponCheck = now
                if not IsPedInAnyVehicle(ped) then
                    SetCanPedEquipAllWeapons(ped, false)
                end
            end

            Wait(0)
        end
    end)
end

function inSafeMode()
    local ped = PlayerPedId()
    SetLocalPlayerAsGhost(true)
    SetGhostedEntityAlpha(254)
    LocalPlayer["state"]["Invincible"] = true
    SetEntityInvincible(ped,true)
    SetPedConfigFlag(ped, 186, true)
    SetCanPedEquipAllWeapons(ped, false)
    CreateThread(function()
        local lastHeavyCheck = 0
        while safeMode do
            if safeuser then
                local now = GetGameTimer()
                if now - lastHeavyCheck >= 1000 then
                    lastHeavyCheck = now
                    SetPedConfigFlag(ped, 186, true)
                    SetCanPedEquipAllWeapons(ped, false)
                    SetEntityInvincible(ped, true)
                end
                Wait(500)
            else
                if not LocalPlayer["state"]["enable-weapons-vehicle"] then
                    DisableControlAction(0, 140, true)
                    DisablePlayerFiring(ped, true)
                end

                local now = GetGameTimer()
                if now - lastHeavyCheck >= 1000 then
                    lastHeavyCheck = now
                    SetPedConfigFlag(ped, 186, true)
                    SetCanPedEquipAllWeapons(ped, false)
                    SetEntityInvincible(ped, true)
                end
                Wait(0)
            end
        end
        SetPedConfigFlag(ped, 186, false)
    end)
end

local CooldownCheck = GetGameTimer()
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        if LocalPlayer["state"]["Active"] and LocalPlayer["state"]["Route"] <= 900000 then
            local px, py = coords.x, coords.y
            for k,v in pairs(safeZone) do
                local cache = safeZoneCache[k]
                if cache then
                    local dx = px - cache.center.x
                    local dy = py - cache.center.y
                    if dx * dx + dy * dy > cache.radiusSq then
                        goto continue
                    end
                end
                isInside = v:isPointInside(coords)
                if isInside then
                    safeuser = v
                    safeZoneName = k
                    cooldownInside = GetGameTimer() + 1000*60
                    if CooldownCheck <= GetGameTimer() then
                        CooldownCheck = GetGameTimer() + 1000*60*5
                    end
                    insidePoly()
                end
                ::continue::
            end
        end
        Wait(2000)
    end
end)

local EnterSafing = false
RegisterNetEvent("safezone:updateNewbie")
AddEventHandler("safezone:updateNewbie",function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    if safeZone["Pier"]:isPointInside(coords) then
        if GetGameTimer() >= safeCooldown then
            safeCooldown = GetGameTimer() + 5000

            if safeuser then
                if not EnterSafing then
                    if not safeMode then
                        TriggerEvent("Progress","Entrando no modo seguro",30000)
                        EnterSafing = true
                        Wait(30000)

                        EnterSafing = false
                        local ped = PlayerPedId()
                        local coords = GetEntityCoords(ped)
                        if safeZone["Pier"]:isPointInside(coords) then
                            safeMode = true
                            if safeuser then
                                --TriggerEvent("Notify","verde","Você entrou no modo segurança.", 3000,"Safezone")
                                TriggerEvent("Notify2","#enteredSafeMode")
                            else
                                --TriggerEvent("Notify","vermelho","Você saiu da safe o modo segurança foi cancelado.", 3000,"Safezone")
                                TriggerEvent("Notify2","#leaveSafeMode")
                            end
                        end
                    else
                        TriggerEvent("Progress","Saindo do modo seguro",30000)
                        EnterSafing = true
                        Wait(30000)

                        EnterSafing = false
                        local ped = PlayerPedId()
                        local coords = GetEntityCoords(ped)
                        if safeZone["Pier"]:isPointInside(coords) then
                            safeMode = false
                            SetPedConfigFlag(ped, 186, false)
                            if safeuser then
                                --TriggerEvent("Notify","vermelho","Você saiu do modo segurança.",3000,"Safezone")
                                TriggerEvent("Notify2","#safeModeOff")
                            else
                                --TriggerEvent("Notify","vermelho","Você saiu da safe o modo segurança foi cancelado.",3000,"Safezone")
                                TriggerEvent("Notify2","#leaveSafeMode")
                            end
                        end
                    end
                end
            else
                --TriggerEvent("Notify","amarelo","Você só pode ativar/desativar em uma zona segura.",3000,"Safezone")
                TriggerEvent("Notify2","#onOffSafe")
            end
        end
    else
        --TriggerEvent("Notify","amarelo","Vai pro pier.",3000,"Safezone")
        TriggerEvent("Notify2","#goPier")
    end
end)

AddStateBagChangeHandler('inSafeMode',('player:%s'):format(Player) , function(_, _, Value)
    local Ped = PlayerPedId()
    if not GlobalState["SafeZone"] then
        return
    end
    if not Value then
        LocalPlayer["state"]["Invincible"] = false
        SetEntityInvincible(Ped, false)
        safeMode = false
    else
        if LocalPlayer["state"]["Route"] >= 900000 then
            return
        end
        safeMode = true
        inSafeMode()
    end
end)

AddStateBagChangeHandler('PVP',('player:%s'):format(Player) , function(_, _, Value)
    local ped = PlayerPedId()
    if not GlobalState["SafeZone"] then
        return
    end
    if Value then
        SetLocalPlayerAsGhost(false)
        DisablePlayerFiring(ped,false)
        SetPlayerTargetingMode(2)
        SetPlayerLockon(PlayerId(), true)
        SetEntityInvincible(ped,false)
        LocalPlayer["state"]["Invincible"] = false
        SetSafeZoneLocal( false )
        safeuser = false
        safeZoneName = false
    end
end)

RegisterNetEvent( 'net:routing_bucket_changed', function( bucketId )

    bucketId = tonumber(bucketId) or 1

    if bucketSafe[bucketId] or bucketId <= 1 or not safeuser then
        return
    end

    local ped = PlayerPedId()
    SetLocalPlayerAsGhost(false)
    DisablePlayerFiring(ped,false)
    SetPlayerTargetingMode(2)
    SetPlayerLockon(PlayerId(), true)
    SetEntityInvincible(ped,false)
    SetCanPedEquipAllWeapons(ped, true)
    LocalPlayer["state"]["Invincible"] = false
    SetSafeZoneLocal( false )
    TriggerEvent("hud:Safe",false)
    safeuser = false
    safeZoneName = false
    safeMode = false

    if LocalPlayer.state["inSafeMode"] then
        vSERVER.setSafeMode(false)
    end
end)

AddStateBagChangeHandler('Newbie',('player:%s'):format(Player) , function(_, _, Value)
    local Ped = PlayerPedId()
    if GlobalState["WarMode"] then
        return
    end
    if not GlobalState["SafeZone"] then
        return
    end
    if not Value then
        SetLocalPlayerAsGhost(false)
        DisablePlayerFiring(Ped,false)
        SetEntityInvincible(Ped,false)
        LocalPlayer["state"]["Invincible"] = false
        safeMode = false
    else
        if LocalPlayer["state"]["Route"] >= 900000 then
            return
        end
        safeMode = true
        SetEntityInvincible(Ped,true)
        LocalPlayer["state"]["Invincible"] = true
        inSafeMode()
    end
end)


AddEventHandler("gameEventTriggered",function(name,args)
    local ped = PlayerPedId()
    if name == "CEventNetworkEntityDamage" and args[1] == ped then
        if LocalPlayer["state"]["Route"] >= 900000 then
            return
        end
        if GetEntityHealth(ped) <= 100 then
            local coords = GetEntityCoords(ped)
            local px, py = coords.x, coords.y
            for k,v in pairs(safeZone) do
                local cache = safeZoneCache[k]
                if cache then
                    local dx = px - cache.center.x
                    local dy = py - cache.center.y
                    if dx * dx + dy * dy > cache.radiusSq then
                        goto continueDmg
                    end
                end
                isInside = v:isPointInside(coords)
                if isInside then
                    --if cooldownInside <= GetGameTimer() then
                    -- if k == "Pier" then
                    --     Wait(2500)
                    --     exports["survival"]:Revive(400)
                    --     exports['pma-voice']:resetProximityCheck()
                    -- end
                end
                ::continueDmg::
            end
        end
	end
end)
local createdZone = false
RegisterCommand("testzone",function()
    local Ped = PlayerPedId()
    local Coords = GetEntityCoords(Ped)
    if createdZone then
        createdZone:destroy()
        createdZone = false
    end
    createdZone = CircleZone:Create(vector3(Coords), 424.0, {
        name="circle_zone",
        debugPoly=true,
    })
end)


RegisterNUICallback("getCityName",function(Data,Callback)
    cityName = GetConvar("cityName", "")
    Callback(string.lower(cityName))
end)

-- CreateThread(function()
--     Wait(5000)
--     if not GlobalState["NoVehicleDamage"] then
--         return
--     end
--     while true do
--         SetWeaponDamageModifier(-1553120962, 0.0) 
--         Wait(0)
--     end
-- end)
CreateThread(function()
	while true do
		Wait(100)
        local Ped = PlayerPedId()
        local Player = PlayerId()
        if IsPedFalling(Ped) then
            SetPedCanRagdoll(Ped, true)
            Wait(60000)
            SetPedCanRagdoll(Ped, false)
        end
    end
end)

CreateThread(function()
    Wait(5000)
    if GlobalState["FallDamage"] then
        return
    end
	while true do
		Wait(5)
        local Ped = PlayerPedId()
        local Player = PlayerId()
        if IsPedFalling(Ped) then
            SetEntityInvincible(Ped, true)
            SetPlayerInvincible(Player, true)
            SetPedCanRagdoll(Ped, false)
            ClearPedBloodDamage(Ped)
            ResetPedVisibleDamage(Ped)
            ClearPedLastWeaponDamage(Ped)
            SetEntityProofs(Ped, true, true, true, true, true, true, true, true)
            SetEntityOnlyDamagedByPlayer(Ped, false)
            SetEntityCanBeDamaged(Ped, false)
        else
            SetEntityInvincible(Ped, false)
            SetPlayerInvincible(Player, false)
            -- SetPedCanRagdoll(Ped, true)
            ClearPedLastWeaponDamage(Ped)
            SetEntityProofs(Ped, false, false, false, false, false, false, false, false)
            SetEntityOnlyDamagedByPlayer(Ped, false)
            SetEntityCanBeDamaged(Ped, true)
        end 
	end
end)



function Creative.GetCoords()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    return coords
end

--[[
RegisterCommand("testaudio",function(source,Message)
    local Keyboard = exports["keyboard"]:keySingle("Link do Video:")
    if Keyboard and Keyboard[1]  then
        TriggerEvent("promotion_button:OpenAudio",Keyboard[1])
    end
end)
--]]
