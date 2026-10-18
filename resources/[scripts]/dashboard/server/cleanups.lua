CreateThread(function()
    while true do
        Wait(3600000)
        exports.oxmysql:executeSync('DELETE FROM dashboard_bans WHERE expires_at > 0 AND expires_at < ?', { os.time() })
    end
end)
