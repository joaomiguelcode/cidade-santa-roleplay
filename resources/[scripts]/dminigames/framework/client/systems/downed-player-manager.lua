---@class MatchDownedStateConfig
---@field animationDict? string
---@field animationName? string
---@field invincibilityPriority? integer
---@field collision? boolean

---@class DownedPlayerManager
---@field minigameName string
---@field animationDict string
---@field animationName string
---@field invincibilityPriority integer
---@field invincibilityOwner string
---@field collisionEnabled boolean
---@field active boolean
---@field revision integer
---@field presentedRevision integer
---@field nextAnimationCheckAt integer
DownedPlayerManager = class()

local DOWNED_PED_BASE_HEALTH = 100
local DOWNED_PLAYER_CONTROL_FLAGS = 0
local DOWNED_DEFAULT_ANIMATION_DICT = 'misstrevor3_beatup'
local DOWNED_DEFAULT_ANIMATION_NAME = 'guard_beatup_exit_dockworker'
local DOWNED_DEFAULT_INVINCIBILITY_PRIORITY = 80
local DOWNED_ANIMATION_REFRESH_MS = 750
local DOWNED_BLOCKED_CONTROLS = {
    21, -- sprint
    22, -- jump
    24, -- attack
    25, -- aim
    30, -- move left/right
    31, -- move forward/backward
    37, -- weapon wheel
    44, -- cover
}

local gDownedPlayerManagers = {}

---@param minigameName string
---@param config? MatchDownedStateConfig
function DownedPlayerManager:__init( minigameName, config )
    config = type( config ) == 'table' and config or {}

    self.minigameName = minigameName
    self.animationDict = config.animationDict or DOWNED_DEFAULT_ANIMATION_DICT
    self.animationName = config.animationName or DOWNED_DEFAULT_ANIMATION_NAME
    self.invincibilityPriority = tonumber( config.invincibilityPriority )
        or DOWNED_DEFAULT_INVINCIBILITY_PRIORITY
    self.invincibilityOwner = ( 'minigame_%s_downed' ):format( minigameName )
    self.collisionEnabled = config.collision ~= false
    self.active = false
    self.revision = 0
    self.presentedRevision = 0
    self.nextAnimationCheckAt = 0

    gDownedPlayerManagers[ self ] = true
end

---@private
---@return boolean loaded
function DownedPlayerManager:requestAnimation()
    if HasAnimDictLoaded( self.animationDict ) then
        return true
    end

    RequestAnimDict( self.animationDict )

    local timeoutAt = GetGameTimer() + 500

    while not HasAnimDictLoaded( self.animationDict )
        and GetGameTimer() < timeoutAt
    do
        Wait( 0 )
    end

    return HasAnimDictLoaded( self.animationDict )
end

---@private
---@param ped integer
function DownedPlayerManager:playAnimation( ped )
    if not DoesEntityExist( ped )
        or IsEntityPlayingAnim( ped, self.animationDict, self.animationName, 3 )
        or not self:requestAnimation()
    then
        return
    end

    TaskPlayAnim(
        ped,
        self.animationDict,
        self.animationName,
        8.0,
        -8.0,
        -1,
        1,
        0.0,
        false,
        false,
        false
    )
end

---@private
---@param revision integer
function DownedPlayerManager:applyPose( revision )
    if not self.active or revision ~= self.revision then
        return
    end

    local ped = PlayerPedId()

    if not DoesEntityExist( ped ) then
        return
    end

    local position = GetEntityCoords( ped )
    local heading = GetEntityHeading( ped )

    if IsEntityDead( ped )
        or IsPedDeadOrDying( ped, true )
        or GetEntityHealth( ped ) < DOWNED_PED_BASE_HEALTH
    then
        NetworkResurrectLocalPlayer(
            position.x,
            position.y,
            position.z,
            heading
        )
        Wait( 0 )
        ped = PlayerPedId()
    end

    if not self.active
        or revision ~= self.revision
        or not DoesEntityExist( ped )
    then
        return
    end

    -- Preserva a posição pós-ressurreição, sem reaplicar o Z anterior do ragdoll.
    SetEntityHeading( ped, heading )

    local stateManager = PlayerStateManager:getInstance()
    stateManager:setInvincibility(
        true,
        self.invincibilityOwner,
        self.invincibilityPriority,
        nil,
        false
    )

    SetEntityHealth( ped, DOWNED_PED_BASE_HEALTH )
    SetEntityCanBeDamaged( ped, false )
    SetEntityProofs( ped, true, true, true, true, true, true, true, true )
    LocalPlayer.state.Invincible = true
    SetEntityVisible( ped, true, false )
    ResetEntityAlpha( ped )
    SetEntityCollision( ped, self.collisionEnabled, self.collisionEnabled )
    SetPedCanRagdoll( ped, false )
    SetPedCanRagdollFromPlayerImpact( ped, false )
    SetPedCanSwitchWeapon( ped, false )
    SetCanPedEquipAllWeapons( ped, false )
    ClearPedTasksImmediately( ped )
    FreezeEntityPosition( ped, true )
    SetNuiFocus( false, false )

    if type( SetNuiFocusKeepInput ) == 'function' then
        SetNuiFocusKeepInput( false )
    end

    -- A partir daqui uma UI do modo pode pedir foco sem ser derrubada pela pose.
    self.presentedRevision = revision
    SetPlayerControl( PlayerId(), true, DOWNED_PLAYER_CONTROL_FLAGS )
    self:playAnimation( ped )
    self.nextAnimationCheckAt = GetGameTimer() + DOWNED_ANIMATION_REFRESH_MS
end

---@private
function DownedPlayerManager:maintainPose()
    local ped = PlayerPedId()

    if DoesEntityExist( ped ) then
        SetEntityInvincible( ped, true )
        SetEntityCanBeDamaged( ped, false )
        SetEntityProofs( ped, true, true, true, true, true, true, true, true )
        SetEntityCollision( ped, self.collisionEnabled, self.collisionEnabled )
        SetEntityVisible( ped, true, false )
        ResetEntityAlpha( ped )
        SetPlayerControl( PlayerId(), true, DOWNED_PLAYER_CONTROL_FLAGS )

        if not IsEntityDead( ped ) and not IsPedDeadOrDying( ped, true ) then
            FreezeEntityPosition( ped, true )
        end

        DisablePlayerFiring( PlayerId(), true )

        if GetGameTimer() >= self.nextAnimationCheckAt then
            self:playAnimation( ped )
            self.nextAnimationCheckAt = GetGameTimer()
                + DOWNED_ANIMATION_REFRESH_MS
        end
    end

    for _, control in ipairs( DOWNED_BLOCKED_CONTROLS ) do
        DisableControlAction( 0, control, true )
    end
end

function DownedPlayerManager:enter()
    if self.active then
        return
    end

    self.active = true
    self.revision = self.revision + 1

    local revision = self.revision

    CreateThread( function()
        Wait( 0 )

        if not self.active or revision ~= self.revision then
            return
        end

        self:applyPose( revision )

        while self.active and revision == self.revision do
            self:maintainPose()
            Wait( 0 )
        end
    end )
end

---A pose abatida ja foi aplicada, e com ela o `SetNuiFocus( false, false )`.
---@return boolean presented
function DownedPlayerManager:isPresented()
    return self.active and self.presentedRevision == self.revision
end

function DownedPlayerManager:exit()
    if not self.active then
        return
    end

    self.active = false
    self.revision = self.revision + 1

    local ped = PlayerPedId()
    local stateManager = PlayerStateManager:getInstance()

    if stateManager.invincibilityOwner == self.invincibilityOwner then
        stateManager:setInvincibility(
            false,
            self.invincibilityOwner,
            self.invincibilityPriority
        )
    elseif not stateManager.invincibilityOwner then
        SetEntityInvincible( ped, false )
        LocalPlayer.state.Invincible = false
    end

    if not DoesEntityExist( ped ) then
        return
    end

    local position = GetEntityCoords( ped )
    local heading = GetEntityHeading( ped )

    if IsEntityDead( ped ) or IsPedDeadOrDying( ped, true ) then
        NetworkResurrectLocalPlayer(
            position.x,
            position.y,
            position.z,
            heading
        )
        Wait( 0 )
        ped = PlayerPedId()
    end

    if not DoesEntityExist( ped ) then
        return
    end

    if GetEntityHealth( ped ) <= DOWNED_PED_BASE_HEALTH then
        SetEntityHealth( ped, DOWNED_PED_BASE_HEALTH + 1 )
    end

    FreezeEntityPosition( ped, false )
    SetEntityCanBeDamaged( ped, true )
    SetEntityProofs( ped, false, false, false, false, false, false, false, false )
    SetEntityVisible( ped, true, false )
    ResetEntityAlpha( ped )
    SetEntityCollision( ped, true, true )
    SetPedCanRagdoll( ped, true )
    SetPedCanRagdollFromPlayerImpact( ped, true )
    SetPedCanSwitchWeapon( ped, true )
    SetCanPedEquipAllWeapons( ped, true )
    ClearPedTasksImmediately( ped )
    ClearPedSecondaryTask( ped )
    SetPlayerControl( PlayerId(), true, DOWNED_PLAYER_CONTROL_FLAGS )
end

---@return boolean active
function DownedPlayerManager:isActive()
    return self.active
end

function DownedPlayerManager:cleanup()
    self:exit()
    gDownedPlayerManagers[ self ] = nil
end

AddEventHandler( 'onResourceStop', function( resourceName )
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    for manager in pairs( gDownedPlayerManagers ) do
        manager:cleanup()
    end
end )
