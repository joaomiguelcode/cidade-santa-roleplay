local CONTEXT_HOME = 'farmer_staffgang:home'
local CONTEXT_CREATE_TEMPLATE = 'farmer_staffgang:create_template'
local CONTEXT_EDIT_LIST = 'farmer_staffgang:edit_list'
local CONTEXT_DELETE_LIST = 'farmer_staffgang:delete_list'
local CONTEXT_FARM_ACTIONS = 'farmer_staffgang:farm_actions'
local CONTEXT_TEMPLATE_LIST = 'farmer_staffgang:template_list'
local CONTEXT_POINTS = 'farmer_staffgang:points'
local CONTEXT_POINT_ACTIONS = 'farmer_staffgang:point_actions'
local CONTEXT_SHOPS = 'farmer_staffgang:shops'
local CONTEXT_SHOP_FARM_LIST = 'farmer_staffgang:shop_farm_list'

---@class StaffGangApiForms
local StaffGangApiForms = {}

local function notify(message, notifyType)
    lib.notify({ title = _t('staffgang.title'), description = message, type = notifyType or 'inform' })
end

local function notifyResult(result)
    if not result then
        notify(_t('staffgang.generic.noServerResponse'), 'error')
        return false
    end

    notify(result.message or _t(result.ok and 'staffgang.generic.ok' or 'staffgang.generic.error'), result.ok and 'success' or 'error')

    return result.ok == true
end

local function handleCancel(onCancel)
    if onCancel then
        onCancel()
        return
    end

    StaffGangApiForms.showHome()
end

function StaffGangApiForms.showHome()
    lib.registerContext({
        id = CONTEXT_HOME,
        title = _t('staffgang.title'),
        options = {
            {
                title = _t('staffgang.home.create.title'),
                description = _t('staffgang.home.create.description'),
                icon = 'plus',
                onSelect = function()
                    lib.showContext(CONTEXT_CREATE_TEMPLATE)
                end,
            },
            {
                title = _t('staffgang.home.edit.title'),
                description = _t('staffgang.home.edit.description'),
                icon = 'pencil',
                onSelect = function()
                    StaffGangApiForms.showEditFarmList()
                end,
            },
            {
                title = _t('staffgang.home.delete.title'),
                description = _t('staffgang.home.delete.description'),
                icon = 'trash-2',
                onSelect = function()
                    StaffGangApiForms.showDeleteFarmList()
                end,
            },
            {
                title = _t('staffgang.home.shops.title'),
                description = _t('staffgang.home.shops.description'),
                icon = 'shopping-cart',
                onSelect = function()
                    StaffGangApiForms.showShopFarmList()
                end,
            },
        },
    })

    lib.showContext(CONTEXT_HOME)
end

local function farmHasShop(farm)
    return StaffgangTemplateHasShop(StaffgangGetFarmTemplate(farm.templateId))
end

local function getTemplateIcon(templateId, fallback)
    local template = StaffgangGetFarmTemplate(templateId)

    return template and template.icon or fallback
end

local function templateSupportsFarmMode(templateId)
    local template = StaffgangGetFarmTemplate(templateId)

    return template ~= nil
        and (template.mode ~= nil or template.activeTemplateId ~= nil or template.afkTemplateId ~= nil)
end

function StaffGangApiForms.showFarmList(contextId, title, onSelectFarm, filterFarm)
    local response = lib.callback.await('farmer:staffgang:list-farms', false)

    if not response or not response.ok then
        notifyResult(response)
        StaffGangApiForms.showHome()
        return
    end

    local farms = {}
    local options = {}

    for _, farm in ipairs(response.data or {}) do
        if not filterFarm or filterFarm(farm) then
            farms[#farms + 1] = farm
        end
    end

    if #farms == 0 then
        options[#options + 1] = {
            title = _t('staffgang.list.empty.title'),
            description = _t('staffgang.list.empty.description'),
            disabled = true,
        }
    end

    for _, farm in ipairs(farms) do
        options[#options + 1] = {
            title = ('[%d] %s - %s'):format(farm.id, farm.farmTypeLabel, farm.title),
            description = StaffGangApiForms.buildFarmDescription(farm),
            icon = getTemplateIcon(farm.templateId, 'sprout'),
            onSelect = function()
                onSelectFarm(farm)
            end,
        }
    end

    lib.registerContext({
        id = contextId,
        title = title,
        menu = CONTEXT_HOME,
        onBack = StaffGangApiForms.showHome,
        canShowTextFilter = true,
        options = options,
    })

    lib.showContext(contextId)
end

function StaffGangApiForms.showEditFarmList()
    StaffGangApiForms.showFarmList(CONTEXT_EDIT_LIST, _t('staffgang.home.edit.title'), function(farm)
        StaffGangApiForms.showFarmActions(farm)
    end)
end

function StaffGangApiForms.showDeleteFarmList()
    StaffGangApiForms.showFarmList(CONTEXT_DELETE_LIST, _t('staffgang.home.delete.title'), function(farm)
        StaffGangApiForms.confirmDisableFarm(farm)
    end)
end

function StaffGangApiForms.showShopFarmList()
    StaffGangApiForms.showFarmList(CONTEXT_SHOP_FARM_LIST, _t('staffgang.list.selectShopFarm'), function(farm)
        StaffGangApiForms.showShopMenu(farm, true)
    end, farmHasShop)
end

local function fetchFarmById(farmId)
    local response = lib.callback.await('farmer:staffgang:list-farms', false)

    if not response or not response.ok then
        notifyResult(response)
        return
    end

    for _, farm in ipairs(response.data or {}) do
        if tonumber(farm.id) == tonumber(farmId) then
            return farm
        end
    end

    notify(_t('staffgang.server.farmNotFound'), 'error')
end

function StaffGangApiForms.showUpdatedFarmActions(farmId)
    local farm = fetchFarmById(farmId)

    if not farm then
        StaffGangApiForms.showHome()
        return
    end

    StaffGangApiForms.showFarmActions(farm)
end

function StaffGangApiForms.showUpdatedPointsMenu(farmId)
    local farm = fetchFarmById(farmId)

    if not farm then
        StaffGangApiForms.showHome()
        return
    end

    StaffGangApiForms.showPointsMenu(farm)
end

function StaffGangApiForms.showUpdatedShopMenu(farmId, returnToShopFarmList)
    local farm = fetchFarmById(farmId)

    if not farm then
        StaffGangApiForms.showHome()
        return
    end

    StaffGangApiForms.showShopMenu(farm, returnToShopFarmList)
end

function StaffGangApiForms.buildFarmDescription(farm)
    local permissions = farm.allowedGroupsText ~= '' and farm.allowedGroupsText or _t('staffgang.generic.free')
    local description = farm.description ~= '' and farm.description or _t('staffgang.generic.noDescription')

    return _t('staffgang.farm.description'):format(
        description,
        permissions,
        farm.createdAt,
        farm.createdByName,
        tostring(farm.createdByCharacterId),
        tostring(farm.activePointsCount or 0),
        tostring(farm.activeShopsCount or 0)
    )
end

local function getPointTypeLabel(pointType)
    return pointType == 'polygon' and _t('staffgang.points.addPolyzone.title') or _t('staffgang.points.addCds.title')
end

local function formatTemplateItems(items, emptyText)
    if type(items) ~= 'table' or #items < 1 then
        return emptyText
    end

    local entries = {}

    local function addEntry(item)
        local itemId = type(item.item) == 'string' and item.item or item.id

        if not itemId then
            return
        end

        entries[#entries + 1] = {
            id = itemId,
            value = item.amount or item.price or item.value or 0,
        }
    end

    for _, item in ipairs(items) do
        if type(item.item) == 'table' then
            for _, reward in ipairs(item.item) do
                addEntry(reward)
            end
        else
            addEntry(item)
        end
    end

    if #entries < 1 then
        return emptyText
    end

    local parts = {}
    local limit = math.min(#entries, 3)

    for index = 1, limit do
        local item = entries[index]

        parts[#parts + 1] = ('%s=%s'):format(item.id, tostring(item.value))
    end

    if #entries > limit then
        parts[#parts + 1] = ('+%d'):format(#entries - limit)
    end

    return table.concat(parts, ', ')
end

local function buildTemplateDescription(template, intro)
    local shop = template.shop or {}
    local rewards = formatTemplateItems(template.rewards, _t('staffgang.generic.noRewards'))
    local shopItems = formatTemplateItems(shop.items, _t('staffgang.generic.notAvailable'))

    return ('%s\n%s: %s\n%s: %s\n%s: %s'):format(
        intro,
        _t('staffgang.actions.points.title'),
        getPointTypeLabel(template.pointType),
        _t('staffgang.template.summary.rewards'),
        rewards,
        _t('staffgang.actions.shops.title'),
        shopItems
    )
end

local function getCurrentCoordsText()
    local coords = GetEntityCoords(PlayerPedId())

    return ('%.3f,%.3f,%.3f'):format(coords.x, coords.y, coords.z)
end

local function parseCoordinatesInput(value)
    local values = {}

    for rawValue in tostring(value or ''):gmatch('[^,]+') do
        values[#values + 1] = tonumber(rawValue)
    end

    if #values ~= 3 or not values[1] or not values[2] or not values[3] then
        return
    end

    return {
        x = tonumber(('%0.3f'):format(values[1])),
        y = tonumber(('%0.3f'):format(values[2])),
        z = tonumber(('%0.3f'):format(values[3])),
    }
end

local function inputBaseFarmData(initialData, includeAllowedGroups, onCancel, includeFarmMode, allowedGroupsRequired)
    local fields = {
        {
            type = 'input',
            label = _t('staffgang.field.title'),
            required = true,
            default = initialData and initialData.title or '',
        },
        {
            type = 'input',
            label = _t('staffgang.field.shopTitle'),
            description = _t('staffgang.field.shopTitle.description'),
            max = 96,
            default = initialData and initialData.shopTitle or '',
        },
        {
            type = 'textarea',
            label = _t('staffgang.field.description'),
            default = initialData and initialData.description or '',
        },
    }

    local hasTaskInputIndex

    if includeFarmMode then
        hasTaskInputIndex = #fields + 1

        fields[#fields + 1] = {
            type = 'checkbox',
            label = _t('staffgang.field.hasTask'),
            description = _t('staffgang.field.hasTask.description'),
            checked = not initialData or initialData.isAfk ~= true,
        }
    end

    if includeAllowedGroups then
        fields[#fields + 1] = {
            type = 'input',
            label = _t('staffgang.field.allowedGroups'),
            description = allowedGroupsRequired
                and _t('staffgang.validation.allowedGroupsRequired')
                or _t('staffgang.field.allowedGroups.description'),
            placeholder = 'Vagos,Umbrella,Metgala',
            default = initialData and initialData.allowedGroupsText or '',
            required = allowedGroupsRequired == true,
        }
    end

    local input = lib.inputDialog(_t('staffgang.dialog.farmData.title'), fields)

    if not input then
        handleCancel(onCancel)
        return
    end

    local isAfk

    if hasTaskInputIndex then
        isAfk = input[hasTaskInputIndex] ~= true
    end

    return {
        title = input[1],
        shopTitle = input[2],
        description = input[3],
        isAfk = isAfk,
        allowedGroupsText = includeAllowedGroups and input[#input] or nil,
    }
end

local function inputFarmMode(initialData, onCancel)
    local input = lib.inputDialog(_t('staffgang.actions.editTemplate.title'), {
        {
            type = 'checkbox',
            label = _t('staffgang.field.hasTask'),
            description = _t('staffgang.field.hasTask.description'),
            checked = not initialData or initialData.isAfk ~= true,
        },
    })

    if not input then
        handleCancel(onCancel)
        return
    end

    return {
        isAfk = input[1] ~= true,
    }
end

local function drawPolyPreview(points)
    for index, point in ipairs(points) do
        DrawMarker(2, point.x, point.y, point.z + 0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, 46, 204, 113, 180, false, true, 2, nil, nil, false)

        local nextPoint = points[index + 1] or points[1]

        if nextPoint and #points > 1 then
            DrawLine(point.x, point.y, point.z + 0.1, nextPoint.x, nextPoint.y, nextPoint.z + 0.1, 46, 204, 113, 220)
        end
    end
end

local function clonePolyzoneVertices(vertices)
    local points = {}

    for _, vertex in ipairs(vertices or {}) do
        local x = tonumber(vertex.x)
        local y = tonumber(vertex.y)
        local z = tonumber(vertex.z or 0.0)

        if x and y and z then
            points[#points + 1] = {
                x = x,
                y = y,
                z = z,
            }
        end
    end

    return points
end

local function startPolyzoneEditor(initialVertices)
    local promiseHandle = promise.new()
    local points = clonePolyzoneVertices(initialVertices)

    lib.showTextUI(_t('staffgang.polyzone.controls'))

    CreateThread(function()
        while true do
            Wait(0)
            drawPolyPreview(points)

            if IsControlJustPressed(0, 38) then
                local coords = GetEntityCoords(PlayerPedId())

                points[#points + 1] = {
                    x = tonumber(('%0.3f'):format(coords.x)),
                    y = tonumber(('%0.3f'):format(coords.y)),
                    z = tonumber(('%0.3f'):format(coords.z)),
                }
            elseif IsControlJustPressed(0, 44) then
                points[#points] = nil
            elseif IsControlJustPressed(0, 191) then
                lib.hideTextUI()
                promiseHandle:resolve(points)
                return
            elseif IsControlJustPressed(0, 200) or IsControlJustPressed(0, 322) then
                lib.hideTextUI()
                promiseHandle:resolve(nil)
                return
            end
        end
    end)

    return Citizen.Await(promiseHandle)
end

local function inputCoordinates(label, onCancel)
    local input = lib.inputDialog(label, {
        {
            type = 'input',
            label = _t('staffgang.field.coordinates'),
            description = _t('staffgang.field.coordinates.description'),
            placeholder = '30.232,40.032,50.032',
            default = getCurrentCoordsText(),
            required = true,
        },
    })

    if not input then
        handleCancel(onCancel)
        return
    end

    local position = parseCoordinatesInput(input[1])

    if not position then
        notify(_t('staffgang.validation.coordinatesInvalid'), 'error')
        handleCancel(onCancel)
        return
    end

    return {
        position = position,
    }
end

local function collectPointPayload(pointType, initialVertices, onCancel)
    if pointType == 'polygon' then
        local vertices = startPolyzoneEditor(initialVertices)

        if not vertices then
            handleCancel(onCancel)
            return
        end

        return {
            vertices = vertices,
        }
    end

    return inputCoordinates(_t('staffgang.dialog.collectCds'), onCancel)
end

local function startCreateFarm(templateId)
    local template = StaffgangGetFarmTemplate(templateId)

    if not template then
        notify(_t('staffgang.validation.templateInvalid'), 'error')
        StaffGangApiForms.showHome()
        return
    end

    local baseData = inputBaseFarmData(
        nil,
        true,
        nil,
        templateSupportsFarmMode(templateId),
        StaffgangTemplateRequiresAllowedGroups(template)
    )

    if not baseData then
        return
    end

    local pointPayload = collectPointPayload(template.pointType)

    if not pointPayload then
        return
    end

    local response = lib.callback.await('farmer:staffgang:create-farm', false, {
        templateId = templateId,
        title = baseData.title,
        shopTitle = baseData.shopTitle,
        description = baseData.description,
        allowedGroupsText = baseData.allowedGroupsText,
        isAfk = baseData.isAfk,
        point = pointPayload,
    })

    notifyResult(response)
    StaffGangApiForms.showHome()
end

local function registerCreateTemplateContext()
    local options = {}

    for _, templateId in ipairs(STAFFGANG_FARM_TEMPLATE_ORDER) do
        local data = STAFFGANG_FARM_TEMPLATES[templateId]

        if not data.isHidden then
            options[#options + 1] = {
                title = data.label,
                description = buildTemplateDescription(data, _t('staffgang.create.template.description'):format(data.label)),
                icon = data.icon,
                onSelect = function()
                    startCreateFarm(templateId)
                end,
            }
        end

    end

    lib.registerContext({
        id = CONTEXT_CREATE_TEMPLATE,
        title = _t('staffgang.home.create.title'),
        menu = CONTEXT_HOME,
        onBack = StaffGangApiForms.showHome,
        canShowTextFilter = true,
        options = options,
    })
end

function StaffGangApiForms.showFarmActions(farm)
    local options = {
        {
            title = _t('staffgang.actions.editData.title'),
            description = _t('staffgang.actions.editData.description'),
            icon = 'text-cursor-input',
            onSelect = function()
                StaffGangApiForms.editFarmData(farm)
            end,
        },
        {
            title = _t('staffgang.actions.editTemplate.title'),
            description = _t('staffgang.actions.editTemplate.description'):format(farm.farmTypeLabel),
            icon = 'layout-template',
            onSelect = function()
                StaffGangApiForms.showTemplateMenu(farm)
            end,
        },
        {
            title = _t('staffgang.actions.editAccess.title'),
            description = farm.allowedGroupsText ~= '' and farm.allowedGroupsText or _t('staffgang.generic.free'),
            icon = 'shield',
            onSelect = function()
                StaffGangApiForms.editFarmAccess(farm)
            end,
        },
        {
            title = _t('staffgang.actions.points.title'),
            description = _t('staffgang.actions.points.description'):format(tostring(farm.activePointsCount or 0)),
            icon = 'map-pinned',
            onSelect = function()
                StaffGangApiForms.showPointsMenu(farm)
            end,
        },
    }

    if farmHasShop(farm) then
        options[#options + 1] = {
            title = _t('staffgang.actions.shops.title'),
            description = _t('staffgang.actions.shops.description'):format(tostring(farm.activeShopsCount or 0)),
            icon = 'shopping-cart',
            onSelect = function()
                StaffGangApiForms.showShopMenu(farm, false)
            end,
        }
    end

    lib.registerContext({
        id = CONTEXT_FARM_ACTIONS,
        title = ('[%d] %s'):format(farm.id, farm.title),
        menu = CONTEXT_HOME,
        onBack = StaffGangApiForms.showHome,
        options = options,
    })

    lib.showContext(CONTEXT_FARM_ACTIONS)
end

function StaffGangApiForms.editFarmData(farm)
    local data = inputBaseFarmData({
        title = farm.title,
        shopTitle = farm.shopTitle,
        description = farm.description,
        isAfk = farm.isAfk,
    }, false, function()
        StaffGangApiForms.showFarmActions(farm)
    end, templateSupportsFarmMode(farm.templateId))

    if not data then
        return
    end

    local payload = {
        title = data.title,
        shopTitle = data.shopTitle,
        description = data.description,
        isAfk = data.isAfk,
    }

    local response = lib.callback.await('farmer:staffgang:update-farm-data', false, farm.id, payload)

    if notifyResult(response) then
        StaffGangApiForms.showUpdatedFarmActions(farm.id)
        return
    end

    StaffGangApiForms.showFarmActions(farm)
end

function StaffGangApiForms.editFarmAccess(farm)
    local input = lib.inputDialog(_t('staffgang.field.allowedGroups'), {
        {
            type = 'input',
            label = _t('staffgang.field.allowedGroups'),
            description = farm.requiresAllowedGroups
                and _t('staffgang.validation.allowedGroupsRequired')
                or _t('staffgang.field.allowedGroups.description'),
            default = farm.allowedGroupsText,
            required = farm.requiresAllowedGroups == true,
        },
    })

    if not input then
        StaffGangApiForms.showFarmActions(farm)
        return
    end

    local response = lib.callback.await('farmer:staffgang:update-farm-access', false, farm.id, input[1])

    if notifyResult(response) then
        StaffGangApiForms.showUpdatedFarmActions(farm.id)
        return
    end

    StaffGangApiForms.showFarmActions(farm)
end

function StaffGangApiForms.showTemplateMenu(farm)
    local options = {}

    for _, templateId in ipairs(STAFFGANG_FARM_TEMPLATE_ORDER) do
        local template = STAFFGANG_FARM_TEMPLATES[templateId]

        if not template.isHidden then
            local isCurrentTemplate = farm.templateId == templateId
            local description = buildTemplateDescription(template, _t('staffgang.template.current'))

            if not isCurrentTemplate then
                description = buildTemplateDescription(
                    template,
                    _t('staffgang.template.change.description'):format(farm.farmTypeLabel, template.label)
                )
            end

            options[#options + 1] = {
                title = template.label,
                description = description,
                icon = template.icon,
                onSelect = function()
                    StaffGangApiForms.confirmUpdateFarmTemplate(farm, templateId)
                end,
            }
        end
    end

    lib.registerContext({
        id = CONTEXT_TEMPLATE_LIST,
        title = _t('staffgang.actions.editTemplate.title'),
        menu = CONTEXT_FARM_ACTIONS,
        onBack = function()
            StaffGangApiForms.showFarmActions(farm)
        end,
        canShowTextFilter = true,
        options = options,
    })

    lib.showContext(CONTEXT_TEMPLATE_LIST)
end

function StaffGangApiForms.confirmUpdateFarmTemplate(farm, templateId)
    local template = StaffgangGetFarmTemplate(templateId)

    if not template then
        notify(_t('staffgang.validation.templateInvalid'), 'error')
        StaffGangApiForms.showFarmActions(farm)
        return
    end

    if StaffgangTemplateRequiresAllowedGroups(template) and farm.allowedGroupsText == '' then
        notify(_t('staffgang.validation.allowedGroupsRequired'), 'error')
        StaffGangApiForms.showFarmActions(farm)
        return
    end

    local response = lib.alertDialog({
        header = _t('staffgang.template.change.header'),
        content = _t('staffgang.template.change.content'):format(farm.title, farm.farmTypeLabel, template.label),
        centered = true,
        cancel = true,
    })

    if response ~= 'confirm' then
        StaffGangApiForms.showFarmActions(farm)
        return
    end

    local farmMode

    if templateSupportsFarmMode(templateId) or templateSupportsFarmMode(farm.templateId) then
        farmMode = inputFarmMode(farm, function()
            StaffGangApiForms.showTemplateMenu(farm)
        end)

        if not farmMode then
            return
        end
    end

    local replacementPoint

    if farm.pointType ~= template.pointType or (farm.activePointsCount or 0) < 1 then
        replacementPoint = collectPointPayload(template.pointType, nil, function()
            StaffGangApiForms.showTemplateMenu(farm)
        end)

        if not replacementPoint then
            return
        end
    end

    local result = lib.callback.await('farmer:staffgang:update-farm-template', false, farm.id, templateId, replacementPoint, farmMode)

    if notifyResult(result) then
        StaffGangApiForms.showUpdatedFarmActions(farm.id)
        return
    end

    StaffGangApiForms.showTemplateMenu(farm)
end

function StaffGangApiForms.showPointsMenu(farm)
    local response = lib.callback.await('farmer:staffgang:list-points', false, farm.id)

    if not response or not response.ok then
        notifyResult(response)
        StaffGangApiForms.showHome()
        return
    end

    local options = {
        {
            title = farm.pointType == 'polygon' and _t('staffgang.points.addPolyzone.title') or _t('staffgang.points.addCds.title'),
            description = _t('staffgang.points.add.description'),
            icon = 'plus',
            onSelect = function()
                StaffGangApiForms.addPointToFarm(farm)
            end,
        },
    }

    for _, point in ipairs(response.data or {}) do
        local isPolygon = point.pointType == 'polygon'

        options[#options + 1] = {
            title = isPolygon and _t('staffgang.points.manage.title'):format(tostring(point.id)) or _t('staffgang.points.remove.title'):format(tostring(point.id)),
            description = point.pointType,
            icon = isPolygon and 'pentagon' or 'trash',
            onSelect = function()
                if isPolygon then
                    return StaffGangApiForms.showPointActions(farm, point)
                end
                StaffGangApiForms.confirmDeletePoint(farm, point)
            end,
        }
    end

    lib.registerContext({
        id = CONTEXT_POINTS,
        title = _t('staffgang.actions.points.title'),
        menu = CONTEXT_FARM_ACTIONS,
        onBack = function()
            StaffGangApiForms.showFarmActions(farm)
        end,
        canShowTextFilter = true,
        options = options,
    })

    lib.showContext(CONTEXT_POINTS)
end

function StaffGangApiForms.addPointToFarm(farm)
    local pointPayload = collectPointPayload(farm.pointType, nil, function()
        StaffGangApiForms.showPointsMenu(farm)
    end)

    if not pointPayload then
        return
    end

    local response = lib.callback.await('farmer:staffgang:create-point', false, farm.id, pointPayload)

    if notifyResult(response) then
        StaffGangApiForms.showUpdatedPointsMenu(farm.id)
        return
    end

    StaffGangApiForms.showPointsMenu(farm)
end

function StaffGangApiForms.showPointActions(farm, point)
    lib.registerContext({
        id = CONTEXT_POINT_ACTIONS,
        title = _t('staffgang.points.manage.title'):format(tostring(point.id)),
        menu = CONTEXT_POINTS,
        onBack = function()
            StaffGangApiForms.showPointsMenu(farm)
        end,
        options = {
            {
                title = _t('staffgang.points.editPolyzone.title'),
                description = _t('staffgang.points.editPolyzone.description'),
                icon = 'pen-line',
                onSelect = function()
                    StaffGangApiForms.editPolyzonePoint(farm, point)
                end,
            },
            {
                title = _t('staffgang.points.remove.title'):format(tostring(point.id)),
                description = _t('staffgang.points.remove.description'),
                icon = 'trash',
                onSelect = function()
                    StaffGangApiForms.confirmDeletePoint(farm, point)
                end,
            },
        },
    })

    lib.showContext(CONTEXT_POINT_ACTIONS)
end

function StaffGangApiForms.editPolyzonePoint(farm, point)
    local zoneDefinition = point.zoneDefinition or {}
    local pointPayload = collectPointPayload('polygon', zoneDefinition.vertices, function()
        StaffGangApiForms.showPointActions(farm, point)
    end)

    if not pointPayload then
        return
    end

    local response = lib.callback.await('farmer:staffgang:update-point', false, farm.id, point.id, pointPayload)

    if notifyResult(response) then
        StaffGangApiForms.showUpdatedPointsMenu(farm.id)
        return
    end

    StaffGangApiForms.showPointActions(farm, point)
end

function StaffGangApiForms.confirmDeletePoint(farm, point)
    local response = lib.alertDialog({
        header = _t('staffgang.points.remove.header'),
        content = _t('staffgang.points.remove.content'):format(tostring(point.id), farm.title),
        centered = true,
        cancel = true,
    })

    if response ~= 'confirm' then
        StaffGangApiForms.showPointsMenu(farm)
        return
    end

    local result = lib.callback.await('farmer:staffgang:delete-point', false, farm.id, point.id)

    if notifyResult(result) then
        StaffGangApiForms.showUpdatedPointsMenu(farm.id)
        return
    end

    StaffGangApiForms.showPointsMenu(farm)
end

function StaffGangApiForms.confirmDisableFarm(farm)
    local response = lib.alertDialog({
        header = _t('staffgang.farm.delete.header'),
        content = _t('staffgang.farm.delete.content'):format(farm.title),
        centered = true,
        cancel = true,
    })

    if response ~= 'confirm' then
        StaffGangApiForms.showDeleteFarmList()
        return
    end

    local result = lib.callback.await('farmer:staffgang:disable-farm', false, farm.id)

    if notifyResult(result) then
        StaffGangApiForms.showHome()
        return
    end

    StaffGangApiForms.showDeleteFarmList()
end

function StaffGangApiForms.showShopMenu(farm, returnToShopFarmList)
    if not farmHasShop(farm) then
        notify(_t('staffgang.validation.templateWithoutShop'), 'error')

        if returnToShopFarmList then
            StaffGangApiForms.showShopFarmList()
            return
        end

        StaffGangApiForms.showFarmActions(farm)
        return
    end

    local response = lib.callback.await('farmer:staffgang:list-shops', false, farm.id)

    if not response or not response.ok then
        notifyResult(response)
        if returnToShopFarmList then
            StaffGangApiForms.showShopFarmList()
            return
        end

        StaffGangApiForms.showFarmActions(farm)
        return
    end

    local options = {
        {
            title = _t('staffgang.shops.add.title'),
            description = _t('staffgang.shops.add.description'),
            icon = 'plus',
            onSelect = function()
                StaffGangApiForms.createShopForFarm(farm, returnToShopFarmList)
            end,
        },
    }

    for _, shop in ipairs(response.data or {}) do
        options[#options + 1] = {
            title = ('[%d] %s'):format(shop.id, shop.title),
            description = shop.description ~= '' and shop.description or _t('staffgang.generic.noDescription'),
            icon = 'shopping-cart',
            onSelect = function()
                StaffGangApiForms.confirmDisableShop(farm, shop, returnToShopFarmList)
            end,
        }
    end

    local parentContext = returnToShopFarmList and CONTEXT_SHOP_FARM_LIST or CONTEXT_FARM_ACTIONS

    lib.registerContext({
        id = CONTEXT_SHOPS,
        title = _t('staffgang.shops.menu.title'):format(farm.title),
        menu = parentContext,
        onBack = function()
            if returnToShopFarmList then
                StaffGangApiForms.showShopFarmList()
                return
            end

            StaffGangApiForms.showFarmActions(farm)
        end,
        canShowTextFilter = true,
        options = options,
    })

    lib.showContext(CONTEXT_SHOPS)
end

function StaffGangApiForms.createShopForFarm(farm, returnToShopFarmList)
    local positionPayload = inputCoordinates(_t('staffgang.dialog.collectShopCds'), function()
        StaffGangApiForms.showShopMenu(farm, returnToShopFarmList)
    end)

    if not positionPayload then
        return
    end

    local response = lib.callback.await('farmer:staffgang:create-shop', false, farm.id, positionPayload)

    if notifyResult(response) then
        StaffGangApiForms.showUpdatedShopMenu(farm.id, returnToShopFarmList)
        return
    end

    StaffGangApiForms.showShopMenu(farm, returnToShopFarmList)
end

function StaffGangApiForms.confirmDisableShop(farm, shop, returnToShopFarmList)
    local response = lib.alertDialog({
        header = _t('staffgang.shops.delete.header'),
        content = _t('staffgang.shops.delete.content'):format(shop.title),
        centered = true,
        cancel = true,
    })

    if response ~= 'confirm' then
        StaffGangApiForms.showShopMenu(farm, returnToShopFarmList)
        return
    end

    local result = lib.callback.await('farmer:staffgang:disable-shop', false, farm.id, shop.id)

    if notifyResult(result) then
        StaffGangApiForms.showUpdatedShopMenu(farm.id, returnToShopFarmList)
        return
    end

    StaffGangApiForms.showShopMenu(farm, returnToShopFarmList)
end

lib.callback.register('farmer:staffgang:open-menu', function()
    registerCreateTemplateContext()
    StaffGangApiForms.showHome()

    return true
end)
