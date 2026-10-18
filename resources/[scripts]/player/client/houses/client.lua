local DUI_WIDTH = 1024
local DUI_HEIGHT = 512
local DEFAULT_RENDER_DISTANCE = 50.0
local DEFAULT_SCALE = 0.18
local MIN_SCALE_FACTOR = 0.45
local DUI_UNLOAD_DELAY_MS = 10000
local DUI_PAYLOAD_RETRY_COUNT = 8
local DUI_PAYLOAD_RETRY_MS = 500

---@class MansionDuiData
---@field name string
---@field gems number
---@field coords vector3
---@field renderDistance number
---@field scale number
---@field purchasable boolean

---@class MansionDuiEntry
---@field id string
---@field data MansionDuiData
---@field dui Dui?
---@field browserKey number?
---@field point CPoint?
---@field interactionId string?
---@field unloadVersion number

---@type table<string, MansionDuiEntry>
local gMansionDuis = {}

---@type table<string, MansionDuiEntry>
local gMansionDuiByBrowserKey = {}

local gNextBrowserKey = 1

---@param id string | number
---@param data table
---@return MansionDuiData | nil normalizedData
local function NormalizeMansionDuiData( id, data )

    if type( id ) ~= "string" and type( id ) ~= "number" then
        sx.logger:warn( ( 'houses DUI: invalid id type=%s' ):format( type( id ) ) )
        return nil
    end

    if type( data ) ~= "table" then
        sx.logger:warn( ( 'houses DUI: invalid data for id=%s' ):format( tostring( id ) ) )
        return nil
    end

    local name = data.name
    local gems = tonumber( data.gems )
    local coords = data.coords

    if type( name ) ~= "string" or name == "" then
        sx.logger:warn( ( 'houses DUI: invalid mansion name for id=%s' ):format( tostring( id ) ) )
        return nil
    end

    if not gems or gems < 0 then
        sx.logger:warn( ( 'houses DUI: invalid gems value for id=%s' ):format( tostring( id ) ) )
        return nil
    end

    if not coords or not coords.x or not coords.y or not coords.z then
        sx.logger:warn( ( 'houses DUI: invalid coords for id=%s' ):format( tostring( id ) ) )
        return nil
    end

    return {
        name = name,
        gems = math.floor( gems ),
        coords = vector3( coords.x + 0.0, coords.y + 0.0, coords.z + 0.0 ),
        renderDistance = math.max( 1.0, tonumber( data.renderDistance ) or DEFAULT_RENDER_DISTANCE ),
        scale = math.max( 0.01, tonumber( data.scale ) or DEFAULT_SCALE ),
        purchasable = data.purchasable == true,
    }
end

---@param entry MansionDuiEntry
---@return table payload
local function BuildMansionDuiPayload( entry )

    return {
        action = "houses:setMansion",
        data = {
            name = entry.data.name,
            gems = entry.data.gems,
            eyebrow = _t( "mansion_sale_dui_eyebrow" ),
            currency = _t( "mansion_sale_currency" ),
        },
    }
end

---@param entry MansionDuiEntry
local function SendMansionDuiPayload( entry )

    if entry.dui then
        entry.dui:sendMessage( BuildMansionDuiPayload( entry ) )
    end
end

---@param entry MansionDuiEntry
---@param dui Dui
---@param attempt number
local function ScheduleMansionDuiPayload( entry, dui, attempt )

    SetTimeout( DUI_PAYLOAD_RETRY_MS, function()

        if gMansionDuis[ entry.id ] ~= entry or entry.dui ~= dui then
            return
        end

        SendMansionDuiPayload( entry )

        if attempt < DUI_PAYLOAD_RETRY_COUNT then
            ScheduleMansionDuiPayload( entry, dui, attempt + 1 )
        end
    end )
end

---@param character string
---@return string encoded
local function EncodeUrlCharacter( character )

    return ( "%%%02X" ):format( string.byte( character ) )
end

---@param value any
---@return string encoded
local function UrlEncode( value )

    return tostring( value ):gsub( "([^%w%-_%.~])", EncodeUrlCharacter )
end

---@param entry MansionDuiEntry
local function SpawnMansionDui( entry )

    if entry.dui then
        return
    end

    local browserKey = gNextBrowserKey
    gNextBrowserKey = gNextBrowserKey + 1

    local payload = BuildMansionDuiPayload( entry ).data
    local url = ( "https://cfx-nui-%s/web/houses/index.html?duiKey=%d&name=%s&gems=%d&eyebrow=%s&currency=%s" ):format(
        GetCurrentResourceName(),
        browserKey,
        UrlEncode( payload.name ),
        payload.gems,
        UrlEncode( payload.eyebrow ),
        UrlEncode( payload.currency )
    )

    entry.browserKey = browserKey
    entry.dui = lib.dui:new( {
        url = url,
        width = DUI_WIDTH,
        height = DUI_HEIGHT,
    } )
    gMansionDuiByBrowserKey[ tostring( browserKey ) ] = entry

    ScheduleMansionDuiPayload( entry, entry.dui, 1 )
    sx.logger:debug( ( 'houses DUI: spawned id=%s url=%s' ):format( entry.id, url ) )
end

---@param entry MansionDuiEntry
local function DestroyMansionDui( entry )

    entry.unloadVersion = entry.unloadVersion + 1

    if entry.browserKey then
        gMansionDuiByBrowserKey[ tostring( entry.browserKey ) ] = nil
        entry.browserKey = nil
    end

    if entry.dui then
        entry.dui:remove()
        entry.dui = nil
    end
end

---@param point CPoint
local function OnMansionPointEnter( point )

    local entry = point.mansionEntry
    entry.unloadVersion = entry.unloadVersion + 1
    SpawnMansionDui( entry )
end

---@param point CPoint
local function OnMansionPointExit( point )

    local entry = point.mansionEntry
    entry.unloadVersion = entry.unloadVersion + 1

    local unloadVersion = entry.unloadVersion

    SetTimeout( DUI_UNLOAD_DELAY_MS, function()

        if gMansionDuis[ entry.id ] == entry and entry.unloadVersion == unloadVersion and not point.currentDistance then
            DestroyMansionDui( entry )
        end
    end )
end

---@param point CPoint
local function DrawMansionDui( point )

    local entry = point.mansionEntry

    if not entry.dui or not IsDuiAvailable( entry.dui.duiObject ) then
        return
    end

    local data = entry.data
    local aspectRatio = GetAspectRatio( true )
    local distance = math.min( point.currentDistance or data.renderDistance, data.renderDistance )
    local proximity = 1.0 - ( distance / data.renderDistance )
    local scale = data.scale * ( MIN_SCALE_FACTOR + ( 1.0 - MIN_SCALE_FACTOR ) * proximity )

    SetDrawOrigin( data.coords.x, data.coords.y, data.coords.z, false )
    DrawInteractiveSprite(
        entry.dui.dictName,
        entry.dui.txtName,
        0.0,
        0.0,
        scale,
        scale * ( DUI_HEIGHT / DUI_WIDTH ) * aspectRatio,
        0.0,
        255,
        255,
        255,
        255
    )
    ClearDrawOrigin()
end

---@param entry MansionDuiEntry
local function RemoveMansionEntryBindings( entry )

    if entry.point then
        entry.point:remove()
        entry.point = nil
    end

    if entry.interactionId then
        interact.removeById( entry.interactionId )
        entry.interactionId = nil
    end
end

---@param entry MansionDuiEntry
local function AddMansionEntryBindings( entry )

    entry.point = lib.points.new( {
        coords = entry.data.coords,
        distance = entry.data.renderDistance,
        mansionEntry = entry,
        onEnter = OnMansionPointEnter,
        onExit = OnMansionPointExit,
        nearby = DrawMansionDui,
    } )

    if not entry.data.purchasable then
        return
    end

    local interactionId = ( "mansion-sale:%s" ):format( entry.id )
    entry.interactionId = interactionId

    interact.addCoords( {
        id = interactionId,
        coords = entry.data.coords,
        options = {
            {
                label = _t( "mansion_sale_interact" ),
                icon = "gem",
                onSelect = function()

                    TriggerServerEvent( "player:houses:buy", entry.id )
                end,
                canInteract = function()

                    return LocalPlayer.state.Active and not LocalPlayer.state.PVP and not GlobalState.Restarting
                end,
            },
        },
        renderDistance = 8.0,
        activeDistance = 2.5,
        cooldown = 1500,
    } )
end

---@param id string | number
---@param data table
---@return boolean success
local function SetMansionDui( id, data )

    local normalizedData = NormalizeMansionDuiData( id, data )

    if not normalizedData then
        return false
    end

    local stringId = tostring( id )
    local entry = gMansionDuis[ stringId ]

    if entry then
        RemoveMansionEntryBindings( entry )
        entry.data = normalizedData
        SendMansionDuiPayload( entry )
        AddMansionEntryBindings( entry )
        return true
    end

    entry = {
        id = stringId,
        data = normalizedData,
        unloadVersion = 0,
    }

    gMansionDuis[ stringId ] = entry
    AddMansionEntryBindings( entry )

    return true
end

---@param id string | number
---@return boolean removed
local function RemoveMansionDui( id )

    local stringId = tostring( id )
    local entry = gMansionDuis[ stringId ]

    if not entry then
        return false
    end

    RemoveMansionEntryBindings( entry )
    DestroyMansionDui( entry )
    gMansionDuis[ stringId ] = nil

    return true
end

local function ClearMansionDuis()

    for _, entry in pairs( gMansionDuis ) do
        RemoveMansionEntryBindings( entry )
        DestroyMansionDui( entry )
    end

    gMansionDuis = {}
end

RegisterNUICallback( "houses:ready", function( data, cb )

    local entry = gMansionDuiByBrowserKey[ tostring( data.duiKey ) ]

    if entry then
        SendMansionDuiPayload( entry )
    end

    cb( { success = entry ~= nil } )
end )

RegisterNetEvent( "player:houses:loadDuis", function( sales )

    ClearMansionDuis()

    if type( sales ) ~= "table" then
        sx.logger:warn( "houses DUI: invalid sales payload" )
        return
    end

    for i = 1, #sales do
        SetMansionDui( sales[ i ].id, sales[ i ].data )
    end
end )

RegisterNetEvent( "player:houses:setDui", function( id, data )

    SetMansionDui( id, data )
end )

RegisterNetEvent( "player:houses:removeDui", function( id )

    RemoveMansionDui( id )
end )

RegisterNetEvent( "player:houses:clearDuis", function()

    ClearMansionDuis()
end )

AddEventHandler( "onClientResourceStart", function( resourceName )

    if resourceName == GetCurrentResourceName() then
        TriggerServerEvent( "player:houses:requestDuis" )
    end
end )

AddEventHandler( "onResourceStop", function( resourceName )

    if resourceName == GetCurrentResourceName() then
        ClearMansionDuis()
    end
end )

exports( "SetMansionDui", SetMansionDui )
exports( "RemoveMansionDui", RemoveMansionDui )
exports( "ClearMansionDuis", ClearMansionDuis )
