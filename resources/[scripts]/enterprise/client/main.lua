---@class IEnterprise.SyncClientTable: IEnterprise.SyncClient
---@field interact_id string

---@class EnterPriseClass
---@field list table<number, IEnterprise.SyncClientTable>
---@field activeEnterprise number | nil id da empresa ativa ( vai servir para identificar a empresa que o jogador está atualmente )
EnterPriseClass = {
    list = {},
    farmPoints = {},
    activeEnterprise = nil
}

---@param enterprise_id number
local function RemoveFarmPoints(enterprise_id)
    if EnterPriseClass.farmPoints[enterprise_id] then
        for _, point in pairs(EnterPriseClass.farmPoints[enterprise_id]) do
            interact.removeById(point)
        end
    end
    EnterPriseClass.farmPoints[enterprise_id] = {}
end

---@param enterprise_id number
---@param position vector3
local function showInteract(enterprise_id, position)
    local options = {
        {
            label = "Abrir Painel",
            icon = "hand", -- Example simple FA icon name
            onSelect = function(data)
                lib.callback.await('enterprise/sleepless/interaction', false, 'open-enterprise', enterprise_id)
            end,
            canInteract = function(entity, distance, coords, id)
                return distance < 10.0 -- Example condition based on distance
            end
        },
        {
            label = WORKFLOW__DELIVERY.interactionName,
            icon = "hand",
            onSelect = function(data)
                TriggerServerEvent('enterprise/workflow_interaction', WORKFLOW__DELIVERY.index, enterprise_id)
            end,
            canInteract = function(entity, distance, coords, id)
                return distance < 10.0 -- Example condition based on distance
            end
        },
    }

    local interactId = ('enterprise:%s'):format(enterprise_id)

    interact.addCoords({
        id = interactId,
        coords = position,
        options = options,
        onEnter = function()
            RemoveFarmPoints(enterprise_id)
            ---@type IEnterPrise.WorkStation[]
            local polyzones = lib.callback.await('enterprise/sleepless/get-farm-points', false, enterprise_id)

            if not polyzones then
                return
            end
            
            for _, point in pairs(polyzones) do
                local center, radius = utils.calculatePolyzoneCenterAndRadius(point.points)

                if radius > 0 then
                    local index = #EnterPriseClass.farmPoints[enterprise_id] + 1
                    local interactionId = ('enterprise:%s:farm_location:%s'):format(enterprise_id, index)
                    table.insert(EnterPriseClass.farmPoints[enterprise_id], interactionId)

                    interact.addCoords({
                        id = interactionId,
                        coords = vector3(center.x, center.y, center.z + 1.0),
                        options = {
                            {
                                label = WORKFLOW__PREMIUM_FARM.interactionName,
                                icon = "hand",
                                onSelect = function(data)
                                    TriggerServerEvent('enterprise/workflow_interaction', WORKFLOW__PREMIUM_FARM.index,
                                        enterprise_id)
                                end
                            },
                            {
                                label = WORKFLOW__FARM.interactionName,
                                icon = "hand",
                                onSelect = function(data)
                                    TriggerServerEvent('enterprise/workflow_interaction', WORKFLOW__FARM.index, enterprise_id)
                                end
                            }
                        },
                        activeDistance = radius,
                        renderDistance = radius,
                        canInteract = function(entity, distance, coords, id)
                            return distance <= radius -- Usa o raio calculado da polyzone
                        end
                    })
                end
            end
        end,
        onExit = function()
        end,
    })

    return interactId
end

function EnterPriseClass:syncListeners()
    ---@param list table<number, table<string,string>>
    RegisterNetEvent('enterprise:sync-add-list', function(list)
        while GetResourceState('sleepless_interact') ~= 'started' do -- Espera o interact ser carregado.
            Wait(10)
        end

        for index, value in pairs(list) do
            local positionStr = utils.split(value[1], ',')
            local coords = vector3(
                utils.tonumber(positionStr[1]),
                utils.tonumber(positionStr[2]),
                utils.tonumber(positionStr[3])
            )

            local interact_id = showInteract(index, coords)
            self.list[index] = { position = coords, name = value[2], interact_id = interact_id }
        end
    end)

    ---@param list table
    RegisterNetEvent('enterprise:sync-remove-list', function(list)
        while GetResourceState('sleepless_interact') ~= 'started' do -- Espera o interact ser carregado.
            Wait(10)
        end

        for index, value in pairs(list) do
            local enterprise = self.list[value]

            if enterprise then
                interact.removeById(enterprise.interact_id)
                RemoveFarmPoints(value)
            end

            self.list[value] = nil
        end
    end)

    ---@param enterprise_id number
    RegisterNetEvent('enterprise:show-enterprise', function(enterprise_id)
        self.activeEnterprise = enterprise_id
        SendNUIMessage({ action = "toggle", data = { active = true, cid = enterprise_id } })
        SetNuiFocus(true, true)
    end)
end

CreateThread(function()
    EnterPriseClass:syncListeners()
    LocalPlayer.state:set('enterprise:ready', true, true)
end)

RegisterNetEvent('enterpise:choice-open-enterprise', function(data)
    local options = {}

    for _, enterprise in pairs(data) do
        table.insert(options, {
            title = enterprise.name,
            description = _t('enterprise_id_desc') .. ' ' .. tostring(enterprise.id),
            onSelect = function()
                lib.callback.await('enterprise/sleepless/interaction', false, 'open-enterprise', enterprise.id)
            end
        })
    end

    lib.registerContext({
        id = 'enterpise:choice-open-enterprise',
        title = _t('select_enterprise_title'),
        options = options,
    })

    lib.showContext('enterpise:choice-open-enterprise')
end)

-- RegisterCommand('test', function(source)
--     TriggerEvent("routes:NPCStart", 'North')
-- end)