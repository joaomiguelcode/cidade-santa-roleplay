---@param callback  fun(id: IEnterprise.ForceHireOrFireModal)
function onListContextEnterprise(callback)
    local list = lib.callback.await('enterprise/show-enterprise-for-staff')

    local options = {}
    do
        for index, enterprise in pairs(list) do
            table.insert(options, {
                title = enterprise.name,
                description = _t('enterprise_id_desc') .. ' ' .. tostring(enterprise.id),
                onSelect = function()
                    callback(enterprise.id)
                end
            })
        end
    end

    local context = lib.registerContext({
        id = 'enterpise:show-list-stores',
        title = _t('select_enterprise_title'),
        options = options,
        onBack = function()
            lib.showContext('enterprise:show-staff-categories')
        end
    })

    lib.showContext('enterpise:show-list-stores')
end