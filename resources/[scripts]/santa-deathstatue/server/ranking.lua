-- deathstatue ranking server-side
MySQL.query.await([[
    CREATE TABLE IF NOT EXISTS santa_deathstatue_ranking (
        id INT AUTO_INCREMENT PRIMARY KEY,
        passport INT NOT NULL,
        name VARCHAR(100),
        points INT DEFAULT 0,
        wins INT DEFAULT 0,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    )
]])

function RecordDeathstatueScore(passport, name, points, isWin)
    MySQL.query([[
        INSERT INTO santa_deathstatue_ranking (passport, name, points, wins)
        VALUES (@passport, @name, @points, @wins)
        ON DUPLICATE KEY UPDATE points = points + @points, wins = wins + @wins
    ]], { passport = passport, name = name, points = points, wins = isWin and 1 or 0 })
end
