-- txAdmin sv_webpipe.lua
RegisterNetEvent('txsv:webpipe:req', function(id, method, path, headers, body)
    local src = source
    TriggerClientEvent('txcl:webpipe:resp', src, id, 200, '{}')
end)
