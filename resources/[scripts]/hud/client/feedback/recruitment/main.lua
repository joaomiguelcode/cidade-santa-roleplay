---@param profile GamifiedFeedbackProfile
---@param rewardXp integer
---@return QualityRecruitmentCopy copy
local function GetQualityRecruitmentCopy( profile, rewardXp )
    local key = ( "hud.quality_recruitment.%s" ):format( profile )

    return {
        title = _t( "hud.quality_recruitment.title" ),
        subtitle = _t( key .. ".subtitle" ),
        banner = _t( key .. ".banner" ),
        factsTitle = _t( "hud.quality_recruitment.facts_title" ),
        facts = {
            _t( key .. ".fact1" ),
            _t( key .. ".fact2" ),
            _t( key .. ".fact3" ),
            _t( key .. ".fact4" ),
        },
        commitment = _t( key .. ".commitment" ),
        commitmentHint = _t( "hud.quality_recruitment.commitment_hint" ),
        confirmLabel = _t( "hud.quality_recruitment.confirm" ),
        rewardTitle = _t( key .. ".reward_title" ),
        footer = _t( key .. ".footer" ),
        rewardXp = rewardXp,
    }
end

---@param data unknown
---@return GamifiedFeedbackProfile|nil profile
---@return integer|nil rewardXp
local function ParseRewardPayload( data )
    if type( data ) ~= "table" then
        return nil, nil
    end

    local profile = data.profile
    local rewardXp = tonumber( data.rewardXp )

    if ( profile ~= "individual" and profile ~= "organization" ) or not rewardXp or rewardXp <= 0 then
        return nil, nil
    end

    return profile, math.floor( rewardXp )
end

---@class QualityRecruitmentModal
---@field open boolean
local RecruitmentModal = {}
RecruitmentModal.__index = RecruitmentModal

---@class FeedbackRecruitmentClientApi
FeedbackRecruitmentClient = {}

---@return boolean active
local function IsAffiliateCommercialActive()

    if GetResourceState( "dashboard" ) ~= "started" then
        return false
    end

    local ok, active = pcall( function()
        return exports.dashboard:IsAffiliateCommercialActive()
    end )

    return ok and active == true
end

---@return QualityRecruitmentModal modal
function RecruitmentModal.New()
    return setmetatable( { open = false }, RecruitmentModal )
end

---@param data unknown
---@return nil
function RecruitmentModal:Open( data )

    if IsAffiliateCommercialActive() then
        return
    end

    local profile, rewardXp = ParseRewardPayload( data )

    if not profile or not rewardXp then
        -- sx.logger:warn( "quality recruitment ignored invalid open payload" )
        return
    end

    self.open = true
    TriggerEvent( "ui:exclusiveModalOpened" )
    SetNuiFocus( true, true )
    SendNUIMessage( {
        action = "qualityRecruitment:open",
        data = GetQualityRecruitmentCopy( profile, rewardXp ),
    } )

    CreateThread( function()
        while self.open do
            DisableControlAction( 0, 200, true )
            DisableControlAction( 0, 322, true )
            SetNuiFocus( true, true )
            Wait( 100 )
        end
    end )
end

---@return nil
function RecruitmentModal:Close()
    self.open = false
    SetNuiFocus( false, false )
    SendNUIMessage( { action = "qualityRecruitment:close" } )
end

---@param data unknown
---@return nil
function RecruitmentModal:ShowReward( data )

    if IsAffiliateCommercialActive() then
        return
    end

    local profile, rewardXp = ParseRewardPayload( data )

    if not profile or not rewardXp then
        -- sx.logger:warn( "quality recruitment ignored invalid reward payload" )
        return
    end

    local copy = GetQualityRecruitmentCopy( profile, rewardXp )

    SendNUIMessage( {
        action = "xp:show",
        data = { amount = copy.rewardXp, title = copy.rewardTitle, duration = 4 },
    } )

    CreateThread( function()
        Wait( 4 * 1000 )
        SendNUIMessage( { action = "xp:hide" } )
    end )
end

---@return nil
function RecruitmentModal:Commit()
    if self.open then
        TriggerServerEvent( "hud:qualityRecruitment:commit" )
    end
end

local modal = RecruitmentModal.New()

exports( "IsQualityRecruitmentOpen", function()
    return modal.open == true
end )

---@return nil
function FeedbackRecruitmentClient.Register()
    RegisterNetEvent( "hud:qualityRecruitment:open", function( data )
        modal:Open( data )
    end )

    RegisterNetEvent( "hud:qualityRecruitment:close", function()
        modal:Close()
    end )

    RegisterNetEvent( "hud:qualityRecruitment:reward", function( data )
        modal:ShowReward( data )
    end )

    AddEventHandler( "dashboard:affiliateCommercialActiveChanged", function( active )

        if active ~= true then
            return
        end

        if modal.open then
            modal:Close()
        end

        SendNUIMessage( { action = "xp:hide" } )
    end )

    RegisterNUICallback( "qualityRecruitment:commit", function( _, cb )
        modal:Commit()
        cb( "ok" )
    end )
end
