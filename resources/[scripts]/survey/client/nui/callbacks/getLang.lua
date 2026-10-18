RegisterNUICallback( "getLang", function( data, cb )
    local name = ( type( data ) == "table" and data.resourceName ) or ( type( data ) == "string" and data ) or "survey"
    local targetLang = GetConvar( "language", "pt-br" )

    local fileUrl = ( "locales/frontend-i18n-config/%s/%s.json" ):format( targetLang, name )
    local contents = LoadResourceFile( "localization", fileUrl )

    if not contents then
        contents = LoadResourceFile( "localization", ( "locales/frontend-i18n-config/pt-br/%s.json" ):format( name ) )
    end

    cb( 
        contents and json.decode( contents ) or {} 
    )
end)
