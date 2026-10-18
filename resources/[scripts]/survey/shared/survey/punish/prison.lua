DEFINE_SURVEY 'prison_punishment' (function(builder)
    builder
        :addPage('prison_punishment', _t("survey.prison.title"))
        :addCheckbox("choice-prison-punishment", _t("survey.prison.title"), {
            { value = "sim",          text = _t("survey.prison.choice.yes") },
            { value = "nao",          text = _t("survey.prison.choice.no") },
            { value = "parcialmente", text = _t("survey.prison.choice.partially") }
        }, { isRequired = true })
        :addTextarea("comment", _t("survey.prison.comment.title"), {
            placeholder = _t("survey.prison.comment.placeholder"),
            rows = 5,
            visibleIf = "{choice-prison-punishment} contains 'nao' or {choice-prison-punishment} contains 'parcialmente'"
        })

    return builder
end)

-- if not IsDuplicityVersion() then
--     RegisterCommand('prison', function()
--         TriggerEvent('survey:open', 'prison_punishment')
--     end)
-- end