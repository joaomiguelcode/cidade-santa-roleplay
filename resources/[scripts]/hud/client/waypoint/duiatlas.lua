local resource = GetCurrentResourceName()

--- Uma única DUI compartilhada por todos os waypoints 3D (atlas).
--- O Lua é dono do layout: cada slot é uma célula CELL x CELL dentro da DUI e o
--- front (`waypoint-marker.html?dui`) só posiciona o marker no `rect` recebido.
--- Capacidade sob demanda: a DUI é recriada no próximo tamanho de TIERS quando
--- lota e volta a encolher após SHRINK_DELAY com pouco uso. No tamanho máximo,
--- os pontos mais próximos do player têm prioridade no slot.
--- Recriar a DUI apaga todos os markers até a página nova montar (~0.3s), então o
--- menor nível já comporta o uso comum (missões do onboarding + QG) sem crescer.

--- Célula de 256px quando o maior sprite padrão cabe nela; desligado = células fixas de 512.
--- Requer o front com `zoom` na célula (rect.size ~= 512, MarkerDui.tsx `AtlasCell`) em `hud/web`;
--- sem ele o conteúdo sai cortado. Deployar sempre junto com esse build.
local ADAPTIVE_CELL = true

--- Lado (px) da célula. Fixo durante a vida do resource (só muda junto de um recreate).
---@return integer
local function resolveCell()
    if not ADAPTIVE_CELL then
        return 512
    end

    local screenW, screenH = GetActiveScreenResolution()

    -- Resolução indisponível: mantém o tamanho antigo em vez de arriscar célula pequena num 4K.
    if not screenW or not screenH or screenW <= 0 or screenH <= 0 then
        return 512
    end

    --- Maior sprite padrão (DUIPoint 0.12 x 0.21 da tela); max(w, h) cobre ultrawide.
    return math.max( 0.12 * screenW, 0.21 * screenH ) <= 288 and 256 or 512
end

local CELL = resolveCell()

DuiAtlas = {
    CELL  = CELL,
    --- Lado (px) da DUI quadrada em cada nível: 16 e 64 slots (colunas 4/8).
    TIERS = { 4 * CELL, 8 * CELL },
}

--- Tempo com uso baixo antes de encolher (ms).
local SHRINK_DELAY = 30000
--- Distância mínima (m) a mais que o dono atual precisa estar para ceder o slot no nível máximo.
local EVICT_MARGIN = 5.0

local bootId = GetGameTimer()

local state = {
    tier       = 1,
    live       = false,
    ready      = false,
    gen        = 0,
    duiObject  = nil,
    dict       = nil,
    texture    = nil,
    --- slot (0-based) -> DUIPoint
    owners     = {},
    lowSince   = nil,
    warnedFull = false,
}

local function sideOf( tier )
    return DuiAtlas.TIERS[tier]
end

local function colsOf( tier )
    return sideOf( tier ) // DuiAtlas.CELL
end

local function capacityOf( tier )
    local cols = colsOf( tier )
    return cols * cols
end

local function ownerCount()
    local count = 0
    for _ in pairs( state.owners ) do
        count = count + 1
    end
    return count
end

--- (Re)cria a DUI no tamanho do nível atual. Uma geração nova invalida qualquer
--- criação em andamento, garantindo uma DUI viva por vez.
local function recreate()
    state.gen = state.gen + 1
    state.ready = false

    local gen = state.gen

    if state.duiObject then
        DestroyDui( state.duiObject )
        state.duiObject = nil
    end

    CreateThread( function()
        while not isNuiReady do
            Wait( 0 )
        end

        if gen ~= state.gen then
            return
        end

        local side = sideOf( state.tier )
        local dict = ('%s_wp_atlas_txd_%d_%d'):format( resource, bootId, gen )
        local texture = ('%s_wp_atlas_tex_%d_%d'):format( resource, bootId, gen )

        local duiObject = CreateDui( ('nui://%s/web/waypoint-marker.html?dui'):format( resource ), side, side )
        local runtimeTxd = CreateRuntimeTxd( dict )
        CreateRuntimeTextureFromDuiHandle( runtimeTxd, texture, GetDuiHandle( duiObject ) )

        while gen == state.gen and not IsDuiAvailable( duiObject ) do
            Wait( 0 )
        end

        if gen ~= state.gen then
            DestroyDui( duiObject )
            return
        end

        state.duiObject = duiObject
        state.dict = dict
        state.texture = texture
        state.ready = true

        sx.logger:debug( ('Waypoint atlas DUI ready (%dx%d, %d slots, %d in use)'):format( side, side, capacityOf( state.tier ), ownerCount() ) )

        -- Página nova: todo dono reenvia o estado para o novo layout.
        for _, point in pairs( state.owners ) do
            point:_onAtlasReady()
        end

        --[[
            NOTE: Gambiarra apenas para garantir o primeiro paint da DUI,
            que é necessário para o NUI calcular as posições iniciais dos elementos
            e evitar um quadrado branco kkkk.

            - @TkzDev

            Com o atlas, roda uma vez por geração (página nova): a página pode perder
            mensagens antes do React montar o listener, então reenvia o estado de TODOS
            os donos (inclusive quem pegar slot nessa janela) 8x a cada 150ms. Relê
            `state.owners` a cada rodada; grow/shrink/compact/destroy mudam `gen` e cortam.
        ]]
        for _ = 1, 8 do
            Wait( 150 )

            if gen ~= state.gen or not state.ready then
                return
            end

            for _, p in pairs( state.owners ) do
                if p.running and p.isActiveDui and p.slot ~= nil then
                    p._lastMarkerSig = nil
                    p:_sendMarkerUpdate()
                end
            end
        end
    end )
end

local function ensureDui()
    if state.live then
        return
    end

    state.live = true
    recreate()
end

---@param slot integer
---@return table rect { x, y, size } em px dentro da DUI
local function rectOf( slot )
    local cols = colsOf( state.tier )
    return {
        x    = ( slot % cols ) * DuiAtlas.CELL,
        y    = ( slot // cols ) * DuiAtlas.CELL,
        size = DuiAtlas.CELL,
    }
end

--- Reatribui os slots em 0..n-1 (usado ao encolher, onde o grid fica menor).
local function compactSlots()
    local points = {}
    for _, point in pairs( state.owners ) do
        points[#points + 1] = point
    end

    state.owners = {}

    for i = 1, #points do
        local slot = i - 1
        state.owners[slot] = points[i]
        points[i]:_onSlotMoved( slot )
    end
end

---@return boolean
function DuiAtlas.isReady()
    return state.ready
end

---@return string dict
---@return string texture
function DuiAtlas.textures()
    return state.dict, state.texture
end

--- Reserva um slot para o ponto: slot livre > cresce a DUI > toma o slot do mais distante.
---@param point table DUIPoint
---@return integer|nil
function DuiAtlas.acquire( point )
    local capacity = capacityOf( state.tier )

    for slot = 0, capacity - 1 do
        if not state.owners[slot] then
            state.owners[slot] = point
            state.warnedFull = false
            ensureDui()
            return slot
        end
    end

    if state.tier < #DuiAtlas.TIERS then
        state.tier = state.tier + 1
        state.lowSince = nil
        state.owners[capacity] = point
        recreate()
        return capacity
    end

    local farSlot, farPoint
    for slot, owner in pairs( state.owners ) do
        if not farPoint or owner.currentDist > farPoint.currentDist then
            farSlot, farPoint = slot, owner
        end
    end

    if farPoint and farPoint.currentDist > point.currentDist + EVICT_MARGIN then
        farPoint:_onSlotEvicted()
        -- Limpa a célula: o updateMarker do novo dono remonta do DEFAULT_MARKER em vez de
        -- herdar título/ícone/cor/escala do dono anterior.
        DuiAtlas.send( farSlot, { action = 'clearSlot' } )
        state.owners[farSlot] = point
        return farSlot
    end

    if not state.warnedFull then
        state.warnedFull = true
        sx.logger:warn( ('Waypoint atlas full (%d slots); marker "%s" not drawn in 3D'):format( capacity, tostring( point.title ) ) )
    end

    return nil
end

---@param slot integer
function DuiAtlas.release( slot )
    if slot == nil or not state.owners[slot] then
        return
    end

    state.owners[slot] = nil
    DuiAtlas.send( slot, { action = 'clearSlot' } )
end

---@param slot integer
---@param payload table
function DuiAtlas.send( slot, payload )
    if not state.ready or slot == nil then
        return
    end

    payload.slot = slot
    payload.rect = rectOf( slot )
    SendDuiMessage( state.duiObject, json.encode( payload ) )
end

--- Coordenadas UV da célula do slot no nível atual (sem alocar; roda por frame no render).
---@param slot integer
---@return number u1
---@return number v1
---@return number u2
---@return number v2
function DuiAtlas.uv( slot )
    local cols = DuiAtlas.TIERS[state.tier] // DuiAtlas.CELL
    local c, r = slot % cols, slot // cols
    return c / cols, r / cols, ( c + 1 ) / cols, ( r + 1 ) / cols
end

function DuiAtlas.destroy()
    state.gen = state.gen + 1
    state.live = false
    state.ready = false
    state.owners = {}
    state.tier = 1
    state.lowSince = nil

    if state.duiObject then
        DestroyDui( state.duiObject )
        state.duiObject = nil
    end
end

--- Encolhe um nível quando o uso cabe folgado (<= metade) no nível de baixo por SHRINK_DELAY.
CreateThread( function()
    while true do
        Wait( 1000 )

        if state.live and state.tier > 1 then
            local count = ownerCount()

            if count <= capacityOf( state.tier - 1 ) // 2 then
                local now = GetGameTimer()
                state.lowSince = state.lowSince or now

                if now - state.lowSince >= SHRINK_DELAY then
                    state.tier = state.tier - 1
                    state.lowSince = nil
                    compactSlots()
                    recreate()
                end
            else
                state.lowSince = nil
            end
        end
    end
end )
