Preferences = {}

RegisterNetEvent('social_ranking:setEffectsEnabled', function(enabled)
    local src = source
    local passport = vRP.Passport(src)
    if passport then
        exports.oxmysql:executeSync('UPDATE social_ranking_xp SET effects_enabled = ? WHERE passport = ?', { enabled and 1 or 0, passport })
    end
end)
