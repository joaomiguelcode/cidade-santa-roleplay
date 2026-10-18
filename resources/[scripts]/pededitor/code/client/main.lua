local PED_APPLICATION_DEBOUNCE_MS = 250
local PED_APPLICATION_COOLDOWN_MS = 100
local PED_CAMERA_REFRESH_DELAY_MS = 100
local PED_SETTLE_CHECK_INTERVAL_MS = 50
local PED_SETTLE_MAX_CHECKS = 40
local PED_SETTLE_REQUIRED_STABLE_CHECKS = 2
local PED_SETTLE_VERTICAL_SPEED_EPSILON = 0.01

---@class PedApplicationRequest
---@field model string | number | nil
---@field refreshCustomization boolean
---@field onCompleted fun(success: boolean) | nil

---@type number | nil
local gOriginalPed = nil

local gShouldRestoreOriginalPed = false
local gIsSkinsMenuOpen = false
local gIsPedApplicationWorkerRunning = false

---@type PedApplicationRequest | nil
local gPendingPedApplication = nil

---@type FormattedSkinsData | nil
local gPendingMenuOpen = nil

---@param skinModel string | number
---@return boolean
local function IsPedUsingModel( skinModel )
    local modelHash = type( skinModel ) == 'number' and skinModel or GetHashKey( skinModel )

    return GetEntityModel( PlayerPedId() ) == modelHash
end

---@param pedId number
---@return number
local function GetPedSurfaceZ( pedId )

    local minDimensions = GetModelDimensions( GetEntityModel( pedId ) )
    local pedCoords = GetEntityCoords( pedId )

    return pedCoords.z + minDimensions.z
end

---@param pedId number
---@param surfaceZ number
local function AlignPedToSurface( pedId, surfaceZ )

    local minDimensions = GetModelDimensions( GetEntityModel( pedId ) )
    local pedCoords = GetEntityCoords( pedId )
    local alignedZ = surfaceZ - minDimensions.z

    SetEntityCoordsNoOffset( pedId, pedCoords.x, pedCoords.y, alignedZ, false, false, true )
    SetEntityVelocity( pedId, 0.0, 0.0, 0.0 )
end

---@param pedId number
---@return boolean settled
local function WaitForPedToSettle( pedId )
    local stableChecks = 0

    for _ = 1, PED_SETTLE_MAX_CHECKS do
        Wait( PED_SETTLE_CHECK_INTERVAL_MS )

        if not gIsSkinsMenuOpen or gPendingPedApplication or PlayerPedId() ~= pedId then
            return false
        end

        local velocity = GetEntityVelocity( pedId )
        local isVerticallyStable = not IsEntityInAir( pedId )
            and math.abs( velocity.z ) <= PED_SETTLE_VERTICAL_SPEED_EPSILON

        if isVerticallyStable then
            stableChecks = stableChecks + 1

            if stableChecks >= PED_SETTLE_REQUIRED_STABLE_CHECKS then
                return true
            end
        else
            stableChecks = 0
        end
    end

    sx.logger:warn( 'O ped de preview não estabilizou antes do limite da câmera.' )

    return false
end

local function RefreshCamAfterPedSettles()
    Wait( PED_CAMERA_REFRESH_DELAY_MS )

    if not gIsSkinsMenuOpen or gPendingPedApplication then
        return
    end

    local pedId = PlayerPedId()

    if WaitForPedToSettle( pedId )
        and gIsSkinsMenuOpen
        and not gPendingPedApplication
        and PlayerPedId() == pedId
    then
        RefreshCamMode()
    end
end

---@param skinModel string | number
---@param refreshCustomization boolean
---@return boolean success
---@return boolean modelChanged
---@return number | nil surfaceZ
local function UpdatePedLocally( skinModel, refreshCustomization )

    assert( skinModel )

    local modelChanged = not IsPedUsingModel( skinModel )
    local surfaceZ = nil

    if modelChanged then
        local previousPedId = PlayerPedId()
        surfaceZ = GetPedSurfaceZ( previousPedId )

        sx.logger:debug( ('Updating ped locally to model: %s (%s)'):format( skinModel, type( skinModel ) ) )

        if gIsSkinsMenuOpen then
            SuspendCamMode()
        end

        vRP.Skin( skinModel )
        Wait(0)

        AlignPedToSurface( PlayerPedId(), surfaceZ )
    end

    local success = IsPedUsingModel( skinModel )

    if not success then
        sx.logger:error( ('Não foi possível aplicar o model de preview: %s'):format( skinModel ) )
    end

    if refreshCustomization then
        TriggerServerEvent( 'player:Debug', { isForced = true } )
    end

    return success, modelChanged, surfaceZ
end

local OpenMenu

local function RunPedApplicationWorker()
    while gPendingPedApplication do
        Wait( PED_APPLICATION_DEBOUNCE_MS )

        local request = gPendingPedApplication
        gPendingPedApplication = nil

        local success = true
        local modelChanged = false
        local surfaceZ = nil

        if request.model then
            success, modelChanged, surfaceZ = UpdatePedLocally( request.model, request.refreshCustomization )
        end

        if request.onCompleted then
            request.onCompleted( success )
        end

        if modelChanged then
            Wait( PED_APPLICATION_COOLDOWN_MS )

            if success and gIsSkinsMenuOpen and surfaceZ then
                AlignPedToSurface( PlayerPedId(), surfaceZ )
            end
        end

        if request.model and success and gIsSkinsMenuOpen and not gPendingPedApplication then
            RefreshCamAfterPedSettles()
        end
    end

    gIsPedApplicationWorkerRunning = false

    if gPendingMenuOpen then
        local skinsData = gPendingMenuOpen
        gPendingMenuOpen = nil

        OpenMenu( skinsData )
    end
end

---@param model string | number | nil
---@param refreshCustomization boolean
---@param onCompleted? fun(success: boolean)
local function QueuePedApplication( model, refreshCustomization, onCompleted )
    gPendingPedApplication = {
        model = model,
        refreshCustomization = refreshCustomization,
        onCompleted = onCompleted,
    }

    if gIsPedApplicationWorkerRunning then
        return
    end

    gIsPedApplicationWorkerRunning = true
    CreateThread( RunPedApplicationWorker )
end

local function RestoreOriginalPed()
    local originalPed = gOriginalPed

    assert( originalPed, 'Model original ausente durante a restauração do preview.' )

    gOriginalPed = nil
    gShouldRestoreOriginalPed = false

    QueuePedApplication( originalPed, true, function( success )
        if success then
            sx.logger:debug( 'Original model restored' )
        end
    end )
end

---@param skinsData FormattedSkinsData
OpenMenu = function( skinsData )
    if gIsSkinsMenuOpen then
        sx.logger:warn( 'O menu de skins já está aberto.' )
        return
    end

    if gIsPedApplicationWorkerRunning then
        gPendingMenuOpen = skinsData
        return
    end

    local pedId = PlayerPedId()

    if IsPedInAnyVehicle( pedId ) then

        -- sx.logger:warn( 'Cannot open menu while in a vehicle' )

        return
    end

    if GetEntityHealth( pedId ) <= 100 then

        -- sx.logger:warn( 'Cannot open menu while dead' )

        return
    end

	if exports.combatsystem:IsInCombat( { showHint = true }) then

		-- sx.logger:warn( 'Cannot open menu while in combat' )

		return
	end

    gOriginalPed = GetEntityModel( pedId )
    gShouldRestoreOriginalPed = true
    gIsSkinsMenuOpen = true

    CreateCamMode()

    LocalPlayer.state.Invincible = true
    SetPlayerInvincible( PlayerId(), true )

    SendNUIMessage({
        action = 'peds-menu:open',
        data = {
            initialTab = eSkinCategory.HUMANOS,
            skinsData = skinsData
        }
    })

    SetNuiFocus( true, true )

    sx.logger:debug( 'Skins menu opened' )
end

local function CloseMenu()

    gIsSkinsMenuOpen = false

    SendNUIMessage({
        action = 'peds-menu:close',
        data = {}
    })

    SetNuiFocus( false, false )
    
    LocalPlayer.state.Invincible = false
    SetPlayerInvincible( PlayerId(), false )

    DestroyCamMode()

    sx.logger:debug( 'Skins menu closed' )

    if gShouldRestoreOriginalPed and gOriginalPed then
        RestoreOriginalPed()
    else
        gOriginalPed = nil
        gShouldRestoreOriginalPed = false
    end

end

RegisterNetEvent( 'net.pededitor.openMenu', OpenMenu )

---@param skinModel string
---@param category? string
local function ConfirmSkinSelection( skinModel, category )
    gShouldRestoreOriginalPed = false
    gOriginalPed = nil
    gIsSkinsMenuOpen = false

    QueuePedApplication( skinModel, false, function( success )
        TriggerServerEvent( 'pededitor:selectSkin', skinModel, category, success )

        sx.logger:debug( ('Requesting skin selection: %s'):format( skinModel ) )
    end )
end

---@param data { pedId: string, category: string }
RegisterNUICallback( 'peds-menu:skinEquipped', function( data, cb )
    local skinModel = data.pedId
    local category = data.category

    if not skinModel or type( skinModel ) ~= 'string' then
        sx.logger:error( 'Invalid skinModel for selection' )
        cb( false )
        return
    end

    ConfirmSkinSelection( skinModel, category )

    CloseMenu()

    cb( true )
end)

---@param data { pedId: string, category: string }
RegisterNUICallback( 'peds-menu:previewSkinModel', function( data, cb )

    local skinModel = data.pedId

    if not gIsSkinsMenuOpen or type( skinModel ) ~= 'string' then
        cb( false )
        return
    end

    QueuePedApplication( skinModel, false )

    sx.logger:debug( ('Requesting skin preview: %s'):format( skinModel ) )

    cb( true )
end)

RegisterNUICallback( 'peds-menu:unequipSkin', function( data, cb )

    gOriginalPed = nil
    gShouldRestoreOriginalPed = false
    gIsSkinsMenuOpen = false

    CloseMenu()

    QueuePedApplication( nil, false, function()
        TriggerServerEvent( 'pededitor:unequipSkin' )
    end )

    cb( true )
end)

---@param data { pedId: string, favorite: boolean }
RegisterNUICallback( 'peds-menu:toggleFavorite', function( data, cb )
    local pedId = data.pedId

    TriggerServerEvent( 'pededitor:toggleFavorite', pedId )

    sx.logger:debug( ('Toggling favorite for skin: %s'):format( pedId ) )

    cb( true )
end)

---@param data { direction: string }
RegisterNUICallback( 'peds-menu:rotatePed', function( data, cb )
    local direction = data.direction
    local rotationAmount = direction == 'left' and -5 or 5

    local pedId = PlayerPedId()
    local currentHeading = GetEntityHeading( pedId )

    SetEntityHeading( pedId, currentHeading + rotationAmount )

    cb( true )
end)

RegisterNUICallback( 'peds-menu:close', function( data, cb )
    CloseMenu()
    cb( true )
end)

RegisterNUICallback( 'getCityName', function( _, cb )
    local cityName = string.lower(
        GetConvar( 'cityName', '' )
    )

    cb( cityName )
end)

---@param callbackName string
---@param fallback table
---@param ... any
---@return table
local function AwaitRedeemServer( callbackName, fallback, ... )
    local response = lib.callback.await( callbackName, false, ... )

    if type( response ) ~= 'table' then
        return fallback
    end

    return response
end

local function CloseRedeemFrame()
    SetNuiFocus( false, false )
    SendNUIMessage({ action = 'setVisible', data = false })
end

---@param payload table
local function OpenRedeemFrame( payload )
    SetNuiFocus( true, true )
    SendNUIMessage({ action = 'openPedRedeem', data = payload })
end

RegisterNUICallback( 'getPeds', function( _, cb )
    local response = AwaitRedeemServer( 'pededitor.ped-redeem.get', {} )

    cb(type( response.data ) == 'table' and response.data or {
        available = false,
        hasPending = false,
        limit = 0,
        peds = {},
        slots = {},
        city = GetConvar( 'cityName', '' ),
    })
end)

RegisterNUICallback( 'redeemPeds', function( data, cb )
    local response = AwaitRedeemServer( 'pededitor.ped-redeem.confirm', {
        success = false,
        message = _t( 'redeem.failed' ),
    }, data )

    if response.success then
        TriggerEvent( 'Notify', 'Confirmed', _t( 'redeem.success' ), 5000, 'Peds VIP' )
    end

    cb(response)
end)

RegisterNUICallback( 'hideFrame', function( _, cb )
    CloseRedeemFrame()
    TriggerServerEvent( 'pededitor:ped-redeem:cancel-session' )
    cb({ success = true })
end)

RegisterNetEvent( 'net.pededitor.openRedeem', function( payload )
    OpenRedeemFrame(type( payload ) == 'table' and payload or {
        available = false,
        hasPending = false,
        limit = 0,
        peds = {},
        slots = {},
    })
end)
