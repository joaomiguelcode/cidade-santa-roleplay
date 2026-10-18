gCamera = 0 ---@typpe number
gCreationState = {} ---@type character-creator.CreationState
gCustomization = {} ---@type character-creator.CustomizationData
gCameraTransitionQueue = {} ---@type character-creator.CameraTransition[]
gCurrentTransition = nil ---@type character-creator.CameraTransition?
gIsFirst = false ---@type boolean
gCollectPlayerData = false ---@type boolean
gLastPresetData = nil ---@type {gender: 'F' | 'M', id: number}?

local TIME_WAIT_SPAWN_MS = 2500

local blockBucketsBarbershop = {
    [25] = true, -- mundo royale
}

function ResetPlayerPosition()
    local ped = PlayerPedId()

    if not gCreationState.position then
        return
    end

    SetEntityCoords(ped, gCreationState.position.x, gCreationState.position.y, gCreationState.position.z - 1.0, true,
        true, true, true)
    SetEntityHeading(ped, gCreationState.position.w)
end

---@param position vector3
---@return boolean
function IsPlayerReadyToSpawn(position)
    return #(GetEntityCoords(PlayerPedId()) - position) < 1.5
end

-- ponytail: debug temporário CTD DecibelSpawn (ver new_spawn/client/native_debug.lua); remover quando identificado
local nsdbgCity = GetConvar('cityName', '')
local nsdbg = (nsdbgCity == 'Fronteira' or nsdbgCity == 'Krown') and GetConvar('newspawn_debug', '1') ~= '0'

---@param flag character-creator.EnumCreationState
---@param customCreatorModel number? isso serve para criação de personagem com modelo customizado
function StartCreation(flag, customCreatorModel, isFirst)
    if nsdbg then
        sx.logger:debug(('[nsdbg] StartCreation flag=%s model=%s isFirst=%s ped=%s'):format(tostring(flag), tostring(customCreatorModel), tostring(isFirst), PlayerPedId()))
    end
    assert(GetResourceState('skinshop') == 'started', 'skinshop resource not started')
    assert(GetResourceState('tattooshop') == 'started', 'tattooshop resource not started')
    assert(not next(gCreationState), 'creation state already started')

    gIsFirst = isFirst or false
    gLastPresetData = nil
    gCollectPlayerData = (flag & eCharacterCreatorCreationState.CREATING) ~= 0
        and lib.callback.await('character-creator:collectsPlayerData', false) == true

    if (flag & eCharacterCreatorCreationState.CREATING) ~= 0 then
        SuspectSystem.resetScore()
    end

    if (flag & eCharacterCreatorCreationState.EDITING) ~= 0 then
        if blockBucketsBarbershop[LocalPlayer.state.Route] then
            return
        end

        --[[
        if not exports.admin:SafeguardAccountHasDiscordAccountLink() then
            return
        end
        --]]
    end
    
    local onVisibilityError, errorVisibility = pcall(Visibility.setVisible, false) -- as vezes o sx da erro de visibilidade quando o creator é aberto.

    if not onVisibilityError then
        print('error on visibility sx: ', errorVisibility)
    end
    
    ChatHelper.setDisable()
    Hud.setVisible(false)
    Invencible.SetPlayer(true)

    LocalPlayer['state']:set(KEY_STATE_CREATOR, flag, true)

    local appearance = ImportLegacyAppearance(GetPlayerAppearanceState())

    gCreationState = {
        flag = flag,
        startAt = GetGameTimer(),
        userModelHash = GetEntityModel(PlayerPedId()),
        clothes = exports.skinshop:getDataset(),
        tattoos = table.clone(GetPlayerTattoosState()),
        appearance = appearance,
        hasAlreadyImportedAppearance = false
    }

    Collision.setDisabled(false)

    DoScreenFadeOut(CREATOR_CONFIG.TRANSITION_FADE_SCREEN_MS)
    Wait(CREATOR_CONFIG.TRANSITION_FADE_SCREEN_MS)

    if (flag & eCharacterCreatorCreationState.CREATING) ~= 0 then
        local model = customCreatorModel or CREATOR_CONFIG.INITIAL_GENDER
        local customization = (GetCustomizationPreset(model) or {})

        Customizator.ChangeGender(model)

        if customization.skinshop then
            TriggerEvent('skinshop:Apply', customization.skinshop)
        end

        if customization.barbershop then
            Customizator.ApplyFromData(ImportLegacyAppearance(customization.barbershop))
        end

        -- caso algum sistema fique colocando o player em uma posição errada, vamos esperar até que o player esteja na posição correta.
        while not IsPlayerReadyToSpawn(CREATOR_CONFIG.SPAWN_POSITION.xyz) do
            local x, y, z, w = table.unpack(CREATOR_CONFIG.SPAWN_POSITION)

            SetEntityCoords(PlayerPedId(), x, y, z - 1.0, false, false, false, false)
            SetEntityHeading(PlayerPedId(), w)
            SetEntityVisible(PlayerPedId(), true, false)

            Wait(TIME_WAIT_SPAWN_MS)
        end
    end

    if (flag & eCharacterCreatorCreationState.EDITING) ~= 0 or (flag & eCharacterCreatorCreationState.USE_CREATOR_ITEM) ~= 0 then
        gCustomization = gCreationState.appearance
    end

    Collision.start()
    Animation.freeze()
    Light.draw()
    Camera.create()

    Customizator.RemoveShoes()
    Customizator.RemoveComponents()

    if (flag & eCharacterCreatorCreationState.EDITING) ~= 0 or (flag & eCharacterCreatorCreationState.USE_CREATOR_ITEM) ~= 0 then
        exports["tattooshop"]:Apply(gCreationState.tattoos)
    end

    SetNuiFocus(true, true)

    DoScreenFadeIn(CREATOR_CONFIG.TRANSITION_FADE_SCREEN_MS)
    Wait(CREATOR_CONFIG.TRANSITION_FADE_SCREEN_MS)

    if isFirst then
        local recommendations = exports.register:getRecommendation(CITY_NAME)
        local socialMedia = exports.register:getSocialMedia(CITY_NAME)

        SendNUIMessage({
            action = "creator:loadConfig",
            data = {
                flags = CreatorFeatures[gCreationState.flag],
                type = GetCreationStateFlagName(),
                ramos = CREATOR_CONFIG.CITIES_RAMO[CITY_NAME],
                oldBoy = CREATOR_CONFIG.OLD_BOY[CITY_NAME],
                isFirst = isFirst,
                recommendationOptions = recommendations,
                socialMediaOptions = socialMedia
            }
        })
    end

    SendNUIMessage({ action = "toggle", data = true })
    SendCustomizationToUI(gCustomization)

    local ped = PlayerPedId()
    local position = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    gCreationState.position = vector4(position.x, position.y, position.z, heading)
    FreezeEntityPosition(ped, true)
end

---@param applyAppearance boolean caso true, ele aplica aparencia, usado quando ele cancela a customização ou quando script é stopado
function StopCreation(applyAppearance)
    if not next(gCreationState) then
        return
    end

    FreezeEntityPosition(PlayerPedId(), false)

    local flag = gCreationState.flag

    Camera.destroy()
    ChatHelper.setEnable()
    Invencible.SetPlayer(false)

    if (flag & eCharacterCreatorCreationState.CREATING) == 0 then
        Hud.setVisible(true)
    end

    pcall(Visibility.setVisible, true) -- caso a resource seja reiniciada o sx tira o visible e da erro kk

    ClearPedTasksImmediately(PlayerPedId())

    if (flag & eCharacterCreatorCreationState.EDITING) ~= 0 or (flag & eCharacterCreatorCreationState.USE_CREATOR_ITEM) ~= 0 then
        if applyAppearance then
            Customizator.ChangeGender(gCreationState.userModelHash)
            Customizator.ApplyFromData(ImportLegacyAppearance(GetPlayerAppearanceState()))
        end

        local model = GetEntityModel(PlayerPedId())

        if next(gCreationState.clothes) and model == gCreationState.userModelHash then
            TriggerEvent('skinshop:Apply', gCreationState.clothes)
        end

        if model == gCreationState.userModelHash then
            exports["tattooshop"]:Apply(gCreationState.tattoos)
        end
    end

    -- caso a pessoa tenha criado um personagem, vamos aplicar a customização do personagem ( padrão da cidade ).
    if (flag & eCharacterCreatorCreationState.CREATING) ~= 0 then
        local model = GetEntityModel(PlayerPedId())
        local customization = (GetCustomizationPreset(model) or {})

        if customization.skinshop then
            TriggerEvent('skinshop:Apply', customization.skinshop)
        end
    end

    SendNUIMessage({ action = "toggle", data = false })
    SetNuiFocus(false, false)

    gCreationState = {}
    gCollectPlayerData = false
    Collision.setDisabled(true)
end

---@param isCanceled boolean caso a pessoa tenha cancelado a customização ( casos de edição ou item do creator )
---@param characterData table?
---@param ramo string?
function FinishCreation(isCanceled, characterData, ramo)
    if not next(gCreationState) then return false end
    local state = table.clone(gCreationState)
    local tutorial = false
    local closed = false
    local function CloseCreator()
        DoScreenFadeOut(CREATOR_CONFIG.TRANSITION_FADE_SCREEN_MS)
        Wait(CREATOR_CONFIG.TRANSITION_FADE_SCREEN_MS)
        ClearPlayerCreatorState()
        StopCreation(isCanceled)
        closed = true
    end

    if not isCanceled then
        local model = GetEntityArchetypeName(PlayerPedId())
        if characterData then
            characterData.sexo = model == 'mp_f_freemode_01' and 'f' or 'm'
            CloseCreator()
        end
        local ok, success, startTutorial = pcall(lib.callback.await, 'character-creator:saveCustomization',
            false, gCustomization, state.flag, model, characterData, ramo)
        if not ok or not success then
            if closed then
                StartCreation(state.flag, GetHashKey(model), gIsFirst)
            else
                SendNUIMessage({ action = 'toggle', data = true })
                SetNuiFocus(true, true)
            end
            return false
        end
        tutorial = startTutorial
        local appearance = ExportLegacyAppearance(gCustomization)
        SavePlayerAppearanceState(appearance)
        SuspectSystem.onSendToSx()

        if characterData then
            Wait(1500)
            Customizator.ApplyFromData(ImportLegacyAppearance(appearance))
        end
    end

    if not closed then CloseCreator() end

    if not isCanceled and (state.flag & eCharacterCreatorCreationState.CREATING) ~= 0
        and GetResourceState('voice_preferences') == 'started'
        and sx.featureflags.enableVoicePreferences() then
        -- Falha aqui não pode abortar o callback: o fade-in abaixo tiraria o jogador da tela preta.
        local ok, voiceResponse = pcall( function()
            return exports.voice_preferences:SetVoicePreferencesAsync( {
                voiceEnabled = true,
                microphoneEnabled = true,
                activationMode = 'activity',
                outputVolume = 10,
                microphoneVolume = 10,
                microphoneSensitivity = 10
            } )
        end )

        if not ok or not voiceResponse or not voiceResponse.ok then
            sx.logger:error( ('Failed to apply new character voice preferences: %s'):format(
                tostring( ok and voiceResponse and voiceResponse.error or voiceResponse ) ) )
        end
    end

    DoScreenFadeIn(CREATOR_CONFIG.TRANSITION_FADE_SCREEN_MS)
    -- O tutorial assume câmera/freeze só depois de encerrar o editor.
    if tutorial then TriggerEvent('new_hub:client:startTutorial') end

    if not isCanceled and characterData then
        local fullName = characterData.nomeCompleto
        if not fullName and type(characterData.nome) == 'string' and type(characterData.nome2) == 'string' then
            fullName = ('%s %s'):format(characterData.nome, characterData.nome2)
        end

        TriggerServerEvent('register:updatePlayer', {
            recommendation = characterData.foundUs, name = fullName, age = characterData.idade,
        })
    end
    return true
end

RegisterNetEvent('net.character-creator.bpreset', function(id)
    local presets = GetAppearancePresets()[GetEntityModel(PlayerPedId())]
    local customization = GetCustomizationPreset(GetEntityModel(PlayerPedId()))

    for idPreset, data in ipairs(presets) do
        if idPreset == id then
            Customizator.ApplyFromData(ImportLegacyAppearance(data.preset))
            exports['skinshop']:Apply(customization.skinshop)
            return
        end
    end
end)
