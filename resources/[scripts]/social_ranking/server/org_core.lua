OrgCore = {}

function OrgCore.GetTopOrgs(limit)
    return exports.oxmysql:executeSync('SELECT * FROM social_ranking_orgs ORDER BY xp_week DESC LIMIT ?', { limit or 10 }) or {}
end
