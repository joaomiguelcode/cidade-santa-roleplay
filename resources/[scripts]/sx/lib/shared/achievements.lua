-- # Achievements

-- sx.client.achievements = { }
-- sx.server.achievements = { }

---@enum achievements.eAchievementRewardKind
eAchievementRewardKind =
{
    Item = 'item',
    Placeholder = 'placeholder',
}

---@class sx.achievements.AchievementBaseRewardDef
---@field kind achievements.eAchievementRewardKind

---@class (exact) sx.achievements.AchievementItemRewardDef : sx.achievements.AchievementBaseRewardDef
---@field kind achievements.eAchievementRewardKind.Item
---@field itemKey string
---@field itemAmount number

---@class (exact) sx.achievements.AchievementPlaceholderRewardDef : sx.achievements.AchievementBaseRewardDef
---@field kind achievements.eAchievementRewardKind.Placeholder
---@field test boolean

---@class sx.achievements.AchievementStatDef
---@field name      string
---@field threshold number

---@class sx.achievements.AchievementDefOptions
---@field stats     sx.achievements.AchievementStatDef[]
---@field rewards?  ( sx.achievements.AchievementItemRewardDef | sx.achievements.AchievementPlaceholderRewardDef )[]
---@field secure?   boolean [true] Quando true, esse achievement só poderá ser dado pelo servidor.
---@field resetSchedule? string [optional] Cron schedule para resetar o achievement.

---@alias sx.achievements.AchievementId string

---@class sx.achievements.AchievementDef
---@field idx         number
---@field name        achievements.eAchievements
---@field displayName string
---@field description string
---@field opts sx.achievements.AchievementDefOptions

---@class sx.services.AchievementService.CreateAchievementRequirementInput
---@field statName  string
---@field threshold number

---@class sx.services.AchievementService.CreateAchievementInput
---@field name                  string
---@field resetSchedule         string | null
---@field requirementsOptions   CreateAchievementRequirementInput[]

---@enum achievements.eAchievements
eAchievements =
{
    PLAYTIME_HOURS_1_DAILY  = 1,
    PLAYTIME_HOURS_2_DAILY  = 2,
    PLAYTIME_HOURS_5_DAILY  = 3,
    PLAYTIME_HOURS_8_DAILY  = 4,
    PLAYTIME_HOURS_12_DAILY = 5,

    -- EARNED_MONEY_100 = 10,
    -- EARNED_MONEY_1027 = 11,

    -- POI_VISITED_5 = 20,
}

---@enum sx.achievements.eAchievementKind
eAchievementKind =
{
    CHALLENGE   = 'challenge',  -- 'Desafios,       - conquistaas geralmente diárias
    GENERIC     = 'generic',    -- 'Genéricos'      - conquistas geralmente sem um tipo específico
    POPULARITY  = 'popularity', -- 'Popularidade'   - conquistas relacionadas a popularidade; likes, reputação, etc...
    MISC        = 'misc',       -- 'Outros'         - conquistas relacionadas a ?
    SPENDING    = 'spending',   -- 'Comercial'      - conquistas relacionadas a vendas, compras, etc...
    LEGENDARY   = 'legendary',  -- 'Lendários'      - conquistas relacionadas a ?
}

---@type table<number, achievements.eAchievements>
local ACHIVEMENT_NAME_BY_INDEX = { }

for achievementName, achievementIdx in pairs( eAchievements ) do

    ACHIVEMENT_NAME_BY_INDEX[ achievementIdx ] = achievementName
end    

---@param idx number
---@return achievements.eAchievements
local function GetAchievementNameByIndex( idx )

    local achievementName = ACHIVEMENT_NAME_BY_INDEX[ idx ]

    assert( achievementName, 'Achievement index not found' )

    return string.lower( achievementName )
end

---@type table<sx.achievements.AchievementId, sx.achievements.AchievementDef>
local gResourceAchievementDefsById = nil

---@param kind        sx.achievements.eAchievementKind
---@param idx         number
---@param displayName string
---@param description string
---@param opts        sx.achievements.AchievementDefOptions
---@return sx.achievements.AchievementDef
function ACHIEVEMENT( kind, idx, displayName, description, opts )

    -- Por padrao, Achievements só podem ser dados pelo servidor.
    opts.secure = opts.secure or true

    local name = GetAchievementNameByIndex( idx )

    ---@type sx.achievements.AchievementDef
    local def       = { }
    def.name    = name
    def.displayName = displayName
    def.description = description
    def.opts    = opts

    return def
end

---@param kind        sx.achievements.eAchievementKind
---@param idx         number
---@param name        string
---@param description string
---@param opts        sx.achievements.AchievementDefOptions
function ACHIEVEMENT_UNSECURE( kind, idx, name, description, opts )

    opts.secure = false

    return ACHIEVEMENT( idx, name, description, opts )
end

---@param ... sx.achievements.AchievementDef
function ACHIEVEMENTS( ... )

    if IS_SERVER then

        local resourceAchievementDefsById = { }

        for _, achievementDef in ipairs( { ... } ) do

            local achService = sx.server and sx.server.services and sx.server.services.achievements
            local achievement = achService and achService.upsertAchievement and achService.upsertAchievement({
                name = achievementDef.name,
                resetSchedule = achievementDef.opts.resetSchedule,
                requirementsOptions = sx.table.map( achievementDef.opts.stats, function( stat )

                    ---@type sx.services.AchievementService.CreateAchievementRequirementInput
                    return {
                        statName  = stat.name,
                        threshold = stat.threshold,
                    }
                end)
            })

            if achievement and achievement.resetSchedule then

                -- Resetar todos os achievements que estão com status "Unlocked"
                --
                -- Usado em achievements diarios, que resetam ao final do dia!
                lib.cron.new( achievement.resetSchedule, function()

                    sx.server.services.achievements.resetAllUnlockedAchievementProgressByAchievementId({ achievementId = achievement.id })
                end)
            end

            if achievement and achievement.id then
                resourceAchievementDefsById[ achievement.id ] = achievementDef
            end
        end

        gResourceAchievementDefsById = resourceAchievementDefsById

        print( ('gResourceAchievementDefsById = %s'):format( json.encode( gResourceAchievementDefsById, { indent = true } ) ) )
    end
end

---Essa função só deve ser executada no script
---que está definindo os ACHIEVEMENTS
---@return sx.achievements.AchievementDef[]
function GET_ACHIEVEMENT_DEFS()

    assert( gResourceAchievementDefsById )

    local achievementDefs = sx.table.map( gResourceAchievementDefsById, function( achievementDef )

        return achievementDef
    end)

    return achievementDefs
end

---Essa função só deve ser executada no script
---que está definindo os ACHIEVEMENTS
---@param achievementId sx.achievements.AchievementId
---@return sx.achievements.AchievementDef
function GET_ACHIEVEMENT_DEF_BY_ID( achievementId )

    assert( gResourceAchievementDefsById, 'Achievement defs not loaded' )

    local achievementDef = gResourceAchievementDefsById[ achievementId ]

    assert( achievementDef, ('Achievement def not found for id "%s"'):format( achievementId ) )

    return achievementDef
end

-- sx.client.achievements.unlockAchievement( eAchievements.EARNED_MONEY_100         )
-- sx.server.achievements.unlockAchievement( eAchievements.EARNED_MONEY_100, source )

--[[

# registrar PLAYSTAT_UNSECURE na api, client buscar a lista de playstats e só recebe os unsecure

# server buscar a lista de playstats e recebe todos, vai ser validado nas api do sx "sx.server.playstats.increment"
# api processa increments no playstat
# caso decidido que vá recebe achievement, adicionar no banco de dados
# e enviar para o servidor, que vai atualizar a lista de achievements do client.

PLAYSTAT_UNSECURE( 'playtime_hours_at_day.%s', ePlaystatSecurityFlags.READ_ONLY )

playtime_hours
playtime_hours_at_day.22112024   -- unix timestamp of the day?
earned_money
poi_visited.hollywood       -- point of interest
likes_received
org_?_delivered

--]]    
-- sx.playstats.load()
-- sx.server.playstats.increment( 'playtime_hours_at_day' )
-- sx.server.playstats.set()
-- # Tests

-- sx.server.achievements.setAchievementProgress( source, eAchievements.WIN_ONE_GAME, 1 )

-- ---@class (exact) metrics.MetricEarnMoney
-- ---@field amount number

-- function AddMoney( addAmount )

--     local balance = 99

--     balance = balance + addAmount

--     sx.server.playstats.increment( 'earned_money', addAmount )
-- end

-- AddMoney( 1 )