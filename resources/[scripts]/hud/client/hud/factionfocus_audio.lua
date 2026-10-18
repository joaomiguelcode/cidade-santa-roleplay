local SOUNDS = {
    entry = { url = _t( 'facfoco.audio.entry.url' ), duration = tonumber( _t( 'facfoco.audio.entry.duration' ) ) },
    spawn = { url = 'https://cdn.santagroup.gg/feedback-ranking/anuncio_iniciante.wav', duration = 3400 },
}
local gAudioQueue = { }
local gAudioPlaying = false

AddConvarChangeListener( 'enable_factionfocus_v3', function()
    if not GetConvarBool( 'enable_factionfocus_v3', false ) then gAudioQueue = { } end
end )

local function CanHear( cue )
    if not GetConvarBool( 'enable_factionfocus_v3', false ) then return false end
    -- ENG-3972: com o mapa aberto o anúncio é descartado (na chegada e na fila), não fica para depois.
    if IsPauseMenuActive() then return false end
    local rank = tonumber( ( vRP.GetPlayerGroups() or { } )[ cue.faction ] )
    if not rank or rank > 3 or tonumber( LocalPlayer.state.Route ) ~= 1
        or LocalPlayer.state.isRecruitmentSuspended then return false end
    local coords = GetEntityCoords( PlayerPedId() )
    local dx, dy = coords.x - cue.location.x, coords.y - cue.location.y
    return dx * dx + dy * dy <= 500.0 * 500.0
end

RegisterNetEvent( 'hud:factionfocus:recruiterAudio', function( cue )
    if type( cue ) ~= 'table' or not SOUNDS[ cue.kind ] or type( cue.location ) ~= 'table'
        or type( cue.location.x ) ~= 'number' or type( cue.location.y ) ~= 'number' then return end
    if not CanHear( cue ) then return end
    gAudioQueue[ #gAudioQueue + 1 ] = cue
    if gAudioPlaying then return end
    gAudioPlaying = true

    CreateThread( function()
        while #gAudioQueue > 0 do
            local pending = table.remove( gAudioQueue, 1 )
            if CanHear( pending ) then
                local sound = SOUNDS[ pending.kind ]
                -- Independente do card/F11 e do toggle geral de notificações sonoras.
                SendNUIMessage({ action = 'playSound', data = {
                    transactionFile = sound.url, transactionVolume = 0.5,
                } })
                -- ponytail: duração dos assets atuais; atualizar no catálogo se o CDN trocar o anúncio.
                Wait( sound.duration )
            end
        end
        gAudioPlaying = false
    end )
end )
