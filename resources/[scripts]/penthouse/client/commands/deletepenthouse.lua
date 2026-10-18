RegisterCommand('deletepenthouse', function(source)
    if (not hasAdminGroup()) then
        return
    end

    local data = lib.inputDialog(translations[language]['delete_penthouse']['title'], {
        {
            type = 'number',
            label = translations[language]['delete_penthouse']['owner_id'],
            min = 1,
            required = true,
        },
    })

    if (not data) then
        return
    end

    data[1] = tonumber(data[1])

    local penthouses = vSERVER.getPenthouses(data[1])

    if (not penthouses) then
        return
    end

    local penthouses_fields = {}

    for k,v in pairs(penthouses) do
        table.insert(penthouses_fields, {
            title    = v.name,
            onSelect = function()
                local success, err = vSERVER.adminDeletePenthouse(v.ownerId, v.id)

                if (not success) then
                    TriggerEvent('Notify', 'error', translations[language]['penthouse_not_deleted'])
                    return print(err)
                end

                TriggerEvent('Notify', 'Warning', translations[language]['penthouse_deleted'])
            end
        })
    end

    local data = lib.registerContext({
        id      = 'delete_penthouse',
        title   = (translations[language]['penthouses_from_user']):format(data[1]),
        options = penthouses_fields
    })

    lib.showContext('delete_penthouse')
end)