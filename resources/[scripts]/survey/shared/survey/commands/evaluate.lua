DEFINE_SURVEY 'evaluate' (function(builder)
    builder
        :addPage('page_evaluate', _t("survey.evaluate.title"))
        :addTextarea('comment', _t("survey.evaluate.description"), {
            isRequired = true,
            placeholder = _t("survey.evaluate.placeholder"),
            rows = 5,
        })

    return builder
end)


-- if not IsDuplicityVersion() then
--     RegisterCommand('evaluate', function()
--         TriggerEvent('survey:open', 'evaluate')
--     end)
-- end