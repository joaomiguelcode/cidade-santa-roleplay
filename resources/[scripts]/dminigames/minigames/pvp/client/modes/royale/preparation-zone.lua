---@class RoyalePreparationZonePayload
---@field id string
---@field kind? string
---@field type? string
---@field shape string
---@field center { x: number, y: number, z: number }
---@field radius number
---@field name string Nome da organizacao, resolvido no servidor
---@field status? string Texto pronto para exibicao

---@class RoyalePreparationZone
---@field zone? MapZoneRendererZone
---@field mapRenderer? MapZoneRenderer
---@field boundaryRenderer? SpatialZoneBoundaryRenderer
---@field revision integer
---@field minimapForced boolean
RoyalePreparationZone = class()

local gMinimapOwner = 'dminigames_royale_preparation'

---@param value any
---@return boolean
local function IsFiniteNumber( value )

    return type( value ) == 'number' and value == value and value > -math.huge and value < math.huge
end

---@param payload RoyalePreparationZonePayload
---@return MapZoneRendererZone?
local function BuildRenderZone( payload )

    if type( payload ) ~= 'table' or type( payload.id ) ~= 'string' or payload.id == ''
        or payload.shape ~= 'circle' or ( payload.kind or payload.type ) ~= 'safe'
        or type( payload.center ) ~= 'table'
        or not IsFiniteNumber( payload.center.x ) or not IsFiniteNumber( payload.center.y )
        or not IsFiniteNumber( payload.center.z ) or not IsFiniteNumber( payload.radius )
        or payload.radius <= 0 or type( payload.name ) ~= 'string' or payload.name == ''
    then
        return nil
    end

    local center = payload.center

    return {
        id = payload.id,
        shape = 'circle',
        type = 'safe',
        state = 'safe',
        center = { x = center.x, y = center.y, z = center.z },
        radius = payload.radius,
        name = payload.name,
        status = type( payload.status ) == 'string' and payload.status or '',
        color = { 38, 201, 151 },
        boundaryBottomZ = center.z - 1000.0,
        boundaryTopZ = center.z + 1000.0,
    }
end

---@param first MapZoneRendererZone?
---@param second MapZoneRendererZone
---@return boolean
local function IsSameZone( first, second )

    return first ~= nil and first.id == second.id and first.radius == second.radius
        and first.name == second.name and first.status == second.status
        and first.center.x == second.center.x and first.center.y == second.center.y
        and first.center.z == second.center.z
end

---@param forced boolean
local function SetMinimapForced( forced )

    if GetResourceState( 'hud' ) == 'started' then
        exports.hud:SetMinimapForced( gMinimapOwner, forced )
    elseif forced then
        DisplayRadar( true )
    end
end

function RoyalePreparationZone:__init()

    self.revision = 0
    self.minimapForced = false
end

---@param payload RoyalePreparationZonePayload
---@return boolean opened
function RoyalePreparationZone:Open( payload )

    local zone = BuildRenderZone( payload )

    if not zone then
        sx.logger:warn( 'Royale: zona de preparacao invalida' )
        return false
    end

    if IsSameZone( self.zone, zone ) then
        return true
    end

    self:Close()
    local revision = self.revision
    local zones = { zone }
    local mapRenderer = MapZoneRenderer( {
        textureDictionaryPrefix = 'dmg_royale_preparation',
        canvasSize = 2048,
        maxWindowSpan = math.huge,
        projectionZones = zones,
        circleSegments = 32,
    } )
    local boundaryRenderer = SpatialZoneBoundaryRenderer( {
        drawDistance = 180.0,
        wallBottomZ = -1000.0,
        wallTopZ = 1000.0,
        wallAlpha = 210,
        textureState = 'neutral',
        useBoundaryProfiles = false,
        useFullTexture = true,
        textureImage = 'web/domination-zone-boundary.png',
        -- Mesmo atlas estatico da Domination: reutiliza o cache de runtime textures.
        textureDictionaryPrefix = 'domination_boundary',
        textureName = 'atlas',
        textureSize = 1024,
        textureRepeatDistance = 100.0,
        visualWallHeight = 100.0,
        circleSegments = 12,
        cylinderZoneIds = true,
        cylinderWallHeight = 500.0,
        cylinderTextureImage = 'web/domination-zone-boundary-cylinder.png',
    } )

    self.zone = zone
    self.mapRenderer = mapRenderer
    self.boundaryRenderer = boundaryRenderer
    self.minimapForced = true
    SetMinimapForced( true )
    boundaryRenderer:setZones( zones )
    boundaryRenderer:show()
    mapRenderer:setZones( zones )
    local shown = mapRenderer:show()

    -- O carregamento de overlay/DUI pode terminar depois da saida da preparacao.
    if self.revision ~= revision then
        return false
    end

    if not shown then
        self:Close()
        return false
    end

    return true
end

---@param position table|vector3
---@return boolean inside
function RoyalePreparationZone:Contains( position )

    local zone = self.zone

    if not zone then return false end

    local dx, dy = position.x - zone.center.x, position.y - zone.center.y
    return dx * dx + dy * dy <= zone.radius * zone.radius
end

function RoyalePreparationZone:Close()

    self.revision = self.revision + 1
    self.zone = nil
    local mapRenderer = self.mapRenderer
    local boundaryRenderer = self.boundaryRenderer
    self.mapRenderer = nil
    self.boundaryRenderer = nil

    if boundaryRenderer then
        boundaryRenderer:destroy()
    end

    if mapRenderer then
        mapRenderer:destroy()
    end

    if self.minimapForced then
        self.minimapForced = false
        SetMinimapForced( false )
    end
end
