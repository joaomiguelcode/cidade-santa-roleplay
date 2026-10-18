DEFINE_SURVEY 'organization_exit' (function(builder)
    builder
        :addPage("page_organization_exit", _t("survey.organization_exit.title"))
        :addCheckbox("choice-organization-exit", _t("survey.organization_exit.title"), {
            { value = "saida_voluntaria",  text = _t("survey.organization_exit.reason.voluntary") },
            { value = "expulso",           text = _t("survey.organization_exit.reason.kicked") },
            { value = "clima_ruim",        text = _t("survey.organization_exit.reason.bad_climate") },
            { value = "falta_atividade",   text = _t("survey.organization_exit.reason.lack_activity") },
            { value = "pouco_retorno",     text = _t("survey.organization_exit.reason.low_payment") },
            { value = "preferencia_outra", text = _t("survey.organization_exit.reason.prefer_other") },
            { value = "outros",            text = _t("survey.organization_exit.reason.others") }
        }, { isRequired = true, colCount = 2,multiple = true})
        :addTextarea("comment", _t("survey.organization_exit.comment.title"), {
            isRequired = false,
            placeholder = _t("survey.organization_exit.comment.placeholder"),
            rows = 5,
            visibleIf = "{choice-organization-exit} contains 'outros'"
        })

    return builder
end)

-- if not IsDuplicityVersion() then
--     RegisterCommand('organization_exit', function()
--         TriggerEvent('survey:open', 'organization_exit')
--     end)
-- end