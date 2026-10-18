handlers = {
    ['getHistory'] = {
        handler = function(data)
            return cache
        end
    },
    ['toggleAlerts'] = {
        handler = function(data)
            TriggerServerEvent('dispatch:toggleAlerts', data.enabled)
            return true
        end
    },
    ['getActionButtons'] = {
        handler = function(data)
            return sendConfigActionsToNui()
        end
    },
    ['deleteNotification'] = {
        handler = function(data)
            return deleteNotification(data)
        end
    },
    ['location'] = {
        handler = function(data)
            return markWaypoint(data)
        end
    },
    ['getCityName'] = {
        handler = function(data)
            return cityName
        end
    },
    ['getCityId'] = {
        handler = function(data)
            return cityName
        end
    },
    ['closeNotificationMenu'] = {
        handler = function(data)
            return closeNUI()
        end
    }
}


callbacks = class()

---@param name string
---@param handler function
---@param cooldown number
---@param sound boolean
function callbacks:__init(name, handler, cooldown, sound)
    self.name     = name
    self.handler  = handler
    self.cooldown = cooldown or nil
    self.sound    = sound or nil
    self.registered = {}

    print('callback', name, 'registered')

end

---@return void
function callbacks:register()
    if (self.registered[self.name]) then
        return print('callback', self.name, 'already registered')
    end

    RegisterNUICallback(self.name, function(data, cb)
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

    self.registered[self.name] = true
end

for name, data in pairs(handlers) do
    local callback = callbacks(name, data.handler, data.cooldown)

    callback:register()
end