DEFINE_SURVEY 'organization_indication' (function(builder)
    builder
        :addPage("page_organization_indication", _t("survey.rate_organization.title_page_1"))
        :addRating("rating-organization-indication-1", _t("survey.rate_organization.rating.never_would_page_1"), {
            isRequired = true,
            rateMin = 0,
            rateMax = 10,
            minRateDescription = _t("survey.rate_organization.rating.never_would_page_1"),
            maxRateDescription = _t("survey.rate_organization.rating.totally_would_page_1")
        })
        :addTextarea("comment", _t("survey.rate_organization.comment.title_page_1"), {
            isRequired = false,
            placeholder = _t("survey.rate_organization.comment.placeholder_page_1"),
            rows = 5,
            visibleIf = "{rating-organization-indication-1} < 7"
        })

    builder
        :addPage("page_organization_indication_2", _t("survey.rate_organization.title_page_2"))

        :addRating("rating-organization-indication-2", _t("survey.rate_organization.rating.not_satisfied_page_2"), {
            isRequired = true,
            rateMin = 0,
            rateMax = 10,
            minRateDescription = _t("survey.rate_organization.rating.not_satisfied_page_2"),
            maxRateDescription = _t("survey.rate_organization.rating.satisfied_page_2")
        })

        :addTextarea("comment", _t("survey.rate_organization.comment.title_page_2"), {
            isRequired = false,
            placeholder = _t("survey.rate_organization.comment.placeholder_page_2"),
            rows = 5,
            visibleIf =
            "{rating-organization-indication-2} < 7"
        })

    builder
        :addPage("page_organization_indication_3", _t("survey.rate_organization.title_page_3"))
        :addCheckbox("choice-organization-indication-3", _t("survey.rate_organization.choice.never"), {
            { value = "never",          text = _t("survey.rate_organization.choice.never") },
            { value = "rarely",          text = _t("survey.rate_organization.choice.rarely") },
            { value = "frequently",          text = _t("survey.rate_organization.choice.frequently") },
        }, { isRequired = true })
        :addTextarea("comment", _t("survey.rate_organization.comment.title_page_3"), {
            isRequired = false,
            placeholder = _t("survey.rate_organization.comment.placeholder_page_3"),
            rows = 5,
            visibleIf =
            "{choice-organization-indication-3} contains 'never' or {choice-organization-indication-3} contains 'rarely'"
        })

    builder
        :addPage("page_organization_indication_4", _t("survey.rate_organization.title_page_4"))
        :addRating("rating-organization-indication-4", _t("survey.rate_organization.rating.not_satisfied_page_4"), {
            isRequired = true,
            rateMin = 0,
            rateMax = 10,
            minRateDescription = _t("survey.rate_organization.rating.not_satisfied_page_4"),
            maxRateDescription = _t("survey.rate_organization.rating.satisfied_page_4")
        })
        
        :addTextarea("comment", _t("survey.rate_organization.comment.title_page_4"), {
            isRequired = false,
            placeholder = _t("survey.rate_organization.comment.placeholder_page_4"),
            rows = 5,
            visibleIf = "{rating-organization-indication-4} < 7"
        })

    builder
        :addPage("page_organization_indication_5", _t("survey.rate_organization.title_page_5"))
        :addRating("rating-organization-indication-5", _t("survey.rate_organization.rating.not_satisfied_page_5"), {
            isRequired = true,
            rateMin = 0,
            rateMax = 10,
            minRateDescription = _t("survey.rate_organization.rating.not_satisfied_page_5"),
            maxRateDescription = _t("survey.rate_organization.rating.satisfied_page_5")
        })
        :addTextarea("comment", _t("survey.rate_organization.comment.title_page_5"), {
            isRequired = false,
            placeholder = _t("survey.rate_organization.comment.placeholder_page_5"),
            rows = 5,
            visibleIf = "{rating-organization-indication-5} < 7"
        })

    return builder
end)

-- if not IsDuplicityVersion() then
--     RegisterCommand('organization_indication', function()
--         TriggerEvent('survey:open', 'organization_indication')
--     end)
-- end
