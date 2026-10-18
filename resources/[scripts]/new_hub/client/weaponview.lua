-- ================================================================
-- WeaponView: cena, câmera, objeto 3D e interação de visualização
-- ================================================================

local _s              = {
    object           = nil,
    attachments      = {},  -- Table to hold all weapon attachments (magazine, grip, scope, etc)
    cam              = nil,
    isProcessing     = false,
    currentLoadingId = nil,
    lastCallTime     = 0,
    isSceneLoading   = false,
    sceneFocusActive = false,
    fadeTimeout      = nil,
    firstFade        = false,
    isRotating       = false,
    lastMouseX       = 0,
    lastMouseY       = 0,
    isLeftMouseDown  = false,
    lastBackground   = nil,
}

local COLLISION_RESTORE_TIMEOUT_MS = 2000

local DEBOUNCE_TIME   = 100
local CENTER_COORDS   = vector3(-829.3, 1271.0, 181.7)
local CENTER_CAM_COORDS   = vector3(-829.3, 1271.0, 181.7)
local INTERIOR_COORDS = vector3(-829.16, 1270.27, 181.80)
local NEAR_DOF        = 0.1
local FAR_DOF         = 4.0
local DOF_STRENGTH    = 0.08
local DEFAULT_FOV     = 41.019259691238
local FOV_BY_TYPE     = {
    pistol = DEFAULT_FOV - 15,
    rifle  = DEFAULT_FOV - 5,
}

-- Luzes de studio (offsets relativos a CENTER_COORDS)
--   key  → quente, frente-direita-acima  (luz principal)
--   fill → fria,   frente-esquerda       (preenchimento suave)
local LIGHTS = {
    { offset = vector3( 0.4, -1.3,  0.6), r = 255, g = 245, b = 220, dist = 3.5, bright = 2.0, radius = 100.0 },
    { offset = vector3(-0.6, -0.9,  0.2), r = 210, g = 220, b = 255, dist = 3.0, bright =  2.0, radius = 100.0 },
}

-- ── Background ──────────────────────────────────────────────────

local background      = {}

function background:new(color)
    self.screenWidth, self.screenHeight = 8, 8
    self.url                            = ('https://singlecolorimage.com/get/%s/%s'):format(color, '8x8')
    self.dict                           = "weapon_skins_background"
    self.texture                        = "color"
    self.duiObject                      = CreateDui(self.url, self.screenWidth, self.screenHeight)
    self.duihandle                      = GetDuiHandle(self.duiObject)
    self.runtimeTxd                     = CreateRuntimeTxd(self.dict)
    self.txdObject                      = CreateRuntimeTextureFromDuiHandle(self.runtimeTxd, self.texture,
        self.duihandle)
    self.alpha                          = 255

    RequestStreamedTextureDict(self.dict, true)
    repeat Wait(1) until IsDuiAvailable(self.duiObject) and HasStreamedTextureDictLoaded(self.dict)

    return self
end

local function setBackgroundColor(color)
    if _s.lastBackground then
        if _s.lastBackground.duiObject then
            DestroyDui(_s.lastBackground.duiObject)
        end
        if _s.lastBackground.runtimeTxd then
            RemoveReplaceTexture("santagroup_guns_bg", "background_color")
            RemoveReplaceTexture("santagroup_guns_bg", "preto")
        end
    end

    local bg = background:new(color)
    _s.lastBackground = bg

    AddReplaceTexture("santagroup_guns_bg", "background_color", bg.dict, bg.texture)
    AddReplaceTexture("santagroup_guns_bg", "preto", bg.dict, bg.texture)
end

-- ── Helpers internos ────────────────────────────────────────────

local function getWeaponType(component)
    for _, skins in pairs(weapons_skins) do
        for _, skin in pairs(skins) do
            if skin.component == component then
                return skin.weapon_type
            end
        end
    end
    return false
end

-- Magazine model mapping for weapon SKINS (from weaponcomponents.meta)
-- Format: [skin_component_name] = magazine_model_name
local SKIN_MAGAZINE_MODELS = {
    ["COMPONENT_EO_SPECIALCARBINEMK2_ELITESINTONIA"] = "eo_specialcarbinemk2_fogonainveja_mag1",
    ["COMPONENT_FAL_PENHASHOP_04"] = "w_ar_fal_penhashop_04_mag1",
    ["COMPONENT_G3_PCJ"] = "w_ar_pl_penhashop_g3_pcj_mag",
    ["COMPONENT_PL_AK_AGUA"] = "w_ar_pl_ak_agua_mag1",
    ["COMPONENT_PL_AK_GAME"] = "w_ar_pl_ak_game_mag1",
    ["COMPONENT_PL_AK_GOLD"] = "w_ar_pl_ak_gold_mag1",
    ["COMPONENT_PL_AK_PUDDIN_PASCOA"] = "w_ar_pl_ak_mk2_puddin_pascoa_mag1",
    ["COMPONENT_PL_AK_TOXIC_V3"] = "w_ar_pl_ak_toxic_v3_mag1",
    ["COMPONENT_PL_AK_UNI"] = "w_ar_pl_ak_uni_mag1",
    ["COMPONENT_PL_AK_WOLF"] = "w_ar_pl_ak_mk2_wolf_mag1",
    ["COMPONENT_PL_COMBATPISTOL_ANIME"] = "w_pi_pl_glock_anime_mag1",
    ["COMPONENT_PL_COMBATPISTOL_FADE"] = "w_pi_pl_glock_fade_mag1",
    ["COMPONENT_PL_COMBATPISTOL_GAME"] = "w_pi_pl_glock_game_mag1",
    ["COMPONENT_PL_COMBATPISTOL_GRAFITE"] = "w_pi_pl_glock_grafite_mag1",
    ["COMPONENT_PL_COMBATPISTOL_OURO_P"] = "w_pi_pl_glock_ouro_p_mag1",
    ["COMPONENT_PL_COMBATPISTOL_TOY"] = "w_pi_pl_glock_toy_mag1",
    ["COMPONENT_PL_M4_ANIME"] = "w_ar_pl_m4_anime_mag1",
    ["COMPONENT_PL_M4_FADE"] = "w_ar_pl_m16_fade_mag1",
    ["COMPONENT_PL_M4_GAME"] = "w_ar_m4_game_mag1",
    ["COMPONENT_PL_M4_LEGO"] = "w_ar_pl_m4_lego_mag1",
    ["COMPONENT_PL_M4_LOVE"] = "w_ar_pl_m4_love_mag1",
    ["COMPONENT_PL_M4_MEDIC"] = "w_ar_pl_m4_medic_mag1",
    ["COMPONENT_PL_M4_MK2_TOXIC"] = "w_ar_pl_m4_mk2_toxic_mag1",
    ["COMPONENT_PL_M4_ROSA"] = "w_ar_pl_m4_rosa_mag1",
    ["COMPONENT_PL_PENHASHOP_G3_AGUA"] = "w_ar_pl_g3_de_agua_mag1",
    ["COMPONENT_PL_PENHASHOP_G3_ANIME"] = "w_ar_pl_penhashop_g3_anime_mag1",
    ["COMPONENT_PL_PENHASHOP_G3_BIOHAZARD"] = "w_ar_pl_penhashop_g3_biohazard_mag1",
    ["COMPONENT_PL_PENHASHOP_G3_GAME"] = "w_ar_pl_g3_game_mag1",
    ["COMPONENT_PL_PENHASHOP_G3_PAPELAO"] = "w_ar_pl_g3_papelao_mag1",
    ["COMPONENT_PL_PENHASHOP_G3_TOXIC_PUDDIN"] = "w_ar_pl_g3_mk2_toxic_puddin_mag1",
    ["COMPONENT_PL_PENHASHOP_G3_TOXIC_V1"] = "w_ar_pl_penhashop_g3_toxic_v1_mag1",
    ["COMPONENT_PL_PENHASHOP_G3_WOLF"] = "w_ar_pl_penhashop_g3_wolf_mag1",
    ["COMPONENT_PL_PISTOLA_AGUA"] = "w_pi_pl_pistola_agua_mag1",
    ["COMPONENT_PL_PISTOLA_BLOCKS"] = "w_pi_pl_pistola_lego_mag1",
    ["COMPONENT_PL_PISTOLMK2_GIH_TOXIC"] = "w_pi_pl_pistolmk2_gih_toxic_mag1",
    ["COMPONENT_PL_PISTOL_1911_AL"] = "w_pi_pl_1911_al_mag1",
    ["COMPONENT_PL_PISTOL_1911_FJ"] = "w_pi_pl_1911_fj_mag1",
    ["COMPONENT_PL_PISTOL_1911_GRA"] = "w_pi_pl_1911_gra_mag1",
    ["COMPONENT_PL_PISTOL_PASCOA_PUDDIN"] = "w_pi_pl_pistol_pascoa_puddin_mag1",
    ["COMPONENT_PL_SNIPER_AL"] = "w_sr_pl_sniper_amor_letal_mag",
    ["COMPONENT_PL_SNIPER_CUTI"] = "w_sr_pl_sniper_cuti_mag",
    ["COMPONENT_PL_SNIPER_GAME"] = "w_sr_pl_sniper_game_mag",
    ["COMPONENT_SPECIALCARBINE_G36WOLF"] = "eo_specialcarbinemk2_lucifergenteboa_mag1",
}

-- Magazine component mapping for custom weapons (from individual meta files)
local WEAPON_MAGAZINES = {
    ["WEAPON_50_RELIKIASHOP"] = { "PENTE_50_RELIKIASHOP" },
    ["WEAPON_ASSAULTRIFLEDEFERRO_RELIKIASHOP"] = { "TAMBOR_AKDERERRO_RELIKIASHOP" },
    ["WEAPON_AKPENTEDE90_RELIKIASHOP"] = { "PENTE_AKDE90_RELIKIASHOP" },
    ["WEAPON_RIFLEPRETO_RELIKIASHOP"] = { "PENTEAR10", "PENTEAR10_EXTENDIDO" },
    ["WEAPON_RIFLEBEGE_RELIKIASHOP"] = { "PENTEAR15BEGE", "TAMBOR_AR15BEGE" },
    ["WEAPON_RIFLEBOTA"] = { "COMPONENT_CARBINERIFLEBOTAFOGO_CLIP_01", "COMPONENT_CARBINERIFLEBOTAFOGO_CLIP_02" },
    ["WEAPON_RIFLEDUBTL"] = { "COMPONENT_CARBINERIFLECVDUBTL_CLIP_01", "COMPONENT_CARBINERIFLECVDUBTL_CLIP_02" },
    ["WEAPON_RIFLEDELUNETA_RELIKIASHOP"] = { "COMPONENT_HEAVYSNIPER1_CLIP_01" },
    ["WEAPON_RIFLEFLA"] = { "COMPONENT_CARBINERIFLEFLAMENGO_CLIP_01", "COMPONENT_CARBINERIFLEFLAMENGO_CLIP_02" },
    ["WEAPON_RIFLEFLA2"] = { "COMPONENT_CARBINERIFLEFLAMENGO2_CLIP_01", "COMPONENT_CARBINERIFLEFLAMENGO2_CLIP_02" },
    ["WEAPON_RIFLEFLU"] = { "COMPONENT_CARBINERIFLEFLUMINENSE_CLIP_01", "COMPONENT_CARBINERIFLEFLUMINENSE_CLIP_02" },
    ["WEAPON_RIFLELUNETAPRATA"] = { "COMPONENT_CARBINERIFLELUNETPRATA_CLIP_01", "COMPONENT_CARBINERIFLELUNETPRATA_CLIP_02" },
    ["WEAPON_RIFLEMILI"] = { "COMPONENT_CARBINERIFLEMILICIA_CLIP_01", "COMPONENT_CARBINERIFLEMILICIA_CLIP_02" },
    ["WEAPON_RIFLETP3"] = { "COMPONENT_ARTCP3_CLIP_01", "COMPONENT_ARTCP3_CLIP_02" },
    ["WEAPON_RIFLETERRORDAALTA"] = { "COMPONENT_CARBINERIFLETERRORDAALTA_CLIP_01", "COMPONENT_CARBINERIFLETERRORDAALTA_CLIP_02" },
    ["WEAPON_RIFLEVA"] = { "COMPONENT_CARBINERIFLEVSC_CLIP_01", "COMPONENT_CARBINERIFLEVSC_CLIP_02" },
    ["WEAPON_SPECIALCARBINELUNETA_RELIKIASHOP"] = { "TAMBORG3_RELIKIASHOP" },
    ["WEAPON_SPECIALCARBINEZAO"] = { "COMPONENT_SPECIALCARBINEG3ZAO_CLIP_01", "COMPONENT_SPECIALCARBINEG3ZAO_CLIP_02" },
    ["WEAPON_COMBATPISTOLLASEROURO"] = { "COMPONENT_GLOCKLASEROURO_CLIP_01", "COMPONENT_GLOCKLASEROURO_CLIP_02" },
    ["WEAPON_COMBATPISTOLLASERPRATA"] = { "COMPONENT_GLOCKLASERPRATA_CLIP_01", "COMPONENT_GLOCKLASERPRATA_CLIP_02" },
    ["WEAPON_COMBATPISTOLFLA"] = { "COMPONENT_GLOCKMENGO_CLIP_01" },
    ["WEAPON_COMBATPISTOLP"] = { "COMPONENT_GLOCKP_CLIP_01", "COMPONENT_GLOCKP_CLIP_02" },
    ["WEAPON_COMBATPISTOL_R"] = { "COMPONENT_GLOCK_PMR_01_CLIP_01", "COMPONENT_GLOCK_PMR_01_CLIP_02" },
    ["WEAPON_GRAJADA"] = { "COMPONENT_GRAJADA_CLIP_01", "COMPONENT_GRAJADA_CLIP_02" },
    ["WEAPON_MCX"] = { "COMPONENT_CARBINERIFLEM4B_CLIP_01", "COMPONENT_CARBINERIFLEM4B_CLIP_02" },
    ["WEAPON_PENTEDUPLO1"] = { "COMPONENT_CARBINERIFLEDUPLO_CLIP_01" },
}

local function getWeaponAttachments(weaponName, weaponHash, component)

    local attachments = {}

    -- If component is a skin (starts with COMPONENT_), check skin magazine mapping first
    if component and component:match("^COMPONENT_") then
        local skinMagModel = SKIN_MAGAZINE_MODELS[component]
        if skinMagModel then
            table.insert(attachments, {
                model = GetHashKey(skinMagModel),
                bone = "WAPClip",
                name = "magazine"
            })
        end
    end

    -- Get magazine from weapon mapping
    local clips = WEAPON_MAGAZINES[weaponName]
    if clips then

        for _, clipName in ipairs(clips) do
            local componentHash = GetHashKey(clipName)
            local hasComponent = HasPedGotWeaponComponent(cache.ped, weaponHash, componentHash)
            if hasComponent then
                local magazineModel = GetWeaponComponentTypeModel(componentHash)
                if magazineModel and magazineModel ~= 0 then
                    table.insert(attachments, {
                        model = magazineModel,
                        bone = "WAPClip",
                        name = clipName
                    })
                end
                break
            end
        end

        -- If no extended clip equipped, use default clip
        if #attachments == 0 or (attachments[1] and attachments[1].bone ~= "WAPClip") then
            local defaultHash = GetHashKey(clips[1])
            local defaultModel = GetWeaponComponentTypeModel(defaultHash)
            if defaultModel and defaultModel ~= 0 then
                table.insert(attachments, {
                    model = defaultModel,
                    bone = "WAPClip",
                    name = clips[1]
                })
            end
        end
    end

    -- Check for attachments from weapon_components.lua (SKIN_COMPONENTS or WEAPON_COMPONENTS)
    local customComponents = nil
    
    -- Try to get components from skin or weapon tables
    if component and SKIN_COMPONENTS and SKIN_COMPONENTS[component] then
        customComponents = SKIN_COMPONENTS[component]
    elseif weaponName and WEAPON_COMPONENTS and WEAPON_COMPONENTS[weaponName] then
        customComponents = WEAPON_COMPONENTS[weaponName]
    end
    
    -- Process custom components if found
    if customComponents then
        -- Track which bones we've already added (to avoid duplicates)
        local addedBones = {}
        
        for _, compData in ipairs(customComponents) do
            local compName = compData.component
            local compBone = compData.bone
            local compModel = compData.model
            
            if compName and compBone then
                -- Skip if we already have an attachment for this bone
                if addedBones[compBone] then
                    goto continue
                end
                
                local compHash = GetHashKey(compName)
                local hasComponent = true
                
                
                if hasComponent then
                    -- Get model hash from component table or use GetWeaponComponentTypeModel
                    local modelHash = nil
                    if compModel then
                        modelHash = GetHashKey(compModel)
                    else
                        modelHash = GetWeaponComponentTypeModel(compHash)
                    end
                    
                    if modelHash and modelHash ~= 0 then
                        table.insert(attachments, {
                            model = modelHash,
                            bone = compBone,
                            name = compName
                        })
                        addedBones[compBone] = true
                    end
                end
                
                ::continue::
            end
        end
    end

    return attachments
end

local function cleanupPartial(loadingId)
    if _s.currentLoadingId ~= loadingId then return end

    if _s.cam and DoesCamExist(_s.cam) then
        DestroyCam(_s.cam, true)
        _s.cam = nil
    end

    -- Delete all attachments
    for _, attachment in ipairs(_s.attachments) do
        if attachment.entity then
            DeleteEntity(attachment.entity)
        end
    end
    _s.attachments = {}

    if _s.object then
        DeleteEntity(_s.object)
        _s.object = nil
    end

    if _s.isSceneLoading then
        NewLoadSceneStop()
        _s.isSceneLoading = false
    end
end

---Carrega a cena e aguarda o interior estar 100% pronto.
---Espelha a abordagem de CameraManager:loadSceneOnce do dminigames.
---@param loadingId number ID da operação atual (race-condition guard)
---@return boolean success
local function loadScene(loadingId)
    local center     = INTERIOR_COORDS
    local interiorID = GetInteriorAtCoords(center.x, center.y, center.z)

    if interiorID ~= 0 then
        RefreshInterior(interiorID)
        PinInteriorInMemory(interiorID)
    end

    -- SetFocusArea antes do NewLoadSceneStart garante streaming correto
    SetFocusArea(center.x, center.y, center.z, 0.0, 0.0, 0.0)
    NewLoadSceneStart(center.x, center.y, center.z, 0.0, 0.0, 0.0, 50.0, 0)
    _s.isSceneLoading = true

    local startTime   = GetGameTimer()
    local timeout     = 5000

    while not IsNewLoadSceneLoaded() do
        if _s.currentLoadingId ~= loadingId then
            NewLoadSceneStop()
            ClearFocus()
            _s.isSceneLoading = false
            cleanupPartial(loadingId)
            _s.isProcessing = false
            return false
        end
        if interiorID ~= 0 and not IsInteriorReady(interiorID) then
            PinInteriorInMemory(interiorID)
        end
        if GetGameTimer() - startTime > timeout then
            NewLoadSceneStop()
            ClearFocus()
            DoScreenFadeIn(500)
            _s.isSceneLoading = false
            _s.isProcessing   = false
            return false
        end
        Wait(1)
    end

    -- Aguarda interior estar 100% pronto (max 2s), como camera.lua
    if interiorID ~= 0 then
        local interiorStart = GetGameTimer()
        while not IsInteriorReady(interiorID) do
            if _s.currentLoadingId ~= loadingId then
                NewLoadSceneStop()
                ClearFocus()
                _s.isSceneLoading = false
                cleanupPartial(loadingId)
                _s.isProcessing = false
                return false
            end
            if GetGameTimer() - interiorStart > 2000 then break end
            Wait(1)
        end
    end

    NewLoadSceneStop()
    _s.isSceneLoading = false

    -- Só agora pina o foco no ponto exato (após streaming pronto)
    SetFocusPosAndVel(center.x, center.y, center.z, 0.0, 0.0, 0.0)
    _s.sceneFocusActive = true

    return true
end

local function restorePlayerCollisionAfterScene()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    FreezeEntityPosition(ped, true)

    local deadline = GetGameTimer() + COLLISION_RESTORE_TIMEOUT_MS

    while not HasCollisionLoadedAroundEntity(ped) do
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)

        if GetGameTimer() >= deadline then
            break
        end

        Wait(0)
    end

    FreezeEntityPosition(ped, false)
end

local function waitForModel(loadingId, componentModel)
    local start = GetGameTimer()
    while not HasModelLoaded(componentModel) do
        if _s.currentLoadingId ~= loadingId then
            cleanupPartial(loadingId)
            _s.isProcessing = false
            return false
        end
        if GetGameTimer() - start > 1000 then
            cleanupPartial(loadingId)
            _s.isProcessing = false
            return false
        end
        Wait(1)
    end

    if _s.currentLoadingId ~= loadingId then
        cleanupPartial(loadingId)
        _s.isProcessing = false
        return false
    end

    return true
end

-- ── API pública ─────────────────────────────────────────────────

WeaponView = {}

function WeaponView.setup(componentHash, component, isCustomWeapon)
    local now = GetGameTimer()

    if now - _s.lastCallTime < DEBOUNCE_TIME then return end
    _s.lastCallTime = now

    if _s.isProcessing then return end
    _s.isProcessing     = true
    local loadingId     = now + math.random(1000, 9999)
    _s.currentLoadingId = loadingId
    _s.fadeTimeout      = nil

    -- Delete all existing attachments
    for _, attachment in ipairs(_s.attachments) do
        if attachment.entity then
            DeleteEntity(attachment.entity)
        end
    end
    _s.attachments = {}

    if _s.object then
        DeleteEntity(_s.object)
        _s.object = nil
    end

    if _s.cam and DoesCamExist(_s.cam) then
        DestroyCam(_s.cam, true)
        _s.cam = nil
    end

    if _s.isSceneLoading then
        NewLoadSceneStop()
        _s.isSceneLoading = false
    end

    if not sx.client.visibility.hasVisibilityOverride() then
        sx.client.visibility.beginVisibilityOverride()
    end

    exports["worldstate"]:SetWorldClockOverride(0)

    if not _s.firstFade then
        _s.firstFade = true
    else
        DoScreenFadeOut(1)
    end

    if not loadScene(loadingId) then return end

    setBackgroundColor(cityColor)

    local componentModel = nil
    if isCustomWeapon then
        componentModel = GetWeapontypeModel(componentHash)
    else
        componentModel = GetWeaponComponentTypeModel(component)
    end
    local weapon         = GetSkinWeapon(component)
    local weaponHash     = isCustomWeapon and componentHash or GetHashKey(weapon)
    local attachmentList = getWeaponAttachments(component, weaponHash, component)

    RequestModel(componentModel)

    -- Request all attachment models
    if attachmentList and #attachmentList > 0 then
        for _, attachment in ipairs(attachmentList) do
            RequestModel(attachment.model)
        end
    end

    local color = GetWeaponBackgroundColor(component)
    setBackgroundColor(color or cityColor)


    if not waitForModel(loadingId, componentModel) then
        return
    end

    -- Wait for all attachment models to load
    if attachmentList and #attachmentList > 0 then
        for _, attachment in ipairs(attachmentList) do
            waitForModel(loadingId, attachment.model)
        end
    end

    if _s.cam and DoesCamExist(_s.cam) then
        DestroyCam(_s.cam, true)
        _s.cam = nil
    end

    local offset = GetSkinOffset(component)
    _s.object = CreateObject(
        componentModel,
        CENTER_COORDS.x + offset.x,
        CENTER_COORDS.y + offset.y,
        CENTER_COORDS.z + offset.z,
        false, true, 0
    )
    SetEntityCollision(_s.object, false, true)
    FreezeEntityPosition(_s.object, true)

    -- Create and attach all weapon attachments (magazine, grip, scope, etc)
    if attachmentList and #attachmentList > 0 then
        for _, attachmentData in ipairs(attachmentList) do

            local attachEntity = CreateObject(
                attachmentData.model,
                CENTER_COORDS.x + offset.x,
                CENTER_COORDS.y + offset.y,
                CENTER_COORDS.z + offset.z,
                false, true, 0
            )

            if attachEntity and attachEntity ~= 0 then
                SetEntityCollision(attachEntity, false, true)
                FreezeEntityPosition(attachEntity, true)

                -- Get bone index
                local boneIndex = GetEntityBoneIndexByName(_s.object, attachmentData.bone)
                if boneIndex == -1 then
                    -- Try alternative bone names
                    if attachmentData.bone == "WAPScop" then
                        boneIndex = GetEntityBoneIndexByName(_s.object, "WAPScope") or -1
                    end
                end

                if boneIndex ~= -1 then
                    AttachEntityToEntity(
                        attachEntity,
                        _s.object,
                        boneIndex,
                        0.0, 0.0, 0.0,
                        0.0, 0.0, 0.0,
                        false, false, false, false,
                        0, true
                    )
                    else
                    AttachEntityToEntity(
                        attachEntity,
                        _s.object,
                        0,  -- Root bone
                        0.0, 0.0, 0.0,
                        0.0, 0.0, 0.0,
                        false, false, false, false,
                        0, true
                    )
                end

                -- Store reference
                table.insert(_s.attachments, {
                    entity = attachEntity,
                    name = attachmentData.name,
                    bone = attachmentData.bone
                })
            else
            end
        end
    end

    local camCoords = vector3(CENTER_CAM_COORDS.x, CENTER_CAM_COORDS.y - 1.5, CENTER_CAM_COORDS.z)

    _s.cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camCoords, 0.0, 0.0, 0, 0.0, false, 0)

    -- PointCamAtCoord(_s.cam, CENTER_COORDS.x, CENTER_COORDS.y, CENTER_COORDS.z)

    local weapon_type = getWeaponType(component)

    SetCamFov(_s.cam, FOV_BY_TYPE[weapon_type] or DEFAULT_FOV)
    SetCamUseShallowDofMode(_s.cam, true)
    SetCamNearDof(_s.cam, NEAR_DOF)
    SetCamFarDof(_s.cam, FAR_DOF)
    SetCamDofStrength(_s.cam, DOF_STRENGTH)
    SetCamActive(_s.cam, true)
    RenderScriptCams(true, false, 0, true, true)

    SetEntityRotation(_s.object, 0.0, 0.0, 0.0, 2, true)

    _s.fadeTimeout = SetTimeout(500, function()
        if _s.currentLoadingId == loadingId then
            DoScreenFadeIn(500)
        end
        _s.fadeTimeout = nil
    end)

    _s.isProcessing = false
end

function WeaponView.cleanup()
    _s.fadeTimeout = nil

    if _s.lastBackground then
        if _s.lastBackground.duiObject then
            DestroyDui(_s.lastBackground.duiObject)
        end
        if _s.lastBackground.runtimeTxd then
            RemoveReplaceTexture("santagroup_guns_bg", "background_color")
            RemoveReplaceTexture("santagroup_guns_bg", "preto")
        end
        _s.lastBackground = nil
    end

    if _s.isSceneLoading then
        NewLoadSceneStop()
        _s.isSceneLoading = false
    end

    local shouldRestoreCollision = _s.sceneFocusActive
    _s.sceneFocusActive = false

    ClearFocus()

    if shouldRestoreCollision then
        restorePlayerCollisionAfterScene()
    end

    exports["worldstate"]:SetWorldClockOverride(nil)

    if sx.client.visibility.hasVisibilityOverride() then
        sx.client.visibility.endVisibilityOverride()
    end

    -- Delete all attachments
    for _, attachment in ipairs(_s.attachments) do
        if attachment.entity then
            DeleteEntity(attachment.entity)
        end
    end
    _s.attachments = {}

    if _s.object then
        DeleteEntity(_s.object)
        _s.object = nil
    end

    if _s.cam then
        DestroyCam(_s.cam, true)
        _s.cam = nil
    end

    RenderScriptCams(false, true, 1, true, true)
    SetNuiFocus(false, false)

    _s.isProcessing     = false
    _s.currentLoadingId = nil
end

-- ── Luzes de studio ─────────────────────────────────────────────

local function normalizeDir(from, to)
    local dx, dy, dz = to.x - from.x, to.y - from.y, to.z - from.z
    local mag = math.sqrt(dx * dx + dy * dy + dz * dz)
    if mag == 0 then return 0.0, 1.0, 0.0 end
    return dx / mag, dy / mag, dz / mag
end

local function drawStudioLights()
    for _, light in ipairs(LIGHTS) do
        local pos = CENTER_COORDS + light.offset
        local dx, dy, dz = normalizeDir(pos, CENTER_COORDS)
        DrawSpotLight(
            pos.x, pos.y, pos.z,
            dx, dy, dz,
            light.r, light.g, light.b,
            light.dist, light.bright,
            0.0, light.radius, 1.0
        )
    end
end

-- ── Rotação do prop ─────────────────────────────────────────────

local function rotatePropWithMouse()
    if not _s.object then return end

    local mouseX, mouseY = GetNuiCursorPosition()

    if _s.isLeftMouseDown then
        if not _s.isRotating then
            _s.isRotating = true
            _s.lastMouseX = mouseX
            _s.lastMouseY = mouseY
        else
            local dx  = (mouseX - _s.lastMouseX) * 0.2
            local dy  = (mouseY - _s.lastMouseY) * 0.2
            local rot = GetEntityRotation(_s.object)
            SetEntityRotation(_s.object, rot.x + dy, rot.y, rot.z + dx, 2, true)
            _s.lastMouseX = mouseX
            _s.lastMouseY = mouseY
        end
    else
        _s.isRotating = false
    end
end

-- ── NUI callbacks de interação com a view ───────────────────────

RegisterNUICallback("mouseEvent", function(data, cb)
    _s.isLeftMouseDown = data.pressed
    cb(true)
end)

RegisterNUICallback("zoomSkin", function(data, cb)
    if _s.cam and DoesCamExist(_s.cam) then
        local delta = (data.direction == -1) and 1 or -1
        SetCamFov(_s.cam, GetCamFov(_s.cam) + delta)
    end
    cb(true)
end)

RegisterNUICallback("selectSkin", function(data, cb)
    local isCustomWeapon = exports.new_hub:IsCustomWeapon( data.component )
    local weaponName = exports.new_hub:GetSkinWeaponName( data.component )
    if isCustomWeapon then
        WeaponView.setup(GetHashKey(weaponName), data.component, true)
    else
        WeaponView.setup(GetHashKey(data.component), data.component)
    end
    cb(true)
end)

-- ── Thread de rotação e lifecycle ───────────────────────────────

CreateThread(function()
    while true do
        if _s.object then
            rotatePropWithMouse()
            -- drawStudioLights()
        end
        Wait(0)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        WeaponView.cleanup()
        LeaveCursorMode()
    end
end)
