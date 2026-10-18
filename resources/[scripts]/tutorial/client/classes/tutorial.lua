tutorial = class()

repeat
    Wait(1)
until exports['tooltip']:wrappers()

tooltip = exports['tooltip']:wrappers()

steps = {
    walk = 1,
    jump = 2,
    crouch = 3,
    enter = 4,
    belt = 5,
    drive = 6
}

function tutorial:__init()
    self.active = false
    self.step = steps.walk
    self.objectModel = 'prop_barier_conc_01a'
    self.vehicleModel = 'elegy2'
    self.crouchClipset = GetHashKey('move_ped_crouched')
    self.object = nil
    self.vehicle = nil
    self.oldCoords = nil

    self.completed = {
        walk = false,
        jump = false,
        crouch = false,
        enter = false,
        belt = false,
        drive = false
    }

    self:loadModels()
end

function tutorial:updateProgress()
    SendNUIMessage(
        {
            action = 'updateTutorialProgress',
            data = self.completed
        }
    )
end

function tutorial:loadModels()
    RequestModel(self.objectModel)
    RequestModel(self.vehicleModel)

    repeat
        Wait(1)
    until HasModelLoaded(self.objectModel) and HasModelLoaded(self.vehicleModel)
end

function tutorial:setVisible(bool)
    -- print(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({action = 'setVisible', data = bool})
    Wait(1000)
    SendNUIMessage({action = 'updateTutorialType', data = 'movement'})
end

function tutorial:start()
    DoScreenFadeOut(1)
    SetNuiFocus(false, false)

    self.oldCoords = GetEntityCoords(PlayerPedId())

    -- print('1')

    tooltip.setText(config.lang[lang].jump)

    -- print('2')

    local ped = PlayerPedId()
    local x, y, z, w = config.startCoords.x, config.startCoords.y, config.startCoords.z, config.startCoords.w

    SetEntityCoords(ped, x, y, z)
    SetEntityHeading(ped, w)
    FreezeEntityPosition(ped, false)

    Wait(2000)

    self.active = true

    self.object =
        CreateObject(
        self.objectModel,
        config.objectPosition.x,
        config.objectPosition.y,
        config.objectPosition.z,
        false,
        false
    )

    PlaceObjectOnGroundProperly(self.object)

    SetModelAsNoLongerNeeded(self.objectModel)

    DoScreenFadeIn(1000)

    CreateThread(
        function()
            while self.active do
                self:stepRoutine()
                Wait(0)
            end
        end
    )

    local camera = camera()
    camera:create(self.step, self.object)
    camera:transition()

    SetGameplayCamRelativeHeading(0.0)
    NetworkStartSoloTutorialSession()
end

function tutorial:getPlayerDistanceFromEntity()
    local ped = PlayerPedId()
    local playerCoords = GetEntityCoords(ped)
    local targetCoords = GetEntityCoords(self.object)
    return #(playerCoords - targetCoords)
end

function tutorial:handleWalk()
    local dist = self:getPlayerDistanceFromEntity()
    local targetCoords = GetEntityCoords(self.object)

    local toolTipCoords = vec3(targetCoords.x, targetCoords.y, targetCoords.z + 1.2)

    tooltip.render(toolTipCoords, 18.0)

    if dist < 5.0 and not self.completed.walk then
        self.completed.walk = true
        self:updateProgress()
        self.step = steps.jump
    end
end

function tutorial:handleJump()
    local dist = self:getPlayerDistanceFromEntity()
    local ped = PlayerPedId()

    local targetCoords = GetEntityCoords(self.object)
    local toolTipCoords = vec3(targetCoords.x, targetCoords.y, targetCoords.z + 1.2)

    tooltip.render(toolTipCoords, 15.0)

    if dist < 4.0 and not self.completed.jump then
        if IsPedClimbing(ped) then
            self.completed.jump = true
            self:updateProgress()

            self.step = steps.crouch

            tooltip.setText(config.lang[lang].crouch)

            SetTimeout(
                2000,
                function()
                    SetEntityDrawOutline(self.object, false)
                    DeleteEntity(self.object)
                    self.object = nil
                end
            )
        end
    else
        if self.object then
            SetEntityDrawOutline(self.object, true)
            SetEntityDrawOutlineColor(130, 178, 255, 50)
        end
    end
end

function tutorial:handleCrouch()
    local ped = PlayerPedId()
    local clipset = GetPedMovementClipset(ped)
    local crouched = (clipset == self.crouchClipset)

    DrawLine(
        config.laser.start.x,
        config.laser.start.y,
        config.laser.start.z + 0.4,
        config.laser.finish.x,
        config.laser.finish.y,
        config.laser.finish.z + 0.4,
        130,
        178,
        255,
        255
    )

    tooltip.render(vec3(config.laser.center.x, config.laser.center.y, config.laser.center.z), 15.0)

    local entity =
        detectEntityFromPointToPoint(
        vec3(config.laser.start.x, config.laser.start.y, config.laser.start.z),
        vec3(config.laser.finish.x, config.laser.finish.y, config.laser.finish.z)
    )

    if crouched and entity == ped and not self.completed.crouch then
        self.completed.crouch = true
        self:updateProgress()
        self.step = steps.enter

        tooltip.setText(config.lang[lang].vehicle)

        DoScreenFadeOut(2000)

        Wait(2000)

        SetEntityCoords(
            PlayerPedId(),
            config.vehicleTaskStartPosition.x,
            config.vehicleTaskStartPosition.y,
            config.vehicleTaskStartPosition.z
        )
        SetEntityHeading(PlayerPedId(), config.vehicleTaskStartPosition.w)

        SendNUIMessage({action = 'updateTutorialType', data = 'car'})
        Wait(1000)

        self.vehicle =
            CreateVehicle(
            self.vehicleModel,
            config.vehicleSpawnPos.x,
            config.vehicleSpawnPos.y,
            config.vehicleSpawnPos.z,
            false,
            false
        )
        SetEntityHeading(self.vehicle, config.vehicleSpawnPos.w)
        SetGameplayCamRelativeHeading(0.0)

        SetModelAsNoLongerNeeded(self.vehicleModel)

        local camera = camera()
        camera:create(self.step, self.vehicle)
        Wait(1000)

        DoScreenFadeIn(2000)
        local vehCoords = GetEntityCoords(self.vehicle)
        camera:transition(vehCoords + vec3(0.0, 0.0, 1.5), 23.0)
    end
end

function tutorial:handleEnterVehicle()
    local vehCoords = GetEntityCoords(self.vehicle)
    local dist = #(GetEntityCoords(PlayerPedId()) - vehCoords)

    tooltip.render(vehCoords + vec3(0.0, 0.0, 0.7), 25.0)

    if (dist < 3.0) then
        if (not self.completed.enter and (GetVehiclePedIsIn(PlayerPedId()) == self.vehicle)) then
            self.completed.enter = true
            self.step = steps.belt
            self:updateProgress()

            SetNewWaypoint(config.driveToPoint.x, config.driveToPoint.y)
            self.checkpoints = {}
            for k, v in pairs(config.checkPoints) do
                local checkpoint = CreateCheckpoint(0, v.x, v.y, v.z - 1.0, v.x, v.y, v.z, 5.0, 3, 190, 252, 150, 0, 0)

                table.insert(self.checkpoints, {
                    checkpoint = checkpoint,
                    coord = vec3(v.x, v.y, v.z)
                })

                SetCheckpointCylinderHeight(checkpoint, 100.0, 2000.0, 5.0)
            end

            tooltip.setText(config.lang[lang].belt)

            CreateThread(
                function()
                    repeat
                        for index, data in ipairs(self.checkpoints) do
                            local checkpoint, coord = data.checkpoint, data.coord

                            local dist = #(GetEntityCoords(PlayerPedId()) - coord)

                            if (dist < 5.0) then
                                DeleteCheckpoint(checkpoint)

                                table.remove(self.checkpoints, index)

                                -- Provavelmente nao estaremos proximo de mais de 2 checkpoints ao mesmo tempo
                                -- entao vamos tentar novamente no proximo tick!
                                break
                            end
                        end

                        -- Nao precisamos validar posicao a cada frame!
                        Wait( 100 )
                    until #self.checkpoints == 0
                end
            )
        end
    end
end

function tutorial:handleBelt()
    local flag = GetPedConfigFlag(PlayerPedId(), 32)
    local vehCoords = GetEntityCoords(self.vehicle)

    tooltip.render(vec3(vehCoords.x, vehCoords.y, vehCoords.z + 0.8), 2.0)

    if (not self.completed.belt and not flag and (GetVehiclePedIsIn(PlayerPedId()) == self.vehicle)) then
        self.completed.belt = true
        self.step = steps.drive
        self:updateProgress()

        tooltip.setText(config.lang[lang].drive)
    end
end

function tutorial:handleDriveToPoint()
    local vehCoords = GetEntityCoords(self.vehicle)

    local x, y, z = config.driveToPoint.x, config.driveToPoint.y, config.driveToPoint.z

    tooltip.render(vec3(x, y, z), 500.0)

    if (not self.completed.drive) then
        local dist = #(GetEntityCoords(PlayerPedId()) - vec3(x, y, z))

        if (dist < 2.0) then
            self.completed.drive = true

            self:updateProgress()

            self:setVisible(false)
        end
    end
end

function tutorial:actionsCompleted()
    for step, bool in pairs(self.completed) do
        if (not self.completed[step]) then
            return false
        end
    end
    return true
end

function tutorial:stepRoutine()
    if not self.active then
        return
    end

    if self.step == steps.walk then
        self:handleWalk()
    elseif self.step == steps.jump then
        self:handleJump()
    elseif self.step == steps.crouch then
        self:handleCrouch()
    elseif self.step == steps.enter then
        self:handleEnterVehicle()
    elseif self.step == steps.belt then
        self:handleBelt()
    elseif self.step == steps.drive then
        self:handleDriveToPoint()
    end

    local completed = self:actionsCompleted()

    if completed or IsControlJustPressed(0, 104) then
        camera:destroy()
        self.active = false
        self:updateProgress()
        NetworkEndTutorialSession()
        TriggerServerEvent('spawn:finishTutorial', completed)
        self:setVisible(false)

        if self.checkpoints then

            for _, checkpoint in ipairs(self.checkpoints) do

                DeleteCheckpoint(checkpoint.checkpoint)
            end

            self.checkpoints = nil
        end

        DoScreenFadeOut(2000)
        Wait(2000)

        FreezeEntityPosition(PlayerPedId(), true)

        SetEntityCoords(PlayerPedId(), self.oldCoords.x, self.oldCoords.y, self.oldCoords.z)

        DoScreenFadeIn(2000)
        Wait(2000)

        FreezeEntityPosition(PlayerPedId(), false)
    end
end

tutorial = tutorial()

setVisible = function(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({action = 'setVisible', data = bool})
end