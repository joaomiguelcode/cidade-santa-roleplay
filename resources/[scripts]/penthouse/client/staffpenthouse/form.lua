local CONTEXT_HOME = 'staff_penthouse_home'
local CONTEXT_LIST = 'staff_penthouse_list'
local CONTEXT_ACTIONS = 'staff_penthouse_actions'
local CONTEXT_EXPIRATION = 'staff_penthouse_expiration'
local CONTEXT_MONTHLY_PRICES = 'staff_penthouse_monthly_prices'
local MAX_VALUE_MONTHLY = 10000

---@class StaffPenthouseFormsTable
StaffPenthouseForms = StaffPenthouseForms or {}

local function getStaffTranslations()
    local locale = translations[language] or translations['pt-br'] or {}

    return locale['staff_penthouse'] or {}
end

---@param key string
---@return string
local function t(key)
    return getStaffTranslations()[key] or ('no translations found with key staff_penthouse.%s'):format(key)
end

---@param message string
---@param notifyType string | nil
local function notify(message, notifyType)
    lib.notify({
        title = t('title'),
        description = message,
        type = notifyType or 'inform',
    })
end

---@param callbackName string
---@param ... any
---@return table | nil
local function request(callbackName, ...)
    return lib.callback.await(('penthouse:staff:%s'):format(callbackName), false, ...)
end

---@param response table | nil
---@return boolean
local function notifyResponse(response)
    if not response then
        notify(t('no_server_response'), 'error')
        return false
    end

    notify(response.message or t(response.ok and 'generic_success' or 'generic_error'), response.ok and 'success' or 'error')

    return response.ok == true
end

---@return table
local function getInteriorOptions()
    local options = {}

    for interiorId, interior in ipairs(config.interiors) do
        options[#options + 1] = {
            value = tostring(interiorId),
            label = ('%s - %s'):format(interior.title or ('#%s'):format(interiorId), interior.address or t('not_available')),
        }
    end

    return options
end

---@return table
local function getAccessOptions()
    local options = {}

    for accessTypeId, accessTypeName in ipairs(accessTypesEnum) do
        options[#options + 1] = {
            value = tostring(accessTypeId),
            label = t(('access_%s'):format(accessTypeName)),
        }
    end

    return options
end

---@return table
local function getColorOptions()
    local options = {}

    for colorId, wallpaper in ipairs(config.wallpapers) do
        options[#options + 1] = {
            value = tostring(colorId),
            label = wallpaper.name or tostring(colorId),
        }
    end

    return options
end

---@param property table
---@return string
local function buildPropertyDescription(property)
    return (t('property_description')):format(
        property.ownerName or property.ownerId,
        property.interiorName or property.interior,
        property.expireAtText or t('permanent')
    )
end

---@param property table
---@return table
local function buildPropertyMetadata(property)
    return {
        { label = t('metadata_owner'), value = property.ownerName or property.ownerId },
        { label = t('metadata_level'), value = property.interiorName or property.interior },
        { label = t('metadata_access'), value = property.accessTypeLabel or property.accessTypeName },
        { label = t('metadata_expiration'), value = property.expireAtText or t('permanent') },
        { label = t('metadata_color'), value = property.colorLabel or property.color },
    }
end

---@param property table
function StaffPenthouseForms.showPropertyActions(property)
    local title = (t('property_title')):format(property.id, property.name or t('not_available'))

    lib.registerContext({
        id = CONTEXT_ACTIONS,
        title = title,
        menu = CONTEXT_LIST,
        options = {
            {
                title = t('action_edit_details_title'),
                description = t('action_edit_details_desc'),
                icon = 'pen-line',
                onSelect = function()
                    StaffPenthouseForms.editDetails(property)
                end,
            },
            {
                title = t('action_edit_expiration_title'),
                description = t('action_edit_expiration_desc'),
                icon = 'calendar-clock',
                onSelect = function()
                    StaffPenthouseForms.showExpirationActions(property)
                end,
            },
            {
                title = t('action_edit_level_title'),
                description = t('action_edit_level_desc'),
                icon = 'house-up',
                onSelect = function()
                    StaffPenthouseForms.editLevel(property)
                end,
            },
            {
                title = t('action_transfer_title'),
                description = t('action_transfer_desc'),
                icon = 'right-left',
                onSelect = function()
                    StaffPenthouseForms.transferOwner(property)
                end,
            },
            {
                title = t('action_delete_title'),
                description = t('action_delete_desc'),
                icon = 'trash',
                iconColor = '#ef4444',
                onSelect = function()
                    StaffPenthouseForms.deleteProperty(property)
                end,
            },
        },
    })

    lib.showContext(CONTEXT_ACTIONS)
end

---@param properties table
---@param title string
local function showPropertyList(properties, title)
    local options = {}

    for _, property in ipairs(properties or {}) do
        options[#options + 1] = {
            title = (t('property_title')):format(property.id, property.name or t('not_available')),
            description = buildPropertyDescription(property),
            icon = property.isExpired and 'house-circle-xmark' or 'house',
            iconColor = property.isExpired and '#ef4444' or '#22c55e',
            metadata = buildPropertyMetadata(property),
            onSelect = function()
                StaffPenthouseForms.showPropertyActions(property)
            end,
        }
    end

    if #options == 0 then
        options[#options + 1] = {
            title = t('no_properties'),
            icon = 'circle-info',
            disabled = true,
        }
    end

    lib.registerContext({
        id = CONTEXT_LIST,
        title = title,
        menu = CONTEXT_HOME,
        onBack = StaffPenthouseForms.showHome,
        canShowTextFilter = true,
        options = options,
    })

    lib.showContext(CONTEXT_LIST)
end

function StaffPenthouseForms.listProperties()
    local response = request('list-properties')

    if not response then
        notify(t('no_server_response'), 'error')
        return
    end

    if not response.ok then
        notify(response.message or t('generic_error'), 'error')
        return
    end

    showPropertyList(response.data and response.data.properties or {}, t('list_title'))
end

function StaffPenthouseForms.searchById()
    local input = lib.inputDialog(t('search_id_title'), {
        {
            type = 'number',
            label = t('field_penthouse_id'),
            min = 1,
            required = true,
        },
    })

    if not input then
        StaffPenthouseForms.showHome()
        return
    end

    local response = request('get-property', input[1])

    if not response then
        notify(t('no_server_response'), 'error')
        return
    end

    if not response.ok then
        notify(response.message or t('generic_error'), 'error')
        return
    end

    StaffPenthouseForms.showPropertyActions(response.data.property)
end

function StaffPenthouseForms.searchByOwner()
    local input = lib.inputDialog(t('search_owner_title'), {
        {
            type = 'number',
            label = t('field_owner_id'),
            min = 1,
            required = true,
        },
    })

    if not input then
        StaffPenthouseForms.showHome()
        return
    end

    local response = request('list-owner-properties', input[1])

    if not response then
        notify(t('no_server_response'), 'error')
        return
    end

    if not response.ok then
        notify(response.message or t('generic_error'), 'error')
        return
    end

    showPropertyList(
        response.data and response.data.properties or {},
        (t('owner_list_title')):format(input[1])
    )
end

function StaffPenthouseForms.createProperty()
    local input = lib.inputDialog(t('home_create_title'), {
        {
            type = 'number',
            label = t('field_owner_id'),
            min = 1,
            required = true,
        },
        {
            type = 'select',
            label = t('field_level'),
            options = getInteriorOptions(),
            default = '1',
            required = true,
            searchable = true,
        },
        {
            type = 'input',
            label = t('field_name'),
            required = true,
        },
        {
            type = 'date',
            label = t('field_expiration_date'),
            description = t('field_expiration_date_description'),
            returnString = true,
            format = 'YYYY-MM-DD',
            clearable = true,
            required = false,
        },
    })

    if not input then
        StaffPenthouseForms.showHome()
        return
    end

    local response = request('create-property', {
        ownerId = input[1],
        interior = tonumber(input[2]),
        name = input[3],
        expireAtDate = input[4],
    })

    if notifyResponse(response) and response.data and response.data.property then
        StaffPenthouseForms.showPropertyActions(response.data.property)
    end
end

---@param property table
function StaffPenthouseForms.editDetails(property)
    local input = lib.inputDialog((t('details_dialog_title')):format(property.id), {
        {
            type = 'input',
            label = t('field_name'),
            default = property.name,
            required = true,
        },
        {
            type = 'select',
            label = t('field_access_type'),
            options = getAccessOptions(),
            default = tostring(property.accessType),
            required = true,
        },
        {
            type = 'select',
            label = t('field_color'),
            options = getColorOptions(),
            default = tostring(property.color),
            required = true,
            searchable = true,
        },
    })

    if not input then
        StaffPenthouseForms.showPropertyActions(property)
        return
    end

    local response = request('update-details', property.id, {
        name = input[1],
        accessType = tonumber(input[2]),
        color = tonumber(input[3]),
    })

    if notifyResponse(response) and response.data and response.data.property then
        StaffPenthouseForms.showPropertyActions(response.data.property)
    end
end

---@param property table
function StaffPenthouseForms.showExpirationActions(property)
    lib.registerContext({
        id = CONTEXT_EXPIRATION,
        title = (t('expiration_menu_title')):format(property.id),
        menu = CONTEXT_ACTIONS,
        onBack = function()
            StaffPenthouseForms.showPropertyActions(property)
        end,
        options = {
            {
                title = t('action_set_expiration_title'),
                description = t('action_set_expiration_desc'),
                icon = 'calendar-days',
                onSelect = function()
                    StaffPenthouseForms.setExpiration(property)
                end,
            },
            {
                title = t('action_remove_expiration_title'),
                description = t('action_remove_expiration_desc'),
                icon = 'calendar-x',
                onSelect = function()
                    StaffPenthouseForms.removeExpiration(property)
                end,
            },
        },
    })

    lib.showContext(CONTEXT_EXPIRATION)
end

---@param property table
function StaffPenthouseForms.setExpiration(property)
    local defaultDate = nil

    if property.expireAt then
        defaultDate = property.expireAt * 1000
    end

    local input = lib.inputDialog((t('expiration_dialog_title')):format(property.id), {
        {
            type = 'date',
            label = t('field_expiration_date'),
            description = t('field_expiration_date_description'),
            default = defaultDate,
            returnString = true,
            format = 'YYYY-MM-DD',
            required = true,
        },
    })

    if not input then
        StaffPenthouseForms.showExpirationActions(property)
        return
    end

    local response = request('update-expiration', property.id, {
        expireAtDate = input[1],
    })

    if notifyResponse(response) and response.data and response.data.property then
        StaffPenthouseForms.showPropertyActions(response.data.property)
    end
end

---@param property table
function StaffPenthouseForms.removeExpiration(property)
    local response = lib.alertDialog({
        header = t('confirm_remove_expiration_header'),
        content = (t('confirm_remove_expiration_content')):format(property.name or property.id),
        centered = true,
        cancel = true,
    })

    if response ~= 'confirm' then
        StaffPenthouseForms.showExpirationActions(property)
        return
    end

    local result = request('update-expiration', property.id, {
        clearExpiration = true,
    })

    if notifyResponse(result) and result.data and result.data.property then
        StaffPenthouseForms.showPropertyActions(result.data.property)
    end
end

---@param property table
function StaffPenthouseForms.editLevel(property)
    local input = lib.inputDialog((t('level_dialog_title')):format(property.id), {
        {
            type = 'select',
            label = t('field_level'),
            options = getInteriorOptions(),
            default = tostring(property.interior),
            required = true,
            searchable = true,
        },
    })

    if not input then
        StaffPenthouseForms.showPropertyActions(property)
        return
    end

    local targetInterior = tonumber(input[1])
    local interior = config.interiors[targetInterior]
    local response = lib.alertDialog({
        header = t('confirm_level_header'),
        content = (t('confirm_level_content')):format(property.name or property.id, interior and interior.address or tostring(targetInterior)),
        centered = true,
        cancel = true,
    })

    if response ~= 'confirm' then
        StaffPenthouseForms.showPropertyActions(property)
        return
    end

    local result = request('update-level', property.id, targetInterior)

    if notifyResponse(result) and result.data and result.data.property then
        StaffPenthouseForms.showPropertyActions(result.data.property)
    end
end

---@param property table
function StaffPenthouseForms.transferOwner(property)
    local input = lib.inputDialog((t('transfer_dialog_title')):format(property.id), {
        {
            type = 'number',
            label = t('field_new_owner_id'),
            min = 1,
            required = true,
        },
    })

    if not input then
        StaffPenthouseForms.showPropertyActions(property)
        return
    end

    local response = lib.alertDialog({
        header = t('confirm_transfer_header'),
        content = (t('confirm_transfer_content')):format(property.name or property.id, tostring(input[1])),
        centered = true,
        cancel = true,
    })

    if response ~= 'confirm' then
        StaffPenthouseForms.showPropertyActions(property)
        return
    end

    local result = request('transfer-owner', property.id, input[1])

    if notifyResponse(result) and result.data and result.data.property then
        StaffPenthouseForms.showPropertyActions(result.data.property)
    end
end

---@param property table
function StaffPenthouseForms.deleteProperty(property)
    local response = lib.alertDialog({
        header = t('confirm_delete_header'),
        content = (t('confirm_delete_content')):format(property.name or property.id, tostring(property.id)),
        centered = true,
        cancel = true,
    })

    if response ~= 'confirm' then
        StaffPenthouseForms.showPropertyActions(property)
        return
    end

    local result = request('delete-property', property.id)

    if notifyResponse(result) then
        StaffPenthouseForms.listProperties()
    end
end

---@param interiorId number
---@param price number | nil
function StaffPenthouseForms.editMonthlyPrice(interiorId, price)
    local interior = config.interiors[interiorId]

    if not interior then
        notify(t('invalid_interior'), 'error')
        return
    end

    local input = lib.inputDialog((t('monthly_price_dialog_title')):format(interior.title), {
        {
            type = 'number',
            label = t('field_monthly_price'),
            default = price,
            min = 1,
            max = MAX_VALUE_MONTHLY,
            step = 1,
            required = true,
        },
    })

    if not input then
        StaffPenthouseForms.showMonthlyPrices()
        return
    end

    local newMonthlyPrice = tonumber(input[1])
    local confirmation = lib.alertDialog({
        header = t('confirm_monthly_price_header'),
        content = (t('confirm_monthly_price_content')):format(
            interior.title,
            price and tostring(price) or t('not_available'),
            tostring(newMonthlyPrice)
        ),
        centered = true,
        cancel = true,
    })

    if confirmation ~= 'confirm' then
        StaffPenthouseForms.showMonthlyPrices()
        return
    end

    local response = request('update-monthly-price', interiorId, newMonthlyPrice)

    if notifyResponse(response) then
        StaffPenthouseForms.showMonthlyPrices()
    end
end

function StaffPenthouseForms.showMonthlyPrices()
    local response = request('list-monthly-prices')

    if not response then
        notify(t('no_server_response'), 'error')
        return
    end

    if not response.ok then
        notify(response.message or t('generic_error'), 'error')
        return
    end

    local monthlyPrices = response.data and response.data.monthlyPrices or {}
    local options = {}
    for _, monthlyPriceData in ipairs(monthlyPrices) do
        local interiorId = monthlyPriceData.interiorId
        local monthlyPrice = monthlyPriceData.monthlyPrice
        local interior = config.interiors[interiorId]

        if interior then
            options[#options + 1] = {
                title = ('%s - %s'):format(
                    monthlyPriceData.title or interior.title,
                    monthlyPriceData.address or interior.address or t('not_available')
                ),
                description = (t('monthly_price_description')):format(
                    monthlyPrice and tostring(monthlyPrice) or t('not_available')
                ),
                icon = 'coins',
                onSelect = function()
                    StaffPenthouseForms.editMonthlyPrice(interiorId, monthlyPrice)
                end,
            }
        end
    end

    if #options == 0 then
        options[#options + 1] = {
            title = t('no_monthly_prices'),
            icon = 'circle-info',
            disabled = true,
        }
    end

    lib.registerContext({
        id = CONTEXT_MONTHLY_PRICES,
        title = t('monthly_prices_title'),
        menu = CONTEXT_HOME,
        onBack = StaffPenthouseForms.showHome,
        canShowTextFilter = true,
        options = options,
    })

    lib.showContext(CONTEXT_MONTHLY_PRICES)
end

function StaffPenthouseForms.showHome()
    lib.registerContext({
        id = CONTEXT_HOME,
        title = t('title'),
        options = {
            {
                title = t('home_list_title'),
                description = t('home_list_desc'),
                icon = 'list',
                onSelect = StaffPenthouseForms.listProperties,
            },
            {
                title = t('home_monthly_prices_title'),
                description = t('home_monthly_prices_desc'),
                icon = 'coins',
                onSelect = StaffPenthouseForms.showMonthlyPrices,
            },
            {
                title = t('home_search_id_title'),
                description = t('home_search_id_desc'),
                icon = 'search',
                onSelect = StaffPenthouseForms.searchById,
            },
            {
                title = t('home_search_owner_title'),
                description = t('home_search_owner_desc'),
                icon = 'id-card',
                onSelect = StaffPenthouseForms.searchByOwner,
            },
            {
                title = t('home_create_title'),
                description = t('home_create_desc'),
                icon = 'house-circle-check',
                onSelect = StaffPenthouseForms.createProperty,
            },
        },
    })

    lib.showContext(CONTEXT_HOME)
end

