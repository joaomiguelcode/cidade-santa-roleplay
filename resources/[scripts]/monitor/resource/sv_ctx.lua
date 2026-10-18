-- txAdmin sv_ctx.lua
RegisterNetEvent('txsv:req:serverCtx', function()
    local src = source
    TriggerClientEvent('txcl:setServerCtx', src, {
        projectName = GetConvar('sv_projectName', 'Cidade Santa Roleplay'),
        maxClients = GetConvarInt('sv_maxclients', 128),
        locale = 'pt-BR',
        oneSync = { type = 'infinity' }
    })
end)
