PenthouseClient = class()

function PenthouseClient:__init()
    self.currentBuildingId = nil
    self.currentEnterLocation = nil
    self.insideHouseData = {}
    self.ui = PenthouseUI()
    self.interactions = PenthouseInteractions(self)
    self.previewingWallpaper = false
end

---@return void
function PenthouseClient:initialize()
    self.interactions:setup()
end

---@param buildingId number
---@param locationId number
---@return void
function PenthouseClient:setCurrentLocation(buildingId, locationId)
    self.currentBuildingId = buildingId
    self.currentEnterLocation = locationId
end

---@return table|nil
function PenthouseClient:getCurrentLocation()
    return {
        buildingId = self.currentBuildingId,
        locationId = self.currentEnterLocation
    }
end

---@return boolean
function PenthouseClient:isInsidePenthouse()
    return self.insideHouseData ~= nil
        and self.insideHouseData.penthouse ~= nil
        and self.insideHouseData.penthouse.id ~= nil
end

---@return table|nil
function PenthouseClient:getCurrentPenthouse()
    if not self:isInsidePenthouse() then
        return nil
    end
    return self.insideHouseData.penthouse
end

---@return number|nil
function PenthouseClient:getCurrentPenthouseId()
    if not self:isInsidePenthouse() then
        return nil
    end
    return self.insideHouseData.penthouse.id
end

---@param data table
---@return void
function PenthouseClient:enterPenthouse(data)
    local penthouse, message = vSERVER.enterPenthouse(
        self.currentBuildingId,
        self.currentEnterLocation,
        data
    )

    if not penthouse then
        return TriggerEvent('Notify', 'Warning', _t(message))
    end
end

function PenthouseClient:showEditTooltip(penthouse)
    print('called showEditTooltip')
    if (not penthouse.isOwner) then
        return print('not owner')
    end

    if (self.tooltipLoop) then
        return print('tooltip loop')
    end

    self.tooltipLoop = true
    CreateThread(function()
        self.tooltip = false
        repeat
            local coord = config.interiors[penthouse.interior].entrance
            local dist = #(GetEntityCoords(PlayerPedId()) - vec3(coord.x, coord.y, coord.z))

            if (dist <= 5.0) then
                if (IsControlJustPressed(0, 47)) then
                    ExecuteCommand(translations[language]['settings_command'])
                end

                -- if (IsControlJustPressed(0, 185)) then
                --     SendNUIMessage({
                --         action = 'PENTHOUSE_SHOWWALLPAPERS',
                --         data = {
                --             visible = true,
                --             houseId = penthouse.interior
                --         }
                --     })
                --     SetNuiFocus(true, true)
                -- end
            end

            if (dist <= 5.0 and not self.tooltip) then
                SendNUIMessage({
                    action = 'PENTHOUSE_SHOWACTIONS',
                    data = {
                        {

                            key = 'G',
                            text = translations[language]['open_penthouse_settings']
                        },
                        -- {

                        --     key = 'F',
                        --     text = translations[language]['open_wallpaper_shop']
                        -- }
                    }
                })

                self.tooltip = true
            end

            if (dist > 5.0 and self.tooltip) then
                SendNUIMessage({
                    action = 'PENTHOUSE_SHOWACTIONS'
                })

                self.tooltip = false
            end

            Wait(1)
        until not self:isInsidePenthouse()

        self.tooltipLoop = false

        SendNUIMessage({
            action = 'PENTHOUSE_SHOWACTIONS'
        })
    end)
end

---@param penthouse table
---@return void
function PenthouseClient:setInsidePenthouse(penthouse)
    local interior_id = penthouse.interior
    local tier = penthouse.tier
    local name = penthouse.name

    local interior = interiors(interior_id, tier)
    local success, message = interior:load()

    if not success then
        print(message)
        return
    end

    self.ui:hideElevator()

    local ped = PlayerPedId()

    self.insideHouseData.interior = success
    self.insideHouseData.oldCoords = GetEntityCoords(ped)
    self.insideHouseData.penthouse = penthouse

    local colored, colorMessage = interior:setColor(penthouse.color or 1)

    if not colored and colorMessage then
        print(colorMessage)
    end

    local config = config.interiors[interior_id]
    local x, y, z, w = config.entrance.x, config.entrance.y, config.entrance.z, config.entrance.w

    SetEntityCoords(ped, x, y, z)
    SetEntityHeading(ped, w)

    DoScreenFadeOut(1)
    Wait(1000)
    DoScreenFadeIn(1)

    self:setupExitInteraction(interior_id, penthouse, name)
    self:showEditTooltip(penthouse)

    TriggerEvent('Notify', 'Attention', ('Você entrou na penthouse: %s'):format(name), 5000)
end

---@param interior_id number
---@param penthouse table
---@param name string
---@return void
function PenthouseClient:setupExitInteraction(interior_id, penthouse, name)
    if self.insideHouseData.entrance_interaction then
        interact.removeById(self.insideHouseData.entrance_interaction)
    end

    self.insideHouseData.entrance_interaction = ('entrance:%s'):format(interior_id)

    local config = config.interiors[interior_id]
    local x, y, z = config.entrance.x, config.entrance.y, config.entrance.z

    interact.addCoords({
        id = self.insideHouseData.entrance_interaction,
        coords = vec3(x, y, z),
        options = {
            {
                label = translations[language]['exit'],
                icon = 'code-fork',
                onSelect = function()
                    self:leavePenthouse(interior_id, penthouse, name)
                end,
                canInteract = function(entity, distance, coords, id)
                    if self:isPreviewingWallpaper() then
                        return false
                    end

                    return true
                end
            }
        },
        renderDistance = 7.5,
        activeDistance = 1.5,
        cooldown = 1500
    })
end

---@param interior_id number
---@param penthouse table
---@param name string
---@return void
function PenthouseClient:leavePenthouse(interior_id, penthouse, name)
    local result = vSERVER.leavePenthouse(interior_id, penthouse)

    if not result then return end

    local ped = PlayerPedId()

    TriggerEvent('Notify', 'Attention', ('Você saiu da penthouse: %s'):format(name), 5000)

    if self.insideHouseData.oldCoords then
        SetEntityCoords(
            ped,
            self.insideHouseData.oldCoords.x,
            self.insideHouseData.oldCoords.y,
            self.insideHouseData.oldCoords.z
        )
    end

    if self.insideHouseData.interior then
        self.insideHouseData.interior:unload()
    end

    if self.insideHouseData.entrance_interaction then
        interact.removeById(self.insideHouseData.entrance_interaction)
    end

    self.insideHouseData = {}
    self.currentBuildingId = nil
    self.currentEnterLocation = nil
end

---@param data table
---@return boolean
function PenthouseClient:startPropertyTour(data)
    local id = data.property.id
    local property = config.interiors[id]

    if not property then
        return false
    end

    local propertyTour = tour(id)
    propertyTour:start()

    return true
end

function PenthouseClient:isPreviewingWallpaper()
    return self.previewingWallpaper
end

function PenthouseClient:visualizeWallpaper(data)
    if not data then return false end

    if self.previewingWallpaper then
        return
    end

    self.previewingWallpaper = true

    local houseId = data.houseId or (self.insideHouseData.penthouse and self.insideHouseData.penthouse.interior)
    local wallpaperId = data.wallpaperId or data.id

    if not houseId or not wallpaperId then
        return false
    end

    local interior = interiors(houseId, 1)
    local success, message = interior:load()

    if not success then
        print(message)
        return false
    end

    self.previewOriginalColors = self.previewOriginalColors or {}
    local currentColor = self:getPenthouseColor(houseId) or 1
    self.previewOriginalColors[houseId] = currentColor

    local applied, applyMessage = interior:setColor(wallpaperId)

    if not applied then
        if applyMessage then
            print(applyMessage)
        end
        return false
    end

    local previewer = tour(houseId)
    previewer:wallpaperTour(function()
        local revertColor = currentColor

        if self.previewOriginalColors and self.previewOriginalColors[houseId] ~= nil then
            revertColor = self.previewOriginalColors[houseId]
            self.previewOriginalColors[houseId] = nil
        end

        local revertSuccess, revertMessage = interior:setColor(revertColor or 1)

        if not revertSuccess and revertMessage then
            print(revertMessage)
        end

        if self.insideHouseData
            and self.insideHouseData.penthouse
            and self.insideHouseData.penthouse.interior == houseId then
            self.insideHouseData.penthouse.color = revertColor or self.insideHouseData.penthouse.color
        end

        self.previewingWallpaper = false
    end)

    return true
end

function PenthouseClient:getPenthouseColor(houseId)
    if not self.insideHouseData or not self.insideHouseData.penthouse then
        return nil
    end

    local penthouse = self.insideHouseData.penthouse

    if penthouse.interior ~= houseId then
        return penthouse.color or 1
    end

    return penthouse.color or 1
end

---@param data table
---@param visible boolean
---@return boolean
function PenthouseClient:editPenthouse(data, visible)
    if visible then
        local penthouse, isOwner = vSERVER.getPenthouseData(data.penthouse.id)

        if penthouse and isOwner then
            penthouse.accessType = accessTypesEnum[penthouse.accessType]
            penthouse.level = config.interiors[penthouse.interior].level

            print('penthouse.interior: ' .. penthouse.interior)
            print('penthouse.level: ' .. penthouse.level)

            self.ui:showEditPenthouse(true, penthouse)
        end
    else
        self.ui:showEditPenthouse(false, nil)
    end

    return true
end

---@param data table
---@return boolean
function PenthouseClient:savePenthouseSettings(data)
    TriggerServerEvent('penthouse.server:savePenthouseSettings', data)
    return true
end

---@param visible boolean
---@param data table|nil
---@return void
function PenthouseClient:showDoorbellModal(visible, data)
    self.ui:showDoorbellModal(visible, data)
end

CreateThread(function()
    local ped = PlayerPedId()
    -- SetEntityCoords(ped, -599.11, 49.43, 43.63)
end)
