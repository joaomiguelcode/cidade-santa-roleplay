exports('TriggerSurvey', function(targetSource, surveyKey)
    SurveyManager.TriggerSurvey(targetSource, surveyKey)
end)

exports('CanTakeSurvey', function(passport, surveyKey)
    return DefaultSurveyStrategy.CanTakeSurvey(passport, surveyKey)
end)
