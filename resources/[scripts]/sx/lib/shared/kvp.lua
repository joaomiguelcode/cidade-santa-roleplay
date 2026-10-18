sx.kvp = { }

local GETTERS = {
	string = GetResourceKvpString,
	number = GetResourceKvpInt,
	float  = GetResourceKvpFloat,
}

local SETTERS = {
	string  = function( key, v ) 
		SetResourceKvp( key, v ) 
	end,

	number  = function( key, v ) 
		SetResourceKvpInt( key, v ) 
	end,

	boolean = function( key, v ) 
		SetResourceKvpInt( key, v and 1 or 0 ) 
	end,

	table   = function( key, v ) 
		SetResourceKvp( key, json.encode( v ) ) 
	end,
}

---@param key  string
---@param kind 'string'|'number'|'float'|nil
---@return any
function sx.kvp.get( key, kind )

	local getter = GETTERS[ kind ]

	local ok, result = pcall( getter, key )
	if ok then return result end

	-- sx.logger:warn( ('sx.kvp.get: falha ao ler "%s" (%s)'):format( key, result ) )
	DeleteResourceKvp( key )
	return
end

---@param key   string
---@param value string|number|boolean|table
function sx.kvp.set( key, value )

	local setter = SETTERS[ type( value ) ]

	if not setter then
		-- sx.logger:warn( ('sx.kvp.set: tipo invalido para "%s" (%s)'):format( key, type( value ) ) )
		return
	end

	setter( key, value )
end

---@param key string
function sx.kvp.delete( key )
	DeleteResourceKvp( key )
end

---@param key string
---@return table|nil
function sx.kvp.getJson( key )
	
	local raw = sx.kvp.get( key, 'string' )
	if not raw or raw == '' then 
		return 
	end

	local ok, decoded = pcall( json.decode, raw )
	if not ok or type( decoded ) ~= 'table' then
		-- sx.logger:warn( ('sx.kvp.getJson: JSON invalido em "%s"'):format( key ) )
		return
	end

	return decoded
end
