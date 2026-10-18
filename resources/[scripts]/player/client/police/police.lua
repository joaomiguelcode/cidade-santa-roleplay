-----------------------------------------------------------------------------------------------------------------------------------------
-- REDUCES
-----------------------------------------------------------------------------------------------------------------------------------------
local reduceList = {
	["1"] = { 1698.86,2472.69,45.56 },
	["2"] = { 1698.48,2472.36,45.56 },
	["3"] = { 1635.66,2490.23,45.56 },
	["4"] = { 1634.63,2490.1,45.56 },
	["5"] = { 1618.41,2521.55,45.56 },
	["6"] = { 1607.39,2541.39,45.56 },
	["7"] = { 1606.3,2542.63,45.56 },
	["8"] = { 1624.83,2567.86,45.56 },
	["9"] = { 1624.78,2567.12,45.56 },
	["10"] = { 1643.77,2565.0,45.56 },
	["11"] = { 1665.05,2567.68,45.56 },
	["12"] = { 1715.97,2567.16,45.56 },
	["13"] = { 1715.97,2567.95,45.56 },
	["14"] = { 1716.02,2568.78,45.56 },
	["15"] = { 1768.79,2565.76,45.56 },
	["16"] = { 1769.77,2565.7,45.56 },
	["17"] = { 1772.72,2536.83,45.56 },
	["18"] = { 1758.19,2508.99,45.56 },
	["19"] = { 1757.87,2507.77,45.56 },
	["20"] = { 1719.9,2502.66,45.56 },
	["21"] = { 1695.28,2506.62,45.56 },
	["22"] = { 1663.84,2515.34,45.56 },
	["23"] = { 1664.44,2516.1,45.56 },
	["24"] = { 1628.63,2543.64,45.56 },
	["25"] = { 1636.16,2553.61,45.56 },
	["26"] = { 1648.41,2536.3,45.56 },
	["27"] = { 1657.61,2549.28,45.56 },
	["28"] = { 1649.78,2538.35,45.56 },
	["29"] = { 1699.18,2535.8,45.56 },
	["30"] = { 1699.57,2534.67,45.56 },
	["31"] = { 1699.39,2532.1,45.56 },
	["32"] = { 1777.42,2560.84,45.66 },
	["33"] = { 1784.21,2561.16,45.66 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number,v in pairs(reduceList) do
		exports["target"]:AddCircleZone("Prison:"..Number,vec3(v[1],v[2],v[3]),0.75,{
			name = "Prison:"..Number,
			heading = 3374176
		},{
			shop = Number,
			Distance = 1.0,
			options = {
				{
					event = "police:Reduces",
					tunnel = "server",
					label = "Vasculhar"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:MDT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("getCityName",function(Data,Callback)
    cityName = GetConvar("cityName", "")
    Callback(string.lower(cityName))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:ARSENAL
-----------------------------------------------------------------------------------------------------------------------------------------
local ArsenalStartCoords = {
    -- vector3(-942.05,-2044.48,9.4),	
}

if cityName == "Santa" then
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-942.05,-2044.48,9.4) 
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2497.71,-342.17,94.09) 
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2521.75,-336.4,101.89) 
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2522.0,-422.92,94.58)
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-444.4,6013.55,37.0)
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2605.97,5343.13,47.6) -- prf
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-2170.24,3210.47,32.81) -- Exercito
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-2359.95,3288.36,32.91) -- Exercito
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(816.10,-1296.02,19.85) -- civil
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-444.34,6013.73,37.0) -- civil
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-785.97,-1221.85,6.86) -- Tatica
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2505.62,-424.57,94.58) -- Tatica
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(842.33,-1296.43,28.24)
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-2170.24,3210.47,32.81) -- Exercito

elseif cityName == "CidadeNobre" then
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-785.97,-1221.85,6.86) -- Tatica nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-470.66,6006.69,27.55) -- Civil nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2511.78,-349.41,93.16) -- Militar
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2605.97,5343.13,47.6) -- prf
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-2234.74,3446.46,35.05) -- Exercito
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2605.51,5349.1,47.58)
elseif cityName == "Boomerang" then
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1875.44,3098.7,32.96) -- exercito nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-785.97,-1221.85,6.86) -- Tatica nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-444.34,6013.73,37.0) -- Civil nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2497.71,-342.17,94.09) -- Militar nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2521.75,-336.4,101.89) -- Militar nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2605.97,5343.13,47.6) -- prf
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1880.95,3109.60,32.92) -- Exercito
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2609.94,5366.68,47.38)
elseif cityName == "Grande" then
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1875.44,3098.7,32.96) -- exercito nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-785.97,-1221.85,6.86) -- Tatica nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-444.34,6013.73,37.0) -- Civil nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2497.71,-342.17,94.09) -- Militar nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2521.75,-336.4,101.89) -- Militar nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2605.97,5343.13,47.6) -- prf
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-2112.25,3238.37,32.81) -- Exercito
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2609.94,5366.68,47.38)
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(1844.64,2581.87,46.01) -- PoliciaPrisional

elseif cityName == "Fronteira" then
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1875.44,3098.7,32.96) -- exercito nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-785.97,-1221.85,6.86) -- Tatica nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-444.34,6013.73,37.0) -- Civil nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2497.71,-342.17,94.09) -- Militar nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2521.75,-336.4,101.89) -- Militar nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2605.97,5343.13,47.6) -- prf
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-2112.25,3238.37,32.81) -- Exercito
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2609.94,5366.68,47.38)
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(1844.64,2581.87,46.01) -- PoliciaPrisional

elseif cityName == "Malta" then
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1875.44,3098.7,32.96) -- exercito nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-785.97,-1221.85,6.86) -- Tatica nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-444.34,6013.73,37.0) -- Civil nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2497.71,-342.17,94.09) -- Militar nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2521.75,-336.4,101.89) -- Militar nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2605.97,5343.13,47.6) -- prf
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1880.95,3109.60,32.92) -- Exercito
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1984.49,3029.94,35.24) -- Exercito
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(480.31,-996.98,30.69) -- Militar praça
	
elseif cityName == "Kingdom" then
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1875.44,3098.7,32.96) -- exercito nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-785.97,-1221.85,6.86) -- Tatica nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-444.34,6013.73,37.0) -- Civil nobre
	-- ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(474.26,-990.69,26.27) -- Militar nobre
	-- ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(479.15,-996.77,30.68) -- Militar nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2605.97,5343.13,47.6) -- prf
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1880.95,3109.60,32.92) -- Exercito
elseif cityName == "Imperium" then
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1875.44,3098.7,32.96) -- exercito nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-785.97,-1221.85,6.86) -- Tatica nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-444.34,6013.73,37.0) -- Civil nobre
	-- ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(474.26,-990.69,26.27) -- Militar nobre
	-- ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(479.15,-996.77,30.68) -- Militar nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2605.97,5343.13,47.6) -- prf
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1880.95,3109.60,32.92) -- Exercito
elseif cityName == "GoatRP" then
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1875.44,3098.7,32.96) -- exercito nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-785.97,-1221.85,6.86) -- Tatica nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-444.34,6013.73,37.0) -- Civil nobre
	-- ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(474.26,-990.69,26.27) -- Militar nobre
	-- ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(479.15,-996.77,30.68) -- Militar nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2605.97,5343.13,47.6) -- prf
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1880.95,3109.60,32.92) -- Exercito

elseif cityName == "District99" then
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1875.44,3098.7,32.96) -- exercito nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-785.97,-1221.85,6.86) -- Tatica nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-444.34,6013.73,37.0) -- Civil nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(456.78,-983.09,30.68) -- Militar
	-- ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(479.15,-996.77,30.68) -- Militar nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2605.97,5343.13,47.6) -- prf
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2623.34,5283.53,47.59) -- prf
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1880.95,3109.60,32.92) -- Exercito

elseif cityName == "Krown" then
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1875.44,3098.7,32.96) -- exercito nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-785.97,-1221.85,6.86) -- Tatica nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-444.34,6013.73,37.0) -- Civil nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(456.78,-983.09,30.68) -- Militar
	-- ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(479.15,-996.77,30.68) -- Militar nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2605.97,5343.13,47.6) -- prf
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1880.95,3109.60,32.92) -- Exercito

elseif cityName == "Orizon" then
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1875.44,3098.7,32.96) -- exercito nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-785.97,-1221.85,6.86) -- Tatica nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-444.34,6013.73,37.0) -- Civil nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(456.78,-983.09,30.68) -- Militar
	-- ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(479.15,-996.77,30.68) -- Militar nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2605.97,5343.13,47.6) -- prf
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1880.95,3109.60,32.92) -- Exercito

elseif cityName == "Liberty99" then
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1875.44,3098.7,32.96) -- exercito nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-785.97,-1221.85,6.86) -- Tatica nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-444.34,6013.73,37.0) -- Civil nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(456.78,-983.09,30.68) -- Militar
	-- ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(479.15,-996.77,30.68) -- Militar nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2605.97,5343.13,47.6) -- prf
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1880.95,3109.60,32.92) -- Exercito
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2497.27,-342.71,94.09) -- Militar

elseif cityName == "Royal" then
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1875.44,3098.7,32.96) -- exercito nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-785.97,-1221.85,6.86) -- Tatica nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-444.34,6013.73,37.0) -- Civil nobre
	-- ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(474.26,-990.69,26.27) -- Militar nobre
	-- ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(479.15,-996.77,30.68) -- Militar nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2605.97,5343.13,47.6) -- prf
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1880.95,3109.60,32.92) -- Exercito

elseif cityName == "Real" then
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1875.44,3098.7,32.96) -- exercito nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-785.97,-1221.85,6.86) -- Tatica nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-444.34,6013.73,37.0) -- Civil nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2497.26,-342.8,94.09) -- Militar
	-- ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(474.26,-990.69,26.27) -- Militar nobre
	-- ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(479.15,-996.77,30.68) -- Militar nobre
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2605.97,5343.13,47.6) -- prf
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1880.95,3109.60,32.92) -- Exercito

elseif cityName == "Prime" then
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1989.20,3044.25,36.84) -- exercito
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-2320.15,3389.47,37.67) -- exercito
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-785.97,-1221.85,6.86) -- Tatica 
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-444.34,6013.73,37.0) -- Civil 
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2497.26,-342.8,94.09) -- Militar
	-- ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(474.26,-990.69,26.27) -- Militar 
	-- ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(479.15,-996.77,30.68) -- Militar 
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2605.97,5343.13,47.6) -- prf
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1880.95,3109.60,32.92) -- Exercito

elseif cityName == "Universo" then
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1875.44,3098.7,32.96) -- exercito universo
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-785.97,-1221.85,6.86) -- Federal universo
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-444.34,6013.73,37.0) -- Civil universo
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-704.06,-1299.33,5.40) -- Civil universo
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-697.16,-1433.30,5.02) -- Civil universo
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2497.71,-342.17,94.09) -- Militar universo
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2521.75,-336.4,101.89) -- Militar universo
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(1840.38,2579.2,46.02) -- policia universo
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-946.85,-2046.54,9.4) -- policia
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2605.97,5343.13,47.6) -- prf
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-825.28,-1239.47,6.87) -- Federal
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1880.95,3109.60,32.92) -- Exercito
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-2359.95,3288.36,32.91) -- Exercito
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-799.51,-1350.93,5.15) -- Tatica
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-446.65,6012.83,32.29)
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(835.02,-1287.15,28.24)
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(823.39,-1294.66,19.85) -- civil

elseif cityName == "Alexandria" then
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2502.85,-427.17,94.58)
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1875.07,3099.31,32.96)
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2497.71,-342.17,94.09)
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2521.75,-336.4,101.89)
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-785.97,-1221.85,6.86) -- Tatica
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-785.97,-1221.85,6.86) -- Prf
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2605.97,5343.13,47.6) -- Prf
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-444.43,6013.61,37.0) -- Civil
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1880.95,3109.60,32.92) -- Exercito

elseif cityName == "Maresia" then
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-444.34,6013.73,37.0) -- Civil 
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2521.75,-336.4,101.89) -- Militar 
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1880.95,3109.60,32.92) -- Exercito
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-2359.97,3288.45,32.91) -- Exercito
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-1875.44,3098.7,32.96) -- exercito
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-803.30,-1352.89,5.15) -- Tatica
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-3796.78,-4384.34,15.26) -- Tatica
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-708.49,-1297.69,5.40) -- Civil
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-772.01,-1323.58,9.60) -- Militar
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-703.66,-1433.15,5.02) -- Militar
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-697.01,-1390.66,5.50) -- Militar
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-742.68,-1258.04,5.70) -- Militar
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(2605.97,5343.13,47.6) -- Prf
	ArsenalStartCoords[#ArsenalStartCoords+1] = vector3(-556.6,-183.75,38.22) -- Juridico

end	

CreateThread(function()
    local Table = {}
    
    for i=1, #ArsenalStartCoords do
        Table[i] = {
            ArsenalStartCoords[i].x,
            ArsenalStartCoords[i].y,
            ArsenalStartCoords[i].z,
            2.5,
            "E",
            _t("openArsenal"),
            _t("pressToTakeArsenal"),
        }
    end
    TriggerEvent("hoverfy:Insert",Table)
    while true do 
        local idle = 2500
        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)
        for i=1, #ArsenalStartCoords do
            local arsenalCoords = ArsenalStartCoords[i]
            local distance = #(Coords - arsenalCoords)

            if distance <= 50.0 then
                idle = 0
                DrawMarker(21, arsenalCoords.x, arsenalCoords.y, arsenalCoords.z, 0, 0, 0, vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0), THEME.rgb.r, THEME.rgb.g, THEME.rgb.b, 94, false, false, 2, true, nil, nil, false)
                DrawMarker(27, arsenalCoords.x, arsenalCoords.y, arsenalCoords.z - 0.9, 0, 0, 0, vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0), THEME.rgb.r, THEME.rgb.g, THEME.rgb.b, 94, false, false, 2, true, nil, nil, false)

                if distance <= 2.5 then
                    if IsControlJustPressed(0,38) then
                        TriggerServerEvent("police:Arsenal")
                    end
                end
            elseif distance < 80.0 then
                idle = math.min(idle, 250)
            end
        end
        Wait(idle)
    end
end)

LicenseCoords = {
    vector4(-441.7, 6016.13, 32.28, 325.99),
    vector4(2623.6, 5242.53, 45.46, 204.1),
    vector4(-812.79, -1233.09, 6.82, 144.57),
    vector4(2511.41, -428.26, 94.58, 138.9),
}
CreateThread(function()
    local Table = {}
    
    for i=1, #LicenseCoords do
        Table[i] = {
            LicenseCoords[i].x,
            LicenseCoords[i].y,
            LicenseCoords[i].z,
            2.5,
            "E",
            _t("open_police_arsenal"),
            _t("press_to_open_police_arsenal"),
        }
    end
    TriggerEvent("hoverfy:Insert",Table)
    while true do 
        local idle = 2500
        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)
        for i=1, #LicenseCoords do
            local currentLicenseCoords = vector3(LicenseCoords[i].x, LicenseCoords[i].y, LicenseCoords[i].z)
            if #(Coords - currentLicenseCoords) <= 2.5 then
                idle = 5
                if IsControlJustPressed(0,38) then
                    TriggerServerEvent("police:License")
                end
            end
        end
        Wait(idle)
    end
end)
