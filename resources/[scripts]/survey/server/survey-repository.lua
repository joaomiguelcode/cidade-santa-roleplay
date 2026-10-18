SurveyRepository = {}

function SurveyRepository.SaveSubmission(passport, surveyKey, answers, rating)
    exports.oxmysql:executeSync([[
        INSERT INTO survey_submissions (passport, survey_key, rating, answers, created_at)
        VALUES (?, ?, ?, ?, ?)
    ]], { passport, surveyKey, rating, json.encode(answers), os.time() })
end

function SurveyRepository.GetLastSubmission(passport, surveyKey)
    local rows = exports.oxmysql:executeSync([[
        SELECT * FROM survey_submissions WHERE passport = ? AND survey_key = ? ORDER BY id DESC LIMIT 1
    ]], { passport, surveyKey })
    return rows and rows[1] or nil
end
