---@class combatsystem.CombatReasonDef
---@field name        string
---@field addDuration number
---@field isInfinite?   boolean

---@type combatsystem.CombatReasonDef[]
gCombatReasonDefs = {}

---@type table<string, number>
eCombatReasons = {}

---@param name string
---@return fun(def: table): combatsystem.CombatReasonDef
function DEFINE_COMBATREASON( name )

	return function( def )

		assert( type( def ) == 'table', 'Combat reason definition must be a table' )

		assert( type( def.addDuration ) == 'number', 'Combat reason must have addDuration field' )

		assert( def.addDuration > 0, 'addDuration must be greater than 0' )

		---@type combatsystem.CombatReasonDef
		local combatReasonDef =
		{
			name        = name:upper(),
			addDuration = def.addDuration,
			isInfinite    = def.isInfinite,
		}

        gCombatReasonDefs[ combatReasonDef.name ] = combatReasonDef

		return combatReasonDef.name
	end
end