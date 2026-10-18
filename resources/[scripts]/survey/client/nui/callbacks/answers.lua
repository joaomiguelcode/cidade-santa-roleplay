RegisterNUICallback('nps:sendAnswers', function(result, callback) -- quando finaliza a pesquisa
    TriggerServerEvent('survey:complete', CurrentSurveyName, result.answers)
    callback(true)
end)

RegisterNUICallback('nps:onCancel', function(result, callback) -- quando cancela a pesquisa
    TriggerServerEvent('survey:canceled', CurrentSurveyName, result)
    callback(true)
end)