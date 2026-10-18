SurveyManager = {}

function SurveyManager.TriggerSurvey(source, surveyKey)
    local passport = vRP.Passport(source)
    if not passport then return end
    
    local canTake, err = DefaultSurveyStrategy.CanTakeSurvey(passport, surveyKey)
    if not canTake then return end
    
    TriggerClientEvent('survey:client:open', source, surveyKey)
end
