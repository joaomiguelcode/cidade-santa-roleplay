IS_SERVER = GetGameName() == 'fxserver'
IS_CLIENT = not IS_SERVER

if IS_SERVER then

    Proxy = module( 'vrp','lib/Proxy' )
    Tunnel = module( 'vrp','lib/Tunnel' )

    vRP = Proxy.getInterface( 'vRP' )
    vRPC = Tunnel.getInterface( 'vRP' )
    adminInputDialog = Tunnel.getInterface( 'admin' )
else

    Proxy = module( 'vrp','lib/Proxy' )
    Tunnel = module( 'vrp','lib/Tunnel' )

    vRP = Proxy.getInterface( 'vRP' )
    vRPC = Tunnel.getInterface( 'vRP' )

end