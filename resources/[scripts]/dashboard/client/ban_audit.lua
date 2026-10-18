---@class BanAuditAcessoRestritoPayload
---@field supportUrl  string
---@field statusLabel string
---@field passport    number
---@field accountId   number
---@field banId       number
---@field city        string
---@field phase       BanAuditOverlayPhase
---@field ticketUrl?   string
---@field reason?     string
---@field name?       string
---@field discordId?  string

local gStaffModalOpen = false

RegisterKeyMapping( 'banAuditOpenTicket', 'Ban Audit - Open Support Ticket', 'keyboard', 'G' )

RegisterCommand( 'banAuditOpenTicket', function()

    SendNUIMessage({ 
        action = 'banAuditOpenTicket' 
    })
end)

---@param enable boolean
---@param withCursor? boolean
local function SetBanAuditNuiFocus( enable, withCursor )

    SetNuiFocus( enable, withCursor == nil and enable or withCursor )
end

---@param phase? BanAuditOverlayPhase
---@return boolean
local function ShouldFocusAcessoRestrito( phase )

    return phase == nil or phase == 'awaiting_email'
end

---@param variant? string
---@return boolean
local function ShouldFocusStatusProvas( variant )

    return variant == 'restabelecido'
end

---@param active boolean
local function SetBanAuditMovementLocked( active )

    FreezeEntityPosition( PlayerPedId(), active == true )
end

---@param needsInteractionLock boolean
local function ApplyBanAuditInteractionLock( needsInteractionLock )

    SetBanAuditNuiFocus( needsInteractionLock, needsInteractionLock )
    SetBanAuditMovementLocked( needsInteractionLock )
end

---@param data? BanAuditAcessoRestritoPayload
local function OpenBanAuditAcessoRestrito( data )

    local phase = type( data ) == 'table' and data.phase or 'awaiting_email'
    local needsInteractionLock = ShouldFocusAcessoRestrito( phase )

    ApplyBanAuditInteractionLock( needsInteractionLock )

    SendNUIMessage({
        action = 'banShowAcessoRestrito',
        data   = data
    })
end

---@param data table
local function OpenBanAuditStatusProvas( data )

    local variant = type( data ) == 'table' and data.variant or nil
    local needsInteractionLock = ShouldFocusStatusProvas( variant )

    ApplyBanAuditInteractionLock( needsInteractionLock )

    SendNUIMessage({
        action = 'banShowStatusProvas',
        data   = data,
    })
end

---@param data table
local function OpenBanAuditStaffModal( data )

    gStaffModalOpen = true
    SetBanAuditNuiFocus( true, true )

    SendNUIMessage({
        action = 'banShowModalStaff',
        data   = data,
    })
end

local function CloseBanAuditScreen()

    SetBanAuditNuiFocus( false, false )
    SendNUIMessage({ action = 'banHide' })
    gStaffModalOpen = false
end

---@param message? string
local function NotifyStaffBanAuditError( message )

    CloseBanAuditScreen()

    if type( message ) ~= 'string' or message == '' then
        return
    end

    TriggerEvent( 'Notify2', '#vipMessage', { msg = message } )
end

RegisterNetEvent( 'ban_audit:setRestricted', function( active )
    SetBanAuditMovementLocked( active )
end)

RegisterNetEvent( 'ban_audit:showAcessoRestrito', function( data )
    OpenBanAuditAcessoRestrito( data )
end)

RegisterNetEvent( 'ban_audit:showStatusProvas', function( data )
    OpenBanAuditStatusProvas( data )
end)

RegisterNetEvent( 'ban_audit:hide', function()
    CloseBanAuditScreen()
    SetBanAuditMovementLocked( false )
end)

RegisterNetEvent( 'ban_audit:setOverlayPhase', function( phase, extra )

    SendNUIMessage({
        action = 'banSetOverlayPhase',
        data   = {
            phase     = phase,
            ticketUrl = type( extra ) == 'table' and extra.ticketUrl or nil,
            email     = type( extra ) == 'table' and extra.email or nil,
        },
    })

    if phase == 'awaiting_email' or phase == 'awaiting_auth' then
        ApplyBanAuditInteractionLock( true )
    end
end)

RegisterNetEvent( 'ban_audit:openStaffModal', function( defaultPlayerId )

    local payload = lib.callback.await( 'ban_audit:getStaffModalConfig', false, defaultPlayerId )

    if type( payload ) == 'table' and payload.ok == false then
        NotifyStaffBanAuditError( payload.message )
        return
    end

    if not payload or not payload.reasons then
        return
    end

    OpenBanAuditStaffModal( payload )
end)

RegisterNuiCallback( 'banAudit:submitEmail', function( data, cb )

    local email = type( data ) == 'table' and data.email or ''
    local ok, errCode, ticketUrl = lib.callback.await( 'ban_audit:submitEmail', false, email )

    cb({
        ok        = ok == true,
        error     = ok and nil or ( errCode or 'BAN_CLAIM_FAILED' ),
        ticketUrl = ok and ticketUrl or nil,
    })
end)

RegisterNuiCallback( 'banAudit:changeEmail', function( _, cb )

    ApplyBanAuditInteractionLock( true )
    TriggerServerEvent( 'ban_audit:changeEmail' )
    cb({ ok = true })
end)

RegisterNuiCallback( 'submitBan', function( data, cb )

    CreateThread( function()

        local ok, result = pcall( function()
            return lib.callback.await( 'ban_audit:submitBan', false, data )
        end)

        if not ok then
            -- sx.logger:error( ('ban_audit: submitBan client callback failed: %s'):format( tostring( result ) ) )
            cb({ ok = false, error = 'INTERNAL' })
            return
        end

        if result and result.ok then
            CloseBanAuditScreen()
        elseif type( result ) == 'table' and result.message then
            NotifyStaffBanAuditError( result.message )
        end

        cb( result or { ok = false, error = 'INTERNAL' } )
    end)
end)

RegisterNetEvent( 'ban_audit:closeStaffModal', function( message )

    if gStaffModalOpen then
        CloseBanAuditScreen()
    end

    if type( message ) == 'string' and message ~= '' then
        TriggerEvent( 'Notify2', '#vipMessage', { msg = message } )
    end
end)

AddEventHandler( 'onClientResourceStart', function( resourceName )

    if resourceName ~= GetCurrentResourceName() then
        return
    end

    TriggerServerEvent( 'ban_audit:requestResume' )
end)

RegisterNetEvent( 'spawn:Finish', function()
    SetTimeout( 1000, function()
        TriggerServerEvent( 'ban_audit:requestResume' )
    end)
end)

AddEventHandler( 'new_spawn:selectionClosed', function()
    TriggerServerEvent( 'ban_audit:requestResume' )
end)

RegisterNuiCallback( 'closeUI', function( _, cb )

    if GetInvokingResource() == nil then
        if TelagemHandleCloseUi and TelagemHandleCloseUi() then
            cb({ ok = true })
            return
        end

        local wasStaffModal = gStaffModalOpen

        CloseBanAuditScreen()

        if wasStaffModal then
            TriggerServerEvent( 'ban_audit:staffModalClosed' )
        else
            TriggerServerEvent( 'ban_audit:sessionEnded' )
        end
    end

    cb({ ok = true })
end)

exports( 'OpenBanAuditAcessoRestrito', OpenBanAuditAcessoRestrito )

exports( 'OpenBanAuditStatusProvas', OpenBanAuditStatusProvas )

exports( 'OpenBanAuditStaffModal', OpenBanAuditStaffModal )

exports( 'CloseBanAuditScreen', CloseBanAuditScreen )

---@return boolean blocked
exports( 'BlockIfInRestrictWorld', function()

    if LocalPlayer.state.banAuditRestricted ~= true then
        return false
    end

    TriggerEvent( 'Notify2', '#noPermission' )
    return true
end)

---@return boolean
exports( 'IsLocalRestricted', function()
    return LocalPlayer.state.banAuditRestricted == true
end)
