local gPlaytimeSeconds = -1
local gLastNpsSliceTriggered = -1  -- Guarda o último slice que disparou NPS

local gPlaytimeBaselineSeconds = nil
local EM_CASA_SLICE_SECONDS = 15 * 60

-- Tempo AFK ( em segundos ) já fechado na janela atual, enviado e zerado a cada
-- request_increment_playtime_hour. Esse contador é usado apenas pelo new_hub.
local gAfkSecondsSinceReport = 0

-- Instante ( GetGameTimer, ms ) em que o trecho AFK atual começou, ou nil se o
-- jogador não está AFK.
local gAfkStartedAtMs = nil

-- Início de um trecho AFK: guarda o instante de começo.
local function OnAfkStarted()

    gAfkStartedAtMs = GetGameTimer()
end

-- Fim de um trecho AFK: soma a duração do trecho no acumulado.
local function OnAfkStopped()

    if not gAfkStartedAtMs then
        return
    end

    gAfkSecondsSinceReport = gAfkSecondsSinceReport + ( GetGameTimer() - gAfkStartedAtMs ) / 1000
    gAfkStartedAtMs = nil
end

---@return number Segundos AFK acumulados desde a última chamada ( zera o buffer ).
local function ConsumeAfkSeconds()

    -- Se ainda está AFK, fecha o trecho atual e reabre a partir de agora, para
    -- não perder o tempo nem contar de novo na próxima janela.
    if gAfkStartedAtMs then

        local now = GetGameTimer()

        gAfkSecondsSinceReport = gAfkSecondsSinceReport + ( now - gAfkStartedAtMs ) / 1000
        gAfkStartedAtMs = now
    end

    local seconds = math.floor( gAfkSecondsSinceReport )

    gAfkSecondsSinceReport = 0

    return seconds
end

-- Reage às transições de AFK emitidas pelo wrapper local ( client/afk_state.lua ).
AddEventHandler( 'afk:started', OnAfkStarted )
AddEventHandler( 'afk:stopped', OnAfkStopped )

---@param playtimeSeconds number Segundos jogados somando todas as sessões de jogo.
RegisterNetEvent( 'net.playsession.on_start_playtime_tracker', function( playtimeSeconds )
    gPlaytimeSeconds = playtimeSeconds
    gPlaytimeBaselineSeconds = playtimeSeconds

    -- Se o jogador já estava AFK quando o tracking começou, abre o trecho agora.
    if exports.player:IsAfk( GetPlayerServerId( PlayerId() ) ) then
        OnAfkStarted()
    end
end)

-- ENG-3871: no restart do new_hub o server reenvia o start antes do client registrar o handler; o evento
-- se perde e o playtime fica -1 ate relogar (bloqueia /adm e F3 pelo filtro de novato do hud). Pede de novo.
CreateThread(function()
    while gPlaytimeSeconds == -1 do
        TriggerServerEvent( 'net.playsession.request_playtime_tracker' )
        Wait( 10000 )
    end
end)

CreateThread(function()

    while true do

        Wait( 0 )


        if gPlaytimeSeconds ~= -1 then

            local secondsSinceLastUpdate = GetFrameTime()

            local prevPlaytimeHours = math.floor( gPlaytimeSeconds / 3600 )

            local newPlaytimeSeconds = gPlaytimeSeconds + secondsSinceLastUpdate
            local newPlaytimeHours = math.floor( newPlaytimeSeconds / 3600 )

            if gPlaytimeBaselineSeconds then
                local prevSessionElapsed = gPlaytimeSeconds - gPlaytimeBaselineSeconds
                local newSessionElapsed = newPlaytimeSeconds - gPlaytimeBaselineSeconds

                local prevBucket = math.floor( prevSessionElapsed / EM_CASA_SLICE_SECONDS )
                local newBucket = math.floor( newSessionElapsed / EM_CASA_SLICE_SECONDS )

                if newBucket > prevBucket and newBucket >= 1 then
                    TriggerServerEvent( 'net.em_casa.playtime_heartbeat' )
                end
            end
            
            local newPlaytimeMinutes = newPlaytimeSeconds / 60
            local prevPlaytimeMinutes  = gPlaytimeSeconds / 60

            local prevPlaytimeSlice = math.floor((prevPlaytimeMinutes - 1) / MAX_MINUTES_TO_TRIGGER_NPS)
            local newPlaytimeSlice = math.floor((newPlaytimeMinutes - 1) / MAX_MINUTES_TO_TRIGGER_NPS)

            -- Previne race condition: só dispara se mudou de slice E ainda não disparou para esse slice
            if newPlaytimeSlice ~= prevPlaytimeSlice and newPlaytimeSlice ~= gLastNpsSliceTriggered then
                gLastNpsSliceTriggered = newPlaytimeSlice
                TriggerServerEvent('net.playsession.trigger_nps_indication')
            end

            -- Adicionamos uma nova hora ao nosso tempo de jogo?
            if newPlaytimeHours > prevPlaytimeHours then

                TriggerServerEvent( 'net.playsession.request_increment_playtime_hour', ConsumeAfkSeconds() )
            end

            gPlaytimeSeconds = newPlaytimeSeconds

            -- print('gPlaytimeSeconds: ' .. gPlaytimeSeconds, secondsSinceLastUpdate, prevPlaytimeHours, newPlaytimeHours)
        end
    end
end)

exports( 'GetPlaytimeSeconds', function()

    return gPlaytimeSeconds
end)

exports( 'GetPlaytimeMinutes', function()

    return math.floor( gPlaytimeSeconds / 60 )
end)

exports( 'GetPlaytimeHours', function()

    return math.floor( gPlaytimeSeconds / 3600 )
end)

exports( 'IsPlaysessionReady', function()

    return gPlaytimeSeconds ~= -1
end)