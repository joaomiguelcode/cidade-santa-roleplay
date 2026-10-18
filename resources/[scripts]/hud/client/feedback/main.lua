---@class GamifiedFeedbackController
---@field state GamifiedFeedbackTimerState
---@field snapshot GamifiedFeedbackSnapshot|nil
---@field remainingMs integer
---@field lastTickAt integer
---@field visible boolean
---@field stopTick fun()|nil
---@field priorities table<string, boolean>
local Feedback = {}
Feedback.__index = Feedback

---@class FeedbackClientApi
FeedbackClient = {}

---@return GamifiedFeedbackController controller
function Feedback.New()
    return setmetatable( {
        state = "disabled",
        snapshot = nil,
        remainingMs = 0,
        lastTickAt = 0,
        visible = false,
        stopTick = nil,
        priorities = {
            nearbyMission = false,
            organizationRanking = false,
            -- ENG-3050 §3.2b/§4: "enquanto o player tem estagio ativo ou esta suspenso, o aviso de
            -- qualidade fica mudo" -- dois avisos vermelhos com a mesma cara confundem.
            recruitmentPunishment = false,
        },
    }, Feedback )
end

---@return boolean isInDefaultWorld
function Feedback:IsInDefaultWorld()
    return tonumber( LocalPlayer.state.Route ) == FEEDBACK_CONFIG.defaultWorldBucket
end

---@return boolean canDisplay
function Feedback:CanDisplay()
    return self:IsInDefaultWorld()
        and not self.priorities.nearbyMission
        and not self.priorities.organizationRanking
        and not self.priorities.recruitmentPunishment
        and not self.priorities.toxicity
end

---@param visible boolean
---@return nil
function Feedback:SetVisible( visible )
    if self.visible == visible then
        return
    end

    self.visible = visible
    TriggerEvent( "hud:gamifiedFeedback:visibilityChanged", visible )

    if visible and self.snapshot then
        TriggerEvent( "hud:gamifiedFeedback:show", self.snapshot )
        return
    end

    TriggerEvent( "hud:gamifiedFeedback:hide" )
end

---@return nil
function Feedback:StopTimer()
    if self.stopTick then
        self.stopTick()
        self.stopTick = nil
    end
end

---@return nil
function Feedback:Disable()
    self:SetVisible( false )
    self.state = "disabled"
    self.snapshot = nil
    self.remainingMs = 0
    self.lastTickAt = 0
    self:StopTimer()
end

---@return nil
function Feedback:StartTimer()
    if self.stopTick then
        return
    end

    self.lastTickAt = GetGameTimer()
    self.stopTick = sx.script.setTick( function()
        self:Update()
    end )
end

---@return nil
function Feedback:BeginDisplay()
    if not self.snapshot then
        self:Disable()
        return
    end

    self.state = "displaying"
    self.remainingMs = FeedbackTime.ToMilliseconds( QUALITY_FEEDBACK_CONFIG.timing.displayDuration )
    self:SetVisible( self:CanDisplay() )
end

---@param extraDelay integer|nil
---@return nil
function Feedback:EndDisplay( extraDelay )
    if self.state ~= "displaying" or not self.snapshot then
        return
    end

    self.state = "waiting_recurrence"
    self.remainingMs = FeedbackTime.ToMilliseconds(
        QUALITY_FEEDBACK_CONFIG.timing.recurrenceByState[self.snapshot.qualityState]
    ) + ( extraDelay or 0 )
    self:SetVisible( false )
end

---@return nil
function Feedback:Dismiss()
    self:EndDisplay( FeedbackTime.RandomMilliseconds(
        QUALITY_FEEDBACK_CONFIG.timing.postActionDelayMin,
        QUALITY_FEEDBACK_CONFIG.timing.postActionDelayMax
    ) )
end

---@return nil
function Feedback:RequestRefresh()
    self.state = "refreshing"
    self.remainingMs = 0
    TriggerServerEvent( "hud:gamifiedFeedback:requestRefresh" )
end

---@param name string
---@param active boolean
---@return nil
function Feedback:SetPriority( name, active )
    self.priorities[name] = active == true

    if self.state == "displaying" then
        self:SetVisible( self:CanDisplay() )
    end
end

---@param snapshot unknown
---@param startsTimer boolean
---@return nil
function Feedback:Sync( snapshot, startsTimer )
    if type( snapshot ) ~= "table" or type( snapshot.qualityState ) ~= "string" then
        -- sx.logger:warn( "hud gamified feedback ignored an invalid snapshot" )
        return
    end

    ---@cast snapshot GamifiedFeedbackSnapshot
    self.snapshot = snapshot
    self:StartTimer()

    if startsTimer == true then
        self.state = "waiting_first"
        self.remainingMs = FeedbackTime.ToMilliseconds( QUALITY_FEEDBACK_CONFIG.timing.initialDelay )
    elseif self.state == "refreshing" then
        self:BeginDisplay()
    end
end

---@param startsTimer boolean
---@param retryDelay string
---@return nil
function Feedback:Unavailable( startsTimer, retryDelay )
    if startsTimer ~= true and self.state ~= "refreshing" then
        return
    end

    self:StartTimer()
    self.state = self.snapshot and "waiting_recurrence" or "waiting_first"
    self.remainingMs = FeedbackTime.ToMilliseconds( retryDelay )
end

---@return nil
function Feedback:Update()
    local now = GetGameTimer()
    local elapsedMs = math.max( 0, now - self.lastTickAt )
    self.lastTickAt = now

    if self.state == "disabled" or self.state == "refreshing" then
        return
    end

    if not self:CanDisplay() then
        self:SetVisible( false )
        return
    end

    if self.state == "displaying" then
        self:SetVisible( true )
    end

    self.remainingMs = math.max( 0, self.remainingMs - elapsedMs )

    if self.remainingMs > 0 then
        return
    end

    if self.state == "displaying" then
        self:EndDisplay()
    else
        self:RequestRefresh()
    end
end

local feedback = Feedback.New()

-- Ponte pra outros modulos do slot principal (ex.: recruitment_punishment/nui.lua) silenciarem o
-- aviso de qualidade sem precisar conhecer o `Feedback` inteiro -- `feedback` acima e local a este
-- arquivo de proposito.
---@param name string
---@param active boolean
---@return nil
function FeedbackClient.SetPriority( name, active )
    feedback:SetPriority( name, active )
end

---@return nil
function FeedbackClient.Register()
    AddEventHandler( 'hud:toxicity:priorityChanged', function( active )
        feedback:SetPriority( 'toxicity', active )
    end )
    AddEventHandler( "hud:gamifiedFeedback:dismiss", function()
        feedback:Dismiss()
    end )

    AddEventHandler( "hud:missions:nearbyPriorityChanged", function( active )
        feedback:SetPriority( "nearbyMission", active )
    end )

    AddEventHandler( "hud:orgRanking:visibilityChanged", function( active )
        feedback:SetPriority( "organizationRanking", active )
    end )

    RegisterNetEvent( "hud:gamifiedFeedback:sync", function( snapshot, startsTimer )
        feedback:Sync( snapshot, startsTimer )
    end )

    RegisterNetEvent( "hud:gamifiedFeedback:unavailable", function( startsTimer, retryDelay )
        feedback:Unavailable( startsTimer, retryDelay )
    end )

    RegisterNetEvent( "hud:gamifiedFeedback:clear", function()
        feedback:Disable()
    end )

    AddEventHandler( "onResourceStop", function( resourceName )
        if resourceName == GetCurrentResourceName() then
            feedback:Disable()
        end
    end )
end
