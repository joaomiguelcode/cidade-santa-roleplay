-- Atalho do Match para cidades que usam LB Phone em vez do smartphone legado.
-- Toda elegibilidade continua no evento server-side de Neighbor.

if not NeighborConfig.enabled then
    return
end

local APP_ID = 'match-social'
local gMatchLbPhoneRegistered = false
local gMatchLbPhoneRegistrationEpoch = 0
local gMatchLbPhoneRegistrationFailures = 0

local function OpenMatch()

    if GetResourceState('lb-phone') ~= 'started' then
        return
    end

    local affiliateBusy = false
    if GetResourceState('dashboard') == 'started' then
        local ok, active = pcall(function()
            return exports.dashboard:IsAffiliateCommercialActive()
        end)
        affiliateBusy = ok and active == true
    end

    exports['lb-phone']:ToggleOpen(false)

    CreateThread(function()
        Wait(250)
        TriggerServerEvent('dminigames:neighbor:openFromApp', affiliateBusy)
    end)
end

local function RegisterMatchApp()

    if gMatchLbPhoneRegistered then
        return true
    end

    if GetResourceState('lb-phone') ~= 'started' then
        return false
    end

    local ok, registered, reason = pcall(function()
        return exports['lb-phone']:AddCustomApp({
            identifier = APP_ID,
            name = NeighborTranslations.get('app_name'),
            description = NeighborTranslations.get('title'),
            icon = 'https://cfx-nui-dminigames/web/match-city/match-social-dark.svg',
            defaultApp = true,
            onUse = OpenMatch,
        })
    end)

    if not ok or registered ~= true then
        gMatchLbPhoneRegistrationFailures = gMatchLbPhoneRegistrationFailures + 1
        if gMatchLbPhoneRegistrationFailures == 1 or gMatchLbPhoneRegistrationFailures % 10 == 0 then
            sx.logger:warn(('matchcity: lb-phone app indisponivel (tentativa %d): %s'):format(
                gMatchLbPhoneRegistrationFailures, tostring(ok and reason or registered)))
        end
        return false
    end

    gMatchLbPhoneRegistered = true
    gMatchLbPhoneRegistrationFailures = 0
    return true
end

local function RetryMatchApp(epoch)

    if epoch ~= gMatchLbPhoneRegistrationEpoch or GetResourceState('lb-phone') ~= 'started' then
        return
    end

    if RegisterMatchApp() then
        return
    end

    SetTimeout(1000, function()
        RetryMatchApp(epoch)
    end)
end

local function RegisterAfterPhoneStart()

    gMatchLbPhoneRegistrationEpoch = gMatchLbPhoneRegistrationEpoch + 1
    local epoch = gMatchLbPhoneRegistrationEpoch

    CreateThread(function()
        Wait(500)
        RetryMatchApp(epoch)
    end)
end

RegisterAfterPhoneStart()

AddEventHandler('onClientResourceStart', function(resourceName)

    if resourceName == 'lb-phone' then
        RegisterAfterPhoneStart()
    end
end)

AddEventHandler('onClientResourceStop', function(resourceName)

    if resourceName == 'lb-phone' then
        gMatchLbPhoneRegistrationEpoch = gMatchLbPhoneRegistrationEpoch + 1
        gMatchLbPhoneRegistered = false
        gMatchLbPhoneRegistrationFailures = 0
    elseif resourceName == GetCurrentResourceName() and gMatchLbPhoneRegistered
        and GetResourceState('lb-phone') == 'started' then
        gMatchLbPhoneRegistrationEpoch = gMatchLbPhoneRegistrationEpoch + 1
        pcall(function()
            exports['lb-phone']:RemoveCustomApp(APP_ID)
        end)
    elseif resourceName == GetCurrentResourceName() then
        gMatchLbPhoneRegistrationEpoch = gMatchLbPhoneRegistrationEpoch + 1
    end
end)
