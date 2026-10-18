local rankingNpcPed = nil
local RANKING_NPC_INTERACT_ID = "deathstatue:rankingNpc"

local function getRankingNpcConfig()
    return Config.RankingNpc
end

local function removeRankingNpcInteract()
    if rankingNpcPed and DoesEntityExist(rankingNpcPed) then
        interact.removeLocalEntity(rankingNpcPed)
    end

    interact.removeById(RANKING_NPC_INTERACT_ID)
end

local function deleteRankingNpc()
    removeRankingNpcInteract()

    if rankingNpcPed and DoesEntityExist(rankingNpcPed) then
        DeleteEntity(rankingNpcPed)
    end

    rankingNpcPed = nil
end

local function openRankingPanel(page)
    if inDeathStatueLobby or gameStarted or betweenRounds then
        return
    end

    local payload = lib.callback.await("deathstatue:server:getRankingPage", false, page or 1)
    if type(payload) ~= "table" then
        payload = {
            title = _t("ranking_title"),
            subtitle = _t("ranking_subtitle"),
            rows = {},
            best = nil,
            page = 1,
            totalPages = 1,
        }
    end

    showEstatuaRanking(payload)
end

local function registerRankingNpcInteract()
    if not rankingNpcPed or not DoesEntityExist(rankingNpcPed) then
        return
    end

    local cfg = getRankingNpcConfig()
    removeRankingNpcInteract()

    interact.addLocalEntity({
        id = RANKING_NPC_INTERACT_ID,
        entity = rankingNpcPed,
        options = {
            {
                label = _t("npc_ranking_label"),
                icon = "list-ol",
                onSelect = function()
                    openRankingPanel(1)
                end,
                canInteract = function()
                    return not inDeathStatueLobby and not gameStarted and not betweenRounds
                end,
            },
        },
        renderDistance = tonumber(cfg and cfg.RenderDistance) or 10.0,
        activeDistance = tonumber(cfg and cfg.InteractDistance) or 2.0,
        cooldown = 1500,
    })
end

local function spawnRankingNpc()
    local cfg = getRankingNpcConfig()
    if not cfg or cfg.Enabled == false or not cfg.Coords then
        return
    end

    deleteRankingNpc()

    local model = cfg.Model or "a_m_y_business_01"
    local modelHash = type(model) == "string" and joaat(model) or model
    RequestModel(modelHash)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(modelHash) and GetGameTimer() < timeout do
        Wait(10)
    end

    if not HasModelLoaded(modelHash) then
        sx.logger:warn(('deathstatue: falha ao carregar modelo do NPC de ranking (%s)'):format(tostring(model)))
        return
    end

    local coords = cfg.Coords
    rankingNpcPed = CreatePed(4, modelHash, coords.x, coords.y, coords.z - 1.0, coords.w or 0.0, false, true)
    SetEntityHeading(rankingNpcPed, coords.w or 0.0)
    FreezeEntityPosition(rankingNpcPed, true)
    SetEntityInvincible(rankingNpcPed, true)
    SetBlockingOfNonTemporaryEvents(rankingNpcPed, true)
    SetModelAsNoLongerNeeded(modelHash)

    registerRankingNpcInteract()
end

-- CreateThread(function()
--     Wait(1500)
--     spawnRankingNpc()
-- end)

AddEventHandler("onResourceStop", function(name)
    if GetCurrentResourceName() ~= name then return end

    deleteRankingNpc()
end)
