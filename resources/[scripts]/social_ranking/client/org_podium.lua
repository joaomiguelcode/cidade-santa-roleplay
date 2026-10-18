-- Placas dos pódios de organizações (ENG-2645/ENG-2890): brasão da posição (ouro/prata/bronze) e o
-- ALIAS da organização.
--
-- Atlas: UMA DUI para o site mais próximo, com 3 células lado a lado (rank 1/2/3). Cada pedestal
-- desenha o seu terço com SetDrawOrigin + DrawSpriteUv, sem ped, prop ou dependência do ymap do píer.
--
-- A página e seu bundle são LOCAIS ao resource (nui://social_ranking/web/org_podium.html), sem depender
-- do CDN ou dos convars ui_branch/ui_cdn_base.
--
-- ponytail: sem lifecycle de zona/mount — o tick roda sempre e sai barato fora de alcance (até 6 distâncias por
-- frame). Se o profiler acusar, envelopar num lib.points como o pódio da praça.

local PAGE_URL = ('nui://%s/web/org_podium.html'):format( GetCurrentResourceName() )

-- Uma célula por rank; o front (org_podium:plates) usa a mesma ordem.
local ATLAS_CELLS = 3

---@class OrgPodiumPlate
---@field rank     number
---@field organizationType 'faction'|'legal'
---@field site     number  -- índice do site em OrgPodiumConfig.sites[city]
---@field slot     vector4

---@type OrgPodiumPlate[]
local gPlates = {}

-- Espera após (re)carregar a página antes de desenhar: o primeiro reenvio sai em 300ms, e antes disso
-- a textura ainda mostra a página vazia (ou o about:blank de quando estava estacionada).
local ATLAS_DRAW_DELAY_MS = 500

-- DUI única do site mais próximo. Criada na primeira aproximação e só destruída no stop do resource:
-- cada CreateDui gera um runtime TXD que segura a textura da DUI até o fim da sessão (não há native
-- pra liberar), então recriar a cada visita acumularia memória. Fora do raio ela fica estacionada em
-- about:blank (sem pintar) e volta pra PAGE_URL ao reentrar.
---@type { dui: table?, parked: boolean?, loadToken: number, drawAfter: number, site: number?, sent: table<number, table>, unloadAt: number? }
local gAtlas = { sent = {}, loadToken = 0, drawAfter = 0 }
---@type string[]
local gInteractIds = {}
---@type fun()? -- aborta o tick de desenho
local gPlateTickAbort = nil

-- O painel replica name -> alias em GlobalState['AliasGroup'] (painel/server/server.lua). Sem alias
-- cadastrado cai no nome cru da org, que é o que o resto da cidade mostra.
---@param orgName string
---@return string
local function ResolveOrgAlias( orgName )

    local aliases = GlobalState[ 'AliasGroup' ]

    return ( type( aliases ) == 'table' and aliases[ orgName ] ) or orgName
end

---@param organizationType 'faction'|'legal'
---@param rank number
---@return table? payload -- nil quando o rank está vago
local function BuildPlatePayload( organizationType, rank )

    local bag = GlobalState[ OrgPodiumBagKey( organizationType, rank ) ]

    if type( bag ) ~= 'table' or not bag.name or bag.name == '' then
        return nil
    end

    return {
        rank    = rank,
        alias   = ResolveOrgAlias( bag.name ),
        xpCycle = bag.xpCycle or 0,
    }
end

-- Vetor forward unitário a partir da rotação da câmera (graus, ordem pitch/roll/yaw do GTA).
---@param rot vector3
---@return vector3
local function CamRotToDirection( rot )

    local radZ = math.rad( rot.z )
    local radX = math.rad( rot.x )
    local cosX = math.abs( math.cos( radX ) )

    return vector3( -math.sin( radZ ) * cosX, math.cos( radZ ) * cosX, math.sin( radX ) )
end

---@return nil
local function SendAtlasPlates()

    local list = {}

    for rank = 1, ATLAS_CELLS do
        if gAtlas.sent[ rank ] then
            list[ #list + 1 ] = gAtlas.sent[ rank ]
        end
    end

    gAtlas.dui:sendMessage( { action = 'org_podium:plates', data = list } )
end

-- A página é local, mas ainda existe a janela entre (re)carregar a DUI e o DOM montar o listener.
-- Reenviar algumas vezes é mais barato que um canal de ack. Aborta se a página foi trocada/estacionada.
---@return nil
local function PrimeAtlasPage()

    gAtlas.loadToken = gAtlas.loadToken + 1
    gAtlas.drawAfter = GetGameTimer() + ATLAS_DRAW_DELAY_MS

    local token = gAtlas.loadToken

    CreateThread( function()

        for _ = 1, 6 do

            Wait( 300 )

            if gAtlas.loadToken ~= token or not gAtlas.dui or gAtlas.parked then
                return
            end

            SendAtlasPlates()
        end
    end )
end

---@return nil
local function SpawnAtlasDui()

    local card = OrgPodiumConfig.card

    gAtlas.dui = lib.dui:new( {
        url    = PAGE_URL,
        width  = card.width * ATLAS_CELLS,
        height = card.height,
    } )

    PrimeAtlasPage()
end

-- Fora do raio: libera a página (o browser fica ocioso) sem destruir a DUI nem o runtime TXD dela.
---@return nil
local function ParkAtlasDui()

    gAtlas.dui:setUrl( 'about:blank' )
    gAtlas.parked    = true
    gAtlas.loadToken = gAtlas.loadToken + 1
    gAtlas.site      = nil
    gAtlas.sent      = {}
    gAtlas.unloadAt  = nil
end

---@return nil
local function WakeAtlasDui()

    gAtlas.dui:setUrl( PAGE_URL )
    gAtlas.parked = false

    PrimeAtlasPage()
end

-- Só no stop do resource.
---@return nil
local function DestroyAtlasDui()

    gAtlas.dui:remove()
    gAtlas.dui       = nil
    gAtlas.parked    = false
    gAtlas.loadToken = gAtlas.loadToken + 1
    gAtlas.site      = nil
    gAtlas.sent      = {}
    gAtlas.unloadAt  = nil
end

-- Por frame: escolhe o site mais próximo com placa, mantém a DUI do atlas e desenha os pedestais dele.
-- Ordenado do mais longe pro mais perto — sprites em draw origin não fazem depth test entre si.
---@return nil
local function DrawOrgPodiumPlates()

    local card         = OrgPodiumConfig.card
    local playerCoords = GetEntityCoords( PlayerPedId() )
    local ratio        = GetAspectRatio( true )
    local now          = GetGameTimer()

    local camCoords  = GetFinalRenderedCamCoord()
    local camForward = CamRotToDirection( GetFinalRenderedCamRot( 2 ) )

    ---@type table<OrgPodiumPlate, { anchor: vector3, dist: number, payload: table }>
    local near = {}
    local site, siteDist

    for i = 1, #gPlates do

        local plate  = gPlates[ i ]
        local slot   = plate.slot
        local anchor = vector3( slot.x, slot.y, slot.z + card.offsetZ )
        local dist   = #( playerCoords - anchor )

        local payload = dist <= card.nearDistance
            and BuildPlatePayload( plate.organizationType, plate.rank )
            or nil

        if payload then
            near[ plate ] = { anchor = anchor, dist = dist, payload = payload }

            if not siteDist or dist < siteDist then
                site, siteDist = plate.site, dist
            end
        end
    end

    if not site then

        -- fora de alcance OU site sem rank: estaciona a DUI depois da carência (não destrói)
        if gAtlas.dui and not gAtlas.parked then
            if not gAtlas.unloadAt then
                gAtlas.unloadAt = now + card.unloadDelayMs
            elseif now >= gAtlas.unloadAt then
                ParkAtlasDui()
            end
        end

        return
    end

    gAtlas.unloadAt = nil

    -- o snapshot do servidor mudou (novo top 3 / novo XP) ou o site trocou: empurra sem recriar o browser.
    -- As 3 células do site ficam preenchidas mesmo com o pedestal fora do raio (o desenho já filtra por
    -- `near`), senão a placa que entra no raio depois aparece com a célula ainda vazia. Rank vago sai.
    local changed = gAtlas.site ~= site

    -- troca de site sem estacionar (ex.: facção -> legal em < unloadDelayMs): a textura ainda tem o site
    -- anterior até a página repintar.
    if gAtlas.site and changed then
        gAtlas.drawAfter = math.max( gAtlas.drawAfter, now + 150 )
    end

    gAtlas.site = site

    for rank = 1, ATLAS_CELLS do

        local cur

        for i = 1, #gPlates do
            local plate = gPlates[ i ]
            if plate.site == site and plate.rank == rank then
                local item = near[ plate ]
                cur = item and item.payload or BuildPlatePayload( plate.organizationType, rank )
                break
            end
        end

        local sent = gAtlas.sent[ rank ]

        if ( cur == nil ) ~= ( sent == nil )
            or ( cur and ( cur.alias ~= sent.alias or cur.xpCycle ~= sent.xpCycle ) )
        then
            changed = true
            gAtlas.sent[ rank ] = cur
        end
    end

    if not gAtlas.dui then
        SpawnAtlasDui()
        return
    end

    if gAtlas.parked then
        WakeAtlasDui()
        return
    end

    if changed then
        SendAtlasPlates()
    end

    -- a textura fica em branco (ou com o about:blank) até a página montar e receber as placas
    if now < gAtlas.drawAfter or not IsDuiAvailable( gAtlas.dui.duiObject ) then
        return
    end

    ---@type { plate: OrgPodiumPlate, coords: vector3, distance: number }[]
    local drawList = {}

    for i = 1, #gPlates do

        local plate = gPlates[ i ]
        local item  = plate.site == site and near[ plate ]

        if item then
            local toPlate = item.anchor - camCoords
            local len     = #toPlate
            local facing  = len > 0.0
                and ( toPlate.x * camForward.x + toPlate.y * camForward.y + toPlate.z * camForward.z ) / len
                or 1.0

            if facing >= card.facingMinDot then
                drawList[ #drawList + 1 ] = { plate = plate, coords = item.anchor, distance = item.dist }
            end
        end
    end

    table.sort( drawList, function( a, b ) return a.distance > b.distance end )

    for i = 1, #drawList do

        local item = drawList[ i ]
        local scale = math.min(
            card.maxScale,
            card.scale * math.max( 1.0, card.minSizeDistance / math.max( item.distance, 0.1 ) )
        )

        local rank = item.plate.rank

        SetDrawOrigin( item.coords.x, item.coords.y, item.coords.z, false )
        DrawSpriteUv(
            gAtlas.dui.dictName, gAtlas.dui.txtName,
            0.0, 0.0,
            scale, scale * ( card.height / card.width ) * ratio,
            ( rank - 1 ) / ATLAS_CELLS, 0.0, rank / ATLAS_CELLS, 1.0,
            0.0, 255, 255, 255, 255 )
        ClearDrawOrigin()
    end
end

CreateThread( function()

    Wait( 5000 )

    local city  = GetConvar( 'cityName', '' )
    local sites = OrgPodiumConfig.sites[ city ]

    if not sites then
        return
    end

    for siteIndex = 1, #sites do

        local site = sites[ siteIndex ]
        local organizationType = site.organizationType or 'faction'

        if site.interact then

            local interactId = ('org_podium:%s:%d'):format( city, siteIndex )
            gInteractIds[ #gInteractIds + 1 ] = interactId

            interact.addCoords( {
                id             = interactId,
                coords         = site.interact,
                renderDistance = 10.0,
                activeDistance = 5.0,
                options        = {
                    {
                        label    = SocialRankingText( OrgPodiumConfig.interactLabelsByLanguage ),
                        icon     = 'trophy',
                        onSelect = function()
                            TriggerServerEvent( 'social_ranking:requestOpenRanking', 'organizations' )
                        end,
                    },
                },
            } )
        end

        for rank, slot in pairs( site.slots ) do
            gPlates[ #gPlates + 1 ] = {
                rank = rank,
                site = siteIndex,
                organizationType = organizationType,
                slot = slot,
            }
        end
    end

    gPlateTickAbort = sx.script.setTick( DrawOrgPodiumPlates )
end )

AddEventHandler( 'onResourceStop', function( resourceName )

    if resourceName ~= GetCurrentResourceName() then
        return
    end

    if gPlateTickAbort then
        gPlateTickAbort()
        gPlateTickAbort = nil
    end

    for i = 1, #gInteractIds do
        interact.removeById( gInteractIds[ i ] )
    end

    if gAtlas.dui then
        DestroyAtlasDui()
    end
end )
