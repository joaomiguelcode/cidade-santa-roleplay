---TODO: Melhorar isso!

exports( 'nui_proxy_send_message', function( message )

    local logger = sx and sx.logger or nil

    -- if logger then
    --     local data = message and message.data or nil

    --     logger:debug( ('Forwarding NUI message data=%s'):format( json.encode({
    --         type = ( message and message.type ) or 'unknown',
    --         invokingResource = ( message and message.invokingResource ) or 'unknown',
    --         url = ( data and data.url ) or '',
    --         method = ( data and data.method ) or '',
    --         hasInput = ( data and data.input ~= nil ) or false,
    --     }) ) )
    -- end

    SendNUIMessage( message )
end)