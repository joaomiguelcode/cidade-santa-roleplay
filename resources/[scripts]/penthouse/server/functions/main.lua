-- penthouse server functions
function EnterPenthouse(source, propertyId)
    local ped = GetPlayerPed(source)
    local bucket = 8000 + (tonumber(propertyId) or 1)
    SetPlayerRoutingBucket(source, bucket)
    TriggerClientEvent('penthouse:enter', source, propertyId)
end

function ExitPenthouse(source)
    SetPlayerRoutingBucket(source, 0)
    TriggerClientEvent('penthouse:exit', source)
end
