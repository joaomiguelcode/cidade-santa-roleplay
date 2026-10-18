-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPS = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
sRP = {}
Tunnel.bindInterface("register",sRP)
vSERVER = Tunnel.getInterface("register")
cityName = GetConvar("cityName", "")
Player = GetPlayerServerId(PlayerId())
local InRegister = false
gActiveSystemToken = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- CALLBACKS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Step1",function(data,cb)
    local acceptTerms = data["tos"]
    if acceptTerms then
        vSERVER.updateTOS(acceptTerms)
        cb(true)
    else
        cb(false)
    end
end)

RegisterNUICallback("Step2",function(data,cb)
    local validate = false
    print(json.encode(data))
    if not data["gender"] then
        data["gender"] = "masculino"
    end
    
    if not data["foundUs"] then
        data["foundUs"] = "Season 3"
    end
    if data["email"] and data["age"] and data["name"] and data["foundUs"] and data["gender"] and data["whatsapp"] then
        if #data["email"] > 255 or  #data["name"] > 255 or #data["foundUs"] > 255 or #data["gender"] > 255 or #data["whatsapp"] > 255 then
            --TriggerEvent("Notify","vermelho","A descrição não pode ultrapassar 255 caracteres.",5000,"REGISTRO")
            TriggerEvent("Notify2","#maxCaracteres")
            cb(false)
            return
        end

        local name = data["name"] or ""
        local surname = data["surname"] or ""
        local Name = name.." "..surname
        validate = vSERVER.setAccountInfo(Name,data["email"],data["gender"],data["foundUs"],data["age"],data["whatsapp"],data["notifications"],data["friendReferral"], data["influencerCoupon"])
        print("[DEBUG] - STEP2  1", tostring(validate))
        if validate then
            if not GlobalState["ObrigatoryToken"] then
                local Data = {
                    ["nome"] = data["name"],
                    ["nome2"] = data["surname"],
                    ["sexo"] = string.lower(data["gender"]),
                    ["idade"] = data["age"],
                }
                TriggerEvent("spawn:NameInfo",Data)
                TriggerServerEvent("register:AddAction",2)
                print("[DEBUG] - STEP2 2 ", tostring(validate))
                cb(true)
                return
            end
            if not LocalPlayer["state"]["Token"] then
                SetNuiFocus(false,false)
                TransitionFromBlurred(1000)
                local Ped = PlayerPedId()
                SendNUIMessage({
                    action = "close",
                })
                SendNUIMessage({
                    action = "setVisible",
                    data = false
                })
            end
            local Data = {
                ["nome"] = data["name"],
                ["nome2"] = data["surname"],
                ["sexo"] = string.lower(data["gender"]),
                ["idade"] = data["age"],
            }
            TriggerEvent("spawn:NameInfo",Data)
            TriggerServerEvent("register:AddAction",2)
            print("[DEBUG] - STEP2 2 ", tostring(validate))
            cb(true)
        else
            cb(false)
        end
    else
        validate = false
    end
    cb(validate)
end)

RegisterNUICallback("Step3",function(data,cb)
    local Ped = PlayerPedId()
    print("[DEBUG] - STEP3  1", tostring(data))
    local validate = vSERVER.ValidateToken()
    print("[DEBUG] - STEP3  3", tostring(validate))
    if not validate then
        print("[DEBUG] - STEP3 4", tostring(false))
        cb(false)
    else
        print("[DEBUG] - STEP3 5", tostring(true))
        cb(true)
        TriggerServerEvent("register:AddAction",3)
        gActiveSystemToken = false
    end
end)

RegisterNUICallback("carSelected",function(data,cb)
    if data and data ~= "" then
        vSERVER.giveVehicle(data)
    else
        SendNUIMessage({
            action = 'setVisible',
            data = "step3"
        })
    end

    cb("Ok")
end)

RegisterNUICallback("getCars",function(Data,CallBack)
    local cityData = (infoLogin and (infoLogin[cityName] or infoLogin["Santa"] or infoLogin["Base"])) or {}
    CallBack({ 
        recommendation = cityData["Recommendation"] or { "Lista do FiveM", "Influencer", "Indicação de amigo", "Redes sociais", "Outros" },
        socialMedia = cityData["SocialMedia"] or { "Instagram", "Tiktok", "YouTube" },
        cars = cityData["Cars"] or {
            { name = "Yamaha XJ6", spawn = "xj6", link = "" },
            { name = "Golf GTI", spawn = "golfgti", link = "" },
            { name = "Range Rover", spawn = "rangerover", link = "" },
        }
    })
end)

RegisterNUICallback("getID",function(Data,CallBack)
    CallBack(LocalPlayer["state"]["Token"])
end)

RegisterNUICallback("getDiscord",function(Data,CallBack)
    local cityData = (infoLogin and (infoLogin[cityName] or infoLogin["Santa"] or infoLogin["Base"])) or {}
    CallBack(cityData["Discord"] or "https://discord.gg")
end)

RegisterNUICallback("getInfo",function(Data,CallBack)
    local cityData = (infoLogin and (infoLogin[cityName] or infoLogin["Santa"] or infoLogin["Base"])) or {}
    CallBack({
        recommendation = cityData["Recommendation"] or { "Lista do FiveM", "Influencer", "Indicação de amigo", "Redes sociais", "Outros" },
        socialMedia = cityData["SocialMedia"] or { "Instagram", "Tiktok", "YouTube" }
    })
end)

RegisterNUICallback("getCurrentCountryCode",function(Data,CallBack)
    local countryCode = vSERVER.GetPlayerCountryCode()
    print("getCurrentCountryCode",countryCode)
    CallBack(countryCode)
end)


local phoneEnabled = {
    ["Kingdom"] = true,
    ["Imperium"] = true,
    ["GoatRP"] = true,
    ["District99"] = true,
    ["Krown"] = true,
    ["Orizon"] = true,
    ["Royal"] = true,
    ["Real"] = false,
    ["Prime"] = false,
    ["Santa"] = true,
    ["CidadeNobre"] = true,
    ["Boomerang"] = true,
    ["Universo"] = true,
    ["Alexandria"] = true,
    ["Maresia"] = true,
    ["Malta"] = true,
    ["Grande"] = true,
    ["Fronteira"] = true,
}
RegisterNUICallback("isPhoneEnabled",function(Data,CallBack)
    local enabled = phoneEnabled[cityName]
    if enabled == nil then
        enabled = true
    end
    CallBack(enabled)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATEBAGS
-----------------------------------------------------------------------------------------------------------------------------------------
local RegisterTimer = GetGameTimer()
-- AddStateBagChangeHandler('Register',('player:%s'):format(Player) , function(_, _, Value)
--     if Value then
--         Wait(100)
--         RegisterTimer = GetGameTimer() + 30000
--         CreateThread(function()
--             while LocalPlayer["state"]["Register"] do
--                 if GetGameTimer() >= RegisterTimer then
--                     RegisterTimer = GetGameTimer() + 30000
--                     if not LocalPlayer["state"]["Character"] and not InRegister then
--                         TriggerEvent("register:Open")
--                     end
--                     return
--                 end
--                 Wait(1000)
--             end
--         end)
--     end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function SetRoute(route)
    if route == "/" then
        SendNUIMessage({
            action = 'setVisible',
            data = "/"
        })
    elseif route == "step2" then
        SendNUIMessage({
            action = 'setVisible',
            data = "step2"
        })
    elseif route == "step3" then
        SendNUIMessage({
            action = 'setVisible',
            data = "step3"
        })
    end    
end

function isdatevalid(date)
    local year,month,day = string.match(date,"(%d+)-(%d+)-(%d+)")
    if day and month and year then
        if tonumber(day) > 0 and tonumber(day) <= 31 and tonumber(month) > 0 and tonumber(month) <= 12 and tonumber(year) > 1900 and tonumber(year) <= 2022 then
            return true
        end
    end
    return false
end

function formatDate(date)
    local day,month,year = string.match(date,"(%d+)/(%d+)/(%d+)")
    return string.format("%s-%s-%s",year,month,day)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("register:Close")
AddEventHandler("register:Close",function()
    SetNuiFocus(false,false)
    TransitionFromBlurred(1000)
    -- local Ped = PlayerPedId()
    -- ENG-1146: the current React NUI router only listens for the "close"
    -- action. Keep the legacy setVisible=false for older bundles but send
    -- "close" too so the registration screen actually goes away after the
    -- player finishes registration.
    SendNUIMessage({
        action = "close",
    })
    SendNUIMessage({
        action = "setVisible",
        data = false
    })
    TriggerEvent("hud:Active",true)
    TransitionFromBlurred(1000)
    -- FreezeEntityPosition(Ped,false)
    -- SetEntityVisible(Ped,true,false)
    -- FreezeEntityPosition(PlayerPedId(),false)
end)

RegisterNetEvent('register:Open')
AddEventHandler('register:Open', function()
    local Ped = PlayerPedId()
    FreezeEntityPosition(Ped,true)
    TriggerEvent("talknpc:closeTalk")
    TriggerEvent("hud:Active",false)
    TransitionToBlurred(1000)
    Wait(500)
    DoScreenFadeIn(1000)
    SetNuiFocus(true, true)
    FreezeEntityPosition(PlayerPedId(),true)
    SendNUIMessage({
        action = "openTOS",
        data = true
    })
    SendNUIMessage({
        action = "initializeRegister",
        data = true
    })
    SendNUIMessage({
        action = "setVisible",
        data = true
    })
    InRegister = true
    TriggerEvent("hud:Active",false)
end)

local TIME_TO_RELOAD_FOCUS_TOKEN_MS = 500

RegisterNetEvent('register:OpenToken')
AddEventHandler('register:OpenToken', function(validate)
    if not GlobalState["ObrigatoryToken"] then
        return
    end
    InToken = validate
    gActiveSystemToken = true
    TriggerEvent("hud:Active",false)
    TransitionToBlurred(1000)
    SendNUIMessage({
        action = 'setVisible',
        data = "step3"
    })
    SetNuiFocus(true, true)
    FreezeEntityPosition(PlayerPedId(),true)

    CreateThread(function()
        while gActiveSystemToken do
            SetNuiZindex(99999999)
            SetNuiFocus(true, true)
            Wait(TIME_TO_RELOAD_FOCUS_TOKEN_MS)
        end
    end)
end)

RegisterNUICallback("getCityName",function(Data,Callback)
    cityName = GetConvar("cityName", "")
    Callback(string.lower(cityName))
end)

function sRP.CheckRegister()
    return true
end

-- CreateThread(function()
--     -- SendNUIMessage({
--     --     action = 'setVisible',
--     --     data = "/step2"
--     -- })
--     -- SetNuiFocus(true, true)
--     TriggerServerEvent("register:CheckRegister")
-- end)

RegisterNetEvent('register:OpenWhatsApp')
AddEventHandler('register:OpenWhatsApp', function(validate)
    SendNUIMessage({
        action = 'validatePhone',
        data = true
    })
    SetNuiFocus(true, true)
    FreezeEntityPosition(PlayerPedId(),true)
end)

local gHasDiscordAccountLink = vRP.HasDiscordAccountLink() and true or false

---O modal tá aberto na UI do jogador?
---@type boolean
local gIsDiscordAccountLinkingModalOpen = false

-- Local fanout event from vrp — fires both on the initial playerData sync
-- and on runtime vrp:setHasDiscordAccountLink updates. We never listen to
-- vrp's net events directly so vrp owns the wire format.
AddEventHandler("vrp:onPlayerDataUpdated", function(playerData)
    gHasDiscordAccountLink = playerData and playerData["hasDiscordAccountLink"] and true or false
end)

---@param options? { termsInline?: boolean, termsLink?: string }
RegisterNetEvent('register:openNewDiscordValidation', function(accountLinkSessionUrl, discordCode, legacyTokenVerificationEnabled, options)
    gDiscordAccountLinkUrl = accountLinkSessionUrl

    SendNUIMessage({
        action = 'openNewDiscord',
        data = {
            discordCode = discordCode,
            discordLink = accountLinkSessionUrl,
            legacyTokenVerificationEnabled = legacyTokenVerificationEnabled and true or false,
            termsInline = options and options.termsInline or false,
            termsLink = options and options.termsLink or nil,
            preserveStep = options and options.preserveStep or false,
        }
    })
    SetNuiFocus(true, true)

    gIsDiscordAccountLinkingModalOpen = true
end)

RegisterNetEvent('register:discordVerificationSuccess', function(account)
    gHasDiscordAccountLink = true

    if not gIsDiscordAccountLinkingModalOpen then
        return
    end

    SendNUIMessage({
        action = 'discordVerificationSuccess',
        data = {
            success = true,
            account = type(account) == 'table' and account or {},
        }
    })
end)

local function closeDiscordAccountLinkingModal()
    gIsDiscordAccountLinkingModalOpen = false
    gDiscordAccountLinkUrl = nil
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'close',
        data = false,
    })
end

RegisterNetEvent("register:closeDiscordAccountLinkingModal", closeDiscordAccountLinkingModal)

RegisterNUICallback("validateNewDiscord",function(data, cb)

    if gHasDiscordAccountLink then
        cb(true)
        closeDiscordAccountLinkingModal()
        return
    end

    -- ENG-1146: fallback for the webhook-vs-click race. The player can
    -- finish the Discord OAuth on the site and press "Liberar Acesso"
    -- before the webhook has fanned out to the client cache; ask the
    -- server for the authoritative status so the first click does not
    -- show a spurious "Vínculo não encontrado" when the link already
    -- landed.
    -- pcall so a tunnel failure can't leave the React button stuck on
    -- "Validando..." — cb must always fire exactly once.
    local ok, serverLinked = pcall(function()
        return vSERVER.refreshDiscordLinkStatus()
    end)

    if not ok then
        sx.logger:error( ('Discord link status refresh failed error=%s'):format( tostring(serverLinked) ) )
        cb(false)
        return
    end

    if serverLinked then
        gHasDiscordAccountLink = true
        cb(true)
        closeDiscordAccountLinkingModal()
        return
    end

    cb(false)
end)

RegisterNUICallback('closeDiscordModal', function( data, cb )
    -- ENG-1146: the router's closeDiscordModal handler does navigate(-1),
    -- which bounces the player back to whichever route they were on
    -- before the modal opened — usually the registration screen. Send
    -- "close" instead so the whole NUI hides via setVisible(false) and
    -- the game isn't left with the Cadastro form stuck on top.
    closeDiscordAccountLinkingModal()

    cb({ ok = true })
end)

-- ENG-1442: after the Discord step shows its success state, the NUI's
-- "Liberar Acesso" CTA fires this to chain into the phone-validation step
-- (mirroring the website's two-step flow). We close the Discord modal and
-- ask the server to start a phone-linking session — server owns the
-- decision of whether the player still needs to validate, so this is safe
-- to call unconditionally; if the player is already validated the server
-- replies with register:phoneValidationSkipped and the gate releases.
RegisterNUICallback('discordContinueToPhone', function(data, cb)
    gIsDiscordAccountLinkingModalOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })

    TriggerServerEvent("register:requestPhoneValidation")

    cb({ ok = true })
end)

-- ENG-1146: forwards the phone_linked webhook to the PhoneVerificationModal
-- NUI so the "Verificando seu número..." spinner transitions to the success
-- state instead of hanging until the player manually closes the modal.
RegisterNetEvent('register:phoneVerificationSuccess', function()
    SendNUIMessage({
        action = 'qrVerificationSuccess',
        data = { success = true }
    })
end)

-- ENG-1146: NUI callbacks consumed by the PhoneVerificationModal. Without
-- handlers the fetchNui promises reject on the client, which bubbles up as
-- a noisy error in the UI. requestQRStatusCheck is a fire-and-forget no-op
-- — the backend already drives status via register:phoneVerificationSuccess.
RegisterNUICallback('openExternalUrl', function(data, cb)
    if data and data.url then
        TriggerEvent("player:OpenURL", data.url)
    end
    cb({ ok = true })
end)

RegisterNUICallback('requestQRStatusCheck', function(data, cb)
    cb({ ok = true })
end)

RegisterNUICallback("getFormInfos",function(Data,Callback)
    local Info = vSERVER.getAccountInfo()
    Callback(Info)
end)

RegisterNUICallback("Whatsapp",function(Data,Callback)
    vSERVER._updateWhatsapp(Data["whatsapp"])
    SetNuiFocus(false,false)
    TransitionFromBlurred(1000)
    SendNUIMessage({ 
        action = "setVisible",
        data = false 
    })
    Callback(true)
end)

RegisterNUICallback("validateInfluencerCode",function(Data,Callback)
    local validate = vSERVER.redeemInfluencerCode(Data["code"])
    Callback(validate)
end)

RegisterNUICallback("getTOSLink",function(Data,Callback)
    print("[DEBUG] - getTOSLink", TosLink[cityName] or "https://docs.google.com/document/d/1n5Cskzw1ZPCaSvxgivckfyseJheWRjNO9s39zsbvtvY/preview?tab=t.0")
    TriggerEvent("player:OpenURL",TosLink[cityName] or "https://docs.google.com/document/d/1n5Cskzw1ZPCaSvxgivckfyseJheWRjNO9s39zsbvtvY/preview?tab=t.0")
    Callback(true)
end)

local ShowNewNotification = {
    -- ["Grande"] = true,
    -- ["Universo"] = true,
    -- ["Maresia"] = true,
}

RegisterNUICallback("showNotification",function(Data,Callback)
    local enabled = ShowNewNotification[cityName]
    if enabled == nil then
        enabled = false
    end
    Callback(enabled)
end)
