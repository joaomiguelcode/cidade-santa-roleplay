---Variables
---@type boolean
local protection = false
local new_hub = exports.new_hub
local playerState = LocalPlayer.state
local protectionTime = bProtectionTime
-- ENG-3994: fim da proteção do recém-contratado (GetGameTimer, ms); nil = proteção do iniciante por playtime.
---@type number?
local hireProtectionEndsAt = nil

-- ENG-3993: ataque bloqueado durante a proteção (tiro, mira e corpo a corpo; mesma lista do ghost do farm).
local BLOCKED_CONTROLS = { 24, 25, 140, 141, 142, 257, 263, 264 }
-- Outros scripts (saída da safezone, revive, minigames) zeram a invencibilidade: reaplica nesse intervalo.
local INVINCIBLE_REFRESH_MS = 250

---Remaining protection seconds (nil enquanto o playtime não carregou)
---@return number?
local function GetRemainingSeconds()
    if hireProtectionEndsAt then
        return math.max(0, math.ceil((hireProtectionEndsAt - GetGameTimer()) / 1000))
    end

    local playtime = new_hub:GetPlaytimeSeconds()
    if playtime == -1 then return nil end

    return math.max(0, protectionTime - playtime)
end

---@param remainingSeconds number
---@return number
local function ToMinutes(remainingSeconds)
    return math.ceil(remainingSeconds / 60)
end

---ENG-3993: não toma nem causa dano de player (tiro, corpo a corpo e veículo).
---Invencível no próprio ped (o dono do ped decide o dano), ghost contra atropelar/ser atropelado
---e `BProtection` replicado pro server cancelar `weaponDamageEvent` e bloquear algemar/revistar/roubar.
local function ApplyProtectionEffects()
    SetEntityInvincible(PlayerPedId(), true)
    SetLocalPlayerAsGhost(true)

    if not playerState.Invincible then playerState.Invincible = true end
    if not playerState.BProtection then playerState:set("BProtection", true, true) end
end

local function ClearProtectionEffects()
    playerState:set("BProtection", nil, true)

    -- Não desliga ghost/invencibilidade do farm (FarmGhost); a safezone reaplica a dela sozinha.
    if playerState.FarmGhost then return end

    playerState.Invincible = false
    SetLocalPlayerAsGhost(false)
    SetEntityInvincible(PlayerPedId(), false)
end

---Start Protection
---@param creator? boolean
local function StartProtection(creator)
    protection = true

    CreateThread(
        function()
            sx.logger:debug("Protection started")

            CreateThread(
                function()
                    if creator then
                        sx.logger:debug("Waiting for creator delay")
                        Wait(60000 * bProtectionDelay)
                    end

                    -- ENG-3994: contratado nesse meio tempo já recebeu o aviso da proteção dele.
                    if not protection or hireProtectionEndsAt then return end

                    TriggerServerEvent("player:server:firstLogin")

                    local remainingSeconds = GetRemainingSeconds()
                    if remainingSeconds then
                        TriggerEvent("hud.action.newbieNotify", remainingSeconds)
                        TriggerEvent("Notify2", "#bprotectionIn", { minutes = ToMinutes(remainingSeconds) })
                    end
                end
            )

            -- Por frame: sem atacar; a cada INVINCIBLE_REFRESH_MS reaplica a invencibilidade.
            CreateThread(
                function()
                    local refreshAt = 0
                    while protection do
                        DisablePlayerFiring(PlayerId(), true)

                        for _, control in ipairs(BLOCKED_CONTROLS) do
                            DisableControlAction(0, control, true)
                        end

                        local now = GetGameTimer()
                        if now >= refreshAt then
                            refreshAt = now + INVINCIBLE_REFRESH_MS
                            SetEntityInvincible(PlayerPedId(), true)
                        end

                        Wait(0)
                    end
                end
            )

            while protection do
                local remainingSeconds = GetRemainingSeconds()
                if remainingSeconds and remainingSeconds <= 0 then
                    protection = false
                    TriggerEvent("Notify2", "#bprotectionOut")
                    break
                end

                ApplyProtectionEffects()

                Wait(1000)
            end

            hireProtectionEndsAt = nil
            ClearProtectionEffects()

            sx.logger:debug("Protection finished")
        end
    )
end

---Check Protection
---@param creator? boolean
local function CheckProtection(creator)
    if protection then return end

    if bProtectionDisabledCities[cityName] then return end

    if GetResourceState("new_hub") ~= "started" then return end

    -- ENG-3993: só iniciante (server confere o grupo; contratado que reloga não volta pra proteção).
    if not lib.callback.await("player:bprotection:canStart", false) then return end

    local playtime = new_hub:GetPlaytimeSeconds()
    while playtime == -1 do
        Wait(1000)
        playtime = new_hub:GetPlaytimeSeconds()
    end

    sx.logger:debug(("Playtime: %d"):format(playtime))

    local time = bProtectionTime
    if creator then
        -- time spent on character creation added to protection
        time = time + (playtime + 10)

        -- delay time for protection activation after character creation
        time = time + (60 * bProtectionDelay)
    end

    sx.logger:debug(("Protection time: %d"):format(time))

    if playtime > time or protection then return end

    protectionTime = time
    StartProtection(creator)
end RegisterNetEvent("player:client:checkProtection", CheckProtection)

---Get Protection
---@return boolean
---@param silent? boolean
local function GetProtection(silent)

    sx.logger:debug( ('GetProtection called with silent=%s protection=%s'):format( tostring( silent ), tostring( protection ) ) )

    if protection then
        local remainingSeconds = GetRemainingSeconds()

        sx.logger:debug( ('GetProtection: remainingSeconds=%s, protectionTime=%s'):format( tostring( remainingSeconds ), tostring( protectionTime ) ) )
        if remainingSeconds and not silent then
            TriggerEvent("Notify2", "#bprotectionBlock", { minutes = ToMinutes(remainingSeconds) })
        end
    end

    return protection
end


exports("GetProtection", GetProtection)

function Creative.GetProtection(silent)
    return GetProtection(silent)
end

-- ENG-3993: server avisa quando bloqueia algemar/revistar/roubar de quem está protegido.
RegisterNetEvent("player:client:protectionBlocked", function()
    GetProtection()
end)

-- ENG-3994: iniciante contratado ganha a proteção do recém-contratado (tempo corrido, vindo do server).
-- Se ainda estava na proteção do iniciante, ela acaba aqui e passa a valer só esta.
RegisterNetEvent("player:client:hireProtection", function(seconds)
    seconds = tonumber(seconds)
    if not seconds or seconds <= 0 then return end

    hireProtectionEndsAt = GetGameTimer() + seconds * 1000
    TriggerEvent("Notify2", "#bprotectionIn", { minutes = ToMinutes(seconds) })

    sx.logger:info(("Proteção do recém-contratado iniciada: %ds (já protegido=%s)"):format(seconds, tostring(protection)))

    if not protection then StartProtection() end
end)

---Get Protection Status
---@return boolean
local function GetProtectionStatus()
    return protection
end
exports("GetProtectionStatus", GetProtectionStatus)

---On Resource Start
AddEventHandler("onResourceStart", function(resource)
	if resource == GetCurrentResourceName() then
		CheckProtection()
	end
end)

---On Resource Stop
AddEventHandler("onResourceStop", function(resource)
	if resource == GetCurrentResourceName() then
		if protection then
			protection = false
			ClearProtectionEffects()
		end
	end
end)

local RESOURCE_FOUCUSED_NAMES = { 
    "new_hub",
    "inventory",
    "character-creator",
    "garages",
    "hud"
}


local function IsResourceFoucused()
    for _, resourceName in pairs(RESOURCE_FOUCUSED_NAMES) do
        if GetResourceState(resourceName) == "started" and exports[resourceName]:IsResourceFocusedUi() then
            return true
        end
    end
    return false
end

exports("IsResourceFoucused",IsResourceFoucused)

local TIME_TO_SHOW_WELCOME_MESSAGE_SECONDS = 7

local function CreateThreadToShowWelcomeMessage()
    sx.logger:info(('welcome: firstLoginMessage received, locking mission HUD and starting %ds wait'):format(TIME_TO_SHOW_WELCOME_MESSAGE_SECONDS))

    -- First-login: trava o card de missão até 5s após o banner aparecer.
    TriggerEvent("missions:client:lockHud")

    local startTime = GetGameTimer()
    local finishTime = startTime + (TIME_TO_SHOW_WELCOME_MESSAGE_SECONDS * 1000)

    CreateThread(function()
        local lastLogAt = 0
        while true do

            if GetGameTimer() < finishTime then
                local now = GetGameTimer()
                if now - lastLogAt >= 5000 then
                    sx.logger:debug(('welcome: waiting timer remaining=%dms'):format(finishTime - now))
                    lastLogAt = now
                end
                goto ignore
            end

            do
                local health = GetEntityHealth(PlayerPedId())
                if health < 101 then
                    local now = GetGameTimer()
                    if now - lastLogAt >= 5000 then
                        sx.logger:debug(('welcome: blocked by health=%d (need >= 101)'):format(health))
                        lastLogAt = now
                    end
                    goto ignore
                end
            end

            if IsResourceFoucused() then
                local now = GetGameTimer()
                if now - lastLogAt >= 5000 then
                    sx.logger:debug("welcome: blocked by focused UI (new_hub/inventory/character-creator/garages/hud)")
                    lastLogAt = now
                end
                goto ignore
            end

            sx.logger:info("welcome: conditions met, firing exports.hud:eventNotify banner")
            exports.hud:eventNotify({
                visible = true,
                title = "welcomeTitle",
                subtitle = "welcomeSubtitle",
                hint = "welcomeHint"
            })

            SetTimeout( 5 * 1000, function()
                TriggerEvent( "hud:hideEventNotify" )
            end )

            TriggerServerEvent("net.player.show.welcome.message")

            break

            ::ignore::
            Wait(1000)
        end
    end)
end

RegisterNetEvent("player:client:firstLoginMessage", CreateThreadToShowWelcomeMessage)
