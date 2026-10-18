-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
lang = GetConvar("language", "pt-br") or "pt-br"
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("target")
vPLAYER = Tunnel.getInterface("player")
SafeMode = GetConvar("SafeMode", "")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Zones = {}
local Models = {}
local Selected = {}
local Sucess = false
local Dismantleds = 1
cityName = GetConvar("cityName", "")
LocalPlayer["state"]["Carregar"] = false
LocalPlayer["state"]["Target"] = false
local callMechanicCooldown = GetGameTimer()

local SOCIAL_DIGIT_COLORS = {
    [1]  = { r = 240, g = 81, b = 107 }, -- background: rgba(240, 81, 107, 1);
    [2]  = { r = 143,  g = 193, b = 251 }, -- background: rgba(143, 193, 251, 1);
    [3]  = { r = 249,  g = 181, b = 54 }, -- background: rgba(249, 181, 54, 1);
	[4]  = { r = 152, g = 251, b = 143 }, -- background: rgba(152, 251, 143, 1);
	[5]  = { r = 246, g = 59, b = 184 }, -- background: rgba(246, 59, 184, 1);
	[6]  = { r = 72, g = 244, b = 204 }, -- background: rgba(72, 244, 204, 1);
	[7]  = { r = 251, g = 206, b = 143 }, -- background: rgba(251, 206, 143, 1);
	[8]  = { r = 111, g = 107, b = 229 }, -- background: rgba(111, 107, 229, 1);
	[9]  = { r = 189, g = 189, b = 43 }, -- background: rgba(189, 189, 43, 1);
    [10] = { r = 219, g = 73, b = 227 }, -- background: rgba(219, 73, 227, 1);
}
---------------------------------------------------------------------------------------------------------------------------------------
-- TOWS
-----------------------------------------------------------------------------------------------------------------------------------------
local Tows = {
	vec3(-142.24,-1174.19,23.76)
}
local VIPRanks = nil

function GetGroupByAlias(alias)
    local Table = GlobalState["AliasGroup"]
    for Group,Alias in pairs(Table) do
        if Alias == alias then
            return Group
        end
    end
    return alias
end

function CheckVIPRank(Group)
    if not VIPRanks then
        VIPRanks = GetVIPRanks()
    end
    if VIPRanks[Group] then
        return VIPRanks[Group]
    end
    return false
end

function GetAliasByGroup(group)
    local Table = GlobalState["AliasGroup"] or {}
    for Group,Alias in pairs(Table) do
        if Group:lower() == group:lower() then
            return Alias
        end
    end
    return group
end 

local function GetSocialColorIndex(level)
    local digit = level % 10
    if digit == 0 then
        digit = 10
    end
    return digit
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISMANTLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Dismantles = { -- desmanche
	vec3(943.23,-1497.87,30.11),
	vec3(-524.94,-1680.63,19.21),
	-- vec3(1358.14,-2095.41,52.0),
	vec3(602.47,-437.82,24.75),
	vec3(-413.86,-2179.29,10.31),
	-- vec3(1137.99,-794.32,57.59),
	vec3(-93.07,-2549.6,6.0),
	vec3(820.07,-488.43,30.46),
	vec3(1078.62,-2325.56,30.25),
	vec3(-223.39,-1699.13,34.04),
	
	
	
	vec3(2202.99,5557.24,54.05),
	-- vec3(-750.75,-2596.36,13.83), --Outlaws
	vec3(929.65,-2383.12,22.33), -- Topgear
	vec3(1204.69,-3116.71,5.54),
	vec3(-593.86,-1586.3,26.74) -- santa-galaxy overdrive
}
if cityName == "Santa" then 
	Dismantles[#Dismantles+1] = vec3(1137.99,-794.32,57.59)
	Dismantles[#Dismantles+1] = vec3(-750.75,-2596.36,13.83)
	Dismantles[#Dismantles+1] = vec3(-339.34,-135.91,38.93) -- redline
	Dismantles[#Dismantles+1] = vec3(-386.08,-92.33,54.42) -- redline
	Dismantles[#Dismantles+1] = vec3(2725.09,3470.55,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(2720.81,3460.37,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(139.76,-388.5,45.19) -- Big
	Dismantles[#Dismantles+1] = vec3(897.63,-2127.38,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(887.08,-2126.47,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(-317.41,-93.62,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(-324.6,-90.73,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(-234.07,-1317.3,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-236.98,-1339.75,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-232.15,-1278.39,31.29) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-562.23,-914.72,23.88) -- redline
	Dismantles[#Dismantles+1] = vec3(-582.77,-917.47,23.88) -- redline
	Dismantles[#Dismantles+1] = vec3(947.97,-2398.27,22.33) -- qg_67
	Dismantles[#Dismantles+1] = vec3(-1124.2,-1611.21,4.4) -- QG_47
	Dismantles[#Dismantles+1] = vec3(1409.93,-2055.74,52.0) -- QG_68
	Dismantles[#Dismantles+1] = vec3(146.51,320.62,112.14) 
	Dismantles[#Dismantles+1] = vec3(819.53,-822.27,26.18) 
	Dismantles[#Dismantles+1] = vec3(520.91,169.14,99.36) 
	Dismantles[#Dismantles+1] = vec3(-582.83,-924.61,23.88) -- QG_66
	Dismantles[#Dismantles+1] = vec3(-583.05,-931.81,23.88) -- QG_66
	Dismantles[#Dismantles+1] = vec3(114.36,-434.76,41.27) -- QG_13
	Dismantles[#Dismantles+1] = vec3(53.69,-419.95,40.15) 
	Dismantles[#Dismantles+1] = vec3(46.95,-448.43,39.95) 
	Dismantles[#Dismantles+1] = vec3(64.21,-443.05,40.25)
	Dismantles[#Dismantles+1] = vec3(-1172.57,-2037.65,13.75)
	Dismantles[#Dismantles+1] = vec3(67.18,6521.53,31.26) -- QG_327
	Dismantles[#Dismantles+1] = vec3(74.52,6532.33,31.41) -- QG_327
	Dismantles[#Dismantles+1] = vec3(21.83,6502.46,31.36) -- QG_327
	Dismantles[#Dismantles+1] = vec3(987.82,-146.82,74.24) -- QG_232
	Dismantles[#Dismantles+1] = vec3(985.63,-138.25,73.09) -- QG_232
	-- Dismantles[#Dismantles+1] = vec3(-3317.15,484.48,11.88) -- QG_90
	-- Dismantles[#Dismantles+1] = vec3(-3329.67,508.08,12.05) -- QG_90
	
elseif cityName == "CidadeNobre" then
	Dismantles[#Dismantles+1] = vec3(1137.99,-794.32,57.59)
	Dismantles[#Dismantles+1] = vec3(-2936.50,47.70,11.61) -- QG_59
	Dismantles[#Dismantles+1] = vec3(-750.75,-2596.36,13.83)
	Dismantles[#Dismantles+1] = vec3(-750.76,-2596.36,13.82)
	Dismantles[#Dismantles+1] = vec3(-2210.92,4229.61,48.31) -- QG_132
	Dismantles[#Dismantles+1] = vec3(-317.41,-93.62,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(-324.6,-90.73,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(897.63,-2127.38,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(887.08,-2126.47,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(121.48,-415.01,41.28) -- Big
	Dismantles[#Dismantles+1] = vec3(2725.09,3470.55,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(2720.81,3460.37,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(-234.07,-1317.3,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-236.98,-1339.75,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-232.15,-1278.39,31.29) -- Bennys
	-- Dismantles[#Dismantles+1] = vec3(1409.66,-2055.83,52.0) -- Ferrovelho
	-- Dismantles[#Dismantles+1] = vec3(-2297.52,449.87,174.46) -- redline
	Dismantles[#Dismantles+1] = vec3(-581.35,-931.76,23.88) -- redline
	Dismantles[#Dismantles+1] = vec3(691.21,-960.17,23.61) -- QG_108
	Dismantles[#Dismantles+1] = vec3(693.34,-1010.09,22.76) -- QG_108
	Dismantles[#Dismantles+1] = vec3(630.02,947.13,247.64) -- QG_121
	Dismantles[#Dismantles+1] = vec3(74.95,6531.80,31.41) -- QG_175
	Dismantles[#Dismantles+1] = vec3(78.14,6535.30,31.41) -- QG_175
	Dismantles[#Dismantles+1] = vec3(62.41,6517.29,31.26) -- QG_175
	-- Dismantles[#Dismantles+1] = vec3(2032.67,3350.14,46.80) -- QG_150
	-- Dismantles[#Dismantles+1] = vec3(2037.79,3379.81,46.80) -- QG_150
	Dismantles[#Dismantles+1] = vec3(55.84,-456.3,40.25) -- QG_168
	Dismantles[#Dismantles+1] = vec3(58.45,-444.69,40.25) -- QG_168
	Dismantles[#Dismantles+1] = vec3(61.09,-433.37,40.25) -- QG_168
	Dismantles[#Dismantles+1] = vec3(63.55,-422.25,40.25) -- QG_168
	Dismantles[#Dismantles+1] = vec3(55.15,-420.1,40.27) -- QG_168
	Dismantles[#Dismantles+1] = vec3(52.33,-431.49,40.24) -- QG_168
	Dismantles[#Dismantles+1] = vec3(49.72,-443.14,40.07) -- QG_168
	Dismantles[#Dismantles+1] = vec3(46.99,-454.74,40.17) -- QG_168
	Dismantles[#Dismantles+1] = vec3(146.51,320.62,112.14) 
	Dismantles[#Dismantles+1] = vec3(-1537.85,-577.49,25.71) 
	Dismantles[#Dismantles+1] = vec3(819.53,-822.27,26.18) 
	Dismantles[#Dismantles+1] = vec3(520.91,169.14,99.36) 
	Dismantles[#Dismantles+1] = vec3(1397.0,1095.31,114.33) -- QG_432
	Dismantles[#Dismantles+1] = vec3(1398.53,1087.27,114.33) -- QG_432
	Dismantles[#Dismantles+1] = vec3(1397.65,1079.25,114.33) -- QG_432
	Dismantles[#Dismantles+1] = vec3(1398.0,1071.17,114.33) -- QG_432
	-- Dismantles[#Dismantles+1] = vec3(-114.14,1021.07,235.93) -- QG_54
	Dismantles[#Dismantles+1] = vec3(-1172.57,-2037.65,13.75)
	Dismantles[#Dismantles+1] = vec3(1569.05,4073.57,39.24) -- QG_416
	Dismantles[#Dismantles+1] = vec3(1026.51,916.57,215.02) -- QG_23
	Dismantles[#Dismantles+1] = vec3(-1544.96,2546.91,21.11) -- QG_493

elseif cityName == "Boomerang" then
	Dismantles[#Dismantles+1] = vec3(1137.99,-794.32,57.59)
	Dismantles[#Dismantles+1] = vec3(-789.46,-2592.52,13.79) -- QG_55
	Dismantles[#Dismantles+1] = vec3(-317.41,-93.62,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(-324.6,-90.73,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(897.63,-2127.38,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(887.08,-2126.47,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(631.46,-2724.21,6.15) -- yakuza
	Dismantles[#Dismantles+1] = vec3(121.48,-415.01,41.28) -- Big
	Dismantles[#Dismantles+1] = vec3(2725.09,3470.55,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(2720.81,3460.37,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(-234.07,-1317.3,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-236.98,-1339.75,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-232.15,-1278.39,31.29) -- Bennys
	-- Dismantles[#Dismantles+1] = vec3(1409.66,-2055.83,52.0) -- Ferrovelho
	-- Dismantles[#Dismantles+1] = vec3(-2297.52,449.87,174.46) -- redline
	Dismantles[#Dismantles+1] = vec3(-581.35,-931.76,23.88) -- redline
	Dismantles[#Dismantles+1] = vec3(691.21,-960.17,23.61) -- QG_108
	Dismantles[#Dismantles+1] = vec3(693.34,-1010.09,22.76) -- QG_108
	Dismantles[#Dismantles+1] = vec3(630.02,947.13,247.64) -- QG_121
	Dismantles[#Dismantles+1] = vec3(74.95,6531.80,31.41) -- QG_175
	Dismantles[#Dismantles+1] = vec3(78.14,6535.30,31.41) -- QG_175
	Dismantles[#Dismantles+1] = vec3(62.41,6517.29,31.26) -- QG_175
	Dismantles[#Dismantles+1] = vec3(2032.67,3350.14,46.80) -- QG_150
	Dismantles[#Dismantles+1] = vec3(2037.79,3379.81,46.80) -- QG_150
	Dismantles[#Dismantles+1] = vec3(1965.23,3352.40,46.18) -- QG_150
	Dismantles[#Dismantles+1] = vec3(1971.09,3351.14,46.18) -- QG_150
	Dismantles[#Dismantles+1] = vec3(1976.70,3350.08,46.18) -- QG_150
	Dismantles[#Dismantles+1] = vec3(55.84,-456.3,40.25) -- QG_168
	Dismantles[#Dismantles+1] = vec3(58.45,-444.69,40.25) -- QG_168
	Dismantles[#Dismantles+1] = vec3(61.09,-433.37,40.25) -- QG_168
	Dismantles[#Dismantles+1] = vec3(63.55,-422.25,40.25) -- QG_168
	Dismantles[#Dismantles+1] = vec3(55.15,-420.1,40.27) -- QG_168
	Dismantles[#Dismantles+1] = vec3(52.33,-431.49,40.24) -- QG_168
	Dismantles[#Dismantles+1] = vec3(49.72,-443.14,40.07) -- QG_168
	Dismantles[#Dismantles+1] = vec3(46.99,-454.74,40.17) -- QG_168
	Dismantles[#Dismantles+1] = vec3(146.51,320.62,112.14) 
	Dismantles[#Dismantles+1] = vec3(-1537.85,-577.49,25.71) 
	Dismantles[#Dismantles+1] = vec3(819.53,-822.27,26.18) 
	Dismantles[#Dismantles+1] = vec3(520.91,169.14,99.36) 
	Dismantles[#Dismantles+1] = vec3(1397.0,1095.31,114.33) -- QG_16
	Dismantles[#Dismantles+1] = vec3(1398.53,1087.27,114.33) -- QG_16
	Dismantles[#Dismantles+1] = vec3(1397.65,1079.25,114.33) -- QG_16
	Dismantles[#Dismantles+1] = vec3(1398.0,1071.17,114.33) -- QG_16
	Dismantles[#Dismantles+1] = vec3(-1172.57,-2037.65,13.75)

elseif cityName == "Grande" then
	Dismantles[#Dismantles+1] = vec3(-750.75,-2596.36,13.83)
	Dismantles[#Dismantles+1] = vec3(-750.76,-2596.36,13.82)
	Dismantles[#Dismantles+1] = vec3(-336.4,-1574.0,25.21) -- QG_112
	Dismantles[#Dismantles+1] = vec3(-344.94,-1579.6,25.22) -- QG_112
	Dismantles[#Dismantles+1] = vec3(2764.37,3489.76,55.4) -- QG_14
	Dismantles[#Dismantles+1] = vec3(2768.44,3499.22,55.25) -- QG_14
	Dismantles[#Dismantles+1] = vec3(-317.41,-93.62,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(-324.6,-90.73,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(897.63,-2127.38,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(887.08,-2126.47,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(631.46,-2724.21,6.15) -- yakuza
	Dismantles[#Dismantles+1] = vec3(121.48,-415.01,41.28) -- Big
	Dismantles[#Dismantles+1] = vec3(2725.09,3470.55,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(2720.81,3460.37,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(-234.07,-1317.3,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-236.98,-1339.75,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-232.15,-1278.39,31.29) -- Bennys
	Dismantles[#Dismantles+1] = vec3(1360.12,-2094.01,52.0) -- Ferrovelho
	-- Dismantles[#Dismantles+1] = vec3(1409.66,-2055.83,52.0) -- Ferrovelho
	-- Dismantles[#Dismantles+1] = vec3(-2297.52,449.87,174.46) -- redline
	Dismantles[#Dismantles+1] = vec3(-581.35,-931.76,23.88) -- redline
	Dismantles[#Dismantles+1] = vec3(691.21,-960.17,23.61) -- QG_108
	Dismantles[#Dismantles+1] = vec3(630.02,947.13,247.64) -- QG_121
	Dismantles[#Dismantles+1] = vec3(1409.93,-2055.74,52.0) -- QG_68
	Dismantles[#Dismantles+1] = vec3(2032.67,3350.14,46.80) -- QG_150
	Dismantles[#Dismantles+1] = vec3(2037.79,3379.81,46.80) -- QG_150
	Dismantles[#Dismantles+1] = vec3(1965.23,3352.40,46.18) -- QG_150
	Dismantles[#Dismantles+1] = vec3(1971.09,3351.14,46.18) -- QG_150
	Dismantles[#Dismantles+1] = vec3(1976.70,3350.08,46.18) -- QG_150
	Dismantles[#Dismantles+1] = vec3(146.51,320.62,112.14) 
	Dismantles[#Dismantles+1] = vec3(-1537.85,-577.49,25.71) 
	Dismantles[#Dismantles+1] = vec3(819.53,-822.27,26.18) 
	Dismantles[#Dismantles+1] = vec3(520.91,169.14,99.36) 
	Dismantles[#Dismantles+1] = vec3(139.51,-385.49,44.94) -- QG_13

elseif cityName == "Fronteira" then
	Dismantles[#Dismantles+1] = vec3(1137.99,-794.32,57.59)
	Dismantles[#Dismantles+1] = vec3(-750.76,-2596.36,13.82)
	Dismantles[#Dismantles+1] = vec3(3272.44,5171.7,21.06)
	Dismantles[#Dismantles+1] = vec3(-317.41,-93.62,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(-324.6,-90.73,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(897.63,-2127.38,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(887.08,-2126.47,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(631.46,-2724.21,6.15) -- yakuza
	Dismantles[#Dismantles+1] = vec3(121.48,-415.01,41.28) -- Big
	Dismantles[#Dismantles+1] = vec3(2725.09,3470.55,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(2720.81,3460.37,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(-234.07,-1317.3,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-236.98,-1339.75,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-232.15,-1278.39,31.29) -- Bennys
	Dismantles[#Dismantles+1] = vec3(1360.12,-2094.01,52.0) -- Ferrovelho
	-- Dismantles[#Dismantles+1] = vec3(1409.66,-2055.83,52.0) -- Ferrovelho
	-- Dismantles[#Dismantles+1] = vec3(-2297.52,449.87,174.46) -- redline
	Dismantles[#Dismantles+1] = vec3(691.21,-960.17,23.61) -- QG_108
	Dismantles[#Dismantles+1] = vec3(693.34,-1010.09,22.76) -- QG_108
	Dismantles[#Dismantles+1] = vec3(630.02,947.13,247.64) -- QG_121
	Dismantles[#Dismantles+1] = vec3(1409.93,-2055.74,52.0) -- QG_68
	Dismantles[#Dismantles+1] = vec3(146.51,320.62,112.14) 
	Dismantles[#Dismantles+1] = vec3(-1537.85,-577.49,25.71) 
	Dismantles[#Dismantles+1] = vec3(819.53,-822.27,26.18) 
	Dismantles[#Dismantles+1] = vec3(520.91,169.14,99.36) 
	Dismantles[#Dismantles+1] = vec3(139.51,-385.49,44.94) -- QG_13


elseif cityName == "Malta" then
	Dismantles[#Dismantles+1] = vec3(-750.75,-2596.36,13.83)
	Dismantles[#Dismantles+1] = vec3(-750.76,-2596.36,13.82)
	Dismantles[#Dismantles+1] = vec3(154.88,-123.46,60.76) -- QG_322
	Dismantles[#Dismantles+1] = vec3(126.35,-117.5,60.76) -- QG_322
	Dismantles[#Dismantles+1] = vec3(985.84,-138.29,73.09) -- QG_349
	Dismantles[#Dismantles+1] = vec3(3272.44,5171.7,21.06)
	Dismantles[#Dismantles+1] = vec3(-1126.44,-1609.48,4.40)
	Dismantles[#Dismantles+1] = vec3(-317.41,-93.62,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(-324.6,-90.73,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(897.63,-2127.38,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(887.08,-2126.47,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(631.46,-2724.21,6.15) -- yakuza
	Dismantles[#Dismantles+1] = vec3(139.76,-388.5,45.19) -- Big
	Dismantles[#Dismantles+1] = vec3(2725.09,3470.55,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(2720.81,3460.37,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(-234.07,-1317.3,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-236.98,-1339.75,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-232.15,-1278.39,31.29) -- Bennys
	Dismantles[#Dismantles+1] = vec3(1360.12,-2094.01,52.0) -- Ferrovelho
	-- Dismantles[#Dismantles+1] = vec3(1409.66,-2055.83,52.0) -- Ferrovelho
	-- Dismantles[#Dismantles+1] = vec3(-2297.52,449.87,174.46) -- redline
	Dismantles[#Dismantles+1] = vec3(-581.35,-931.76,23.88) -- redline
	Dismantles[#Dismantles+1] = vec3(691.21,-960.17,23.61) -- QG_108
	Dismantles[#Dismantles+1] = vec3(-1625.76,125.28,61.65) -- QG_20
	Dismantles[#Dismantles+1] = vec3(-1505.98,77.86,55.6) -- QG_20
	Dismantles[#Dismantles+1] = vec3(630.02,947.13,247.64) -- QG_121
	Dismantles[#Dismantles+1] = vec3(1409.93,-2055.74,52.0) -- QG_68
	Dismantles[#Dismantles+1] = vec3(62.19,6517.42,31.26) -- QG_131
	Dismantles[#Dismantles+1] = vec3(75.01,6531.73,31.41) -- QG_131
	Dismantles[#Dismantles+1] = vec3(78.09,6535.15,31.41) -- QG_131
	Dismantles[#Dismantles+1] = vec3(-1172.57,-2037.65,13.75)

elseif cityName == "Kingdom" then
	Dismantles[#Dismantles+1] = vec3(-750.75,-2596.36,13.83)
	Dismantles[#Dismantles+1] = vec3(-750.76,-2596.36,13.82)
	Dismantles[#Dismantles+1] = vec3(693.34,-1010.09,22.76) -- QG_108
	-- Dismantles[#Dismantles+1] = vec3(693.34,-1010.09,22.76) -- QG_167
	Dismantles[#Dismantles+1] = vec3(74.95,6531.80,31.41) -- QG_131
	Dismantles[#Dismantles+1] = vec3(78.14,6535.30,31.41) -- QG_131
	Dismantles[#Dismantles+1] = vec3(62.41,6517.29,31.26) -- QG_131
	Dismantles[#Dismantles+1] = vec3(-317.41,-93.62,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(1360.12,-2094.01,52.0) -- Ferrovelho/QG_68
	Dismantles[#Dismantles+1] = vec3(1409.66,-2055.83,52.0) -- FerroVelho/QG_68
	Dismantles[#Dismantles+1] = vec3(-324.6,-90.73,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(897.63,-2127.38,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(887.08,-2126.47,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(631.46,-2724.21,6.15) -- yakuza
	Dismantles[#Dismantles+1] = vec3(139.76,-388.5,45.19) -- Big
	Dismantles[#Dismantles+1] = vec3(2725.09,3470.55,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(2720.81,3460.37,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(-234.07,-1317.3,30.9) -- QG_46
	Dismantles[#Dismantles+1] = vec3(-236.98,-1339.75,30.9) -- QG_46
	Dismantles[#Dismantles+1] = vec3(-228.03,-1287.92,31.29) -- QG_46
	Dismantles[#Dismantles+1] = vec3(-581.35,-931.76,23.88) -- redline
	Dismantles[#Dismantles+1] = vec3(-1124.2,-1611.21,4.4) -- QG_47
	Dismantles[#Dismantles+1] = vec3(146.51,320.62,112.14) 
	Dismantles[#Dismantles+1] = vec3(-1537.85,-577.49,25.71) 
	Dismantles[#Dismantles+1] = vec3(819.53,-822.27,26.18) 
	Dismantles[#Dismantles+1] = vec3(520.91,169.14,99.36) 
	Dismantles[#Dismantles+1] = vec3(-1172.57,-2037.65,13.75)
	Dismantles[#Dismantles+1] = vec3(1708.05,3692.02,34.53) -- QG_419
	Dismantles[#Dismantles+1] = vec3(1711.64,3686.56,34.53) -- QG_419
	Dismantles[#Dismantles+1] = vec3(1701.82,3702.36,34.58) -- QG_419
elseif cityName == "Imperium" then
	Dismantles[#Dismantles+1] = vec3(-750.76,-2596.36,13.82)
	Dismantles[#Dismantles+1] = vec3(693.34,-1010.09,22.76) -- QG_108
	-- Dismantles[#Dismantles+1] = vec3(693.34,-1010.09,22.76) -- QG_167
	Dismantles[#Dismantles+1] = vec3(74.95,6531.80,31.41) -- QG_131
	Dismantles[#Dismantles+1] = vec3(78.14,6535.30,31.41) -- QG_131
	Dismantles[#Dismantles+1] = vec3(62.41,6517.29,31.26) -- QG_131
	Dismantles[#Dismantles+1] = vec3(3272.44,5171.7,21.06)
	Dismantles[#Dismantles+1] = vec3(-317.41,-93.62,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(1360.12,-2094.01,52.0) -- Ferrovelho/QG_68
	Dismantles[#Dismantles+1] = vec3(1409.66,-2055.83,52.0) -- FerroVelho/QG_68
	Dismantles[#Dismantles+1] = vec3(-324.6,-90.73,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(897.63,-2127.38,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(887.08,-2126.47,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(631.46,-2724.21,6.15) -- yakuza
	Dismantles[#Dismantles+1] = vec3(139.76,-388.5,45.19) -- Big
	Dismantles[#Dismantles+1] = vec3(2725.09,3470.55,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(2720.81,3460.37,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(-234.07,-1317.3,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-236.98,-1339.75,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-232.15,-1278.39,31.29) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-581.35,-931.76,23.88) -- redline
	Dismantles[#Dismantles+1] = vec3(-1124.2,-1611.21,4.4) -- QG_47
	Dismantles[#Dismantles+1] = vec3(146.51,320.62,112.14) 
	Dismantles[#Dismantles+1] = vec3(-1537.85,-577.49,25.71) 
	Dismantles[#Dismantles+1] = vec3(819.53,-822.27,26.18) 
	Dismantles[#Dismantles+1] = vec3(520.91,169.14,99.36) 
elseif cityName == "GoatRP" then
	Dismantles[#Dismantles+1] = vec3(-750.76,-2596.36,13.82)
	Dismantles[#Dismantles+1] = vec3(693.34,-1010.09,22.76) -- QG_108
	-- Dismantles[#Dismantles+1] = vec3(693.34,-1010.09,22.76) -- QG_167
	Dismantles[#Dismantles+1] = vec3(74.95,6531.80,31.41) -- QG_131
	Dismantles[#Dismantles+1] = vec3(78.14,6535.30,31.41) -- QG_131
	Dismantles[#Dismantles+1] = vec3(62.41,6517.29,31.26) -- QG_131
	Dismantles[#Dismantles+1] = vec3(3272.44,5171.7,21.06)
	Dismantles[#Dismantles+1] = vec3(-317.41,-93.62,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(1360.12,-2094.01,52.0) -- Ferrovelho/QG_68
	Dismantles[#Dismantles+1] = vec3(1409.66,-2055.83,52.0) -- FerroVelho/QG_68
	Dismantles[#Dismantles+1] = vec3(-324.6,-90.73,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(897.63,-2127.38,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(887.08,-2126.47,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(631.46,-2724.21,6.15) -- yakuza
	Dismantles[#Dismantles+1] = vec3(139.76,-388.5,45.19) -- Big
	Dismantles[#Dismantles+1] = vec3(2725.09,3470.55,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(2720.81,3460.37,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(-234.07,-1317.3,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-236.98,-1339.75,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-232.15,-1278.39,31.29) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-581.35,-931.76,23.88) -- redline
	Dismantles[#Dismantles+1] = vec3(-1124.2,-1611.21,4.4) -- QG_47
	Dismantles[#Dismantles+1] = vec3(146.51,320.62,112.14) 
	Dismantles[#Dismantles+1] = vec3(-1537.85,-577.49,25.71) 
	Dismantles[#Dismantles+1] = vec3(819.53,-822.27,26.18) 
	Dismantles[#Dismantles+1] = vec3(520.91,169.14,99.36) 

elseif cityName == "District99" then
	Dismantles[#Dismantles+1] = vec3(1137.99,-794.32,57.59)
	Dismantles[#Dismantles+1] = vec3(-750.75,-2596.36,13.83)
	Dismantles[#Dismantles+1] = vec3(-750.76,-2596.36,13.82)
	Dismantles[#Dismantles+1] = vec3(-237.06,-1338.01,30.90) -- QG_46
	Dismantles[#Dismantles+1] = vec3(-233.89,-1316.06,30.90) -- QG_46
	Dismantles[#Dismantles+1] = vec3(-233.48,-1280.31,31.30) -- QG_46
	Dismantles[#Dismantles+1] = vec3(-1906.69,2004.44,141.84) -- QG_18
	Dismantles[#Dismantles+1] = vec3(-1908.84,2060.4,140.73) -- QG_18
	Dismantles[#Dismantles+1] = vec3(693.34,-1010.09,22.76) -- QG_108
	-- Dismantles[#Dismantles+1] = vec3(693.34,-1010.09,22.76) -- QG_167
	Dismantles[#Dismantles+1] = vec3(74.95,6531.80,31.41) -- QG_131
	Dismantles[#Dismantles+1] = vec3(78.14,6535.30,31.41) -- QG_131
	Dismantles[#Dismantles+1] = vec3(62.41,6517.29,31.26) -- QG_131
	Dismantles[#Dismantles+1] = vec3(-317.41,-93.62,39.04) -- Virtude
	-- Dismantles[#Dismantles+1] = vec3(1360.12,-2094.01,52.0) -- Ferrovelho/QG_68
	-- Dismantles[#Dismantles+1] = vec3(1409.66,-2055.83,52.0) -- FerroVelho/QG_68
	Dismantles[#Dismantles+1] = vec3(1409.82,-2055.38,52.0) -- QG_483
	Dismantles[#Dismantles+1] = vec3(1360.45,-2093.63,52.0) -- QG_483
	Dismantles[#Dismantles+1] = vec3(-324.6,-90.73,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(897.63,-2127.38,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(887.08,-2126.47,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(631.46,-2724.21,6.15) -- yakuza
	Dismantles[#Dismantles+1] = vec3(139.76,-388.5,45.19) -- Big
	Dismantles[#Dismantles+1] = vec3(2725.09,3470.55,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(2720.81,3460.37,55.71) -- Kraken
	-- Dismantles[#Dismantles+1] = vec3(-234.07,-1317.3,30.9) -- Bennys
	-- Dismantles[#Dismantles+1] = vec3(-236.98,-1339.75,30.9) -- Bennys
	-- Dismantles[#Dismantles+1] = vec3(-232.15,-1278.39,31.29) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-581.35,-931.76,23.88) -- redline
	Dismantles[#Dismantles+1] = vec3(-1124.2,-1611.21,4.4) -- QG_47
	Dismantles[#Dismantles+1] = vec3(146.51,320.62,112.14) 
	Dismantles[#Dismantles+1] = vec3(-1537.85,-577.49,25.71) 
	Dismantles[#Dismantles+1] = vec3(819.53,-822.27,26.18) 
	Dismantles[#Dismantles+1] = vec3(520.91,169.14,99.36) 
	Dismantles[#Dismantles+1] = vec3(-1172.57,-2037.65,13.75)

elseif cityName == "Krown" then
	Dismantles[#Dismantles+1] = vec3(1137.99,-794.32,57.59)
	Dismantles[#Dismantles+1] = vec3(-750.75,-2596.36,13.83)
	Dismantles[#Dismantles+1] = vec3(-750.76,-2596.36,13.82)
	Dismantles[#Dismantles+1] = vec3(-237.06,-1338.01,30.90) -- QG_46
	Dismantles[#Dismantles+1] = vec3(-233.89,-1316.06,30.90) -- QG_46
	Dismantles[#Dismantles+1] = vec3(-233.48,-1280.31,31.30) -- QG_46
	Dismantles[#Dismantles+1] = vec3(693.34,-1010.09,22.76) -- QG_108
	-- Dismantles[#Dismantles+1] = vec3(693.34,-1010.09,22.76) -- QG_167
	Dismantles[#Dismantles+1] = vec3(74.95,6531.80,31.41) -- QG_131
	Dismantles[#Dismantles+1] = vec3(78.14,6535.30,31.41) -- QG_131
	Dismantles[#Dismantles+1] = vec3(62.41,6517.29,31.26) -- QG_131
	Dismantles[#Dismantles+1] = vec3(-317.41,-93.62,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(1360.12,-2094.01,52.0) -- Ferrovelho/QG_68
	Dismantles[#Dismantles+1] = vec3(1409.66,-2055.83,52.0) -- FerroVelho/QG_68
	Dismantles[#Dismantles+1] = vec3(-324.6,-90.73,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(897.63,-2127.38,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(887.08,-2126.47,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(631.46,-2724.21,6.15) -- yakuza
	Dismantles[#Dismantles+1] = vec3(139.76,-388.5,45.19) -- Big
	Dismantles[#Dismantles+1] = vec3(2725.09,3470.55,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(2720.81,3460.37,55.71) -- Kraken
	-- Dismantles[#Dismantles+1] = vec3(-234.07,-1317.3,30.9) -- Bennys
	-- Dismantles[#Dismantles+1] = vec3(-236.98,-1339.75,30.9) -- Bennys
	-- Dismantles[#Dismantles+1] = vec3(-232.15,-1278.39,31.29) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-581.35,-931.76,23.88) -- redline
	Dismantles[#Dismantles+1] = vec3(-1124.2,-1611.21,4.4) -- QG_47
	Dismantles[#Dismantles+1] = vec3(146.51,320.62,112.14) 
	Dismantles[#Dismantles+1] = vec3(-1537.85,-577.49,25.71) 
	Dismantles[#Dismantles+1] = vec3(819.53,-822.27,26.18) 
	Dismantles[#Dismantles+1] = vec3(520.91,169.14,99.36) 
	Dismantles[#Dismantles+1] = vec3(-1172.57,-2037.65,13.75)

elseif cityName == "Orizon" then
	Dismantles[#Dismantles+1] = vec3(1137.99,-794.32,57.59)
	Dismantles[#Dismantles+1] = vec3(-750.75,-2596.36,13.83)
	Dismantles[#Dismantles+1] = vec3(-750.76,-2596.36,13.82)
	Dismantles[#Dismantles+1] = vec3(693.34,-1010.09,22.76) -- QG_108
	-- Dismantles[#Dismantles+1] = vec3(693.34,-1010.09,22.76) -- QG_167
	Dismantles[#Dismantles+1] = vec3(74.95,6531.80,31.41) -- QG_131
	Dismantles[#Dismantles+1] = vec3(78.14,6535.30,31.41) -- QG_131
	Dismantles[#Dismantles+1] = vec3(62.41,6517.29,31.26) -- QG_131
	Dismantles[#Dismantles+1] = vec3(-317.41,-93.62,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(1360.12,-2094.01,52.0) -- Ferrovelho/QG_68
	Dismantles[#Dismantles+1] = vec3(1409.66,-2055.83,52.0) -- FerroVelho/QG_68
	Dismantles[#Dismantles+1] = vec3(-324.6,-90.73,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(897.63,-2127.38,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(887.08,-2126.47,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(631.46,-2724.21,6.15) -- yakuza
	Dismantles[#Dismantles+1] = vec3(139.76,-388.5,45.19) -- Big
	Dismantles[#Dismantles+1] = vec3(2725.09,3470.55,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(2720.81,3460.37,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(-234.07,-1317.3,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-236.98,-1339.75,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-232.15,-1278.39,31.29) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-581.35,-931.76,23.88) -- redline
	Dismantles[#Dismantles+1] = vec3(-1124.2,-1611.21,4.4) -- QG_47
	Dismantles[#Dismantles+1] = vec3(146.51,320.62,112.14) 
	Dismantles[#Dismantles+1] = vec3(-1537.85,-577.49,25.71) 
	Dismantles[#Dismantles+1] = vec3(819.53,-822.27,26.18) 
	Dismantles[#Dismantles+1] = vec3(520.91,169.14,99.36) 
	Dismantles[#Dismantles+1] = vec3(-1172.57,-2037.65,13.75)

elseif cityName == "Liberty99" then
	Dismantles[#Dismantles+1] = vec3(1137.99,-794.32,57.59)
	Dismantles[#Dismantles+1] = vec3(-750.75,-2596.36,13.83)
	Dismantles[#Dismantles+1] = vec3(-750.76,-2596.36,13.82)
	Dismantles[#Dismantles+1] = vec3(693.34,-1010.09,22.76) -- QG_108
	-- Dismantles[#Dismantles+1] = vec3(693.34,-1010.09,22.76) -- QG_167
	Dismantles[#Dismantles+1] = vec3(74.95,6531.80,31.41) -- QG_131
	Dismantles[#Dismantles+1] = vec3(78.14,6535.30,31.41) -- QG_131
	Dismantles[#Dismantles+1] = vec3(62.41,6517.29,31.26) -- QG_131
	Dismantles[#Dismantles+1] = vec3(-317.41,-93.62,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(1360.12,-2094.01,52.0) -- Ferrovelho/QG_68
	Dismantles[#Dismantles+1] = vec3(1409.66,-2055.83,52.0) -- FerroVelho/QG_68
	Dismantles[#Dismantles+1] = vec3(-324.6,-90.73,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(897.63,-2127.38,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(887.08,-2126.47,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(631.46,-2724.21,6.15) -- yakuza
	Dismantles[#Dismantles+1] = vec3(139.76,-388.5,45.19) -- Big
	Dismantles[#Dismantles+1] = vec3(2725.09,3470.55,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(2720.81,3460.37,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(-234.07,-1317.3,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-236.98,-1339.75,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-232.15,-1278.39,31.29) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-581.35,-931.76,23.88) -- redline
	Dismantles[#Dismantles+1] = vec3(-1124.2,-1611.21,4.4) -- QG_47
	Dismantles[#Dismantles+1] = vec3(146.51,320.62,112.14)
	Dismantles[#Dismantles+1] = vec3(-1537.85,-577.49,25.71)
	Dismantles[#Dismantles+1] = vec3(819.53,-822.27,26.18)
	Dismantles[#Dismantles+1] = vec3(520.91,169.14,99.36)
	Dismantles[#Dismantles+1] = vec3(-1172.57,-2037.65,13.75)
	Dismantles[#Dismantles+1] = vec3(1446.83,1177.69,114.18) -- QG_407
	Dismantles[#Dismantles+1] = vec3(1446.48,1166.07,114.18) -- QG_407

elseif cityName == "Royal" then
	Dismantles[#Dismantles+1] = vec3(1137.99,-794.32,57.59)
	Dismantles[#Dismantles+1] = vec3(-750.75,-2596.36,13.83)
	Dismantles[#Dismantles+1] = vec3(-750.76,-2596.36,13.82)
	Dismantles[#Dismantles+1] = vec3(693.34,-1010.09,22.76) -- QG_108
	-- Dismantles[#Dismantles+1] = vec3(693.34,-1010.09,22.76) -- QG_167
	Dismantles[#Dismantles+1] = vec3(74.95,6531.80,31.41) -- QG_131
	Dismantles[#Dismantles+1] = vec3(78.14,6535.30,31.41) -- QG_131
	Dismantles[#Dismantles+1] = vec3(62.41,6517.29,31.26) -- QG_131
	Dismantles[#Dismantles+1] = vec3(-317.41,-93.62,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(1360.12,-2094.01,52.0) -- Ferrovelho/QG_68
	Dismantles[#Dismantles+1] = vec3(1409.66,-2055.83,52.0) -- FerroVelho/QG_68
	Dismantles[#Dismantles+1] = vec3(-324.6,-90.73,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(897.63,-2127.38,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(887.08,-2126.47,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(631.46,-2724.21,6.15) -- yakuza
	Dismantles[#Dismantles+1] = vec3(139.76,-388.5,45.19) -- Big
	Dismantles[#Dismantles+1] = vec3(2725.09,3470.55,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(2720.81,3460.37,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(-234.07,-1317.3,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-236.98,-1339.75,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-232.15,-1278.39,31.29) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-581.35,-931.76,23.88) -- redline
	Dismantles[#Dismantles+1] = vec3(-1124.2,-1611.21,4.4) -- QG_47
	Dismantles[#Dismantles+1] = vec3(146.51,320.62,112.14) 
	Dismantles[#Dismantles+1] = vec3(-1537.85,-577.49,25.71) 
	Dismantles[#Dismantles+1] = vec3(819.53,-822.27,26.18) 
	Dismantles[#Dismantles+1] = vec3(520.91,169.14,99.36) 
	Dismantles[#Dismantles+1] = vec3(-1172.57,-2037.65,13.75)

elseif cityName == "Real" then
	Dismantles[#Dismantles+1] = vec3(1137.99,-794.32,57.59)
	Dismantles[#Dismantles+1] = vec3(-750.75,-2596.36,13.83)
	Dismantles[#Dismantles+1] = vec3(-750.76,-2596.36,13.82)
	Dismantles[#Dismantles+1] = vec3(-317.41,-93.62,39.04) -- Virtude/QG_272
	Dismantles[#Dismantles+1] = vec3(1360.12,-2094.01,52.0) -- Ferrovelho/QG_68
	Dismantles[#Dismantles+1] = vec3(1409.66,-2055.83,52.0) -- FerroVelho/QG_68
	Dismantles[#Dismantles+1] = vec3(-324.6,-90.73,39.04) -- Virtude / QG_272
	Dismantles[#Dismantles+1] = vec3(897.63,-2127.38,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(887.08,-2126.47,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(631.46,-2724.21,6.15) -- yakuza
	Dismantles[#Dismantles+1] = vec3(139.76,-388.5,45.19) -- Big
	Dismantles[#Dismantles+1] = vec3(2725.09,3470.55,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(2720.81,3460.37,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(-234.07,-1317.3,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-236.98,-1339.75,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-232.15,-1278.39,31.29) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-581.35,-931.76,23.88) -- redline
	Dismantles[#Dismantles+1] = vec3(-1124.2,-1611.21,4.4) -- QG_47
	Dismantles[#Dismantles+1] = vec3(146.51,320.62,112.14) 
	Dismantles[#Dismantles+1] = vec3(-1537.85,-577.49,25.71) 
	Dismantles[#Dismantles+1] = vec3(819.53,-822.27,26.18) 
	Dismantles[#Dismantles+1] = vec3(520.91,169.14,99.36) 
	Dismantles[#Dismantles+1] = vec3(-1172.57,-2037.65,13.75)

elseif cityName == "Prime" then
	Dismantles[#Dismantles+1] = vec3(1137.99,-794.32,57.59)
	Dismantles[#Dismantles+1] = vec3(-750.75,-2596.36,13.83)
	Dismantles[#Dismantles+1] = vec3(-750.76,-2596.36,13.82)
	Dismantles[#Dismantles+1] = vec3(-317.41,-93.62,39.04) -- Virtude/QG_272
	Dismantles[#Dismantles+1] = vec3(1360.12,-2094.01,52.0) -- Ferrovelho/QG_68
	Dismantles[#Dismantles+1] = vec3(1409.66,-2055.83,52.0) -- FerroVelho/QG_68
	Dismantles[#Dismantles+1] = vec3(-324.6,-90.73,39.04) -- Virtude / QG_272
	Dismantles[#Dismantles+1] = vec3(897.63,-2127.38,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(887.08,-2126.47,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(631.46,-2724.21,6.15) -- yakuza
	Dismantles[#Dismantles+1] = vec3(139.76,-388.5,45.19) -- Big
	Dismantles[#Dismantles+1] = vec3(2725.09,3470.55,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(2720.81,3460.37,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(-234.07,-1317.3,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-236.98,-1339.75,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-232.15,-1278.39,31.29) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-581.35,-931.76,23.88) -- redline
	Dismantles[#Dismantles+1] = vec3(-1124.2,-1611.21,4.4) -- QG_47
	Dismantles[#Dismantles+1] = vec3(146.51,320.62,112.14) 
	Dismantles[#Dismantles+1] = vec3(-1537.85,-577.49,25.71) 
	Dismantles[#Dismantles+1] = vec3(819.53,-822.27,26.18) 
	Dismantles[#Dismantles+1] = vec3(520.91,169.14,99.36) 

elseif cityName == "Universo" then
	Dismantles[#Dismantles+1] = vec3(1137.99,-794.32,57.59)
	Dismantles[#Dismantles+1] = vec3(-750.76,-2596.36,13.82)
	Dismantles[#Dismantles+1] = vec3(3272.44,5171.7,21.06)
	Dismantles[#Dismantles+1] = vec3(-317.41,-93.62,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(-324.6,-90.73,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(897.63,-2127.38,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(887.08,-2126.47,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(631.46,-2724.21,6.15) -- yakuza
	Dismantles[#Dismantles+1] = vec3(139.76,-388.5,45.19) -- Big
	Dismantles[#Dismantles+1] = vec3(2725.09,3470.55,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(2720.81,3460.37,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(-234.07,-1317.3,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-236.98,-1339.75,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-232.15,-1278.39,31.29) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-583.02,-924.67,23.88) -- redline
	Dismantles[#Dismantles+1] = vec3(-559.72,-914.59,23.88) -- redline
	Dismantles[#Dismantles+1] = vec3(-1124.2,-1611.21,4.4) -- QG_47
	Dismantles[#Dismantles+1] = vec3(1409.93,-2055.74,52.0) -- QG_68
	Dismantles[#Dismantles+1] = vec3(55.39,-462.26,40.17) -- QG_134
	Dismantles[#Dismantles+1] = vec3(56.93,-450.59,40.25) -- QG_134
	Dismantles[#Dismantles+1] = vec3(59.46,-439.39,40.25) -- QG_134
	Dismantles[#Dismantles+1] = vec3(63.26,-427.63,40.22) -- QG_134
	Dismantles[#Dismantles+1] = vec3(74.95,6531.80,31.41) -- QG_131
	Dismantles[#Dismantles+1] = vec3(78.14,6535.30,31.41) -- QG_131
	Dismantles[#Dismantles+1] = vec3(62.41,6517.29,31.26) -- QG_131
	Dismantles[#Dismantles+1] = vec3(146.51,320.62,112.14) 
	Dismantles[#Dismantles+1] = vec3(-1537.85,-577.49,25.71) 
	Dismantles[#Dismantles+1] = vec3(819.53,-822.27,26.18) 
	Dismantles[#Dismantles+1] = vec3(520.91,169.14,99.36) 
	Dismantles[#Dismantles+1] = vec3(-1172.57,-2037.65,13.75)

elseif cityName == "Maresia" then
	Dismantles[#Dismantles+1] = vec3(-750.75,-2596.36,13.83)

	Dismantles[#Dismantles+1] = vec3(74.95,6531.80,31.41) -- QG_131
	Dismantles[#Dismantles+1] = vec3(78.14,6535.30,31.41) -- QG_131
	Dismantles[#Dismantles+1] = vec3(62.41,6517.29,31.26) -- QG_131
	Dismantles[#Dismantles+1] = vec3(57.63,6512.09,31.26) -- QG_131
	Dismantles[#Dismantles+1] = vec3(-357.07,192.26,87.43) -- QG_234
	Dismantles[#Dismantles+1] = vec3(-356.87,199.64,87.06) -- QG_234
	Dismantles[#Dismantles+1] = vec3(-357.23,207.01,86.66) -- QG_234
	Dismantles[#Dismantles+1] = vec3(897.63,-2127.38,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(887.08,-2126.47,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(139.76,-388.5,45.19) -- Big
	Dismantles[#Dismantles+1] = vec3(2725.09,3470.55,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(2720.81,3460.37,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(-234.07,-1317.3,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-236.98,-1339.75,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-232.15,-1278.39,31.29) -- Bennys
    Dismantles[#Dismantles+1] = vec3(-581.35,-931.76,23.88) -- redline
	-- Dismantles[#Dismantles+1] = vec3(-317.41,-93.62,39.04) -- Virtude
	-- Dismantles[#Dismantles+1] = vec3(-324.6,-90.73,39.04) -- Virtude
	Dismantles[#Dismantles+1] = vec3(-326.63,-144.55,39.01) -- virtudes
	Dismantles[#Dismantles+1] = vec3(-338.92,-94.82,39.01) -- virtudes
	Dismantles[#Dismantles+1] = vec3(-1124.2,-1611.21,4.4) -- QG_47
	Dismantles[#Dismantles+1] = vec3(1409.93,-2055.74,52.0) -- QG_68
	Dismantles[#Dismantles+1] = vec3(146.51,320.62,112.14) 
	Dismantles[#Dismantles+1] = vec3(819.53,-822.27,26.18) 
	Dismantles[#Dismantles+1] = vec3(520.91,169.14,99.36) 
	Dismantles[#Dismantles+1] = vec3(-1172.57,-2037.65,13.75)

elseif cityName == "Alexandria" then
	Dismantles[#Dismantles+1] = vec3(-231.75,-1276.06,31.29) -- bennys
	Dismantles[#Dismantles+1] = vec3(139.05,-386.84,45.19) -- Big
	Dismantles[#Dismantles+1] = vec3(618.24,-2772.94,6.05) -- Gang5
	Dismantles[#Dismantles+1] = vec3(2725.31,3470.47,55.71) -- Kraken
	Dismantles[#Dismantles+1] = vec3(-2316.56,291.17,169.46) -- Redline
	Dismantles[#Dismantles+1] = vec3(-234.07,-1317.3,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-236.98,-1339.75,30.9) -- Bennys
	Dismantles[#Dismantles+1] = vec3(-232.15,-1278.39,31.29) -- Bennys
	Dismantles[#Dismantles+1] = vec3(886.79,-2126.82,30.55) -- CarClube
	Dismantles[#Dismantles+1] = vec3(-329.06,-108.01,39.01) -- Virtude
	Dismantles[#Dismantles+1] = vec3(1384.37,-2068.15,52.0) -- FerroVellho
	Dismantles[#Dismantles+1] = vec3(-1124.2,-1611.21,4.4) -- QG_47
	Dismantles[#Dismantles+1] = vec3(1409.93,-2055.74,52.0) -- QG_68
	Dismantles[#Dismantles+1] = vec3(146.51,320.62,112.14) 
	Dismantles[#Dismantles+1] = vec3(-1537.85,-577.49,25.71) 
	Dismantles[#Dismantles+1] = vec3(819.53,-822.27,26.18) 
	Dismantles[#Dismantles+1] = vec3(520.91,169.14,99.36) 

end

CreateThread(function()
    LocalPlayer["state"]["Buttons"] = false
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Route"] < 900000 then
			local Ped = PlayerPedId()
			if not IsPedInAnyVehicle(Ped) then
				local Coords = GetEntityCoords(Ped)

				for Number,v in pairs(Dismantles) do
					if #(Coords - v) <= 50.0 then
						TimeDistance = 1
						DrawMarker(23,v["x"],v["y"],v["z"] - 0.9,0.0,0.0,0.0,0.0,0.0,0.0,5.0,5.0,0.0,46,110,76,100,0,0,0,0)
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)

function GetVipColor(VipGroup)
    local VipColors = sx.vipsystem.GetVipsScriptsConfig("target","vip_colors")
    if VipColors[VipGroup] then
        return VipColors[VipGroup]
    else
        return "~g~"
    end
end

---@param VipGroup string
---@return table?
function GetCustomVipColor(VipGroup)
    local vipColor = (GlobalState["GroupVipColor"] or {})[VipGroup]

    if type(vipColor) ~= "string" then
        return nil
    end

    local red, green, blue = vipColor:match("^rgb%(%s*(%d+),%s*(%d+),%s*(%d+)%s*%)$")

    red, green, blue = tonumber(red), tonumber(green), tonumber(blue)

    if not red or not green or not blue or red > 255 or green > 255 or blue > 255 then
        return nil
    end

    return { r = red, g = green, b = blue, isCustom = true }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:DISMANTLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:Dismantles")
AddEventHandler("target:Dismantles",function()
	Dismantleds = math.random(#Dismantles)
	TriggerEvent("NotifyPush",{ code = "QRU", title = "Desmanche", x = Dismantles[Dismantleds]["x"], y = Dismantles[Dismantleds]["y"], z = Dismantles[Dismantleds]["z"], blipColor = 60 })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TYRELIST
-----------------------------------------------------------------------------------------------------------------------------------------
local tyreList = {
	["wheel_lf"] = 0,
	["wheel_rf"] = 1,
	["wheel_lm"] = 2,
	["wheel_rm"] = 3,
	["wheel_lr"] = 4,
	["wheel_rr"] = 5
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUELS
-----------------------------------------------------------------------------------------------------------------------------------------
local Fuels = {
	{ 273.83,-1253.46,28.29 },
	{ 273.83,-1261.29,28.29 },
	{ 273.83,-1268.63,28.29 },
	{ 265.06,-1253.46,28.29 },
	{ 265.06,-1261.29,28.29 },
	{ 265.06,-1268.63,28.29 },
	{ 256.43,-1253.46,28.29 },
	{ 256.43,-1261.29,28.29 },
	{ 256.43,-1268.63,28.29 },
	{ 2680.90,3266.40,54.39 },
	{ 2678.51,3262.33,54.39 },
	{ -2104.53,-311.01,12.16 },
	{ -2105.39,-319.21,12.16 },
	{ -2106.06,-325.57,12.16 },
	{ -2097.48,-326.48,12.16 },
	{ -2096.81,-320.11,12.16 },
	{ -2096.09,-311.90,12.16 },
	{ -2087.21,-312.81,12.16 },
	{ -2088.08,-321.03,12.16 },
	{ -2088.75,-327.39,12.16 },
	{ -2551.39,2327.11,32.24 },
	{ -2558.02,2326.70,32.24 },
	{ -2558.48,2334.13,32.24 },
	{ -2552.60,2334.46,32.24 },
	{ -2558.77,2341.48,32.24 },
	{ -2552.39,2341.89,32.24 },
	{ 186.97,6606.21,31.06 },
	{ 179.67,6604.93,31.06 },
	{ 172.33,6603.63,31.06 },
	{ 818.99,-1026.24,25.44 },
	{ 810.7,-1026.24,25.44 },
	{ 810.7,-1030.94,25.44 },
	{ 818.99,-1030.94,25.44 },
	{ 818.99,-1026.24,25.44 },
	{ 827.3,-1026.24,25.64 },
	{ 827.3,-1030.94,25.64 },
	{ 1207.07,-1398.16,34.39 },
	{ 1204.2,-1401.03,34.39 },
	{ 1210.07,-1406.9,34.39 },
	{ 1212.94,-1404.03,34.39 },
	{ 1178.97,-339.54,68.37 },
	{ 1186.4,-338.23,68.36 },
	{ 1184.89,-329.7,68.31 },
	{ 1177.46,-331.01,68.32 },
	{ 1175.71,-322.3,68.36 },
	{ 1183.13,-320.99,68.36 },
	{ 629.64,263.84,102.27 },
	{ 629.64,273.97,102.27 },
	{ 620.99,273.97,102.27 },
	{ 621.0,263.84,102.27 },
	{ 612.44,263.84,102.27 },
	{ 612.43,273.96,102.27 },
	{ 2588.41,358.56,107.66 },
	{ 2588.65,364.06,107.66 },
	{ 2581.18,364.39,107.66 },
	{ 2580.94,358.89,107.66 },
	{ 2573.55,359.21,107.66 },
	{ 2573.79,364.71,107.66 },
	{ 174.99,-1568.44,28.33 },
	{ 181.81,-1561.96,28.33 },
	{ 176.03,-1555.91,28.33 },
	{ 169.3,-1562.26,28.33 },
	{ -329.81,-1471.63,29.73 },
	{ -324.74,-1480.41,29.73 },
	{ -317.26,-1476.09,29.73 },
	{ -322.33,-1467.31,29.73 },
	{ -314.92,-1463.03,29.73 },
	{ -309.85,-1471.79,29.73 },
	{ 1786.08,3329.86,40.42 },
	{ 1785.04,3331.48,40.35 },
	{ 50.31,2778.54,57.05 },
	{ 48.92,2779.59,57.05 },
	{ 264.98,2607.18,43.99 },
	{ 263.09,2606.8,43.99 },
	{ 1035.45,2674.44,38.71 },
	{ 1043.22,2674.45,38.71 },
	{ 1043.22,2667.92,38.71 },
	{ 1035.45,2667.91,38.71 },
	{ 1209.59,2658.36,36.9 },
	{ 1208.52,2659.43,36.9 },
	{ 1205.91,2662.05,36.9 },
	{ 2539.8,2594.81,36.96 },
	{ 2001.55,3772.21,31.4 },
	{ 2003.92,3773.48,31.4 },
	{ 2006.21,3774.96,31.4 },
	{ 2009.26,3776.78,31.4 },
	{ 1684.6,4931.66,41.23 },
	{ 1690.1,4927.81,41.23 },
	{ 1705.74,6414.61,31.77 },
	{ 1701.73,6416.49,31.77 },
	{ 1697.76,6418.35,31.77 },
	{ -97.06,6416.77,30.65 },
	{ -91.29,6422.54,30.65 },
	{ -1808.71,799.96,137.69 },
	{ -1803.62,794.4,137.69 },
	{ -1797.22,800.56,137.66 },
	{ -1802.31,806.12,137.66 },
	{ -1795.93,811.97,137.7 },
	{ -1790.83,806.41,137.7 },
	{ -1438.07,-268.69,45.41 },
	{ -1444.5,-274.23,45.41 },
	{ -1435.5,-284.68,45.41 },
	{ -1429.07,-279.15,45.41 },
	{ -732.64,-932.51,18.22 },
	{ -732.64,-939.32,18.22 },
	{ -724.0,-939.32,18.22 },
	{ -724.0,-932.51,18.22 },
	{ -715.43,-932.51,18.22 },
	{ -715.43,-939.32,18.22 },
	{ -532.28,-1212.71,17.33 },
	{ -529.51,-1213.96,17.33 },
	{ -524.92,-1216.15,17.33 },
	{ -522.23,-1217.42,17.33 },
	{ -518.52,-1209.5,17.33 },
	{ -521.21,-1208.23,17.33 },
	{ -525.8,-1206.04,17.33 },
	{ -528.57,-1204.8,17.33 },
	{ -72.03,-1765.1,28.53 },
	{ -69.45,-1758.01,28.55 },
	{ -77.59,-1755.05,28.81 },
	{ -80.17,-1762.14,28.8 },
	{ -63.61,-1767.93,28.27 },
	{ -61.03,-1760.85,28.31 },
	{ 814.53,-789.63,25.251 },
	{ 812.96,-789.63,25.251 },
	{ 807.00,-789.63,25.251 },
	{ 805.42,-789.63,25.251 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
local AddedZone = {}
CreateThread(function()
	RegisterCommand("+entityTarget",TargetEnable)
	RegisterCommand("-entityTarget",TargetDisable)
	RegisterKeyMapping("+entityTarget", _t("entityTarget"), "keyboard", "LMENU")
    --[[ for i=1,#ATMCoords do
        AddBoxZone("ATM"..i,ATMCoords[i],0.50,0.50,{
            name = "ATM"..i,
            heading = 3374176,
            minZ = ATMCoords[i].z - 1.00,
            maxZ = ATMCoords[i].z + 1.00
        },{
            shop = i,
            Distance = 2.0,
            options = {
                {
                    event = "target:ATMRobbery",
                    label = _t("rob_atm"),
                    tunnel = "client",
                    number = i
                },
                {
                    event = "target:OpenBank",
                    label = _t("access_atm"),
                    tunnel = "client"
                }
            }
        })
    end ]]
    
	AddTargetModel({ -1364697528,-1364697528,-870868698,-1126237515 },{
		options = {
			{
				event = "target:ATMRobbery",
				label = _t("rob_atm"),
				tunnel = "client",
			},
			{
				event = "target:OpenBank",
				label = _t("access_atm"),
				tunnel = "client"
			}
		},
		Distance = 4.0
	})
	AddBoxZone("CallBurgerShot",vec3(-1187.86,-904.92,13.73),0.25,0.25,{
		name = "CallBurgerShot",
		heading = 3374176,
		minZ = 13.50,
		maxZ = 14.00
	},{
		shop = "BurgerShot",
		Distance = 1.0,
		options = {
			{
				event = "target:CallWorks",
				label = _t("call_deliverers"),
				tunnel = "server"
			}
		}
	})

	AddBoxZone("CallUwuCoffee",vec3(-584.09,-1061.45,22.37),0.25,0.25,{
		name = "CallUwuCoffee",
		heading = 3374176,
		minZ = 22.25,
		maxZ = 22.50
	},{
		shop = "UwU Café",
		Distance = 1.0,
		options = {
			{
				event = "target:CallWorks",
				label = _t("call_deliverers"),
				tunnel = "server"
			}
		}
	})

	AddBoxZone("CallPizzaThis",vec3(811.28,-750.61,26.85),0.25,0.25,{
		name = "CallPizzaThis",
		heading = 3374176,
		minZ = 26.50,
		maxZ = 27.00
	},{
		shop = "Pizza This",
		Distance = 1.0,
		options = {
			{
				event = "target:CallWorks",
				label = _t("call_deliverers"),
				tunnel = "server"
			}
		}
	})

	AddBoxZone("CallBeanMachine",vec3(122.22,-1036.56,29.44),0.25,0.25,{
		name = "CallBeanMachine",
		heading = 3374176,
		minZ = 29.25,
		maxZ = 29.75
	},{
		shop = "Bean Machine",
		Distance = 1.0,
		options = {
			{
				event = "target:CallWorks",
				label = _t("call_deliverers"),
				tunnel = "server"
			}
		}
	})

	AddBoxZone("CallParamedic",vec3(311.83,-593.31,43.08),0.25,0.25,{
		name = "CallParamedic",
		heading = 3374176,
		minZ = 43.00,
		maxZ = 43.25
	},{
		shop = "Paramedic",
		Distance = 2.0,
		options = {
			{
				event = "target:CallWorks",
				label = _t("call_deliverers"),
				tunnel = "server"
			}
		}
	})

	AddTargetModel({ -2007231801,1339433404,1694452750,1933174915,-462817101,-469694731,-164877493,486135101 },{
		options = {
			{
				event = "shops:Fuel",
				label = _t("fuel"),
				tunnel = "client"
			}
		},
		Distance = 0.75
	})

	AddCircleZone("makePaper",vec3(-533.18,5292.15,74.17),0.5,{
		name = "makePaper",
		heading = 3374176
	},{
		Distance = 0.75,
		options = {
			{
				event = "inventory:MakeProducts",
				label = _t("produce"),
				tunnel = "products",
				service = "paper"
			}
		}
	})

	AddCircleZone("Yoga01",vec3(-492.83,-217.31,35.61),0.5,{
		name = "Yoga01",
		heading = 3374176
	},{
		Distance = 1.25,
		options = {
			{
				event = "player:Yoga",
				label = _t("yoga"),
				tunnel = "client"
			}
		}
	})

	AddCircleZone("Yoga02",vec3(-492.87,-219.03,36.55),0.5,{
		name = "Yoga02",
		heading = 3374176
	},{
		Distance = 1.25,
		options = {
			{
				event = "player:Yoga",
				label = _t("yoga"),
				tunnel = "client"
			}
		}
	})

	AddCircleZone("Yoga03",vec3(-492.89,-220.68,36.51),0.5,{
		name = "Yoga03",
		heading = 3374176
	},{
		Distance = 1.25,
		options = {
			{
				event = "player:Yoga",
				label = _t("yoga"),
				tunnel = "client"
			}
		}
	})

	AddCircleZone("Yoga04",vec3(-490.21,-220.91,36.51),0.5,{
		name = "Yoga04",
		heading = 3374176
	},{
		Distance = 1.25,
		options = {
			{
				event = "player:Yoga",
				label = _t("yoga"),
				tunnel = "client"
			}
		}
	})

	AddCircleZone("Yoga05",vec3(-490.18,-219.24,36.58),0.5,{
		name = "Yoga05",
		heading = 3374176
	},{
		Distance = 1.25,
		options = {
			{
				event = "player:Yoga",
				label = _t("yoga"),
				tunnel = "client"
			}
		}
	})

	AddCircleZone("Yoga06",vec3(-490.16,-217.33,36.63),0.5,{
		name = "Yoga06",
		heading = 3374176
	},{
		Distance = 1.25,
		options = {
			{
				event = "player:Yoga",
				label = _t("yoga"),
				tunnel = "client"
			}
		}
	})

	AddTargetModel({ 654385216,161343630,-430989390,1096374064,-1519644200,-1932041857,207578973,-487222358 },{
		options = {
			{
				event = "slotmachine:Init",
				label = "Caça-Níqueis",
				tunnel = "client"
			}
		},
		Distance = 0.75
	})

	AddTargetModel({ -1691644768,-742198632 },{
		options = {
			{
				event = "inventory:MakeProducts",
				label = "Encher",
				tunnel = "products",
				service = "emptybottle"
			},
			{
				event = "inventory:Drink",
				label = _t("drink"),
				tunnel = "server"
			}
		},
		Distance = 0.75
	})

	AddTargetModel({ -935625561 },{
		options = {
			{
				event = "target:BedDeitar",
				label = _t("lay"),
				tunnel = "client"
			},{
				event = "target:BedPickup",
				label = _t("pick_up"),
				tunnel = "client"
			},{
				event = "target:BedDestroy",
				label = _t("destroy"),
				tunnel = "client"
			}
		},
		Distance = 1.0
	})

	AddTargetModel({ 690372739 },{
		options = {
			{
				event = "shops:coffeeMachine",
				label = _t("buy"),
				tunnel = "client"
			}
		},
		Distance = 1.0
	})

	AddTargetModel({ -654402915,1421582485 },{
		options = {
			{
				event = "shops:donutMachine",
				label = _t("buy"),
				tunnel = "client"
			}
		},
		Distance = 1.0
	})

	AddTargetModel({ 992069095,1114264700 },{
		options = {
			{
				event = "shops:sodaMachine",
				label = _t("buy"),
				tunnel = "client"
			}
		},
		Distance = 1.0
	})

	AddTargetModel({ 1129053052 },{
		options = {
			{
				event = "shops:burgerMachine",
				label = _t("buy"),
				tunnel = "client"
			}
		},
		Distance = 1.0
	})

	AddTargetModel({ -1581502570 },{
		options = {
			{
				event = "shops:hotdogMachine",
				label = _t("buy"),
				tunnel = "client"
			}
		},
		Distance = 1.0
	})

	AddTargetModel({ -272361894 },{
		options = {
			{
				event = "shops:Chihuahua",
				label = _t("buy"),
				tunnel = "client"
			}
		},
		Distance = 1.0
	})

	AddTargetModel({ 1099892058 },{
		options = {
			{
				event = "shops:waterMachine",
				label = _t("buy"),
				tunnel = "client"
			}
		},
		Distance = 1.0
	})

	AddTargetModel({ 1281992692,1158960338,1511539537,-78626473,-429560270 },{
		options = {
			{
				event = "hup:phoneObject",
				label = "Ligar",
				tunnel = "client"
			}
		},
		Distance = 1.0
	})

	AddTargetModel({ -206690185,666561306,218085040,-58485588,1511880420,682791951 },{
		options = {
			{
				event = "player:enterTrash",
				label = _t("hide"),
				tunnel = "client"
			},{
				event = "player.attempt_check_player_in_trash",
				label = _t("inspect"),
				tunnel = "client"
			},{
				event = "chest:Open",
				label = _t("open"),
				tunnel = "entity",
				service = "Custom"
			}
		},
		Distance = 0.75
	})

	AddCircleZone("Juice01",vec3(-1189.37,-905.32,14.53),0.5,{
		name = "Juice01",
		heading = 3374176
	},{
		Distance = 1.25,
		options = {
			{
				event = "inventory:MakeProducts",
				label = _t("fill_cup"),
				tunnel = "products",
				service = "burgershot1"
			}
		}
	})

	AddCircleZone("Burger01",vec3(-1202.74,-897.66,13.93),0.5,{
		name = "Burger01",
		heading = 3374176
	},{
		Distance = 1.0,
		options = {
			{
				event = "inventory:MakeProducts",
				label = _t("assemble_sandwich"),
				tunnel = "products",
				service = "burgershot2"
			}
		}
	})

	AddCircleZone("Box01",vec3(-1198.27,-892.84,14.31),0.5,{
		name = "Box01",
		heading = 3374176
	},{
		Distance = 1.25,
		options = {
			{
				event = "inventory:MakeProducts",
				label = _t("assemble_combo"),
				tunnel = "products",
				service = "burgershot3"
			}
		}
	})

	AddCircleZone("Juice02",vec3(810.69,-764.58,26.77),0.5,{
		name = "Juice02",
		heading = 3374176
	},{
		Distance = 1.25,
		options = {
			{
				event = "inventory:MakeProducts",
				label = _t("fill_cup"),
				tunnel = "products",
				service = "pizzathis1"
			}
		}
	})

	AddCircleZone("Burger02",vec3(807.68,-762.3,26.77),0.5,{
		name = "Burger02",
		heading = 3374176
	},{
		Distance = 1.0,
		options = {
			{
				event = "inventory:MakeProducts",
				label = _t("assemble_sandwich"),
				tunnel = "products",
				service = "pizzathis2"
			}
		}
	})

	AddCircleZone("Box02",vec3(809.87,-761.15,26.77),0.5,{
		name = "Box02",
		heading = 3374176
	},{
		Distance = 1.25,
		options = {
			{
				event = "inventory:MakeProducts",
				label = _t("assemble_combo"),
				tunnel = "products",
				service = "pizzathis3"
			}
		}
	})

	AddCircleZone("Juice03",vec3(-590.36,-1058.54,22.34),0.5,{
		name = "Juice03",
		heading = 3374176
	},{
		Distance = 1.25,
		options = {
			{
				event = "inventory:MakeProducts",
				label = _t("fill_cup"),
				tunnel = "products",
				service = "uwucoffee1"
			}
		}
	})

	AddCircleZone("Burger03",vec3(-590.49,-1056.51,22.36),0.5,{
		name = "Burger03",
		heading = 3374176
	},{
		Distance = 1.0,
		options = {
			{
				event = "inventory:MakeProducts",
				label = _t("assemble_sandwich"),
				tunnel = "products",
				service = "uwucoffee2"
			}
		}
	})

	AddCircleZone("Box03",vec3(-590.5,-1063.02,22.36),0.5,{
		name = "Box03",
		heading = 3374176
	},{
		Distance = 1.25,
		options = {
			{
				event = "inventory:MakeProducts",
				label = _t("assemble_combo"),
				tunnel = "products",
				service = "uwucoffee3"
			}
		}
	})

	AddCircleZone("Juice04",vec3(126.28,-1035.83,29.27),0.5,{
		name = "Juice04",
		heading = 3374176
	},{
		Distance = 1.25,
		options = {
			{
				event = "inventory:MakeProducts",
				label = _t("fill_cup"),
				tunnel = "products",
				service = "beanmachine1"
			}
		}
	})

	AddCircleZone("Burger04",vec3(122.31,-1038.35,29.27),0.5,{
		name = "Burger04",
		heading = 3374176
	},{
		Distance = 1.0,
		options = {
			{
				event = "inventory:MakeProducts",
				label = _t("assemble_sandwich"),
				tunnel = "products",
				service = "beanmachine2"
			}
		}
	})

	AddCircleZone("Box04",vec3(122.79,-1044.03,29.27),0.5,{
		name = "Box04",
		heading = 3374176
	},{
		Distance = 1.25,
		options = {
			{
				event = "inventory:MakeProducts",
				label = _t("assemble_combo"),
				tunnel = "products",
				service = "beanmachine3"
			}
		}
	})

	AddCircleZone("tabletVehicles01",vec3(-38.9,-1100.22,27.26),0.5,{
		name = "tabletVehicles01",
		heading = 3374176
	},{
		shop = "Santos",
		Distance = 1.0,
		options = {
			{
				event = "tablet:Open",
				label = _t("open"),
				tunnel = "shop"
			}
		}
	})

	AddCircleZone("tabletVehicles02",vec3(-40.37,-1094.57,27.26),0.5,{
		name = "tabletVehicles02",
		heading = 3374176
	},{
		shop = "Santos",
		Distance = 1.0,
		options = {
			{
				event = "tablet:Open",
				label = _t("open"),
				tunnel = "shop"
			}
		}
	})

	AddCircleZone("tabletVehicles03",vec3(-46.87,-1095.5,27.26),0.5,{
		name = "tabletVehicles03",
		heading = 3374176
	},{
		shop = "Santos",
		Distance = 1.0,
		options = {
			{
				event = "tablet:Open",
				label = _t("open"),
				tunnel = "shop"
			}
		}
	})

	AddCircleZone("tabletVehicles04",vec3(-51.59,-1094.98,27.26),0.5,{
		name = "tabletVehicles04",
		heading = 3374176
	},{
		shop = "Santos",
		Distance = 1.0,
		options = {
			{
				event = "tablet:Open",
				label = _t("open"),
				tunnel = "shop"
			}
		}
	})

	AddCircleZone("tabletVehicles05",vec3(-51.15,-1087.13,27.26),0.5,{
		name = "tabletVehicles05",
		heading = 3374176
	},{
		shop = "Santos",
		Distance = 1.0,
		options = {
			{
				event = "tablet:Open",
				label = _t("open"),
				tunnel = "shop"
			}
		}
	})

	AddCircleZone("tabletVehicles06",vec3(1224.78,2728.01,38.0),0.5,{
		name = "tabletVehicles06",
		heading = 3374176
	},{
		shop = "Sandy",
		Distance = 2.0,
		options = {
			{
				event = "tablet:Open",
				label = _t("open"),
				tunnel = "shop"
			}
		}
	})

	AddCircleZone("cemiteryMan",vec3(-1745.57,-205.19,57.37),0.5,{
		name = "cemiteryMan",
		heading = 3374176
	},{
		Distance = 1.0,
		options = {
			{
				event = "cemitery:initBody",
				label = _t("talk"),
				tunnel = "client"
			}
		}
	})

	AddCircleZone("CassinoWheel",vec3(988.37,43.06,71.3),0.5,{
		name = "CassinoWheel",
		heading = 3374176
	},{
		Distance = 1.5,
		options = {
			{
				event = "luckywheel:Target",
				label = _t("fortune_wheel"),
				tunnel = "client"
			}
		}
	})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGETENABLE
-----------------------------------------------------------------------------------------------------------------------------------------
local CooldownWarMode = GetGameTimer()
local AddedBox = {}
local PuroPrimePassportsCitys = {
    ["CidadeNobre"] = {
        [6] = "Domn",
    }
}
local PuroPrimePassports = PuroPrimePassportsCitys[cityName] or {}
function TargetEnable()
    LocalPlayer["state"]["Target"] = true
    local inWarMode = false
    local Ped = PlayerPedId()
    local PlayerSource = GetPlayerServerId((NetworkGetPlayerIndexFromPed(Ped)))

    AddedBox = {}
    if not GlobalState["Premios"] then
        TriggerEvent("RewardsDisable",false)
    end
    --[[ if not GlobalState["AssaultHourDisable"] then
        TriggerEvent("AssaultHourDisable",false)
    end ]]

    CreateThread(function()
        while LocalPlayer["state"]["Target"] do
            local Peds = GetGamePool("CPed")
            local PedCoords = GetEntityCoords(Ped)
            local isUsingFreecam = exports.admin:IsUsingFreecam()
            if isUsingFreecam then
                PedCoords = GetFinalRenderedCamCoord()
            end
            for i=1,#Peds do
                local SelectedPed = Peds[i]
                if IsPedAPlayer(SelectedPed) then
                    local Newbie = Entity(SelectedPed)["state"]["Newbie"]
                    local Coords = GetEntityCoords(SelectedPed)
                    local Distance = #(PedCoords - Coords)
                    if Newbie and Distance <= 20 then
                        DrawMarker(23,Coords["x"],Coords["y"],Coords["z"] - 0.97,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,0.0,46,110,76,100,0,0,0,0)
                    end
                end
            end
            Wait(1)
        end
        if not GlobalState["Premios"] then
            TriggerEvent("RewardsDisable",true)
        end
       --[[  if not GlobalState["AssaultHourDisable"] then
            TriggerEvent("AssaultHourDisable",true)
        end ]]
    end)

    CreateThread(function()
        while LocalPlayer["state"]["Target"] do
            local Players = GetActivePlayers()
            local isUsingFreecam = exports.admin:IsUsingFreecam()
            for i=1,#Players do
                local SelectedPlayer = Players[i]
                local PlayerPed = GetPlayerPed(SelectedPlayer)
                local PedCoords = GetEntityCoords(Ped)
                if isUsingFreecam then
                    PedCoords = GetFinalRenderedCamCoord()
                end
                local HasClearLos = isUsingFreecam and true or HasEntityClearLosToEntity(Ped,PlayerPed,17)
                if PlayerPed == Ped then
                    goto Skip
                end

                if NetworkIsPlayerTalking(SelectedPlayer) then
                    local Coords = GetEntityCoords(PlayerPed)
                    local Distance = #(PedCoords - Coords)
                    if Distance <= 20 then
                        DrawMarker(27,Coords["x"],Coords["y"],Coords["z"] - 0.97,0.0,0.0,0.0,0.0,0.0,0.0,1.25,1.25,0.0,46,110,76,100,0,0,0,0)
                    end
                else
                    local Coords = GetEntityCoords(PlayerPed)
                    local Distance = #(PedCoords - Coords)
                    local Recording = Entity(PlayerPed)["state"]["recording"]
                    if Distance <= 20 and IsEntityVisible(PlayerPed) and HasClearLos and not Recording then
                        local tracking = Entity(PlayerPed)["state"]["tracking"]
                        if not tracking then
                            tracking = 0
                        end
                        local Hours =  parseInt(tracking/3600)
                        local HoursText = ""
                        if not Hours then
                            Hours = 0
                        end
                        
                        if Hours > 0 then
                            if Hours < 50 then
                                DrawMarker(23,Coords["x"],Coords["y"],Coords["z"] - 0.97,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,0.0, 255, 215, 0, 75,0,0,0,0)
                            end
                        else
                            DrawMarker(23,Coords["x"],Coords["y"],Coords["z"] - 0.97,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,0.0, 255, 215, 0, 75,0,0,0,0)
                        end
                    end
                end
                ::Skip::
            end
            Wait(1)
        end
    end)

	if LocalPlayer["state"]["Active"] and not IsPauseMenuActive() and not LocalPlayer["state"]["Carregar"] then
		local Ped = PlayerPedId()

		if GetEntityHealth(Ped) <= 100 or LocalPlayer["state"]["Buttons"] or LocalPlayer["state"]["Commands"] or LocalPlayer["state"]["Handcuff"] or Sucess or IsPedInAnyVehicle(Ped) or LocalPlayer["state"]["Route"] > 900000 then
			return
		end

        CreateThread(function()
            while LocalPlayer["state"]["Target"] do
                local Peds = GetActivePlayers()
                local PedCoords = GetEntityCoords(Ped)
                local isUsingFreecam = exports.admin:IsUsingFreecam()
                if isUsingFreecam then
                    PedCoords = GetFinalRenderedCamCoord()
                end
                for i=1,#Peds do
                    local SelectedPed = GetPlayerPed(Peds[i])
                    if IsPedAPlayer(SelectedPed) then
                        local SelectCoords = GetEntityCoords(SelectedPed)
                        local Distance = #(PedCoords - SelectCoords)
                        local Wanted = Entity(SelectedPed)["state"]["Wanted"]
                        local Recording = Entity(SelectedPed)["state"]["recording"]
                        local HasClearLos = isUsingFreecam and true or HasEntityClearLosToEntity(Ped,SelectedPed,17)
                        if IsEntityVisible(SelectedPed) and HasClearLos and Wanted and not Recording then
                            if Distance <= 5.0 then
                                DrawText(SelectCoords["x"],SelectCoords["y"],SelectCoords["z"]+1.25,"~r~".._t("wanted").."~w~")
                            end
                        end
                    end
                end
                Wait(1)
            end
        end)

		SendNUIMessage({ Action = "Open" })

        CreateThread(function()
            while LocalPlayer["state"]["Target"] do
                local Peds = GetActivePlayers()
                local PedCoords = GetEntityCoords(Ped)
                local isUsingFreecam = exports.admin:IsUsingFreecam()
                if isUsingFreecam then
                    PedCoords = GetFinalRenderedCamCoord()
                end
                for i=1,#Peds do
                    local SelectedPed = GetPlayerPed(Peds[i])

                    if IsPedAPlayer(SelectedPed) then
                        local Newbie = Entity(SelectedPed)["state"]["Newbie"]
                        local Title = Entity(SelectedPed)["state"]["Title"]
                        local VIP = Entity(SelectedPed)["state"]["VipEmote"]
                        local VipGroup = Entity(SelectedPed)["state"]["VipGroup"]
                        local Country = Entity(SelectedPed)["state"]["Country"]
						local isAPlayerMute = Entity(SelectedPed)["state"]["Muted"]
						local sid = GetPlayerServerId(NetworkGetPlayerIndexFromPed(SelectedPed))

						if VipGroup and VipGroup == "VipImperial" and Player(sid).state.Spotify and not Player(sid).state.VipImperial then
							VIP = nil
							VipGroup = nil
						end

						local isAPlayerAfk = exports.player:IsAfk( sid )
						
						local Affiliate = Player(sid)["state"]["Afiliado"]
						local Passport = Player(sid).state.Passport or Entity(SelectedPed)["state"]["Passport"]
						if (not Passport or Passport == 0) and sid == GetPlayerServerId(PlayerId()) then
							Passport = LocalPlayer["state"]["Passport"]
						end
                        if Newbie then
                            Title = "Iniciante"
                        end

                        local Distance = #(PedCoords - GetEntityCoords(SelectedPed))
                        local Coords = GetEntityCoords(SelectedPed)
                        local Recording = Entity(SelectedPed)["state"]["recording"]
                        local HasClearLos = isUsingFreecam and true or HasEntityClearLosToEntity(Ped,SelectedPed,17)
                        if Distance <= 5.0 and IsEntityVisible(SelectedPed) and HasClearLos and Title and not Recording then
                            DrawText3D(Coords["x"],Coords["y"],Coords["z"]+1.0,Title)
                        end
                        if Distance <= 5.0 and IsEntityVisible(SelectedPed) and HasClearLos and not Recording then
                            DrawText3D(Coords["x"],Coords["y"],Coords["z"]+0.25,Country, 0.20, 255, 255, 255, 0, true)
                        end
                        local vipIcon = VipGroup and (GlobalState["GroupEmoji"] or {})[VipGroup]

                        if (VIP or vipIcon) and Distance <= 5.0 and IsEntityVisible(SelectedPed) and HasClearLos and not Recording then
                            if PuroPrimePassports[Passport] then
                                VIP = "🐊"
                            end
                            VIP = vipIcon or VIP
                            DrawText(Coords["x"],Coords["y"],Coords["z"]+1.16,VIP)
                        end
                        if Distance <= 5.0 and IsEntityVisible(SelectedPed) and HasClearLos and not Recording then
                            if Entity(SelectedPed)["state"]["tracking"] then
								local HoursText = ""
								if not Affiliate then
									local tracking = Entity(SelectedPed)["state"]["tracking"]
									if not tracking then
										tracking = 0
									end
									local Hours =  parseInt(tracking/3600)
									if not Hours then
										Hours = 0
									end
									
									if Hours > 0 then
										if Hours < 3 then
											HoursText = "~g~".._t("beginner").."~w~"
										elseif Hours > 3 and Hours < 50 then
											HoursText = "~y~"..Hours.." h | ".._t("under_evaluation").."~w~"
										else
											HoursText = "~w~"..Hours.." h ~w~"
										end
									else
										HoursText = "~g~".._t("beginner").."~w~"
									end
								else
									HoursText = "~y~".._t("commercial_team").."~w~"
                                    local HoursText2 = ""
                                    local tracking = Entity(SelectedPed)["state"]["tracking"]
                                    if not tracking then
                                        tracking = 0
                                    end
                                    local Hours =  parseInt(tracking/3600)
                                    if not Hours then
                                        Hours = 0
                                    end
                                    Hours = Hours + 1000
                                    HoursText2 = "~w~"..Hours.." h ~w~"
                                    DrawText3D(Coords["x"],Coords["y"],Coords["z"]-0.2,HoursText2)
								end

                                local Coords = GetEntityCoords(SelectedPed)
                                DrawText3D(Coords["x"],Coords["y"],Coords["z"],HoursText)
                            end

							local AffiliateDrawVip = false
                            local Text = "~r~".._t("noVIP").."~w~"
                            local r,g,b = 255,0,0

                            if VipGroup and VipGroup ~= "" then
								AffiliateDrawVip = true
                                if PuroPrimePassports[Passport] then
                                    VipGroup = " PuroPrime"
                                end
                                local VipColor = GetVipColor(VipGroup)
                                local customVipColor = GetCustomVipColor(VipGroup)
                                if not VipColor then
                                    VipColor = { text = "~g~", r = 204, g = 102, b = 0 }
                                end
                                if not VipColor.text then
                                    VipColor = { text = "~g~", r = 204, g = 102, b = 0 }
                                end
                                local hasForcedVipColor = PuroPrimePassports[Passport] or VipGroup == "PuroPrime" or VipGroup == "VipGusta"
                                if hasForcedVipColor then
                                    VipColor = { text = "~r~", r = 255, g = 0, b = 0 }
                                elseif customVipColor then
                                    VipColor = customVipColor
                                end
                                local alias = GetAliasByGroup(VipGroup)
                                if not CheckVIPRank(VipGroup) then
                                    alias = ""
                                end
                                local displayAlias = alias
                                if VipGroup:lower() == "vipatl" then
                                    displayAlias = "VIP ATL"
                                elseif VipGroup:lower() == "vipgusta" then
                                    displayAlias = "VIP BoiGusta"
                                elseif VipGroup:lower() == "vipolympus" then
                                    displayAlias = "Olympus Vip"
                                elseif not displayAlias:upper():match("^VIP%s+") then
                                    displayAlias = "VIP "..displayAlias
                                end
                                if VipColor.isCustom then
                                    Text = string.upper(displayAlias)
                                elseif VipGroup == "VipGinD10" then
                                    Text = VipColor.text..string.upper(displayAlias).."~w~"
                                else
                                    Text = string.upper(VipColor.text..displayAlias.."~w~")
                                end
                                r,g,b = VipColor.r,VipColor.g,VipColor.b
                            end

							if isAPlayerMute then
								textMute = "~r~MUTED~w~"
								
                            	DrawText3D(Coords["x"],Coords["y"],Coords["z"]+0.8,textMute,0.35,r,g,b)
							end

							if isAPlayerAfk then

								textAfk = "~r~AFK~w~"
								
                            	DrawText3D(Coords["x"],Coords["y"],Coords["z"]-0.2,textAfk,0.35,r,g,b)
							else
								local socialLevel = Player(sid).state["SocialSkillLevel"] or 1
								local colorIndex = GetSocialColorIndex(socialLevel)
								local socialColor = SOCIAL_DIGIT_COLORS[colorIndex] or SOCIAL_DIGIT_COLORS[1]
								DrawText3D(Coords["x"], Coords["y"], Coords["z"] - 0.2, _t("level_social"):format(socialLevel), 0.35, socialColor.r, socialColor.g, socialColor.b)
							end

							if not Affiliate or (Affiliate and AffiliateDrawVip) then
                            	DrawText3D(Coords["x"],Coords["y"],Coords["z"]+0.2,Text,0.35,r,g,b)
							end

							local resolvedPassport = (Passport and Passport > 0) and Passport or (Player(sid).state.Passport or Entity(SelectedPed)["state"]["Passport"] or (sid == GetPlayerServerId(PlayerId()) and LocalPlayer["state"]["Passport"]))
							local passport = exports.admin:GetCustomPassportLabel(resolvedPassport) or resolvedPassport or 0

							if not Affiliate or (Affiliate and resolvedPassport and resolvedPassport <= 1000) then
                            	DrawText3D(Coords["x"],Coords["y"],Coords["z"]+0.4,"~w~ID: "..passport.."~w~",0.35,r,g,b)
							end
                        end
                    else
                        local Distance = #(PedCoords - GetEntityCoords(SelectedPed))
                        local PetName = Entity(SelectedPed)["state"]["petName"]
                        local Recording = Entity(SelectedPed)["state"]["recording"]
                        local HasClearLos = isUsingFreecam and true or HasEntityClearLosToEntity(Ped,SelectedPed,17)
                        if Distance <= 5.0 and IsEntityVisible(SelectedPed) and HasClearLos and PetName and not Recording then
                            local Coords = GetEntityCoords(SelectedPed)
                            DrawText3D(Coords["x"],Coords["y"],Coords["z"],PetName)
                        end
                    end
                end
                Wait(1)
            end
        end)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:ROLLVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:RollVehicle")
AddEventHandler("target:RollVehicle",function(Network)
	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) then
			SetVehicleOnGroundProperly(Vehicle)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGETDISABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function TargetDisable()
	if Sucess or not LocalPlayer["state"]["Target"] then
		return
	end
    for Zone,Name in pairs(AddedZone) do
        RemCircleZone(Name)
        AddedZone[Zone] = nil
    end
	SendNUIMessage({ Action = "Close" })
	LocalPlayer["state"]["Target"] = false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASGROUP
-----------------------------------------------------------------------------------------------------------------------------------------
---@param group string
---@return number?
function HasGroup(group)
    local groups = vRP.GetPlayerGroups() or {}
    local groupsParent = Groups[group] and Groups[group]["Parent"]

    if groups[group] then
        return groups[group]
    end

    if groupsParent then
        for parentGroup, _ in pairs(groupsParent) do
            if groups[parentGroup] then
                return groups[parentGroup]
            end
        end
    end

    return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SELECT
-----------------------------------------------------------------------------------------------------------------------------------------
local ReportCooldown = GetGameTimer()
local BoxReportCooldown = GetGameTimer()
RegisterNUICallback("Select",function(Data,Callback)
    if not LocalPlayer["state"]["Target"] then
        return
    end
	Sucess = false
	SetNuiFocus(false,false)
	SendNUIMessage({ Action = "Close" })
	LocalPlayer["state"]["Target"] = false

    for Zone,Name in pairs(AddedZone) do
        RemCircleZone(Name)
        AddedZone[Zone] = nil
    end

	if Data["tunnel"] == "client" then
		TriggerEvent(Data["event"],Selected)
	elseif Data["tunnel"] == "shop" then
		TriggerEvent(Data["event"],Selected,Data["service"])
	elseif Data["tunnel"] == "entity" then
		TriggerEvent(Data["event"],Selected[1],Data["service"])
	elseif Data["tunnel"] == "products" then
		TriggerEvent(Data["event"],Data["service"])
	elseif Data["tunnel"] == "Airdrop" then
		TriggerServerEvent(Data["event"],Entity(Selected)["state"]["Entity"])
	elseif Data["tunnel"] == "reportBox" then
        ReportBox = GetConvar("ReportBox", "")
        if ReportBox == "false" then
            --TriggerEvent("Notify","aviso","Sistema temporariamente desativado",5000,"REPORT BOX")
			TriggerEvent("Notify2","#systemTempOff")
            return
        end
        if BoxReportCooldown > GetGameTimer() then
            --TriggerEvent("Notify","vermelho","Você precisa esperar "..parseInt((BoxReportCooldown - GetGameTimer()) / 1000).." segundos para reportar novamente.",5000,"REPORTAR BOX")
			TriggerEvent("Notify2","#waitReportBox",{msg=parseInt((BoxReportCooldown - GetGameTimer()) / 1000)})
            return
        end
        BoxReportCooldown = GetGameTimer() + 30000
        TriggerServerEvent(Data["event"],Entity(Selected)["state"]["User"])
	elseif Data["tunnel"] == "server" then
		TriggerServerEvent(Data["event"],Selected)
	elseif Data["tunnel"] == "police" then
		TriggerServerEvent(Data["event"],Selected,Data["service"])
	elseif Data["tunnel"] == "report" then
        if ReportCooldown > GetGameTimer() then
            --TriggerEvent("Notify","vermelho","Você precisa esperar "..parseInt((ReportCooldown - GetGameTimer()) / 1000).." segundos para reportar novamente.",5000,"REPORTAR")
			TriggerEvent("Notify2","#waitReportCD",{msg=parseInt((ReportCooldown - GetGameTimer()) / 1000)})
            return
        end
        ReportCooldown = GetGameTimer() + 30000
		TriggerServerEvent(Data["event"],Selected[1],Data["service"])
	elseif Data["tunnel"] == "warmode" then
        if CooldownWarMode > GetGameTimer() then
            --TriggerEvent("Notify","vermelho","Você precisa esperar "..parseInt((CooldownWarMode - GetGameTimer()) / 1000).." segundos para usar o MODO GUERRA novamente.",5000,"MODO GUERRA")
			TriggerEvent("Notify2","#waitEnterWarMode",{msg=parseInt((CooldownWarMode - GetGameTimer()) / 1000)})
            return
        end
        if not HasGroup("Policia") then 
            CooldownWarMode = GetGameTimer() + 15000
        end
		TriggerServerEvent(Data["event"],Selected[1])
	elseif Data["tunnel"] == "paramedic" then
		TriggerServerEvent(Data["event"],Selected[1],Data["service"])
	elseif Data["tunnel"] == "instagram" then
		TriggerEvent("openInstagram",Data["event"])
	elseif Data["tunnel"] == "tiktok" then
		TriggerEvent("openTikTok",Data["event"])
	elseif Data["tunnel"] == "proserver" then
		TriggerServerEvent(Data["event"],Data["service"])
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	Sucess = false
	SetNuiFocus(false,false)
	SendNUIMessage({ Action = "Close" })
	LocalPlayer["state"]["Target"] = false

    for Zone,Name in pairs(AddedZone) do
        RemCircleZone(Name)
        AddedZone[Zone] = nil
    end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:Debug")
AddEventHandler("target:Debug",function()
	Sucess = false
	SetNuiFocus(false,false)
	SendNUIMessage({ Action = "Close" })
	LocalPlayer["state"]["Target"] = false

    for Zone,Name in pairs(AddedZone) do
        RemCircleZone(Name)
        AddedZone[Zone] = nil
    end

end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCOORDSFROMCAM
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCoordsFromCam(Distance,Coords)
	local Rotation = GetGameplayCamRot()
	local Adjuste = vec3((math.pi / 180) * Rotation["x"],(math.pi / 180) * Rotation["y"],(math.pi / 180) * Rotation["z"])
	local direction = vec3(-math.sin(Adjuste[3]) * math.abs(math.cos(Adjuste[1])),math.cos(Adjuste[3]) * math.abs(math.cos(Adjuste[1])),math.sin(Adjuste[1]))

	return vec3(Coords[1] + direction[1] * Distance, Coords[2] + direction[2] * Distance, Coords[3] + direction[3] * Distance)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RAYCASTGAMEPLAYCAMERA
-----------------------------------------------------------------------------------------------------------------------------------------
function RayCastGamePlayCamera()
	local Ped = PlayerPedId()
	local Cam = GetGameplayCamCoord()
	local Cam2 = GetCoordsFromCam(10.0,Cam)
	local Handle = StartExpensiveSynchronousShapeTestLosProbe(Cam,Cam2,-1,Ped,4)
	local a,Hit,Coords,b,entity = GetShapeTestResult(Handle)

	return Hit,Coords,entity
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDCIRCLEZONE
-----------------------------------------------------------------------------------------------------------------------------------------
function AddCircleZone(Name,Center,Radius,Options,Target)
	Zones[Name] = CircleZone:Create(Center,Radius,Options)
	Zones[Name]["targetoptions"] = Target
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMCIRCLEZONE
-----------------------------------------------------------------------------------------------------------------------------------------
function RemCircleZone(Name)
	if Zones[Name] then
		Zones[Name] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDTARGETMODEL
-----------------------------------------------------------------------------------------------------------------------------------------
function AddTargetModel(Model,Options)
	for _,v in pairs(Model) do
		Models[v] = Options
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LABELTEXT
-----------------------------------------------------------------------------------------------------------------------------------------
function LabelText(Name,Text)
	if Zones[Name] then
		Zones[Name]["targetoptions"]["options"][1]["label"] = Text
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBOXZONE
-----------------------------------------------------------------------------------------------------------------------------------------
function AddBoxZone(Name,Center,Length,Width,Options,Target)
    Zones[Name] = BoxZone:Create(Center,Length,Width,Options)
    Zones[Name]["targetoptions"] = Target
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("LabelText",LabelText)
exports("AddBoxZone",AddBoxZone)
exports("RemCircleZone",RemCircleZone)
exports("AddCircleZone",AddCircleZone)
exports("AddTargetModel",AddTargetModel)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT
-----------------------------------------------------------------------------------------------------------------------------------------

---
---@param x any
---@param y any
---@param z any
---@param text any
---@param scale any
---@param r any
---@param g any
---@param b any
---@param a any
---@param noRect any
function DrawText3D( x, y, z, text, scale, r, g, b, a, noRect )
	local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)
    r,g,b = r or 255, g or 255, b or 255
    a = a or 150
	if onScreen then
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringKeyboardDisplay(text)
		SetTextColour(r,g,b,a)
		SetTextScale(scale or 0.35,scale or 0.35)
		SetTextFont(4)
		SetTextCentre(1)
		EndTextCommandDisplayText(_x,_y)
        if not noRect then
            local width = string.len(text) / 160 * 0.60
            DrawRect(_x,_y + 0.0125,width,0.03,0,0,0,200)
        end
	end
end

function DrawText(x,y,z,Message, scale)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    font = RegisterFontId("Poppins")
    SetTextFont(font)
	if onScreen then
		BeginTextCommandDisplayText("STRING")
		AddTextComponentString(Message)
        SetTextColour(255,215,0,255)
		SetTextScale(scale or 0.35,scale or 0.35)
        SetTextCentre(true)
        SetTextProportional(true)
		EndTextCommandDisplayText(_x,_y)
	end
end

RegisterCommand("instagram",function()
    local Keyboard = exports["keyboard"]:keySingle("Digite seu @ do instagram:")
    if Keyboard and Keyboard[1] then
        local Instagram = Keyboard[1]
        if Instagram ~= "" then
            Instagram = Instagram:gsub("[<>]","")
            Instagram = Instagram:gsub("@","")
            TriggerServerEvent("target:SetInstagram",Instagram)
            SetResourceKvp("Instagram",Instagram)
        else
            SetResourceKvp("Instagram","")
            TriggerServerEvent("target:RemInstagram")
        end
    else
        SetResourceKvp("Instagram","")
        TriggerServerEvent("target:RemInstagram")
    end
end)

RegisterCommand("TikTok",function()
    local Keyboard = exports["keyboard"]:keySingle("Digite seu @ do TikTok:")
    if Keyboard and Keyboard[1] then
        local TikTok = Keyboard[1]
        if TikTok ~= "" then
            TikTok = TikTok:gsub("[<>]","")
            TikTok = TikTok:gsub("@","")
            TriggerServerEvent("target:SetTikTok",TikTok)
            SetResourceKvp("TikTok",TikTok)
        else
            SetResourceKvp("TikTok","")
            TriggerServerEvent("target:RemTikTok")
        end
    else
        SetResourceKvp("TikTok","")
        TriggerServerEvent("target:RemTikTok")
    end
end)

RegisterNetEvent("vRP:Active")
AddEventHandler("vRP:Active",function()
    local Instagram = GetResourceKvpString("Instagram")
    if Instagram and Instagram ~= "" then
        TriggerServerEvent("target:SetInstagram",Instagram)
    end	
    local TikTok = GetResourceKvpString("TikTok")
    if TikTok and TikTok ~= "" then
        TriggerServerEvent("target:SetTikTok",TikTok)
    end	
end)

AddEventHandler("openInstagram",function(instagramUser)
    TriggerEvent("player:OpenURL","https://www.instagram.com/"..instagramUser)
end)
AddEventHandler("openTikTok",function(tiktokUser)
    TriggerEvent("player:OpenURL","https://www.tiktok.com/@"..tiktokUser)
end)

local Reviving = false
RegisterNetEvent("target:SetReviving")
AddEventHandler("target:SetReviving",function(Boolean)
    Reviving = Boolean
end)

AddEventHandler("actions:Cancel",function()
    if Reviving then
        TriggerEvent("Progress","Revivendo",0)
        TriggerServerEvent("target:StopReviving")
        Reviving = false
    end
end)


-- local ATMHash = {
--     -1364697528,
--     -870868698,
--     -1126237515
-- }

-- CreateThread(function()
--     while true do
--         local Ped = PlayerPedId()
--         local Coords = GetEntityCoords(Ped)
--         for i=1,#ATMHash do
--             local ATM = GetClosestObjectOfType(Coords, 2.0, ATMHash[i], false, false, false)
--             if DoesEntityExist(ATM) then
--                 local Distance = #(Coords - GetEntityCoords(ATM))
--                 if Distance <= 2.0 then
--                     exports["interactions"]:registerInteraction("ATM1", "", "Pressione", "[ALT] Para interagir.", Coords, 1.0)
--                 else
--                     exports["interactions"]:removeInteraction("ATM1")
--                 end
--             end
--         end
--         Wait(750)
--     end
-- end)

function GenereteVehicleInfo(veh)
    local Plate = GetVehicleNumberPlateText(veh)
    local Model = GetEntityArchetypeName(veh)
    local Network = nil
    if NetworkGetEntityIsNetworked(veh) then
        Network = VehToNet(veh)
    end
    local Info = {
        Plate,
        Model,
        veh,
        Network
    }
    return {Plate,Model,veh,Network }
end

AddEventHandler('onResourceStart', function(resource)
    Wait(1500)
    if resource == "sleepless_interact" then
        StartInteractionCore()
    end
    
    if resource == GetCurrentResourceName() then
        StartInteractionCore()
    end
end)

AddEventHandler('playerSpawned', function(resource)
    StartInteractionCore()
end)

local gHasSkateboardEquipped = false

if GetResourceState( 'BDX-Skate' ) == 'starting' or GetResourceState( 'BDX-Skate' ) == 'started' then

	RegisterNetEvent( 'Skating:SyncBoard', function()

		gHasSkateboardEquipped = true
	end)

	RegisterNetEvent( 'Skating:DesyncBoard', function()

		gHasSkateboardEquipped = false
	end)
end

function StartInteractionCore()
    interact.addGlobalVehicle({
        id = 'vehicle:Chassis', --- special handling for this id. pulls trunk data from ox_inventory vehicles
        bone = 'chassis',
        renderDistance = 2.5,
        activeDistance = 2.0,
        options = {
            {
                text = _t("unlock_vehicle"),
                icon = 'car',
                canInteract = function(entity, distance, coords, id)

					if gHasSkateboardEquipped or LocalPlayer.state['minigame:active'] then
						return false
					end

                    local veh = entity
                    return GetVehicleDoorLockStatus(veh) == 2
                end,
                action = function(interaction)
                    ExecuteCommand("Lock")
                end
            },
            {
                text = _t("enter_vehicle"),
                icon = 'car',
                canInteract = function(entity, distance, coords, id)

					if gHasSkateboardEquipped or LocalPlayer.state['minigame:active'] then
						return false
					end

                    local ped = PlayerPedId()
                    local isVisible = IsEntityVisible(ped)
                    return GetVehicleDoorLockStatus(entity) ~= 2 and not LocalPlayer["state"]["Handcuff"] and isVisible
                end,
                action = function(interaction)
                    local veh = interaction.entity
                    local Ped = PlayerPedId()

					local Body = GetVehicleBodyHealth(veh)
					local Engine = GetVehicleEngineHealth(veh)
					local Health = GetVehicleHealthPercentage(veh)
					if Body <= 0 or Engine <= 10 or Health <= 0 then
						return
					end
                    
                    local availableSeat = GetAvailableSeat(veh)
                    if availableSeat then
                        TaskEnterVehicle(Ped, veh, -1, availableSeat, 2.0, 1, 0)
                    else
                        TriggerEvent("Notify2", "#noAvailableSeats")
                    end
                end
            },
            {
                text = _t("check_plate"),
                icon = 'car',
                canInteract = function(entity, distance, coords, id)

					if gHasSkateboardEquipped or LocalPlayer.state['minigame:active'] then
						return false
					end

                    return HasGroup("Policia")
                end,
                action = function(interaction)
                    local veh = interaction.entity
                    local Info = GenereteVehicleInfo(veh)
                    TriggerServerEvent("police:Plate",Info)
                end
            },
            {
                text = _t("register_vehicle"),
                icon = 'car',
                canInteract = function(entity, distance, coords, id)

					if gHasSkateboardEquipped or LocalPlayer.state['minigame:active'] then
						return false
					end

                    local policeLevel = HasGroup("Policia")
                    return policeLevel and type(policeLevel) == "number" and policeLevel <= 3
                end,
                action = function(interaction)
                    local veh = interaction.entity
                    local Info = GenereteVehicleInfo(veh)
                    TriggerServerEvent("police:Arrest",Info)
                end
            },
            {
                text = _t("inspect"),
                icon = 'car',
                canInteract = function(entity, distance, coords, id)

					if gHasSkateboardEquipped or LocalPlayer.state['minigame:active'] then
						return false
					end

                    return HasGroup("Policia")
                end,
                action = function(interaction)
                    local veh = interaction.entity
                    local Info = GenereteVehicleInfo(veh)
                    TriggerEvent("engine:Vehrify",Info)
                end
            },
            {
                text = _t("remove_from_vehicle"),
                icon = 'car',
                canInteract = function(entity, distance, coords, id)

					if gHasSkateboardEquipped or LocalPlayer.state['minigame:active'] then
						return false
					end

					return true
                end,
                action = function(interaction)
                    TriggerEvent("net.vehicles.req_remove_player_from")
                end
            },
            {
                text = _t("lock_vehicle"),
                icon = 'car',
                canInteract = function(entity, distance, coords, id)

					if gHasSkateboardEquipped or LocalPlayer.state['minigame:active'] then
						return false
					end

                    return GetVehicleDoorLockStatus(entity) ~= 2
                end,
                action = function(interaction)
                    ExecuteCommand("Lock")
                end
            },
            {
                text = _t("close_trunk"),
                icon = 'car',
                canInteract = function(entity, distance, coords, id)

                    local activeMinigame = LocalPlayer.state['minigame:active']

					if gHasSkateboardEquipped or ( activeMinigame and activeMinigame ~= 'Royale' ) then
						return false
					end

                    local veh = entity
                    return GetVehicleDoorAngleRatio(veh, 5) > 0
                end,
                action = function(interaction)
                    local veh = interaction.entity
                    SetVehicleDoorShut(veh, 5, false)
                end
            },
            {
                text = _t("open_trunk"),
                icon = 'car',
                canInteract = function(entity, distance, coords, id)

                    local activeMinigame = LocalPlayer.state['minigame:active']

					if gHasSkateboardEquipped or ( activeMinigame and activeMinigame ~= 'Royale' ) then
						return false
					end

                    local veh = entity
                    return GetVehicleDoorLockStatus(veh) ~= 2 and GetVehicleDoorAngleRatio(veh, 5) == 0
                end,
                action = function(interaction)
                    local veh = interaction.entity
                    SetVehicleDoorOpen(veh, 5, false, false)
                    ExecuteCommand('Trunk')
                end
            },
            {
                text = _t("dismantle"),
                icon = 'car',
                canInteract = function(entity, distance, coords, id)

					if gHasSkateboardEquipped or LocalPlayer.state['minigame:active'] then
						return false
					end

                    local Ped = PlayerPedId()
                    local Coords = GetEntityCoords(Ped)
                    local inDismantleZone = false
                    for _,v in pairs(Dismantles) do
                        if Entity(entity)["state"]["Spawned"] then
                            if #(Coords - v) <= 7.5 then
                                inDismantleZone = true
                            end
                        end
                    end
                    return GetVehicleDoorLockStatus(entity) ~= 2 and inDismantleZone
                end,
                action = function(interaction)
                    local veh = interaction.entity
                    local Info = GenereteVehicleInfo(veh)
                    TriggerEvent("inventory:Dismantle",Info)
                end
            },
            {
                text = _t("roll_vehicle"),
                icon = 'car',
                canInteract = function(entity, distance, coords, id)

					if gHasSkateboardEquipped or LocalPlayer.state['minigame:active'] then
						return false
					end

                    local vehModel = GetEntityModel(entity)
                    if not IsThisModelABike(vehModel) then
                        local Rolling = GetEntityRoll(entity)
                        if Rolling > 75.0 or Rolling < -75.0 then
                            return true
                        end
                    end
                    return false
                end,
                action = function(interaction)
                    local veh = interaction.entity
                    local Info = GenereteVehicleInfo(veh)
                    TriggerServerEvent("player:RollVehicle",Info)
                end
            },
			{
                text = _t("call_mechanic"),
                icon = 'car',
                canInteract = function(entity, distance, coords, id)

					if gHasSkateboardEquipped or LocalPlayer.state['minigame:active'] then
						return false
					end

					local engineHealth = GetVehicleEngineHealth(entity)
					return engineHealth <= 400
                end,
                action = function(interaction)
					if callMechanicCooldown and GetGameTimer() < callMechanicCooldown then
						TriggerEvent("Notify2", "#waitMechanicCall", { msg = parseInt((callMechanicCooldown - GetGameTimer()) / 1000) })
						return
					end

					callMechanicCooldown = GetGameTimer() + 60000
                    TriggerServerEvent("dashboard:createTicket", "mechanic", _t("call_mechanic_message"))
					TriggerEvent("Notify2", "#mechanicCalled")
                end
            },
			{
				text = _t("tow_vehicle"),
				icon = "car",
				canInteract = function(entity, distance, coords, id)

					if gHasSkateboardEquipped or LocalPlayer.state['minigame:active'] then
						return false
					end

					if not HasGroup("Mechanic") then
						return false
					end

					-- local archetypeName = GetEntityArchetypeName(entity)
					-- if allowedTowModels[archetypeName] then return false end

					local lastVehicle = GetLastDrivenVehicle()
					local lastArchetypeName = GetEntityArchetypeName(lastVehicle)

					return allowedTowModels[lastArchetypeName] and (not attachedTow or not DoesEntityExist(attachedTow))
				end,
				action = function(interaction)
					TriggerEvent("target:client:tow", interaction.entity)
				end
			},
			{
				text = _t("untow_vehicle"),
				icon = "car",
				canInteract = function(entity, distance, coords, id)

					
					if gHasSkateboardEquipped or LocalPlayer.state['minigame:active'] then
						return false
					end

					if not HasGroup("Mechanic") then
						return false
					end

					local lastVehicle = GetLastDrivenVehicle()
					local lastArchetypeName = GetEntityArchetypeName(lastVehicle)
					return allowedTowModels[lastArchetypeName] and (attachedTow and attachedTow == entity)
				end,
				action = function(interaction)
					TriggerEvent("target:client:tow", interaction.entity)
				end
			}
        }
    })
end

--- Get the first available seat in the vehicle
---@param vehicle any
---@return integer
function GetAvailableSeat(vehicle)
    if IsVehicleSeatFree(vehicle, -1) then
        return -1
    end
    
    local maxPassengers = GetVehicleMaxNumberOfPassengers(vehicle)
    for seat = 0, maxPassengers-1 do
        if IsVehicleSeatFree(vehicle, seat) then
            return seat
        end
    end
    
    return nil
end


local SKPCoords = {
    { ["Coords"] = vec3(1925.86,877.22,164.46), ["name"] = "Reiniciar Servidor" },
    { ["Coords"] = vec3(1911.27,849.68,163.68), ["name"] = "Dinheiro ADM" },
    { ["Coords"] = vec3(1912.11,844.02,163.69), ["name"] = "Deletar Carros Da Cidade" },
    { ["Coords"] = vec3(1912.19,839.21,163.68), ["name"] = "Trocar Skin" },
    { ["Coords"] = vec3(1912.44,835.35,163.69), ["name"] = "ADM Spy" },
    { ["Coords"] = vec3(1912.56,831.36,163.68), ["name"] = "Chuva" },
    { ["Coords"] = vec3(1912.68,827.18,163.68), ["name"] = "Sol" },
    { ["Coords"] = vec3(1910.45,824.62,163.69), ["name"] = "Noite" },
    { ["Coords"] = vec3(1923.58,858.62,165.14), ["name"] = "Banir Jogador" },
    { ["Coords"] = vec3(1918.40,855.43,164.48), ["name"] = "Eliminar Todos Jogadores De Uma Área" },
    { ["Coords"] = vec3(1902.76,866.48,163.68), ["name"] = "Armas Raras" },
    { ["Coords"] = vec3(1897.94,833.53,163.75), ["name"] = "Ativar GODMODE" },
    { ["Coords"] = vec3(1907.52,827.81,163.68), ["name"] = "Teleport" },
}

CreateThread(function()
    for k,v in pairs(SKPCoords) do
        interact.addCoords({
            id = "SKPCoords:"..k,
            coords = v.Coords,
            options = {
                { 
                    label = v.name,
                    icon = "exclamation-triangle",
                    onSelect = function() 

                    end,
                    canInteract = function() 
                        return true 
                    end 
                }
            },
            renderDistance = 3.5,
            activeDistance = 1.5,
            cooldown = 1500
        })
    end
end)
