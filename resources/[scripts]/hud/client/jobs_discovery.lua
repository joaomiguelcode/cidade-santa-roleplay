--[[
    Waypoints paralelos (QGs de facção) sincronizados com `FACTIONFOCUS_DISPLAY`.

    Três estágios visuais (ver STAGES):
      EMPREGO            → Iniciante (gates atuais). Roxo, animação padrão.
      FAC_EM_FOCO        → Membros do grupo WallStreet/Orgs (QG selecionado) e
                           membros das próprias facções em foco (somente o QG da sua fac).
                           Roxo, animação padrão.
      INICIANTE_PROXIMO  → Override de FAC_EM_FOCO quando o servidor sinaliza
                           que existe um Iniciante proximo daquele QG (100m na V3).
                           Vermelho, animação pulse.

    ConVars (client; setr no server.cfg):
        setr hud_faction_discovery_enabled 1
]]

local resourceName = GetCurrentResourceName()

local CONVAR_ENABLED = 'hud_faction_discovery_enabled'

local MISSION_ID = 'nova_familia'

local KVP_HUB_OPENED = 'jobsdiscovery:hub_opened'

local DISCOVERY_ICON = 'mask'

local STAGES = {
    EMPREGO = {
        id          = 'EMPREGO',
        titleKey    = 'hud.faction',
        borderColor = '#7C3AED',
        iconVariant = 'mask',
    },
    FAC_EM_FOCO = {
        id          = 'FAC_EM_FOCO',
        titleKey    = 'hud.faction_em_foco',
        borderColor = '#7C3AED',
        iconVariant = 'mask',
    },
    INICIANTE_PROXIMO = {
        id          = 'INICIANTE_PROXIMO',
        titleKey    = 'hud.faction_iniciante_proximo',
        borderColor = '#DC2626',
        iconVariant = 'mask:pulse',
    },
}

local AUDIENCE = {
    INICIANTE      = 'INICIANTE',
    WALLSTREET     = 'WALLSTREET',
    FAC_RECRUITERS = 'FAC_RECRUITERS',
    NONE           = 'NONE',
}

--   { markerNuiId, faction, x, y, z, cycleId?, inicianteNearby? }
local currentTop3 = {}

-- activeWaypoints[markerNuiId] = { id = waypointId, stageId, faction, x, y, z }
local activeWaypoints = {}

-- activeBlips[markerNuiId] = { handle, faction, x, y, z } (somente INICIANTE/WALLSTREET)
local activeBlips = {}

local novaFamiliaDone = false
local hubOpenedOnce   = false

local function logWarn( msg )

    if not ( sx and sx.logger ) then
        return
    end

    -- sx.logger:warn( msg )
end

local function missionsExport( name, ... )

    if GetResourceState( 'missions' ) ~= 'started' then
        return nil
    end

    return exports.missions[ name ]( ... )
end

local function refreshHubOpenedOnce()

    if hubOpenedOnce then
        return true
    end

    if not ( sx and sx.kvp ) then
        return false
    end

    hubOpenedOnce = sx.kvp.get( KVP_HUB_OPENED, 'number' ) == 1

    return hubOpenedOnce
end

local CRIMINAL_BRANCH_RAMO = {
    criminoso  = true,
    empresario = true,
    produtor   = true,
    artista    = true,
}

local function normalizedPlayerRamoKey()

    local r = missionsExport( 'GetPlayerRamo' )

    if type( r ) ~= 'string' then
        return nil
    end

    local k = r:lower():gsub( '^%s+', '' ):gsub( '%s+$', '' )

    if k == '' then
        return nil
    end

    return k:gsub( 'empresário', 'empresario' )
end

local function isCriminalBranchRamo()

    local k = normalizedPlayerRamoKey()

    return k ~= nil and CRIMINAL_BRANCH_RAMO[ k ] == true
end

local function isNovaFamiliaIncomplete()

    local ok = missionsExport( 'MissionNotCompleted', MISSION_ID )

    if ok == nil then
        return true
    end

    return ok
end

local function isFactionDiscoveryEnabledByConvar()
    return GetConvarInt( CONVAR_ENABLED, 1 ) == 1
end

local function playerGroups()
    return vRP.GetPlayerGroups() or {}
end

local function isInicianteGroup()
    return playerGroups()[ 'Iniciante' ] ~= nil
end

local function isWallStreetGroup()
    return ( 
        playerGroups()[ 'WallStreet' ] ~= nil 
        or playerGroups()[ 'Orgs' ] ~= nil 
    )
end

---@param top3 table[]
---@return string|nil faction the local player belongs to (if any in top3)
local function findOwnFactionInTop3( top3 )

    local groups = playerGroups()

    for i = 1, #top3 do
        local f = top3[ i ].faction
        if f and groups[ f ] then
            return f
        end
    end

    return nil
end

---@return string one of AUDIENCE.*
local function resolveAudience()

    if not isFactionDiscoveryEnabledByConvar() then
        return AUDIENCE.NONE
    end

    if isWallStreetGroup() then
        return AUDIENCE.WALLSTREET
    end

    if not novaFamiliaDone
        and refreshHubOpenedOnce()
        and isInicianteGroup()
        and isCriminalBranchRamo()
        and isNovaFamiliaIncomplete() then
        return AUDIENCE.INICIANTE
    end

    if findOwnFactionInTop3( currentTop3 ) and LocalPlayer.state.isFactionRecruiter then
        return AUDIENCE.FAC_RECRUITERS
    end

    return AUDIENCE.NONE
end

local RECRUITER_QG_RADIUS_SQ = 500.0 * 500.0

---@param slot table
---@return boolean
local function IsWithinRecruiterQGRange( slot )

    local px, py = table.unpack( GetEntityCoords( PlayerPedId() ) )
    local dx, dy = slot.x - px, slot.y - py

    return dx * dx + dy * dy <= RECRUITER_QG_RADIUS_SQ
end

---@param slot table
---@param audience string
---@param playerFaction string|nil
---@return boolean
local function shouldShowSlot( slot, audience, playerFaction )

    if audience == AUDIENCE.WALLSTREET then return true end

    if audience == AUDIENCE.INICIANTE then
        return true
    end

    if audience == AUDIENCE.FAC_RECRUITERS and slot.faction == playerFaction then
        return IsWithinRecruiterQGRange( slot )
    end

    return false
end

local lastRecruiterStageSignature

---@param playerFaction string|nil
---@return string
local function BuildRecruiterStageSignature( playerFaction )
    local signatures = {}

    for index = 1, #currentTop3 do
        local slot = currentTop3[ index ]

        if not playerFaction or slot.faction == playerFaction then
            -- Visibilidade global do staff não substitui a distância do recrutador.
            local withinRadius = IsWithinRecruiterQGRange( slot )

            signatures[ #signatures + 1 ] = ( '%s:%s:%s:%s' ):format(
                tostring( slot.cycleId ),
                tostring( slot.faction ),
                tostring( slot.inicianteNearby ),
                tostring( withinRadius )
            )
        end
    end

    return table.concat( signatures, '|' )
end

---@param slot table
---@param audience string
---@param playerFaction string|nil
---@return table stage
local function resolveStage( slot, audience, playerFaction )

    if audience == AUDIENCE.INICIANTE then
        return STAGES.EMPREGO
    end

    if ( audience == AUDIENCE.WALLSTREET or audience == AUDIENCE.FAC_RECRUITERS and slot.faction == playerFaction ) and slot.inicianteNearby then
        if IsWithinRecruiterQGRange( slot ) then
            return STAGES.INICIANTE_PROXIMO
        end
    end

    return STAGES.FAC_EM_FOCO
end

local MARKER_VISIBLE_DISTANCE = 9999.0

---@param slot table
---@param stage table
local function buildWaypointPayload( slot, stage )
    return {
        coords                     = vec3( slot.x + 0.0, slot.y + 0.0, slot.z + 0.0 ),
        title                      = _t( stage.titleKey ),
        icon                       = stage.iconVariant,
        markerNuiId                = slot.markerNuiId,
        parallelDuiLane            = true,
        family                     = 'faction',
        customBorderColors         = stage.borderColor,
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

---@param slot table
---@param stage table
local function createWaypoint( slot, stage )

    local payload = buildWaypointPayload( slot, stage )

    local ok, id = pcall(
        function()
            return exports.hud:waypointCreate( payload )
        end
    )

    if not ok or not id then
        logWarn( ('jobsdiscovery: falha ao criar waypoint nuiId=%s'):format( tostring( slot.markerNuiId ) ) )
        return
    end

    activeWaypoints[ slot.markerNuiId ] = {
        id      = id,
        stageId = stage.id,
        faction = slot.faction,
        x       = slot.x,
        y       = slot.y,
        z       = slot.z,
    }
end

---@param markerNuiId string
local function removeWaypoint( markerNuiId )

    local entry = activeWaypoints[ markerNuiId ]

    if not entry then
        return
    end

    pcall( 
        function()
            exports.hud:waypointRemove( entry.id )
        end
    )

    activeWaypoints[ markerNuiId ] = nil
end

local function removeAllWaypoints()

    for nuiId in pairs( activeWaypoints ) do
        removeWaypoint( nuiId )
    end
end

local BLIP_SPRITE = 1
local BLIP_COLOR  = 27
local BLIP_SCALE  = 0.9

---@param slot table
---@param stage table
local function createBlip( slot, stage )

    local blip = AddBlipForCoord( slot.x + 0.0, slot.y + 0.0, slot.z + 0.0 )

    SetBlipSprite( blip, BLIP_SPRITE )
    SetBlipColour( blip, BLIP_COLOR )
    SetBlipScale( blip, BLIP_SCALE )
    SetBlipAsShortRange( blip, false )
    ShowHeightOnBlip( blip, false )

    BeginTextCommandSetBlipName( 'STRING' )
    AddTextComponentSubstringPlayerName( _t( stage.titleKey ) )
    EndTextCommandSetBlipName( blip )

    activeBlips[ slot.markerNuiId ] = {
        handle  = blip,
        faction = slot.faction,
        x       = slot.x,
        y       = slot.y,
        z       = slot.z,
    }
end

---@param markerNuiId string
local function removeBlip( markerNuiId )

    local entry = activeBlips[ markerNuiId ]

    if not entry then
        return
    end

    if DoesBlipExist( entry.handle ) then
        RemoveBlip( entry.handle )
    end

    activeBlips[ markerNuiId ] = nil
end

local function removeAllBlips()

    for nuiId in pairs( activeBlips ) do
        removeBlip( nuiId )
    end
end

---@param rendered { faction: string, x: number, y: number, z: number }
---@param slot table
---@return boolean
local function slotMoved( rendered, slot )
    return rendered.faction ~= slot.faction
        or rendered.x ~= slot.x
        or rendered.y ~= slot.y
        or rendered.z ~= slot.z
end

local pickedSingleFaction = nil

---@param top3 table[]
---@return table|nil
local function resolveSingleSlot( top3 )

    local assignedId = LocalPlayer.state.factionFocusAssignedId
    for _, slot in ipairs( top3 ) do
        if slot.cycleId == assignedId then return slot end
    end
    if assignedId then return nil end

    if #top3 == 0 then
        pickedSingleFaction = nil
        return
    end

    for i = 1, #top3 do
        if top3[ i ].beginnerFocus then
            return top3[ i ]
        end
    end

    if pickedSingleFaction then
        for i = 1, #top3 do
            if top3[ i ].faction == pickedSingleFaction then
                return top3[ i ]
            end
        end
    end

    local slot = top3[ math.random( #top3 ) ]

    pickedSingleFaction = slot.faction

    return slot
end

local reportedShownFaction = nil
local reportedShownCycleId = nil

---@return string|number|nil
local function activeCycleId()

    local slot = currentTop3[ 1 ]

    return slot and slot.cycleId or nil
end

---@param slot table
---@param force boolean|nil
local function reportShownSlot( slot, force )

    if not slot or not slot.cycleId or not activeWaypoints[ slot.markerNuiId ] then
        return
    end

    if not force
        and reportedShownFaction == slot.faction
        and reportedShownCycleId == slot.cycleId then
        return
    end

    reportedShownFaction = slot.faction
    reportedShownCycleId = slot.cycleId

    TriggerServerEvent( 'net.factionfocus.funnelShown', slot.cycleId, { slot.faction } )
end

---@param audience string
---@param desired  table<string, { slot: table, stage: table }>
local function reportShownSlots( audience, desired )

    if audience ~= AUDIENCE.INICIANTE then
        reportedShownFaction = nil
        reportedShownCycleId = nil
        return
    end

    for nuiId, want in pairs( desired ) do

        local slot = want.slot

        if slot.cycleId and activeWaypoints[ nuiId ] then
            reportShownSlot( slot )
            return
        end
    end
end

local function reconcile()

    if GetResourceState( 'hud' ) ~= 'started' then
        return
    end

    local audience      = resolveAudience()
    local playerFaction = findOwnFactionInTop3( currentTop3 )

    lastRecruiterStageSignature = ( audience == AUDIENCE.FAC_RECRUITERS or audience == AUDIENCE.WALLSTREET )
        and BuildRecruiterStageSignature( audience == AUDIENCE.FAC_RECRUITERS and playerFaction or nil )
        or nil

    if audience == AUDIENCE.NONE then
        reportedShownFaction = nil
        reportedShownCycleId = nil
        removeAllWaypoints()
        removeAllBlips()
        return
    end

    local singleSlot = nil

    if audience == AUDIENCE.INICIANTE then
        singleSlot = resolveSingleSlot( currentTop3 )
    end

    local desired = {} -- markerNuiId → { slot, stage }

    for i = 1, #currentTop3 do
        local slot = currentTop3[ i ]
        if shouldShowSlot( slot, audience, playerFaction )
            and ( audience ~= AUDIENCE.INICIANTE or singleSlot ~= nil )
            and ( singleSlot == nil or slot == singleSlot ) then
            desired[ slot.markerNuiId ] = {
                slot  = slot,
                stage = resolveStage( slot, audience, playerFaction ),
            }
        end
    end

    -- Remove waypoints no longer desired.
    for nuiId in pairs( activeWaypoints ) do
        if not desired[ nuiId ] then
            removeWaypoint( nuiId )
        end
    end

    for nuiId, want in pairs( desired ) do

        local entry = activeWaypoints[ nuiId ]

        if entry and ( entry.stageId ~= want.stage.id or slotMoved( entry, want.slot ) ) then

            local payload = buildWaypointPayload( want.slot, want.stage )

            local ok = pcall(
                function()
                    exports.hud:waypointUpdate( entry.id, payload )
                end
            )

            if ok then
                entry.stageId = want.stage.id
                entry.faction = want.slot.faction
                entry.x       = want.slot.x
                entry.y       = want.slot.y
                entry.z       = want.slot.z
            else
                logWarn( ('jobsdiscovery: falha ao atualizar waypoint nuiId=%s'):format( tostring( nuiId ) ) )
                removeWaypoint( nuiId )
                entry = nil
            end
        end

        if not entry then
            createWaypoint( want.slot, want.stage )
        end
    end

    reportShownSlots( audience, desired )

    local showBlips = audience
    == AUDIENCE.INICIANTE 
    or audience == AUDIENCE.WALLSTREET

    for nuiId in pairs( activeBlips ) do
        if not ( showBlips and desired[ nuiId ] ) then
            removeBlip( nuiId )
        end
    end

    if not showBlips then
        return
    end

    for nuiId, want in pairs( desired ) do

        local blip = activeBlips[ nuiId ]

        if blip and slotMoved( blip, want.slot ) then
            removeBlip( nuiId )
            blip = nil
        end

        if not blip then
            createBlip( want.slot, want.stage )
        end
    end
end

---@param raw table|nil
local function applyTop3( raw )

    local rebuilt = {}

    if type( raw ) == 'table' then
        for i = 1, #raw do
            local p = raw[ i ]
            if p and p.markerNuiId then
                rebuilt[ #rebuilt + 1 ] = {
                    markerNuiId     = p.markerNuiId,
                    faction         = p.faction,
                    x               = p.x or 0.0,
                    y               = p.y or 0.0,
                    z               = p.z or 0.0,
                    cycleId         = p.cycleId,
                    beginnerFocus   = p.beginnerFocus == true,
                    inicianteNearby = p.inicianteNearby == true,
                    beginnerProximityRadius = p.beginnerProximityRadius,
                }
            end
        end
    end

    currentTop3 = rebuilt

    reconcile()
end

---@class FocusStatusAlertDetail
---@field text string
---@field passed boolean|nil

---@class FocusStatusAlertRow
---@field title string
---@field description string
---@field details FocusStatusAlertDetail[]

---@class FocusStatusAlertPayload
---@field title string
---@field summary string
---@field legend string
---@field closeLabel string
---@field rows FocusStatusAlertRow[]

---@param passed boolean|nil
---@return string marker
local function FocusStatusRuleMarker( passed )

    if passed == true then
        return '✅'
    end

    if passed == false then
        return '❌'
    end

    return 'ℹ️'
end

---@param row any
---@return boolean
local function IsFocusStatusAlertRow( row )
    return type( row ) == 'table'
        and type( row.title ) == 'string'
        and type( row.description ) == 'string'
        and type( row.details ) == 'table'
end

---@param data FocusStatusAlertPayload
---@return string|nil content
local function BuildFocusStatusAlertContent( data )

    if type( data ) ~= 'table'
        or type( data.title ) ~= 'string'
        or type( data.summary ) ~= 'string'
        or type( data.legend ) ~= 'string'
        or type( data.closeLabel ) ~= 'string'
        or type( data.rows ) ~= 'table' then
        -- sx.logger:warn( 'factionfocus: payload invalido recebido para o alertDialog de elegibilidade' )
        return nil
    end

    local blocks = {
        ( '**%s**  \n%s' ):format( data.summary, data.legend ),
    }

    for i = 1, #data.rows do

        local row = data.rows[ i ]

        if not IsFocusStatusAlertRow( row ) then
            -- sx.logger:warn( ( 'factionfocus: linha invalida recebida no alertDialog index=%d' ):format( i ) )
        else
            local detailLines = {}

            for detailIndex = 1, #row.details do

                local detail = row.details[ detailIndex ]

                if type( detail ) == 'table' and type( detail.text ) == 'string' then
                    detailLines[ #detailLines + 1 ] = ( '- %s %s' ):format(
                        FocusStatusRuleMarker( detail.passed ),
                        detail.text
                    )
                end
            end

            blocks[ #blocks + 1 ] = ( '### %s  \n%s\n\n%s' ):format(
                row.title,
                row.description,
                table.concat( detailLines, '\n' )
            )
        end
    end

    if #blocks == 1 then
        -- sx.logger:warn( 'factionfocus: alertDialog de elegibilidade recebido sem linhas validas' )
        return nil
    end

    return table.concat( blocks, '\n\n---\n\n' )
end

---@param data FocusStatusAlertPayload
---@return boolean opened
local function OpenFocusStatusAlertDialog( data )

    local content = BuildFocusStatusAlertContent( data )

    if not content then
        return false
    end

    local result = lib.alertDialog( {
        header   = data.title,
        content  = content,
        centered = true,
        cancel   = false,
        size     = 'xl',
        overflow = true,
        labels   = {
            confirm = data.closeLabel,
        },
    } )

    if result == nil then
        -- sx.logger:warn( 'factionfocus: alertDialog de elegibilidade nao abriu porque ja existe outro alerta ativo' )
        return false
    end

    return true
end

RegisterNetEvent( 'hud:factionfocus:openStatusDialog', function( data )
    OpenFocusStatusAlertDialog( data )
end)

RegisterNetEvent( 'hud:factionfocus:openChangeDialog', function( data )

    if type( data ) ~= 'table'
        or type( data.previousAlias ) ~= 'string'
        or type( data.candidateFaction ) ~= 'string'
        or type( data.candidateAlias ) ~= 'string' then
        return
    end

    local input = lib.inputDialog( _t( 'facfoco.order.reason.title' ), {
        {
            type     = 'input',
            label    = _t( 'facfoco.order.current.label' ),
            default  = data.previousAlias,
            disabled = true,
        },
        {
            type     = 'input',
            label    = _t( 'facfoco.order.candidate.label' ),
            default  = data.candidateAlias,
            disabled = true,
        },
        {
            type        = 'textarea',
            label       = _t( 'facfoco.order.reason.label' ),
            description = _t( 'facfoco.order.reason.description' ),
            required    = true,
            autosize    = true,
            minRows     = 3,
            maxRows     = 6,
            minLength   = 1,
            maxLength   = 200,
        },
        {
            type     = 'checkbox',
            label    = ( _t( 'facfoco.order.confirm' ) ):format( data.candidateAlias ),
            required = true,
        },
    }, {
        allowCancel = true,
        size        = 'md',
    } )

    if not input then
        return
    end

    local success, errorCode, selectedAlias, remainingSeconds = lib.callback.await(
        'hud:factionfocus:changeDisplay',
        false,
        data.candidateFaction,
        input[ 3 ],
        input[ 4 ] == true
    )

    local description

    if success then
        description = ( _t( 'facfoco.order.success' ) ):format( selectedAlias )
    elseif errorCode == 'cooldown' then
        local remaining = math.max( 0, math.floor( tonumber( remainingSeconds ) or 0 ) )
        description = ( _t( 'facfoco.order.cooldown' ) ):format(
            ( '%d:%02d' ):format( math.floor( remaining / 60 ), remaining % 60 )
        )
    elseif errorCode == 'none' then
        description = _t( 'facfoco.order.none' )
    elseif errorCode == 'no_top2' then
        description = _t( 'facfoco.order.no_top2' )
    elseif errorCode == 'all_vetoed' then
        description = _t( 'facfoco.order.all_vetoed' )
    elseif errorCode == 'same' then
        description = _t( 'facfoco.order.no_change' )
    else
        description = _t( 'facfoco.order.failed' )
    end

    lib.notify( {
        title       = _t( 'facfoco.order.title' ),
        description = description,
        type        = success and 'success' or 'error',
    } )
end)

---@return table|nil input
function Creative.RequestFactionFocusForceInput()

	local input = lib.inputDialog( _t( 'facfoco.force.title' ), {
		{
			type        = 'input',
			label       = _t( 'facfoco.force.faction.label' ),
			description = _t( 'facfoco.force.faction.description' ),
			required    = true,
			minLength   = 1,
			maxLength   = 64,
		},
		{
			type        = 'textarea',
			label       = _t( 'facfoco.order.reason.label' ),
			description = _t( 'facfoco.order.reason.description' ),
			required    = true,
			autosize    = true,
			minRows     = 3,
			maxRows     = 6,
			minLength   = 1,
			maxLength   = 200,
		},
	}, {
		allowCancel = true,
		size        = 'md',
	} )

	if not input then
		return nil
	end

	return {
		faction = input[ 1 ],
		reason  = input[ 2 ],
	}
end

AddStateBagChangeHandler( 'factionFocusAssignedId', nil, function( bagName )
    if bagName == ( 'player:%d' ):format( GetPlayerServerId( PlayerId() ) ) then
        SetTimeout( 0, function() reconcile() end )
    end
end )

AddStateBagChangeHandler( 'FACTIONFOCUS_DISPLAY', 'global', function( _, _, value )
    applyTop3( value )
end)

AddStateBagChangeHandler( 'isFactionRecruiter', ('player:%d'):format( GetPlayerServerId( PlayerId() ) ), function()
    reconcile()
end)

CreateThread( function()
    applyTop3( GlobalState[ 'FACTIONFOCUS_DISPLAY' ] )
end)

CreateThread( function()

    local deadline = GetGameTimer() + 30000

    while GetGameTimer() < deadline do

        if GetResourceState( 'hud' ) == 'started' and normalizedPlayerRamoKey() ~= nil then
            break
        end

        Wait( 250 )
    end

    reconcile()
end)

RegisterNetEvent( 'missions:updatePlayerData', function()
    CreateThread( 
        function()
            Wait( 100 )
            reconcile()
        end
    )
end)

RegisterNetEvent( 'missions:client:missionCompleted', function( missionId )

    if missionId == MISSION_ID then
        novaFamiliaDone = true
    end

    reconcile()
end)

AddEventHandler( 'hud:jobsDiscovery:hubOpened', function()

    if hubOpenedOnce then
        return
    end

    hubOpenedOnce = true
    sx.kvp.set( KVP_HUB_OPENED, true )

    reconcile()
end)

AddEventHandler( 'hub:visibilityChanged', function( visible )
    if not visible then
        removeAllWaypoints()
        reconcile()
    end
end )

RegisterNetEvent( 'playerGroups:RemoveGroup', function( _ )
    reconcile()
end)

RegisterNetEvent( 'playerGroups:AddGroup', function( _ )
    reconcile()
end)

AddEventHandler( 'onResourceStop', function( res )

    if res ~= resourceName then
        return
    end

    removeAllWaypoints()
    removeAllBlips()
end)

local INICIANTE_PROX_RADIUS_SQ  = 20.0 * 20.0
local PROXIMITY_POLL_MS         = 500

local reportedNearby = {} -- [faction] = 'nearby' ou 'arrived'

local PROXIMITY_RATELIMIT_KEY = 'inicianteProximity'

local proximityRatelimiter

local function ensureProximityRatelimiter()

    if proximityRatelimiter == nil and sx and sx.ratelimiter then
        proximityRatelimiter = sx.ratelimiter.new({
            strategy = sx.ratelimiter.strategies.fixedWindow({ windowMs = 500 }),
        })
    end

    return proximityRatelimiter
end

---@param faction string
---@param nearby boolean
---@param force boolean|nil
---@return boolean
local function emitProximity( faction, nearby, force )

    local rl = ensureProximityRatelimiter()

    if  not force 
        and rl 
        and not rl:consume( PROXIMITY_RATELIMIT_KEY ) 
    then
        return false
    end

    TriggerServerEvent( 'net.factionfocus.beginnerNearby', faction, nearby )

    return true
end

local function clearReportedNearby()
    for faction in pairs( reportedNearby ) do
        emitProximity( faction, false, true )
        reportedNearby[ faction ] = nil
    end
end

AddEventHandler( 'onResourceStop', function( res )

    if res ~= resourceName then
        return
    end

    clearReportedNearby()
end)

local lastProxCycleId = nil

CreateThread( function()

    while true do

        Wait( PROXIMITY_POLL_MS )

        local audience = resolveAudience()

        if audience == AUDIENCE.FAC_RECRUITERS or audience == AUDIENCE.WALLSTREET then
            if next( reportedNearby ) ~= nil then
                clearReportedNearby()
            end

            local signature = BuildRecruiterStageSignature(
                audience == AUDIENCE.FAC_RECRUITERS and findOwnFactionInTop3( currentTop3 ) or nil
            )

            if signature ~= lastRecruiterStageSignature then
                reconcile()
            end

            goto continue
        end

        lastRecruiterStageSignature = nil

        if audience ~= AUDIENCE.INICIANTE then

            if next( reportedNearby ) ~= nil then
                clearReportedNearby()
            end

            goto continue
        end

        local cycleId      = activeCycleId()
        local cycleChanged = cycleId ~= nil and cycleId ~= lastProxCycleId

        lastProxCycleId = cycleId

        local ped    = PlayerPedId()
        local px, py = table.unpack( GetEntityCoords( ped ) )

        local present    = {}
        local singleSlot = resolveSingleSlot( currentTop3 )

        if singleSlot then
            local slot = singleSlot
            local dx   = slot.x - px
            local dy   = slot.y - py

            local radiusSq = slot.beginnerProximityRadius and slot.beginnerProximityRadius ^ 2 or INICIANTE_PROX_RADIUS_SQ

            if ( dx * dx + dy * dy ) <= radiusSq then
                present[ slot.faction ] = ( dx * dx + dy * dy ) <= INICIANTE_PROX_RADIUS_SQ and 'arrived' or 'nearby'
            end
        end

        for faction, proximity in pairs( present ) do
            if ( reportedNearby[ faction ] ~= proximity or cycleChanged )
                and emitProximity( faction, true, cycleChanged ) then
                reportedNearby[ faction ] = proximity
            end
        end

        for faction in pairs( reportedNearby ) do
            if not present[ faction ] and emitProximity( faction, false ) then
                reportedNearby[ faction ] = nil
            end
        end

        ::continue::
    end
end)

local _activeCache, _activeCacheUntil = nil, 0

exports( 'isFactionDiscoveryActive', function()

    local now = GetGameTimer()

    if _activeCache ~= nil and now < _activeCacheUntil then
        return _activeCache
    end
    _activeCache      = resolveAudience() ~= AUDIENCE.NONE
    _activeCacheUntil = now + 1000

    return _activeCache
end)
