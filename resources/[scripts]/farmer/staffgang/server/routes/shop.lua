-- staffgang routes shop
lib.callback.register('farmer:staffgang:list-shops', function(source, farmId)
    local rows = StaffgangRepository.listShops(farmId)
    for _, r in ipairs(rows) do
        if r.data then r.data = json.decode(r.data) end
    end
    return rows
end)

lib.callback.register('farmer:staffgang:create-shop', function(source, farmId, positionPayload)
    local passport = vRP.Passport(source)
    if not vRP.hasPermission(passport, 'Admin') then return { success = false } end
    local id = StaffgangRepository.createShop(farmId, positionPayload)
    return { success = true, id = id }
end)

lib.callback.register('farmer:staffgang:disable-shop', function(source, farmId, shopId)
    local passport = vRP.Passport(source)
    if not vRP.hasPermission(passport, 'Admin') then return { success = false } end
    MySQL.update.await('UPDATE staffgang_shops SET disabled = 1 WHERE id = @id', { id = shopId })
    return { success = true }
end)
