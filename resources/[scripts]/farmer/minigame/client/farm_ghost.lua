-- ENG-3850: player farmando fica em ghost (não agarra/ataca/rouba nem é agarrado/atacado/roubado).
-- Config sem deploy (convars replicadas, `setr`):
--   farm_ghost_defs         padrões Lua separados por vírgula dos minigames que valem (padrão: farm,routes)
--   farm_ghost_idle_seconds tempo sem ação de farm até sair do ghost (padrão: 10)
-- Server checa `Player(src).state.FarmGhost` no carry (H, /carregar, agarrar do staff), no algemar e no revistar.

local GHOST_ALPHA = 150
local UNARMED = `WEAPON_UNARMED`
-- Ataque: tiro, mira e melee.
local BLOCKED_CONTROLS = { 24, 25, 140, 141, 142, 257, 263, 264 }

local gGhost = false
local gLastActionAt = 0

---@param defName string
---@return boolean
local function IsGhostDef( defName )

    for pattern in GetConvar( 'farm_ghost_defs', 'farm,routes' ):gmatch( '[^,%s]+' ) do
        if defName:find( pattern ) then return true end
    end

    return false
end

---@return boolean
local function ShouldGhost()

    if GetSelectedPedWeapon( PlayerPedId() ) ~= UNARMED then return false end

    -- ENG-3947: não entra em ghost em modo combate (anti-abuso); quem já está segue a regra normal.
    if not gGhost and exports.combatsystem:IsInCombat() then return false end

    -- ENG-3863: farm AFK legado (`client-side/afkfarm.lua`) não usa minigame.
    if IsLegacyAfkFarming() then return true end

    local minigame = GetActiveMinigame()

    -- Sem minigame = fora da área de farm: sai na hora.
    if not minigame then return false end

    local defName = minigame.def.name or ''

    -- ENG-3859: farm AFK do staffgang (`staffgang_template_afk_*`) não tem ação de farm; conta enquanto o minigame existir.
    if defName:find( '^staffgang_template_afk_' ) then return true end

    -- ENG-3863: farm ativo do staffgang (`staffgang_template_active_*`) vale sempre, independente de `farm_ghost_defs`.
    if not defName:find( '^staffgang_template_active_' ) and not IsGhostDef( defName ) then return false end

    local now = GetGameTimer()

    if minigame.isStarted then gLastActionAt = now end

    return now - gLastActionAt < GetConvarInt( 'farm_ghost_idle_seconds', 10 ) * 1000
end

---@param enable boolean
local function SetGhost( enable )

    local ped = PlayerPedId()

    gGhost = enable
    LocalPlayer.state:set( 'FarmGhost', enable or nil, true )
    SetPedCanRagdoll( ped, not enable )

    -- Não desliga proteção de outros donos (minigame com MDF_FLAG_PLAYER_INVINCIBLE, safezone).
    if not enable and LocalPlayer.state.Invincible then return end

    SetLocalPlayerAsGhost( enable )
    SetEntityInvincible( ped, enable )
end

CreateThread( function()

    while true do

        local enable = ShouldGhost()

        if enable ~= gGhost then
            SetGhost( enable )
        elseif enable then
            -- Outros scripts (queda da safezone) zeram a invencibilidade: reaplica.
            SetEntityInvincible( PlayerPedId(), true )
        end

        Wait( 250 )
    end
end )

-- Bloqueio de ataque só enquanto em ghost (por frame).
CreateThread( function()

    while true do

        if gGhost then
            DisablePlayerFiring( PlayerId(), true )

            for _, control in ipairs( BLOCKED_CONTROLS ) do
                DisableControlAction( 0, control, true )
            end

            Wait( 0 )
        else
            Wait( 250 )
        end
    end
end )

-- Semitransparência pros outros. ponytail: varre players próximos a cada 1s; troca por state bag handler se pesar.
local gAlphaPeds = {}

CreateThread( function()

    while true do

        local seen = {}

        for _, player in ipairs( GetActivePlayers() ) do
            if player ~= PlayerId() and Player( GetPlayerServerId( player ) ).state.FarmGhost then
                local ped = GetPlayerPed( player )

                seen[ ped ] = true
                SetEntityAlpha( ped, GHOST_ALPHA, false )
            end
        end

        for ped in pairs( gAlphaPeds ) do
            if not seen[ ped ] and DoesEntityExist( ped ) then ResetEntityAlpha( ped ) end
        end

        gAlphaPeds = seen
        Wait( 1000 )
    end
end )
