---@param enterprise_id number
---@param vips table<string, number>
local function OnFormConfigureStocksVips(enterprise_id, vips)
    local fields = {}

    for key, data in pairs(SHARED_SETTINGS.VIPS) do
        table.insert(fields, {
            type = 'input',
            label = data.name,
            description = data.description,
            default = vips[data.id] or 0
        })
    end

    local response = lib.inputDialog(_t('configure_vip_stock_title'), fields)

    if not response then
        return lib.showContext('enterprise:show-staff-categories')
    end

    local payload = {}

    for key, value in pairs(response) do
        payload[SHARED_SETTINGS.VIPS[key].id] = tonumber(value) or 0
    end

    return lib.callback.await('enterprise:update-stocks-vips', false, enterprise_id, payload)
end

DEFINE_CONTEXT_FORM {
    title = _t('configure_stock_vips_title'),
    description = _t('configure_stock_vips_desc'),
    icon = 'cog',
    onSelect = function()
        OnSelectEnterPriseList(function(enterprise)
            OnFormConfigureStocksVips(enterprise.id, enterprise.stock_vips)
        end, DEFINE_GETTERS_ENTERPRISE_INFOS.STOCK_VIPS)
    end
}
