RegisterNUICallback( "aflStore.get", function( Data, Callback )
    local payload = vSERVER.GetAflStore() or {}
    local balance = type( payload.balance ) == "number" and payload.balance or 0

    Callback( { balance = balance } )
end )

local gAflBuying = false

RegisterNUICallback( "aflStore.buy", function( Data, Callback )
    if gAflBuying then
        Callback( { success = false, message = _t( "store_purchase_in_progress" ) } )
        return
    end

    gAflBuying = true
    local ok, result = pcall( function() return vSERVER.BuyAflStore( Data ) end )
    gAflBuying = false

    Callback( ok and result or { success = false, message = _t( "store_purchase_error" ) } )
end )
