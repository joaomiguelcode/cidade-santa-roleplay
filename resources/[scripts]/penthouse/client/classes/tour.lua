tour = class()

activeTour = nil

---@param id number
function tour:__init(id)
    self.id        = id
    self.tier      = 1
    self.property  = config.interiors[id]
    self.ped       = PlayerPedId()

    local coords   = GetEntityCoords(self.ped)
    local x, y, z  = coords.x, coords.y, coords.z
    local w        = GetEntityHeading(self.ped)

    self.oldCoords = vec4(x, y, z, w)

    if (not self.property) then
        return false
    end

    self.visiting = false
    self.tour     = false
end

---@return void
function tour:actions()
    CreateThread(function()
        TriggerEvent("Notify:Text", translations[language]['tour']['visit'])

        while not self.visiting do
            if (IsControlJustPressed(0, 38)) then
                self.visiting = true
                TriggerEvent('Notify:Text', '')
                activeCam:destroy()
            end

            Wait(1)
        end

        TriggerEvent("Notify:Text", translations[language]['tour']['exit_visit'])

        while self.visiting do
            if (IsControlJustPressed(0, 38) or GetEntityHealth(self.ped) <= 101) then
                self.visiting = false
                TriggerEvent('Notify:Text', '')

                self:stop()
            end

            Wait(1)
        end
    end)
end

---@return void
function tour:start()
    activeTour = self

    self.tour = true

    local spawn = self.property.tour.spawn

    setRealEstateMenuVisible(false)

    DoScreenFadeOut(1)
    Wait(1000)

    SetEntityCoords(self.ped, spawn.x, spawn.y, spawn.z)
    SetEntityHeading(self.ped, spawn.w)

    local success, message = interiors(self.id, self.tier):load()

    if (not success) then
        return print(message)
    end

    NetworkStartSoloTutorialSession()

    self:actions()

    self.cam = cam(self.id)
end

---@return void
function tour:stop()
    activeCam:destroy()
    activeTour    = nil

    self.tour     = false
    self.visiting = false

    DoScreenFadeIn(1000)

    SetEntityCoords(self.ped, self.oldCoords.x, self.oldCoords.y, self.oldCoords.z)
    SetEntityHeading(self.ped, self.oldCoords.w)

    TriggerEvent('Notify:Text', '')

    NetworkEndTutorialSession()

    local interior = interiors(self.id, self.tier)

    interior:unload()
end

function tour:stopWallpaperTour()
    self.cam:destroy()
    self.tour = false
    activeTour = nil
    print('wallpaper tour stopped')
end


function tour:tourActions()
    self.tour = true

    TriggerEvent("Notify:Text", translations[language]['tour']['exit_wallpaper_tour'])

    CreateThread(function()
        repeat
            -- press E
            if (IsControlJustPressed(0, 38)) then
                self.tour = false
                TriggerEvent('Notify:Text', '')

                self:stopWallpaperTour()
            end


            Wait(1)
        until not self.tour

        if (self.onPreviewEnd) then
            self.onPreviewEnd()
        end

        print('tour stopped')
    end)
end

function tour:wallpaperTour(onPreviewEnd)
    if (activeTour) then
        return
    end

    activeTour = self

    self.onPreviewEnd = onPreviewEnd
    self:tourActions()

    self.cam = cam(self.id, function()
        self.tour = false
        TriggerEvent('Notify:Text', '')

        self:stopWallpaperTour()
    end)
end