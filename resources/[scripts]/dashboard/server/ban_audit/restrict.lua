BanRestrict = {}

function BanRestrict.IsRestricted(passport)
    local rows = exports.oxmysql:executeSync('SELECT * FROM dashboard_bans WHERE passport = ? AND expires_at > ?', { passport, os.time() })
    return rows and #rows > 0
end
