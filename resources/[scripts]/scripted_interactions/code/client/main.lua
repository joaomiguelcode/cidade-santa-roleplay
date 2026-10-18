-- ---@type table<number, ScriptedInteraction>
-- local gScriptedInteractions = { }

---@type table<number, table<number, ScriptedInteraction>>
local gScriptedInteractionByEntityId = { }

local SCRIPTED_INTERACTION_STREAMING_TIMEOUT_MS = 5000

---@param modelName string|number
---@return number
local function GetScriptedInteractionModelHash( modelName )

	if type( modelName ) == 'number' then
		return modelName
	end

	return joaat( modelName )
end

---@param interaction ScriptedInteraction
---@param interactionPropDef ScriptedInteractionPropDef
---@return boolean
local function CreateScriptedInteractionPropLocally( interaction, interactionPropDef )

	local offsetPropPosition = vector3( 0.0, 0.0, 0.0 )
	local offsetPosition = interactionPropDef.offsetPosition or vector3( 0.0, 0.0, 0.0 )	
	local offsetRotation = interactionPropDef.offsetRotation or vector3( 0.0, 0.0, 0.0 )
	local modelHash = GetScriptedInteractionModelHash( interactionPropDef.modelName )
    
	local boneIndex = GetPedBoneIndex( interaction.entityId, interactionPropDef.boneId )
	if type(interactionPropDef.boneId) ~= 'number' then -- feito isso pois tem um colecionavel bola de ouro que ele não fica com attached no ped
		offsetPropPosition = GetOffsetFromEntityInWorldCoords(
			interaction.entityId,
			offsetPosition.x,
			offsetPosition.y,
			offsetPosition.z
		)
	end

	local propEntityId = CreateObjectNoOffset( modelHash, offsetPropPosition.x, offsetPropPosition.y, offsetPropPosition.z, false, false, false )

	if propEntityId == 0 or not DoesEntityExist( propEntityId ) then
		sx.logger:error(
			('Failed to create scripted interaction prop interaction="%s" model="%s" entity=%d')
				:format( interaction.def.name, tostring( interactionPropDef.modelName ), interaction.entityId )
		)
		SetModelAsNoLongerNeeded( modelHash )
		return false
	end

	if type(interactionPropDef.boneId) ~= 'number' then -- feito isso pois tem um colecionavel bola de ouro que ele não fica com attached no ped
		local heading = GetEntityHeading(interaction.entityId)

		SetEntityRotation(
			propEntityId,
			offsetRotation.x,
			offsetRotation.y,
			heading + offsetRotation.z,
			2,
			true
		)
	end

	if not IsEntityVisible(interaction.entityId) then
		SetEntityVisible(propEntityId, false, false)
	end

	table.insert( interaction.propEntityIds, propEntityId )

	SetEntityAsMissionEntity( propEntityId, true, true )
	if type(interactionPropDef.boneId) == 'number' then 
		AttachEntityToEntity( propEntityId, interaction.entityId, boneIndex, offsetPosition.x, offsetPosition.y, offsetPosition.z, offsetRotation.x, offsetRotation.y, offsetRotation.z, false, false, false, interactionPropDef.attachAsPed == true, 1, true )
	end

	SetModelAsNoLongerNeeded( modelHash )
	if interactionPropDef.animDict then
		PlayEntityAnim( propEntityId, interactionPropDef.animName, interactionPropDef.animDict, 8.0, true, true, false, 0, 0 )
		RemoveAnimDict( interactionPropDef.animDict )
	end

	if interactionPropDef.animDict2 then
		PlayEntityAnim( propEntityId, interactionPropDef.animName2, interactionPropDef.animDict2, 8.0, true, true, false, 0, 0 )
		RemoveAnimDict( interactionPropDef.animDict2 )
	end

	return true
end

---@param interaction ScriptedInteraction
---@param ptfxDef ScriptedInteractionPtfxDef
local function StartScriptedInteractionPtfxLocally( interaction, ptfxDef )

	local target = interaction.entityId

	if ptfxDef.onProp and interaction.propEntityIds[ 1 ] and DoesEntityExist( interaction.propEntityIds[ 1 ] ) then
		target = interaction.propEntityIds[ 1 ]
	end

	local boneIndex = -1
	if ptfxDef.boneName then
		boneIndex = GetEntityBoneIndexByName( target, ptfxDef.boneName )
	elseif ptfxDef.boneId then
		boneIndex = GetPedBoneIndex( interaction.entityId, ptfxDef.boneId )
	end
	local offsetPosition = ptfxDef.offsetPosition
	local offsetRotation = ptfxDef.offsetRotation

	UseParticleFxAsset( ptfxDef.asset )

	local ptfxHandle = StartNetworkedParticleFxLoopedOnEntityBone(
		ptfxDef.name,
		target,
		offsetPosition.x, offsetPosition.y, offsetPosition.z,
		offsetRotation.x, offsetRotation.y, offsetRotation.z,
		boneIndex,
		ptfxDef.scale + 0.0,
		false, false, false
	)

	local color = ptfxDef.color

	if color then

		if color[ 1 ] and type( color[ 1 ] ) == 'table' then
			color = color[ math.random( 1, #color ) ]
		end

		SetParticleFxLoopedAlpha( ptfxHandle, color.A )
		SetParticleFxLoopedColour( ptfxHandle, color.R / 255, color.G / 255, color.B / 255, false )
	end

	interaction.ptfxHandle = ptfxHandle
	interaction.ptfxAsset = ptfxDef.asset
end

---@param interaction ScriptedInteraction
local function StopScriptedInteractionPtfxLocally( interaction )

	if not interaction.ptfxHandle then
		return
	end

	StopParticleFxLooped( interaction.ptfxHandle, false )
	RemoveNamedPtfxAsset( interaction.ptfxAsset )

	interaction.ptfxHandle = nil
	interaction.ptfxAsset = nil
end

---@param interaction ScriptedInteraction
local function StoreScriptedInteraction( interaction )

	-- print('StoreScriptedInteraction', interaction.entityId)

	local interactionsBySlot = gScriptedInteractionByEntityId[ interaction.entityId ]

	if not interactionsBySlot then
		interactionsBySlot = { }
		gScriptedInteractionByEntityId[ interaction.entityId ] = interactionsBySlot
	end

	interactionsBySlot[ interaction.slot ] = interaction
end

---@param interaction ScriptedInteraction
local function FreeScriptedInteraction( interaction )

	-- print('FreeScriptedInteraction',  interaction.entityId)

	local interactionsBySlot = gScriptedInteractionByEntityId[ interaction.entityId ]

	assert( interactionsBySlot and interactionsBySlot[ interaction.slot ] == interaction )

	interactionsBySlot[ interaction.slot ] = nil

	if not next( interactionsBySlot ) then
		gScriptedInteractionByEntityId[ interaction.entityId ] = nil
	end
end

---@param interactionDef ScriptedInteractionDef
---@return boolean
local function GetScriptedInteractionDefHasProps( interactionDef )

	return interactionDef.props ~= nil or interactionDef.prop ~= nil
end

---@param interactionDef ScriptedInteractionDef
---@return ScriptedInteractionPropDef[]
local function GetScriptedInteractionDefProps( interactionDef )

	return interactionDef.props or { interactionDef.prop }
end

---@param interaction ScriptedInteraction
---@return boolean
local function AreScriptedInteractionPropsCreated( interaction )

	return #interaction.propEntityIds > 0
end

---@param interaction ScriptedInteraction
---@param immediately boolean
local function CleanupScriptedInteractionState( interaction, immediately )

	-- print( ('CleanupScriptedInteractionState :: interaction.state.name="%s" interaction.propEntityId=%s immediately=%s'):format( GetScriptedInteractionStateDef( interaction ).name, interaction.propEntityId, immediately ) )

	local interactionStateDef = GetScriptedInteractionStateDef( interaction )

	StopScriptedInteractionPtfxLocally( interaction )

	-- print( '( interactionStateDef.flags & eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP ) ~= 0 =', ( interactionStateDef.flags & eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP ) ~= 0  )

	-- Temos a flag de deletar todos os props ou estamos forçando o cleanup?
	if ( interactionStateDef.flags & eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP ) ~= 0 --[[ or immediately --]] then

		-- Temos um prop?
		-- TODO: Deduplicar codigo
		if AreScriptedInteractionPropsCreated( interaction ) then

			for _, propEntityId in ipairs( interaction.propEntityIds ) do

				DetachEntity( propEntityId, true, false )

				DeleteEntity( propEntityId )
			end

			table.wipe( interaction.propEntityIds )
		end
	end

	-- Caso o prop ainda exista, o comportamento padrão é só o dettach!
	if AreScriptedInteractionPropsCreated( interaction ) then

		-- Esse state NÃO tem a flag de manter o prop anterior?
		if not ( ( interactionStateDef.flags & eScriptedInteractionStateFlags.STATE_TRANSITION__KEEP_ALL_PROP ) ~= 0 ) then

			for _, propEntityId in ipairs( interaction.propEntityIds ) do

				DetachEntity( propEntityId, true, false )

				SetEntityAsNoLongerNeeded( propEntityId )
			end

			table.wipe( interaction.propEntityIds )
		end
	end

	local interactionStateDef = GetScriptedInteractionStateDef( interaction )

	if interactionStateDef.animation and not IsCloneScriptedInteraction( interaction ) then
		StopAnimTask( interaction.entityId, interactionStateDef.animation.dict, interactionStateDef.animation.name, 2.0 )

		-- print('cleanedup taskas')
	end
end

---@param interaction ScriptedInteraction
---@param immediately boolean
local function StopClientEntityScriptedInteraction( interaction, immediately )

	-- print( ('StopClientEntityScriptedInteraction :: interaction.def.name="%s" immediately=%s interaction.isStopped=%s interaction.isStopping=%s'):format( interaction.def.name, immediately, interaction.isStopped, interaction.isStopping ) )

	-- print( 'StopClientEntityScriptedInteraction :: trace', debug.traceback() )

	if interaction.isStopped then
		return
	end

	interaction.isStopped  = immediately
	interaction.isStopping = not immediately

	-- print('StopClientEntityScriptedInteraction :: interaction.isStopping=', interaction.isStopping, 'interaction.isStopped=', interaction.isStopped)

	if immediately then

		local interactionsBySlot = gScriptedInteractionByEntityId[ interaction.entityId ]

		if interactionsBySlot and interactionsBySlot[ interaction.slot ] == interaction then

			FreeScriptedInteraction( interaction )
		end

		if not IsCloneScriptedInteraction( interaction ) then
			local runningInteractionDef, runningInteractionStateName = GetNetworkScriptedInteractionBySlot( interaction.entityId, interaction.slot )

			if runningInteractionDef == interaction.def and runningInteractionStateName == interaction.stateName then
				TriggerServerEvent( 'scripted_interactions:server:stopScriptedInteraction', {
					interactionName = interaction.def.name,
					slot = interaction.slot,
				} )
			end
		end

		CleanupScriptedInteractionState( interaction, immediately )

		if not IsCloneScriptedInteraction( interaction ) then

			TriggerEvent( 'scripted_interactions:onLocalScriptedInteractionStopped', interaction.def.name, interaction.entityId, interaction.slot, interaction.stateName )
		end
	end
end

--

---@param interaction ScriptedInteraction
---@return boolean
local function ProcessLocalScriptedInteraction( interaction )

	if interaction.isStopping or interaction.isStopped then

		-- print( 'ProcessLocalScriptedInteraction :: stopped due to isStopping or isStopped' )

		return false
	end

	if not DoesEntityExist( interaction.entityId ) then

		-- print( 'ProcessLocalScriptedInteraction :: stopped due to entity not exist' )

		return false
	end

	local interactionStateDef = GetScriptedInteractionStateDef( interaction )

	if interactionStateDef.animation and not IsEntityPlayingAnim( interaction.entityId, interactionStateDef.animation.dict, interactionStateDef.animation.name, 3 ) then

		-- print( 'ProcessLocalScriptedInteractionAnimation :: stopped due to not playing anim' )

		return false
	end

	if ( interactionStateDef.flags & eScriptedInteractionStateFlags.SKIP_ALL_CHECKS ) ~= 0 then
		return true
	end

	if IsPedClimbing( interaction.entityId ) then
		return false
	end

	if ( interactionStateDef.flags & eScriptedInteractionStateFlags.SKIP_IN_WATER_CHECKS ) ~= 0 --[[ or immediately --]] then

		if IsPedSwimming( interaction.entityId ) or IsPedSwimmingUnderWater( interaction.entityId ) then
			return false
		end

	end

	if IsPedFalling( interaction.entityId ) then
		return false
	end

	return true
end

---@param interaction ScriptedInteraction
local function PlayScriptedInteraction( interaction, interactionStateName )

	-- print( ('PlayScriptedInteraction :: interactionStateName="%s" interaction.isStopped=%s interaction.isStopping=%s'):format( interactionStateName, interaction.isStopped, interaction.isStopping ) )

	if interaction.isStopped or interaction.isStopping then
		return
	end

	local prevInteractionStateName = interaction.stateName

	if prevInteractionStateName ~= interactionStateName then
		CleanupScriptedInteractionState( interaction, false )
	end

	SetScriptedInteractionState( interaction, interactionStateName )

	local interactionStateDef = GetScriptedInteractionStateDef( interaction )
	local interactionProps = { }

	if GetScriptedInteractionDefHasProps( interactionStateDef ) then
		interactionProps = GetScriptedInteractionDefProps( interactionStateDef )

		for _, interactionPropDef in ipairs( interactionProps ) do
			local modelHash = GetScriptedInteractionModelHash( interactionPropDef.modelName )

			if not IsModelValid( modelHash ) then
				sx.logger:error(
					('Invalid scripted interaction prop model interaction="%s" model="%s"')
						:format( interaction.def.name, tostring( interactionPropDef.modelName ) )
				)
				StopClientEntityScriptedInteraction( interaction, true )
				return
			end

			RequestModel( modelHash )

			if interactionPropDef.animDict then
				RequestAnimDict( interactionPropDef.animDict )
			end

			if interactionPropDef.animDict2 then
				RequestAnimDict( interactionPropDef.animDict2 )
			end
		end
	end

	if interactionStateDef.animation and not IsCloneScriptedInteraction( interaction ) then
		RequestAnimDict( interactionStateDef.animation.dict )
	end

	if interactionStateDef.ptfx then
		RequestNamedPtfxAsset( interactionStateDef.ptfx.asset )
	end

	local streamingDeadline = GetGameTimer() + SCRIPTED_INTERACTION_STREAMING_TIMEOUT_MS

	while true do

		if interaction.isStopped or interaction.isStopping then
			StopClientEntityScriptedInteraction( interaction, true )
			for _, interactionPropDef in ipairs( interactionProps ) do
				SetModelAsNoLongerNeeded( GetScriptedInteractionModelHash( interactionPropDef.modelName ) )
			end
			return
		end

		if not DoesEntityExist( interaction.entityId ) then
			return
		end

		local loadedAllModels = true
		local loadedAllAnimations = true
		local loadedPtfxAsset = true

		for _, interactionPropDef in ipairs( interactionProps ) do
			local modelHash = GetScriptedInteractionModelHash( interactionPropDef.modelName )

			if not HasModelLoaded( modelHash ) then
				loadedAllModels = false
			end

			if interactionPropDef.animDict and not HasAnimDictLoaded( interactionPropDef.animDict ) then
				loadedAllAnimations = false
			end

			if interactionPropDef.animDict2 and not HasAnimDictLoaded( interactionPropDef.animDict2 ) then
				loadedAllAnimations = false
			end
		end

		if interactionStateDef.animation
			and not IsCloneScriptedInteraction( interaction )
			and not HasAnimDictLoaded( interactionStateDef.animation.dict ) then
			loadedAllAnimations = false
		end

		if interactionStateDef.ptfx and not HasNamedPtfxAssetLoaded( interactionStateDef.ptfx.asset ) then
			loadedPtfxAsset = false
		end

		if loadedAllModels and loadedAllAnimations and loadedPtfxAsset then
			break
		end

		if GetGameTimer() >= streamingDeadline then
			sx.logger:error(
				('Timed out loading scripted interaction assets interaction="%s" modelsLoaded=%s animationsLoaded=%s ptfxLoaded=%s')
					:format( interaction.def.name, tostring( loadedAllModels ), tostring( loadedAllAnimations ), tostring( loadedPtfxAsset ) )
			)
			StopClientEntityScriptedInteraction( interaction, true )
			return
		end

		Wait( 0 )
	end

	-- Esse state precisa de um prop?
	if GetScriptedInteractionDefHasProps( interactionStateDef ) then

		-- O prop ja existe?
		if not AreScriptedInteractionPropsCreated( interaction ) then

			for _, interactionPropDef in ipairs( interactionProps ) do

				if not CreateScriptedInteractionPropLocally( interaction, interactionPropDef ) then
					StopClientEntityScriptedInteraction( interaction, true )
					return
				end
			end
		end
	end

	-- print('PlayScriptedInteraction -> interaction.isStopped=', interaction.isStopped)

	if interactionStateDef.animation and not IsCloneScriptedInteraction( interaction ) then

		--print("anim",interactionStateDef.animation.dict, interactionStateDef.animation.name)
        TaskPlayAnim( interaction.entityId, interactionStateDef.animation.dict, interactionStateDef.animation.name, 8.0, -8.0, -1, interactionStateDef.animation.flags, 0, false, false, false )

		pcall(
			function (...)

				-- A gente não se importa com o error
				-- só quero esperar a animação começar

				lib.waitFor(function ()

					-- print('waiting anim to start')

					if IsEntityPlayingAnim( interaction.entityId, interactionStateDef.animation.dict, interactionStateDef.animation.name, 3 ) then
						return true
					end
		
					return nil
				end, 'waiting anim to start', 2000 )
			end
		)

		RemoveAnimDict( interactionStateDef.animation.dict )

		-- print(' PlayScriptedInteraction -> starting thread')
	end

	-- Ptfx roda em todos os clients (dono e clones): cada um cria a propria copia local.
	if interactionStateDef.ptfx then
		if not interaction.ptfxHandle then
			StartScriptedInteractionPtfxLocally( interaction, interactionStateDef.ptfx )
		end
	else
		StopScriptedInteractionPtfxLocally( interaction )
	end

	Wait(500)
	if interaction.isStopped or interaction.isStopping then
		StopClientEntityScriptedInteraction( interaction, true )
		return
	end
	TriggerEvent( 'scripted_interactions:onLocalScriptedInteractionStarted', interaction.def.name, interaction.entityId, interaction.slot, interaction.stateName )

	CreateThread( function ()

		while true do

			Wait( 0 )

			local fc = GetFrameCount()

			if fc % 10 == 0 then

				-- Process every 10 frames

				local keepPlaying = ProcessLocalScriptedInteraction( interaction )

				if not keepPlaying then
					break
				end
			end
		end

		-- isStopping = true, vamos finalizar imediatmente agora!
		if not interaction.isStopped then

			-- print('animation probably ended, let stopped scriptedinteraction')

			StopClientEntityScriptedInteraction( interaction, true )
		end
	end)
end

---@class (exact) ScriptedInteraction
---@field def      		ScriptedInteractionDef
---@field slot       number
---@field stateName		string
---@field entityId 		number
---@field isStopped		boolean
---@field isStopping	boolean
---@field propEntityIds number[]
---@field ptfxHandle?	number
---@field ptfxAsset?	string

---@param interaction ScriptedInteraction
function IsCloneScriptedInteraction( interaction )

    return NetworkGetEntityOwner( interaction.entityId ) ~= PlayerId()
end

---@param entityId number
---@param slot? number
---@return ScriptedInteraction | nil
local function GetScriptedInteractionFromEntity( entityId, slot )

	local interactionsBySlot = gScriptedInteractionByEntityId[ entityId ]

	if not interactionsBySlot then
		return nil
	end

	if slot ~= nil then
		return interactionsBySlot[ slot ]
	end

	for currentSlot = 1, MAX_SCRIPTED_INTERACTION_SLOTS do

		if interactionsBySlot[ currentSlot ] then
			return interactionsBySlot[ currentSlot ]
		end
	end

	return nil
end

---@param entityId number
---@param params? table
---@return ScriptedInteraction | nil
local function FindLocalScriptedInteraction( entityId, params )

	params = params or { }

	if params.slot ~= nil then
		local interaction = GetScriptedInteractionFromEntity( entityId, params.slot )

		if params.interactionName and ( not interaction or interaction.def.name ~= params.interactionName ) then
			return nil
		end

		return interaction
	elseif params.interactionName then
		for slot = 1, MAX_SCRIPTED_INTERACTION_SLOTS do
			local currInteraction = GetScriptedInteractionFromEntity( entityId, slot )

			if currInteraction and currInteraction.def.name == params.interactionName then
				return currInteraction
			end
		end

		return nil
	end

	return GetScriptedInteractionFromEntity( entityId )
end

---@param entityId number
---@param params? table
---@return ScriptedInteraction | nil
local function GetLocalScriptedInteractionPropId( entityId, params )

	local interaction = FindLocalScriptedInteraction( entityId, params )

	assert( interaction, 'Not playing any ScriptedInteraction!' )

	return interaction.propEntityIds[ 1 ], interaction.slot
end

---@param entityId number
---@param params? { slot?: number, interactionName?: string, state?: string, requireAttached?: boolean }
---@return boolean ready
---@return number | nil slot
local function AreLocalScriptedInteractionPropsReady( entityId, params )

	params = params or { }

	local interaction = FindLocalScriptedInteraction( entityId, params )

	if not interaction or interaction.isStopped or interaction.isStopping then
		return false
	end

	if params.state and interaction.stateName ~= params.state then
		return false
	end

	local interactionStateDef = GetScriptedInteractionStateDef( interaction )

	if not GetScriptedInteractionDefHasProps( interactionStateDef ) then
		return false
	end

	local expectedPropCount = #GetScriptedInteractionDefProps( interactionStateDef )

	if #interaction.propEntityIds ~= expectedPropCount then
		return false
	end

	for _, propEntityId in ipairs( interaction.propEntityIds ) do
		if not DoesEntityExist( propEntityId ) then
			return false
		end

		if params.requireAttached and GetEntityAttachedTo( propEntityId ) ~= entityId then
			return false
		end
	end

	return true, interaction.slot
end

---@param slot number
local function HandleStateBagSlotChange( slot, bagName, key, value, reserved, replicated )

	-- print('scripted-interaction', bagName, key, json.encode(value), reserved, replicated)

	-- sx.logger:debug( ('scripted-interaction :: bagName="%s" key="%s" value=%s'):format( bagName, key, json.encode( value )) )

	if replicated then

		--[[ Ignore locally set state ]]

		return
	end

	-- print( ('scripted-interaction :: bagName="%s" key="%s" value=%s reserved=%s replicated=%s'):format( bagName, key, json.encode( value ), reserved, replicated ) )

	value = value or { }

    local newInteractionDefIndex, newInteractionStateName = table.unpack( value )

	newInteractionStateName = newInteractionStateName or DEFAULT_SCRIPTED_INTERACTION_STATE

    local entityId = GetEntityFromStateBagName( bagName )

	lib.waitFor(
		function()

			entityId = GetEntityFromStateBagName( bagName )

			if entityId ~= 0 then

				-- We ok!

				return true
			end
		end,
		'Failed to get playerIndex from bagName',
		20000
	)

	local prevInteraction = GetScriptedInteractionFromEntity( entityId, slot )

	if prevInteraction and prevInteraction.def.index ~= newInteractionDefIndex then

		-- Remover imediatamento caso a gente não seja o dono dessa scripted interaction!
		local immediately =
			( prevInteraction.def.exclusiveGroup ~= nil or IsCloneScriptedInteraction( prevInteraction ) )
				and true
				or	false

		StopClientEntityScriptedInteraction( prevInteraction, immediately )
	end

	if newInteractionDefIndex and ( prevInteraction == nil or prevInteraction.def.index ~= newInteractionDefIndex ) then

		local interactionDef = GetScriptedInteractionDefinitionByIndex( newInteractionDefIndex )

		local interaction = CreateEntityScriptedInteraction( interactionDef, entityId, slot, newInteractionStateName )

		StoreScriptedInteraction( interaction )
	end

	local currInteraction = GetScriptedInteractionFromEntity( entityId, slot )

	-- print('newInteractionStateName=', newInteractionStateName)

	if currInteraction and not ( currInteraction.isStopped or currInteraction.isStopping ) then

		PlayScriptedInteraction( currInteraction, newInteractionStateName )
	end

	-- print('###')
end

for slot = 1, MAX_SCRIPTED_INTERACTION_SLOTS do

	local stateBagKey = GetScriptedInteractionSlotStateBagKey( slot )

	AddStateBagChangeHandler( stateBagKey, nil, function( bagName, key, value, reserved, replicated )
		HandleStateBagSlotChange( slot, bagName, key, value, reserved, replicated )
	end)
end

AddEventHandler( 'onResourceStop', function ( resourceName )

	if resourceName ~= GetCurrentResourceName() then
		return
	end

	for _, interactionsBySlot in pairs( gScriptedInteractionByEntityId ) do

			for _, interaction in pairs( interactionsBySlot ) do
				StopClientEntityScriptedInteraction( interaction, true )
			end
	end
end)

-- # External

---@param interactionName string
---@return boolean
function IsRunningScriptedInteraction( interactionName )

    return GetIsEntityRunningScriptedInteraction( PlayerPedId(), interactionName )
end

---@return boolean
function IsRunningAnyScriptedInteraction()

    return GetIsEntityRunningAnyScriptedInteraction( PlayerPedId() )
end

---@return boolean
function IsRunningPedAnimatedScriptedInteraction()

    return GetIsEntityRunningPedAnimatedScriptedInteraction( PlayerPedId() )
end

---@param interactionName string
---@param params? 		  StartScriptedInteractionParams
---@return boolean
function StartScriptedInteraction( interactionName, params )

    assert( interactionName, 'Parameter "interactionName" cannot be nil' )

	params = params or { }

    params.interactionName = interactionName

	TriggerServerEvent( 'scripted_interactions:server:startScriptedInteraction', interactionName, params )

	return true
end

---@param stopParamsOrImmediately table | boolean | nil
function StopScriptedInteraction( stopParamsOrImmediately )

	local stopParams = nil
	local immediately = false

	if type( stopParamsOrImmediately ) == 'table' then
		stopParams = stopParamsOrImmediately
		immediately = stopParams.immediately or false
	else
		immediately = stopParamsOrImmediately or false
		stopParams = { }
	end

	local entityId = PlayerPedId()

	TriggerServerEvent( 'scripted_interactions:server:stopScriptedInteraction', stopParams )

	if stopParams.stopAll or ( stopParams.slot == nil and stopParams.interactionName == nil ) then

		for slot = 1, MAX_SCRIPTED_INTERACTION_SLOTS do

			local interaction = GetScriptedInteractionFromEntity( entityId, slot )

			if interaction then
				StopClientEntityScriptedInteraction( interaction, immediately )
			end
		end

		return
	end

	if stopParams.slot ~= nil then

		local interaction = GetScriptedInteractionFromEntity( entityId, stopParams.slot )

		if interaction and ( not stopParams.interactionName or interaction.def.name == stopParams.interactionName ) then
			StopClientEntityScriptedInteraction( interaction, immediately )
		end

		return
	end

	if stopParams.interactionName then

		for slot = 1, MAX_SCRIPTED_INTERACTION_SLOTS do

			local interaction = GetScriptedInteractionFromEntity( entityId, slot )

			if interaction and interaction.def.name == stopParams.interactionName then
				StopClientEntityScriptedInteraction( interaction, immediately )
				break
			end
		end
	end
end

---@param interactionName? string
---@return string | nil
function GetScriptedInteractionState( interactionName )

	local entityId = PlayerPedId()

	for slot = 1, MAX_SCRIPTED_INTERACTION_SLOTS do

		local interactionDef, stateName = GetNetworkScriptedInteractionBySlot( entityId, slot )

		if interactionDef and ( interactionName == nil or interactionDef.name == interactionName ) then
			return stateName
		end
	end

	return nil
end

---@class SwitchableScriptedInteraction
---@field slot number
---@field interactionName string
---@field displayName string | nil
---@field stateName string
---@field states { name: string, title: string | nil, description: string | nil }[]

---@return SwitchableScriptedInteraction[]
function GetSwitchableScriptedInteractions()

	local entityId = PlayerPedId()
	local switchableInteractions = { }

	for slot = 1, MAX_SCRIPTED_INTERACTION_SLOTS do

		local interactionDef, stateName = GetNetworkScriptedInteractionBySlot( entityId, slot )

		if interactionDef and interactionDef.canSwitchState then

			local states = { }

			for _, state in ipairs( interactionDef.states ) do

				table.insert( states, {
					name = state.name,
					title = state.title,
					description = state.description,
				} )
			end

			table.insert( switchableInteractions, {
				slot = slot,
				interactionName = interactionDef.name,
				displayName = interactionDef.displayName,
				stateName = stateName,
				states = states,
			} )
		end
	end

	return switchableInteractions
end

-- TODO: Assert on ScriptedDefinitionDef count mismatch between client and server
-- TODO: Assert with better messages

exports( 'isRunningScriptedInteraction', IsRunningScriptedInteraction )
exports( 'isRunningAnyScriptedInteraction', IsRunningAnyScriptedInteraction )
exports( 'startScriptedInteraction'    , StartScriptedInteraction  	  )
exports( 'stopScriptedInteraction'     , StopScriptedInteraction   	  )
exports( 'getScriptedInteractionState' , GetScriptedInteractionState  )
exports( 'getSwitchableScriptedInteractions', GetSwitchableScriptedInteractions )
exports( 'getLocalScriptedInteractionPropId', GetLocalScriptedInteractionPropId )
exports( 'areLocalScriptedInteractionPropsReady', AreLocalScriptedInteractionPropsReady )

-- for _, entityId in ipairs( GetGamePool('CObject') ) do
-- 	DetachEntity( entityId, true, true )
-- end
