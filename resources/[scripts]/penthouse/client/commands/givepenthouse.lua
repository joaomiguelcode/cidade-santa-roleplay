local GIVE_PENTHOUSE_FIELDS = {
    {
        type = 'number',
        label = translations[language]['give_penthouse']['owner_id'],
        min = 1,
        required = true,
    },
    {
        type = 'number',
        label = translations[language]['give_penthouse']['penthouse_interior_id'],
        min = 1,
        max = #config.interiors,
        default = 1,
        required = true,
    },
    {
        type = 'input',
        label = translations[language]['give_penthouse']['penthouse_name'],
        required = true,
    }
}

---@return void
givePenthouse = function()
    local ok = hasAdminGroup()

    if not ok then return end

    local data = lib.inputDialog(translations[language]['give_penthouse']['title'], GIVE_PENTHOUSE_FIELDS)

    if not data then
        return
    end

    data[1] = tonumber(data[1])
    data[2] = tonumber(data[2])
    data[3] = data[3]

    if (not config.interiors[data[2]]) then
        return TriggerEvent('Notify', 'error', translations[language]['give_penthouse']['invalid_interior'])
    end

    TriggerServerEvent('penthouse.server:givePenthouse', data)
end

RegisterCommand('givepenthouse', givePenthouse)