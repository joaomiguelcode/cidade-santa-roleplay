---@type GamifiedFeedbackSnapshot|nil
local gActionSnapshot = nil
local FEEDBACK_ACTION_COMMAND = "hudOpenFeedbackRanking"

---@class FeedbackQualityClientApi
FeedbackQualityClient = {}

local ACTION_TARGETS = {
    individual = { category = "personal", openSaiba = true, openDailyBreakdown = false },
    organization = { category = "organization", openSaiba = false, openDailyBreakdown = true },
}

local SOUND_BY_QUALITY = {
    excellent = QUALITY_FEEDBACK_CONFIG.sounds.positive,
    good = QUALITY_FEEDBACK_CONFIG.sounds.positive,
    medium = QUALITY_FEEDBACK_CONFIG.sounds.negative,
    bad = QUALITY_FEEDBACK_CONFIG.sounds.negative,
    very_bad = QUALITY_FEEDBACK_CONFIG.sounds.negative,
}

---@param text string
---@param recruited integer
---@param notReturned integer
---@return string resolved
local function ResolvePlaceholders( text, recruited, notReturned )
    return ( text:gsub( "{r}", tostring( recruited ) ):gsub(
        "{n}",
        tostring( notReturned )
    ) )
end

---@param snapshot GamifiedFeedbackSnapshot
---@return GamifiedFeedbackText|nil text
local function ResolveText( snapshot )
    local byProfile = GAMIFIED_FEEDBACK_TEXTS[snapshot.profile]

    if not byProfile then
        return nil
    end

    return byProfile[snapshot.qualityState]
end

---@param snapshot GamifiedFeedbackSnapshot
---@param text GamifiedFeedbackText
---@return string[] description
local function BuildDescription( snapshot, text )
    local qualityWindow = snapshot.qualityWindow
    local recruited = math.max( 0, math.floor( qualityWindow.recruited or 0 ) )
    local returned = math.max( 0, math.min( recruited, math.floor( qualityWindow.returned or 0 ) ) )
    local notReturned = recruited - returned
    local description = {}

    for index = 1, #text.description do
        description[index] = ResolvePlaceholders( text.description[index], recruited, notReturned )
    end

    return description
end

---@return nil
local function OpenFeedbackRanking()
    local snapshot = gActionSnapshot

    if not snapshot then
        return
    end

    gActionSnapshot = nil
    TriggerEvent( "hub:OpenRanking", ACTION_TARGETS[snapshot.profile] )
    TriggerEvent( "hud:gamifiedFeedback:dismiss" )
end

---@param snapshot GamifiedFeedbackSnapshot
---@return nil
local function OnFeedbackShow( snapshot )
    local text = ResolveText( snapshot )

    if not text then
        -- sx.logger:warn( ( "hud gamified feedback without text profile=%s state=%s" ):format(
            -- tostring( snapshot.profile ),
            -- tostring( snapshot.qualityState )
        -- ) )
        return
    end

    SendNUIMessage( {
        action = "feedback:show",
        data = {
            type = text.type,
            title = text.title,
            description = BuildDescription( snapshot, text ),
            actionKey = "M",
            actionLabel = text.actionLabel,
            duration = FeedbackTime.ToSeconds(
                QUALITY_FEEDBACK_CONFIG.timing.displayDuration
            ),
        },
    } )

    local sound = SOUND_BY_QUALITY[snapshot.qualityState]

    if sound then
        TriggerEvent( "sounds:Private", sound.url, sound.volume )
    end

    gActionSnapshot = snapshot
end

---@return nil
local function OnFeedbackHide()
    gActionSnapshot = nil
    SendNUIMessage( { action = "feedback:hide" } )
end

---@return nil
function FeedbackQualityClient.Register()
    -- Tecla unica (M): se algum card de punicao por recrutamento reivindicou a acao
    -- (`FeedbackActionKey`, ENG-3050 §3.2b), ela manda; senao, cai no comportamento de sempre.
    RegisterCommand( FEEDBACK_ACTION_COMMAND, function()
        if FeedbackActionKey.Trigger() then
            return
        end

        OpenFeedbackRanking()
    end, false )
    RegisterKeyMapping( FEEDBACK_ACTION_COMMAND, _t( "hud.keymap.feedback_open_ranking" ), "keyboard", "M" )
    AddEventHandler( "hud:gamifiedFeedback:show", OnFeedbackShow )
    AddEventHandler( "hud:gamifiedFeedback:hide", OnFeedbackHide )
end
