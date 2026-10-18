local SPATIAL_ZONE_EDGE_EPSILON = 0.001
local SPATIAL_ZONE_CIRCLE_SEGMENTS = 64
local SPATIAL_ZONE_MIN_BOUNDARY_POINTS = 3
local SPATIAL_ZONE_INDEX_CELL_SIZE = 256.0
local SPATIAL_ZONE_MAX_INDEX_CELLS_PER_ZONE = 256

---@param value table|vector2|vector3
---@param key string
---@param index number
---@return number?
local function ReadCoordinate( value, key, index )
    if not value then
        return nil
    end

    local valueType = type( value )

    if valueType == 'vector2' or valueType == 'vector3' or valueType == 'vector4' then
        if key == 'x' then
            return tonumber( value.x )
        end

        if key == 'y' then
            return tonumber( value.y )
        end

        if key == 'z' and valueType ~= 'vector2' then
            return tonumber( value.z )
        end

        return nil
    end

    return tonumber( value[ key ] or value[ index ] )
end

---@param value table|vector2|vector3
---@return table? point
local function CopyPoint( value )
    local x = ReadCoordinate( value, 'x', 1 )
    local y = ReadCoordinate( value, 'y', 2 )

    if not x or not y then
        return nil
    end

    return {
        x = x,
        y = y,
        z = ReadCoordinate( value, 'z', 3 ),
    }
end

---@param pointX number
---@param pointY number
---@param startPoint table
---@param endPoint table
---@return boolean onSegment
local function IsPointOnSegment( pointX, pointY, startPoint, endPoint )
    local edgeX = endPoint.x - startPoint.x
    local edgeY = endPoint.y - startPoint.y
    local lengthSquared = edgeX * edgeX + edgeY * edgeY

    if lengthSquared <= SPATIAL_ZONE_EDGE_EPSILON * SPATIAL_ZONE_EDGE_EPSILON then
        local deltaX = pointX - startPoint.x
        local deltaY = pointY - startPoint.y

        return deltaX * deltaX + deltaY * deltaY
            <= SPATIAL_ZONE_EDGE_EPSILON * SPATIAL_ZONE_EDGE_EPSILON
    end

    local projection = (
        ( pointX - startPoint.x ) * edgeX
        + ( pointY - startPoint.y ) * edgeY
    ) / lengthSquared

    if projection < 0.0 or projection > 1.0 then
        return false
    end

    local closestX = startPoint.x + projection * edgeX
    local closestY = startPoint.y + projection * edgeY
    local deltaX = pointX - closestX
    local deltaY = pointY - closestY

    return deltaX * deltaX + deltaY * deltaY
        <= SPATIAL_ZONE_EDGE_EPSILON * SPATIAL_ZONE_EDGE_EPSILON
end

---@class SpatialZone
---@field id string|number
---@field shape 'circle'|'polygon'
---@field center? table
---@field radius? number
---@field points? table[]
---@field boundaryPoints? table[]
---@field boundaryHeight? number
---@field minZ? number
---@field maxZ? number
---@field bounds table
---@field outline table[]

SpatialZoneGeometry = {}

---@param definition table
---@return SpatialZone? zone
---@return string? errorMessage
function SpatialZoneGeometry.Normalize( definition )
    if type( definition ) ~= 'table' then
        return nil, 'zone definition deve ser uma table'
    end

    if definition.id == nil then
        return nil, 'zone definition precisa de id'
    end

    local shape = definition.shape

    if shape == nil and type( definition.points ) == 'table' then
        shape = 'polygon'
    end

    if shape ~= 'circle' and shape ~= 'polygon' then
        return nil, ('zona %s possui shape invalido'):format( tostring( definition.id ) )
    end

    local minZ = tonumber( definition.minZ )
    local maxZ = tonumber( definition.maxZ )

    if minZ and maxZ and minZ > maxZ then
        return nil, ('zona %s possui minZ maior que maxZ'):format( tostring( definition.id ) )
    end

    local zone = {}

    for key, value in pairs( definition ) do
        zone[ key ] = value
    end

    zone.shape = shape
    zone.minZ = minZ
    zone.maxZ = maxZ
    zone.outline = {}

    if shape == 'circle' then
        local center = CopyPoint( definition.center )
        local radius = tonumber( definition.radius )

        if not center or not radius or radius <= 0.0 then
            return nil, ('zona circular %s precisa de center e radius positivo'):format(
                tostring( definition.id )
            )
        end

        zone.center = center
        zone.radius = radius
        zone.points = nil
        zone.bounds = {
            minX = center.x - radius,
            minY = center.y - radius,
            maxX = center.x + radius,
            maxY = center.y + radius,
        }

        if type( definition.boundaryPoints ) == 'table'
            and #definition.boundaryPoints >= SPATIAL_ZONE_MIN_BOUNDARY_POINTS
        then
            for pointIndex, definitionPoint in ipairs( definition.boundaryPoints ) do
                local point = CopyPoint( definitionPoint )

                if not point or not point.z then
                    return nil, ('zona circular %s possui boundaryPoint invalido no indice %d'):format(
                        tostring( definition.id ),
                        pointIndex
                    )
                end

                zone.outline[ pointIndex ] = point
            end
        else
            for pointIndex = 1, SPATIAL_ZONE_CIRCLE_SEGMENTS do
                local angle = ( pointIndex - 1 ) / SPATIAL_ZONE_CIRCLE_SEGMENTS * math.pi * 2.0

                zone.outline[ pointIndex ] = {
                    x = center.x + math.cos( angle ) * radius,
                    y = center.y + math.sin( angle ) * radius,
                }
            end
        end

        return zone
    end

    if type( definition.points ) ~= 'table' or #definition.points < 3 then
        return nil, ('zona poligonal %s precisa de pelo menos 3 pontos'):format(
            tostring( definition.id )
        )
    end

    local points = {}
    local minX, minY = math.huge, math.huge
    local maxX, maxY = -math.huge, -math.huge

    for pointIndex, definitionPoint in ipairs( definition.points ) do
        local point = CopyPoint( definitionPoint )

        if not point then
            return nil, ('zona %s possui ponto invalido no indice %d'):format(
                tostring( definition.id ),
                pointIndex
            )
        end

        points[ pointIndex ] = point
        zone.outline[ pointIndex ] = point
        minX = math.min( minX, point.x )
        minY = math.min( minY, point.y )
        maxX = math.max( maxX, point.x )
        maxY = math.max( maxY, point.y )
    end

    zone.center = nil
    zone.radius = nil
    zone.points = points
    zone.bounds = {
        minX = minX,
        minY = minY,
        maxX = maxX,
        maxY = maxY,
    }

    return zone
end

---@param zone SpatialZone
---@param position table|vector2|vector3
---@return boolean inside
function SpatialZoneGeometry.Contains( zone, position )
    local pointX = ReadCoordinate( position, 'x', 1 )
    local pointY = ReadCoordinate( position, 'y', 2 )
    local pointZ = ReadCoordinate( position, 'z', 3 )

    if not pointX or not pointY then
        return false
    end

    if zone.minZ and ( not pointZ or pointZ < zone.minZ ) then
        return false
    end

    if zone.maxZ and ( not pointZ or pointZ > zone.maxZ ) then
        return false
    end

    local bounds = zone.bounds

    if pointX < bounds.minX - SPATIAL_ZONE_EDGE_EPSILON
        or pointX > bounds.maxX + SPATIAL_ZONE_EDGE_EPSILON
        or pointY < bounds.minY - SPATIAL_ZONE_EDGE_EPSILON
        or pointY > bounds.maxY + SPATIAL_ZONE_EDGE_EPSILON
    then
        return false
    end

    if zone.shape == 'circle' then
        local deltaX = pointX - zone.center.x
        local deltaY = pointY - zone.center.y
        local radius = zone.radius + SPATIAL_ZONE_EDGE_EPSILON

        return deltaX * deltaX + deltaY * deltaY <= radius * radius
    end

    local inside = false
    local previousPoint = zone.points[ #zone.points ]

    for _, point in ipairs( zone.points ) do
        if IsPointOnSegment( pointX, pointY, previousPoint, point ) then
            return true
        end

        local crossesHorizontalRay = ( point.y > pointY ) ~= ( previousPoint.y > pointY )

        if crossesHorizontalRay then
            local intersectionX = (
                ( previousPoint.x - point.x )
                * ( pointY - point.y )
                / ( previousPoint.y - point.y )
            ) + point.x

            if pointX < intersectionX then
                inside = not inside
            end
        end

        previousPoint = point
    end

    return inside
end

---@class SpatialZoneSet
---@field zones SpatialZone[]
---@field zoneById table<string, SpatialZone>
---@field spatialIndex table<integer, table<integer, SpatialZone[]>>
---@field globalZones SpatialZone[]
SpatialZoneSet = class()

---@param spatialIndex table<integer, table<integer, SpatialZone[]>>
---@param cellX integer
---@param cellY integer
---@param zone SpatialZone
local function AddZoneToSpatialIndex( spatialIndex, cellX, cellY, zone )
    local column = spatialIndex[ cellX ]

    if not column then
        column = {}
        spatialIndex[ cellX ] = column
    end

    local cell = column[ cellY ]

    if not cell then
        cell = {}
        column[ cellY ] = cell
    end

    cell[ #cell + 1 ] = zone
end

---@param zones SpatialZone[]
---@return table<integer, table<integer, SpatialZone[]>> spatialIndex
---@return SpatialZone[] globalZones
local function BuildSpatialIndex( zones )
    local spatialIndex = {}
    local globalZones = {}

    for _, zone in ipairs( zones ) do
        local bounds = zone.bounds
        local minCellX = math.floor(
            ( bounds.minX - SPATIAL_ZONE_EDGE_EPSILON ) / SPATIAL_ZONE_INDEX_CELL_SIZE
        )
        local minCellY = math.floor(
            ( bounds.minY - SPATIAL_ZONE_EDGE_EPSILON ) / SPATIAL_ZONE_INDEX_CELL_SIZE
        )
        local maxCellX = math.floor(
            ( bounds.maxX + SPATIAL_ZONE_EDGE_EPSILON ) / SPATIAL_ZONE_INDEX_CELL_SIZE
        )
        local maxCellY = math.floor(
            ( bounds.maxY + SPATIAL_ZONE_EDGE_EPSILON ) / SPATIAL_ZONE_INDEX_CELL_SIZE
        )
        local cellCount = ( maxCellX - minCellX + 1 ) * ( maxCellY - minCellY + 1 )

        if cellCount > SPATIAL_ZONE_MAX_INDEX_CELLS_PER_ZONE then
            globalZones[ #globalZones + 1 ] = zone
        else
            for cellX = minCellX, maxCellX do
                for cellY = minCellY, maxCellY do
                    AddZoneToSpatialIndex( spatialIndex, cellX, cellY, zone )
                end
            end
        end
    end

    return spatialIndex, globalZones
end

---@param definitions table[]?
function SpatialZoneSet:__init( definitions )
    self.zones = {}
    self.zoneById = {}
    self.spatialIndex = {}
    self.globalZones = {}

    local success, errorMessage = self:setZones( definitions or {} )

    assert( success, errorMessage )
end

---@param definitions table[]
---@return boolean success
---@return string? errorMessage
function SpatialZoneSet:setZones( definitions )
    if type( definitions ) ~= 'table' then
        return false, 'zones deve ser uma table'
    end

    local zones = {}
    local zoneById = {}

    for zoneIndex, definition in ipairs( definitions ) do
        local zone, errorMessage = SpatialZoneGeometry.Normalize( definition )

        if not zone then
            return false, errorMessage
        end

        local zoneKey = tostring( zone.id )

        if zoneById[ zoneKey ] then
            return false, ('zone id duplicado: %s'):format( zoneKey )
        end

        zones[ zoneIndex ] = zone
        zoneById[ zoneKey ] = zone
    end

    self.zones = zones
    self.zoneById = zoneById
    self.spatialIndex, self.globalZones = BuildSpatialIndex( zones )
    return true
end

---@return SpatialZone[] zones
function SpatialZoneSet:getZones()
    return self.zones
end

---@param zoneId string|number
---@return SpatialZone? zone
function SpatialZoneSet:getZone( zoneId )
    return self.zoneById[ tostring( zoneId ) ]
end

---@param zoneId string|number
---@param position table|vector2|vector3
---@return boolean inside
function SpatialZoneSet:contains( zoneId, position )
    local zone = self:getZone( zoneId )

    return zone ~= nil and SpatialZoneGeometry.Contains( zone, position )
end

---@param position table|vector2|vector3
---@param distance number
---@return SpatialZone[] zones
function SpatialZoneSet:getNearbyZones( position, distance )
    local pointX = ReadCoordinate( position, 'x', 1 )
    local pointY = ReadCoordinate( position, 'y', 2 )

    if not pointX or not pointY then
        return {}
    end

    distance = math.max( 0.0, tonumber( distance ) or 0.0 )

    local minCellX = math.floor( ( pointX - distance ) / SPATIAL_ZONE_INDEX_CELL_SIZE )
    local minCellY = math.floor( ( pointY - distance ) / SPATIAL_ZONE_INDEX_CELL_SIZE )
    local maxCellX = math.floor( ( pointX + distance ) / SPATIAL_ZONE_INDEX_CELL_SIZE )
    local maxCellY = math.floor( ( pointY + distance ) / SPATIAL_ZONE_INDEX_CELL_SIZE )
    local nearbyZones = {}
    local addedZoneById = {}

    for _, zone in ipairs( self.globalZones ) do
        local zoneKey = tostring( zone.id )

        nearbyZones[ #nearbyZones + 1 ] = zone
        addedZoneById[ zoneKey ] = true
    end

    for cellX = minCellX, maxCellX do
        local column = self.spatialIndex[ cellX ]

        if column then
            for cellY = minCellY, maxCellY do
                for _, zone in ipairs( column[ cellY ] or {} ) do
                    local zoneKey = tostring( zone.id )

                    if not addedZoneById[ zoneKey ] then
                        nearbyZones[ #nearbyZones + 1 ] = zone
                        addedZoneById[ zoneKey ] = true
                    end
                end
            end
        end
    end

    return nearbyZones
end

---@param position table|vector2|vector3
---@return table<string, SpatialZone> membershipById
function SpatialZoneSet:resolveMembership( position )
    local membershipById = {}
    local pointX = ReadCoordinate( position, 'x', 1 )
    local pointY = ReadCoordinate( position, 'y', 2 )

    if not pointX or not pointY then
        return membershipById
    end

    local cellX = math.floor( pointX / SPATIAL_ZONE_INDEX_CELL_SIZE )
    local cellY = math.floor( pointY / SPATIAL_ZONE_INDEX_CELL_SIZE )
    local column = self.spatialIndex[ cellX ]
    local candidates = column and column[ cellY ] or nil

    for _, zone in ipairs( self.globalZones ) do
        if SpatialZoneGeometry.Contains( zone, position ) then
            membershipById[ tostring( zone.id ) ] = zone
        end
    end

    if candidates then
        for _, zone in ipairs( candidates ) do
            if SpatialZoneGeometry.Contains( zone, position ) then
                membershipById[ tostring( zone.id ) ] = zone
            end
        end
    end

    return membershipById
end
