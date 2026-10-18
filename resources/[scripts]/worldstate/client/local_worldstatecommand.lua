local Proxy = module("vrp","lib/Proxy")

vRP = Proxy.getInterface("vRP")

-- RegisterCommand( _t("day"), function( source, args )
--     Wait(100)
--     print("Day command")
--     SetWorldClockOverride( 12 )
-- end, false)

-- RegisterCommand( _t("night"), function( source, args )

--     ClearWorldClockOverride()
-- end, false)

RegisterCommand( 'servertime', function( source, args )

    print( ('Server time is: %0.2f'):format( GetServerTime() ) )
end, false)

RegisterCommand( 'smoggy', function( source, args )

    local playerGroups = vRP.GetPlayerGroups()
	local isAdmin = playerGroups["Admin"] == 1 or playerGroups["gestaoinfluencer"] == 1 or playerGroups["Developers"] == 1

    if not isAdmin then
        return
    end

    exports["worldstate"]:SetWeatherOverride( "SMOG" )
end, false)

RegisterCommand( 'foggy', function( source, args )

    local playerGroups = vRP.GetPlayerGroups()
	local isAdmin = playerGroups["Admin"] == 1 or playerGroups["gestaoinfluencer"] == 1 or playerGroups["Developers"] == 1

    if not isAdmin then
        return
    end

    exports["worldstate"]:SetWeatherOverride( "FOGGY" )
end, false)