sx.vehicles = { }

---@enum eKnockOffVehicle
eKnockOffVehicle =
{
    DEFAULT = 0,

    NEVER   = 1,

    EASY    = 2,
    
    HARD    = 3,
}


KNOCK_OFF_VEHICLE_ALLOWED_VEHICLES = {
    "kanb",
    "fox2",
    "WildChildSanta",
}

local VEHICLE_CLASS_MOTORCYCLES = 8


function sx.vehicles.GetKnockOffVehicleFlag()

    local pedId = PlayerPedId()

    local vehicle = GetVehiclePedIsIn( pedId )

    if GetVehicleClass( vehicle ) == VEHICLE_CLASS_MOTORCYCLES then
        return eKnockOffVehicle.NEVER
    end

    local vehicleModel = GetEntityModel( vehicle )

    local allowedVehicle = sx.table.find( 
        KNOCK_OFF_VEHICLE_ALLOWED_VEHICLES, 
        function( vehicle )
            return GetHashKey( vehicle ) == vehicleModel
        end
    )

    -- sx.logger:info( ('sx.vehicles.GetKnockOffVehicleFlag :: allowedVehicle: %s'):format( allowedVehicle ) )

    if allowedVehicle then
        return eKnockOffVehicle.NEVER
    end

    return eKnockOffVehicle.DEFAULT
end