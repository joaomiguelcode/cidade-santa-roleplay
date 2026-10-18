---Backend which uses the filesystem
---@param backendResourceName string
function sx.i18n.backends.fsBackend( backendResourceName )

    assert( backendResourceName )

    ---@type i18n.i18nBackend
    return {

        options =
        {
            loadPath = '/locales/{{lng}}/{{ns}}.json',
        },

        read = function( self, language, namespace, callback )

            local filename = sx.i18n.interpolator.interpolate( self.options.loadPath, {  } )

            print( 'filename', filename )

            xpcall(
                function()

                    local contents = LoadResourceFile( backendResourceName, filename )

                    local data = json.decode( data )

                    callback( nil, data )
                end,
                function( err )

                    callback( err, nil )
                end
            )
        end
    }
end