
---@alias survey.Database table<string, survey.Survey>
---@type survey.Database
SURVEY_DATABASE = {}

---Define um survey no banco de dados
---@param key string
---@return fun(builder: fun(survey: survey.Builder): survey.Builder): survey.Survey
function DEFINE_SURVEY(key)
    return function(builder)
        local surveyBuilder = builder(SurveyBuilderClass.new())
        local survey = surveyBuilder:build()
        
        SURVEY_DATABASE[key] = survey
        return survey
    end
end