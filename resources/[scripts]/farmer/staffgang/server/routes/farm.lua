-- staffgang routes farm
lib.callback.register('farmer:staffgang:list-farms', function(source)
    return StaffgangRepository.listFarms()
end)

lib.callback.register('farmer:staffgang:create-farm', function(source, payload)
    local passport = vRP.Passport(source)
    if not vRP.hasPermission(passport, 'Admin') then return { success = false, message = 'Sem permissão' } end
    local id = StaffgangRepository.createFarm(payload)
    if payload.point then
        StaffgangRepository.createPoint(id, payload.point)
    end
    return { success = true, id = id }
end)

lib.callback.register('farmer:staffgang:update-farm-data', function(source, farmId, payload)
    local passport = vRP.Passport(source)
    if not vRP.hasPermission(passport, 'Admin') then return { success = false } end
    StaffgangRepository.updateFarmData(farmId, payload)
    return { success = true }
end)

lib.callback.register('farmer:staffgang:update-farm-access', function(source, farmId, accessText)
    local passport = vRP.Passport(source)
    if not vRP.hasPermission(passport, 'Admin') then return { success = false } end
    MySQL.update.await('UPDATE staffgang_farms SET allowedGroupsText = @allowedGroupsText WHERE id = @id', {
        id = farmId,
        allowedGroupsText = accessText
    })
    return { success = true }
end)

lib.callback.register('farmer:staffgang:update-farm-template', function(source, farmId, templateId, replacementPoint, farmMode)
    local passport = vRP.Passport(source)
    if not vRP.hasPermission(passport, 'Admin') then return { success = false } end
    MySQL.update.await('UPDATE staffgang_farms SET templateId = @templateId WHERE id = @id', {
        id = farmId,
        templateId = templateId
    })
    return { success = true }
end)

lib.callback.register('farmer:staffgang:disable-farm', function(source, farmId)
    local passport = vRP.Passport(source)
    if not vRP.hasPermission(passport, 'Admin') then return { success = false } end
    MySQL.update.await('UPDATE staffgang_farms SET disabled = 1 WHERE id = @id', { id = farmId })
    return { success = true }
end)
