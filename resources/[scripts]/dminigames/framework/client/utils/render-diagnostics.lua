-- QA temporario. Observa somente lifecycle; nunca consulta GPU/CEF por frame.
DminigamesRenderDiagnostics = {}

local WATCH_KEY = 'domination_render_diagnostics_watch'
local LAST_STOP_KEY = 'domination_render_diagnostics_last_stop'
local gWatching = GetResourceKvpInt( WATCH_KEY ) == 1
local gFromBoot = gWatching
local gBoot = GetGameTimer()
local gStats = {}
local gDuis = {}
local gLoops = {}
local gRenderers = {}
local gNextLoop = 0

---@param group string
---@return table
local function GetStats( group )

    if not gStats[ group ] then
        gStats[ group ] = { duiCreated = 0, duiDestroyed = 0, duiLive = 0,
            txdCreated = 0, textureCreated = 0, loopsStarted = 0, loopsFinished = 0 }
    end

    return gStats[ group ]
end

---@param message string
local function Log( message )

    if gWatching then
        sx.logger:info( ('[DominationRender] boot=%d %s'):format( gBoot, message ) )
    end
end

---Wrappers locais aos renderers instrumentados; nao substituem natives globais.
---Sem polling, retry, consulta de resolucao ou mudanca na ordem das natives.
---@param group string
---@return table
function DminigamesRenderDiagnostics.Natives( group )

    local natives = {}

    for name, counter in pairs( {
        CreateDui = 'duiCreated', DestroyDui = 'duiDestroyed', CreateRuntimeTxd = 'txdCreated',
        CreateRuntimeTexture = 'textureCreated', CreateRuntimeTextureFromImage = 'textureCreated',
        CreateRuntimeTextureFromDuiHandle = 'textureCreated',
    } ) do
        local native = _G[ name ]
        natives[ name ] = function( ... )
            local result = native( ... )

            if gWatching then
                local stats = GetStats( group )

                if name == 'DestroyDui' then
                    local handle = ...
                    local owner = gDuis[ handle ]

                    if owner then
                        stats = GetStats( owner )
                        stats.duiDestroyed = stats.duiDestroyed + 1
                        stats.duiLive = stats.duiLive - 1
                        gDuis[ handle ] = nil
                    end

                    Log( ('%s DestroyDui handle=%s conhecido=%s'):format( group, tostring( handle ), tostring( owner ~= nil ) ) )
                elseif result and result ~= 0 then
                    stats[ counter ] = stats[ counter ] + 1

                    if name == 'CreateDui' then
                        gDuis[ result ] = group
                        stats.duiLive = stats.duiLive + 1
                    end

                    Log( ('%s %s handle=%s'):format( group, name, tostring( result ) ) )
                else
                    Log( ('%s %s retornou handle invalido=%s'):format( group, name, tostring( result ) ) )
                end
            end

            return result
        end
    end

    return natives
end

---Conta corrotinas agendadas/ativas, nao frames nem iteracoes.
---@param group string
---@param owner table
---@return number?
function DminigamesRenderDiagnostics.LoopStarted( group, owner )

    if not gWatching then return nil end

    gNextLoop = gNextLoop + 1
    gLoops[ gNextLoop ] = { group = group, owner = owner, stopping = false }
    local stats = GetStats( group )
    stats.loopsStarted = stats.loopsStarted + 1
    Log( ('%s loop #%d iniciado'):format( group, gNextLoop ) )
    return gNextLoop
end

---@param owner table
function DminigamesRenderDiagnostics.LoopsStopping( owner )

    for id, loop in pairs( gLoops ) do
        if loop.owner == owner and not loop.stopping then
            loop.stopping = true
            Log( ('%s loop #%d cancelamento solicitado'):format( loop.group, id ) )
        end
    end
end

---@param id number?
function DminigamesRenderDiagnostics.LoopFinished( id )

    local loop = id and gLoops[ id ]

    if not loop then return end

    local stats = GetStats( loop.group )
    stats.loopsFinished = stats.loopsFinished + 1
    gLoops[ id ] = nil
    Log( ('%s loop #%d finalizado'):format( loop.group, id ) )
end

---Intercepta show/hide e protege setZones do mapa durante clear-overlay.
---O estado desejado continua acompanhando entrada/saida de selector etc.
---@param renderer table
---@param group string
---@param showName string?
---@param hideName string?
function DminigamesRenderDiagnostics.Attach( renderer, group, showName, hideName )

    if not gWatching or not renderer or gRenderers[ renderer ] then return end

    showName, hideName = showName or 'show', hideName or 'hide'
    local show, hide = renderer[ showName ], renderer[ hideName ]
    local entry = { group = group, paused = false, released = false, overlaysCleared = false,
        overlayClearAccepted = false, blankPageRequested = false,
        wanted = renderer.IsDrawing and renderer:IsDrawing() or renderer.visible == true,
        showName = showName, hideName = hideName, show = show, hide = hide }
    gRenderers[ renderer ] = entry
    renderer[ showName ] = function( self, ... )
        entry.wanted = true

        if entry.paused or entry.released or entry.overlaysCleared then return false end

        local result = show( self, ... )

        -- show() do mapa pode ceder enquanto aguarda CEF/overlay.
        if entry.paused then hide( self ) end

        return result
    end
    renderer[ hideName ] = function( self, ... )
        entry.wanted = false
        return hide( self, ... )
    end

    if group == 'minimap' and type( renderer.setZones ) == 'function' then
        entry.setZones = renderer.setZones
        renderer.setZones = function( self, ... )

            -- Uma troca de zonas pode reconstruir paginas ou reinscrever overlays.
            -- Congela so a apresentacao do mapa neste teste, ate sair do modo.
            if entry.overlaysCleared then return false end

            return entry.setZones( self, ... )
        end
    end
end

---@param group string
---@param paused boolean
---@return boolean found
function DminigamesRenderDiagnostics.SetPaused( group, paused )

    local found = false
    local blocked = false

    for renderer, entry in pairs( gRenderers ) do
        if entry.group == group or group == 'all' then
            found = true

            if ( entry.released or entry.overlaysCleared ) and not paused then
                blocked = true
            elseif entry.paused ~= paused then
                entry.paused = paused

                if paused then
                    entry.hide( renderer )
                elseif entry.wanted then
                    entry.show( renderer )
                end
            end
        end
    end

    if blocked then
        sx.logger:warn( '[DominationRender] Renderers isolados para teste. Saia e entre no modo para restaura-los; ON nao os reativa nesta sessao.' )
    elseif found then
        Log( ('%s desenho=%s (sem destruir DUI/TXD)'):format( group, paused and 'OFF' or 'ON' ) )
    end

    return found
end

---Remove apenas os overlays do Scaleform, sem destruir DUI/textura ou watcher.
---@return boolean success
function DminigamesRenderDiagnostics.ClearMinimapOverlays()

    if not gWatching then
        sx.logger:warn( '[DominationRender] Ative watch antes do teste clear-overlay.' )
        return false
    end

    local targets = {}

    for renderer, entry in pairs( gRenderers ) do
        if not entry.paused then
            sx.logger:warn( '[DominationRender] Execute testdominationrender all off antes de clear-overlay e anote o FPS.' )
            return false
        end

        if entry.group == 'minimap' then
            if entry.released or not renderer.pages or #renderer.pages == 0
                or not renderer.overlayHandle or renderer.overlayHandle < 0
                or not HasMinimapOverlayLoaded( renderer.overlayHandle )
            then
                sx.logger:warn( '[DominationRender] Minimapa indisponivel ou ja liberado. Entre novamente no modo antes do teste.' )
                return false
            end

            for _, page in ipairs( renderer.pages ) do
                if not page.dui or page.dui == 0 or not page.textureReady then
                    sx.logger:warn( '[DominationRender] Aguarde a DUI/textura do minimapa ficar pronta antes de clear-overlay.' )
                    return false
                end
            end

            targets[ #targets + 1 ] = { renderer = renderer, entry = entry }
        end
    end

    if #targets == 0 then
        sx.logger:warn( '[DominationRender] Sem minimapa nesta sessao para clear-overlay.' )
        return false
    end

    local success = true

    for _, target in ipairs( targets ) do
        target.entry.overlaysCleared = true
        target.entry.overlayClearAccepted = false
        target.entry.wanted = false
        local ok, err = pcall( function()

            local renderer = target.renderer
            local started = CallMinimapScaleformFunction( renderer.overlayHandle, 'CLEAR_ALL' )

            if started == nil or started == false or started == 0 then
                error( 'CallMinimapScaleformFunction recusou CLEAR_ALL' )
            end

            EndScaleformMovieMethod()

            for _, page in ipairs( renderer.pages ) do
                page.overlayIndex = nil
                page.overlayBounds = nil
            end

            renderer.nextOverlayIndex = 0
            target.entry.overlayClearAccepted = true
        end )

        if not ok then
            success = false
            sx.logger:error( ('[DominationRender] Falha em clear-overlay: %s. Mapa segue bloqueado; pode repetir o comando.'):format( tostring( err ) ) )
        end
    end

    DminigamesRenderDiagnostics.Snapshot( success and 'minimap-overlay-cleared' or 'minimap-overlay-clear-incomplete' )
    Log( 'Clear-overlay solicitado. Mesmas DUIs, texturas e watcher; sem release. Compare FPS antes de release minimap. Saia e entre no modo para restaurar.' )
    return success
end

---Troca somente o documento do browser existente, apos remover os overlays.
---SetDuiUrl nao confirma carregamento; o snapshot registra apenas a solicitacao.
---@return boolean success
function DminigamesRenderDiagnostics.BlankMinimap()

    if not gWatching then
        sx.logger:warn( '[DominationRender] Ative watch antes do teste blank-minimap.' )
        return false
    end

    local targets = {}

    for renderer, entry in pairs( gRenderers ) do
        if not entry.paused then
            sx.logger:warn( '[DominationRender] Execute testdominationrender all off antes de blank-minimap.' )
            return false
        end

        if entry.group == 'minimap' then
            if entry.released or not renderer.pages or #renderer.pages == 0 then
                sx.logger:warn( '[DominationRender] Minimapa indisponivel ou ja liberado. Entre novamente no modo antes do teste.' )
                return false
            end

            if not entry.overlayClearAccepted then
                sx.logger:warn( '[DominationRender] Execute clear-overlay com sucesso e anote o FPS antes de blank-minimap.' )
                return false
            end

            for _, page in ipairs( renderer.pages ) do
                if not page.dui or page.dui == 0 or not page.textureReady then
                    sx.logger:warn( '[DominationRender] DUI/textura do minimapa indisponivel para blank-minimap.' )
                    return false
                end
            end

            targets[ #targets + 1 ] = { renderer = renderer, entry = entry }
        end
    end

    if #targets == 0 then
        sx.logger:warn( '[DominationRender] Sem minimapa nesta sessao para blank-minimap.' )
        return false
    end

    local success = true

    for _, target in ipairs( targets ) do
        local entry = target.entry
        entry.blankPageRequests = entry.blankPageRequests or {}
        local requested = true

        for _, page in ipairs( target.renderer.pages ) do
            if not entry.blankPageRequests[ page.dui ] then
                local ok, err = pcall( SetDuiUrl, page.dui, 'about:blank' )

                if ok then
                    entry.blankPageRequests[ page.dui ] = true
                else
                    requested = false
                    success = false
                    sx.logger:error( ('[DominationRender] Falha em blank-minimap handle=%s: %s. Pode repetir o comando.'):format( tostring( page.dui ), tostring( err ) ) )
                end
            end
        end

        entry.blankPageRequested = requested
    end

    DminigamesRenderDiagnostics.Snapshot( success and 'minimap-blank-requested' or 'minimap-blank-request-incomplete' )
    Log( 'Blank-minimap: apenas navegacao para about:blank, sem confirmar carregamento. Mesmas DUIs, vinculos e resolucao; watcher preservado. Compare FPS antes de release minimap.' )
    return success
end

---A/B destrutivo apenas dos browsers do mapa/placas; nao encerra a partida.
---Exige all off para nao misturar pausa de desenho e teardown na mesma medida.
---@param group string? minimap|rankings|all; padrao all
---@return boolean success
function DminigamesRenderDiagnostics.ReleaseDuis( group )

    group = group or 'all'

    if group ~= 'all' and group ~= 'minimap' and group ~= 'rankings' then
        sx.logger:warn( '[DominationRender] Use testdominationrender release [minimap|rankings|all].' )
        return false
    end

    if not gWatching then
        sx.logger:warn( '[DominationRender] Ative watch antes do teste release.' )
        return false
    end

    local targets = {}

    for renderer, entry in pairs( gRenderers ) do
        if not entry.paused then
            sx.logger:warn( '[DominationRender] Execute testdominationrender all off antes de release e anote o FPS.' )
            return false
        end

        if ( entry.group == 'minimap' or entry.group == 'rankings' ) and ( group == 'all' or entry.group == group ) then
            if renderer.textureCreating then
                sx.logger:warn( '[DominationRender] Aguarde a criacao pendente das placas terminar e repita release.' )
                return false
            end

            targets[ #targets + 1 ] = { renderer = renderer, entry = entry }
        end
    end

    if #targets == 0 then
        sx.logger:warn( ('[DominationRender] Sem renderers de minimapa/rankings para release %s nesta sessao.'):format( group ) )
        return false
    end

    -- Trava todos antes de destruir qualquer um. O destroy invalida tambem
    -- as revisoes de criacao assincrona; show automatico nao pode recriar.
    for _, target in ipairs( targets ) do
        target.entry.released = true
        target.entry.wanted = false
    end

    local success = true

    for _, target in ipairs( targets ) do
        local ok, err = pcall( target.renderer.destroy, target.renderer )

        if not ok then
            success = false
            sx.logger:error( ('[DominationRender] Falha no release de %s: %s. Renderers seguem bloqueados; pode repetir release.'):format( target.entry.group, tostring( err ) ) )
        end
    end

    local label = success and 'duis-released' or 'duis-release-incomplete'
    DminigamesRenderDiagnostics.Snapshot( group == 'all' and label or ('%s-%s'):format( label, group ) )
    Log( ('Release %s solicitado pelos destructors existentes. Nao libera explicitamente runtime textures antigas. Saia e entre no modo para restaurar.'):format( group ) )
    return success
end

---Libera referencias do diagnostico na saida; nao toca em recursos graficos.
function DminigamesRenderDiagnostics.DetachAll()

    for renderer, entry in pairs( gRenderers ) do
        renderer[ entry.showName ] = entry.show
        renderer[ entry.hideName ] = entry.hide

        if entry.setZones then renderer.setZones = entry.setZones end
    end

    gRenderers = {}
end

---@param label string
---@param persist boolean?
function DminigamesRenderDiagnostics.Snapshot( label, persist )

    if not gWatching then return end

    local snapshot = { boot = gBoot, label = label, fromBoot = gFromBoot, groups = {}, renderers = {} }

    for renderer, entry in pairs( gRenderers ) do
        snapshot.renderers[ #snapshot.renderers + 1 ] = { group = entry.group, paused = entry.paused, released = entry.released, overlaysCleared = entry.overlaysCleared,
            overlayClearAccepted = entry.overlayClearAccepted, blankPageRequested = entry.blankPageRequested,
            wanted = entry.wanted, visible = renderer.IsDrawing and renderer:IsDrawing() or renderer.visible == true }
    end

    for group, stats in pairs( gStats ) do
        local active, stopping = 0, 0

        for _, loop in pairs( gLoops ) do
            if loop.group == group then
                if loop.stopping then stopping = stopping + 1 else active = active + 1 end
            end
        end

        snapshot.groups[ group ] = { duiCreated = stats.duiCreated, duiDestroyed = stats.duiDestroyed,
            duiLive = stats.duiLive, txdCreated = stats.txdCreated, textureCreated = stats.textureCreated,
            loopsStarted = stats.loopsStarted, loopsFinished = stats.loopsFinished,
            activeLoops = active, stoppingLoops = stopping }
    end

    local serialized = json.encode( snapshot )
    Log( serialized )

    if persist then SetResourceKvp( LAST_STOP_KEY, serialized ) end
end

---@param enabled boolean
---@return boolean success
function DminigamesRenderDiagnostics.SetWatching( enabled )

    if not enabled then
        for _, entry in pairs( gRenderers ) do
            if entry.released or entry.overlaysCleared then
                sx.logger:warn( '[DominationRender] Saia do modo antes de desligar o diagnostico; o teste precisa manter o bloqueio de recriacao nesta sessao.' )
                return false
            end
        end

        DminigamesRenderDiagnostics.SetPaused( 'all', false )
        DminigamesRenderDiagnostics.DetachAll()
        gStats, gDuis, gLoops = {}, {}, {}
        gFromBoot = false
    end

    gWatching = enabled
    SetResourceKvpInt( WATCH_KEY, enabled and 1 or 0 )
    sx.logger:info( ('[DominationRender] diagnostico=%s; persiste no restart. Runtime criadas = chamadas acumuladas, NAO memoria/VRAM viva.'):format( enabled and 'ON' or 'OFF' ) )

    if enabled and not gFromBoot then
        sx.logger:info( '[DominationRender] Baseline parcial: saia do modo e entre novamente; para comparar restart completo, reinicie o resource com watch ativo.' )
    end

    return true
end

---@return boolean
function DminigamesRenderDiagnostics.IsWatching()

    return gWatching
end

function DminigamesRenderDiagnostics.PrintPreviousStop()

    local previous = GetResourceKvpString( LAST_STOP_KEY )
    sx.logger:info( ('[DominationRender] ultimo-stop=%s'):format( previous or 'nenhum registrado' ) )
end

Log( 'inicio do resource; contadores novos. Corrotinas canceladas podem aguardar Wait no stop; runtime encerra essas threads.' )
