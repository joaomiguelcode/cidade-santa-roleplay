DEFAULT_SCRIPTED_INTERACTION_STATE = 'idle'

STATEBAG_SLOTS_KEY = 'scr-it:slots'
STATEBAG_SLOT_KEY_PREFIX = 'scr-it:slot:'

MAX_SCRIPTED_INTERACTION_SLOTS = 3
DEFAULT_SCRIPTED_INTERACTION_SLOT = 1

SCRIPTED_INTERACTION_SLOT_BITS =
{
    [ 1 ] = 1 << 0,
    [ 2 ] = 1 << 1,
    [ 3 ] = 1 << 2,
}

---@param slot number
---@return boolean
local function IsScriptedInteractionSlotValid( slot )

    return type( slot ) == 'number' and slot >= 1 and slot <= MAX_SCRIPTED_INTERACTION_SLOTS
end

---@param slot number
---@return string
function GetScriptedInteractionSlotStateBagKey( slot )

    if not IsScriptedInteractionSlotValid( slot ) then

        assert( false, ('Invalid scripted interaction slot "%s"'):format( tostring( slot ) ) )
    end

    return ('%s%s'):format( STATEBAG_SLOT_KEY_PREFIX, slot )
end

---@param slot number
---@return number
local function GetScriptedInteractionSlotBit( slot )

    return SCRIPTED_INTERACTION_SLOT_BITS[ slot ]
end

---@param slotsMask number
---@return number[]
local function GetSlotsFromMask( slotsMask )

    slotsMask = slotsMask or 0

    local slots = { }

    for slot = 1, MAX_SCRIPTED_INTERACTION_SLOTS do

        if ( slotsMask & GetScriptedInteractionSlotBit( slot ) ) ~= 0 then
            table.insert( slots, slot )
        end
    end

    return slots
end

---@param entityId number
---@return number
local function GetNetworkScriptedInteractionSlotsMask( entityId )

    local slotsMask = Entity( entityId ).state[ STATEBAG_SLOTS_KEY ]

    if type( slotsMask ) ~= 'number' then
        return 0
    end

    return slotsMask
end

---@param entityId number
---@param slot number
---@return number | nil, string | nil
local function GetNetworkScriptedInteractionRawBySlot( entityId, slot )

    local value = Entity( entityId ).state[ GetScriptedInteractionSlotStateBagKey( slot ) ]

    if not value then
        return nil
    end

    local interactionDefIndex, interactionStateName = table.unpack( value )

    if not interactionDefIndex then
        Citizen.Trace( ('GetNetworkScriptedInteractionRawBySlot :: interactionDefIndex is nil! entityId=%s slot=%s\n'):format( entityId, slot ) )
        return nil
    end

    interactionStateName = interactionStateName or DEFAULT_SCRIPTED_INTERACTION_STATE

    return interactionDefIndex, interactionStateName
end

---@param entityId number
---@param slot number
---@param value table | nil
---@param isNetworked boolean
local function SetEntityScriptedInteractionSlotValue( entityId, slot, value, isNetworked )

    local isProfiling = isNetworked and ProfilerIsRecording() == 1

    if isProfiling then
        ProfilerEnterScope( 'scr-it:state:get (scripted_interactions)' )
    end

    local entityState = Entity( entityId ).state
    local currentSlotsMask = entityState[ STATEBAG_SLOTS_KEY ]

    if isProfiling then
        ProfilerExitScope()
    end

    local slotsMask = type( currentSlotsMask ) == 'number' and currentSlotsMask or 0
    local slotBit = GetScriptedInteractionSlotBit( slot )

    if value then
        slotsMask = slotsMask | slotBit
    else
        slotsMask = slotsMask & (~slotBit)
    end

    slotsMask = slotsMask ~= 0 and slotsMask or nil

    if isProfiling then
        ProfilerEnterScope( 'scr-it:slot:set (scripted_interactions)' )
    end

    entityState:set( GetScriptedInteractionSlotStateBagKey( slot ), value, isNetworked )

    if isProfiling then
        ProfilerExitScope()
    end

    if currentSlotsMask ~= slotsMask then

        if isProfiling then
            ProfilerEnterScope( 'scr-it:slots-mask:set (scripted_interactions)' )
        end

        entityState:set( STATEBAG_SLOTS_KEY, slotsMask, isNetworked )

        if isProfiling then
            ProfilerExitScope()
        end
    end

end

---@class StopScriptedInteractionParams
---@field slot? number
---@field interactionName? string
---@field stopAll? boolean

---@param interaction ScriptedInteraction
---@return ScriptedInteractionStateDef
function GetScriptedInteractionStateDef( interaction )

	for _, state in ipairs( interaction.def.states ) do

		if state.name == interaction.stateName then

			return state
		end
	end

	error( ('Invalid state name! interaction.stateName="%s"'):format( interaction.stateName ) )
end

---@param interaction 		   ScriptedInteraction
---@param interactionStateName string
function SetScriptedInteractionState( interaction, interactionStateName )

	-- print( ('SetScriptedInteractionState :: interactionStateName="%s"'):format( interactionStateName ) )

	interaction.stateName = interactionStateName

	-- Will assert if statedef is invalid!
	GetScriptedInteractionStateDef( interaction)
end

---@param interactionDef ScriptedInteractionDef
---@param entityId       number
---@param slot?          number
---@param stateName?     string
---@return ScriptedInteraction
function CreateEntityScriptedInteraction( interactionDef, entityId, slot, stateName )

    assert( IsPedAPlayer( entityId ) )

    -- print( ('CreateEntityScriptedInteraction :: interactionDef=%s'):format( json.encode( interactionDef, { indent = true }) ) )

    ---@type ScriptedInteraction
    local interaction =
    {
        def      = interactionDef,
        slot     = slot or DEFAULT_SCRIPTED_INTERACTION_SLOT,
        entityId = entityId,
        stateName = nil,
        isStopped = false,
        isStopping = false,
        propEntityIds = { },
    }

    SetScriptedInteractionState( interaction, stateName or DEFAULT_SCRIPTED_INTERACTION_STATE )

    return interaction
end

---@param entityId number
function DeleteScriptedInteractionWithEntity( entityId )

    local entityState = Entity( entityId ).state

    for slot = 1, MAX_SCRIPTED_INTERACTION_SLOTS do
        entityState:set( GetScriptedInteractionSlotStateBagKey( slot ), nil, true )
    end

    entityState:set( STATEBAG_SLOTS_KEY, nil, true )
end

---@class StartScriptedInteractionParams
---@field interactionName string
---@field state       string
---@field slot?       number
---@field requireFreeSlot? boolean

---@params StartScriptedInteractionParams
---@return ScriptedInteractionDef
local function ValidateStartScriptedInteractionParams( params )

    assert( params, 'Parameter "params" cannot be nil')
    assert( params.interactionName, 'params is missing "interactionName"' )

    local interactionDef = GetScriptedInteractionDefinitionByName( params.interactionName )

    if params.slot ~= nil then
        assert( IsScriptedInteractionSlotValid( params.slot ), ('Invalid scripted interaction slot "%s"'):format( tostring( params.slot ) ) )
    end

	assert( interactionDef, ('Invalid scripted interaction name "%s"'):format( params.interactionName ) )

	return interactionDef
end

---@param entityId number
---@return number | nil, string | nil
function GetNetworkScriptedInteraction( entityId )
    local slotsMask = GetNetworkScriptedInteractionSlotsMask( entityId )

    for _, slot in ipairs( GetSlotsFromMask( slotsMask ) ) do

        local slotInteractionDefIndex, slotInteractionStateName = GetNetworkScriptedInteractionRawBySlot( entityId, slot )

        if slotInteractionDefIndex then
            return GetScriptedInteractionDefinitionByIndex( slotInteractionDefIndex ), slotInteractionStateName
        end
    end

    return nil
end

exports( 'GetNetworkScriptedInteraction', GetNetworkScriptedInteraction )

---@param entityId number
---@param slot number
---@return ScriptedInteractionDef | nil, string | nil
function GetNetworkScriptedInteractionBySlot( entityId, slot )

    if not IsScriptedInteractionSlotValid( slot ) then
        return nil
    end

    local interactionDefIndex, interactionStateName = GetNetworkScriptedInteractionRawBySlot( entityId, slot )

    if not interactionDefIndex then
        return nil
    end

    return GetScriptedInteractionDefinitionByIndex( interactionDefIndex ), interactionStateName
end

exports( 'GetNetworkScriptedInteractionBySlot', GetNetworkScriptedInteractionBySlot )

---@param entityId number
---@return { slot: number, definition: ScriptedInteractionDef, state: string }[]
function GetNetworkScriptedInteractions( entityId )

    local interactions = { }
    local slotsMask = GetNetworkScriptedInteractionSlotsMask( entityId )

    for _, slot in ipairs( GetSlotsFromMask( slotsMask ) ) do

        local definition, state = GetNetworkScriptedInteractionBySlot( entityId, slot )

        if definition then
            interactions[ #interactions + 1 ] = {
                slot = slot,
                definition = definition,
                state = state,
            }
        end
    end

    return interactions
end

exports( 'GetNetworkScriptedInteractions', GetNetworkScriptedInteractions )

---@param entityId number
---@return number
function GetNetworkScriptedInteractionSlots( entityId )

    return GetNetworkScriptedInteractionSlotsMask( entityId )
end

exports( 'GetNetworkScriptedInteractionSlots', GetNetworkScriptedInteractionSlots )

---@param entityId number
---@param interactionName string
---@return number | nil
local function GetEntityScriptedInteractionSlotByName( entityId, interactionName )

    local interactionDef = GetScriptedInteractionDefinitionByName( interactionName )
    local slotsMask = GetNetworkScriptedInteractionSlotsMask( entityId )

    for _, slot in ipairs( GetSlotsFromMask( slotsMask ) ) do

        local interactionDefIndex = GetNetworkScriptedInteractionRawBySlot( entityId, slot )

        if interactionDefIndex and GetScriptedInteractionDefinitionByIndex( interactionDefIndex ) == interactionDef then
            return slot
        end
    end

    return nil
end

---@param entityId number
---@return number | nil
local function GetFirstAvailableScriptedInteractionSlot( entityId )

    for slot = 1, MAX_SCRIPTED_INTERACTION_SLOTS do

        local interactionDef = GetNetworkScriptedInteractionBySlot( entityId, slot )

        if not interactionDef then
            return slot
        end
    end

    return nil
end

---@param entityId number
---@return number | nil
local function GetFirstRunningScriptedInteractionSlot( entityId )

    for slot = 1, MAX_SCRIPTED_INTERACTION_SLOTS do

        if GetNetworkScriptedInteractionBySlot( entityId, slot ) ~= nil then
            return slot
        end
    end

    return nil
end

---@param entityId        number
---@param interactionName string
---@return boolean
function GetIsEntityRunningScriptedInteraction( entityId, interactionName )

    local interactionDef = GetScriptedInteractionDefinitionByName( interactionName )

    local slotsMask = GetNetworkScriptedInteractionSlotsMask( entityId )

    for _, slot in ipairs( GetSlotsFromMask( slotsMask ) ) do

        local interactionDefIndex = GetNetworkScriptedInteractionRawBySlot( entityId, slot )

        if interactionDefIndex and GetScriptedInteractionDefinitionByIndex( interactionDefIndex ) == interactionDef then
            return true
        end
    end

    return false
end

---@param entityId number
---@return boolean
function GetIsEntityRunningAnyScriptedInteraction( entityId )

    return GetNetworkScriptedInteractionSlotsMask( entityId ) ~= 0
end

---@param entityId number
---@return boolean
function GetIsEntityRunningPedAnimatedScriptedInteraction( entityId )

	local interactionDef, interactionStateName = GetNetworkScriptedInteraction( entityId )

	if not interactionDef then

		return false
	end

	interactionStateName = interactionStateName or DEFAULT_SCRIPTED_INTERACTION_STATE

	for _, state in ipairs( interactionDef.states ) do

		if state.name == interactionStateName then

			return state.animation ~= nil
		end
	end

	return false
end

---@param entityId number
---@return boolean
function GetIsEntityRunningPedAnimatedScriptedInteraction( entityId )

	local interactionDef, interactionStateName = GetNetworkScriptedInteraction( entityId )

	if not interactionDef then

		return false
	end

	interactionStateName = interactionStateName or DEFAULT_SCRIPTED_INTERACTION_STATE

	for _, state in ipairs( interactionDef.states ) do

		if state.name == interactionStateName then

			return state.animation ~= nil
		end
	end

	return false
end

---@param entityId 	  number
---@param isNetworked boolean
---@param stopParams? StopScriptedInteractionParams
---@return boolean
function StopEntityScriptedInteraction( entityId, isNetworked, stopParams )

    stopParams = stopParams or { }

    local stopAll = stopParams.stopAll
    local targetSlot = stopParams.slot

    if targetSlot ~= nil then
        assert( IsScriptedInteractionSlotValid( targetSlot ), ('StopEntityScriptedInteraction :: invalid slot "%s"'):format( tostring( targetSlot ) ) )
    end

    if not stopAll and stopParams.interactionName and targetSlot == nil then
        targetSlot = GetEntityScriptedInteractionSlotByName( entityId, stopParams.interactionName )
        if targetSlot == nil then
            return false
        end
    end

    if not stopAll and targetSlot == nil then
		targetSlot = GetFirstRunningScriptedInteractionSlot( entityId )
    end

    if stopAll or targetSlot == nil then

        if not GetIsEntityRunningAnyScriptedInteraction( entityId ) then
            return false
        end

        DeleteScriptedInteractionWithEntity( entityId )

        return true
    end

    local runningInteractionDef = GetNetworkScriptedInteractionBySlot( entityId, targetSlot )

    if not runningInteractionDef then
        return false
    end

    if stopParams.interactionName and runningInteractionDef.name ~= stopParams.interactionName then
        return false
    end

    SetEntityScriptedInteractionSlotValue( entityId, targetSlot, nil, isNetworked )

    return true
end

-- esse delay existe para evitar que quando uma interação ja está ativa ele consiga iniciar outra pois a função StopEntityScriptedInteraction não é assincrona?
---@type number
local DELAY_FOR_START_SCRIPTED_INTERACTION_MS = 400

---@param params 	  StartScriptedInteractionParams
---@param entityId 	  number
---@param isNetworked boolean
---@return boolean, ScriptedInteractionDef
function StartEntityScriptedInteraction( params, entityId, isNetworked )

    local interactionDef = ValidateStartScriptedInteractionParams( params )

    if not params.state then
        params.state = interactionDef.canSwitchState
            and interactionDef.states[ math.random( #interactionDef.states ) ].name
            or DEFAULT_SCRIPTED_INTERACTION_STATE
    end

    local slot = params.slot
    local exclusiveSlots = { }

    if interactionDef.exclusiveGroup then
        for _, running in ipairs( GetNetworkScriptedInteractions( entityId ) ) do
            if running.definition.exclusiveGroup == interactionDef.exclusiveGroup then
                exclusiveSlots[ #exclusiveSlots + 1 ] = running.slot
            end
        end
    end

    -- Callers without explicit slot are auto-routed to a free slot.
    if slot == nil then

        slot = GetEntityScriptedInteractionSlotByName( entityId, interactionDef.name )
            or exclusiveSlots[ 1 ]
            or GetFirstAvailableScriptedInteractionSlot( entityId )

        if slot == nil then
            if params.requireFreeSlot then
                return false, interactionDef
            end

            slot = DEFAULT_SCRIPTED_INTERACTION_SLOT
        end
    end

    assert( IsScriptedInteractionSlotValid( slot ), ('Invalid scripted interaction slot "%s"'):format( tostring( slot ) ) )

    local interactionStateName = params.state

    local runningInteractionDef, runningInteractionStateName = GetNetworkScriptedInteractionBySlot( entityId, slot )
    local replacesExclusiveGroup = interactionDef.exclusiveGroup ~= nil
        and runningInteractionDef ~= nil
        and runningInteractionDef.exclusiveGroup == interactionDef.exclusiveGroup

    if params.requireFreeSlot and runningInteractionDef and runningInteractionDef ~= interactionDef and not replacesExclusiveGroup then
        return false, interactionDef
    end

    for _, exclusiveSlot in ipairs( exclusiveSlots ) do
        if exclusiveSlot ~= slot then
            StopEntityScriptedInteraction( entityId, isNetworked, { slot = exclusiveSlot } )
        end
    end

    -- print( 'StartEntityScriptedInteraction :: runningInteractionDef=', runningInteractionDef, 'runningInteractionStateName=', runningInteractionStateName, json.encode( params ) )

    -- print('StartEntityScriptedInteraction :: runningInteractionStateName=', runningInteractionStateName)
    -- print('StartEntityScriptedInteraction :: interactionStateName=', interactionStateName)

    -- Já estamos executando esse scripted interaction?
    if runningInteractionDef == interactionDef and runningInteractionStateName == interactionStateName then

        -- print('já está rodando')

        return
    end

    if not GetIsEntityRunningScriptedInteraction( entityId, interactionDef.name ) and runningInteractionDef and not replacesExclusiveGroup then
        StopEntityScriptedInteraction( entityId, isNetworked, { slot = slot } )
        Wait(DELAY_FOR_START_SCRIPTED_INTERACTION_MS)
    end

    -- print( ('StartEntityScriptedInteraction :: finished!') )

    -- Por enquanto, somente o servidor é responsável por setar novo scriptedinteractions
    SetEntityScriptedInteractionSlotValue( entityId, slot, { interactionDef.index, interactionStateName }, isNetworked )

    return true, interactionDef
end
