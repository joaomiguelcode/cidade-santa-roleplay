DEFINE_MINIGAME 'milking' {

    -- Nome que será exibido para o jogador
    -- ( o sistema de exibir texto não gosta de acentos )
    displayName = _t("milking"),

    distance = 7.0,

    -- Duração desde o inicio até o termino do minigame
    duration = 16.0,

    -- Animação que será executada
    scriptedInteractionName = 'cow_animation',

    flags = eMinigameDefFlags.MDF__BEFORE_START__REQUIRE_TASK,

    requirements =
    {
        -- flags = eMinigameRequirementsFlags.CONSUME_ITEMS,

        items =
        {
            { id = 'emptybottle', amount = 1 },
        },
    },

    -- # Recompensas
    rewards =
    {
        item =
        {
            { id = 'milkbottle', amount = 1 },
        }
    },

    -- Pontos de inicio do minigame
    points =
        table_join(
            {
                vector3(2440.58,4736.35,34.29),
                vector3(2432.5,4744.58,34.31),
                vector3(2424.47,4752.37,34.31),
                vector3(2416.28,4760.8,34.31),
                vector3(2408.6,4768.88,34.31),
                vector3(2400.32,4777.48,34.53),
                vector3(2432.46,4802.66,34.83),
                vector3(2440.62,4794.22,34.66),
                vector3(2448.65,4786.57,34.64),
                vector3(2456.88,4778.08,34.49),
                vector3(2464.53,4770.04,34.37),
                vector3(2473.38,4760.98,34.31),
                vector3(2495.03,4762.77,34.37),
                vector3(2503.13,4754.08,34.31),
                vector3(2511.34,4746.04,34.31),
                vector3(2519.56,4737.35,34.29),
            },
            SWITCH( cityName, {
                { 'Santa',
                    {
                        vector3(-1494.46,807.31,178.85),
                        vector3(-1494.09,810.22,178.90),
                        vector3(-1492.99,806.56,178.90),
                        vector3(-1493.41,807.88,178.90),
                        vector3(-70.82,807.25,227.25),
                        vector3(-62.39,945.51,232.43),
                        vector3(-1560.46,354.98,86.96),
                    }
                },
                { 'CidadeNobre',
                    {
                        vector3(-2567.41,-2191.89,2.84),
                        vector3(-2561.73,-2194.0,2.94),
                        vector3(-2557.31,-2195.76,2.99),
                        vector3(-2565.25,-2197.46,2.9),
                        vector3(-2561.19,-2198.54,2.95),
                    }
                },
                { 'Boomerang',
                    {
                    }
                },
                { 'Grande',
                    {
                    }
                },
                { 'Fronteira',
                    {
                    }
                },
                { 'Malta',
                    {
                    }
                },
                { 'GoatRP',
                    {
                    }
                },
                { 'Kingdom',
                    {
                    }
                },
                { 'District99',
                    {
                    }
                },

                { 'Krown',
                    {
                    }
                },
                { 'Orizon',
                    {
                    }
                },
                { 'Royal',
                    {
                    }
                },
                { 'Real',
                    {
                    }
                },
                { 'Prime',
                    {
                    }
                },
                { 'Universo',
                    {
                    }
                },
                { 'Alexandria',
                    {
                    }
                },
                { 'Maresia',
                    {
                    }
                },
            })
        )
}
