-- deathstatue main server-side
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

local server = {}
Tunnel.bindInterface('santa-deathstatue', server)

local eventActive = false
local participants = {}

function server.playerEnteredFinishZone()
    local source = source
    local passport = vRP.Passport(source)
    if not passport then return end
    
    if participants[source] and not participants[source].finished then
        participants[source].finished = true
        participants[source].points = (participants[source].points or 0) + 100
        RecordDeathstatueScore(passport, participants[source].name, 100, true)
        TriggerClientEvent('Notify', source, 'sucesso', 'Parabéns! Você cruzou a linha de chegada!')
    end
end

function server.playerLeftZone()
end

function server.playerCaught()
    local source = source
    local ped = GetPlayerPed(source)
    SetEntityHealth(ped, 100) -- knocked down
    TriggerClientEvent('Notify', source, 'negado', 'Você se mexeu no sinal vermelho e foi eliminado!')
end

RegisterNetEvent('deathstatue:server:acceptFromInvite', function()
    local source = source
    local passport = vRP.Passport(source)
    if not passport or not eventActive then return end
    
    participants[source] = {
        source = source,
        passport = passport,
        name = vRP.FullName(passport),
        points = 0,
        finished = false
    }
    
    SetPlayerRoutingBucket(source, Config.EventBucketMin or 9000)
    TriggerClientEvent('deathstatue:client:startEvent', source)
end)

RegisterCommand('deathstatue', function(source, args)
    local passport = vRP.Passport(source)
    if not vRP.hasPermission(passport, 'Admin') then return end
    
    eventActive = true
    participants = {}
    TriggerClientEvent('Notify', -1, 'importante', 'O Evento Batatinha Frita 1, 2, 3 vai começar!')
end)
