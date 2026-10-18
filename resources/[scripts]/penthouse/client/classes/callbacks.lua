callbacks = class()

---@param shouldCloseAll boolean|nil
local function notifyRenewPropertySuccess(shouldCloseAll)
    if PenthouseManager and PenthouseManager.ui then
        if shouldCloseAll then
            PenthouseManager.ui:closeAll()
        else
            PenthouseManager.ui:hideElevator()
        end
    else
        SetNuiFocus(false, false)
    end

    TriggerEvent('Notify', 'Attention', translations[language]['renew_penthouse_success'], 5000)
end

handlers = {
    ['PENTHOUSE_OPENGEMSSTORE'] = {
        handler = function()
            if GetResourceState('new_hub') ~= 'started' or not PenthouseManager or not PenthouseManager.ui then
                return false
            end

            PenthouseManager.ui:closeAll()
            local success, opened = pcall(function()
                return exports.new_hub:OpenGemsStore('Penthouse')
            end)

            if not success or not opened then
                PenthouseManager.ui:showRealEstateMenu(true)
                return false
            end

            return true
        end,
        cooldown = 1000,
    },
    ['PENTHOUSE_CLOSEEDIT']          = {
        handler = function(data)
            SetNuiFocus(false, false)

            return true
        end,
        cooldown = 1000,
    },
    ['PENTHOUSE_CLOSEELEVATOR']      = {
        handler = function(data)
            SetNuiFocus(false, false)

            return true
        end,
        cooldown = 1000,
    },
    ['PENTHOUSE_RENEWPROPERTY'] = { 
        handler = function(data)
            local result = vSERVER.renewProperty(data.propertyId)

            if result and result.success then
                notifyRenewPropertySuccess()
            end

            return result
        end,
    },
    ['PENTHOUSE_RENEWCOVERAGE'] = { 
        handler = function(data)
            local result = vSERVER.renewProperty(data.houseId)

            if result and result.success then
                notifyRenewPropertySuccess(true)
            end

            return result
        end
    },
    ['PENTHOUSE_UPGRADECOVERAGE'] = { 
        handler = function(data)
            return vSERVER.renewProperty(tonumber(data.penthouseId), data.targetLevel)
        end
    },
    ['PENTHOUSE_BUYPROPERTY'] = {
        handler = function(data)
            return vSERVER.buyHouse(data.propertyId)
        end,
    },
    ['PENTHOUSE_VALIDATEUPGRADE'] = {
        handler = function(data)
            return vSERVER.validateUpgrade(data)
        end,
    },
    ['PENTHOUSE_GETMYPROPERTYS']     = {
        handler = function(data)
            local location = PenthouseManager:getCurrentLocation()
            local retval = vSERVER.getMyHouses(location.buildingId, location.locationId)

            return retval or {}
        end,
        cooldown = 1000,
    },
    ['PENTHOUSE_GETNEIGHBORS']       = {
        handler = function(data)
            local location = PenthouseManager:getCurrentLocation()
            local retval = vSERVER.getNeighbors(location.buildingId, location.locationId)
            return retval or {}
        end,
        cooldown = 1000,
    },
    ['PENTHOUSE_CLOSEHOME']          = {
        handler = function(data)
            SetNuiFocus(false, false)

            return true
        end,
        cooldown = 1000,
    },
    ['PENTHOUSE_GETHOME']            = {
        handler = function(data)
            return getProperties()
        end,
        cooldown = 1000,
    },
    ['PENTHOUSE_HOMETOUR']           = {
        handler = function(data)
            if PenthouseManager then
                return PenthouseManager:startPropertyTour(data)
            end
            return false
        end,
        cooldown = 1000,
    },
    ['PENTHOUSE_JOINPROPERTY']       = {
        handler = function(data)
            return enterPenthouse(data)
        end,
        cooldown = 1000,
    },
    ['PENTHOUSE_RINGDOORBELL']       = {
        handler = function(data)
            local success, err = vSERVER.ringDoorbell(data)

            if (not success) then
                print(err)
                TriggerEvent('Notify', 'error', translations[language]['ring_doorbell'][err], 15000)
            end

            return success
        end,
        cooldown = 1000,
    },
    ['PENTHOUSE_UPDATEHOUSENAME']    = {
        handler = function(data)
            return vSERVER.updateHouseName(data)
        end,
        cooldown = 1000,
    },
    ['PENTHOUSE_CALLHELP']           = {
        handler = function(data)
            return vSERVER.callHelp(data)
        end,
        cooldown = 1000,
    },
    ['requestEditPenthouse']         = {
        handler = function(data)
            return setEditPenthouse(data, true)
        end,
        cooldown = 1000,
    },
    ['PENTHOUSE_BANPLAYER']          = {
        handler = function(data)
            return vSERVER.banUser(data)
        end,
        cooldown = 1000,
    },
    ['PENTHOUSE_UNBANPLAYER']        = {
        handler = function(data)
            return vSERVER.unbanUser(data)
        end,
        cooldown = 1000,
    },
    ['PENTHOUSE_KICKPLAYER']         = {
        handler = function(data)
            local success, message = vSERVER.kickVisitor(data)

            return success
        end,
        cooldown = 1000,
    },
    ['PENTHOUSE_UPDATEACCESSTYPE']   = {
        handler = function(data)
            local success, message = vSERVER.updateAccessType(data)

            print(success, message)


            return success
        end,
        cooldown = 1000,
    },
    ['PENTHOUSE_UPDATEMAXVISITORS']  = {
        handler = function(data)
            return vSERVER.updateMaxVisitors(data)
        end,
        cooldown = 1000,
    },
    -- default theme callbacks
    ['getCityName']                  = {
        handler = function(data)
            return city
        end,
        cooldown = 1000,
    },
    ['getCityId']                    = {
        handler = function(data)
            return city
        end,
        cooldown = 1000,
    },
    ['PENTHOUSE_GETWALLPAPERS']      = {
        handler = function(data)
            return config.wallpapers
        end,
        cooldown = 1000,
    },
    ['PENTHOUSE_CLOSEWALLPAPERS']    = {
        handler = function(data)
            SetNuiFocus(false, false)

            return true
        end,
        cooldown = 1000,
    },
    ['PENTHOUSE_VISUALIZEWALLPAPER'] = {
        handler = function(data)
            PenthouseManager:visualizeWallpaper(data)
            SendNUIMessage({
                action = 'PENTHOUSE_SHOWACTIONS'
            })

            SendNUIMessage({
                action = 'PENTHOUSE_SHOWWALLPAPERS',
                data = {
                    visible = false
                }
            })
            SetNuiFocus(false, false)

            return true
        end,
        cooldown = 1000,
    },
    ['PENTHOUSE_OPENSTORE']          = {
        handler = function(data)
            SetPenthouseVersion()
            
            local penthouse = PenthouseManager:getCurrentPenthouse()
            
            SendNUIMessage({
                action = 'PENTHOUSE_SHOWWALLPAPERS',
                data = {
                    visible = true,
                    houseId = penthouse.interior
                }
            })
            
            SetNuiFocus(true, true)
            
            return true
        end,
        cooldown = 1000,
    }

}

---@param name string
---@param handler function
---@param cooldown number
---@param sound boolean
function callbacks:__init(name, handler, cooldown, sound)
    self.name     = name
    self.handler  = handler
    self.cooldown = cooldown or nil
    self.sound    = sound or nil
    self.debug    = true
end

---@return void
function callbacks:register()
    RegisterNUICallback(self.name, function(data, cb)
        if (self.debug) then
            -- print('callback: ' .. self.name)
        end

        if (self.cooldown) then
            if (not self.nextCall) then
                self.nextCall = 0
            end

            local elapsed = self.nextCall - GetGameTimer()

            if (elapsed > 0) then
                return cb(false)
            end

            self.nextCall = GetGameTimer() + self.cooldown
        end

        local retval = self.handler(data)

        if (self.sound) then
            PlaySoundFrontend(-1, self.sound[1], self.sound[2], 1)
        end

        cb(retval)
    end)
end

for name, data in pairs(handlers) do
    local callback = callbacks(name, data.handler, data.cooldown)

    callback:register()
end
