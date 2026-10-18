DEFINE_MINIGAME 'mining' {

    -- Nome que será exibido para o jogador
    -- ( o sistema de exibir texto não gosta de acentos )
    displayName = _t("mining"),

    -- Pontos de inicio do minigame
    points =
    {
        vector3( 2171.45, 2920.87, -81.08 ),
    },

    distance = 20.0,

    -- Duração desde o inicio até o termino do minigame
    duration = 60,

    -- Animação que será executada
    scriptedInteractionName = 'hacker_typing',

    -- # Recompensas
    rewards =
    {
        -- # Recompensas do tipo "monetário"
        currency =
        {
            -- # Quantidade de dinheiro que será recebido
            { amount = 1000 },
        },
    }
}