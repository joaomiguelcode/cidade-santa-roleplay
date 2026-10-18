local Tools = module("lib/Tools")

local Proxy = {}

local pcall 		 = pcall
local table_unpack = table.unpack
local fast_assert  = fast_assert

local Citizen_CreateThreadNow = Citizen.CreateThreadNow

---@param proxy 	table
---@param service 	string
---@return table
local function GetCallerProxyTrampoline( proxy, service )

	---@deprecated Em favor de clonar Characters[source] e remover as propriedades indesejadas
	--[[
	if service == 'vRP' then

		-- Toda chamada para vRP.Identity( passport ) será interceptada
		-- e redirecionada para o vRP.getIdentity_["propriedade"]( passport )
		proxy.Identity = function( passport )

			if not vRP.HasIdentity( passport ) then
				return false
			end

			return setmetatable({ __passport = passport }, {

				__index = function( t, key )

					-- vRP.Identity( passport )['license'] -> vRP.getIdentity_license( passport )
					return proxy[ ('getIdentity_%s'):format( key ) ]( passport )
				end
			})
		end
	end
	--]]

	return proxy
end

---@param provider string
---@param service  string
---@return string
local function GetProxyExportProviderServiceBasePath( provider, service )

	return ( 'vrp.proxy.%s.%s' ):format( provider, service )
end

---@param service string
---@param base    table
function Proxy.addInterface( service, base )

	local provider = VRP_LIB_CURRENT_RESOURCE_NAME

	local basePath = GetProxyExportProviderServiceBasePath( provider, service )

	---@param key 	  string
	---@param handler function
	local function createCallee( key, handler )

		if type( handler ) ~= 'function' then

			-- Ignorar propriedades que não são funções

			return
		end

		local path = ( '%s:%s' ):format( basePath, key )

		exports( path, function( ... )

			return handler( ... )
		end)
	end

	-- Registrar os handlers que já estão na tabela base.
	for key, handler in pairs( base ) do

		createCallee( key, handler )
	end

	setmetatable( base, {

		__newindex = function( t, key, handler )

			-- O callee vai ser registrar uma unica vez como export
			-- e registrado na tabela 'base' pra não chamar via exports

			createCallee( key, handler )

			rawset( t, key, handler )
		end,
	})
end

---@param service  string
---@param provider string
function Proxy.getInterface( service, provider )

	provider = provider or 'vrp'

	local basePath = GetProxyExportProviderServiceBasePath( provider, service )

	---@type table<string, fun(self, ...)>
	local exps = exports[ provider ]

	---@param key string
	local function createCaller( key ) 

		local isAsync = key:sub( 1, 1 ) == '_' -- Verificar se é uma função assíncrona

		key = isAsync
			and key:sub( 2 ) -- Remover o '_' do nome da função
			or  key

		local path = ( '%s:%s' ):format( basePath, key )

		local handler = exps[ path ]

		return function( ... )

			if PROFILER_RECORDING_STATE then

				local debuginfo = debug.getinfo( 2, 'Sl' )

				ProfilerEnterScope( ('profiling (vRP Proxy2) "%s".%s [@%s[%d]]'):format( service, key, debuginfo.short_src, debuginfo.currentline ) )
			end

			---		 { [1]: status , [2]: error  | ... }
			---@type { [1]: boolean, [2]: string | ... }
			local response = nil

			if isAsync then

				-- Citizen.CreateThreadNow Não aceita varargs...
				local input = { ... }

				response = {
					true, -- status
					Citizen_CreateThreadNow(
					function()

							handler( exps, table.unpack( input ) )
						end
					)
				}
			else

				-- `pcall` ja repassa os varargs para o handler; a closure intermediaria
				-- so alocava um objeto por chamada de vRP.*
				response = { pcall( handler, exps, ... ) }
			end

			local status = response[ 1 --[[ pcall->status --]] ]

			if PROFILER_RECORDING_STATE then

				ProfilerExitScope()
			end

			-- TODO: Melhorar esse error!
			fast_assert( status or ('Ocorreu um error ao chamar a função "%s" %s'):format( key, response[ 2 ] ), 3 )

			-- TODO: Handle "export not valid" errors?
			return table_unpack( response, 2 --[[ início da resposta do callback ( quando não tem error ) --]] )
		end
	end

	local proxy = setmetatable( GetCallerProxyTrampoline( { }, service ), {

		---@param t   self
		---@param key string
		__index = function ( t, key )

			local caller = createCaller( key )

			rawset( t, key, caller )

			return caller
		end
	})

	return proxy
end

return Proxy