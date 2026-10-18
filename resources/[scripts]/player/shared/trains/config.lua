-- Passeio de trem (Sandy Shores -> Los Santos).
-- Experiencia scriptada: chama o trem, embarca (com outros players), e apos a janela
-- de embarque um jogo de camera + fade teleporta todo mundo pra cidade.

local trainCityName = GetConvar('cityName', rawget(_G, 'cityName') or '')

local trainEnabledCities = {
    Kingdom = true
}

local function isTrainCityEnabled(city)
    city = tostring(city or ''):lower()

    for enabledCity in pairs(trainEnabledCities) do
        if (enabledCity:lower() == city) then
            return true
        end
    end

    return false
end

TrainConfig = {
    enabled = isTrainCityEnabled(trainCityName),
    enabledCities = trainEnabledCities,

    model = 'metrotrain', -- unico modelo autorizado no anti-cheat do santa_radio
    -- indices de config de trains.xml testados EM ORDEM; usa o primeiro que spawnar um metrotrain.
    -- Nesta build: 21 = metro simples. (26 = trem de CARGA aqui, nao metro duplo -> bloqueado pelo anti-cheat.)
    configIndices = { 21 },

    station = {
        coords = vec3(1907.38, 3568.21, 38.82),
        heading = 198.81,
        labelKey = 'trains_station_label',
        blip = { sprite = 795, color = 3, scale = 0.8 }
    },

    destination = {
        coords = vec3(110.63,-1724.96,29.00),
        heading = 213.03
    },

    callDistance = 30.0, -- alcance do interact e validacao server-side (anti teleporte de graca)
    boardWindow = 20000, -- ms de embarque antes de partir (define quanto tempo o trem fica na estacao)
    cooldown = 20, -- s de cooldown do MESMO player (anti-spam); nao afeta outros players
    -- (o lock que impede chamar 2 trens ao mesmo tempo e calculado no server: ~= boardWindow + cena de partida)

    moveSpeed = 8.0, -- m/s: arrancada do trem durante a cena de partida (so quem controla dirige)

    fadeTime = 800, -- ms de fade in/out
    departCinematic = 3000, -- ms de camera cinematografica no trem antes do fade
    departDriveTime = 5000, -- ms que o trem anda visivel antes do fade/teleporte
    arriveCinematic = 2500, -- ms de camera no destino apos o fade in

    -- painel DUI 3D "proximo trem em" no trem (holografico flutuante, sempre de frente)
    board = {
        offset = vec3(0.0, 0.0, 4.0), -- deslocamento relativo ao trem
        size = 0.2, -- tamanho do painel (fracao de tela; ajuste fino in-game)
        renderDistance = 22.0, -- distancia pra desenhar o painel
        duiWidth = 620, -- resolucao da textura da DUI
        duiHeight = 320
    }
}
