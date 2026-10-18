---@class AchievementNotificationQueue
---@field nextAllowedAt integer
---@field pending AchievementNotification|nil
---@field flushScheduled boolean
local AchievementQueue = {}
AchievementQueue.__index = AchievementQueue

---@class FeedbackAchievementsClientApi
FeedbackAchievementsClient = {}

---@return AchievementNotificationQueue queue
function AchievementQueue.New()
    return setmetatable( {
        nextAllowedAt = 0,
        pending = nil,
        flushScheduled = false,
    }, AchievementQueue )
end

local FEED_ICON_BY_TYPE = {
    individual_return = "🎉",
    individual_quality_return = "💎",
    individual_recruitment = "🤝",
    organization_recruitment = "🤝",
    organization_retention_milestone = "🎯",
}

---@return nil
local function PlayFeedSound()
    local sound = ACHIEVEMENT_NOTIFICATION_CONFIG.feedSound

    if not sound then
        -- sx.logger:warn( "hud achievement feed has no sound" )
        return
    end

    TriggerEvent( "sounds:Private", sound.url, sound.volume )
end

---@return nil
local function PlayBannerSound()
    local sound = ACHIEVEMENT_NOTIFICATION_CONFIG.bannerSound

    if not sound then
        -- sx.logger:warn( "hud achievement banner has no sound" )
        return
    end

    TriggerEvent( "sounds:Private", sound.url, sound.volume )
end

---@param notification AchievementNotification
---@return string text
local function BuildFeedText( notification )
    if notification.type == "individual_quality_return" then
        return _t( "hud.feedback.achievement.quality_returned" )
    end

    if notification.type == "individual_recruitment"
        or notification.type == "organization_recruitment" then
        return _t( "hud.feedback.achievement.recruitment_completed" )
    end

    if notification.type == "organization_retention_milestone" then
        return ( _t( "hud.feedback.achievement.fac_retention" ) ):format(
            notification.count or 5,
            notification.remaining or 0
        )
    end

    return _t( "hud.feedback.achievement.returned" )
end

---@param notification AchievementNotification
---@return nil
local function ShowFeed( notification )
    SendNUIMessage( {
        action = "xpFeed",
        data = {
            amount = ( "%s +%d XP" ):format(
                FEED_ICON_BY_TYPE[notification.type] or "🎉",
                notification.xp
            ),
            type = BuildFeedText( notification ),
            variant = "feedback",
        },
    } )
end

---@param notification AchievementNotification
---@return nil
function AchievementQueue:Show( notification )
    self.nextAllowedAt = GetGameTimer() + FeedbackTime.ToMilliseconds(
        ACHIEVEMENT_NOTIFICATION_CONFIG.cooldown
    )

    SendNUIMessage( {
        action = "missionNotify",
        data = {
            visible = true,
            subtitle = _t( "hud.feedback.achievement.banner_subtitle" ),
            title = BuildFeedText( notification ),
            extra = ( "+%d XP" ):format( notification.xp ),
            rewards = {},
            variant = "feedback",
        },
    } )

    ShowFeed( notification )
    PlayFeedSound()
    PlayBannerSound()

    CreateThread( function()
        Wait( FeedbackTime.ToMilliseconds( ACHIEVEMENT_NOTIFICATION_CONFIG.displayDuration ) )
        SendNUIMessage( { action = "missionNotify", data = { visible = false } } )
    end )
end

---@return nil
function AchievementQueue:ScheduleFlush()
    if self.flushScheduled then
        return
    end

    self.flushScheduled = true
    CreateThread( function()
        local remainingMs = math.max( 0, self.nextAllowedAt - GetGameTimer() )
        Wait( remainingMs )
        self.flushScheduled = false

        local pending = self.pending
        self.pending = nil

        if pending then
            self:Show( pending )
        end
    end )
end

---@param notification AchievementNotification
---@return nil
function AchievementQueue:Enqueue( notification )
    if GetGameTimer() >= self.nextAllowedAt and not self.pending then
        self:Show( notification )
        return
    end

    if not self.pending then
        self.pending = {
            type = notification.type,
            xp = notification.xp,
            count = notification.count or 1,
            remaining = notification.remaining,
        }
    else
        self.pending.xp = self.pending.xp + notification.xp
        self.pending.count = ( self.pending.count or 1 ) + ( notification.count or 1 )

        if notification.type == "individual_quality_return" then
            self.pending.type = notification.type
        end

        if notification.remaining ~= nil then
            self.pending.remaining = notification.remaining
        end
    end

    self:ScheduleFlush()
end

local queue = AchievementQueue.New()

---@return nil
function FeedbackAchievementsClient.Register()
    RegisterNetEvent( "hud:achievementNotification:enqueue", function( data )
        if type( data ) ~= "table" or type( data.type ) ~= "string" then
            -- sx.logger:warn( "hud achievement client ignored invalid payload" )
            return
        end

        local xp = math.floor( tonumber( data.xp ) or 0 )
        local count = math.max( 1, math.floor( tonumber( data.count ) or 1 ) )
        local remaining = math.max( 0, math.floor( tonumber( data.remaining ) or 0 ) )

        if xp <= 0 then
            -- sx.logger:warn( "hud achievement client ignored invalid xp" )
            return
        end

        local notification = {
            type = data.type,
            xp = xp,
            count = count,
            remaining = remaining,
        }

        if data.type == "individual_recruitment" or data.type == "organization_recruitment" then
            ShowFeed( notification )
            PlayFeedSound()
            return
        end

        queue:Enqueue( notification )
    end )
end
