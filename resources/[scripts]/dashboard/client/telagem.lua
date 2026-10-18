local gTelagemStaffModalOpen = false
local gTelagemPlayerScreenOpen = false

---@param enable boolean
local function SetTelagemInteractionLock( enable )

    SetNuiFocus( enable, enable )
    FreezeEntityPosition( PlayerPedId(), enable )
end

---@param data table
local function OpenTelagemStaffModal( data )

    gTelagemStaffModalOpen = true
    SetNuiFocus( true, true )

    SendNUIMessage({
        action = 'telagemShowModalStaff',
        data   = data,
    })
end

---@param data table
local function OpenTelagemPlayerScreen( data )

    gTelagemPlayerScreenOpen = true
    SetTelagemInteractionLock( true )

    SendNUIMessage({
        action = 'telagemShowRevisaoSolicitada',
        data   = data,
    })
end

---@param data table
local function OpenTelagemSecureQuitScreen( data )

    gTelagemPlayerScreenOpen = true
    SetTelagemInteractionLock( true )

    SendNUIMessage({
        action = 'telagemShowSecureQuit',
        data   = data,
    })
end

local function CloseTelagemScreen()

    local wasPlayerScreenOpen = gTelagemPlayerScreenOpen

    gTelagemStaffModalOpen = false
    gTelagemPlayerScreenOpen = false
    SetNuiFocus( false, false )

    if wasPlayerScreenOpen then
        FreezeEntityPosition( PlayerPedId(), false )
    end

    SendNUIMessage({ action = 'telagemHide' })
end

local function HandoffTelagemToBanAudit()

    gTelagemStaffModalOpen = false
    gTelagemPlayerScreenOpen = false
    SetTelagemInteractionLock( false )
end

---@return boolean handled
function TelagemHandleCloseUi()

    if gTelagemPlayerScreenOpen then
        return true
    end

    if not gTelagemStaffModalOpen then
        return false
    end

    CloseTelagemScreen()
    TriggerServerEvent( 'telagem:staffModalClosed' )

    return true
end

RegisterNetEvent( 'telagem:openStaffModal', function( defaultPlayerId )

    local payload = lib.callback.await( 'telagem:getStaffModalConfig', false, defaultPlayerId )

    if type( payload ) ~= 'table' or payload.ok == false then
        local message = type( payload ) == 'table' and payload.message or _t( 'telagem.error.open_failed' )

        TriggerEvent( 'Notify2', '#vipMessage', { msg = message } )
        return
    end

    OpenTelagemStaffModal( payload )
end)

RegisterNetEvent( 'telagem:showRevisaoSolicitada', function( data )
    OpenTelagemPlayerScreen( data or {} )
end)

RegisterNetEvent( 'telagem:showSecureQuit', function( data )
    OpenTelagemSecureQuitScreen( data or {} )
end)

RegisterNetEvent( 'telagem:hide', function()
    CloseTelagemScreen()
end)

RegisterNetEvent( 'telagem:handoffToBanAudit', function()
    HandoffTelagemToBanAudit()
end)

RegisterNetEvent( 'spawn:Finish', function()
    SetTimeout( 1000, function()
        TriggerServerEvent( 'telagem:requestResume' )
    end)
end)

AddEventHandler( 'new_spawn:selectionClosed', function()

    if gTelagemPlayerScreenOpen then
        SetTelagemInteractionLock( true )
    end

    TriggerServerEvent( 'telagem:requestResume' )
end)

RegisterNuiCallback( 'submitTelagem', function( data, cb )
    local ok, result = pcall( function()
        return lib.callback.await( 'telagem:submit', false, data )
    end)

    if not ok then
        sx.logger:error( ('telagem: submit callback failed err=%s'):format( tostring( result ) ) )
        cb({ ok = false, error = 'INTERNAL' })
        return
    end

    if type( result ) == 'table' and result.message then
        TriggerEvent( 'Notify2', '#vipMessage', { msg = result.message } )
    end

    cb( result or { ok = false, error = 'INTERNAL' } )
end)

RegisterNuiCallback( 'telagem:goToCall', function( _, cb )
    cb({ ok = true })
end)

AddEventHandler( 'onResourceStop', function( resourceName )

    if resourceName == GetCurrentResourceName() and gTelagemPlayerScreenOpen then
        FreezeEntityPosition( PlayerPedId(), false )
    end
end)

exports( 'CloseTelagemScreen', CloseTelagemScreen )
