-- Floating 3D cards for the plaza podium peds (reference: image2.png), rendered as DUI billboards:
-- ONE DUI (atlas) for the whole podium, one row per rank stacked vertically (row = rank), drawn into
-- the world each frame with SetDrawOrigin + DrawSpriteUv (each ped samples its own third).
--
-- The DUI loads the same 'social-ranking-cards' page the sx nui_loader serves; the page URL is
-- resolved here from the same convars the loader uses (ui_local_<page> for dev, else ui_branch +
-- ui_cdn_base). The page renders the atlas rows from the card list pushed via SendDuiMessage.
--
-- Localization: a DUI loaded from a CDN url has NO NUI callback channel, so the page can't fetch
-- translations (no getLang). The app bundles its own locale JSON files and selects one from a `?lang=`
-- query param, which we append to the DUI url from the `language` convar. So the payload carries raw
-- reason KEYS and the page translates them.
--
-- client/peds.lua registers one card per ped via AddSocialCard() as it spawns the ped, and calls
-- RemoveSocialCard() when a ped despawns. The draw tick only runs while at least one card is
-- registered. The atlas DUI is created the first frame the player is within card.nearDistance of any
-- card and is never destroyed until resource stop: every lib.dui:new creates a runtime TXD that pins
-- the DUI texture for the rest of the session (there is no native to free it), so recreating it per
-- visit would leak. Instead, card.unloadDelayMs after the player leaves range (or when the last card
-- is removed) the DUI is parked on about:blank (idle, no painting) and woken on re-entry.

local CDN_DEFAULT_HOST  = 'santa-ui.pages.dev'
local CDN_PROD_HOST     = 'frontend.santagroup.gg'
local CDN_UI_BRANCH     = 'main'
local CF_BRANCH_MAX    = 28

---@class SocialCardPayload
---@field name      string
---@field passport  number
---@field position  number
---@field level     number
---@field xpWeek    number

---@class SocialCard
---@field ped      number
---@field payload  SocialCardPayload

---@type table<number, SocialCard> -- rank -> registered card
local gCards = {}

-- One row per rank (the page stacks them vertically in the same order). Must match ATLAS_ROWS in
-- nuis monorepo/apps/social-ranking-cards/src/app.tsx; ranks above it are not drawn.
local ATLAS_ROWS = 3

-- A card added while the atlas is awake (winner swap) shares the texture with the previous winner's row
-- until the page repaints: hold that card back this long.
local CARD_SETTLE_MS = 150

-- The CDN page's first resend lands at 500ms; before that the texture still shows an empty page (or the
-- parked about:blank), so the cards wait this long after each (re)load before drawing.
local ATLAS_DRAW_DELAY_MS = 1200

---@type { dui: Dui?, parked: boolean?, loadToken: number, drawAfter: number, unloadAt: number? }
local gAtlas = { loadToken = 0, drawAfter = 0 }
---@type fun()? -- aborts the draw tick (returned by sx.script.setTick)
local gCardTickAbortSignal = nil

-- Normalize a git branch to the CF Pages subdomain format (mirrors nui_loader.js normalizeBranch).
-- NOTE: outside a character class `-` is the lazy quantifier in Lua patterns, so a literal dash must
-- be escaped as `%-` (the JS uses `/-+/`, `/^-|-$/`).
---@param branch string
---@return string
local function NormalizeBranch( branch )

    local slug = branch:lower()
    slug = slug:gsub( '[^a-z0-9%-]', '-' ) -- non-alphanumeric (and non-dash) -> dash
    slug = slug:gsub( '%-+', '-' )         -- collapse runs of dashes
    slug = slug:gsub( '^%-', '' )          -- trim leading dash
    slug = slug:gsub( '%-$', '' )          -- trim trailing dash
    return slug:sub( 1, CF_BRANCH_MAX )
end

-- Resolve the page URL from the same convars the sx nui_loader uses (see nui_loader.js
-- computeBaseUrl), with the player's language appended as ?lang= so the DUI can pick its bundled
-- locale (it has no window.nuiSystemLanguages). DUI loads it directly.
--
-- Use the directory form (trailing slash), NOT /index.html: the prod host 308-redirects
-- `<page>/index.html` to `/` (which lands on the hub), while `<page>/` serves the app.
---@param pageName string
---@return string url
local function ResolvePageUrl( pageName )

    local lang = GetConvar( 'language', 'pt-br' )
    local localOverride = GetConvar( ('ui_local_%s'):format( pageName ), '' )

    if localOverride ~= '' then
        return ('%s/?lang=%s'):format( ( localOverride:gsub( '/+$', '' ) ), lang )
    end

    local branch  = NormalizeBranch( CDN_UI_BRANCH )
    local cdnBase = GetConvar( 'ui_cdn_base', '' ) ~= '' and GetConvar( 'ui_cdn_base', '' ) or CDN_DEFAULT_HOST
    local host    = branch == 'main' and CDN_PROD_HOST or ('%s.%s'):format( branch, cdnBase )

    return ('https://%s/%s/?lang=%s'):format( host, pageName, lang )
end

-- Build the render-ready payload pushed to a card's DUI.
---@param payload SocialCardPayload
---@return table
function BuildDuiPayload( payload )

    return {
        name     = payload.name,
        passport = payload.passport,
        position = payload.position,
        level    = payload.level,
        xpWeek   = payload.xpWeek,
    }
end

---@param ped number
---@return boolean -- is the local player currently free-aiming at this ped
local function IsAimingAt( ped )

    local playerId = PlayerId()

    if not IsPlayerFreeAiming( playerId ) then
        return false
    end

    local aiming, entity = GetEntityPlayerIsFreeAimingAt( playerId )

    return aiming and entity == ped
end

-- Push every registered card to the atlas page (row = rank). Missing ranks leave their row empty.
---@return nil
local function SendAtlasCards()

    if not gAtlas.dui or gAtlas.parked then
        return
    end

    local list = {}

    for rank = 1, ATLAS_ROWS do
        local entry = gCards[ rank ]
        if entry then
            local data = BuildDuiPayload( entry.payload )
            data.slot = rank
            list[ #list + 1 ] = data
        end
    end

    gAtlas.dui:sendMessage( { action = 'social_cards:cards', data = list } )
end

-- A DUI loaded from a CDN has no DOM-ready signal and no ack channel, so a 'message' fired before the
-- page's React listener mounts is lost: resend the cards a few times across the load window. Bails if
-- the page was reloaded or parked in the meantime.
---@return nil
local function PrimeAtlasPage()

    gAtlas.loadToken = gAtlas.loadToken + 1
    gAtlas.drawAfter = GetGameTimer() + ATLAS_DRAW_DELAY_MS

    local token = gAtlas.loadToken

    CreateThread( function()

        for _ = 1, 8 do

            Wait( 500 )

            if gAtlas.loadToken ~= token or not gAtlas.dui or gAtlas.parked then
                return
            end

            SendAtlasCards()
        end
    end )
end

---@param card PodiumCardConfig
---@return nil
local function SpawnAtlasDui( card )

    gAtlas.dui = lib.dui:new( {
        url    = ResolvePageUrl( card.pageName ),
        width  = card.width,
        height = card.height * ATLAS_ROWS,
    } )

    PrimeAtlasPage()
end

-- Out of range / no cards: release the page (the browser idles) without destroying the DUI or its TXD.
---@return nil
local function ParkAtlasDui()

    if not gAtlas.dui or gAtlas.parked then
        return
    end

    gAtlas.dui:setUrl( 'about:blank' )
    gAtlas.parked    = true
    gAtlas.loadToken = gAtlas.loadToken + 1
    gAtlas.unloadAt  = nil
end

---@param card PodiumCardConfig
---@return nil
local function WakeAtlasDui( card )

    gAtlas.dui:setUrl( ResolvePageUrl( card.pageName ) )
    gAtlas.parked = false

    PrimeAtlasPage()
end

-- Resource stop only.
---@return nil
local function DestroyAtlasDui()

    if not gAtlas.dui then
        return
    end

    gAtlas.dui:remove()
    gAtlas.dui       = nil
    gAtlas.parked    = false
    gAtlas.loadToken = gAtlas.loadToken + 1
    gAtlas.unloadAt  = nil
end

-- Unit forward vector from a camera rotation (degrees, GTA pitch/roll/yaw order).
---@param rot vector3
---@return vector3
local function CamRotToDirection( rot )

    local radZ = math.rad( rot.z )
    local radX = math.rad( rot.x )
    local cosX = math.abs( math.cos( radX ) )

    return vector3( -math.sin( radZ ) * cosX, math.cos( radZ ) * cosX, math.sin( radX ) )
end

-- Draw one card as a worldspace billboard anchored above its ped, sampling its rank's row of the atlas.
---@param rank  number
---@param coords vector3 -- the ped coords
---@param card  PodiumCardConfig
---@param ratio number -- aspect ratio
---@return nil
local function DrawSocialCardSprite( rank, coords, card, ratio )

    SetDrawOrigin( coords.x, coords.y, coords.z + card.cardOffsetZ, false )
    DrawSpriteUv(
        gAtlas.dui.dictName, gAtlas.dui.txtName,
        0.0, 0.0,
        card.scale, card.scale * ( card.height / card.width ) * ratio,
        0.0, ( rank - 1 ) / ATLAS_ROWS, 1.0, rank / ATLAS_ROWS,
        0.0, 255, 255, 255, 255 )
    ClearDrawOrigin()
end

-- Best (largest) facing dot between the camera forward and the direction to the ped, sampled at a few
-- heights spanning the ped's body (feet up to the head anchor). Returns the max over the samples, so the
-- camera counts as "facing" the ped when it points at any part of it, not only the head point.
---@param coords      vector3 -- ped ground coords (feet)
---@param camCoords   vector3
---@param camForward  vector3 -- unit forward
---@param bodySpanZ   number  -- top of the sampled span (~head height)
---@return number dot -- [-1, 1]; 1 = dead-on
local function BestFacingDotToPed( coords, camCoords, camForward, bodySpanZ )

    local BODY_SAMPLES = 5 -- feet, knees, waist, chest, head — enough to cover the full silhouette
    local best = -1.0

    for i = 0, BODY_SAMPLES - 1 do

        local sampleZ = coords.z + ( bodySpanZ * i / ( BODY_SAMPLES - 1 ) )
        local toPed = vector3( coords.x, coords.y, sampleZ ) - camCoords
        local len = #toPed

        local dot = len > 0.0
            and ( toPed.x * camForward.x + toPed.y * camForward.y + toPed.z * camForward.z ) / len
            or 1.0

        if dot > best then
            best = dot
        end
    end

    return best
end

-- Per-frame: keep the atlas DUI awake while the player is within card.nearDistance of any card (park it
-- card.unloadDelayMs after they leave), then draw the in-range cards as worldspace billboards. Cards are
-- only drawn while the camera roughly faces the ped, and are depth-sorted so the nearest card paints
-- LAST (on top) — 2D sprites at a draw origin don't depth-test each other.
---@return nil
local function DrawDUIPodiumCard()

    local card = GetPodiumConfig().card
    local playerCoords = GetEntityCoords( PlayerPedId() )
    local ratio = GetAspectRatio( true )
    local now = GetGameTimer()

    local camCoords = GetFinalRenderedCamCoord()
    local camForward = CamRotToDirection( GetFinalRenderedCamRot( 2 ) )

    -- collected this frame, then sorted far->near and drawn in that order
    ---@type { rank: number, coords: vector3, distance: number, drawAfter: number? }[]
    local inRange = {}

    for rank, entry in pairs( gCards ) do

        if rank <= ATLAS_ROWS and DoesEntityExist( entry.ped ) then

            local coords = GetEntityCoords( entry.ped )
            local distance = #( playerCoords - coords )

            if distance <= card.nearDistance then
                inRange[ #inRange + 1 ] = { rank = rank, coords = coords, distance = distance, drawAfter = entry.drawAfter }
            end
        end
    end

    if #inRange == 0 then

        -- out of range: schedule the park, then release the page once the grace window elapses
        if gAtlas.dui and not gAtlas.parked then
            if not gAtlas.unloadAt then
                gAtlas.unloadAt = now + card.unloadDelayMs
            elseif now >= gAtlas.unloadAt then
                ParkAtlasDui()
            end
        end

        return
    end

    -- in range: cancel any pending park, create/wake the DUI on demand
    gAtlas.unloadAt = nil

    if not gAtlas.dui then
        SpawnAtlasDui( card )
        return
    end

    if gAtlas.parked then
        WakeAtlasDui( card )
        return
    end

    -- the texture is blank (or still about:blank) until the page mounts and receives the cards
    if now < gAtlas.drawAfter or not IsDuiAvailable( gAtlas.dui.duiObject ) then
        return
    end

    ---@type { rank: number, coords: vector3, distance: number }[]
    local drawList = {}

    for i = 1, #inRange do

        local item = inRange[ i ]

        if item.drawAfter and now < item.drawAfter then
            goto continue
        end

        -- Draw if the camera roughly faces ANY part of the ped, not just the head: sample the facing dot
        -- along the body (feet -> head) and keep the best, so looking head-to-toe keeps the card up
        -- instead of only a narrow cone around the head anchor.
        local facing = BestFacingDotToPed( item.coords, camCoords, camForward, card.bodySpanZ )

        if facing >= card.facingMinDot then
            drawList[ #drawList + 1 ] = item
        end

        ::continue::
    end

    -- farthest first so the nearest card is painted last and sits on top of any it overlaps
    table.sort( drawList, function( a, b ) return a.distance > b.distance end )

    for i = 1, #drawList do
        DrawSocialCardSprite( drawList[ i ].rank, drawList[ i ].coords, card, ratio )
    end
end

-- Register a floating card for a podium ped and start the draw tick on the first card. The DUI is NOT
-- created here — the tick spawns/wakes the atlas once the player is within render range (see SpawnAtlasDui).
---@param rank    number
---@param ped     number
---@param payload SocialCardPayload
---@return nil
function AddSocialCard( rank, ped, payload )

    gCards[ rank ] = {
        ped       = ped,
        payload   = payload,
        drawAfter = GetGameTimer() + CARD_SETTLE_MS,
    }

    SendAtlasCards()

    if not gCardTickAbortSignal then
        gCardTickAbortSignal = sx.script.setTick( DrawDUIPodiumCard )
    end
end

-- Remove a single card: drop the registration (its atlas row is cleared), and stop the draw tick and park
-- the atlas DUI once the last card is gone. No-op if the slot has no card (e.g. a placeholder slot, or one already removed).
---@param rank number
---@return nil
function RemoveSocialCard( rank )

    local entry = gCards[ rank ]
    if entry == nil then
        return
    end

    gCards[ rank ] = nil

    SendAtlasCards()

    -- last card gone (podium despawned): stop the tick and park the DUI — it is reused on respawn
    if next( gCards ) == nil then
        if gCardTickAbortSignal then
            gCardTickAbortSignal()
            gCardTickAbortSignal = nil
        end

        ParkAtlasDui()
    end
end

-- Refresh a card's payload in place (same winner, new weekly numbers) and push it to the live DUI if
-- one is currently spawned. No ped churn — the draw tick keeps drawing the same browser.
---@param rank    number
---@param payload SocialCardPayload
---@return nil
function UpdateSocialCard( rank, payload )

    local entry = gCards[ rank ]
    if entry == nil then
        return
    end

    entry.payload = payload

    SendAtlasCards()
end

-- Termination (called by client/main.lua on resource stop): drop every card, destroy the atlas DUI,
-- stop the tick.
---@return nil
function ClearPodiumCards()

    if gCardTickAbortSignal then
        gCardTickAbortSignal()
        gCardTickAbortSignal = nil
    end

    for rank in pairs( gCards ) do
        gCards[ rank ] = nil
    end

    DestroyAtlasDui()
end
