PenthouseInteractions = class()

function PenthouseInteractions:__init(client)
    self.client = client
    self.interactions = {}
end

---@return void
function PenthouseInteractions:setup()
    self:setupBuyingLocations()
    self:setupEnteringLocations()
    self:setupDryVolumes()
end

---@return void
function PenthouseInteractions:setupBuyingLocations()
    for buildingId, buildingData in pairs(config.buildings) do
        local buyingLocations = buildingData.buyingLocations or {}

        for id, location in pairs(buyingLocations) do
            self:addBuyingInteraction(buildingId, id, location)
        end
    end
end

---@return void
function PenthouseInteractions:setupEnteringLocations()
    for buildingId, buildingData in pairs(config.buildings) do
        local enteringLocations = buildingData.enteringLocations or {}

        for id, location in pairs(enteringLocations) do
            self:addEnteringInteraction(buildingId, id, location)
        end
    end
end

---@return void
function PenthouseInteractions:setupDryVolumes()
    for _, interior in pairs(config.interiors) do
        for _, volume in pairs(interior.dry_volumes) do
            CreateDryVolume(
                volume.min.x,
                volume.min.y,
                volume.min.z,
                volume.max.x,
                volume.max.y,
                volume.max.z
            )
        end
    end
end

---@param buildingId number
---@param id number
---@param location vector4
---@return void
function PenthouseInteractions:addBuyingInteraction(buildingId, id, location)
    local interactId = ('penthouse_list:%s'):format(id)

    interact.addCoords({
        id = interactId,
        coords = vec3(location.x, location.y, location.z),
        options = {
            {
                label = translations[language]['open_penthouse_list'],
                icon = 'code-fork',
                onSelect = function()
                    self:onBuyingLocationSelect(buildingId, id)
                end,
            },
        },
        renderDistance = 7.5,
        activeDistance = 1.5,
        cooldown = 1500
    })

    self.interactions[interactId] = true
end

---@param buildingId number
---@param id number
---@param location vector4
---@return void
function PenthouseInteractions:addEnteringInteraction(buildingId, id, location)
    local interactId = ('penthouse_entering:%s'):format(id)

    interact.addCoords({
        id = interactId,
        coords = vec3(location.x, location.y, location.z),
        options = {
            {
                label = translations[language]['elevator_title'],
                icon = 'code-fork',
                onSelect = function()
                    self:onEnteringLocationSelect(buildingId, id)
                end,
            }
        },
        renderDistance = 7.5,
        activeDistance = 1.5,
        cooldown = 1500
    })

    self.interactions[interactId] = true
end

---@param buildingId number
---@param locationId number
---@return void
function PenthouseInteractions:onBuyingLocationSelect(buildingId, locationId)
    self.client:setCurrentLocation(buildingId, locationId)

    local serverConfig = vSERVER.getShopMenuConfig(buildingId, locationId)

    setPenthouseConfig(serverConfig)
    self.client.ui:showRealEstateMenu(true, 'properties')
end

---@param buildingId number
---@param locationId number
---@return void
function PenthouseInteractions:onEnteringLocationSelect(buildingId, locationId)
    self.client:setCurrentLocation(buildingId, locationId)
    self.client.ui:showElevator(true)
    SetNuiFocus(true, true)
end

---@param interactId string
---@return void
function PenthouseInteractions:removeInteraction(interactId)
    if self.interactions[interactId] then
        interact.removeById(interactId)
        self.interactions[interactId] = nil
    end
end

---@return void
function PenthouseInteractions:removeAll()
    for interactId, _ in pairs(self.interactions) do
        interact.removeById(interactId)
    end
    self.interactions = {}
end

---@return table
function PenthouseInteractions:getAllInteractions()
    return self.interactions
end
