local GRID_SIZE = 50.0
local PARTICLE_DICT = 'scr_indep_fireworks'
local PARTICLE_NAMES = {
'scr_indep_firework_sparkle_spawn',
'scr_indep_firework_starburst',
'scr_indep_firework_fountain',
'scr_indep_firework_trailburst_spawn',
'scr_indep_firework_shotburst',
'scr_indep_firework_burst_spawn',
'scr_indep_firework_trailburst',
'scr_indep_firework_trail_spawn',
}

local FIREWORK_BOX_MODEL = `ind_prop_firework_03`

---@enum FireworkType
local FireworkType = {
	COMMON  = 'firework_common',
	RARE 	= 'firework_rare',
	SPECIAL = 'firework_special',
}

---@type table<FireworkType, {r: number, g: number, b: number}>
local FIREWORK_COLORS = {
	[ FireworkType.COMMON ]  = { 
		r = 0.0, 
		g = 0.0, 
		b = 255.0 
	},
	[ FireworkType.RARE ] 	 = { 
		r = 255.0, 
		g = 0.0, 
		b = 255.0 
	},
	[ FireworkType.SPECIAL ] = { 
		r = 255.0, 
		g = 215.0, 
		b = 0.0 
	},
}

local activeFireworks = {}
local nearbyGrids = {}
local particleDictLoaded = false

local function loadParticleDict()
	if particleDictLoaded then
		return true
	end

	RequestNamedPtfxAsset( PARTICLE_DICT )
	
	local timeout = 0
	while not HasNamedPtfxAssetLoaded( PARTICLE_DICT ) and timeout < 5000 do
		Wait( 100 )
		timeout = timeout + 100
	end

	if HasNamedPtfxAssetLoaded( PARTICLE_DICT ) then
		particleDictLoaded = true
		return true
	end

	return false
end

local function getGridKey( x, y )
	local gridX = math.floor( x / GRID_SIZE )
	local gridY = math.floor( y / GRID_SIZE )
	return ('%d:%d'):format( gridX, gridY )
end

local function updateNearbyGrids()
	local ped = PlayerPedId()
	local coords = GetEntityCoords( ped )
	
	nearbyGrids = {}
	
	for dx = -3, 3 do
		for dy = -3, 3 do
			local gridX = math.floor( coords.x / GRID_SIZE ) + dx
			local gridY = math.floor( coords.y / GRID_SIZE ) + dy
			local gridKey = ('%d:%d'):format( gridX, gridY )
			nearbyGrids[gridKey] = true
		end
	end
end

local function isNearby( gridKey )
	return nearbyGrids[gridKey] == true
end

---@param particleName string
---@param particleType string
---@param particleCoords vector3
local function spawnParticle( particleName, particleType, particleCoords )
	if not loadParticleDict() then
		return
	end

	local typeColor = FireworkType[ particleType ] or FireworkType.COMMON
	local color = FIREWORK_COLORS[ typeColor ]

	local heightOffset = math.random( 100, 500 ) / 10.0
	local spreadX = math.random( -50, 50 ) / 10.0
	local spreadY = math.random( -50, 50 ) / 10.0

	local finalCoords = vector3(
		particleCoords.x + spreadX,
		particleCoords.y + spreadY,
		particleCoords.z + heightOffset
	)

	UseParticleFxAssetNextCall( PARTICLE_DICT )
	SetParticleFxNonLoopedColour( color.r, color.g, color.b )
	SetParticleFxNonLoopedAlpha( 1.0 )
	StartNetworkedParticleFxNonLoopedAtCoord(
		particleName,
		finalCoords.x,
		finalCoords.y,
		finalCoords.z,
		0.0,
		0.0,
		0.0,
		math.random( 20, 35 ) / 10.0,
		false,
		false,
		false,
		false
	)
end

local function handleFireworkStateChange( index, value )
	if not value then
		if activeFireworks[ index ] then
			activeFireworks[ index ] = nil
		end
		return
	end

	local gridKey = getGridKey( value.x, value.y )
	local nearby = isNearby( gridKey )
	
	if not activeFireworks[ index ] and nearby then
		activeFireworks[ index ] = true
		spawnParticle( value.particleName, value.particleType, vector3( value.x, value.y, value.z ) )
	end
end

for i = 1, 2048 do
	local stateKey = ('fireworks:%d'):format( i )
	local index = i
	AddStateBagChangeHandler( stateKey, 'global', function( bagName, key, value )
		handleFireworkStateChange( index, value )
	end)
end

CreateThread( function()
	while true do
		Wait( 2000 )
		updateNearbyGrids()
	end
end)