camera = class()

function camera:__init()
    self.cameras = {}
    self.active = false
    self.camera = nil
end


function camera:create(id, pointAtEntity)
    if (DoesCamExist(self.cam))  then
        RenderScriptCams(false,false,0,1,0)
        DestroyAllCams(true)
    end

    self.camera = id

    if (not config.cameras[self.camera]) then
        return
    end

    local start = config.cameras[self.camera].start
    local nodes = config.cameras[self.camera].nodes
    local transitionSpeed = config.cameras[self.camera].transitionSpeed or 1000
    local fov = config.cameras[self.camera].fov

    self.cam = CreateCam('DEFAULT_SPLINE_CAMERA', true)

    SetCamFov(self.cam, fov)

    SetCamCoord(self.cam, start.x, start.y - 1.0, start.z + 1.0)

    if pointAtEntity then
        PointCamAtEntity(self.cam, pointAtEntity)
    else
        PointCamAtCoord(self.cam, start.x, start.y, start.z)
    end
    AddCamSplineNode(self.cam, start.x, start.y, start.z, 0.0, 0.0, 0.0, transitionSpeed, 50, 1)
    for _, coord in pairs(nodes) do
        AddCamSplineNode(self.cam, coord.x, coord.y, coord.z, 0.0, 0.0, 0.0, transitionSpeed, 50, 1)
    end
end

function camera:transition(shouldRenderTooltip, showDistance)
    if not self.cam then
        -- print('Camera not created. Call create() first.')
        return
    end

    RenderScriptCams(true, true, 1, false, true)

    repeat
        if (shouldRenderTooltip) then
            tooltip.render(shouldRenderTooltip, showDistance)
        end

        Wait(1)
    until GetCamSplinePhase(self.cam) == 1.0

    RenderScriptCams(false,false,0,1,0)
    DestroyCam(self.cam)
    DestroyAllCams(true)

    if (self.camera == 1) then
        SetGameplayCamRelativeHeading(0.0)
    end


    self.cam = nil
    self.active = false

end


function camera:destroy()
    if (DoesCamExist(self.cam))  then
        RenderScriptCams(false,false,0,1,0)
        DestroyAllCams(true)
    end
end