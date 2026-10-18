-- ENG-3969: sons do Legal em Foco. O servidor (server/hud/legal_focus.lua) escolhe a cadência e manda só
-- pra quem vê a NUI azul do líder (recrutador nível 1 a 3 da org em foco, mundo padrão, sem AFK): anúncio
-- do legal na entrada e na metade da leva, som de iniciante nos demais spawns. F11 não silencia.
local SOUNDS = {
    entry = { url = _t( 'legalfoco.audio.entry.url' ), duration = tonumber( _t( 'legalfoco.audio.entry.duration' ) ) },
    spawn = { url = 'https://cdn.santagroup.gg/feedback-ranking/anuncio_iniciante.wav', duration = 3400 },
}
local LEADER_MAX_LEVEL = 3
local gAudioQueue = { }
local gAudioPlaying = false

--- Revalida antes de tocar cada item da fila: ainda recrutador da org e no mundo padrão.
local function CanHear( cue )
    local level = tonumber( ( vRP.GetPlayerGroups() or { } )[ cue.org ] )

    return level ~= nil and level <= LEADER_MAX_LEVEL and tonumber( LocalPlayer.state.Route ) == 1
end

RegisterNetEvent( 'hud:legalFocus:recruiterAudio', function( cue )
    if type( cue ) ~= 'table' or not SOUNDS[ cue.kind ] or type( cue.org ) ~= 'string' then return end
    if not CanHear( cue ) then return end

    gAudioQueue[ #gAudioQueue + 1 ] = cue
    if gAudioPlaying then return end
    gAudioPlaying = true

    CreateThread( function()
        while #gAudioQueue > 0 do
            local pending = table.remove( gAudioQueue, 1 )

            if CanHear( pending ) then
                local sound = SOUNDS[ pending.kind ]

                SendNUIMessage({ action = 'playSound', data = {
                    transactionFile = sound.url, transactionVolume = 0.5,
                } })
                Wait( sound.duration )
            end
        end
        gAudioPlaying = false
    end )
end )
