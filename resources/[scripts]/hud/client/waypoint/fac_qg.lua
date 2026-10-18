local ROLE_LIDER   = 'lider'
local ROLE_GERENTE = 'gerente'
local ROLE_FAC     = 'fac'
local ROLE_MEMBRO  = 'membro'
local ROLE_FARM    = 'farm'
local ROLE_PVP     = 'pvp'

local WAYPOINT_COLOR    = '#7C3AED'
local FARM_MAX_DISTANCE = 100.0

local VETERAN_HOURS_THRESHOLD       = 30
local KVP_FIRST_RECRUIT_SESSION     = 'fac_qg:first_recruit_session'

local DEFAULT_SCALES = {
	markerScale        = 1.0,
	markerIconScale    = 0.6,
	indicatorScale     = 0.9,
	indicatorIconScale = 0.70,
}

local ICON_BOX    = 'https://cdn.santagroup.gg/onboarding/box.svg'
local ICON_CROWN  = 'https://cdn.santagroup.gg/onboarding/boxcrown.svg'
local ICON_LOCK   = 'https://cdn.santagroup.gg/onboarding/boxlock.svg'
local ICON_MALOTE = 'https://cdn.santagroup.gg/onboarding/malote.svg'
local ICON_PVP    = 'https://cdn.santagroup.gg/onboarding/skull.svg'

local ROLE_META = {
	[ ROLE_LIDER ]   = { title = _t( 'hud.fac.waypoint.leader_chest' ),  icon = ICON_CROWN  },
	[ ROLE_GERENTE ] = { title = _t( 'hud.fac.waypoint.manager_chest' ), icon = ICON_LOCK   },
	[ ROLE_FAC ]     = { title = _t( 'hud.fac.waypoint.fac_chest' ),     icon = ICON_BOX    },
	[ ROLE_MEMBRO ]  = { title = _t( 'hud.fac.waypoint.member_chest' ),  icon = ICON_BOX    },
	[ ROLE_FARM ]    = { title = _t( 'hud.fac.waypoint.active_farm' ),   icon = ICON_MALOTE },
	[ ROLE_PVP ]     = { title = _t( 'hud.fac.waypoint.pvp_arena' ),     icon = ICON_PVP    },
}

local CHEST_SUFFIX_ROLE = {
	[ '-2$' ] = ROLE_LIDER,
	[ '-3$' ] = ROLE_GERENTE,
	[ '-4$' ] = ROLE_FAC,
}

---@type table<string, string|number>
local activeIds             = {}
local currentQg             = nil
local currentZone           = nil
local insideZone            = false
local hideWaypoints         = false
local isFirstRecruitSession = false

---@return boolean
local function OrgWaypointsHidden()
	local cfg = GetHudConfig()

	return cfg ~= nil and cfg.hideOrgWaypoints == true
end

---@param chestName string|nil
---@return string|nil
local function ChestRoleFromName( chestName )
	if not chestName then
		return nil
	end

	for suffix, role in pairs( CHEST_SUFFIX_ROLE ) do
		if chestName:find( suffix ) then
			return role
		end
	end

	if chestName == 'PlayerChest' then
		return ROLE_MEMBRO
	end

	return nil
end

local function RemoveAllWaypoints()
	for role, id in pairs( activeIds ) do
		exports.hud:waypointRemove( id )

		activeIds[role] = nil
	end
end

---@param role string
---@param coords vector3
local function CreateRoleWaypoint( role, coords )
	local meta = ROLE_META[role]

	if not meta or not coords then
		return
	end

	local id = exports.hud:waypointCreate( {
		coords             = coords,
		title              = meta.title,
		icon               = meta.icon,
		family             = 'faction',
		customBorderColors = WAYPOINT_COLOR,
		markerNuiId        = ('fac_qg_%s'):format( role ),
		parallelDuiLane    = true,
		groupId            = ('fac_qg_%s'):format( role ),
		markerScale        = DEFAULT_SCALES.markerScale,
		markerIconScale    = DEFAULT_SCALES.markerIconScale,
		indicatorScale     = DEFAULT_SCALES.indicatorScale,
		indicatorIconScale = DEFAULT_SCALES.indicatorIconScale,
		markerDistance     = 9999.0,
		indicatorDistance  = 150.0,
		seeThroughWalls    = true,
	} )

	if id then
		activeIds[role] = id
	end
end

---@param value any
---@return vector3|nil
local function AsVector( value )
	if not value then
		return nil
	end

	if value.x then
		return vector3( value.x, value.y, value.z or 0.0 )
	end

	return nil
end

---@param points table|nil
---@return vector3|nil
local function PolygonCentroid( points )
	if not points or #points == 0 then
		return nil
	end

	local sumX, sumY, sumZ = 0.0, 0.0, 0.0
	local count            = 0

	for i = 1, #points do
		local p = AsVector( points[i] )

		if p then
			sumX  = sumX + p.x
			sumY  = sumY + p.y
			sumZ  = sumZ + p.z
			count = count + 1
		end
	end

	if count == 0 then
		return nil
	end

	return vector3( sumX / count, sumY / count, sumZ / count )
end

---@param cfg table
---@return vector3|nil
local function GetFacAnchor( cfg )
	if not cfg then
		return nil
	end

	local risk  = cfg.RISK_ZONES
	local entry = risk and risk[ 1 ]

	if not entry then
		return nil
	end

	local asVec = AsVector( entry )

	if asVec then
		return asVec
	end

	return PolygonCentroid( entry )
end

---@return table|nil
local function GetFarmerDefCoords()
	local ok, farms = pcall( 
		function()
			return exports.farmer:GetDefCoords()
		end
	)

	if not ok then
		return nil
	end

	return farms
end

---@param cfg table
---@return vector3|nil
local function ResolveFacFarmCoords( cfg )
	local anchor = GetFacAnchor( cfg )

	if not anchor then
		-- sx.logger:debug( ('[fac_qg-farm] %s sem anchor (RISK_ZONES ausente ou vazio)'):format( tostring( currentQg ) ) )
		return nil
	end

	local farms = GetFarmerDefCoords()

	if not farms then
		-- sx.logger:debug( ('[fac_qg-farm] %s farmer:GetDefCoords falhou'):format( tostring( currentQg ) ) )
		return nil
	end

	local bestCoords     = nil
	local bestDistance   = FARM_MAX_DISTANCE
	local nearestSeen    = math.huge

	for i = 1, #farms do
		local coords   = farms[i]
		local distance = #( coords - anchor )

		if distance < nearestSeen then
			nearestSeen = distance
		end

		if distance < bestDistance then
			bestDistance = distance
			bestCoords   = coords
		end
	end

	if not bestCoords then
		-- sx.logger:debug( ('[fac_qg-farm] %s sem farm <= %.1fm (mais perto: %.1fm, total=%d)'):format(
			-- tostring( currentQg ), FARM_MAX_DISTANCE, nearestSeen, #farms
		-- ))
	end

	return bestCoords
end

---@return number
local function GetPlayedHours()
	return math.floor( 
		( Entity( PlayerPedId() ).state.tracking or 0 ) / 3600 
	)
end

---@return boolean
local function IsInicianteGroup()
	local groups = vRP.GetPlayerGroups() or {}
	return groups[ 'Iniciante' ] ~= nil
end


local function ShouldShowChestWaypoints()
	if IsInicianteGroup() then
		return true
	end

	if isFirstRecruitSession then
		return true
	end

	if GetPlayedHours() > VETERAN_HOURS_THRESHOLD then
		return false
	end

	return true
end

---@param cfg table
local function ShowChestWaypoints( cfg )
	if not ShouldShowChestWaypoints() then
		return
	end

	local chests = cfg.CHESTS or {}

	for i = 1, #chests do
		local chest = chests[i]
		local role  = ChestRoleFromName( chest.Name )

		if role and chest.Coords and not activeIds[role] then
			CreateRoleWaypoint( role, chest.Coords )
		end
	end

	if isFirstRecruitSession and sx and sx.kvp then
		sx.kvp.set( KVP_FIRST_RECRUIT_SESSION, 0 )
	end
end

---@param cfg table
---@return vector3|nil
local function ResolvePvpArenaCoords( cfg )
	local pvp   = cfg.WORLD_PVP

	local entry = pvp and pvp[ 1 ]
    
	local coord = entry and entry[ 1 ]

	return AsVector( coord )
end

---@param cfg table
local function ShowPvpWaypoint( cfg )
	local coords = ResolvePvpArenaCoords( cfg )

	if not coords then
		return
	end

	CreateRoleWaypoint( ROLE_PVP, coords )
end

---@param cfg table
local function ShowFarmWaypoint( cfg )
	local farmCoords = ResolveFacFarmCoords( cfg )

	if not farmCoords then
		return
	end

	CreateRoleWaypoint( ROLE_FARM, farmCoords )
end

local function ShowWaypoints()
	if not currentQg or not ORGS_CONFIG then
		return
	end

	if next( activeIds ) ~= nil then
		return
	end

	local cfg = ORGS_CONFIG[currentQg]

	if not cfg then
		return
	end

	ShowChestWaypoints( cfg )
	ShowFarmWaypoint( cfg )
	ShowPvpWaypoint( cfg )
end

local function RebuildZone()
	currentZone = nil
	insideZone  = false

	if not currentQg or not ORGS_CONFIG then
		return
	end

	local cfg     = ORGS_CONFIG[currentQg]
	local rdm     = cfg and cfg.RDM_ZONES and cfg.RDM_ZONES[currentQg]
	local points  = rdm and rdm[1]
	local options = rdm and rdm[2] or { name = currentQg }

	if not points then
		-- sx.logger:debug( ('[fac_qg-debug] no RDM_ZONES for %s'):format( tostring( currentQg ) ) )
		return
	end

	currentZone = PolyZone:Create( points, options )
end

---@param job string|nil
---@return string|nil
local function ResolveQgFromJob( job )
	if not job or job == '' then
		return nil
	end

	local cache = GlobalState['GROUP_CACHE']
	local qg    = cache and cache[job]

	if qg and qg ~= '' then
		return qg
	end

	return nil
end

---@param job string|nil
local function HandleJobChange( job )
	local qg = ResolveQgFromJob( job )

	if qg == currentQg then
		return
	end

	currentQg = qg

	RemoveAllWaypoints()
	RebuildZone()
end

local function UpdateZonePresence()
	local hidden = OrgWaypointsHidden()

	if not currentZone then
		if next( activeIds ) ~= nil then
			RemoveAllWaypoints()
		end

		insideZone    = false
		hideWaypoints = hidden

		return
	end

	local coords = GetEntityCoords( PlayerPedId() )
	local inside = currentZone:isPointInside( coords )

	if inside == insideZone and hidden == hideWaypoints then
		return
	end

	insideZone    = inside
	hideWaypoints = hidden

	if inside and not hidden then
		ShowWaypoints()
	else
		RemoveAllWaypoints()
	end
end

AddStateBagChangeHandler( 'Job', nil, function( bagName, _, value )
	local expected = ('player:%d'):format( GetPlayerServerId( PlayerId() ) )

	if bagName ~= expected then
		return
	end

	HandleJobChange( value )
end)

RegisterNetEvent( 'hud:fac_qg:newRecruit', function()
	isFirstRecruitSession = true

	if sx and sx.kvp then
		sx.kvp.set( KVP_FIRST_RECRUIT_SESSION, 1 )
	end

	if insideZone and not hideWaypoints and currentQg and ORGS_CONFIG then
		local cfg = ORGS_CONFIG[ currentQg ]

		if cfg then
			ShowChestWaypoints( cfg )
		end
	end

	-- sx.logger:debug( '[fac_qg] newRecruit recebido — primeira sessão ativada' )
end)

CreateThread( function()
	while GetPlayerServerId( PlayerId() ) == 0 do
		Wait( 250 )
	end

	while not ORGS_CONFIG do
		Wait( 250 )
	end

	if sx and sx.kvp then
		if sx.kvp.get( KVP_FIRST_RECRUIT_SESSION, 'number' ) == 1 then
			isFirstRecruitSession = true
		end
	end

	currentQg = ResolveQgFromJob( LocalPlayer.state.Job )

	RebuildZone()

	while true do
		Wait( 750 )

		UpdateZonePresence()
	end
end)

AddEventHandler( 'onResourceStop', function( res )
	if res ~= GetCurrentResourceName() then
		return
	end

	RemoveAllWaypoints()
end)
