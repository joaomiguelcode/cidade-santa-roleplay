--[[
	Partículas nos props: máscara Skorpion, máscara Sub-Zero, chapéu Raiden.
	Client-only (natives de partículas).
]]

if IsDuplicityVersion() then
	return
end

---@class LutasMortaisPtfxConfig
---@field asset string
---@field effect string
---@field offset number[]
---@field rot number[]
---@field scale number
---@field boneName? string nome do osso no **prop** (ex.: Bone.002); omitir ou nil = osso raiz (0)

---@alias LutasMortaisPtfxInteractionConfig LutasMortaisPtfxConfig | LutasMortaisPtfxConfig[]

---@type table<string, LutasMortaisPtfxInteractionConfig>
local CONFIG = {
	collectible_flamemask = {
		{
			asset = 'core',
			effect = 'fire_wrecked_plane_cockpit',
			boneName = 'Bone.002',
			offset = { 0.0, 0.0, 0.0 },
			rot = { -110.0, 85.0, -150.0 },
			scale = 0.05,
		},
		{
			asset = 'core',
			effect = 'fire_wrecked_plane_cockpit',
			boneName = 'Bone.001',
			offset = { 0.0, 0.0, 0.0 },
			rot = { -90.0, 85.0, -50.0 },
			scale = 0.05,
		}
    },
	collectible_freezemask = {
		asset = 'core',
		effect = 'exp_grd_bzgas_smoke',
		offset = { 0.0, 0.0, 0.1 },
		rot = { 0.0, 0.0, 0.0 },
		scale = 0.1,
	},
	collectible_stormhat = {
		asset = 'scr_martin1',
		effect = 'scr_sol1_plane_elec_crackle',
		offset = { 0.0, 0.2, 0.0 },
		rot = { 0.0, 0.0, 0.0 },
		scale = 0.5,
	},
}

---@param asset string
local function LoadParticleFxAsset( asset )
	while not HasNamedPtfxAssetLoaded( asset ) do
		RequestNamedPtfxAsset( asset )
		Wait( 10 )
	end

	return true
end

---@param interactionCfg LutasMortaisPtfxInteractionConfig
---@return LutasMortaisPtfxConfig[]
local function GetPtfxEffectList( interactionCfg )
	local first = interactionCfg[ 1 ]
	if type( first ) == 'table' and first.asset ~= nil and first.effect ~= nil then
		return interactionCfg --[[ @as LutasMortaisPtfxConfig[] ]]
	end

	return { interactionCfg --[[ @as LutasMortaisPtfxConfig ]] }
end

---@type table<number, number[]>
local gPtfxByEntity = {}

---@param interactionName string
---@param entityId number
local function StartLutasMortaisPtfx( interactionName, entityId )
	local interactionCfg = CONFIG[ interactionName ]
	if not interactionCfg then
		return
	end

	local prop = exports.scripted_interactions:getLocalScriptedInteractionPropId( entityId )

	if not ( prop and DoesEntityExist( prop ) ) then
		sx.logger:error( ( 'ScriptedInteraction Lutas Mortais ptfx :: prop not found (%s)!' ):format( interactionName ) )
		return
	end

	local effects = GetPtfxEffectList( interactionCfg )

	if not gPtfxByEntity[ entityId ] then
		gPtfxByEntity[ entityId ] = {}
	end

	for _, cfg in ipairs( effects ) do

		if not LoadParticleFxAsset( cfg.asset ) then
			sx.logger:error( ( 'ScriptedInteraction Lutas Mortais ptfx :: failed to load asset %s (%s)!' ):format( cfg.asset, interactionName ) )
		else
			local boneIdx = 0
			local boneName = cfg.boneName
			if boneName and boneName ~= '' then
				local idx = GetEntityBoneIndexByName( prop, boneName )
				if idx ~= -1 then
					boneIdx = idx
				else
					sx.logger:warn( ( 'ScriptedInteraction Lutas Mortais ptfx :: bone "%s" not found on prop (%s), using root.' ):format( boneName, interactionName ) )
				end
			end

			UseParticleFxAssetNextCall( cfg.asset )

			print('created effect', cfg.effect)

			local ptfx = StartNetworkedParticleFxLoopedOnEntityBone(
				cfg.effect,
				prop,
				cfg.offset[ 1 ],
				cfg.offset[ 2 ],
				cfg.offset[ 3 ],
				cfg.rot[ 1 ],
				cfg.rot[ 2 ],
				cfg.rot[ 3 ],
				boneIdx,
				cfg.scale,
				0,
				0,
				0,
				1065353216,
				1065353216,
				1065353216,
				0
			)

			table.insert( gPtfxByEntity[ entityId ], ptfx )
		end
	end
end

---@param entityId number
local function StopLutasMortaisPtfx( entityId )
	local handles = gPtfxByEntity[ entityId ]
	if not handles then
		return
	end

	for _, h in ipairs( handles ) do
		StopParticleFxLooped( h, false )
	end

	gPtfxByEntity[ entityId ] = nil
end

---@param interactionName string
---@param entityId number
AddEventHandler( 'scripted_interactions:onLocalScriptedInteractionStarted', function( interactionName, entityId )

	if not CONFIG[ interactionName ] then
		return
	end

	StartLutasMortaisPtfx( interactionName, entityId )
end )

AddEventHandler( 'scripted_interactions:onLocalScriptedInteractionStopped', function( interactionName, entityId )

	if not CONFIG[ interactionName ] then
		return
	end

	StopLutasMortaisPtfx( entityId )
end )
