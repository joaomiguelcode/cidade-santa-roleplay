local CONTEXT_HOME = 'hud_coupons:home'
local CONTEXT_LIST = 'hud_coupons:list'
local CONTEXT_CATEGORY = 'hud_coupons:category'
local CONTEXT_ACTIONS = 'hud_coupons:actions'
local CONTEXT_VIP_COLLECTION = 'hud_coupons:vip_collection'

local CouponsAdminMenuApi = {}

---@param categoryValue string
---@return string
local function GetCouponCategoryLabel(categoryValue)
    for _, category in ipairs(COUPONS_CONFIG.CATEGORIES) do
        if category.VALUE == categoryValue then
            return _t(category.TRANSLATION)
        end
    end

    return categoryValue
end

---@return table[]
local function GetCouponCategoryOptions()
    local options = {}

    for _, category in ipairs(COUPONS_CONFIG.CATEGORIES) do
        options[#options + 1] = {
            value = category.VALUE,
            label = _t(category.TRANSLATION),
        }
    end

    return options
end

---@param message string
---@param notifyType? string
local function Notify(message, notifyType)
    lib.notify({
        title = _t('coupons.title'),
        description = message,
        type = notifyType or 'inform',
    })
end

---@param result HudCouponResult?
---@return boolean
local function NotifyResult(result)
    if not result then
        Notify(_t('coupons.generic.noServerResponse'), 'error')
        return false
    end

    Notify(
        result.message or _t(result.ok and 'coupons.generic.ok' or 'coupons.generic.error'),
        result.ok and 'success' or 'error'
    )

    return result.ok == true
end

---@param value? number
---@return string
local function FormatMinimumPurchase(value)
    if value == nil then
        return _t('coupons.value.noMinimum')
    end

    return ('R$ %.2f'):format(value)
end

---@param value number
---@return string
local function FormatDiscount(value)
    return ('%d%%'):format(value)
end

---@param value? string
---@return string
local function FormatDate(value)
    return value or _t('coupons.value.noDate')
end

---@param coupon HudCouponAdminDto
---@return string
local function BuildCouponDescription(coupon)
    return _t('coupons.list.item.description'):format(
        FormatDiscount(coupon.discount),
        _t(coupon.isActive and 'coupons.status.active' or 'coupons.status.inactive'),
        _t(coupon.isAvailable and 'coupons.availability.available' or 'coupons.availability.unavailable'),
        FormatMinimumPurchase(coupon.minimumPurchase),
        FormatDate(coupon.startsAtFormatted),
        FormatDate(coupon.expiresAtFormatted),
        coupon.updatedByName,
        tostring(coupon.updatedByCharacterId),
        FormatDate(coupon.createdAtFormatted),
        FormatDate(coupon.updatedAtFormatted)
    )
end

---@param coupon? HudCouponAdminDto
---@param onCancel function
---@return HudCouponPayload?
local function InputCoupon(coupon, onCancel)
    local input = lib.inputDialog(
        _t(coupon and 'coupons.dialog.edit.title' or 'coupons.dialog.create.title'),
        {
            {
                type = 'input',
                label = _t('coupons.dialog.code'),
                required = true,
                default = coupon and coupon.code or nil,
                min = COUPONS_CONFIG.CONSTRAINTS.CODE_MIN_LENGTH,
                max = COUPONS_CONFIG.CONSTRAINTS.CODE_MAX_LENGTH,
            },
            {
                type = 'select',
                label = _t('coupons.dialog.category'),
                required = true,
                default = coupon and coupon.category or nil,
                options = GetCouponCategoryOptions(),
            },
            {
                type = 'number',
                label = _t('coupons.dialog.discount'),
                required = true,
                default = coupon and tonumber(coupon.discount) or nil,
                min = COUPONS_CONFIG.CONSTRAINTS.DISCOUNT_MIN,
                max = COUPONS_CONFIG.CONSTRAINTS.DISCOUNT_MAX,
                step = 1,
            },
            {
                type = 'input',
                label = _t('coupons.dialog.tebexUrl'),
                required = true,
                default = coupon and coupon.tebexUrl or nil,
                max = COUPONS_CONFIG.CONSTRAINTS.URL_MAX_LENGTH,
            },
            {
                type = 'number',
                label = _t('coupons.dialog.minimumPurchase'),
                default = coupon and tonumber(coupon.minimumPurchase) or nil,
                min = 0,
                precision = 2,
            },
            {
                type = 'date',
                label = _t('coupons.dialog.startsAt'),
                default = coupon and coupon.startsAt or nil,
                clearable = true,
            },
            {
                type = 'date',
                label = _t('coupons.dialog.expiresAt'),
                default = coupon and coupon.expiresAt or nil,
                clearable = true,
            },
            {
                type = 'checkbox',
                label = _t('coupons.dialog.active'),
                checked = coupon == nil or coupon.isActive,
            },
        }
    )

    if not input then
        onCancel()
        return nil
    end

    return {
        code = input[1],
        category = input[2],
        discount = tonumber(input[3]),
        tebexUrl = input[4],
        minimumPurchase = tonumber(input[5]),
        startsAt = input[6],
        expiresAt = input[7],
        isActive = input[8] == true,
    }
end

---@param collection? HudVipCollectionAdminDto
---@return HudVipCollectionPayload?
local function InputVipCollection(collection)
    local constraints = COUPONS_CONFIG.CONSTRAINTS.VIP_COLLECTION
    local input = lib.inputDialog(
        _t(collection and 'coupons.vipCollection.dialog.edit.title' or 'coupons.vipCollection.dialog.create.title'),
        {
            {
                type = 'input',
                label = _t('coupons.vipCollection.dialog.title'),
                required = true,
                default = collection and collection.title or nil,
                min = constraints.TITLE_MIN_LENGTH,
                max = constraints.TITLE_MAX_LENGTH,
            },
            {
                type = 'textarea',
                label = _t('coupons.vipCollection.dialog.description'),
                required = true,
                default = collection and collection.description or nil,
                min = constraints.DESCRIPTION_MIN_LENGTH,
                max = constraints.DESCRIPTION_MAX_LENGTH,
                autosize = true,
            },
            {
                type = 'input',
                label = _t('coupons.vipCollection.dialog.tebexUrl'),
                required = true,
                default = collection and collection.tebexUrl or nil,
                max = constraints.URL_MAX_LENGTH,
            },
            {
                type = 'input',
                label = _t('coupons.vipCollection.dialog.bannerUrl'),
                required = true,
                default = collection and collection.bannerUrl or nil,
                max = constraints.URL_MAX_LENGTH,
            },
        }
    )

    if not input then
        return nil
    end

    return {
        title = input[1],
        description = input[2],
        tebexUrl = input[3],
        bannerUrl = input[4],
    }
end

function CouponsAdminMenuApi.showHome()
    lib.registerContext({
        id = CONTEXT_HOME,
        title = _t('coupons.title'),
        options = {
            {
                title = _t('coupons.home.create.title'),
                description = _t('coupons.home.create.description'),
                icon = 'plus',
                onSelect = function()
                    CouponsAdminMenuApi.create()
                end,
            },
            {
                title = _t('coupons.home.list.title'),
                description = _t('coupons.home.list.description'),
                icon = 'ticket',
                onSelect = function()
                    CouponsAdminMenuApi.showList()
                end,
            },
            {
                title = _t('coupons.vipCollection.home.title'),
                description = _t('coupons.vipCollection.home.description'),
                icon = 'crown',
                onSelect = function()
                    CouponsAdminMenuApi.showVipCollection()
                end,
            },
        },
    })

    lib.showContext(CONTEXT_HOME)
end

function CouponsAdminMenuApi.showList()
    local response = lib.callback.await(COUPONS_CONFIG.CALLBACKS.LIST, false)

    if not response or not response.ok then
        NotifyResult(response)
        CouponsAdminMenuApi.showHome()
        return
    end

    local options = {}
    local couponCountByCategory = {}
    local categories = {}

    if #response.data < 1 then
        options[#options + 1] = {
            title = _t('coupons.list.empty.title'),
            description = _t('coupons.list.empty.description'),
            disabled = true,
        }
    end

    for _, coupon in ipairs(response.data) do
        if not couponCountByCategory[coupon.category] then
            couponCountByCategory[coupon.category] = 0
            categories[#categories + 1] = coupon.category
        end

        couponCountByCategory[coupon.category] = couponCountByCategory[coupon.category] + 1
    end

    table.sort(categories, function(left, right)
        return GetCouponCategoryLabel(left):lower() < GetCouponCategoryLabel(right):lower()
    end)

    for _, category in ipairs(categories) do
        local selectedCategory = category

        options[#options + 1] = {
            title = GetCouponCategoryLabel(selectedCategory),
            description = _t('coupons.list.category.description'):format(couponCountByCategory[selectedCategory]),
            icon = 'folder',
            onSelect = function()
                CouponsAdminMenuApi.showCategory(selectedCategory)
            end,
        }
    end

    lib.registerContext({
        id = CONTEXT_LIST,
        title = _t('coupons.home.list.title'),
        menu = CONTEXT_HOME,
        onBack = CouponsAdminMenuApi.showHome,
        canShowTextFilter = true,
        options = options,
    })

    lib.showContext(CONTEXT_LIST)
end

---@param category string
function CouponsAdminMenuApi.showCategory(category)
    local response = lib.callback.await(COUPONS_CONFIG.CALLBACKS.LIST, false)

    if not response or not response.ok then
        NotifyResult(response)
        return CouponsAdminMenuApi.showList()
    end

    local coupons = {}

    for _, coupon in ipairs(response.data) do
        if coupon.category == category then
            coupons[#coupons + 1] = coupon
        end
    end

    if #coupons < 1 then
        return CouponsAdminMenuApi.showList()
    end

    table.sort(coupons, function(left, right)
        return left.code < right.code
    end)

    local options = {}

    for _, coupon in ipairs(coupons) do
        local selectedCoupon = coupon

        options[#options + 1] = {
            title = ('[%d] %s'):format(selectedCoupon.id, selectedCoupon.code),
            description = BuildCouponDescription(selectedCoupon),
            icon = selectedCoupon.isAvailable and 'badge-check' or 'ticket-x',
            onSelect = function()
                CouponsAdminMenuApi.showActions(selectedCoupon)
            end,
        }
    end

    lib.registerContext({
        id = CONTEXT_CATEGORY,
        title = GetCouponCategoryLabel(category),
        menu = CONTEXT_LIST,
        onBack = CouponsAdminMenuApi.showList,
        canShowTextFilter = true,
        options = options,
    })

    lib.showContext(CONTEXT_CATEGORY)
end

---@param coupon HudCouponAdminDto
function CouponsAdminMenuApi.showActions(coupon)
    local statusTitle = coupon.isActive and 'coupons.actions.disable.title' or 'coupons.actions.enable.title'
    local statusDescription = coupon.isActive and 'coupons.actions.disable.description' or 'coupons.actions.enable.description'

    lib.registerContext({
        id = CONTEXT_ACTIONS,
        title = ('[%d] %s'):format(coupon.id, coupon.code),
        menu = CONTEXT_CATEGORY,
        onBack = function()
            CouponsAdminMenuApi.showCategory(coupon.category)
        end,
        options = {
            {
                title = _t('coupons.actions.edit.title'),
                description = _t('coupons.actions.edit.description'),
                icon = 'pencil',
                onSelect = function()
                    CouponsAdminMenuApi.edit(coupon)
                end,
            },
            {
                title = _t(statusTitle),
                description = _t(statusDescription),
                icon = coupon.isActive and 'toggle-right' or 'toggle-left',
                onSelect = function()
                    CouponsAdminMenuApi.toggleStatus(coupon)
                end,
            },
            {
                title = _t('coupons.actions.remove.title'),
                description = _t('coupons.actions.remove.description'),
                icon = 'trash',
                onSelect = function()
                    CouponsAdminMenuApi.remove(coupon)
                end,
            },
        },
    })

    lib.showContext(CONTEXT_ACTIONS)
end

function CouponsAdminMenuApi.showVipCollection()
    local response = lib.callback.await(COUPONS_CONFIG.CALLBACKS.GET_VIP_COLLECTION, false)

    if not response or not response.ok then
        NotifyResult(response)
        return CouponsAdminMenuApi.showHome()
    end

    local collection = response.data
    local options = {}

    if collection then
        options[#options + 1] = {
            title = collection.title,
            description = collection.description,
            image = collection.bannerUrl,
            readOnly = true,
            metadata = {
                {
                    label = _t('coupons.vipCollection.dialog.tebexUrl'),
                    value = collection.tebexUrl,
                },
                {
                    label = _t('coupons.vipCollection.value.createdBy'),
                    value = ('%s (%s)'):format(collection.createdByName, collection.createdByCharacterId),
                },
                {
                    label = _t('coupons.vipCollection.value.updatedBy'),
                    value = ('%s (%s)'):format(collection.updatedByName, collection.updatedByCharacterId),
                },
            },
        }
    end

    options[#options + 1] = {
        title = _t(collection and 'coupons.vipCollection.actions.edit.title' or 'coupons.vipCollection.actions.create.title'),
        description = _t(collection and 'coupons.vipCollection.actions.edit.description' or 'coupons.vipCollection.actions.create.description'),
        icon = collection and 'pencil' or 'plus',
        onSelect = function()
            CouponsAdminMenuApi.saveVipCollection(collection)
        end,
    }

    if collection then
        options[#options + 1] = {
            title = _t('coupons.vipCollection.actions.remove.title'),
            description = _t('coupons.vipCollection.actions.remove.description'),
            icon = 'trash',
            onSelect = function()
                CouponsAdminMenuApi.removeVipCollection(collection)
            end,
        }
    end

    lib.registerContext({
        id = CONTEXT_VIP_COLLECTION,
        title = _t('coupons.vipCollection.home.title'),
        menu = CONTEXT_HOME,
        onBack = CouponsAdminMenuApi.showHome,
        options = options,
    })

    lib.showContext(CONTEXT_VIP_COLLECTION)
end

---@param collection? HudVipCollectionAdminDto
function CouponsAdminMenuApi.saveVipCollection(collection)
    local payload = InputVipCollection(collection)

    if not payload then
        return CouponsAdminMenuApi.showVipCollection()
    end

    local response = lib.callback.await(COUPONS_CONFIG.CALLBACKS.SAVE_VIP_COLLECTION, false, payload)

    NotifyResult(response)
    CouponsAdminMenuApi.showVipCollection()
end

---@param collection HudVipCollectionAdminDto
function CouponsAdminMenuApi.removeVipCollection(collection)
    local confirmation = lib.alertDialog({
        header = _t('coupons.vipCollection.dialog.remove.header'),
        content = _t('coupons.vipCollection.dialog.remove.content'):format(collection.title),
        centered = true,
        cancel = true,
    })

    if confirmation ~= 'confirm' then
        return CouponsAdminMenuApi.showVipCollection()
    end

    local response = lib.callback.await(COUPONS_CONFIG.CALLBACKS.REMOVE_VIP_COLLECTION, false)

    NotifyResult(response)
    CouponsAdminMenuApi.showVipCollection()
end

function CouponsAdminMenuApi.create()
    local payload = InputCoupon(nil, CouponsAdminMenuApi.showHome)

    if not payload then
        return
    end

    local response = lib.callback.await(COUPONS_CONFIG.CALLBACKS.CREATE, false, payload)

    if NotifyResult(response) then
        return CouponsAdminMenuApi.showList()
    end

    CouponsAdminMenuApi.showHome()
end

---@param coupon HudCouponAdminDto
function CouponsAdminMenuApi.edit(coupon)
    local payload = InputCoupon(coupon, function()
        CouponsAdminMenuApi.showActions(coupon)
    end)

    if not payload then
        return
    end

    local response = lib.callback.await(COUPONS_CONFIG.CALLBACKS.UPDATE, false, coupon.id, payload)

    if NotifyResult(response) and response.data then
        CouponsAdminMenuApi.showActions(response.data)
        return
    end

    CouponsAdminMenuApi.showActions(coupon)
end

---@param coupon HudCouponAdminDto
function CouponsAdminMenuApi.toggleStatus(coupon)
    local response = lib.callback.await(COUPONS_CONFIG.CALLBACKS.UPDATE_STATUS, false, coupon.id, not coupon.isActive)

    if NotifyResult(response) and response.data then
        CouponsAdminMenuApi.showActions(response.data)
        return
    end

    CouponsAdminMenuApi.showActions(coupon)
end

---@param coupon HudCouponAdminDto
function CouponsAdminMenuApi.remove(coupon)
    local confirmation = lib.alertDialog({
        header = _t('coupons.dialog.remove.header'),
        content = _t('coupons.dialog.remove.content'):format(coupon.code),
        centered = true,
        cancel = true,
    })

    if confirmation ~= 'confirm' then
        CouponsAdminMenuApi.showActions(coupon)
        return
    end

    local response = lib.callback.await(COUPONS_CONFIG.CALLBACKS.REMOVE, false, coupon.id)

    if NotifyResult(response) then
        return CouponsAdminMenuApi.showCategory(coupon.category)
    end

    CouponsAdminMenuApi.showActions(coupon)
end

lib.callback.register(COUPONS_CONFIG.CALLBACKS.OPEN_ADMIN, function()
    CouponsAdminMenuApi.showHome()

    return true
end)
