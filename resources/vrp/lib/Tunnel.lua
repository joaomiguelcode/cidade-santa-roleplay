local Tools = module("lib/Tools")

local TriggerRemoteEvent = nil
local RegisterLocalEvent = nil
if SERVER then
	TriggerRemoteEvent = TriggerClientEvent
	RegisterLocalEvent = RegisterServerEvent
else
	TriggerRemoteEvent = TriggerServerEvent
	RegisterLocalEvent = RegisterNetEvent
end

local Tunnel = {}
local function tunnel_resolve(itable,key)
	local mtable = getmetatable(itable)
	local iname = mtable.name
	local ids = mtable.tunnel_ids
	local callbacks = mtable.tunnel_callbacks
	local identifier = mtable.identifier
	local fname = key
	local no_wait = false
	if string.sub(key,1,1) == "_" then
		fname = string.sub(key,2)
		no_wait = true
	end

	local fcall = function(...)

		local Message = {...} 

		if PROFILER_RECORDING_STATE then

			local info = debug.getinfo( 2, "Sl" )

			ProfilerEnterScope( ('profiling (vRP Tunnel) "%s".%s [to #%s @%s[%d]]'):format( iname, key, CLIENT and 'server' or Message[1], info.short_src, info.currentline ) ) -- 0

		end -- DEBUG end

		local r = nil
		local profile

		local dest = nil
		if SERVER then
			dest = Message[1]
			Message = { table.unpack(Message,2,table.maxn(Message)) }
			local validDest = dest and (dest == -1 or parseInt(dest) > 0)
			if validDest and not no_wait then
				r = async()
			end
		elseif not no_wait then
			r = async()
		end

		local rid = -1
		if r then
			rid = ids:gen()
			callbacks[rid] = r
		end

		if SERVER then
			if dest and (dest == -1 or parseInt(dest) > 0) then
				TriggerRemoteEvent(iname..":tunnel_req",dest,fname,Message,identifier,rid)
			end
		else
			TriggerRemoteEvent(iname..":tunnel_req",fname,Message,identifier,rid)
		end

		if r then
			local rets = { r:wait() }

			if PROFILER_RECORDING_STATE then

				ProfilerExitScope() -- 0

			end -- DEBUG end

			return table.unpack( rets )
		end

		if PROFILER_RECORDING_STATE then

			ProfilerExitScope() -- 0

		end -- DEBUG end
	end

	itable[key] = fcall

	return fcall
end

local eventStats = {}

function Tunnel.bindInterface(name, interface)
    RegisterLocalEvent(name .. ":tunnel_req")
    AddEventHandler(name .. ":tunnel_req", function(member, Message, identifier, rid)
        local source = source

		if PROFILER_RECORDING_STATE then

			ProfilerEnterScope( ('profiling (vRP Tunnel) "%s".%s [requested by #%s]'):format( name, member, source ) ) -- 0

		end -- DEBUG end

        local f = interface[member]

        local rets = {}
        if type(f) == "function" then
            rets = {f(table.unpack(Message, 1, table.maxn(Message)))}
        end

        if rid ~= nil then
            if rid >= 0 then
                if SERVER then
                    TriggerRemoteEvent(name .. ":" .. identifier .. ":tunnel_res", source, rid, rets)
                else
                    TriggerRemoteEvent(name .. ":" .. identifier .. ":tunnel_res", rid, rets)
                end
            end
        end

        local eventName = name
        if not eventStats[eventName] then
            eventStats[eventName] = {
                calls = 0,
                member = member,
            }
        end
        eventStats[eventName].calls = eventStats[eventName].calls + 1
        eventStats[eventName].member = member 

		if PROFILER_RECORDING_STATE then

			ProfilerExitScope() -- 0

		end -- DEBUG end
    end)
end

-- Citizen.CreateThread(function()
--     if PlayerPedId then
--         return
--     end
--     while true do
--         Citizen.Wait(60000) -- Wait for 1 minute
--         local Count = 0
--         for eventName, stats in pairs(eventStats) do
--             if stats.calls == 0 then
--                 eventStats[eventName] = nil
--             else
--                 Count = Count + 1
--             end
--         end
--         if Count > 0 then
--             for eventName, stats in pairs(eventStats) do
--                 print("TUNNEL:"..eventName.." | Function: "..stats.member.." Count: "..stats.calls)
--             end
--         end
--         eventStats = {}
--     end
-- end)


function Tunnel.getInterface(name,identifier)
	if not identifier then
		identifier = GetCurrentResourceName()
	end
  
	local callbacks = {}
	local ids = Tools.newIDGenerator()
	local r = setmetatable({},{ __index = tunnel_resolve, name = name, tunnel_ids = ids, tunnel_callbacks = callbacks, identifier = identifier })

	RegisterLocalEvent(name..":"..identifier..":tunnel_res")
	AddEventHandler(name..":"..identifier..":tunnel_res",function(rid,Message)
		local callback = callbacks[rid]
		if callback then
			ids:free(rid)
			callbacks[rid] = nil
			callback(table.unpack(Message,1,table.maxn(Message)))
		end
	end)

	return r
end

return Tunnel