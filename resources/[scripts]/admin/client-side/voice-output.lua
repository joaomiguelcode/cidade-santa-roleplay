function Creative.CyclePlayerVoiceOutput( direction )

    return exports.voice_preferences:CycleVoiceDeviceAsync( 'output', direction )

end

function Creative.VoiceOutputCommandResult( message )

    print( message )
end
