-----------------------------------------------------------------------------------------------------------------------------------------
-- LOJA DE DIAMANTES — Bridge NUI -> Server
-----------------------------------------------------------------------------------------------------------------------------------------

exports('OpenGemsStore', function(categoryName)
    if type(categoryName) ~= 'string' or categoryName == '' or #categoryName > 64 then
        return false
    end

    return OpenHub(nil, nil, categoryName) == true
end)

RegisterNUICallback( "store.get", function( Data, Callback )
    local store = vSERVER.GetStore()
    Callback( store or {} )
end )

-- Trava local contra clique repetido enquanto a compra anterior nao respondeu.
-- Defesa de primeira linha; o lock autoritativo por passport fica no server.
local gBuying = false

RegisterNUICallback( "store.buy", function( Data, Callback )
    if gBuying then
        Callback( { success = false, message = _t("store_purchase_in_progress") } )
        return
    end

    gBuying = true
    local ok, result = pcall( function() return vSERVER.BuyStore( Data ) end )
    gBuying = false

    Callback( ok and result or { success = false, message = _t("store_purchase_error") } )
end )

RegisterNUICallback( "store.history", function( Data, Callback )
    local ok, result = pcall( function() return vSERVER.GetStoreHistory( Data ) end )
    Callback( ok and result or { items = {}, total = 0, categories = {} } )
end )
