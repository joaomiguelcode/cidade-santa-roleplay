
RegisterNUICallback('getCityName', function(data, callback)
    cityName = GetConvar('cityName', '')
    callback(string.lower(cityName))
end)

RegisterNUICallback('hideFrame', function(data, callback)
    SetNuiFocus(false, false)
    callback(true)
end)

RegisterNUICallback('company:roles', function(data, callback)
    local companyRoles = lib.callback.await('enterprise/ui/get-roles-labels', false, EnterPriseClass.activeEnterprise)
    callback(companyRoles)
end)