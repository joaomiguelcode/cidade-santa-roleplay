--- TODO: Remover esta merda, não sei como o translation funciona
local function t(key, v )

    if key == 'achievements:playtime_hours_x_daily.displayName' then

        if GetConvar( 'language', 'pt-br' ) == 'en-us' then

            return ('Online for at least %s hour(s) (Today)'):format( v )
        end

        return ('Conectado por + de %s hora(s) (Hoje)'):format( v )
    end

    if key == 'achievements:playtime_hours_x_daily.description' then

        if GetConvar( 'language', 'pt-br' ) == 'en-us' then

            return ('Stay online for at least %s hour(s) to complete this mission (Today)'):format( v )
        end

        return ('Fique conectado por + de %s hora hoje para completar essa missão.'):format( v )
    end

    error( 'Key not found: ' .. key )
end

local CRON_EXPRESION_DIALY = '0 0 * * *'

-- TODO: Melhorar, eAchivementKind não está disponivel no primeiro tick!!
CreateThread(
    function()

        while not eAchievementKind or not eAchievements or not eAchievementRewardKind or not ACHIEVEMENTS or not ACHIEVEMENT do
            Wait(0)
        end

        ACHIEVEMENTS(

            ACHIEVEMENT( eAchievementKind.CHALLENGE, eAchievements.PLAYTIME_HOURS_1_DAILY, t( 'achievements:playtime_hours_x_daily.displayName', 1 ), t( 'achievements:playtime_hours_x_daily.description', 1 ),
                {
                    stats =
                    {
                        { name = 'playtime_hours', threshold = 1 },
                    },
                    rewards =
                    {
                        {
                            kind = eAchievementRewardKind.Item,
                            itemKey    = 'dollars',
                            itemAmount = 350,
                        }
                    },
                    resetSchedule = CRON_EXPRESION_DIALY,
                }),

            ACHIEVEMENT( eAchievementKind.CHALLENGE, eAchievements.PLAYTIME_HOURS_2_DAILY, t( 'achievements:playtime_hours_x_daily.displayName', 2 ), t( 'achievements:playtime_hours_x_daily.description', 2 ),
                {
                    stats =
                    {
                        { name = 'playtime_hours', threshold = 2 },
                    },
                    rewards =
                    {
                        {
                            kind = eAchievementRewardKind.Item,
                            itemKey    = 'dollars',
                            itemAmount = 520,
                        }
                    },
                    resetSchedule = CRON_EXPRESION_DIALY,
                }),

            ACHIEVEMENT( eAchievementKind.CHALLENGE, eAchievements.PLAYTIME_HOURS_5_DAILY, t( 'achievements:playtime_hours_x_daily.displayName', 5 ), t( 'achievements:playtime_hours_x_daily.description', 5 ),
                {
                    stats =
                    {
                        { name = 'playtime_hours', threshold = 5 },
                    },
                    rewards =
                    {
                        {
                            kind = eAchievementRewardKind.Item,
                            itemKey    = 'dollars',
                            itemAmount = 520,
                        }
                    },
                    resetSchedule = CRON_EXPRESION_DIALY,
                }),

            ACHIEVEMENT( eAchievementKind.CHALLENGE, eAchievements.PLAYTIME_HOURS_8_DAILY, t( 'achievements:playtime_hours_x_daily.displayName', 8 ), t( 'achievements:playtime_hours_x_daily.description', 8 ),
                {
                    stats =
                    {
                        { name = 'playtime_hours', threshold = 8 },
                    },
                    rewards =
                    {
                        {
                            kind = eAchievementRewardKind.Item,
                            itemKey    = 'dollars',
                            itemAmount = 1050,
                        }
                    },
                    resetSchedule = CRON_EXPRESION_DIALY,
                }),

            ACHIEVEMENT( eAchievementKind.CHALLENGE, eAchievements.PLAYTIME_HOURS_12_DAILY, t( 'achievements:playtime_hours_x_daily.displayName', 12 ), t( 'achievements:playtime_hours_x_daily.description', 12 ),
                {
                    stats =
                    {
                        { name = 'playtime_hours', threshold = 12 },
                    },
                    rewards =
                    {
                        {
                            kind = eAchievementRewardKind.Item,
                            itemKey    = 'dollars',
                            itemAmount = 1050,
                        }
                    },
                    resetSchedule = CRON_EXPRESION_DIALY,
                })

            --[[
            -- # eAchievements.EARNED_MONEY
            ACHIEVEMENT( eAchievementKind.CHALLENGE, eAchievements.EARNED_MONEY_1027, 'Ganhar 105 dólares', '',
                {
                    stats =
                    {
                        { name = 'earned_dollars', threshold = 105 },
                    },
                    rewards =
                    {
                        {
                            kind = eAchievementRewardKind.Item,

                            itemKey    = 'dollars',
                            itemAmount = 1,
                        }
                    }
                })
            --]]

            -- -- # eAchievements.POI_VISITED
            -- ACHIEVEMENT_UNSECURE( eAchievements.POI_VISITED_5, 'Visitar 5 Pontos de Interesse', '',
            --     {
            --         stats = {
            --             { name = 'poi_visited.hollywood'   , threshold = 1 },
            --             { name = 'poi_visited.riodejaneiro', threshold = 1 },
            --             { name = 'poi_visited.texas'       , threshold = 1 },
            --             { name = 'poi_visited.los_santos'  , threshold = 1 },
            --             { name = 'poi_visited.paleto'      , threshold = 1 },
            --         }
            --     }),
        )

    end
)