-- Video billboard above the plaza podium, rendered onto a SCREEN PROP via a named render target. The
-- prop's screen surface defines the position/size/orientation exactly, so there is no manual centring:
-- we just draw the DUI texture onto the prop's render target each frame (the ptelevision technique, see
-- ptelevision/client/dui.lua). Mounted/unmounted by the podium render zone (client/peds.lua).
--
-- A distance loop pushes a falloff volume to the page each 100ms (the page owns the <video>/audio) — the
-- "3D audio". PAGE_NAME points at the podium cards page for now (placeholder); swap to the video page and
-- set VIDEO_URL once it's built. The page must accept { action='billboard:play', url } and
-- { setVolume=true, data=0..100 }.

-- == REQUIRED: a prop that has a baked render target, and that target's name ==
-- Render targets are embedded in the model; most props DON'T have one. PROP_MODEL must be a screen prop
-- and RENDER_TARGET must be the exact target name baked into it (e.g. ptelevision's screen models).
-- v_ilev_cin_screen
-- prop_huge_display_01
-- prop_huge_display_02
-- faraostore_prop_cinescreen
local PROP_MODEL    = `xm_prop_x17_tv_scrn_01`          -- TODO: set to the screen prop model
local RENDER_TARGET = 'prop_x17_tv_scrn_01'   -- TODO: set to that model's baked render-target name
local PROP_Z_OFFSET = 1.5   -- metres above the rank-1 ped's foot coords
local PROP_SCALE    = 1.5   -- uniform scale applied via SetEntityMatrix (1.0 = original)
local PROP_PITCH    = 20.0  -- degrees to tilt downward (positive = screen faces down)

local PAGE_NAME      = 'social-ranking-cards'
local IMAGE_URL      = ''                     -- TEST: load an image straight into the DUI instead of the page
local VIDEO_URL      = 'https://www.w3schools.com/html/mov_bbb.mp4'                     -- empty = no play message; set to push a video to the page
local WIDTH          = 1280                   -- DUI canvas px
local HEIGHT         = 720                    -- DUI canvas px
local RANGE          = 10.0                   -- audible radius; volume falls to 0 at the edge
local DEFAULT_VOLUME = 0.7                    -- 0..1 base volume before distance falloff

local TXD_NAME = 'social_billboard_dict'
local TXN_NAME = 'social_billboard_txd'

---@type number?     -- the DUI object while mounted
local gBillboardDui = nil
---@type number?     -- the spawned screen prop while mounted
local gBillboardProp = nil
---@type fun()?      -- aborts the render tick
local gBillboardRenderAbort = nil
---@type number      -- current committed heading (rad); only updated when delta exceeds threshold
local gBillboardHeading = 0.0

local ROTATION_THRESHOLD = math.rad( 15.0 )  -- dead-zone: must move 15° before prop rotates
local ROTATION_LERP      = 0.05              -- fraction to close per tick (0=no movement, 1=instant)

local CDN_DEFAULT_HOST = 'santa-ui.pages.dev'
local CDN_PROD_HOST    = 'frontend.santagroup.gg'
local CF_BRANCH_MAX    = 28

-- Mirrors cards.lua: normalize a git branch to the CF Pages subdomain slug.
---@param branch string
---@return string
local function NormalizeBranch( branch )

    local slug = branch:lower()
    slug = slug:gsub( '[^a-z0-9%-]', '-' )
    slug = slug:gsub( '%-+', '-' )
    slug = slug:gsub( '^%-', '' )
    slug = slug:gsub( '%-$', '' )
    return slug:sub( 1, CF_BRANCH_MAX )
end

-- Resolve the page URL from the same convars the sx nui_loader / cards.lua use.
---@param pageName string
---@return string url
local function ResolvePageUrl( pageName )

    local lang = GetConvar( 'language', 'pt-br' )
    local localOverride = GetConvar( ('ui_local_%s'):format( pageName ), '' )

    if localOverride ~= '' then
        return ('%s/?lang=%s'):format( ( localOverride:gsub( '/+$', '' ) ), lang )
    end

    local branch  = NormalizeBranch( GetConvar( 'ui_branch', '' ) ~= '' and GetConvar( 'ui_branch', '' ) or 'main' )
    local cdnBase = GetConvar( 'ui_cdn_base', '' ) ~= '' and GetConvar( 'ui_cdn_base', '' ) or CDN_DEFAULT_HOST
    local host    = branch == 'main' and CDN_PROD_HOST or ('%s.%s'):format( branch, cdnBase )

    return 'http://localhost:5173/social-ranking-cards/#/billboard' -- ('https://%s/%s/?lang=%s#/billboard'):format( host, pageName, lang )
end

RegisterNuiCallback( 'getBillboardVideoUrl', function( _, cb )


    cb( { url = VIDEO_URL } )
end )

-- Volume after distance falloff (mirrors ptelevision): full at the billboard, linearly down to 0 at range.
---@param volume number -- base 0..1
---@param dist number
---@param range number
---@return number -- 0..100
local function ComputeVolumeFalloff( volume, dist, range )

    local rem = dist / range
    rem = rem > volume and volume or rem
    return math.floor( ( volume - rem ) * 100 )
end

-- Resolve (registering/linking on first use) the render id for our target on PROP_MODEL.
-- Mirrors ptelevision/client/dui.lua CreateNamedRenderTargetForModel.
---@return number renderId -- 0 if the target isn't registered
local function ResolveRenderTarget()

    if not IsNamedRendertargetRegistered( RENDER_TARGET ) then
        RegisterNamedRendertarget( RENDER_TARGET, 0 )
    end

    if not IsNamedRendertargetLinked( PROP_MODEL ) then
        LinkNamedRendertarget( PROP_MODEL )
    end

    return IsNamedRendertargetRegistered( RENDER_TARGET ) and GetNamedRendertargetRenderId( RENDER_TARGET ) or 0
end

---@param model number|string
---@return boolean loaded
local function LoadModel( model )

    RequestModel( model )

    local startedAt = GetGameTimer()
    while not HasModelLoaded( model ) do
        if GetGameTimer() - startedAt > 10000 then
            return false
        end
        Wait( 0 )
    end

    return true
end

-- Draw the DUI texture onto the prop's render target each frame: the prop's screen surface places it.
---@param renderId number
---@return nil
local function DrawBillboardToTarget( renderId )

    SetTextRenderId( renderId )
    Set_2dLayer( 4 )
    SetScriptGfxDrawBehindPausemenu( 1 )
    DrawSprite( TXD_NAME, TXN_NAME, 0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255 )
    SetTextRenderId( GetDefaultScriptRendertargetRenderId() )
    SetScriptGfxDrawBehindPausemenu( 0 )
end

-- Start the billboard: spawn the screen prop, create the DUI + runtime texture, kick the video, and start
-- the render + volume ticks.
---@return nil
function StartSocialPodiumBillboard()

    if gBillboardProp then
        return -- already mounted
    end

    if not LoadModel( PROP_MODEL ) then

        sx.logger:error( ('billboard: could not load prop model=%s'):format( tostring( PROP_MODEL ) ) )

        return
    end

    local ped1Slot = GetPodiumConfig().peds[ 1 ]
    local ped1     = ped1Slot.coords  -- vector4: world x, y, z (foot), heading
    local spawnX   = ped1.x
    local spawnY   = ped1.y
    local spawnZ   = ped1.z + PROP_Z_OFFSET
    local spawnH   = 170.0


    gBillboardProp = CreateObject( PROP_MODEL, spawnX, spawnY, spawnZ, false, false, false )
    FreezeEntityPosition( gBillboardProp, true )

    -- rage Matrix4x4 arg order: FORWARD (offset 4), RIGHT (offset 0), UP (offset 8), POSITION
    local h = math.rad( ( spawnH + 180.0 ) % 360.0 )
    local p = -math.rad( PROP_PITCH )  -- negate: positive PROP_PITCH = faces down
    local s = PROP_SCALE
    -- yaw basis
    local fwdX, fwdY = math.sin( h ), math.cos( h )
    local rgtX, rgtY = math.cos( h ), -math.sin( h )
    SetEntityMatrix(
        gBillboardProp,
        s * fwdX * math.cos( p ),  s * fwdY * math.cos( p ),  -s * math.sin( p ),  -- forward pitched
        s * rgtX,                   s * rgtY,                    0.0,                 -- right unchanged
        s * fwdX * math.sin( p ),  s * fwdY * math.sin( p ),   s * math.cos( p ),   -- up pitched
        spawnX, spawnY, spawnZ
    )
    SetModelAsNoLongerNeeded( PROP_MODEL )

    local txd = CreateRuntimeTxd( TXD_NAME )
    local duiUrl = IMAGE_URL ~= '' and IMAGE_URL or ResolvePageUrl( PAGE_NAME )
    gBillboardDui = CreateDui( duiUrl, WIDTH, HEIGHT )
    CreateRuntimeTextureFromDuiHandle( txd, TXN_NAME, GetDuiHandle( gBillboardDui ) )

    gBillboardHeading = math.atan( spawnX - GetGameplayCamCoords().x, spawnY - GetGameplayCamCoords().y ) + math.pi

    local anchor           = vector3( spawnX, spawnY, spawnZ )

    gBillboardRenderAbort = sx.script.setTick( function()

        local cam    = GetGameplayCamCoords()
        local target = math.atan( cam.x - spawnX, cam.y - spawnY ) + math.pi
        local delta  = ( ( target - gBillboardHeading + math.pi ) % ( 2 * math.pi ) ) - math.pi
        if math.abs( delta ) > ROTATION_THRESHOLD then
            gBillboardHeading = gBillboardHeading + delta * ROTATION_LERP
        end

        local h     = gBillboardHeading
        local p     = -math.rad( PROP_PITCH )
        local s     = PROP_SCALE
        local fwdX  = math.sin( h )
        local fwdY  = math.cos( h )
        local rgtX  =  math.cos( h )
        local rgtY  = -math.sin( h )

        SetEntityMatrix(
            gBillboardProp,
            s * fwdX * math.cos( p ),  s * fwdY * math.cos( p ),  -s * math.sin( p ),
            s * rgtX,                   s * rgtY,                    0.0,
            s * fwdX * math.sin( p ),  s * fwdY * math.sin( p ),   s * math.cos( p ),
            spawnX, spawnY, spawnZ
        )

        local renderId = ResolveRenderTarget()
        if renderId ~= 0 then
            DrawBillboardToTarget( renderId )
        end

        if GetFrameCount() % 6 == 0 then
            local dist = #( GetEntityCoords( PlayerPedId() ) - anchor )
            SendDuiMessage( gBillboardDui, json.encode( {
                action = 'setVolume',
                data   = ComputeVolumeFalloff( DEFAULT_VOLUME, dist, RANGE ),
            } ) )
        end
    end )
end

-- Stop the billboard: kill both ticks, destroy the DUI, delete the prop, release the render target. Idempotent.
---@return nil
function StopSocialPodiumBillboard()

    if gBillboardRenderAbort then
        gBillboardRenderAbort()
        gBillboardRenderAbort = nil
    end

    if gBillboardDui then
        DestroyDui( gBillboardDui )
        gBillboardDui = nil
    end

    if gBillboardProp then
        if DoesEntityExist( gBillboardProp ) then
            DeleteEntity( gBillboardProp )
        end
        gBillboardProp = nil
    end

    if IsNamedRendertargetRegistered( RENDER_TARGET ) then
        ReleaseNamedRendertarget( RENDER_TARGET )
    end
end
