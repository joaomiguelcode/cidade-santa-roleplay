local DEFAULT_NPC_IMAGE = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painel/emprego/velho.png"
local DEFAULT_NPC_NAME = _t("tutorial.npc_name")

gStateMicTutorialStarted = false
gMicSetupStarted = false
gCanShowModalVip = false
gAnyTutorialStarted = false

function SetCanShowModalVip(value)
    gCanShowModalVip = value
end

function ResetCanShowModalVip()
    gCanShowModalVip = true
end

function SetAnyTutorialStarted(value)
    gAnyTutorialStarted = value
end

function ResetAnyTutorialStarted()
    gAnyTutorialStarted = false
end

function GetCanShowModalVip()
    return gCanShowModalVip
end

-- function CanShowDetailedHubTutorial()
--     if cityName ~= 'Maresia' then
--         return false
--     end
--     return exports.tutorial:CanStartUiTutorial('tutorial.ui.hub')
-- end

function FinishDetailedHubTutorial()
    exports.tutorial:SendFinishedUiTutorial('tutorial.ui.hub')
end

---@class HubTutorialStep
---@field target? string
---@field title string
---@field content? string
---@field npcDialogue? string
---@field placement? "top" | "bottom" | "left" | "right" | "auto"

local specialkeyCodes = {
    ["b_100"] = "LMB", -- Left Mouse Button
    ["b_101"] = "RMB", -- Right Mouse Button
    ["b_102"] = "MMB", -- Middle Mouse Button
    ["b_103"] = "Mouse Button 1",
    ["b_104"] = "Mouse Button 2",
    ["b_105"] = "Mouse Button 3",
    ["b_106"] = "Mouse Button 4",
    ["b_107"] = "Mouse Button 5",
    ["b_108"] = "Mouse Button 6",
    ["b_109"] = "Mouse Button 7",
    ["b_110"] = "Mouse Button 8",
    ["b_115"] = "Mouse Wheel Up",
    ["b_116"] = "Mouse Wheel Down",
    ["b_130"] = "Num -",
    ["b_131"] = "Num +",
    ["b_134"] = "Num *",
    ["b_135"] = "Num Enter",
    ["b_137"] = "Num 1",
    ["b_138"] = "Num 2",
    ["b_139"] = "Num 3",
    ["b_140"] = "Num 4",
    ["b_141"] = "Num 5",
    ["b_142"] = "Num 6",
    ["b_143"] = "Num 7",
    ["b_144"] = "Num 8",
    ["b_145"] = "Num 9",
    ["b_170"] = "F1",
    ["b_171"] = "F2",
    ["b_172"] = "F3",
    ["b_173"] = "F4",
    ["b_174"] = "F5",
    ["b_175"] = "F6",
    ["b_176"] = "F7",
    ["b_177"] = "F8",
    ["b_178"] = "F9",
    ["b_179"] = "F10",
    ["b_180"] = "F11",
    ["b_181"] = "F12",
    ["b_182"] = "F13",
    ["b_183"] = "F14",
    ["b_184"] = "F15",
    ["b_185"] = "F16",
    ["b_186"] = "F17",
    ["b_187"] = "F18",
    ["b_188"] = "F19",
    ["b_189"] = "F20",
    ["b_190"] = "F21",
    ["b_191"] = "F22",
    ["b_192"] = "F23",
    ["b_193"] = "F24",
    ["b_194"] = "Arrow Up",
    ["b_195"] = "Arrow Down",
    ["b_196"] = "Arrow Left",
    ["b_197"] = "Arrow Right",
    ["b_198"] = "Delete",
    ["b_199"] = "Escape",
    ["b_200"] = "Insert",
    ["b_201"] = "End",
    ["b_210"] = "Delete",
    ["b_211"] = "Insert",
    ["b_212"] = "End",
    ["b_1000"] = "Shift",
    ["b_1002"] = "Tab",
    ["b_1003"] = "Enter",
    ["b_1004"] = "Backspace",
    ["b_1009"] = "PageUp",
    ["b_1008"] = "Home",
    ["b_1010"] = "PageDown",
    ["b_1012"] = "CapsLock",
    ["b_1013"] = "Control",
    ["b_1014"] = "Right Control",
    ["b_1015"] = "Alt",
    ["b_1055"] = "Home",
    ["b_1056"] = "PageUp",
    ["b_2000"] = "Space"
}

---@param steps HubTutorialStep[]
---@param npcImage? string
---@param npcName? string
local function StartTutorial(steps, npcImage, npcName)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "tutorial:start",
        data = {
            npcImage = npcImage or DEFAULT_NPC_IMAGE,
            npcName = npcName or DEFAULT_NPC_NAME,
            steps = steps or {}
        }
    })
end

function CloseTutorial()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "tutorial:close" })
end

local function NextTutorialStep()
    SendNUIMessage({ action = "tutorial:next" })
end

local function PrevTutorialStep()
    SendNUIMessage({ action = "tutorial:prev" })
end

---@param stepIndex integer
local function GotoTutorialStep(stepIndex)
    SendNUIMessage({ action = "tutorial:goto", data = stepIndex })
end

RegisterNUICallback("tutorial:finished", function(data, cb)
    
    cb({})
end)

RegisterNUICallback("tutorial:skipped", function(data, cb)
    cb({})
end)

RegisterNetEvent("hub:tutorial:start", function(data)
    if not data then
        return
    end

    StartTutorial(data.steps or {}, data.npcImage, data.npcName)
end)

exports("StartTutorial", StartTutorial)
exports("CloseTutorial", CloseTutorial)
exports("NextTutorialStep", NextTutorialStep)
exports("PrevTutorialStep", PrevTutorialStep)
exports("GotoTutorialStep", GotoTutorialStep)

---@param skipCanStartCheck boolean
function StartHubTutorial( skipCanStartCheck )

    skipCanStartCheck = skipCanStartCheck or false

    print("function StartHubTutorial", gAnyTutorialStarted, gMicSetupStarted)

    if not skipCanStartCheck and gAnyTutorialStarted then -- tem algum tutorial em andamento ( isso previne o gMicSetupStarted de ser iniciado essa função meu deus do ceu)7
        print("function StartHubTutorial1", gAnyTutorialStarted, gMicSetupStarted)
        return
    end

    if not skipCanStartCheck and gMicSetupStarted then -- tem o mic setup em andamento tutorial nao pode ser iniciado
        print("function StartHubTutorial2", gAnyTutorialStarted, gMicSetupStarted)
        return
    end

    if not skipCanStartCheck and not exports.tutorial:CanStartUiTutorial('tutorial.ui.hub') then -- verifica se o tutorial pode ser iniciado
        print("function StartHubTutorial", gAnyTutorialStarted, gMicSetupStarted)
		return
	end

    SetCanShowModalVip(false)
    SetAnyTutorialStarted(true)
    
    OpenHub()
    Wait(100)
    
    print("function StartHubTutorial4", gAnyTutorialStarted, gMicSetupStarted)
    
    SendNUIMessage({
        action = "tutorialHub:start",
        data = {
            npcImage = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painel/emprego/velho.png",
            npcName  = _t("tutorial.npc_name"),
            steps = {
                {
                    target = '[data-nav-path="/tasks"]',
                    placement = "bottom",
                    title = _t("tutorial.hub_tutorial.title"),
                    content = _t("tutorial.hub_tutorial.content"),
                    npcDialogue = _t("tutorial.hub_tutorial.npc_dialogue"),
                    advanceOnPath = "/tasks",
                },
                {
                    target = '[data-tutorial-card="tutorial"]',
                    title = _t("tutorial.hub_tutorial2.title"),
                    npcDialogue = _t("tutorial.hub_tutorial2.npc_dialogue"),
                    advanceOnClick = true,
                },
                {
                    target = '[data-tutorial-modal="tasks"]',
                    placement = "auto",
                    title = _t("tutorial.hub_tutorial_tasks_modal.title"),
                    content = _t("tutorial.hub_tutorial_tasks_modal.content"),
                    npcDialogue = _t("tutorial.hub_tutorial_tasks_modal.npc_dialogue"),
                    advanceOnClick = true,
                },
                {
                    target = '[data-nav-path="/skills"]',
                    placement = "bottom",
                    title = _t("tutorial.hub_tutorial3.title"),
                    content = _t("tutorial.hub_tutorial3.content"),
                    npcDialogue = _t("tutorial.hub_tutorial3.npc_dialogue"),
                    advanceOnPath = "/skills",
                },
                {
                    target = '[data-tutorial-card="social"]',
                    title = _t("tutorial.hub_tutorial4.title"),
                    npcDialogue = _t("tutorial.hub_tutorial4.npc_dialogue"),
                    advanceOnClick = true,
                },
                {
                    title = _t("tutorial.hub_tutorial5.title"),
                    npcDialogue = _t("tutorial.hub_tutorial5.npc_dialogue"),
                    closeOnEscape = true,
                },
            },
        },
    })
end

RegisterCommand("testtutorial", function()
    StartHubTutorial( true )
end)

local function CleanupHubTutorial()
    ResetCanShowModalVip()
    ResetAnyTutorialStarted()
end

RegisterNUICallback("tutorialHub:finished", function(data, cb)
    CleanupHubTutorial()
    exports.tutorial:SendFinishedUiTutorial('tutorial.ui.hub')
    cb({})
end)

RegisterNUICallback("tutorialHub:skipped", function(data, cb)
    CleanupHubTutorial()
    cb({})
end)

---@return string
local function GetPushToTalkKeyLabel()
    local key = GetControlInstructionalButton(0, 249, true)
    if string.find(key, "t_") then
        local label, _count = string.gsub(key, "t_", "")
        return label
    else
        return specialkeyCodes[key] or "unknown"
    end
end

function StartMicSetup()
    if sx.featureflags.enableVoicePreferences() then return end

    
    -- if not exports.tutorial:CanStartUiTutorial('tutorial.mic.hub') then -- verifica se o tutorial pode ser iniciado
	-- 	return
	-- end

    SetAnyTutorialStarted(true)
    SetCanShowModalVip(false)
    print("StartMicSetup")

    gMicSetupStarted = true
    -- Esconde a HUD do jogo durante o teste de microfone. setHudStatus(false) seta BlockHud,
    -- o que anula o hud:Active(true) tardio do CloseHub (core.lua:532); hud:Active(false)
    -- garante o logo da cidade escondido independente do estado anterior.
    TriggerEvent("hud:setHudStatus", false)
    TriggerEvent("hud:Active", false)
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)
    SendNUIMessage({
        action = "micsetup:start",
        data = {
            npcImage = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painel/emprego/velho.png",
            npcName = _t("tutorial.npc_name"),
            title = _t("tutorial.mic_setup.title"),
            subtitle = _t("tutorial.mic_setup.content"),
            npcDialogue = _t("tutorial.mic_setup.npc_dialogue"),
            testKey = GetPushToTalkKeyLabel(),
            skipKey = "H"
        }
    })

    CreateThread(function()
        LocalPlayer.state.Invincible = true

        while gMicSetupStarted do
            Wait(100)

            SetPlayerInvincible(PlayerId(), true)
            
            local talking = MumbleIsPlayerTalking(PlayerId())
            if talking then
                SendNUIMessage({ action = "micsetup:mic-detected" })
            else
                SendNUIMessage({ action = "micsetup:mic-lost" })
            end
        end

        LocalPlayer.state.Invincible = false
        SetPlayerInvincible(PlayerId(), false)
    end)
end

local function CloseMicSetup()
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({ action = "micsetup:close" })
end

local function ResetStateMicSetup()
    gMicSetupStarted = false
    gOpenMicSetup = false
end

RegisterNUICallback("micsetup:done", function(data, cb)
    print("micsetup:done", json.encode(data, { indent = true }))
    CloseMicSetup()
    ResetCanShowModalVip()
    ResetStateMicSetup()
    ResetAnyTutorialStarted()
    gStateMicTutorialStarted = false
    
    TriggerEvent("net.character-creator.open-ramo-select")
    exports.tutorial:SendFinishedUiTutorial("tutorial.mic.hub")

    CreateThread(function()
        Wait(200)
        local ped = PlayerPedId()
        SetEntityVisible(ped, true, false)
        FreezeEntityPosition(ped, false)
        SetPlayerControl(PlayerId(), true, 0)

        TriggerEvent("hud.action.esc_tutorial")
    end)

    cb({})
end)

RegisterNUICallback("micsetup:skip", function(data, cb)
    print("micsetup:skip", json.encode(data, { indent = true }))
    CloseMicSetup()
    ResetCanShowModalVip()
    ResetStateMicSetup()
    gStateMicTutorialStarted = false
    
    TriggerEvent("net.character-creator.open-ramo-select")

    CreateThread(function()
        Wait(200)
        local ped = PlayerPedId()
        SetEntityVisible(ped, true, false)
        FreezeEntityPosition(ped, false)
        SetPlayerControl(PlayerId(), true, 0)
    end)

    cb({})
end)

RegisterNUICallback("micsetup:configure", function(data, cb)
    if sx.featureflags.enableVoicePreferences() then
        cb({ ok = false })
        return
    end
    print("micsetup:configure", json.encode(data, { indent = true }))
    ResetStateMicSetup()
    CloseMicSetup()
    -- Libera o BlockHud setado em StartMicSetup; daqui pra frente o hub controla a HUD
    -- (OpenHub esconde via hud:Active(false), CloseHub restaura). Sem isso a HUD ficaria travada.
    TriggerEvent("hud:setHudStatus", true)
    OpenHub()
    Wait(100)

    ---@type HubTutorialStep[]
    local steps = {
        {
            target = "[data-tutorial='mic-settings']",
            title = _t("tutorial.mic_config.title"),
            content = _t("tutorial.mic_config.content"),
            npcDialogue = _t("tutorial.mic_config.npc_dialogue"),
            placement = "bottom"
        },
        {
            title = _t("tutorial.mic_config2.title"),
            content = _t("tutorial.mic_config2.content"),
            npcDialogue = _t("tutorial.mic_config2.npc_dialogue"),
        }
    }

    StartTutorial(steps)
    
    cb({})
end)

RegisterNUICallback("micsetup:test", function(data, cb)
    print("micsetup:test", json.encode(data, { indent = true }))

    cb({})
end)

-- RegisterCommand("startmicsetup", function()
--     TriggerEvent("new_hub:client:startTutorial")
-- end)

RegisterNetEvent("new_hub:client:startTutorial", function()
    if sx.featureflags.enableVoicePreferences() then
        TriggerEvent("net.character-creator.open-ramo-select")
        TriggerEvent("hud.action.esc_tutorial")
        return
    end
    gStateMicTutorialStarted = true
    TriggerEvent("hub:close")
    Wait(100)

    local ped = PlayerPedId()
    SetEntityVisible(ped, false, false)
    FreezeEntityPosition(ped, true)
    SetPlayerControl(PlayerId(), false, 0)

    DoScreenFadeIn(1000)

    StartMicSetup()
end)

RegisterNetEvent('new_hub.client:openDirectView', function(_data)
    print('openDirectView', json.encode(_data, { indent = true }))
    if GetResourceState("hud") ~= "started" then
        return
    end
    local ok, m = pcall(function()
        return exports.hud:GetMissionsHudHighlight()
    end)
    if not ok or not m then
        return
    end

    print('openDirectView', json.encode(m, { indent = true }))

    -- if not exports.admin:SafeguardAccountHasDiscordAccountLink() then
    --     return
    -- end

    -- local mission = {
    --     name = m.name,
    --     description = m.description,
    --     current = m.current or 0,
    --     max = m.max or 1,
    --     groupName = m.groupName,
    --     groupIcon = m.groupIcon,
    -- }

    OpenHub(m.groupId)
    -- Wait(100)

    -- local title1
    -- if mission.groupName and mission.name then
    --     title1 = mission.groupName .. " — " .. mission.name
    -- elseif mission.name then
    --     title1 = mission.name
    -- elseif mission.groupName then
    --     title1 = mission.groupName
    -- else
    --     title1 = "Missão"
    -- end

    -- local desc = mission.description or ""
    -- local progress = ("(%d/%d)"):format(mission.current, mission.max)
    -- local content1 = (desc == "") and progress or (desc .. " " .. progress)

    -- ---@type HubTutorialStep[]
    -- local steps = {
    --     {
    --         target = '[data-nav-path="/tasks"]',
    --         title = title1,
    --         content = content1,
    --         npcDialogue = (desc ~= "" and desc) or title1,
    --         placement = "bottom",
    --     },
    --     {
    --         title = mission.name or "Missão",
    --         content = content1,
    --         npcDialogue = (desc ~= "" and desc) or progress,
    --     }
    -- }

    -- local portrait = (mission.groupIcon and mission.groupIcon ~= "") and mission.groupIcon or nil
    -- StartTutorial(steps, portrait, nil)
    -- local portrait = (mission.groupIcon and mission.groupIcon ~= "") and mission.groupIcon or nil
    -- StartTutorial(steps, portrait, nil)
end)
