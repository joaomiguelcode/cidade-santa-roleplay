sx.featureflags.enableVoicePreferences = sx.featureflag( {
    key = 'featureflag__voicechat_enabled_by_default',
    defaultValue = true,
    decide = function( opts )
        return GetConvarBool( opts.key, true )
    end,
} )
