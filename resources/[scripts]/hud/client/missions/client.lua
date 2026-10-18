local WAYPOINT_RADIUS      = 50.0
local COMPLETION_DELAY     = 5000
local REFRESH_INTERVAL     = 2000
local GENTE_BOA_MISSION_ID = "gente_boa_do_topo"
local FAC_GENTE_BOA_MISSION_ID = "fac_gente_boa"

local LEVEL_UP_BANNER_REWARD_ICON = "https://cdn.santagroup.gg/dc3168c1-da00-4c23-8331-4841b206df6b-star.svg"

--- Tabela de copy das missões da Trilha Inicial.
--- - cardTitle / cardLine: vão pro card direito (header e corpo).
--- - left: texto curto do card "Missão Ativa" (top-left abaixo do chat).
--- - tipText: string OU função `() -> string` quando o texto depende de estado
---   (ramo, missão, ConVar). A função roda a cada render do card.
--- - tipKey: opcional. Quando setado, a tip vira variante "com keyhint" e é
---   renderizada como `Use [<tipKey>] <tipText>` (ex: link_discord, cidadao_oficial).
local RAMO_TIP_TEXT       = _t("hud.mission.ramo.tip_default")

---@return boolean
local function IsCriminalRamo()

    if GetResourceState( "missions" ) ~= "started" then
        return false
    end

    local success, playerRamo = pcall( function()
        return exports[ "missions" ]:GetPlayerRamo()
    end )

    return success and type( playerRamo ) == "string" and playerRamo:lower() == "criminoso"
end

---@param mission table | nil
---@return string
local function GetGenteBoaDescription(mission)

    local isFacMission = mission and mission.id == FAC_GENTE_BOA_MISSION_ID
    local translationPrefix = isFacMission and "hud.mission.fac_gente_boa" or "hud.mission.gente_boa_do_topo"
    local goal = mission and tonumber(mission.max) or ( isFacMission and 15 or 10 )
    local description = (_t( ( "%s.tipText" ):format( translationPrefix ) )):format(goal)
    local supportText = _t( ( "%s.supportText" ):format( translationPrefix ) )

    return ('<span style="color: rgba(255, 255, 255, 0.8); font-weight: 600">%s</span><br><span style="color: rgba(255, 255, 255, 0.5); font-weight: 400">%s</span>'):format(
        description, supportText)
end

---@param mission table | nil
---@return string | nil
local function GetGenteBoaProgressText(mission)

    if not mission or ( mission.id ~= GENTE_BOA_MISSION_ID and mission.id ~= FAC_GENTE_BOA_MISSION_ID ) then
        return nil
    end

    local current = tonumber(mission.current) or 0
    local goal = tonumber(mission.max) or ( mission.id == FAC_GENTE_BOA_MISSION_ID and 15 or 10 )

    return ("%d/%d"):format(current, goal)
end

---@param mission table | nil
---@return number | nil progress
local function GetGenteBoaProgressValue(mission)

    if not mission or ( mission.id ~= GENTE_BOA_MISSION_ID and mission.id ~= FAC_GENTE_BOA_MISSION_ID ) then
        return nil
    end

    local current = tonumber(mission.current) or 0
    local goal = tonumber(mission.max) or ( mission.id == FAC_GENTE_BOA_MISSION_ID and 15 or 10 )

    if goal <= 0 then
        return 0
    end

    return math.floor(math.min(current / goal, 1.0) * 100)
end

local MISSION_HUD_TEXT     = {
    link_discord             = { cardTitle = _t("hud.mission.link_discord.cardTitle"),        cardLine = _t("hud.mission.link_discord.cardLine"),                             left = "", tipKey = "M", tipText = _t("hud.mission.link_discord.tipText") },
    seja_voce                = { cardTitle = _t("hud.mission.seja_voce.cardTitle"),        cardLine = _t("hud.mission.seja_voce.cardLine"),                      left = "", tipText = _t("hud.mission.seja_voce.tipText") },
    nova_familia             = { cardTitle = _t("hud.mission.nova_familia.cardTitle"),     cardLine = _t("hud.mission.nova_familia.cardLine"),                        left = "", tipText = function()
        if IsCriminalRamo() then
            return _t("hud.mission.nova_familia.tipText_discovery")
        end
        return _t("hud.mission.nova_familia.tipText")
    end },
    primeiras_rodas          = { cardTitle = _t("hud.mission.primeiras_rodas.cardTitle"),  cardLine = _t("hud.mission.primeiras_rodas.cardLine"),                                left = "", tipText = _t("hud.mission.primeiras_rodas.tipText") },
    documento_na_mao         = { cardTitle = _t("hud.mission.documento_na_mao.cardTitle"), cardLine = _t("hud.mission.documento_na_mao.cardLine"),     left = "", tipText = _t("hud.mission.documento_na_mao.tipText") },
    em_casa                  = { cardTitle = _t("hud.mission.em_casa.cardTitle"),          cardLine = _t("hud.mission.em_casa.cardLine"),                              left = "", tipText = _t("hud.mission.em_casa.tipText") },
    cidadao_oficial          = { cardTitle = _t("hud.mission.cidadao_oficial.cardTitle"),  cardLine = _t("hud.mission.cidadao_oficial.cardLine"),                             left = "", tipKey = "M", tipText = _t("hud.mission.cidadao_oficial.tipText") },
    cara_conhecida           = { cardTitle = _t("hud.mission.cara_conhecida.cardTitle"),   cardLine = _t("hud.mission.cara_conhecida.cardLine"),                            left = "", tipText = _t("hud.mission.cara_conhecida.tipText") },
    boa_impressao            = { cardTitle = _t("hud.mission.boa_impressao.cardTitle"),    cardLine = _t("hud.mission.boa_impressao.cardLine"),                                  left = "", tipText = _t("hud.mission.boa_impressao.tipText") },
    role_pela_cidade         = { cardTitle = _t("hud.mission.role_pela_cidade.cardTitle"), cardLine = _t("hud.mission.role_pela_cidade.cardLine"),                 left = "", tipText = _t("hud.mission.role_pela_cidade.tipText") },
    -- M11 (ramo) — tip genérica única, não varia por ramo (ENG-1550).
    ramo_primeiro_roubo      = { cardTitle = _t("hud.mission.ramo_primeiro_roubo.cardTitle"),   cardLine = _t("hud.mission.ramo_primeiro_roubo.cardLine"), left = "",tipText = RAMO_TIP_TEXT },
    ramo_primeira_patrulha   = { cardTitle = _t("hud.mission.ramo_primeira_patrulha.cardTitle"),cardLine = _t("hud.mission.ramo_primeira_patrulha.cardLine"),                                 left = "",tipText = RAMO_TIP_TEXT },
    ramo_primeiro_conserto   = { cardTitle = _t("hud.mission.ramo_primeiro_conserto.cardTitle"),cardLine = _t("hud.mission.ramo_primeiro_conserto.cardLine"),                             left = "",tipText = RAMO_TIP_TEXT },
    ramo_primeiro_socorro    = { cardTitle = _t("hud.mission.ramo_primeiro_socorro.cardTitle"), cardLine = _t("hud.mission.ramo_primeiro_socorro.cardLine"),                              left = "",tipText = _t("hud.mission.ramo_primeiro_socorro.tipText") },
    ramo_primeiro_negocio    = { cardTitle = _t("hud.mission.ramo_primeiro_negocio.cardTitle"), cardLine = _t("hud.mission.ramo_primeiro_negocio.cardLine"),                              left = "",tipText = RAMO_TIP_TEXT },
    ramo_primeiro_show       = { cardTitle = _t("hud.mission.ramo_primeiro_show.cardTitle"),    cardLine = _t("hud.mission.ramo_primeiro_show.cardLine"),                               left = "R",tipText = RAMO_TIP_TEXT },

    vestir_uniforme          = { cardTitle = _t("hud.mission.vestir_uniforme.cardTitle"), cardLine = "",                 left = "", tipText = _t("hud.mission.vestir_uniforme.tipText") },
    entrar_na_radio          = { cardTitle = _t("hud.mission.entrar_na_radio.cardTitle"), cardLine = "",                 left = "", tipText = _t("hud.mission.entrar_na_radio.tipText") },
    farm_e_deposito_bau      = { cardTitle = _t("hud.mission.farm_e_deposito_bau.cardTitle"), cardLine = "",                 left = "", tipText = _t("hud.mission.farm_e_deposito_bau.tipText") },
    farm_coletivo            = { cardTitle = _t("hud.mission.farm_coletivo.cardTitle"), cardLine = "",                 left = "", tipText = _t("hud.mission.farm_coletivo.tipText") },
    conhecer_novos_farms     = { cardTitle = _t("hud.mission.conhecer_novos_farms.cardTitle"), cardLine = "",                 left = "", tipText = _t("hud.mission.conhecer_novos_farms.tipText") },
    roubo_atm                = { cardTitle = _t("hud.mission.roubo_atm.cardTitle"), cardLine = "",                 left = "", tipText = _t("hud.mission.roubo_atm.tipText") },
    arena_pista              = { cardTitle = _t("hud.mission.arena_pista.cardTitle"), cardLine = "",                 left = "", tipText = _t("hud.mission.arena_pista.tipText") },
    roubo_lojinha            = { cardTitle = _t("hud.mission.roubo_lojinha.cardTitle"), cardLine = "",                 left = "", tipText = _t("hud.mission.roubo_lojinha.tipText") },
    arena_1x1                = { cardTitle = _t("hud.mission.arena_1x1.cardTitle"), cardLine = "",                 left = "", tipText = _t("hud.mission.arena_1x1.tipText") },
    primeiro_bico            = { cardTitle = _t("hud.mission.primeiro_bico.cardTitle"), cardLine = "",                 left = "", tipText = _t("hud.mission.primeiro_bico.tipText") },
    parceiro_de_crime        = { cardTitle = _t("hud.mission.parceiro_de_crime.cardTitle"), cardLine = "",                 left = "", tipText = _t("hud.mission.parceiro_de_crime.tipText") },
    lenda_criminal           = { cardTitle = _t("hud.mission.lenda_criminal.cardTitle"), cardLine = "",                 left = "", tipText = _t("hud.mission.lenda_criminal.tipText") },
    mestre_do_crime          = { cardTitle = _t("hud.mission.mestre_do_crime.cardTitle"), cardLine = "",                 left = "", tipText = _t("hud.mission.mestre_do_crime.tipText") },
    gente_boa_do_topo        = { cardTitle = _t("hud.mission.gente_boa_do_topo.cardTitle"), cardLine = "", left = "", tipText = GetGenteBoaDescription, hideDetails = true },
    fac_gente_boa             = { cardTitle = _t("hud.mission.fac_gente_boa.cardTitle"), cardLine = "", left = "", tipText = GetGenteBoaDescription, hideDetails = true },
}

---@return string cardTitle, string cardLine, string leftLine
local function GetHudTextLines(mission)
    if not mission or not mission.id then
        return _t("hud.label.mission_default"), "", ""
    end
    local o = MISSION_HUD_TEXT[mission.id]
    if o then
        return o.cardTitle, o.cardLine, o.left
    end
    local name = mission.name or mission.groupName or _t("hud.label.mission_default")
    local desc = mission.description or ""
    return name, desc, desc
end

local currentMission       = nil
local nextMissionName      = nil
local minimizedByPlayer    = false
local forceVisibleByPlayer = false
local hintVisible          = false
local gIsQualityFeedbackVisible = false
local welcomeCityVisible   = false
-- Default true: chars retornantes não bloqueiam. Vira false só quando bprotection
-- avisa que é first-login dessa sessão; libera 5s após o banner "BOAS VINDAS".
local hudUnlocked          = true
-- Trava o RefreshHUD durante a janela de celebração para o card "Missão Concluída"
-- não ser sobrescrito ou escondido pelo refresh periódico.
local completionLockUntil  = 0
local gAffiliateCommercialActive = false

---@return boolean blocked
local function IsMissionDisplayBlocked()

    return IsMissionHudBlocked() or gAffiliateCommercialActive
end

---@return boolean
local function IsAdminWithPersistentMissionCardPreference()

    local playerGroups = vRP.GetPlayerGroups()
    local adminLevel = playerGroups and tonumber( playerGroups[ "Admin" ] )

    return adminLevel ~= nil and adminLevel >= 1 and adminLevel <= 4
end

local function CompareMissionsByGroupThenOrder(a, b)
    local ga = a.groupIndex
    local gb = b.groupIndex

    if ga ~= gb then
        return ga < gb
    end

    return a.order < b.order
end

---@param a table
---@param b table
---@return boolean
local function CompareByTrailIndex(a, b)

    if a.trailIndex ~= b.trailIndex then
        return a.trailIndex < b.trailIndex
    end

    return (a.order or 0) < (b.order or 0)
end

---@param a table
---@param b table
---@return boolean
local function CompareByFacPriority(a, b)

    if a.facPriority ~= b.facPriority then
        return a.facPriority < b.facPriority
    end

    return (a.order or 0) < (b.order or 0)
end

---@param mission table | nil
---@param radius number
---@return boolean
local function IsMissionWithinRadius(mission, radius)

    if not mission or not mission.waypoints then
        return false
    end

    local pCoords = GetEntityCoords(PlayerPedId())

    for _, wp in ipairs(mission.waypoints) do

        if wp.coords then
            local dist = #(pCoords - wp.coords)

            if dist <= radius then
                return true
            end
        end
    end

    return false
end

---@param onboarding table
---@return table | nil mission
local function GetNearbyOnboardingMission(onboarding)

    if #onboarding == 0 then
        return nil
    end

    table.sort(onboarding, CompareByTrailIndex)

    for _, mission in ipairs(onboarding) do

        if IsMissionWithinRadius(mission, WAYPOINT_RADIUS) then
            return mission
        end
    end

    return nil
end

---@param missions table
---@param missionId string
---@return table | nil mission
local function FindMissionById(missions, missionId)

    for _, mission in ipairs(missions) do

        if mission.id == missionId then
            return mission
        end
    end

    return nil
end

---@return boolean
local function HasRecruiterRank()

    if not vRP or not vRP.GetPlayerJob then
        return false
    end

    local job, rank = vRP.GetPlayerJob()

    if job and ( 
        job == 'Desempregado' or job == 'Iniciante'
    ) then
        return false
    end

    return job and rank and rank <= 3 or false
end

---@return boolean
local function IsFacMissionOwner()

    if GetResourceState( "missions" ) ~= "started" then
        return false
    end

    return exports[ "missions" ]:IsFacMissionOwner()
end

---@param missions table
---@return table | nil mission
local function GetClosestMissionWithinRadius(missions)

    local pCoords = GetEntityCoords(PlayerPedId())
    local closestMission = nil
    local minDistance = WAYPOINT_RADIUS

    for _, mission in ipairs(missions) do

        if mission.id ~= GENTE_BOA_MISSION_ID and mission.waypoints then

            for _, wp in ipairs(mission.waypoints) do

                if wp.coords then
                    local dist = #(pCoords - wp.coords)

                    if dist <= WAYPOINT_RADIUS and dist < minDistance then
                        minDistance = dist
                        closestMission = mission
                    end
                end
            end
        end
    end

    return closestMission
end

---@return table mission
local function BuildGenteBoaMissionFallback()

    local mission = {
        id          = GENTE_BOA_MISSION_ID,
        name        = _t("hud.mission.gente_boa_do_topo.cardTitle"),
        icon        = "https://cdn.santagroup.gg/onboarding/nova_fam_lia.svg",
        current     = 0,
        max         = 10,
        groupId     = "social",
        groupName   = "Social",
        groupIcon   = "https://cdn.santagroup.gg/onboarding/nova_fam_lia.svg",
        groupIndex  = 4,
        order       = 1,
    }

    mission.description = GetGenteBoaDescription( mission )
    return mission
end

---@return table mission
local function BuildFacGenteBoaMissionFallback()

    local mission = {
        id          = FAC_GENTE_BOA_MISSION_ID,
        name        = _t("hud.mission.fac_gente_boa.cardTitle"),
        icon        = "https://cdn.santagroup.gg/onboarding/nova_fam_lia.svg",
        current     = 0,
        max         = 15,
        groupId     = "social",
        groupName   = "Social",
        groupIcon   = "https://cdn.santagroup.gg/onboarding/nova_fam_lia.svg",
        groupIndex  = 4,
        order       = 1,
    }

    mission.description = GetGenteBoaDescription( mission )
    return mission
end

---@return table all
---@return table onboarding
---@return table facTrack
---@return table | nil linkDiscord
local function CollectOpenMissions( tasksData )

    if not tasksData then
        if GetResourceState( "missions" ) ~= "started" then
            return {}, {}, {}, nil
        end
        local ok, fetched = pcall( function() return exports[ "missions" ]:GetTasksData() end )
        if not ok or not fetched then
            return {}, {}, {}, nil
        end
        tasksData = fetched
    end

    local all, onboarding, facTrack = {}, {}, {}
    local linkDiscord = nil
    local hasRecruiterRank = HasRecruiterRank()
    local isFacMissionOwner = IsFacMissionOwner()

    for _, group in ipairs( tasksData ) do

        if group.status == "active" and group.subTasks then
            local facPriority = GetFacTrackPriority and GetFacTrackPriority(group.id)

            for _, subTask in ipairs(group.subTasks) do

                if subTask.status ~= "completed" then
                    if ( subTask.id == GENTE_BOA_MISSION_ID or subTask.id == FAC_GENTE_BOA_MISSION_ID )
                        and not hasRecruiterRank then
                        goto continue
                    end

                    if subTask.id == GENTE_BOA_MISSION_ID and isFacMissionOwner then
                        goto continue
                    end

                    if subTask.id == FAC_GENTE_BOA_MISSION_ID and not isFacMissionOwner then
                        goto continue
                    end

                    local trailIndex = GetOnboardingIndex and GetOnboardingIndex(subTask.id) or nil
                    local mission = {
                        id          = subTask.id,
                        name        = subTask.name,
                        description = subTask.description,
                        icon        = subTask.icon,
                        current     = subTask.current or 0,
                        max         = subTask.max or 1,
                        groupId     = group.id,
                        groupName   = group.name,
                        groupIcon   = group.icon,
                        groupIndex  = group.index,
                        waypoints   = subTask.waypoints,
                        order       = subTask.order,
                        trailIndex  = trailIndex,
                        facPriority = facPriority,
                    }
                    all[#all + 1] = mission

                    if trailIndex then onboarding[#onboarding + 1] = mission end

                    if facPriority then facTrack[#facTrack + 1] = mission end

                    if subTask.id == "link_discord" then linkDiscord = mission end
                end

                ::continue::
            end
        end
    end

    return all, onboarding, facTrack, linkDiscord
end

---@return table | nil mission
---@return table allMissions
local function GetBestMission( tasksData )

    local all, onboarding, facTrack, linkDiscord = CollectOpenMissions( tasksData )
    local hasRecruiterRank = HasRecruiterRank()
    local isFacMissionOwner = IsFacMissionOwner()
    local genteBoaMission = nil

    if hasRecruiterRank then
        if isFacMissionOwner then
            genteBoaMission = FindMissionById( all, FAC_GENTE_BOA_MISSION_ID ) or BuildFacGenteBoaMissionFallback()
        else
            genteBoaMission = FindMissionById( all, GENTE_BOA_MISSION_ID ) or BuildGenteBoaMissionFallback()
        end
    end
    local closestMission = GetClosestMissionWithinRadius(all)
    local novaFamiliaMission = FindMissionById(onboarding, "nova_familia")

    if genteBoaMission then
        if #all == 0 then
            all[#all + 1] = genteBoaMission
        end

        return closestMission or genteBoaMission, all
    end

    if #all == 0 then
        return nil, {}
    end

    if linkDiscord then
        return linkDiscord, all
    end

    local nearbyOnboardingMission = GetNearbyOnboardingMission(onboarding)

    if nearbyOnboardingMission then
        return nearbyOnboardingMission, all
    end

    if novaFamiliaMission then
        return novaFamiliaMission, all
    end

    if #facTrack > 0 then
        table.sort(facTrack, CompareByFacPriority)
        return facTrack[1], all
    end

    if closestMission then
        return closestMission, all
    end

    table.sort(all, CompareMissionsByGroupThenOrder)
    local sequentialMission = all[1]

    if sequentialMission.waypoints and #sequentialMission.waypoints > 0 then
        return sequentialMission, all
    end

    return nil, all
end

---@param mission table | nil
---@return table | nil
local function BuildTrailProgress( mission, tasksData )

    if not GetOnboardingTotal then return nil end

    local total = GetOnboardingTotal()

    if not total or total <= 0 then return nil end

    local _, onboarding = CollectOpenMissions( tasksData )
    local openByIndex = {}

    for _, m in ipairs(onboarding) do

        if m.trailIndex then
            openByIndex[m.trailIndex] = true
        end
    end

    local slots = {}
    local completed = 0

    for i = 1, total do
        local isOpen = openByIndex[i] == true
        slots[i] = not isOpen

        if not isOpen then completed = completed + 1 end
    end

    local activeIndex = mission and mission.trailIndex or nil

    return {
        total       = total,
        completed   = completed,
        slots       = slots,
        activeIndex = activeIndex,
    }
end

--- Mesma prioridade do card de missão do HUD (Discord → waypoint 50m → 1ª com route); se ninguém for “eleito”, 1ª pendente na ordem.
function GetMissionsHudHighlight()
    if IsMissionDisplayBlocked() then return nil end

    local mission, allMissions = GetBestMission()
    if mission then
        return mission
    end
    if #allMissions > 0 then
        table.sort(allMissions, CompareMissionsByGroupThenOrder)
        return allMissions[1]
    end
    return nil
end

exports("GetMissionsHudHighlight", GetMissionsHudHighlight)

local function IsNearCurrentMission()
    if not currentMission or not currentMission.waypoints then return false end
    local pCoords = GetEntityCoords(PlayerPedId())
    for _, wp in ipairs(currentMission.waypoints) do
        local dist = #(pCoords - wp.coords)
        if dist < (wp.markerDistance or WAYPOINT_RADIUS) then
            return true
        end
    end
    return false
end

local function GetMissionDistanceText(mission)
    if not mission or not mission.waypoints or #mission.waypoints == 0 then
        return _t("next")
    end

    local pCoords = GetEntityCoords(PlayerPedId())
    local closestDistance = nil

    for _, wp in ipairs(mission.waypoints) do
        if wp.coords then
            local dist = #(pCoords - wp.coords)
            if not closestDistance or dist < closestDistance then
                closestDistance = dist
            end
        end
    end

    if not closestDistance then
        return _t("next")
    end

    local meters = math.floor(closestDistance + 0.5)
    if meters <= 1 then
        return _t("next")
    end

    return ("%dm"):format(meters)
end

local _lastDocumentNotifySig = nil
local affiliateWorldShortcutsVisible = false
-- Card de punição no ar: ele e o de missão dividem o mesmo canto da tela, e a punição ganha.
local punishmentCardVisible = false
local toxicityCardVisible = false
-- ENG-3724: card do convite X1 (dashboard) ocupa o canto da missão ativa.
local x1InviteCardVisible = false
local matchCityCardVisible = false
local gLastMissionSoundId = nil

local function ShowDocumentCard(mission, completed, tasksData)
    local title, missionName, text, distance
    local tipKey, tipText
    if completed == true then
        local cardTitle, cardLine = GetHudTextLines(mission)
        title       = mission.completedTitle or _t("hud.label.mission_completed")
        missionName = cardTitle or mission.completedMissionName or mission.name or _t("hud.label.mission")
        text        = mission.completedText or cardLine or mission.description or missionName
        distance    = false
    else
        local cardTitle, cardLine = GetHudTextLines(mission)
        title, missionName, text = cardTitle, cardTitle, cardLine
        distance = GetGenteBoaProgressText(mission) or GetMissionDistanceText(mission)
        local o = mission and mission.id and MISSION_HUD_TEXT[mission.id]
        if o then
            tipKey  = o.tipKey
            tipText = type(o.tipText) == 'function' and o.tipText(mission) or o.tipText
        end
    end
    local progress = GetGenteBoaProgressValue(mission) or BuildTrailProgress(mission, tasksData)
    local hideDetails = not completed and mission and mission.id and MISSION_HUD_TEXT[mission.id] and MISSION_HUD_TEXT[mission.id].hideDetails == true
    local payload = {
        visible   = true,
        title     = completed == true and title or _t("hud.label.mission_active"),
        missionName = missionName,
        distance  = distance,
        text      = completed == true and text or (tipText or text),
        icon      = mission.icon or mission.groupIcon or "",
        completed = completed == true,
        collapsed = completed == true and false or minimizedByPlayer == true,
        keyText   = hideDetails and "U" or "M",
        progress  = progress,
        keyPress  = hideDetails and "U" or "M",
        description = hideDetails and _t("hud.label.mission_hide2") or _t("hud.label.mission_details"),
        extraKey  = "U",
        extraText = _t("hud.label.mission_hide"),
        accent    = mission.id == FAC_GENTE_BOA_MISSION_ID and "gold" or "theme",
    }

    local progressSig = type(progress) == "table"
        and ( '%s/%s@%s' ):format( tostring( progress.completed ), tostring( progress.total ), tostring( progress.activeIndex ) )
        or tostring(progress or '')
    local sig = ( '%s|%s|%s|%s|%s|%s|%s|%s|%s' ):format(
        tostring( payload.title ), tostring( payload.missionName ),
        tostring( payload.distance ), tostring( payload.text ),
        tostring( payload.icon ), tostring( payload.completed ),
        tostring( payload.collapsed ), progressSig, tostring( payload.accent )
    )
    if sig == _lastDocumentNotifySig then return end
    _lastDocumentNotifySig = sig

    local missionSound = not completed and FEEDBACK_MISSION_SOUNDS[mission.id]

    if missionSound and gLastMissionSoundId ~= mission.id then
        TriggerEvent( "sounds:Private", missionSound.url, missionSound.volume )
        gLastMissionSoundId = mission.id
    elseif not missionSound then
        gLastMissionSoundId = nil
    end

    SendNUIMessage({ action = 'documentNotify', data = payload })
end

local function HideDocumentCard()
    _lastDocumentNotifySig = nil
    SendNUIMessage({ action = 'documentNotify', data = { visible = false, collapsed = false } })
end

local function ShowMissionToggleButton()
    SendNUIMessage({ action = 'helpActionNotify', data = { visible = false } })
    SendNUIMessage({ action = 'missionToggleButton', data = { visible = true, keyText = "U" } })
end

local function HideMissionToggleButton()
    SendNUIMessage({ action = 'missionToggleButton', data = { visible = false } })
end

--- Sincroniza o estado "card oculto" (toggle do H) com o NUI.
--- React esconde o card direito via cardCollapsed e troca a tip da esquerda para a variante 3.
local function SetCardCollapsed(collapsed)
    SendNUIMessage({
        action = 'toggleMissionCard',
        data   = { collapsed = collapsed and true or false },
    })
end

local function ShowActiveMission(mission, nextName)
    -- local _, _, left = GetHudTextLines(mission)
    -- SendNUIMessage({
    --     action = 'activeMission',
    --     data   = {
    --         visible = true,
    --         title   = "",
    --         text    = left,
    --         next    = _t("next"),
    --     }
    -- })
end

local function HideActiveMission()
    SendNUIMessage({ action = 'activeMission', data = { visible = false } })
end

local function SendXpFeeds(skillRewards)
    if IsMissionDisplayBlocked() then return end

    if not skillRewards then return end
    for skillId, amount in pairs(skillRewards) do
        SendNUIMessage({
            action = 'xpFeed',
            data   = {
                amount = string.format("+%d XP", amount),
                type   = _t("skill." .. skillId) or skillId,
            }
        })
    end
end

local function RefreshHUD(forceShow, allowPlayerMinimizedReopen)
    if IsMissionDisplayBlocked() then
        HideDocumentCard()
        HideActiveMission()
        HideMissionToggleButton()
        SendNUIMessage({ action = 'missionNotify', data = { visible = false } })
        SendNUIMessage({ action = 'welcomeCityNotify', data = { visible = false } })
        SendNUIMessage({ action = 'levelUpNotify', data = { visible = false } })
        if welcomeCityVisible then
            welcomeCityVisible = false
            SetNuiFocus(false, false)
        end
        completionLockUntil = 0
        currentMission = nil
        hintVisible = false
        return
    end

    if affiliateWorldShortcutsVisible or punishmentCardVisible or toxicityCardVisible
        or x1InviteCardVisible or matchCityCardVisible then
        HideDocumentCard()
        HideActiveMission()
        HideMissionToggleButton()
        return
    end

    if GetGameTimer() < completionLockUntil then
        return
    end

    local tasksData = nil
    if GetResourceState( "missions" ) == "started" then
        local ok, fetched = pcall( function() return exports[ "missions" ]:GetTasksData() end )
        if ok then tasksData = fetched end
    end
    local mission, allMissions = GetBestMission( tasksData )

    if not mission then
        if forceVisibleByPlayer and #allMissions > 0 then
            table.sort(allMissions, CompareMissionsByGroupThenOrder)
            mission = allMissions[1]
        end
    end

    if not mission then
        HideDocumentCard()
        HideActiveMission()
        currentMission  = nil
        nextMissionName = nil

        if #allMissions > 0 then
            if not hintVisible then
                hintVisible = true
                ShowMissionToggleButton()
            end
        else
            if hintVisible then
                hintVisible = false
                SendNUIMessage({ action = 'helpActionNotify', data = { visible = false } })
            end
            HideDocumentCard()
            HideMissionToggleButton()
        end
        return
    end

    if hintVisible then
        hintVisible = false
        SendNUIMessage({ action = 'helpActionNotify', data = { visible = false } })
        HideMissionToggleButton()
    end

    local nextMission = nil
    table.sort(allMissions, CompareMissionsByGroupThenOrder)
    for i, m in ipairs(allMissions) do
        if m.id == mission.id then
            nextMission = allMissions[i+1]
            break
        end
    end

    local missionChanged = not currentMission or currentMission.id ~= mission.id

    if missionChanged then
        currentMission    = mission
    end

    nextMissionName = nextMission and nextMission.name or nil

    if forceShow and allowPlayerMinimizedReopen then
        minimizedByPlayer = false
        SetCardCollapsed(false)
    end

    if not hudUnlocked then
        HideActiveMission()
        HideDocumentCard()
        return
    end

    if gIsQualityFeedbackVisible then
        HideActiveMission()
        HideDocumentCard()
        return
    end

    -- Sempre empurra os dados do card; a visibilidade real do card direito é decidida no React
    -- via cardCollapsed (toggle do H). Quando minimizado, a tip esquerda mostra a variante 3.
    HideMissionToggleButton()
    if minimizedByPlayer then
        SetCardCollapsed(true)
    end
    ShowDocumentCard( mission, false, tasksData )
    if not minimizedByPlayer then
        ShowActiveMission(mission, nextMissionName)
    else
        HideActiveMission()
    end
end

---@param isVisible boolean
---@return nil
local function OnQualityFeedbackVisibilityChanged( isVisible )
    gIsQualityFeedbackVisible = isVisible == true

    if gIsQualityFeedbackVisible then
        HideActiveMission()
        HideDocumentCard()
        return
    end

    RefreshHUD( false )
end

AddEventHandler( "hud:gamifiedFeedback:visibilityChanged", OnQualityFeedbackVisibilityChanged )

AddEventHandler( 'dashboard:affiliateServiceChanged', function()

    RefreshHUD( true, true )
end )

RegisterCommand('+hud_mission_card_toggle', function()
    if IsMissionDisplayBlocked() then return end

    -- Com o card de punição no ar, o U é dele: sem isso o mesmo toque mexeria nos dois.
    if affiliateWorldShortcutsVisible or punishmentCardVisible or toxicityCardVisible
        or x1InviteCardVisible or matchCityCardVisible then
        return
    end

    local proximityMission, allMissions = GetBestMission()
    
    if not proximityMission then
        if #allMissions > 0 then
            forceVisibleByPlayer = not forceVisibleByPlayer
            RefreshHUD(true, true)
        end
        return
    end

    if minimizedByPlayer then
        minimizedByPlayer = false
        SetCardCollapsed(false)
        RefreshHUD(true, true)
    else
        minimizedByPlayer = true
        SetCardCollapsed(true)
        HideActiveMission()
    end
end, false)

RegisterNetEvent("hud:AffiliateWorldShortcutsVisibilityChanged", function(visible)
    affiliateWorldShortcutsVisible = visible == true
    RefreshHUD(true, true)
end)

AddEventHandler( 'dashboard:affiliateCommercialActiveChanged', function( active )

    gAffiliateCommercialActive = active == true
    RefreshHUD( true, true )
end )

CreateThread( function()

    Wait( 0 )

    if GetResourceState( 'dashboard' ) ~= 'started' then
        return
    end

    local ok, active = pcall( function()
        return exports.dashboard:IsAffiliateCommercialActive()
    end )

    if ok and active == true then
        gAffiliateCommercialActive = true
        RefreshHUD( true, true )
    end
end )

-- Evento local (do feedback/recruitment_punishment), não net: quem manda é o cliente.
AddEventHandler("hud:punishmentCard:priorityChanged", function(visible)
    punishmentCardVisible = visible == true
    RefreshHUD(true, true)
end)

AddEventHandler( 'hud:toxicity:priorityChanged', function( visible )
    toxicityCardVisible = visible == true
    RefreshHUD( true, true )
end )

-- Evento local do dashboard (client/x1_invite.lua).
AddEventHandler( 'hud:x1Invite:priorityChanged', function( visible )
    x1InviteCardVisible = visible == true
    RefreshHUD( true, true )
end )

AddEventHandler( 'hud:matchCity:priorityChanged', function( visible )
    matchCityCardVisible = visible == true
    RefreshHUD( true, true )
end )

exports('IsMatchCityMissionCardEligible', function()

    return (currentMission ~= nil or hintVisible) and not welcomeCityVisible
        and not x1InviteCardVisible and not punishmentCardVisible and not toxicityCardVisible
end)

RegisterCommand('-hud_mission_card_toggle', function() end, false)
RegisterKeyMapping('+hud_mission_card_toggle', _t("hud.keymap.mission_toggle"), 'keyboard', 'U')

RegisterCommand('missionOpenInHub', function()
    if IsMissionDisplayBlocked() then return end

    local missionConfig = currentMission and MISSION_HUD_TEXT[currentMission.id]

    if missionConfig and missionConfig.hideDetails == true then
        return
    end

    if GetResourceState('new_hub') ~= 'started' then
        return
    end

    TriggerEvent('new_hub.client:openDirectView')
end, false)

RegisterKeyMapping('missionOpenInHub', _t("hud.keymap.mission_open_hub"), 'keyboard', 'm')

RegisterCommand('testmissioncomplete', function()
    if not currentMission then
        -- sx.logger:debug('[Missions HUD] Nenhuma missão ativa para completar.')
        return
    end

    -- sx.logger:debug( ('[Missions HUD] Completando missão no server: %s'):format(currentMission.id) )
    TriggerServerEvent("hud:debug:completeMission", currentMission.id)
end, false)

RegisterNetEvent("missions:updatePlayerData", function(_playerData)
    Wait(500)
    RefreshHUD(false)
end)

RegisterNetEvent("missions:skill_levelup")
AddEventHandler("missions:skill_levelup", function(_skillId, level, skillName)
    local lvl = tonumber(level) or 1
    local name = skillName or _skillId or ""
    Wait(5500)
    if IsMissionDisplayBlocked() then return end

    SendNUIMessage({
        action = "levelUpNotify",
        data = {
            visible = true,
            level = string.format("%02d", lvl),
            subtitle = (_t("skill.level_up.subtitle")):format(name),
            rewards = {
                { icon = LEVEL_UP_BANNER_REWARD_ICON },
                { icon = LEVEL_UP_BANNER_REWARD_ICON },
            },
        },
    })
end)

-- bprotection lock/unlock: esconde mission HUD em first-login até 5s pós-"BOAS VINDAS".
RegisterNetEvent("missions:client:lockHud", function()
    hudUnlocked = false
    RefreshHUD(false)
end)

RegisterNetEvent("missions:client:unlockHud", function()
    hudUnlocked = true
    RefreshHUD(true)
end)

RegisterNetEvent("missions:welcomeCityNotify", function(data)
    if IsMissionDisplayBlocked() then return end

    welcomeCityVisible = data and data.visible ~= false
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'welcomeCityNotify',
        data = data
    })
end)

RegisterNUICallback('closeWelcomeCity', function(data, cb)
    welcomeCityVisible = false
    SetNuiFocus(false, false)
    CreateThread(function()
        Wait(50)
        minimizedByPlayer = false
        SetCardCollapsed(false)
        RefreshHUD(true, true)
    end)
    cb('ok')
end)

RegisterNetEvent("missions:welcomeCityNotify:close", function()
    -- sx.logger:info('missions:welcomeCityNotify:close')
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'welcomeCityNotify', data = { visible = false } })

    if not welcomeCityVisible then
        RefreshHUD(false)
        return
    end

    welcomeCityVisible = false

    CreateThread(function()
        Wait(50)
        minimizedByPlayer = false
        SetCardCollapsed(false)
        RefreshHUD(true, true)
    end)
end)

RegisterNetEvent("missions:client:missionCompleted", function(missionId, missionName, skillRewards)

    if IsMissionDisplayBlocked() then return end

    completionLockUntil = GetGameTimer() + COMPLETION_DELAY
    minimizedByPlayer = false
    SetCardCollapsed(false)

    local completedMission = currentMission
    if not completedMission or completedMission.id ~= missionId then
        completedMission = {
            id          = missionId,
            name        = missionName,
            description = missionName,
            groupIcon   = currentMission and currentMission.groupIcon or "",
        }
    end
    completedMission.completedTitle = _t("hud.label.mission_completed")
    completedMission.completedMissionName = missionName or completedMission.name

    if not matchCityCardVisible then
        ShowDocumentCard(completedMission, true)
    end
    local EarnedXP = 500

    if skillRewards then           
        for skillId, amount in pairs(skillRewards) do
            EarnedXP = EarnedXP + amount
        end
    end

    SendNUIMessage({
        action = 'missionNotify',
        data   = {
            visible  = true,
            subtitle = (_t("hud.label.mission_prefix")):format(missionName),
            title    = _t("hud.label.mission_completed_upper"),
            rewards  = {
                { icon = 'https://cdn.santagroup.gg/8254aea1-217b-4b6c-843c-3e5ef30c3c65-xp.png', label = 'XP'  },
                { icon = 'https://cdn.santagroup.gg/8254aea1-217b-4b6c-843c-3e5ef30c3c65-xp.png', label = '500' },
            },
        }
    })
    TriggerEvent('sounds:Private', 'https://cdn.santagroup.gg/c997a181-6856-47e1-8fc5-2767a1f4dbce-missioncomplete.m4a', 0.3)

    SendXpFeeds(skillRewards)

    CreateThread(function()
        Wait(COMPLETION_DELAY)

        SendNUIMessage({ action = 'missionNotify', data = { visible = false } })

        -- Auto-cycle: após completar, mostra a próxima missão sequencial mesmo
        -- sem proximidade. Sem isso, RefreshHUD cairia no ramo "sem missão" e
        -- exibiria o hint "press H", forçando o player a abrir manualmente.
        forceVisibleByPlayer = true
        currentMission       = nil
        completionLockUntil  = 0
        RefreshHUD(true)
    end)
end)

RegisterNetEvent("missions:client:groupCompleted", function(_groupId, groupName)
    if IsMissionDisplayBlocked() then return end

    completionLockUntil = GetGameTimer() + COMPLETION_DELAY

    SendNUIMessage({
        action = 'missionNotify',
        data   = {
            visible  = true,
            subtitle = (_t("hud.label.group_prefix")):format(groupName),
            title    = _t("hud.label.group_completed_upper"),
        }
    })

    CreateThread(function()
        Wait(COMPLETION_DELAY)
        SendNUIMessage({ action = 'missionNotify', data = { visible = false } })
        forceVisibleByPlayer = true
        completionLockUntil  = 0
        RefreshHUD(true)
    end)
end)

RegisterNetEvent("missions:client:retentionD1Completed", function(_missionId, _missionName, skillRewards, _count)

    SendXpFeeds(skillRewards)
    RefreshHUD(true)
end)

AddEventHandler('playerSpawned', function()

    print('playerSpawned', LocalPlayer.state['character-creator-state'])

    RefreshHUD(true)
end)

RegisterNetEvent("hud:Active", function(status)
    if status ~= true then
        return
    end

    CreateThread(function()
        Wait(100)
        RefreshHUD(false)
    end)
end)

CreateThread(function()
    Wait(5000)

    while true do
        Wait(REFRESH_INTERVAL)
        RefreshHUD(false)
    end
end)

CreateThread(function()
    Wait(6000)

    local wasNear = false

    while true do
        Wait(1000)

        if currentMission then
            local isNear = IsNearCurrentMission()

            if isNear ~= wasNear then
                TriggerEvent( "hud:missions:nearbyPriorityChanged", isNear )
            end

            if isNear and not wasNear and minimizedByPlayer and not IsAdminWithPersistentMissionCardPreference() then
                RefreshHUD(true, true)
            end

            wasNear = isNear
        else
            if wasNear then
                TriggerEvent( "hud:missions:nearbyPriorityChanged", false )
            end

            wasNear = false
        end
    end
end)
