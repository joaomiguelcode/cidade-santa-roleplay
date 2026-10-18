
local attachments = {}
RegisterNetEvent('sx:playerAttachment:sync', function(data)
    local src = source
    attachments[src] = data
    TriggerClientEvent('sx:playerAttachment:update', -1, src, data)
end)
