-- staffgang routes point
lib.callback.register('farmer:staffgang:list-points', function(source, farmId)
    local rows = StaffgangRepository.listPoints(farmId)
    for _, r in ipairs(rows) do
        if r.data then r.data = json.decode(r.data) end
    end
    return rows
end)

lib.callback.register('farmer:staffgang:create-point', function(source, farmId, pointPayload)
    local passport = vRP.Passport(source)
    if not vRP.hasPermission(passport, 'Admin') then return { success = false } end
    local id = StaffgangRepository.createPoint(farmId, pointPayload)
    return { success = true, id = id }
end)

lib.callback.register('farmer:staffgang:update-point', function(source, farmId, pointId, pointPayload)
    local passport = vRP.Passport(source)
    if not vRP.hasPermission(passport, 'Admin') then return { success = false } end
    MySQL.update.await('UPDATE staffgang_points SET data = @data WHERE id = @id', {
        id = pointId,
        data = json.encode(pointPayload)
    })
    return { success = true }
end)

lib.callback.register('farmer:staffgang:delete-point', function(source, farmId, pointId)
    local passport = vRP.Passport(source)
    if not vRP.hasPermission(passport, 'Admin') then return { success = false } end
    MySQL.update.await('UPDATE staffgang_points SET disabled = 1 WHERE id = @id', { id = pointId })
    return { success = true }
end)
