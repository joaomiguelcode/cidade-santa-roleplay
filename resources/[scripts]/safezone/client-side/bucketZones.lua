local IN_BUCKET_ZONE = false
local BUCKET_ZONES = {}
local DEBUG_POLY_BUCKET = false
CreateThread(function()
    for i=1,#bucketZones do
        local minZ = nil
        local maxZ = nil
        if bucketZones[i]["minZ"] then
            minZ = bucketZones[i]["minZ"]
            maxZ = bucketZones[i]["maxZ"]
        end
        local Zone = bucketZones[i]["Zone"]
        BUCKET_ZONES[i] = PolyZone:Create(Zone,{ name="BucketZone "..i, debugPoly=DEBUG_POLY_BUCKET, minZ=minZ, maxZ=maxZ})
    end
    Wait(100)
    while true do
        local Ped = PlayerPedId()
        local Idle = 100
        local Coords = GetEntityCoords(Ped)
        if not IN_BUCKET_ZONE then
            if not IsPedInAnyVehicle(Ped) then
                for i=1,#BUCKET_ZONES do
                    local Zone = BUCKET_ZONES[i]
                    if Zone:isPointInside(Coords) then
                        IN_BUCKET_ZONE = Zone
                        TriggerServerEvent("bucket:inBucketZone",i)
                        break
                    end
                end
            end
        else
            Idle = 50
            if not IN_BUCKET_ZONE:isPointInside(Coords) then
                IN_BUCKET_ZONE = false
                TriggerServerEvent("bucket:outBucketZone")
            end
        end
        Wait(Idle)
    end
end)