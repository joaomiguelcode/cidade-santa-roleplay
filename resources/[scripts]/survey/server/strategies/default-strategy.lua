DefaultSurveyStrategy = {}

function DefaultSurveyStrategy.CanTakeSurvey(passport, surveyKey)
    local last = SurveyRepository.GetLastSubmission(passport, surveyKey)
    if last and (os.time() - last.created_at) < 86400 then
        return false, 'Você já respondeu esta pesquisa recentemente.'
    end
    return true
end
