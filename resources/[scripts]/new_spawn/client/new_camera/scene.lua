Scene = class()

function Scene:__init()
    local city = GetConvar("cityName", "")
    self.config           = CameraConfig[city] or CameraConfig['DEFAULT']
    NsDbgLog(('[nsdbg] Scene:__init city=%s config=%s'):format( city, CameraConfig[city] and city or 'DEFAULT' ) )
    self.currentLoadingId = 0
    self.isSceneLoading   = false
    self.isProcessing     = false
    self.spawned          = {}
    self.models           = {}
    for k, v in pairs(self.config.MODELS) do self.models[k] = v end
    self.dev = true
end

---Carrega a cena e aguarda o interior estar 100% pronto.
---@param loadingId number ID da operação atual (race-condition guard)
---@return boolean success
function Scene:loadArea(loadingId)
    self.currentLoadingId = loadingId

    local center          = self.config.START_POS
    local interiorID      = GetInteriorAtCoords(center.x, center.y, center.z)

    NsDbgLog(('[nsdbg] Scene:loadArea id=%s center=%s interior=%s'):format( loadingId, center, interiorID ) )

    SetEntityCoords(PlayerPedId(), center.x, center.y, center.z)

    if interiorID ~= 0 then
        RefreshInterior(interiorID)
        PinInteriorInMemory(interiorID)
    end

    ClearAreaOfEverything(center.x, center.y, center.z, 100.0, false, false, false, false)

    -- NÃO combinar SetFocusArea com NewLoadSceneStart: o load scene gerencia o próprio focus
    -- interno e a combinação briga com o streaming (CTD nos SetFocus*). O foco fixo da cena
    -- entra só depois do NewLoadSceneStop, via SetFocusPosAndVel.
    NewLoadSceneStart(center.x, center.y, center.z, 0.0, 0.0, 0.0, 150.0, 0)
    self.isSceneLoading = true

    local startTime     = GetGameTimer()
    local timeout       = 5000

    while not IsNewLoadSceneLoaded() do
        if self.currentLoadingId ~= loadingId then
            NewLoadSceneStop()
            ClearFocus()
            self.isSceneLoading = false
            self.isProcessing   = false
            NsDbgLog(('[nsdbg] Scene:loadArea cancelado (id trocou) em %dms'):format( GetGameTimer() - startTime ) )
            return false
        end

        if interiorID ~= 0 and not IsInteriorReady(interiorID) then
            PinInteriorInMemory(interiorID)
        end

        if GetGameTimer() - startTime > timeout then
            NewLoadSceneStop()
            ClearFocus()
            DoScreenFadeIn(500)
            self.isSceneLoading = false
            self.isProcessing   = false
            NsDbgLog(('[nsdbg] Scene:loadArea timeout em %dms'):format( GetGameTimer() - startTime ) )
            return false
        end

        Wait(1)
    end

    -- Aguarda interior estar 100% pronto (max 2s)
    if interiorID ~= 0 then
        local interiorStart = GetGameTimer()
        while not IsInteriorReady(interiorID) do
            if self.currentLoadingId ~= loadingId then
                NewLoadSceneStop()
                ClearFocus()
                self.isSceneLoading = false
                self.isProcessing   = false
                NsDbgLog(('[nsdbg] Scene:loadArea cancelado no wait do interior em %dms'):format( GetGameTimer() - startTime ) )
                return false
            end
            if GetGameTimer() - interiorStart > 2000 then break end
            Wait(1)
        end
    end

    NewLoadSceneStop()
    self.isSceneLoading = false

    -- Só agora pina o foco no ponto exato (após streaming pronto)
    SetFocusPosAndVel(center.x, center.y, center.z, 0.0, 0.0, 0.0)

    NsDbgLog(('[nsdbg] Scene:loadArea ok em %dms'):format( GetGameTimer() - startTime ) )
    return true
end

---Descarrega a cena e limpa o foco.
function Scene:unloadArea()
    self.currentLoadingId = self.currentLoadingId + 1 -- invalida qualquer load() em curso
    NsDbgLog('[nsdbg] Scene:unloadArea' )

    -- Depois que loadArea termina, qualquer NewLoadScene ativo pode pertencer ao
    -- admin:Teleport do spawn. A Scene só encerra o load enquanto ainda é dona dele.
    if self.isSceneLoading and IsNewLoadSceneActive() then
        NewLoadSceneStop()
    end
    self.isSceneLoading = false

    if not IsNewLoadSceneActive() then
        ClearFocus()
    end

    return true
end

function Scene:loadModels(playerCharacters)
    NsDbgLog(('[nsdbg] Scene:loadModels chars=%d'):format( #playerCharacters ) )
    for _, character in pairs(playerCharacters) do
        self.models[character.model] = character.model
    end

    local function loadSingleModel(model)
        local startTime = GetGameTimer()
        local timeout   = startTime + 10000
        while not HasModelLoaded(model) do
            if GetGameTimer() > timeout then
                NsDbgLog(('[nsdbg] Scene:loadModels timeout model=%s em %dms'):format( model, GetGameTimer() - startTime ) )
                return false
            end
            RequestModel(model)
            Wait(1)
        end
        NsDbgLog(('[nsdbg] Scene:loadModels ok model=%s em %dms'):format( model, GetGameTimer() - startTime ) )
        return true
    end

    for key, model in pairs(self.models) do
        -- 'locked'/'unlocked' só são usados em peds "ghosted" (slots vazios). Com
        -- USE_GHOSTED_PEDS desligado eles nunca são usados, e carregá-los trava em
        -- modelos especiais (mp_*_character_select) que não streamam em todas as cidades.
        local ghostOnlyModel = (key == 'locked' or key == 'unlocked')
        if not (ghostOnlyModel and not self.config.USE_GHOSTED_PEDS) then
            if type(model) == 'table' then
                for _, m in ipairs(model) do
                    if not loadSingleModel(m) then return false end
                end
            else
                if not loadSingleModel(model) then return false end
            end
        end
    end

    return true
end

function Scene:createCharacters(startAt, endAt, playerCharacters)
    NsDbgLog(('[nsdbg] Scene:createCharacters %s..%s'):format( startAt, endAt ) )
    for i = startAt, endAt do
        local data = self.config.PED_POSITIONS[i]
        local character = playerCharacters[i]
        if (character) then
            NsDbgLog(('[nsdbg] createCharacters i=%d model=%s'):format( i, character.model ) )
            local anim = data.anim

            local ped = CreatePed(4, character.model, data.coord.x, data.coord.y, data.coord.z - 1.0, data.coord.w, false,
            false)

            SetEntityCollision(ped, false, false)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            FreezeEntityPosition(ped, true)
            SetModelAsNoLongerNeeded(character.model)

            self:applyAppearances(character, ped)
            self:applyAnimation(anim, ped)

            self.spawned[i] = ped
        end
    end

    if (not self.config.USE_GHOSTED_PEDS) then
        return
    end

    NsDbgLog('[nsdbg] createCharacters ghosted peds' )
    for i = 1, #self.config.PED_POSITIONS do
        if not self.spawned[i] then
            local data = self.config.PED_POSITIONS[i]

            local lockedModels = self.models['locked']
            local lockedModel  = lockedModels[((i - 1) % #lockedModels) + 1]

            local ped = CreatePed(4, lockedModel, data.coord.x, data.coord.y, data.coord.z - 1.0, data.coord.w, false, false)
            SetEntityCollision(ped, false, false)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            FreezeEntityPosition(ped, true)
            SetModelAsNoLongerNeeded(lockedModel)
            self:applyAnimation(data.anim, ped)
            SetEntityAlpha(ped, 180, false)
            self.spawned[i] = ped
        end
    end
end

function Scene:applyAppearances(character, ped)
    if character.clothings then
        NsDbgLog(('[nsdbg] applyAppearances skinshop ped=%s'):format( ped ) )
        exports["skinshop"]:Apply(character.clothings, ped)
    end
    if character.barbershop then
        NsDbgLog(('[nsdbg] applyAppearances barbershop ped=%s'):format( ped ) )
        TriggerEvent('net.character-creator.set-customization', character.barbershop, ped)
    end
    if character.tattooshop then
        NsDbgLog(('[nsdbg] applyAppearances tattooshop ped=%s'):format( ped ) )
        exports["tattooshop"]:Apply(character.tattooshop, ped)
    end
    NsDbgLog(('[nsdbg] applyAppearances done ped=%s'):format( ped ) )
end

function Scene:applyAnimation(animData, ped)
    local dict = animData.dict
    local anim = animData.anim

    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 1, 0.0, false, false, false)
end

function Scene:loadAnimations()
    NsDbgLog('[nsdbg] Scene:loadAnimations' )
    for _, data in pairs(self.config.PED_POSITIONS) do
        local animData = data.anim
        local dict = animData.dict

        local now = GetGameTimer()
        local timeout = now + 10000

        while not HasAnimDictLoaded(dict) do
            if (GetGameTimer() > timeout) then
                NsDbgLog(('[nsdbg] Scene:loadAnimations timeout dict=%s em %dms'):format( dict, GetGameTimer() - now ) )
                return false
            end

            RequestAnimDict(dict)
            Wait(1)
        end
    end

    return true
end

---@param id number índice 1-based do personagem em Scene.spawned
function Scene:focus(id)
    NsDbgLog(('[nsdbg] Scene:focus id=%s'):format( id ) )
    CameraManager:focus(id)
end

function Scene:play()
    NsDbgLog('[nsdbg] Scene:play' )
    CameraManager:play()
end

function Scene:deleteCharacters()
    NsDbgLog(('[nsdbg] Scene:deleteCharacters count=%d'):format( #self.spawned ) )
    for _, ped in pairs(self.spawned) do
        DeleteEntity(ped)
    end
    self.spawned = {}
end

function Scene:unloadAnimations()
    for _, data in pairs(self.config.PED_POSITIONS) do
        local animData = data.anim
        local dict = animData.dict
        if HasAnimDictLoaded(dict) then
            RemoveAnimDict(dict)
        end
    end
end

function Scene:start(loadingId, startAt, endAt, playerCharacters)
    self:unloadArea()

    -- o caller passa sempre 1; id fixo deixava dois loadArea "válidos" ao mesmo tempo
    -- (cada um dando NewLoadSceneStart/Stop + SetFocusPosAndVel) — gera id único real
    loadingId = self.currentLoadingId + 1

    NsDbgLog(('[nsdbg] Scene:start id=%s %s..%s chars=%d'):format( loadingId, startAt, endAt, #playerCharacters ) )

    local loadedArea = self:loadArea(loadingId)
    if not loadedArea then
        NsDbgLog('[nsdbg] Scene:start abortado - area nao carregou' )
        return
    end

    local loadedAnimations = self:loadAnimations()
    if not loadedAnimations then
        NsDbgLog('[nsdbg] Scene:start abortado - animacoes nao carregaram' )
        return
    end

    local loadedModels = self:loadModels(playerCharacters)
    if not loadedModels then
        NsDbgLog('[nsdbg] Scene:start abortado - models nao carregaram' )
        return
    end

    self:createCharacters(startAt, endAt, playerCharacters)

    NsDbgLog('[nsdbg] Scene:start -> CameraManager:start(1)' )
    CameraManager:start(1)
end

function Scene:stop()
    NsDbgLog('[nsdbg] Scene:stop' )
    CameraManager:destroy()
    self:deleteCharacters()
    self:unloadArea()
    self:unloadAnimations()
    NsDbgLog('[nsdbg] Scene:stop done' )
end

Scene = Scene()
