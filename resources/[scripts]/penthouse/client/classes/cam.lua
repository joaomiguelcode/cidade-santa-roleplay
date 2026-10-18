cam = class()

---@param id number
function cam:__init(id, onFinish)
    self.id       = id
    self.property = config.interiors[id]
    self.splines  = self.property.tour.splines
    self.active   = true
    self.camera   = nil

    self:transition(onFinish)

    activeCam = self
end

---@return boolean, string
function cam:destroy()
    self.active = false

    RenderScriptCams(false, false, 0, 1, 0)
    DestroyAllCams(true)

    DoScreenFadeIn(500)

    return true, 'cam destroyed'
end

---@return boolean, number, boolean
function cam:hasTransitionEnded()
    local currentTime = GetGameTimer()

    if (self.spline == #self.splines + 1) then
        return true, self.spline, true
    end

    if (currentTime >= self.nextSplineStartTime) then
        self.nextSplineStartTime = currentTime + self.splines[self.spline].interval

        if (self.spline <= #self.splines) then
            self.spline = self.spline + 1
        end

        DoScreenFadeOut(1)

        return true, self.spline, false
    end

    return false, self.spline, false
end

---@param spline number
---@return boolean, string
function cam:createSpline(spline)
    if (not self.splines[spline]) then
        return false, 'spline not found'
    end

    DoScreenFadeIn(500)

    if (self.camera) then
        DestroyCam(self.camera, true)
        self.camera = nil
    end

    RenderScriptCams(false, false, 0, 1, 0)
    DestroyAllCams(true)

    self.camera = CreateCam('DEFAULT_SPLINE_CAMERA', true)

    SetCamCoord(self.camera, self.splines[spline].from.x, self.splines[spline].from.y, self.splines[spline].from.z)
    PointCamAtCoord(self.camera, self.splines[spline].center.x, self.splines[spline].center.y,
        self.splines[spline].center.z)
    AddCamSplineNode(self.camera, self.splines[spline].from.x, self.splines[spline].from.y, self.splines[spline].from.z,
        0.0, 0.0, 0.0, 1, 1, 1)
    AddCamSplineNode(self.camera, self.splines[spline].to.x, self.splines[spline].to.y, self.splines[spline].to.z, 0.0,
        0.0, 0.0, 1, 1, 1)
    SetCamSplineDuration(self.camera, self.splines[spline].interval)
    RenderScriptCams(true, true, 1, false, true)

    return true, 'spline created'
end

---@return void
function cam:transition(onFinish)
    self.spline = 1
    self.nextSplineStartTime = GetGameTimer() + self.splines[self.spline].interval

    self:createSpline(self.spline)

    CreateThread(function()
        while self.active do
            local ended, spline, last = self:hasTransitionEnded()

            if (last) then
                self:destroy()

                if (activeTour) then
                    activeTour.visiting = true
                end

                if (onFinish) then
                    onFinish()
                end
                return
            end

            if (ended) then
                self:createSpline(spline)
            end

            Wait(1)
        end
    end)
end

CreateThread(function()
    DoScreenFadeIn(500)

    TriggerEvent('Notify:Text', '')
end)
