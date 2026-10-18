DEFINE_SURVEY 'organization_leader_survey' (function(builder)
    builder
        :addPage("page_organization_leader_survey", _t('survey.organization_leader.title'))
        :addRating("rating-organization-leader-survey", _t('survey.organization_leader.rating.not_satisfied'), {
            isRequired = true,
            rateMin = 0,
            rateMax = 10,
            minRateDescription = _t('survey.organization_leader.rating.not_satisfied'),
            maxRateDescription = _t('survey.organization_leader.rating.satisfied')
        })
        :addTextarea("comment", _t('survey.organization_leader.comment.title'), {
            isRequired = true,
            placeholder = _t('survey.organization_leader.comment.placeholder'),
            rows = 5,
        })

    return builder
end)

if not IsDuplicityVersion() then
    RegisterCommand('organization_leader_survey', function()
        TriggerEvent('survey:open', 'organization_leader_survey')
    end)
end
