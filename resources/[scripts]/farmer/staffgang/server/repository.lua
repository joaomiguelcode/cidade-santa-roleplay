-- farmer staffgang repository
StaffgangRepository = {}

function StaffgangRepository.listFarms()
    return MySQL.query.await('SELECT * FROM staffgang_farms WHERE disabled = 0')
end

function StaffgangRepository.createFarm(data)
    local id = MySQL.insert.await([[
        INSERT INTO staffgang_farms (templateId, title, shopTitle, description, allowedGroupsText, isAfk)
        VALUES (@templateId, @title, @shopTitle, @description, @allowedGroupsText, @isAfk)
    ]], {
        templateId = data.templateId,
        title = data.title,
        shopTitle = data.shopTitle,
        description = data.description,
        allowedGroupsText = data.allowedGroupsText,
        isAfk = data.isAfk and 1 or 0
    })
    return id
end

function StaffgangRepository.updateFarmData(id, payload)
    return MySQL.update.await([[
        UPDATE staffgang_farms
        SET title = @title, description = @description, shopTitle = @shopTitle,
            allowedGroupsText = @allowedGroupsText, isAfk = @isAfk
        WHERE id = @id
    ]], {
        id = id,
        title = payload.title,
        description = payload.description,
        shopTitle = payload.shopTitle,
        allowedGroupsText = payload.allowedGroupsText,
        isAfk = payload.isAfk and 1 or 0
    })
end

function StaffgangRepository.listPoints(farmId)
    return MySQL.query.await('SELECT * FROM staffgang_points WHERE farmId = @farmId AND disabled = 0', { farmId = farmId })
end

function StaffgangRepository.createPoint(farmId, payload)
    return MySQL.insert.await('INSERT INTO staffgang_points (farmId, data) VALUES (@farmId, @data)', {
        farmId = farmId,
        data = json.encode(payload)
    })
end

function StaffgangRepository.listShops(farmId)
    return MySQL.query.await('SELECT * FROM staffgang_shops WHERE farmId = @farmId AND disabled = 0', { farmId = farmId })
end

function StaffgangRepository.createShop(farmId, payload)
    return MySQL.insert.await('INSERT INTO staffgang_shops (farmId, data) VALUES (@farmId, @data)', {
        farmId = farmId,
        data = json.encode(payload)
    })
end
