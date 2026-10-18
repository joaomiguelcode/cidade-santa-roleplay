local playerClones = {}
local CLONE_COUNT = 5
local SMOKE_DICT = "scr_paleto_roof"
local SMOKE_EFFECT = "scr_paleto_roof"
local CLONE_GROUP_CREATED = false

local isCloning = false
local hasRevealedFromClone = false
local hostilePeds = {} -- Cache de peds hostis para relacionamento agressivo

local function RequestPtfxAsset(assetName)
    if not HasNamedPtfxAssetLoaded(assetName) then
        RequestNamedPtfxAsset(assetName)
        local timeout = 0
        while not HasNamedPtfxAssetLoaded(assetName) and timeout < 100 do
            Wait(10)
            timeout = timeout + 1
        end
    end
end

local function CreateSmokeOnPed(ped)
    if not HasNamedPtfxAssetLoaded("scr_sum2_hal") then
        RequestNamedPtfxAsset("scr_sum2_hal")
        local timeout = 0
        while not HasNamedPtfxAssetLoaded("scr_sum2_hal") and timeout < 100 do
            Wait(10)
            timeout = timeout + 1
        end
    end

    if not HasNamedPtfxAssetLoaded("scr_sum2_hal") then
        return
    end

    local bones = {
        { id = 14201, scale = 2.0, offset = { x = 0.0, y = 0.0, z = 0.0 } },
        { id = 52301, scale = 2.0, offset = { x = 0.0, y = 0.0, z = 0.0 } },
        { id = 24818, scale = 1.2, offset = { x = 0.0, y = -0.25, z = 0.0 } },
        { id = 11816, scale = 1.0, offset = { x = 0.0, y = 0.0, z = 0.0 } },
    }

    for _, boneData in pairs(bones) do
        UseParticleFxAssetNextCall("scr_sum2_hal")
        local particle = StartParticleFxLoopedOnPedBone(
            "sp_sum2_hal_rider_death_trail_green",
            ped,
            boneData.offset.x, boneData.offset.y, boneData.offset.z,
            0.0, 0.0, 0.0,
            boneData.id,
            boneData.scale,
            false, false, false
        )

        if particle then
            CreateThread(function()
                Wait(1200)
                if DoesParticleFxLoopedExist(particle) then
                    RemoveParticleFx(particle, false)
                end
            end)
        end
    end
end

local function CreateSmokeEffect(coords)
    RequestPtfxAsset(SMOKE_DICT)
    
    if not HasNamedPtfxAssetLoaded(SMOKE_DICT) then
        return nil
    end
    
    UseParticleFxAssetNextCall(SMOKE_DICT)
    
    local effect = StartParticleFxLoopedAtCoord(
        SMOKE_EFFECT,
        coords.x,
        coords.y,
        coords.z,
        0.0,
        0.0,
        0.0,
        3.0,
        false,
        false,
        false
    )
    
    if effect then
        CreateThread(function()
            Wait(3000)
            if DoesParticleFxLoopedExist(effect) then
                StopParticleFxLooped(effect, false)
                RemoveParticleFx(effect, false)
            end
        end)
    end
    
    return effect
end

local function CopyPedAppearance(sourcePed, targetPed)
    if not DoesEntityExist(sourcePed) or not DoesEntityExist(targetPed) then
        return false
    end
    
    ClonePedToTarget(sourcePed, targetPed)
    Wait(200)
    
    for i = 0, 11 do
        local drawable = GetPedDrawableVariation(sourcePed, i)
        local texture = GetPedTextureVariation(sourcePed, i)
        local palette = GetPedPaletteVariation(sourcePed, i)
        SetPedComponentVariation(targetPed, i, drawable, texture, palette)
    end
    
    for i = 0, 10 do
        local propIndex = GetPedPropIndex(sourcePed, i)
        if propIndex ~= 0 then
            local propTexture = GetPedPropTextureIndex(sourcePed, i)
            SetPedPropIndex(targetPed, i, propIndex, propTexture, true)
        else
            ClearPedProp(targetPed, i)
        end
    end
    
    SetPedEyeColor(targetPed, GetPedEyeColor(sourcePed))
    SetPedHairColor(targetPed, GetPedHairColor(sourcePed), GetPedHairHighlightColor(sourcePed))
    
    return true
end

local function SetupCloneAppearance(clonePed, playerPed)
    if not DoesEntityExist(clonePed) or not DoesEntityExist(playerPed) then
        return false
    end
    
    Wait(100)
    
    CopyPedAppearance(playerPed, clonePed)
    
    local currentWeapon = GetSelectedPedWeapon(playerPed)
    if currentWeapon ~= 0 then
        GiveWeaponToPed(clonePed, currentWeapon, 250, false, true)
        SetCurrentPedWeapon(clonePed, currentWeapon, true)
        SetPedAmmo(clonePed, currentWeapon, 250)
    end
    
    return true
end

local function SetPedHostileToClones(ped)
    if not DoesEntityExist(ped) then
        hostilePeds[ped] = nil
        return
    end
    
    if not hostilePeds[ped] then
        hostilePeds[ped] = true
        
        -- Criar grupo de relacionamento único para este ped hostil
        local pedGroupName = "HOSTILE_" .. tostring(ped)
        AddRelationshipGroup(pedGroupName)
        
        local pedGroupHash = GetHashKey(pedGroupName)
        SetPedRelationshipGroupHash(ped, pedGroupHash)
        
        -- Configurar relacionamento hostil com clones
        SetRelationshipBetweenGroups(5, `CLONES`, pedGroupHash)
        SetRelationshipBetweenGroups(5, pedGroupHash, `CLONES`)
        
        -- Configurar relacionamento hostil com player também
        SetRelationshipBetweenGroups(5, `PLAYER`, pedGroupHash)
        SetRelationshipBetweenGroups(5, pedGroupHash, `PLAYER`)
    end
end

-- Limpar cache de peds hostis mortos
CreateThread(function()
    while true do
        Wait(5000)
        for ped, _ in pairs(hostilePeds) do
            if not DoesEntityExist(ped) or IsPedDeadOrDying(ped, true) then
                hostilePeds[ped] = nil
            end
        end
    end
end)

local function SetupCloneDefense(clonePed, playerPed)
    local lastHealth = GetEntityMaxHealth(clonePed)
    local lastPlayerHealth = GetEntityHealth(playerPed)
    local currentTarget = nil
    
    CreateThread(function()
        while DoesEntityExist(clonePed) do
            Wait(50) -- Verificar frequentemente para resposta rápida
            
            if not DoesEntityExist(playerPed) then
                break
            end
            
            local cloneStateBag = Entity(clonePed).state
            if cloneStateBag and not cloneStateBag.cloneActive then
                break
            end
            
            if IsPedDeadOrDying(clonePed, true) then
                DeleteEntity(clonePed)
                break
            end
            
            -- Se já está em combate, manter
            if currentTarget and DoesEntityExist(currentTarget) and IsPedInCombat(clonePed, currentTarget) then
                lastHealth = GetEntityHealth(clonePed)
                lastPlayerHealth = GetEntityHealth(playerPed)
                goto continue
            end
            
            currentTarget = nil
            local currentHealth = GetEntityHealth(clonePed)
            local currentPlayerHealth = GetEntityHealth(playerPed)
            local cloneCoords = GetEntityCoords(clonePed)
            local playerCoords = GetEntityCoords(playerPed)
            local playerShooting = IsPedShooting(playerPed)
            
            -- Verificar se player ou clone foram atacados
            local playerAttacked = (currentPlayerHealth < lastPlayerHealth)
            local cloneAttacked = (currentHealth < lastHealth)
            
            -- Buscar ameaças
            local allPeds = GetGamePool('CPed')
            local threatFound = false
            
            for _, ped in ipairs(allPeds) do
                if ped == clonePed or ped == playerPed or not DoesEntityExist(ped) or not IsPedHuman(ped) then
                    goto next_ped
                end
                
                local pedCoords = GetEntityCoords(ped)
                local distanceToPlayer = #(playerCoords - pedCoords)
                local distanceToClone = #(cloneCoords - pedCoords)
                
                -- Verificar apenas peds próximos
                if distanceToPlayer > 100.0 and distanceToClone > 100.0 then
                    goto next_ped
                end
                
                local isThreat = false
                
                -- Prioridade 1: Está atirando na direção do player ou clone
                if IsPedShooting(ped) then
                    if distanceToPlayer < 100.0 then
                        local pedHeading = GetEntityHeading(ped)
                        local directionToPlayer = math.deg(math.atan2(playerCoords.y - pedCoords.y, playerCoords.x - pedCoords.x))
                        local angleDiff = math.abs(pedHeading - directionToPlayer)
                        if angleDiff < 90.0 or angleDiff > 270.0 then
                            isThreat = true
                        end
                    end
                    if not isThreat and distanceToClone < 100.0 then
                        local pedHeading = GetEntityHeading(ped)
                        local directionToClone = math.deg(math.atan2(cloneCoords.y - pedCoords.y, cloneCoords.x - pedCoords.x))
                        local angleDiff = math.abs(pedHeading - directionToClone)
                        if angleDiff < 90.0 or angleDiff > 270.0 then
                            isThreat = true
                        end
                    end
                end
                
                -- Prioridade 2: Causou dano ao player
                if not isThreat and playerAttacked and distanceToPlayer < 100.0 then
                    if HasEntityBeenDamagedByEntity(playerPed, ped, true) or IsPedInCombat(ped, playerPed) then
                        isThreat = true
                    end
                end
                
                -- Prioridade 3: Causou dano ao clone
                if not isThreat and cloneAttacked and distanceToClone < 80.0 then
                    if HasEntityBeenDamagedByEntity(clonePed, ped, true) or HasEntityBeenDamagedByEntity(ped, clonePed, true) then
                        isThreat = true
                    end
                end
                
                -- Prioridade 4: Player está atirando neste ped
                if not isThreat and playerShooting and distanceToPlayer < 100.0 then
                    if HasEntityBeenDamagedByEntity(ped, playerPed, true) or IsPedInCombat(playerPed, ped) then
                        isThreat = true
                    end
                end
                
                -- Atacar ameaça
                if isThreat and distanceToClone < 150.0 then
                    if not IsPedInCombat(clonePed, ped) then
                        SetPedHostileToClones(ped)
                        TaskCombatPed(clonePed, ped, 0, 16)
                        currentTarget = ped
                        threatFound = true
                        break
                    end
                end
                
                ::next_ped::
            end
            
            lastHealth = currentHealth
            lastPlayerHealth = currentPlayerHealth
            
            ::continue::
        end
    end)
end

RegisterNetEvent("admin:requestCloneData", function()
    local playerPed = PlayerPedId()
    if not DoesEntityExist(playerPed) then
        return
    end
    
    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)
    local playerModel = GetEntityModel(playerPed)
    
    -- fumaça no ped + invisibilidade temporária
    isCloning = true
    hasRevealedFromClone = false
    CreateSmokeOnPed(playerPed)
    SetEntityVisible(playerPed, false, false)

    TriggerServerEvent("admin:createClones", playerCoords, playerHeading, playerModel)

    -- fallback: revelar mesmo se statebag atrasar
    CreateThread(function()
        Wait(1500)
        if isCloning and not hasRevealedFromClone then
            SetEntityVisible(playerPed, true, false)
            isCloning = false
        end
    end)
end)

AddStateBagChangeHandler("cloneActive", nil, function(bagName, key, value, reserved, replicated)
    if not value or value ~= true then
        local success, clonePed = pcall(GetEntityFromStateBagName, bagName)
        if success and clonePed and clonePed ~= 0 and DoesEntityExist(clonePed) then
            for i, cloneData in ipairs(playerClones) do
                if cloneData.ped == clonePed then
                    table.remove(playerClones, i)
                    break
                end
            end
            DeleteEntity(clonePed)
        end
        return
    end
    
    Wait(100)
    
    local success, clonePed = pcall(GetEntityFromStateBagName, bagName)
    if not success or not clonePed or clonePed == 0 or not DoesEntityExist(clonePed) then
        return
    end
    
    local cloneStateBag = Entity(clonePed).state
    if not cloneStateBag then
        return
    end
    
    local cloneOwner = cloneStateBag.cloneOwner
    if not cloneOwner then
        Wait(200)
        cloneOwner = cloneStateBag.cloneOwner
    end
    
    if not cloneOwner then
        return
    end
    
    local playerPed = PlayerPedId()
    local playerId = GetPlayerServerId(PlayerId())
    
    if cloneOwner ~= playerId then
        return
    end
    
    if not DoesEntityExist(playerPed) then
        return
    end
    
    local netId = NetworkGetNetworkIdFromEntity(clonePed)
    if not netId or netId == 0 then
        return
    end
    
    for _, existingClone in ipairs(playerClones) do
        if existingClone.ped == clonePed or existingClone.netId == netId then
            return
        end
    end
    
    SetEntityAsMissionEntity(clonePed, true, true)
    SetPedCanRagdoll(clonePed, false)
    SetEntityInvincible(clonePed, false)
    SetBlockingOfNonTemporaryEvents(clonePed, true)
    SetPedFleeAttributes(clonePed, 0, false)
    SetPedCombatAttributes(clonePed, 46, true)
    SetPedCombatAbility(clonePed, 100)
    SetPedCombatRange(clonePed, 2)
    SetPedAccuracy(clonePed, 80)
    SetPedCombatMovement(clonePed, 2) -- Movimento de combate agressivo
    SetPedFleeAttributes(clonePed, 0, false) -- Não fugir
    SetPedSeeingRange(clonePed, 150.0)
    SetPedHearingRange(clonePed, 150.0)
    SetPedAlertness(clonePed, 3)
    SetPedKeepTask(clonePed, true)
    
    -- Configurar vida do clone para 600
    SetEntityMaxHealth(clonePed, 600)
    SetEntityHealth(clonePed, 600)
    
    -- Configurar relacionamento dos clones
    if not CLONE_GROUP_CREATED then
        AddRelationshipGroup("CLONES")
        CLONE_GROUP_CREATED = true
    end
    
    SetPedRelationshipGroupHash(clonePed, `CLONES`)
    
    -- Relacionamento amigável APENAS com o player que criou
    SetRelationshipBetweenGroups(0, `CLONES`, `PLAYER`)
    SetRelationshipBetweenGroups(0, `PLAYER`, `CLONES`)
    
    -- Clones não atacam outros clones do mesmo player
    SetRelationshipBetweenGroups(0, `CLONES`, `CLONES`)
    
    SetupCloneAppearance(clonePed, playerPed)
    
    table.insert(playerClones, {
        ped = clonePed,
        netId = netId
    })
    
    SetupCloneDefense(clonePed, playerPed)
    
    if isCloning and not hasRevealedFromClone then
        SetEntityVisible(playerPed, true, false)
        isCloning = false
        hasRevealedFromClone = true
    end

    Wait(200)
    
    local playerCoords = GetEntityCoords(playerPed)
    TaskGoToEntity(clonePed, playerPed, -1, 3.0, 2.0, 1073741824, 0)
    
    CreateThread(function()
        while DoesEntityExist(clonePed) do
            Wait(500)
            if not DoesEntityExist(playerPed) then
                break
            end
            
            local cloneStateBag = Entity(clonePed).state
            if cloneStateBag and not cloneStateBag.cloneActive then
                break
            end
            
            -- Se o clone está em combate, não precisa seguir o player
            if IsPedInCombat(clonePed) then
                Wait(500)
                goto continue
            end
            
            -- Seguir o player apenas se não estiver em combate
            local playerCoords = GetEntityCoords(playerPed)
            local cloneCoords = GetEntityCoords(clonePed)
            local distance = #(cloneCoords - playerCoords)
            
            if distance > 15.0 then
                TaskGoToEntity(clonePed, playerPed, -1, 3.0, 2.0, 1073741824, 0)
            elseif distance > 5.0 then
                TaskGoToEntity(clonePed, playerPed, -1, 2.0, 1.5, 1073741824, 0)
            else
                TaskStandStill(clonePed, 1000)
            end
            
            ::continue::
        end
    end)
    
    if #playerClones == 1 then
        TriggerEvent("Notify2", "Clones criados!")
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        for _, cloneData in ipairs(playerClones) do
            if DoesEntityExist(cloneData.ped) then
                DeleteEntity(cloneData.ped)
            end
        end
        playerClones = {}
    end
end)

