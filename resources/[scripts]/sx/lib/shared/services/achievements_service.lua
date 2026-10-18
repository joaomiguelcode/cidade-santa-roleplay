-- TODO: Melhorars
sx.services.achievements = { }

---@alias sx.services.AchievementService.UUCID string

---@param object table
local function encodeUriComponent( object )

    local encoded = ''

    for key, value in pairs( object ) do
        encoded = encoded .. ('%s=%s&'):format( key, value )
    end

    return encoded
end

-- Copiado de sx/lib/server/services
IS_ENV_DEVELOPMENT = ( GetConvar('Development', '') or 'false' ) == 'true'

IS_ENV_PRODUCTION = not IS_ENV_DEVELOPMENT

IS_ENV_PRODUCTION = true

--TODO: Melhorar!
SX_SERVICES_ACHIEVEMENT_API_URL =
    IS_ENV_DEVELOPMENT
    and 'http://localhost:3000'
    or  'http://api.roleplayrp.com:4015'

---@param passport Passport
---@return sx.services.AchievementService.UUCID
function sx.services.achievements.passport2uucid( passport )

    -- Injetar parametro 'cityId' em todos os requests
    local cityId = IS_ENV_DEVELOPMENT
        and 'Development'
        or  cityName

    local uucid = ('%s_%s'):format( cityId, passport )

    return uucid
end

function sx.services.achievements.uucid2passport( uucid )

    local titleName, passport = string.match( uucid, '(%w+)_(%w+)' )

    assert( titleName, 'Invalid universal character id' )
    assert( passport, 'Invalid universal character id' )

    passport = tonumber( passport )

    return passport
end

---@param uucid             sx.services.AchievementService.UUCID
---@param achievementName   string
function sx.services.achievements.unlockAchievement( uucid, achievementId )
end

sx.services.achievements.stats = { }

---@class sx.services.AchievementService.Achievement
---@field id   sx.achievements.AchievementId
---@field name string
---@field resetSchedule? string

---@class sx.services.AchievementService.AchievementProgress
---@field uucid         sx.services.AchievementService.UUCID
---@field achievementId sx.achievements.AchievementId
---@field status        sx.achievements.AchievementProgressStatus
---@field progressValue number

---#

---@see HttpResponse
---@alias TRPCResponse<TData> { status: eHttpStatus, error: any } | { status: eHttpStatus.OK, data: { result: { data: TData } } }

---@alias sx.services.AchievementService.IncrementCharacterStatInput sx.stats.StatChange[]

---@class sx.services.AchievementService.IncrementCharacterStatOutput
---@field achievementProgressesCompleted sx.services.AchievementService.AchievementProgress[]

--[[
---@param input sx.stats.StatChange[]
---@param _tempHeaders? { authorization: string }
function sx.services.achievements.stats.increment( input, _tempHeaders )

    -- TODO: Melhorar, fazer um fetch genérico!
    local fetch = IS_SERVER
        and sx.server.http.transports.http
        or  sx.client.http.transports.nui

    ---@type TRPCResponse<sx.services.AchievementService.IncrementCharacterStatOutput>
    -- TODO: Usar sx.server.services.createClient para facilitar a definição de headers a afins tanto no client quanto no server
    local response = fetch( ('%s/trpc/v1.stats.increment'):format( SX_SERVICES_ACHIEVEMENT_API_URL ), { method = 'POST', input = input, headers = _tempHeaders } )

    -- print('sx.services.achievements.stats.increment :: response', json.encode(response, { indent = true }))

    assert( response.status == 200, 'Failed to increment stats' .. json.encode( response ) )

    return response
end
--]]

sx.services.achievements.leaderboard = { }

---@class sx.services.AchievementService.LeaderboardByStatInput
---@field uucid     sx.services.AchievementService.UUCID
---@field statName  string
---@field count?    number
---@field offset?   number
---@field date?     string

---@param statName  string
---@param include   sx.services.AchievementService.UUCID[]
---@param count?    number
function sx.services.achievements.leaderboard.getLeaderboardByStat( statName, include, count )

    ---@type sx.services.AchievementService.LeaderboardByStatInput
    local input =
    {
        uucid   = include[ 1 ],
        statName = statName,
        count   = count,
        offset  = nil,
        date    = nil,
    }

    -- TODO: Melhorar, fazer um fetch genérico!
    local fetch = IS_SERVER
        and sx.server.http.transports.http
        or  sx.client.http.transports.nui

    --@type TRPCResponse<sx.services.AchievementService.IncrementCharacterStatOutput>
    -- TODO: Usar sx.server.services.createClient para facilitar a definição de headers a afins tanto no client quanto no server
    local response = fetch( ('%s/v1/leaderboard/%s?uucid=%s'):format( SX_SERVICES_ACHIEVEMENT_API_URL, statName, include[ 1 ] ), { method = 'GET' } )

    -- print('sx.services.achievements.leaderboard.getLeaderboardByStat :: response', json.encode(response, { indent = true }))

    assert( response.status == 200, 'Failed to get leaderboard stats' .. json.encode( response ) )
end

sx.services.achievements.achievementprogress = { }

---@class sx.services.AchievementService.AchivementProgressByUUCIDInput
---@field uucid         sx.services.AchievementService.UUCID
---@field achievementId sx.achievements.AchievementId

---@alias sx.services.AchievementService.AchivementProgressByUUCIDOutput sx.services.AchievementService.AchievementProgress

---@param input sx.services.AchievementService.AchivementProgressByUUCIDInput
function sx.services.achievements.achievementprogress.getAchievementProgressByUUCID( input )

    -- TODO: Melhorar, fazer um fetch genérico!
    local fetch = IS_SERVER
        and sx.server.http.transports.http
        or  sx.client.http.transports.nui

    ---@type HttpResponse<sx.services.AchievementService.AchivementProgressByUUCIDOutput>
    local response = fetch( ('%s/v1/achievement-progress?%s'):format( SX_SERVICES_ACHIEVEMENT_API_URL, encodeUriComponent( input ) ), { method = 'GET', headers = { authorization = 'Bearer 00197ad8-f264-4b28-8eed-a4ab5c3534b1' } } )

    -- print('sx.services.achievements.achievementprogress.getAchievementProgress :: response', json.encode(response, { indent = true }))

    assert( response.status == 200, 'Failed to get leaderboard stats' .. json.encode( response ) )

    return response.data
end

function sx.services.achievements.upsertAchievement(data)
    return { id = data.name, name = data.name, resetSchedule = data.resetSchedule }
end

sx.server = sx.server or {}
sx.server.services = sx.server.services or {}
sx.server.services.achievements = sx.services.achievements
