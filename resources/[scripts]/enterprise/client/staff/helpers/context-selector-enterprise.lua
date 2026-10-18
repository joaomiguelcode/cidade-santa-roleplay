---@param callback  fun(enterprise: IEnterprise)
---@param flags? eDEFINE_GETTERS_ENTERPRISE_INFOS
function OnSelectEnterPriseList(callback, flags)
    local list = lib.callback.await('enterprise/show-enterprise-for-staff')

    local options = {} do
        for index, enterprise in pairs(list) do
            table.insert(options, {
                title = enterprise.name,
                description = _t('enterprise_id_desc') .. ' ' .. tostring(enterprise.id),
                onSelect = function()
                    if not flags then -- caso ele queira apenas escolher uma empresa sem fazer consulta nas informações
                        ---@diagnostic disable-next-line: missing-fields
                        return callback({ id = enterprise.id, name = enterprise.name })
                    end

                    local data = lib.callback.await('enterprise/get-enterprise-by-id', false, flags, enterprise.id)

                    if not data then
                        return
                    end

                    data.id = enterprise.id
                    data.name = enterprise.name

                    callback(data)
                end
            })
        end
    end

    lib.registerContext({
        id = 'enterpise:show-list-stores',
        title = _t('select_enterprise_title'),
        options = options,
        onBack = function()
            lib.showContext('enterprise:show-staff-categories')
        end
    })

    lib.showContext('enterpise:show-list-stores')
end
