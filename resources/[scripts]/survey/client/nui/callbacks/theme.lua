RegisterNUICallback('getCityName', function(data, callback)
    cityName = GetConvar('cityName', '')
    callback(string.lower(cityName))
end)
