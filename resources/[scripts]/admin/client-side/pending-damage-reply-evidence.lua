local HISTORY_MAX = 64
local HISTORY_WINDOW_MS = 3000
local MAX_CANDIDATES = 12
local DAMAGE_STATE_SAMPLE_INTERVAL_MS = 50

local REQUEST_EVENT = 'admin:pendingDamageReplyEvidence:request'
local RESPONSE_EVENT = 'admin:pendingDamageReplyEvidence:response'

local gunShotHistory = { }
local damageStateHistory = { }

---@param nativeValue boolean | number | nil
---@return boolean | nil booleanValue
local function MapNativeBooleanValue( nativeValue )

    if type( nativeValue ) == 'boolean' then
        return nativeValue
    end

    if nativeValue == 0 then
        return false
    end

    if nativeValue == 1 then
        return true
    end

    return nil
end

local function NetworkTime()
    if GetNetworkTimeAccurate then
        return GetNetworkTimeAccurate() & 0xFFFFFFFF
    end

    return GetNetworkTime() & 0xFFFFFFFF
end

local function NetworkDelta( first, second )
    if not first or not second then
        return 0x7FFFFFFF
    end

    local forward = ( first - second ) & 0xFFFFFFFF
    local reverse = ( second - first ) & 0xFFFFFFFF

    return math.min( forward, reverse )
end

local function PlayerSourceFromPed( ped )
    local playerIndex = NetworkGetPlayerIndexFromPed( ped )

    if playerIndex == -1 then
        return nil
    end

    return GetPlayerServerId( playerIndex )
end

---@param entity number
---@return number | nil ownerSource
local function EntityOwnerSource( entity )
    local ownerPlayerIndex = NetworkGetEntityOwner( entity )

    if ownerPlayerIndex == -1 then
        return nil
    end

    return GetPlayerServerId( ownerPlayerIndex )
end

---@param entity number
---@return table proofs
local function EntityProofs( entity )
    local _, bulletProof, _, _, collisionProof = GetEntityProofs( entity )

    return {
        bullet = MapNativeBooleanValue( bulletProof ),
        collision = MapNativeBooleanValue( collisionProof ),
    }
end

---@param entity number
---@return boolean invincible
local function EntityInvincibleState( entity )

    return Citizen.InvokeNative(
        0xC1213506D205EB3F,
        entity,
        Citizen.ResultAsInteger()
    ) == 1
end

---@param playerIndex number
---@param ped number
---@return table damageState
local function PlayerDamageState( playerIndex, ped )

    assert( playerIndex ~= -1, 'Expected local victim player index' )
    assert( DoesEntityExist( ped ), 'Expected local victim ped to exist' )

    local canBeDamaged

    -- This native is not available in every client runtime. Keep the field
    -- best-effort instead of failing the evidence response when it is absent.
    if type( GetEntityCanBeDamaged ) == 'function' then
        canBeDamaged = MapNativeBooleanValue( GetEntityCanBeDamaged( ped ) )
    end

    return {
        invincible = MapNativeBooleanValue( GetPlayerInvincible( playerIndex ) ),
        entityInvincible = EntityInvincibleState( ped ),
        collisionDisabled = MapNativeBooleanValue( GetEntityCollisionDisabled( ped ) ),
        canBeDamaged = canBeDamaged,
        weaponDefenseModifier = GetPlayerWeaponDefenseModifier( playerIndex ),
        weaponDefenseModifier2 = GetPlayerWeaponDefenseModifier_2( playerIndex ),
        entityOwnerSource = EntityOwnerSource( ped ),
        proofs = EntityProofs( ped ),
    }
end

---@return table clientDamageState
local function CaptureClientDamageState()
    local victimPlayerIndex = PlayerId()
    local victimPed = PlayerPedId()
    local victim = PlayerDamageState( victimPlayerIndex, victimPed )

    victim.invincibleStateBag = LocalPlayer["state"]["Invincible"] == true

    return victim
end

local function RecordClientDamageState()

    table.insert( damageStateHistory, {
        observedAt = GetGameTimer(),
        networkTime = NetworkTime(),
        state = CaptureClientDamageState(),
    } )

    while #damageStateHistory > HISTORY_MAX do
        table.remove( damageStateHistory, 1 )
    end
end

local function ClosestVictimDamageState( damageTime, now )
    local closest
    local closestDelta = 0x7FFFFFFF

    for i = #damageStateHistory, 1, -1 do
        local entry = damageStateHistory[i]

        if entry.observedAt + HISTORY_WINDOW_MS < now then
            table.remove( damageStateHistory, i )
        else
            local delta = NetworkDelta( entry.networkTime, damageTime )

            if delta < closestDelta then
                closest = entry
                closestDelta = delta
            end
        end
    end

    if not closest then
        return nil
    end

    closest.state.networkTime = closest.networkTime

    return closest.state
end

local function WeaponFromAttacker( attackerPed )
    return GetSelectedPedWeapon( attackerPed ) & 0xFFFFFFFF
end

local function DoRay( origin, target, attackerPed )
    local ray = StartShapeTestRay(
        origin.x, origin.y, origin.z,
        target.x, target.y, target.z,
        511,
        attackerPed,
        7
    )

    local status, entityHit

    repeat
        local resultStatus, _, _, _, resultEntityHit = GetShapeTestResult( ray )
        status = resultStatus
        entityHit = resultEntityHit

        if status == 1 then
            Wait( 0 )
        end
    until status ~= 1

    local victimPed = PlayerPedId()

    return {
        completed = status == 0 or status == 2,
        entityIsVictim = entityHit == victimPed,
    }
end

local function CaptureRaycast( entry )
    local attackerPed = entry.attackerPed
    local victimPed = PlayerPedId()
    local origin = GetPedBoneCoords( attackerPed, 57005, 0.0, 0.0, 0.0 )
    local head = GetPedBoneCoords( victimPed, 31086, 0.0, 0.0, 0.0 )
    local chest = GetPedBoneCoords( victimPed, 24816, 0.0, 0.0, 0.0 )

    entry.raycast = {
        head = DoRay( origin, head, attackerPed ),
        chest = DoRay( origin, chest, attackerPed ),
    }
end

local function RecordGunShot( attackerPed )
    local victimPed = PlayerPedId()
    local attackerCoords = GetEntityCoords( attackerPed )
    local victimCoords = GetEntityCoords( victimPed )

    local entry = {
        observedAt = GetGameTimer(),
        networkTime = NetworkTime(),
        attackerSource = PlayerSourceFromPed( attackerPed ),
        victimSource = GetPlayerServerId( PlayerId() ),
        weaponHash = WeaponFromAttacker( attackerPed ),
        attackerPed = attackerPed,
        attackerCoords = attackerCoords,
        victimCoords = victimCoords,
    }

    CreateThread( function()
        CaptureRaycast( entry )
        table.insert( gunShotHistory, entry )

        while #gunShotHistory > HISTORY_MAX do
            table.remove( gunShotHistory, 1 )
        end
    end )
end

local function CandidateFor( entry, request, now )
    return entry.observedAt + HISTORY_WINDOW_MS >= now and
        entry.victimSource == request.victimSource and
        entry.attackerSource == request.attackerSource and
        entry.weaponHash == request.weaponHash
end

local function SerializeRay( ray )
    if not ray then
        return nil
    end

    return {
        completed = ray.completed,
        entityIsVictim = ray.entityIsVictim,
    }
end

local function Serialize( entry )
    return {
        networkTime = entry.networkTime,
        attackerSource = entry.attackerSource,
        victimSource = entry.victimSource,
        weaponHash = entry.weaponHash,
        attackerCoords = entry.attackerCoords,
        victimCoords = entry.victimCoords,
        raycast = {
            head = SerializeRay( entry.raycast and entry.raycast.head ),
            chest = SerializeRay( entry.raycast and entry.raycast.chest ),
        },
    }
end

RegisterNetEvent( REQUEST_EVENT, function( requestId, request )
    local now = GetGameTimer()
    local candidates = { }

    assert(
        request.victimSource == GetPlayerServerId( PlayerId() ),
        'Expected pending damage reply evidence request for the local victim'
    )

    for i = #gunShotHistory, 1, -1 do
        local entry = gunShotHistory[i]

        if entry.observedAt + HISTORY_WINDOW_MS < now then
            table.remove( gunShotHistory, i )
        elseif CandidateFor( entry, request, now ) then
            table.insert( candidates, entry )
        end
    end

    table.sort( candidates, function( first, second )
        return NetworkDelta( first.networkTime, request.damageTime ) <
            NetworkDelta( second.networkTime, request.damageTime )
    end )

    local response = {
        requestId = requestId,
        candidates = { },
        clientState = ClosestVictimDamageState( request.damageTime, now ),
    }

    for i = 1, math.min( MAX_CANDIDATES, #candidates ) do
        table.insert( response.candidates, Serialize( candidates[i] ) )
    end

    TriggerServerEvent( RESPONSE_EVENT, response )
end )

CreateThread( function()
    while true do
        RecordClientDamageState()
        Wait( DAMAGE_STATE_SAMPLE_INTERVAL_MS )
    end
end )

AddEventHandler( 'CEventGunShot', function( _, attackerPed )
    if not DoesEntityExist( attackerPed ) or not IsPedAPlayer( attackerPed ) then
        return
    end

    RecordGunShot( attackerPed )
end )
