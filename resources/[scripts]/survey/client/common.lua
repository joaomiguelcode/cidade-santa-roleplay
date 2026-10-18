CurrentSurveyName = nil

AddEventHandler('survey:set-kvp', function(key, value)
    SetResourceKvp(key, value)
end)

---@param surveyName string
RegisterNetEvent('survey:open', function(surveyName)
    SetNuiFocus(true,true)
    CurrentSurveyName = surveyName
    SendNUIMessage({action = 'open', data = SURVEY_DATABASE[surveyName]})
end)

RegisterNetEvent('survey:close', function()
    SetNuiFocus(false,false)
    SendNUIMessage({action = 'close'})
end)

lib.callback.register('survey:get-kvp', function(key)
    return GetResourceKvpString(key)
end)

exports('getKvp', function(key)
    return GetResourceKvpString(key)
end)

RegisterNetEvent('survey:set-kvp', function(key, value)
    SetResourceKvp(key, value)
end)