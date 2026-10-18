lib.callback.register('enterprise:show-staff-categories', function()
    lib.registerContext({
        id = 'enterprise:show-staff-categories',
        title = _t('enterprise_system_title'),
        options = STAFF_CONTEXT_FORMS_CONFIGURATOR
    })
    lib.showContext('enterprise:show-staff-categories')
end)