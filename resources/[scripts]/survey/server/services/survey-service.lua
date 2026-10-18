SurveyService = {}

function SurveyService.ProcessSubmission(passport, surveyKey, answers)
    local survey = SURVEY_DATABASE[surveyKey]
    if not survey then return false, 'Survey não encontrado' end
    
    local rating = tonumber(answers.rating or answers.score or 10)
    SurveyRepository.SaveSubmission(passport, surveyKey, answers, rating)
    
    if rating <= 3 then
        SurveyLowRatingLog.Log(passport, surveyKey, rating, answers)
    end
    
    return true
end
