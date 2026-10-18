cityName = GetConvar("cityName", "")
local CURRENT_NEWS = "new_farm"

-- All text content for the News Promo modal
-- Change these to update the modal without rebuilding the frontend
local NEWS_PROMO_CONFIG = {
    ["Maresia"] = {
        title = "Novidades na Área!",
        subtitle = "Novos Farms",
        description = "Conheça os Novos Farms disponíveis no painel de organização. Complete ações pela cidade e ganhe o seu farm. Escolha uma opção e comece agora.",
        cta = "Começar Agora",
        cards = {
            {
                emoji = "⚔️",
                badge = "Farm",
                title = "Farm de Dominação",
                description = "Domine os pontos da cidade e garanta farm para a sua organização.",
                image = "https://cdn.santagroup.gg/minigame/banner5.webp",
            },
            {
                emoji = "🎁",
                badge = "Farm",
                title = "Roubo a ATM",
                description = "Conclua roubos de caixa eletrônico e ganhe farm.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painelfac/atm.png",
            },
            {
                emoji = "💸",
                badge = "Farm",
                title = "Roubo a Lojinhas",
                description = "Complete roubos de lojinhas e ganhe mais no seu farm.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painelfac/central.png",
            },
            {
                emoji = "🎁",
                badge = "Farm",
                title = "Arena Pista",
                description = "Participe da Arena e ganhe farm por tempo jogado.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painelfac/descequebra.png",
            },
            {
                emoji = "💸",
                badge = "Farm",
                title = "Arena 1x1",
                description = "Termine uma partida de x1 e ganhe mais no seu farm.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painelfac/ffa.png",
            },
        },
    },
    --[[
    ["Malta"] = {
        title = "Novidades na Área!",
        subtitle = "Novos Farms",
        description = "Conheça os Novos Farms disponíveis no painel de organização. Complete ações pela cidade e ganhe o seu farm. Escolha uma opção e comece agora.",
        cta = "Começar Agora",
        cards = {
            {
                emoji = "🎁",
                badge = "Farm",
                title = "Roubo a ATM",
                description = "Conclua roubos de caixa eletrônico e ganhe farm.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painelfac/atm.png",
            },
            {
                emoji = "💸",
                badge = "Farm",
                title = "Roubo a Lojinhas",
                description = "Complete roubos de lojinhas e ganhe mais no seu farm.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painelfac/central.png",
            },
            {
                emoji = "🎁",
                badge = "Farm",
                title = "Arena Pista",
                description = "Participe da Arena e ganhe farm por tempo jogado.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painelfac/descequebra.png",
            },
            {
                emoji = "💸",
                badge = "Farm",
                title = "Arena 1x1",
                description = "Termine uma partida de x1 e ganhe mais no seu farm.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painelfac/ffa.png",
            },
        },
    },
    --]]
    ["GoatRP"] = {
        title = "Du nouveau dans le coin !",
        subtitle = "Nouvelles farms",
        description = "Découvrez les nouvelles farms disponibles dans le panneau d'organisation. Réalisez des actions en ville et remportez votre farm. Choisissez une option et lancez-vous.",
        cta = "Commencer maintenant",
        cards = {
            {
                emoji = "🎁",
                badge = "Farm",
                title = "Braquage d'ATM",
                description = "Réalisez des braquages de distributeurs automatiques et gagnez du farm.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painelfac/atm.png",
            },
            {
                emoji = "💸",
                badge = "Farm",
                title = "Braquage d'supérettes",
                description = "Terminez des braquages de supérettes et augmentez votre farm.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painelfac/central.png",
            },
            {
                emoji = "🎁",
                badge = "Farm",
                title = "Arène piste",
                description = "Participez à l'arène et gagnez du farm selon le temps joué.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painelfac/descequebra.png",
            },
            {
                emoji = "💸",
                badge = "Farm",
                title = "Arène 1x1",
                description = "Terminez un match en 1 contre 1 et gagnez plus pour votre farm.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painelfac/ffa.png",
            },
        },
    },
    --[[
    ["Liberty99"] = {
        title = "What's New in the Area!",
        subtitle = "New Farms",
        description = "Check out the new Farms available in the organization panel. Complete actions around the city and earn your farm. Pick an option and get started now.",
        cta = "Start Now",
        cards = {
            {
                emoji = "🎁",
                badge = "Farm",
                title = "ATM Robbery",
                description = "Complete ATM robberies and earn farm.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painelfac/atm.png",
            },
            {
                emoji = "💸",
                badge = "Farm",
                title = "Convenience Store Robbery",
                description = "Complete store robberies and earn more on your farm.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painelfac/central.png",
            },
            {
                emoji = "🎁",
                badge = "Farm",
                title = "Arena Track",
                description = "Join the Arena and earn farm based on time played.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painelfac/descequebra.png",
            },
            {
                emoji = "💸",
                badge = "Farm",
                title = "1v1 Arena",
                description = "Finish a 1v1 match and earn more on your farm.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painelfac/ffa.png",
            },
        },
    },
    --]]
}
-- KVP Key formats
local KVP_TOTAL_VIEWS = CURRENT_NEWS..":new_hub:news_modal:total_views:%s"        -- cityName (total times modal was shown)
local KVP_HAS_CONVERTED = CURRENT_NEWS..":new_hub:news_modal:has_converted:%s"    -- cityName (if player ever clicked "Começar Agora")
local KVP_LAST_VIEW_DAY = CURRENT_NEWS..":new_hub:news_modal:last_view_day:%s"    -- cityName

local MIN_VIEWS_TO_STOP = 3

-- Current day from GlobalState
local currentDay = nil

--=============================================================================
-- KVP Helper Functions
--=============================================================================

local function GetKvpTotalViews()
    local key = KVP_TOTAL_VIEWS:format(cityName)
    local value = GetResourceKvpInt(key)
    return value > 0 and value or 0
end

local function SetKvpTotalViews(count)
    local key = KVP_TOTAL_VIEWS:format(cityName)
    SetResourceKvpInt(key, count)
end

local function GetKvpHasConverted()
    local key = KVP_HAS_CONVERTED:format(cityName)
    local value = GetResourceKvpInt(key)
    return value == 1
end

local function SetKvpHasConverted()
    local key = KVP_HAS_CONVERTED:format(cityName)
    SetResourceKvpInt(key, 1)
end

local function GetKvpLastViewDay()
    local key = KVP_LAST_VIEW_DAY:format(cityName)
    return GetResourceKvpString(key) or ""
end

local function SetKvpLastViewDay(day)
    local key = KVP_LAST_VIEW_DAY:format(cityName)
    SetResourceKvp(key, day)
end

--=============================================================================
-- Stop Conditions
--=============================================================================

-- CONDIÇÃO PARA PARAR DE EXIBIR (nunca mais):
-- Foi exibido ao menos 3 vezes, E o player converteu ao menos 1 vez
local function ShouldStopShowingForever()
    local totalViews = GetKvpTotalViews()
    local hasConverted = GetKvpHasConverted()
    return totalViews >= MIN_VIEWS_TO_STOP and hasConverted
end

-- Check if was shown today
local function WasShownToday()
    local lastViewDay = GetKvpLastViewDay()
    return lastViewDay == currentDay
end

--=============================================================================
-- Event Handlers
--=============================================================================

RegisterNetEvent('hub:openNewsPromo')
AddEventHandler('hub:openNewsPromo', function()
    local Data = NEWS_PROMO_CONFIG[cityName]
    if not Data then
        return
    end
    print(json.encode(Data))
    SendNUIMessage({
        action = 'openNewsPromo',
        data = Data
    })
    SetNuiFocus(true, true)
end)

-- Callback: Player clicked "Começar Agora" (Start Now)
RegisterNUICallback('startNewsPromo', function(data, cb)
    print('[NewsPromo] Player clicked Comecar Agora - marking converted')

    -- Marca que converteu (pelo menos 1 vez)
    SetKvpHasConverted()
    TriggerServerEvent("new_hub:news:addEvent", "news_modal_converted:"..CURRENT_NEWS)

    SetNuiFocus(false, false)
    Wait(100)
    TriggerServerEvent("net:painel:OpenFarmScreen")
    cb('ok')
end)

-- Callback: Player closed the News Promo modal (X)
RegisterNUICallback('closeNewsPromo', function(data, cb)
    print('[NewsPromo] Player closed with X')

    -- Incrementa contador de exibições
    local totalViews = GetKvpTotalViews()
    SetKvpTotalViews(totalViews + 1)

    -- Marca último dia visto
    SetKvpLastViewDay(currentDay)

    TriggerServerEvent("new_hub:news:addEvent", "news_modal_closed:"..CURRENT_NEWS)

    SetNuiFocus(false, false)
    cb('ok')
end)

-- Debug command
RegisterCommand('newspromohub', function()
    currentDay = GlobalState["TodaysDate"]
    print('[NewsPromo] Total views:', GetKvpTotalViews())
    print('[NewsPromo] Has converted:', GetKvpHasConverted())
    print('[NewsPromo] Last view day:', GetKvpLastViewDay())
    print('[NewsPromo] Current day:', currentDay)
    print('[NewsPromo] Was shown today:', WasShownToday())
    print('[NewsPromo] Should stop forever:', ShouldStopShowingForever())
    TriggerEvent('hub:openNewsPromo')
end)

--=============================================================================
-- Main Flow - Player enters the city
--=============================================================================

AddEventHandler("vRP:Active", function(Passport, Name)

    if not GlobalState["NewFarmPVP"] then
        return
    end

    print('[NewsPromo] vRP:Active triggered')
    Wait(35000)
    print('[NewsPromo] Waiting 35000ms')
    currentDay = GlobalState["TodaysDate"]

    -- Wait for current day from GlobalState
    local attempts = 0
    while not currentDay and attempts < 50 do
        currentDay = GlobalState["TodaysDate"]
        Wait(100)
        attempts = attempts + 1
    end

    if not currentDay then
        print('[NewsPromo] Error: currentDay not available')
        return
    end

    -- Player é iniciante? (FirstLogin)
    if LocalPlayer["state"]["FirstLogin"] then
        print('[NewsPromo] Not showing - FirstLogin')
        return
    end

    -- Player está criando personagem?
    if LocalPlayer["state"]["Creating"] then
        print('[NewsPromo] Not showing - Creating')
        return
    end

    -- CONDIÇÃO 1: Player tem organização? → Se não, para. Não exibe.
    local Job = LocalPlayer.state['Job']
    if not Job or Job == "none" then
        print('[NewsPromo] Not showing - no job')
        return
    end

    -- Verificar se é organização ilegal
    if not exports['painel']:CheckIfIlegal(Job) then
        print('[NewsPromo] Not showing - not illegal')
        return
    end

    -- CONDIÇÃO 2: Já viu 3x E já converteu? → Se sim, para. Não exibe.
    -- (Foi exibido ao menos 3 vezes, E player converteu ao menos 1 vez)
    if ShouldStopShowingForever() then
        print('[NewsPromo] Not showing - viewed 3+ times AND converted (stop forever)')
        return
    end

    -- CONDIÇÃO 3: Já foi exibido hoje? → Se sim, para. Não exibe.
    if WasShownToday() then
        print('[NewsPromo] Not showing - already shown today')
        return
    end

    -- Passou tudo → exibe e conta +1
    print('[NewsPromo] Showing modal - all checks passed')
    TriggerEvent('hub:openNewsPromo')
    TriggerServerEvent("new_hub:news:addEvent", "news_modal_triggered:"..CURRENT_NEWS)
end)
