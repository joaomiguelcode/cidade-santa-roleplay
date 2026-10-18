local gStaffState
local gStaffCollapsed = false
local gStaffHubOpen = false
-- ENG-3972: o mapa (P/ESC) cobre a tela como o hub; o card e o banner da próxima somem até ele fechar.
local gStaffMapOpen = false
local gStaffReceivedAt = 0
local gMarkedRouteSignature

local function MapTargets()
    if not gStaffState then return { } end
    if gStaffState.next and gStaffState.next.peakActive
        and #( gStaffState.next.factions or { } ) >= 2 then
        return gStaffState.next.factions
    end
    if #( gStaffState.focuses or { } ) >= 2 then
        return gStaffState.focuses
    end
    local target = gStaffState.next or gStaffState.focus
    return target and { target } or { }
end

local function MapSignature( targets )
    local parts = { }
    for _, target in ipairs( targets ) do
        local position = target.waypoint or { }
        parts[ #parts + 1 ] = ( '%s:%s:%s:%s' ):format( tostring( target.focusId or target.faction ), tostring( position.x ), tostring( position.y ), tostring( position.z ) )
    end
    return table.concat( parts, '|' )
end

local function ClearStaffRoute()
    if not gMarkedRouteSignature then return end
    ClearGpsMultiRoute()
    gMarkedRouteSignature = nil
end

local function Send()
    if gMarkedRouteSignature and gMarkedRouteSignature ~= MapSignature( MapTargets() ) then ClearStaffRoute() end
    local state = { }
    for key, value in pairs( gStaffState or { } ) do state[ key ] = value end
    if state.serverNowMs then state.serverNowMs = state.serverNowMs + GetGameTimer() - gStaffReceivedAt end
    state.collapsed = gStaffCollapsed
    if gStaffHubOpen or gStaffMapOpen then state = { } end
    TriggerEvent( 'dashboard:factionFocus', { action = 'factionFocusStaff:state', data = state } )
end

RegisterNetEvent( 'hud:factionFocusStaff', function( _, state )
    if type( state ) ~= 'table' then return end
    local oldFocus = gStaffState and gStaffState.focus and gStaffState.focus.focusId
    local oldNext = gStaffState and gStaffState.next and gStaffState.next.announcedAt
    if state.focuses then
        local before, after = { }, { }
        for _, focus in ipairs( gStaffState and gStaffState.focuses or { } ) do before[ #before + 1 ] = focus.focusId end
        for _, focus in ipairs( state.focuses ) do after[ #after + 1 ] = focus.focusId end
        if table.concat( before, ',' ) ~= table.concat( after, ',' ) then gStaffCollapsed = false end
    end
    if ( state.focus and state.focus.focusId ~= oldFocus ) or ( state.next and state.next.announcedAt ~= oldNext ) then
        gStaffCollapsed = false
    end
    gStaffState = ( state.focus or state.next ) and state or nil
    gStaffReceivedAt = GetGameTimer()
    Send()
end )

local function HandleKey( key )
    if not gStaffState or gStaffHubOpen or gStaffMapOpen then return false end
    if key == 'F11' then
        gStaffCollapsed = not gStaffCollapsed
        Send()
        return true
    end
    if key == 'Q' then
        if gStaffCollapsed then return false end
        local targets = MapTargets()
        local hasAllWaypoints = true
        for _, target in ipairs( targets ) do
            if not target.waypoint then hasAllWaypoints = false break end
        end
        if #targets >= 2 and hasAllWaypoints then
            ClearStaffRoute()
            SetWaypointOff()
            StartGpsMultiRoute( 12, true, true )
            for _, target in ipairs( targets ) do
                local location = target.waypoint
                AddPointToGpsMultiRoute( location.x, location.y, location.z )
            end
            SetGpsMultiRouteRender( true )
            gMarkedRouteSignature = MapSignature( targets )
            return true
        end
        ClearStaffRoute()
        local target = gStaffState.next or gStaffState.focus
        local location = target and target.waypoint
        if location then SetNewWaypoint( location.x, location.y ) end
        return true
    end
    return false
end

exports( 'HandleFactionFocusStaffKey', HandleKey )
exports( 'GetFactionFocusStaffState', function()
    TriggerServerEvent( 'hud:factionFocusStaff:request' )
    -- O evento assíncrono atualiza o relógio usando o horário atual do servidor.
    return { }
end )
AddEventHandler( 'hud:factionFocusStaff:hide', function() HandleKey( 'F11' ) end )
AddEventHandler( 'hud:factionFocusStaff:markLocation', function() HandleKey( 'Q' ) end )
AddEventHandler( 'hub:visibilityChanged', function( visible ) gStaffHubOpen = visible; Send() end )
AddEventHandler( 'hud:pauseMenu:visibilityChanged', function( visible ) gStaffMapOpen = visible == true; Send() end )

local function Refresh() TriggerServerEvent( 'hud:factionFocusStaff:request' ) end
RegisterNetEvent( 'net:routing_bucket_changed', function() gStaffState = nil; Send(); Refresh() end )
RegisterNetEvent( 'playerGroups:AddGroup', Refresh )
RegisterNetEvent( 'playerGroups:RemoveGroup', function() gStaffState = nil; Send(); Refresh() end )
AddEventHandler( 'onResourceStop', function( resource ) if resource == GetCurrentResourceName() then gStaffState = nil; Send() end end )
CreateThread( function() Wait( 3500 ); Refresh() end )
