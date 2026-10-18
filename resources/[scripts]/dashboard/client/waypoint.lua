local PREVIEW_OFFER_ID = 'debug-waypoint'
local CONTROL_GROUP = 0
local PAUSE_CONTROL = 200
local CANCEL_CONTROL = 322

local gOfferId
local gFocusAbort

local function CloseWaypoint()

    if not gOfferId then return end
    SendNUIMessage({ action = 'waypoint:close', data = { offerId = gOfferId } })
    gOfferId = nil

    if gFocusAbort then gFocusAbort(); gFocusAbort = nil end
    SetNuiFocus( false, false )
end

local function HoldWaypointFocus()

    DisableControlAction( CONTROL_GROUP, PAUSE_CONTROL, true )
    DisableControlAction( CONTROL_GROUP, CANCEL_CONTROL, true )

    if not IsNuiFocused() then SetNuiFocus( true, true ) end
end

---@param offerId string
---@return boolean
function Client.OpenWaypoint( offerId )

    if type( offerId ) ~= 'string' or offerId == '' then return false end
    if gOfferId then return gOfferId == offerId end
    if IsNuiFocused() or IsPauseMenuActive() then return false end
    gOfferId = offerId
    SetNuiFocusKeepInput( false )
    SetNuiFocus( true, true )
    SendNUIMessage({ action = 'waypoint:open', data = { offerId = offerId } })
    gFocusAbort = sx.script.setTick( HoldWaypointFocus )
    return true
end

RegisterNetEvent( 'dashboard:waypoint:preview', function()

    Client.OpenWaypoint( PREVIEW_OFFER_ID )
end )

---@param data table
---@return boolean
local function IsCurrentOffer( data )

    return type( data ) == 'table' and type( data.offerId ) == 'string'
        and gOfferId ~= nil and data.offerId == gOfferId
end

---@param name string
---@param request function
---@return boolean
local function RequestWaypoint( name, request )

    local success, response = pcall( request )

    if not success then
        sx.logger:warn( ( 'waypoint: callback=%s error=%s' ):format( name, tostring( response ) ) )
        return false
    end

    return type( response ) == 'table' and response.ok == true
end

RegisterNUICallback( 'waypoint:getState', function( _, callback )

    callback({ offerId = gOfferId })
end )

RegisterNUICallback( 'waypoint:shown', function( data, callback )

    if not IsCurrentOffer( data ) then callback({ ok = false }); return end
    if gOfferId == PREVIEW_OFFER_ID then callback({ ok = true }); return end
    local ok = RequestWaypoint( 'shown', function() return vSERVER.WaypointShown( data.offerId ) end )
    callback({ ok = ok })
end )

RegisterNUICallback( 'waypoint:choice', function( data, callback )

    if not IsCurrentOffer( data ) or type( data.accepted ) ~= 'boolean' then
        callback({ ok = false })
        return
    end

    if gOfferId == PREVIEW_OFFER_ID then
        CloseWaypoint()
        callback({ ok = true })
        return
    end

    local ok = RequestWaypoint( 'choice', function() return vSERVER.WaypointChoice( data.offerId, data.accepted ) end )

    if ok and gOfferId == data.offerId then CloseWaypoint() end
    callback({ ok = ok })
end )

RegisterNetEvent( 'dashboard:waypoint:close', function( offerId )

    if gOfferId == offerId then CloseWaypoint() end
end )

RegisterNetEvent( 'dashboard:waypoint:markSquare', function( x, y )

    SetNewWaypoint( x, y )
    TriggerEvent( 'Notify2', '#marcaGPS' )
end )

AddEventHandler( 'onClientResourceStop', function( resource )

    if resource == GetCurrentResourceName() or resource == 'hud' then CloseWaypoint() end
end )
