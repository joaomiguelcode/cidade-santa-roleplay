---@param enterprise IEnterprise | nil
---@param callback fun(response: IEnterprise)
local function OnFormEditEnterprise(enterprise, callback)
    local storeOptions = {}
    do
        for option, data in pairs(SHARED_SETTINGS.ENTERPRISE_TYPES) do
            table.insert(storeOptions, { label = data.label, value = option })
        end
    end

    local dialogTitle = enterprise and ('Editando - %s, id: %s'):format(enterprise.name, enterprise.id) or
        'Criando empresa'

    local input = lib.inputDialog(dialogTitle, {
        {
            type = 'input',
            label = 'Nome',
            description = _t('enterprise_name_desc'),
            default = enterprise and enterprise.name,
            required = true,
            min = 4,
            max = 16
        },
        {
            type = 'input',
            label = 'Imagem',
            description = _t('enterprise_image_desc'),
            default = enterprise and enterprise.photo,
            required = false,
            min = 4
        },
        {
            type = 'input',
            label = 'Banner',
            description = _t('enterprise_banner_desc'),
            default = enterprise and enterprise.banner,
            required = false,
            min = 4
        },
        {
            type = 'select',
            label = _t('label_function'),
            placeholder = _t('placeholder_select'),
            description = _t('enterprise_type_desc'),
            default = enterprise and enterprise.type,
            options = storeOptions
        },
        {
            type = 'input',
            label = _t('label_coordinates'),
            description = _t('enterprise_position_desc'),
            required = true,
            default = utils.transformVecToString(enterprise and enterprise.position or GetEntityCoords(PlayerPedId()))
        },
        {
            type = 'slider',
            label = 'Level da empresa',
            description = _t('enterprise_level_desc'),
            default = enterprise and enterprise.upgrade or 1,
            min = 1,
            max = #SHARED_SETTINGS.ENTERPRISE_LIMITS
        },
        {
            type = 'number',
            label = _t('enterprise_radio_frequency_label'),
            description = _t('enterprise_radio_frequency_desc'),
            default = enterprise and enterprise.radio_frequency or nil,
            required = false,
            min = 1,
            max = 3000
        },
    })

    if not input then
        return lib.showContext('enterprise:show-staff-categories')
    end

    local response = {
        name = input[1],
        photo = input[2] or '',
        banner = input[3] or '',
        type = input[4],
        position = input[5],
        id = enterprise and enterprise.id or -1,
        upgrade = input[6],
        radio_frequency = tonumber(input[7]) or nil,
    }

    if #utils.split(response.position, ',') < 3 then
        utils.notify(0, "Warning", _t('invalid_coordinates_desc'), 8000, _t('invalid_coordinates_title'))
        return OnFormEditEnterprise(enterprise, callback)
    end
    if response.banner ~= '' and not (response.banner:find('http://') or response.banner:find('https://')) then
        utils.notify(0, "Warning", _t('invalid_banner_desc'), 8000, _t('invalid_banner_title'))
        return OnFormEditEnterprise(enterprise, callback)
    end

    if not SHARED_SETTINGS.ENTERPRISE_LIMITS[response.upgrade] then
        utils.notify(0, "Warning", _t('invalid_level_desc'), 8000, _t('invalid_level_title'))
        return OnFormEditEnterprise(enterprise, callback)
    end

    if response.photo ~= '' and not (response.photo:find('http://') or response.photo:find('https://')) then
        utils.notify(0, "Warning", _t('invalid_image_desc'), 8000, _t('invalid_image_title'))
        return OnFormEditEnterprise(enterprise, callback)
    end

    callback(response)
end

DEFINE_CONTEXT_FORM {
    title = _t('create_enterprise_title'),
    description = _t('create_enterprise_desc'),
    icon = 'plus-circle',
    onSelect = function()
        OnFormEditEnterprise(nil, function(input)
            lib.callback.await('enterprise:create-enterprise', false, input)
        end)
    end
}

DEFINE_CONTEXT_FORM {
    title = _t('edit_enterprise_title'),
    description = _t('edit_enterprise_desc'),
    icon = 'edit',
    onSelect = function()
        OnSelectEnterPriseList(function(enterprise)
            OnFormEditEnterprise(enterprise, function(input)
                lib.callback.await('enterprise:edit-enterprise', false, input)
            end)
        end, DEFINE_GETTERS_ENTERPRISE_INFOS.BASIC_INFORMATIONS)
    end
}

DEFINE_CONTEXT_FORM {
    title = _t('delete_enterprise_title'),
    description = _t('delete_enterprise_desc'),
    icon = 'trash',
    onSelect = function()
        OnSelectEnterPriseList(function(enterprise)
            lib.callback.await('enterprise:delete-enterprise', false, enterprise.id)
        end)
    end
}
