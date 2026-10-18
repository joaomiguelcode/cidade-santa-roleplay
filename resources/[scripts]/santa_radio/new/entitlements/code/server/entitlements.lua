Entitlements = {}

function Entitlements.Has(passport, key)
    local rows = exports.oxmysql:executeSync('SELECT * FROM player_entitlements WHERE passport = ? AND feature = ?', { passport, key })
    return rows and #rows > 0
end

function Entitlements.Grant(passport, key)
    exports.oxmysql:executeSync('INSERT INTO player_entitlements (passport, feature) VALUES (?, ?) ON DUPLICATE KEY UPDATE granted_at = CURRENT_TIMESTAMP', { passport, key })
end
