---@class RankingMilestoneClientApi
RankingMilestoneClient = {}

---@class RankingMilestonePayload
---@field tier number
---@field position number

---@type RankingMilestonePayload|nil
local gPending = nil
---@type boolean
local gShowing = false
---@type RankingMilestonePayload|nil
local gCurrent = nil

local GATE_RETRY_MS = 1000
local COMMERCIAL_STATE_NUI_ACTION = "affiliateCommercialActiveChanged"

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

---@param active boolean
---@return nil
local function SendAffiliateCommercialState( active )

    SendNUIMessage( {
        action = COMMERCIAL_STATE_NUI_ACTION,
        data = active == true,
    } )
end

---@return nil
local function HoldFocus()
    CreateThread( function()
        while gShowing do
            DisableControlAction( 0, 200, true )
            DisableControlAction( 0, 322, true )
            SetNuiFocus( true, true )
            Wait( 100 )
        end
    end )
end

---@return boolean
local function CanDisplay()
    local ped = PlayerPedId()

    if IsAffiliateCommercialActive() then
        return false
    end

    if tonumber( LocalPlayer.state.Route ) ~= FEEDBACK_CONFIG.defaultWorldBucket then
        return false
    end

    if IsPedInCombat( ped, 0 ) or IsPedInMeleeCombat( ped ) or IsPlayerFreeAiming( PlayerId() ) then
        return false
    end

    if IsEntityDead( ped ) or IsPauseMenuActive() or IsNuiFocused() then
        return false
    end

    return true
end

---@param payload RankingMilestonePayload
---@return nil
local function OpenScreen( payload )
    gCurrent = payload
    SendNUIMessage( {
        action = "rankingGenteBoa:open",
        data = {
            milestone = payload.tier,
            position  = payload.position,
        },
    } )

    FeedbackClient.SetPriority( "rankingMilestone", true )
    TriggerEvent( "ui:exclusiveModalOpened" )
    SetNuiFocus( true, true )
    HoldFocus()

    TriggerServerEvent( "hud:rankingMilestone:shown", payload.tier )
end

---@return nil
local function CloseScreen()
    SendNUIMessage( { action = "rankingGenteBoa:close", data = {} } )
    gShowing = false
    gCurrent = nil
    SetNuiFocus( false, false )
    FeedbackClient.SetPriority( "rankingMilestone", false )
end

---@return nil
function RankingMilestoneClient.Register()

    RegisterNetEvent( "hud:rankingMilestone:show", function( payload )
        if type( payload ) ~= "table" or type( payload.tier ) ~= "number" then
            return
        end

        if gShowing or gPending then
            return
        end

        gPending = payload
    end )

    RegisterNUICallback( "rankingGenteBoa:close", function( _data, cb )
        CloseScreen()
        cb( { ok = true } )
    end )

    RegisterNUICallback( "rankingGenteBoa:viewRanking", function( _data, cb )
        CloseScreen()
        TriggerEvent( "hub:OpenRanking", { category = "personal" } )
        cb( { ok = true } )
    end )

    AddEventHandler( "dashboard:affiliateCommercialActiveChanged", function( active )

        SendAffiliateCommercialState( active )

        if active ~= true or not gShowing then
            return
        end

        local interrupted = gCurrent

        CloseScreen()
        gPending = interrupted or gPending
    end )

    CreateThread( function()

        Wait( 1000 )
        SendAffiliateCommercialState( IsAffiliateCommercialActive() )
    end )

    CreateThread( function()
        while true do
            if gPending and not gShowing and CanDisplay() then
                local payload = gPending
                gPending = nil
                gShowing = true
                OpenScreen( payload )
            end
            Wait( GATE_RETRY_MS )
        end
    end )
end
