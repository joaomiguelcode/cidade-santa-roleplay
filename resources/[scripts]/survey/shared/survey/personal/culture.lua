DEFINE_SURVEY 'culture' (function(builder)
    builder
        :addPage("page_culture", _t("survey.culture.title"))
        :addCheckbox("choice-respect", _t("survey.culture.question.respect"), {
            { value = "nunca",          text = _t("survey.culture.choice.never") },
            { value = "as_vezes",      text = _t("survey.culture.choice.rarely") },
            { value = "frequentemente", text = _t("survey.culture.choice.frequently") },
        }, { isRequired = true })
        :addTextarea("comment", _t("survey.culture.comment.title"), {
            isRequired = false,
            placeholder = _t("survey.culture.comment.placeholder"),
            visibleIf = nil,
            rows = 5
        })
    return builder
end)

-- if not IsDuplicityVersion() then
--     RegisterCommand('culture', function()
--         TriggerEvent('survey:open', 'culture')
--     end)
-- end
