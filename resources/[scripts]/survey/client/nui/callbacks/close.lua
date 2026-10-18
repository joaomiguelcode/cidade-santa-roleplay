RegisterNUICallback('close', function(data, callback)
    SetNuiFocus(false,false)
    callback(true)
end)