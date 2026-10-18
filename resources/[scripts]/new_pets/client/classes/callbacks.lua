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
end

function callbacks:register()
    RegisterNUICallback(self.name, function(data, cb)
        if (self.cooldown) then
            if (not self.nextCall) then
                self.nextCall = 0
            end

            local elapsed = self.nextCall - GetGameTimer()

            if (elapsed > 0) then
                
                if (config.warnCooldown) then
                    TriggerEvent('Notify', 'error', _t('cooldown', elapsed / 1000), 5000)
                end

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

for name, data in pairs(nuiHandlers) do
    local callback = callbacks(name, data.handler, data.cooldown)

    callback:register()
end