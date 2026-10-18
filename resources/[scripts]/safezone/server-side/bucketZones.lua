-----------------------------------------------------------------------------------------------------------------------------------------
-- BUCKET ZONES (SERVER)
-----------------------------------------------------------------------------------------------------------------------------------------
local playerBuckets = {}

RegisterNetEvent("safezone:setBucket", function(bucketId)
    local source = source
    bucketId = tonumber(bucketId) or 0
    SetPlayerRoutingBucket(source, bucketId)
    playerBuckets[source] = bucketId
end)

AddEventHandler("playerDropped", function()
    playerBuckets[source] = nil
end)
