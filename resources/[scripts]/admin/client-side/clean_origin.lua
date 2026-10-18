local CLEANUP_COORDS           = vector3( 0.0, 0.0, 0.0 )
local CLEANUP_RADIUS           = 50.0
local CLEANUP_TRIGGER_DISTANCE = 500.0
local CLEANUP_INTERVAL         = 100

CreateThread(function()

    while true do
        local playerCoords = GetEntityCoords( PlayerPedId() )

        if #( playerCoords - CLEANUP_COORDS ) <= CLEANUP_TRIGGER_DISTANCE then
            ClearAreaOfVehicles(
                CLEANUP_COORDS.x,
                CLEANUP_COORDS.y,
                CLEANUP_COORDS.z,
                CLEANUP_RADIUS,
                false,
                false,
                false,
                false,
                false
            )
            ClearAreaOfEverything(
                CLEANUP_COORDS.x,
                CLEANUP_COORDS.y,
                CLEANUP_COORDS.z,
                CLEANUP_RADIUS,
                false,
                false,
                false,
                false
            )
        end

        Wait( CLEANUP_INTERVAL )
    end
end)
