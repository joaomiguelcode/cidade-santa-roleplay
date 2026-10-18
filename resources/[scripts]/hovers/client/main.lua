Tunnel = module("vrp","lib/Tunnel")
Proxy = module("vrp","lib/Proxy")
vRPS = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
cityName = GetConvar("cityName", "")

RegisterNUICallback("getCityName",function(Data,Callback)
  cityName = GetConvar("cityName", "")
  Callback(string.lower(cityName))
end)

RegisterNUICallback("getLang",function(Data,Callback)
  Callback(translations[lang])
end)
