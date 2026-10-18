---@class affiliateWorld.AimTrainingRunner
---@field ped integer
---@field laneIndex integer
---@field rollUntil integer
---@field nextRollAt integer
---@field removeAt integer
---@field lastPosition vector3
---@field lastMoveCheckAt integer

---@class affiliateWorld.AimTrainingTarget
---@field ped integer
---@field positionIndex integer
---@field respawnAt integer

---@class affiliateWorld.AimTrainingDamageNumber
---@field text string
---@field coords vector3
---@field createdAt integer
---@field isHeadshot boolean

---@class affiliateWorld.AimTrainingStats
---@field kills integer
---@field bodyHits integer
---@field streak integer
---@field bestStreak integer

-- Ossos de cabeca/pescoco retornados por GetPedLastDamageBone para validar headshot.
local AFFILIATE_AIM_HEADSHOT_BONES = {
    [31086] = true,
    [39317] = true,
}

local AFFILIATE_AIM_LOGIC_INTERVAL_MS = 50
local AFFILIATE_AIM_MODEL_TIMEOUT_MS = 5000
local AFFILIATE_AIM_DIFFICULTY_LOCK_MS = 800

-- Painel de estatisticas, em fracao de tela. A borda direita fica fixa; mexer em
-- AFFILIATE_AIM_HUD_WIDTH so estreita ou alarga a caixa, sem desalinhar o texto.
local AFFILIATE_AIM_HUD_RIGHT = 0.9725
local AFFILIATE_AIM_HUD_WIDTH = 0.130
local AFFILIATE_AIM_HUD_HEIGHT = 0.100
local AFFILIATE_AIM_HUD_PADDING = 0.012
local AFFILIATE_AIM_HUD_CENTER_X = AFFILIATE_AIM_HUD_RIGHT - AFFILIATE_AIM_HUD_WIDTH / 2
local AFFILIATE_AIM_HUD_CENTER_Y = 0.809
local AFFILIATE_AIM_HUD_TEXT_X = AFFILIATE_AIM_HUD_RIGHT - AFFILIATE_AIM_HUD_WIDTH + AFFILIATE_AIM_HUD_PADDING

-- Rotulo sobre o alvo de dificuldade. Somente o Z e em metros: o recuo e o espacamento
-- das linhas sao em fracao de tela, para as duas linhas manterem a mesma distancia
-- entre si de perto e de longe.
local AFFILIATE_AIM_LABEL_WORLD_OFFSET_Z = 0.55
local AFFILIATE_AIM_LABEL_SCREEN_OFFSET_Y = 0.020
local AFFILIATE_AIM_LABEL_LINE_HEIGHT = 0.030
local AFFILIATE_AIM_LABEL_TITLE_SCALE = 0.40
local AFFILIATE_AIM_LABEL_HINT_SCALE = 0.30

-- Numero de dano flutuante sobre o boneco atingido. Sobe RISE metros em LIFETIME_MS e
-- some no ultimo terco; o jitter horizontal evita empilhar numeros de tiros seguidos.
local AFFILIATE_AIM_DAMAGE_LIFETIME_MS = 900
local AFFILIATE_AIM_DAMAGE_RISE = 0.6
local AFFILIATE_AIM_DAMAGE_OFFSET_Z = 0.9
local AFFILIATE_AIM_DAMAGE_JITTER = 0.25
local AFFILIATE_AIM_DAMAGE_SCALE = 0.45
local AFFILIATE_AIM_DAMAGE_MAX = 24

---@type fun()?
local gAffiliateAimTrainingTickAbort = nil

-- Cada entrada de sessao invalida os carregamentos assincronos da anterior.
local gAffiliateAimTrainingGeneration = 0
local gAffiliateAimTrainingReady = false
local gAffiliateAimTrainingPedModel = GetHashKey(AFFILIATE_WORLD_CONFIG.AIM_TRAINING.NPC_MODEL)
local gAffiliateAimTrainingPropModel = GetHashKey(AFFILIATE_WORLD_CONFIG.AIM_TRAINING.DIFFICULTY_PROP.MODEL)

---@type table<integer, affiliateWorld.AimTrainingTarget>
local gAffiliateAimTrainingTargets = {}

---@type affiliateWorld.AimTrainingRunner[]
local gAffiliateAimTrainingRunners = {}

---@type table<integer, integer>
local gAffiliateAimTrainingLaneSpawnAt = {}

local gAffiliateAimTrainingDifficultyIndex = 1
local gAffiliateAimTrainingDifficultyProp = nil
local gAffiliateAimTrainingDifficultyLockedUntil = 0
local gAffiliateAimTrainingBlip = nil
local gAffiliateAimTrainingLogicAt = 0
local gAffiliateAimTrainingAmmoAt = 0

---@type affiliateWorld.AimTrainingStats
local gAffiliateAimTrainingStats = {
    kills = 0,
    bodyHits = 0,
    streak = 0,
    bestStreak = 0,
}

-- Textos ja traduzidos e ja formatados: a HUD e desenhada todo frame e nao deve
-- refazer lookup de traducao nem concatenacao a cada chamada.
---@type table<string, string>
local gAffiliateAimTrainingLabels = {}

---@type affiliateWorld.AimTrainingDamageNumber[]
local gAffiliateAimTrainingDamageNumbers = {}

---@type string[]
local gAffiliateAimTrainingHudLines = { "", "", "" }

---@type fun()
local RefreshAffiliateAimTrainingScoreboard

---@return affiliateWorld.AimTrainingDifficulty
local function GetAffiliateAimTrainingDifficulty()
    local difficulties = AFFILIATE_WORLD_CONFIG.AIM_TRAINING.DIFFICULTIES

    return difficulties[gAffiliateAimTrainingDifficultyIndex] or difficulties[1]
end

---@param model integer
---@return boolean
local function RequestAffiliateAimTrainingModel(model)

    if HasModelLoaded(model) then
        return true
    end

    local generation = gAffiliateAimTrainingGeneration
    local timeoutAt = GetGameTimer() + AFFILIATE_AIM_MODEL_TIMEOUT_MS

    RequestModel(model)

    while not HasModelLoaded(model) and GetGameTimer() < timeoutAt do

        if generation ~= gAffiliateAimTrainingGeneration then
            return false
        end

        Wait(50)
    end

    if not HasModelLoaded(model) then
        sx.logger:warn(('Affiliate aim training model could not be loaded model=%d'):format(model))

        return false
    end

    return true
end

---@param x number
---@param y number
---@param z number
---@return number
local function ResolveAffiliateAimTrainingGroundZ(x, y, z)
    local foundGround, groundZ = GetGroundZFor_3dCoord(x, y, z + 30.0, false)

    return foundGround and groundZ + 0.05 or z
end

---@param ped integer
local function ConfigureAffiliateAimTrainingPed(ped)
    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskSetBlockingOfNonTemporaryEvents(ped, true)

    -- Vida alta mantem o boneco de pe em tiro de corpo; o abate e decidido pelo osso atingido.
    SetPedMaxHealth(ped, AFFILIATE_WORLD_CONFIG.AIM_TRAINING.NPC_HEALTH)
    SetEntityHealth(ped, AFFILIATE_WORLD_CONFIG.AIM_TRAINING.NPC_HEALTH)
    SetPedArmour(ped, 0)
    SetEntityInvincible(ped, false)
    SetPedSuffersCriticalHits(ped, true)

    SetPedCanRagdoll(ped, false)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    SetPedRagdollOnCollision(ped, false)
    SetPedFleeAttributes(ped, 0, false)
    SetPedCombatAttributes(ped, 17, true)
    SetPedConfigFlag(ped, 2, true)
    SetPedConfigFlag(ped, 188, true)
    SetPedConfigFlag(ped, 281, true)
    DisablePedPainAudio(ped, true)
    SetEntityCollision(ped, true, true)
end

---@param position vector4
---@return integer?
local function CreateAffiliateAimTrainingPed(position)

    if not HasModelLoaded(gAffiliateAimTrainingPedModel) then
        return nil
    end

    local groundZ = ResolveAffiliateAimTrainingGroundZ(position.x, position.y, position.z)

    -- isNetwork = false mantem o boneco local: cada jogador ve e abate somente os proprios NPCs.
    local ped = CreatePed(4, gAffiliateAimTrainingPedModel, position.x, position.y, groundZ, position.w, false, false)

    if ped == 0 or not DoesEntityExist(ped) then
        sx.logger:warn(('Affiliate aim training ped creation failed x=%.1f y=%.1f'):format(position.x, position.y))

        return nil
    end

    ConfigureAffiliateAimTrainingPed(ped)

    return ped
end

---@param ped? integer
local function DeleteAffiliateAimTrainingPed(ped)

    if not ped or ped == 0 or not DoesEntityExist(ped) then
        return
    end

    SetEntityAsMissionEntity(ped, true, true)
    DeleteEntity(ped)
end

---@param coords vector3
local function PlayAffiliateAimTrainingFeedback(coords)
    if not HasNamedPtfxAssetLoaded("core") then
        return
    end

    UseParticleFxAssetNextCall("core")
    StartParticleFxNonLoopedAtCoord("bul_flesh", coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.6, false, false, false)
end

---@param isHeadshot boolean
local function RegisterAffiliateAimTrainingHit(isHeadshot)

    if not isHeadshot then
        gAffiliateAimTrainingStats.bodyHits = gAffiliateAimTrainingStats.bodyHits + 1
        gAffiliateAimTrainingStats.streak = 0
        RefreshAffiliateAimTrainingScoreboard()

        return
    end

    gAffiliateAimTrainingStats.kills = gAffiliateAimTrainingStats.kills + 1
    gAffiliateAimTrainingStats.streak = gAffiliateAimTrainingStats.streak + 1

    if gAffiliateAimTrainingStats.streak > gAffiliateAimTrainingStats.bestStreak then
        gAffiliateAimTrainingStats.bestStreak = gAffiliateAimTrainingStats.streak
    end

    RefreshAffiliateAimTrainingScoreboard()
end

---@param ped integer
---@return boolean damaged
---@return boolean isHeadshot
---@return integer damage
local function ConsumeAffiliateAimTrainingDamage(ped)

    if not HasEntityBeenDamagedByAnyPed(ped) then
        return false, false, 0
    end

    local _, bone = GetPedLastDamageBone(ped)

    ClearEntityLastDamageEntity(ped)

    -- Todo acerto de corpo cura o boneco de volta para NPC_HEALTH, entao a diferenca
    -- e o dano desde a ultima leitura.
    local damage = math.max(AFFILIATE_WORLD_CONFIG.AIM_TRAINING.NPC_HEALTH - GetEntityHealth(ped), 0)

    return true, AFFILIATE_AIM_HEADSHOT_BONES[bone] == true, damage
end

---@param ped integer
---@param damage integer
---@param isHeadshot boolean
local function AddAffiliateAimTrainingDamageNumber(ped, damage, isHeadshot)

    if damage <= 0 then
        return
    end

    if #gAffiliateAimTrainingDamageNumbers >= AFFILIATE_AIM_DAMAGE_MAX then
        table.remove(gAffiliateAimTrainingDamageNumbers, 1)
    end

    local coords = GetEntityCoords(ped)
    local jitterX = (math.random() * 2 - 1) * AFFILIATE_AIM_DAMAGE_JITTER
    local jitterY = (math.random() * 2 - 1) * AFFILIATE_AIM_DAMAGE_JITTER

    gAffiliateAimTrainingDamageNumbers[#gAffiliateAimTrainingDamageNumbers + 1] = {
        text = tostring(damage),
        coords = vector3(coords.x + jitterX, coords.y + jitterY, coords.z + AFFILIATE_AIM_DAMAGE_OFFSET_Z),
        createdAt = GetGameTimer(),
        isHeadshot = isHeadshot,
    }
end

-- ============================================================
--  Alvos parados
-- ============================================================

--- Escolhe um ponto livre do estande: nem o ponto atual do slot, nem o de outro alvo vivo.
---@param slot integer
---@return integer
local function PickAffiliateAimTrainingTargetPosition(slot)
    local positions = AFFILIATE_WORLD_CONFIG.TARGET_RANGE_POSITIONS
    local occupied = {}

    for _, target in pairs(gAffiliateAimTrainingTargets) do
        occupied[target.positionIndex] = true
    end

    local available = {}

    for index = 1, #positions do

        if not occupied[index] then
            available[#available + 1] = index
        end
    end

    if #available == 0 then
        local current = gAffiliateAimTrainingTargets[slot]

        return current and current.positionIndex or 1
    end

    return available[math.random(#available)]
end

--- Reposiciona o alvo do slot. A entrada da tabela e criada uma vez e so mutada depois,
--- porque o tick percorre `gAffiliateAimTrainingTargets` com `pairs`.
---@param slot integer
local function SpawnAffiliateAimTrainingTarget(slot)
    local target = gAffiliateAimTrainingTargets[slot]

    if not target then
        target = { ped = 0, positionIndex = 0, respawnAt = 0 }
        gAffiliateAimTrainingTargets[slot] = target
    end

    target.positionIndex = PickAffiliateAimTrainingTargetPosition(slot)

    local ped = CreateAffiliateAimTrainingPed(AFFILIATE_WORLD_CONFIG.TARGET_RANGE_POSITIONS[target.positionIndex])

    if not ped then
        target.ped = 0
        target.respawnAt = GetGameTimer() + AFFILIATE_WORLD_CONFIG.AIM_TRAINING.RESPAWN_DELAY_MS

        return
    end

    FreezeEntityPosition(ped, true)

    target.ped = ped
    target.respawnAt = 0
end

---@param now integer
---@param slot integer
---@param target affiliateWorld.AimTrainingTarget
local function UpdateAffiliateAimTrainingTarget(now, slot, target)

    if target.respawnAt == 0 then
        local alive = target.ped ~= 0 and DoesEntityExist(target.ped) and not IsEntityDead(target.ped)

        if not alive then
            target.respawnAt = now + AFFILIATE_WORLD_CONFIG.AIM_TRAINING.RESPAWN_DELAY_MS
        else
            local damaged, isHeadshot, damage = ConsumeAffiliateAimTrainingDamage(target.ped)

            if damaged then
                RegisterAffiliateAimTrainingHit(isHeadshot)
                AddAffiliateAimTrainingDamageNumber(target.ped, damage, isHeadshot)
                PlayAffiliateAimTrainingFeedback(GetEntityCoords(target.ped))

                if isHeadshot then
                    FreezeEntityPosition(target.ped, false)
                    SetPedCanRagdoll(target.ped, true)
                    SetEntityHealth(target.ped, 0)
                    target.respawnAt = now + AFFILIATE_WORLD_CONFIG.AIM_TRAINING.RESPAWN_DELAY_MS
                else
                    SetEntityHealth(target.ped, AFFILIATE_WORLD_CONFIG.AIM_TRAINING.NPC_HEALTH)
                end
            end
        end
    end

    if target.respawnAt ~= 0 and now >= target.respawnAt then
        DeleteAffiliateAimTrainingPed(target.ped)
        target.ped = 0
        SpawnAffiliateAimTrainingTarget(slot)
    end
end

---@param now integer
local function UpdateAffiliateAimTrainingTargets(now)

    for slot, target in pairs(gAffiliateAimTrainingTargets) do
        UpdateAffiliateAimTrainingTarget(now, slot, target)
    end
end

-- ============================================================
--  Alvos em movimento
-- ============================================================

---@param runner affiliateWorld.AimTrainingRunner
---@param difficulty affiliateWorld.AimTrainingDifficulty
local function IssueAffiliateAimTrainingRunTask(runner, difficulty)
    local lane = AFFILIATE_WORLD_CONFIG.AIM_TRAINING.LANES[runner.laneIndex]

    ClearPedTasks(runner.ped)
    SetEntityHeading(runner.ped, lane.START.w)
    ForcePedMotionState(runner.ped, GetHashKey("MotionState_Run"), false, 0, false)
    TaskGoStraightToCoord(runner.ped, lane.FINISH.x, lane.FINISH.y, lane.FINISH.z, difficulty.TASK_SPEED, -1, lane.START.w, 0.5)
    SetPedDesiredMoveBlendRatio(runner.ped, 3.0)
    SetPedMoveRateOverride(runner.ped, difficulty.MOVE_RATE)

    runner.lastPosition = GetEntityCoords(runner.ped)
    runner.lastMoveCheckAt = GetGameTimer()
end

---@param laneIndex integer
---@return integer
local function CountAffiliateAimTrainingRunners(laneIndex)
    local total = 0

    for _, runner in ipairs(gAffiliateAimTrainingRunners) do

        -- Boneco ja abatido nao ocupa vaga: a pista repoe enquanto o corpo cai.
        if runner.laneIndex == laneIndex and runner.removeAt == 0 and DoesEntityExist(runner.ped) then
            total = total + 1
        end
    end

    return total
end

---@param laneIndex integer
local function SpawnAffiliateAimTrainingRunner(laneIndex)
    local lane = AFFILIATE_WORLD_CONFIG.AIM_TRAINING.LANES[laneIndex]
    local ped = CreateAffiliateAimTrainingPed(lane.START)

    if not ped then
        return
    end

    local difficulty = GetAffiliateAimTrainingDifficulty()

    ---@type affiliateWorld.AimTrainingRunner
    local runner = {
        ped = ped,
        laneIndex = laneIndex,
        rollUntil = 0,
        nextRollAt = 0,
        removeAt = 0,
        lastPosition = GetEntityCoords(ped),
        lastMoveCheckAt = GetGameTimer(),
    }

    IssueAffiliateAimTrainingRunTask(runner, difficulty)

    -- Empurrao unico no spawn para o boneco entrar na pista ja na velocidade da dificuldade.
    local forward = GetEntityForwardVector(ped)
    SetEntityVelocity(ped, forward.x * difficulty.SPAWN_VELOCITY, forward.y * difficulty.SPAWN_VELOCITY, 0.0)

    gAffiliateAimTrainingRunners[#gAffiliateAimTrainingRunners + 1] = runner
end

---@param runner affiliateWorld.AimTrainingRunner
---@param now integer
---@param difficulty affiliateWorld.AimTrainingDifficulty
local function StartAffiliateAimTrainingRoll(runner, now, difficulty)
    local dict = AFFILIATE_WORLD_CONFIG.AIM_TRAINING.ROLL_ANIM_DICT

    if not HasAnimDictLoaded(dict) then
        return
    end

    local anims = AFFILIATE_WORLD_CONFIG.AIM_TRAINING.ROLL_ANIMS

    runner.rollUntil = now + difficulty.ROLL_DURATION_MS
    runner.nextRollAt = runner.rollUntil + difficulty.ROLL_COOLDOWN_MS

    TaskPlayAnim(runner.ped, dict, anims[math.random(#anims)], 8.0, -4.0, difficulty.ROLL_DURATION_MS, 0, 0, false, false, false)
end

---@param runner affiliateWorld.AimTrainingRunner
---@param now integer
---@return boolean
local function IsAffiliateAimTrainingRunnerStuck(runner, now)

    if now - runner.lastMoveCheckAt < AFFILIATE_WORLD_CONFIG.AIM_TRAINING.STUCK_INTERVAL_MS then
        return false
    end

    local position = GetEntityCoords(runner.ped)
    local moved = #(position - runner.lastPosition)

    runner.lastPosition = position
    runner.lastMoveCheckAt = now

    return moved < AFFILIATE_WORLD_CONFIG.AIM_TRAINING.STUCK_DISTANCE
end

---@param index integer
local function RemoveAffiliateAimTrainingRunner(index)
    DeleteAffiliateAimTrainingPed(gAffiliateAimTrainingRunners[index].ped)
    table.remove(gAffiliateAimTrainingRunners, index)
end

---@return integer?
local function GetAffiliateAimTrainingAimedEntity()

    if not IsPlayerFreeAiming(PlayerId()) then
        return nil
    end

    local aiming, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())

    return aiming and entity or nil
end

---@param now integer
---@param atRange boolean
local function UpdateAffiliateAimTrainingRunners(now, atRange)

    if not atRange then

        for index = #gAffiliateAimTrainingRunners, 1, -1 do
            RemoveAffiliateAimTrainingRunner(index)
        end

        return
    end

    local difficulty = GetAffiliateAimTrainingDifficulty()
    local aimedEntity = GetAffiliateAimTrainingAimedEntity()
    local deleteDistance = AFFILIATE_WORLD_CONFIG.AIM_TRAINING.LANE_DELETE_DISTANCE

    for index = #gAffiliateAimTrainingRunners, 1, -1 do
        local runner = gAffiliateAimTrainingRunners[index]

        -- Abatido: deixa o corpo cair antes de limpar a entidade.
        if runner.removeAt ~= 0 then

            if now >= runner.removeAt or not DoesEntityExist(runner.ped) then
                RemoveAffiliateAimTrainingRunner(index)
            end

            goto continue
        end

        if not DoesEntityExist(runner.ped) or IsEntityDead(runner.ped) then
            RemoveAffiliateAimTrainingRunner(index)
            goto continue
        end

        local damaged, isHeadshot, damage = ConsumeAffiliateAimTrainingDamage(runner.ped)

        if damaged then
            RegisterAffiliateAimTrainingHit(isHeadshot)
            AddAffiliateAimTrainingDamageNumber(runner.ped, damage, isHeadshot)
            PlayAffiliateAimTrainingFeedback(GetEntityCoords(runner.ped))

            if isHeadshot then
                SetPedCanRagdoll(runner.ped, true)
                SetEntityHealth(runner.ped, 0)
                runner.removeAt = now + AFFILIATE_WORLD_CONFIG.AIM_TRAINING.RESPAWN_DELAY_MS
                goto continue
            end

            SetEntityHealth(runner.ped, AFFILIATE_WORLD_CONFIG.AIM_TRAINING.NPC_HEALTH)
        end

        local lane = AFFILIATE_WORLD_CONFIG.AIM_TRAINING.LANES[runner.laneIndex]
        local finish = vector3(lane.FINISH.x, lane.FINISH.y, lane.FINISH.z)

        if #(GetEntityCoords(runner.ped) - finish) < deleteDistance then
            RemoveAffiliateAimTrainingRunner(index)
            goto continue
        end

        if runner.rollUntil ~= 0 then

            if now >= runner.rollUntil then
                runner.rollUntil = 0
                IssueAffiliateAimTrainingRunTask(runner, difficulty)
            end

            goto continue
        end

        -- Esquiva so quando o jogador realmente mira o boneco, como no treino legado.
        if aimedEntity == runner.ped and now >= runner.nextRollAt then
            StartAffiliateAimTrainingRoll(runner, now, difficulty)
            goto continue
        end

        if IsAffiliateAimTrainingRunnerStuck(runner, now) then
            IssueAffiliateAimTrainingRunTask(runner, difficulty)
            goto continue
        end

        SetPedDesiredMoveBlendRatio(runner.ped, 3.0)
        SetPedMoveRateOverride(runner.ped, difficulty.MOVE_RATE)

        ::continue::
    end

    for laneIndex = 1, #AFFILIATE_WORLD_CONFIG.AIM_TRAINING.LANES do

        if now >= (gAffiliateAimTrainingLaneSpawnAt[laneIndex] or 0)
            and CountAffiliateAimTrainingRunners(laneIndex) < difficulty.MAX_PER_LANE then
            gAffiliateAimTrainingLaneSpawnAt[laneIndex] = now + difficulty.SPAWN_INTERVAL_MS
            SpawnAffiliateAimTrainingRunner(laneIndex)
        end
    end
end

-- ============================================================
--  Alvo de dificuldade e HUD
-- ============================================================

local function CreateAffiliateAimTrainingDifficultyProp()

    if gAffiliateAimTrainingDifficultyProp and DoesEntityExist(gAffiliateAimTrainingDifficultyProp) then
        return
    end

    if not HasModelLoaded(gAffiliateAimTrainingPropModel) then
        gAffiliateAimTrainingDifficultyProp = nil

        return
    end

    local position = AFFILIATE_WORLD_CONFIG.AIM_TRAINING.DIFFICULTY_PROP.POSITION
    local groundZ = ResolveAffiliateAimTrainingGroundZ(position.x, position.y, position.z)
    local prop = CreateObject(gAffiliateAimTrainingPropModel, position.x, position.y, groundZ, false, true, false)

    if prop == 0 or not DoesEntityExist(prop) then
        sx.logger:warn("Affiliate aim training difficulty prop creation failed")
        gAffiliateAimTrainingDifficultyProp = nil

        return
    end

    SetEntityHeading(prop, position.w)
    PlaceObjectOnGroundProperly(prop)
    FreezeEntityPosition(prop, true)
    SetEntityAsMissionEntity(prop, true, true)

    gAffiliateAimTrainingDifficultyProp = prop
end

---@param now integer
local function UpdateAffiliateAimTrainingDifficultyProp(now)

    if not gAffiliateAimTrainingDifficultyProp or not DoesEntityExist(gAffiliateAimTrainingDifficultyProp) then
        CreateAffiliateAimTrainingDifficultyProp()

        return
    end

    if not HasEntityBeenDamagedByAnyPed(gAffiliateAimTrainingDifficultyProp) then
        return
    end

    ClearEntityLastDamageEntity(gAffiliateAimTrainingDifficultyProp)

    if now < gAffiliateAimTrainingDifficultyLockedUntil then
        return
    end

    gAffiliateAimTrainingDifficultyLockedUntil = now + AFFILIATE_AIM_DIFFICULTY_LOCK_MS
    gAffiliateAimTrainingDifficultyIndex = gAffiliateAimTrainingDifficultyIndex % #AFFILIATE_WORLD_CONFIG.AIM_TRAINING.DIFFICULTIES + 1

    local difficulty = GetAffiliateAimTrainingDifficulty()

    -- Bonecos ja na pista recebem a tarefa de novo para assumir a velocidade nova.
    for _, runner in ipairs(gAffiliateAimTrainingRunners) do

        if DoesEntityExist(runner.ped) and runner.removeAt == 0 and runner.rollUntil == 0 then
            IssueAffiliateAimTrainingRunTask(runner, difficulty)
        end
    end

    RefreshAffiliateAimTrainingScoreboard()
    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

---@param text string
---@param x number
---@param y number
---@param scale number
---@param centred boolean
local function DrawAffiliateAimTrainingText(text, x, y, scale, centred)
    SetTextFont(4)
    SetTextScale(scale, scale)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 225)
    SetTextDropShadow(1, 0, 0, 0, 255)
    SetTextOutline()
    SetTextCentre(centred)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

local function CacheAffiliateAimTrainingLabels()
    gAffiliateAimTrainingLabels = {
        difficulty = _t("affiliate_world_aim_difficulty_label"),
        hint = _t("affiliate_world_aim_difficulty_hint"),
        title = _t("affiliate_world_aim_hud_title"),
        kills = _t("affiliate_world_aim_hud_kills"),
        streak = _t("affiliate_world_aim_hud_streak"),
        accuracy = _t("affiliate_world_aim_hud_accuracy"),
        bestStreak = _t("affiliate_world_aim_hud_best_streak"),
    }

    for _, difficulty in ipairs(AFFILIATE_WORLD_CONFIG.AIM_TRAINING.DIFFICULTIES) do
        gAffiliateAimTrainingLabels[difficulty.LABEL_KEY] = _t(difficulty.LABEL_KEY)
    end
end

function RefreshAffiliateAimTrainingScoreboard()
    local shots = gAffiliateAimTrainingStats.kills + gAffiliateAimTrainingStats.bodyHits
    local accuracy = shots > 0 and math.floor(gAffiliateAimTrainingStats.kills / shots * 100) or 0

    gAffiliateAimTrainingHudLines[1] = ('%s: %s'):format(
        gAffiliateAimTrainingLabels.difficulty,
        gAffiliateAimTrainingLabels[GetAffiliateAimTrainingDifficulty().LABEL_KEY] or ""
    )
    gAffiliateAimTrainingHudLines[2] = ('%s: %d   %s: %d'):format(
        gAffiliateAimTrainingLabels.kills,
        gAffiliateAimTrainingStats.kills,
        gAffiliateAimTrainingLabels.streak,
        gAffiliateAimTrainingStats.streak
    )
    gAffiliateAimTrainingHudLines[3] = ('%s: %d%%   %s: %d'):format(
        gAffiliateAimTrainingLabels.accuracy,
        accuracy,
        gAffiliateAimTrainingLabels.bestStreak,
        gAffiliateAimTrainingStats.bestStreak
    )
end

local function DrawAffiliateAimTrainingDifficultyLabel()

    if not gAffiliateAimTrainingDifficultyProp or not DoesEntityExist(gAffiliateAimTrainingDifficultyProp) then
        return
    end

    local coords = GetEntityCoords(gAffiliateAimTrainingDifficultyProp)
    local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(
        coords.x,
        coords.y,
        coords.z + AFFILIATE_AIM_LABEL_WORLD_OFFSET_Z
    )

    if not onScreen then
        return
    end

    -- Uma projecao so, com a segunda linha deslocada em tela. Projetando dois pontos de
    -- mundo o espacamento encolhe junto com a distancia e as linhas se sobrepoem.
    local titleY = screenY - AFFILIATE_AIM_LABEL_SCREEN_OFFSET_Y

    DrawAffiliateAimTrainingText(gAffiliateAimTrainingHudLines[1], screenX, titleY, AFFILIATE_AIM_LABEL_TITLE_SCALE, true)
    DrawAffiliateAimTrainingText(
        gAffiliateAimTrainingLabels.hint,
        screenX,
        titleY + AFFILIATE_AIM_LABEL_LINE_HEIGHT,
        AFFILIATE_AIM_LABEL_HINT_SCALE,
        true
    )
end

local function DrawAffiliateAimTrainingScoreboard()
    DrawRect(AFFILIATE_AIM_HUD_CENTER_X, AFFILIATE_AIM_HUD_CENTER_Y, AFFILIATE_AIM_HUD_WIDTH, AFFILIATE_AIM_HUD_HEIGHT, 0, 0, 0, 140)
    DrawAffiliateAimTrainingText(gAffiliateAimTrainingLabels.title, AFFILIATE_AIM_HUD_TEXT_X, 0.769, 0.38, false)
    DrawAffiliateAimTrainingText(gAffiliateAimTrainingHudLines[2], AFFILIATE_AIM_HUD_TEXT_X, 0.797, 0.30, false)
    DrawAffiliateAimTrainingText(gAffiliateAimTrainingHudLines[3], AFFILIATE_AIM_HUD_TEXT_X, 0.825, 0.30, false)
end

local function DrawAffiliateAimTrainingDamageNumbers()
    local now = GetGameTimer()

    for index = #gAffiliateAimTrainingDamageNumbers, 1, -1 do
        local entry = gAffiliateAimTrainingDamageNumbers[index]
        local progress = (now - entry.createdAt) / AFFILIATE_AIM_DAMAGE_LIFETIME_MS

        if progress >= 1.0 then
            table.remove(gAffiliateAimTrainingDamageNumbers, index)
        else
            local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(
                entry.coords.x,
                entry.coords.y,
                entry.coords.z + AFFILIATE_AIM_DAMAGE_RISE * progress
            )

            if onScreen then
                local alpha = progress < 0.66 and 255 or math.floor(255 * (1.0 - progress) / 0.34)
                local scale = entry.isHeadshot and AFFILIATE_AIM_DAMAGE_SCALE * 1.25 or AFFILIATE_AIM_DAMAGE_SCALE

                SetTextFont(4)
                SetTextScale(scale, scale)
                SetTextProportional(1)

                if entry.isHeadshot then
                    SetTextColour(255, 214, 0, alpha)
                else
                    SetTextColour(255, 255, 255, alpha)
                end

                SetTextDropShadow(1, 0, 0, 0, alpha)
                SetTextOutline()
                SetTextCentre(true)
                SetTextEntry("STRING")
                AddTextComponentString(entry.text)
                DrawText(screenX, screenY)
            end
        end
    end
end

local function DrawAffiliateAimTrainingHud()
    DrawAffiliateAimTrainingDamageNumbers()
    DrawAffiliateAimTrainingDifficultyLabel()
    DrawAffiliateAimTrainingScoreboard()
end

-- ============================================================
--  Ciclo de vida
-- ============================================================

---@param localPed integer
---@return boolean
local function IsAffiliateAimTrainingPlayerAtRange(localPed)
    local distance = #(GetEntityCoords(localPed) - AFFILIATE_WORLD_CONFIG.AIM_TRAINING.RANGE_CENTER)

    return distance <= AFFILIATE_WORLD_CONFIG.AIM_TRAINING.RANGE_RADIUS
end

local function TickAffiliateAimTraining()

    if not gAffiliateAimTrainingReady then
        return
    end

    local localPed = PlayerPedId()

    if not DoesEntityExist(localPed) then
        return
    end

    local atRange = IsAffiliateAimTrainingPlayerAtRange(localPed)

    if atRange then
        DrawAffiliateAimTrainingHud()
    end

    local now = GetGameTimer()

    if now < gAffiliateAimTrainingLogicAt then
        return
    end

    gAffiliateAimTrainingLogicAt = now + AFFILIATE_AIM_LOGIC_INTERVAL_MS

    -- Longe do estande nada precisa correr: os bonecos das pistas sao removidos e
    -- o catalogo/compra do Mundo Afiliado nao paga o custo do treino.
    UpdateAffiliateAimTrainingRunners(now, atRange)

    if not atRange then
        return
    end

    UpdateAffiliateAimTrainingTargets(now)
    UpdateAffiliateAimTrainingDifficultyProp(now)

    if AFFILIATE_WORLD_CONFIG.AIM_TRAINING.INFINITE_AMMO and now >= gAffiliateAimTrainingAmmoAt then
        gAffiliateAimTrainingAmmoAt = now + 500
        SetPedInfiniteAmmoClip(localPed, true)
    end
end

local function CreateAffiliateAimTrainingBlip()

    if gAffiliateAimTrainingBlip then
        return
    end

    local blipConfig = AFFILIATE_WORLD_CONFIG.AIM_TRAINING.BLIP
    local position = AFFILIATE_WORLD_CONFIG.AIM_TRAINING.RANGE_CENTER

    gAffiliateAimTrainingBlip = AddBlipForCoord(position.x, position.y, position.z)

    SetBlipSprite(gAffiliateAimTrainingBlip, blipConfig.SPRITE)
    SetBlipColour(gAffiliateAimTrainingBlip, blipConfig.COLOR)
    SetBlipScale(gAffiliateAimTrainingBlip, blipConfig.SCALE)
    SetBlipAsShortRange(gAffiliateAimTrainingBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(_t("affiliate_world_aim_blip"))
    EndTextCommandSetBlipName(gAffiliateAimTrainingBlip)
end

local function BuildAffiliateAimTrainingRange()
    local generation = gAffiliateAimTrainingGeneration

    CreateThread(function()

        if not RequestAffiliateAimTrainingModel(gAffiliateAimTrainingPedModel) then
            return
        end

        RequestAffiliateAimTrainingModel(gAffiliateAimTrainingPropModel)
        RequestAnimDict(AFFILIATE_WORLD_CONFIG.AIM_TRAINING.ROLL_ANIM_DICT)
        RequestNamedPtfxAsset("core")

        if generation ~= gAffiliateAimTrainingGeneration or not gAffiliateAimTrainingTickAbort then
            return
        end

        CacheAffiliateAimTrainingLabels()
        RefreshAffiliateAimTrainingScoreboard()

        for slot = 1, AFFILIATE_WORLD_CONFIG.AIM_TRAINING.STATIC_TARGET_COUNT do
            SpawnAffiliateAimTrainingTarget(slot)
        end

        CreateAffiliateAimTrainingDifficultyProp()
        CreateAffiliateAimTrainingBlip()

        gAffiliateAimTrainingReady = true
    end)
end

local function StopAffiliateAimTraining()
    gAffiliateAimTrainingGeneration = gAffiliateAimTrainingGeneration + 1
    gAffiliateAimTrainingReady = false

    if gAffiliateAimTrainingTickAbort then
        gAffiliateAimTrainingTickAbort()
        gAffiliateAimTrainingTickAbort = nil
    end

    for _, target in pairs(gAffiliateAimTrainingTargets) do
        DeleteAffiliateAimTrainingPed(target.ped)
    end

    for _, runner in ipairs(gAffiliateAimTrainingRunners) do
        DeleteAffiliateAimTrainingPed(runner.ped)
    end

    if gAffiliateAimTrainingDifficultyProp and DoesEntityExist(gAffiliateAimTrainingDifficultyProp) then
        DeleteEntity(gAffiliateAimTrainingDifficultyProp)
    end

    if gAffiliateAimTrainingBlip then
        RemoveBlip(gAffiliateAimTrainingBlip)
        gAffiliateAimTrainingBlip = nil
    end

    local localPed = PlayerPedId()

    if AFFILIATE_WORLD_CONFIG.AIM_TRAINING.INFINITE_AMMO and DoesEntityExist(localPed) then
        SetPedInfiniteAmmoClip(localPed, false)
    end

    gAffiliateAimTrainingTargets = {}
    gAffiliateAimTrainingRunners = {}
    gAffiliateAimTrainingLaneSpawnAt = {}
    gAffiliateAimTrainingDifficultyProp = nil
    gAffiliateAimTrainingDifficultyIndex = 1
    gAffiliateAimTrainingDifficultyLockedUntil = 0
    gAffiliateAimTrainingLogicAt = 0
    gAffiliateAimTrainingAmmoAt = 0
    gAffiliateAimTrainingStats = { kills = 0, bodyHits = 0, streak = 0, bestStreak = 0 }
    gAffiliateAimTrainingHudLines = { "", "", "" }
    gAffiliateAimTrainingDamageNumbers = {}

    SetModelAsNoLongerNeeded(gAffiliateAimTrainingPedModel)
    SetModelAsNoLongerNeeded(gAffiliateAimTrainingPropModel)
    RemoveAnimDict(AFFILIATE_WORLD_CONFIG.AIM_TRAINING.ROLL_ANIM_DICT)
end

--- Liga o estande de tiro do Mundo Afiliado. Vale para a sessao individual e a publica:
--- os NPCs sao criados somente no client, entao cada jogador tem os proprios alvos e abates.
---@param active boolean
function UpdateAffiliateWorldAimTraining(active)

    if not active or not AFFILIATE_WORLD_CONFIG.AIM_TRAINING.ENABLED then
        StopAffiliateAimTraining()

        return
    end

    if gAffiliateAimTrainingTickAbort then
        return
    end

    gAffiliateAimTrainingGeneration = gAffiliateAimTrainingGeneration + 1
    gAffiliateAimTrainingTickAbort = sx.script.setTick(TickAffiliateAimTraining)

    BuildAffiliateAimTrainingRange()
end

AddEventHandler("onResourceStop", function(resourceName)

    if resourceName == GetCurrentResourceName() then
        StopAffiliateAimTraining()
    end
end)
