DEFINE_SURVEY 'personal' (function(builder)
    builder
        :addPage("page_persnal", _t("survey.personal.title"))
        :addTextarea("comment", _t("survey.personal.question.opinion"), {
            isRequired = true,
            placeholder = _t("survey.placeholder.describe_opinion"),
            rows = 6,
            maxLength = 1000
        })
        :setOptions({ 
            showProgressBar = "off", 
            showQuestionNumbers = "off", 
            completeText = _t("survey.button.submit"), 
            nextStepText = _t("survey.button.next")
        })
    return builder
end)

-- if not IsDuplicityVersion() then
--     RegisterCommand('personal', function()
--         TriggerEvent('survey:open', 'personal')
--     end)
-- end