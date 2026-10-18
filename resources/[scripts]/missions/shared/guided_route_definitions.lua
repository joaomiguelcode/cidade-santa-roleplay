cityName = GetConvar("cityName", "")

CONNECT_ONBOARDING_DOCUMENTO_COORDS = vec3(142.50, -987.95, 29.67)
CONNECT_ONBOARDING_DOCUMENTO_HEADING = 359.22

if cityName == "Kingdom" then
	CONNECT_ONBOARDING_DOCUMENTO_COORDS = vec3(144.6, -983.52, 30.6)
	CONNECT_ONBOARDING_DOCUMENTO_HEADING = 56.7
end



GUIDED_ROUTE_PRESETS = {

    connect_documento = {

        id = 'connect_documento',

        destination = vec3(145.16,-991.73,29.36),

        blipSprite = 480,

        blipColour = 3,

        blipScale = 0.9,

        blipShortRange = false,

        labelTranslationKey = 'mission.documento_na_mao.waypoint.title',

        labelFallback = 'Documento',

    },

}



GUIDED_ROUTE_MISSION_RULES = {

    {

        presetId = 'connect_documento',

        startWhenMissionInProgress = 'primeiras_rodas',

        startAfterMissionCompletes = 'primeiras_rodas',

        stopWhenMissionCompletes = 'documento_na_mao',

        startOnVehicleEnter = true,

        requireDriverSeat = true,

    },

}

