local Tunnel = module('vrp', 'lib/Tunnel')
local server = Tunnel.getInterface('group_leadership')
local visible = false
local pending = false

local function close()
    if pending then return false end
    visible = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'closeLeadership', data = {} })
    return true
end

RegisterNetEvent('group_leadership:open', function(data)
    if pending then return end
    visible = true
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'openLeadership', data = data })
end)

RegisterNUICallback('getCityName', function(_, callback)
    callback(GetConvar('cityName', 'Maresia'):lower())
end)

RegisterNUICallback('hideFrame', function(_, callback)
    callback(close())
end)

for _, method in ipairs({ 'getLeadershipData', 'validateLeadership', 'confirmLeadership' }) do
    RegisterNUICallback(method, function(data, callback)
        if method ~= 'getLeadershipData' and not visible then callback({ ok = false, error = 'forbidden' }) return end
        if method == 'confirmLeadership' and pending then callback({ ok = false, error = 'busy' }) return end
        if method == 'confirmLeadership' then pending = true end
        local ok, result = pcall(function() return server[method](data) end)
        if method == 'confirmLeadership' then pending = false end
        callback(ok and result or { ok = false, error = 'unavailable' })
    end)
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() and visible then SetNuiFocus(false, false) end
    if resource == 'painel' then
        pending = false
        if visible then close() end
    end
end)
