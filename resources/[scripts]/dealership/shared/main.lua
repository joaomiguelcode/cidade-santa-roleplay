---@class dealership.VehicleInfoDatabaseInitOptions
---@field economyAverageBalance     number
---@field vehiclePricesMultiplier   number
---@field vehiclePricesOverride     table<string, number>

DEALERSHIP_VEHICLE_INFO_DATABASE_INIT_OPTIONS_STATE_BAG_KEY = 'dealership.vidio'

-- slashkeyvalue: Não sei pra que serve essa variável...
VehicleClass =
{
    ["Legendary"] = 20,
    ["Vip"] = 10
}

blockedVehicles = {
    "samsonfull",
    "gstdwood2",
    "oraclestd",
    "KHvyInsurgentPol",
    "KPoleveronFull",
    "KPolyReblaSuv",
    "KWeevilAbsPol",
    "gstrem1",
    "Kchillybin1",
    "KChillybin1",
    "bati2",
    "gstdukfull",
}

local blockedVehiclesLookup = { }
for _, vehicleId in ipairs( blockedVehicles ) do
    blockedVehiclesLookup[vehicleId] = true
end

---@param opts dealership.VehicleInfoDatabaseInitOptions
---@return table<string, unknown>, table<string, unknown>, table<string, unknown>
function InitDealershipVehicleInfoDatabase( opts )

    local economyAverageBalance, vehiclePricesMultiplier, vehiclePricesOverride in opts

    if IS_SERVER then

        GlobalState:set( DEALERSHIP_VEHICLE_INFO_DATABASE_INIT_OPTIONS_STATE_BAG_KEY, opts, true )
    end

    local Cars, Bikes, Rental = { }, { }, { }

	for Index,v in pairs( VehicleGlobal() ) do

        -- geesy: Gambiarrinhazinha de momento pra não mostrar alguns veículos em alguns casos...
    
        if not blockedVehiclesLookup[Index] then

            local isVIP = false
            if v["VIP"] then
                isVIP = true
            end
            if v["Mode"] == "cars" then
                local Price = v["Price"]
                if vehiclePricesOverride[Index] then
                    Price = vehiclePricesOverride[Index]
                end
                if v["Economy"] then
                    if economyAverageBalance > 1 then
                        Price = economyAverageBalance * (v["Economy"]*4)
                    end
                end
                Price = Price * vehiclePricesMultiplier
                if Price > 100 then
                    Cars[#Cars + 1] = { k = Index, name = v["Name"], price = Price, chest = v["Weight"], tax = v["Price"] * 0.10, isVIP = isVIP }
                end
                
            elseif v["Mode"] == "bikes" then
                local Price = v["Price"]
                if vehiclePricesOverride[Index] then
                    Price = vehiclePricesOverride[Index]
                end
                if v["Economy"] then
                    if economyAverageBalance > 1 then
                        Price = economyAverageBalance * (v["Economy"]*4)
                    end
                end
                Price = Price * vehiclePricesMultiplier
                if Price > 100 then
                    Bikes[#Bikes + 1] = { k = Index, name = v["Name"], price = Price, chest = v["Weight"], tax = v["Price"] * 0.10, isVIP = isVIP }
                end
            elseif v["Mode"] == "rental" then
                if v["Dealership"] then
                    local adjustedPrice = parseInt(economyAverageBalance * VehicleClass[v["Class"]])
                    if adjustedPrice > 100 then
                        if v["Dealership"] == "cars" then
                            Cars[#Cars + 1] = { k = Index, name = v["Name"], price = adjustedPrice, chest = v["Weight"], tax = v["Price"] * 0.10, isVIP = isVIP }
                        else
                            Bikes[#Bikes + 1] = { k = Index, name = v["Name"], price = adjustedPrice, chest = v["Weight"], tax = v["Price"] * 0.10, isVIP = isVIP }
                        end
                    end

                end
                local Price = v["Gems"]
                if Price then
                    --print(v["Name"],Price)
                    if vehiclePricesOverride[Index] then
                        Price = vehiclePricesOverride[Index]
                    end
                    Price = Price * vehiclePricesMultiplier
                    if Price > 100 then
                        Rental[#Rental + 1] = { k = Index, name = v["Name"], price = v["Gems"], chest = v["Weight"], tax = v["Price"] * 0.10, isVIP = isVIP, isDiamond = true }
                    end
                end
            end

        end
	end

    return Cars, Bikes, Rental
end