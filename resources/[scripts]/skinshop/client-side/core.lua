-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG ENG-2327 — hook SetPedComponentVariation pra rastrear drawable errado no cancelar
-- ponytail: remover este bloco depois de identificar a chamada culpada
-----------------------------------------------------------------------------------------------------------------------------------------
-- do
-- 	local _SetPedComponentVariation = SetPedComponentVariation
-- 	function SetPedComponentVariation( ped, component, drawable, texture, palette )
-- 		sx.logger:debug( ('[ENG-2327] SetPedComponentVariation(component=%s, drawable=%s, texture=%s, palette=%s)\n%s')
-- 			:format( tostring( component ), tostring( drawable ), tostring( texture ), tostring( palette ), debug.traceback( nil, 2 ) ) )
-- 		return _SetPedComponentVariation( ped, component, drawable, texture, palette )
-- 	end
-- end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("skinshop",Creative)
vSERVER = Tunnel.getInterface("skinshop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Init = "hat"
local Camera = nil
local Animation = false
local Command = false
local gOpenedFromClothingStore = false
cityName = GetConvar("cityName", "")
-- ponytail: debug temporário CTD DecibelSpawn (ver new_spawn/client/native_debug.lua); remover quando identificado
local nsdbg = ( cityName == "Fronteira" or cityName == "Krown" ) and GetConvar( "newspawn_debug", "1" ) ~= "0"
local Bucket = 1
local Newbie = false
local CachedCoords
local playerModel ---@type number
---@type table
local playerCustomization = {}

---@type ISkinShop.OpenWithFlags
local openHandlers = {
   flags = 0 -- inicialmente sem flag
}

local function ResetSkinshopOpenOrigin()
	Command = false
	gOpenedFromClothingStore = false
end

local blockBuckets = {
    [25] = true, -- mundo royale
}

function OnRestoreApparence()
	Dataset = next(playerCustomization) and playerCustomization or Dataset

	if not (playerModel and IsModelValid(playerModel)) then
		return
	end

	RequestModel(playerModel)
	while not HasModelLoaded(playerModel) do
		Wait(0)
	end

	SetPlayerModel(PlayerId(), playerModel)
	while GetEntityModel(PlayerPedId()) ~= playerModel do
		Wait(0)
	end

	TriggerServerEvent("player:Debug")
end

AddEventHandler("onResourceStop", function(resource)
	if resource ~= GetCurrentResourceName() then
		return
	end
	
	if ( openHandlers.flags & eSkinshopOpenFlags.TEMPORARY_CUSTOMIZATION ) ~= 0 then
		OnRestoreApparence()
		FreezeEntityPosition(PlayerPedId(),false)
		openHandlers.callback({})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DATASET
-----------------------------------------------------------------------------------------------------------------------------------------
local DEFAULT_DATASET =  {
	["pants"] = { item = 0, texture = 0 },
	["arms"] = { item = 0, texture = 0 },
	["tshirt"] = { item = 1, texture = 0 },
	["torso"] = { item = 0, texture = 0 },
	["vest"] = { item = 0, texture = 0 },
	["shoes"] = { item = 0, texture = 0 },
	["mask"] = { item = 0, texture = 0 },
	["backpack"] = { item = 0, texture = 0 },
	["hat"] = { item = -1, texture = 0 },
	["glass"] = { item = 0, texture = 0 },
	["ear"] = { item = -1, texture = 0 },
	["watch"] = { item = -1, texture = 0 },
	["bracelet"] = { item = -1, texture = 0 },
	["accessory"] = { item = 0, texture = 0 },
	["decals"] = { item = 0, texture = 0 }
}

local Dataset = DEFAULT_DATASET

local gApplyCategoryOrder = {
	"pants",
	"arms",
	"backpack",
	"tshirt",
	"vest",
	"torso",
	"shoes",
	"mask",
	"decals",
	"accessory",
	"hat",
	"glass",
	"ear",
	"watch",
	"bracelet",
}

---@param part table?
---@return table
local function copyClothingPart(part)
	part = type(part) == "table" and part or {}

	return {
		item = part.item or 0,
		texture = part.texture or 0,
	}
end

---@param data table?
---@return table
local function buildCompletedDataset(data)
	data = type(data) == "table" and data or {}

	local completedDataset = {}

	for category, part in pairs(Dataset) do
		completedDataset[category] = copyClothingPart(data[category] or part)
	end

	for category, part in pairs(data) do
		if not completedDataset[category] then
			completedDataset[category] = copyClothingPart(part)
		end
	end

	return completedDataset
end

---@param currentDataset table?
---@param backupDataset table?
---@return boolean
local function HasClothingDatasetChanged(currentDataset, backupDataset)
	currentDataset = type(currentDataset) == "table" and currentDataset or {}
	backupDataset = type(backupDataset) == "table" and backupDataset or {}

	for category, defaults in pairs(DEFAULT_DATASET) do
		local currentPart = currentDataset[category] or {}
		local backupPart = backupDataset[category] or {}

		local currentItem = tonumber(currentPart.item) or defaults.item
		local currentTexture = tonumber(currentPart.texture) or defaults.texture
		local backupItem = tonumber(backupPart.item) or defaults.item
		local backupTexture = tonumber(backupPart.texture) or defaults.texture

		if currentItem ~= backupItem or currentTexture ~= backupTexture then
			return true
		end
	end

	return false
end

---@param data table
---@param ped number
---@param canUseBlockedClothing boolean?
---@return table
local function filterVisualDataset(data, ped, canUseBlockedClothing)
	if not SkinshopClothingRulesPreview then
		return data
	end

	return SkinshopClothingRulesPreview.FilterDataset(data, { canUseBlockedClothing = canUseBlockedClothing, ped = ped })
end

---@param category string
---@param item any
---@param texture any
---@param ped number
---@return boolean
local function canUseVisualPart(category, item, texture, ped)
	if not SkinshopClothingRulesPreview then
		return true
	end

	return SkinshopClothingRulesPreview.CanUsePart(category, item, texture, {
		ped = ped,
	})
end

tableToLuaString = function(tbl, indent)
    indent = indent or "                    "  -- padrão de indentação para combinar com seu exemplo
    local str = "{\n"
    for k, v in pairs(tbl) do
        str = str .. indent .. "[\"" .. k .. "\"] = "
        if type(v) == "table" then
            local inner = {}
            for ik, iv in pairs(v) do
                table.insert(inner, ik .. " = " .. tostring(iv))
            end
            str = str .. "{ " .. table.concat(inner, ", ") .. " },\n"
        else
            str = str .. tostring(v) .. ",\n"
        end
    end
    return str .. indent:sub(1, -5) .. "}"
end



RegisterCommand('getpreset', function(source)
	lib.setClipboard(tableToLuaString(Dataset))	
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOP:APPLY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:Apply")
---@param canUseBlockedClothing boolean? isso serve para permitir o uso de componentes que são bloqueados na lista
AddEventHandler("skinshop:Apply",function(Table, forceEmptyUpdate --[[ Outros scripts dependem que esse evento salve as roupas novamente, mas no login a gente não tem essa necessidade! ]], canUseBlockedClothing )
	if nsdbg then
		sx.logger:debug( ('[nsdbg] evento skinshop:Apply ped=%s'):format( PlayerPedId() ) )
	end
	local nextDataset = buildCompletedDataset(Table)

	if SkinshopClothingRulesPreview and not canUseBlockedClothing then
		SkinshopClothingRulesPreview.Refresh(false)
	end

    LocalPlayer["state"]["Skinshop"] = nextDataset
	Dataset = nextDataset

	vSERVER.Update(forceEmptyUpdate and { } or Dataset)

	exports["skinshop"]:Apply(nil, nil, canUseBlockedClothing)
end)

exports('getDataset', function()
	return Dataset
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOPS
-----------------------------------------------------------------------------------------------------------------------------------------
local Skinshops = {
	{ 74.88,-1400.08,29.37 },
	{ 80.42,-1400.13,29.37 },
	{ -713.98,-146.54,37.41,130.4 },
	{ -708.26,-160.93,37.41,31.19 },
	{ -158.55,-296.5,39.73,158.75 },
	{ -165.56,-310.29,39.73,255.12 },
	{ -828.15,-1076.28,11.32,300.48 },
	{ -825.73,-1081.25,11.32,303.31 },
	{ -1198.52,-770.74,17.32,215.44 },
	{ -1457.27,-241.59,49.81,317.49 },
	{ -1445.59,-231.6,49.81,45.36 },
	{ 9.86,6516.37,31.88,136.07 },
	{ 6.33,6520.67,31.88,136.07 },
	{ 1693.52,4829.39,42.06,192.76 },
	{ 1688.13,4828.75,42.06,192.76 },
	{ 128.66,-218.03,54.56,68.04 },
	{ 614.17,2756.72,42.09,277.8 },
	{ 1190.18,2710.78,38.22,274.97 },
	{ 1190.29,2705.29,38.22,274.97 },
	{ -3167.44,1049.23,20.86,70.87 },
	{ -1105.96,2707.06,19.11,317.49 },
	{ -1102.86,2702.64,19.11,317.49 },
	{ 426.2,-800.22,29.49,184.26 },
	{ 420.57,-800.05,29.49,184.26 },
	
	-- { -1181.86,-900.55,13.99 }, -- BurgerShot
	{ 1841.13,3679.86,34.19 }, -- Departamento Sheriff
	{ -437.49,6009.62,36.99 }, -- Departamento Sheriff
	{ 361.77,-1593.19,25.9 }, -- Departamento State
	{ -256.56,6327.32,32.42 }, -- Hospital Norte
	{ -1816.23,-359.72,49.45,48.19 }, -- Hospital fem
	{ -1812.26,-355.6,49.47,48.19 }, -- Hospital masc
	{ 826.96,-956.12,22.09,127.56 }, -- Mecânica Sul
	{ 1372.7,6554.29,18.53,308.98 }, -- pier norte
	{ 1399.89,6584.21,18.53,0.0 }, -- pier norte
	{ -271.84,-1641.79,32.27,246.62 },

	----------------------------------------------------------------------------------
	-- mansões exclusivas
	----------------------------------------------------------------------------------
	{ -3219.67,783.5,14.09,300.48 },
	{ 8.27,529.1,170.64,206.93 },
	{ -817.34,267.31,82.8,76.54 },
	{ -788.0,338.5,243.38,272.13 },
	{ 1403.02,1154.43,114.33,348.67 },
	{ -60.03,994.01,239.52,45.36 },
	{ -2619.24,1711.28,146.32,198.43 },
	{ -2798.98,1436.23,97.32,42.52 },
	{ -56.55,837.08,235.71,42.52 },
	-- { -1047.4,299.78,71.66,280.63 },
	{ -2598.5,1889.46,163.75,25.52 },
	{ -2180.12,2663.74,4.53,85.04 },
	{ -2674.91,1307.4,152.0,263.63 },
	{ 2539.24,6148.24,168.11,255.12 },
	{ 180.52,1719.13,231.08,181.42 },
	{ 3266.75,-129.38,20.54,73.71 },
	{ -5863.51,1141.59,13.26,170.08 },
	{ -1721.76,381.91,89.73,116.23 },
	-- { -1981.35,-500.42,20.73,311.82 }, -- Mansao19
	{ -519.5,499.9,112.44,223.94 },
	{ -899.27,42.77,53.3,136.07 },
	{ -812.16,175.07,76.73,107.72 },
	{ -1468.2,-45.65,58.67,130.4 },
	{ -2093.2,-1012.04,5.88,70.87 },
	{ -1520.45,138.86,60.44,130.4 },
	{ -1415.45,6754.41,11.91,76.54 }, -- iate 02
	{ 2010.59,3379.98,51.59,82.21 }, -- Mansao13
	{ 236.71,752.68,200.09,127.56 }, -- mansao 26
	{ -221.49,584.41,185.7,269.3 }, -- mansao 27
	-- { -539.63,5008.08,163.83,147.41 }, -- mansao 28
	{ -2560.93,3762.39,17.04,266.46 }, -- mansao 29
	{ -3310.64,-1220.55,7.8,34.02 }, -- mansao 30
	{ -280.36,-722.16,125.46,255.12 }, -- mansao 31
	{ -696.5,631.43,159.18,79.38 }, -- mansao 32
	{ -637.46,941.53,243.95,357.17 }, -- mansao 34
	{ -846.35,-16.02,44.15,93.55 }, -- mansao 35
	{ -2012.59,307.09,95.72,209.77 }, -- mansao 36
	{ -754.54,820.54,216.99,201.26 }, -- mansao 37
	{ -1034.42,-1152.36,7.03,25.52 }, -- mansao 38
	{ -940.39,-939.38,7.03,303.31 }, -- mansao 39
	{ -996.6,-881.27,6.87,39.69 }, -- mansao 40
	{ -1113.83,-1074.83,6.87,28.35 }, -- mansao 41
	{ -991.87,-1098.38,7.03,147.41 }, -- mansao 42
	{ -1022.79,-992.8,7.01,127.56 }, -- mansao 43
	{ -1235.18,795.79,197.19,104.89 }, -- mansao 44
	{ -185.12,981.95,232.14,0.0 }, -- mansao 45
	{ -174.87,918.22,239.94,226.78 }, -- mansao 46
	{ -2700.13,-74.87,21.74,136.07 }, -- mansao 47
	{ 757.94,3423.13,62.68,85.04 }, -- mansao 48
	{ 1416.53,4718.05,140.24,70.87 }, -- mansao 50
	{ 1240.16,-853.16,79.11,263.63 }, -- mansao 51
	{ 3440.97,4940.38,39.85,48.19 }, -- mansao 52
	-- { 1180.03,873.25,147.54,96.38 }, -- mansao 53
	-- { 1609.15,-2631.75,56.88,306.15 }, -- mansao 55
	{ -1987.91,-227.47,89.62,243.78 }, -- mansao 56
	-- { -2983.99,-391.14,15.74,161.58 }, -- mansao 57
	{ -3093.44,1551.38,37.27,99.22 }, -- mansao 58
	{ 583.05,745.21,206.17,56.7 }, -- mansao 59
	{ -2311.43,4333.24,37.07,323.15 }, -- mansao 63
	{ -558.18,812.48,197.51,161.58 }, -- mansao 64
	-- { -2824.53,-33.45,37.05,155.91 }, -- mansao65
	{ -2801.11,3023.95,10.16,150.241 }, -- mansao66
	-- { 3501.53,5125.8,9.71,289.14 }, -- mansao67
	{ -825.99,-688.27,123.42,272.13 }, -- mansao68
	-- { -1305.56,716.17,195.34,121.89 }, -- mansao69
	-- { -3077.07,190.16,19.61,17.01 }, -- mansao70
	-- { -3010.0,3183.28,9.69,325.99 }, -- mansao72
	-- { -2873.74,3598.45,8.76,221.11 }, -- mansao73
	-- { -3937.92,-846.18,13.26,17.01 }, -- mansao74
	-- { -2037.01,-664.48,6.77,130.4 }, -- mansao75
	{ 2838.82,-698.54,12.22,107.72 }, -- mansao78
	-- { -939.4,400.4,77.8,138.9 }, -- mansao79
	-- { 618.45,2247.22,66.99,76.54 }, -- mansao80
	{ -1869.94,644.25,130.01,320.32 }, -- mansao81
	-- { -2249.44,469.85,178.24,184.26 }, -- mansao82
	-- { -2772.11,-210.0,17.32,226.78 }, -- mansao83
	-- { -332.99,6377.36,28.64,320.32 }, -- mansao84
	{ 574.78,6619.56,31.42,96.38 }, -- mansao86
	-- { -2932.5,-1800.17,13.26,240.95 }, -- mansao88
	-- { -669.34,6391.46,13.01,320.32 }, -- mansao91
	-- { 647.74,2066.43,115.76,184.26 }, -- mansao92
	-- { -3421.46,112.78,12.47,133.23 }, -- Paradise
	
	{ 3082.71,5465.73,23.59,206.93 }, -- Bunker
	{ 284.21,107.16,100.44,252.29 }, -- Cinema
	{ -3550.16,946.94,2.26,272.13 }, -- LuxuryPier
	{ 746.39,-555.2,33.63,102.05 }, -- medusa
	{ 5081.32,-5755.04,15.82,141.74 }, -- CayoPerico
	-- { -2566.45,-2204.01,5.05,161.58 }, -- Resort
	-- { 203.08,-1645.05,29.81,48.19 },  -- bombeiros
	{ 2132.22,4623.95,34.51,79.38 },  -- bloco 01
	{ 2124.68,4596.18,34.51,65.2 },  -- bloco 02
	{ 2106.89,4573.07,34.51,39.69 },  -- bloco 03
	{ 2081.73,4557.74,34.51,31.19 },  -- bloco 04
	{ 2055.95,4550.21,34.51,17.01 },  -- bloco 05
	-- { 1180.61,873.26,147.51,264.94 },  -- mansao53
	-- { -817.45,267.30,82.80,72.27 },  -- mansao03
	{ -1691.06,-1127.32,14.0,68.04 },
}

if cityName == "Santa" then
	Skinshops[#Skinshops+1] = { -2566.45,-2204.01,5.05,161.58 } -- Resort
	Skinshops[#Skinshops+1] = { -1226.24,-1737.73,4.53,138.9 } -- QG_338
	Skinshops[#Skinshops+1] = { -1236.58,795.1,197.19,198.43 } -- QG_271
	Skinshops[#Skinshops+1] = { 676.73,909.14,247.57,164.41 } -- QG_302
	Skinshops[#Skinshops+1] = { 688.13,914.25,247.57,107.72 } -- QG_302
	Skinshops[#Skinshops+1] = { -306.58,2768.66,64.84,93.55 } -- QG_216
	Skinshops[#Skinshops+1] = { -417.98,4372.91,61.35,184.26 } -- mansao94
	Skinshops[#Skinshops+1] = { -1981.52,-500.39,20.73,45.36 } -- Mansao221
	Skinshops[#Skinshops+1] = { -800.92,174.43,76.73,192.76 } -- Mansao240
	Skinshops[#Skinshops+1] = { -812.08,175.14,76.73,76.54 } -- Mansao240
	Skinshops[#Skinshops+1] = { -1140.94,375.14,74.93,150.24 } -- Mansao230
	Skinshops[#Skinshops+1] = { -1050.32,-2011.89,13.16,138.47 } -- mecanica
	Skinshops[#Skinshops+1] = { 1133.63,-1518.37,34.84,66.08 } -- paramedic
	Skinshops[#Skinshops+1] = { -2619.09,1712.25,146.32,206.93 } -- Mansao183
	Skinshops[#Skinshops+1] = { -2614.07,1698.6,142.38,297.64 } -- Mansao183
	Skinshops[#Skinshops+1] = { -2121.79,-2615.52,11.44,76.54 } -- mansao182
	Skinshops[#Skinshops+1] = { -2135.78,-2617.47,11.42,68.04 } -- mansao182
	Skinshops[#Skinshops+1] = { -2158.03,-2606.74,6.27,161.58 } -- mansao182
	Skinshops[#Skinshops+1] = { -2039.47,-2091.86,27.72,311.82 } -- QG_370
	Skinshops[#Skinshops+1] = { -2046.9,-2090.72,27.72,130.4 } -- QG_370
	Skinshops[#Skinshops+1] = { -2035.89,-2132.63,27.72,36.86 } -- QG_370
	-- Skinshops[#Skinshops+1] = { -2587.87,1874.95,167.3,36.86 } -- QG_366
	-- Skinshops[#Skinshops+1] = { -2591.49,1873.94,163.8,289.14 } -- QG_366
	Skinshops[#Skinshops+1] = { 1997.74,4296.12,43.27,28.35 } -- mansao118
	Skinshops[#Skinshops+1] = { -2772.55,-212.18,22.09,45.36 } -- Mansao83
	Skinshops[#Skinshops+1] = { 90.07,6516.15,31.26,130.4 } -- QG_327
	Skinshops[#Skinshops+1] = { -256.9,6328.01,32.42,28.35 } -- hp norte
	Skinshops[#Skinshops+1] = { -3068.65,3456.45,10.03,255.12 } -- mansao93
	-- Skinshops[#Skinshops+1] = { -1229.48,785.58,191.43,14.18 } -- Mansao157
	-- Skinshops[#Skinshops+1] = { -1240.64,792.89,194.94,306.15 } -- mansao157
	Skinshops[#Skinshops+1] = { -554.14,1192.33,334.08,280.63 } -- AlphaA1
	Skinshops[#Skinshops+1] = { -575.98,1193.24,334.08,184.26 } -- AlphaA2
	Skinshops[#Skinshops+1] = { -604.07,1192.34,334.08,269.3 } -- AlphaA3
	Skinshops[#Skinshops+1] = { -628.87,1192.29,334.08,283.47 } -- AlphaA4
	Skinshops[#Skinshops+1] = { -543.57,1251.58,334.08,85.04 } -- AlphaB1
	Skinshops[#Skinshops+1] = { -568.49,1251.75,334.08,110.56 } -- AlphaB2
	Skinshops[#Skinshops+1] = { -593.38,1251.64,334.08,102.05 } -- AlphaB3
	Skinshops[#Skinshops+1] = { -618.02,1251.67,334.08,87.88 } -- AlphaB4
	Skinshops[#Skinshops+1] = { -2680.41,1156.48,167.64,90.71 } -- Alpha2A1
	Skinshops[#Skinshops+1] = { -2705.23,1155.46,167.64,93.55 } -- Alpha2A2
	Skinshops[#Skinshops+1] = { -2730.14,1154.5,167.64,96.38 } -- Alpha2A3
	Skinshops[#Skinshops+1] = { -2755.1,1153.55,167.64,90.71 } -- Alpha2A4
	Skinshops[#Skinshops+1] = { -2671.39,1216.28,167.64,277.8 } -- Alpha2B1
	Skinshops[#Skinshops+1] = { -2696.07,1215.24,167.64,272.13 } -- Alpha2B2
	Skinshops[#Skinshops+1] = { -2721.03,1214.27,167.64,266.46 } -- Alpha2B3
	Skinshops[#Skinshops+1] = { -2746.06,1213.4,167.64,274.97 } -- Alpha2B4
	Skinshops[#Skinshops+1] = { -300.90,197.26,88.17,188.71 } -- QG_268
	Skinshops[#Skinshops+1] = { 4660.11,-4778.71,16.07,39.69 } -- mansao153
	Skinshops[#Skinshops+1] = { -1514.82,-1468.04,6.39,206.93 } -- Atlantis
	Skinshops[#Skinshops+1] = { -846.01,5620.24,32.47,59.53 } -- mansao151
	Skinshops[#Skinshops+1] = { -3803.84,287.78,158.81,175.75 } -- mansao133
	Skinshops[#Skinshops+1] = { -3541.55,4586.17,14.05,25.52 } -- mansao138
	Skinshops[#Skinshops+1] = { -3143.94,2135.77,6.53,321.09 } -- mansao136
	Skinshops[#Skinshops+1] = { -2325.15,2331.08,36.87,102.05 } -- mansao135
	Skinshops[#Skinshops+1] = { -1695.24,-1130.01,14.0,147.41 }
	Skinshops[#Skinshops+1] = { -2320.02,-660.38,23.54,127.56 } -- QG_225 / mansao156
	-- Skinshops[#Skinshops+1] = { -1385.11,-597.63,30.31,306.15 } -- QG_224
	Skinshops[#Skinshops+1] = { 461.87,-1321.78,29.44,229.61 } -- mansao127
	Skinshops[#Skinshops+1] = { -1519.41,109.96,60.79,226.78 } -- mansao25
	Skinshops[#Skinshops+1] = { -780.21,-1211.9,10.38,141.74 } -- Tatica
	Skinshops[#Skinshops+1] = { -437.84,6012.35,36.99,357.17 } -- civil
	Skinshops[#Skinshops+1] = { -1699.29,-1126.98,14.0,226.78 }
	Skinshops[#Skinshops+1] = { -1136.33,-2076.44,21.28,223.94 } -- mecanica
	-- Skinshops[#Skinshops+1] = { -1812.30,-1402.18,5.88,272.24 } -- mansao121
	Skinshops[#Skinshops+1] = { -1957.18,-1245.60,5.88,351.21 } -- mansao122
	Skinshops[#Skinshops+1] = { 162.64,-1854.10,32.18,246.01 } -- mansao115
	Skinshops[#Skinshops+1] = { 3737.24,4589.85,78.0,45.36 } -- mansao109
	Skinshops[#Skinshops+1] = { 791.97,5736.84,702.57,76.54 } -- mansao90
	Skinshops[#Skinshops+1] = { 2651.39,1801.94,33.38,181.42 } -- QG_210
	Skinshops[#Skinshops+1] = { 1834.26,2575.59,46.01,167.09 }
	Skinshops[#Skinshops+1] = { -2349.97,3266.35,32.81,154.02 }
	Skinshops[#Skinshops+1] = { 2023.49,-1600.29,258.50,347.38 } -- mansao101
	Skinshops[#Skinshops+1] = { 63.77,-1800.41,165.87,323.01 } -- mansao106
	Skinshops[#Skinshops+1] = { 4083.84,4627.84,12.98,211.98 } -- QG_301
	-- Skinshops[#Skinshops+1] = { 523.28,-1986.00,25.36,285.60 } -- mansao100
	Skinshops[#Skinshops+1] = { 129.47,-99.07,49.58,207.22 } -- mansao98
	Skinshops[#Skinshops+1] = { -127.16,6635.97,31.67,38.87 } -- mansao77
	Skinshops[#Skinshops+1] = { -1042.19,-2786.41,21.33,337.33 } -- aeroporto
	Skinshops[#Skinshops+1] = { -308.82,-1313.31,31.29,5.67 } -- mecanica
	Skinshops[#Skinshops+1] = { -632.41,-134.04,43.22,93.55 } -- Bombeiros
	Skinshops[#Skinshops+1] = { 457.64,-990.77,30.68,11.34 } -- dp praça
	Skinshops[#Skinshops+1] = { 1149.96,-1582.44,35.28,175.75 } -- hp
	Skinshops[#Skinshops+1] = { -951.75,-2042.66,9.4,226.78} -- dp principal
	Skinshops[#Skinshops+1] = { 2517.92,-346.08,101.89,36.86 } -- dp
	Skinshops[#Skinshops+1] = { 2508.49,-442.21,106.91,76.54 } -- dp
	Skinshops[#Skinshops+1] = { 2612.27,5333.94,47.57,59.53 } -- prf
	Skinshops[#Skinshops+1] = { -2141.76,-574.83,18.25,198.43 } -- mansao 49
	Skinshops[#Skinshops+1] = { -3690.06,620.68,4.6,28.35 } -- mansao54
	Skinshops[#Skinshops+1] = { 1076.15,3266.02,38.6,226.78 } -- Verde
	Skinshops[#Skinshops+1] = { -2305.71,-251.61,48.14,127.56 } -- Gang4
	Skinshops[#Skinshops+1] = { 1502.54,1517.99,108.16,348.67 } -- Marrom
	Skinshops[#Skinshops+1] = { 1165.34,-142.11,59.55,226.78 } -- Vermelho
	Skinshops[#Skinshops+1] = { 2133.61,-15.7,227.22,45.36 } -- Rosa
	Skinshops[#Skinshops+1] = { 2742.43,2716.88,55.84,48.19 } -- Sindicato
	Skinshops[#Skinshops+1] = { -458.91,-1264.9,25.48,51.03 } -- Afetados
	Skinshops[#Skinshops+1] = { 875.42,1860.9,142.5,226.78 } -- Metgala
	Skinshops[#Skinshops+1] = { -299.65,-1667.63,35.62,337.33 } -- Groove
	Skinshops[#Skinshops+1] = { 2356.32,5512.44,51.93,317.49 } -- Amarelo
	Skinshops[#Skinshops+1] = { 2115.64,3886.09,33.23,215.44 } -- Roxo
	Skinshops[#Skinshops+1] = { 358.11,-2033.39,22.39,48.19 } -- Vagos
	Skinshops[#Skinshops+1] = { 89.54,-1989.74,20.41,314.65 } -- Ballas
	Skinshops[#Skinshops+1] = { 103.51,3613.09,40.49,175.75 } -- Laranja
	Skinshops[#Skinshops+1] = { -291.24,216.89,78.82,277.8 } -- Bahamas
	Skinshops[#Skinshops+1] = { 963.86,18.02,75.74,144.57 } -- Bellagio
	Skinshops[#Skinshops+1] = { -324.23,-140.2,39.01,62.37 } -- Redline
	Skinshops[#Skinshops+1] = { -203.27,-1330.04,34.9,127.56 } -- Undergrounds
	Skinshops[#Skinshops+1] = { 747.78,-308.18,59.8,306.15 } -- Franca
	Skinshops[#Skinshops+1] = { 1382.88,-2093.85,47.21,31.19 } -- fazer
	Skinshops[#Skinshops+1] = { 1402.74,1154.66,114.33,266.46 } -- fazendinha
	Skinshops[#Skinshops+1] = { 2361.62,5647.1,92.71,141.74 } -- Topgear
	Skinshops[#Skinshops+1] = { -1149.56,-1554.59,7.63,153.08 } -- bandoleros
	Skinshops[#Skinshops+1] = { 556.33,-2773.46,6.08,59.53 } -- Gang5
	Skinshops[#Skinshops+1] = { 100.44,1228.13,207.17,130.4 } -- Mayans
	Skinshops[#Skinshops+1] = { 1028.6,-2550.72,32.28,351.5 } -- soa
	Skinshops[#Skinshops+1] = { -641.82,-1240.5,11.54,42.52 } -- hellsangels
	Skinshops[#Skinshops+1] = { 413.04,6468.02,29.82,274.97 } -- Pinkmans
	Skinshops[#Skinshops+1] = { 3234.18,5120.17,20.15,116.23 }
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { 1065.13,-1990.52,31.76,238.12 } -- gringa
	Skinshops[#Skinshops+1] = { -2294.76,357.76,174.6,297.64 } -- bloods
	Skinshops[#Skinshops+1] = { -3025.46,59.49,11.95,331.66 } -- Tropadu7
	Skinshops[#Skinshops+1] = { -603.37,-915.38,23.88,263.63 } -- crips
	Skinshops[#Skinshops+1] = { -459.91,1545.42,393.22,334.49 } -- Tribo	
	Skinshops[#Skinshops+1] = { 355.76,-2729.82,1.72,257.96 } -- warlocks
	Skinshops[#Skinshops+1] = { -1814.54,447.96,127.91,351.5 } -- mexicana
	Skinshops[#Skinshops+1] = { 2169.34,5111.07,62.97,79.38 } -- russia
	Skinshops[#Skinshops+1] = { 2195.41,5091.26,62.97,82.21 } -- russia
	Skinshops[#Skinshops+1] = { 2142.45,5139.16,59.87,184.26 } -- russia
	Skinshops[#Skinshops+1] = { -1491.07,845.77,181.59,87.88 } -- irlandesa
	Skinshops[#Skinshops+1] = { -321.6,1967.37,153.79,280.63 } -- triade
	Skinshops[#Skinshops+1] = { 420.53,-1483.85,33.8,116.23 } -- italiana
	Skinshops[#Skinshops+1] = { -613.39,-1625.22,33.01,87.88 } -- overdrive
	Skinshops[#Skinshops+1] = { -777.34,-2592.59,17.66,51.03 } -- Outlaws 
	Skinshops[#Skinshops+1] = { 956.47,-2390.61,22.33,22.68 } -- Topgear 
	Skinshops[#Skinshops+1] = { 3227.02,5121.41,20.15,297.64 } -- china
	Skinshops[#Skinshops+1] = { 576.28,-3107.89,6.07,187.09 } -- israel
	Skinshops[#Skinshops+1] = { -1671.96,432.73,108.6,277.8 } -- playboy
	Skinshops[#Skinshops+1] = { -678.46,868.62,225.23,266.46 }
	Skinshops[#Skinshops+1] = { 451.03,-977.31,30.68,357.17 }
	Skinshops[#Skinshops+1] = { -2004.09,4490.88,57.29,133.23 } -- QG_01
	Skinshops[#Skinshops+1] = { 1795.9,442.8,172.34,73.71 } -- sinaloa
	Skinshops[#Skinshops+1] = { 1252.95,-1720.72,56.45,65.2 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1289.66,-1762.54,54.21,22.68 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 876.22,1860.49,142.5,223.94 } -- Azuis
	Skinshops[#Skinshops+1] = { 514.2,370.01,151.73,104.89 } -- roxos
	Skinshops[#Skinshops+1] = { 2226.68,3453.87,61.33,170.08 } -- cinzas
	Skinshops[#Skinshops+1] = { 932.68,1060.22,271.87,223.94 } -- marrons
	Skinshops[#Skinshops+1] = { 1043.45,885.2,220.36,51.03 } -- marrons
	Skinshops[#Skinshops+1] = { 1403.4,-2397.56,65.7,334.49 } -- rosas
	Skinshops[#Skinshops+1] = { 1451.9,-2440.5,66.81,277.8 } -- rosas
	Skinshops[#Skinshops+1] = { 1338.0,-792.43,71.51,343.0 } -- brancos
	Skinshops[#Skinshops+1] = { 1346.33,-705.11,67.74,73.71 } -- brancos
	Skinshops[#Skinshops+1] = { 1251.7,-265.25,77.91,107.72 } -- barragem
	Skinshops[#Skinshops+1] = { -1555.78,340.34,87.25,243.78 } -- playboy
	Skinshops[#Skinshops+1] = { 2226.14,3453.91,61.33,187.09 } -- cinzas
	Skinshops[#Skinshops+1] = { -1818.65,448.0,127.91,198.43 } -- mansao33
	Skinshops[#Skinshops+1] = { -216.48,-282.14,29.25,99.22 }
	Skinshops[#Skinshops+1] = { 537.74,454.51,172.49,257.96 } -- Roxos
	Skinshops[#Skinshops+1] = { -132.29,869.99,232.68,144.57 }
	Skinshops[#Skinshops+1] = { -427.29,1608.35,359.86,85.04 }
	Skinshops[#Skinshops+1] = { 48.44,800.47,200.68,136.07 }
	Skinshops[#Skinshops+1] = { -2779.14,2509.53,3.98,0.0 } -- Noxus
	Skinshops[#Skinshops+1] = { -1540.78,141.86,60.44,48.19 } -- LaMafia
	Skinshops[#Skinshops+1] = { 1099.2,3267.41,37.73,45.36 } -- cartel
	Skinshops[#Skinshops+1] = { 1885.56,-1028.46,79.21,240.95 } -- AlcateiaHsT
	Skinshops[#Skinshops+1] = { -149.7,-1606.14,35.03,337.33 }
	Skinshops[#Skinshops+1] = { -1046.14,309.93,66.99,206.93 } -- inglaterra
	Skinshops[#Skinshops+1] = { -414.31,1593.54,358.67,102.05 }
	Skinshops[#Skinshops+1] = { 886.14,353.00,112.56,225.05 } -- qg_17
	Skinshops[#Skinshops+1] = { 2742.47,3500.22,61.3,357.17} -- Kraken
	Skinshops[#Skinshops+1] = { 134.68,-369.75,50.33,17.01 } -- Big
	Skinshops[#Skinshops+1] = { 883.73,-2100.55,30.46,175.75 } -- CarClube
	Skinshops[#Skinshops+1] = { 414.94,-23.43,91.93,56.7 } -- Callisto
	Skinshops[#Skinshops+1] = { 736.58,-806.95,16.28,357.17 } -- Arcade
	Skinshops[#Skinshops+1] = { -337.81,-166.57,44.58,272.13 } -- Virtude
	Skinshops[#Skinshops+1] = { -2022.42,4435.69,53.09,345.83 } -- Banzas	
	Skinshops[#Skinshops+1] = { -339.2,-1523.7,29.34,22.68 } -- Dixavas
	Skinshops[#Skinshops+1] = { 5026.55,-5760.97,15.77,232.45 } -- Caribe
	Skinshops[#Skinshops+1] = { 3088.32,5091.99,23.25,73.71 } -- qg_80
	Skinshops[#Skinshops+1] = { -1179.62,302.46,73.67,102.05 } -- qg_82
	Skinshops[#Skinshops+1] = { -3337.02,537.67,17.44,127.56 } -- mansao 60
	Skinshops[#Skinshops+1] = { -1226.24,-1737.73,4.53,138.9 } -- qg_83
	Skinshops[#Skinshops+1] = { -2423.52,1790.06,185.48,39.69 } -- qg_84
	Skinshops[#Skinshops+1] = { -878.0,-1434.81,7.53,201.26 } -- qg_85
	-- Skinshops[#Skinshops+1] = { -3311.2,566.5,17.44,144.57 } -- qg_90
	-- Skinshops[#Skinshops+1] = { -1125.91,932.85,209.76,311.82 } -- mansao44
	Skinshops[#Skinshops+1] = { 3082.44,5458.49,31.8,28.35 }
	Skinshops[#Skinshops+1] = { 1175.57,873.79,144.03,181.42 } -- Mansao242
	Skinshops[#Skinshops+1] = { 659.2,2091.06,110.28,269.3 } -- Mansao245
	Skinshops[#Skinshops+1] = { 652.95,2097.0,110.27,351.5 } -- Mansao245
	Skinshops[#Skinshops+1] = { 647.27,2064.51,115.27,354.34 } -- Mansao245
	Skinshops[#Skinshops+1] = { 648.2,2068.0,115.27,187.09 } -- Mansao245
	Skinshops[#Skinshops+1] = { -1118.49,921.04,209.39,320.32 } -- Mansao260
	Skinshops[#Skinshops+1] = { -1127.23,931.68,209.83,300.48 } -- Mansao260
	Skinshops[#Skinshops+1] = { -793.02,926.42,243.9,104.89 } -- Mansao261
	Skinshops[#Skinshops+1] = { -762.01,927.25,243.9,104.89 } -- Mansao261
	Skinshops[#Skinshops+1] = { -749.1,943.05,243.31,113.39 } -- Mansao261
	Skinshops[#Skinshops+1] = { 325.02,817.44,197.06,39.69 } -- Mansao251
	Skinshops[#Skinshops+1] = { 356.3,832.83,201.37,116.23 } -- Mansao251
	Skinshops[#Skinshops+1] = { -1649.68,722.83,207.57,175.75 } -- Mansao249
	Skinshops[#Skinshops+1] = { -1644.44,701.1,206.36,87.88 } -- Mansao249
	Skinshops[#Skinshops+1] = { 380.68,2361.02,80.24,235.28 } -- Mansao268
	Skinshops[#Skinshops+1] = { 368.93,2384.59,80.24,317.49 } -- Mansao268
	Skinshops[#Skinshops+1] = { 368.08,2383.43,75.25,328.82 } -- Mansao268
	Skinshops[#Skinshops+1] = { 359.58,2381.64,75.23,51.03 } -- Mansao268
	Skinshops[#Skinshops+1] = { 2314.46,-962.53,162.99,274.97 } -- Mansao278
	-- Skinshops[#Skinshops+1] = { -2245.85,507.24,179.2,85.04 } -- Mansao262
	Skinshops[#Skinshops+1] = { -1017.01,1134.35,225.37,82.21 } -- Alpha3B1
	Skinshops[#Skinshops+1] = { -1024.91,1094.09,225.37,82.21 } -- Alpha3B2
	Skinshops[#Skinshops+1] = { -1032.56,1053.6,225.37,79.38 } -- Alpha3B3
	Skinshops[#Skinshops+1] = { -973.09,1019.16,225.37,82.21 } -- Alpha3B4
	Skinshops[#Skinshops+1] = { -965.32,1059.39,225.37,87.88 } -- Alpha3B5
	Skinshops[#Skinshops+1] = { -957.27,1099.48,225.37,68.04 } -- Alpha3B6
	-- Skinshops[#Skinshops+1] = { -2239.97,487.1,179.2,269.3 } -- Mansao262
	Skinshops[#Skinshops+1] = { 549.72,746.09,206.17,53.86 } -- QG_102
	-- Skinshops[#Skinshops+1] = { 2839.68,-704.57,12.22,99.22 } -- QG_120
	Skinshops[#Skinshops+1] = { -1285.17,-1722.11,6.15,127.73 } -- 
	Skinshops[#Skinshops+1] = { 832.61,-1291.74,19.85,11.36 } -- civil
	-- Skinshops[#Skinshops+1] = { -1379.81,-636.05,30.31,212.6 } -- PuroPrime
	Skinshops[#Skinshops+1] = { 636.81,1256.87,360.77,303.31 } -- Mansao283
	Skinshops[#Skinshops+1] = { 691.9,1247.16,367.92,195.6 } -- Mansao283
	Skinshops[#Skinshops+1] = { 692.72,1245.51,361.01,260.79 } -- Mansao283

elseif cityName == "CidadeNobre" then
	-- remove loja de roupas civil do Skinshops base (só Nobre)
	for i = #Skinshops, 1, -1 do
		local s = Skinshops[i]
		if s[1] == -437.49 and s[2] == 6009.62 then
			table.remove(Skinshops, i)
		end
	end
	Skinshops[#Skinshops+1] = { -3001.96,3194.76,9.69,229.61 } -- Mansao233
	Skinshops[#Skinshops+1] = { -3011.16,3182.68,9.69,240.95 } -- Mansao233
	Skinshops[#Skinshops+1] = { -2099.56,4973.24,51.58,34.02 } -- Mansao232
	Skinshops[#Skinshops+1] = { -2099.05,4964.56,51.58,124.73 } -- Mansao232
	Skinshops[#Skinshops+1] = { -2075.73,4982.67,56.58,320.32 } -- Mansao232
	Skinshops[#Skinshops+1] = { -2072.82,4984.77,56.58,133.23 } -- Mansao232
	Skinshops[#Skinshops+1] = { -2100.68,4974.62,56.58,36.86 } -- Mansao232
	Skinshops[#Skinshops+1] = { -817.26,267.18,82.8,263.63 } -- Mansao229
	Skinshops[#Skinshops+1] = { -826.33,263.33,82.8,345.83 } -- Mansao229
	Skinshops[#Skinshops+1] = { -2566.45,-2204.01,5.05,161.58 } -- Resort
	Skinshops[#Skinshops+1] = { -1691.44,-1127.7,14.0,311.82 } -- PIER
	-- Skinshops[#Skinshops+1] = { 2370.44,4349.29,40.17,45.36 } -- mansao190
	-- Skinshops[#Skinshops+1] = { 2368.36,4315.31,45.31,17.01 } -- mansao190
	Skinshops[#Skinshops+1] = { 83.84,-1807.79,29.29,132.64 } -- mecanica
	Skinshops[#Skinshops+1] = { -300.90,197.26,88.17,188.71 } -- QG_281
	-- Skinshops[#Skinshops+1] = { -1627.99,-1791.27,15.84,266.46 } -- Mansao184
	-- Skinshops[#Skinshops+1] = { -1624.39,-1766.62,13.11,170.08 } -- Mansao184
	Skinshops[#Skinshops+1] = { -1891.66,-46.6,104.92,42.52 } -- QG_372
	Skinshops[#Skinshops+1] = { -1910.41,-56.49,104.89,308.98 } -- QG_372
	Skinshops[#Skinshops+1] = { -1135.8,121.68,65.6,351.5 } -- Mansao177
	Skinshops[#Skinshops+1] = { 801.71,6810.33,13.28,212.6 } -- QG_347
	-- Skinshops[#Skinshops+1] = { -809.53,262.13,86.19,99.22 } -- QG_346
	Skinshops[#Skinshops+1] = { 3962.71,-631.17,12.86,255.12 } -- QG_325
	Skinshops[#Skinshops+1] = { 248.7,3582.51,41.62,155.91 } -- mansao171
	Skinshops[#Skinshops+1] = { -3068.65,3456.45,10.03,255.12 } -- mansao93
	Skinshops[#Skinshops+1] = { -3419.32,4566.12,32.45,345.83 } -- QG_307
	Skinshops[#Skinshops+1] = { -2590.9,-524.42,17.81,99.22 } -- QG_296
	Skinshops[#Skinshops+1] = { 1030.83,7300.61,12.37,269.3 } -- mansao162
	Skinshops[#Skinshops+1] = { -554.14,1192.33,334.08,280.63 } -- AlphaA1
	Skinshops[#Skinshops+1] = { -575.98,1193.24,334.08,184.26 } -- AlphaA2
	Skinshops[#Skinshops+1] = { -604.07,1192.34,334.08,269.3 } -- AlphaA3
	Skinshops[#Skinshops+1] = { -628.87,1192.29,334.08,283.47 } -- AlphaA4
	Skinshops[#Skinshops+1] = { -543.57,1251.58,334.08,85.04 } -- AlphaB1
	Skinshops[#Skinshops+1] = { -568.49,1251.75,334.08,110.56 } -- AlphaB2
	Skinshops[#Skinshops+1] = { -593.38,1251.64,334.08,102.05 } -- AlphaB3
	Skinshops[#Skinshops+1] = { -618.02,1251.67,334.08,87.88 } -- AlphaB4
	Skinshops[#Skinshops+1] = { -2680.41,1156.48,167.64,90.71 } -- Alpha2A1
	Skinshops[#Skinshops+1] = { -2705.23,1155.46,167.64,93.55 } -- Alpha2A2
	Skinshops[#Skinshops+1] = { -2730.14,1154.5,167.64,96.38 } -- Alpha2A3
	Skinshops[#Skinshops+1] = { -2755.1,1153.55,167.64,90.71 } -- Alpha2A4
	Skinshops[#Skinshops+1] = { -2671.39,1216.28,167.64,277.8 } -- Alpha2B1
	Skinshops[#Skinshops+1] = { -2696.07,1215.24,167.64,272.13 } -- Alpha2B2
	Skinshops[#Skinshops+1] = { -2721.03,1214.27,167.64,266.46 } -- Alpha2B3
	Skinshops[#Skinshops+1] = { -2746.06,1213.4,167.64,274.97 } -- Alpha2B4
	Skinshops[#Skinshops+1] = { -1017.01,1134.35,225.37,82.21 } -- Alpha3B1
	Skinshops[#Skinshops+1] = { -1024.91,1094.09,225.37,82.21 } -- Alpha3B2
	Skinshops[#Skinshops+1] = { -1032.56,1053.6,225.37,79.38 } -- Alpha3B3
	Skinshops[#Skinshops+1] = { -973.09,1019.16,225.37,82.21 } -- Alpha3B4
	Skinshops[#Skinshops+1] = { -965.32,1059.39,225.37,87.88 } -- Alpha3B5
	Skinshops[#Skinshops+1] = { -957.27,1099.48,225.37,68.04 } -- Alpha3B6
	Skinshops[#Skinshops+1] = { -793.02,926.42,243.9,104.89 } -- Mansao243
	Skinshops[#Skinshops+1] = { -762.01,927.25,243.9,104.89 } -- Mansao243
	Skinshops[#Skinshops+1] = { -749.1,943.05,243.31,113.39 } -- Mansao243
	Skinshops[#Skinshops+1] = { -2234.75,3439.01,35.03,269.3 } -- Exercito
	Skinshops[#Skinshops+1] = { 225.21,2707.34,52.12,34.02 } -- mansao152
	Skinshops[#Skinshops+1] = { 2203.64,4625.27,38.82,175.75 } -- QG_298
	Skinshops[#Skinshops+1] = { -119.9,7117.43,17.3,99.22 } -- mansao148
	Skinshops[#Skinshops+1] = { 483.88,1464.68,362.47,25.52 } -- mansao98
	Skinshops[#Skinshops+1] = { -2451.86,-1038.83,16.93,170.08} -- mansao105
	Skinshops[#Skinshops+1] = { -1707.12,-91.01,89.83,45.36 } -- mansao139
	Skinshops[#Skinshops+1] = { -5863.43,1141.37,13.26,315.64 } -- mansao17
	Skinshops[#Skinshops+1] = { 1327.96,3746.93,41.69,90.71 } -- QG_239
	Skinshops[#Skinshops+1] = { 1671.22,3592.45,35.89,193.35 } -- Bombeiros
	Skinshops[#Skinshops+1] = { -1691.38,-1136.25,14.0,138.9 } -- pier
	-- Skinshops[#Skinshops+1] = { -973.91,1085.65,226.35,261.37 } -- mansao126
	Skinshops[#Skinshops+1] = { -1132.90,988.99,204.10,115.35 } -- mansao131
	Skinshops[#Skinshops+1] = { -306.58,2768.66,64.84,93.55 } -- QG_216
	Skinshops[#Skinshops+1] = { 2649.51,1799.6,33.38,90.71 } -- QG_223
	-- Skinshops[#Skinshops+1] = { -2099.39,4973.11,51.58,215.44 } -- QG_230
	Skinshops[#Skinshops+1] = { -1157.93,7304.06,21.25,0.0 } -- mansao125
	Skinshops[#Skinshops+1] = { 1316.90,-2485.82,51.84,139.13 } -- QG_133
	Skinshops[#Skinshops+1] = { -3803.9,288.08,158.81,175.75 } -- QG_173
	Skinshops[#Skinshops+1] = { -2715.16,1336.3,156.13,150.24 } -- mansao117
	Skinshops[#Skinshops+1] = { 699.49,3846.49,49.99,357.17 } -- QG_192
	-- Skinshops[#Skinshops+1] = { 791.97,5736.84,702.57,76.54 } -- mansao90
	Skinshops[#Skinshops+1] = { 282.12,6471.34,46.05,39.69 } -- mansao110
	Skinshops[#Skinshops+1] = { -938.38,5846.29,18.03,161.58 } -- mansao111
	Skinshops[#Skinshops+1] = { -2439.03,-1211.55,23.34,308.98 } -- mansao112
	-- Skinshops[#Skinshops+1] = { -788.09,933.37,243.43,113.39 } -- mansao54
	Skinshops[#Skinshops+1] = { -3077.26,1881.28,33.95,79.38 } -- mansao55
	Skinshops[#Skinshops+1] = { 2026.40,4290.20,43.25,193.02 } -- QG_428
	Skinshops[#Skinshops+1] = { 42.9,6511.56,31.53,42.52 } -- QG_181
	Skinshops[#Skinshops+1] = { 725.69,-791.85,16.47,179.15 } -- QG_185
	Skinshops[#Skinshops+1] = { 1678.57,7055.46,11.77,141.25 }
	Skinshops[#Skinshops+1] = { 1104.53,196.11,-49.44,45.36 } -- CassinoDiamond
	Skinshops[#Skinshops+1] = { 1584.33,4088.21,43.50,259.14 } -- QG_416
	Skinshops[#Skinshops+1] = { 136.79,-346.87,50.33,158.75 } -- QG_168
	Skinshops[#Skinshops+1] = { -404.72,4373.04,62.82,354.34 } -- mansao94
	Skinshops[#Skinshops+1] = { -142.82,6494.48,38.84,39.69 } -- mansao102
	Skinshops[#Skinshops+1] = { 2023.49,-1600.29,258.50,347.38 } -- mansao101
	Skinshops[#Skinshops+1] = { 368.92,2384.33,80.24,137.06 } -- mansao49
	Skinshops[#Skinshops+1] = { -126.17,6619.03,33.85,311.82 } -- mansao51
	-- Skinshops[#Skinshops+1] = { -1474.76,-1759.03,14.35,3.21 } -- mansao70
	Skinshops[#Skinshops+1] = { -2766.96,-941.86,16.05,64.63 } -- mansao71
	Skinshops[#Skinshops+1] = { -1141.65,374.78,74.97,226.04 } -- Mansao74
	Skinshops[#Skinshops+1] = { -1379.81,-636.05,30.31,212.6 } -- PuroPrime
	Skinshops[#Skinshops+1] = { -3090.98,3367.52,17.32,180.20 } -- mansao66
	Skinshops[#Skinshops+1] = { -3536.63,4623.20,6.72,287.43 } -- mansao96
	-- Skinshops[#Skinshops+1] = { 1036.84,3678.09,39.05,179.56 } -- mansao16
	Skinshops[#Skinshops+1] = { 93.40,6517.33,31.26,305.00 } -- QG_175
	-- Skinshops[#Skinshops+1] = { 2006.75,3354.94,51.60,83.44 } -- QG_150
	-- Skinshops[#Skinshops+1] = { 102.37,-1311.13,21.13,48.19 } -- QG_143
	Skinshops[#Skinshops+1] = { -2189.20,4283.77,49.18,196.14 } -- QG_132
	Skinshops[#Skinshops+1] = { 958.86,-966.6,42.95,348.67 } -- mecanica
	Skinshops[#Skinshops+1] = { 1200.19,-1486.81,34.69,359.46 } -- Bombeiros
	Skinshops[#Skinshops+1] = { 1219.15,-1495.01,42.47,300.09 } -- Bombeiros
	-- Skinshops[#Skinshops+1] = { 1150.65,-1583.05,35.28,138.9 } -- hp
	Skinshops[#Skinshops+1] = { -914.78,-714.38,24.61,2.29 } -- hp
	Skinshops[#Skinshops+1] = { -919.26,-731.08,24.61,159.91 } -- hp
	Skinshops[#Skinshops+1] = { -919.01,-725.18,24.61,40.35 } -- hp
	Skinshops[#Skinshops+1] = { 457.64,-990.77,30.68,11.34 } -- dp praça
	Skinshops[#Skinshops+1] = { 2499.97,-337.52,93.16,167.00 } -- Militar
	Skinshops[#Skinshops+1] = { 2505.25,-337.50,93.16,271.64 } -- Militar
	Skinshops[#Skinshops+1] = { -461.46,5998.09,27.55,137.84 } -- civil
	Skinshops[#Skinshops+1] = { -780.21,-1211.9,10.38,141.74 } -- Tatica
	Skinshops[#Skinshops+1] = { 1075.28,3273.75,41.11,198.43 } -- umbrella
	Skinshops[#Skinshops+1] = { 875.42,1860.9,142.5,226.78 } -- Metgala
	Skinshops[#Skinshops+1] = { -2197.05,-275.16,35.79,257.96 } -- Gang4
	Skinshops[#Skinshops+1] = { -458.91,-1264.9,25.48,51.03 } -- Afetados
	Skinshops[#Skinshops+1] = { 413.04,6468.02,29.82,274.97 } -- Pinkmans
	Skinshops[#Skinshops+1] = { 1513.4,1356.95,108.29,286.3 } -- Gang9
	Skinshops[#Skinshops+1] = { 957.6,-2390.99,22.33,175.75 } -- China
	Skinshops[#Skinshops+1] = { 790.13,5752.55,702.57,249.45 } -- Mansao95
	Skinshops[#Skinshops+1] = { -763.42,29.24,40.64,161.58 } -- Igreja
	Skinshops[#Skinshops+1] = { 3047.53,-4136.9,9.86,351.5 }
	Skinshops[#Skinshops+1] = { -2003.59,4494.14,57.29,320.32 }
	-- Skinshops[#Skinshops+1] = { 2029.85,4299.39,38.25,99.22 } -- QG_110
	-- Skinshops[#Skinshops+1] = { 1030.2,-2550.23,32.28,85.04 } -- Vermelhos
	Skinshops[#Skinshops+1] = { 1797.05,441.96,172.34,59.53 } -- Azul
	Skinshops[#Skinshops+1] = { 2133.61,-15.7,227.22,45.36 } -- Rosa
	Skinshops[#Skinshops+1] = { 2742.43,2716.88,55.84,48.19 } -- Sindicato
	-- Skinshops[#Skinshops+1] = { -139.96,-1609.06,35.03,68.04 } -- Groove
	Skinshops[#Skinshops+1] = { 2115.64,3886.09,33.23,215.44 } -- Roxos
	Skinshops[#Skinshops+1] = { 514.2,370.01,151.73,104.89 } -- Roxos
	Skinshops[#Skinshops+1] = { 358.11,-2033.39,22.39,48.19 } -- Vagos
	Skinshops[#Skinshops+1] = { 117.31,-1962.14,21.33,201.26 } -- Ballas
	-- Skinshops[#Skinshops+1] = {  103.51,3613.09,40.49,175.75 } -- Laranja
	Skinshops[#Skinshops+1] = { 291.24,216.89,78.82,277.8 } -- Bahamas
	Skinshops[#Skinshops+1] = { 945.01,47.64,80.29,53.86 } -- Bellagio
	Skinshops[#Skinshops+1] = { -1540.36,321.5,87.25,73.71 } -- Lavajato
	Skinshops[#Skinshops+1] = { 102.53,-1311.89,21.13,31.19 } -- Putaria
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { -3320.91,548.73,13.77,303.31 } -- Arcade
	Skinshops[#Skinshops+1] = { 414.94,-23.43,91.93,56.7 } -- Callisto
	Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
	Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
	Skinshops[#Skinshops+1] = { -203.27,-1330.04,34.9,127.56 } -- Undergrounds
	Skinshops[#Skinshops+1] = { 1382.88,-2093.85,47.21,31.19 } -- fazer
	Skinshops[#Skinshops+1] = { 2361.62,5647.1,92.71,141.74 } -- Topgear
	Skinshops[#Skinshops+1] = { 1378.51,-2096.32,52.6,39.69  } -- FerroVelho
	Skinshops[#Skinshops+1] = { 2643.51,3636.15,106.73,39.69 } -- Morro-do-Sacola
	Skinshops[#Skinshops+1] = { 883.73,-2100.55,30.46,175.75 } -- CarClube
	Skinshops[#Skinshops+1] = { -337.81,-166.57,44.58,272.13 } -- Virtude
	Skinshops[#Skinshops+1] = { 134.68,-369.75,50.33,17.01 } -- Big
	Skinshops[#Skinshops+1] = { 2742.47,3500.22,61.3,357.17} -- Kraken
	Skinshops[#Skinshops+1] = { -1149.56,-1554.59,7.63,153.08 } -- bandoleros
	Skinshops[#Skinshops+1] = { 556.33,-2773.46,6.08,59.53 } -- Gang5
	Skinshops[#Skinshops+1] = { 99.06,1229.61,207.17,345.83 } -- Mayans
	Skinshops[#Skinshops+1] = { 1028.6,-2550.72,32.28,351.5 } -- soa
	Skinshops[#Skinshops+1] = { 1026.51,-2542.27,28.29,170.08 } -- hellsangels
	Skinshops[#Skinshops+1] = { 3234.18,5120.17,20.15,116.23 }
	Skinshops[#Skinshops+1] = { 2312.64,5568.36,51.91,343.0 } -- sinaloa
	Skinshops[#Skinshops+1] = { -60.09,994.66,239.52,328.82 } -- gringa
	Skinshops[#Skinshops+1] = { -1539.52,141.51,55.65,51.03 } -- bloods
	-- Skinshops[#Skinshops+1] = { -2804.84,2261.69,24.11,320.32 } -- bloods secundario
	Skinshops[#Skinshops+1] = { -3025.46,59.49,11.95,331.66 } -- crips
	Skinshops[#Skinshops+1] = { -1814.54,447.96,127.91,351.5 } -- mexicana
	Skinshops[#Skinshops+1] = { -1887.16,2070.1,145.57,334.49 } -- russa
	Skinshops[#Skinshops+1] = { -1491.07,845.77,181.59,87.88 } -- irlandesa
	Skinshops[#Skinshops+1] = { 173.45,668.33,207.66,104.89 } -- triade
	Skinshops[#Skinshops+1] = { 420.53,-1483.85,33.8,116.23 } -- italiana
	Skinshops[#Skinshops+1] = { 2332.3,5524.54,51.68,249.45 } -- overdrive
	Skinshops[#Skinshops+1] = { -776.37,-2593.33,17.66,238.12 } -- Outlaws 
	Skinshops[#Skinshops+1] = { -617.15,-1617.33,33.01,172.92 } -- Topgear 
	Skinshops[#Skinshops+1] = { -290.78,1986.24,166.14,334.49 } -- israel
	-- Skinshops[#Skinshops+1] = { 1078.37,-1973.3,31.48,235.28 } -- gringa
	Skinshops[#Skinshops+1] = { -303.2,220.21,77.91,257.96 } -- luxor
	Skinshops[#Skinshops+1] = { 1252.95,-1720.72,56.45,65.2 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1289.66,-1762.54,54.21,22.68 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1338.0,-792.43,71.51,343.0 } -- brancos
	Skinshops[#Skinshops+1] = { 1346.33,-705.11,67.74,73.71 } -- brancos
	Skinshops[#Skinshops+1] = { 1267.24,-299.03,84.59,158.75 } -- barragem
	Skinshops[#Skinshops+1] = { 1251.62,-265.92,77.91,107.72 } -- barragem
	Skinshops[#Skinshops+1] = { 1506.8,-2368.57,78.03,274.97 } -- rosas
	Skinshops[#Skinshops+1] = { 1512.78,-2365.16,78.03,195.6 } -- rosas
	-- Skinshops[#Skinshops+1] = { 2225.07,3452.81,61.33,172.92 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2229.55,3452.95,61.33,170.08 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2226.14,3453.91,61.33,187.09 } -- cinzas
	Skinshops[#Skinshops+1] = { 103.67,1221.91,207.17,102.05 } -- SOA
	Skinshops[#Skinshops+1] = { 1306.65,-735.32,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -215.34,-1334.28,34.9,266.46 } -- bennys
	Skinshops[#Skinshops+1] = { 1048.13,888.82,220.34,48.19 } -- playboy
	Skinshops[#Skinshops+1] = { 1341.91,-790.49,71.51,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { 1336.42,-788.7,71.51,348.67 } -- brancos
	Skinshops[#Skinshops+1] = { 1308.3,-733.85,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -1550.84,-393.9,41.97,51.03 } -- 
	Skinshops[#Skinshops+1] = { -3337.8,543.54,17.44,215.44 } -- mansao 60
	Skinshops[#Skinshops+1] = { 1963.43,6415.17,61.7,311.82 } -- marrons
	Skinshops[#Skinshops+1] = { -2272.06,323.23,174.6,22.68 }
	Skinshops[#Skinshops+1] = { -1687.17,-3185.18,14.0,243.78 }
	Skinshops[#Skinshops+1] = { 747.78,-308.18,59.8,306.15 } -- Campinho
	Skinshops[#Skinshops+1] = { -1044.65,305.04,71.66,266.46 } -- Inglaterra
	Skinshops[#Skinshops+1] = { -2022.42,4435.69,53.09,345.83 } -- Banzas
	Skinshops[#Skinshops+1] = { 355.76,-2729.82,1.72,257.96 } -- Dixavas
	Skinshops[#Skinshops+1] = { -769.38,8.1,40.64,345.83 } 
	Skinshops[#Skinshops+1] = { 1471.81,6539.39,18.64,85.04 } -- pier norte
	Skinshops[#Skinshops+1] = { -602.0,-914.22,23.88,184.26 } -- Anonymous
	Skinshops[#Skinshops+1] = { -602.7,-923.49,17.59,328.82 } -- Anonymous
	Skinshops[#Skinshops+1] = { -2813.9,2266.37,24.33,354.34 } -- qg 71
	Skinshops[#Skinshops+1] = { 676.42,909.22,247.57,170.08 } -- Inglaterra
	Skinshops[#Skinshops+1] = { 5026.55,-5760.97,15.77,232.45 } -- Caribe
	Skinshops[#Skinshops+1] = { 2612.27,5333.94,47.57,59.53 } -- prf
	Skinshops[#Skinshops+1] = { 3088.32,5091.99,23.25,73.71 } -- qg_80
	Skinshops[#Skinshops+1] = { -156.96,8259.62,12.82,11.34 } -- iate
	Skinshops[#Skinshops+1] = { -1784.4,-1376.75,11.88,39.69 } -- iate
	Skinshops[#Skinshops+1] = { -1883.34,-1164.43,11.73,320.32 } -- iate
	Skinshops[#Skinshops+1] = { -2210.16,-586.48,11.73,232.45 } 
	Skinshops[#Skinshops+1] = { 866.58,1871.27,140.39,87.88 } -- QG_07
	Skinshops[#Skinshops+1] = { -1179.62,302.46,73.67,102.05 } -- qg_82
	Skinshops[#Skinshops+1] = { -1285.76,-1723.91,6.15,43.20 } -- QG_266
	Skinshops[#Skinshops+1] = { -2423.52,1790.06,185.48,39.69 } -- qg_84
	Skinshops[#Skinshops+1] = { -878.0,-1434.81,7.53,201.26 } -- qg_85
	Skinshops[#Skinshops+1] = { -539.93,5002.83,159.92,272.13 } -- qg_86
	Skinshops[#Skinshops+1] = { -2675.14,1307.61,152.0,272.13 } -- qg_87
	Skinshops[#Skinshops+1] = { -2277.87,336.33,178.57,300.48 } -- qg_88
	Skinshops[#Skinshops+1] = { 3482.3,5015.04,11.91,212.6 }
	Skinshops[#Skinshops+1] = { -4504.72,-70.94,12.81,164.41 }
	Skinshops[#Skinshops+1] = { 994.15,3403.17,61.97,280.63 } -- QG_31
	Skinshops[#Skinshops+1] = { 89.54,-1966.65,20.74,320.32 } -- QG_43
	Skinshops[#Skinshops+1] = { 2456.34,4980.02,46.83,158.75 } -- QG_64
	Skinshops[#Skinshops+1] = { -935.2,403.8,79.23,195.6 } -- QG_103
	Skinshops[#Skinshops+1] = { 129.79,-99.03,49.57,161.58 } -- QG_106
	Skinshops[#Skinshops+1] = { 3496.16,-3283.35,10.62,25.52 } -- IlhaBatman
	Skinshops[#Skinshops+1] = { 715.75,-959.24,30.4,354.34 } -- QG_108
	Skinshops[#Skinshops+1] = { 867.22,1872.93,140.39,153.08 } -- QG_07
	Skinshops[#Skinshops+1] = { -59.51,842.14,235.71,308.98 } -- QG_118
	Skinshops[#Skinshops+1] = { 676.42,909.22,247.57,170.08} -- QG_121
	Skinshops[#Skinshops+1] = { -1136.33,-2076.44,21.28,223.94 } -- mecanica
	Skinshops[#Skinshops+1] = { -3660.96,2774.97,45.33,240.95 } -- StarCity
	Skinshops[#Skinshops+1] = { -552.75,6458.59,12.74,204.1 } -- mansao141
	Skinshops[#Skinshops+1] = { -341.86,1141.85,331.67,113.39 } -- mansao142
	Skinshops[#Skinshops+1] = { -59.51,640.48,213.86,297.64 } -- Mansao270
	Skinshops[#Skinshops+1] = { -54.98,634.66,208.85,306.15 } -- Mansao270
	Skinshops[#Skinshops+1] = { -40.1,645.55,208.85,121.89 } -- Mansao270
	Skinshops[#Skinshops+1] = { 180.57,-1251.36,29.3,155.91 } -- Mansao271
	Skinshops[#Skinshops+1] = { 101.02,-1312.1,21.13,25.52 } -- Mansao271
	Skinshops[#Skinshops+1] = { -3925.56,4407.35,12.84,5.67 } -- Mansao272
	Skinshops[#Skinshops+1] = { -3922.83,4398.44,12.84,11.34 } -- Mansao272
	Skinshops[#Skinshops+1] = { -3914.33,4387.73,12.87,14.18 } -- Mansao272
	Skinshops[#Skinshops+1] = { -3933.04,4389.79,12.86,286.3 } -- Mansao272
	Skinshops[#Skinshops+1] = { -1322.44,-1275.13,4.56,22.45 } -- QG_487
	Skinshops[#Skinshops+1] = { 542.13,-1646.01,29.42,318.19 } -- QG_488
	Skinshops[#Skinshops+1] = { 504.34,-1946.91,24.97,32.44 } -- QG_489
	Skinshops[#Skinshops+1] = { 2476.66,-854.53,136.65,27.05 } -- QG_490
	Skinshops[#Skinshops+1] = { -1240.88,807.49,195.07,240.41 } -- QG_491
	Skinshops[#Skinshops+1] = { -1159.51,-1739.27,5.20,212.62 } -- QG_492
	Skinshops[#Skinshops+1] = { -1368.51,2489.32,35.86,26.74 } -- QG_493
	Skinshops[#Skinshops+1] = { -543.84,-179.25,47.55,226.78 } -- Juridico
	Skinshops[#Skinshops+1] = { -535.84,-174.47,47.55,183.80 } -- Juridico
	Skinshops[#Skinshops+1] = { 1031.15,3668.4,39.06,274.97 } -- Mansao279
	Skinshops[#Skinshops+1] = { 1036.79,3678.02,39.06,42.52 } -- Mansao279
	Skinshops[#Skinshops+1] = { 1015.5,3673.44,39.06,246.62 } -- Mansao279
	Skinshops[#Skinshops+1] = { -1649.68,722.83,207.57,175.75 } -- Mansao249
	Skinshops[#Skinshops+1] = { -1644.44,701.1,206.36,87.88 } -- Mansao249
	Skinshops[#Skinshops+1] = { -742.78,504.39,109.57,291.97 } -- Mansao281
	Skinshops[#Skinshops+1] = { -2245.85,507.24,179.2,85.04 } -- Mansao282
	Skinshops[#Skinshops+1] = { -2239.97,487.1,179.2,269.3 } -- Mansao282
	Skinshops[#Skinshops+1] = { -2793.25,-190.8,17.32,119.06 } -- Mansao284
	Skinshops[#Skinshops+1] = { -2765.22,-214.72,17.32,138.9 } -- Mansao284
	Skinshops[#Skinshops+1] = { -2753.01,-220.07,17.32,68.04 } -- Mansao284
	Skinshops[#Skinshops+1] = { -823.27,6162.69,19.11,144.57 } -- Mansao288
	Skinshops[#Skinshops+1] = { -834.29,6173.16,19.11,147.41 } -- Mansao288
	Skinshops[#Skinshops+1] = { -802.91,6186.03,19.11,323.15 } -- Mansao288

elseif cityName == "Boomerang" then
	Skinshops[#Skinshops+1] = { -2349.97,3266.35,32.81,154.02 }
	Skinshops[#Skinshops+1] = { -1050.32,-2011.89,13.16,138.47 } -- mecanica
	Skinshops[#Skinshops+1] = { 1133.63,-1518.37,34.84,66.08 } -- paramedic
	Skinshops[#Skinshops+1] = { -3068.65,3456.45,10.03,255.12 } -- mansao93
	Skinshops[#Skinshops+1] = { -1695.24,-1130.01,14.0,147.41 }
	Skinshops[#Skinshops+1] = { -1699.29,-1126.98,14.0,226.78 }
	Skinshops[#Skinshops+1] = { -3803.9,288.08,158.81,175.75 } -- QG_173
	Skinshops[#Skinshops+1] = { 791.97,5736.84,702.57,76.54 } -- mansao90
	Skinshops[#Skinshops+1] = { 2026.2,4290.16,43.25,17.01 } -- QG_180
	Skinshops[#Skinshops+1] = { 45.04,6503.65,31.53,317.49 } -- QG_181
	Skinshops[#Skinshops+1] = { 1678.57,7055.46,11.77,141.25 }
	Skinshops[#Skinshops+1] = { 1104.53,196.11,-49.44,45.36 } -- CassinoDiamond
	Skinshops[#Skinshops+1] = { 1584.97,4087.41,43.06,198.55 } -- QG_165
	Skinshops[#Skinshops+1] = { 136.79,-346.87,50.33,158.75 } -- QG_168
	Skinshops[#Skinshops+1] = { -404.72,4373.04,62.82,354.34 } -- mansao94
	Skinshops[#Skinshops+1] = { -142.82,6494.48,38.84,39.69 } -- mansao102
	Skinshops[#Skinshops+1] = { 2023.49,-1600.29,258.50,347.38 } -- mansao101
	Skinshops[#Skinshops+1] = { 368.92,2384.33,80.24,137.06 } -- mansao49
	Skinshops[#Skinshops+1] = { -126.17,6619.03,33.85,311.82 } -- mansao51
	Skinshops[#Skinshops+1] = { -1474.76,-1759.03,14.35,3.21 } -- mansao70
	Skinshops[#Skinshops+1] = { -2766.96,-941.86,16.05,64.63 } -- mansao71
	Skinshops[#Skinshops+1] = { -1141.65,374.78,74.97,226.04 } -- Mansao74
	Skinshops[#Skinshops+1] = { -1417.25,-617.80,30.72,36.73 } -- MajorBahamas
	Skinshops[#Skinshops+1] = { -3090.98,3367.52,17.32,180.20 } -- mansao66
	Skinshops[#Skinshops+1] = { -3536.63,4623.20,6.72,287.43 } -- mansao96
	Skinshops[#Skinshops+1] = { 1036.84,3678.09,39.05,179.56 } -- mansao16
	Skinshops[#Skinshops+1] = { 93.40,6517.33,31.26,305.00 } -- QG_175
	Skinshops[#Skinshops+1] = { 2006.75,3354.94,51.60,83.44 } -- QG_150
	Skinshops[#Skinshops+1] = { 102.37,-1311.13,21.13,48.19 } -- QG_143
	Skinshops[#Skinshops+1] = { -2189.20,4283.77,49.18,196.14 } -- QG_132
	Skinshops[#Skinshops+1] = { 958.86,-966.6,42.95,348.67 } -- mecanica
	Skinshops[#Skinshops+1] = { -632.41,-134.04,43.22,93.55 } -- Bombeiros
	Skinshops[#Skinshops+1] = { 1150.65,-1583.05,35.28,138.9 } -- hp
	Skinshops[#Skinshops+1] = { 457.64,-990.77,30.68,11.34 } -- dp praça
	Skinshops[#Skinshops+1] = { 2516.96,-345.11,101.89,42.52 } -- Militar
	Skinshops[#Skinshops+1] = { -437.84,6012.35,36.99,357.17 } -- civil
	Skinshops[#Skinshops+1] = { -780.21,-1211.9,10.38,141.74 } -- Tatica
	Skinshops[#Skinshops+1] = { -1887.58,3026.39,32.96,328.82 } -- Exercito
	Skinshops[#Skinshops+1] = { 1075.28,3273.75,41.11,198.43 } -- umbrella
	Skinshops[#Skinshops+1] = { 875.42,1860.9,142.5,226.78 } -- Metgala
	Skinshops[#Skinshops+1] = { -2197.05,-275.16,35.79,257.96 } -- Gang4
	Skinshops[#Skinshops+1] = { -458.91,-1264.9,25.48,51.03 } -- Afetados
	Skinshops[#Skinshops+1] = { 413.04,6468.02,29.82,274.97 } -- Pinkmans
	Skinshops[#Skinshops+1] = { 1513.4,1356.95,108.29,286.3 } -- Gang9
	Skinshops[#Skinshops+1] = { 957.6,-2390.99,22.33,175.75 } -- China
	Skinshops[#Skinshops+1] = { 790.13,5752.55,702.57,249.45 } -- Mansao95
	Skinshops[#Skinshops+1] = { -763.42,29.24,40.64,161.58 } -- Igreja
	Skinshops[#Skinshops+1] = { 3047.53,-4136.9,9.86,351.5 }
	Skinshops[#Skinshops+1] = { -2003.59,4494.14,57.29,320.32 }
	-- Skinshops[#Skinshops+1] = { 2029.85,4299.39,38.25,99.22 } -- QG_110
	-- Skinshops[#Skinshops+1] = { 1030.2,-2550.23,32.28,85.04 } -- Vermelhos
	Skinshops[#Skinshops+1] = { 1797.05,441.96,172.34,59.53 } -- Azul
	Skinshops[#Skinshops+1] = { 2133.61,-15.7,227.22,45.36 } -- Rosa
	Skinshops[#Skinshops+1] = { 2742.43,2716.88,55.84,48.19 } -- Sindicato
	-- Skinshops[#Skinshops+1] = { -139.96,-1609.06,35.03,68.04 } -- Groove
	Skinshops[#Skinshops+1] = { 2115.64,3886.09,33.23,215.44 } -- Roxos
	Skinshops[#Skinshops+1] = { 514.2,370.01,151.73,104.89 } -- Roxos
	Skinshops[#Skinshops+1] = { 358.11,-2033.39,22.39,48.19 } -- Vagos
	Skinshops[#Skinshops+1] = { 117.31,-1962.14,21.33,201.26 } -- Ballas
	-- Skinshops[#Skinshops+1] = {  103.51,3613.09,40.49,175.75 } -- Laranja
	Skinshops[#Skinshops+1] = { 291.24,216.89,78.82,277.8 } -- Bahamas
	Skinshops[#Skinshops+1] = { 945.01,47.64,80.29,53.86 } -- Bellagio
	Skinshops[#Skinshops+1] = { -1540.36,321.5,87.25,73.71 } -- Lavajato
	Skinshops[#Skinshops+1] = { 102.53,-1311.89,21.13,31.19 } -- Putaria
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { -3320.91,548.73,13.77,303.31 } -- Arcade
	Skinshops[#Skinshops+1] = { 414.94,-23.43,91.93,56.7 } -- Callisto
	Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
	Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
	Skinshops[#Skinshops+1] = { -203.27,-1330.04,34.9,127.56 } -- Undergrounds
	Skinshops[#Skinshops+1] = { 1382.88,-2093.85,47.21,31.19 } -- fazer
	Skinshops[#Skinshops+1] = { 2361.62,5647.1,92.71,141.74 } -- Topgear
	Skinshops[#Skinshops+1] = { 1378.51,-2096.32,52.6,39.69  } -- FerroVelho
	Skinshops[#Skinshops+1] = { 2643.51,3636.15,106.73,39.69 } -- Morro-do-Sacola
	Skinshops[#Skinshops+1] = { 883.73,-2100.55,30.46,175.75 } -- CarClube
	Skinshops[#Skinshops+1] = { -337.81,-166.57,44.58,272.13 } -- Virtude
	Skinshops[#Skinshops+1] = { 134.68,-369.75,50.33,17.01 } -- Big
	Skinshops[#Skinshops+1] = { 2742.47,3500.22,61.3,357.17} -- Kraken
	Skinshops[#Skinshops+1] = { -1149.56,-1554.59,7.63,153.08 } -- bandoleros
	Skinshops[#Skinshops+1] = { 556.33,-2773.46,6.08,59.53 } -- Gang5
	Skinshops[#Skinshops+1] = { 99.06,1229.61,207.17,345.83 } -- Mayans
	Skinshops[#Skinshops+1] = { 1028.6,-2550.72,32.28,351.5 } -- soa
	Skinshops[#Skinshops+1] = { 1026.51,-2542.27,28.29,170.08 } -- hellsangels
	Skinshops[#Skinshops+1] = { 3234.18,5120.17,20.15,116.23 }
	Skinshops[#Skinshops+1] = { 2312.64,5568.36,51.91,343.0 } -- sinaloa
	Skinshops[#Skinshops+1] = { -60.09,994.66,239.52,328.82 } -- gringa
	Skinshops[#Skinshops+1] = { -1539.52,141.51,55.65,51.03 } -- bloods
	-- Skinshops[#Skinshops+1] = { -2804.84,2261.69,24.11,320.32 } -- bloods secundario
	Skinshops[#Skinshops+1] = { -3025.46,59.49,11.95,331.66 } -- crips
	Skinshops[#Skinshops+1] = { -1814.54,447.96,127.91,351.5 } -- mexicana
	Skinshops[#Skinshops+1] = { -1887.16,2070.1,145.57,334.49 } -- russa
	Skinshops[#Skinshops+1] = { -1491.07,845.77,181.59,87.88 } -- irlandesa
	Skinshops[#Skinshops+1] = { 173.45,668.33,207.66,104.89 } -- triade
	Skinshops[#Skinshops+1] = { 420.53,-1483.85,33.8,116.23 } -- italiana
	Skinshops[#Skinshops+1] = { 2332.3,5524.54,51.68,249.45 } -- overdrive
	Skinshops[#Skinshops+1] = { -776.37,-2593.33,17.66,238.12 } -- Outlaws 
	Skinshops[#Skinshops+1] = { -617.15,-1617.33,33.01,172.92 } -- Topgear 
	Skinshops[#Skinshops+1] = { -290.78,1986.24,166.14,334.49 } -- israel
	-- Skinshops[#Skinshops+1] = { 1078.37,-1973.3,31.48,235.28 } -- gringa
	Skinshops[#Skinshops+1] = { -303.2,220.21,77.91,257.96 } -- luxor
	Skinshops[#Skinshops+1] = { 1252.95,-1720.72,56.45,65.2 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1289.66,-1762.54,54.21,22.68 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1338.0,-792.43,71.51,343.0 } -- brancos
	Skinshops[#Skinshops+1] = { 1346.33,-705.11,67.74,73.71 } -- brancos
	Skinshops[#Skinshops+1] = { 1267.24,-299.03,84.59,158.75 } -- barragem
	Skinshops[#Skinshops+1] = { 1251.62,-265.92,77.91,107.72 } -- barragem
	Skinshops[#Skinshops+1] = { 1506.8,-2368.57,78.03,274.97 } -- rosas
	Skinshops[#Skinshops+1] = { 1512.78,-2365.16,78.03,195.6 } -- rosas
	-- Skinshops[#Skinshops+1] = { 2225.07,3452.81,61.33,172.92 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2229.55,3452.95,61.33,170.08 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2226.14,3453.91,61.33,187.09 } -- cinzas
	Skinshops[#Skinshops+1] = { 103.67,1221.91,207.17,102.05 } -- SOA
	Skinshops[#Skinshops+1] = { 1306.65,-735.32,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -215.34,-1334.28,34.9,266.46 } -- bennys
	Skinshops[#Skinshops+1] = { 1048.13,888.82,220.34,48.19 } -- playboy
	Skinshops[#Skinshops+1] = { 1341.91,-790.49,71.51,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { 1336.42,-788.7,71.51,348.67 } -- brancos
	Skinshops[#Skinshops+1] = { 1308.3,-733.85,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -1550.84,-393.9,41.97,51.03 } -- 
	Skinshops[#Skinshops+1] = { -3337.8,543.54,17.44,215.44 } -- mansao 60
	Skinshops[#Skinshops+1] = { 1963.43,6415.17,61.7,311.82 } -- marrons
	Skinshops[#Skinshops+1] = { -2272.06,323.23,174.6,22.68 }
	Skinshops[#Skinshops+1] = { -1687.17,-3185.18,14.0,243.78 }
	Skinshops[#Skinshops+1] = { 747.78,-308.18,59.8,306.15 } -- Campinho
	Skinshops[#Skinshops+1] = { 905.89,339.35,112.29,345.83 } -- Japao
	Skinshops[#Skinshops+1] = { -1044.65,305.04,71.66,266.46 } -- Inglaterra
	Skinshops[#Skinshops+1] = { -2022.42,4435.69,53.09,345.83 } -- Banzas
	Skinshops[#Skinshops+1] = { 355.76,-2729.82,1.72,257.96 } -- Dixavas
	Skinshops[#Skinshops+1] = { -769.38,8.1,40.64,345.83 } 
	Skinshops[#Skinshops+1] = { 1471.81,6539.39,18.64,85.04 } -- pier norte
	Skinshops[#Skinshops+1] = { -602.0,-914.22,23.88,184.26 } -- Anonymous
	Skinshops[#Skinshops+1] = { -602.7,-923.49,17.59,328.82 } -- Anonymous
	Skinshops[#Skinshops+1] = { -2813.9,2266.37,24.33,354.34 } -- qg 71
	Skinshops[#Skinshops+1] = { 676.42,909.22,247.57,170.08 } -- Inglaterra
	Skinshops[#Skinshops+1] = { 5026.55,-5760.97,15.77,232.45 } -- Caribe
	Skinshops[#Skinshops+1] = { 2612.27,5333.94,47.57,59.53 } -- prf
	Skinshops[#Skinshops+1] = { 3088.32,5091.99,23.25,73.71 } -- qg_80
	Skinshops[#Skinshops+1] = { -156.96,8259.62,12.82,11.34 } -- iate
	Skinshops[#Skinshops+1] = { -1784.4,-1376.75,11.88,39.69 } -- iate
	Skinshops[#Skinshops+1] = { -1883.34,-1164.43,11.73,320.32 } -- iate
	Skinshops[#Skinshops+1] = { -2210.16,-586.48,11.73,232.45 } 
	Skinshops[#Skinshops+1] = { 866.58,1871.27,140.39,87.88 } -- QG_07
	Skinshops[#Skinshops+1] = { -1179.62,302.46,73.67,102.05 } -- qg_82
	Skinshops[#Skinshops+1] = { -1226.24,-1737.73,4.53,138.9 } -- qg_83
	Skinshops[#Skinshops+1] = { -2423.52,1790.06,185.48,39.69 } -- qg_84
	Skinshops[#Skinshops+1] = { -878.0,-1434.81,7.53,201.26 } -- qg_85
	Skinshops[#Skinshops+1] = { -539.93,5002.83,159.92,272.13 } -- qg_86
	Skinshops[#Skinshops+1] = { -2675.14,1307.61,152.0,272.13 } -- qg_87
	Skinshops[#Skinshops+1] = { -2277.87,336.33,178.57,300.48 } -- qg_88
	Skinshops[#Skinshops+1] = { 3482.3,5015.04,11.91,212.6 }
	Skinshops[#Skinshops+1] = { -4504.72,-70.94,12.81,164.41 }
	Skinshops[#Skinshops+1] = { 994.15,3403.17,61.97,280.63 } -- QG_31
	Skinshops[#Skinshops+1] = { 89.54,-1966.65,20.74,320.32 } -- QG_43
	Skinshops[#Skinshops+1] = { 2456.34,4980.02,46.83,158.75 } -- QG_64
	Skinshops[#Skinshops+1] = { -935.2,403.8,79.23,195.6 } -- QG_103
	Skinshops[#Skinshops+1] = { 129.79,-99.03,49.57,161.58 } -- QG_106
	Skinshops[#Skinshops+1] = { 3496.16,-3283.35,10.62,25.52 } -- IlhaBatman
	Skinshops[#Skinshops+1] = { 715.75,-959.24,30.4,354.34 } -- QG_108
	Skinshops[#Skinshops+1] = { 867.22,1872.93,140.39,153.08 } -- QG_07
	Skinshops[#Skinshops+1] = { -59.51,842.14,235.71,308.98 } -- QG_118
	Skinshops[#Skinshops+1] = { 676.42,909.22,247.57,170.08} -- QG_121
	Skinshops[#Skinshops+1] = { -1136.33,-2076.44,21.28,223.94 } -- mecanica

elseif cityName == "Malta" then
	Skinshops[#Skinshops+1] = { -2566.45,-2204.01,5.05,161.58 } -- Resort
	Skinshops[#Skinshops+1] = { 1743.41,3629.43,34.58,307.32 } -- paramedic
	Skinshops[#Skinshops+1] = { -1050.32,-2011.89,13.16,138.47 } -- mecanica
	Skinshops[#Skinshops+1] = { 564.81,-186.92,59.07,89.95 } -- Mechanic
	Skinshops[#Skinshops+1] = { 1696.90,3698.67,39.00,297.98 } -- Mecanica Sandy Shoes
	Skinshops[#Skinshops+1] = { 1133.63,-1518.37,34.84,66.08 } -- paramedic
	Skinshops[#Skinshops+1] = { 676.50,907.89,252.58,170.08 } -- QG_376
	Skinshops[#Skinshops+1] = { 575.66,-3126.42,18.77,91.86 } -- QG_359
	-- Skinshops[#Skinshops+1] = { -1579.87,-1847.2,12.74,121.89 } -- mansao172
	-- Skinshops[#Skinshops+1] = { -1570.65,-1847.93,12.72,221.11 } -- mansao172
	-- Skinshops[#Skinshops+1] = { -1586.41,-1818.9,17.73,221.11 } -- mansao172
	-- Skinshops[#Skinshops+1] = { -1580.83,-1848.25,17.73,121.89 } -- mansao172
	Skinshops[#Skinshops+1] = { -3722.96,3744.86,69.47,172.92 } -- mansao170
	Skinshops[#Skinshops+1] = { -1795.65,453.76,117.95,262.64 } -- QG_15
	-- Skinshops[#Skinshops+1] = { -1764.51,589.77,187.42,96.38 } -- mansao168
	-- Skinshops[#Skinshops+1] = { -2106.66,-499.22,17.20,49.73 } -- mansao47
	-- Skinshops[#Skinshops+1] = { 790.11,5752.5,702.57,68.04 } -- Mansao164
	Skinshops[#Skinshops+1] = { 1036.80,3678.02,39.05,171.87 } -- mansao169
	Skinshops[#Skinshops+1] = { -554.14,1192.33,334.08,280.63 } -- AlphaA1
	Skinshops[#Skinshops+1] = { -575.98,1193.24,334.08,184.26 } -- AlphaA2
	Skinshops[#Skinshops+1] = { -604.07,1192.34,334.08,269.3 } -- AlphaA3
	Skinshops[#Skinshops+1] = { -628.87,1192.29,334.08,283.47 } -- AlphaA4
	Skinshops[#Skinshops+1] = { -543.57,1251.58,334.08,85.04 } -- AlphaB1
	Skinshops[#Skinshops+1] = { -568.49,1251.75,334.08,110.56 } -- AlphaB2
	Skinshops[#Skinshops+1] = { -593.38,1251.64,334.08,102.05 } -- AlphaB3
	Skinshops[#Skinshops+1] = { -618.02,1251.67,334.08,87.88 } -- AlphaB4
	Skinshops[#Skinshops+1] = { -2349.97,3266.35,32.81,154.02 }
	-- Skinshops[#Skinshops+1] = { -1514.82,-1468.04,6.39,206.93 } -- Atlantis
	-- Skinshops[#Skinshops+1] = { -3844.72,1614.1,16.26,48.19 } -- mansao149
	Skinshops[#Skinshops+1] = { -2674.98,1304.27,152.0,269.3 } -- mansao147
	Skinshops[#Skinshops+1] = { -1695.24,-1130.01,14.0,147.41 }
	Skinshops[#Skinshops+1] = { -1699.29,-1126.98,14.0,226.78 }
	-- Skinshops[#Skinshops+1] = { 2505.30,3595.42,98.52,130.91 } -- QG_104
	Skinshops[#Skinshops+1] = { -1759.79,172.42,122.77,110.56 } -- mansao134
	-- Skinshops[#Skinshops+1] = { -1044.63,304.98,71.66,107.72 } -- mansao130
	Skinshops[#Skinshops+1] = { 461.13,-996.01,30.68,174.18 } -- db praça
	-- Skinshops[#Skinshops+1] = { -404.72,4373.04,62.82,354.34 } -- mansao94
	Skinshops[#Skinshops+1] = { -417.65,4373.11,61.35,85.04 } -- Mansao244
	Skinshops[#Skinshops+1] = { -416.92,4388.25,61.35,85.04 } -- Mansao244
	Skinshops[#Skinshops+1] = { -387.83,4371.83,61.35,274.97 } -- Mansao244
	Skinshops[#Skinshops+1] = { -387.37,4381.69,61.35,272.13 } -- Mansao244
	Skinshops[#Skinshops+1] = { 2023.49,-1600.29,258.50,347.38 } -- mansao101
	Skinshops[#Skinshops+1] = { -3541.44,4585.71,14.05,22.65 } -- mansao104
	Skinshops[#Skinshops+1] = { 93.40,6517.33,31.26,305.00 } -- QG_131
	Skinshops[#Skinshops+1] = { -2189.20,4283.77,49.18,196.14 } -- QG_132
	Skinshops[#Skinshops+1] = { 958.86,-966.6,42.95,348.67 } -- mecanica
	Skinshops[#Skinshops+1] = { -632.41,-134.04,43.22,93.55 } -- Bombeiros
	Skinshops[#Skinshops+1] = { 1686.24,3598.55,35.73,116.60 } -- Bombeiros Sandy Shoes
	Skinshops[#Skinshops+1] = { 1150.65,-1583.05,35.28,138.9 } -- hp
	Skinshops[#Skinshops+1] = { 2516.96,-345.11,101.89,42.52 } -- Militar
	Skinshops[#Skinshops+1] = { -437.84,6012.35,36.99,357.17 } -- civil
	Skinshops[#Skinshops+1] = { -780.21,-1211.9,10.38,141.74 } -- Tatica
	Skinshops[#Skinshops+1] = { -1887.58,3026.39,32.96,328.82 } -- Exercito
	Skinshops[#Skinshops+1] = { 1075.28,3273.75,41.11,198.43 } -- umbrella
	Skinshops[#Skinshops+1] = { 875.42,1860.9,142.5,226.78 } -- Metgala
	Skinshops[#Skinshops+1] = { -2197.05,-275.16,35.79,257.96 } -- Gang4
	Skinshops[#Skinshops+1] = { -458.91,-1264.9,25.48,51.03 } -- Afetados
	Skinshops[#Skinshops+1] = { 413.04,6468.02,29.82,274.97 } -- Pinkmans
	Skinshops[#Skinshops+1] = { 1513.4,1356.95,108.29,286.3 } -- Gang9
	Skinshops[#Skinshops+1] = { 957.6,-2390.99,22.33,175.75 } -- China
	Skinshops[#Skinshops+1] = { -763.42,29.24,40.64,161.58 } -- Igreja
	Skinshops[#Skinshops+1] = { 3047.53,-4136.9,9.86,351.5 }
	Skinshops[#Skinshops+1] = { 2029.85,4299.39,38.25,99.22 } -- QG_110
	-- Skinshops[#Skinshops+1] = { 1030.2,-2550.23,32.28,85.04 } -- Vermelhos
	Skinshops[#Skinshops+1] = { 1797.05,441.96,172.34,59.53 } -- Azul
	Skinshops[#Skinshops+1] = { 2133.61,-15.7,227.22,45.36 } -- Rosa
	Skinshops[#Skinshops+1] = { 2742.43,2716.88,55.84,48.19 } -- Sindicato
	-- Skinshops[#Skinshops+1] = { -139.96,-1609.06,35.03,68.04 } -- Groove
	Skinshops[#Skinshops+1] = { 2115.64,3886.09,33.23,215.44 } -- Roxos
	Skinshops[#Skinshops+1] = { 514.2,370.01,151.73,104.89 } -- Roxos
	Skinshops[#Skinshops+1] = { 358.11,-2033.39,22.39,48.19 } -- Vagos
	Skinshops[#Skinshops+1] = { 117.31,-1962.14,21.33,201.26 } -- Ballas
	-- Skinshops[#Skinshops+1] = {  103.51,3613.09,40.49,175.75 } -- Laranja
	Skinshops[#Skinshops+1] = { 291.24,216.89,78.82,277.8 } -- Bahamas
	Skinshops[#Skinshops+1] = { 945.01,47.64,80.29,53.86 } -- Bellagio
	Skinshops[#Skinshops+1] = { -1540.36,321.5,87.25,73.71 } -- Lavajato
	Skinshops[#Skinshops+1] = { 102.53,-1311.89,21.13,31.19 } -- Putaria
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { -3320.91,548.73,13.77,303.31 } -- Arcade
	Skinshops[#Skinshops+1] = { 414.94,-23.43,91.93,56.7 } -- Callisto
	Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
	Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
	Skinshops[#Skinshops+1] = { -203.27,-1330.04,34.9,127.56 } -- Undergrounds
	Skinshops[#Skinshops+1] = { 1382.88,-2093.85,47.21,31.19 } -- fazer
	Skinshops[#Skinshops+1] = { 2361.62,5647.1,92.71,141.74 } -- Topgear
	Skinshops[#Skinshops+1] = { 1378.51,-2096.32,52.6,39.69  } -- FerroVelho
	-- Skinshops[#Skinshops+1] = { 2643.51,3636.15,106.73,39.69 } -- Morro-do-Sacola / QG_104
	Skinshops[#Skinshops+1] = { 883.73,-2100.55,30.46,175.75 } -- CarClube
	Skinshops[#Skinshops+1] = { -337.81,-166.57,44.58,272.13 } -- Virtude
	Skinshops[#Skinshops+1] = { 134.68,-369.75,50.33,17.01 } -- Big
	Skinshops[#Skinshops+1] = { 2742.47,3500.22,61.3,357.17} -- Kraken
	Skinshops[#Skinshops+1] = { -1149.56,-1554.59,7.63,153.08 } -- bandoleros
	Skinshops[#Skinshops+1] = { 556.33,-2773.46,6.08,59.53 } -- Gang5
	Skinshops[#Skinshops+1] = { 99.06,1229.61,207.17,345.83 } -- Mayans
	Skinshops[#Skinshops+1] = { 1028.6,-2550.72,32.28,351.5 } -- soa
	Skinshops[#Skinshops+1] = { 1026.51,-2542.27,28.29,170.08 } -- hellsangels
	Skinshops[#Skinshops+1] = { 3234.18,5120.17,20.15,116.23 }
	Skinshops[#Skinshops+1] = { 2312.64,5568.36,51.91,343.0 } -- sinaloa
	Skinshops[#Skinshops+1] = { -60.09,994.66,239.52,328.82 } -- gringa
	Skinshops[#Skinshops+1] = { -1539.52,141.51,55.65,51.03 } -- bloods
	-- Skinshops[#Skinshops+1] = { -2804.84,2261.69,24.11,320.32 } -- bloods secundario
	Skinshops[#Skinshops+1] = { -3025.46,59.49,11.95,331.66 } -- crips
	Skinshops[#Skinshops+1] = { -339.2,-1523.7,29.34,22.68 } -- warlocks
	Skinshops[#Skinshops+1] = { -1814.54,447.96,127.91,351.5 } -- mexicana
	Skinshops[#Skinshops+1] = { -1887.16,2070.1,145.57,334.49 } -- russa
	Skinshops[#Skinshops+1] = { -1491.07,845.77,181.59,87.88 } -- irlandesa
	Skinshops[#Skinshops+1] = { 173.45,668.33,207.66,104.89 } -- triade
	Skinshops[#Skinshops+1] = { 420.53,-1483.85,33.8,116.23 } -- italiana
	Skinshops[#Skinshops+1] = { -776.37,-2593.33,17.66,238.12 } -- Outlaws 
	Skinshops[#Skinshops+1] = { -617.15,-1617.33,33.01,172.92 } -- Topgear 
	Skinshops[#Skinshops+1] = { -290.78,1986.24,166.14,334.49 } -- israel
	-- Skinshops[#Skinshops+1] = { 1078.37,-1973.3,31.48,235.28 } -- gringa
	Skinshops[#Skinshops+1] = { -303.2,220.21,77.91,257.96 } -- luxor
	Skinshops[#Skinshops+1] = { 1252.95,-1720.72,56.45,65.2 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1289.66,-1762.54,54.21,22.68 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1338.0,-792.43,71.51,343.0 } -- brancos
	Skinshops[#Skinshops+1] = { 1346.33,-705.11,67.74,73.71 } -- brancos
	Skinshops[#Skinshops+1] = { 1267.24,-299.03,84.59,158.75 } -- barragem
	Skinshops[#Skinshops+1] = { 1251.62,-265.92,77.91,107.72 } -- barragem
	Skinshops[#Skinshops+1] = { 1506.8,-2368.57,78.03,274.97 } -- rosas
	Skinshops[#Skinshops+1] = { 1512.78,-2365.16,78.03,195.6 } -- rosas
	-- Skinshops[#Skinshops+1] = { 2225.07,3452.81,61.33,172.92 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2229.55,3452.95,61.33,170.08 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2226.14,3453.91,61.33,187.09 } -- cinzas
	Skinshops[#Skinshops+1] = { 103.67,1221.91,207.17,102.05 } -- SOA
	Skinshops[#Skinshops+1] = { 1306.65,-735.32,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -215.34,-1334.28,34.9,266.46 } -- bennys
	Skinshops[#Skinshops+1] = { 1048.13,888.82,220.34,48.19 } -- playboy
	Skinshops[#Skinshops+1] = { 1341.91,-790.49,71.51,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { 1336.42,-788.7,71.51,348.67 } -- brancos
	Skinshops[#Skinshops+1] = { 1308.3,-733.85,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -1550.84,-393.9,41.97,51.03 } -- 
	Skinshops[#Skinshops+1] = { -3337.8,543.54,17.44,215.44 } -- mansao 60
	Skinshops[#Skinshops+1] = { 1963.43,6415.17,61.7,311.82 } -- marrons
	Skinshops[#Skinshops+1] = { -2272.06,323.23,174.6,22.68 }
	Skinshops[#Skinshops+1] = { -1687.17,-3185.18,14.0,243.78 }
	Skinshops[#Skinshops+1] = { 747.78,-308.18,59.8,306.15 } -- Campinho
	Skinshops[#Skinshops+1] = { 905.89,339.35,112.29,345.83 } -- Japao
	Skinshops[#Skinshops+1] = { -1044.65,305.04,71.66,266.46 } -- Inglaterra
	Skinshops[#Skinshops+1] = { -2022.42,4435.69,53.09,345.83 } -- Banzas
	Skinshops[#Skinshops+1] = { 355.76,-2729.82,1.72,257.96 } -- Dixavas
	Skinshops[#Skinshops+1] = { -769.38,8.1,40.64,345.83 } 
	Skinshops[#Skinshops+1] = { 1471.81,6539.39,18.64,85.04 } -- pier norte
	Skinshops[#Skinshops+1] = { -602.0,-914.22,23.88,184.26 } -- Anonymous
	Skinshops[#Skinshops+1] = { -602.7,-923.49,17.59,328.82 } -- Anonymous
	Skinshops[#Skinshops+1] = { -2813.9,2266.37,24.33,354.34 } -- qg 71
	Skinshops[#Skinshops+1] = { 676.42,909.22,247.57,170.08 } -- Inglaterra
	Skinshops[#Skinshops+1] = { 5026.55,-5760.97,15.77,232.45 } -- Caribe
	Skinshops[#Skinshops+1] = { 2612.27,5333.94,47.57,59.53 } -- prf
	-- Skinshops[#Skinshops+1] = { 3088.32,5091.99,23.25,73.71 } -- qg_80
	Skinshops[#Skinshops+1] = { -156.96,8259.62,12.82,11.34 } -- iate
	Skinshops[#Skinshops+1] = { -1784.4,-1376.75,11.88,39.69 } -- iate
	Skinshops[#Skinshops+1] = { -1883.34,-1164.43,11.73,320.32 } -- iate
	Skinshops[#Skinshops+1] = { -2210.16,-586.48,11.73,232.45 } 
	Skinshops[#Skinshops+1] = { 866.58,1871.27,140.39,87.88 } -- QG_07
	Skinshops[#Skinshops+1] = { -1179.62,302.46,73.67,102.05 } -- qg_82
	-- Skinshops[#Skinshops+1] = { -1226.24,-1737.73,4.53,138.9 } -- qg_83
	Skinshops[#Skinshops+1] = { -2423.52,1790.06,185.48,39.69 } -- qg_84
	Skinshops[#Skinshops+1] = { -539.93,5002.83,159.92,272.13 } -- qg_86
	Skinshops[#Skinshops+1] = { -2675.14,1307.61,152.0,272.13 } -- qg_87
	Skinshops[#Skinshops+1] = { -2277.87,336.33,178.57,300.48 } -- qg_88
	Skinshops[#Skinshops+1] = { 3482.3,5015.04,11.91,212.6 }
	Skinshops[#Skinshops+1] = { -4504.72,-70.94,12.81,164.41 }
	Skinshops[#Skinshops+1] = { 994.15,3403.17,61.97,280.63 } -- QG_31
	Skinshops[#Skinshops+1] = { 89.54,-1966.65,20.74,320.32 } -- QG_43
	Skinshops[#Skinshops+1] = { 2456.34,4980.02,46.83,158.75 } -- QG_64
	Skinshops[#Skinshops+1] = { -935.2,403.8,79.23,195.6 } -- QG_103
	Skinshops[#Skinshops+1] = { 129.79,-99.03,49.57,161.58 } -- QG_106
	Skinshops[#Skinshops+1] = { 3496.16,-3283.35,10.62,25.52 } -- IlhaBatman
	Skinshops[#Skinshops+1] = { 715.75,-959.24,30.4,354.34 } -- QG_108
	Skinshops[#Skinshops+1] = { 867.22,1872.93,140.39,153.08 } -- QG_07
	-- Skinshops[#Skinshops+1] = { -59.51,842.14,235.71,308.98 } -- QG_118
	Skinshops[#Skinshops+1] = { 676.42,909.22,247.57,170.08} -- QG_121
	Skinshops[#Skinshops+1] = { -1136.33,-2076.44,21.28,223.94 } -- mecanica
	Skinshops[#Skinshops+1] = { -793.02,926.42,243.9,104.89 } -- Mansao243
	Skinshops[#Skinshops+1] = { -762.01,927.25,243.9,104.89 } -- Mansao243
	Skinshops[#Skinshops+1] = { -749.1,943.05,243.31,113.39 } -- Mansao243
	Skinshops[#Skinshops+1] = { -1017.01,1134.35,225.37,82.21 } -- Alpha3B1
	Skinshops[#Skinshops+1] = { -1024.91,1094.09,225.37,82.21 } -- Alpha3B2
	Skinshops[#Skinshops+1] = { -1032.56,1053.6,225.37,79.38 } -- Alpha3B3
	Skinshops[#Skinshops+1] = { -973.09,1019.16,225.37,82.21 } -- Alpha3B4
	Skinshops[#Skinshops+1] = { -965.32,1059.39,225.37,87.88 } -- Alpha3B5
	Skinshops[#Skinshops+1] = { -957.27,1099.48,225.37,68.04 } -- Alpha3B6
	Skinshops[#Skinshops+1] = { 1953.78,3842.41,32.48,121.10 } -- Sandy Shoes
	Skinshops[#Skinshops+1] = { 1760.00,3818.23,35.45,23.15 } -- Exercito Sandy Shoes
	Skinshops[#Skinshops+1] = { -1720.29,-91.35,93.63,320.32 } -- Mansao199
	Skinshops[#Skinshops+1] = { -3843.49,1641.41,12.25,320.32 } -- QG_446
	Skinshops[#Skinshops+1] = { -3837.4,1632.86,12.25,325.99 } -- QG_446
	Skinshops[#Skinshops+1] = { -1649.68,722.83,207.57,175.75 } -- Mansao249
	Skinshops[#Skinshops+1] = { -1644.44,701.1,206.36,87.88 } -- Mansao249
	Skinshops[#Skinshops+1] = { -1704.11,468.44,133.05,102.05 } -- Mansao250
	Skinshops[#Skinshops+1] = { -1706.46,467.83,133.06,286.3 } -- Mansao250
	Skinshops[#Skinshops+1] = { 325.02,817.44,197.06,39.69 } -- Mansao251
	Skinshops[#Skinshops+1] = { 356.3,832.83,201.37,116.23 } -- Mansao251
	Skinshops[#Skinshops+1] = { -2245.85,507.24,179.2,85.04 } -- Mansao255
	Skinshops[#Skinshops+1] = { -2239.97,487.1,179.2,269.3 } -- Mansao255
	Skinshops[#Skinshops+1] = { -1887.03,-56.26,130.22,189.93 } -- Mansao257
	Skinshops[#Skinshops+1] = { -1886.32,-57.54,135.2,195.6 } -- Mansao257
	Skinshops[#Skinshops+1] = { -1912.66,-53.77,135.24,189.93 } -- Mansao257
	Skinshops[#Skinshops+1] = { -175.22,1247.2,311.5,314.65 } -- Mansao258
	Skinshops[#Skinshops+1] = { -170.14,1232.7,311.45,39.69 } -- Mansao258
	Skinshops[#Skinshops+1] = { -144.8,1265.65,320.7,48.19 } -- Mansao258
	Skinshops[#Skinshops+1] = { 244.67,764.8,200.09,269.3 } -- Mansao289
	Skinshops[#Skinshops+1] = { 236.89,751.92,200.09,90.71 } -- Mansao289
	Skinshops[#Skinshops+1] = { -1045.25,300.43,71.66,294.81 } -- Mansao10

elseif cityName == "Kingdom" then
	Skinshops[#Skinshops+1] = { -2566.45,-2204.01,5.05,161.58 } -- Resort
	Skinshops[#Skinshops+1] = { -3527.02,1278.03,13.26,343.0 }
	-- Skinshops[#Skinshops+1] = { -753.42,941.17,241.91,291.97 } -- Mansao200
	-- Skinshops[#Skinshops+1] = { -1539.61,803.97,188.62,294.81 } -- Mansao202
	Skinshops[#Skinshops+1] = { -304.02,6273.91,34.79,53.86 } -- Mansao214
	Skinshops[#Skinshops+1] = { 281.97,6470.93,46.05,204.1 } -- Mansao215
	Skinshops[#Skinshops+1] = { 252.28,6469.27,46.05,294.81 } -- Mansao215
	Skinshops[#Skinshops+1] = { 255.78,6470.02,46.05,121.89 } -- Mansao215
	Skinshops[#Skinshops+1] = { 281.11,6472.17,41.06,204.1 } -- Mansao215
	Skinshops[#Skinshops+1] = { 283.26,6480.69,41.05,291.97 } -- Mansao215
	-- Skinshops[#Skinshops+1] = { -2263.01,-665.82,19.06,133.23 } -- Mansao217
	-- Skinshops[#Skinshops+1] = { -2271.07,-640.82,19.06,53.86 } -- Mansao217
	-- Skinshops[#Skinshops+1] = { -2272.97,-637.81,19.06,223.94 } -- Mansao217
	-- Skinshops[#Skinshops+1] = { -2253.27,-664.24,14.05,218.27 } -- Mansao217
	-- Skinshops[#Skinshops+1] = { -2262.25,-664.57,14.07,124.73 } -- Mansao217
	Skinshops[#Skinshops+1] = { -2246.04,475.14,179.2,85.04 } -- Mansao218
	Skinshops[#Skinshops+1] = { -2246.18,507.22,179.2,79.38 } -- Mansao218
	Skinshops[#Skinshops+1] = { -53.01,828.59,235.71,130.4 } -- Mansao236
	Skinshops[#Skinshops+1] = { -84.42,825.58,235.71,201.26 } -- Mansao236
	Skinshops[#Skinshops+1] = { -81.98,824.85,231.33,90.71 } -- Mansao236
	Skinshops[#Skinshops+1] = { -817.26,267.18,82.8,263.63 } -- Mansao241
	Skinshops[#Skinshops+1] = { -826.33,263.33,82.8,345.83 } -- Mansao241
	Skinshops[#Skinshops+1] = { -3432.32,105.59,12.47,223.94 } -- Mansao276
	-- Skinshops[#Skinshops+1] = { -3485.3,2799.67,22.01,357.17 } -- Mansao161
	-- Skinshops[#Skinshops+1] = { -3467.55,2835.87,22.01,150.24 } -- Mansao161
	Skinshops[#Skinshops+1] = { -523.75,514.0,108.07,53.86 } -- mansao194
	Skinshops[#Skinshops+1] = { -520.04,499.65,112.44,311.82 } -- mansao194
	Skinshops[#Skinshops+1] = { -2017.54,-642.97,11.79,124.73 } -- mansao193
	Skinshops[#Skinshops+1] = { -2984.63,2194.69,45.09,147.41 } -- mansao191
	Skinshops[#Skinshops+1] = { -3003.58,2185.27,45.09,136.07 } -- mansao191
	Skinshops[#Skinshops+1] = { -3009.71,2179.14,45.09,141.74 } -- mansao191
	Skinshops[#Skinshops+1] = { -2987.47,-382.69,19.68,255.12 } -- mansao198
	Skinshops[#Skinshops+1] = { -2968.65,-375.82,19.71,340.16 } -- mansao198
	Skinshops[#Skinshops+1] = { 1133.63,-1518.37,34.84,66.08 } -- paramedic
	Skinshops[#Skinshops+1] = { -151.55,1275.47,311.45,136.07 } -- QG_379
	Skinshops[#Skinshops+1] = { -167.82,1241.52,306.52,317.96 } -- mansao180
	Skinshops[#Skinshops+1] = { -3443.52,826.69,19.63,5.67 } -- mansao178
	Skinshops[#Skinshops+1] = { 3435.74,4943.86,39.85,317.49 } -- Mansao175
	Skinshops[#Skinshops+1] = { -1561.81,-569.01,108.51,121.89 } -- Mansao174
	Skinshops[#Skinshops+1] = { -3068.65,3456.45,10.03,255.12 } -- mansao93
	Skinshops[#Skinshops+1] = { -554.14,1192.33,334.08,280.63 } -- AlphaA1
	Skinshops[#Skinshops+1] = { -575.98,1193.24,334.08,184.26 } -- AlphaA2
	Skinshops[#Skinshops+1] = { -604.07,1192.34,334.08,269.3 } -- AlphaA3
	Skinshops[#Skinshops+1] = { -628.87,1192.29,334.08,283.47 } -- AlphaA4
	Skinshops[#Skinshops+1] = { -543.57,1251.58,334.08,85.04 } -- AlphaB1
	Skinshops[#Skinshops+1] = { -568.49,1251.75,334.08,110.56 } -- AlphaB2
	Skinshops[#Skinshops+1] = { -593.38,1251.64,334.08,102.05 } -- AlphaB3
	Skinshops[#Skinshops+1] = { -618.02,1251.67,334.08,87.88 } -- AlphaB4
	Skinshops[#Skinshops+1] = { -2680.41,1156.48,167.64,90.71 } -- Alpha2A1
	Skinshops[#Skinshops+1] = { -2705.23,1155.46,167.64,93.55 } -- Alpha2A2
	Skinshops[#Skinshops+1] = { -2730.14,1154.5,167.64,96.38 } -- Alpha2A3
	Skinshops[#Skinshops+1] = { -2755.1,1153.55,167.64,90.71 } -- Alpha2A4
	Skinshops[#Skinshops+1] = { -2671.39,1216.28,167.64,277.8 } -- Alpha2B1
	Skinshops[#Skinshops+1] = { -2696.07,1215.24,167.64,272.13 } -- Alpha2B2
	Skinshops[#Skinshops+1] = { -2721.03,1214.27,167.64,266.46 } -- Alpha2B3
	Skinshops[#Skinshops+1] = { -2746.06,1213.4,167.64,274.97 } -- Alpha2B4
	Skinshops[#Skinshops+1] = { -1017.01,1134.35,225.37,82.21 } -- Alpha3B1
	Skinshops[#Skinshops+1] = { -1024.91,1094.09,225.37,82.21 } -- Alpha3B2
	Skinshops[#Skinshops+1] = { -1032.56,1053.6,225.37,79.38 } -- Alpha3B3
	Skinshops[#Skinshops+1] = { -973.09,1019.16,225.37,82.21 } -- Alpha3B4
	Skinshops[#Skinshops+1] = { -965.32,1059.39,225.37,87.88 } -- Alpha3B5
	Skinshops[#Skinshops+1] = { -957.27,1099.48,225.37,68.04 } -- Alpha3B6
	Skinshops[#Skinshops+1] = { -2349.97,3266.35,32.81,154.02 }
	-- Skinshops[#Skinshops+1] = { -1514.82,-1468.04,6.39,206.93 } -- Atlantis
	Skinshops[#Skinshops+1] = { -1695.24,-1130.01,14.0,147.41 }
	Skinshops[#Skinshops+1] = { -1699.29,-1126.98,14.0,226.78 }
	Skinshops[#Skinshops+1] = { 123.2,-98.87,49.57,133.23 } -- mansao146
	-- Skinshops[#Skinshops+1] = { -304.41,6274.05,34.79,119.06 } -- mansao128
	Skinshops[#Skinshops+1] = { 958.7,-966.6,42.95,263.63 } -- mecanica
	Skinshops[#Skinshops+1] = { -2025.86,-654.70,6.78,315.17 } -- mansao75
	Skinshops[#Skinshops+1] = { -417.98,4372.91,61.35,184.26 } -- mansao94
	Skinshops[#Skinshops+1] = { -2675.31,1307.53,152.01,277.90 } -- mansao119
	-- Skinshops[#Skinshops+1] = { 127.86,-1298.24,21.11,127.56 } -- Mansao116
	Skinshops[#Skinshops+1] = { 791.97,5736.84,702.57,76.54 } -- mansao90
	-- Skinshops[#Skinshops+1] = { 2023.49,-1600.29,258.50,347.38 } -- mansao101
	Skinshops[#Skinshops+1] = { 3496.16,-3283.35,10.62,25.52 } -- mansao103
	Skinshops[#Skinshops+1] = { 840.40,-124.81,79.77,60.72 } -- mansao105
	Skinshops[#Skinshops+1] = { -3803.98,287.45,158.80,171.05 } -- mansao108
	Skinshops[#Skinshops+1] = { -3529.43,4608.58,10.05,291.43 } -- mansao114
	Skinshops[#Skinshops+1] = { 93.40,6517.33,31.26,305.00 } -- QG_131
	Skinshops[#Skinshops+1] = { 660.40,2090.36,115.28,49.34 } -- QG_174
	Skinshops[#Skinshops+1] = { -1729.43,374.72,89.72,230.96 } -- QG_154
	Skinshops[#Skinshops+1] = { 180.28,1715.41,231.16,344.05 } -- QG_161 / mansao15
	Skinshops[#Skinshops+1] = { -2086.45,-303.38,13.24,167.25 } -- QG_156
	Skinshops[#Skinshops+1] = { -523.98,514.28,108.08,315.38 } -- QG_158
	-- Skinshops[#Skinshops+1] = { 1185.11,873.56,144.00,161.87 } -- QG_159 / Mansao53
	Skinshops[#Skinshops+1] = { -1368.02,-613.34,30.32,34.56 } -- QG_148
	Skinshops[#Skinshops+1] = { -632.41,-134.04,43.22,93.55 } -- Bombeiros
	Skinshops[#Skinshops+1] = { 1150.65,-1583.05,35.28,138.9 } -- hp
	Skinshops[#Skinshops+1] = { 458.14,-999.19,30.68,331.66 } -- Militar
	Skinshops[#Skinshops+1] = { -437.84,6012.35,36.99,357.17 } -- civil
	Skinshops[#Skinshops+1] = { -780.21,-1211.9,10.38,141.74 } -- Tatica
	Skinshops[#Skinshops+1] = { -1887.58,3026.39,32.96,328.82 } -- Exercito
	Skinshops[#Skinshops+1] = { 1075.28,3273.75,41.11,198.43 } -- umbrella
	Skinshops[#Skinshops+1] = { 875.42,1860.9,142.5,226.78 } -- Metgala
	Skinshops[#Skinshops+1] = { -2197.05,-275.16,35.79,257.96 } -- Gang4
	Skinshops[#Skinshops+1] = { -458.91,-1264.9,25.48,51.03 } -- Afetados
	Skinshops[#Skinshops+1] = { 413.04,6468.02,29.82,274.97 } -- Pinkmans
	Skinshops[#Skinshops+1] = { 1513.4,1356.95,108.29,286.3 } -- Gang9
	Skinshops[#Skinshops+1] = { 957.6,-2390.99,22.33,175.75 } -- China
	Skinshops[#Skinshops+1] = { 3047.53,-4136.9,9.86,351.5 }
	-- Skinshops[#Skinshops+1] = { 1030.2,-2550.23,32.28,85.04 } -- Vermelhos
	Skinshops[#Skinshops+1] = { 1797.05,441.96,172.34,59.53 } -- Azul
	Skinshops[#Skinshops+1] = { 2133.61,-15.7,227.22,45.36 } -- Rosa
	Skinshops[#Skinshops+1] = { 2742.43,2716.88,55.84,48.19 } -- Sindicato
	-- Skinshops[#Skinshops+1] = { -139.96,-1609.06,35.03,68.04 } -- Groove
	-- Skinshops[#Skinshops+1] = { 2115.64,3886.09,33.23,215.44 } -- Roxos
	Skinshops[#Skinshops+1] = { 514.2,370.01,151.73,104.89 } -- Roxos
	Skinshops[#Skinshops+1] = { 358.11,-2033.39,22.39,48.19 } -- Vagos
	Skinshops[#Skinshops+1] = { 117.31,-1962.14,21.33,201.26 } -- Ballas
	Skinshops[#Skinshops+1] = { 755.82,-203.84,70.63,289.14 } -- QG_34
	Skinshops[#Skinshops+1] = { 755.7,-203.72,70.63,280.63 } -- QG_113
	Skinshops[#Skinshops+1] = { 1221.1,-1858.54,45.71,289.14 } -- QG_116
	Skinshops[#Skinshops+1] = { 1330.04,-707.86,67.28,116.23 } -- QG_117
	Skinshops[#Skinshops+1] = { -2189.20,4283.77,49.18,196.14 } -- QG_144
	-- Skinshops[#Skinshops+1] = {  103.51,3613.09,40.49,175.75 } -- Laranja
	Skinshops[#Skinshops+1] = { 291.24,216.89,78.82,277.8 } -- Bahamas
	Skinshops[#Skinshops+1] = { 945.01,47.64,80.29,53.86 } -- Bellagio
	Skinshops[#Skinshops+1] = { -1540.36,321.5,87.25,73.71 } -- Lavajato
	Skinshops[#Skinshops+1] = { 102.53,-1311.89,21.13,31.19 } -- Putaria
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { -3320.91,548.73,13.77,303.31 } -- Arcade
	Skinshops[#Skinshops+1] = { 414.94,-23.43,91.93,56.7 } -- Callisto
	Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
	Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
	Skinshops[#Skinshops+1] = { -203.27,-1330.04,34.9,127.56 } -- Undergrounds
	Skinshops[#Skinshops+1] = { 1382.88,-2093.85,47.21,31.19 } -- fazer
	Skinshops[#Skinshops+1] = { 2361.62,5647.1,92.71,141.74 } -- Topgear
	Skinshops[#Skinshops+1] = { 1378.51,-2096.32,52.6,39.69  } -- FerroVelho
	Skinshops[#Skinshops+1] = { 2643.51,3636.15,106.73,39.69 } -- Morro-do-Sacola
	Skinshops[#Skinshops+1] = { 883.73,-2100.55,30.46,175.75 } -- CarClube
	Skinshops[#Skinshops+1] = { -337.81,-166.57,44.58,272.13 } -- Virtude
	Skinshops[#Skinshops+1] = { 134.68,-369.75,50.33,17.01 } -- Big
	Skinshops[#Skinshops+1] = { 2742.47,3500.22,61.3,357.17} -- Kraken
	Skinshops[#Skinshops+1] = { -1149.56,-1554.59,7.63,153.08 } -- bandoleros
	Skinshops[#Skinshops+1] = { 556.33,-2773.46,6.08,59.53 } -- Gang5
	Skinshops[#Skinshops+1] = { 99.06,1229.61,207.17,345.83 } -- Mayans
	Skinshops[#Skinshops+1] = { 1028.6,-2550.72,32.28,351.5 } -- soa
	Skinshops[#Skinshops+1] = { 1026.51,-2542.27,28.29,170.08 } -- hellsangels
	Skinshops[#Skinshops+1] = { 3234.18,5120.17,20.15,116.23 }
	Skinshops[#Skinshops+1] = { 2312.64,5568.36,51.91,343.0 } -- sinaloa
	Skinshops[#Skinshops+1] = { -60.09,994.66,239.52,328.82 } -- gringa
	Skinshops[#Skinshops+1] = { -1539.52,141.51,55.65,51.03 } -- bloods
	-- Skinshops[#Skinshops+1] = { -2804.84,2261.69,24.11,320.32 } -- bloods secundario
	Skinshops[#Skinshops+1] = { -3025.46,59.49,11.95,331.66 } -- crips
	Skinshops[#Skinshops+1] = { -339.2,-1523.7,29.34,22.68 } -- warlocks
	Skinshops[#Skinshops+1] = { -1814.54,447.96,127.91,351.5 } -- mexicana
	Skinshops[#Skinshops+1] = { -1887.16,2070.1,145.57,334.49 } -- russa
	Skinshops[#Skinshops+1] = { -1491.07,845.77,181.59,87.88 } -- irlandesa
	Skinshops[#Skinshops+1] = { 173.45,668.33,207.66,104.89 } -- triade
	Skinshops[#Skinshops+1] = { 420.53,-1483.85,33.8,116.23 } -- italiana
	Skinshops[#Skinshops+1] = { 2332.3,5524.54,51.68,249.45 } -- overdrive
	Skinshops[#Skinshops+1] = { -776.37,-2593.33,17.66,238.12 } -- Outlaws 
	Skinshops[#Skinshops+1] = { -617.15,-1617.33,33.01,172.92 } -- Topgear 
	Skinshops[#Skinshops+1] = { -290.78,1986.24,166.14,334.49 } -- israel
	-- Skinshops[#Skinshops+1] = { 1078.37,-1973.3,31.48,235.28 } -- gringa
	Skinshops[#Skinshops+1] = { -303.2,220.21,77.91,257.96 } -- luxor
	Skinshops[#Skinshops+1] = { 1252.95,-1720.72,56.45,65.2 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1289.66,-1762.54,54.21,22.68 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1338.0,-792.43,71.51,343.0 } -- brancos
	Skinshops[#Skinshops+1] = { 1346.33,-705.11,67.74,73.71 } -- brancos
	-- Skinshops[#Skinshops+1] = { 1267.24,-299.03,84.59,158.75 } -- barragem
	Skinshops[#Skinshops+1] = { 1251.62,-265.92,77.91,107.72 } -- barragem
	Skinshops[#Skinshops+1] = { 1506.8,-2368.57,78.03,274.97 } -- rosas
	Skinshops[#Skinshops+1] = { 1512.78,-2365.16,78.03,195.6 } -- rosas
	-- Skinshops[#Skinshops+1] = { 2225.07,3452.81,61.33,172.92 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2229.55,3452.95,61.33,170.08 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2226.14,3453.91,61.33,187.09 } -- cinzas
	Skinshops[#Skinshops+1] = { 103.67,1221.91,207.17,102.05 } -- SOA
	Skinshops[#Skinshops+1] = { 1306.65,-735.32,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -215.34,-1334.28,34.9,266.46 } -- bennys
	Skinshops[#Skinshops+1] = { 1048.13,888.82,220.34,48.19 } -- playboy
	Skinshops[#Skinshops+1] = { 1341.91,-790.49,71.51,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { 1336.42,-788.7,71.51,348.67 } -- brancos
	Skinshops[#Skinshops+1] = { 1308.3,-733.85,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -1550.84,-393.9,41.97,51.03 } -- 
	Skinshops[#Skinshops+1] = { -3337.8,543.54,17.44,215.44 } -- mansao 60
	Skinshops[#Skinshops+1] = { 1963.43,6415.17,61.7,311.82 } -- marrons
	Skinshops[#Skinshops+1] = { -2272.06,323.23,174.6,22.68 }
	Skinshops[#Skinshops+1] = { -1687.17,-3185.18,14.0,243.78 }
	Skinshops[#Skinshops+1] = { 1402.74,1154.66,114.33,266.46 } -- fazendinha
	Skinshops[#Skinshops+1] = { 747.78,-308.18,59.8,306.15 } -- Campinho
	Skinshops[#Skinshops+1] = { 905.89,339.35,112.29,345.83 } -- Japao
	Skinshops[#Skinshops+1] = { -1044.65,305.04,71.66,266.46 } -- Inglaterra
	Skinshops[#Skinshops+1] = { -2022.42,4435.69,53.09,345.83 } -- Banzas
	Skinshops[#Skinshops+1] = { 355.76,-2729.82,1.72,257.96 } -- Dixavas
	Skinshops[#Skinshops+1] = { -769.38,8.1,40.64,345.83 } 
	Skinshops[#Skinshops+1] = { 1471.81,6539.39,18.64,85.04 } -- pier norte
	Skinshops[#Skinshops+1] = { -602.0,-914.22,23.88,184.26 } -- Anonymous
	Skinshops[#Skinshops+1] = { -602.7,-923.49,17.59,328.82 } -- Anonymous
	Skinshops[#Skinshops+1] = { -2813.9,2266.37,24.33,354.34 } -- qg 71
	Skinshops[#Skinshops+1] = { 676.42,909.22,247.57,170.08 } -- Inglaterra
	Skinshops[#Skinshops+1] = { 5026.55,-5760.97,15.77,232.45 } -- Caribe
	Skinshops[#Skinshops+1] = { 2612.27,5333.94,47.57,59.53 } -- prf
	Skinshops[#Skinshops+1] = { 3088.32,5091.99,23.25,73.71 } -- qg_80
	Skinshops[#Skinshops+1] = { -156.96,8259.62,12.82,11.34 } -- iate
	Skinshops[#Skinshops+1] = { -1784.4,-1376.75,11.88,39.69 } -- iate
	Skinshops[#Skinshops+1] = { -1883.34,-1164.43,11.73,320.32 } -- iate
	Skinshops[#Skinshops+1] = { -2210.16,-586.48,11.73,232.45 } 
	Skinshops[#Skinshops+1] = { -1179.62,302.46,73.67,102.05 } -- qg_82
	Skinshops[#Skinshops+1] = { -1226.24,-1737.73,4.53,138.9 } -- qg_83
	Skinshops[#Skinshops+1] = { -2423.52,1790.06,185.48,39.69 } -- qg_84
	Skinshops[#Skinshops+1] = { -878.0,-1434.81,7.53,201.26 } -- qg_85
	Skinshops[#Skinshops+1] = { -539.93,5002.83,159.92,272.13 } -- qg_86
	Skinshops[#Skinshops+1] = { -2675.14,1307.61,152.0,272.13 } -- qg_87
	Skinshops[#Skinshops+1] = { -2277.87,336.33,178.57,300.48 } -- qg_88
	Skinshops[#Skinshops+1] = { 3482.3,5015.04,11.91,212.6 }
	Skinshops[#Skinshops+1] = { -4504.72,-70.94,12.81,164.41 }
	Skinshops[#Skinshops+1] = { 994.15,3403.17,61.97,280.63 } -- QG_31
	Skinshops[#Skinshops+1] = { 89.54,-1966.65,20.74,320.32 } -- QG_43
	Skinshops[#Skinshops+1] = { 2456.34,4980.02,46.83,158.75 } -- QG_64
	Skinshops[#Skinshops+1] = { -2813.7,2266.54,24.31,343.0 } -- QG_124
	Skinshops[#Skinshops+1] = { 866.7,1872.27,144.52,138.9 } -- QG_126
	Skinshops[#Skinshops+1] = { 1378.59,-2096.53,52.6,306.15 } -- QG_68
	Skinshops[#Skinshops+1] = { -2598.64,1889.43,163.75,323.7 } -- QG_129
	Skinshops[#Skinshops+1] = { 2022.46,3373.80,46.60,80.00 } -- Mansao13
	Skinshops[#Skinshops+1] = { 694.59,1251.54,361.04,348.67 } -- Mansao286
	Skinshops[#Skinshops+1] = { 692.27,1245.24,361.01,82.21 } -- Mansao286
	Skinshops[#Skinshops+1] = { 691.85,1247.06,367.92,249.45 } -- Mansao286

elseif cityName == "Imperium" then
	Skinshops[#Skinshops+1] = { -3527.02,1278.03,13.26,343.0 }
	Skinshops[#Skinshops+1] = { -3068.65,3456.45,10.03,255.12 } -- mansao93
	Skinshops[#Skinshops+1] = { -554.14,1192.33,334.08,280.63 } -- AlphaA1
	Skinshops[#Skinshops+1] = { -575.98,1193.24,334.08,184.26 } -- AlphaA2
	Skinshops[#Skinshops+1] = { -604.07,1192.34,334.08,269.3 } -- AlphaA3
	Skinshops[#Skinshops+1] = { -628.87,1192.29,334.08,283.47 } -- AlphaA4
	Skinshops[#Skinshops+1] = { -543.57,1251.58,334.08,85.04 } -- AlphaB1
	Skinshops[#Skinshops+1] = { -568.49,1251.75,334.08,110.56 } -- AlphaB2
	Skinshops[#Skinshops+1] = { -593.38,1251.64,334.08,102.05 } -- AlphaB3
	Skinshops[#Skinshops+1] = { -618.02,1251.67,334.08,87.88 } -- AlphaB4
	Skinshops[#Skinshops+1] = { -2680.41,1156.48,167.64,90.71 } -- Alpha2A1
	Skinshops[#Skinshops+1] = { -2705.23,1155.46,167.64,93.55 } -- Alpha2A2
	Skinshops[#Skinshops+1] = { -2730.14,1154.5,167.64,96.38 } -- Alpha2A3
	Skinshops[#Skinshops+1] = { -2755.1,1153.55,167.64,90.71 } -- Alpha2A4
	Skinshops[#Skinshops+1] = { -2671.39,1216.28,167.64,277.8 } -- Alpha2B1
	Skinshops[#Skinshops+1] = { -2696.07,1215.24,167.64,272.13 } -- Alpha2B2
	Skinshops[#Skinshops+1] = { -2721.03,1214.27,167.64,266.46 } -- Alpha2B3
	Skinshops[#Skinshops+1] = { -2746.06,1213.4,167.64,274.97 } -- Alpha2B4
	Skinshops[#Skinshops+1] = { -2349.97,3266.35,32.81,154.02 }
	Skinshops[#Skinshops+1] = { -1514.82,-1468.04,6.39,206.93 } -- Atlantis
	Skinshops[#Skinshops+1] = { -1695.24,-1130.01,14.0,147.41 }
	Skinshops[#Skinshops+1] = { -1699.29,-1126.98,14.0,226.78 }
	Skinshops[#Skinshops+1] = { 123.2,-98.87,49.57,133.23 } -- mansao146
	Skinshops[#Skinshops+1] = { -304.41,6274.05,34.79,119.06 } -- mansao128
	Skinshops[#Skinshops+1] = { -1136.33,-2076.44,21.28,223.94 } -- mecanica
	Skinshops[#Skinshops+1] = { -2025.86,-654.70,6.78,315.17 } -- mansao75
	Skinshops[#Skinshops+1] = { -417.98,4372.91,61.35,184.26 } -- mansao94
	Skinshops[#Skinshops+1] = { -2675.31,1307.53,152.01,277.90 } -- mansao119
	Skinshops[#Skinshops+1] = { 127.86,-1298.24,21.11,127.56 } -- Mansao116
	Skinshops[#Skinshops+1] = { 791.97,5736.84,702.57,76.54 } -- mansao90
	Skinshops[#Skinshops+1] = { 2023.49,-1600.29,258.50,347.38 } -- mansao101
	Skinshops[#Skinshops+1] = { 3496.16,-3283.35,10.62,25.52 } -- mansao103
	Skinshops[#Skinshops+1] = { 840.40,-124.81,79.77,60.72 } -- mansao105
	Skinshops[#Skinshops+1] = { -3803.98,287.45,158.80,171.05 } -- mansao108
	Skinshops[#Skinshops+1] = { -3529.43,4608.58,10.05,291.43 } -- mansao114
	Skinshops[#Skinshops+1] = { 93.40,6517.33,31.26,305.00 } -- QG_131
	Skinshops[#Skinshops+1] = { 660.40,2090.36,115.28,49.34 } -- QG_174
	Skinshops[#Skinshops+1] = { -1729.43,374.72,89.72,230.96 } -- QG_154
	Skinshops[#Skinshops+1] = { 180.28,1715.41,231.16,344.05 } -- QG_161 / mansao15
	Skinshops[#Skinshops+1] = { -2086.45,-303.38,13.24,167.25 } -- QG_156
	Skinshops[#Skinshops+1] = { -523.98,514.28,108.08,315.38 } -- QG_158
	-- Skinshops[#Skinshops+1] = { 1185.11,873.56,144.00,161.87 } -- QG_159 / Mansao53
	Skinshops[#Skinshops+1] = { -1368.02,-613.34,30.32,34.56 } -- QG_148
	Skinshops[#Skinshops+1] = { 958.86,-966.6,42.95,348.67 } -- mecanica
	Skinshops[#Skinshops+1] = { -632.41,-134.04,43.22,93.55 } -- Bombeiros
	Skinshops[#Skinshops+1] = { 1150.65,-1583.05,35.28,138.9 } -- hp
	Skinshops[#Skinshops+1] = { 458.14,-999.19,30.68,331.66 } -- Militar
	Skinshops[#Skinshops+1] = { -437.84,6012.35,36.99,357.17 } -- civil
	Skinshops[#Skinshops+1] = { -780.21,-1211.9,10.38,141.74 } -- Tatica
	Skinshops[#Skinshops+1] = { -1887.58,3026.39,32.96,328.82 } -- Exercito
	Skinshops[#Skinshops+1] = { 1075.28,3273.75,41.11,198.43 } -- umbrella
	Skinshops[#Skinshops+1] = { 875.42,1860.9,142.5,226.78 } -- Metgala
	Skinshops[#Skinshops+1] = { -2197.05,-275.16,35.79,257.96 } -- Gang4
	Skinshops[#Skinshops+1] = { -458.91,-1264.9,25.48,51.03 } -- Afetados
	Skinshops[#Skinshops+1] = { 413.04,6468.02,29.82,274.97 } -- Pinkmans
	Skinshops[#Skinshops+1] = { 1513.4,1356.95,108.29,286.3 } -- Gang9
	Skinshops[#Skinshops+1] = { 957.6,-2390.99,22.33,175.75 } -- China
	Skinshops[#Skinshops+1] = { 3047.53,-4136.9,9.86,351.5 }
	-- Skinshops[#Skinshops+1] = { 1030.2,-2550.23,32.28,85.04 } -- Vermelhos
	Skinshops[#Skinshops+1] = { 1797.05,441.96,172.34,59.53 } -- Azul
	Skinshops[#Skinshops+1] = { 2133.61,-15.7,227.22,45.36 } -- Rosa
	Skinshops[#Skinshops+1] = { 2742.43,2716.88,55.84,48.19 } -- Sindicato
	-- Skinshops[#Skinshops+1] = { -139.96,-1609.06,35.03,68.04 } -- Groove
	-- Skinshops[#Skinshops+1] = { 2115.64,3886.09,33.23,215.44 } -- Roxos
	Skinshops[#Skinshops+1] = { 514.2,370.01,151.73,104.89 } -- Roxos
	Skinshops[#Skinshops+1] = { 358.11,-2033.39,22.39,48.19 } -- Vagos
	Skinshops[#Skinshops+1] = { 117.31,-1962.14,21.33,201.26 } -- Ballas
	Skinshops[#Skinshops+1] = { 755.82,-203.84,70.63,289.14 } -- QG_34
	Skinshops[#Skinshops+1] = { 755.7,-203.72,70.63,280.63 } -- QG_113
	Skinshops[#Skinshops+1] = { 1221.1,-1858.54,45.71,289.14 } -- QG_116
	Skinshops[#Skinshops+1] = { 1330.04,-707.86,67.28,116.23 } -- QG_117
	Skinshops[#Skinshops+1] = { -2189.20,4283.77,49.18,196.14 } -- QG_144
	-- Skinshops[#Skinshops+1] = {  103.51,3613.09,40.49,175.75 } -- Laranja
	Skinshops[#Skinshops+1] = { 291.24,216.89,78.82,277.8 } -- Bahamas
	Skinshops[#Skinshops+1] = { 945.01,47.64,80.29,53.86 } -- Bellagio
	Skinshops[#Skinshops+1] = { -1540.36,321.5,87.25,73.71 } -- Lavajato
	Skinshops[#Skinshops+1] = { 102.53,-1311.89,21.13,31.19 } -- Putaria
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { -3320.91,548.73,13.77,303.31 } -- Arcade
	Skinshops[#Skinshops+1] = { 414.94,-23.43,91.93,56.7 } -- Callisto
	Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
	Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
	Skinshops[#Skinshops+1] = { -203.27,-1330.04,34.9,127.56 } -- Undergrounds
	Skinshops[#Skinshops+1] = { 1382.88,-2093.85,47.21,31.19 } -- fazer
	Skinshops[#Skinshops+1] = { 2361.62,5647.1,92.71,141.74 } -- Topgear
	Skinshops[#Skinshops+1] = { 1378.51,-2096.32,52.6,39.69  } -- FerroVelho
	Skinshops[#Skinshops+1] = { 2643.51,3636.15,106.73,39.69 } -- Morro-do-Sacola
	Skinshops[#Skinshops+1] = { 883.73,-2100.55,30.46,175.75 } -- CarClube
	Skinshops[#Skinshops+1] = { -337.81,-166.57,44.58,272.13 } -- Virtude
	Skinshops[#Skinshops+1] = { 134.68,-369.75,50.33,17.01 } -- Big
	Skinshops[#Skinshops+1] = { 2742.47,3500.22,61.3,357.17} -- Kraken
	Skinshops[#Skinshops+1] = { -1149.56,-1554.59,7.63,153.08 } -- bandoleros
	Skinshops[#Skinshops+1] = { 556.33,-2773.46,6.08,59.53 } -- Gang5
	Skinshops[#Skinshops+1] = { 99.06,1229.61,207.17,345.83 } -- Mayans
	Skinshops[#Skinshops+1] = { 1028.6,-2550.72,32.28,351.5 } -- soa
	Skinshops[#Skinshops+1] = { 1026.51,-2542.27,28.29,170.08 } -- hellsangels
	Skinshops[#Skinshops+1] = { 3234.18,5120.17,20.15,116.23 }
	Skinshops[#Skinshops+1] = { 2312.64,5568.36,51.91,343.0 } -- sinaloa
	Skinshops[#Skinshops+1] = { -60.09,994.66,239.52,328.82 } -- gringa
	Skinshops[#Skinshops+1] = { -1539.52,141.51,55.65,51.03 } -- bloods
	-- Skinshops[#Skinshops+1] = { -2804.84,2261.69,24.11,320.32 } -- bloods secundario
	Skinshops[#Skinshops+1] = { -3025.46,59.49,11.95,331.66 } -- crips
	Skinshops[#Skinshops+1] = { -339.2,-1523.7,29.34,22.68 } -- warlocks
	Skinshops[#Skinshops+1] = { -1814.54,447.96,127.91,351.5 } -- mexicana
	Skinshops[#Skinshops+1] = { -1887.16,2070.1,145.57,334.49 } -- russa
	Skinshops[#Skinshops+1] = { -1491.07,845.77,181.59,87.88 } -- irlandesa
	Skinshops[#Skinshops+1] = { 173.45,668.33,207.66,104.89 } -- triade
	Skinshops[#Skinshops+1] = { 420.53,-1483.85,33.8,116.23 } -- italiana
	Skinshops[#Skinshops+1] = { 2332.3,5524.54,51.68,249.45 } -- overdrive
	Skinshops[#Skinshops+1] = { -776.37,-2593.33,17.66,238.12 } -- Outlaws 
	Skinshops[#Skinshops+1] = { -617.15,-1617.33,33.01,172.92 } -- Topgear 
	Skinshops[#Skinshops+1] = { -290.78,1986.24,166.14,334.49 } -- israel
	-- Skinshops[#Skinshops+1] = { 1078.37,-1973.3,31.48,235.28 } -- gringa
	Skinshops[#Skinshops+1] = { -303.2,220.21,77.91,257.96 } -- luxor
	Skinshops[#Skinshops+1] = { 1252.95,-1720.72,56.45,65.2 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1289.66,-1762.54,54.21,22.68 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1338.0,-792.43,71.51,343.0 } -- brancos
	Skinshops[#Skinshops+1] = { 1346.33,-705.11,67.74,73.71 } -- brancos
	Skinshops[#Skinshops+1] = { 1267.24,-299.03,84.59,158.75 } -- barragem
	Skinshops[#Skinshops+1] = { 1251.62,-265.92,77.91,107.72 } -- barragem
	Skinshops[#Skinshops+1] = { 1506.8,-2368.57,78.03,274.97 } -- rosas
	Skinshops[#Skinshops+1] = { 1512.78,-2365.16,78.03,195.6 } -- rosas
	-- Skinshops[#Skinshops+1] = { 2225.07,3452.81,61.33,172.92 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2229.55,3452.95,61.33,170.08 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2226.14,3453.91,61.33,187.09 } -- cinzas
	Skinshops[#Skinshops+1] = { 103.67,1221.91,207.17,102.05 } -- SOA
	Skinshops[#Skinshops+1] = { 1306.65,-735.32,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -215.34,-1334.28,34.9,266.46 } -- bennys
	Skinshops[#Skinshops+1] = { 1048.13,888.82,220.34,48.19 } -- playboy
	Skinshops[#Skinshops+1] = { 1341.91,-790.49,71.51,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { 1336.42,-788.7,71.51,348.67 } -- brancos
	Skinshops[#Skinshops+1] = { 1308.3,-733.85,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -1550.84,-393.9,41.97,51.03 } -- 
	Skinshops[#Skinshops+1] = { -3337.8,543.54,17.44,215.44 } -- mansao 60
	Skinshops[#Skinshops+1] = { 1963.43,6415.17,61.7,311.82 } -- marrons
	Skinshops[#Skinshops+1] = { -2272.06,323.23,174.6,22.68 }
	Skinshops[#Skinshops+1] = { -1687.17,-3185.18,14.0,243.78 }
	Skinshops[#Skinshops+1] = { 1402.74,1154.66,114.33,266.46 } -- fazendinha
	Skinshops[#Skinshops+1] = { 747.78,-308.18,59.8,306.15 } -- Campinho
	Skinshops[#Skinshops+1] = { 905.89,339.35,112.29,345.83 } -- Japao
	Skinshops[#Skinshops+1] = { -1044.65,305.04,71.66,266.46 } -- Inglaterra
	Skinshops[#Skinshops+1] = { -2022.42,4435.69,53.09,345.83 } -- Banzas
	Skinshops[#Skinshops+1] = { 355.76,-2729.82,1.72,257.96 } -- Dixavas
	Skinshops[#Skinshops+1] = { -769.38,8.1,40.64,345.83 } 
	Skinshops[#Skinshops+1] = { 1471.81,6539.39,18.64,85.04 } -- pier norte
	Skinshops[#Skinshops+1] = { -602.0,-914.22,23.88,184.26 } -- Anonymous
	Skinshops[#Skinshops+1] = { -602.7,-923.49,17.59,328.82 } -- Anonymous
	Skinshops[#Skinshops+1] = { -2813.9,2266.37,24.33,354.34 } -- qg 71
	Skinshops[#Skinshops+1] = { 676.42,909.22,247.57,170.08 } -- Inglaterra
	Skinshops[#Skinshops+1] = { 5026.55,-5760.97,15.77,232.45 } -- Caribe
	Skinshops[#Skinshops+1] = { 2612.27,5333.94,47.57,59.53 } -- prf
	Skinshops[#Skinshops+1] = { 3088.32,5091.99,23.25,73.71 } -- qg_80
	Skinshops[#Skinshops+1] = { -156.96,8259.62,12.82,11.34 } -- iate
	Skinshops[#Skinshops+1] = { -1784.4,-1376.75,11.88,39.69 } -- iate
	Skinshops[#Skinshops+1] = { -1883.34,-1164.43,11.73,320.32 } -- iate
	Skinshops[#Skinshops+1] = { -2210.16,-586.48,11.73,232.45 } 
	Skinshops[#Skinshops+1] = { -1179.62,302.46,73.67,102.05 } -- qg_82
	Skinshops[#Skinshops+1] = { -1226.24,-1737.73,4.53,138.9 } -- qg_83
	Skinshops[#Skinshops+1] = { -2423.52,1790.06,185.48,39.69 } -- qg_84
	Skinshops[#Skinshops+1] = { -878.0,-1434.81,7.53,201.26 } -- qg_85
	Skinshops[#Skinshops+1] = { -539.93,5002.83,159.92,272.13 } -- qg_86
	Skinshops[#Skinshops+1] = { -2675.14,1307.61,152.0,272.13 } -- qg_87
	Skinshops[#Skinshops+1] = { -2277.87,336.33,178.57,300.48 } -- qg_88
	Skinshops[#Skinshops+1] = { 3482.3,5015.04,11.91,212.6 }
	Skinshops[#Skinshops+1] = { -4504.72,-70.94,12.81,164.41 }
	Skinshops[#Skinshops+1] = { 994.15,3403.17,61.97,280.63 } -- QG_31
	Skinshops[#Skinshops+1] = { 89.54,-1966.65,20.74,320.32 } -- QG_43
	Skinshops[#Skinshops+1] = { 2456.34,4980.02,46.83,158.75 } -- QG_64
	Skinshops[#Skinshops+1] = { -2813.7,2266.54,24.31,343.0 } -- QG_124
	Skinshops[#Skinshops+1] = { 866.7,1872.27,144.52,138.9 } -- QG_126
	Skinshops[#Skinshops+1] = { 1378.59,-2096.53,52.6,306.15 } -- QG_68
	Skinshops[#Skinshops+1] = { -669.18,6391.58,13.02,133.53 } -- QG_128
	Skinshops[#Skinshops+1] = { -2598.64,1889.43,163.75,323.7 } -- QG_129
	Skinshops[#Skinshops+1] = { 2022.46,3373.80,46.60,80.00 } -- QG_130
elseif cityName == "GoatRP" then
	Skinshops[#Skinshops+1] = { -3527.02,1278.03,13.26,343.0 }
	Skinshops[#Skinshops+1] = { -3068.65,3456.45,10.03,255.12 } -- mansao93
	Skinshops[#Skinshops+1] = { -554.14,1192.33,334.08,280.63 } -- AlphaA1
	Skinshops[#Skinshops+1] = { -575.98,1193.24,334.08,184.26 } -- AlphaA2
	Skinshops[#Skinshops+1] = { -604.07,1192.34,334.08,269.3 } -- AlphaA3
	Skinshops[#Skinshops+1] = { -628.87,1192.29,334.08,283.47 } -- AlphaA4
	Skinshops[#Skinshops+1] = { -543.57,1251.58,334.08,85.04 } -- AlphaB1
	Skinshops[#Skinshops+1] = { -568.49,1251.75,334.08,110.56 } -- AlphaB2
	Skinshops[#Skinshops+1] = { -593.38,1251.64,334.08,102.05 } -- AlphaB3
	Skinshops[#Skinshops+1] = { -618.02,1251.67,334.08,87.88 } -- AlphaB4
	Skinshops[#Skinshops+1] = { -2680.41,1156.48,167.64,90.71 } -- Alpha2A1
	Skinshops[#Skinshops+1] = { -2705.23,1155.46,167.64,93.55 } -- Alpha2A2
	Skinshops[#Skinshops+1] = { -2730.14,1154.5,167.64,96.38 } -- Alpha2A3
	Skinshops[#Skinshops+1] = { -2755.1,1153.55,167.64,90.71 } -- Alpha2A4
	Skinshops[#Skinshops+1] = { -2671.39,1216.28,167.64,277.8 } -- Alpha2B1
	Skinshops[#Skinshops+1] = { -2696.07,1215.24,167.64,272.13 } -- Alpha2B2
	Skinshops[#Skinshops+1] = { -2721.03,1214.27,167.64,266.46 } -- Alpha2B3
	Skinshops[#Skinshops+1] = { -2746.06,1213.4,167.64,274.97 } -- Alpha2B4
	Skinshops[#Skinshops+1] = { -2349.97,3266.35,32.81,154.02 }
	Skinshops[#Skinshops+1] = { -1514.82,-1468.04,6.39,206.93 } -- Atlantis
	Skinshops[#Skinshops+1] = { -1695.24,-1130.01,14.0,147.41 }
	Skinshops[#Skinshops+1] = { -1699.29,-1126.98,14.0,226.78 }
	Skinshops[#Skinshops+1] = { 123.2,-98.87,49.57,133.23 } -- mansao146
	Skinshops[#Skinshops+1] = { -304.41,6274.05,34.79,119.06 } -- mansao128
	Skinshops[#Skinshops+1] = { -1136.33,-2076.44,21.28,223.94 } -- mecanica
	Skinshops[#Skinshops+1] = { -2025.86,-654.70,6.78,315.17 } -- mansao75
	Skinshops[#Skinshops+1] = { -417.98,4372.91,61.35,184.26 } -- mansao94
	Skinshops[#Skinshops+1] = { -2675.31,1307.53,152.01,277.90 } -- mansao119
	Skinshops[#Skinshops+1] = { 127.86,-1298.24,21.11,127.56 } -- Mansao116
	Skinshops[#Skinshops+1] = { 791.97,5736.84,702.57,76.54 } -- mansao90
	Skinshops[#Skinshops+1] = { 2023.49,-1600.29,258.50,347.38 } -- mansao101
	Skinshops[#Skinshops+1] = { 3496.16,-3283.35,10.62,25.52 } -- mansao103
	Skinshops[#Skinshops+1] = { 840.40,-124.81,79.77,60.72 } -- mansao105
	Skinshops[#Skinshops+1] = { -3803.98,287.45,158.80,171.05 } -- mansao108
	Skinshops[#Skinshops+1] = { -3529.43,4608.58,10.05,291.43 } -- mansao114
	Skinshops[#Skinshops+1] = { 93.40,6517.33,31.26,305.00 } -- QG_131
	Skinshops[#Skinshops+1] = { 660.40,2090.36,115.28,49.34 } -- QG_174
	Skinshops[#Skinshops+1] = { -1729.43,374.72,89.72,230.96 } -- QG_154
	Skinshops[#Skinshops+1] = { 180.28,1715.41,231.16,344.05 } -- QG_161 / mansao15
	Skinshops[#Skinshops+1] = { -2086.45,-303.38,13.24,167.25 } -- QG_156
	Skinshops[#Skinshops+1] = { -523.98,514.28,108.08,315.38 } -- QG_158
	-- Skinshops[#Skinshops+1] = { 1185.11,873.56,144.00,161.87 } -- QG_159 / Mansao53
	Skinshops[#Skinshops+1] = { -1368.02,-613.34,30.32,34.56 } -- QG_148
	Skinshops[#Skinshops+1] = { 958.86,-966.6,42.95,348.67 } -- mecanica
	Skinshops[#Skinshops+1] = { -632.41,-134.04,43.22,93.55 } -- Bombeiros
	Skinshops[#Skinshops+1] = { 1150.65,-1583.05,35.28,138.9 } -- hp
	Skinshops[#Skinshops+1] = { 458.14,-999.19,30.68,331.66 } -- Militar
	Skinshops[#Skinshops+1] = { -437.84,6012.35,36.99,357.17 } -- civil
	Skinshops[#Skinshops+1] = { -780.21,-1211.9,10.38,141.74 } -- Tatica
	Skinshops[#Skinshops+1] = { -1887.58,3026.39,32.96,328.82 } -- Exercito
	Skinshops[#Skinshops+1] = { 1075.28,3273.75,41.11,198.43 } -- umbrella
	Skinshops[#Skinshops+1] = { 875.42,1860.9,142.5,226.78 } -- Metgala
	Skinshops[#Skinshops+1] = { -2197.05,-275.16,35.79,257.96 } -- Gang4
	Skinshops[#Skinshops+1] = { -458.91,-1264.9,25.48,51.03 } -- Afetados
	Skinshops[#Skinshops+1] = { 413.04,6468.02,29.82,274.97 } -- Pinkmans
	Skinshops[#Skinshops+1] = { 1513.4,1356.95,108.29,286.3 } -- Gang9
	Skinshops[#Skinshops+1] = { 957.6,-2390.99,22.33,175.75 } -- China
	Skinshops[#Skinshops+1] = { 3047.53,-4136.9,9.86,351.5 }
	-- Skinshops[#Skinshops+1] = { 1030.2,-2550.23,32.28,85.04 } -- Vermelhos
	Skinshops[#Skinshops+1] = { 1797.05,441.96,172.34,59.53 } -- Azul
	Skinshops[#Skinshops+1] = { 2133.61,-15.7,227.22,45.36 } -- Rosa
	Skinshops[#Skinshops+1] = { 2742.43,2716.88,55.84,48.19 } -- Sindicato
	-- Skinshops[#Skinshops+1] = { -139.96,-1609.06,35.03,68.04 } -- Groove
	-- Skinshops[#Skinshops+1] = { 2115.64,3886.09,33.23,215.44 } -- Roxos
	Skinshops[#Skinshops+1] = { 514.2,370.01,151.73,104.89 } -- Roxos
	Skinshops[#Skinshops+1] = { 358.11,-2033.39,22.39,48.19 } -- Vagos
	Skinshops[#Skinshops+1] = { 117.31,-1962.14,21.33,201.26 } -- Ballas
	Skinshops[#Skinshops+1] = { 755.82,-203.84,70.63,289.14 } -- QG_34
	Skinshops[#Skinshops+1] = { 755.7,-203.72,70.63,280.63 } -- QG_113
	Skinshops[#Skinshops+1] = { 1221.1,-1858.54,45.71,289.14 } -- QG_116
	Skinshops[#Skinshops+1] = { 1330.04,-707.86,67.28,116.23 } -- QG_117
	Skinshops[#Skinshops+1] = { -2189.20,4283.77,49.18,196.14 } -- QG_144
	-- Skinshops[#Skinshops+1] = {  103.51,3613.09,40.49,175.75 } -- Laranja
	Skinshops[#Skinshops+1] = { 291.24,216.89,78.82,277.8 } -- Bahamas
	Skinshops[#Skinshops+1] = { 945.01,47.64,80.29,53.86 } -- Bellagio
	Skinshops[#Skinshops+1] = { -1540.36,321.5,87.25,73.71 } -- Lavajato
	Skinshops[#Skinshops+1] = { 102.53,-1311.89,21.13,31.19 } -- Putaria
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { -3320.91,548.73,13.77,303.31 } -- Arcade
	Skinshops[#Skinshops+1] = { 414.94,-23.43,91.93,56.7 } -- Callisto
	Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
	Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
	Skinshops[#Skinshops+1] = { -203.27,-1330.04,34.9,127.56 } -- Undergrounds
	Skinshops[#Skinshops+1] = { 1382.88,-2093.85,47.21,31.19 } -- fazer
	Skinshops[#Skinshops+1] = { 2361.62,5647.1,92.71,141.74 } -- Topgear
	Skinshops[#Skinshops+1] = { 1378.51,-2096.32,52.6,39.69  } -- FerroVelho
	Skinshops[#Skinshops+1] = { 2643.51,3636.15,106.73,39.69 } -- Morro-do-Sacola
	Skinshops[#Skinshops+1] = { 883.73,-2100.55,30.46,175.75 } -- CarClube
	Skinshops[#Skinshops+1] = { -337.81,-166.57,44.58,272.13 } -- Virtude
	Skinshops[#Skinshops+1] = { 134.68,-369.75,50.33,17.01 } -- Big
	Skinshops[#Skinshops+1] = { 2742.47,3500.22,61.3,357.17} -- Kraken
	Skinshops[#Skinshops+1] = { -1149.56,-1554.59,7.63,153.08 } -- bandoleros
	Skinshops[#Skinshops+1] = { 556.33,-2773.46,6.08,59.53 } -- Gang5
	Skinshops[#Skinshops+1] = { 99.06,1229.61,207.17,345.83 } -- Mayans
	Skinshops[#Skinshops+1] = { 1028.6,-2550.72,32.28,351.5 } -- soa
	Skinshops[#Skinshops+1] = { 1026.51,-2542.27,28.29,170.08 } -- hellsangels
	Skinshops[#Skinshops+1] = { 3234.18,5120.17,20.15,116.23 }
	Skinshops[#Skinshops+1] = { 2312.64,5568.36,51.91,343.0 } -- sinaloa
	Skinshops[#Skinshops+1] = { -60.09,994.66,239.52,328.82 } -- gringa
	Skinshops[#Skinshops+1] = { -1539.52,141.51,55.65,51.03 } -- bloods
	-- Skinshops[#Skinshops+1] = { -2804.84,2261.69,24.11,320.32 } -- bloods secundario
	Skinshops[#Skinshops+1] = { -3025.46,59.49,11.95,331.66 } -- crips
	Skinshops[#Skinshops+1] = { -339.2,-1523.7,29.34,22.68 } -- warlocks
	Skinshops[#Skinshops+1] = { -1814.54,447.96,127.91,351.5 } -- mexicana
	Skinshops[#Skinshops+1] = { -1887.16,2070.1,145.57,334.49 } -- russa
	Skinshops[#Skinshops+1] = { -1491.07,845.77,181.59,87.88 } -- irlandesa
	Skinshops[#Skinshops+1] = { 173.45,668.33,207.66,104.89 } -- triade
	Skinshops[#Skinshops+1] = { 420.53,-1483.85,33.8,116.23 } -- italiana
	Skinshops[#Skinshops+1] = { 2332.3,5524.54,51.68,249.45 } -- overdrive
	Skinshops[#Skinshops+1] = { -776.37,-2593.33,17.66,238.12 } -- Outlaws 
	Skinshops[#Skinshops+1] = { -617.15,-1617.33,33.01,172.92 } -- Topgear 
	Skinshops[#Skinshops+1] = { -290.78,1986.24,166.14,334.49 } -- israel
	-- Skinshops[#Skinshops+1] = { 1078.37,-1973.3,31.48,235.28 } -- gringa
	Skinshops[#Skinshops+1] = { -303.2,220.21,77.91,257.96 } -- luxor
	Skinshops[#Skinshops+1] = { 1252.95,-1720.72,56.45,65.2 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1289.66,-1762.54,54.21,22.68 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1338.0,-792.43,71.51,343.0 } -- brancos
	Skinshops[#Skinshops+1] = { 1346.33,-705.11,67.74,73.71 } -- brancos
	Skinshops[#Skinshops+1] = { 1267.24,-299.03,84.59,158.75 } -- barragem
	Skinshops[#Skinshops+1] = { 1251.62,-265.92,77.91,107.72 } -- barragem
	Skinshops[#Skinshops+1] = { 1506.8,-2368.57,78.03,274.97 } -- rosas
	Skinshops[#Skinshops+1] = { 1512.78,-2365.16,78.03,195.6 } -- rosas
	-- Skinshops[#Skinshops+1] = { 2225.07,3452.81,61.33,172.92 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2229.55,3452.95,61.33,170.08 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2226.14,3453.91,61.33,187.09 } -- cinzas
	Skinshops[#Skinshops+1] = { 103.67,1221.91,207.17,102.05 } -- SOA
	Skinshops[#Skinshops+1] = { 1306.65,-735.32,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -215.34,-1334.28,34.9,266.46 } -- bennys
	Skinshops[#Skinshops+1] = { 1048.13,888.82,220.34,48.19 } -- playboy
	Skinshops[#Skinshops+1] = { 1341.91,-790.49,71.51,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { 1336.42,-788.7,71.51,348.67 } -- brancos
	Skinshops[#Skinshops+1] = { 1308.3,-733.85,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -1550.84,-393.9,41.97,51.03 } -- 
	Skinshops[#Skinshops+1] = { -3337.8,543.54,17.44,215.44 } -- mansao 60
	Skinshops[#Skinshops+1] = { 1963.43,6415.17,61.7,311.82 } -- marrons
	Skinshops[#Skinshops+1] = { -2272.06,323.23,174.6,22.68 }
	Skinshops[#Skinshops+1] = { -1687.17,-3185.18,14.0,243.78 }
	Skinshops[#Skinshops+1] = { 1402.74,1154.66,114.33,266.46 } -- fazendinha
	Skinshops[#Skinshops+1] = { 747.78,-308.18,59.8,306.15 } -- Campinho
	Skinshops[#Skinshops+1] = { 905.89,339.35,112.29,345.83 } -- Japao
	Skinshops[#Skinshops+1] = { -1044.65,305.04,71.66,266.46 } -- Inglaterra
	Skinshops[#Skinshops+1] = { -2022.42,4435.69,53.09,345.83 } -- Banzas
	Skinshops[#Skinshops+1] = { 355.76,-2729.82,1.72,257.96 } -- Dixavas
	Skinshops[#Skinshops+1] = { -769.38,8.1,40.64,345.83 } 
	Skinshops[#Skinshops+1] = { 1471.81,6539.39,18.64,85.04 } -- pier norte
	Skinshops[#Skinshops+1] = { -602.0,-914.22,23.88,184.26 } -- Anonymous
	Skinshops[#Skinshops+1] = { -602.7,-923.49,17.59,328.82 } -- Anonymous
	Skinshops[#Skinshops+1] = { -2813.9,2266.37,24.33,354.34 } -- qg 71
	Skinshops[#Skinshops+1] = { 676.42,909.22,247.57,170.08 } -- Inglaterra
	Skinshops[#Skinshops+1] = { 5026.55,-5760.97,15.77,232.45 } -- Caribe
	Skinshops[#Skinshops+1] = { 2612.27,5333.94,47.57,59.53 } -- prf
	Skinshops[#Skinshops+1] = { 3088.32,5091.99,23.25,73.71 } -- qg_80
	Skinshops[#Skinshops+1] = { -156.96,8259.62,12.82,11.34 } -- iate
	Skinshops[#Skinshops+1] = { -1784.4,-1376.75,11.88,39.69 } -- iate
	Skinshops[#Skinshops+1] = { -1883.34,-1164.43,11.73,320.32 } -- iate
	Skinshops[#Skinshops+1] = { -2210.16,-586.48,11.73,232.45 } 
	Skinshops[#Skinshops+1] = { -1179.62,302.46,73.67,102.05 } -- qg_82
	Skinshops[#Skinshops+1] = { -1226.24,-1737.73,4.53,138.9 } -- qg_83
	Skinshops[#Skinshops+1] = { -2423.52,1790.06,185.48,39.69 } -- qg_84
	Skinshops[#Skinshops+1] = { -878.0,-1434.81,7.53,201.26 } -- qg_85
	Skinshops[#Skinshops+1] = { -539.93,5002.83,159.92,272.13 } -- qg_86
	Skinshops[#Skinshops+1] = { -2675.14,1307.61,152.0,272.13 } -- qg_87
	Skinshops[#Skinshops+1] = { -2277.87,336.33,178.57,300.48 } -- qg_88
	Skinshops[#Skinshops+1] = { 3482.3,5015.04,11.91,212.6 }
	Skinshops[#Skinshops+1] = { -4504.72,-70.94,12.81,164.41 }
	Skinshops[#Skinshops+1] = { 994.15,3403.17,61.97,280.63 } -- QG_31
	Skinshops[#Skinshops+1] = { 89.54,-1966.65,20.74,320.32 } -- QG_43
	Skinshops[#Skinshops+1] = { 2456.34,4980.02,46.83,158.75 } -- QG_64
	Skinshops[#Skinshops+1] = { -2813.7,2266.54,24.31,343.0 } -- QG_124
	Skinshops[#Skinshops+1] = { 866.7,1872.27,144.52,138.9 } -- QG_126
	Skinshops[#Skinshops+1] = { 1378.59,-2096.53,52.6,306.15 } -- QG_68
	Skinshops[#Skinshops+1] = { -669.18,6391.58,13.02,133.53 } -- QG_128
	Skinshops[#Skinshops+1] = { -2598.64,1889.43,163.75,323.7 } -- QG_129
	Skinshops[#Skinshops+1] = { 2022.46,3373.80,46.60,80.00 } -- QG_130

elseif cityName == "District99" then
		-- Skinshops[#Skinshops+1] = { -3068.65,3456.45,10.03,255.12 } -- mansao93
		-- Skinshops[#Skinshops+1] = { 1036.79,3677.97,39.06,357.17 } -- QG_404
		Skinshops[#Skinshops+1] = { 2026.40,4290.20,43.25,193.02 } -- QG_437
		Skinshops[#Skinshops+1] = { 4641.18,-4817.28,26.42,124.73 } -- QG_500
		Skinshops[#Skinshops+1] = { 380.68,2361.02,80.24,235.28 } -- mansao192
		Skinshops[#Skinshops+1] = { -1415.64,-616.65,30.72,204.1 } -- mansao207
		Skinshops[#Skinshops+1] = { -1367.94,-613.49,30.31,2.84 } -- mansao207
		Skinshops[#Skinshops+1] = { -1381.79,-591.58,30.31,136.07 } -- mansao207
		Skinshops[#Skinshops+1] = { -1383.32,-595.18,30.31,334.49 } -- mansao207
		Skinshops[#Skinshops+1] = { 368.93,2384.59,80.24,317.49 } -- mansao192
		Skinshops[#Skinshops+1] = { 368.08,2383.43,75.25,328.82 } -- mansao192
		Skinshops[#Skinshops+1] = { 359.58,2381.64,75.23,51.03 } -- mansao192
		Skinshops[#Skinshops+1] = { -2984.63,2194.69,45.09,147.41 } -- mansao191
		Skinshops[#Skinshops+1] = { -3003.58,2185.27,45.09,136.07 } -- mansao191
		Skinshops[#Skinshops+1] = { -1050.32,-2011.89,13.16,138.47 } -- mecanica
		Skinshops[#Skinshops+1] = { 1133.63,-1518.37,34.84,66.08 } -- paramedic
		-- Skinshops[#Skinshops+1] = { 1041.13,3674.80,39.05,291.97 } -- QG_171
		Skinshops[#Skinshops+1] = { -1139.66,374.11,74.93,52.99 } -- QG_355
		Skinshops[#Skinshops+1] = { -1914.03,-53.82,135.69,22.68 } -- mansao154
		Skinshops[#Skinshops+1] = { -3485.3,2799.67,22.01,357.17 } -- Mansao161
		Skinshops[#Skinshops+1] = { -3467.55,2835.87,22.01,150.24 } -- Mansao161
		Skinshops[#Skinshops+1] = { -3458.63,915.79,21.18,195.6 } -- Mansao226
		Skinshops[#Skinshops+1] = { 1036.67,3678.0,39.06,2.84 } -- Mansao227
		Skinshops[#Skinshops+1] = { 1015.72,3679.17,39.06,2.84 } -- Mansao227
		Skinshops[#Skinshops+1] = { 1015.18,3673.34,39.06,263.63 } -- Mansao227
		Skinshops[#Skinshops+1] = { 658.49,3846.51,53.31,348.67 } -- Mansao231
		Skinshops[#Skinshops+1] = { 700.41,3846.7,53.31,0.0 } -- Mansao231
		-- Skinshops[#Skinshops+1] = { -2932.41,-1800.1,13.26,238.12 } -- Mansao234
		Skinshops[#Skinshops+1] = { -3289.79,415.1,6.13,252.29 } -- Mansao235
		Skinshops[#Skinshops+1] = { -2515.96,-1803.42,19.56,39.69 } -- Mansao275
		Skinshops[#Skinshops+1] = { -2494.47,-1830.93,23.88,36.86 } -- Mansao275
		Skinshops[#Skinshops+1] = { 325.02,817.44,197.06,39.69 } -- Mansao251
		Skinshops[#Skinshops+1] = { 356.3,832.83,201.37,116.23 } -- Mansao251
		-- Skinshops[#Skinshops+1] = { -2597.16,-525.77,17.81,11.26 } -- mansao179
		-- Skinshops[#Skinshops+1] = { 359.69,2381.42,75.23,229.61 } -- QG_361
		-- Skinshops[#Skinshops+1] = { 368.06,2383.07,75.23,144.57 } -- QG_361
		-- Skinshops[#Skinshops+1] = { -2597.16,-525.77,17.81,11.26 } -- QG_348
		Skinshops[#Skinshops+1] = { -2235.48,499.10,174.40,156.49 } -- QG_337
		Skinshops[#Skinshops+1] = { -2238.06,498.90,178.23,35.39 } -- QG_337
		Skinshops[#Skinshops+1] = { -2982.14,-389.51,19.68,340.16 } -- mansao57
		Skinshops[#Skinshops+1] = { -1467.92,-45.17,58.67,133.23 } -- QG_331
		Skinshops[#Skinshops+1] = { 547.03,920.90,250.95,181.53 } -- mansao167
		Skinshops[#Skinshops+1] = { 3440.50,4940.65,39.86,216.22 } -- mansao166
		Skinshops[#Skinshops+1] = { 3423.33,4957.89,36.01,295.83 } -- mansao166
		Skinshops[#Skinshops+1] = { -554.14,1192.33,334.08,280.63 } -- AlphaA1
		Skinshops[#Skinshops+1] = { -575.98,1193.24,334.08,184.26 } -- AlphaA2
		Skinshops[#Skinshops+1] = { -604.07,1192.34,334.08,269.3 } -- AlphaA3
		Skinshops[#Skinshops+1] = { -628.87,1192.29,334.08,283.47 } -- AlphaA4
		Skinshops[#Skinshops+1] = { -543.57,1251.58,334.08,85.04 } -- AlphaB1
		Skinshops[#Skinshops+1] = { -568.49,1251.75,334.08,110.56 } -- AlphaB2
		Skinshops[#Skinshops+1] = { -593.38,1251.64,334.08,102.05 } -- AlphaB3
		Skinshops[#Skinshops+1] = { -618.02,1251.67,334.08,87.88 } -- AlphaB4
		Skinshops[#Skinshops+1] = { -1017.01,1134.35,225.37,82.21 } -- Alpha3B1
		Skinshops[#Skinshops+1] = { -1024.91,1094.09,225.37,82.21 } -- Alpha3B2
		Skinshops[#Skinshops+1] = { -1032.56,1053.6,225.37,79.38 } -- Alpha3B3
		Skinshops[#Skinshops+1] = { -973.09,1019.16,225.37,82.21 } -- Alpha3B4
		Skinshops[#Skinshops+1] = { -965.32,1059.39,225.37,87.88 } -- Alpha3B5
		Skinshops[#Skinshops+1] = { -957.27,1099.48,225.37,68.04 } -- Alpha3B6
		-- Skinshops[#Skinshops+1] = { 1200.65,613.52,98.17,62.37 } -- Mansao223
		-- Skinshops[#Skinshops+1] = { 1184.72,596.84,98.13,240.95 } -- Mansao223
		-- Skinshops[#Skinshops+1] = { -2252.95,-664.07,14.52,223.94 } -- Mansao224
		-- Skinshops[#Skinshops+1] = { -2261.74,-664.29,14.52,130.4 } -- Mansao224
		-- Skinshops[#Skinshops+1] = { -2262.64,-665.3,19.51,133.23 } -- Mansao224
		-- Skinshops[#Skinshops+1] = { -2272.78,-637.26,19.51,229.61 } -- Mansao224
		-- Skinshops[#Skinshops+1] = { -2270.7,-640.49,19.51,51.03 } -- Mansao224
		Skinshops[#Skinshops+1] = { -2349.97,3266.35,32.81,154.02 }
		Skinshops[#Skinshops+1] = { 129.47,-99.07,49.58,207.22 } -- Nightclub
		-- Skinshops[#Skinshops+1] = { -1514.82,-1468.04,6.39,206.93 } -- Atlantis
		Skinshops[#Skinshops+1] = { -1695.24,-1130.01,14.0,147.41 }
		Skinshops[#Skinshops+1] = { -1699.29,-1126.98,14.0,226.78 }
		Skinshops[#Skinshops+1] = { -1695.16,-1123.33,14.0,235.28 }
		Skinshops[#Skinshops+1] = { -1690.89,-1135.97,14.0,320.32 }
		Skinshops[#Skinshops+1] = { -1691.3,-1127.11,14.0,255.12 }
		Skinshops[#Skinshops+1] = { -304.41,6274.05,34.79,119.06 } -- mansao128
		Skinshops[#Skinshops+1] = { -1136.33,-2076.44,21.28,223.94 } -- mecanica
		Skinshops[#Skinshops+1] = { -417.98,4372.91,61.35,184.26 } -- mansao94
		Skinshops[#Skinshops+1] = { -2675.31,1307.53,152.01,277.90 } -- mansao119
		Skinshops[#Skinshops+1] = { 127.86,-1298.24,21.11,127.56 } -- Mansao116
		-- Skinshops[#Skinshops+1] = { 791.97,5736.84,702.57,76.54 } -- mansao90
		Skinshops[#Skinshops+1] = { 2023.49,-1600.29,258.50,347.38 } -- mansao101
		-- Skinshops[#Skinshops+1] = { 3496.16,-3283.35,10.62,25.52 } -- mansao103
		Skinshops[#Skinshops+1] = { 840.40,-124.81,79.77,60.72 } -- mansao105
		Skinshops[#Skinshops+1] = { -3803.98,287.45,158.80,171.05 } -- mansao108
		Skinshops[#Skinshops+1] = { -3529.43,4608.58,10.05,291.43 } -- mansao114
		Skinshops[#Skinshops+1] = { 93.40,6517.33,31.26,305.00 } -- QG_131
		Skinshops[#Skinshops+1] = { -1729.43,374.72,89.72,230.96 } -- QG_154
		Skinshops[#Skinshops+1] = { -2086.45,-303.38,13.24,167.25 } -- QG_156
		Skinshops[#Skinshops+1] = { -523.98,514.28,108.08,315.38 } -- QG_158
		-- Skinshops[#Skinshops+1] = { 1185.11,873.56,144.00,161.87 } -- QG_159 / Mansao53
		-- Skinshops[#Skinshops+1] = { -1368.02,-613.34,30.32,34.56 } -- QG_148
		Skinshops[#Skinshops+1] = { 958.86,-966.6,42.95,348.67 } -- mecanica
		Skinshops[#Skinshops+1] = { -632.41,-134.04,43.22,93.55 } -- Bombeiros
		Skinshops[#Skinshops+1] = { 1150.65,-1583.05,35.28,138.9 } -- hp
		Skinshops[#Skinshops+1] = { 458.14,-999.19,30.68,331.66 } -- Militar
		Skinshops[#Skinshops+1] = { -437.84,6012.35,36.99,357.17 } -- civil
		Skinshops[#Skinshops+1] = { -780.21,-1211.9,10.38,141.74 } -- Tatica
		Skinshops[#Skinshops+1] = { -1887.58,3026.39,32.96,328.82 } -- Exercito
		Skinshops[#Skinshops+1] = { 1075.28,3273.75,41.11,198.43 } -- umbrella
		Skinshops[#Skinshops+1] = { 875.42,1860.9,142.5,226.78 } -- Metgala
		Skinshops[#Skinshops+1] = { -2197.05,-275.16,35.79,257.96 } -- Gang4
		Skinshops[#Skinshops+1] = { -458.91,-1264.9,25.48,51.03 } -- Afetados
		Skinshops[#Skinshops+1] = { 413.04,6468.02,29.82,274.97 } -- Pinkmans
		Skinshops[#Skinshops+1] = { 1513.4,1356.95,108.29,286.3 } -- Gang9
		Skinshops[#Skinshops+1] = { 957.6,-2390.99,22.33,175.75 } -- China
		Skinshops[#Skinshops+1] = { 3047.53,-4136.9,9.86,351.5 }
		-- Skinshops[#Skinshops+1] = { 1030.2,-2550.23,32.28,85.04 } -- Vermelhos
		Skinshops[#Skinshops+1] = { 1797.05,441.96,172.34,59.53 } -- Azul
		Skinshops[#Skinshops+1] = { 2133.61,-15.7,227.22,45.36 } -- Rosa
		Skinshops[#Skinshops+1] = { 2742.43,2716.88,55.84,48.19 } -- Sindicato
		-- Skinshops[#Skinshops+1] = { -139.96,-1609.06,35.03,68.04 } -- Groove
		-- Skinshops[#Skinshops+1] = { 2115.64,3886.09,33.23,215.44 } -- Roxos
		Skinshops[#Skinshops+1] = { 514.2,370.01,151.73,104.89 } -- Roxos
		Skinshops[#Skinshops+1] = { 358.11,-2033.39,22.39,48.19 } -- Vagos
		Skinshops[#Skinshops+1] = { 117.31,-1962.14,21.33,201.26 } -- Ballas
		Skinshops[#Skinshops+1] = { 755.82,-203.84,70.63,289.14 } -- QG_34
		Skinshops[#Skinshops+1] = { 755.7,-203.72,70.63,280.63 } -- QG_113
		Skinshops[#Skinshops+1] = { 1221.1,-1858.54,45.71,289.14 } -- QG_116
		Skinshops[#Skinshops+1] = { 1330.04,-707.86,67.28,116.23 } -- QG_117
		Skinshops[#Skinshops+1] = { -2189.20,4283.77,49.18,196.14 } -- QG_144
		-- Skinshops[#Skinshops+1] = {  103.51,3613.09,40.49,175.75 } -- Laranja
		Skinshops[#Skinshops+1] = { 291.24,216.89,78.82,277.8 } -- Bahamas
		Skinshops[#Skinshops+1] = { 945.01,47.64,80.29,53.86 } -- Bellagio
		Skinshops[#Skinshops+1] = { -1540.36,321.5,87.25,73.71 } -- Lavajato
		Skinshops[#Skinshops+1] = { 102.53,-1311.89,21.13,31.19 } -- Putaria
		Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
		Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
		Skinshops[#Skinshops+1] = { -3320.91,548.73,13.77,303.31 } -- Arcade
		Skinshops[#Skinshops+1] = { 414.94,-23.43,91.93,56.7 } -- Callisto
		Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
		Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
		Skinshops[#Skinshops+1] = { -203.27,-1330.04,34.9,127.56 } -- Undergrounds
		Skinshops[#Skinshops+1] = { 1382.88,-2093.85,47.21,31.19 } -- fazer
		Skinshops[#Skinshops+1] = { 2361.62,5647.1,92.71,141.74 } -- Topgear
		Skinshops[#Skinshops+1] = { 1378.51,-2096.32,52.6,39.69  } -- FerroVelho
		Skinshops[#Skinshops+1] = { 2643.51,3636.15,106.73,39.69 } -- Morro-do-Sacola
		Skinshops[#Skinshops+1] = { 883.73,-2100.55,30.46,175.75 } -- CarClube
		Skinshops[#Skinshops+1] = { -337.81,-166.57,44.58,272.13 } -- Virtude
		Skinshops[#Skinshops+1] = { 134.68,-369.75,50.33,17.01 } -- Big
		Skinshops[#Skinshops+1] = { 2742.47,3500.22,61.3,357.17} -- Kraken
		Skinshops[#Skinshops+1] = { -1149.56,-1554.59,7.63,153.08 } -- bandoleros
		Skinshops[#Skinshops+1] = { 556.33,-2773.46,6.08,59.53 } -- Gang5
		Skinshops[#Skinshops+1] = { 99.06,1229.61,207.17,345.83 } -- Mayans
		Skinshops[#Skinshops+1] = { 1028.6,-2550.72,32.28,351.5 } -- soa
		Skinshops[#Skinshops+1] = { 1026.51,-2542.27,28.29,170.08 } -- hellsangels
		Skinshops[#Skinshops+1] = { 3234.18,5120.17,20.15,116.23 }
		Skinshops[#Skinshops+1] = { 2312.64,5568.36,51.91,343.0 } -- sinaloa
		Skinshops[#Skinshops+1] = { -60.09,994.66,239.52,328.82 } -- gringa
		Skinshops[#Skinshops+1] = { -1539.52,141.51,55.65,51.03 } -- bloods
		-- Skinshops[#Skinshops+1] = { -2804.84,2261.69,24.11,320.32 } -- bloods secundario
		Skinshops[#Skinshops+1] = { -3025.46,59.49,11.95,331.66 } -- crips
		Skinshops[#Skinshops+1] = { -339.2,-1523.7,29.34,22.68 } -- warlocks
		Skinshops[#Skinshops+1] = { -1814.54,447.96,127.91,351.5 } -- mexicana
		Skinshops[#Skinshops+1] = { -1887.16,2070.1,145.57,334.49 } -- russa
		Skinshops[#Skinshops+1] = { -1491.07,845.77,181.59,87.88 } -- irlandesa
		Skinshops[#Skinshops+1] = { 173.45,668.33,207.66,104.89 } -- triade
		Skinshops[#Skinshops+1] = { 420.53,-1483.85,33.8,116.23 } -- italiana
		Skinshops[#Skinshops+1] = { 2332.3,5524.54,51.68,249.45 } -- overdrive
		Skinshops[#Skinshops+1] = { -776.37,-2593.33,17.66,238.12 } -- Outlaws 
		Skinshops[#Skinshops+1] = { -617.15,-1617.33,33.01,172.92 } -- Topgear 
		Skinshops[#Skinshops+1] = { -290.78,1986.24,166.14,334.49 } -- israel
		-- Skinshops[#Skinshops+1] = { 1078.37,-1973.3,31.48,235.28 } -- gringa
		Skinshops[#Skinshops+1] = { -303.2,220.21,77.91,257.96 } -- luxor
		Skinshops[#Skinshops+1] = { 1252.95,-1720.72,56.45,65.2 } -- LosAztecas
		Skinshops[#Skinshops+1] = { 1289.66,-1762.54,54.21,22.68 } -- LosAztecas
		Skinshops[#Skinshops+1] = { 1338.0,-792.43,71.51,343.0 } -- brancos
		Skinshops[#Skinshops+1] = { 1346.33,-705.11,67.74,73.71 } -- brancos
		Skinshops[#Skinshops+1] = { 1267.24,-299.03,84.59,158.75 } -- barragem
		Skinshops[#Skinshops+1] = { 1251.62,-265.92,77.91,107.72 } -- barragem
		Skinshops[#Skinshops+1] = { 1506.8,-2368.57,78.03,274.97 } -- rosas
		Skinshops[#Skinshops+1] = { 1512.78,-2365.16,78.03,195.6 } -- rosas
		-- Skinshops[#Skinshops+1] = { 2225.07,3452.81,61.33,172.92 } -- cinzas
		-- Skinshops[#Skinshops+1] = { 2229.55,3452.95,61.33,170.08 } -- cinzas
		-- Skinshops[#Skinshops+1] = { 2226.14,3453.91,61.33,187.09 } -- cinzas
		Skinshops[#Skinshops+1] = { 103.67,1221.91,207.17,102.05 } -- SOA
		Skinshops[#Skinshops+1] = { 1306.65,-735.32,65.09,340.16 } -- brancos
		Skinshops[#Skinshops+1] = { -215.34,-1334.28,34.9,266.46 } -- bennys
		Skinshops[#Skinshops+1] = { 1048.13,888.82,220.34,48.19 } -- playboy
		Skinshops[#Skinshops+1] = { 1341.91,-790.49,71.51,340.16 } -- brancos
		Skinshops[#Skinshops+1] = { 1336.42,-788.7,71.51,348.67 } -- brancos
		Skinshops[#Skinshops+1] = { 1308.3,-733.85,65.09,340.16 } -- brancos
		Skinshops[#Skinshops+1] = { 1963.43,6415.17,61.7,311.82 } -- marrons
		Skinshops[#Skinshops+1] = { -2272.06,323.23,174.6,22.68 }
		Skinshops[#Skinshops+1] = { -1687.17,-3185.18,14.0,243.78 }
		Skinshops[#Skinshops+1] = { 1402.74,1154.66,114.33,266.46 } -- fazendinha
		Skinshops[#Skinshops+1] = { 747.78,-308.18,59.8,306.15 } -- Campinho
		Skinshops[#Skinshops+1] = { 905.89,339.35,112.29,345.83 } -- Japao
		Skinshops[#Skinshops+1] = { -1044.65,305.04,71.66,266.46 } -- Inglaterra
		Skinshops[#Skinshops+1] = { -2022.42,4435.69,53.09,345.83 } -- Banzas
		Skinshops[#Skinshops+1] = { 355.76,-2729.82,1.72,257.96 } -- Dixavas
		Skinshops[#Skinshops+1] = { -769.38,8.1,40.64,345.83 } 
		Skinshops[#Skinshops+1] = { 1471.81,6539.39,18.64,85.04 } -- pier norte
		Skinshops[#Skinshops+1] = { -602.0,-914.22,23.88,184.26 } -- Anonymous
		Skinshops[#Skinshops+1] = { -602.7,-923.49,17.59,328.82 } -- Anonymous
		Skinshops[#Skinshops+1] = { -2813.9,2266.37,24.33,354.34 } -- qg 71
		Skinshops[#Skinshops+1] = { 676.42,909.22,247.57,170.08 } -- Inglaterra
		Skinshops[#Skinshops+1] = { 5026.55,-5760.97,15.77,232.45 } -- Caribe
		Skinshops[#Skinshops+1] = { 2612.27,5333.94,47.57,59.53 } -- prf
		Skinshops[#Skinshops+1] = { 3088.32,5091.99,23.25,73.71 } -- qg_80
		Skinshops[#Skinshops+1] = { -156.96,8259.62,12.82,11.34 } -- iate
		Skinshops[#Skinshops+1] = { -1784.4,-1376.75,11.88,39.69 } -- iate
		Skinshops[#Skinshops+1] = { -1883.34,-1164.43,11.73,320.32 } -- iate
		Skinshops[#Skinshops+1] = { -2210.16,-586.48,11.73,232.45 } 
		Skinshops[#Skinshops+1] = { -1179.62,302.46,73.67,102.05 } -- qg_82
		Skinshops[#Skinshops+1] = { -1226.24,-1737.73,4.53,138.9 } -- qg_83
		Skinshops[#Skinshops+1] = { -2423.52,1790.06,185.48,39.69 } -- qg_84
		Skinshops[#Skinshops+1] = { -878.0,-1434.81,7.53,201.26 } -- qg_85
		-- Skinshops[#Skinshops+1] = { -539.93,5002.83,159.92,272.13 } -- qg_86
		Skinshops[#Skinshops+1] = { -2675.14,1307.61,152.0,272.13 } -- qg_87
		Skinshops[#Skinshops+1] = { -2277.87,336.33,178.57,300.48 } -- qg_88
		Skinshops[#Skinshops+1] = { 3482.3,5015.04,11.91,212.6 }
		Skinshops[#Skinshops+1] = { -4504.72,-70.94,12.81,164.41 }
		Skinshops[#Skinshops+1] = { 994.15,3403.17,61.97,280.63 } -- QG_31
		Skinshops[#Skinshops+1] = { 2456.34,4980.02,46.83,158.75 } -- QG_64
		Skinshops[#Skinshops+1] = { -2813.7,2266.54,24.31,343.0 } -- QG_124
		Skinshops[#Skinshops+1] = { 866.7,1872.27,144.52,138.9 } -- QG_126
		-- Skinshops[#Skinshops+1] = { 1378.59,-2096.53,52.6,306.15 } -- QG_68
		-- Skinshops[#Skinshops+1] = { -669.18,6391.58,13.02,133.53 } -- QG_389
		-- Skinshops[#Skinshops+1] = { -2598.64,1889.43,163.75,323.7 } -- QG_129
		Skinshops[#Skinshops+1] = { 2022.46,3373.80,46.60,80.00 } -- QG_130
		Skinshops[#Skinshops+1] = { -754.83,820.86,216.99,209.77 } -- Mansao210
		-- Skinshops[#Skinshops+1] = { -520.32,499.82,112.44,311.82 } -- Mansao211
		-- Skinshops[#Skinshops+1] = { -522.89,514.71,108.07,39.69 } -- Mansao211
		Skinshops[#Skinshops+1] = { 102.36,-1311.65,21.13,34.02 } -- Mansao216
		Skinshops[#Skinshops+1] = { 128.01,-1298.1,21.11,39.69 } -- Mansao216
		Skinshops[#Skinshops+1] = { -2306.09,4328.43,37.07,323.15 } -- Mansao219
		Skinshops[#Skinshops+1] = { -2311.76,4333.15,37.07,320.32 } -- Mansao219
		Skinshops[#Skinshops+1] = { -2290.54,4348.44,37.1,138.9 } -- Mansao219
		Skinshops[#Skinshops+1] = { -2306.29,4328.59,37.07,317.49 } -- Mansao219
		-- Skinshops[#Skinshops+1] = { -404.0,-196.65,37.91,28.35 } -- Mansao220
		-- Skinshops[#Skinshops+1] = { -394.37,-191.9,37.91,31.19 } -- Mansao220
		Skinshops[#Skinshops+1] = { 1208.58,596.18,107.1,130.4 } -- QG_445
		Skinshops[#Skinshops+1] = { 1184.51,599.1,102.62,56.7 } -- QG_445
		Skinshops[#Skinshops+1] = { 846.85,1424.23,345.79,172.92 } -- Alpha4B1
		Skinshops[#Skinshops+1] = { 847.76,1427.29,345.79,90.71 } -- Alpha4B1
		Skinshops[#Skinshops+1] = { 837.57,1416.94,354.05,2.84 } -- Alpha4B1
		Skinshops[#Skinshops+1] = { 846.98,1478.22,345.79,189.93 } -- Alpha4B2
		Skinshops[#Skinshops+1] = { 847.72,1481.46,345.79,104.89 } -- Alpha4B2
		Skinshops[#Skinshops+1] = { 837.42,1471.23,354.05,354.34 } -- Alpha4B2
		Skinshops[#Skinshops+1] = { 846.85,1532.34,345.79,175.75 } -- Alpha4B3
		Skinshops[#Skinshops+1] = { 847.71,1535.31,345.79,93.55 } -- Alpha4B3
		Skinshops[#Skinshops+1] = { 837.62,1525.15,354.05,0.0 } -- Alpha4B3
		Skinshops[#Skinshops+1] = { 758.11,1564.98,345.79,354.34 } -- Alpha4B4
		Skinshops[#Skinshops+1] = { 757.01,1561.61,345.79,274.97 } -- Alpha4B4
		Skinshops[#Skinshops+1] = { 754.28,1558.57,345.79,0.0 } -- Alpha4B4
		Skinshops[#Skinshops+1] = { 757.86,1510.63,345.79,0.0 } -- Alpha4B5
		Skinshops[#Skinshops+1] = { 757.05,1507.71,345.79,266.46 } -- Alpha4B5
		Skinshops[#Skinshops+1] = { 767.24,1517.82,354.05,187.09 } -- Alpha4B5
		Skinshops[#Skinshops+1] = { 757.63,1456.67,345.79,5.67 } -- Alpha4B6
		Skinshops[#Skinshops+1] = { 757.02,1453.56,345.79,266.46 } -- Alpha4B6
		Skinshops[#Skinshops+1] = { 766.82,1464.02,354.05,184.26 } -- Alpha4B6
		Skinshops[#Skinshops+1] = { -3054.67,3452.54,10.03,79.38 } -- Mansao252
		Skinshops[#Skinshops+1] = { -3070.77,3458.21,10.03,170.08 } -- Mansao252
		Skinshops[#Skinshops+1] = { -1705.6,-483.66,42.76,138.9 } -- Mansao256
		Skinshops[#Skinshops+1] = { 540.48,450.53,188.99,141.74 } -- QG_473
		Skinshops[#Skinshops+1] = { 170.39,628.42,216.84,184.26 } -- Mansao280
		Skinshops[#Skinshops+1] = { 177.1,619.94,212.11,90.71 } -- Mansao280
		Skinshops[#Skinshops+1] = { 676.73,909.14,247.57,164.41 } -- QG_494
		Skinshops[#Skinshops+1] = { 688.13,914.25,247.57,107.72 } -- QG_494
		Skinshops[#Skinshops+1] = { 694.59,1251.54,361.04,348.67 } -- Mansao285
		Skinshops[#Skinshops+1] = { 692.27,1245.24,361.01,82.21 } -- Mansao285
		Skinshops[#Skinshops+1] = { 691.85,1247.06,367.92,249.45 } -- Mansao285

elseif cityName == "Krown" then
	Skinshops[#Skinshops+1] = { -2566.45,-2204.01,5.05,161.58 } -- Resort
		-- Skinshops[#Skinshops+1] = { -3068.65,3456.45,10.03,255.12 } -- mansao93
		Skinshops[#Skinshops+1] = { -1720.29,-91.35,93.63,320.32 } -- mansao199
		-- Skinshops[#Skinshops+1] = { -753.42,941.17,241.91,291.97 } -- mansao200
		Skinshops[#Skinshops+1] = { -182.59,1240.25,311.45,56.7 } -- mansao201
		Skinshops[#Skinshops+1] = { -1539.61,803.97,188.62,294.81 } -- mansao202
		Skinshops[#Skinshops+1] = { 787.73,3416.62,62.68,266.46 } -- mansao203
		Skinshops[#Skinshops+1] = { 738.73,3415.85,62.68,291.97 } -- mansao203
		Skinshops[#Skinshops+1] = { 758.84,3423.9,67.45,93.55 } -- mansao203
		Skinshops[#Skinshops+1] = { 582.99,745.1,206.17,56.7 } -- mansao204
		Skinshops[#Skinshops+1] = { 2817.0,-692.01,12.22,187.09 } -- mansao205
		Skinshops[#Skinshops+1] = { 2839.15,-698.37,12.22,93.55 } -- mansao205
		-- Skinshops[#Skinshops+1] = { -1233.36,788.63,197.19,274.97 } -- mansao206
		Skinshops[#Skinshops+1] = { -1017.01,1134.35,225.37,82.21 } -- Alpha3B1
		Skinshops[#Skinshops+1] = { -1024.91,1094.09,225.37,82.21 } -- Alpha3B2
		Skinshops[#Skinshops+1] = { -1032.56,1053.6,225.37,79.38 } -- Alpha3B3
		Skinshops[#Skinshops+1] = { -973.09,1019.16,225.37,82.21 } -- Alpha3B4
		Skinshops[#Skinshops+1] = { -965.32,1059.39,225.37,87.88 } -- Alpha3B5
		Skinshops[#Skinshops+1] = { -957.27,1099.48,225.37,68.04 } -- Alpha3B6
		Skinshops[#Skinshops+1] = { 5026.7,-5761.37,15.77,255.12 } -- Mansao253
		Skinshops[#Skinshops+1] = { 5005.24,-5754.83,28.85,320.32 } -- Mansao253
		Skinshops[#Skinshops+1] = { -82.68,831.54,235.72,290.06 } -- QG_392
		Skinshops[#Skinshops+1] = { 557.16,-192.72,54.53,357.17 } -- mecanica
		Skinshops[#Skinshops+1] = { -307.7,-590.09,32.77,104.89 } -- paramedic
		Skinshops[#Skinshops+1] = { -303.87,6274.04,34.79,45.36 } -- Mansao188
		-- Skinshops[#Skinshops+1] = { -3067.05,1915.53,33.95,155.91 } -- Mansao187
		-- Skinshops[#Skinshops+1] = { -3092.03,1884.82,33.95,164.41 } -- Mansao187
		Skinshops[#Skinshops+1] = { -2779.46,-488.03,6.62,320.94 } -- Iate03
		Skinshops[#Skinshops+1] = { -2794.15,-204.13,23.62,21.27 } -- Mansao186
		Skinshops[#Skinshops+1] = { -3333.67,575.02,14.41,303.31 } -- QG_76
		Skinshops[#Skinshops+1] = { 676.73,909.14,247.57,164.41 } -- QG_302
		Skinshops[#Skinshops+1] = { 688.13,914.25,247.57,107.72 } -- QG_302
		Skinshops[#Skinshops+1] = { -1379.81,-636.05,30.31,212.6 } -- Bahamas
		Skinshops[#Skinshops+1] = { 1834.41,2571.42,46.01,336.15 } -- PoliciaPrisional
		Skinshops[#Skinshops+1] = { -162.92,1245.87,311.45,51.03 } -- QG_328
		-- Skinshops[#Skinshops+1] = { -3077.26,1881.28,33.95,79.38 } -- mansao55
		-- Skinshops[#Skinshops+1] = { -1707.12,-91.01,89.83,45.36 } -- mansao139
		-- Skinshops[#Skinshops+1] = { 653.44,921.91,252.6,170.08 } -- mansao61
		-- Skinshops[#Skinshops+1] = { -2987.77,2185.47,45.09,127.56 } -- mansao62
		-- Skinshops[#Skinshops+1] = { 757.92,3423.04,62.68,76.54 } -- mansao48
		Skinshops[#Skinshops+1] = { -1048.78,2790.62,27.20,105.51 } -- mansao158
		-- Skinshops[#Skinshops+1] = { -1238.71,795.43,197.19,96.38 } -- mansao44
		Skinshops[#Skinshops+1] = { -1530.12,821.28,184.92,8.69 } -- QG_269
		Skinshops[#Skinshops+1] = { -554.14,1192.33,334.08,280.63 } -- AlphaA1
		Skinshops[#Skinshops+1] = { -575.98,1193.24,334.08,184.26 } -- AlphaA2
		Skinshops[#Skinshops+1] = { -604.07,1192.34,334.08,269.3 } -- AlphaA3
		Skinshops[#Skinshops+1] = { -628.87,1192.29,334.08,283.47 } -- AlphaA4
		Skinshops[#Skinshops+1] = { -543.57,1251.58,334.08,85.04 } -- AlphaB1
		Skinshops[#Skinshops+1] = { -568.49,1251.75,334.08,110.56 } -- AlphaB2
		Skinshops[#Skinshops+1] = { -593.38,1251.64,334.08,102.05 } -- AlphaB3
		Skinshops[#Skinshops+1] = { -618.02,1251.67,334.08,87.88 } -- AlphaB4
		Skinshops[#Skinshops+1] = { -2349.97,3266.35,32.81,154.02 }
		-- Skinshops[#Skinshops+1] = { -1914.03,-53.82,135.69,22.68 } -- mansao154
		Skinshops[#Skinshops+1] = { -3164.47,2336.05,14.2,8.51 } -- QG_264
		-- Skinshops[#Skinshops+1] = { -1514.82,-1468.04,6.39,206.93 } -- Atlantis
		Skinshops[#Skinshops+1] = { -1695.24,-1130.01,14.0,147.41 }
		Skinshops[#Skinshops+1] = { -1699.29,-1126.98,14.0,226.78 }
		Skinshops[#Skinshops+1] = { -3803.9,288.08,158.81,175.75 } -- QG_173
		Skinshops[#Skinshops+1] = { 1678.57,7055.46,11.77,141.25 }
		Skinshops[#Skinshops+1] = { 136.79,-346.87,50.33,158.75 } -- QG_168
		-- Skinshops[#Skinshops+1] = { -404.72,4373.04,62.82,354.34 } -- mansao94
		Skinshops[#Skinshops+1] = { -142.82,6494.48,38.84,39.69 } -- mansao102
		-- Skinshops[#Skinshops+1] = { 2023.49,-1600.29,258.50,347.38 } -- mansao101
		Skinshops[#Skinshops+1] = { 368.92,2384.33,80.24,137.06 } -- mansao49
		Skinshops[#Skinshops+1] = { -126.17,6619.03,33.85,311.82 } -- mansao51
		-- Skinshops[#Skinshops+1] = { -1474.76,-1759.03,14.35,3.21 } -- mansao70
		Skinshops[#Skinshops+1] = { -2766.96,-941.86,16.05,64.63 } -- mansao71
		Skinshops[#Skinshops+1] = { -1141.65,374.78,74.97,226.04 } -- QG_155
		Skinshops[#Skinshops+1] = { -1417.25,-617.80,30.72,36.73 } -- MajorBahamas
		-- Skinshops[#Skinshops+1] = { -3090.98,3367.52,17.32,180.20 } -- mansao66
		Skinshops[#Skinshops+1] = { -3536.63,4623.20,6.72,287.43 } -- mansao96
		-- Skinshops[#Skinshops+1] = { 1036.84,3678.09,39.05,179.56 } -- mansao16
		Skinshops[#Skinshops+1] = { 2006.75,3354.94,51.60,83.44 } -- QG_150
		Skinshops[#Skinshops+1] = { 102.37,-1311.13,21.13,48.19 } -- QG_143
		Skinshops[#Skinshops+1] = { -2189.20,4283.77,49.18,196.14 } -- QG_132
		Skinshops[#Skinshops+1] = { 958.7,-966.6,42.95,263.63 } -- mecanica
		Skinshops[#Skinshops+1] = { -632.41,-134.04,43.22,93.55 } -- Bombeiros
		Skinshops[#Skinshops+1] = { 1087.36,-922.42,51.27,175.24 } -- Bombeiros
		Skinshops[#Skinshops+1] = { 1150.65,-1583.05,35.28,138.9 } -- hp
		Skinshops[#Skinshops+1] = { 457.64,-990.77,30.68,11.34 } -- dp praça
		Skinshops[#Skinshops+1] = { 2516.96,-345.11,101.89,42.52 } -- Militar
		Skinshops[#Skinshops+1] = { -437.84,6012.35,36.99,357.17 } -- civil
		Skinshops[#Skinshops+1] = { -780.21,-1211.9,10.38,141.74 } -- Tatica
		Skinshops[#Skinshops+1] = { -1887.58,3026.39,32.96,328.82 } -- Exercito
		Skinshops[#Skinshops+1] = { 1075.28,3273.75,41.11,198.43 } -- umbrella
		Skinshops[#Skinshops+1] = { 875.42,1860.9,142.5,226.78 } -- Metgala
		Skinshops[#Skinshops+1] = { -2197.05,-275.16,35.79,257.96 } -- Gang4
		Skinshops[#Skinshops+1] = { -458.91,-1264.9,25.48,51.03 } -- Afetados
		Skinshops[#Skinshops+1] = { 413.04,6468.02,29.82,274.97 } -- Pinkmans
		Skinshops[#Skinshops+1] = { 1513.4,1356.95,108.29,286.3 } -- Gang9
		Skinshops[#Skinshops+1] = { 957.6,-2390.99,22.33,175.75 } -- China
		Skinshops[#Skinshops+1] = { 790.13,5752.55,702.57,249.45 } -- Mansao95
		Skinshops[#Skinshops+1] = { -763.42,29.24,40.64,161.58 } -- Igreja
		Skinshops[#Skinshops+1] = { 3047.53,-4136.9,9.86,351.5 }
		Skinshops[#Skinshops+1] = { -2003.59,4494.14,57.29,320.32 }
		Skinshops[#Skinshops+1] = { -1628.7,-1100.71,13.09,229.61 }
		-- Skinshops[#Skinshops+1] = { 2029.85,4299.39,38.25,99.22 } -- QG_110
		-- Skinshops[#Skinshops+1] = { 1030.2,-2550.23,32.28,85.04 } -- Vermelhos
		Skinshops[#Skinshops+1] = { 1797.05,441.96,172.34,59.53 } -- Azul
		Skinshops[#Skinshops+1] = { 2133.61,-15.7,227.22,45.36 } -- Rosa
		Skinshops[#Skinshops+1] = { 2742.43,2716.88,55.84,48.19 } -- Sindicato
		-- Skinshops[#Skinshops+1] = { -139.96,-1609.06,35.03,68.04 } -- Groove
		Skinshops[#Skinshops+1] = { 2115.64,3886.09,33.23,215.44 } -- Roxos
		Skinshops[#Skinshops+1] = { 514.2,370.01,151.73,104.89 } -- Roxos
		Skinshops[#Skinshops+1] = { 358.11,-2033.39,22.39,48.19 } -- Vagos
		Skinshops[#Skinshops+1] = { 117.31,-1962.14,21.33,201.26 } -- Ballas
		-- Skinshops[#Skinshops+1] = {  103.51,3613.09,40.49,175.75 } -- Laranja
		Skinshops[#Skinshops+1] = { 291.24,216.89,78.82,277.8 } -- Bahamas
		Skinshops[#Skinshops+1] = { 945.01,47.64,80.29,53.86 } -- Bellagio
		Skinshops[#Skinshops+1] = { -1540.36,321.5,87.25,73.71 } -- Lavajato
		Skinshops[#Skinshops+1] = { 102.53,-1311.89,21.13,31.19 } -- Putaria
		Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
		Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
		Skinshops[#Skinshops+1] = { 414.94,-23.43,91.93,56.7 } -- Callisto
		Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
		Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
		Skinshops[#Skinshops+1] = { -203.27,-1330.04,34.9,127.56 } -- Undergrounds
		Skinshops[#Skinshops+1] = { 1382.88,-2093.85,47.21,31.19 } -- fazer
		Skinshops[#Skinshops+1] = { 2361.62,5647.1,92.71,141.74 } -- Topgear
		Skinshops[#Skinshops+1] = { 1378.51,-2096.32,52.6,39.69  } -- FerroVelho
		Skinshops[#Skinshops+1] = { 2643.51,3636.15,106.73,39.69 } -- Morro-do-Sacola
		Skinshops[#Skinshops+1] = { 883.73,-2100.55,30.46,175.75 } -- CarClube
		Skinshops[#Skinshops+1] = { -337.81,-166.57,44.58,272.13 } -- Virtude
		Skinshops[#Skinshops+1] = { 134.68,-369.75,50.33,17.01 } -- Big
		Skinshops[#Skinshops+1] = { 2742.47,3500.22,61.3,357.17} -- Kraken
		Skinshops[#Skinshops+1] = { -1149.56,-1554.59,7.63,153.08 } -- bandoleros
		Skinshops[#Skinshops+1] = { 556.33,-2773.46,6.08,59.53 } -- Gang5
		Skinshops[#Skinshops+1] = { 99.06,1229.61,207.17,345.83 } -- Mayans
		Skinshops[#Skinshops+1] = { 1028.6,-2550.72,32.28,351.5 } -- soa
		Skinshops[#Skinshops+1] = { 1026.51,-2542.27,28.29,170.08 } -- hellsangels
		Skinshops[#Skinshops+1] = { 3234.18,5120.17,20.15,116.23 }
		Skinshops[#Skinshops+1] = { 2312.64,5568.36,51.91,343.0 } -- sinaloa
		Skinshops[#Skinshops+1] = { -60.09,994.66,239.52,328.82 } -- gringa
		Skinshops[#Skinshops+1] = { -1539.52,141.51,55.65,51.03 } -- bloods
		-- Skinshops[#Skinshops+1] = { -2804.84,2261.69,24.11,320.32 } -- bloods secundario
		Skinshops[#Skinshops+1] = { -3025.46,59.49,11.95,331.66 } -- crips
		Skinshops[#Skinshops+1] = { -1814.54,447.96,127.91,351.5 } -- mexicana
		Skinshops[#Skinshops+1] = { -1887.16,2070.1,145.57,334.49 } -- russa
		Skinshops[#Skinshops+1] = { -1491.07,845.77,181.59,87.88 } -- irlandesa
		Skinshops[#Skinshops+1] = { 173.45,668.33,207.66,104.89 } -- triade
		Skinshops[#Skinshops+1] = { 420.53,-1483.85,33.8,116.23 } -- italiana
		Skinshops[#Skinshops+1] = { 2332.3,5524.54,51.68,249.45 } -- overdrive
		Skinshops[#Skinshops+1] = { -776.37,-2593.33,17.66,238.12 } -- Outlaws 
		Skinshops[#Skinshops+1] = { -617.15,-1617.33,33.01,172.92 } -- Topgear 
		Skinshops[#Skinshops+1] = { -290.78,1986.24,166.14,334.49 } -- israel
		-- Skinshops[#Skinshops+1] = { 1078.37,-1973.3,31.48,235.28 } -- gringa
		Skinshops[#Skinshops+1] = { -303.2,220.21,77.91,257.96 } -- luxor
		Skinshops[#Skinshops+1] = { 1252.95,-1720.72,56.45,65.2 } -- LosAztecas
		Skinshops[#Skinshops+1] = { 1289.66,-1762.54,54.21,22.68 } -- LosAztecas
		Skinshops[#Skinshops+1] = { 1338.0,-792.43,71.51,343.0 } -- brancos
		Skinshops[#Skinshops+1] = { 1346.33,-705.11,67.74,73.71 } -- brancos
		Skinshops[#Skinshops+1] = { 1267.24,-299.03,84.59,158.75 } -- barragem
		Skinshops[#Skinshops+1] = { 1251.62,-265.92,77.91,107.72 } -- barragem
		Skinshops[#Skinshops+1] = { 1506.8,-2368.57,78.03,274.97 } -- rosas
		Skinshops[#Skinshops+1] = { 1512.78,-2365.16,78.03,195.6 } -- rosas
		-- Skinshops[#Skinshops+1] = { 2225.07,3452.81,61.33,172.92 } -- cinzas
		-- Skinshops[#Skinshops+1] = { 2229.55,3452.95,61.33,170.08 } -- cinzas
		-- Skinshops[#Skinshops+1] = { 2226.14,3453.91,61.33,187.09 } -- cinzas
		Skinshops[#Skinshops+1] = { 103.67,1221.91,207.17,102.05 } -- SOA
		Skinshops[#Skinshops+1] = { 1306.65,-735.32,65.09,340.16 } -- brancos
		Skinshops[#Skinshops+1] = { -215.34,-1334.28,34.9,266.46 } -- bennys
		Skinshops[#Skinshops+1] = { 1048.13,888.82,220.34,48.19 } -- playboy
		Skinshops[#Skinshops+1] = { 1341.91,-790.49,71.51,340.16 } -- brancos
		Skinshops[#Skinshops+1] = { 1336.42,-788.7,71.51,348.67 } -- brancos
		Skinshops[#Skinshops+1] = { 1308.3,-733.85,65.09,340.16 } -- brancos
		Skinshops[#Skinshops+1] = { -1550.84,-393.9,41.97,51.03 } -- 
		Skinshops[#Skinshops+1] = { 1963.43,6415.17,61.7,311.82 } -- marrons
		Skinshops[#Skinshops+1] = { -2272.06,323.23,174.6,22.68 }
		Skinshops[#Skinshops+1] = { -1687.17,-3185.18,14.0,243.78 }
		Skinshops[#Skinshops+1] = { 747.78,-308.18,59.8,306.15 } -- Campinho
		Skinshops[#Skinshops+1] = { 905.89,339.35,112.29,345.83 } -- Japao
		Skinshops[#Skinshops+1] = { -1044.65,305.04,71.66,266.46 } -- Inglaterra
		Skinshops[#Skinshops+1] = { -2022.42,4435.69,53.09,345.83 } -- Banzas
		Skinshops[#Skinshops+1] = { 355.76,-2729.82,1.72,257.96 } -- Dixavas
		Skinshops[#Skinshops+1] = { -769.38,8.1,40.64,345.83 } 
		Skinshops[#Skinshops+1] = { 1471.81,6539.39,18.64,85.04 } -- pier norte
		Skinshops[#Skinshops+1] = { -602.0,-914.22,23.88,184.26 } -- Anonymous
		Skinshops[#Skinshops+1] = { -602.7,-923.49,17.59,328.82 } -- Anonymous
		Skinshops[#Skinshops+1] = { -2813.9,2266.37,24.33,354.34 } -- qg 71
		Skinshops[#Skinshops+1] = { 676.42,909.22,247.57,170.08 } -- Inglaterra
		Skinshops[#Skinshops+1] = { 5026.55,-5760.97,15.77,232.45 } -- Caribe
		Skinshops[#Skinshops+1] = { 2612.27,5333.94,47.57,59.53 } -- prf
		Skinshops[#Skinshops+1] = { 3088.32,5091.99,23.25,73.71 } -- qg_80
		Skinshops[#Skinshops+1] = { -156.96,8259.62,12.82,11.34 } -- iate
		Skinshops[#Skinshops+1] = { -1784.4,-1376.75,11.88,39.69 } -- iate
		Skinshops[#Skinshops+1] = { -1883.34,-1164.43,11.73,320.32 } -- iate
		Skinshops[#Skinshops+1] = { -2210.16,-586.48,11.73,232.45 } 
		Skinshops[#Skinshops+1] = { 866.58,1871.27,140.39,87.88 } -- QG_07
		Skinshops[#Skinshops+1] = { -1179.62,302.46,73.67,102.05 } -- qg_82
		Skinshops[#Skinshops+1] = { -1226.24,-1737.73,4.53,138.9 } -- qg_83
		Skinshops[#Skinshops+1] = { -2423.52,1790.06,185.48,39.69 } -- qg_84
		Skinshops[#Skinshops+1] = { -878.0,-1434.81,7.53,201.26 } -- qg_85
		Skinshops[#Skinshops+1] = { -539.93,5002.83,159.92,272.13 } -- qg_86
		Skinshops[#Skinshops+1] = { -2675.14,1307.61,152.0,272.13 } -- qg_87
		Skinshops[#Skinshops+1] = { -2277.87,336.33,178.57,300.48 } -- qg_88
		Skinshops[#Skinshops+1] = { 3482.3,5015.04,11.91,212.6 }
		Skinshops[#Skinshops+1] = { -4504.72,-70.94,12.81,164.41 }
		Skinshops[#Skinshops+1] = { 994.15,3403.17,61.97,280.63 } -- QG_31
		Skinshops[#Skinshops+1] = { 89.54,-1966.65,20.74,320.32 } -- QG_43
		Skinshops[#Skinshops+1] = { 2456.34,4980.02,46.83,158.75 } -- QG_64
		Skinshops[#Skinshops+1] = { -935.2,403.8,79.23,195.6 } -- QG_103
		Skinshops[#Skinshops+1] = { 129.79,-99.03,49.57,161.58 } -- QG_106
		Skinshops[#Skinshops+1] = { 3496.16,-3283.35,10.62,25.52 } -- IlhaBatman
		Skinshops[#Skinshops+1] = { 715.75,-959.24,30.4,354.34 } -- QG_108
		Skinshops[#Skinshops+1] = { 867.22,1872.93,140.39,153.08 } -- QG_07
		Skinshops[#Skinshops+1] = { 676.42,909.22,247.57,170.08} -- QG_121
		Skinshops[#Skinshops+1] = { -3485.3,2799.67,22.01,357.17 } -- Mansao161
		Skinshops[#Skinshops+1] = { -3467.55,2835.87,22.01,150.24 } -- Mansao161

elseif cityName == "Orizon" then
	Skinshops[#Skinshops+1] = { -2566.45,-2204.01,5.05,161.58 } -- Resort
		Skinshops[#Skinshops+1] = { -3068.65,3456.45,10.03,255.12 } -- mansao93
		Skinshops[#Skinshops+1] = { 557.16,-192.72,54.53,357.17 } -- mecanica
		Skinshops[#Skinshops+1] = { 1133.63,-1518.37,34.84,66.08 } -- paramedic
		Skinshops[#Skinshops+1] = { -2597.16,-525.77,17.81,11.26 } -- mansao179
		-- Skinshops[#Skinshops+1] = { -2597.16,-525.77,17.81,11.26 } -- QG_348
		Skinshops[#Skinshops+1] = { -2235.48,499.10,174.40,156.49 } -- QG_337
		Skinshops[#Skinshops+1] = { -2238.06,498.90,178.23,35.39 } -- QG_337
		Skinshops[#Skinshops+1] = { -2982.14,-389.51,19.68,340.16 } -- mansao57
		Skinshops[#Skinshops+1] = { -1467.92,-45.17,58.67,133.23 } -- QG_331
		Skinshops[#Skinshops+1] = { 547.03,920.90,250.95,181.53 } -- mansao167
		Skinshops[#Skinshops+1] = { 3440.50,4940.65,39.86,216.22 } -- mansao166
		Skinshops[#Skinshops+1] = { 3423.33,4957.89,36.01,295.83 } -- mansao166
		Skinshops[#Skinshops+1] = { -3672.06,3869.33,19.95,5.67 } -- Mansao247
		Skinshops[#Skinshops+1] = { -3670.74,3882.16,19.95,184.26 } -- Mansao247
		Skinshops[#Skinshops+1] = { -1887.03,-56.26,130.22,189.93 } -- Mansao259
		Skinshops[#Skinshops+1] = { -1886.32,-57.54,135.2,195.6 } -- Mansao259
		Skinshops[#Skinshops+1] = { -1912.66,-53.77,135.24,189.93 } -- Mansao259
		Skinshops[#Skinshops+1] = { -3006.06,-1363.04,61.25,223.94 } -- Mansao273
		Skinshops[#Skinshops+1] = { -2990.96,-1362.85,61.25,42.52 } -- Mansao273
		Skinshops[#Skinshops+1] = { -2977.52,-1386.81,56.58,314.65 } -- Mansao273
		Skinshops[#Skinshops+1] = { -554.14,1192.33,334.08,280.63 } -- AlphaA1
		Skinshops[#Skinshops+1] = { -575.98,1193.24,334.08,184.26 } -- AlphaA2
		Skinshops[#Skinshops+1] = { -604.07,1192.34,334.08,269.3 } -- AlphaA3
		Skinshops[#Skinshops+1] = { -628.87,1192.29,334.08,283.47 } -- AlphaA4
		Skinshops[#Skinshops+1] = { -543.57,1251.58,334.08,85.04 } -- AlphaB1
		Skinshops[#Skinshops+1] = { -568.49,1251.75,334.08,110.56 } -- AlphaB2
		Skinshops[#Skinshops+1] = { -593.38,1251.64,334.08,102.05 } -- AlphaB3
		Skinshops[#Skinshops+1] = { -618.02,1251.67,334.08,87.88 } -- AlphaB4
		Skinshops[#Skinshops+1] = { -2349.97,3266.35,32.81,154.02 }
		Skinshops[#Skinshops+1] = { 129.47,-99.07,49.58,207.22 } -- Nightclub
		-- Skinshops[#Skinshops+1] = { -1514.82,-1468.04,6.39,206.93 } -- Atlantis
		Skinshops[#Skinshops+1] = { -1695.24,-1130.01,14.0,147.41 }
		Skinshops[#Skinshops+1] = { -1699.29,-1126.98,14.0,226.78 }
		Skinshops[#Skinshops+1] = { -1695.16,-1123.33,14.0,235.28 }
		Skinshops[#Skinshops+1] = { -1690.89,-1135.97,14.0,320.32 }
		Skinshops[#Skinshops+1] = { -1691.3,-1127.11,14.0,255.12 }
		Skinshops[#Skinshops+1] = { -304.41,6274.05,34.79,119.06 } -- mansao128
		Skinshops[#Skinshops+1] = { -1136.33,-2076.44,21.28,223.94 } -- mecanica
		Skinshops[#Skinshops+1] = { -417.98,4372.91,61.35,184.26 } -- mansao94
		Skinshops[#Skinshops+1] = { -2675.31,1307.53,152.01,277.90 } -- mansao119
		Skinshops[#Skinshops+1] = { 102.33,-1312.02,21.13,42.52 } -- QG_463
		-- Skinshops[#Skinshops+1] = { 791.97,5736.84,702.57,76.54 } -- mansao90
		Skinshops[#Skinshops+1] = { 2023.49,-1600.29,258.50,347.38 } -- mansao101
		Skinshops[#Skinshops+1] = { 3496.16,-3283.35,10.62,25.52 } -- mansao103
		Skinshops[#Skinshops+1] = { 840.40,-124.81,79.77,60.72 } -- mansao105
		Skinshops[#Skinshops+1] = { -3803.98,287.45,158.80,171.05 } -- mansao108
		Skinshops[#Skinshops+1] = { -3529.43,4608.58,10.05,291.43 } -- mansao114
		Skinshops[#Skinshops+1] = { 93.40,6517.33,31.26,305.00 } -- QG_131
		Skinshops[#Skinshops+1] = { -1729.43,374.72,89.72,230.96 } -- QG_154
		Skinshops[#Skinshops+1] = { -2086.45,-303.38,13.24,167.25 } -- QG_156
		Skinshops[#Skinshops+1] = { -523.98,514.28,108.08,315.38 } -- QG_158
		-- Skinshops[#Skinshops+1] = { 1185.11,873.56,144.00,161.87 } -- QG_159 / Mansao53
		Skinshops[#Skinshops+1] = { -1368.02,-613.34,30.32,34.56 } -- QG_148
		Skinshops[#Skinshops+1] = { 958.86,-966.6,42.95,348.67 } -- mecanica
		Skinshops[#Skinshops+1] = { -632.41,-134.04,43.22,93.55 } -- Bombeiros
		Skinshops[#Skinshops+1] = { 1150.65,-1583.05,35.28,138.9 } -- hp
		Skinshops[#Skinshops+1] = { 458.14,-999.19,30.68,331.66 } -- Militar
		Skinshops[#Skinshops+1] = { -437.84,6012.35,36.99,357.17 } -- civil
		Skinshops[#Skinshops+1] = { -780.21,-1211.9,10.38,141.74 } -- Tatica
		Skinshops[#Skinshops+1] = { -1887.58,3026.39,32.96,328.82 } -- Exercito
		Skinshops[#Skinshops+1] = { 1075.28,3273.75,41.11,198.43 } -- umbrella
		Skinshops[#Skinshops+1] = { 875.42,1860.9,142.5,226.78 } -- Metgala
		Skinshops[#Skinshops+1] = { -2197.05,-275.16,35.79,257.96 } -- Gang4
		Skinshops[#Skinshops+1] = { -458.91,-1264.9,25.48,51.03 } -- Afetados
		Skinshops[#Skinshops+1] = { 413.04,6468.02,29.82,274.97 } -- Pinkmans
		Skinshops[#Skinshops+1] = { 1513.4,1356.95,108.29,286.3 } -- Gang9
		Skinshops[#Skinshops+1] = { 957.6,-2390.99,22.33,175.75 } -- China
		Skinshops[#Skinshops+1] = { 3047.53,-4136.9,9.86,351.5 }
		-- Skinshops[#Skinshops+1] = { 1030.2,-2550.23,32.28,85.04 } -- Vermelhos
		Skinshops[#Skinshops+1] = { 1797.05,441.96,172.34,59.53 } -- Azul
		Skinshops[#Skinshops+1] = { 2133.61,-15.7,227.22,45.36 } -- Rosa
		Skinshops[#Skinshops+1] = { 2742.43,2716.88,55.84,48.19 } -- Sindicato
		-- Skinshops[#Skinshops+1] = { -139.96,-1609.06,35.03,68.04 } -- Groove
		-- Skinshops[#Skinshops+1] = { 2115.64,3886.09,33.23,215.44 } -- Roxos
		Skinshops[#Skinshops+1] = { 514.2,370.01,151.73,104.89 } -- Roxos
		Skinshops[#Skinshops+1] = { 358.11,-2033.39,22.39,48.19 } -- Vagos
		Skinshops[#Skinshops+1] = { 117.31,-1962.14,21.33,201.26 } -- Ballas
		Skinshops[#Skinshops+1] = { 755.82,-203.84,70.63,289.14 } -- QG_34
		Skinshops[#Skinshops+1] = { 755.7,-203.72,70.63,280.63 } -- QG_113
		Skinshops[#Skinshops+1] = { 1221.1,-1858.54,45.71,289.14 } -- QG_116
		Skinshops[#Skinshops+1] = { 1330.04,-707.86,67.28,116.23 } -- QG_117
		Skinshops[#Skinshops+1] = { -2189.20,4283.77,49.18,196.14 } -- QG_144
		-- Skinshops[#Skinshops+1] = {  103.51,3613.09,40.49,175.75 } -- Laranja
		Skinshops[#Skinshops+1] = { 291.24,216.89,78.82,277.8 } -- Bahamas
		Skinshops[#Skinshops+1] = { 945.01,47.64,80.29,53.86 } -- Bellagio
		Skinshops[#Skinshops+1] = { -1540.36,321.5,87.25,73.71 } -- Lavajato
		Skinshops[#Skinshops+1] = { 102.53,-1311.89,21.13,31.19 } -- Putaria
		Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
		Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
		Skinshops[#Skinshops+1] = { -3320.91,548.73,13.77,303.31 } -- Arcade
		Skinshops[#Skinshops+1] = { 414.94,-23.43,91.93,56.7 } -- Callisto
		Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
		Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
		Skinshops[#Skinshops+1] = { -203.27,-1330.04,34.9,127.56 } -- Undergrounds
		Skinshops[#Skinshops+1] = { 1382.88,-2093.85,47.21,31.19 } -- fazer
		Skinshops[#Skinshops+1] = { 2361.62,5647.1,92.71,141.74 } -- Topgear
		Skinshops[#Skinshops+1] = { 1378.51,-2096.32,52.6,39.69  } -- FerroVelho
		Skinshops[#Skinshops+1] = { 2643.51,3636.15,106.73,39.69 } -- Morro-do-Sacola
		Skinshops[#Skinshops+1] = { 883.73,-2100.55,30.46,175.75 } -- CarClube
		Skinshops[#Skinshops+1] = { -337.81,-166.57,44.58,272.13 } -- Virtude
		Skinshops[#Skinshops+1] = { 134.68,-369.75,50.33,17.01 } -- Big
		Skinshops[#Skinshops+1] = { 2742.47,3500.22,61.3,357.17} -- Kraken
		Skinshops[#Skinshops+1] = { -1149.56,-1554.59,7.63,153.08 } -- bandoleros
		Skinshops[#Skinshops+1] = { 556.33,-2773.46,6.08,59.53 } -- Gang5
		Skinshops[#Skinshops+1] = { 99.06,1229.61,207.17,345.83 } -- Mayans
		Skinshops[#Skinshops+1] = { 1028.6,-2550.72,32.28,351.5 } -- soa
		Skinshops[#Skinshops+1] = { 1026.51,-2542.27,28.29,170.08 } -- hellsangels
		Skinshops[#Skinshops+1] = { 3234.18,5120.17,20.15,116.23 }
		Skinshops[#Skinshops+1] = { 2312.64,5568.36,51.91,343.0 } -- sinaloa
		Skinshops[#Skinshops+1] = { -60.09,994.66,239.52,328.82 } -- gringa
		Skinshops[#Skinshops+1] = { -1539.52,141.51,55.65,51.03 } -- bloods
		-- Skinshops[#Skinshops+1] = { -2804.84,2261.69,24.11,320.32 } -- bloods secundario
		Skinshops[#Skinshops+1] = { -3025.46,59.49,11.95,331.66 } -- crips
		Skinshops[#Skinshops+1] = { -339.2,-1523.7,29.34,22.68 } -- warlocks
		Skinshops[#Skinshops+1] = { -1814.54,447.96,127.91,351.5 } -- mexicana
		Skinshops[#Skinshops+1] = { -1887.16,2070.1,145.57,334.49 } -- russa
		Skinshops[#Skinshops+1] = { -1491.07,845.77,181.59,87.88 } -- irlandesa
		Skinshops[#Skinshops+1] = { 173.45,668.33,207.66,104.89 } -- triade
		Skinshops[#Skinshops+1] = { 420.53,-1483.85,33.8,116.23 } -- italiana
		Skinshops[#Skinshops+1] = { 2332.3,5524.54,51.68,249.45 } -- overdrive
		Skinshops[#Skinshops+1] = { -776.37,-2593.33,17.66,238.12 } -- Outlaws 
		Skinshops[#Skinshops+1] = { -617.15,-1617.33,33.01,172.92 } -- Topgear 
		Skinshops[#Skinshops+1] = { -290.78,1986.24,166.14,334.49 } -- israel
		-- Skinshops[#Skinshops+1] = { 1078.37,-1973.3,31.48,235.28 } -- gringa
		Skinshops[#Skinshops+1] = { -303.2,220.21,77.91,257.96 } -- luxor
		Skinshops[#Skinshops+1] = { 1252.95,-1720.72,56.45,65.2 } -- LosAztecas
		Skinshops[#Skinshops+1] = { 1289.66,-1762.54,54.21,22.68 } -- LosAztecas
		Skinshops[#Skinshops+1] = { 1338.0,-792.43,71.51,343.0 } -- brancos
		Skinshops[#Skinshops+1] = { 1346.33,-705.11,67.74,73.71 } -- brancos
		Skinshops[#Skinshops+1] = { 1267.24,-299.03,84.59,158.75 } -- barragem
		Skinshops[#Skinshops+1] = { 1251.62,-265.92,77.91,107.72 } -- barragem
		Skinshops[#Skinshops+1] = { 1506.8,-2368.57,78.03,274.97 } -- rosas
		Skinshops[#Skinshops+1] = { 1512.78,-2365.16,78.03,195.6 } -- rosas
		-- Skinshops[#Skinshops+1] = { 2225.07,3452.81,61.33,172.92 } -- cinzas
		-- Skinshops[#Skinshops+1] = { 2229.55,3452.95,61.33,170.08 } -- cinzas
		-- Skinshops[#Skinshops+1] = { 2226.14,3453.91,61.33,187.09 } -- cinzas
		Skinshops[#Skinshops+1] = { 103.67,1221.91,207.17,102.05 } -- SOA
		Skinshops[#Skinshops+1] = { 1306.65,-735.32,65.09,340.16 } -- brancos
		Skinshops[#Skinshops+1] = { -215.34,-1334.28,34.9,266.46 } -- bennys
		Skinshops[#Skinshops+1] = { 1048.13,888.82,220.34,48.19 } -- playboy
		Skinshops[#Skinshops+1] = { 1341.91,-790.49,71.51,340.16 } -- brancos
		Skinshops[#Skinshops+1] = { 1336.42,-788.7,71.51,348.67 } -- brancos
		Skinshops[#Skinshops+1] = { 1308.3,-733.85,65.09,340.16 } -- brancos
		Skinshops[#Skinshops+1] = { -1550.84,-393.9,41.97,51.03 } -- 
		Skinshops[#Skinshops+1] = { -3337.8,543.54,17.44,215.44 } -- mansao 60
		Skinshops[#Skinshops+1] = { 1963.43,6415.17,61.7,311.82 } -- marrons
		Skinshops[#Skinshops+1] = { -2272.06,323.23,174.6,22.68 }
		Skinshops[#Skinshops+1] = { -1687.17,-3185.18,14.0,243.78 }
		Skinshops[#Skinshops+1] = { 1402.74,1154.66,114.33,266.46 } -- fazendinha
		Skinshops[#Skinshops+1] = { 747.78,-308.18,59.8,306.15 } -- Campinho
		Skinshops[#Skinshops+1] = { 905.89,339.35,112.29,345.83 } -- Japao
		Skinshops[#Skinshops+1] = { -1044.65,305.04,71.66,266.46 } -- Inglaterra
		Skinshops[#Skinshops+1] = { -2022.42,4435.69,53.09,345.83 } -- Banzas
		Skinshops[#Skinshops+1] = { 355.76,-2729.82,1.72,257.96 } -- Dixavas
		Skinshops[#Skinshops+1] = { -769.38,8.1,40.64,345.83 } 
		Skinshops[#Skinshops+1] = { 1471.81,6539.39,18.64,85.04 } -- pier norte
		Skinshops[#Skinshops+1] = { -602.0,-914.22,23.88,184.26 } -- Anonymous
		Skinshops[#Skinshops+1] = { -602.7,-923.49,17.59,328.82 } -- Anonymous
		Skinshops[#Skinshops+1] = { -2813.9,2266.37,24.33,354.34 } -- qg 71
		Skinshops[#Skinshops+1] = { 676.42,909.22,247.57,170.08 } -- Inglaterra
		Skinshops[#Skinshops+1] = { 5026.55,-5760.97,15.77,232.45 } -- Caribe
		Skinshops[#Skinshops+1] = { 2612.27,5333.94,47.57,59.53 } -- prf
		Skinshops[#Skinshops+1] = { 3088.32,5091.99,23.25,73.71 } -- qg_80
		Skinshops[#Skinshops+1] = { -156.96,8259.62,12.82,11.34 } -- iate
		Skinshops[#Skinshops+1] = { -1784.4,-1376.75,11.88,39.69 } -- iate
		Skinshops[#Skinshops+1] = { -1883.34,-1164.43,11.73,320.32 } -- iate
		Skinshops[#Skinshops+1] = { -2210.16,-586.48,11.73,232.45 } 
		Skinshops[#Skinshops+1] = { -1179.62,302.46,73.67,102.05 } -- qg_82
		Skinshops[#Skinshops+1] = { -1226.24,-1737.73,4.53,138.9 } -- qg_83
		Skinshops[#Skinshops+1] = { -2423.52,1790.06,185.48,39.69 } -- qg_84
		Skinshops[#Skinshops+1] = { -878.0,-1434.81,7.53,201.26 } -- qg_85
		Skinshops[#Skinshops+1] = { -539.93,5002.83,159.92,272.13 } -- qg_86
		Skinshops[#Skinshops+1] = { -2675.14,1307.61,152.0,272.13 } -- qg_87
		Skinshops[#Skinshops+1] = { -2277.87,336.33,178.57,300.48 } -- qg_88
		Skinshops[#Skinshops+1] = { 3482.3,5015.04,11.91,212.6 }
		Skinshops[#Skinshops+1] = { -4504.72,-70.94,12.81,164.41 }
		Skinshops[#Skinshops+1] = { 994.15,3403.17,61.97,280.63 } -- QG_31
		Skinshops[#Skinshops+1] = { 2456.34,4980.02,46.83,158.75 } -- QG_64
		Skinshops[#Skinshops+1] = { -2813.7,2266.54,24.31,343.0 } -- QG_124
		Skinshops[#Skinshops+1] = { 866.7,1872.27,144.52,138.9 } -- QG_126
		Skinshops[#Skinshops+1] = { 1378.59,-2096.53,52.6,306.15 } -- QG_68
		Skinshops[#Skinshops+1] = { -669.18,6391.58,13.02,133.53 } -- QG_128
		Skinshops[#Skinshops+1] = { -2598.64,1889.43,163.75,323.7 } -- QG_129
		Skinshops[#Skinshops+1] = { 2022.46,3373.80,46.60,80.00 } -- QG_130

elseif cityName == "Liberty99" then
	Skinshops[#Skinshops+1] = { -877.7,-1434.85,7.53,209.77 } -- QG_434
	Skinshops[#Skinshops+1] = { -2566.45,-2204.01,5.05,161.58 } -- Resort
		Skinshops[#Skinshops+1] = { -2713.12,-64.74,21.74,34.02 } -- Mansao277
		Skinshops[#Skinshops+1] = { -2700.32,-75.08,21.74,215.44 } -- Mansao277
		Skinshops[#Skinshops+1] = { -3068.65,3456.45,10.03,255.12 } -- mansao93
		Skinshops[#Skinshops+1] = { -82.68,831.54,235.72,290.06 } -- QG_392
		Skinshops[#Skinshops+1] = { 557.16,-192.72,54.53,357.17 } -- mecanica
		Skinshops[#Skinshops+1] = { -307.7,-590.09,32.77,104.89 } -- paramedic
		-- Skinshops[#Skinshops+1] = { -303.87,6274.04,34.79,45.36 } -- Mansao188
		-- Skinshops[#Skinshops+1] = { -3067.05,1915.53,33.95,155.91 } -- Mansao187
		-- Skinshops[#Skinshops+1] = { -3092.03,1884.82,33.95,164.41 } -- Mansao187
		Skinshops[#Skinshops+1] = { -2779.46,-488.03,6.62,320.94 } -- Iate03
		-- Skinshops[#Skinshops+1] = { -2794.15,-204.13,23.62,21.27 } -- Mansao186
		Skinshops[#Skinshops+1] = { -1988.18,-227.63,89.62,328.82 } -- Mansao208
		Skinshops[#Skinshops+1] = { -1973.39,-224.51,89.62,48.19 } -- Mansao208
		Skinshops[#Skinshops+1] = { -1956.59,-245.65,84.96,317.49 } -- Mansao208
		Skinshops[#Skinshops+1] = { -1218.32,853.80,197.11,264.00 } -- Mansao209
		Skinshops[#Skinshops+1] = { 2951.2,895.72,17.12,31.19 } -- Mansao222
		Skinshops[#Skinshops+1] = { 2905.61,929.06,21.89,249.45 } -- Mansao222
		Skinshops[#Skinshops+1] = { 2922.6,925.53,21.89,36.86 } -- Mansao222
		Skinshops[#Skinshops+1] = { 2903.82,936.22,17.12,238.12 } -- Mansao222
		Skinshops[#Skinshops+1] = { -753.42,941.17,241.91,291.97 } -- Mansao200
		Skinshops[#Skinshops+1] = { -3333.67,575.02,14.41,303.31 } -- QG_76
		Skinshops[#Skinshops+1] = { 676.73,909.14,247.57,164.41 } -- QG_302
		Skinshops[#Skinshops+1] = { 688.13,914.25,247.57,107.72 } -- QG_302
		Skinshops[#Skinshops+1] = { -1379.81,-636.05,30.31,212.6 } -- Bahamas
		Skinshops[#Skinshops+1] = { 1834.41,2571.42,46.01,336.15 } -- PoliciaPrisional
		Skinshops[#Skinshops+1] = { -162.92,1245.87,311.45,51.03 } -- QG_328
		-- Skinshops[#Skinshops+1] = { -3077.26,1881.28,33.95,79.38 } -- mansao55
		-- Skinshops[#Skinshops+1] = { -1707.12,-91.01,89.83,45.36 } -- mansao139
		-- Skinshops[#Skinshops+1] = { 653.44,921.91,252.6,170.08 } -- mansao61
		Skinshops[#Skinshops+1] = { -2987.77,2185.47,45.09,127.56 } -- mansao62
		Skinshops[#Skinshops+1] = { 757.92,3423.04,62.68,76.54 } -- mansao48
		Skinshops[#Skinshops+1] = { -1048.78,2790.62,27.20,105.51 } -- mansao158
		-- Skinshops[#Skinshops+1] = { -1238.71,795.43,197.19,96.38 } -- mansao44
		Skinshops[#Skinshops+1] = { -1530.12,821.28,184.92,8.69 } -- QG_269
		Skinshops[#Skinshops+1] = { -554.14,1192.33,334.08,280.63 } -- AlphaA1
		Skinshops[#Skinshops+1] = { -575.98,1193.24,334.08,184.26 } -- AlphaA2
		Skinshops[#Skinshops+1] = { -604.07,1192.34,334.08,269.3 } -- AlphaA3
		Skinshops[#Skinshops+1] = { -628.87,1192.29,334.08,283.47 } -- AlphaA4
		Skinshops[#Skinshops+1] = { -543.57,1251.58,334.08,85.04 } -- AlphaB1
		Skinshops[#Skinshops+1] = { -568.49,1251.75,334.08,110.56 } -- AlphaB2
		Skinshops[#Skinshops+1] = { -593.38,1251.64,334.08,102.05 } -- AlphaB3
		Skinshops[#Skinshops+1] = { -618.02,1251.67,334.08,87.88 } -- AlphaB4
		Skinshops[#Skinshops+1] = { -1017.01,1134.35,225.37,82.21 } -- Alpha3B1
		Skinshops[#Skinshops+1] = { -1024.91,1094.09,225.37,82.21 } -- Alpha3B2
		Skinshops[#Skinshops+1] = { -1032.56,1053.6,225.37,79.38 } -- Alpha3B3
		Skinshops[#Skinshops+1] = { -973.09,1019.16,225.37,82.21 } -- Alpha3B4
		Skinshops[#Skinshops+1] = { -965.32,1059.39,225.37,87.88 } -- Alpha3B5
		Skinshops[#Skinshops+1] = { -957.27,1099.48,225.37,68.04 } -- Alpha3B6
		Skinshops[#Skinshops+1] = { -2252.95,-664.07,14.52,223.94 } -- Mansao224
		Skinshops[#Skinshops+1] = { -2261.74,-664.29,14.52,130.4 } -- Mansao224
		Skinshops[#Skinshops+1] = { -2262.64,-665.3,19.51,133.23 } -- Mansao224
		Skinshops[#Skinshops+1] = { -2272.78,-637.26,19.51,229.61 } -- Mansao224
		Skinshops[#Skinshops+1] = { -2270.7,-640.49,19.51,51.03 } -- Mansao224
		Skinshops[#Skinshops+1] = { -2239.89,485.86,179.2,266.46 } -- Mansao225
		Skinshops[#Skinshops+1] = { -2246.25,475.28,179.2,90.71 } -- Mansao225
		Skinshops[#Skinshops+1] = { -2250.36,525.26,179.2,187.09 } -- Mansao225
		Skinshops[#Skinshops+1] = { 658.49,3846.51,53.31,348.67 } -- Mansao231
		Skinshops[#Skinshops+1] = { 700.41,3846.7,53.31,0.0 } -- Mansao231
		Skinshops[#Skinshops+1] = { 325.02,817.44,197.06,39.69 } -- Mansao251
		Skinshops[#Skinshops+1] = { 356.3,832.83,201.37,116.23 } -- Mansao251
		Skinshops[#Skinshops+1] = { -3485.3,2799.67,22.01,357.17 } -- Mansao161
		Skinshops[#Skinshops+1] = { -3467.55,2835.87,22.01,150.24 } -- Mansao161
		Skinshops[#Skinshops+1] = { -2349.97,3266.35,32.81,154.02 }
		-- Skinshops[#Skinshops+1] = { -1914.03,-53.82,135.69,22.68 } -- mansao154
		Skinshops[#Skinshops+1] = { -3164.47,2336.05,14.2,8.51 } -- QG_264
		-- Skinshops[#Skinshops+1] = { -1514.82,-1468.04,6.39,206.93 } -- Atlantis
		Skinshops[#Skinshops+1] = { -1695.24,-1130.01,14.0,147.41 }
		Skinshops[#Skinshops+1] = { -1699.29,-1126.98,14.0,226.78 }
		Skinshops[#Skinshops+1] = { -3803.9,288.08,158.81,175.75 } -- QG_173
		Skinshops[#Skinshops+1] = { 1678.57,7055.46,11.77,141.25 }
		Skinshops[#Skinshops+1] = { 136.79,-346.87,50.33,158.75 } -- QG_168
		Skinshops[#Skinshops+1] = { -404.72,4373.04,62.82,354.34 } -- mansao94
		Skinshops[#Skinshops+1] = { -142.82,6494.48,38.84,39.69 } -- mansao102
		Skinshops[#Skinshops+1] = { 2023.49,-1600.29,258.50,347.38 } -- mansao101
		Skinshops[#Skinshops+1] = { 368.92,2384.33,80.24,137.06 } -- mansao49
		Skinshops[#Skinshops+1] = { -126.17,6619.03,33.85,311.82 } -- mansao51
		Skinshops[#Skinshops+1] = { -1474.76,-1759.03,14.35,3.21 } -- mansao70
		Skinshops[#Skinshops+1] = { -2766.96,-941.86,16.05,64.63 } -- mansao71
		Skinshops[#Skinshops+1] = { -1141.65,374.78,74.97,226.04 } -- QG_155
		Skinshops[#Skinshops+1] = { -1417.25,-617.80,30.72,36.73 } -- MajorBahamas
		Skinshops[#Skinshops+1] = { -3090.98,3367.52,17.32,180.20 } -- mansao66
		Skinshops[#Skinshops+1] = { -3536.63,4623.20,6.72,287.43 } -- mansao96
		Skinshops[#Skinshops+1] = { 1036.84,3678.09,39.05,179.56 } -- mansao16
		Skinshops[#Skinshops+1] = { 2006.75,3354.94,51.60,83.44 } -- QG_150
		Skinshops[#Skinshops+1] = { 102.37,-1311.13,21.13,48.19 } -- QG_143
		Skinshops[#Skinshops+1] = { -2189.20,4283.77,49.18,196.14 } -- QG_132
		Skinshops[#Skinshops+1] = { 958.7,-966.6,42.95,263.63 } -- mecanica
		Skinshops[#Skinshops+1] = { -632.41,-134.04,43.22,93.55 } -- Bombeiros
		Skinshops[#Skinshops+1] = { 1087.36,-922.42,51.27,175.24 } -- Bombeiros
		Skinshops[#Skinshops+1] = { 1150.65,-1583.05,35.28,138.9 } -- hp
		Skinshops[#Skinshops+1] = { 457.64,-990.77,30.68,11.34 } -- dp praça
		Skinshops[#Skinshops+1] = { 2516.96,-345.11,101.89,42.52 } -- Militar
		Skinshops[#Skinshops+1] = { -437.84,6012.35,36.99,357.17 } -- civil
		Skinshops[#Skinshops+1] = { -780.21,-1211.9,10.38,141.74 } -- Tatica
		Skinshops[#Skinshops+1] = { -1887.58,3026.39,32.96,328.82 } -- Exercito
		Skinshops[#Skinshops+1] = { 1075.28,3273.75,41.11,198.43 } -- umbrella
		Skinshops[#Skinshops+1] = { 875.42,1860.9,142.5,226.78 } -- Metgala
		Skinshops[#Skinshops+1] = { -2197.05,-275.16,35.79,257.96 } -- Gang4
		Skinshops[#Skinshops+1] = { -458.91,-1264.9,25.48,51.03 } -- Afetados
		Skinshops[#Skinshops+1] = { 413.04,6468.02,29.82,274.97 } -- Pinkmans
		Skinshops[#Skinshops+1] = { 1513.4,1356.95,108.29,286.3 } -- Gang9
		Skinshops[#Skinshops+1] = { 957.6,-2390.99,22.33,175.75 } -- China
		Skinshops[#Skinshops+1] = { 790.13,5752.55,702.57,249.45 } -- Mansao95
		Skinshops[#Skinshops+1] = { -763.42,29.24,40.64,161.58 } -- Igreja
		Skinshops[#Skinshops+1] = { 3047.53,-4136.9,9.86,351.5 }
		Skinshops[#Skinshops+1] = { -2003.59,4494.14,57.29,320.32 }
		Skinshops[#Skinshops+1] = { -1628.7,-1100.71,13.09,229.61 }
		-- Skinshops[#Skinshops+1] = { 2029.85,4299.39,38.25,99.22 } -- QG_110
		-- Skinshops[#Skinshops+1] = { 1030.2,-2550.23,32.28,85.04 } -- Vermelhos
		Skinshops[#Skinshops+1] = { 1797.05,441.96,172.34,59.53 } -- Azul
		Skinshops[#Skinshops+1] = { 2133.61,-15.7,227.22,45.36 } -- Rosa
		Skinshops[#Skinshops+1] = { 2742.43,2716.88,55.84,48.19 } -- Sindicato
		-- Skinshops[#Skinshops+1] = { -139.96,-1609.06,35.03,68.04 } -- Groove
		Skinshops[#Skinshops+1] = { 2115.64,3886.09,33.23,215.44 } -- Roxos
		Skinshops[#Skinshops+1] = { 514.2,370.01,151.73,104.89 } -- Roxos
		Skinshops[#Skinshops+1] = { 358.11,-2033.39,22.39,48.19 } -- Vagos
		Skinshops[#Skinshops+1] = { 117.31,-1962.14,21.33,201.26 } -- Ballas
		-- Skinshops[#Skinshops+1] = {  103.51,3613.09,40.49,175.75 } -- Laranja
		Skinshops[#Skinshops+1] = { 291.24,216.89,78.82,277.8 } -- Bahamas
		Skinshops[#Skinshops+1] = { 945.01,47.64,80.29,53.86 } -- Bellagio
		Skinshops[#Skinshops+1] = { -1540.36,321.5,87.25,73.71 } -- Lavajato
		Skinshops[#Skinshops+1] = { 102.53,-1311.89,21.13,31.19 } -- Putaria
		Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
		Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
		Skinshops[#Skinshops+1] = { 414.94,-23.43,91.93,56.7 } -- Callisto
		Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
		Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
		Skinshops[#Skinshops+1] = { -203.27,-1330.04,34.9,127.56 } -- Undergrounds
		Skinshops[#Skinshops+1] = { 1382.88,-2093.85,47.21,31.19 } -- fazer
		Skinshops[#Skinshops+1] = { 2361.62,5647.1,92.71,141.74 } -- Topgear
		Skinshops[#Skinshops+1] = { 1378.51,-2096.32,52.6,39.69  } -- FerroVelho
		Skinshops[#Skinshops+1] = { 2643.51,3636.15,106.73,39.69 } -- Morro-do-Sacola
		Skinshops[#Skinshops+1] = { 883.73,-2100.55,30.46,175.75 } -- CarClube
		Skinshops[#Skinshops+1] = { -337.81,-166.57,44.58,272.13 } -- Virtude
		Skinshops[#Skinshops+1] = { 134.68,-369.75,50.33,17.01 } -- Big
		Skinshops[#Skinshops+1] = { 2742.47,3500.22,61.3,357.17} -- Kraken
		Skinshops[#Skinshops+1] = { -1149.56,-1554.59,7.63,153.08 } -- bandoleros
		Skinshops[#Skinshops+1] = { 556.33,-2773.46,6.08,59.53 } -- Gang5
		Skinshops[#Skinshops+1] = { 99.06,1229.61,207.17,345.83 } -- Mayans
		Skinshops[#Skinshops+1] = { 1028.6,-2550.72,32.28,351.5 } -- soa
		Skinshops[#Skinshops+1] = { 1026.51,-2542.27,28.29,170.08 } -- hellsangels
		Skinshops[#Skinshops+1] = { 3234.18,5120.17,20.15,116.23 }
		Skinshops[#Skinshops+1] = { 2312.64,5568.36,51.91,343.0 } -- sinaloa
		Skinshops[#Skinshops+1] = { -60.09,994.66,239.52,328.82 } -- gringa
		Skinshops[#Skinshops+1] = { -1539.52,141.51,55.65,51.03 } -- bloods
		-- Skinshops[#Skinshops+1] = { -2804.84,2261.69,24.11,320.32 } -- bloods secundario
		Skinshops[#Skinshops+1] = { -3025.46,59.49,11.95,331.66 } -- crips
		Skinshops[#Skinshops+1] = { -1814.54,447.96,127.91,351.5 } -- mexicana
		Skinshops[#Skinshops+1] = { -1887.16,2070.1,145.57,334.49 } -- russa
		Skinshops[#Skinshops+1] = { -1491.07,845.77,181.59,87.88 } -- irlandesa
		Skinshops[#Skinshops+1] = { 173.45,668.33,207.66,104.89 } -- triade
		Skinshops[#Skinshops+1] = { 420.53,-1483.85,33.8,116.23 } -- italiana
		Skinshops[#Skinshops+1] = { 2332.3,5524.54,51.68,249.45 } -- overdrive
		Skinshops[#Skinshops+1] = { -776.37,-2593.33,17.66,238.12 } -- Outlaws 
		Skinshops[#Skinshops+1] = { -617.15,-1617.33,33.01,172.92 } -- Topgear 
		Skinshops[#Skinshops+1] = { -290.78,1986.24,166.14,334.49 } -- israel
		-- Skinshops[#Skinshops+1] = { 1078.37,-1973.3,31.48,235.28 } -- gringa
		Skinshops[#Skinshops+1] = { -303.2,220.21,77.91,257.96 } -- luxor
		Skinshops[#Skinshops+1] = { 1252.95,-1720.72,56.45,65.2 } -- LosAztecas
		Skinshops[#Skinshops+1] = { 1289.66,-1762.54,54.21,22.68 } -- LosAztecas
		Skinshops[#Skinshops+1] = { 1338.0,-792.43,71.51,343.0 } -- brancos
		Skinshops[#Skinshops+1] = { 1346.33,-705.11,67.74,73.71 } -- brancos
		Skinshops[#Skinshops+1] = { 1267.24,-299.03,84.59,158.75 } -- barragem
		Skinshops[#Skinshops+1] = { 1251.62,-265.92,77.91,107.72 } -- barragem
		Skinshops[#Skinshops+1] = { 1506.8,-2368.57,78.03,274.97 } -- rosas
		Skinshops[#Skinshops+1] = { 1512.78,-2365.16,78.03,195.6 } -- rosas
		-- Skinshops[#Skinshops+1] = { 2225.07,3452.81,61.33,172.92 } -- cinzas
		-- Skinshops[#Skinshops+1] = { 2229.55,3452.95,61.33,170.08 } -- cinzas
		-- Skinshops[#Skinshops+1] = { 2226.14,3453.91,61.33,187.09 } -- cinzas
		Skinshops[#Skinshops+1] = { 103.67,1221.91,207.17,102.05 } -- SOA
		Skinshops[#Skinshops+1] = { 1306.65,-735.32,65.09,340.16 } -- brancos
		Skinshops[#Skinshops+1] = { -215.34,-1334.28,34.9,266.46 } -- bennys
		Skinshops[#Skinshops+1] = { 1048.13,888.82,220.34,48.19 } -- playboy
		Skinshops[#Skinshops+1] = { 1341.91,-790.49,71.51,340.16 } -- brancos
		Skinshops[#Skinshops+1] = { 1336.42,-788.7,71.51,348.67 } -- brancos
		Skinshops[#Skinshops+1] = { 1308.3,-733.85,65.09,340.16 } -- brancos
		Skinshops[#Skinshops+1] = { -1550.84,-393.9,41.97,51.03 } -- 
		Skinshops[#Skinshops+1] = { 1963.43,6415.17,61.7,311.82 } -- marrons
		Skinshops[#Skinshops+1] = { -2272.06,323.23,174.6,22.68 }
		Skinshops[#Skinshops+1] = { -1687.17,-3185.18,14.0,243.78 }
		Skinshops[#Skinshops+1] = { 747.78,-308.18,59.8,306.15 } -- Campinho
		Skinshops[#Skinshops+1] = { 905.89,339.35,112.29,345.83 } -- Japao
		Skinshops[#Skinshops+1] = { -1044.65,305.04,71.66,266.46 } -- Inglaterra
		Skinshops[#Skinshops+1] = { -2022.42,4435.69,53.09,345.83 } -- Banzas
		Skinshops[#Skinshops+1] = { 355.76,-2729.82,1.72,257.96 } -- Dixavas
		Skinshops[#Skinshops+1] = { -769.38,8.1,40.64,345.83 } 
		Skinshops[#Skinshops+1] = { 1471.81,6539.39,18.64,85.04 } -- pier norte
		Skinshops[#Skinshops+1] = { -602.0,-914.22,23.88,184.26 } -- Anonymous
		Skinshops[#Skinshops+1] = { -602.7,-923.49,17.59,328.82 } -- Anonymous
		Skinshops[#Skinshops+1] = { -2813.9,2266.37,24.33,354.34 } -- qg 71
		Skinshops[#Skinshops+1] = { 676.42,909.22,247.57,170.08 } -- Inglaterra
		Skinshops[#Skinshops+1] = { 5026.55,-5760.97,15.77,232.45 } -- Caribe
		Skinshops[#Skinshops+1] = { 2612.27,5333.94,47.57,59.53 } -- prf
		Skinshops[#Skinshops+1] = { 3088.32,5091.99,23.25,73.71 } -- qg_80
		Skinshops[#Skinshops+1] = { -156.96,8259.62,12.82,11.34 } -- iate
		Skinshops[#Skinshops+1] = { -1784.4,-1376.75,11.88,39.69 } -- iate
		Skinshops[#Skinshops+1] = { -1883.34,-1164.43,11.73,320.32 } -- iate
		Skinshops[#Skinshops+1] = { -2210.16,-586.48,11.73,232.45 } 
		Skinshops[#Skinshops+1] = { 866.58,1871.27,140.39,87.88 } -- QG_07
		Skinshops[#Skinshops+1] = { -1179.62,302.46,73.67,102.05 } -- qg_82
		Skinshops[#Skinshops+1] = { -1226.24,-1737.73,4.53,138.9 } -- qg_83
		Skinshops[#Skinshops+1] = { -2423.52,1790.06,185.48,39.69 } -- qg_84
		-- Skinshops[#Skinshops+1] = { -878.0,-1434.81,7.53,201.26 } -- qg_85
		Skinshops[#Skinshops+1] = { -539.93,5002.83,159.92,272.13 } -- qg_86
		Skinshops[#Skinshops+1] = { -2675.14,1307.61,152.0,272.13 } -- qg_87
		Skinshops[#Skinshops+1] = { -2277.87,336.33,178.57,300.48 } -- qg_88
		Skinshops[#Skinshops+1] = { 3482.3,5015.04,11.91,212.6 }
		Skinshops[#Skinshops+1] = { -4504.72,-70.94,12.81,164.41 }
		Skinshops[#Skinshops+1] = { 994.15,3403.17,61.97,280.63 } -- QG_31
		Skinshops[#Skinshops+1] = { 89.54,-1966.65,20.74,320.32 } -- QG_43
		Skinshops[#Skinshops+1] = { 2456.34,4980.02,46.83,158.75 } -- QG_64
		Skinshops[#Skinshops+1] = { -935.2,403.8,79.23,195.6 } -- QG_103
		Skinshops[#Skinshops+1] = { 129.79,-99.03,49.57,161.58 } -- QG_106
		Skinshops[#Skinshops+1] = { 3496.16,-3283.35,10.62,25.52 } -- IlhaBatman
		Skinshops[#Skinshops+1] = { 715.75,-959.24,30.4,354.34 } -- QG_108
		Skinshops[#Skinshops+1] = { 867.22,1872.93,140.39,153.08 } -- QG_07
		Skinshops[#Skinshops+1] = { 676.42,909.22,247.57,170.08} -- QG_121
		Skinshops[#Skinshops+1] = { 694.59,1251.54,361.04,348.67 } -- Mansao287
		Skinshops[#Skinshops+1] = { 692.27,1245.24,361.01,82.21 } -- Mansao287
		Skinshops[#Skinshops+1] = { 691.85,1247.06,367.92,249.45 } -- Mansao287

elseif cityName == "Royal" then
	Skinshops[#Skinshops+1] = { -2566.45,-2204.01,5.05,161.58 } -- Resort
	Skinshops[#Skinshops+1] = { -3068.65,3456.45,10.03,255.12 } -- mansao93
	-- Skinshops[#Skinshops+1] = { -1496.75,105.84,60.84,5.67 } -- mansao173
	Skinshops[#Skinshops+1] = { -2987.47,-382.69,19.68,255.12 } -- mansao198
	Skinshops[#Skinshops+1] = { -2968.65,-375.82,19.71,340.16 } -- mansao198
	Skinshops[#Skinshops+1] = { -1579.87,-1847.2,12.74,121.89 } -- Mansao172
	Skinshops[#Skinshops+1] = { -1570.65,-1847.93,12.72,221.11 } -- Mansao172
	Skinshops[#Skinshops+1] = { -1586.41,-1818.9,17.73,221.11 } -- Mansao172
	Skinshops[#Skinshops+1] = { -1580.83,-1848.25,17.73,121.89 } -- Mansao172
	Skinshops[#Skinshops+1] = { -1649.68,722.83,207.57,175.75 } -- Mansao249
	Skinshops[#Skinshops+1] = { -1644.44,701.1,206.36,87.88 } -- Mansao249
	Skinshops[#Skinshops+1] = { 653.7,924.91,253.03,110.56 } -- QG_255
	Skinshops[#Skinshops+1] = { -3342.38,565.82,17.18,264.70 } -- QG_273
	Skinshops[#Skinshops+1] = { -554.14,1192.33,334.08,280.63 } -- AlphaA1
	Skinshops[#Skinshops+1] = { -575.98,1193.24,334.08,184.26 } -- AlphaA2
	Skinshops[#Skinshops+1] = { -604.07,1192.34,334.08,269.3 } -- AlphaA3
	Skinshops[#Skinshops+1] = { -628.87,1192.29,334.08,283.47 } -- AlphaA4
	Skinshops[#Skinshops+1] = { -543.57,1251.58,334.08,85.04 } -- AlphaB1
	Skinshops[#Skinshops+1] = { -568.49,1251.75,334.08,110.56 } -- AlphaB2
	Skinshops[#Skinshops+1] = { -593.38,1251.64,334.08,102.05 } -- AlphaB3
	Skinshops[#Skinshops+1] = { -618.02,1251.67,334.08,87.88 } -- AlphaB4
	Skinshops[#Skinshops+1] = { -1017.01,1134.35,225.37,82.21 } -- Alpha3B1
	Skinshops[#Skinshops+1] = { -1024.91,1094.09,225.37,82.21 } -- Alpha3B2
	Skinshops[#Skinshops+1] = { -1032.56,1053.6,225.37,79.38 } -- Alpha3B3
	Skinshops[#Skinshops+1] = { -973.09,1019.16,225.37,82.21 } -- Alpha3B4
	Skinshops[#Skinshops+1] = { -965.32,1059.39,225.37,87.88 } -- Alpha3B5
	Skinshops[#Skinshops+1] = { -957.27,1099.48,225.37,68.04 } -- Alpha3B6
	Skinshops[#Skinshops+1] = { -793.02,926.42,243.9,104.89 } -- Mansao263
	Skinshops[#Skinshops+1] = { -762.01,927.25,243.9,104.89 } -- Mansao263
	Skinshops[#Skinshops+1] = { -749.1,943.05,243.31,113.39 } -- Mansao263
	Skinshops[#Skinshops+1] = { -1720.29,-91.35,93.63,320.32 } -- Mansao264
	Skinshops[#Skinshops+1] = { 380.68,2361.02,80.24,235.28 } -- Mansao265
	Skinshops[#Skinshops+1] = { 368.93,2384.59,80.24,317.49 } -- Mansao265
	Skinshops[#Skinshops+1] = { 368.08,2383.43,75.25,328.82 } -- Mansao265
	Skinshops[#Skinshops+1] = { 359.58,2381.64,75.23,51.03 } -- Mansao265
	Skinshops[#Skinshops+1] = { -3672.06,3869.33,19.95,5.67 } -- Mansao266
	Skinshops[#Skinshops+1] = { -3670.74,3882.16,19.95,184.26 } -- Mansao266
	Skinshops[#Skinshops+1] = { -1704.11,468.44,133.05,102.05 } -- Mansao267
	Skinshops[#Skinshops+1] = { -1706.46,467.83,133.06,286.3 } -- Mansao267
	Skinshops[#Skinshops+1] = { -2349.97,3266.35,32.81,154.02 }
	Skinshops[#Skinshops+1] = { -1514.82,-1468.04,6.39,206.93 } -- Atlantis
	Skinshops[#Skinshops+1] = { -2311.47,4333.13,37.07,136.07 } -- Mansao150
	Skinshops[#Skinshops+1] = { 1179.95,873.78,147.54,144.57 } -- Mansao145
	Skinshops[#Skinshops+1] = { -417.98,4372.91,61.35,184.26 } -- mansao94
	Skinshops[#Skinshops+1] = { -696.43,631.64,159.18,119.06 } -- Mansao144
	Skinshops[#Skinshops+1] = { -540.03,5008.22,163.83,56.7 } -- mansao143
	Skinshops[#Skinshops+1] = { -1690.82,-1136.04,14.0,331.66 }
	Skinshops[#Skinshops+1] = { -1687.21,-1131.57,14.0,238.12 }
	Skinshops[#Skinshops+1] = { -1695.08,-1123.43,14.0,229.61 }
	Skinshops[#Skinshops+1] = { -1697.18,-1127.15,14.0,206.93 }
	Skinshops[#Skinshops+1] = { 127.86,-1298.24,21.11,127.56 } -- Mansao116
	Skinshops[#Skinshops+1] = { 791.97,5736.84,702.57,76.54 } -- mansao90
	Skinshops[#Skinshops+1] = { 2023.49,-1600.29,258.50,347.38 } -- mansao101
	Skinshops[#Skinshops+1] = { 3496.16,-3283.35,10.62,25.52 } -- mansao103
	Skinshops[#Skinshops+1] = { 840.40,-124.81,79.77,60.72 } -- mansao105
	Skinshops[#Skinshops+1] = { -3803.98,287.45,158.80,171.05 } -- mansao108
	Skinshops[#Skinshops+1] = { -3529.43,4608.58,10.05,291.43 } -- mansao114
	Skinshops[#Skinshops+1] = { 93.40,6517.33,31.26,305.00 } -- QG_131
	Skinshops[#Skinshops+1] = { 660.40,2090.36,115.28,49.34 } -- QG_174
	Skinshops[#Skinshops+1] = { -1729.43,374.72,89.72,230.96 } -- QG_154
	Skinshops[#Skinshops+1] = { 180.28,1715.41,231.16,344.05 } -- QG_161 / mansao15
	Skinshops[#Skinshops+1] = { -2086.45,-303.38,13.24,167.25 } -- QG_156
	Skinshops[#Skinshops+1] = { -523.98,514.28,108.08,315.38 } -- QG_158
	-- Skinshops[#Skinshops+1] = { 1185.11,873.56,144.00,161.87 } -- QG_159 / Mansao53
	Skinshops[#Skinshops+1] = { -1368.02,-613.34,30.32,34.56 } -- QG_148
	Skinshops[#Skinshops+1] = { 958.86,-966.6,42.95,348.67 } -- mecanica
	Skinshops[#Skinshops+1] = { -632.41,-134.04,43.22,93.55 } -- Bombeiros
	Skinshops[#Skinshops+1] = { 1150.65,-1583.05,35.28,138.9 } -- hp
	Skinshops[#Skinshops+1] = { 458.14,-999.19,30.68,331.66 } -- Militar
	Skinshops[#Skinshops+1] = { -437.84,6012.35,36.99,357.17 } -- civil
	Skinshops[#Skinshops+1] = { -780.21,-1211.9,10.38,141.74 } -- Tatica
	Skinshops[#Skinshops+1] = { -1887.58,3026.39,32.96,328.82 } -- Exercito
	Skinshops[#Skinshops+1] = { 1075.28,3273.75,41.11,198.43 } -- umbrella
	Skinshops[#Skinshops+1] = { 875.42,1860.9,142.5,226.78 } -- Metgala
	Skinshops[#Skinshops+1] = { -2197.05,-275.16,35.79,257.96 } -- Gang4
	Skinshops[#Skinshops+1] = { -458.91,-1264.9,25.48,51.03 } -- Afetados
	Skinshops[#Skinshops+1] = { 413.04,6468.02,29.82,274.97 } -- Pinkmans
	Skinshops[#Skinshops+1] = { 1513.4,1356.95,108.29,286.3 } -- Gang9
	Skinshops[#Skinshops+1] = { 957.6,-2390.99,22.33,175.75 } -- China
	Skinshops[#Skinshops+1] = { 3047.53,-4136.9,9.86,351.5 }
	-- Skinshops[#Skinshops+1] = { 1030.2,-2550.23,32.28,85.04 } -- Vermelhos
	Skinshops[#Skinshops+1] = { 1797.05,441.96,172.34,59.53 } -- Azul
	Skinshops[#Skinshops+1] = { 2133.61,-15.7,227.22,45.36 } -- Rosa
	Skinshops[#Skinshops+1] = { 2742.43,2716.88,55.84,48.19 } -- Sindicato
	-- Skinshops[#Skinshops+1] = { -139.96,-1609.06,35.03,68.04 } -- Groove
	-- Skinshops[#Skinshops+1] = { 2115.64,3886.09,33.23,215.44 } -- Roxos
	Skinshops[#Skinshops+1] = { 514.2,370.01,151.73,104.89 } -- Roxos
	Skinshops[#Skinshops+1] = { 358.11,-2033.39,22.39,48.19 } -- Vagos
	Skinshops[#Skinshops+1] = { 117.31,-1962.14,21.33,201.26 } -- Ballas
	Skinshops[#Skinshops+1] = { 755.82,-203.84,70.63,289.14 } -- QG_34
	Skinshops[#Skinshops+1] = { 755.7,-203.72,70.63,280.63 } -- QG_113
	Skinshops[#Skinshops+1] = { 1221.1,-1858.54,45.71,289.14 } -- QG_116
	Skinshops[#Skinshops+1] = { 1330.04,-707.86,67.28,116.23 } -- QG_117
	Skinshops[#Skinshops+1] = { -2189.20,4283.77,49.18,196.14 } -- QG_144
	-- Skinshops[#Skinshops+1] = {  103.51,3613.09,40.49,175.75 } -- Laranja
	Skinshops[#Skinshops+1] = { 291.24,216.89,78.82,277.8 } -- Bahamas
	Skinshops[#Skinshops+1] = { 945.01,47.64,80.29,53.86 } -- Bellagio
	Skinshops[#Skinshops+1] = { -1540.36,321.5,87.25,73.71 } -- Lavajato
	Skinshops[#Skinshops+1] = { 102.53,-1311.89,21.13,31.19 } -- Putaria
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { 414.94,-23.43,91.93,56.7 } -- Callisto
	Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
	Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
	Skinshops[#Skinshops+1] = { -203.27,-1330.04,34.9,127.56 } -- Undergrounds
	Skinshops[#Skinshops+1] = { 1382.88,-2093.85,47.21,31.19 } -- fazer
	Skinshops[#Skinshops+1] = { 2361.62,5647.1,92.71,141.74 } -- Topgear
	Skinshops[#Skinshops+1] = { 1378.51,-2096.32,52.6,39.69  } -- FerroVelho
	Skinshops[#Skinshops+1] = { 2643.51,3636.15,106.73,39.69 } -- Morro-do-Sacola
	Skinshops[#Skinshops+1] = { 883.73,-2100.55,30.46,175.75 } -- CarClube
	Skinshops[#Skinshops+1] = { -337.81,-166.57,44.58,272.13 } -- Virtude
	Skinshops[#Skinshops+1] = { 134.68,-369.75,50.33,17.01 } -- Big
	Skinshops[#Skinshops+1] = { 2742.47,3500.22,61.3,357.17} -- Kraken
	Skinshops[#Skinshops+1] = { -1149.56,-1554.59,7.63,153.08 } -- bandoleros
	Skinshops[#Skinshops+1] = { 556.33,-2773.46,6.08,59.53 } -- Gang5
	Skinshops[#Skinshops+1] = { 99.06,1229.61,207.17,345.83 } -- Mayans
	Skinshops[#Skinshops+1] = { 1028.6,-2550.72,32.28,351.5 } -- soa
	Skinshops[#Skinshops+1] = { 1026.51,-2542.27,28.29,170.08 } -- hellsangels
	Skinshops[#Skinshops+1] = { 3234.18,5120.17,20.15,116.23 }
	Skinshops[#Skinshops+1] = { 2312.64,5568.36,51.91,343.0 } -- sinaloa
	Skinshops[#Skinshops+1] = { -60.09,994.66,239.52,328.82 } -- gringa
	Skinshops[#Skinshops+1] = { -1539.52,141.51,55.65,51.03 } -- bloods
	-- Skinshops[#Skinshops+1] = { -2804.84,2261.69,24.11,320.32 } -- bloods secundario
	Skinshops[#Skinshops+1] = { -3025.46,59.49,11.95,331.66 } -- crips
	Skinshops[#Skinshops+1] = { -339.2,-1523.7,29.34,22.68 } -- warlocks
	Skinshops[#Skinshops+1] = { -1814.54,447.96,127.91,351.5 } -- mexicana
	Skinshops[#Skinshops+1] = { -1887.16,2070.1,145.57,334.49 } -- russa
	Skinshops[#Skinshops+1] = { -1491.07,845.77,181.59,87.88 } -- irlandesa
	Skinshops[#Skinshops+1] = { 173.45,668.33,207.66,104.89 } -- triade
	Skinshops[#Skinshops+1] = { 420.53,-1483.85,33.8,116.23 } -- italiana
	Skinshops[#Skinshops+1] = { 2332.3,5524.54,51.68,249.45 } -- overdrive
	Skinshops[#Skinshops+1] = { -776.37,-2593.33,17.66,238.12 } -- Outlaws 
	Skinshops[#Skinshops+1] = { -617.15,-1617.33,33.01,172.92 } -- Topgear 
	Skinshops[#Skinshops+1] = { -290.78,1986.24,166.14,334.49 } -- israel
	-- Skinshops[#Skinshops+1] = { 1078.37,-1973.3,31.48,235.28 } -- gringa
	Skinshops[#Skinshops+1] = { -303.2,220.21,77.91,257.96 } -- luxor
	Skinshops[#Skinshops+1] = { 1252.95,-1720.72,56.45,65.2 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1289.66,-1762.54,54.21,22.68 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1338.0,-792.43,71.51,343.0 } -- brancos
	Skinshops[#Skinshops+1] = { 1346.33,-705.11,67.74,73.71 } -- brancos
	-- Skinshops[#Skinshops+1] = { 1267.24,-299.03,84.59,158.75 } -- barragem
	Skinshops[#Skinshops+1] = { 1251.62,-265.92,77.91,107.72 } -- barragem
	Skinshops[#Skinshops+1] = { 1506.8,-2368.57,78.03,274.97 } -- rosas
	Skinshops[#Skinshops+1] = { 1512.78,-2365.16,78.03,195.6 } -- rosas
	-- Skinshops[#Skinshops+1] = { 2225.07,3452.81,61.33,172.92 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2229.55,3452.95,61.33,170.08 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2226.14,3453.91,61.33,187.09 } -- cinzas
	Skinshops[#Skinshops+1] = { 103.67,1221.91,207.17,102.05 } -- SOA
	Skinshops[#Skinshops+1] = { 1306.65,-735.32,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -215.34,-1334.28,34.9,266.46 } -- bennys
	Skinshops[#Skinshops+1] = { 1048.13,888.82,220.34,48.19 } -- playboy
	Skinshops[#Skinshops+1] = { 1341.91,-790.49,71.51,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { 1336.42,-788.7,71.51,348.67 } -- brancos
	Skinshops[#Skinshops+1] = { 1308.3,-733.85,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -1550.84,-393.9,41.97,51.03 } -- 
	Skinshops[#Skinshops+1] = { 1963.43,6415.17,61.7,311.82 } -- marrons
	Skinshops[#Skinshops+1] = { -2272.06,323.23,174.6,22.68 }
	Skinshops[#Skinshops+1] = { -1687.17,-3185.18,14.0,243.78 }
	Skinshops[#Skinshops+1] = { 1402.74,1154.66,114.33,266.46 } -- fazendinha
	Skinshops[#Skinshops+1] = { 747.78,-308.18,59.8,306.15 } -- Campinho
	Skinshops[#Skinshops+1] = { 905.89,339.35,112.29,345.83 } -- Japao
	Skinshops[#Skinshops+1] = { -1044.65,305.04,71.66,266.46 } -- Inglaterra
	Skinshops[#Skinshops+1] = { -2022.42,4435.69,53.09,345.83 } -- Banzas
	Skinshops[#Skinshops+1] = { 355.76,-2729.82,1.72,257.96 } -- Dixavas
	Skinshops[#Skinshops+1] = { -769.38,8.1,40.64,345.83 } 
	Skinshops[#Skinshops+1] = { 1471.81,6539.39,18.64,85.04 } -- pier norte
	Skinshops[#Skinshops+1] = { -602.0,-914.22,23.88,184.26 } -- Anonymous
	Skinshops[#Skinshops+1] = { -602.7,-923.49,17.59,328.82 } -- Anonymous
	Skinshops[#Skinshops+1] = { -2813.9,2266.37,24.33,354.34 } -- qg 71
	Skinshops[#Skinshops+1] = { 676.42,909.22,247.57,170.08 } -- Inglaterra
	Skinshops[#Skinshops+1] = { 5026.55,-5760.97,15.77,232.45 } -- Caribe
	Skinshops[#Skinshops+1] = { 2612.27,5333.94,47.57,59.53 } -- prf
	Skinshops[#Skinshops+1] = { 3088.32,5091.99,23.25,73.71 } -- qg_80
	Skinshops[#Skinshops+1] = { -156.96,8259.62,12.82,11.34 } -- iate
	Skinshops[#Skinshops+1] = { -1784.4,-1376.75,11.88,39.69 } -- iate
	Skinshops[#Skinshops+1] = { -1883.34,-1164.43,11.73,320.32 } -- iate
	Skinshops[#Skinshops+1] = { -2210.16,-586.48,11.73,232.45 } 
	Skinshops[#Skinshops+1] = { -1179.62,302.46,73.67,102.05 } -- qg_82
	Skinshops[#Skinshops+1] = { -1226.24,-1737.73,4.53,138.9 } -- qg_83
	Skinshops[#Skinshops+1] = { -2423.52,1790.06,185.48,39.69 } -- qg_84
	Skinshops[#Skinshops+1] = { -878.0,-1434.81,7.53,201.26 } -- qg_85
	Skinshops[#Skinshops+1] = { -539.93,5002.83,159.92,272.13 } -- qg_86
	Skinshops[#Skinshops+1] = { -2675.14,1307.61,152.0,272.13 } -- qg_87
	Skinshops[#Skinshops+1] = { -2277.87,336.33,178.57,300.48 } -- qg_88
	Skinshops[#Skinshops+1] = { 3482.3,5015.04,11.91,212.6 }
	Skinshops[#Skinshops+1] = { -4504.72,-70.94,12.81,164.41 }
	Skinshops[#Skinshops+1] = { 994.15,3403.17,61.97,280.63 } -- QG_31
	Skinshops[#Skinshops+1] = { 89.54,-1966.65,20.74,320.32 } -- QG_43
	Skinshops[#Skinshops+1] = { 2456.34,4980.02,46.83,158.75 } -- QG_64
	Skinshops[#Skinshops+1] = { 866.7,1872.27,144.52,138.9 } -- QG_126
	Skinshops[#Skinshops+1] = { 1378.59,-2096.53,52.6,306.15 } -- QG_68
	Skinshops[#Skinshops+1] = { -669.18,6391.58,13.02,133.53 } -- QG_128
	Skinshops[#Skinshops+1] = { -2598.64,1889.43,163.75,323.7 } -- QG_129
	Skinshops[#Skinshops+1] = { 2022.46,3373.80,46.60,80.00 } -- QG_130
	Skinshops[#Skinshops+1] = { -1136.33,-2076.44,21.28,223.94 } -- mecanica


elseif cityName == "Real" then
	Skinshops[#Skinshops+1] = { -2566.45,-2204.01,5.05,161.58 } -- Resort
	Skinshops[#Skinshops+1] = { -3068.65,3456.45,10.03,255.12 } -- mansao93
	Skinshops[#Skinshops+1] = { 380.68,2361.02,80.24,235.28 } -- mansao192
	Skinshops[#Skinshops+1] = { 368.93,2384.59,80.24,317.49 } -- mansao192
	Skinshops[#Skinshops+1] = { 368.08,2383.43,75.25,328.82 } -- mansao192
	Skinshops[#Skinshops+1] = { 359.58,2381.64,75.23,51.03 } -- mansao192
	Skinshops[#Skinshops+1] = { -3519.9,1301.06,13.26,240.95 } -- Mansao237
	Skinshops[#Skinshops+1] = { -3518.98,1272.39,13.26,155.91 } -- Mansao237
	Skinshops[#Skinshops+1] = { -3151.83,1762.13,45.01,107.72 } -- Mansao239
	Skinshops[#Skinshops+1] = { -3151.48,1757.94,45.01,102.05 } -- Mansao239
	Skinshops[#Skinshops+1] = { -3168.56,1708.42,45.01,189.93 } -- Mansao239
	Skinshops[#Skinshops+1] = { -3145.67,1724.47,45.01,110.56 } -- Mansao239
	Skinshops[#Skinshops+1] = { -3541.55,4585.79,14.05,212.6 } -- Mansao246
	Skinshops[#Skinshops+1] = { -3521.24,4599.03,14.04,17.01 } -- Mansao246
	Skinshops[#Skinshops+1] = { -3529.67,4608.4,10.04,289.14 } -- Mansao246
	Skinshops[#Skinshops+1] = { -3369.01,-1009.97,18.37,14.18 } -- Mansao248
	Skinshops[#Skinshops+1] = { -3370.87,-1018.19,18.37,121.89 } -- Mansao248
	Skinshops[#Skinshops+1] = { -3369.6,-1008.75,23.35,22.68 } -- Mansao248
	Skinshops[#Skinshops+1] = { -3343.35,-1008.58,23.35,294.81 } -- Mansao248
	Skinshops[#Skinshops+1] = { -3339.77,-1007.76,23.35,116.23 } -- Mansao248
	Skinshops[#Skinshops+1] = { -3262.14,-931.72,21.72,121.89 } -- Mansao248
	Skinshops[#Skinshops+1] = { -1050.32,-2011.89,13.16,138.47 } -- mecanica
	Skinshops[#Skinshops+1] = { 1133.63,-1518.37,34.84,66.08 } -- paramedic
	Skinshops[#Skinshops+1] = { -554.14,1192.33,334.08,280.63 } -- AlphaA1
	Skinshops[#Skinshops+1] = { -575.98,1193.24,334.08,184.26 } -- AlphaA2
	Skinshops[#Skinshops+1] = { -604.07,1192.34,334.08,269.3 } -- AlphaA3
	Skinshops[#Skinshops+1] = { -628.87,1192.29,334.08,283.47 } -- AlphaA4
	Skinshops[#Skinshops+1] = { -543.57,1251.58,334.08,85.04 } -- AlphaB1
	Skinshops[#Skinshops+1] = { -568.49,1251.75,334.08,110.56 } -- AlphaB2
	Skinshops[#Skinshops+1] = { -593.38,1251.64,334.08,102.05 } -- AlphaB3
	Skinshops[#Skinshops+1] = { -618.02,1251.67,334.08,87.88 } -- AlphaB4
	Skinshops[#Skinshops+1] = { -337.3,-166.77,44.58,272.13 } -- QG_272
	Skinshops[#Skinshops+1] = { -2349.97,3266.35,32.81,154.02 }
	Skinshops[#Skinshops+1] = { -1514.82,-1468.04,6.39,206.93 } -- Atlantis
	Skinshops[#Skinshops+1] = { -1695.24,-1130.01,14.0,147.41 }
	Skinshops[#Skinshops+1] = { -1699.29,-1126.98,14.0,226.78 }
	Skinshops[#Skinshops+1] = { -417.98,4372.91,61.35,184.26 } -- mansao94
	Skinshops[#Skinshops+1] = { 2023.49,-1600.29,258.50,347.38 } -- mansao101
	Skinshops[#Skinshops+1] = { -1729.43,374.72,89.72,230.96 } -- QG_154
	Skinshops[#Skinshops+1] = { 180.28,1715.41,231.16,344.05 } -- QG_161
	Skinshops[#Skinshops+1] = { -2086.45,-303.38,13.24,167.25 } -- QG_156
	Skinshops[#Skinshops+1] = { -523.98,514.28,108.08,315.38 } -- QG_158
	Skinshops[#Skinshops+1] = { 1185.11,873.56,144.00,161.87 } -- QG_159
	Skinshops[#Skinshops+1] = { -1368.02,-613.34,30.32,34.56 } -- QG_148
	Skinshops[#Skinshops+1] = { 958.86,-966.6,42.95,348.67 } -- mecanica
	Skinshops[#Skinshops+1] = { -632.41,-134.04,43.22,93.55 } -- Bombeiros
	Skinshops[#Skinshops+1] = { 1150.65,-1583.05,35.28,138.9 } -- hp
	Skinshops[#Skinshops+1] = { 458.14,-999.19,30.68,331.66 } -- Militar
	Skinshops[#Skinshops+1] = { -437.84,6012.35,36.99,357.17 } -- civil
	Skinshops[#Skinshops+1] = { -780.21,-1211.9,10.38,141.74 } -- Tatica
	Skinshops[#Skinshops+1] = { -1887.58,3026.39,32.96,328.82 } -- Exercito
	Skinshops[#Skinshops+1] = { 1075.28,3273.75,41.11,198.43 } -- umbrella
	Skinshops[#Skinshops+1] = { 875.42,1860.9,142.5,226.78 } -- Metgala
	Skinshops[#Skinshops+1] = { -2197.05,-275.16,35.79,257.96 } -- Gang4
	Skinshops[#Skinshops+1] = { -458.91,-1264.9,25.48,51.03 } -- Afetados
	Skinshops[#Skinshops+1] = { 413.04,6468.02,29.82,274.97 } -- Pinkmans
	Skinshops[#Skinshops+1] = { 1513.4,1356.95,108.29,286.3 } -- Gang9
	Skinshops[#Skinshops+1] = { 957.6,-2390.99,22.33,175.75 } -- China
	Skinshops[#Skinshops+1] = { 3047.53,-4136.9,9.86,351.5 }
	-- Skinshops[#Skinshops+1] = { 1030.2,-2550.23,32.28,85.04 } -- Vermelhos
	Skinshops[#Skinshops+1] = { 1797.05,441.96,172.34,59.53 } -- Azul
	Skinshops[#Skinshops+1] = { 2133.61,-15.7,227.22,45.36 } -- Rosa
	Skinshops[#Skinshops+1] = { 2742.43,2716.88,55.84,48.19 } -- Sindicato
	-- Skinshops[#Skinshops+1] = { -139.96,-1609.06,35.03,68.04 } -- Groove
	-- Skinshops[#Skinshops+1] = { 2115.64,3886.09,33.23,215.44 } -- Roxos
	Skinshops[#Skinshops+1] = { 514.2,370.01,151.73,104.89 } -- Roxos
	Skinshops[#Skinshops+1] = { 358.11,-2033.39,22.39,48.19 } -- Vagos
	Skinshops[#Skinshops+1] = { 117.31,-1962.14,21.33,201.26 } -- Ballas
	Skinshops[#Skinshops+1] = { 755.82,-203.84,70.63,289.14 } -- QG_34
	Skinshops[#Skinshops+1] = { 755.7,-203.72,70.63,280.63 } -- QG_113
	Skinshops[#Skinshops+1] = { 1221.1,-1858.54,45.71,289.14 } -- QG_116
	Skinshops[#Skinshops+1] = { 1330.04,-707.86,67.28,116.23 } -- QG_117
	Skinshops[#Skinshops+1] = { -2189.20,4283.77,49.18,196.14 } -- QG_144
	-- Skinshops[#Skinshops+1] = {  103.51,3613.09,40.49,175.75 } -- Laranja
	Skinshops[#Skinshops+1] = { 291.24,216.89,78.82,277.8 } -- Bahamas
	Skinshops[#Skinshops+1] = { 945.01,47.64,80.29,53.86 } -- Bellagio
	Skinshops[#Skinshops+1] = { -1540.36,321.5,87.25,73.71 } -- Lavajato
	Skinshops[#Skinshops+1] = { 102.53,-1311.89,21.13,31.19 } -- Putaria
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { -3320.91,548.73,13.77,303.31 } -- Arcade
	Skinshops[#Skinshops+1] = { 414.94,-23.43,91.93,56.7 } -- Callisto
	Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
	Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
	Skinshops[#Skinshops+1] = { -203.27,-1330.04,34.9,127.56 } -- Undergrounds
	Skinshops[#Skinshops+1] = { 1382.88,-2093.85,47.21,31.19 } -- fazer
	Skinshops[#Skinshops+1] = { 2361.62,5647.1,92.71,141.74 } -- Topgear
	Skinshops[#Skinshops+1] = { 1378.51,-2096.32,52.6,39.69  } -- FerroVelho
	Skinshops[#Skinshops+1] = { 2643.51,3636.15,106.73,39.69 } -- Morro-do-Sacola
	Skinshops[#Skinshops+1] = { 883.73,-2100.55,30.46,175.75 } -- CarClube
	Skinshops[#Skinshops+1] = { -337.81,-166.57,44.58,272.13 } -- Virtude
	Skinshops[#Skinshops+1] = { 134.68,-369.75,50.33,17.01 } -- Big
	Skinshops[#Skinshops+1] = { 2742.47,3500.22,61.3,357.17} -- Kraken
	Skinshops[#Skinshops+1] = { -1149.56,-1554.59,7.63,153.08 } -- bandoleros
	Skinshops[#Skinshops+1] = { 556.33,-2773.46,6.08,59.53 } -- Gang5
	Skinshops[#Skinshops+1] = { 99.06,1229.61,207.17,345.83 } -- Mayans
	Skinshops[#Skinshops+1] = { 1028.6,-2550.72,32.28,351.5 } -- soa
	Skinshops[#Skinshops+1] = { 1026.51,-2542.27,28.29,170.08 } -- hellsangels
	Skinshops[#Skinshops+1] = { 3234.18,5120.17,20.15,116.23 }
	Skinshops[#Skinshops+1] = { 2312.64,5568.36,51.91,343.0 } -- sinaloa
	Skinshops[#Skinshops+1] = { -60.09,994.66,239.52,328.82 } -- gringa
	Skinshops[#Skinshops+1] = { -1539.52,141.51,55.65,51.03 } -- bloods
	-- Skinshops[#Skinshops+1] = { -2804.84,2261.69,24.11,320.32 } -- bloods secundario
	Skinshops[#Skinshops+1] = { -3025.46,59.49,11.95,331.66 } -- crips
	Skinshops[#Skinshops+1] = { -339.2,-1523.7,29.34,22.68 } -- warlocks
	Skinshops[#Skinshops+1] = { -1814.54,447.96,127.91,351.5 } -- mexicana
	Skinshops[#Skinshops+1] = { -1887.16,2070.1,145.57,334.49 } -- russa
	Skinshops[#Skinshops+1] = { -1491.07,845.77,181.59,87.88 } -- irlandesa
	Skinshops[#Skinshops+1] = { 173.45,668.33,207.66,104.89 } -- triade
	Skinshops[#Skinshops+1] = { 420.53,-1483.85,33.8,116.23 } -- italiana
	Skinshops[#Skinshops+1] = { 2332.3,5524.54,51.68,249.45 } -- overdrive
	Skinshops[#Skinshops+1] = { -776.37,-2593.33,17.66,238.12 } -- Outlaws 
	Skinshops[#Skinshops+1] = { -617.15,-1617.33,33.01,172.92 } -- Topgear 
	Skinshops[#Skinshops+1] = { -290.78,1986.24,166.14,334.49 } -- israel
	-- Skinshops[#Skinshops+1] = { 1078.37,-1973.3,31.48,235.28 } -- gringa
	Skinshops[#Skinshops+1] = { -303.2,220.21,77.91,257.96 } -- luxor
	Skinshops[#Skinshops+1] = { 1252.95,-1720.72,56.45,65.2 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1338.0,-792.43,71.51,343.0 } -- brancos
	Skinshops[#Skinshops+1] = { 1346.33,-705.11,67.74,73.71 } -- brancos
	Skinshops[#Skinshops+1] = { 1267.24,-299.03,84.59,158.75 } -- barragem
	Skinshops[#Skinshops+1] = { 1251.62,-265.92,77.91,107.72 } -- barragem
	Skinshops[#Skinshops+1] = { 1506.8,-2368.57,78.03,274.97 } -- rosas
	Skinshops[#Skinshops+1] = { 1512.78,-2365.16,78.03,195.6 } -- rosas
	-- Skinshops[#Skinshops+1] = { 2225.07,3452.81,61.33,172.92 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2229.55,3452.95,61.33,170.08 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2226.14,3453.91,61.33,187.09 } -- cinzas
	Skinshops[#Skinshops+1] = { 103.67,1221.91,207.17,102.05 } -- SOA
	Skinshops[#Skinshops+1] = { 1306.65,-735.32,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -215.34,-1334.28,34.9,266.46 } -- bennys
	Skinshops[#Skinshops+1] = { 1048.13,888.82,220.34,48.19 } -- playboy
	Skinshops[#Skinshops+1] = { 1341.91,-790.49,71.51,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { 1336.42,-788.7,71.51,348.67 } -- brancos
	Skinshops[#Skinshops+1] = { 1308.3,-733.85,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -1550.84,-393.9,41.97,51.03 } -- 
	Skinshops[#Skinshops+1] = { -3337.8,543.54,17.44,215.44 } -- mansao 60
	Skinshops[#Skinshops+1] = { 1963.43,6415.17,61.7,311.82 } -- marrons
	Skinshops[#Skinshops+1] = { -2272.06,323.23,174.6,22.68 }
	-- Skinshops[#Skinshops+1] = { -1687.17,-3185.18,14.0,243.78 }
	Skinshops[#Skinshops+1] = { 1402.74,1154.66,114.33,266.46 } -- fazendinha
	Skinshops[#Skinshops+1] = { 747.78,-308.18,59.8,306.15 } -- Campinho
	Skinshops[#Skinshops+1] = { 905.89,339.35,112.29,345.83 } -- Japao
	Skinshops[#Skinshops+1] = { -1044.65,305.04,71.66,266.46 } -- Inglaterra
	Skinshops[#Skinshops+1] = { -2022.42,4435.69,53.09,345.83 } -- Banzas
	Skinshops[#Skinshops+1] = { 355.76,-2729.82,1.72,257.96 } -- Dixavas
	Skinshops[#Skinshops+1] = { -769.38,8.1,40.64,345.83 } 
	Skinshops[#Skinshops+1] = { 1471.81,6539.39,18.64,85.04 } -- pier norte
	Skinshops[#Skinshops+1] = { -602.0,-914.22,23.88,184.26 } -- Anonymous
	Skinshops[#Skinshops+1] = { -602.7,-923.49,17.59,328.82 } -- Anonymous
	Skinshops[#Skinshops+1] = { 676.42,909.22,247.57,170.08 } -- Inglaterra
	Skinshops[#Skinshops+1] = { 5026.55,-5760.97,15.77,232.45 } -- Caribe
	Skinshops[#Skinshops+1] = { 2612.27,5333.94,47.57,59.53 } -- prf
	Skinshops[#Skinshops+1] = { 3088.32,5091.99,23.25,73.71 } -- qg_80
	Skinshops[#Skinshops+1] = { -156.96,8259.62,12.82,11.34 } -- iate
	Skinshops[#Skinshops+1] = { -1784.4,-1376.75,11.88,39.69 } -- iate
	Skinshops[#Skinshops+1] = { -1883.34,-1164.43,11.73,320.32 } -- iate
	Skinshops[#Skinshops+1] = { -2210.16,-586.48,11.73,232.45 } 
	Skinshops[#Skinshops+1] = { -1179.62,302.46,73.67,102.05 } -- qg_82
	Skinshops[#Skinshops+1] = { -1226.24,-1737.73,4.53,138.9 } -- qg_83
	Skinshops[#Skinshops+1] = { -2423.52,1790.06,185.48,39.69 } -- qg_84
	Skinshops[#Skinshops+1] = { -878.0,-1434.81,7.53,201.26 } -- qg_85
	Skinshops[#Skinshops+1] = { -539.93,5002.83,159.92,272.13 } -- qg_86
	Skinshops[#Skinshops+1] = { -2675.14,1307.61,152.0,272.13 } -- qg_87
	Skinshops[#Skinshops+1] = { -2277.87,336.33,178.57,300.48 } -- qg_88
	Skinshops[#Skinshops+1] = { 3482.3,5015.04,11.91,212.6 }
	Skinshops[#Skinshops+1] = { -4504.72,-70.94,12.81,164.41 }
	Skinshops[#Skinshops+1] = { 994.15,3403.17,61.97,280.63 } -- QG_31
	Skinshops[#Skinshops+1] = { 89.54,-1966.65,20.74,320.32 } -- QG_43
	Skinshops[#Skinshops+1] = { 2456.34,4980.02,46.83,158.75 } -- QG_64
	Skinshops[#Skinshops+1] = { 866.7,1872.27,144.52,138.9 } -- QG_126
	Skinshops[#Skinshops+1] = { 1378.59,-2096.53,52.6,306.15 } -- QG_68
	Skinshops[#Skinshops+1] = { -669.18,6391.58,13.02,133.53 } -- QG_128
	Skinshops[#Skinshops+1] = { -2598.64,1889.43,163.75,323.7 } -- QG_129
	Skinshops[#Skinshops+1] = { 2022.46,3373.80,46.60,80.00 } -- QG_130
	Skinshops[#Skinshops+1] = { -1136.33,-2076.44,21.28,223.94 } -- mecanica

elseif cityName == "Prime" then
	Skinshops[#Skinshops+1] = { -2566.45,-2204.01,5.05,161.58 } -- Resort
	Skinshops[#Skinshops+1] = { -3068.65,3456.45,10.03,255.12 } -- mansao93
	Skinshops[#Skinshops+1] = { -1050.32,-2011.89,13.16,138.47 } -- mecanica
	Skinshops[#Skinshops+1] = { 1133.63,-1518.37,34.84,66.08 } -- paramedic
	Skinshops[#Skinshops+1] = { -554.14,1192.33,334.08,280.63 } -- AlphaA1
	Skinshops[#Skinshops+1] = { -575.98,1193.24,334.08,184.26 } -- AlphaA2
	Skinshops[#Skinshops+1] = { -604.07,1192.34,334.08,269.3 } -- AlphaA3
	Skinshops[#Skinshops+1] = { -628.87,1192.29,334.08,283.47 } -- AlphaA4
	Skinshops[#Skinshops+1] = { -543.57,1251.58,334.08,85.04 } -- AlphaB1
	Skinshops[#Skinshops+1] = { -568.49,1251.75,334.08,110.56 } -- AlphaB2
	Skinshops[#Skinshops+1] = { -593.38,1251.64,334.08,102.05 } -- AlphaB3
	Skinshops[#Skinshops+1] = { -618.02,1251.67,334.08,87.88 } -- AlphaB4
	Skinshops[#Skinshops+1] = { -337.3,-166.77,44.58,272.13 } -- QG_272
	Skinshops[#Skinshops+1] = { -2357.54,3256.29,32.81,52.43 } -- Exercito
	Skinshops[#Skinshops+1] = { 180.28,1715.41,231.16,344.05 } -- mansao15
	Skinshops[#Skinshops+1] = { -2349.97,3266.35,32.81,154.02 }
	Skinshops[#Skinshops+1] = { -1514.82,-1468.04,6.39,206.93 } -- Atlantis
	Skinshops[#Skinshops+1] = { -1695.24,-1130.01,14.0,147.41 }
	Skinshops[#Skinshops+1] = { -1699.29,-1126.98,14.0,226.78 }
	Skinshops[#Skinshops+1] = { 791.97,5736.84,702.57,76.54 } -- mansao90
	Skinshops[#Skinshops+1] = { -417.98,4372.91,61.35,184.26 } -- mansao94
	Skinshops[#Skinshops+1] = { 2023.49,-1600.29,258.50,347.38 } -- mansao101
	-- Skinshops[#Skinshops+1] = { -3215.31,5.24,10.36,11.34 } -- Mansao254
	Skinshops[#Skinshops+1] = { -1729.43,374.72,89.72,230.96 } -- QG_154
	Skinshops[#Skinshops+1] = { 180.28,1715.41,231.16,344.05 } -- QG_161
	Skinshops[#Skinshops+1] = { -2086.45,-303.38,13.24,167.25 } -- QG_156
	Skinshops[#Skinshops+1] = { -523.98,514.28,108.08,315.38 } -- QG_158
	Skinshops[#Skinshops+1] = { 1185.11,873.56,144.00,161.87 } -- QG_159
	Skinshops[#Skinshops+1] = { -1368.02,-613.34,30.32,34.56 } -- QG_148
	Skinshops[#Skinshops+1] = { 958.86,-966.6,42.95,348.67 } -- mecanica
	Skinshops[#Skinshops+1] = { 1087.36,-922.42,51.27,175.24 } -- Bombeiros
	Skinshops[#Skinshops+1] = { 1150.65,-1583.05,35.28,138.9 } -- hp
	Skinshops[#Skinshops+1] = { 458.14,-999.19,30.68,331.66 } -- Militar
	Skinshops[#Skinshops+1] = { -437.84,6012.35,36.99,357.17 } -- civil
	Skinshops[#Skinshops+1] = { -780.21,-1211.9,10.38,141.74 } -- Tatica
	Skinshops[#Skinshops+1] = { -1887.58,3026.39,32.96,328.82 } -- Exercito
	Skinshops[#Skinshops+1] = { 1075.28,3273.75,41.11,198.43 } -- umbrella
	Skinshops[#Skinshops+1] = { 875.42,1860.9,142.5,226.78 } -- Metgala
	Skinshops[#Skinshops+1] = { -2197.05,-275.16,35.79,257.96 } -- Gang4
	Skinshops[#Skinshops+1] = { -458.91,-1264.9,25.48,51.03 } -- Afetados
	Skinshops[#Skinshops+1] = { 413.04,6468.02,29.82,274.97 } -- Pinkmans
	Skinshops[#Skinshops+1] = { 1513.4,1356.95,108.29,286.3 } -- Gang9
	Skinshops[#Skinshops+1] = { 957.6,-2390.99,22.33,175.75 } -- China
	Skinshops[#Skinshops+1] = { 3047.53,-4136.9,9.86,351.5 }
	-- Skinshops[#Skinshops+1] = { 1030.2,-2550.23,32.28,85.04 } -- Vermelhos
	Skinshops[#Skinshops+1] = { 1797.05,441.96,172.34,59.53 } -- Azul
	Skinshops[#Skinshops+1] = { 2133.61,-15.7,227.22,45.36 } -- Rosa
	Skinshops[#Skinshops+1] = { 2742.43,2716.88,55.84,48.19 } -- Sindicato
	-- Skinshops[#Skinshops+1] = { -139.96,-1609.06,35.03,68.04 } -- Groove
	-- Skinshops[#Skinshops+1] = { 2115.64,3886.09,33.23,215.44 } -- Roxos
	Skinshops[#Skinshops+1] = { 514.2,370.01,151.73,104.89 } -- Roxos
	Skinshops[#Skinshops+1] = { 358.11,-2033.39,22.39,48.19 } -- Vagos
	Skinshops[#Skinshops+1] = { 117.31,-1962.14,21.33,201.26 } -- Ballas
	Skinshops[#Skinshops+1] = { 755.82,-203.84,70.63,289.14 } -- QG_34
	Skinshops[#Skinshops+1] = { 755.7,-203.72,70.63,280.63 } -- QG_113
	Skinshops[#Skinshops+1] = { 1221.1,-1858.54,45.71,289.14 } -- QG_116
	Skinshops[#Skinshops+1] = { 1330.04,-707.86,67.28,116.23 } -- QG_117
	Skinshops[#Skinshops+1] = { -2189.20,4283.77,49.18,196.14 } -- QG_144
	-- Skinshops[#Skinshops+1] = {  103.51,3613.09,40.49,175.75 } -- Laranja
	Skinshops[#Skinshops+1] = { 291.24,216.89,78.82,277.8 } -- Bahamas
	Skinshops[#Skinshops+1] = { 945.01,47.64,80.29,53.86 } -- Bellagio
	Skinshops[#Skinshops+1] = { -1540.36,321.5,87.25,73.71 } -- Lavajato
	Skinshops[#Skinshops+1] = { 102.53,-1311.89,21.13,31.19 } -- Putaria
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { -3320.91,548.73,13.77,303.31 } -- Arcade
	Skinshops[#Skinshops+1] = { 414.94,-23.43,91.93,56.7 } -- Callisto
	Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
	Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
	Skinshops[#Skinshops+1] = { -203.27,-1330.04,34.9,127.56 } -- Undergrounds
	Skinshops[#Skinshops+1] = { 1382.88,-2093.85,47.21,31.19 } -- fazer
	Skinshops[#Skinshops+1] = { 2361.62,5647.1,92.71,141.74 } -- Topgear
	Skinshops[#Skinshops+1] = { 1378.51,-2096.32,52.6,39.69  } -- FerroVelho
	Skinshops[#Skinshops+1] = { 2643.51,3636.15,106.73,39.69 } -- Morro-do-Sacola
	Skinshops[#Skinshops+1] = { 883.73,-2100.55,30.46,175.75 } -- CarClube
	Skinshops[#Skinshops+1] = { -337.81,-166.57,44.58,272.13 } -- Virtude
	Skinshops[#Skinshops+1] = { 134.68,-369.75,50.33,17.01 } -- Big
	Skinshops[#Skinshops+1] = { 2742.47,3500.22,61.3,357.17} -- Kraken
	Skinshops[#Skinshops+1] = { -1149.56,-1554.59,7.63,153.08 } -- bandoleros
	Skinshops[#Skinshops+1] = { 556.33,-2773.46,6.08,59.53 } -- Gang5
	Skinshops[#Skinshops+1] = { 99.06,1229.61,207.17,345.83 } -- Mayans
	Skinshops[#Skinshops+1] = { 1028.6,-2550.72,32.28,351.5 } -- soa
	Skinshops[#Skinshops+1] = { 1026.51,-2542.27,28.29,170.08 } -- hellsangels
	Skinshops[#Skinshops+1] = { 3234.18,5120.17,20.15,116.23 }
	Skinshops[#Skinshops+1] = { 2312.64,5568.36,51.91,343.0 } -- sinaloa
	Skinshops[#Skinshops+1] = { -60.09,994.66,239.52,328.82 } -- gringa
	Skinshops[#Skinshops+1] = { -1539.52,141.51,55.65,51.03 } -- bloods
	-- Skinshops[#Skinshops+1] = { -2804.84,2261.69,24.11,320.32 } -- bloods secundario
	Skinshops[#Skinshops+1] = { -3025.46,59.49,11.95,331.66 } -- crips
	Skinshops[#Skinshops+1] = { -339.2,-1523.7,29.34,22.68 } -- warlocks
	Skinshops[#Skinshops+1] = { -1814.54,447.96,127.91,351.5 } -- mexicana
	Skinshops[#Skinshops+1] = { -1887.16,2070.1,145.57,334.49 } -- russa
	Skinshops[#Skinshops+1] = { -1491.07,845.77,181.59,87.88 } -- irlandesa
	Skinshops[#Skinshops+1] = { 173.45,668.33,207.66,104.89 } -- triade
	Skinshops[#Skinshops+1] = { 420.53,-1483.85,33.8,116.23 } -- italiana
	Skinshops[#Skinshops+1] = { 2332.3,5524.54,51.68,249.45 } -- overdrive
	Skinshops[#Skinshops+1] = { -776.37,-2593.33,17.66,238.12 } -- Outlaws 
	Skinshops[#Skinshops+1] = { -617.15,-1617.33,33.01,172.92 } -- Topgear 
	Skinshops[#Skinshops+1] = { -290.78,1986.24,166.14,334.49 } -- israel
	-- Skinshops[#Skinshops+1] = { 1078.37,-1973.3,31.48,235.28 } -- gringa
	Skinshops[#Skinshops+1] = { 1252.95,-1720.72,56.45,65.2 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1289.66,-1762.54,54.21,22.68 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1338.0,-792.43,71.51,343.0 } -- brancos
	Skinshops[#Skinshops+1] = { 1346.33,-705.11,67.74,73.71 } -- brancos
	Skinshops[#Skinshops+1] = { 1267.24,-299.03,84.59,158.75 } -- barragem
	Skinshops[#Skinshops+1] = { 1251.62,-265.92,77.91,107.72 } -- barragem
	Skinshops[#Skinshops+1] = { 1506.8,-2368.57,78.03,274.97 } -- rosas
	Skinshops[#Skinshops+1] = { 1512.78,-2365.16,78.03,195.6 } -- rosas
	-- Skinshops[#Skinshops+1] = { 2225.07,3452.81,61.33,172.92 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2229.55,3452.95,61.33,170.08 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2226.14,3453.91,61.33,187.09 } -- cinzas
	Skinshops[#Skinshops+1] = { 103.67,1221.91,207.17,102.05 } -- SOA
	Skinshops[#Skinshops+1] = { 1306.65,-735.32,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -215.34,-1334.28,34.9,266.46 } -- bennys
	Skinshops[#Skinshops+1] = { 1048.13,888.82,220.34,48.19 } -- playboy
	Skinshops[#Skinshops+1] = { 1341.91,-790.49,71.51,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { 1336.42,-788.7,71.51,348.67 } -- brancos
	Skinshops[#Skinshops+1] = { 1308.3,-733.85,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -1550.84,-393.9,41.97,51.03 } -- 
	Skinshops[#Skinshops+1] = { -3337.8,543.54,17.44,215.44 } -- mansao 60
	Skinshops[#Skinshops+1] = { 1963.43,6415.17,61.7,311.82 } -- marrons
	Skinshops[#Skinshops+1] = { -2272.06,323.23,174.6,22.68 }
	Skinshops[#Skinshops+1] = { -1687.17,-3185.18,14.0,243.78 }
	Skinshops[#Skinshops+1] = { 1402.74,1154.66,114.33,266.46 } -- fazendinha
	Skinshops[#Skinshops+1] = { 747.78,-308.18,59.8,306.15 } -- Campinho
	Skinshops[#Skinshops+1] = { 905.89,339.35,112.29,345.83 } -- Japao
	Skinshops[#Skinshops+1] = { -1044.65,305.04,71.66,266.46 } -- Inglaterra
	Skinshops[#Skinshops+1] = { -2022.42,4435.69,53.09,345.83 } -- Banzas
	Skinshops[#Skinshops+1] = { 355.76,-2729.82,1.72,257.96 } -- Dixavas
	Skinshops[#Skinshops+1] = { -769.38,8.1,40.64,345.83 } 
	Skinshops[#Skinshops+1] = { 1471.81,6539.39,18.64,85.04 } -- pier norte
	Skinshops[#Skinshops+1] = { -602.0,-914.22,23.88,184.26 } -- Anonymous
	Skinshops[#Skinshops+1] = { -602.7,-923.49,17.59,328.82 } -- Anonymous
	Skinshops[#Skinshops+1] = { -2813.9,2266.37,24.33,354.34 } -- qg 71
	Skinshops[#Skinshops+1] = { 676.42,909.22,247.57,170.08 } -- Inglaterra
	Skinshops[#Skinshops+1] = { 5026.55,-5760.97,15.77,232.45 } -- Caribe
	Skinshops[#Skinshops+1] = { 2612.27,5333.94,47.57,59.53 } -- prf
	Skinshops[#Skinshops+1] = { 3088.32,5091.99,23.25,73.71 } -- qg_80
	Skinshops[#Skinshops+1] = { -156.96,8259.62,12.82,11.34 } -- iate
	Skinshops[#Skinshops+1] = { -1784.4,-1376.75,11.88,39.69 } -- iate
	Skinshops[#Skinshops+1] = { -1883.34,-1164.43,11.73,320.32 } -- iate
	Skinshops[#Skinshops+1] = { -2210.16,-586.48,11.73,232.45 } 
	Skinshops[#Skinshops+1] = { -1179.62,302.46,73.67,102.05 } -- qg_82
	Skinshops[#Skinshops+1] = { -1226.24,-1737.73,4.53,138.9 } -- qg_83
	Skinshops[#Skinshops+1] = { -2423.52,1790.06,185.48,39.69 } -- qg_84
	Skinshops[#Skinshops+1] = { -878.0,-1434.81,7.53,201.26 } -- qg_85
	Skinshops[#Skinshops+1] = { -539.93,5002.83,159.92,272.13 } -- qg_86
	Skinshops[#Skinshops+1] = { -2675.14,1307.61,152.0,272.13 } -- qg_87
	Skinshops[#Skinshops+1] = { -2277.87,336.33,178.57,300.48 } -- qg_88
	Skinshops[#Skinshops+1] = { 3482.3,5015.04,11.91,212.6 }
	Skinshops[#Skinshops+1] = { -4504.72,-70.94,12.81,164.41 }
	Skinshops[#Skinshops+1] = { 994.15,3403.17,61.97,280.63 } -- QG_31
	Skinshops[#Skinshops+1] = { 89.54,-1966.65,20.74,320.32 } -- QG_43
	Skinshops[#Skinshops+1] = { 2456.34,4980.02,46.83,158.75 } -- QG_64
	Skinshops[#Skinshops+1] = { -2813.7,2266.54,24.31,343.0 } -- QG_124
	Skinshops[#Skinshops+1] = { 866.7,1872.27,144.52,138.9 } -- QG_126
	Skinshops[#Skinshops+1] = { 1378.59,-2096.53,52.6,306.15 } -- QG_68
	Skinshops[#Skinshops+1] = { -669.18,6391.58,13.02,133.53 } -- QG_128
	Skinshops[#Skinshops+1] = { -2598.64,1889.43,163.75,323.7 } -- QG_129
	Skinshops[#Skinshops+1] = { 2022.46,3373.80,46.60,80.00 } -- QG_130
	Skinshops[#Skinshops+1] = { -290.69,217.56,78.83,301.80 } -- QG_409
	Skinshops[#Skinshops+1] = { -3204.3,-53.85,11.07,354.34 } -- Iate04
	Skinshops[#Skinshops+1] = { -3239.28,15.13,10.4,22.68 } -- Mansao269
	Skinshops[#Skinshops+1] = { -1136.33,-2076.44,21.28,223.94 } -- mecanica

elseif cityName == "Universo" then
	Skinshops[#Skinshops+1] = { -3068.65,3456.45,10.03,255.12 } -- mansao93
	Skinshops[#Skinshops+1] = { -554.14,1192.33,334.08,280.63 } -- AlphaA1
	Skinshops[#Skinshops+1] = { -575.98,1193.24,334.08,184.26 } -- AlphaA2
	Skinshops[#Skinshops+1] = { -604.07,1192.34,334.08,269.3 } -- AlphaA3
	Skinshops[#Skinshops+1] = { -628.87,1192.29,334.08,283.47 } -- AlphaA4
	Skinshops[#Skinshops+1] = { -543.57,1251.58,334.08,85.04 } -- AlphaB1
	Skinshops[#Skinshops+1] = { -568.49,1251.75,334.08,110.56 } -- AlphaB2
	Skinshops[#Skinshops+1] = { -593.38,1251.64,334.08,102.05 } -- AlphaB3
	Skinshops[#Skinshops+1] = { -618.02,1251.67,334.08,87.88 } -- AlphaB4
	Skinshops[#Skinshops+1] = { -417.98,4372.91,61.35,184.26 } -- mansao94
	Skinshops[#Skinshops+1] = { -1514.82,-1468.04,6.39,206.93 } -- Atlantis
	Skinshops[#Skinshops+1] = { -650.83,6381.89,17.03,134.78 } -- QG_261
	Skinshops[#Skinshops+1] = { -3314.39,-1053.86,9.42,200.48 } -- mansao30
	Skinshops[#Skinshops+1] = { 791.97,5736.84,702.57,76.54 } -- mansao90
	Skinshops[#Skinshops+1] = { 2023.49,-1600.29,258.50,347.38 } -- mansao101
	Skinshops[#Skinshops+1] = { 101.14,-1311.09,21.14,331.55 } -- mansao94
	Skinshops[#Skinshops+1] = { 2651.69,1800.31,33.38,189.93 } -- QG_172
	Skinshops[#Skinshops+1] = { -877.91,-1435.03,7.53,27.00 } -- QG_196
	Skinshops[#Skinshops+1] = { 2317.67,4864.61,47.49,307.93 } -- mansao97
	Skinshops[#Skinshops+1] = { -1468.16,-45.54,58.67,134.27 } -- mansao23
	Skinshops[#Skinshops+1] = { 4883.73,-5665.22,80.79,108.60 } -- mansao96
	Skinshops[#Skinshops+1] = { 134.68,-369.75,50.33,17.01 } -- QG_134
	Skinshops[#Skinshops+1] = { -386.03,4385.87,61.36,271.47 } -- QG_164
	Skinshops[#Skinshops+1] = { 958.86,-966.6,42.95,348.67 } -- mecanica
	Skinshops[#Skinshops+1] = { -632.41,-134.04,43.22,93.55 } -- Bombeiros
	Skinshops[#Skinshops+1] = { -1691.65,-1137.11,14.01,316.04 } -- pier sul
	Skinshops[#Skinshops+1] = { -1698.16,-1126.31,14.01,230.06 } -- pier sul
	Skinshops[#Skinshops+1] = { -1695.06,-1122.87,14.01,223.58 } -- pier sul
	Skinshops[#Skinshops+1] = { -951.11,-2046.77,12.92,130.4 } -- dp
	Skinshops[#Skinshops+1] = { 832.49,-1291.80,19.85,178.48 } -- Tatica
	Skinshops[#Skinshops+1] = { 457.64,-990.77,30.68,11.34 } -- dp praça
	Skinshops[#Skinshops+1] = { 2612.27,5333.94,47.57,59.53 } -- prf
	Skinshops[#Skinshops+1] = { 1150.65,-1583.05,35.28,138.9 } -- hp
	Skinshops[#Skinshops+1] = { 2516.96,-345.11,101.89,42.52 } -- Militar
	Skinshops[#Skinshops+1] = { -437.84,6012.35,36.99,357.17 } -- civil
	Skinshops[#Skinshops+1] = { -780.21,-1211.9,10.38,141.74 } -- Federal
	Skinshops[#Skinshops+1] = { -1887.58,3026.39,32.96,328.82 } -- Exercito
	Skinshops[#Skinshops+1] = { 1075.28,3273.75,41.11,198.43 } -- umbrella
	Skinshops[#Skinshops+1] = { 875.42,1860.9,142.5,226.78 } -- Metgala
	Skinshops[#Skinshops+1] = { -2305.71,-251.61,48.14,127.56 } -- Gang4
	Skinshops[#Skinshops+1] = { -458.91,-1264.9,25.48,51.03 } -- Afetados
	Skinshops[#Skinshops+1] = { 413.04,6468.02,29.82,274.97 } -- Pinkmans
	Skinshops[#Skinshops+1] = { 1513.4,1356.95,108.29,286.3 } -- Gang9
	Skinshops[#Skinshops+1] = { 957.6,-2390.99,22.33,175.75 } -- China
	-- Skinshops[#Skinshops+1] = { 1030.2,-2550.23,32.28,85.04 } -- Vermelhos
	Skinshops[#Skinshops+1] = { 1797.05,441.96,172.34,59.53 } -- Azul
	Skinshops[#Skinshops+1] = { 2133.61,-15.7,227.22,45.36 } -- Rosa
	Skinshops[#Skinshops+1] = { 2742.43,2716.88,55.84,48.19 } -- Sindicato
	-- Skinshops[#Skinshops+1] = { -139.96,-1609.06,35.03,68.04 } -- Groove
	Skinshops[#Skinshops+1] = { 2115.64,3886.09,33.23,215.44 } -- Roxos
	Skinshops[#Skinshops+1] = { 514.2,370.01,151.73,104.89 } -- Roxos
	Skinshops[#Skinshops+1] = { 358.11,-2033.39,22.39,48.19 } -- Vagos
	Skinshops[#Skinshops+1] = { 117.31,-1962.14,21.33,201.26 } -- Ballas
	-- Skinshops[#Skinshops+1] = {  103.51,3613.09,40.49,175.75 } -- Laranja
	Skinshops[#Skinshops+1] = { 291.24,216.89,78.82,277.8 } -- Bahamas
	Skinshops[#Skinshops+1] = { 945.01,47.64,80.29,53.86 } -- Bellagio
	Skinshops[#Skinshops+1] = { -1540.36,321.5,87.25,73.71 } -- Lavajato
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { 736.58,-806.95,16.28,357.17 } -- Arcade
	Skinshops[#Skinshops+1] = { 414.94,-23.43,91.93,56.7 } -- Callisto
	Skinshops[#Skinshops+1] = { -599.26,-914.01,23.88,87.88 } -- Redline
	Skinshops[#Skinshops+1] = { -203.27,-1330.04,34.9,127.56 } -- Undergrounds
	Skinshops[#Skinshops+1] = { 1382.88,-2093.85,47.21,31.19 } -- fazer
	Skinshops[#Skinshops+1] = { 2361.62,5647.1,92.71,141.74 } -- Topgear
	Skinshops[#Skinshops+1] = { 883.73,-2100.55,30.46,175.75 } -- CarClube
	Skinshops[#Skinshops+1] = { -337.81,-166.57,44.58,272.13 } -- Virtude
	Skinshops[#Skinshops+1] = { 134.68,-369.75,50.33,17.01 } -- Big
	Skinshops[#Skinshops+1] = { 2742.47,3500.22,61.3,357.17} -- Kraken
	Skinshops[#Skinshops+1] = { -1149.56,-1554.59,7.63,153.08 } -- bandoleros
	Skinshops[#Skinshops+1] = { 556.33,-2773.46,6.08,59.53 } -- Gang5
	Skinshops[#Skinshops+1] = { 99.06,1229.61,207.17,345.83 } -- Mayans
	Skinshops[#Skinshops+1] = { 1028.6,-2550.72,32.28,351.5 } -- soa
	Skinshops[#Skinshops+1] = { 1026.51,-2542.27,28.29,170.08 } -- hellsangels
	Skinshops[#Skinshops+1] = { 3234.18,5120.17,20.15,116.23 }
	Skinshops[#Skinshops+1] = { 2312.64,5568.36,51.91,343.0 } -- sinaloa
	Skinshops[#Skinshops+1] = { -60.09,994.66,239.52,328.82 } -- gringa
	Skinshops[#Skinshops+1] = { -1539.52,141.51,55.65,51.03 } -- bloods
	-- Skinshops[#Skinshops+1] = { -2804.84,2261.69,24.11,320.32 } -- bloods secundario
	Skinshops[#Skinshops+1] = { -3025.46,59.49,11.95,331.66 } -- crips
	Skinshops[#Skinshops+1] = { -339.2,-1523.7,29.34,22.68 } -- warlocks
	Skinshops[#Skinshops+1] = { -1814.54,447.96,127.91,351.5 } -- mexicana
	Skinshops[#Skinshops+1] = { -1887.16,2070.1,145.57,334.49 } -- russa
	Skinshops[#Skinshops+1] = { -1491.07,845.77,181.59,87.88 } -- irlandesa
	Skinshops[#Skinshops+1] = { 173.45,668.33,207.66,104.89 } -- triade
	Skinshops[#Skinshops+1] = { 420.53,-1483.85,33.8,116.23 } -- italiana
	Skinshops[#Skinshops+1] = { 2332.3,5524.54,51.68,249.45 } -- overdrive
	Skinshops[#Skinshops+1] = { -776.37,-2593.33,17.66,238.12 } -- Outlaws 
	Skinshops[#Skinshops+1] = { -617.15,-1617.33,33.01,172.92 } -- Topgear 
	Skinshops[#Skinshops+1] = { -290.78,1986.24,166.14,334.49 } -- israel
	-- Skinshops[#Skinshops+1] = { 1078.37,-1973.3,31.48,235.28 } -- gringa
	Skinshops[#Skinshops+1] = { -303.2,220.21,77.91,257.96 } -- luxor
	Skinshops[#Skinshops+1] = { 1252.95,-1720.72,56.45,65.2 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1289.66,-1762.54,54.21,22.68 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1338.0,-792.43,71.51,343.0 } -- brancos
	Skinshops[#Skinshops+1] = { 1346.33,-705.11,67.74,73.71 } -- brancos
	Skinshops[#Skinshops+1] = { 1267.24,-299.03,84.59,158.75 } -- barragem
	Skinshops[#Skinshops+1] = { 1251.62,-265.92,77.91,107.72 } -- barragem
	Skinshops[#Skinshops+1] = { 1506.8,-2368.57,78.03,274.97 } -- rosas
	Skinshops[#Skinshops+1] = { 1512.78,-2365.16,78.03,195.6 } -- rosas
	-- Skinshops[#Skinshops+1] = { 2225.07,3452.81,61.33,172.92 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2229.55,3452.95,61.33,170.08 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2226.14,3453.91,61.33,187.09 } -- cinzas
	Skinshops[#Skinshops+1] = { 103.67,1221.91,207.17,102.05 } -- SOA
	Skinshops[#Skinshops+1] = { 1306.65,-735.32,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -215.34,-1334.28,34.9,266.46 } -- bennys
	Skinshops[#Skinshops+1] = { 1048.13,888.82,220.34,48.19 } -- playboy
	Skinshops[#Skinshops+1] = { 1341.91,-790.49,71.51,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { 1336.42,-788.7,71.51,348.67 } -- brancos
	Skinshops[#Skinshops+1] = { 1308.3,-733.85,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -1550.84,-393.9,41.97,51.03 } -- 
	Skinshops[#Skinshops+1] = { -3337.8,543.54,17.44,215.44 } -- mansao 60
	Skinshops[#Skinshops+1] = { 1963.43,6415.17,61.7,311.82 } -- marrons
	Skinshops[#Skinshops+1] = { -2272.06,323.23,174.6,22.68 }
	Skinshops[#Skinshops+1] = { -1687.17,-3185.18,14.0,243.78 }
	Skinshops[#Skinshops+1] = { 1402.74,1154.66,114.33,266.46 } -- fazendinha
	Skinshops[#Skinshops+1] = { 747.78,-308.18,59.8,306.15 } -- Campinho
	Skinshops[#Skinshops+1] = { 886.42,352.9,112.56,226.78 } -- qg_17
	Skinshops[#Skinshops+1] = { -1044.65,305.04,71.66,266.46 } -- Inglaterra
	Skinshops[#Skinshops+1] = { -2022.42,4435.69,53.09,345.83 } -- Banzas
	Skinshops[#Skinshops+1] = { 355.76,-2729.82,1.72,257.96 } -- Dixavas
	Skinshops[#Skinshops+1] = { -769.38,8.1,40.64,345.83 } 
	Skinshops[#Skinshops+1] = { 1471.81,6539.39,18.64,85.04 } -- pier norte
	Skinshops[#Skinshops+1] = { -457.41,1545.76,393.22,147.41 } -- medelin
	Skinshops[#Skinshops+1] = { -2806.25,2267.16,24.08,314.65 } -- Noxus
	Skinshops[#Skinshops+1] = { 1836.37,2573.52,46.02,357.17 } -- Policia
	Skinshops[#Skinshops+1] = { 5026.55,-5760.97,15.77,232.45 } -- Caribe
	Skinshops[#Skinshops+1] = { 3088.32,5091.99,23.25,73.71 } -- qg_80
	Skinshops[#Skinshops+1] = { -1179.62,302.46,73.67,102.05 } -- qg_82
	Skinshops[#Skinshops+1] = { -1226.24,-1737.73,4.53,138.9 } -- qg_83
	Skinshops[#Skinshops+1] = { -2423.52,1790.06,185.48,39.69 } -- qg_84
	Skinshops[#Skinshops+1] = { -878.0,-1434.81,7.53,201.26 } -- qg_85
	Skinshops[#Skinshops+1] = { 2505.72,3590.05,98.5,127.56 } -- qg_104
	Skinshops[#Skinshops+1] = { 129.79,-99.03,49.57,161.58 } -- QG_106
	Skinshops[#Skinshops+1] = { -770.97,-1318.31,9.60,225.74 } -- Federal

elseif cityName == "Grande" then
	Skinshops[#Skinshops+1] = { -2566.45,-2204.01,5.05,161.58 } -- Resort
	Skinshops[#Skinshops+1] = { 676.73,909.14,247.57,164.41 } -- QG_302
	Skinshops[#Skinshops+1] = { 688.13,914.25,247.57,107.72 } -- QG_302
	Skinshops[#Skinshops+1] = { -3068.65,3456.45,10.03,255.12 } -- mansao93
	Skinshops[#Skinshops+1] = { 3192.85,2038.79,16.24,215.44 } -- mansao195
	Skinshops[#Skinshops+1] = { 3202.37,2039.41,21.05,297.64 } -- mansao195
	Skinshops[#Skinshops+1] = { 3195.34,2018.15,21.06,317.49 } -- mansao195
	Skinshops[#Skinshops+1] = { 3199.38,2029.75,25.81,2.84 } -- mansao195
	Skinshops[#Skinshops+1] = { 3196.79,2018.23,25.81,328.82 } -- mansao195
	Skinshops[#Skinshops+1] = { 2671.31,-420.36,120.43,141.74 } -- Mansao212
	Skinshops[#Skinshops+1] = { 2681.13,-439.71,120.43,204.1 } -- Mansao212
	Skinshops[#Skinshops+1] = { 2669.28,-431.14,115.03,8.51 } -- Mansao212
	Skinshops[#Skinshops+1] = { 927.24,-2526.84,83.1,184.26 } -- Mansao213
	Skinshops[#Skinshops+1] = { 989.82,-2389.7,20.41,28.35 } -- BoateMetralha
	Skinshops[#Skinshops+1] = { 3429.5,4929.75,39.85,48.19 } -- Mansao228
	Skinshops[#Skinshops+1] = { 3458.75,4916.29,39.85,235.28 } -- Mansao228
	Skinshops[#Skinshops+1] = { 3451.64,4908.86,39.85,229.61 } -- Mansao228
	Skinshops[#Skinshops+1] = { -1915.08,-54.09,135.24,297.64 } -- Mansao274
	Skinshops[#Skinshops+1] = { -652.36,6380.13,17.02,133.23 } -- Mansao91
	Skinshops[#Skinshops+1] = { 557.16,-192.72,54.53,357.17 } -- mecanica
	Skinshops[#Skinshops+1] = { -307.7,-590.09,32.77,104.89 } -- paramedic
	-- Skinshops[#Skinshops+1] = { -817.45,267.30,82.80,72.27 }  -- mansao03
	Skinshops[#Skinshops+1] = { -1141.69,374.45,74.97,229.10 } -- mansao24
	Skinshops[#Skinshops+1] = { 1834.41,2571.42,46.01,336.15 } -- PoliciaPrisional
	Skinshops[#Skinshops+1] = { -3662.83,3905.37,14.83,87.88 } -- QG_289
	Skinshops[#Skinshops+1] = { 795.41,3426.52,62.71,257.96 } -- QG_287
	Skinshops[#Skinshops+1] = { -1048.78,2790.62,27.20,105.51 } -- QG_99
	Skinshops[#Skinshops+1] = { -1236.58,795.1,197.19,198.43 } -- QG_271
	Skinshops[#Skinshops+1] = { -1530.12,821.28,184.92,8.69 } -- QG_53
	Skinshops[#Skinshops+1] = { -554.14,1192.33,334.08,280.63 } -- AlphaA1
	Skinshops[#Skinshops+1] = { -575.98,1193.24,334.08,184.26 } -- AlphaA2
	Skinshops[#Skinshops+1] = { -604.07,1192.34,334.08,269.3 } -- AlphaA3
	Skinshops[#Skinshops+1] = { -628.87,1192.29,334.08,283.47 } -- AlphaA4
	Skinshops[#Skinshops+1] = { -543.57,1251.58,334.08,85.04 } -- AlphaB1
	Skinshops[#Skinshops+1] = { -568.49,1251.75,334.08,110.56 } -- AlphaB2
	Skinshops[#Skinshops+1] = { -593.38,1251.64,334.08,102.05 } -- AlphaB3
	Skinshops[#Skinshops+1] = { -618.02,1251.67,334.08,87.88 } -- AlphaB4
	Skinshops[#Skinshops+1] = { 846.85,1424.23,345.79,172.92 } -- Alpha4B1
	Skinshops[#Skinshops+1] = { 847.76,1427.29,345.79,90.71 } -- Alpha4B1
	Skinshops[#Skinshops+1] = { 837.57,1416.94,354.05,2.84 } -- Alpha4B1
	Skinshops[#Skinshops+1] = { 846.98,1478.22,345.79,189.93 } -- Alpha4B2
	Skinshops[#Skinshops+1] = { 847.72,1481.46,345.79,104.89 } -- Alpha4B2
	Skinshops[#Skinshops+1] = { 837.42,1471.23,354.05,354.34 } -- Alpha4B2
	Skinshops[#Skinshops+1] = { 846.85,1532.34,345.79,175.75 } -- Alpha4B3
	Skinshops[#Skinshops+1] = { 847.71,1535.31,345.79,93.55 } -- Alpha4B3
	Skinshops[#Skinshops+1] = { 837.62,1525.15,354.05,0.0 } -- Alpha4B3
	Skinshops[#Skinshops+1] = { 758.11,1564.98,345.79,354.34 } -- Alpha4B4
	Skinshops[#Skinshops+1] = { 757.01,1561.61,345.79,274.97 } -- Alpha4B4
	Skinshops[#Skinshops+1] = { 754.28,1558.57,345.79,0.0 } -- Alpha4B4
	Skinshops[#Skinshops+1] = { 757.86,1510.63,345.79,0.0 } -- Alpha4B5
	Skinshops[#Skinshops+1] = { 757.05,1507.71,345.79,266.46 } -- Alpha4B5
	Skinshops[#Skinshops+1] = { 767.24,1517.82,354.05,187.09 } -- Alpha4B5
	Skinshops[#Skinshops+1] = { 757.63,1456.67,345.79,5.67 } -- Alpha4B6
	Skinshops[#Skinshops+1] = { 757.02,1453.56,345.79,266.46 } -- Alpha4B6
	Skinshops[#Skinshops+1] = { 766.82,1464.02,354.05,184.26 } -- Alpha4B6
	Skinshops[#Skinshops+1] = { -2349.97,3266.35,32.81,154.02 }
	-- Skinshops[#Skinshops+1] = { -1914.03,-53.82,135.69,22.68 } -- mansao154
	Skinshops[#Skinshops+1] = { -3164.47,2336.05,14.2,8.51 } -- QG_264
	Skinshops[#Skinshops+1] = { 2649.51,1799.6,33.38,90.71 } -- Mansao35
	Skinshops[#Skinshops+1] = { -1514.82,-1468.04,6.39,206.93 } -- Atlantis
	Skinshops[#Skinshops+1] = { -3101.94,1519.96,37.67,59.94 } -- QG_257
	Skinshops[#Skinshops+1] = { -1695.24,-1130.01,14.0,147.41 }
	Skinshops[#Skinshops+1] = { -1699.29,-1126.98,14.0,226.78 }
	Skinshops[#Skinshops+1] = { -3803.9,288.08,158.81,175.75 } -- QG_173
	-- Skinshops[#Skinshops+1] = { 676.35,909.26,247.58,6.31 } -- mansao61
	Skinshops[#Skinshops+1] = { 2026.2,4290.16,43.25,17.01 } -- QG_180
	Skinshops[#Skinshops+1] = { 1678.57,7055.46,11.77,141.25 }
	Skinshops[#Skinshops+1] = { 1584.97,4087.41,43.06,198.55 } -- QG_165
	Skinshops[#Skinshops+1] = { 136.79,-346.87,50.33,158.75 } -- QG_168
	Skinshops[#Skinshops+1] = { -404.72,4373.04,62.82,354.34 } -- mansao94
	Skinshops[#Skinshops+1] = { -142.82,6494.48,38.84,39.69 } -- mansao102
	-- Skinshops[#Skinshops+1] = { 2023.49,-1600.29,258.50,347.38 } -- mansao101
	Skinshops[#Skinshops+1] = { 368.92,2384.33,80.24,137.06 } -- mansao49
	Skinshops[#Skinshops+1] = { -126.17,6619.03,33.85,311.82 } -- mansao51
	Skinshops[#Skinshops+1] = { -1474.76,-1759.03,14.35,3.21 } -- mansao70
	Skinshops[#Skinshops+1] = { -2766.96,-941.86,16.05,64.63 } -- mansao71
	Skinshops[#Skinshops+1] = { -1417.25,-617.80,30.72,36.73 } -- MajorBahamas
	Skinshops[#Skinshops+1] = { -3090.98,3367.52,17.32,180.20 } -- mansao66
	Skinshops[#Skinshops+1] = { -3536.63,4623.20,6.72,287.43 } -- mansao96
	Skinshops[#Skinshops+1] = { 1036.84,3678.09,39.05,179.56 } -- mansao16
	Skinshops[#Skinshops+1] = { 2006.75,3354.94,51.60,83.44 } -- QG_150
	Skinshops[#Skinshops+1] = { 102.37,-1311.13,21.13,48.19 } -- QG_143
	Skinshops[#Skinshops+1] = { -2189.20,4283.77,49.18,196.14 } -- QG_132
	Skinshops[#Skinshops+1] = { 958.86,-966.6,42.95,348.67 } -- mecanica
	Skinshops[#Skinshops+1] = { -527.39,-186.79,42.84,187.09 } -- juridico
	Skinshops[#Skinshops+1] = { -632.41,-134.04,43.22,93.55 } -- Bombeiros
	Skinshops[#Skinshops+1] = { 1150.65,-1583.05,35.28,138.9 } -- hp
	Skinshops[#Skinshops+1] = { 457.64,-990.77,30.68,11.34 } -- dp praça
	Skinshops[#Skinshops+1] = { 2516.96,-345.11,101.89,42.52 } -- Militar
	Skinshops[#Skinshops+1] = { -437.84,6012.35,36.99,357.17 } -- civil
	Skinshops[#Skinshops+1] = { -780.21,-1211.9,10.38,141.74 } -- Tatica
	Skinshops[#Skinshops+1] = { -1887.58,3026.39,32.96,328.82 } -- Exercito
	Skinshops[#Skinshops+1] = { 1075.28,3273.75,41.11,198.43 } -- umbrella
	Skinshops[#Skinshops+1] = { 875.42,1860.9,142.5,226.78 } -- Metgala
	Skinshops[#Skinshops+1] = { -2197.05,-275.16,35.79,257.96 } -- Gang4
	Skinshops[#Skinshops+1] = { -458.91,-1264.9,25.48,51.03 } -- Afetados
	Skinshops[#Skinshops+1] = { 413.04,6468.02,29.82,274.97 } -- Pinkmans
	Skinshops[#Skinshops+1] = { 1513.4,1356.95,108.29,286.3 } -- Gang9
	Skinshops[#Skinshops+1] = { 957.6,-2390.99,22.33,175.75 } -- China
	Skinshops[#Skinshops+1] = { 790.13,5752.55,702.57,249.45 } -- Mansao95
	Skinshops[#Skinshops+1] = { -763.42,29.24,40.64,161.58 } -- Igreja
	Skinshops[#Skinshops+1] = { 3047.53,-4136.9,9.86,351.5 }
	Skinshops[#Skinshops+1] = { -2003.59,4494.14,57.29,320.32 }
	Skinshops[#Skinshops+1] = { -1628.7,-1100.71,13.09,229.61 }
	-- Skinshops[#Skinshops+1] = { 2029.85,4299.39,38.25,99.22 } -- QG_110
	-- Skinshops[#Skinshops+1] = { 1030.2,-2550.23,32.28,85.04 } -- Vermelhos
	Skinshops[#Skinshops+1] = { 1797.05,441.96,172.34,59.53 } -- Azul
	Skinshops[#Skinshops+1] = { 2133.61,-15.7,227.22,45.36 } -- Rosa
	Skinshops[#Skinshops+1] = { 2742.43,2716.88,55.84,48.19 } -- Sindicato
	-- Skinshops[#Skinshops+1] = { -139.96,-1609.06,35.03,68.04 } -- Groove
	Skinshops[#Skinshops+1] = { 2115.64,3886.09,33.23,215.44 } -- Roxos
	Skinshops[#Skinshops+1] = { 514.2,370.01,151.73,104.89 } -- Roxos
	Skinshops[#Skinshops+1] = { 358.11,-2033.39,22.39,48.19 } -- Vagos
	Skinshops[#Skinshops+1] = { 117.31,-1962.14,21.33,201.26 } -- Ballas
	-- Skinshops[#Skinshops+1] = {  103.51,3613.09,40.49,175.75 } -- Laranja
	Skinshops[#Skinshops+1] = { 291.24,216.89,78.82,277.8 } -- Bahamas
	Skinshops[#Skinshops+1] = { 945.01,47.64,80.29,53.86 } -- Bellagio
	Skinshops[#Skinshops+1] = { -1540.36,321.5,87.25,73.71 } -- Lavajato
	Skinshops[#Skinshops+1] = { 102.53,-1311.89,21.13,31.19 } -- Putaria
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { -3320.91,548.73,13.77,303.31 } -- Arcade
	Skinshops[#Skinshops+1] = { 414.94,-23.43,91.93,56.7 } -- Callisto
	Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
	Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
	Skinshops[#Skinshops+1] = { -203.27,-1330.04,34.9,127.56 } -- Undergrounds
	Skinshops[#Skinshops+1] = { 1382.88,-2093.85,47.21,31.19 } -- fazer
	Skinshops[#Skinshops+1] = { 2361.62,5647.1,92.71,141.74 } -- Topgear
	Skinshops[#Skinshops+1] = { 1378.51,-2096.32,52.6,39.69  } -- FerroVelho
	Skinshops[#Skinshops+1] = { 2643.51,3636.15,106.73,39.69 } -- Morro-do-Sacola
	Skinshops[#Skinshops+1] = { 883.73,-2100.55,30.46,175.75 } -- CarClube
	Skinshops[#Skinshops+1] = { -337.81,-166.57,44.58,272.13 } -- Virtude
	Skinshops[#Skinshops+1] = { 134.68,-369.75,50.33,17.01 } -- Big
	Skinshops[#Skinshops+1] = { 2742.47,3500.22,61.3,357.17} -- Kraken
	Skinshops[#Skinshops+1] = { -1149.56,-1554.59,7.63,153.08 } -- bandoleros
	Skinshops[#Skinshops+1] = { 556.33,-2773.46,6.08,59.53 } -- Gang5
	Skinshops[#Skinshops+1] = { 99.06,1229.61,207.17,345.83 } -- Mayans
	Skinshops[#Skinshops+1] = { 1028.6,-2550.72,32.28,351.5 } -- soa
	Skinshops[#Skinshops+1] = { 1026.51,-2542.27,28.29,170.08 } -- hellsangels
	Skinshops[#Skinshops+1] = { 3234.18,5120.17,20.15,116.23 }
	Skinshops[#Skinshops+1] = { 2312.64,5568.36,51.91,343.0 } -- sinaloa
	Skinshops[#Skinshops+1] = { -60.09,994.66,239.52,328.82 } -- gringa
	Skinshops[#Skinshops+1] = { -1539.52,141.51,55.65,51.03 } -- bloods
	-- Skinshops[#Skinshops+1] = { -2804.84,2261.69,24.11,320.32 } -- bloods secundario
	Skinshops[#Skinshops+1] = { -3025.46,59.49,11.95,331.66 } -- crips
	Skinshops[#Skinshops+1] = { -1814.54,447.96,127.91,351.5 } -- mexicana
	Skinshops[#Skinshops+1] = { -1887.16,2070.1,145.57,334.49 } -- russa
	Skinshops[#Skinshops+1] = { -1491.07,845.77,181.59,87.88 } -- irlandesa
	Skinshops[#Skinshops+1] = { 173.45,668.33,207.66,104.89 } -- triade
	Skinshops[#Skinshops+1] = { 420.53,-1483.85,33.8,116.23 } -- italiana
	Skinshops[#Skinshops+1] = { 2332.3,5524.54,51.68,249.45 } -- overdrive
	Skinshops[#Skinshops+1] = { -776.37,-2593.33,17.66,238.12 } -- Outlaws 
	Skinshops[#Skinshops+1] = { -617.15,-1617.33,33.01,172.92 } -- Topgear 
	Skinshops[#Skinshops+1] = { -290.78,1986.24,166.14,334.49 } -- israel
	-- Skinshops[#Skinshops+1] = { 1078.37,-1973.3,31.48,235.28 } -- gringa
	Skinshops[#Skinshops+1] = { -303.2,220.21,77.91,257.96 } -- luxor
	Skinshops[#Skinshops+1] = { 1252.95,-1720.72,56.45,65.2 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1289.66,-1762.54,54.21,22.68 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1338.0,-792.43,71.51,343.0 } -- brancos
	Skinshops[#Skinshops+1] = { 1346.33,-705.11,67.74,73.71 } -- brancos
	Skinshops[#Skinshops+1] = { 1267.24,-299.03,84.59,158.75 } -- barragem
	Skinshops[#Skinshops+1] = { 1251.62,-265.92,77.91,107.72 } -- barragem
	Skinshops[#Skinshops+1] = { 1506.8,-2368.57,78.03,274.97 } -- rosas
	Skinshops[#Skinshops+1] = { 1512.78,-2365.16,78.03,195.6 } -- rosas
	-- Skinshops[#Skinshops+1] = { 2225.07,3452.81,61.33,172.92 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2229.55,3452.95,61.33,170.08 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2226.14,3453.91,61.33,187.09 } -- cinzas
	Skinshops[#Skinshops+1] = { 103.67,1221.91,207.17,102.05 } -- SOA
	Skinshops[#Skinshops+1] = { 1306.65,-735.32,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -215.34,-1334.28,34.9,266.46 } -- bennys
	Skinshops[#Skinshops+1] = { 1048.13,888.82,220.34,48.19 } -- playboy
	Skinshops[#Skinshops+1] = { 1341.91,-790.49,71.51,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { 1336.42,-788.7,71.51,348.67 } -- brancos
	Skinshops[#Skinshops+1] = { 1308.3,-733.85,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -1550.84,-393.9,41.97,51.03 } -- 
	Skinshops[#Skinshops+1] = { -3337.8,543.54,17.44,215.44 } -- mansao 60
	Skinshops[#Skinshops+1] = { 1963.43,6415.17,61.7,311.82 } -- marrons
	Skinshops[#Skinshops+1] = { -2272.06,323.23,174.6,22.68 }
	Skinshops[#Skinshops+1] = { -1687.17,-3185.18,14.0,243.78 }
	Skinshops[#Skinshops+1] = { 747.78,-308.18,59.8,306.15 } -- Campinho
	-- Skinshops[#Skinshops+1] = { 905.89,339.35,112.29,345.83 } -- Japao
	Skinshops[#Skinshops+1] = { -1044.65,305.04,71.66,266.46 } -- Inglaterra
	Skinshops[#Skinshops+1] = { -2022.42,4435.69,53.09,345.83 } -- Banzas
	Skinshops[#Skinshops+1] = { 355.76,-2729.82,1.72,257.96 } -- Dixavas
	Skinshops[#Skinshops+1] = { -769.38,8.1,40.64,345.83 } 
	Skinshops[#Skinshops+1] = { 1471.81,6539.39,18.64,85.04 } -- pier norte
	Skinshops[#Skinshops+1] = { -602.0,-914.22,23.88,184.26 } -- Anonymous
	Skinshops[#Skinshops+1] = { -602.7,-923.49,17.59,328.82 } -- Anonymous
	Skinshops[#Skinshops+1] = { -2813.9,2266.37,24.33,354.34 } -- qg 71
	Skinshops[#Skinshops+1] = { 676.42,909.22,247.57,170.08 } -- Inglaterra
	Skinshops[#Skinshops+1] = { 5026.55,-5760.97,15.77,232.45 } -- Caribe
	Skinshops[#Skinshops+1] = { 2612.27,5333.94,47.57,59.53 } -- prf
	Skinshops[#Skinshops+1] = { 3088.32,5091.99,23.25,73.71 } -- qg_80
	Skinshops[#Skinshops+1] = { -156.96,8259.62,12.82,11.34 } -- iate
	Skinshops[#Skinshops+1] = { -1784.4,-1376.75,11.88,39.69 } -- iate
	Skinshops[#Skinshops+1] = { -1883.34,-1164.43,11.73,320.32 } -- iate
	Skinshops[#Skinshops+1] = { -2210.16,-586.48,11.73,232.45 } 
	Skinshops[#Skinshops+1] = { 866.58,1871.27,140.39,87.88 } -- QG_07
	Skinshops[#Skinshops+1] = { -1179.62,302.46,73.67,102.05 } -- qg_82
	Skinshops[#Skinshops+1] = { -1226.24,-1737.73,4.53,138.9 } -- QG_338
	Skinshops[#Skinshops+1] = { -2423.52,1790.06,185.48,39.69 } -- qg_84
	Skinshops[#Skinshops+1] = { -878.0,-1434.81,7.53,201.26 } -- qg_85
	Skinshops[#Skinshops+1] = { -539.93,5002.83,159.92,272.13 } -- qg_86
	Skinshops[#Skinshops+1] = { -2675.14,1307.61,152.0,272.13 } -- qg_87
	Skinshops[#Skinshops+1] = { -2277.87,336.33,178.57,300.48 } -- qg_88
	Skinshops[#Skinshops+1] = { 3482.3,5015.04,11.91,212.6 }
	Skinshops[#Skinshops+1] = { -4504.72,-70.94,12.81,164.41 }
	Skinshops[#Skinshops+1] = { 994.15,3403.17,61.97,280.63 } -- QG_31
	Skinshops[#Skinshops+1] = { 89.54,-1966.65,20.74,320.32 } -- QG_43
	Skinshops[#Skinshops+1] = { 2456.34,4980.02,46.83,158.75 } -- QG_64
	Skinshops[#Skinshops+1] = { -935.2,403.8,79.23,195.6 } -- QG_103
	Skinshops[#Skinshops+1] = { 129.79,-99.03,49.57,161.58 } -- QG_106
	Skinshops[#Skinshops+1] = { 3496.16,-3283.35,10.62,25.52 } -- IlhaBatman
	Skinshops[#Skinshops+1] = { 715.75,-959.24,30.4,354.34 } -- QG_108
	Skinshops[#Skinshops+1] = { 867.22,1872.93,140.39,153.08 } -- QG_07
	Skinshops[#Skinshops+1] = { -59.51,842.14,235.71,308.98 } -- QG_118
	Skinshops[#Skinshops+1] = { 676.42,909.22,247.57,170.08} -- QG_121
	Skinshops[#Skinshops+1] = { -1136.33,-2076.44,21.28,223.94 } -- mecanica
	
elseif cityName == "Galaxy" then
	Skinshops[#Skinshops+1] = { -417.98,4372.91,61.35,184.26 } -- mansao94
	Skinshops[#Skinshops+1] = { 1138.87,-1538.69,35.03,272.13 } -- hp
	Skinshops[#Skinshops+1] = { 2509.94,-441.94,106.91,320.32 } -- dp principal
	Skinshops[#Skinshops+1] = { 2517.45,-345.63,101.89,39.69 } -- dp principal
	Skinshops[#Skinshops+1] = { 1076.15,3266.02,38.6,226.78 } -- Verde
	Skinshops[#Skinshops+1] = { 1502.54,1517.99,108.16,348.67 } -- Marrom
	Skinshops[#Skinshops+1] = { 1165.34,-142.11,59.55,226.78 } -- Vermelho
	Skinshops[#Skinshops+1] = { 1797.05,441.96,172.34,59.53 } -- Azul
	Skinshops[#Skinshops+1] = { 2133.61,-15.7,227.22,45.36 } -- Rosa
	Skinshops[#Skinshops+1] = { 2742.43,2716.88,55.84,48.19 } -- Sindicato
	Skinshops[#Skinshops+1] = { -1081.81,-247.81,44.01,238.12 }
	Skinshops[#Skinshops+1] = { 3606.11,3729.53,29.69,343.0 } -- Groove
	Skinshops[#Skinshops+1] = { -1049.56,-229.46,44.01,215.44 } -- Amarelo
	Skinshops[#Skinshops+1] = { 2115.64,3886.09,33.23,215.44 } -- Roxo
	Skinshops[#Skinshops+1] = { 358.11,-2033.39,22.39,48.19 } -- Vagos
	Skinshops[#Skinshops+1] = { 89.54,-1989.74,20.41,314.65 } -- Ballas
	Skinshops[#Skinshops+1] = { 103.51,3613.09,40.49,175.75 } -- Laranja
	Skinshops[#Skinshops+1] = { -291.24,216.89,78.82,277.8 } -- Bahamas
	Skinshops[#Skinshops+1] = { 963.86,18.02,75.74,144.57 } -- Bellagio
	Skinshops[#Skinshops+1] = { -141.41,-1608.56,35.03,51.03 } -- Redline
	Skinshops[#Skinshops+1] = { -203.27,-1330.04,34.9,127.56 } -- Undergrounds
	Skinshops[#Skinshops+1] = { 1382.88,-2093.85,47.21,31.19 } -- fazer
	Skinshops[#Skinshops+1] = { 2361.62,5647.1,92.71,141.74 } -- Topgear
	Skinshops[#Skinshops+1] = { 2513.83,4107.05,38.59,243.78 } -- israel
	Skinshops[#Skinshops+1] = { -1149.56,-1554.59,7.63,153.08 } -- bandoleros
	Skinshops[#Skinshops+1] = { -2131.91,-176.94,42.44,218.27 } -- Gang5
	Skinshops[#Skinshops+1] = { 99.06,1229.61,207.17,345.83 } -- Mayans
	Skinshops[#Skinshops+1] = { 1028.6,-2550.72,32.28,351.5 } -- soa
	Skinshops[#Skinshops+1] = { 1033.38,916.42,222.06,59.53 } -- hellsangels
	Skinshops[#Skinshops+1] = { 3234.18,5120.17,20.15,116.23 }
	Skinshops[#Skinshops+1] = { 1065.13,-1990.52,31.76,238.12 } -- gringa
	Skinshops[#Skinshops+1] = { -1563.89,-373.7,48.04,303.31 } -- bloods
	Skinshops[#Skinshops+1] = { -3025.46,59.49,11.95,331.66 } -- crips
	Skinshops[#Skinshops+1] = { 355.53,-2729.49,1.7,56.7 } -- warlocks
	Skinshops[#Skinshops+1] = { 928.25,363.91,112.35,229.61  } -- mexicana
	Skinshops[#Skinshops+1] = {-1881.59,2068.82,145.57,155.91 } -- russa
	Skinshops[#Skinshops+1] = { -1491.07,845.77,181.59,87.88 } -- irlandesa
	Skinshops[#Skinshops+1] = { -324.01,1992.22,151.26,291.97 } -- triade
	Skinshops[#Skinshops+1] = { 420.53,-1483.85,33.8,116.23 } -- italiana
	Skinshops[#Skinshops+1] = { -613.39,-1625.22,33.01,87.88 } -- overdrive
	Skinshops[#Skinshops+1] = { -777.34,-2592.59,17.66,51.03 } -- Outlaws 
	Skinshops[#Skinshops+1] = { 956.47,-2390.61,22.33,22.68 } -- Topgear 
	Skinshops[#Skinshops+1] = { 2743.75,2717.9,55.84,218.27 }
	Skinshops[#Skinshops+1] = { -1797.74,425.97,128.28,314.65 } -- luxor
	Skinshops[#Skinshops+1] = { 2312.64,5568.36,51.91,343.0 } -- sinaloa
	Skinshops[#Skinshops+1] = { -1520.57,138.72,60.44,133.23 } -- playboy
	Skinshops[#Skinshops+1] = { 1252.95,-1720.72,56.45,65.2 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1289.66,-1762.54,54.21,22.68 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1338.0,-792.43,71.51,343.0 } -- brancos
	Skinshops[#Skinshops+1] = { 1346.33,-705.11,67.74,73.71 } -- brancos
	Skinshops[#Skinshops+1] = { 1324.2,-704.54,67.9,201.26 } -- brancos
	Skinshops[#Skinshops+1] = { 1251.7,-265.25,77.91,107.72 } -- barragem
	Skinshops[#Skinshops+1] = { 489.17,2580.53,49.99,195.6 } -- azuis
	Skinshops[#Skinshops+1] = { 2226.14,3453.91,61.33,187.09 } -- cinzas
	Skinshops[#Skinshops+1] = { -1541.68,324.89,87.25,238.12 } -- frança
	Skinshops[#Skinshops+1] = { 176.63,669.24,207.66,96.38 } -- bahamas
	Skinshops[#Skinshops+1] = { 1869.37,6375.66,45.6,252.29 } -- marrons
	Skinshops[#Skinshops+1] = { 1403.4,-2397.56,65.7,334.49 } -- rosas
	Skinshops[#Skinshops+1] = { 1507.72,-2369.02,78.03,280.63 } -- rosas
	Skinshops[#Skinshops+1] = { 514.87,370.09,151.73,116.23 } -- roxos
	Skinshops[#Skinshops+1] = { -2779.14,2509.53,3.98,0.0 } -- Noxus
	Skinshops[#Skinshops+1] = { -2776.76,2324.3,6.79,53.86 } -- Noxus
	Skinshops[#Skinshops+1] = { 3094.7,-4710.87,15.27,172.92 } 
	Skinshops[#Skinshops+1] = { 5026.55,-5760.97,15.77,232.45 } -- Caribe

elseif cityName == "Gaules" then
	Skinshops[#Skinshops+1] = { -417.98,4372.91,61.35,184.26 } -- mansao94
	Skinshops[#Skinshops+1] = { 1138.87,-1538.69,35.03,272.13 } -- hp
	Skinshops[#Skinshops+1] = { 2509.94,-441.94,106.91,320.32 } -- dp principal
	Skinshops[#Skinshops+1] = { 2517.45,-345.63,101.89,39.69 } -- dp principal
	Skinshops[#Skinshops+1] = {   1076.15,3266.02,38.6,226.78 } -- Verde
	Skinshops[#Skinshops+1] = {  1502.54,1517.99,108.16,348.67 } -- Marrom
	Skinshops[#Skinshops+1] = {  1165.34,-142.11,59.55,226.78 } -- Vermelho
	Skinshops[#Skinshops+1] = {  1797.05,441.96,172.34,59.53 } -- Azul
	Skinshops[#Skinshops+1] = {  2133.61,-15.7,227.22,45.36 } -- Rosa
	Skinshops[#Skinshops+1] = {  2742.43,2716.88,55.84,48.19 } -- Sindicato
	Skinshops[#Skinshops+1] = {  -1081.81,-247.81,44.01,238.12 }
	Skinshops[#Skinshops+1] = {  3606.11,3729.53,29.69,343.0 } -- Groove
	Skinshops[#Skinshops+1] = {  -1049.56,-229.46,44.01,215.44 } -- Amarelo
	Skinshops[#Skinshops+1] = {  2115.64,3886.09,33.23,215.44 } -- Roxo
	Skinshops[#Skinshops+1] = {  358.11,-2033.39,22.39,48.19 } -- Vagos
	Skinshops[#Skinshops+1] = {  89.54,-1989.74,20.41,314.65 } -- Ballas
	Skinshops[#Skinshops+1] = {  103.51,3613.09,40.49,175.75 } -- Laranja
	Skinshops[#Skinshops+1] = {  -291.24,216.89,78.82,277.8 } -- Bahamas
	Skinshops[#Skinshops+1] = {  963.86,18.02,75.74,144.57 } -- Bellagio
	Skinshops[#Skinshops+1] = {  -141.41,-1608.56,35.03,51.03 } -- Redline
	Skinshops[#Skinshops+1] = {  -203.27,-1330.04,34.9,127.56 } -- Undergrounds
	Skinshops[#Skinshops+1] = {  1382.88,-2093.85,47.21,31.19 } -- fazer
	Skinshops[#Skinshops+1] = {  2361.62,5647.1,92.71,141.74 } -- Topgear
	Skinshops[#Skinshops+1] = { 2513.83,4107.05,38.59,243.78 } -- israel
	Skinshops[#Skinshops+1] = {  -1149.56,-1554.59,7.63,153.08 } -- bandoleros
	Skinshops[#Skinshops+1] = {  556.33,-2773.46,6.08,59.53 } -- Gang5
	Skinshops[#Skinshops+1] = {  99.06,1229.61,207.17,345.83 } -- Mayans
	Skinshops[#Skinshops+1] = {  1028.6,-2550.72,32.28,351.5 } -- soa
	Skinshops[#Skinshops+1] = {  -641.82,-1240.5,11.54,42.52 } -- hellsangels
	Skinshops[#Skinshops+1] = {  3234.18,5120.17,20.15,116.23 }
	Skinshops[#Skinshops+1] = { 2312.64,5568.36,51.91,343.0 } -- sinaloa
	Skinshops[#Skinshops+1] = {  1065.13,-1990.52,31.76,238.12 } -- gringa
	Skinshops[#Skinshops+1] = {  -1563.89,-373.7,48.04,303.31 } -- bloods
	Skinshops[#Skinshops+1] = {  -3025.46,59.49,11.95,331.66 } -- crips
	Skinshops[#Skinshops+1] = {  355.53,-2729.49,1.7,56.7 } -- warlocks
	Skinshops[#Skinshops+1] = {  -1814.54,447.96,127.91,351.5 } -- mexicana
	Skinshops[#Skinshops+1] = {  -1881.59,2068.82,145.57,155.91 } -- russa
	Skinshops[#Skinshops+1] = {  -1491.07,845.77,181.59,87.88 } -- irlandesa
	Skinshops[#Skinshops+1] = {  -566.04,227.81,74.88,76.54 } -- triade
	Skinshops[#Skinshops+1] = {  420.53,-1483.85,33.8,116.23 } -- italiana
	Skinshops[#Skinshops+1] = {  2332.3,5524.54,51.68,249.45 } -- overdrive
	Skinshops[#Skinshops+1] = {  -777.34,-2592.59,17.66,51.03 } -- Outlaws 
	Skinshops[#Skinshops+1] = {  956.47,-2390.61,22.33,22.68 } -- Topgear 
	Skinshops[#Skinshops+1] = { 1252.95,-1720.72,56.45,65.2 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1289.66,-1762.54,54.21,22.68 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1338.0,-792.43,71.51,343.0 } -- brancos
	Skinshops[#Skinshops+1] = { 1346.33,-705.11,67.74,73.71 } -- brancos
	Skinshops[#Skinshops+1] = { 1251.7,-265.25,77.91,107.72 } -- barragem
	Skinshops[#Skinshops+1] = { 489.17,2580.53,49.99,195.6 } -- azuis
	Skinshops[#Skinshops+1] = { 2226.14,3453.91,61.33,187.09 } -- cinzas
	Skinshops[#Skinshops+1] = { -2779.14,2509.53,3.98,0.0 } -- Noxus
	Skinshops[#Skinshops+1] = { 5026.55,-5760.97,15.77,232.45 } -- Caribe

elseif cityName == "Fronteira" then
	Skinshops[#Skinshops+1] = { -3068.65,3456.45,10.03,255.12 } -- mansao93
	Skinshops[#Skinshops+1] = { 1834.41,2571.42,46.01,336.15 } -- PoliciaPrisional
	Skinshops[#Skinshops+1] = { -162.92,1245.87,311.45,51.03 } -- mansao165
	Skinshops[#Skinshops+1] = { -3077.26,1881.28,33.95,79.38 } -- mansao55
	Skinshops[#Skinshops+1] = { -1707.12,-91.01,89.83,45.36 } -- mansao139
	Skinshops[#Skinshops+1] = { 653.44,921.91,252.6,170.08 } -- mansao61
	Skinshops[#Skinshops+1] = { -2987.77,2185.47,45.09,127.56 } -- mansao62
	Skinshops[#Skinshops+1] = { 757.92,3423.04,62.68,76.54 } -- mansao48
	Skinshops[#Skinshops+1] = { -1048.78,2790.62,27.20,105.51 } -- mansao158
	Skinshops[#Skinshops+1] = { -1238.71,795.43,197.19,96.38 } -- mansao44
	Skinshops[#Skinshops+1] = { -1530.12,821.28,184.92,8.69 } -- QG_269
	Skinshops[#Skinshops+1] = { -554.14,1192.33,334.08,280.63 } -- AlphaA1
	Skinshops[#Skinshops+1] = { -575.98,1193.24,334.08,184.26 } -- AlphaA2
	Skinshops[#Skinshops+1] = { -604.07,1192.34,334.08,269.3 } -- AlphaA3
	Skinshops[#Skinshops+1] = { -628.87,1192.29,334.08,283.47 } -- AlphaA4
	Skinshops[#Skinshops+1] = { -543.57,1251.58,334.08,85.04 } -- AlphaB1
	Skinshops[#Skinshops+1] = { -568.49,1251.75,334.08,110.56 } -- AlphaB2
	Skinshops[#Skinshops+1] = { -593.38,1251.64,334.08,102.05 } -- AlphaB3
	Skinshops[#Skinshops+1] = { -618.02,1251.67,334.08,87.88 } -- AlphaB4
	Skinshops[#Skinshops+1] = { -2349.97,3266.35,32.81,154.02 }
	Skinshops[#Skinshops+1] = { -1914.03,-53.82,135.69,22.68 } -- mansao154
	Skinshops[#Skinshops+1] = { -3164.47,2336.05,14.2,8.51 } -- QG_264
	Skinshops[#Skinshops+1] = { -1514.82,-1468.04,6.39,206.93 } -- Atlantis
	Skinshops[#Skinshops+1] = { -1695.24,-1130.01,14.0,147.41 }
	Skinshops[#Skinshops+1] = { -1699.29,-1126.98,14.0,226.78 }
	Skinshops[#Skinshops+1] = { -3803.9,288.08,158.81,175.75 } -- QG_173
	Skinshops[#Skinshops+1] = { 2026.2,4290.16,43.25,17.01 } -- QG_180
	Skinshops[#Skinshops+1] = { 1678.57,7055.46,11.77,141.25 }
	Skinshops[#Skinshops+1] = { 1584.97,4087.41,43.06,198.55 } -- QG_165
	Skinshops[#Skinshops+1] = { 136.79,-346.87,50.33,158.75 } -- QG_168
	Skinshops[#Skinshops+1] = { -404.72,4373.04,62.82,354.34 } -- mansao94
	Skinshops[#Skinshops+1] = { -142.82,6494.48,38.84,39.69 } -- mansao102
	Skinshops[#Skinshops+1] = { 2023.49,-1600.29,258.50,347.38 } -- mansao101
	Skinshops[#Skinshops+1] = { 368.92,2384.33,80.24,137.06 } -- mansao49
	Skinshops[#Skinshops+1] = { -126.17,6619.03,33.85,311.82 } -- mansao51
	Skinshops[#Skinshops+1] = { -1474.76,-1759.03,14.35,3.21 } -- mansao70
	Skinshops[#Skinshops+1] = { -2766.96,-941.86,16.05,64.63 } -- mansao71
	Skinshops[#Skinshops+1] = { -1141.65,374.78,74.97,226.04 } -- QG_155
	Skinshops[#Skinshops+1] = { -1417.25,-617.80,30.72,36.73 } -- MajorBahamas
	Skinshops[#Skinshops+1] = { -3090.98,3367.52,17.32,180.20 } -- mansao66
	Skinshops[#Skinshops+1] = { -3536.63,4623.20,6.72,287.43 } -- mansao96
	Skinshops[#Skinshops+1] = { 1036.84,3678.09,39.05,179.56 } -- mansao16
	Skinshops[#Skinshops+1] = { 2006.75,3354.94,51.60,83.44 } -- QG_150
	Skinshops[#Skinshops+1] = { 102.37,-1311.13,21.13,48.19 } -- QG_143
	Skinshops[#Skinshops+1] = { -2189.20,4283.77,49.18,196.14 } -- QG_132
	Skinshops[#Skinshops+1] = { 958.86,-966.6,42.95,348.67 } -- mecanica
	Skinshops[#Skinshops+1] = { -632.41,-134.04,43.22,93.55 } -- Bombeiros
	Skinshops[#Skinshops+1] = { 1087.36,-922.42,51.27,175.24 } -- Bombeiros
	Skinshops[#Skinshops+1] = { 1150.65,-1583.05,35.28,138.9 } -- hp
	Skinshops[#Skinshops+1] = { 457.64,-990.77,30.68,11.34 } -- dp praça
	Skinshops[#Skinshops+1] = { 2516.96,-345.11,101.89,42.52 } -- Militar
	Skinshops[#Skinshops+1] = { -437.84,6012.35,36.99,357.17 } -- civil
	Skinshops[#Skinshops+1] = { -780.21,-1211.9,10.38,141.74 } -- Tatica
	Skinshops[#Skinshops+1] = { -1887.58,3026.39,32.96,328.82 } -- Exercito
	Skinshops[#Skinshops+1] = { 1075.28,3273.75,41.11,198.43 } -- umbrella
	Skinshops[#Skinshops+1] = { 875.42,1860.9,142.5,226.78 } -- Metgala
	Skinshops[#Skinshops+1] = { -2197.05,-275.16,35.79,257.96 } -- Gang4
	Skinshops[#Skinshops+1] = { -458.91,-1264.9,25.48,51.03 } -- Afetados
	Skinshops[#Skinshops+1] = { 413.04,6468.02,29.82,274.97 } -- Pinkmans
	Skinshops[#Skinshops+1] = { 1513.4,1356.95,108.29,286.3 } -- Gang9
	Skinshops[#Skinshops+1] = { 957.6,-2390.99,22.33,175.75 } -- China
	Skinshops[#Skinshops+1] = { 790.13,5752.55,702.57,249.45 } -- Mansao95
	Skinshops[#Skinshops+1] = { -763.42,29.24,40.64,161.58 } -- Igreja
	Skinshops[#Skinshops+1] = { 3047.53,-4136.9,9.86,351.5 }
	Skinshops[#Skinshops+1] = { -2003.59,4494.14,57.29,320.32 }
	Skinshops[#Skinshops+1] = { -1628.7,-1100.71,13.09,229.61 }
	-- Skinshops[#Skinshops+1] = { 2029.85,4299.39,38.25,99.22 } -- QG_110
	-- Skinshops[#Skinshops+1] = { 1030.2,-2550.23,32.28,85.04 } -- Vermelhos
	Skinshops[#Skinshops+1] = { 1797.05,441.96,172.34,59.53 } -- Azul
	Skinshops[#Skinshops+1] = { 2133.61,-15.7,227.22,45.36 } -- Rosa
	Skinshops[#Skinshops+1] = { 2742.43,2716.88,55.84,48.19 } -- Sindicato
	-- Skinshops[#Skinshops+1] = { -139.96,-1609.06,35.03,68.04 } -- Groove
	Skinshops[#Skinshops+1] = { 2115.64,3886.09,33.23,215.44 } -- Roxos
	Skinshops[#Skinshops+1] = { 514.2,370.01,151.73,104.89 } -- Roxos
	Skinshops[#Skinshops+1] = { 358.11,-2033.39,22.39,48.19 } -- Vagos
	Skinshops[#Skinshops+1] = { 117.31,-1962.14,21.33,201.26 } -- Ballas
	-- Skinshops[#Skinshops+1] = {  103.51,3613.09,40.49,175.75 } -- Laranja
	Skinshops[#Skinshops+1] = { 291.24,216.89,78.82,277.8 } -- Bahamas
	Skinshops[#Skinshops+1] = { 945.01,47.64,80.29,53.86 } -- Bellagio
	Skinshops[#Skinshops+1] = { -1540.36,321.5,87.25,73.71 } -- Lavajato
	Skinshops[#Skinshops+1] = { 102.53,-1311.89,21.13,31.19 } -- Putaria
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { 414.94,-23.43,91.93,56.7 } -- Callisto
	Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
	Skinshops[#Skinshops+1] = { -2271.77,322.98,174.6,22.68 } -- Redline
	Skinshops[#Skinshops+1] = { -203.27,-1330.04,34.9,127.56 } -- Undergrounds
	Skinshops[#Skinshops+1] = { 1382.88,-2093.85,47.21,31.19 } -- fazer
	Skinshops[#Skinshops+1] = { 2361.62,5647.1,92.71,141.74 } -- Topgear
	Skinshops[#Skinshops+1] = { 1378.51,-2096.32,52.6,39.69  } -- FerroVelho
	Skinshops[#Skinshops+1] = { 2643.51,3636.15,106.73,39.69 } -- Morro-do-Sacola
	Skinshops[#Skinshops+1] = { 883.73,-2100.55,30.46,175.75 } -- CarClube
	Skinshops[#Skinshops+1] = { -337.81,-166.57,44.58,272.13 } -- Virtude
	Skinshops[#Skinshops+1] = { 134.68,-369.75,50.33,17.01 } -- Big
	Skinshops[#Skinshops+1] = { 2742.47,3500.22,61.3,357.17} -- Kraken
	Skinshops[#Skinshops+1] = { -1149.56,-1554.59,7.63,153.08 } -- bandoleros
	Skinshops[#Skinshops+1] = { 556.33,-2773.46,6.08,59.53 } -- Gang5
	Skinshops[#Skinshops+1] = { 99.06,1229.61,207.17,345.83 } -- Mayans
	Skinshops[#Skinshops+1] = { 1028.6,-2550.72,32.28,351.5 } -- soa
	Skinshops[#Skinshops+1] = { 1026.51,-2542.27,28.29,170.08 } -- hellsangels
	Skinshops[#Skinshops+1] = { 3234.18,5120.17,20.15,116.23 }
	Skinshops[#Skinshops+1] = { 2312.64,5568.36,51.91,343.0 } -- sinaloa
	Skinshops[#Skinshops+1] = { -60.09,994.66,239.52,328.82 } -- gringa
	Skinshops[#Skinshops+1] = { -1539.52,141.51,55.65,51.03 } -- bloods
	-- Skinshops[#Skinshops+1] = { -2804.84,2261.69,24.11,320.32 } -- bloods secundario
	Skinshops[#Skinshops+1] = { -3025.46,59.49,11.95,331.66 } -- crips
	Skinshops[#Skinshops+1] = { -1814.54,447.96,127.91,351.5 } -- mexicana
	Skinshops[#Skinshops+1] = { -1887.16,2070.1,145.57,334.49 } -- russa
	Skinshops[#Skinshops+1] = { -1491.07,845.77,181.59,87.88 } -- irlandesa
	Skinshops[#Skinshops+1] = { 173.45,668.33,207.66,104.89 } -- triade
	Skinshops[#Skinshops+1] = { 420.53,-1483.85,33.8,116.23 } -- italiana
	Skinshops[#Skinshops+1] = { 2332.3,5524.54,51.68,249.45 } -- overdrive
	Skinshops[#Skinshops+1] = { -776.37,-2593.33,17.66,238.12 } -- Outlaws 
	Skinshops[#Skinshops+1] = { -617.15,-1617.33,33.01,172.92 } -- Topgear 
	Skinshops[#Skinshops+1] = { -290.78,1986.24,166.14,334.49 } -- israel
	-- Skinshops[#Skinshops+1] = { 1078.37,-1973.3,31.48,235.28 } -- gringa
	Skinshops[#Skinshops+1] = { -303.2,220.21,77.91,257.96 } -- luxor
	Skinshops[#Skinshops+1] = { 1252.95,-1720.72,56.45,65.2 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1289.66,-1762.54,54.21,22.68 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1338.0,-792.43,71.51,343.0 } -- brancos
	Skinshops[#Skinshops+1] = { 1346.33,-705.11,67.74,73.71 } -- brancos
	Skinshops[#Skinshops+1] = { 1267.24,-299.03,84.59,158.75 } -- barragem
	Skinshops[#Skinshops+1] = { 1251.62,-265.92,77.91,107.72 } -- barragem
	Skinshops[#Skinshops+1] = { 1506.8,-2368.57,78.03,274.97 } -- rosas
	Skinshops[#Skinshops+1] = { 1512.78,-2365.16,78.03,195.6 } -- rosas
	-- Skinshops[#Skinshops+1] = { 2225.07,3452.81,61.33,172.92 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2229.55,3452.95,61.33,170.08 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2226.14,3453.91,61.33,187.09 } -- cinzas
	Skinshops[#Skinshops+1] = { 103.67,1221.91,207.17,102.05 } -- SOA
	Skinshops[#Skinshops+1] = { 1306.65,-735.32,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -215.34,-1334.28,34.9,266.46 } -- bennys
	Skinshops[#Skinshops+1] = { 1048.13,888.82,220.34,48.19 } -- playboy
	Skinshops[#Skinshops+1] = { 1341.91,-790.49,71.51,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { 1336.42,-788.7,71.51,348.67 } -- brancos
	Skinshops[#Skinshops+1] = { 1308.3,-733.85,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -1550.84,-393.9,41.97,51.03 } -- 
	Skinshops[#Skinshops+1] = { -3337.8,543.54,17.44,215.44 } -- mansao 60
	Skinshops[#Skinshops+1] = { 1963.43,6415.17,61.7,311.82 } -- marrons
	Skinshops[#Skinshops+1] = { -2272.06,323.23,174.6,22.68 }
	Skinshops[#Skinshops+1] = { -1687.17,-3185.18,14.0,243.78 }
	Skinshops[#Skinshops+1] = { 747.78,-308.18,59.8,306.15 } -- Campinho
	Skinshops[#Skinshops+1] = { 905.89,339.35,112.29,345.83 } -- Japao
	Skinshops[#Skinshops+1] = { -1044.65,305.04,71.66,266.46 } -- Inglaterra
	Skinshops[#Skinshops+1] = { -2022.42,4435.69,53.09,345.83 } -- Banzas
	Skinshops[#Skinshops+1] = { 355.76,-2729.82,1.72,257.96 } -- Dixavas
	Skinshops[#Skinshops+1] = { -769.38,8.1,40.64,345.83 } 
	Skinshops[#Skinshops+1] = { 1471.81,6539.39,18.64,85.04 } -- pier norte
	Skinshops[#Skinshops+1] = { -602.0,-914.22,23.88,184.26 } -- Anonymous
	Skinshops[#Skinshops+1] = { -602.7,-923.49,17.59,328.82 } -- Anonymous
	Skinshops[#Skinshops+1] = { -2813.9,2266.37,24.33,354.34 } -- qg 71
	Skinshops[#Skinshops+1] = { 676.42,909.22,247.57,170.08 } -- Inglaterra
	Skinshops[#Skinshops+1] = { 5026.55,-5760.97,15.77,232.45 } -- Caribe
	Skinshops[#Skinshops+1] = { 2612.27,5333.94,47.57,59.53 } -- prf
	Skinshops[#Skinshops+1] = { 3088.32,5091.99,23.25,73.71 } -- qg_80
	Skinshops[#Skinshops+1] = { -156.96,8259.62,12.82,11.34 } -- iate
	Skinshops[#Skinshops+1] = { -1784.4,-1376.75,11.88,39.69 } -- iate
	Skinshops[#Skinshops+1] = { -1883.34,-1164.43,11.73,320.32 } -- iate
	Skinshops[#Skinshops+1] = { -2210.16,-586.48,11.73,232.45 } 
	Skinshops[#Skinshops+1] = { 866.58,1871.27,140.39,87.88 } -- QG_07
	Skinshops[#Skinshops+1] = { -1179.62,302.46,73.67,102.05 } -- qg_82
	Skinshops[#Skinshops+1] = { -1226.24,-1737.73,4.53,138.9 } -- qg_83
	Skinshops[#Skinshops+1] = { -2423.52,1790.06,185.48,39.69 } -- qg_84
	Skinshops[#Skinshops+1] = { -878.0,-1434.81,7.53,201.26 } -- qg_85
	Skinshops[#Skinshops+1] = { -539.93,5002.83,159.92,272.13 } -- qg_86
	Skinshops[#Skinshops+1] = { -2675.14,1307.61,152.0,272.13 } -- qg_87
	Skinshops[#Skinshops+1] = { -2277.87,336.33,178.57,300.48 } -- qg_88
	Skinshops[#Skinshops+1] = { 3482.3,5015.04,11.91,212.6 }
	Skinshops[#Skinshops+1] = { -4504.72,-70.94,12.81,164.41 }
	Skinshops[#Skinshops+1] = { 994.15,3403.17,61.97,280.63 } -- QG_31
	Skinshops[#Skinshops+1] = { 89.54,-1966.65,20.74,320.32 } -- QG_43
	Skinshops[#Skinshops+1] = { 2456.34,4980.02,46.83,158.75 } -- QG_64
	Skinshops[#Skinshops+1] = { -935.2,403.8,79.23,195.6 } -- QG_103
	Skinshops[#Skinshops+1] = { 129.79,-99.03,49.57,161.58 } -- QG_106
	Skinshops[#Skinshops+1] = { 3496.16,-3283.35,10.62,25.52 } -- IlhaBatman
	Skinshops[#Skinshops+1] = { 715.75,-959.24,30.4,354.34 } -- QG_108
	Skinshops[#Skinshops+1] = { 867.22,1872.93,140.39,153.08 } -- QG_07
	Skinshops[#Skinshops+1] = { 676.42,909.22,247.57,170.08} -- QG_121
	Skinshops[#Skinshops+1] = { -1136.33,-2076.44,21.28,223.94 } -- mecanica

elseif cityName == "Alexandria" then
	Skinshops[#Skinshops+1] = { -2349.97,3266.35,32.81,154.02 }
	Skinshops[#Skinshops+1] = { -417.98,4372.91,61.35,184.26 } -- mansao94
	Skinshops[#Skinshops+1] = { 791.97,5736.84,702.57,76.54 } -- mansao90
	Skinshops[#Skinshops+1] = { 2023.49,-1600.29,258.50,347.38 } -- mansao101
	Skinshops[#Skinshops+1] = { 2505.72,3590.05,98.5,127.56 } -- QG_104
	Skinshops[#Skinshops+1] = { -632.41,-134.04,43.22,93.55 } -- bombeiros
	Skinshops[#Skinshops+1] = { 1472.11,6539.36,18.64,272.13 } -- pier norte
	Skinshops[#Skinshops+1] = { 1150.08,-1583.2,35.28,178.59 } -- hp
	Skinshops[#Skinshops+1] = { 2509.94,-441.94,106.91,320.32 } -- dp principal
	Skinshops[#Skinshops+1] = { 2517.45,-345.63,101.89,39.69 } -- dp principal
	Skinshops[#Skinshops+1] = {   1076.15,3266.02,38.6,226.78 } -- Verde
	Skinshops[#Skinshops+1] = { 457.64,-990.77,30.68,11.34 } -- dp praça
	Skinshops[#Skinshops+1] = {  1502.54,1517.99,108.16,348.67 } -- Marrom
	Skinshops[#Skinshops+1] = {  1165.34,-142.11,59.55,226.78 } -- Vermelho
	Skinshops[#Skinshops+1] = {  1797.05,441.96,172.34,59.53 } -- Azul
	Skinshops[#Skinshops+1] = {  2133.61,-15.7,227.22,45.36 } -- Rosa
	Skinshops[#Skinshops+1] = {  2742.43,2716.88,55.84,48.19 } -- Sindicato
	Skinshops[#Skinshops+1] = {  3606.11,3729.53,29.69,343.0 } -- Groove
	Skinshops[#Skinshops+1] = { 2115.64,3886.09,33.23,215.44 } -- Roxo
	Skinshops[#Skinshops+1] = { 358.11,-2033.39,22.39,48.19 } -- Vagos
	Skinshops[#Skinshops+1] = { 89.54,-1989.74,20.41,314.65 } -- Ballas
	Skinshops[#Skinshops+1] = { 103.51,3613.09,40.49,175.75 } -- Laranja
	Skinshops[#Skinshops+1] = { -291.24,216.89,78.82,277.8 } -- Bahamas
	Skinshops[#Skinshops+1] = { 963.86,18.02,75.74,144.57 } -- Bellagio
	Skinshops[#Skinshops+1] = { -141.41,-1608.56,35.03,51.03 } -- Redline
	Skinshops[#Skinshops+1] = { -203.27,-1330.04,34.9,127.56 } -- Undergrounds
	Skinshops[#Skinshops+1] = { 1382.88,-2093.85,47.21,31.19 } -- fazer
	Skinshops[#Skinshops+1] = { 2361.62,5647.1,92.71,141.74 } -- Topgear
	Skinshops[#Skinshops+1] = { 2513.83,4107.05,38.59,243.78 } -- israel
	Skinshops[#Skinshops+1] = { -1149.56,-1554.59,7.63,153.08 } -- bandoleros
	Skinshops[#Skinshops+1] = { 556.33,-2773.46,6.08,59.53 } -- Gang5
	Skinshops[#Skinshops+1] = { 99.06,1229.61,207.17,345.83 } -- Mayans
	Skinshops[#Skinshops+1] = { 1028.6,-2550.72,32.28,351.5 } -- soa
	Skinshops[#Skinshops+1] = { -641.82,-1240.5,11.54,42.52 } -- hellsangels
	Skinshops[#Skinshops+1] = { 3234.18,5120.17,20.15,116.23 }
	Skinshops[#Skinshops+1] = { 2312.64,5568.36,51.91,343.0 } -- sinaloa
	Skinshops[#Skinshops+1] = { 1065.13,-1990.52,31.76,238.12 } -- gringa
	Skinshops[#Skinshops+1] = { -1563.89,-373.7,48.04,303.31 } -- bloods
	Skinshops[#Skinshops+1] = { -1566.02,327.9,86.84,289.14 } -- crips
	Skinshops[#Skinshops+1] = { 355.53,-2729.49,1.7,56.7 } -- warlocks
	Skinshops[#Skinshops+1] = { -1814.54,447.96,127.91,351.5 } -- mexicana
	Skinshops[#Skinshops+1] = { -1881.59,2068.82,145.57,155.91 } -- russa
	Skinshops[#Skinshops+1] = { -1491.07,845.77,181.59,87.88 } -- irlandesa
	Skinshops[#Skinshops+1] = { 1044.08,884.63,220.36,42.52 } -- triade
	Skinshops[#Skinshops+1] = { -1522.87,136.83,60.44,34.02 } -- italiana
	Skinshops[#Skinshops+1] = { 2332.3,5524.54,51.68,249.45 } -- overdrive
	Skinshops[#Skinshops+1] = { -777.34,-2592.59,17.66,51.03 } -- Outlaws 
	Skinshops[#Skinshops+1] = { 956.47,-2390.61,22.33,22.68 } -- Topgear 
	Skinshops[#Skinshops+1] = { 1252.95,-1720.72,56.45,65.2 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1289.66,-1762.54,54.21,22.68 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1338.0,-792.43,71.51,343.0 } -- brancos
	Skinshops[#Skinshops+1] = { 1346.33,-705.11,67.74,73.71 } -- brancos
	Skinshops[#Skinshops+1] = { 1251.7,-265.25,77.91,107.72 } -- barragem
	Skinshops[#Skinshops+1] = { -3050.88,109.82,12.35,328.82 }
	Skinshops[#Skinshops+1] = { 489.17,2580.53,49.99,195.6 } -- azuis
	Skinshops[#Skinshops+1] = { 2226.14,3453.91,61.33,187.09 } -- cinzas
	Skinshops[#Skinshops+1] = { -2779.14,2509.53,3.98,0.0 } -- Noxus
	Skinshops[#Skinshops+1] = { -951.12,-2043.19,9.4,249.45 }
	Skinshops[#Skinshops+1] = { 5026.55,-5760.97,15.77,232.45 } -- Caribe
	Skinshops[#Skinshops+1] = { 3088.32,5091.99,23.25,73.71 } -- qg_80
	Skinshops[#Skinshops+1] = { -1179.62,302.46,73.67,102.05 } -- qg_82
	Skinshops[#Skinshops+1] = { -1226.24,-1737.73,4.53,138.9 } -- qg_83
	Skinshops[#Skinshops+1] = { -2423.52,1790.06,185.48,39.69 } -- qg_84
	Skinshops[#Skinshops+1] = { -878.0,-1434.81,7.53,201.26 } -- qg_85
	Skinshops[#Skinshops+1] = { -3337.8,543.54,17.44,215.44 } -- mansao 60
	Skinshops[#Skinshops+1] = { -780.21,-1211.9,10.38,141.74} -- Tatica
	Skinshops[#Skinshops+1] = { 2613.76,5333.45,47.57,198.43 } -- Prf
	Skinshops[#Skinshops+1] = { -1628.99,-1100.47,13.09,45.70 } -- pier
	Skinshops[#Skinshops+1] = { -1136.33,-2076.44,21.28,223.94 } -- mecanica
	
elseif cityName == "Maresia" then
	Skinshops[#Skinshops+1] = { -2566.45,-2204.01,5.05,161.58 } -- Resort
	Skinshops[#Skinshops+1] = { -3068.65,3456.45,10.03,255.12 } -- mansao93
	Skinshops[#Skinshops+1] = { -2238.13,498.4,178.24,345.83 } -- mansao196
	Skinshops[#Skinshops+1] = { -2252.94,501.79,178.22,343.0 } -- mansao196
	Skinshops[#Skinshops+1] = { -2259.34,472.04,178.22,170.08 } -- mansao196
	Skinshops[#Skinshops+1] = { -2249.63,469.85,178.24,164.41 } -- mansao196
	Skinshops[#Skinshops+1] = { -1050.32,-2011.89,13.16,138.47 } -- mecanica
	Skinshops[#Skinshops+1] = { 1133.63,-1518.37,34.84,66.08 } -- paramedic
	Skinshops[#Skinshops+1] = { -1474.81,-1751.84,14.34,93.55 } -- QG_374
	Skinshops[#Skinshops+1] = { -1474.03,-1760.28,14.81,87.88 } -- QG_374
	Skinshops[#Skinshops+1] = { -1441.49,-1760.65,14.81,269.3 } -- QG_374
	Skinshops[#Skinshops+1] = { -1440.76,-1752.13,14.34,277.8 } -- QG_374
	Skinshops[#Skinshops+1] = { -1050.32,-2011.89,13.16,226.78 } -- mecanica
	Skinshops[#Skinshops+1] = { 1133.63,-1518.37,34.84,66.08 } -- paramedic / hp
	Skinshops[#Skinshops+1] = { 2522.22,-422.85,94.58,20.02 }
	Skinshops[#Skinshops+1] = { 1472.13,6539.47,18.64,269.45 }
	Skinshops[#Skinshops+1] = { 676.73,909.14,247.57,164.41 } -- QG_302
	Skinshops[#Skinshops+1] = { 688.13,914.25,247.57,107.72 } -- QG_302
	-- Skinshops[#Skinshops+1] = { 676.75,907.61,252.58,181.42 } -- Mansao238
	-- Skinshops[#Skinshops+1] = { 655.22,923.82,252.6,53.86 } -- Mansao238
	-- Skinshops[#Skinshops+1] = { 651.96,924.78,252.58,257.96 } -- Mansao238
	-- Skinshops[#Skinshops+1] = { 676.79,909.12,247.57,161.58 } -- Mansao238
	Skinshops[#Skinshops+1] = { -3485.3,2799.67,22.01,357.17 } -- Mansao161
	Skinshops[#Skinshops+1] = { -3467.55,2835.87,22.01,150.24 } -- Mansao161
	Skinshops[#Skinshops+1] = { -3816.19,-4488.65,15.26,343.17 } -- tatica
	Skinshops[#Skinshops+1] = { -414.12,1594.14,358.67,127.87 } -- QG_285
	Skinshops[#Skinshops+1] = { -460.06,1546.54,393.23,156.48 } -- QG_285
	Skinshops[#Skinshops+1] = { -554.14,1192.33,334.08,280.63 } -- AlphaA1
	Skinshops[#Skinshops+1] = { -575.98,1193.24,334.08,184.26 } -- AlphaA2
	Skinshops[#Skinshops+1] = { -604.07,1192.34,334.08,269.3 } -- AlphaA3
	Skinshops[#Skinshops+1] = { -628.87,1192.29,334.08,283.47 } -- AlphaA4
	Skinshops[#Skinshops+1] = { -543.57,1251.58,334.08,85.04 } -- AlphaB1
	Skinshops[#Skinshops+1] = { -568.49,1251.75,334.08,110.56 } -- AlphaB2
	Skinshops[#Skinshops+1] = { -593.38,1251.64,334.08,102.05 } -- AlphaB3
	Skinshops[#Skinshops+1] = { -618.02,1251.67,334.08,87.88 } -- AlphaB4
	Skinshops[#Skinshops+1] = { -2349.97,3266.35,32.81,154.02 }
	Skinshops[#Skinshops+1] = { -1691.65,-1127.63,14.01,323.37 }
	Skinshops[#Skinshops+1] = { -1694.43,-1125.29,14.01,321.56 }
	Skinshops[#Skinshops+1] = { -1692.71,-1134.14,14.01,222.41 }
	Skinshops[#Skinshops+1] = { -1514.82,-1468.04,6.39,206.93 } -- Atlantis
	Skinshops[#Skinshops+1] = { 530.76,-1982.72,25.36,201.26 }
	Skinshops[#Skinshops+1] = { 749.5,-285.5,59.72,116.23 } -- QG_238
	Skinshops[#Skinshops+1] = { -303.6,220.62,77.91,189.93 } -- QG_234
	Skinshops[#Skinshops+1] = { 4640.87,-4815.28,25.95,131.72 } -- mansao98
	Skinshops[#Skinshops+1] = { -3536.63,4623.20,6.72,287.43 } -- mansao96
	-- Skinshops[#Skinshops+1] = { 791.97,5736.84,702.57,76.54 } -- mansao90
	Skinshops[#Skinshops+1] = { 2023.49,-1600.29,258.50,347.38 } -- mansao101
	Skinshops[#Skinshops+1] = { 1997.74,4296.12,43.27,28.35 } -- mansao118
	Skinshops[#Skinshops+1] = { 774.4,1286.67,370.26,85.04 } -- mansao120
	Skinshops[#Skinshops+1] = { -795.55,-1349.70,5.15,120.98 } -- Tatica
	Skinshops[#Skinshops+1] = { -699.43,-1434.45,5.02,203.45 } -- Militar
	Skinshops[#Skinshops+1] = { -776.59,-1321.66,9.60,289.27 } -- Militar
	Skinshops[#Skinshops+1] = { 2517.92,-346.08,101.89,36.86 } -- Militar
	Skinshops[#Skinshops+1] = { 2508.49,-442.21,106.91,76.54 } -- Militar
	Skinshops[#Skinshops+1] = { 2612.27,5333.94,47.57,59.53 } -- Prf
	Skinshops[#Skinshops+1] = { -699.67,-1299.11,5.40,51.70 } -- Civil
	Skinshops[#Skinshops+1] = { -1205.07,-891.86,13.88,303.31 } -- Empresa1
	Skinshops[#Skinshops+1] = { 129.79,-99.03,49.57,161.58 } -- QG_106
	Skinshops[#Skinshops+1] = { -417.98,4372.91,61.35,184.26 } -- mansao94
	Skinshops[#Skinshops+1] = { 101.29,-1311.01,21.13,25.52 } -- QG_422
	Skinshops[#Skinshops+1] = { -632.41,-134.04,43.22,93.55 } -- Bombeiros
	Skinshops[#Skinshops+1] = { 1680.34,3599.86,35.59,36.59 } -- Bombeiros norte
	Skinshops[#Skinshops+1] = { 1150.45,-1583.11,35.28,323.15 } -- hp
	Skinshops[#Skinshops+1] = { -336.9,-165.99,44.58,2.84 } -- mecanica
	Skinshops[#Skinshops+1] = { 457.64,-990.77,30.68,11.34 } -- dp praça
	Skinshops[#Skinshops+1] = { -951.75,-2042.66,9.4,226.78} -- dp principal
	Skinshops[#Skinshops+1] = { 176.33,669.34,207.66,85.04 } -- Galaxy
	Skinshops[#Skinshops+1] = { 1076.15,3266.02,38.6,226.78 } -- Verde
	Skinshops[#Skinshops+1] = { 1882.0,6400.07,48.53,175.75 }-- marrons
	Skinshops[#Skinshops+1] = { -2305.71,-251.61,48.14,127.56 } -- Gang4
	Skinshops[#Skinshops+1] = { 1502.54,1517.99,108.16,348.67 } -- Marrom
	Skinshops[#Skinshops+1] = { 747.78,-308.18,59.8,306.15 } -- Campinho
	Skinshops[#Skinshops+1] = { 1165.34,-142.11,59.55,226.78 } -- Vermelho
	Skinshops[#Skinshops+1] = { 1797.05,441.96,172.34,59.53 } -- Azul
	Skinshops[#Skinshops+1] = { -458.91,-1264.9,25.48,51.03 } -- Afetados
	Skinshops[#Skinshops+1] = { 875.42,1860.9,142.5,226.78 } -- Metgala
	Skinshops[#Skinshops+1] = { 2133.61,-15.7,227.22,45.36 } -- Rosa
	Skinshops[#Skinshops+1] = { 2798.91,2661.26,82.34,34.02 } -- Sindicato
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { -566.38,279.92,82.97,79.38 } -- Tequilas
	Skinshops[#Skinshops+1] = { 2742.47,3500.22,61.3,357.17} -- Kraken
	-- Skinshops[#Skinshops+1] = { -1046.14,309.93,66.99,206.93 } -- inglaterra
	Skinshops[#Skinshops+1] = { 3606.11,3729.53,29.69,343.0 } -- Groove
	Skinshops[#Skinshops+1] = { 2115.64,3886.09,33.23,215.44 } -- Roxo
	Skinshops[#Skinshops+1] = { 358.11,-2033.39,22.39,48.19 } -- Vagos
	Skinshops[#Skinshops+1] = { 89.54,-1989.74,20.41,314.65 } -- Ballas
	Skinshops[#Skinshops+1] = { 103.51,3613.09,40.49,175.75 } -- Laranja
	Skinshops[#Skinshops+1] = { 1033.47,916.33,222.06,11.34 } -- Bahamas
	Skinshops[#Skinshops+1] = { 963.86,18.02,75.74,144.57 } -- Bellagio
	Skinshops[#Skinshops+1] = { -141.41,-1608.56,35.03,51.03 } -- Redline
	Skinshops[#Skinshops+1] = { -203.27,-1330.04,34.9,127.56 } -- Undergrounds
	Skinshops[#Skinshops+1] = { 1382.88,-2093.85,47.21,31.19 } -- fazer
	Skinshops[#Skinshops+1] = { 2361.62,5647.1,92.71,141.74 } -- Topgear
	Skinshops[#Skinshops+1] = { 2513.83,4107.05,38.59,243.78 } -- Jamakeikos
	Skinshops[#Skinshops+1] = { -1149.56,-1554.59,7.63,153.08 } -- bandoleros
	Skinshops[#Skinshops+1] = { 556.33,-2773.46,6.08,59.53 } -- Gang5
	Skinshops[#Skinshops+1] = { 99.06,1229.61,207.17,345.83 } -- Mayans
	Skinshops[#Skinshops+1] = { 1028.6,-2550.72,32.28,351.5 } -- soa
	Skinshops[#Skinshops+1] = { -641.82,-1240.5,11.54,42.52 } -- hellsangels
	Skinshops[#Skinshops+1] = { 3234.18,5120.17,20.15,116.23 }
	Skinshops[#Skinshops+1] = { -303.6,220.58,77.91,11.34 } -- luxor
	Skinshops[#Skinshops+1] = { 2312.64,5568.36,51.91,343.0 } -- sinaloa
	Skinshops[#Skinshops+1] = { 1065.13,-1990.52,31.76,238.12 } -- gringa
	Skinshops[#Skinshops+1] = { -1813.92,446.95,127.91,306.15 } -- bloods
	Skinshops[#Skinshops+1] = { -1672.27,432.66,108.6,2.84 } -- crips
	Skinshops[#Skinshops+1] = { 355.53,-2729.49,1.7,56.7 } -- warlocks
	Skinshops[#Skinshops+1] = { -1814.54,447.96,127.91,351.5 } -- mexicana
	Skinshops[#Skinshops+1] = { -1514.29,832.99,181.59,22.68 } -- russia
	Skinshops[#Skinshops+1] = { -1491.07,845.77,181.59,87.88 } -- irlandesa
	Skinshops[#Skinshops+1] = { -277.37,1851.72,194.48,14.18 } -- triade
	Skinshops[#Skinshops+1] = { 420.53,-1483.85,33.8,116.23 } -- italiana
	Skinshops[#Skinshops+1] = { 2332.3,5524.54,51.68,249.45 } -- overdrive
	Skinshops[#Skinshops+1] = { -777.34,-2592.59,17.66,51.03 } -- Outlaws 
	Skinshops[#Skinshops+1] = { 956.47,-2390.61,22.33,22.68 } -- Topgear 
	Skinshops[#Skinshops+1] = { 1252.95,-1720.72,56.45,65.2 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1289.66,-1762.54,54.21,22.68 } -- LosAztecas
	Skinshops[#Skinshops+1] = { 1338.0,-792.43,71.51,343.0 } -- brancos
	Skinshops[#Skinshops+1] = { 1346.33,-705.11,67.74,73.71 } -- brancos
	Skinshops[#Skinshops+1] = { 1267.24,-299.03,84.59,158.75 } -- barragem
	Skinshops[#Skinshops+1] = { 1251.62,-265.92,77.91,107.72 } -- barragem
	Skinshops[#Skinshops+1] = { 1506.8,-2368.57,78.03,274.97 } -- rosas
	Skinshops[#Skinshops+1] = { 1512.78,-2365.16,78.03,195.6 } -- rosas
	-- Skinshops[#Skinshops+1] = { 2225.07,3452.81,61.33,172.92 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2229.55,3452.95,61.33,170.08 } -- cinzas
	-- Skinshops[#Skinshops+1] = { 2226.14,3453.91,61.33,187.09 } -- cinzas
	Skinshops[#Skinshops+1] = { 103.67,1221.91,207.17,102.05 } -- SOA
	Skinshops[#Skinshops+1] = { 1306.65,-735.32,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -215.34,-1334.28,34.9,266.46 } -- bennys
	Skinshops[#Skinshops+1] = { 1048.13,888.82,220.34,48.19 } -- playboy
	Skinshops[#Skinshops+1] = { 1341.91,-790.49,71.51,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { 1336.42,-788.7,71.51,348.67 } -- brancos
	Skinshops[#Skinshops+1] = { 1308.3,-733.85,65.09,340.16 } -- brancos
	Skinshops[#Skinshops+1] = { -1550.84,-393.9,41.97,51.03 } -- 
	Skinshops[#Skinshops+1] = { 2513.83,4107.05,38.59,243.78 } -- Jamakeikos
	Skinshops[#Skinshops+1] = { 1963.43,6415.17,61.7,311.82 } -- marrons
	Skinshops[#Skinshops+1] = { -2272.06,323.23,174.6,22.68 }
	-- Skinshops[#Skinshops+1] = { -1687.17,-3185.18,14.0,243.78 }
	Skinshops[#Skinshops+1] = { 1402.74,1154.66,114.33,266.46 } -- fazendinha
	Skinshops[#Skinshops+1] = { 747.78,-308.18,59.8,306.15 } -- Campinho
	Skinshops[#Skinshops+1] = { 884.07,349.15,112.56,141.07 } -- Japao
	Skinshops[#Skinshops+1] = { 1402.74,1154.66,114.33,266.46 } -- fazendinha
	Skinshops[#Skinshops+1] = { 134.68,-369.75,50.33,17.01 } -- Big
	Skinshops[#Skinshops+1] = { 883.73,-2100.55,30.46,175.75 } -- CarClube
	Skinshops[#Skinshops+1] = { 414.94,-23.43,91.93,56.7 } -- Callisto
	Skinshops[#Skinshops+1] = { 736.58,-806.95,16.28,357.17 } -- Arcade
	-- Skinshops[#Skinshops+1] = { -337.81,-166.57,44.58,272.13 } -- Virtude
	Skinshops[#Skinshops+1] = { -2022.42,4435.69,53.09,345.83 } -- Banzas
	Skinshops[#Skinshops+1] = { -339.2,-1523.7,29.34,22.68 } -- Dixavas

	Skinshops[#Skinshops+1] = { 5026.55,-5760.97,15.77,232.45 } -- Caribe
	Skinshops[#Skinshops+1] = { 3088.32,5091.99,23.25,73.71 } -- qg_80
	Skinshops[#Skinshops+1] = { -1179.62,302.46,73.67,102.05 } -- qg_82
	Skinshops[#Skinshops+1] = { -1226.24,-1737.73,4.53,138.9 } -- qg_83
	Skinshops[#Skinshops+1] = { -2423.52,1790.06,185.48,39.69 } -- qg_84
	Skinshops[#Skinshops+1] = { -878.0,-1434.81,7.53,201.26 } -- qg_85
	Skinshops[#Skinshops+1] = { -3337.8,543.54,17.44,215.44 } -- mansao 60
	-- arenas
	Skinshops[#Skinshops+1] = { -1868.47,5791.96,209.38,209.77 } -- Arena Fazenda
	Skinshops[#Skinshops+1] = { -1575.78,5913.55,213.54,300.48 } -- Arena Prédio
	-- vanilla
	Skinshops[#Skinshops+1] = { 133.55,-1296.23,-84.25,269.3 }
	Skinshops[#Skinshops+1] = { 135.62,-1319.09,-84.25,79.38 }
	Skinshops[#Skinshops+1] = { 119.78,-1313.3,-84.25,229.61 }
	Skinshops[#Skinshops+1] = { 106.22,-1319.56,-84.25,14.18 }
	Skinshops[#Skinshops+1] = { 119.75,-1305.41,-84.25,19.85 }
	Skinshops[#Skinshops+1] = { 105.63,-1297.38,-84.13,11.34 }
	Skinshops[#Skinshops+1] = { 127.17,-1296.73,-84.25,277.8 }
	Skinshops[#Skinshops+1] = { -1136.33,-2076.44,21.28,223.94 } -- mecanica
	
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
-- CreateThread(function()
-- 	local Tables = {}

-- 	for Number = 1,#Skinshops do
-- 		Tables[#Tables + 1] = { Skinshops[Number][1],Skinshops[Number][2],Skinshops[Number][3],2.0,"E","Loja de Roupas","Pressione para abrir" }
-- 	end

-- 	TriggerEvent("hoverfy:Insert",Tables)
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
-- CreateThread(function()
-- 	while true do
-- 		local TimeDistance = 999
-- 		if LocalPlayer["state"]["Route"] < 900000 then
-- 			local Ped = PlayerPedId()
-- 			if not IsPedInAnyVehicle(Ped) then
-- 				local Coords = GetEntityCoords(Ped)

-- 				for Number = 1,#Skinshops do
-- 					local Distance = #(Coords - vec3(Skinshops[Number][1],Skinshops[Number][2],Skinshops[Number][3]))
-- 					if Distance <= 2 then
-- 						TimeDistance = 1

-- 						if IsControlJustPressed(0,38) and not exports["hud"]:Wanted() and not exports["hud"]:Reposed() then
--                             if not LocalPlayer["state"]["Plaster"] then
--                                 OpenSkinshop()
--                             end
-- 						end
-- 					end
-- 				end
-- 			end
-- 		end

-- 		Wait(TimeDistance)
-- 	end
-- end)

AddEventHandler('onResourceStart', function(resource)
    Wait(1500)
    if resource == "sleepless_interact" then
        StartInteraction()
    end

    if resource == GetCurrentResourceName() then
        StartInteraction()
    end
end)

AddEventHandler('playerSpawned', function(resource)
    StartInteraction()
end)

function StartInteraction()
    for Number = 1,#Skinshops do
        interact.addCoords({
            id = "skinshop:"..tostring(Number),
            coords = vec3(Skinshops[Number][1],Skinshops[Number][2],Skinshops[Number][3]),
            options = {
                {
                    label = _t("openSkinshop"),
                    icon = "shopping-bag",
                    onSelect = function(data)
                        OpenSkinshop(true)
                    end,
                    canInteract = function(entity, distance, coords, id)
                        return not exports["hud"]:Wanted() and not exports["hud"]:Reposed() and not LocalPlayer["state"]["Plaster"] and not exports["hud"]:Wanted() and not LocalPlayer["state"]["FFA"] and not LocalPlayer["state"]["PVP"] and not GlobalState["Restarting"] and LocalPlayer["state"]["Route"] < 900000
                    end
                }
            },
            renderDistance = 7.5,
            activeDistance = 1.5,
            cooldown = 1500
        })
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOP:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:Open")
AddEventHandler("skinshop:Open",function(Boolean,Variable)
	if LocalPlayer["state"]["character-creator-state"] or LocalPlayer['state']['snowball:match'] or LocalPlayer["state"]["minigame:active"] then
		return
	end

	TriggerEvent("dynamic:closeSystem")
    if Variable then
        local Ped = PlayerPedId()
        if IsPedFalling(Ped) then
            return
        end
        Newbie = true
        OpenSkinshop(false, false)
        vSERVER.Open()
        return
    end
	if not exports["hud"]:Wanted() and not exports["hud"]:Reposed() then
        local Ped = PlayerPedId()
        if IsPedFalling(Ped) then
            return
        end
        OpenSkinshop(false, Boolean == true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAXVALUES
-----------------------------------------------------------------------------------------------------------------------------------------
function MaxValues()
	local MaxValues = {}
	local Ped = PlayerPedId()
    local isMale = GetEntityModel(Ped) == GetHashKey("mp_m_freemode_01")
	for Index, dump in pairs(SharedClothingData) do
        local v = {}
        v["min"] = dump["min"]
        v["max"] = dump["max"]
        v["id"] = dump["id"]
        v["mode"] = dump["mode"]
        v["vips"] = dump["vips"]
        v["diamonds"] = dump["diamonds"]
        v["prices"] = dump["prices"]
        v["reset"] = dump["reset"]

		if v["mode"] == "variation" then
			v["item"] = GetNumberOfPedDrawableVariations(Ped,v["id"])
			v["texture"] = GetNumberOfPedTextureVariations(Ped,v["id"],GetPedDrawableVariation(Ped,v["id"])) - 1
		elseif v["mode"] == "prop" then
			v["item"] = GetNumberOfPedPropDrawableVariations(Ped,v["id"])
			v["texture"] = GetNumberOfPedPropTextureVariations(Ped,v["id"],GetPedPropIndex(Ped,v["id"])) - 1
		end

        if isMale then
            v["diamonds"] = v["diamonds"]["mp_m_freemode_01"]
            v["vips"] = v["vips"]["mp_m_freemode_01"]
            v["prices"] = v["prices"]["mp_m_freemode_01"]
        else
            v["diamonds"] = v["diamonds"]["mp_f_freemode_01"]
            v["vips"] = v["vips"]["mp_f_freemode_01"]
            v["prices"] = v["prices"]["mp_f_freemode_01"]
        end

        if isMale then
            v["reset"] = v["reset"]["mp_m_freemode_01"]
        else
            v["reset"] = v["reset"]["mp_f_freemode_01"]
        end

		if v["texture"] < 0 then
			v["texture"] = 0
		end
        MaxValues[Index] = v
	end

	return MaxValues
end

---@param category string?
---@return table
local function currentValueOfCategory(category)
	if not category then
		return copyClothingPart(nil)
	end

	return copyClothingPart(Dataset[category] or DEFAULT_DATASET[category])
end

---@param category string?
---@return table
local function fallbackMaxValueOfCategory(category)
	local clothingData = category and SharedClothingData[category] or nil

	return {
		min = clothingData and clothingData["min"] or 0,
		max = clothingData and clothingData["max"] or 0,
		id = clothingData and clothingData["id"] or 0,
		mode = clothingData and clothingData["mode"] or "variation",
		vips = {},
		diamonds = {},
		prices = {},
		reset = 0,
		item = 0,
		texture = 0,
	}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET DATASET FROM PED (sincroniza loja com o que está vestido no ped, ex.: atalhos F8)
-----------------------------------------------------------------------------------------------------------------------------------------
local function GetDatasetFromPed(ped)
	if not ped or not DoesEntityExist(ped) then
		return nil
	end
	local result = {}
	for tag, data in pairs(SharedClothingData) do
		if data.mode == "variation" and data.id then
			result[tag] = {
				item = GetPedDrawableVariation(ped, data.id),
				texture = GetPedTextureVariation(ped, data.id)
			}
		elseif data.mode == "prop" and data.id then
			local propDrawable = GetPedPropIndex(ped, data.id)
			result[tag] = {
				item = (propDrawable == -1) and 0 or propDrawable,
				texture = GetPedPropTextureIndex(ped, data.id)
			}
			if propDrawable == -1 and (tag == "hat" or tag == "ear" or tag == "watch" or tag == "bracelet") then
				result[tag].item = -1
			end
		end
	end
	return result
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENSKINSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function OpenSkinshop(openedFromClothingStore, openedByCommand)
	local isOpenedFromClothingStore = openedFromClothingStore == true
	local isOpenedByCommand = openedByCommand == true

	ResetSkinshopOpenOrigin()

	if LocalPlayer["state"]["character-creator-state"] then
		return false
	end

	if exports.inventory:IsPlayerInEvent() then
		TriggerEvent("Notify2","#cantDoAgain")
		return false
	end

	Bucket = LocalPlayer["state"]["Route"]
	if blockBuckets[Bucket] then
		return false
	end

	if cityName == "Universo" then
		local discordLink = exports.register:isDiscordValidated()
		if discordLink then
			TriggerEvent("register:openNewDiscordValidation")
			return false
		end
	end

	Command = isOpenedByCommand
	gOpenedFromClothingStore = isOpenedFromClothingStore

	local ped = PlayerPedId()

	if SkinshopClothingRulesPreview then
		SkinshopClothingRulesPreview.Refresh(true)
	end
	-- Sincronizar Dataset com o estado atual do ped (ex.: peças equipadas por atalho F8)
	if ( openHandlers.flags & eSkinshopOpenFlags.TEMPORARY_CUSTOMIZATION ) == 0 then
		local fromPed = GetDatasetFromPed(ped)
		if fromPed and next(fromPed) then
			for tag, v in pairs(fromPed) do
				if Dataset[tag] then
					Dataset[tag].item = v.item
					Dataset[tag].texture = v.texture
				end
			end
		end
	end

    FreezeEntityPosition(ped, true)
	local backupDataset = buildCompletedDataset(Dataset)
	LocalPlayer["state"]["Skinshop"] = backupDataset
	playerCustomization = backupDataset
	
	if openHandlers.flags & eSkinshopOpenFlags.TEMPORARY_CUSTOMIZATION ~= 0 then
		LocalPlayer["state"]["Skinshop"] = {
			["pants"] = { item = 0, texture = 0 },
			["arms"] = { item = 0, texture = 0 },
			["tshirt"] = { item = 0, texture = 0 },
			["torso"] = { item = 0, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["shoes"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["hat"] = { item = -1, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 }
		}
		Dataset = LocalPlayer["state"]["Skinshop"]
	end
	

	if not Command then
		TriggerServerEvent("skinshop:setBlockHandcuff", true)
	end

	if not Command then
        vSERVER.Open()
    end
    SendNUIMessage({ action = "setVisible", data = "" })

	vRP.playAnim(true,{"mp_sleep","bind_pose_180"},true)
    CachedCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.25,1.0,0.0)

	SetNuiFocus(true,true)
	CameraActive()
    TriggerEvent("hud:Active",false)

    local visId = sx.client.visibility.beginVisibilityOverride()
    sx.client.visibility.addVisibilityOverrideExcludePlayer( visId, PlayerId() )

	return true
end

---@class ISkinShop.OpenWithFlags
---@field flags eSkinshopFlags
---@field customModel? number
---@field callback fun(cloth: table)

---@param data ISkinShop.OpenWithFlags
AddEventHandler("skinshop:open-with-flags",function(data)
	openHandlers = data

	if ( data.flags & eSkinshopOpenFlags.TEMPORARY_CUSTOMIZATION ) ~= 0 and data.customModel then
		playerModel = GetEntityModel(PlayerPedId())

		RequestModel(data.customModel)
		while not HasModelLoaded(data.customModel) do
			Wait(0)
		end
		
		SetPlayerModel(PlayerId(), data.customModel)
		SetPedDefaultComponentVariation(PlayerPedId())

		while GetEntityModel(PlayerPedId()) ~= data.customModel do
			Wait(0)	
		end
	end

	OpenSkinshop(false, false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAMERAACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
local function UpdateCameraBasedOnInit()
	local Ped = PlayerPedId()
    if not CachedCoords then
        CachedCoords = GetOffsetFromEntityInWorldCoords(Ped,0.25,1.0,0.0)
    end

	if Init == "hat" then
		SetCamCoord(Camera,CachedCoords["x"],CachedCoords["y"],CachedCoords["z"] + 0.45)
    elseif Init == "mask" then
        SetCamCoord(Camera,CachedCoords["x"],CachedCoords["y"],CachedCoords["z"] + 0.45)
	elseif Init == "shirt" then
		SetCamCoord(Camera,CachedCoords["x"],CachedCoords["y"],CachedCoords["z"] + 0.25)
	elseif Init == "pants" then
		SetCamCoord(Camera,CachedCoords["x"],CachedCoords["y"],CachedCoords["z"] - 0.45)
	elseif Init == "watch" then
		SetCamCoord(Camera,CachedCoords["x"],CachedCoords["y"],CachedCoords["z"] + 0.05)
    elseif Init == "bracelet" then
        SetCamCoord(Camera,CachedCoords["x"],CachedCoords["y"],CachedCoords["z"] + 0.05)
    elseif Init == "arms" then
        SetCamCoord(Camera,CachedCoords["x"],CachedCoords["y"],CachedCoords["z"] + 0.15)
    elseif Init == "vest" then
        SetCamCoord(Camera,CachedCoords["x"],CachedCoords["y"],CachedCoords["z"] + 0.15)
    elseif Init == "shoes" then
        SetCamCoord(Camera,CachedCoords["x"],CachedCoords["y"],CachedCoords["z"] - 0.75)
    else
        SetCamCoord(Camera,CachedCoords["x"],CachedCoords["y"],CachedCoords["z"] + 0.25)
	end
end

function CameraActive(Number,NPC)
	if DoesCamExist(Camera) then
		RenderScriptCams(false,false,0,false,false)
		SetCamActive(Camera,false)
		DestroyCam(Camera,false)
		Camera = nil
	end

	local Ped = PlayerPedId()

	if Number then
		SetEntityCoords(Ped,Skinshops[Number][1],Skinshops[Number][2],Skinshops[Number][3] - 1)
		SetEntityHeading(Ped,Skinshops[Number][4])
	end

    if NPC then
        SetEntityCoords(Ped,NPC["x"],NPC["y"],NPC["z"] - 1)
        SetEntityHeading(Ped,NPC["w"])
    end

	local Heading = GetEntityHeading(Ped)
	Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA",true)
    UpdateCameraBasedOnInit()

	RenderScriptCams(true,true,100,true,true)
	SetCamRot(Camera,0.0,0.0,Heading + 180)
	SetEntityHeading(Ped,Heading)
	SetCamActive(Camera,true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLY
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Apply",function(Data,Ped, canUseBlockedClothing)
	if nsdbg then
		sx.logger:debug( ('[nsdbg] skinshop Apply(export) ped=%s exists=%s'):format( tostring( Ped ), tostring( Ped ~= nil and DoesEntityExist( Ped ) ) ) )
	end
	if not Ped then
		Ped = PlayerPedId()
	end

	local visualData = buildCompletedDataset(Data or Dataset)

	visualData = filterVisualDataset(visualData, Ped, canUseBlockedClothing)
	for _, category in ipairs(gApplyCategoryOrder) do
		local info = visualData[category]

		if info then
			SkinshopClothingVisual.ApplyCategory(Ped, category, info["item"], info["texture"], 1)
		end
	end

	TriggerEvent('net.clothingMetrics.scan')
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESKINSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("getDataOfCategory", function(tag, Callback)
	local Ped = PlayerPedId()
	local isMale = GetEntityModel(Ped) == GetHashKey("mp_m_freemode_01")
	local category = SkinshopClothingRuleTypes.normalizeCategory(tag)
	local maxValues = MaxValues()
	local currentsOfTag = currentValueOfCategory(category)
	local maxsOfTag = category and maxValues[category] or nil
	local playerGroups = vRP.GetPlayerGroups() or {}
	local isVip = (playerGroups["Bruce"] ~= nil) or (playerGroups["Estrelinha"] ~= nil)

	Callback({
		current = currentsOfTag,
		max = maxsOfTag or fallbackMaxValueOfCategory(category),
		isVip = isVip,
		isMale = isMale
	})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateDataOfCategory",function(Data,Callback)
	Data = type(Data) == "table" and Data or {}

	local currentDataset = Dataset
	local category = SkinshopClothingRuleTypes.normalizeCategory(Data["category"])

    if Data["item"] ~= nil and Data["texture"] ~= nil and category and currentDataset[category] then
		local ped = PlayerPedId()

		if canUseVisualPart(category, Data["item"], Data["texture"], ped) then
			currentDataset[category]["item"] = Data["item"]
			currentDataset[category]["texture"] = Data["texture"]
			-- ponytail: NÃO escrever em state.Skinshop aqui — desde #5223 ele guarda o backup
			-- usado pra restaurar no cancel; sobrescrever fazia o cancel salvar a roupa (ENG-2327)
			SkinshopClothingVisual.ApplyCategory(ped, category, Data["item"], Data["texture"], 1)
			TriggerEvent('net.clothingMetrics.scan')
		end
    end

	Callback(MaxValues())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
--RegisterNUICallback("buyDataOfCategory",function(Data,Callback)
--    local isMale = GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01")
--    local success = vSERVER.tryBuyCloth(Data["category"], Data["item"], isMale)
--    if success then
--        local newData = LocalPlayer["state"]["Skinshop"]
--        newData[Data["category"]]["item"] = Data["item"]
--        newData[Data["category"]]["texture"] = Data["texture"]
--        vSERVER.Update(newData)
--    end
--	Callback("Ok")
--end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateCamera",function(Data,Callback)
	Init = Data
    UpdateCameraBasedOnInit()

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("getIsFirstLogin",function(Data,Callback)
	Callback(LocalPlayer["state"]["FirstLogin"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("save",function(Data,Callback)
	local openedByCommand = Command
	local openedFromClothingStore = gOpenedFromClothingStore

	if DoesCamExist(Camera) then
		RenderScriptCams(false,false,0,false,false)
		SetCamActive(Camera,false)
		DestroyCam(Camera,false)
		Camera = nil
	end
    if not openedByCommand then
        vSERVER.Cancel()
    end
    ResetSkinshopOpenOrigin()

	if ( openHandlers.flags & eSkinshopOpenFlags.TEMPORARY_CUSTOMIZATION ) == 0 then
		local outfitChanged = openedFromClothingStore and not openedByCommand and HasClothingDatasetChanged(Dataset, LocalPlayer["state"]["Skinshop"])
		vSERVER.Update(Dataset, outfitChanged, false)
	end

	if ( openHandlers.flags & eSkinshopOpenFlags.TEMPORARY_CUSTOMIZATION ) ~= 0 then
		OnRestoreApparence()
		openHandlers.callback(Dataset)
	end

	openHandlers = { flags = 0 }
	TriggerEvent("vrp:removeObjects")
    if Newbie then
        vSERVER.Cancel()
        Newbie = false
    end
	SetNuiFocus(false,false)
    TriggerEvent("hud:Active", true)
    Callback("Ok")
    FreezeEntityPosition(PlayerPedId(),false)
	sx.client.visibility.endVisibilityOverride()
	TriggerServerEvent("skinshop:setBlockHandcuff", false)

	TriggerEvent('hud:syncConfig')
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESET
-----------------------------------------------------------------------------------------------------------------------------------------
local function CloseSkinshopFrame()
	if ( openHandlers.flags & eSkinshopOpenFlags.TEMPORARY_CUSTOMIZATION ) ~= 0 then
		OnRestoreApparence()
		openHandlers.callback({})
	end

	openHandlers = { flags = 0 }

	if DoesCamExist(Camera) then
		RenderScriptCams(false,false,0,false,false)
		SetCamActive(Camera,false)
		DestroyCam(Camera,false)
		Camera = nil
	end

	exports["skinshop"]:Apply(LocalPlayer["state"]["Skinshop"])

	if not Command then
		vSERVER.Cancel()
	end

	ResetSkinshopOpenOrigin()
	Dataset = LocalPlayer["state"]["Skinshop"]
	LocalPlayer["state"]["Skinshop"] = {}
	TriggerServerEvent("skinshop:setBlockHandcuff", false)

	SetNuiFocus(false,false)
	FreezeEntityPosition(PlayerPedId(),false)
	SendNUIMessage({ action = "setVisible", data = false })
	TriggerEvent("hud:Active",true)
	TriggerEvent("vrp:removeObjects")

	if Newbie then
		if LocalPlayer["state"]["DefaultSpawn"] then
			TriggerEvent("talknpc:NpcVovo2")
		else
			TriggerEvent("talknpc:NpcVovo")
		end
		Newbie = false
	end

	sx.client.visibility.endVisibilityOverride()

	TriggerEvent("hud:syncConfig")
end

RegisterNUICallback("hideFrame",function(Data,Callback)
	if LocalPlayer["state"]["FirstLogin"] then
		return
	end

	CloseSkinshopFrame()

	Callback("Ok")
end)

RegisterNetEvent("skinshop:ForceClose", function()
	if not DoesCamExist(Camera) then
		return
	end

	CloseSkinshopFrame()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Rotate",function(Data,Callback)
	local Ped = PlayerPedId()

	if Data == "Left" then
		SetEntityHeading(Ped,GetEntityHeading(Ped) - 5)
	elseif Data == "Right" then
		SetEntityHeading(Ped,GetEntityHeading(Ped) + 5)
	elseif Data == "Top" then
		local Coords = GetCamCoord(Camera)
		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] + 0.05)
	elseif Data == "Bottom" then
		local Coords = GetCamCoord(Camera)
		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] - 0.05)
	end

	Callback("Ok")
end)

local exec_functions_by_component_id = {

	-- mask
	[ 1 ] = function( pedId )

		Animation = true
		vRP.playAnim( true, { "missfbi4", "takeoff_mask" }, true )

		SetTimeout( 1000, function( )

			local drawableVariation = GetPedDrawableVariation( pedId, 1 )
	
			if drawableVariation == Dataset.mask.item then

				SetPedComponentVariation( pedId, 1, 0, 0, 1 )
			else

				SetPedComponentVariation( pedId, 1, Dataset.mask.item, Dataset.mask.texture, 1 )
			end
	
			Animation = false

			TriggerEvent( "vrp:removeObjects" )
		end)


	end,

	-- hat
	[ 2 ] = function( pedId )

		Animation = true
		vRP.playAnim( true, { "mp_masks@standard_car@ds@", "put_on_mask" }, true )

		SetTimeout( 1000, function( )

			local propIndex = GetPedPropIndex( pedId, 0 )
	
			if propIndex == Dataset.hat.item then

				ClearPedProp( pedId, 0 )
			else

				SetPedPropIndex( pedId, 0, Dataset.hat.item, Dataset.hat.texture, 1 )
			end
	
			Animation = false

			TriggerEvent( "vrp:removeObjects" )
		end)

	end,

	-- glasses
	[ 3 ] = function( pedId )
		
		Animation = true
		vRP.playAnim( true, { "clothingspecs", "take_off" }, true )

		SetTimeout( 1000, function( )

			local propIndex = GetPedPropIndex( pedId, 1 )
	
			if propIndex == Dataset.glass.item then

				ClearPedProp( pedId, 1 )
			else

				SetPedPropIndex( pedId, 1, Dataset.glass.item, Dataset.glass.texture, 1 )
			end
	
			Animation = false

			TriggerEvent( "vrp:removeObjects" )
		end)

	end,
}

---@param _componentId string -- dynamic envia parametros como string...
AddEventHandler( "net.clothes.req_set_component_from_ped", function( _componentId )

	local componentId = tonumber( _componentId )

	local pedId = PlayerPedId( )

    if IsPedInAnyVehicle( pedId, true ) then

        -- esta dentro do veiculo ?

        return  
    end

    local nearbyPlayers = sx.client.spatial.findPlayersNearby( 2.0, 1 )

    TriggerServerEvent( "net.clothes.req_set_component_from_ped", nearbyPlayers, componentId )

end)

---@param componentId number
RegisterNetEvent( "net.clothes.set_component_from_ped", function( componentId )

	if Animation or LocalPlayer.state.Buttons then

		-- esta com alguma animação em andamento ?

		return
	end

	local pedId = PlayerPedId( )

	exec_functions_by_component_id[ componentId ]( pedId )

end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSHOES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkShoes()
	local Number = 34
	local Ped = PlayerPedId()
	if GetEntityModel(Ped) == GetHashKey("mp_f_freemode_01") then
		Number = 35
	end
	if Dataset["shoes"]["item"] ~= Number then
		Dataset["shoes"]["item"] = Number
		Dataset["shoes"]["texture"] = 0
		SetPedComponentVariation(Ped,6,Dataset["shoes"]["item"],Dataset["shoes"]["texture"],1)

		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CUSTOMIZATION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Customization()
	return Dataset
end

RegisterNetEvent("skinshop:Open:NPC")
AddEventHandler("skinshop:Open:NPC",function(coords)
    TriggerEvent("talknpc:closeTalk")
    OpenSkinshop(true)
end)

RegisterNetEvent('register:Open')
AddEventHandler('register:Open',function()
    SendNUIMessage({ action = "setVisible", data = false })
    SetNuiFocus(false,false)
    FreezeEntityPosition(PlayerPedId(),false)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SETMASCARA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('setmascara')
AddEventHandler('setmascara',function(modelo,cor)
	local ped = PlayerPedId()

	if not canUseVisualPart("mask", modelo, cor, ped) then
		return
	end
	if GetEntityHealth(ped) > 101 then
		if modelo == nil then
			vRP.playAnim(true,{"missfbi4","takeoff_mask"},false)
			Wait(1100)
			vRP._stopAnim(true)
			SetPedComponentVariation(ped,1,0,0,2)
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") or GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			vRP.playAnim(true,{"misscommon@van_put_on_masks","put_on_mask_ps"},false)
			Wait(1500)
			vRP._stopAnim(true)
			SetPedComponentVariation(ped,1,parseInt(modelo),parseInt(cor),2)
		end
        local DataSet = LocalPlayer["state"]["Skinshop"] or Dataset
        if not DataSet["mask"] then DataSet["mask"] = { item = 0, texture = 0 } end
        DataSet["mask"]["item"] = parseInt(modelo)
        DataSet["mask"]["texture"] = parseInt(cor)
        LocalPlayer["state"]["Skinshop"] = DataSet
        Dataset = DataSet
        vSERVER.Update(DataSet)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETBLUSA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('setblusa')
AddEventHandler('setblusa',function(modelo,cor)
	local ped = PlayerPedId()

	if not canUseVisualPart("tshirt", modelo, cor, ped) then
		return
	end
	if GetEntityHealth(ped) > 101  then
		if not modelo then
			vRP.playAnim(true,{"clothingshirt","try_shirt_positive_d"},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,8,15,0,2)
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			vRP.playAnim(true,{"clothingshirt","try_shirt_positive_d"},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,8,parseInt(modelo),parseInt(cor),2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			vRP.playAnim(true,{"clothingshirt","try_shirt_positive_d"},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,8,parseInt(modelo),parseInt(cor),2)
		end
        local DataSet = LocalPlayer["state"]["Skinshop"] or Dataset
        if not DataSet["tshirt"] then DataSet["tshirt"] = { item = 0, texture = 0 } end
        DataSet["tshirt"]["item"] = parseInt(modelo)
        DataSet["tshirt"]["texture"] = parseInt(cor)
        LocalPlayer["state"]["Skinshop"] = DataSet
        Dataset = DataSet
        vSERVER.Update(DataSet)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETCOLETE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('setcolete')
AddEventHandler('setcolete',function(modelo,cor)
	local ped = PlayerPedId()

	if not canUseVisualPart("vest", modelo, cor, ped) then
		return
	end
	if GetEntityHealth(ped) > 101  then
		if not modelo then
			vRP.playAnim(true,{"clothingshirt","try_shirt_positive_d"},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,9,0,0,2)
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			vRP.playAnim(true,{"clothingshirt","try_shirt_positive_d"},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,9,parseInt(modelo),parseInt(cor),2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			vRP.playAnim(true,{"clothingshirt","try_shirt_positive_d"},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,9,parseInt(modelo),parseInt(cor),2)
		end
        local DataSet = LocalPlayer["state"]["Skinshop"] or Dataset
        if not DataSet["vest"] then DataSet["vest"] = { item = 0, texture = 0 } end
        DataSet["vest"]["item"] = parseInt(modelo)
        DataSet["vest"]["texture"] = parseInt(cor)
        LocalPlayer["state"]["Skinshop"] = DataSet
        Dataset = DataSet
        vSERVER.Update(DataSet)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETJAQUETA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('setjaqueta')
AddEventHandler('setjaqueta',function(modelo,cor)
	local ped = PlayerPedId()

	if not canUseVisualPart("torso", modelo, cor, ped) then
		return
	end
	if GetEntityHealth(ped) > 101  then
		if not modelo then
			vRP.playAnim(true,{"clothingshirt","try_shirt_positive_d"},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,11,15,0,2)
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			vRP.playAnim(true,{"clothingshirt","try_shirt_positive_d"},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,11,parseInt(modelo),parseInt(cor),2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			vRP.playAnim(true,{"clothingshirt","try_shirt_positive_d"},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,11,parseInt(modelo),parseInt(cor),2)
		end
        local DataSet = LocalPlayer["state"]["Skinshop"] or Dataset
        if not DataSet["torso"] then DataSet["torso"] = { item = 0, texture = 0 } end
        DataSet["torso"]["item"] = parseInt(modelo)
        DataSet["torso"]["texture"] = parseInt(cor)
        LocalPlayer["state"]["Skinshop"] = DataSet
        Dataset = DataSet
        vSERVER.Update(DataSet)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETMAOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('setmaos')
AddEventHandler('setmaos',function(modelo,cor)
	local ped = PlayerPedId()

	if not canUseVisualPart("arms", modelo, cor, ped) then
		return
	end
	if GetEntityHealth(ped) > 101 then
		if not modelo then
			vRP.playAnim(true,{"clothingshirt","try_shirt_positive_d"},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,3,15,0,2)
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			vRP.playAnim(true,{"clothingshirt","try_shirt_positive_d"},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,3,parseInt(modelo),parseInt(cor),2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			vRP.playAnim(true,{"clothingshirt","try_shirt_positive_d"},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,3,parseInt(modelo),parseInt(cor),2)
        end
        local DataSet = LocalPlayer["state"]["Skinshop"] or Dataset
        if not DataSet["arms"] then DataSet["arms"] = { item = 0, texture = 0 } end
        DataSet["arms"]["item"] = parseInt(modelo)
        DataSet["arms"]["texture"] = parseInt(cor)
        LocalPlayer["state"]["Skinshop"] = DataSet
        Dataset = DataSet
        vSERVER.Update(DataSet)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETCALCA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('setcalca')
AddEventHandler('setcalca',function(modelo,cor)
	local ped = PlayerPedId()

	if not canUseVisualPart("pants", modelo, cor, ped) then
		return
	end
	if GetEntityHealth(ped) > 101  then
		if not modelo then
			if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
				vRP.playAnim(true,{"clothingtrousers","try_trousers_neutral_c"},false)
				Wait(2500)
				ClearPedTasks(ped)
				SetPedComponentVariation(ped,4,18,0,2)
			elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
				vRP.playAnim(true,{"clothingtrousers","try_trousers_neutral_c"},false)
				Wait(2500)
				ClearPedTasks(ped)
				SetPedComponentVariation(ped,4,15,0,2)
			end
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			vRP.playAnim(true,{"clothingtrousers","try_trousers_neutral_c"},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,4,parseInt(modelo),parseInt(cor),2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			vRP.playAnim(true,{"clothingtrousers","try_trousers_neutral_c"},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,4,parseInt(modelo),parseInt(cor),2)
		end
        local DataSet = LocalPlayer["state"]["Skinshop"] or Dataset
        if not DataSet["pants"] then DataSet["pants"] = { item = 0, texture = 0 } end
        DataSet["pants"]["item"] = parseInt(modelo)
        DataSet["pants"]["texture"] = parseInt(cor)
        LocalPlayer["state"]["Skinshop"] = DataSet
        Dataset = DataSet
        vSERVER.Update(DataSet)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETACESSORIOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('setacessorios')
AddEventHandler('setacessorios',function(modelo,cor)
	local ped = PlayerPedId()

	if not canUseVisualPart("accessory", modelo, cor, ped) then
		return
	end
	if GetEntityHealth(ped) > 101 then
		if not modelo then
			SetPedComponentVariation(ped,7,0,0,2)
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			SetPedComponentVariation(ped,7,parseInt(modelo),parseInt(cor),2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			SetPedComponentVariation(ped,7,parseInt(modelo),parseInt(cor),2)
		end
        local DataSet = LocalPlayer["state"]["Skinshop"] or Dataset
        if not DataSet["accessory"] then DataSet["accessory"] = { item = 0, texture = 0 } end
        DataSet["accessory"]["item"] = parseInt(modelo)
        DataSet["accessory"]["texture"] = parseInt(cor)
        LocalPlayer["state"]["Skinshop"] = DataSet
        Dataset = DataSet
        vSERVER.Update(DataSet)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETSAPATOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('setsapatos')
AddEventHandler('setsapatos',function(modelo,cor)
	local ped = PlayerPedId()

	if not canUseVisualPart("shoes", modelo, cor, ped) then
		return
	end
	if GetEntityHealth(ped) > 101 and not IsPedInAnyVehicle(ped) then
		if not modelo then
			if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
				vRP.playAnim(false,{"clothingshoes","try_shoes_positive_d"},false)
				Wait(2200)
				SetPedComponentVariation(ped,6,34,0,2)
				Wait(500)
				ClearPedTasks(ped)
			elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
				vRP.playAnim(false,{"clothingshoes","try_shoes_positive_d"},false)
				Wait(2200)
				SetPedComponentVariation(ped,6,35,0,2)
				Wait(500)
				ClearPedTasks(ped)
			end
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			vRP.playAnim(false,{"clothingshoes","try_shoes_positive_d"},false)
			Wait(2200)
			SetPedComponentVariation(ped,6,parseInt(modelo),parseInt(cor),2)
			Wait(500)
			ClearPedTasks(ped)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			vRP.playAnim(false,{"clothingshoes","try_shoes_positive_d"},false)
			Wait(2200)
			SetPedComponentVariation(ped,6,parseInt(modelo),parseInt(cor),2)
			Wait(500)
			ClearPedTasks(ped)
		end
        local DataSet = LocalPlayer["state"]["Skinshop"] or Dataset
        if not DataSet["shoes"] then DataSet["shoes"] = { item = 0, texture = 0 } end
        DataSet["shoes"]["item"] = parseInt(modelo)
        DataSet["shoes"]["texture"] = parseInt(cor)
        LocalPlayer["state"]["Skinshop"] = DataSet
        Dataset = DataSet
        vSERVER.Update(DataSet)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETCHAPEU
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('setchapeu')
AddEventHandler('setchapeu',function(modelo,cor)
	local ped = PlayerPedId()

	if not canUseVisualPart("hat", modelo, cor, ped) then
		return
	end
	if GetEntityHealth(ped) > 101 then
		if not modelo then
			vRP.playAnim(true,{"veh@common@fp_helmet@","take_off_helmet_stand"},false)
			Wait(700)
			ClearPedProp(ped,0)
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") and parseInt(modelo) ~= 39 then
			vRP.playAnim(true,{"veh@common@fp_helmet@","put_on_helmet"},false)
			Wait(1700)
			SetPedPropIndex(ped,0,parseInt(modelo),parseInt(cor),2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") and parseInt(modelo) ~= 38 then
			vRP.playAnim(true,{"veh@common@fp_helmet@","put_on_helmet"},false)
			Wait(1700)
			SetPedPropIndex(ped,0,parseInt(modelo),parseInt(cor),2)
		end
        local DataSet = LocalPlayer["state"]["Skinshop"] or Dataset
        if not DataSet["hat"] then DataSet["hat"] = { item = -1, texture = 0 } end
        DataSet["hat"]["item"] = parseInt(modelo)
        DataSet["hat"]["texture"] = parseInt(cor)
        LocalPlayer["state"]["Skinshop"] = DataSet
        Dataset = DataSet
        vSERVER.Update(DataSet)
	end 
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETOCULOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('setoculos')
AddEventHandler('setoculos',function(modelo,cor)
	local ped = PlayerPedId()

	if not canUseVisualPart("glass", modelo, cor, ped) then
		return
	end
	if GetEntityHealth(ped) > 101 then
		if not modelo then
			vRP.playAnim(true,{"mini@ears_defenders","takeoff_earsdefenders_idle"},false)
			Wait(500)
			ClearPedTasks(ped)
			ClearPedProp(ped,1)
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			vRP.playAnim(true,{"misscommon@van_put_on_masks","put_on_mask_ps"},false)
			Wait(800)
			ClearPedTasks(ped)
			SetPedPropIndex(ped,1,parseInt(modelo),parseInt(cor),2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			vRP.playAnim(true,{"misscommon@van_put_on_masks","put_on_mask_ps"},false)
			Wait(800)
			ClearPedTasks(ped)
			SetPedPropIndex(ped,1,parseInt(modelo),parseInt(cor),2)
		end
        local DataSet = LocalPlayer["state"]["Skinshop"] or Dataset
        if not DataSet["glass"] then DataSet["glass"] = { item = 0, texture = 0 } end
        DataSet["glass"]["item"] = parseInt(modelo)
        DataSet["glass"]["texture"] = parseInt(cor)
        LocalPlayer["state"]["Skinshop"] = DataSet
        Dataset = DataSet
        vSERVER.Update(DataSet)
	end
end)


-- RegisterNetEvent("safezone:OpenVideo")
-- AddEventHandler("safezone:OpenVideo",function(url)
--     DoScreenFadeOut(0)
--     Wait(10000)
--     SendNUIMessage({
--         action = "setVisible",
--         data = "videoFull",
--     })
--     Wait(100)
--     SendNUIMessage({
--         action = "setVideoFull",
--         data = {
--             url = url,
--         }
--     })
--     DoScreenFadeIn(2500)
-- end)

function AddSkinshop(Name,Coords)
    local Name = "skinshop:"..Name
    interact.addCoords({
        id = Name,
        coords = vec3(Coords.x,Coords.y,Coords.z),
        options = {
            {
                label = _t("openSkinshop"),
                icon = "shopping-bag",
                onSelect = function(data)
                    OpenSkinshop(true)
                end,
                canInteract = function(entity, distance, coords, id)
                    return not exports["hud"]:Wanted() and not exports["hud"]:Reposed() and not LocalPlayer["state"]["Plaster"] and not exports["hud"]:Wanted() and not LocalPlayer["state"]["FFA"] and not LocalPlayer["state"]["PVP"] and not GlobalState["Restarting"] and LocalPlayer["state"]["Route"] < 900000
                end
            }
        },
        renderDistance = 7.5,
        activeDistance = 1.5,
        cooldown = 1500
    })
    return Name
end
exports("AddSkinshop",AddSkinshop)

function RemoveSkinshop(Name)
    interact.removeById(Name)
end
exports("RemoveSkinshop",RemoveSkinshop)
