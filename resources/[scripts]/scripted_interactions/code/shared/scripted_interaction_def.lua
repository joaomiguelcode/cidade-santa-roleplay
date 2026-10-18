---@class ScriptedInteractionAnimationDef
---@field dict string
---@field name string

---@class ScriptedInteractionPropDef
---@field modelName string|number
---@field boneId? number
---@field animDict? string
---@field animName? string

---@class ScriptedInteractionPtfxDef
---@field asset          string
---@field name           string
---@field offsetPosition { x: number, y: number, z: number }
---@field offsetRotation { x: number, y: number, z: number }
---@field scale          number
---@field boneId?        number  -- bone do ped; sem ele a particula prende na raiz da entidade
---@field onProp?        boolean -- anexa no primeiro prop do state em vez do ped
---@field boneName?      string  -- osso nomeado do alvo, útil quando onProp é true
---@field color?         table   -- { R, G, B, A } ou lista de cores (sorteio por client)

---@class baseScriptedInteractionStateDef
---@field name? 	 string
---@field title? string
---@field description? string
---@field animation? ScriptedInteractionAnimationDef
---@field flags?     eScriptedInteractionStateFlags
---@field prop?      ScriptedInteractionPropDef
---@field props?     ScriptedInteractionPropDef[]
---@field ptfx?      ScriptedInteractionPtfxDef

---@class baseScriptedInteractionDef : baseScriptedInteractionStateDef[]
---@field canSwitchState? boolean
---@field displayName? string

---@class ScriptedInteractionStateDef
---@field name 	 	 string
---@field title? string
---@field description? string
---@field animation? ScriptedInteractionAnimationDef
---@field flags      eScriptedInteractionStateFlags
---@field prop?      ScriptedInteractionPropDef
---@field props?     ScriptedInteractionPropDef[]
---@field ptfx?      ScriptedInteractionPtfxDef

---@class ScriptedInteractionDef
---@field index  number
---@field name   string
---@field states ScriptedInteractionStateDef[]
---@field canSwitchState boolean
---@field displayName? string

---@class ScriptedInteractionCollectibleState
---@field name string
---@field title string
---@field description string

---@type ScriptedInteractionDef[]
local gScriptedInteractionDefinitions = { }

---@type table<string, ScriptedInteractionDef>
local gScriptedInteractionDefinitionsByName = { }

---@type table<string, ScriptedInteractionCollectibleState[]>
local gCollectibleStatesByLookupKey = { }

---@enum eScriptedInteractionStateFlags
eScriptedInteractionStateFlags =
{
	NONE = 1 << 0,
	STATE_TRANSITION__KEEP_ALL_PROP = 1 << 1,	-- Ao mudar de state, mantem os props que foram criados no state anterior e não tenta criar novos!

	WHEN_FINISHED__DELETE_ALL_PROP = 1 << 10,

	SKIP_IN_WATER_CHECKS = 1 << 11, -- Ignorar as validações quando estiver dentro da água
	SKIP_ALL_CHECKS = 1 << 12, -- Ignorar todas as validações
}

---@param def ScriptedInteractionDef
function ValidateScriptedInteractionDefinition( def )
end

---@param states baseScriptedInteractionDef
local function NormalizeScriptedInteractionStates( states )

	for _, state in ipairs( states ) do

		if state.name == nil then

			assert( #states == 1, 'ScriptedInteractionDef com mais de um state deve ter uma propriedade "name" para cada state!' )
		end

		state.name = state.name or DEFAULT_SCRIPTED_INTERACTION_STATE
		state.flags = state.flags or eScriptedInteractionStateFlags.NONE
	end
end

---@param def ScriptedInteractionDef
local function UpdateCollectibleStates( def )

    gCollectibleStatesByLookupKey[ def.name ] = nil

    if not def.name:find( '^collectible_' ) then
        return
    end

    local states = { }

    for _, state in ipairs( def.states ) do

        if type( state.name ) == 'string'
            and type( state.title ) == 'string'
            and type( state.description ) == 'string'
            and state.name ~= ''
            and state.title ~= ''
            and state.description ~= '' then
            states[ #states + 1 ] = {
                name = state.name,
                title = state.title,
                description = state.description,
            }
        end
    end

    if #states > 0 then
        gCollectibleStatesByLookupKey[ def.name ] = states
    end
end

---@param name string
---@param base baseScriptedInteractionDef
function RegisterScriptedInteractionDefinition( name, base )

	local states = base

	NormalizeScriptedInteractionStates( states )

	---@type ScriptedInteractionDef
	local def =
	{
		index = #gScriptedInteractionDefinitions + 1,
		name  = name,
		canSwitchState = base.canSwitchState,
		exclusiveGroup = base.exclusiveGroup,
		displayName = base.displayName,

		states = states,
	}

    table.insert( gScriptedInteractionDefinitions, def )

	gScriptedInteractionDefinitionsByName[ name ] = def

    UpdateCollectibleStates( def )
end

---@param name string
---@param base baseScriptedInteractionDef
function ReplaceScriptedInteractionDefinition( name, base )

	local def = assert(
		gScriptedInteractionDefinitionsByName[ name ],
		('ScriptedInteractionDef with name="%s" not found!'):format( name )
	)

	NormalizeScriptedInteractionStates( base )
	def.canSwitchState = base.canSwitchState
	def.exclusiveGroup = base.exclusiveGroup
	def.displayName = base.displayName
	def.states = base

    UpdateCollectibleStates( def )
end

---@return table<string, ScriptedInteractionCollectibleState[]>
function GetCollectibleStates()

    local catalog = { }

    for lookupKey, states in pairs( gCollectibleStatesByLookupKey ) do
        catalog[ lookupKey ] = { }

        for index, state in ipairs( states ) do
            catalog[ lookupKey ][ index ] = {
                name = state.name,
                title = state.title,
                description = state.description,
            }
        end
    end

    return catalog
end

exports( 'GetCollectibleStates', GetCollectibleStates )

---@param lookupKey string
---@param stateName string
---@return boolean
function IsCollectibleState( lookupKey, stateName )

    local states = gCollectibleStatesByLookupKey[ lookupKey ]

    if not states then
        return false
    end

    for _, state in ipairs( states ) do

        if state.name == stateName then
            return true
        end
    end

    return false
end

exports( 'IsCollectibleState', IsCollectibleState )

---@param interactionName string
---@return boolean
function IsScriptedInteractionDefinitionValid( interactionName )

	local interactionDef = gScriptedInteractionDefinitionsByName[ interactionName ]

	return interactionDef ~= nil
end

exports( 'isScriptedInteractionDefinitionValid', IsScriptedInteractionDefinitionValid )

---@param index number
---@return ScriptedInteractionDef
function GetScriptedInteractionDefinitionByIndex( index )

	local interactionDef = gScriptedInteractionDefinitions[ index ]

	-- O dump so pode ser montado no caminho de erro: Lua avalia os argumentos de
	-- `assert` sempre, e `gScriptedInteractionDefinitions` tem ~1.5k definicoes.
	if not interactionDef then

		assert( false, ('Invalid ScriptInteraction index=%s. dump=%s'):format( index, json.encode( gScriptedInteractionDefinitions, { indent = true }) ) )
	end

	return interactionDef
end

---@param interactionName string
---@return ScriptedInteractionDef
function GetScriptedInteractionDefinitionByName( interactionName )

	local interactionDef = gScriptedInteractionDefinitionsByName[ interactionName ]

	if not interactionDef then

		assert( false, ('ScriptedInteractionDef with name="%s" not found!'):format( interactionName ) )
	end

	return interactionDef
end

-- !

---@param interactionName string
function DEFINE_SCRIPTED_INTERACTION( interactionName )

    -- animation states ( idle, running, etc )
    -- props
    -- maybe

	---@param def  baseScriptedInteractionDef
	return function ( def )

		RegisterScriptedInteractionDefinition( interactionName, def )
	end
end

exports( 'defineScriptedInteraction', DEFINE_SCRIPTED_INTERACTION )
