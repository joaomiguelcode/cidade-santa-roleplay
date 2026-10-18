-- itemvip routes
lib.callback.register('itemvip:redeem-items', function(source, data)
    local passport = vRP.Passport(source)
    if not passport then return { success = false } end
    
    local selections = data and data.selections
    if not selections then return { success = false } end
    
    for _, sel in ipairs(selections) do
        if sel.item and sel.amount then
            vRP.generateItem(passport, sel.item, sel.amount, true)
        end
    end
    
    ItemVipRepository.logRedeem(passport, selections)
    return { success = true }
end)
