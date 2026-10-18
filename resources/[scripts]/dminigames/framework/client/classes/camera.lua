---@class CameraManager
---@field active boolean
---@field camera number|nil
---@field spline number|nil
---@field transitionThread thread|nil
---@field looped boolean
---@field splines table|nil
---@field nextSplineStartTime number|nil

CameraManager = class()

local SCENE_LOAD_TIMEOUT_FAST = 3000 -- Primeira tentativa: 3s (maioria dos PCs)
local SCENE_LOAD_TIMEOUT_NORMAL = 8000 -- Segunda tentativa: 8s (PCs lentos)
local SCENE_LOAD_TIMEOUT_SLOW = 15000 -- Terceira tentativa: 15s (último recurso)

---Inicializa o CameraManager
function CameraManager:__init()
    self.active = false
    self.camera = nil
    self.spline = nil
    self.transitionThread = nil
    self.looped = true
    self._scenePreLoaded = false -- Cena carregada uma vez (como draces), não por spline
end

---Carrega a cena UMA VEZ antes de iniciar a câmera (como draces FinishManager.loadArea).
---Evita que alguns jogadores não vejam a cinemática (timeout de 2s por spline falhava em PCs lentos).
---@param center vec3 Centro da área (ex: primeira spline)
---@param stateChecker? function Função que retorna true se ainda deve continuar carregando (previne race condition)
---@param customTimeout? number Timeout customizado em ms (para retries)
---@return boolean success
function CameraManager:loadSceneOnce(center, stateChecker, customTimeout)
    if not center then 
        -- print('[CAMERA DEBUG] ❌ loadSceneOnce: center é nil')
        return false 
    end
    self._scenePreLoaded = false
    local startTime = GetGameTimer()
    local timeout = customTimeout or SCENE_LOAD_TIMEOUT_FAST
    
    -- print(('[CAMERA DEBUG] ▶️ Iniciando loadSceneOnce | Timeout: %dms | Center: %.2f, %.2f, %.2f'):format( timeout, center.x, center.y, center.z ))

    -- 1. Identifica se é um interior
    local interiorID = GetInteriorAtCoords(center.x, center.y, center.z)
    -- print(('[CAMERA DEBUG] Interior ID: %d | É interior: %s'):format(interiorID, tostring(interiorID ~= 0)))

    DoScreenFadeOut(1)
    -- print('[CAMERA DEBUG] 🔳 Tela fade out iniciado')

    -- Se for interior, força refresh para evitar tela preta (interior não carregado)
    if interiorID ~= 0 then
        -- print('[CAMERA DEBUG] 🏠 Carregando interior...')
        RefreshInterior(interiorID)
        PinInteriorInMemory(interiorID)
        -- print('[CAMERA DEBUG] 📌 Interior pinado na memória')
    end

    -- 2. Inicia o carregamento pesado
    SetFocusArea(center.x, center.y, center.z, 0.0, 0.0, 0.0)
    NewLoadSceneStart(center.x, center.y, center.z, 0.0, 0.0, 0.0, 50.0, 0)
    -- print('[CAMERA DEBUG] 🔄 NewLoadSceneStart iniciado')

    -- 3. Loop de carregamento híbrido
    local loopIterations = 0
    local lastLogTime = GetGameTimer()
    while not IsNewLoadSceneLoaded() do
        Wait(1)
        loopIterations = loopIterations + 1
        
        -- Log a cada 1 segundo para não spammar
        if GetGameTimer() - lastLogTime > 1000 then
            local elapsed = GetGameTimer() - startTime
            local remaining = timeout - elapsed
            -- print(('[CAMERA DEBUG] ⏳ Carregando... | Tempo: %dms/%dms | Iterações: %d'):format( elapsed, timeout, loopIterations ))
            lastLogTime = GetGameTimer()
        end
        
        -- ✅ FIX RACE CONDITION: Verifica se ainda deve continuar (ex: ainda está na fila)
        if stateChecker and not stateChecker() then
            -- Estado mudou (match iniciou), aborta carregamento
            -- print('[CAMERA DEBUG] ⚠️ Estado mudou durante carregamento, abortando')
            NewLoadSceneStop()
            ClearFocus()
            DoScreenFadeIn(500)  -- Recupera da tela preta
            return false
        end
        
        -- Se for interior, garante que ele está pronto
        if interiorID ~= 0 and not IsInteriorReady(interiorID) then
            PinInteriorInMemory(interiorID)
        end

        if GetGameTimer() - startTime > timeout then
            -- ✅ FIX TIMEOUT: Recupera da tela preta ao invés de deixar permanente
            local elapsed = GetGameTimer() - startTime
            -- print(('[CAMERA DEBUG] ⏱️ TIMEOUT após %dms | Iterações: %d'):format(elapsed, loopIterations))
            NewLoadSceneStop()
            ClearFocus()
            DoScreenFadeIn(500)
            return false
        end
    end
    
    -- print(('[CAMERA DEBUG] ✅ Cena carregada! | Tempo: %dms | Iterações: %d'):format( GetGameTimer() - startTime, loopIterations ))
    
    -- ✅ FIX INTERIOR: Check final se interior está 100% pronto antes de iniciar câmera
    if interiorID ~= 0 then
        -- print('[CAMERA DEBUG] 🔍 Verificando se interior está 100% pronto...')
        local interiorWaitStart = GetGameTimer()
        local interiorWaitIterations = 0
        while not IsInteriorReady(interiorID) do
            Wait(1)
            interiorWaitIterations = interiorWaitIterations + 1
            
            -- Verifica estado novamente durante espera de interior
            if stateChecker and not stateChecker() then
                -- print('[CAMERA DEBUG] ⚠️ Estado mudou durante espera de interior, abortando')
                NewLoadSceneStop()
                ClearFocus()
                DoScreenFadeIn(500)
                return false
            end
            
            if GetGameTimer() - interiorWaitStart > 2000 then
                -- Max 2s extra para interior ficar pronto
                -- print(('[CAMERA DEBUG] ⚠️ Interior timeout após %dms | Iterações: %d'):format( GetGameTimer() - interiorWaitStart, interiorWaitIterations ))
                break
            end
        end
        
        if IsInteriorReady(interiorID) then
            -- print(('[CAMERA DEBUG] ✅ Interior pronto! | Tempo espera: %dms'):format( GetGameTimer() - interiorWaitStart ))
        end
    end

    -- O estado pode mudar exatamente quando IsNewLoadSceneLoaded() passa a true.
    -- Revalida antes de assumir o foco para uma câmera que já foi encerrada.
    if stateChecker and not stateChecker() then
        NewLoadSceneStop()
        ClearFocus()
        DoScreenFadeIn(500)
        return false
    end

    SetFocusPosAndVel(center.x, center.y, center.z, 0.0, 0.0, 0.0)
    self._scenePreLoaded = true
    -- print(('[CAMERA DEBUG] ✅ loadSceneOnce concluído com sucesso | Tempo total: %dms'):format( GetGameTimer() - startTime ))
    return true
end

---Define as splines da câmera
---@param splines table Array de configurações de spline
---@return nil
function CameraManager:setSplines(splines)
    -- Se já estiver ativo, para antes de definir novas splines
    if self.active then
        self.active = false
        if self.camera then
            DestroyCam(self.camera, true)
            self.camera = nil
        end
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyAllCams(true)
    end
    self.splines = splines
end

---Destrói a câmera e limpa recursos
---@return boolean success Se a câmera foi destruída com sucesso
---@return string message Mensagem de status
function CameraManager:destroyCamera()
    local stateManager = PlayerStateManager:getInstance()
    
    -- ✅ REFATORADO: Cancela todas as operações da câmera no PlayerStateManager
    -- Isso garante que invencibilidade e outras operações sejam limpas
    stateManager:cancelOwnerOperations('camera')
    
    -- Para o loop de transição primeiro (mais importante - faz o thread sair rapidamente)
    self.active = false
    self.looped = false -- Garante que não vai tentar fazer loop

    -- Limpa splines primeiro para evitar que o thread tente criar novas splines
    self.splines = nil

    -- Destrói a câmera imediatamente
    if self.camera then
        DestroyCam(self.camera, true)
        self.camera = nil
    end

    -- Para renderização de câmeras script
    RenderScriptCams(false, false, 0, 1, 0)

    -- Destrói todas as câmeras
    DestroyAllCams(true)

    -- Limpa focus e scene
    self._scenePreLoaded = false
    NewLoadSceneStop()
    ClearFocus()

    -- ✅ FIX PERFORMANCE: Fade in mais rápido (500ms ao invés de 1000ms)
    DoScreenFadeIn(500)

    -- Limpa referências
    self.spline = nil
    self.transitionThread = nil

    return true, 'cam destroyed'
end

---Verifica se a transição da câmera terminou
---@return boolean ended Se a transição terminou
---@return number spline Índice da spline atual
---@return boolean last Se é a última spline
function CameraManager:hasTransitionEnded()
    -- Verifica se ainda está ativo
    if not self.active then
        return false, self.spline or 0, false
    end

    -- Verifica se há splines configurados
    if not self.splines or #self.splines == 0 then
        return false, self.spline or 0, false
    end

    local currentTime = GetGameTimer()

    if (self.spline == #self.splines + 1) then
        return true, self.spline, true
    end

    if (currentTime >= self.nextSplineStartTime) then
        if (self.spline <= #self.splines) then
            self.spline = self.spline + 1
        end

        -- calcular o próximo tempo apenas se ainda houver splines
        if self.spline <= #self.splines then
            self.nextSplineStartTime = currentTime + self.splines[self.spline].interval
        end

        DoScreenFadeOut(1)
        -- Não chama NewLoadSceneStop — cena foi pré-carregada (como draces)
        return true, self.spline, false
    end

    return false, self.spline, false
end

---Cria uma spline de câmera
---@param splineId number ID da spline a ser criada
---@return boolean success Se a spline foi criada com sucesso
---@return string message Mensagem de status
function CameraManager:createSpline(splineId)
    -- Verifica se ainda está ativo antes de criar
    if not self.active then
        return false, 'camera not active'
    end

    local spline = self.splines[splineId]
    if (not spline) then
        return false, 'spline not found'
    end

    -- Não chama NewLoadSceneStop/ClearFocus aqui — cena foi pré-carregada (como draces)
    if (self.camera) then
        DestroyCam(self.camera, true)
        self.camera = nil
    end

    RenderScriptCams(false, false, 0, 1, 0)
    DestroyAllCams(true)

    if not self.active then
        return false, 'camera destroyed during creation'
    end

    self.camera = CreateCam('DEFAULT_SPLINE_CAMERA', true)
    SetCamCoord(self.camera, spline.from.x, spline.from.y, spline.from.z)
    PointCamAtCoord(self.camera, spline.center.x, spline.center.y, spline.center.z)

    -- Atualiza focus para esta spline (cena já carregada em loadSceneOnce)
    SetFocusPosAndVel(spline.center.x, spline.center.y, spline.center.z, 0.0, 0.0, 0.0)

    AddCamSplineNode(self.camera, spline.from.x, spline.from.y, spline.from.z, 0.0, 0.0, 0.0, 1, 1, 1)
    AddCamSplineNode(self.camera, spline.to.x, spline.to.y, spline.to.z, 0.0, 0.0, 0.0, 1, 1, 1)
    SetCamSplineDuration(self.camera, spline.interval)
    
    -- ✅ FIX PERFORMANCE: Renderiza câmera sem transição (mais rápido)
    RenderScriptCams(true, false, 0, false, true)
    
    -- ✅ FIX PERFORMANCE: Fade in mais rápido (500ms ao invés de 1000ms)
    DoScreenFadeIn(500)
    return true, 'spline created'
end

---Inicia a transição de câmera entre splines
---@param looped boolean Se true, faz loop infinito; se false, executa apenas uma vez
---@return nil
function CameraManager:transitionCamera(looped)
    -- Define se deve fazer loop (padrão é true para manter compatibilidade)
    self.looped = looped ~= false

    -- Verifica se há splines configurados
    if not self.splines or #self.splines == 0 then
        return
    end

    -- Para qualquer transição anterior se estiver rodando
    if self.active then
        self.active = false
        -- Destrói câmera atual se existir
        if self.camera then
            DestroyCam(self.camera, true)
            self.camera = nil
        end
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyAllCams(true)
        -- Aguarda um pouco para garantir que tudo foi limpo
        Wait(50)
    end

    -- Pré-carrega cena se ainda não foi (para doPlayerPresentationAtCoord e outros fluxos)
    if not self._scenePreLoaded and self.splines[1] and self.splines[1].center then
        self:loadSceneOnce(self.splines[1].center)
    end
    
    self.active = true
    self.spline = 1
    self.nextSplineStartTime = GetGameTimer() + self.splines[self.spline].interval

    self:createSpline(self.spline)

    -- Cria novo thread de transição
    self.transitionThread = CreateThread(function()
        while self.active do
            -- Verifica se ainda está ativo antes de processar
            if not self.active then
                break
            end

            -- Verifica se há splines (podem ter sido limpos)
            if not self.splines or #self.splines == 0 then
                break
            end

            local ended, spline, last = self:hasTransitionEnded()

            -- Verifica novamente se ainda está ativo após hasTransitionEnded
            if not self.active then
                break
            end

            -- Verifica novamente se há splines
            if not self.splines or #self.splines == 0 then
                break
            end

            if (last) then
                -- Ao chegar no último spline
                if self.looped then
                    -- Se looped for true, reinicia do primeiro (loop)
                    if self.active and self.splines and #self.splines > 0 then
                        self.spline = 1
                        self.nextSplineStartTime = GetGameTimer() + self.splines[self.spline].interval
                        self:createSpline(self.spline)
                    end
                else
                    -- Se looped for false, para a transição (executa apenas uma vez)
                    -- Faz fade out antes de destruir
                    DoScreenFadeOut(500)
                    Wait(500) -- Aguarda o fade out completar
                    self.active = false
                    break
                end
            elseif (ended) then
                -- Só cria nova spline se ainda estiver ativo
                if self.active and self.splines and #self.splines > 0 then
                    self:createSpline(spline)
                end
            end

            Wait(0)
        end

        -- Destrói a câmera imediatamente quando o loop termina (sem delay)
        self:destroyCamera()

        -- Limpa referência do thread quando termina
        self.transitionThread = nil
    end)
end

---Apresenta o jogador em uma coordenada específica
---@param coord vector4 Coordenadas para apresentação
---@param duration number Duração da apresentação em ms
---@return nil
function CameraManager:doPlayerPresentationAtCoord(coord, duration)
    local playerPed = PlayerPedId()
    local stateManager = PlayerStateManager:getInstance()

    -- Força o teleporte imediatamente
    SetEntityCoords(playerPed, coord.x, coord.y, coord.z, false, false, false, true)
    SetEntityHeading(playerPed, coord.w)
    
    -- Freeza o jogador e mantém durante toda a apresentação
    FreezeEntityPosition(playerPed, true)
    
    -- ✅ REFATORADO: Usa PlayerStateManager para gerenciar invencibilidade
    -- Prioridade baixa (30) - câmera não deve bloquear minigame
    stateManager:setInvincibility(true, 'camera', 30, duration)

    Wait(500)

    self:setSplines({
        {
            center = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0.0, 0.5),
            from = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.0, 0.5),
            to = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 2.0, 0.5),
            interval = duration
        }
    })

    self:transitionCamera(false)
    
    -- ✅ REFATORADO: PlayerStateManager gerencia remoção de invencibilidade automaticamente
    -- Apenas gerencia freeze do jogador
    CreateThread(function()
        Wait(duration)
        
        -- ✅ CORRIGIDO: Verifica se a câmera ainda está ativa antes de desfreezar
        -- Se saiu da partida durante a intro, a câmera foi destruída (active=false)
        if self.active then
            FreezeEntityPosition(playerPed, false)
        end
    end)
end
