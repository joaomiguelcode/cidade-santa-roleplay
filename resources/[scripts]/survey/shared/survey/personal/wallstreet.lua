DEFINE_SURVEY 'wallstreet' (function(builder)
    builder
        :addPage("page_wallstreet", _t("survey.wallstreet.title"))
        :addRating("rating", _t("survey.wallstreet.title"), {
            isRequired = true,
            rateMin = 0,
            rateMax = 10,
            minRateDescription = _t("survey.wallstreet.rating.very_bad"),
            maxRateDescription = _t("survey.wallstreet.rating.very_good")
        })
        :addTextarea("comment", _t("survey.wallstreet.comment.title"), {
            isRequired = false,
            placeholder = _t("survey.wallstreet.comment.placeholder"),
            rows = 5,
            visibleIf = "{rating} < 7"
        })
    return builder
end)


-- if not IsDuplicityVersion() then
--     RegisterCommand('wallstreet', function()
--         TriggerEvent('survey:open', 'wallstreet')
--     end)
-- end
