local animDict = 'poisonstoresprayanim@animation'
local animName = 'poisonstoresprayanim_clip'
local ptfxPlacement = { 0.0, -0.05, -0.15, 0.0, 0.0, 0.0 }
local ptfxAsset = 'scr_playerlamgraff'
local ptfxName = 'scr_lamgraff_paint_spray'
local SCALE_EFFECT = 2.0


local COLORS_EFFECT = {
	{0.255, 0.48, 0.255},
	{0.18, 0.109, 0.255},
	{0.238, 0.250, 0.12},
	{0.17, 0.245, 0.5},
	{0.226, 0.10, 0.255}
}


local function GetRandomColor()
	return COLORS_EFFECT[math.random(1, #COLORS_EFFECT)]
end

DEFINE_SCRIPTED_INTERACTION 'collectible_spraycarnaval' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		animation = {
			dict  = animDict,
			name  = animName,
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		},

		props =
		{
			{
				modelName      = 'poisonstorecarnaval13',
				boneId         = 28422,

				offsetPosition = vector3(0.015303865603187, -0.0075115841288926, -0.017609076607578),
				offsetRotation = vector3(123.9166552015, -32.900022556719, 136.45599906275),
			}
		}
	}
}

---@param asset string
local function LoadParticleFxAsset(asset)
	while not HasNamedPtfxAssetLoaded(asset) do
		RequestNamedPtfxAsset(asset)
		Wait(10)
	end
	return true
end

---@param interactionName string
---@param entityId number
AddEventHandler('scripted_interactions:onLocalScriptedInteractionStarted', function(interactionName, entityId)
	if interactionName ~= 'collectible_spraycarnaval' then
		return
	end

	local prop = exports.scripted_interactions:getLocalScriptedInteractionPropId(entityId)

	assert(prop ~= nil, 'ScriptedInteraction Collectible Spray Carnaval :: prop not found!')

	if not LoadParticleFxAsset(ptfxAsset) then
		sx.logger:error(('ScriptedInteraction Collectible Spray Carnaval :: failed to load particle fx asset %s!')
			:format(ptfxAsset))
		return
	end

	UseParticleFxAssetNextCall(ptfxAsset)

	local ptfx = StartNetworkedParticleFxLoopedOnEntityBone(
		ptfxName,
		prop, 
		ptfxPlacement[ 1 ], 
		ptfxPlacement[ 2 ], 
		ptfxPlacement[ 3 ], 
		ptfxPlacement[ 4 ], 
		ptfxPlacement[ 5 ], 
		ptfxPlacement[ 6 ], 
		GetEntityBoneIndexByName( prop, 'VFX' ), 
		SCALE_EFFECT, 
		0, 
		0, 
		0, 
		1065353216, 
		1065353216,
		1065353216, 
		0
	)

	local r,g,b = table.unpack(GetRandomColor())

	SetParticleFxLoopedColour(ptfx, r, g, b, false)
end)
