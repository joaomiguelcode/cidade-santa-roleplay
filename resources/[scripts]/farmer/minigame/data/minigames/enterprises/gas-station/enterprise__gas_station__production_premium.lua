DEFINE_MINIGAME 'enterprise__gas_station__production_premium' {

    -- Nome que será exibido para o jogador
    -- ( o sistema de exibir texto não gosta de acentos )
    displayName = _t( 'gas_route_displayname' ),

    distance = 1.5,

    -- Duração desde o inicio até o termino do minigame
    duration = 16.0,

    flags = eMinigameDefFlags.MDF_ONLY_CREATED_BY_SCRIPT,
}