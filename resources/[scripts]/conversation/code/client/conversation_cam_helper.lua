local cam = nil
local camRotation = nil

---@param currentEntityPed number
function CreateCamInstance( currentEntityPed )

    if not currentEntityPed or not DoesEntityExist( currentEntityPed ) then
        -- sx.logger:error( ('Invalid entity for camera creation: entityId=%s'):format( tostring( currentEntityPed ) ) )
        return
    end

    local currentEntityPedCoords = GetEntityCoords( currentEntityPed, true )

    local pedForward =  GetEntityForwardVector( currentEntityPed ) * 1.2

    local camPos = currentEntityPedCoords + pedForward + vector3( 0.0, 0.0, 0.52 )

    local rx = GetEntityRotation( currentEntityPed, 2 )
    camRotation = rx + vector3( 0.0, 0.0, 181.0 )

    cam = CreateCamWithParams( "DEFAULT_SCRIPTED_CAMERA", camPos.x, camPos.y, camPos.z, camRotation, GetGameplayCamFov( ) )

    SetCamActive( cam, true )
    RenderScriptCams( true, true, 1000, 1, 1 )
end

function DestroyCamInstance( )
    if (not DoesCamExist( cam )) then
        -- print('Cam not found')
        return
    end

    RenderScriptCams( false, false, 0, false, false )
    SetCamActive( cam, false )
    DestroyCam( cam, false )
    cam = nil
end 