---@class SpatialZoneTrackerOptions
---@field zones table[]?
---@field intervalMs number?
---@field positionProvider fun(): table|vector3|nil
---@field onEnter? fun(zone: SpatialZone, position: table|vector3)
---@field onExit? fun(zone: SpatialZone, position: table|vector3|nil)

---@class SpatialZoneTracker
---@field zoneSet SpatialZoneSet
---@field insideById table<string, SpatialZone>
---@field running boolean
---@field revision integer
SpatialZoneTracker = class()

---@return vector3? position
local function GetLocalPlayerPosition()
    local ped = PlayerPedId()

    if ped == 0 or not DoesEntityExist( ped ) then
        return nil
    end

    return GetEntityCoords( ped )
end

---@param options SpatialZoneTrackerOptions
function SpatialZoneTracker:__init( options )
    assert( type( options ) == 'table', 'SpatialZoneTracker precisa de options' )

    self.zoneSet = SpatialZoneSet( options.zones or {} )
    self.intervalMs = math.max( 50, math.floor( tonumber( options.intervalMs ) or 200 ) )
    self.positionProvider = options.positionProvider or GetLocalPlayerPosition
    self.onEnter = options.onEnter
    self.onExit = options.onExit
    self.insideById = {}
    self.running = false
    self.revision = 0
end

---@param zones table[]
---@param preserveMembership? boolean
function SpatialZoneTracker:setZones( zones, preserveMembership )
    local wasRunning = self.running

    if wasRunning and not preserveMembership then
        self:stop( true )
    end

    local success, errorMessage = self.zoneSet:setZones( zones )

    assert( success, errorMessage )

    if wasRunning then
        if preserveMembership then
            self:updateNow()
        else
            self:start()
        end
    end
end

---@return boolean updated
function SpatialZoneTracker:updateNow()
    local position = self.positionProvider()

    if not position then
        return false
    end

    local nextInsideById = self.zoneSet:resolveMembership( position )

    for zoneId, zone in pairs( nextInsideById ) do
        if not self.insideById[ zoneId ] and self.onEnter then
            self.onEnter( zone, position )
        end
    end

    for zoneId, zone in pairs( self.insideById ) do
        if not nextInsideById[ zoneId ] and self.onExit then
            self.onExit( zone, position )
        end
    end

    self.insideById = nextInsideById
    return true
end

function SpatialZoneTracker:start()
    if self.running then
        return
    end

    self.running = true
    self.revision = self.revision + 1

    local revision = self.revision

    CreateThread( function()
        while self.running and self.revision == revision do
            self:updateNow()
            Wait( self.intervalMs )
        end
    end )
end

---@param emitExits boolean?
function SpatialZoneTracker:stop( emitExits )
    self.running = false
    self.revision = self.revision + 1

    if emitExits and self.onExit then
        local position = self.positionProvider()

        for _, zone in pairs( self.insideById ) do
            self.onExit( zone, position )
        end
    end

    self.insideById = {}
end

---@param zoneId string|number
---@return boolean inside
function SpatialZoneTracker:isInside( zoneId )
    return self.insideById[ tostring( zoneId ) ] ~= nil
end

---@return table<string, SpatialZone> insideById
function SpatialZoneTracker:getInsideZones()
    return self.insideById
end

function SpatialZoneTracker:destroy()
    self:stop( false )
    self.zoneSet:setZones( {} )
end
