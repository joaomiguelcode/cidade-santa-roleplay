-- NUI bridge for the Ranking Gente Boa visual-effects toggle. The preference lives in this client's KVP;
-- social_ranking republishes it through the rank bags and applies it to both the particle and title.

local SOCIAL_RANKING_RESOURCE = 'social_ranking'
local PED_EFFECTS_KVP_KEY = 'gente_boa_ped_effects_enabled'

---@return boolean
local function IsSocialRankingStarted()
    return GetResourceState( SOCIAL_RANKING_RESOURCE ) == 'started'
end

---@return boolean
local function GetPedEffectsEnabled()
    return GetResourceKvpString( PED_EFFECTS_KVP_KEY ) ~= 'false'
end

---@param enabled boolean
---@return nil
local function PublishPedEffectsPreference( enabled )

    if IsSocialRankingStarted() then
        TriggerServerEvent( 'social_ranking:setPedEffectsEnabled', enabled )
    end
end

RegisterNUICallback( 'getGenteBoaPedEffects', function( _, callback )

    if not IsSocialRankingStarted() then
        return callback( { available = false, enabled = GetPedEffectsEnabled() } )
    end

    local success, state = pcall( function()
        return exports[ SOCIAL_RANKING_RESOURCE ]:GetPedEffectsState()
    end )

    if not success or type( state ) ~= 'table' or type( state.available ) ~= 'boolean' then
        return callback( { available = false, enabled = GetPedEffectsEnabled() } )
    end

    callback( {
        available = state.available,
        enabled = GetPedEffectsEnabled(),
    } )
end )

RegisterNUICallback( 'setGenteBoaPedEffects', function( data, callback )

    local enabled = data and data.enabled
    if type( enabled ) ~= 'boolean' then
        return callback( { ok = false } )
    end

    SetResourceKvp( PED_EFFECTS_KVP_KEY, tostring( enabled ) )
    PublishPedEffectsPreference( enabled )

    callback( { ok = true } )
end )

AddEventHandler( 'onClientResourceStart', function( resourceName )

    if resourceName == GetCurrentResourceName() or resourceName == SOCIAL_RANKING_RESOURCE then
        PublishPedEffectsPreference( GetPedEffectsEnabled() )
    end
end )
