-- character-creator repository
MySQL.query.await([[
    CREATE TABLE IF NOT EXISTS character_customizations (
        id INT AUTO_INCREMENT PRIMARY KEY,
        passport INT NOT NULL,
        data LONGTEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        UNIQUE KEY uq_passport (passport)
    )
]])

CreatorRepository = {}

function CreatorRepository.saveCustomization(passport, data)
    MySQL.query([[
        INSERT INTO character_customizations (passport, data)
        VALUES (@passport, @data)
        ON DUPLICATE KEY UPDATE data = @data
    ]], { passport = passport, data = json.encode(data) })
end

function CreatorRepository.getCustomization(passport)
    local row = MySQL.query.await('SELECT data FROM character_customizations WHERE passport = @passport', { passport = passport })
    if row and row[1] and row[1].data then
        return json.decode(row[1].data)
    end
    return nil
end
