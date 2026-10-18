-- phone middleware check
RegisterPhoneMiddleware('item_check', function(action, source, data)
    if not vRP then return true end
    local passport = vRP.Passport and vRP.Passport(source) or vRP.getUserId(source)
    if not passport then return false end
    -- Check if player has cellphone item
    local amount = vRP.InventoryItemAmount and vRP.InventoryItemAmount(passport, 'celular') or {0}
    if type(amount) == 'table' then amount = amount[1] or 0 end
    if amount <= 0 then
        -- Also check "phone" or "smartphone"
        local alt = vRP.InventoryItemAmount(passport, 'phone')
        if type(alt) == 'table' then alt = alt[1] or 0 end
        if alt <= 0 then
            return false
        end
    end
    return true
end)
