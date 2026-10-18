DEFINE_SURVEY 'staff_support' (function(builder)
    builder
        :addPage("page_staff_support", _t("survey.staff_support.title"))
        :addRating("rating", _t("survey.staff_support.question.rating"), {
            isRequired = true,
            rateMin = 0,
            rateMax = 10,
            minRateDescription = _t("survey.staff_support.rating.not_satisfied"),
            maxRateDescription = _t("survey.staff_support.rating.satisfied")
        })
        :addTextarea("comment", _t("survey.staff_support.comment.title"), {
            isRequired = false,
            placeholder = _t("survey.staff_support.comment.placeholder"),
            rows = 5,
            visibleIf = "{rating} < 7"
        })

    return builder
end)

-- if not IsDuplicityVersion() then
--     RegisterCommand('staff_support', function()
--         TriggerEvent('survey:open', 'staff_support')
--     end)
-- end
