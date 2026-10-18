-- OOP Class helper
class = class or function(base)
    local cls = {}
    cls.__index = cls
    cls.__base = base

    setmetatable(cls, {
        __call = function(_, ...)
            local instance = setmetatable({}, cls)
            if cls.__init then
                cls.__init(instance, ...)
            end
            return instance
        end,
        __index = base
    })

    return cls
end

-- enterprise framework adapter
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')
vRPC = Tunnel.getInterface('vRP')
