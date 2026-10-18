Tunnel = module('vrp', 'lib/Tunnel')
Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')
scope = IsDuplicityVersion()
resource = GetCurrentResourceName()

cache = {}
disabledAlerts = {}
notificationIdCounter = 0

cityName = GetConvar('cityName', '')
language = string.lower(GetConvar("language", "pt-br") or "pt-br")
city = string.lower(cityName)

split = function(inputstr, sep)
    if sep == nil then
        sep = '%s'
    end
    local t = {}

    for field in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
        table.insert(t, field)
    end
    return t
end

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
    print('loading config for', city)
end



function table.count(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end
