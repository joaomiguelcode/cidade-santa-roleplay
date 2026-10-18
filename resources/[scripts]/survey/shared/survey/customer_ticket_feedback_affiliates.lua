DEFINE_SURVEY 'customer_ticket_feedback_affiliates' (function(builder)
    builder
        :addPage("page_feedback_affiliates", _t("survey.customer_ticket_feedback_affiliates.title"))
        :addRating("rating", _t("survey.customer_ticket_feedback_affiliates.rating.not_satisfied"), {
            isRequired = true,
            rateMin = 0,
            rateMax = 10,
            minRateDescription = _t("survey.customer_ticket_feedback_affiliates.rating.not_satisfied"),
            maxRateDescription = _t("survey.customer_ticket_feedback_affiliates.rating.satisfied")
        })
        :addTextarea("comment", _t("survey.customer_ticket_feedback_affiliates.comment.title"), {
            isRequired = false,
            placeholder = _t("survey.customer_ticket_feedback_affiliates.comment.placeholder"),
            rows = 5,
            visibleIf = nil
            -- visibleIf = "{rating} < 7"
        })

        return builder
end)

-- if not IsDuplicityVersion() then
--     RegisterCommand('customer_ticket_feedback_affiliates', function()
--         TriggerEvent('survey:open', 'customer_ticket_feedback_affiliates')
--     end)
-- end
