---@class RoyaleReviveClientOptions
---@field isAlive fun(): boolean

---@class RoyaleReviveClient
---@field isAlive fun(): boolean
---@field matchId any?
---@field active boolean
---@field suspended boolean
---@field revision integer
---@field eligibleBySource table<integer, boolean>
---@field eligibleCount integer
RoyaleReviveClient = class()

local ROYALE_REVIVE_CONTROL = 38
local ROYALE_REVIVE_SCAN_INTERVAL_MS = 150
local ROYALE_REVIVE_ACTIVE_SCAN_MIN_TARGETS = 8
local ROYALE_REVIVE_DISTANCE = 2.75
local ROYALE_REVIVE_DISTANCE_SQUARED = ROYALE_REVIVE_DISTANCE * ROYALE_REVIVE_DISTANCE
local ROYALE_REVIVE_DEFAULT_DURATION_MS = 3200
local ROYALE_REVIVE_ANIM_DICT = 'mini@cpr@char_a@cpr_str'
local ROYALE_REVIVE_ANIM_NAME = 'cpr_pumpchest'
local ROYALE_REVIVE_ANIM_TIMEOUT_MS = 3000
local ROYALE_REVIVE_COMPLETE_DISPLAY_MS = 650

---@param options RoyaleReviveClientOptions
function RoyaleReviveClient:__init( options )

    self.isAlive = type( options ) == 'table' and type( options.isAlive ) == 'function'
        and options.isAlive or function() return false end
    self.active = false
    self.suspended = false
    self.revision = 0
    self.loopRevision = 0
    self.loopRunning = false
    self.animationRevision = 0
    self.completionRevision = 0
    self.eligibleBySource = {}
    self.eligibleCount = 0
    self.renderer = DominationCapturePointRenderer( {
        textureDictionaryPrefix = 'royale_revive_point',
        textureName = 'revive_point',
        textureSize = 512,
        drawDistance = ROYALE_REVIVE_DISTANCE,
    } )
end

---@param value any
---@return integer?
local function PositiveInteger( value )

    value = tonumber( value )
    if not value or value < 1 or value % 1 ~= 0 then return end
    return value
end

---@param player integer
---@return integer? ped
local function GetValidPlayerPed( player )

    if player == -1 then return end

    local ped = GetPlayerPed( player )
    if not ped or ped == 0 or not DoesEntityExist( ped ) then return end
    return ped
end

---@param source integer
---@return integer? ped
local function GetTargetPed( source )

    return GetValidPlayerPed( GetPlayerFromServerId( source ) )
end

---@param first table
---@param second table
---@return number
local function DistanceSquared( first, second )

    local dx, dy, dz = first.x - second.x, first.y - second.y, first.z - second.z
    return dx * dx + dy * dy + dz * dz
end

---@param localCoords table
---@param targetPed integer?
---@return number?
local function GetTargetDistanceSquared( localCoords, targetPed )

    if not targetPed then return end

    local distance = DistanceSquared( localCoords, GetEntityCoords( targetPed ) )
    if distance > ROYALE_REVIVE_DISTANCE_SQUARED then return end

    return distance
end

---@return boolean
function RoyaleReviveClient:IsInteractionContextValid()

    if not self.active or self.suspended or not self.isAlive() then return false end

    local ped = PlayerPedId()
    return ped ~= 0
        and DoesEntityExist( ped )
        and not IsEntityDead( ped )
        and not IsPedDeadOrDying( ped, true )
        and GetEntityHealth( ped ) > 100
        and GetVehiclePedIsIn( ped, false ) == 0
end

---@param source any
---@return integer? targetPed
function RoyaleReviveClient:GetTargetInRange( source )

    source = PositiveInteger( source )
    if not source or not self.eligibleBySource[ source ] then return end

    local localServerId = GetPlayerServerId( PlayerId() )
    if source == localServerId then return end

    local targetPed = GetTargetPed( source )
    if not targetPed then return end

    local localPed = PlayerPedId()
    if localPed == 0 or not DoesEntityExist( localPed ) then return end

    if DistanceSquared( GetEntityCoords( localPed ), GetEntityCoords( targetPed ) )
        > ROYALE_REVIVE_DISTANCE_SQUARED then
        return
    end

    return targetPed
end

---@param source integer?
---@param targetPed integer?
function RoyaleReviveClient:SetCandidate( source, targetPed )

    source = PositiveInteger( source )
    if not source or not targetPed then
        self.candidateSource = nil
        if not self.requestTargetSource and not self.attemptId and not self.completionPending then
            self.renderer:hide()
        end
        return
    end

    self.candidateSource = source
    self.renderer:setReviveTarget( { mode = 'revive', source = source, entity = targetPed } )
    if not self.requestTargetSource and not self.attemptId and not self.completionPending then
        self.renderer:setReviveState( 'idle' )
    end
    self.renderer:show()
end

---@param source integer?
---@return integer? targetSource
---@return integer? targetPed
function RoyaleReviveClient:FindNearestTarget()

    local nearestSource, nearestPed, nearestDistance
    local localPed = PlayerPedId()
    if localPed == 0 or not DoesEntityExist( localPed ) then return end
    local localCoords = GetEntityCoords( localPed )
    local localServerId = GetPlayerServerId( PlayerId() )

    if self.eligibleCount > ROYALE_REVIVE_ACTIVE_SCAN_MIN_TARGETS then
        local activePlayers = GetActivePlayers()
        if #activePlayers < self.eligibleCount then
            for _, player in ipairs( activePlayers ) do
                local targetSource = GetPlayerServerId( player )
                if targetSource ~= localServerId and self.eligibleBySource[ targetSource ] then
                    local targetPed = GetValidPlayerPed( player )
                    local distance = GetTargetDistanceSquared( localCoords, targetPed )
                    if distance and ( not nearestDistance or distance < nearestDistance ) then
                        nearestSource, nearestPed, nearestDistance = targetSource, targetPed, distance
                    end
                end
            end
            return nearestSource, nearestPed
        end
    end

    for targetSource in pairs( self.eligibleBySource ) do
        if targetSource ~= localServerId then
            local targetPed = GetTargetPed( targetSource )
            local distance = GetTargetDistanceSquared( localCoords, targetPed )
            if distance and ( not nearestDistance or distance < nearestDistance ) then
                nearestSource, nearestPed, nearestDistance = targetSource, targetPed, distance
            end
        end
    end

    return nearestSource, nearestPed
end

---@param notifyServer boolean
function RoyaleReviveClient:CancelAttempt( notifyServer )

    local attemptId, targetSource = self.attemptId, self.attemptTargetSource or self.requestTargetSource
    self:StopAnimation()
    self.requestTargetSource = nil
    self.requestReleased = false
    self.attemptId = nil
    self.attemptTargetSource = nil
    self.attemptFinishAt = nil
    self.completionPending = false

    if notifyServer and targetSource then
        TriggerServerEvent( 'pvp.royale:cancelRevive', self.matchId, attemptId or 0, targetSource )
    end

    local candidatePed = self.candidateSource and self:GetTargetInRange( self.candidateSource )
    if candidatePed then
        self.renderer:setReviveState( 'idle' )
    else
        self:SetCandidate( nil, nil )
    end
end

function RoyaleReviveClient:StopAnimation()

    self.animationRevision = self.animationRevision + 1
    local ped = self.animationPed
    self.animationPed = nil

    if ped and DoesEntityExist( ped ) and IsEntityPlayingAnim(
        ped, ROYALE_REVIVE_ANIM_DICT, ROYALE_REVIVE_ANIM_NAME, 3
    ) then
        StopAnimTask( ped, ROYALE_REVIVE_ANIM_DICT, ROYALE_REVIVE_ANIM_NAME, 1.0 )
    end

    if HasAnimDictLoaded( ROYALE_REVIVE_ANIM_DICT ) then
        RemoveAnimDict( ROYALE_REVIVE_ANIM_DICT )
    end
end

function RoyaleReviveClient:StartAnimation()

    self:StopAnimation()
    local revision = self.animationRevision
    local sessionRevision = self.revision

    CreateThread( function()
        local timeoutAt = GetGameTimer() + ROYALE_REVIVE_ANIM_TIMEOUT_MS
        RequestAnimDict( ROYALE_REVIVE_ANIM_DICT )

        while self.active and self.revision == sessionRevision
            and self.animationRevision == revision and self.attemptId
            and not HasAnimDictLoaded( ROYALE_REVIVE_ANIM_DICT )
            and GetGameTimer() < timeoutAt do
            Wait( 0 )
        end

        if not self.active or self.revision ~= sessionRevision
            or self.animationRevision ~= revision or not self.attemptId
            or not HasAnimDictLoaded( ROYALE_REVIVE_ANIM_DICT ) then return end

        local ped = PlayerPedId()
        if ped == 0 or not DoesEntityExist( ped ) or not self:IsInteractionContextValid() then return end

        self.animationPed = ped
        TaskPlayAnim( ped, ROYALE_REVIVE_ANIM_DICT, ROYALE_REVIVE_ANIM_NAME,
            8.0, -8.0, -1, 1, 0.0, false, false, false )
    end )
end

---@param matchId any
---@return boolean
function RoyaleReviveClient:Open( matchId )

    if matchId == nil then return false end
    self:Close()
    if self.rendererDestroyed then
        self.renderer = DominationCapturePointRenderer( {
            textureDictionaryPrefix = 'royale_revive_point',
            textureName = 'revive_point',
            textureSize = 512,
            drawDistance = ROYALE_REVIVE_DISTANCE,
        } )
        self.rendererDestroyed = false
    end
    self.matchId = matchId
    self.active = true
    self.suspended = false
    self.eligibleBySource = {}
    self.eligibleCount = 0
    self.revision = self.revision + 1
    return true
end

function RoyaleReviveClient:Close()

    self.active = false
    self.suspended = false
    self.revision = self.revision + 1
    self.loopRevision = self.loopRevision + 1
    self.loopRunning = false
    self:CancelAttempt( true )
    self.matchId = nil
    self.eligibleBySource = {}
    self.eligibleCount = 0
    self.candidateSource = nil
    self.completionRevision = self.completionRevision + 1
    if not self.rendererDestroyed then
        self.renderer:destroy()
        self.rendererDestroyed = true
    end
end

function RoyaleReviveClient:Suspend()

    if not self.active or self.suspended then return end
    self.suspended = true
    self.loopRevision = self.loopRevision + 1
    self.loopRunning = false
    self:CancelAttempt( true )
    self.renderer:hide()
end

function RoyaleReviveClient:Resume()

    if not self.active or not self.suspended then return end
    self.suspended = false
    self.revision = self.revision + 1
    self:EnsureLoop()
end

---@return boolean
function RoyaleReviveClient:HasLoopWork()

    return self.eligibleCount > 0
        or self.attemptId ~= nil
        or self.requestTargetSource ~= nil
        or self.completionPending == true
end

function RoyaleReviveClient:EnsureLoop()

    if not self.active or self.suspended or self.loopRunning or not self:HasLoopWork() then return end
    self.loopRevision = self.loopRevision + 1
    self.loopRunning = true
    self:StartLoop( self.loopRevision )
end

---@param payload table
---@return boolean
function RoyaleReviveClient:SetTargets( payload )

    if type( payload ) ~= 'table' or payload.matchId ~= self.matchId
        or type( payload.sources ) ~= 'table' then return false end

    local targets = {}
    local targetCount = 0
    for _, value in ipairs( payload.sources ) do
        local source = PositiveInteger( value )
        if source and not targets[ source ] then
            targets[ source ] = true
            targetCount = targetCount + 1
        end
    end
    self.eligibleBySource = targets
    self.eligibleCount = targetCount

    if self.requestTargetSource and not targets[ self.requestTargetSource ] then
        self:CancelAttempt( true )
    elseif self.attemptTargetSource and not targets[ self.attemptTargetSource ] then
        self:CancelAttempt( true )
    elseif self.candidateSource and not targets[ self.candidateSource ] then
        self:SetCandidate( nil, nil )
    end
    self:EnsureLoop()
    return true
end

---@param payload table
---@return boolean
function RoyaleReviveClient:SetEligibility( payload )

    if type( payload ) ~= 'table' or payload.matchId ~= self.matchId then return false end
    local source = PositiveInteger( payload.targetSource )
    if not source or type( payload.eligible ) ~= 'boolean' then return false end

    if payload.eligible and not self.eligibleBySource[ source ] then
        self.eligibleBySource[ source ] = true
        self.eligibleCount = self.eligibleCount + 1
    elseif not payload.eligible and self.eligibleBySource[ source ] then
        self.eligibleBySource[ source ] = nil
        self.eligibleCount = self.eligibleCount - 1
    end
    if not payload.eligible and ( self.requestTargetSource == source
        or self.attemptTargetSource == source ) then
        self:CancelAttempt( true )
    elseif not payload.eligible and self.candidateSource == source then
        self:SetCandidate( nil, nil )
    end
    self:EnsureLoop()
    return true
end

---@param payload table
---@return boolean
function RoyaleReviveClient:OnStarted( payload )

    if type( payload ) ~= 'table' or payload.matchId ~= self.matchId then return false end
    local attemptId, targetSource = PositiveInteger( payload.attemptId ), PositiveInteger( payload.targetSource )
    if not attemptId or not targetSource then return false end
    if attemptId == self.attemptId and targetSource == self.attemptTargetSource then return true end
    if targetSource ~= self.requestTargetSource then
        -- A resposta chegou depois do cancel local; fecha a tentativa server-side.
        TriggerServerEvent( 'pvp.royale:cancelRevive', self.matchId, attemptId, targetSource )
        return false
    end

    local durationMs = PositiveInteger( payload.durationMs ) or ROYALE_REVIVE_DEFAULT_DURATION_MS
    local targetPed = self:GetTargetInRange( targetSource )
    if self.requestReleased or not IsDisabledControlPressed( 0, ROYALE_REVIVE_CONTROL )
        or not targetPed or not self:IsInteractionContextValid() then
        TriggerServerEvent( 'pvp.royale:cancelRevive', self.matchId, attemptId, targetSource )
        self.requestTargetSource = nil
        self.requestReleased = false
        self:SetCandidate( nil, nil )
        return true
    end

    self.requestTargetSource = nil
    self.requestReleased = false
    self.attemptId = attemptId
    self.attemptTargetSource = targetSource
    self.attemptFinishAt = GetGameTimer() + durationMs
    self.completionPending = false
    self:SetCandidate( targetSource, targetPed )
    self.renderer:setReviveState( 'holding', durationMs, 0.0 )
    self:StartAnimation()
    return true
end

---@param payload table
---@return boolean
function RoyaleReviveClient:OnCancelled( payload )

    if type( payload ) ~= 'table' or payload.matchId ~= self.matchId then return false end
    local attemptId = tonumber( payload.attemptId )
    local targetSource = PositiveInteger( payload.targetSource )
    if not targetSource or not attemptId or attemptId < 0 or attemptId % 1 ~= 0 then return false end
    local expectedTarget = self.attemptTargetSource or self.requestTargetSource
    if not expectedTarget or expectedTarget ~= targetSource then return false end
    if attemptId == 0 and not self.attemptId and self.requestTargetSource == targetSource then
        self.requestTargetSource = nil
        self.requestReleased = false
        self:SetCandidate( self.candidateSource, self.candidateSource and self:GetTargetInRange( self.candidateSource ) )
        return true
    end
    if self.attemptId ~= attemptId then return false end
    self:CancelAttempt( false )
    return true
end

---@param payload table
---@return boolean
function RoyaleReviveClient:OnFinished( payload )

    if type( payload ) ~= 'table' or payload.matchId ~= self.matchId then return false end
    local attemptId, targetSource = PositiveInteger( payload.attemptId ), PositiveInteger( payload.targetSource )
    if not attemptId or attemptId ~= self.attemptId or targetSource ~= self.attemptTargetSource then return false end

    self:StopAnimation()
    self.attemptId = nil
    self.attemptTargetSource = nil
    self.attemptFinishAt = nil
    self.completionPending = true
    self.completionRevision = self.completionRevision + 1
    local revision = self.completionRevision
    self.renderer:setReviveState( 'complete', nil, 1.0 )
    SetTimeout( ROYALE_REVIVE_COMPLETE_DISPLAY_MS, function()
        if self.completionRevision ~= revision or not self.active then return end
        self.completionPending = false
        self:SetCandidate( nil, nil )
    end )
    return true
end

---@param revision integer
function RoyaleReviveClient:StartLoop( revision )

    CreateThread( function()
        local nextScanAt = 0
        while self.active and not self.suspended and self.loopRevision == revision
            and self:HasLoopWork() do
            local now = GetGameTimer()
            local contextValid = self:IsInteractionContextValid()
            if not contextValid then
                if self.attemptId or self.requestTargetSource then self:CancelAttempt( true ) end
                self:SetCandidate( nil, nil )
            end

            if contextValid and not self.attemptId and not self.requestTargetSource
                and not self.completionPending and now >= nextScanAt then
                local source, targetPed = self:FindNearestTarget()
                self:SetCandidate( source, targetPed )
                nextScanAt = now + ROYALE_REVIVE_SCAN_INTERVAL_MS
            end

            local source = self.attemptTargetSource or self.requestTargetSource or self.candidateSource
            local targetPed = contextValid and source and self:GetTargetInRange( source ) or nil
            if not targetPed and ( self.attemptId or self.requestTargetSource ) then
                self:CancelAttempt( true )
            elseif not targetPed and self.candidateSource then
                self:SetCandidate( nil, nil )
            elseif targetPed then
                self.renderer:setReviveTarget( { mode = 'revive', source = source, entity = targetPed } )
                DisableControlAction( 0, ROYALE_REVIVE_CONTROL, true )
                if self.attemptId then
                    if not IsDisabledControlPressed( 0, ROYALE_REVIVE_CONTROL ) then
                        self:CancelAttempt( true )
                    elseif not self.completionPending and self.attemptFinishAt
                        and now >= self.attemptFinishAt then
                        self.completionPending = true
                        TriggerServerEvent( 'pvp.royale:completeRevive',
                            self.matchId, self.attemptId, self.attemptTargetSource )
                    end
                elseif self.requestTargetSource then
                    if not IsDisabledControlPressed( 0, ROYALE_REVIVE_CONTROL ) then
                        self.requestReleased = true
                        self:CancelAttempt( true )
                    end
                elseif IsDisabledControlJustPressed( 0, ROYALE_REVIVE_CONTROL ) then
                    self.requestTargetSource = source
                    self.requestReleased = false
                    TriggerServerEvent( 'pvp.royale:requestRevive', self.matchId, source )
                end
            end

            if targetPed or self.attemptId or self.requestTargetSource then
                Wait( 0 )
            else
                Wait( ROYALE_REVIVE_SCAN_INTERVAL_MS )
            end
        end

        if self.loopRevision == revision then
            self.loopRunning = false
            self:CancelAttempt( false )
            self.renderer:hide()
        end
    end )
end
