DEFINE_SURVEY 'affiliates_ticket_close_reason2' (function(builder)
    builder
        :addPage("page_affiliates_ticket_close_reason", _t("survey.affiliates_ticket_close_reason.title"))
        :addCheckbox("reason", _t("survey.affiliates_ticket_close_reason.question"), {
            -- { value = "venda_realizada", text = _t("survey.affiliates_ticket_close_reason.reason.sale_made") },
            { value = "CANCELED_CUSTOMER_ALREADY_HAS_PRODUCT", text = _t("survey.affiliates_ticket_close_reason.reason.client_already_owned") },
            { value = "CANCELED_CUSTOMER_BADCONDUCT", text = _t("survey.affiliates_ticket_close_reason.reason.misconduct") },
            { value = "CANCELED_CUSTOMER_WANTS_TO_BUY_LATER", text = _t("survey.affiliates_ticket_close_reason.reason.client_will_buy_later") },
            { value = "CANCELED_CUSTOMER_UNAVAILABLE", text = _t("survey.affiliates_ticket_close_reason.reason.client_unavailable") },
            { value = "CANCELED_CUSTOMER_NO_FUNDS", text = _t("survey.affiliates_ticket_close_reason.reason.client_no_money") },
            { value = "CANCELED_CUSTOMER_CONNECTION_ISSUES", text = _t("survey.affiliates_ticket_close_reason.reason.connection_problem") },
            { value = "CANCELED_CUSTOMER_REFUSED_OFFER", text = _t("survey.affiliates_ticket_close_reason.reason.refused_offer") }

        }, { isRequired = true, colCount = 2, multiple = false })
        :addTextarea("comment", _t("survey.affiliates_ticket_close_reason.comment.title"), {
            isRequired = true,
            placeholder = _t("survey.affiliates_ticket_close_reason.comment.placeholder"),
            rows = 5,
            maxLength = 255,
        })
        :setOptions({
            -- Não funciona!
            nextStepText = _t("survey.affiliates_ticket_close_reason.next_step_text"),
        })

    return builder
end)
-- if not IsDuplicityVersion() then
--     RegisterCommand('staff_support', function()
--         TriggerEvent('survey:open', 'staff_support')
--     end)
-- end
