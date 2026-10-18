local COMBINE_SURVEYS = {
    'culture',
    'wallstreet',
    'staff_support'
}

local function isReadyCombineSurveys()
    for _, survey in pairs(COMBINE_SURVEYS) do
        if not SURVEY_DATABASE[survey] then
            return false
        end
    end
    return true
end

DEFINE_SURVEY 'indication' (function(builder)
    builder
        :addPage("page_indication", _t("survey.indication.title"))
        :addRating("rating", _t("survey.indication.question.recommend"), {
            isRequired = true,
            rateMin = 0,
            rateMax = 10,
            minRateDescription = _t("survey.indication.rating.never_would"),
            maxRateDescription = _t("survey.indication.rating.would")
        })
        :addTextarea("comment", _t("survey.indication.comment.title"), {
            isRequired = false,
            placeholder = _t("survey.indication.comment.placeholder"),
            rows = 5,
            visibleIf = nil
            -- visibleIf = "{rating} < 7"
        })

    while not isReadyCombineSurveys() do
        Wait(1000)
    end

    for _, surveyName in pairs(COMBINE_SURVEYS) do
        local survey = SURVEY_DATABASE[surveyName]

        for _, page in pairs(survey.pages) do
            builder:addPage(page.name, page.title)

            for _, element in pairs(page.elements) do
                local clone = table.clone(element)

                clone.visibleIf = nil
                builder:addElement(clone)
            end
        end
    end

    return builder
end)

-- if not IsDuplicityVersion() then
--     RegisterCommand('indication', function()
--         TriggerEvent('survey:open', 'indication')
--     end)
-- end
