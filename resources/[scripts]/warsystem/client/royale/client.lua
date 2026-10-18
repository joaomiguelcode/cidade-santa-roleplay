
---@class battleroyale.ClientSafezone : battleroyale.Safezone
---@field rendererZone table
---@field damageUpdateTimer number

---@type battleroyale.ClientSafezone | nil
local gSafezone = nil

---@return battleroyale.ClientSafezone
local function GetSafezone()

    assert( gSafezone, 'Safezone not created' )

    return gSafezone
end

---@param fc       number
---@param safezone battleroyale.ClientSafezone
local function UpdateSafezoneRenderer( fc, safezone )

    safezone.rendererZone:setRadius( GetCurrentSafezoneTransitionRadius( safezone ) )
    safezone.rendererZone:draw()
end

---@param safezone battleroyale.ClientSafezone
local function UpdateSafezone( safezone )

    -- Melhorar isso?
    if LocalPlayer[ 'state' ][ 'Route' ] == 1 then
        return
    end

    UpdateSafezoneRenderer( GetFrameCount(), safezone )

    safezone.damageUpdateTimer += GetFrameTime()

    if safezone.damageUpdateTimer >= BATTLEROYALE_DAMAGE_UPDATE_INTERVAL_SECONDS  then

        safezone.damageUpdateTimer = 0

        local pedId  = PlayerPedId()
        local pedPos = GetEntityCoords( pedId )

        -- ENG-3870: staff isento segue em servico vendo a safe, sem tomar o dano dela.
        if not safezone.rendererZone:isPointInside( pedPos ) and not exports.admin:IsUsingFreecam()
            and not LocalPlayer.state.staffOnDuty then

            SetEntityHealth( pedId, GetEntityHealth( pedId ) - 13 )
        end
    end
end

local function CreateSafezoneMainThread()

    CreateThread(function()

        while true do

            local safezone = gSafezone

            if not safezone then
                return
            end

            UpdateSafezone( safezone )

            Wait(0)
        end
    end)

    local Ped = PlayerPedId()

    -- CreateThread(function()
    --     while true do

    --         local safezone = gSafezone

    --         if not safezone then
    --             return
    --         end

    --         local Coords = GetEntityCoords(Ped)
    --         local PlayerVehicle = GetVehiclePedIsIn(Ped)
    --         local Vehicles = GetGamePool('CVehicle')
    --         local Peds = GetGamePool('CPed')
    
    --         for i=1, #Vehicles do
    --             local Vehicle = Vehicles[i]
    --             if #(Coords - GetEntityCoords(Vehicle)) < 60.0 then
    --                 SetEntityNoCollisionEntity(Vehicle, PlayerVehicle, true)
    --                 if Vehicle ~= PlayerVehicle then
    --                     SetEntityNoCollisionEntity(Vehicle, Ped, true)
    --                 end
    --             end
    --         end

    --         for i=1,#Peds do
    --             local SelectedPed = Peds[i]
    --             if #(Coords - GetEntityCoords(SelectedPed)) < 60.0 then
    --                 SetEntityNoCollisionEntity(SelectedPed, Ped, true)
    --             end
    --         end
    
    --         Wait(1)
    --     end
    -- end)
end

---@return battleroyale.ClientSafezone
local function GetOrCreateSafezone()

    local safezone = gSafezone

    if not safezone then

        local rendererZone = CircleZone:Create( 
            vector3( 0.0, 0.0, 0.0 ),
            0.0,
            {
                name = 'Zone',
                useZ = true,
                debugPoly = false,
                debugColor = { 0 ,0, 255, 200 },
            }
        )

        ---@type battleroyale.ClientSafezone
        safezone =
        {
            isPaused    = false,

            transitionStartedAt = 0,
            transitionStateFrom = { position = vector3(0, 0, 0), radius = 0.0 },
            transitionStateTo   = { position = vector3(0, 0, 0), radius = 0.0 },

            transitionPausedAt = nil,

            rendererZone = rendererZone,

            damageUpdateTimer = 0,
        }

        gSafezone = safezone

        CreateSafezoneMainThread()
    end

    return safezone
end

function DestroySafezone()

    local safezone = gSafezone

    if not safezone then
        return
    end

    safezone.rendererZone:destroy()

    gSafezone = nil

    -- print('Safezone destroyed')
end

---@param safezone battleroyale.ClientSafezone
---@param transitionStartedAt number
---@param transitionStateFrom battleroyale.SafezoneTransitionState
---@param transitionStateTo   battleroyale.SafezoneTransitionState
---@param transitionDuration  number
function OnSafezoneTransitionStarted( safezone, transitionStartedAt, transitionStateFrom, transitionStateTo, transitionDuration )

    safezone.transitionStartedAt = transitionStartedAt
    safezone.transitionStateFrom = transitionStateFrom
    safezone.transitionStateTo   = transitionStateTo
    safezone.transitionDuration = transitionDuration

    safezone.rendererZone:setCenter( transitionStateFrom.position )
    safezone.rendererZone:setRadius( transitionStateFrom.radius   )
end

---@param safezone battleroyale.ClientSafezone
---@param isPaused           boolean
---@param transitionPausedAt number | nil
function OnSafezonePausedStateChanged( safezone, isPaused, transitionPausedAt )

    safezone.isPaused = isPaused
    safezone.transitionPausedAt = transitionPausedAt
end

---@param packet battleroyale.SafezoneTransitionStartedPacket
RegisterNetEvent( 'battleroyale:safezone_transition_started', function ( packet )

    OnSafezoneTransitionStarted(
        GetOrCreateSafezone(),
        packet.transitionStartedAt,
        {
            position = packet.transitionStateFromPosition,
            radius = packet.transitionStateFromRadius,
        },
        {
            position = packet.transitionStateToPosition,
            radius = packet.transitionStateToRadius,
        },
        packet.transitionDuration
    )

    OnSafezonePausedStateChanged( GetSafezone(), false, nil )
end)

---@param packet battleroyale.SafezonePausedStateChangedPacket
RegisterNetEvent( 'battleroyale:safezone_paused_state_changed', function ( packet )

    OnSafezonePausedStateChanged(
        GetSafezone(),

        packet[ 1 ],
        packet[ 2 ]
    )
end)

---@param event NetworkSafezoneDeletedEvent | nil
RegisterNetEvent( 'battleroyale:safezone_deleted', function ( event )

    local reason = event
        and event[ 1 ]
        or  eSafezoneDeletedReason.UNKNOWN

    DestroySafezone()

    if reason == eSafezoneDeletedReason.COMMAND_DELETE then
        
        exports["survival"]:Revive( 400 )

        TriggerEvent( 'Notify', 'vermelho', 'Voce foi removido do <b>Evento Royale</b>.', 8000, 'ROYALE' )
        TriggerEvent( 'admin:Teleport', TELEPORT_DEATH )
    end
end)

AddEventHandler( 'onResourceStop', function( resourceName )

    if resourceName == GetCurrentResourceName() then

        DestroySafezone()
    end
end)

AddEventHandler("gameEventTriggered",function(name,args)

    if not gSafezone then
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

        local KillerServerId = KillerServerId ~= -1 and GetPlayerServerId((NetworkGetPlayerIndexFromPed(Attacker))) or nil

        TriggerServerEvent("royale:killFeed",KillerServerId)
    end
end)

exports( 'IsParticipatingInBattleRoyale', function( )

    return gSafezone ~= nil
end)
