-- audio_scheduler repository
MySQL.query.await([[
    CREATE TABLE IF NOT EXISTS audio_schedules (
        id INT AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(100),
        url TEXT NOT NULL,
        type VARCHAR(50) DEFAULT 'announcement',
        frequency VARCHAR(50) DEFAULT 'once',
        scheduled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        audience VARCHAR(50) DEFAULT 'all',
        world VARCHAR(50) DEFAULT 'global',
        volume FLOAT DEFAULT 0.5,
        status VARCHAR(20) DEFAULT 'pending',
        created_by INT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
]])

AudioRepository = {}

function AudioRepository.listSchedules()
    return MySQL.query.await('SELECT * FROM audio_schedules ORDER BY scheduled_at ASC')
end

function AudioRepository.createSchedule(data)
    return MySQL.insert.await([[
        INSERT INTO audio_schedules (title, url, type, frequency, scheduled_at, audience, world, volume, created_by)
        VALUES (@title, @url, @type, @frequency, @scheduled_at, @audience, @world, @volume, @created_by)
    ]], {
        title = data.title or 'Anúncio',
        url = data.url,
        type = data.type or 'announcement',
        frequency = data.frequency or 'once',
        scheduled_at = data.scheduled_at or os.date('%Y-%m-%d %H:%M:%S'),
        audience = data.audience or 'all',
        world = data.world or 'global',
        volume = data.volume or 0.5,
        created_by = data.passport or 0
    })
end

function AudioRepository.cancelSchedule(id)
    return MySQL.update.await('UPDATE audio_schedules SET status = "cancelled" WHERE id = @id', { id = id })
end
