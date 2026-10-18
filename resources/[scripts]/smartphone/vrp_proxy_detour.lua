
local Proxy = module('vrp','lib/Proxy')

local vRP = Proxy.getInterface('vRP')

--- 'smartphone' usa os eventos default do Proxy da vRP para fazer chamadas, a gente já não usa mais isso...
AddEventHandler( 'vRP:proxy', function(member,Message,identifier,rid)

    if identifier ~= 'smartphone' then

        return
    end

    local handler = vRP[ member ]

    local rets = { handler( table.unpack( Message ) ) }

    TriggerEvent( 'vRP:' .. identifier.. ':proxy_res', rid, rets )
end)