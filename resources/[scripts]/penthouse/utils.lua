Tunnel   = module('vrp', 'lib/Tunnel')
Proxy    = module('vrp', 'lib/Proxy')
vRP      = Proxy.getInterface('vRP')
scope    = IsDuplicityVersion()
resource = GetCurrentResourceName()

city = string.lower(GetConvar("cityName", ""))
accessTypesEnum = {
    [1] = 'trancado_campainha',
    [2] = 'aberto',
    [3] = 'trancado',
    [4] = 'invisivel'
}

accessTypesEnumReverse = {
    ['trancado_campainha'] = 1,
    ['aberto']             = 2,
    ['trancado']           = 3,
    ['invisivel']          = 4
}

local scope = IsDuplicityVersion() and 'server' or 'client'
language    = GetConvar('language', 'pt-br') or 'pt-br'

function tD(n)
	n = math.ceil(n * 100) / 100
	return n
end

function string.split(inputstr, sep)
    if sep == nil then
    sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
    end

    return t
end

function table.reverse(original)
    local reversed = {}
    for key, value in pairs(original) do
        reversed[value] = key
    end
    return reversed
end


if scope == 'server' then
    rpc = {} -- vrp server => client rpc
    vRP = Proxy.getInterface('vRP')
    vRPc = Tunnel.getInterface('vRP')
    Tunnel.bindInterface(resource, rpc)
    vCLIENT = Tunnel.getInterface(resource)

else
    rpc = {} -- vrp client => server rpc
    Tunnel.bindInterface(resource, rpc)
    vSERVER = Tunnel.getInterface(resource)
end