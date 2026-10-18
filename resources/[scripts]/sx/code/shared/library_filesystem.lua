GlobalState:set( 'sxlib_resource_name', GetCurrentResourceName(), false )

-- Inicializa o sistema de arquivos caso seja possivel!
CreateThread(function()
    -- Aguardar um tick para inicializar os exports

    SetIsLibraryFilesystemReady( GetLibraryFilesystem() ~= nil )
end)

AddEventHandler( 'onResourceStop', function( resourceName )

    if resourceName == RESOURCE_NAME then

        -- O recurso foi parado, vamos limpar o sistema de arquivos do client.
        SetIsLibraryFilesystemReady( false )
    end
end)