SCRIPTED_INTERACTION_SCUBA_GEAR = 'scuba_gear'

---@param enabled boolean
local function SetScubaGearEffectsEnabled( enabled )

	local pedId = PlayerPedId()

	SetEnableScuba( pedId,enabled )
	SetPedMaxTimeUnderwater( pedId, enabled and 9999.0 or 10.0 )
end

---@param interactionName string
AddEventHandler( 'scripted_interactions:onLocalScriptedInteractionStarted', function( interactionName )

	if interactionName ~= SCRIPTED_INTERACTION_SCUBA_GEAR then
		return
	end

	SetScubaGearEffectsEnabled( true )
end)

---@param interactionName string
AddEventHandler( 'scripted_interactions:onLocalScriptedInteractionStopped', function( interactionName )

	if interactionName ~= SCRIPTED_INTERACTION_SCUBA_GEAR then
		return
	end

	SetScubaGearEffectsEnabled( false )
end)

--

-- Evento usado por outros scripts do cliente para remover o efeito de scuba gear
AddEventHandler("hud:ScubaRemove",function()

	if not exports.scripted_interactions:isRunningScriptedInteraction( SCRIPTED_INTERACTION_SCUBA_GEAR ) then

		return
	end

	exports.scripted_interactions:stopScriptedInteraction({ interactionName = SCRIPTED_INTERACTION_SCUBA_GEAR })
end)