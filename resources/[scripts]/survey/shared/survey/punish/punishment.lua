DEFINE_SURVEY 'punishment' (function(builder)
    builder
        :addPage("page_punishment", _t("survey.punishment.title"))
        :addCheckbox("choice-punishment", _t("survey.punishment.title"), {
            { value = "sim",          text = _t("survey.punishment.choice.yes") },
            { value = "nao",          text = _t("survey.punishment.choice.no") },
            { value = "parcialmente", text = _t("survey.punishment.choice.partially") }
        }, { isRequired = true })
        :addTextarea("comment", _t("survey.punishment.comment.title"), {
            placeholder = _t("survey.punishment.comment.placeholder"),
            rows = 5,
            visibleIf = "{choice-punishment} contains 'nao' or {choice-punishment} contains 'parcialmente'"
        })
    return builder
end)

-- if not IsDuplicityVersion() then
--     RegisterCommand('punishment', function()
--         TriggerEvent('survey:open', 'punishment')
--     end)
-- end
