-- cargame main server-side
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

local server = {}
Tunnel.bindInterface('santa-cargame', server)

local eventActive = false
local participants = {}

function server.gridReady()
    local source = source
    return true
end

function server.vehicleReady()
    local source = source
    return true
end

function server._reportStanding(round, points)
    local source = source
    local passport = vRP.Passport(source)
    if not passport then return end
    if participants[source] then
        participants[source].points = (participants[source].points or 0) + (points or 0)
    end
end

RegisterNetEvent('cargame:server:acceptFromInvite', function()
    local source = source
    local passport = vRP.Passport(source)
    if not passport or not eventActive then return end
    
    participants[source] = {
        source = source,
        passport = passport,
        name = vRP.FullName(passport),
        points = 0
    }
    
    SetPlayerRoutingBucket(source, Config.EventBucketMin or 9000)
    TriggerClientEvent('cargame:client:startEvent', source)
end)

RegisterCommand('cargame', function(source, args)
    local passport = vRP.Passport(source)
    if not vRP.hasPermission(passport, 'Admin') then return end
    
    eventActive = true
    participants = {}
    TriggerClientEvent('Notify', -1, 'importante', 'O Evento Piso do Carro vai começar! Abra o convite para participar.')
end)
