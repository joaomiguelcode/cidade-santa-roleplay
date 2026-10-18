-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
Tunnel = module("vrp","lib/Tunnel")
Proxy = module("vrp","lib/Proxy")
vRPS = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("hud",Creative)
vSERVER = Tunnel.getInterface("hud")

local DEFAULT_VOLUME = 0.5

local function playAudio(url, volume)
    if type(url) ~= 'string' or url == '' then
        print('[Audio] Invalid URL')
        return
    end

    volume = tonumber(volume) or DEFAULT_VOLUME
    if volume < 0.0 then volume = 0.0 end
    if volume > 1.0 then volume = 1.0 end

    SendNUIMessage({
        action = 'setAudio',
        data = {
            url = url,
            volume = volume,
        }
    })

    print(('[Audio] Playing: %s (volume: %.2f)'):format(url, volume))
end

local function stopAudio()
    SendNUIMessage({
        action = 'setAudio',
        data = {
            url = nil,
            volume = 0.0,
            stop = true,
        }
    })
    print('[Audio] Stopped')
end


local CooldownOpenAudio = GetGameTimer()
lang = GetConvar("language", "pt-br") or "pt-br"
RegisterNetEvent("promotion_button:OpenAudio")
AddEventHandler("promotion_button:OpenAudio",function(url)
    if CooldownOpenAudio >= GetGameTimer() then
        print("3")
        return
    end
    CooldownOpenAudio = GetGameTimer() + 10000
    url = url:gsub("[<>]","")
    Wait(300)
    playAudio(url,0.1)
end)