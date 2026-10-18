print("^2[FAKE-CONTROL-PLAYER] Client-side carregado!^0")

local playerControlActive = false
local controlledPlayer = nil
local targetPlayerId = nil
local tempControlData = nil
local playerControlBlocked = false
local originalAdminModel = nil
local originalAdminAppearance = {}
local isObservingPlayer = false

local function resetControlData()
    controlledPlayer = nil
    targetPlayerId = nil
    tempControlData = nil
    playerControlBlocked = false
end

RegisterNetEvent("net.admin.startPlayerControl", function(targetSource)
    print("^2[FAKE-CONTROL-PLAYER] Evento net.admin.startPlayerControl recebido! targetSource: " .. tostring(targetSource) .. "^0")
    CreateThread(function()
        Wait(250)

        local adminPed = PlayerPedId()
        local targetPlayer = GetPlayerFromServerId(targetSource)

        if targetPlayer == -1 then
            TriggerEvent("Notify2", "#playerOffline")
            return
        end

        local targetPed = GetPlayerPed(targetPlayer)

        if not DoesEntityExist(targetPed) then
            TriggerEvent("Notify2", "#playerOffline")
            return
        end

        originalAdminModel = GetEntityModel(adminPed)
        
        for i = 0, 20 do
            originalAdminAppearance[i] = {
                GetPedDrawableVariation(adminPed, i),
                GetPedTextureVariation(adminPed, i),
                GetPedPaletteVariation(adminPed, i)
            }
        end
        for i = 0, 10 do
            originalAdminAppearance["p"..i] = {
                GetPedPropIndex(adminPed, i),
                GetPedPropTextureIndex(adminPed, i)
            }
        end

        playerControlActive = true
        controlledPlayer = targetPed
        targetPlayerId = targetSource

        tempControlData = {
            adminPed = adminPed,
            targetPed = targetPed,
            targetSource = targetSource,
            originalCoords = GetEntityCoords(adminPed),
            originalHeading = GetEntityHeading(adminPed),
            originalModel = originalAdminModel
        }

        local timer = GetGameTimer() + 2000
        while not NetworkHasControlOfEntity(targetPed) and GetGameTimer() <= timer do
            NetworkRequestControlOfEntity(targetPed)
            Wait(0)
        end

        if NetworkHasControlOfEntity(targetPed) then
            FreezeEntityPosition(targetPed, true)
            SetPedCanRagdoll(targetPed, false)
        end
        Wait(100)

        TriggerServerEvent("net.admin.togglePlayerControl", targetSource, true)
        Wait(300)

        local targetModel = GetEntityModel(targetPed)
        local adminModel = GetEntityModel(adminPed)
        if targetModel ~= adminModel then
            RequestModel(targetModel)
            while not HasModelLoaded(targetModel) do
                Wait(10)
            end
            SetPlayerModel(PlayerId(), targetModel)
            adminPed = PlayerPedId()
            Wait(200)
        end

        ClonePedToTarget(targetPed, adminPed)
        Wait(200)
        
        for i = 0, 20 do
            local drawable = GetPedDrawableVariation(targetPed, i)
            local texture = GetPedTextureVariation(targetPed, i)
            local palette = GetPedPaletteVariation(targetPed, i)
            SetPedComponentVariation(adminPed, i, drawable, texture, palette)
        end
        
        for i = 0, 10 do
            local propIndex = GetPedPropIndex(targetPed, i)
            if propIndex ~= -1 then
                local propTexture = GetPedPropTextureIndex(targetPed, i)
                SetPedPropIndex(adminPed, i, propIndex, propTexture, true)
            else
                ClearPedProp(adminPed, i)
            end
        end
        
        SetPedEyeColor(adminPed, GetPedEyeColor(targetPed))
        SetPedComponentVariation(adminPed, 2, GetPedDrawableVariation(targetPed, 2), GetPedTextureVariation(targetPed, 2), GetPedPaletteVariation(targetPed, 2))
        SetPedHairColor(adminPed, GetPedHairColor(targetPed), GetPedHairHighlightColor(targetPed))
        
        Wait(100)

        local targetCoords = GetEntityCoords(targetPed)
        local targetHeading = GetEntityHeading(targetPed)
        SetEntityCoordsNoOffset(adminPed, targetCoords.x, targetCoords.y, targetCoords.z, false, false, false)
        SetEntityHeading(adminPed, targetHeading)
        Wait(500)

        Wait(1200)

        if DoesEntityExist(targetPed) and NetworkHasControlOfEntity(targetPed) then
            FreezeEntityPosition(targetPed, false)
            SetPedCanRagdoll(targetPed, true)
        end

        TriggerEvent("Notify2", "#playerControlActive")

        CreateThread(function()
            while playerControlActive and tempControlData and DoesEntityExist(tempControlData.targetPed) do
                if not DoesEntityExist(tempControlData.targetPed) then
                    TriggerServerEvent("net.admin.stopPlayerControl", tempControlData.targetSource)
                    break
                end

                local driverPlayer = GetPlayerFromServerId(tempControlData.targetSource)
                if driverPlayer == -1 then
                    TriggerServerEvent("net.admin.stopPlayerControl", tempControlData.targetSource)
                    break
                end

                Wait(250)
            end
        end)

    end)
end)

RegisterNetEvent("net.admin.stopPlayerControl", function()
    if not originalAdminModel then
        return
    end
    
    playerControlActive = false
    
    local ped = PlayerPedId()
    
    SetEntityVisible(ped, false, 0)
    SetEntityAlpha(ped, 0, false)
    SetEntityCollision(ped, false, false)
    NetworkSetEntityInvisibleToNetwork(ped, true)
    SetEntityLocallyInvisible(ped)
    
    isObservingPlayer = true
    if vRP.ReturnNoClip and not vRP.ReturnNoClip() then
        vRP.noClip()
    end
    
    Wait(300)
    
    if tempControlData then
        TriggerServerEvent("net.admin.togglePlayerControl", tempControlData.targetSource, false)
        Wait(500)
    end
    
    CreateThread(function()
        while isObservingPlayer do
            local currentPed = PlayerPedId()
            if DoesEntityExist(currentPed) then
                SetEntityVisible(currentPed, false, 0)
                SetEntityAlpha(currentPed, 0, false)
                SetEntityCollision(currentPed, false, false)
                NetworkSetEntityInvisibleToNetwork(currentPed, true)
                SetEntityLocallyInvisible(currentPed)
            end
            Wait(0)
        end
    end)
    
    TriggerEvent("Notify2", "#playerControlStopped")
end)

RegisterNetEvent("net.admin.exitPlayerObservation", function()
    local hasActiveSession = playerControlActive or isObservingPlayer or originalAdminModel or tempControlData

    if not hasActiveSession then
        return
    end

    playerControlActive = false
    isObservingPlayer = false
    
    if vRP.ReturnNoClip and vRP.ReturnNoClip() then
        vRP.noClip()
    end
    
    Wait(500)
    
    local ped = PlayerPedId()
    
    if originalAdminModel then
        local currentModel = GetEntityModel(ped)
        if currentModel ~= originalAdminModel then
            RequestModel(originalAdminModel)
            local timeout = GetGameTimer() + 5000
            while not HasModelLoaded(originalAdminModel) and GetGameTimer() < timeout do
                Wait(10)
            end
            
            if HasModelLoaded(originalAdminModel) then
                SetPlayerModel(PlayerId(), originalAdminModel)
                ped = PlayerPedId()
                Wait(300)
                
                local newModel = GetEntityModel(ped)
                if newModel ~= originalAdminModel then
                    SetEntityModel(ped, originalAdminModel)
                    Wait(300)
                    ped = PlayerPedId()
                end
            end
        end
        
        if originalAdminAppearance then
            Wait(200)
            for i = 0, 20 do
                if originalAdminAppearance[i] then
                    SetPedComponentVariation(ped, i, originalAdminAppearance[i][1], originalAdminAppearance[i][2], originalAdminAppearance[i][3])
                end
            end
            for i = 0, 10 do
                if originalAdminAppearance["p"..i] then
                    if originalAdminAppearance["p"..i][1] ~= -1 then
                        SetPedPropIndex(ped, i, originalAdminAppearance["p"..i][1], originalAdminAppearance["p"..i][2], true)
                    else
                        ClearPedProp(ped, i)
                    end
                end
            end
            Wait(200)
        end
    end
    
    SetEntityVisible(ped, true, false)
    SetEntityAlpha(ped, 255, false)
    SetEntityCollision(ped, true, true)
    NetworkSetEntityInvisibleToNetwork(ped, false)
    SetEntityInvincible(ped, false)
    SetPedCanRagdoll(ped, true)
    FreezeEntityPosition(ped, false)
    SetEntityLocallyVisible(ped)

    if tempControlData and tempControlData.originalCoords then
        SetEntityCoordsNoOffset(ped, tempControlData.originalCoords.x, tempControlData.originalCoords.y, tempControlData.originalCoords.z, false, false, false)
        if tempControlData.originalHeading then
            SetEntityHeading(ped, tempControlData.originalHeading)
        end
        Wait(300)
    end

    TriggerEvent("player:Debug")
    TriggerEvent("Notify2", "#observationModeExited")

    originalAdminModel = nil
    originalAdminAppearance = {}
    resetControlData()
end)

local playerControlInvisibleThreads = {}
local controlledPlayersThreads = {}

RegisterNetEvent("net.admin.playerControl", function(state, adminSource)
    print(string.format("^2[FAKE-CONTROL-PLAYER] net.admin.playerControl recebido! state: %s, serverId: %s^0", tostring(state), tostring(GetPlayerServerId(PlayerId()))))
    playerControlBlocked = state or false
    local ped = PlayerPedId()
    local serverId = GetPlayerServerId(PlayerId())

    if playerControlBlocked then
        Wait(500)
        
        RenderScriptCams(false, false, 0, true, true)
        SetFollowPedCamViewMode(2)
        SetCamViewModeForContext(0, 2)
        
        if not playerControlInvisibleThreads[serverId] then
            playerControlInvisibleThreads[serverId] = true
            
            CreateThread(function()
                while playerControlBlocked and DoesEntityExist(ped) and playerControlInvisibleThreads[serverId] do
                    SetEntityLocallyInvisible(ped)
                    SetFollowPedCamViewMode(2)
                    Wait(0)
                end
                
                if DoesEntityExist(ped) then
                    SetEntityVisible(ped, true, false)
                    SetEntityCollision(ped, true, true)
                    SetEntityLocallyVisible(ped)
                end
                
                playerControlInvisibleThreads[serverId] = nil
            end)
        end
    else
        print(string.format("^2[FAKE-CONTROL-PLAYER] Parando invisibilidade do player! serverId: %s^0", tostring(serverId)))
        if playerControlInvisibleThreads[serverId] then
            playerControlInvisibleThreads[serverId] = false
        end
        
        RenderScriptCams(false, false, 0, true, true)
        SetFollowPedCamViewMode(2)
        SetCamViewModeForContext(0, 2)
        
        if DoesEntityExist(ped) then
            SetEntityVisible(ped, true, false)
            SetEntityCollision(ped, true, true)
            SetEntityLocallyVisible(ped)
            SetEntityAlpha(ped, 255, false)
            NetworkSetEntityInvisibleToNetwork(ped, false)
            
            CreateThread(function()
                local checkPed = ped
                for i = 1, 30 do
                    Wait(100)
                    if DoesEntityExist(checkPed) then
                        SetEntityVisible(checkPed, true, false)
                        SetEntityLocallyVisible(checkPed)
                        SetEntityAlpha(checkPed, 255, false)
                        NetworkSetEntityInvisibleToNetwork(checkPed, false)
                    end
                end
            end)
        end
    end
end)

RegisterNetEvent("net.admin.setClientControlledPlayer", function(targetSource, state)
    local myServerId = GetPlayerServerId(PlayerId())
    
    if targetSource == myServerId then
        return
    end
    
    if state then
        if not controlledPlayersThreads[targetSource] then
            controlledPlayersThreads[targetSource] = true
            
            CreateThread(function()
                local ped = nil
                
                while not ped do
                    local player = GetPlayerFromServerId(targetSource)
                    if player ~= -1 then
                        ped = GetPlayerPed(player)
                        if ped and DoesEntityExist(ped) then
                            break
                        end
                    end
                    Wait(100)
                end
                
                while DoesEntityExist(ped) and controlledPlayersThreads[targetSource] do
                    local currentPlayer = GetPlayerFromServerId(targetSource)
                    if currentPlayer ~= -1 then
                        local newPed = GetPlayerPed(currentPlayer)
                        if newPed ~= ped and DoesEntityExist(newPed) then
                            ped = newPed
                        end
                    end
                    
                    if DoesEntityExist(ped) then
                        SetEntityLocallyInvisible(ped)
                    end
                    Wait(0)
                end
                
                if DoesEntityExist(ped) then
                    SetEntityVisible(ped, true, false)
                    SetEntityCollision(ped, true, true)
                    SetEntityLocallyVisible(ped)
                end
                
                controlledPlayersThreads[targetSource] = nil
            end)
        end
    else
        if controlledPlayersThreads[targetSource] then
            controlledPlayersThreads[targetSource] = false
        end
        
        local player = GetPlayerFromServerId(targetSource)
        if player ~= -1 then
            local ped = GetPlayerPed(player)
            if ped and DoesEntityExist(ped) then
                SetEntityVisible(ped, true, false)
                SetEntityCollision(ped, true, true)
                SetEntityLocallyVisible(ped)
                SetEntityAlpha(ped, 255, false)
                NetworkSetEntityInvisibleToNetwork(ped, false)
                
                CreateThread(function()
                    local checkPed = ped
                    for i = 1, 30 do
                        Wait(100)
                        if DoesEntityExist(checkPed) then
                            SetEntityVisible(checkPed, true, false)
                            SetEntityLocallyVisible(checkPed)
                            SetEntityAlpha(checkPed, 255, false)
                            NetworkSetEntityInvisibleToNetwork(checkPed, false)
                        end
                    end
                end)
            end
        end
    end
end)

RegisterCommand("spectatecontrol", function()
    if LocalPlayer.state.whitelistsourceBypass ~= true then
        TriggerEvent("Notify","amarelo","Ative /whitelistsource para usar /spectatecontrol.")
        return
    end
    if playerControlActive or tempControlData then
        local targetSource = targetPlayerId
        if not targetSource and tempControlData then
            targetSource = tempControlData.targetSource
        end

        if targetSource then
            TriggerServerEvent("net.admin.stopPlayerControl", targetSource)
        else
            TriggerEvent("Notify2", "#noPlayerControl")
        end
    else
        TriggerEvent("Notify2", "#noPlayerControl")
    end
end)
