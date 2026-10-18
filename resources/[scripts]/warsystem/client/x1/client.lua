InX1 = false
StartingX1 = false
InQueue = false

X1Spawns = {
    ["1x1"] = {
        [1] = {
            vector4(-1663.09,5864.77,210.36,34.02),
    
        },
        [2] = {
            vector4(-1675.43,5886.27,210.36,218.27),
        }
    },
}


local function validateDeathState( )
    -- Isso daqui é uma gambiarra para esperar o player estar morto definitavamente
    -- para assim então tentar revive-lo
    -- Necessário porque a gente não tem um fluxo de morte/vida bem definido

    local workaroundStartedAt = GetGameTimer()

    while not exports["survival"]:IsLocalPlayerDead() and ( GetGameTimer() < ( workaroundStartedAt + 20000 ) ) do
        Wait( 0 )
    end

    local validationTime = GetGameTimer() - workaroundStartedAt
    sx.logger:debug( ('[X1] Estado de morte confirmado em %dms.'):format( validationTime ) )

    return validationTime
end

local function ensureX1Weapon()
    Wait( 600 )

    local weaponHash = GetHashKey( "WEAPON_PISTOL_MK2" )

    for _ = 1, 8 do
        if not InX1 then
            return false
        end

        local ped = PlayerPedId()

        if HasPedGotWeapon( ped, weaponHash, false ) then
            SetPedAmmo( ped, weaponHash, 250 )
            SetCurrentPedWeapon( ped, weaponHash, true )
            return true
        end

        if LocalPlayer.state["1x1"] then
            local equipped = exports["inventory"]:putWeaponHands( "WEAPON_PISTOL_MK2", 250, {}, false )

            if equipped and HasPedGotWeapon( ped, weaponHash, false ) then
                SetPedAmmo( ped, weaponHash, 250 )
                SetCurrentPedWeapon( ped, weaponHash, true )
                return true
            end
        end

        Wait( 250 )
    end

    sx.logger:error( ('[X1] Falha ao equipar WEAPON_PISTOL_MK2 apos 8 tentativas. route=%s state=%s'):format(
        tostring( LocalPlayer.state.Route ),
        tostring( LocalPlayer.state["1x1"] )
    ) )

    return false
end


RegisterNetEvent("1x1:pause")
AddEventHandler("1x1:pause",function()
    StartingX1 = false
    local Ped = PlayerPedId()
    FreezeEntityPosition(Ped,true)
end)

RegisterNetEvent("1x1:PreStart")
AddEventHandler("1x1:PreStart",function(Team,Table,TeamName,Type)
    InQueue = false
    local Ped = PlayerPedId()
    SetEntityCoords(Ped,X1Spawns[Type][Team][1]["x"],X1Spawns[Type][Team][1]["y"],X1Spawns[Type][Team][1]["z"],false,false,false,false)
    FreezeEntityPosition(Ped,true)
    TriggerEvent("Notify:Remkey",false)
end)


RegisterNetEvent("1x1:Start")
AddEventHandler("1x1:Start",function(Team,Table,TeamName,Type, diedThisRound )
    local roundStartedAt = GetGameTimer()
    local Ped = PlayerPedId()
    local Player = PlayerId()
    SetNuiFocus(false,false)
    TriggerEvent("admin:resetSpectate")
    SetEntityCoords(Ped,X1Spawns[Type][Team][1]["x"],X1Spawns[Type][Team][1]["y"],X1Spawns[Type][Team][1]["z"],false,false,false,false)
    FreezeEntityPosition(Ped,true)
    StartingX1 = true
    SetRunSprintMultiplierForPlayer(Player,1.10)
    SetEntityVisible(Ped,true)
    if not InX1 then
        TriggerEvent("1x1:StartNui",Table)
        InX1 = true

                
        CreateThread(function()
            while InX1 do
                DisableControlAction(0,140,true)
                DisableControlAction(0,141,true)
                DisableControlAction(0,142,true)
                Wait(1)
            end
        end)
        CreateThread(function()
            while InX1 do
                if IsControlJustPressed(0,47) then
                    TriggerServerEvent("1x1:LeaveMatch")
                    break
                end
                Wait(1)
            end
        end)
        LocalPlayer["state"]["InX1"] = true
        CreateThread(function()
            local Ped = PlayerPedId()
            while InX1 do
                local Health = parseInt(GetEntityHealth(Ped))
                SendNUIMessage({
                    action = 'UpdateHealth',
                    data = Health
                })
                Wait(250)
            end
        end)
        -- Thread para restringir movimento quando morto durante x1
        CreateThread(function()
            while InX1 do
                local Ped = PlayerPedId()
                if exports["survival"]:IsLocalPlayerDead() then
                    -- Congela o jogador quando morto durante o x1
                    FreezeEntityPosition(Ped, true)

                elseif StartingX1 then
                    -- Mantém congelado durante StartingX1 (esperando próximo round)
                    FreezeEntityPosition(Ped, true)
                
                else
                    -- Remove o freeze apenas quando não está morto e não está em StartingX1
                    FreezeEntityPosition(Ped, false)
                
                end
                Wait(100)
            end
        end)
        TriggerEvent("hud:Active",false)
        TriggerEvent("Notify:Remkey" ,true)
        TriggerEvent("safezone:remPromo",true)
    else
        TriggerEvent("1x1:NewRound",Table)
    end
    SetEntityCollision(Ped,true,true)

    if diedThisRound then

        validateDeathState( )

    end

    exports["survival"]:Revive(400)
    SetPedSuffersCriticalHits(Ped, true)
    Wait(100)
    ClearPedTasks(Ped)
    TriggerEvent("hud:Active",false)
    TriggerEvent("Notify:Remkey",true)
    ensureX1Weapon()
    -- Garante que o jogador continue congelado após revive (igual aos outros que não morreram)
    FreezeEntityPosition(Ped, true)
    local remainingCountdown = 5000 - ( GetGameTimer() - roundStartedAt )
    if remainingCountdown > 0 then
        Wait( remainingCountdown )
    end
    if StartingX1 then
        StartingX1 = false
        FreezeEntityPosition(Ped,false)
    end 
end)

RegisterNetEvent("1x1:Update")
AddEventHandler("1x1:Update",function(Table)
    SendNUIMessage({
        action = 'setVisible',
        data = "gameplay-versus"
    })
     Wait(100)
    SendNUIMessage({
        action = 'UpdateGameStats',
        data = Table
    })
end)

AddEventHandler("1x1:NewRound",function(Table)
    local Ped = PlayerPedId()
    TriggerEvent("admin:resetSpectate")
    SetEntityCollision(Ped,true,true)
    SendNUIMessage({
        action = 'setVisible',
        data = "countdown-versus"
    })
    Wait(5000)
    SendNUIMessage({
        action = 'setVisible',
        data = "gameplay-versus"
    })
     Wait(100)
    SendNUIMessage({
        action = 'UpdateGameStats',
        data = Table
    })
end)

AddEventHandler("1x1:StartNui",function(Table)
    Wait(100)
    SendNUIMessage({
        action = 'setVisible',
        data = "countdown-versus"
    })
    
    Wait(5000)

    SendNUIMessage({
        action = 'setVisible',
        data = "gameplay-versus"
    })

    Wait(100)
    SendNUIMessage({
        action = 'UpdateGameStats',
        data = Table
    })
end)

CreateThread(function()
    local Ped = PlayerPedId()
    while true do
        local Idle = 2500
        if InX1 then
            Idle = 250
            local Health = parseInt(GetEntityHealth(Ped))
            SendNUIMessage({
                action = 'UpdateHealth',
                data = Health
            })
        end
        Wait(Idle)
    end
end)

AddEventHandler("gameEventTriggered",function(name,args)

    if not InX1 then
        return
    end

    if name ~= "CEventNetworkEntityDamage" then
        return
    end

    local Victim = PlayerPedId()
    
    if args[1] ~= Victim then
        return
    end

    local Attacker = tonumber(args[2])
    local VictimDied = GetEntityHealth(Victim) <= 100
    local Weapon = tostring(args[7])
    if VictimDied then
        if IsEntityAPed(Victim) then
            if IsPedAPlayer(Attacker) then
                local KillerServerId = GetPlayerServerId((NetworkGetPlayerIndexFromPed(Attacker)))

                TriggerServerEvent( 'warsystem:i_died', KillerServerId, Weapon )
            end
        end
    end
end)

RegisterNetEvent("1x1:Finish", function(gDiedThisRound)
    local Ped = PlayerPedId( )
    local Player = PlayerId( )
    local validationTime = 100

    SendNUIMessage({
        action = 'setVisible',
        data = false
    })

    --- [ Gambiarra necessária para identificar o morto e validar a morte apenas no morto, não para todos, como anteriormente.  ]
    if GetPlayerServerId(Player) == gDiedThisRound then 

        validationTime = validateDeathState( )     
        sx.logger:debug( ('[X1] Validacao de morte no fim levou %dms.'):format( validationTime ) )

    end
    


    Wait(validationTime)

    exports.survival:Revive( 400 )

    SetPedRelationshipGroupHash( Ped, `PLAYER` )

    TriggerEvent( "Notify:Remkey", false )
    TriggerEvent( "safezone:remPromo", false )
    TriggerEvent( "hud:Active" ,true )

    SetEntityCoords( Ped, 207.05, -960.36, 29.76, 141.74 ) 
    SetRunSprintMultiplierForPlayer( Player, 1.10 )

    ClearPedTasks( Ped )
    FreezeEntityPosition( Ped, false )

    --- Necessário porque a gente não tem um fluxo de morte/vida 
    --- bem definido quando esta no PVP de arena / x1

    
    InX1 = false
    LocalPlayer.state.InX1 = false

    SetTimeout(1000, function()
        exports.combatsystem:RemoveCombat( eCombatReasons.DEATH, { removeAll = true } )
    end)
end)

RegisterNetEvent("1x1:KillFeed")
AddEventHandler("1x1:KillFeed",function(KillerName,VictimName,Weapon,Kills)
    SendNUIMessage({
        action = 'KillFeed',
        data = { 
            killerName = KillerName,
            victimName = VictimName,
            weapon = Weapon,
            duration = 2500,
        }
    })
    SendNUIMessage({
        action = 'UpdateKills',
        data = Kills
    })
end)


RegisterNetEvent("1x1:StartQueue")
AddEventHandler("1x1:StartQueue",function()
    SendNUIMessage({
        action = 'setVisible',
        data = "versus-queue"
    })
    InQueue = true
    CreateThread(function()
        while InQueue do
            if IsControlJustPressed(0,38) then
                InQueue = false
                SendNUIMessage({
                    action = 'setVisible',
                    data = false
                })
                TriggerServerEvent("1x1:LeaveQueue")
            end
            Wait(1)
        end
    end)
end)


RegisterNetEvent("1x1:UpdateQueue")
AddEventHandler("1x1:UpdateQueue",function(Table)
    SendNUIMessage({
        action = 'setVisible',
        data = "versus-queue"
    })
    Wait(100)
    SendNUIMessage({
        action = 'UpdateQueue',
        data = Table
    })
end)

CreateThread(function()
    if LocalPlayer.state["1x1"] then
            --- [ Gambiarra necessária para identificar o morto e validar a morte apenas no morto, não para todos, como anteriormente.  ]
        local Player = PlayerId()
        local validationTime = 100
        local Ped = PlayerPedId()
        local Health = parseInt(GetEntityHealth(Ped))
        if Health <= 101 then
            if GetPlayerServerId(Player) then 

                validationTime = validateDeathState( )     
                sx.logger:debug( ('[X1] Validacao de morte no recovery levou %dms.'):format( validationTime ) )

            end
        end

        Wait(validationTime)

        exports.survival:Revive( 400 )

        SetPedRelationshipGroupHash( Ped, `PLAYER` )

        TriggerEvent( "Notify:Remkey", false )
        TriggerEvent( "safezone:remPromo", false )
        TriggerEvent( "hud:Active" ,true )

        SetEntityCoords( Ped, 207.05, -960.36, 29.76, 141.74 ) 
        SetRunSprintMultiplierForPlayer( Player, 1.10 )

        ClearPedTasks( Ped )
        FreezeEntityPosition( Ped, false )
        TriggerServerEvent("x1:Restarted")
        
        SetTimeout(1000, function()
            exports.combatsystem:RemoveCombat( eCombatReasons.DEATH, { removeAll = true } )
        end)
    end
end)
