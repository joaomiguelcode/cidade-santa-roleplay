---@param collectible collectibles.Collectible
RegisterNetEvent( 'net.collectibles.added', function( collectible )

    -- Escrever diretamente na colecao sem fazer um request/update no servidor!
    gMeCollectiblesCollection.utils.writeInsert( collectible )
end)