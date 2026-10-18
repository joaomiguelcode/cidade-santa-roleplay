---@class FactionFocusPanelLocation
---@field x number
---@field y number
---@field z number

---@class FactionFocusPanelData
---@field factionName string
---@field setName string
---@field qg string
---@field time string
---@field batchRecruits integer
---@field batchTarget integer
---@field entryReason string
---@field online integer
---@field minimumOnline integer
---@field recruitersAtQG integer
---@field dailyRecruits integer
---@field dailyLimit integer
---@field lastRecruit string
---@field locationKey string
---@field actionKey string
---@field location FactionFocusPanelLocation

---@type FactionFocusPanelData|nil
local gFactionFocusPanelData
local gFactionFocusPanelOpen = false
local gFactionFocusPanelCollapsed = true
local DEFAULT_WORLD_BUCKET = 1
local ReconcileFactionFocusPanel

local function SendFactionFocusDashboardMessage( action, data )
    TriggerEvent( 'dashboard:factionFocus', {
        action = action,
        data = data,
    } )
end

---@param data unknown
---@return FactionFocusPanelData
local function AssertFactionFocusPanelData( data )

    fast_assert( type( data ) == 'table' or 'FactionFocus panel data must be a table' )

    fast_assert( type( data.location ) == 'table' or 'FactionFocus panel data must include a location' )

    fast_assert( type( data.location.x ) == 'number' or 'FactionFocus panel location.x must be a number' )

    fast_assert( type( data.location.y ) == 'number' or 'FactionFocus panel location.y must be a number' )

    fast_assert( type( data.location.z ) == 'number' or 'FactionFocus panel location.z must be a number' )
    
    return data
end

---@return boolean
local function IsInStandardWorld()
    return tonumber( LocalPlayer.state.Route ) == DEFAULT_WORLD_BUCKET
end

---@return boolean
local function CanViewFactionFocusPanel()
    local groups = vRP.GetPlayerGroups() or { }

    return IsInStandardWorld()
        and (
            groups[ 'WallStreet' ] ~= nil
            or groups[ 'Orgs' ] ~= nil
        )
end

local function CloseFactionFocusPanel()
    if not gFactionFocusPanelOpen then
        return
    end

    gFactionFocusPanelOpen = false
    gFactionFocusPanelCollapsed = true
    gFactionFocusPanelData = nil
    SendFactionFocusDashboardMessage( 'factionFocus:clear', nil )
end

---@param data FactionFocusPanelData
local function OpenFactionFocusPanel( data )
    data = AssertFactionFocusPanelData( data )

    if not CanViewFactionFocusPanel() then
        CloseFactionFocusPanel()
        return
    end

    gFactionFocusPanelData = data
    gFactionFocusPanelOpen = true
    gFactionFocusPanelCollapsed = false
    SendFactionFocusDashboardMessage( 'factionFocus:open', data )
end

---@param data FactionFocusPanelData
local function UpdateFactionFocusPanel( data )
    data = AssertFactionFocusPanelData( data )

    if not CanViewFactionFocusPanel() then
        CloseFactionFocusPanel()
        return
    end

    gFactionFocusPanelData = data
    SendFactionFocusDashboardMessage( 'factionFocus:update', data )
end

local function ToggleFactionFocusPanel()
    if exports.hud:HandleFactionFocusStaffKey( 'F11' ) then return end
    if exports.hud:HandleFactionFocusLeadershipKey( 'F11' ) then return end
    if exports.hud:HandleLegalFocusLeadershipKey( 'F11' ) then return end
    if not CanViewFactionFocusPanel() then
        return
    end

    if not gFactionFocusPanelOpen then
        ReconcileFactionFocusPanel( GlobalState[ 'FACTIONFOCUS_DISPLAY' ] )

        if gFactionFocusPanelOpen then
            -- sx.logger:debug( 'factionfocus: F11 reconciled panel from global state' )
            return
        end

        TriggerEvent( 'Notify', 'amarelo', _t( 'factionfocus.no_active' ), 5000, _t( 'factionfocus.no_active.title' ) )
        return
    end

    if gFactionFocusPanelCollapsed then
        fast_assert( gFactionFocusPanelData ~= nil or 'FactionFocus panel data is required while open' )
        gFactionFocusPanelCollapsed = false
        SendFactionFocusDashboardMessage( 'factionFocus:open', gFactionFocusPanelData )
        return
    end

    gFactionFocusPanelCollapsed = true
    SendFactionFocusDashboardMessage( 'factionFocus:close', nil )
end

local function MarkFactionFocusLocation()
    if GetResourceState( 'dminigames' ) == 'started' then
        local ok, handled = pcall( function()
            return exports.dminigames:HandleMatchCityQueueKey()
        end )
        if ok and handled == true then return end
    end
    if exports.hud:HandleFactionFocusStaffKey( 'Q' ) then return end
    if exports.hud:HandleFactionFocusLeadershipKey( 'Q' ) then return end
    if exports.hud:HandleLegalFocusLeadershipKey( 'Q' ) then return end
    if not gFactionFocusPanelOpen or gFactionFocusPanelCollapsed or not CanViewFactionFocusPanel() then
        return
    end

    fast_assert( gFactionFocusPanelData ~= nil or 'FactionFocus panel data is required while open' )
    local location = gFactionFocusPanelData.location

    SetNewWaypoint( location.x, location.y )
    TriggerEvent( 'Notify2', '#marcaGPS' )
end

---@param display table|nil
ReconcileFactionFocusPanel = function( display )
    assert( type( display ) == 'table' or display == nil, 'FactionFocus display must be a table or nil' )

    local panel = display and display.panel or nil

    if type( panel ) ~= 'table' or not CanViewFactionFocusPanel() then
        CloseFactionFocusPanel()
        return
    end

    if gFactionFocusPanelOpen then
        UpdateFactionFocusPanel( panel )
        return
    end

    OpenFactionFocusPanel( panel )
end

RegisterNetEvent( 'net:routing_bucket_changed', function( bucket )
    if tonumber( bucket ) == DEFAULT_WORLD_BUCKET then
        ReconcileFactionFocusPanel( GlobalState[ 'FACTIONFOCUS_DISPLAY' ] )
        return
    end

    CloseFactionFocusPanel()
end)

AddStateBagChangeHandler( 'FACTIONFOCUS_DISPLAY', 'global', function( _, _, value )
    local panel = type( value ) == 'table' and value.panel or nil

    -- sx.logger:debug( ( 'factionfocus: display state updated panel=%s' ):format(
        -- json.encode( panel or { } )
    -- ) )

    ReconcileFactionFocusPanel( value )
end)

AddEventHandler( 'hud:factionFocus:hide', function()
    CloseFactionFocusPanel()
end )

RegisterCommand( 'factionfocus_mark_location', function()
    MarkFactionFocusLocation()
end)

RegisterKeyMapping(
    'factionfocus_mark_location',
    'Marcar localização da facção em foco',
    'keyboard',
    'Q'
)

RegisterCommand( 'factionfocushud', ToggleFactionFocusPanel)

RegisterKeyMapping(
    'factionfocushud',
    'Abrir ou ocultar painel da facção em foco',
    'keyboard',
    'F11'
)

local function ReconcileFactionFocusAfterGroupChange()
    CreateThread( function()
        for attempt = 1, 12 do
            if CanViewFactionFocusPanel() then
                -- sx.logger:debug( ( 'factionfocus: group sync reconciled attempt=%d' ):format( attempt ) )
                ReconcileFactionFocusPanel( GlobalState[ 'FACTIONFOCUS_DISPLAY' ] )
                return
            end

            Wait( 250 )
        end

        CloseFactionFocusPanel()
    end )
end

RegisterNetEvent( 'playerGroups:AddGroup', ReconcileFactionFocusAfterGroupChange )

RegisterNetEvent( 'playerGroups:RemoveGroup', ReconcileFactionFocusAfterGroupChange )

AddEventHandler( 'onResourceStop', function( resourceName )
    if resourceName == GetCurrentResourceName() then
        CloseFactionFocusPanel()
    end
end)

CreateThread( 
    function()

        Wait( 3500 )

        if not CanViewFactionFocusPanel() then
            return
        end

        -- Garantir que ao logar apareca o hover do F11 e o Q

        SendFactionFocusDashboardMessage( 'factionFocus:update', {
            rankingKey = 'Q',
            hideKey = 'F11',
        } )

        ReconcileFactionFocusPanel( GlobalState[ 'FACTIONFOCUS_DISPLAY' ] )

    end
)
