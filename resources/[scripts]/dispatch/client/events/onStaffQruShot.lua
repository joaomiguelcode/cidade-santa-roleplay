local staffQruBlips = {}

local staffQruBlipCounter = 0

local STAFF_QRU_BLIP_DURATION_MS = 60000

CreateThread( function()
    while true do
        for _, blip in pairs( staffQruBlips ) do
            if DoesBlipExist( blip ) then
                SetBlipColour( blip, 85 )
            end
        end

        Wait( 500 )

        for _, blip in pairs( staffQruBlips ) do
            if DoesBlipExist( blip ) then
                SetBlipColour( blip, 1 )
            end
        end

        Wait( 500 )
    end
end )

onStaffQruShot = function( coords )
    if not coords then
        return
    end

    staffQruBlipCounter = staffQruBlipCounter + 1
    local id = tostring( staffQruBlipCounter )

    local x = coords.x
    local y = coords.y
    local z = coords.z

    local gunShotsBlipConfig = config.reportBlips[enum.reportType.gunShots]
    local handler = gunShotsBlipConfig and gunShotsBlipConfig.handler

    if not handler then
        return
    end

    local blip = handler( x, y, z )

    staffQruBlips[id] = blip

    local timeToDelete = gunShotsBlipConfig.timeToDelete or STAFF_QRU_BLIP_DURATION_MS

    SetTimeout( timeToDelete, function()
        if DoesBlipExist( blip ) then
            RemoveBlip( blip )
        end

        staffQruBlips[id] = nil
    end )
end

RegisterNetEvent( 'dispatch:onStaffQruShot', onStaffQruShot )
