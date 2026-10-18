--[[
    ENG-3959 (Waypoint Legal v1): marcador azul "Legal em Foco" no spawn da org legal que receberia o
    próximo iniciante de cada opção (polícia, paramédico). Mesmo marcador e blip do Fac em Foco
    (`jobs_discovery.lua`), com estado próprio (`LEGAL_FOCUS_DISPLAY`) para os dois não se misturarem.
    ENG-3978: público próprio, separado do Fac em Foco:
      WallStreet/Orgs nível 1 a 5 → todos, com blip.
      Iniciante                   → só o da opção que escolheu no ramo, com blip.
      Mais ninguém (membro/recrutador da org legal recebe a NUI do líder, não o marcador).
]]

local resourceName = GetCurrentResourceName()

local CONVAR_ENABLED = 'hud_faction_discovery_enabled'
local TITLE_KEY = 'hud.legal_em_foco'
-- ENG-3977: ícone próprio do legal (URL da config da cidade); sem ele, o SVG padrão do Legal em Foco.
local DEFAULT_ICON = 'https://cdn.santagroup.gg/feedback-ranking/policon.svg'
local MARKER_VISIBLE_DISTANCE = 9999.0
local STAFF_GROUPS = { 'Orgs', 'WallStreet' }
local STAFF_MAX_LEVEL = 5
local BLIP_SPRITE = 1
local BLIP_SCALE = 0.9
local RECONCILE_MS = 1000

-- { markerNuiId, option, org, x, y, z, color, blipColor, icon }
local currentSlots = { }
-- activeWaypoints[markerNuiId] = { id, org, x, y, z, color, icon }
local activeWaypoints = { }
-- activeBlips[markerNuiId] = { handle, org, x, y, z, color, icon }
local activeBlips = { }

---@return string|nil
local function PlayerRamo()
    if GetResourceState( 'missions' ) ~= 'started' then return nil end

    local ok, ramo = pcall( function() return exports.missions:GetPlayerRamo() end )

    return ok and type( ramo ) == 'string' and ramo:lower() or nil
end

--- Staff de Orgs ou WallStreet, nível 1 a 5.
---@param groups table<string, integer>
---@return boolean
local function IsStaff( groups )
    for _, group in ipairs( STAFF_GROUPS ) do
        local level = tonumber( groups[ group ] )

        if level and level >= 1 and level <= STAFF_MAX_LEVEL then return true end
    end

    return false
end

--- Visível e com blip? Staff vê todos; iniciante só o da opção que escolheu; mais ninguém.
---@param slot table
---@param groups table
---@param ramo string|nil
---@return boolean visible
---@return boolean blip
local function ResolveVisibility( slot, groups, ramo )
    if IsStaff( groups ) then return true, true end
    if groups[ 'Iniciante' ] ~= nil and ramo == slot.option then return true, true end

    return false, false
end

---@param slot table
local function BuildWaypointPayload( slot )
    return {
        coords                     = vec3( slot.x + 0.0, slot.y + 0.0, slot.z + 0.0 ),
        title                      = _t( TITLE_KEY ),
        icon                       = slot.icon,
        markerNuiId                = slot.markerNuiId,
        parallelDuiLane            = true,
        family                     = 'legal_focus',
        customBorderColors         = slot.color,
        markerScale                = 1.9,
        titleScale                 = 1.25,
        spriteWidth                = 0.08,
        indicatorScale             = 1.0,
        indicatorIconScale         = 1.0,
        spriteHeight               = 0.14,
        markerDistance             = MARKER_VISIBLE_DISTANCE,
        seeThroughWalls            = true,
        suppressIndicatorWhenAimed = true,
        dynamicSkyOffset           = { pitch = 8.0, min = 0.0, max = 700.0 },
    }
end

---@param rendered table
---@param slot table
---@return boolean
local function SlotChanged( rendered, slot )
    return rendered.org ~= slot.org or rendered.color ~= slot.color or rendered.icon ~= slot.icon
        or rendered.x ~= slot.x or rendered.y ~= slot.y or rendered.z ~= slot.z
end

---@param slot table
---@param fields table
---@return table
local function Rendered( slot, fields )
    fields.org, fields.color, fields.icon = slot.org, slot.color, slot.icon
    fields.x, fields.y, fields.z = slot.x, slot.y, slot.z
    return fields
end

---@param markerNuiId string
local function RemoveWaypoint( markerNuiId )
    local entry = activeWaypoints[ markerNuiId ]

    if not entry then return end
    pcall( function() exports.hud:waypointRemove( entry.id ) end )
    activeWaypoints[ markerNuiId ] = nil
end

---@param markerNuiId string
local function RemoveLegalBlip( markerNuiId )
    local entry = activeBlips[ markerNuiId ]

    if not entry then return end
    if DoesBlipExist( entry.handle ) then RemoveBlip( entry.handle ) end
    activeBlips[ markerNuiId ] = nil
end

---@param slot table
local function CreateLegalBlip( slot )
    local blip = AddBlipForCoord( slot.x + 0.0, slot.y + 0.0, slot.z + 0.0 )

    SetBlipSprite( blip, BLIP_SPRITE )
    SetBlipColour( blip, slot.blipColor )
    SetBlipScale( blip, BLIP_SCALE )
    SetBlipAsShortRange( blip, false )
    ShowHeightOnBlip( blip, false )
    BeginTextCommandSetBlipName( 'STRING' )
    AddTextComponentSubstringPlayerName( _t( TITLE_KEY ) )
    EndTextCommandSetBlipName( blip )

    activeBlips[ slot.markerNuiId ] = Rendered( slot, { handle = blip } )
end

local function Reconcile()
    if GetResourceState( 'hud' ) ~= 'started' then return end

    local enabled = GetConvarInt( CONVAR_ENABLED, 1 ) == 1
    local groups = vRP.GetPlayerGroups() or { }
    local ramo = PlayerRamo()
    local wantWaypoint, wantBlip = { }, { }

    for _, slot in ipairs( currentSlots ) do
        local visible, blip = false, false

        if enabled then visible, blip = ResolveVisibility( slot, groups, ramo ) end
        if visible then wantWaypoint[ slot.markerNuiId ] = slot end
        if blip then wantBlip[ slot.markerNuiId ] = slot end
    end

    for nuiId, entry in pairs( activeWaypoints ) do
        local slot = wantWaypoint[ nuiId ]

        if not slot then
            RemoveWaypoint( nuiId )
        elseif SlotChanged( entry, slot ) then
            local ok = pcall( function() exports.hud:waypointUpdate( entry.id, BuildWaypointPayload( slot ) ) end )

            if ok then Rendered( slot, entry ) else RemoveWaypoint( nuiId ) end
        end
    end

    for nuiId, slot in pairs( wantWaypoint ) do
        if not activeWaypoints[ nuiId ] then
            local ok, id = pcall( function() return exports.hud:waypointCreate( BuildWaypointPayload( slot ) ) end )

            if ok and id then activeWaypoints[ nuiId ] = Rendered( slot, { id = id } ) end
        end
    end

    for nuiId, entry in pairs( activeBlips ) do
        local slot = wantBlip[ nuiId ]

        if not slot or SlotChanged( entry, slot ) then RemoveLegalBlip( nuiId ) end
    end

    for nuiId, slot in pairs( wantBlip ) do
        if not activeBlips[ nuiId ] then CreateLegalBlip( slot ) end
    end
end

---@param raw table|nil
local function ApplyDisplay( raw )
    local slots = { }

    if type( raw ) == 'table' then
        for _, entry in ipairs( raw ) do
            if type( entry ) == 'table' and entry.markerNuiId and tonumber( entry.x ) and tonumber( entry.y ) then
                slots[ #slots + 1 ] = {
                    markerNuiId = entry.markerNuiId,
                    option      = entry.option,
                    org         = entry.org,
                    x           = entry.x,
                    y           = entry.y,
                    z           = entry.z or 0.0,
                    color       = entry.color,
                    blipColor   = tonumber( entry.blipColor ) or 3,
                    icon        = type( entry.icon ) == 'string' and entry.icon ~= '' and entry.icon or DEFAULT_ICON,
                }
            end
        end
    end

    currentSlots = slots
    Reconcile()
end

AddStateBagChangeHandler( 'LEGAL_FOCUS_DISPLAY', 'global', function( _, _, value )
    ApplyDisplay( value )
end )

-- ENG-3984 (RF-103): a staff vê no topo, pelo tempo de fim de foco, a org legal que assumiu cada opção
-- (`LEGAL_FOCUS_ANNOUNCEMENT`, publicado pelo servidor). Some com o hub e o mapa abertos (ENG-3972).
local ANNOUNCEMENT_KEY = 'LEGAL_FOCUS_ANNOUNCEMENT'
local ANNOUNCEMENT_OPTIONS = { 'policial', 'paramedico' }
-- announcements[option] = { id, org, label, durationSeconds, seenAt }
local announcements = { }
local announcementCovered = { hub = false, map = false }
local announcementShown = false

local function SendAnnouncements()
    local list = { }

    if not announcementCovered.hub and not announcementCovered.map and IsStaff( vRP.GetPlayerGroups() or { } ) then
        local now = GetGameTimer()

        for _, option in ipairs( ANNOUNCEMENT_OPTIONS ) do
            local entry = announcements[ option ]
            local remaining = entry and entry.durationSeconds - ( now - entry.seenAt ) / 1000

            if remaining and remaining > 0 then
                list[ #list + 1 ] = {
                    option = option, org = entry.org, label = entry.label,
                    remainingSeconds = math.ceil( remaining ), durationSeconds = entry.durationSeconds,
                }
            end
        end
    end

    -- Lista vazia só vai pra NUI pra fechar o que estava na tela.
    if #list == 0 and not announcementShown then return end

    announcementShown = #list > 0
    TriggerEvent( 'dashboard:factionFocus', { action = 'legalFocusStaff:state', data = { announcements = list } } )
end

---@param value table|nil
local function ApplyAnnouncements( value )
    local now, current = GetGameTimer(), { }

    for _, option in ipairs( ANNOUNCEMENT_OPTIONS ) do
        local entry = type( value ) == 'table' and value[ option ]

        if type( entry ) == 'table' and type( entry.id ) == 'string' then
            local previous = announcements[ option ]

            current[ option ] = {
                id = entry.id, org = entry.org, label = entry.label,
                durationSeconds = tonumber( entry.durationSeconds ) or 30,
                seenAt = previous and previous.id == entry.id and previous.seenAt or now,
            }
        end
    end

    announcements = current
    SendAnnouncements()
end

AddStateBagChangeHandler( ANNOUNCEMENT_KEY, 'global', function( _, _, value )
    ApplyAnnouncements( value )
end )

AddEventHandler( 'hub:visibilityChanged', function( visible )
    announcementCovered.hub = visible == true
    SendAnnouncements()
end )

AddEventHandler( 'hud:pauseMenu:visibilityChanged', function( visible )
    announcementCovered.map = visible == true
    SendAnnouncements()
end )

RegisterNetEvent( 'playerGroups:AddGroup', function() Reconcile(); SendAnnouncements() end )
RegisterNetEvent( 'playerGroups:RemoveGroup', function() Reconcile(); SendAnnouncements() end )
RegisterNetEvent( 'missions:updatePlayerData', function() SetTimeout( 100, Reconcile ) end )

-- Ramo do iniciante muda sem evento próprio.
CreateThread( function()
    ApplyDisplay( GlobalState[ 'LEGAL_FOCUS_DISPLAY' ] )
    ApplyAnnouncements( GlobalState[ ANNOUNCEMENT_KEY ] )

    while true do
        Wait( RECONCILE_MS )
        if next( currentSlots ) then Reconcile() end
    end
end )

AddEventHandler( 'onResourceStop', function( res )
    if res ~= resourceName then return end

    for nuiId in pairs( activeWaypoints ) do RemoveWaypoint( nuiId ) end
    for nuiId in pairs( activeBlips ) do RemoveLegalBlip( nuiId ) end
    announcements = { }
    SendAnnouncements()
end )
