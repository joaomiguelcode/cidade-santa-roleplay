---@param callback fun(data: IEnterprise.ForceHireOrFireModal)
local function OnFormForceHireOrFire(callback)
    local selectRoles = {}

    for role, data in ipairs(SHARED_SETTINGS.roles) do
        table.insert(selectRoles, { label = data.title, value = role })
    end

    local input = lib.inputDialog(_t('force_hire_fire_dialog'), {
        {
            type = 'input',
            label = _t('label_passport'),
            description = _t('hire_kick_userid_desc'),
            required = true,
            min = 1,
            max = 10
        },
        {
            type = 'select',
            label = _t('label_function'),
            placeholder = _t('placeholder_select'),
            description = _t('hire_kick_role_desc'),
            options = selectRoles,
            required = false,
        },
        {
            type = 'select',
            label = _t('hire_fire_question'),
            placeholder = _t('placeholder_select'),
            description = _t('hire_kick_action_desc'),
            options = {
                { label = _t('hire_option'), value = 'hire' },
                { label = _t('fire_option'), value = 'fire' }
            },
            required = true,
        }
    })

    if not input then
        return lib.showContext('enterprise:show-staff-categories')
    end

    callback({ user_id = utils.tonumber(input[1]), role = utils.tonumber(input[2]), type = input[3] })
end

DEFINE_CONTEXT_FORM {
    title = _t('force_hire_kick_title'),
    description = _t('force_hire_kick_desc'),
    icon = 'user-plus',
    onSelect = function()
        OnSelectEnterPriseList(function(enterprise)
            OnFormForceHireOrFire(function(data)
                lib.callback.await('enterprise:force-add-or-remove-member', false, enterprise.id, data)
            end)
        end)
    end
}