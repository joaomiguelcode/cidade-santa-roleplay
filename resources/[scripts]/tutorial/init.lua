Tunnel = module('vrp', 'lib/Tunnel')
Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')
scope = IsDuplicityVersion()
resource = GetCurrentResourceName()

lang = GetConvar('language', 'pt-br') or 'pt-br'

class = function(base)
    local cls = {}
    cls.__index = cls
    cls.__base = base
    setmetatable(
        cls,
        {
            __call = function(_, ...)
                local instance = setmetatable({}, cls)
                if cls.__init then
                    cls.__init(instance, ...)
                end
                return instance
            end,
            __index = base
        }
    )
    return cls
end

if (scope) then
    rpc = {}
    vRPC = Tunnel.getInterface('vRP')
    Tunnel.bindInterface(resource, rpc)
    vCLIENT = Tunnel.getInterface(resource)
    mysql = exports['oxmysql']
else
    rpc = {}
    Tunnel.bindInterface(resource, rpc)
    vSERVER = Tunnel.getInterface(resource)
end
