if IS_SERVER then
    
    Proxy = module( 'vrp', 'lib/Proxy' )

    vRP = Proxy.getInterface( 'vRP' )

    SQL = exports.oxmysql

end