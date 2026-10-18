StaffPenthouseRepository = {}

function StaffPenthouseRepository.GetAll()
    return exports.oxmysql:executeSync('SELECT * FROM penthouses') or {}
end

function StaffPenthouseRepository.Save(data)
    exports.oxmysql:executeSync([[
        INSERT INTO penthouses (property_id, building_id, location_id, owner_passport, house_name, monthly_price, expires_at)
        VALUES (?, ?, ?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE house_name = VALUES(house_name), monthly_price = VALUES(monthly_price), expires_at = VALUES(expires_at)
    ]], { data.property_id, data.building_id, data.location_id, data.owner_passport, data.house_name, data.monthly_price, data.expires_at })
end
