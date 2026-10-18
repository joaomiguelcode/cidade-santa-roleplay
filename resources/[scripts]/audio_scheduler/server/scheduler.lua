-- audio_scheduler ticker
CreateThread(function()
    while true do
        Wait(30000)
        local now = os.date('%Y-%m-%d %H:%M:00')
        local pending = MySQL.query.await('SELECT * FROM audio_schedules WHERE status = "pending" AND scheduled_at <= @now', { now = now })
        if pending and #pending > 0 then
            for _, item in ipairs(pending) do
                TriggerClientEvent('audio_scheduler:play', -1, item.url, item.volume or 0.5)
                MySQL.update.await('UPDATE audio_schedules SET status = "completed" WHERE id = @id', { id = item.id })
            end
        end
    end
end)
