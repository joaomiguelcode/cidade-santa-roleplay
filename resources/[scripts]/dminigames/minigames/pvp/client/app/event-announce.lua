---@class PvpEventAnnouncementPayload
---@field title string
---@field sender string
---@field description string
---@field keyPrompt string
---@field keyLabel string
---@field imageSrc string
---@field bgColor string
---@field duration number

---@class PvpVisibleEventAnnouncement
---@field owner string
---@field expiresAt number
---@field onAccept? fun()

local gPressIntervalMs = 1000
local gNextPressAt = 0
local gDeathStatueInviteOpen = false
---@type PvpVisibleEventAnnouncement?
local gVisibleAnnouncement

PvpEventAnnounce = {}

---@return boolean
local function CanUseAnnouncement()

    if gDeathStatueInviteOpen or LocalPlayer.state[ 'minigame:active' ] then
        return false
    end

    if GetResourceState( 'new_hub' ) == 'started' and exports.new_hub:IsAffiliateWorldClientActive() then
        return false
    end

    if GetResourceState( 'hud' ) == 'started' and exports.hud:IsNewbieAnnounceBlocked() then
        return false
    end

    return true
end

local function ClearAnnouncement()

    local announcement = gVisibleAnnouncement
    gVisibleAnnouncement = nil

    if announcement and GetGameTimer() < announcement.expiresAt then
        TriggerEvent( 'pvp.hud:closeEventAnnounce' )
    end
end

---@param owner string
---@param payload PvpEventAnnouncementPayload
---@param onAccept? fun()
---@return boolean shown
function PvpEventAnnounce.Show( owner, payload, onAccept )

    assert( type( owner ) == 'string' and owner ~= '', 'Expected announcement owner' )
    assert( onAccept == nil or type( onAccept ) == 'function', 'Expected announcement callback' )

    if type( payload ) ~= 'table' then
        return false
    end

    local duration = payload.duration

    if type( duration ) ~= 'number' or duration <= 0 or duration >= math.huge or duration ~= duration
        or not CanUseAnnouncement()
    then
        return false
    end

    -- A HUD empilha anuncios. Substituir o anterior mantem um unico convite PVP.
    ClearAnnouncement()
    gVisibleAnnouncement = { owner = owner, expiresAt = GetGameTimer() + duration, onAccept = onAccept }
    TriggerEvent( 'pvp.hud:showEventAnnounce', payload )
    TriggerEvent( 'sounds:Private', 'recrutamento', 0.09 )
    return true
end

---@param owner string
---@return boolean accepted
function PvpEventAnnounce.Accept( owner )

    local announcement = gVisibleAnnouncement
    local now = GetGameTimer()

    if not announcement or announcement.owner ~= owner then
        return false
    end

    if now >= announcement.expiresAt or not CanUseAnnouncement() then
        ClearAnnouncement()
        return false
    end

    if not announcement.onAccept or now < gNextPressAt then
        return false
    end

    -- Uma recusa no servidor permite tentar novamente enquanto o card esta visivel.
    gNextPressAt = now + gPressIntervalMs
    announcement.onAccept()
    return true
end

---@param owner string
---@return boolean closed
function PvpEventAnnounce.Close( owner )

    if not gVisibleAnnouncement or gVisibleAnnouncement.owner ~= owner then
        return false
    end

    ClearAnnouncement()
    return true
end

AddEventHandler( 'hud:deathstatueInviteOpen', function( open )

    gDeathStatueInviteOpen = open == true

    if gDeathStatueInviteOpen then
        ClearAnnouncement()
    end
end )

AddStateBagChangeHandler(
    'minigame:active',
    ( 'player:%d' ):format( GetPlayerServerId( PlayerId() ) ),
    function( _, _, value )

        if value then
            ClearAnnouncement()
        end
    end
)

AddEventHandler( 'onClientResourceStop', function( resourceName )

    if resourceName == GetCurrentResourceName() then
        ClearAnnouncement()
    end
end )
