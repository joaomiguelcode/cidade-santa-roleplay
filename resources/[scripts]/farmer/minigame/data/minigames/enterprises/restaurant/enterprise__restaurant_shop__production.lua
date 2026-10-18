DEFINE_MINIGAME 'enterprise__restaurant_shop__production' {

    -- Nome que será exibido para o jogador
    -- ( o sistema de exibir texto não gosta de acentos )
    displayName = _t( 'restaurant_route_displayname' ),
    distance = 10.0,
    flags = eMinigameDefFlags.MDF_ONLY_CREATED_BY_SCRIPT | eMinigameDefFlags.MDF__BEFORE_START__REQUIRE_TASK,
    duration = 16.0,
}