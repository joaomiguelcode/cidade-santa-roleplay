-- Render step for the nametag host: the lazy per-frame draw thread plus the label projection, distance
-- scale and staggered line-of-sight occlusion. Only StartNametagRenderThread is global (the lifecycle in
-- nametags.lua spawns it on the first nametag); everything else here — the tunables and the draw helpers —
-- is local to this file, since nothing else needs them.

local PED_HEAD_BONE = 0x796E -- SKEL_Head; the label is anchored to this bone, not the entity root
local NAMETAG_HEAD_OFFSET_Z = 0.35 -- clearance above the head bone so the label floats over the head
local NAMETAG_EMOJI_GAP_Z = 0.15 -- vertical gap (metres) lifting the emoji above the label so it reads as a separate glyph

-- DEBUG: when true, every nametag is drawn once per font in NAMETAG_DEBUG_FONTS, stacked vertically with a
-- per-row Z offset and each row prefixed with its font number, so you can eyeball which font reads best.
-- Set back to false (or strip this block) once a font is chosen; production draws a single label at SetTextFont(4).
local NAMETAG_DEBUG_FONTS_ENABLED = false
local NAMETAG_DEBUG_FONTS = { 0, 1, 2, 4, 5, 6, 7, 8 } -- the GTA text font ids to compare
local NAMETAG_DEBUG_ROW_OFFSET_Z = 0.12 -- vertical gap (metres) between stacked font rows

-- Distance and scale are measured from the FOCUS position, not the ped: sx.client.player.getFocusPosition()
-- returns the freecam coord while an admin is noclipping and the ped coord otherwise, so labels track the
-- view that is actually rendering (which is not the ped during freecam / other non-ped cameras).
local NAMETAG_RENDER_DISTANCE = 15.0 -- metres from the focus position; skip the draw beyond this

-- Text shrinks with distance from the focus position (perspective) and grows when the rendered camera
-- narrows its fov (zoom). Clamped to NAMETAG_MIN_SCALE so far labels stay legible.
local NAMETAG_BASE_SCALE = 0.3
local NAMETAG_MIN_SCALE = 0.13
local NAMETAG_REFERENCE_FOV = 70.0 -- the fov NAMETAG_BASE_SCALE is tuned for; narrower fov enlarges proportionally

-- Occlusion (is the ped behind walls?) is checked with a line-of-sight probe, which is too expensive to
-- run for every nametag every frame. Each entry caches its last result and re-probes once every
-- NAMETAG_VISIBILITY_REFRESH_FRAMES; the (frame + slot) stagger spreads the probes across frames so only
-- a handful run per tick instead of all at once.
local NAMETAG_VISIBILITY_REFRESH_FRAMES = 15
local NAMETAG_LOS_TRACE_TYPE = 17 -- world geometry + objects (peds/vehicles don't occlude labels)

---@type table<number, number> -- server id -> current local player index
local gNametagPlayerByServerId = {}
local gNametagPlayerLookupFrame = -1

---@param dist number -- metres from the focus position to the ped
---@return number scale
local function NametagTextScale( dist )

    -- Linear falloff: full size at the focus point, fading toward the render edge; floored at MIN_SCALE.
    -- The fov factor keeps on-screen size stable when the rendered camera zooms in (smaller fov).
    local fovFactor = NAMETAG_REFERENCE_FOV / GetFinalRenderedCamFov()
    local scale = NAMETAG_BASE_SCALE * fovFactor * ( NAMETAG_RENDER_DISTANCE - dist ) / NAMETAG_RENDER_DISTANCE

    return math.max( scale, NAMETAG_MIN_SCALE )
end

---@param x number
---@param y number
---@param z number
---@param text string
---@param r number
---@param g number
---@param b number
---@param scale number
---@param font? number -- text font id; defaults to the production font 4
---@return nil
local function DrawNametag3D( x, y, z, text, r, g, b, scale, font )

    -- SetDrawOrigin anchors the following 2D draw to a world point: the engine projects it to screen and
    -- culls it when behind the camera, so the text is positioned in 3D space without a manual projection.
    -- Draw at the origin (0, 0) and clear it afterwards so it doesn't leak into other draws this frame.
    SetDrawOrigin( x, y, z, 0 )

    SetTextScale( scale, scale )
    SetTextFont( font or 0 )
    SetTextDropShadow( 1, 0, 0, 0, 255 )
    SetTextOutline()
    SetTextProportional( 1 )
    SetTextColour( r, g, b, 225 )
    SetTextEntry( 'STRING' )
    SetTextCentre( 1 )
    AddTextComponentString( text )
    DrawText( 0.0, 0.0 )

    ClearDrawOrigin()
end

-- Refresh player bindings on the existing LOS stagger; misses and recycled indices refresh immediately.
-- All slots share at most one active-player lookup per frame, including retries for out-of-scope players.
-- Only the player index is cached: the current ped and head position are still read every frame.
---@param nametag Nametag
---@param frame number
---@param refreshBinding boolean
---@return number ped
local function GetNametagPed( nametag, frame, refreshBinding )

    if nametag.serverId then
        local playerId = gNametagPlayerByServerId[ nametag.serverId ]

        if refreshBinding or not playerId or GetPlayerServerId( playerId ) ~= nametag.serverId then

            if gNametagPlayerLookupFrame ~= frame then
                gNametagPlayerByServerId = {}

                for _, activePlayerId in ipairs( GetActivePlayers() ) do
                    gNametagPlayerByServerId[ GetPlayerServerId( activePlayerId ) ] = activePlayerId
                end

                gNametagPlayerLookupFrame = frame
            end

            playerId = gNametagPlayerByServerId[ nametag.serverId ]
        end

        return playerId and GetPlayerPed( playerId ) or 0
    end

    return nametag.entity or 0
end

-- Spawned on the first nametag, drains itself when the last entry is freed. While alive it draws every
-- frame, walking only the fixed table (no hash iteration) and skipping peds beyond NAMETAG_RENDER_DISTANCE
-- from the focus position. When gNametagActiveCount hits 0 the loop ends and gNametagThreadRunning resets.
---@return nil
function StartNametagRenderThread()

    gNametagThreadRunning = true

    CreateThread( function()

        local frame = 0
        gNametagPlayerByServerId = {}
        gNametagPlayerLookupFrame = -1

        while gNametagActiveCount > 0 do

            local viewerPed = PlayerPedId()
            local focusCoords = sx.client.player.getFocusPosition()

            for i = 1, MAX_NAMETAG_SLOTS do

                local nametag = gNametag[ i ]
                if nametag.isValid then

                    local refreshSlot = ( frame + i ) % NAMETAG_VISIBILITY_REFRESH_FRAMES == 0
                    local ped = GetNametagPed( nametag, frame, refreshSlot )

                    -- an invisible ped (e.g. cutscene/admin hidden) draws no label
                    if ped ~= 0 and DoesEntityExist( ped ) and IsEntityVisible( ped ) then

                        local headCoords = GetPedBoneCoords( ped, PED_HEAD_BONE, 0.0, 0.0, 0.0 )
                        local dist = #( headCoords - focusCoords )
                        if dist <= NAMETAG_RENDER_DISTANCE then

                            -- Re-probe occlusion only on this slot's staggered frame; draw from the cache otherwise.
                            if refreshSlot then
                                nametag.isVisible = HasEntityClearLosToEntity( viewerPed, ped, NAMETAG_LOS_TRACE_TYPE )
                            end

                            if nametag.isVisible then
                                local def = nametag.def
                                local scale = NametagTextScale( dist )

                                if NAMETAG_DEBUG_FONTS_ENABLED then
                                    -- Stack one row per font, top row = first font, each prefixed with its id.
                                    for row = 1, #NAMETAG_DEBUG_FONTS do
                                        local font = NAMETAG_DEBUG_FONTS[ row ]
                                        local rowZ = headCoords.z + NAMETAG_HEAD_OFFSET_Z + ( #NAMETAG_DEBUG_FONTS - row ) * NAMETAG_DEBUG_ROW_OFFSET_Z
                                        DrawNametag3D( headCoords.x, headCoords.y, rowZ, ('[%d] %s'):format( font, def.label ), def.color.r, def.color.g, def.color.b, scale, font )
                                    end
                                else
                                    local labelZ = headCoords.z + NAMETAG_HEAD_OFFSET_Z
                                    DrawNametag3D( headCoords.x, headCoords.y, labelZ, def.label, def.color.r, def.color.g, def.color.b, scale )

                                    -- The emoji is its own centred draw, lifted a fixed gap above the label so it
                                    -- reads as a separate glyph instead of inline text. Both draws are centred, so
                                    -- it sits over the middle of the label and the world-Z gap keeps them spaced.
                                    if def.emoji then
                                        DrawNametag3D( headCoords.x, headCoords.y, labelZ + NAMETAG_EMOJI_GAP_Z, def.emoji, def.color.r, def.color.g, def.color.b, scale )
                                    end
                                end
                            end
                        end
                    end
                end
            end

            frame = frame + 1
            Wait( 0 )
        end

        gNametagThreadRunning = false
    end )
end
