local COMBAT_CHECK_INTERVAL = 1000

local gCombatData = nil
local gCombatHandle = nil

---@class combatsystem.IsInCombatOptions
---@field showHint? boolean

---@param options? combatsystem.IsInCombatOptions
---@return boolean
local function IsInCombat( options )

    if gCombatData?.reason and options?.showHint then

        local currentTime = GetNetworkTimeAccurate( )
        local remaining   = gCombatData?.expireAt - currentTime
        
        local timeLeft = math.floor( remaining / 1000 )
        local reasonCombat = ('#combatsystem.reasons.%s.hintText'):format( gCombatData.reason:lower() )

        if gCombatData.isInfinite then

            -- mode combat is infinite ?

            TriggerEvent( 'Notify2', '#combatsystem.in_combat_infinite_with_reason', { 
                reason = reasonCombat
            })

        else
            
            TriggerEvent( 'Notify2', '#combatsystem.in_combat_with_reason', { 
                msg = timeLeft,
                reason = reasonCombat
            })
        end

    end 

    -- sx.logger:debug( ('IsInCombat :: Player is in combat: %s'):format( json.encode( gCombatData, { indent = true } ) ) )

    return gCombatData?.reason ~= nil
end

---@param reason combatsystem.CombatReason
local function SetInCombat( reason )

    assert( reason, 'reason is required' )

    -- sx.logger:debug( ('SetInCombat :: Player is setting combat for reason %s'):format( reason ) )

    if exports.safezone:IsAnyZone( GetEntityCoords( PlayerPedId() ) ) then
        return
    end

    TriggerServerEvent( 'net.combatsystem.setInCombat', reason )
end

---@class combatsystem.RemoveCombatOptions
---@field removeAll? boolean

---@param reason combatsystem.CombatReason
---@param options? combatsystem.RemoveCombatOptions
local function RemoveCombat( reason, options )

    assert( reason, 'reason is required' )

    -- sx.logger:debug( ('RemoveCombat :: Removing combat reason %s'):format( reason ) )

    TriggerServerEvent( 'net.combatsystem.removeCombat', reason, options )
end

---@param expireAt number
---@param isInfinite boolean
local function CombatHandleTick( expireAt, isInfinite )

    if isInfinite then
        return
    end
    if GetNetworkTimeAccurate( ) >= expireAt then

        gCombatData = nil

        TriggerServerEvent( 'net.combatsystem.combatExpired' )
        TriggerEvent( 'Notify2', '#combatsystem.combat_expired' )
        sx.logger:debug('combatsystem expired -> hud.combatsystem.enable false')
        TriggerEvent( 'hud.combatsystem.enable', false )

        gCombatHandle = nil
    end

end 

---@param data CombatData
RegisterNetEvent( 'net.combatsystem.updateCombat', function( data )

    gCombatData = data
    sx.logger:debug( ('updateCombat received hasData=%s'):format( tostring( data ~= nil ) ) )
    if not gCombatData then

        sx.logger:debug('updateCombat -> hud.combatsystem.enable false')
        TriggerEvent( 'hud.combatsystem.enable', false )
        gCombatHandle = nil

        return
    end

    sx.logger:debug('updateCombat -> hud.combatsystem.enable true')
    TriggerEvent( 'hud.combatsystem.enable', true )

    gCombatHandle = sx.script.setTick(
        function( )

            if not gCombatData?.reason then
                return
            end

            CombatHandleTick( gCombatData?.expireAt, gCombatData?.isInfinite )
        end
    )
    
end)

exports( 'SetInCombat'    , SetInCombat    )
exports( 'IsInCombat'     , IsInCombat     )
exports( 'RemoveCombat'   , RemoveCombat   )
